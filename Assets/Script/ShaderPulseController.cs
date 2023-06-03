using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

// This script MUST be attached to a gameobject with a Mask
public class ShaderPulseController : MonoBehaviour
{
    private Image _i;
    private Material _m;
    public Color color;
    public float frequency = 2;
    [Range(0.0f, 0.99f)]
    public float delay = 0.8f; // 0 - 0.99

    private void Start()
    {
        this._i = this.GetComponent<Image>();
        if (this._i != null)
        {
            this._m = this._i.material;
            if (this._m == null)
                return;
            this._m = new Material(this._m); // copy the material
            this._i.material = this._m; // assign the new copy !
            this._m.SetColor("_Color", this.color);
            this._m.SetFloat("_Frequency", this.frequency);
            this._m.SetFloat("_Delay", this.delay);
        }
    }
}
