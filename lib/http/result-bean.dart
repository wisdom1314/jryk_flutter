class ResultBean<T>{

  T _data;

  String _message;

  ResultBean(this._data, this._message);

  String get message => _message;

  T get data => _data;

}