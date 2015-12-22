using UnityEngine;
using System.Collections;

public class CamControl1 : MonoBehaviour {

	Vector3 position0;
	Vector3 rotation0, rotation1;
	bool move = false;

	// Use this for initialization
	void Start () {
		//position0 = new Vector3(-5, 4, -2.5f);
		//position0 = new Vector3(6, 1, -2);
		position0 = new Vector3(12, 1.5f, 4);
		//rotation0 = new Vector3(45, -20, 0);
		//rotation1 = new Vector3(20, 30, 0);
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetKeyDown (KeyCode.Space)) {
			move = true;
			transform.position = position0;
		}
		if (move) {
			//transform.position = transform.position + new Vector3(0.05f, 0, 0);
			//transform.position = transform.position + new Vector3(0, 0, 0.015f);
			transform.position = transform.position + new Vector3(-0.05f, -0.0085f, 0);
		}
		//if (transform.position.x > 6 ){
		//if (transform.position.z > 6 ){
		if (transform.position.x < 8.5 ){
			move = false;
		}
	}
}
