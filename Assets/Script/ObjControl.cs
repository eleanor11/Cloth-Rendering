using UnityEngine;
using System.Collections;

public class ObjControl : MonoBehaviour {
	
	private float sensitivityX = 2f;
	private float sensitivityY = 2f;
	
	private float rotationY = 0f;
	private float minimumY = -60f;
	private float maximumY = 60f;


	public float translateSpeed = 0.1f;
	public float baseHeight = 1f;

	// Use this for initialization
	void Start () {

	}
	
	// Update is called once per frame
	void Update () {

		//look up and down
		//rotationY = Mathf.Clamp (rotationY, minimumY, maximumY);
		
		//transform.localEulerAngles = new Vector3(-rotationY, 0, 0);

		//rotation
		float rotationX = transform.localEulerAngles.y + Input.GetAxis("Mouse X") * sensitivityX;
		
		rotationY += Input.GetAxis("Mouse Y") * sensitivityY;
		rotationY = Mathf.Clamp (rotationY, minimumY, maximumY);

		transform.localEulerAngles = new Vector3(-rotationY, rotationX, 0);
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
	}

	void OnGUI(){


	}
}
