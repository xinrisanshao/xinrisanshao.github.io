{% if theme.alipay or theme.wechatpay %}
  <div align="center">
    {% if not is_index %}
     <div class="">
      <p><span>
      <b>本文地址：</b><a href="{{ url_for(page.path) }}" title="{{ page.title }}">{{ page.permalink }}</a><br/><b>转载请注明出处，谢谢！</b>
     </span></p>
  </div>
 {% endif %}
  </div>
  <div style="padding: 10px 0; margin: 20px auto; width: 90%; text-align: center;">
	<div>{{ theme.reward_comment }}</div>
    <button id="rewardButton" disable="enable" onclick="var qr = document.getElementById('QR'); if (qr.style.display === 'none') {qr.style.display='block';} else {qr.style.display='none'}">
      <span>赏</span>
    </button>
    <div id="QR" style="display: none;">
      {% if theme.wechatpay %}
        <div id="wechat" style="display: inline-block">
          <img id="wechat_qr" src="{{ theme.wechatpay }}" alt="{{ theme.author }} WeChat Pay"/>
          <p>微信打赏</p>
        </div>
      {% endif %}
      {% if theme.alipay %}
        <div id="alipay" style="display: inline-block">
          <img id="alipay_qr" src="{{ theme.alipay }}" alt="{{ theme.author }} Alipay"/>
          <p>支付宝打赏</p>
        </div>
      {% endif %}
    </div>
  </div>
{% endif %}
