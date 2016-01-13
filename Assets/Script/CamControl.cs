using UnityEngine;
using System.Collections;

public class CamControl : MonoBehaviour {
	
	private float sensitivityX = 2f;
	private float sensitivityY = 2f;
	
	private float rotationY = 0f;
	private float minimumY = -90f;
	private float maximumY = 90f;


	public float translateSpeed = 0.1f;
	public float baseHeight = 1f;

	public float scaleSpeed = 0.1f;
	private float scale = 0f;
	private float scaleMax;

	// Use this for initialization
	void Start () {
		
		scaleMax = scaleSpeed * 10;
	}
	
	// Update is called once per frame
	void Update () {

		//look up and down
		//rotationY = Mathf.Clamp (rotationY, minimumY, maximumY);
		
		//transform.localEulerAngles = new Vector3(-rotationY, 0, 0);

		//rotation
		//float rotationX = transform.localEulerAngles.y + Input.GetAxis("Mouse X") * sensitivityX;
		
		//rotationY += Input.GetAxis("Mouse Y") * sensitivityY;
		//rotationY = Mathf.Clamp (rotationY, minimumY, maximumY);

		//transform.localEulerAngles = new Vector3(-rotationY, rotationX, 0);
		//transform.localEulerAngles = new Vector3(0, rotationX, 0);

		//move
		if (Input.GetMouseButton (0)) {
			//walk forward
			transform.Translate(Vector3.forward * translateSpeed);
		}

		if (Input.GetMouseButton (1)) {
			//walk backward
			transform.Translate(-Vector3.forward * translateSpeed);
		}

		if (Input.GetKey (KeyCode.W)) {
			transform.Translate(new Vector3(0, 0, Time.deltaTime * translateSpeed * 50));
		}
		
		if (Input.GetKey (KeyCode.S)) {
			transform.Translate(new Vector3(0, 0, -Time.deltaTime * translateSpeed * 50));
		}
		
		if (Input.GetKey (KeyCode.D)) {
			transform.Translate(new Vector3(Time.deltaTime * translateSpeed * 50, 0, 0));
		}
		
		if (Input.GetKey (KeyCode.A)) {
			transform.Translate(new Vector3(-Time.deltaTime * translateSpeed * 50, 0, 0));
		}
		
		if (Input.GetKey (KeyCode.E)) {
			transform.Translate(new Vector3(0, Time.deltaTime * translateSpeed * 50, 0));
		}
		
		if (Input.GetKey (KeyCode.Q)) {
			transform.Translate(new Vector3(0, -Time.deltaTime * translateSpeed * 50, 0));
		}

		//scale
		float scroll = Input.GetAxis("Mouse ScrollWheel") * scaleSpeed;
		float newScale = scale + scroll;
		if (newScale > 0 && newScale < scaleMax) {
			transform.Translate (Vector3.forward * scroll);
			scale = newScale;
		}

	}

	void OnGUI(){


	}
}
