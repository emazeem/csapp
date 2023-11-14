
class ApiResponse<T> {
  late Status status;
  late T data;
  late String message;

  ApiResponse() {
    status = Status.IDLE;
  }

  ApiResponse.loading(this.message) : status = Status.BUSY;
  ApiResponse.completed(this.data) : status = Status.IDLE;
  ApiResponse.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return 'Status : $status \n Message : $message \n Data : $data';
  }
}
enum Status {
  IDLE,
  BUSY,
  ERROR,
}
