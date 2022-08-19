.. default-domain:: py

pathoption
==========

.. automodule:: pathoption
    
.. function:: create_pathoption()

    Returns a :class:`PathOption` object

        :rtype: :class:`PathOption`

|

.. function:: register_pathoption(pathoption,pathkey,function_reference)

    Registers data pair pathkey:function_reference with object pathoption. 

    :param PathOption pathoption: The object to register the data pair.
    :param str pathkey: The --path option value
    :param function_reference: A reference to a function

|

.. class:: PathOption

    PathOption stores the function references that when invoked return the
    installation paths. The function references are stored in data pairs
    pathkey:function_reference where pathkey corresponds to the --path option value.

    .. method:: add_option(self,pathkey,ref_to_function)

        Adds the data value pair pathkey:function_reference. If a duplicate pathkey value
        an exception will be raised.

        :param str pathkey: A --path option value
        :param ref_to_function: A function reference that when invoked returns a string.
        :raises ErrorDuplicatePathOptionKey: If an existing pathkey is already registered

    .. method:: get_path(self,key)

        For the value of key, returns the corresponding function reference.

        :param str key: A --path option value
        :rtype: str
        :Returns: The corresponding path for the key value.
