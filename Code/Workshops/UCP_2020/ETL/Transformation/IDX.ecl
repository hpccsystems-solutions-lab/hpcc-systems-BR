IMPORT $;
EXPORT IDX := INDEX($.File_PeopleAll.People,{lastname,firstname},{$.File_PeopleAll.People},'~CLASS::HPCC::XXX::NameIndex');
