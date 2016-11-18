# -*- coding: utf-8 -*-
'''
Manage Kibana objects.

.. code-block:: yaml

    kibana:
      kibana_url: 'https://es.host.com:9200'
      kibana_index: '.kibana'

.. code-block:: yaml

    Ensure minimum dashboard is managed:
      kibana_objects.present:
        - name: 'Logs'
        - kibana_content: <JSON object>
        - kibana_type: 'dashboard'

'''

# Import Python libs
import requests

# Import Salt libs
from salt.utils.dictdiffer import DictDiffer


def __virtual__():
    '''Always load the module.'''
    return True


def present(name, kibana_content=None, kibana_type=None):
    '''
    Ensure the Kibana object exists in the database.

    name
        Name of the object

    kibana_content
        Content in JSON

    kibana_type
        String
    '''
    ret = {'name': name, 'result': True, 'comment': '', 'changes': {}}

    if not kibana_content:
        ret['result'] = False
        ret['comment'] = 'Content is not set'
        return ret

    profile = __salt__['config.option']('kibana')

    url, index = _set_parameters(name, kibana_type, profile)
    if not url:
        ret['result'] = False
        ret['comment'] = index
        return ret

    try:
        headers = {'Content-type': 'application/json'}
        response = requests.get(url, headers=headers)
        if response.ok:
            delta = DictDiffer(response.json(), kibana_content)
            ret['changes'] = {
                'old': "{}".format(delta.removed()),
                'new': "{}".format(delta.added()),
                'updated': "{}".format(delta.changed())
            }
            if not ret['changes']['old'] and not ret['changes']['new'] and not ret['changes']['updated']:
                ret['comment'] = "Object {} is already present".format(name)
                return ret
        response = requests.put(url, headers=headers, json=kibana_content)
    except requests.exceptions.RequestException as exc:
        ret['result'] = False
        ret['comment'] = ("Failed to create Kibana object {0}\n"
                          "Got exception: {1}").format(name, exc)
    else:
        if response.ok:
            if ret['changes']['old'] or ret['changes']['new'] or ret['changes']['updated']:
                ret['comment'] = 'Kibana object {0} has been updated'.format(name)
            else:
                ret['comment'] = 'Kibana object {0} has been created'.format(name)
                ret['changes']['new'] = 'Kibana objects created'
        else:
            ret['result'] = False
            ret['comment'] = ("Failed to post Kibana object {0}\n"
                              "Response: {1}").format(name, response)

    return ret


def absent(name, kibana_type=None):
    '''
    Ensure the Kibana object is not present in the database.

    name
        Name of the object

    kibana_type
        String
    '''
    ret = {'name': name, 'result': True, 'comment': '', 'changes': {}}

    profile = __salt__['config.option']('kibana')

    url, index = _set_parameters(name, kibana_type, profile)
    if not url:
        ret['result'] = False
        ret['comment'] = index
        return ret

    try:
        response = requests.delete(url)
    except requests.exceptions.RequestException as exc:
        ret['result'] = False
        ret['comment'] = ("Failed to delete Kibana object {0}\n"
                          "Got exception: {1}").format(name, exc)
    else:
        if response.ok:
            ret['comment'] = "Kibana object {0} has been deleted".format(name)
        elif response.status_code == 404:
            ret['comment'] = "Kibana object {0} was not present".format(name)
        else:
            ret['result'] = False
            ret['comment'] = ("Failed to delete Kibana object {0}\n"
                              "Response: {1}").format(name, response)

    return ret


def _set_parameters(name, kibana_type, profile):
    '''
    Retrieve parameters from profile.
    '''

    if not kibana_type:
        return False, 'Type is not set'

    url = profile.get('kibana_url')
    if not url:
        return False, 'Cannot get URL needed by Kibana client'

    index = profile.get('kibana_index')
    if not index:
        return False, 'Cannot get the index needed by Kibana client'

    url = "http://{0}/{1}/{2}/{3}".format(url, index, kibana_type, name)
    return url, index
