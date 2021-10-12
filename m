Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B7F42A050
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 10:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235352AbhJLIu7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 04:50:59 -0400
Received: from mx22.baidu.com ([220.181.50.185]:48474 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235028AbhJLIu6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 04:50:58 -0400
Received: from BJHW-Mail-Ex14.internal.baidu.com (unknown [10.127.64.37])
        by Forcepoint Email with ESMTPS id CE9CF75583C0A56DEA1D;
        Tue, 12 Oct 2021 16:48:51 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BJHW-Mail-Ex14.internal.baidu.com (10.127.64.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Tue, 12 Oct 2021 16:48:51 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.014; Tue, 12 Oct 2021 16:48:51 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Andy Lutomirski <luto@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIEtWTTogeDg2OiBkaXJlY3RseSBjYWxsIHdiaW52?=
 =?utf-8?Q?d_for_local_cpu_when_emulate_wbinvd?=
Thread-Topic: [PATCH] KVM: x86: directly call wbinvd for local cpu when
 emulate wbinvd
Thread-Index: AQHXuXMaPPVMI+ZMo0W+myyiElZgI6vECFTAgAsMGRA=
Date:   Tue, 12 Oct 2021 08:48:51 +0000
Message-ID: <48a4c36814104159b72dcfc480f8618f@baidu.com>
References: <1632821269-52969-1-git-send-email-lirongqing@baidu.com>
 <fe38bc2e-64a5-e770-a86a-b2b70eef4fb4@kernel.org> 
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.206.11]
x-baidu-bdmsfe-datecheck: 1_BJHW-Mail-Ex14_2021-10-12 16:48:51:679
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IExpLFJvbmdxaW5nDQo+
IOWPkemAgeaXtumXtDogMjAyMeW5tDEw5pyINeaXpSAxNjowNQ0KPiDmlLbku7bkuro6ICdBbmR5
IEx1dG9taXJza2knIDxsdXRvQGtlcm5lbC5vcmc+OyBrdm1Admdlci5rZXJuZWwub3JnOw0KPiB3
YW5wZW5nbGlAdGVuY2VudC5jb207IGphbi5raXN6a2FAc2llbWVucy5jb207IHg4NkBrZXJuZWwu
b3JnDQo+IOS4u+mimDog562U5aSNOiBbUEFUQ0hdIEtWTTogeDg2OiBkaXJlY3RseSBjYWxsIHdi
aW52ZCBmb3IgbG9jYWwgY3B1IHdoZW4gZW11bGF0ZQ0KPiB3YmludmQNCj4gDQo+IA0KPiANCj4g
PiAtLS0tLemCruS7tuWOn+S7ti0tLS0tDQo+ID4g5Y+R5Lu25Lq6OiBBbmR5IEx1dG9taXJza2kg
PGx1dG9Aa2VybmVsLm9yZz4NCj4gPiDlj5HpgIHml7bpl7Q6IDIwMjHlubQxMOaciDXml6UgNjo1
Nw0KPiA+IOaUtuS7tuS6ujogTGksUm9uZ3FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPjsga3Zt
QHZnZXIua2VybmVsLm9yZzsNCj4gPiB3YW5wZW5nbGlAdGVuY2VudC5jb207IGphbi5raXN6a2FA
c2llbWVucy5jb207IHg4NkBrZXJuZWwub3JnDQo+ID4g5Li76aKYOiBSZTogW1BBVENIXSBLVk06
IHg4NjogZGlyZWN0bHkgY2FsbCB3YmludmQgZm9yIGxvY2FsIGNwdSB3aGVuDQo+ID4gZW11bGF0
ZSB3YmludmQNCj4gPg0KPiA+IE9uIDkvMjgvMjEgMDI6MjcsIExpIFJvbmdRaW5nIHdyb3RlOg0K
PiA+ID4gZGlyZWN0bHkgY2FsbCB3YmludmQgZm9yIGxvY2FsIHBDUFUsIHdoaWNoIGNhbiBhdm9p
ZCBpcGkgZm9yIGl0c2VsZg0KPiA+ID4gYW5kIGNhbGxpbmcgb2YgZ2V0X2NwdS9vbl9lYWNoX2Nw
dV9tYXNrL2V0Yy4NCj4gPiA+DQo+ID4NCj4gPiBXaHkgaXMgdGhpcyBhbiBpbXByb3ZlbWVudD8g
IFRyYWRpbmcgZ2V0X2NwdSgpIHZzIHByZWVtcHRfZGlzYWJsZSgpDQo+ID4gc2VlbXMgbGlrZSBh
IG5lZ2xpZ2libGUgZGlmZmVyZW5jZSwgYW5kIGl0IG1ha2VzIHRoZSBjb2RlIG1vcmUgY29tcGxp
Y2F0ZWQuDQo+ID4NCj4gDQo+IEZpcnN0OiB0byBsb2NhbCBwQ3B1LCB0aGlzIHJlZHVjZXMgYSBp
cGkgdG8gaXRzZWxmLCBpcGkgd2lsbCB0cmlnZ2VyIGNvbnRleHQgc3dpdGNoDQo+IGJldHdlZW4g
aXJxIGFuZCB0aHJlYWQsIGl0IGlzIGV4cGVuc2l2ZS4NCj4gDQoNCm9uX2VhY2hfY3B1X21hc2sg
d2lsbCBub3Qgc2VuZCBpcGkgdG8gbG9jYWwgY3B1LCB0aGUgY2FsbGJhY2sgZnVuY3Rpb24gd2ls
bCBiZSBleGVjdXRlZCBkaXJlY3RseSBmb3IgbG9jYWwgY3B1DQoNCkJ1dCB0aGlzIHBhdGNoIGlz
IHVzZWZ1bCBzdGlsbCwgVXNpbmcgc21wX2NhbGxfZnVuY3Rpb25fbWFueSBhbmQgZGlyZWN0bHkg
Y2FsbGluZyB3YmludmQgY2FuIHJlZHVjZSB0aGUgdW5uZWNlc3NhcnkgY3B1bWFza19zZXRfY3B1
IGFuZCBjcHVtYXNrX3Rlc3RfY3B1KCksIGFuZCBzb21lIGR1cGxpY2F0ZSBwcmVlbXB0IGRpc2Fi
bGUNCg0KLUxpDQo+IFNlY29uZCwgcHJlZW1wdF9kaXNhYmxlL3ByZWVtcHRfZW5hYmxlIHZzIGdl
dF9jcHUvDQo+IGNwdW1hc2tfc2V0X2NwdS9wdXRfY3B1LCB0aGUgcHJlZW1wdF9kaXNhYmxlLyBw
cmVlbXB0X2VuYWJsZSBpcyBtb3JlDQo+IHNsaWdodC4NCj4gDQo+IEFuZCB0aGlzIGNhbiBhdm9p
ZCB0aGUgYXRvbWljIGNwdW1hc2tfc2V0X2NwdQ0KPiANCj4gLUxpDQo+IA0KPiANCj4gPiA+IElu
IGZhY3QsIFRoaXMgY2hhbmdlIHJldmVydHMgY29tbWl0IDJlZWM3MzQzNzQ4NyAoIktWTTogeDg2
OiBBdm9pZA0KPiA+ID4gaXNzdWluZyB3YmludmQgdHdpY2UiKSwgc2luY2Ugc21wX2NhbGxfZnVu
Y3Rpb25fbWFueSBpcyBza2lwaW5nIHRoZQ0KPiA+ID4gbG9jYWwgY3B1IChhcyBkZXNjcmlwdGlv
biBvZiBjMjE2MmUxM2Q2ZTJmKSwgd2JpbnZkIGlzIG5vdCBpc3N1ZWQNCj4gPiA+IHR3aWNlDQo+
ID4gPg0KPiA+ID4gYW5kIHJldmVydHMgY29tbWl0IGMyMTYyZTEzZDZlMmYgKCJLVk06IFg4Njog
Rml4IG1pc3NpbmcgbG9jYWwgcENQVQ0KPiA+ID4gd2hlbiBleGVjdXRpbmcgd2JpbnZkIG9uIGFs
bCBkaXJ0eSBwQ1BVcyIpIHRvbywgd2hpY2ggZml4ZWQgdGhlDQo+ID4gPiBwcmV2aW91cyBwYXRj
aCwgd2hlbiByZXZlcnQgcHJldmlvdXMgcGF0Y2gsIGl0IGlzIG5vdCBuZWVkZWQuDQo+ID4gPg0K
PiA+ID4gU2lnbmVkLW9mZi1ieTogTGkgUm9uZ1FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPg0K
PiA+ID4gLS0tDQo+ID4gPiAgIGFyY2gveDg2L2t2bS94ODYuYyB8ICAgMTMgKysrKysrLS0tLS0t
LQ0KPiA+ID4gICAxIGZpbGVzIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMo
LSkNCj4gPiA+DQo+ID4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3g4Ni5jIGIvYXJjaC94
ODYva3ZtL3g4Ni5jIGluZGV4DQo+ID4gPiAyOGVmMTQxLi5lZTY1OTQxIDEwMDY0NA0KPiA+ID4g
LS0tIGEvYXJjaC94ODYva3ZtL3g4Ni5jDQo+ID4gPiArKysgYi9hcmNoL3g4Ni9rdm0veDg2LmMN
Cj4gPiA+IEBAIC02OTg0LDE1ICs2OTg0LDE0IEBAIHN0YXRpYyBpbnQga3ZtX2VtdWxhdGVfd2Jp
bnZkX25vc2tpcChzdHJ1Y3QNCj4gPiBrdm1fdmNwdSAqdmNwdSkNCj4gPiA+ICAgCQlyZXR1cm4g
WDg2RU1VTF9DT05USU5VRTsNCj4gPiA+DQo+ID4gPiAgIAlpZiAoc3RhdGljX2NhbGwoa3ZtX3g4
Nl9oYXNfd2JpbnZkX2V4aXQpKCkpIHsNCj4gPiA+IC0JCWludCBjcHUgPSBnZXRfY3B1KCk7DQo+
ID4gPiAtDQo+ID4gPiAtCQljcHVtYXNrX3NldF9jcHUoY3B1LCB2Y3B1LT5hcmNoLndiaW52ZF9k
aXJ0eV9tYXNrKTsNCj4gPiA+IC0JCW9uX2VhY2hfY3B1X21hc2sodmNwdS0+YXJjaC53YmludmRf
ZGlydHlfbWFzaywNCj4gPiA+ICsJCXByZWVtcHRfZGlzYWJsZSgpOw0KPiA+ID4gKwkJc21wX2Nh
bGxfZnVuY3Rpb25fbWFueSh2Y3B1LT5hcmNoLndiaW52ZF9kaXJ0eV9tYXNrLA0KPiA+ID4gICAJ
CQkJd2JpbnZkX2lwaSwgTlVMTCwgMSk7DQo+ID4gPiAtCQlwdXRfY3B1KCk7DQo+ID4gPiArCQlw
cmVlbXB0X2VuYWJsZSgpOw0KPiA+ID4gICAJCWNwdW1hc2tfY2xlYXIodmNwdS0+YXJjaC53Ymlu
dmRfZGlydHlfbWFzayk7DQo+ID4gPiAtCX0gZWxzZQ0KPiA+ID4gLQkJd2JpbnZkKCk7DQo+ID4g
PiArCX0NCj4gPiA+ICsNCj4gPiA+ICsJd2JpbnZkKCk7DQo+ID4gPiAgIAlyZXR1cm4gWDg2RU1V
TF9DT05USU5VRTsNCj4gPiA+ICAgfQ0KPiA+ID4NCj4gPiA+DQoNCg==
