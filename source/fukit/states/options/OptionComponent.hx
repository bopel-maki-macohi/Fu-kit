package fukit.states.options;

class OptionComponent
{
	public var id:String;

	public var display:String;

	public var methodVar:Void->Void;

	public function new(id:String, ?methodVar:Void->Void, ?display:String)
	{
		this.id = id;
		this.display = display ?? id;
		this.methodVar = methodVar;

		updateDisplay();
	}

	public function method()
	{
		if (methodVar != null)
			methodVar();

		updateDisplay();
	}

	public function updateDisplay() {}
}
