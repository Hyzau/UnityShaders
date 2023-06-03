using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

// This script MUST be attached to a gameobject with a Mask
public class ShaderFillController : MonoBehaviour
{
    private Image _i;
    private Material _m;
    [Range(0.0f, 1.0f)]
    private float _fill = 0;
    public Color color;
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
            _m.SetFloat("_Fill", _fill);
        }
    }
    // Update function is for debugging purpose only
    public void Update()
    {
        this._fill += Time.deltaTime * 0.1f;
        this.SetProgress(this._fill);
    }

    public void SetProgress(float progress)
    {
        if (this._m != null)
        {
            this._fill = progress % 1.0f;
            _m.SetFloat("_Fill", this._fill);
        }
    }
}
