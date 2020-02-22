Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3678168D89
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2020 09:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgBVIL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Feb 2020 03:11:29 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:38614 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725958AbgBVIL3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Feb 2020 03:11:29 -0500
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 08C28D6CBCAD3CF561BF;
        Sat, 22 Feb 2020 16:11:10 +0800 (CST)
Received: from DGGEMM423-HUB.china.huawei.com (10.1.198.40) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 22 Feb 2020 16:11:09 +0800
Received: from DGGEMM508-MBX.china.huawei.com ([169.254.2.45]) by
 dggemm423-hub.china.huawei.com ([10.1.198.40]) with mapi id 14.03.0439.000;
 Sat, 22 Feb 2020 16:11:01 +0800
From:   "Zhoujian (jay)" <jianjay.zhou@huawei.com>
To:     Peter Xu <peterx@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wangxin (U)" <wangxinxin.wang@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "Liujinsong (Paul)" <liu.jinsong@huawei.com>
Subject: RE: [PATCH v2] KVM: x86: enable dirty log gradually in small chunks
Thread-Topic: [PATCH v2] KVM: x86: enable dirty log gradually in small chunks
Thread-Index: AQHV56Y5Alj8LhDzKkeojlXWbxjKp6gj70QAgAFYILD///fOAIABn6PA
Date:   Sat, 22 Feb 2020 08:11:00 +0000
Message-ID: <B2D15215269B544CADD246097EACE7474BB1421D@dggemm508-mbx.china.huawei.com>
References: <20200220042828.27464-1-jianjay.zhou@huawei.com>
 <20200220191706.GF2905@xz-x1>
 <B2D15215269B544CADD246097EACE7474BB064B7@DGGEMM528-MBX.china.huawei.com>
 <20200221151926.GA37727@xz-x1>
In-Reply-To: <20200221151926.GA37727@xz-x1>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.228.206]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGV0ZXIgWHUgW21haWx0
bzpwZXRlcnhAcmVkaGF0LmNvbV0NCj4gU2VudDogRnJpZGF5LCBGZWJydWFyeSAyMSwgMjAyMCAx
MToxOSBQTQ0KPiBUbzogWmhvdWppYW4gKGpheSkgPGppYW5qYXkuemhvdUBodWF3ZWkuY29tPg0K
PiBDYzoga3ZtQHZnZXIua2VybmVsLm9yZzsgcGJvbnppbmlAcmVkaGF0LmNvbTsgd2FuZ3hpbiAo
VSkNCj4gPHdhbmd4aW54aW4ud2FuZ0BodWF3ZWkuY29tPjsgSHVhbmd3ZWlkb25nIChDKQ0KPiA8
d2VpZG9uZy5odWFuZ0BodWF3ZWkuY29tPjsgc2Vhbi5qLmNocmlzdG9waGVyc29uQGludGVsLmNv
bTsgTGl1amluc29uZw0KPiAoUGF1bCkgPGxpdS5qaW5zb25nQGh1YXdlaS5jb20+DQo+IFN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggdjJdIEtWTTogeDg2OiBlbmFibGUgZGlydHkgbG9nIGdyYWR1YWxseSBp
biBzbWFsbCBjaHVua3MNCj4gDQo+IE9uIEZyaSwgRmViIDIxLCAyMDIwIGF0IDA5OjMxOjUyQU0g
KzAwMDAsIFpob3VqaWFuIChqYXkpIHdyb3RlOg0KPiANCj4gWy4uLl0NCj4gDQo+ID4gPiA+IGRp
ZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vZGlydHlfbG9nX3Rlc3QuYw0K
PiA+ID4gPiBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9kaXJ0eV9sb2dfdGVzdC5jDQo+
ID4gPiA+IGluZGV4IDU2MTQyMjIuLjJhNDkzYzEgMTAwNjQ0DQo+ID4gPiA+IC0tLSBhL3Rvb2xz
L3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9kaXJ0eV9sb2dfdGVzdC5jDQo+ID4gPiA+ICsrKyBiL3Rv
b2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9kaXJ0eV9sb2dfdGVzdC5jDQo+ID4gPiA+IEBAIC0z
MTcsMTAgKzMxNywxMSBAQCBzdGF0aWMgdm9pZCBydW5fdGVzdChlbnVtIHZtX2d1ZXN0X21vZGUN
Cj4gPiA+ID4gbW9kZSwNCj4gPiA+IHVuc2lnbmVkIGxvbmcgaXRlcmF0aW9ucywNCj4gPiA+ID4g
IAlob3N0X2JtYXBfdHJhY2sgPSBiaXRtYXBfYWxsb2MoaG9zdF9udW1fcGFnZXMpOw0KPiA+ID4g
Pg0KPiA+ID4gPiAgI2lmZGVmIFVTRV9DTEVBUl9ESVJUWV9MT0cNCj4gPiA+ID4gKwlpbnQgcmV0
ID0NCj4ga3ZtX2NoZWNrX2NhcChLVk1fQ0FQX01BTlVBTF9ESVJUWV9MT0dfUFJPVEVDVDIpOw0K
PiA+ID4gPiAgCXN0cnVjdCBrdm1fZW5hYmxlX2NhcCBjYXAgPSB7fTsNCj4gPiA+ID4NCj4gPiA+
ID4gIAljYXAuY2FwID0gS1ZNX0NBUF9NQU5VQUxfRElSVFlfTE9HX1BST1RFQ1QyOw0KPiA+ID4g
PiAtCWNhcC5hcmdzWzBdID0gMTsNCj4gPiA+ID4gKwljYXAuYXJnc1swXSA9IHJldDsNCj4gPiA+
DQo+ID4gPiBZb3UgZW5hYmxlZCB0aGUgaW5pdGlhbC1hbGwtc2V0IGJ1dCBkaWRuJ3QgcmVhbGx5
IGNoZWNrIGl0LCBzbyBpdA0KPiA+ID4gZGlkbid0IGhlbHAgbXVjaCBmcm9tIHRoZSB0ZXN0Y2Fz
ZSBwb3YuLi4NCj4gPg0KPiA+IHZtX2VuYWJsZV9jYXAgaXMgY2FsbGVkIGFmdGVyd2FyZHMsIHRo
ZSByZXR1cm4gdmFsdWUgaXMgY2hlY2tlZCBpbnNpZGUNCj4gPiBpdCwgbWF5IEkgYXNrIHRoaXMg
Y2hlY2sgaXMgZW5vdWdoLCBvciBpdCBpcyBuZWVkZWQgdG8gZ2V0IHRoZSB2YWx1ZQ0KPiA+IHRo
cm91Z2ggc29tZXRoaW5nIGxpa2Ugdm1fZ2V0X2NhcCA/DQo+IA0KPiBJIG1lYW50IHRvIGNoZWNr
IHdoYXQgaGFzIG9mZmVyZWQgYnkgdGhlIGluaXRpYWwtYWxsLXNldCBmZWF0dXJlIGJpdCwgd2hp
Y2ggaXMsIHdlDQo+IHNob3VsZCBnZXQgdGhlIGJpdG1hcCBiZWZvcmUgZGlydHlpbmcgYW5kIHZl
cmlmeSB0aGF0IGl0J3MgYWxsIG9uZXMuDQoNCk9LLCBJIGdvdCB5b3VyIG1lYW5pbmcgbm93Lg0K
DQo+IA0KPiA+DQo+ID4gPiBJJ2Qgc3VnZ2VzdCB5b3UgZHJvcCB0aGlzIGNoYW5nZSwgYW5kIHlv
dSBjYW4gd29yayBvbiB0b3AgYWZ0ZXIgdGhpcw0KPiA+ID4gcGF0Y2ggY2FuIGJlIGFjY2VwdGVk
Lg0KPiA+DQo+ID4gT0ssIHNvbWUgaW5wdXQgcGFyYW1ldGVycyBmb3IgY2FwLmFyZ3NbMF0gc2hv
dWxkIGJlIHRlc3RlZCBJIHRoaW5rOiAwLA0KPiA+IDEsIDMgc2hvdWxkIGJlIGFjY2VwdGVkLCB0
aGUgb3RoZXIgbnVtYmVycyB3aWxsIG5vdC4NCj4gDQo+IFllcy4gSSB0aGluayBpdCdsbCBiZSBm
aW5lIHRvbyBpZiB5b3Ugd2FudCB0byBwdXQgdGhlIHRlc3QgY2hhbmdlcyBpbnRvIHRoaXMgcGF0
Y2guDQo+IEl0J3MganVzdCBub3QgcmVxdWlyZWQgc28gdGhpcyBwYXRjaCBjb3VsZCBwb3RlbnRp
YWxseSBnZXQgbWVyZ2VkIGVhc2llciwgc2luY2UNCj4gdGhlIHRlc3QgbWF5IG5vdCBiZSBhbiBv
bmVsaW5lciBjaGFuZ2UuDQoNClllYWgsIHdpbGwgZHJvcCBpdCBpbiB0aGUgbmV4dCB2ZXJzaW9u
Lg0KDQo+IA0KPiA+DQo+ID4gPg0KPiA+ID4gKE5vdCB0byBtZW50aW9uIHRoZSBvcmlnaW5hbCB0
ZXN0IGFjdHVhbGx5IHZlcmlmaWVkIHRoYXQgd2UgZG9uJ3QNCj4gPiA+IGJyZWFrLCB3aGljaCBz
ZWVtcyBnb29kLi4pDQo+ID4gPg0KPiA+ID4gPiAgCXZtX2VuYWJsZV9jYXAodm0sICZjYXApOw0K
PiA+ID4gPiAgI2VuZGlmDQo+ID4gPiA+DQo+ID4gPiA+IGRpZmYgLS1naXQgYS92aXJ0L2t2bS9r
dm1fbWFpbi5jIGIvdmlydC9rdm0va3ZtX21haW4uYyBpbmRleA0KPiA+ID4gPiA3MGYwM2NlLi5m
MjYzMWQwIDEwMDY0NA0KPiA+ID4gPiAtLS0gYS92aXJ0L2t2bS9rdm1fbWFpbi5jDQo+ID4gPiA+
ICsrKyBiL3ZpcnQva3ZtL2t2bV9tYWluLmMNCj4gPiA+ID4gQEAgLTg2Miw3ICs4NjIsNyBAQCBz
dGF0aWMgaW50IGt2bV92bV9yZWxlYXNlKHN0cnVjdCBpbm9kZSAqaW5vZGUsDQo+ID4gPiBzdHJ1
Y3QgZmlsZSAqZmlscCkNCj4gPiA+ID4gICAqIEFsbG9jYXRpb24gc2l6ZSBpcyB0d2ljZSBhcyBs
YXJnZSBhcyB0aGUgYWN0dWFsIGRpcnR5IGJpdG1hcCBzaXplLg0KPiA+ID4gPiAgICogU2VlIHg4
NidzIGt2bV92bV9pb2N0bF9nZXRfZGlydHlfbG9nKCkgd2h5IHRoaXMgaXMgbmVlZGVkLg0KPiA+
ID4gPiAgICovDQo+ID4gPiA+IC1zdGF0aWMgaW50IGt2bV9jcmVhdGVfZGlydHlfYml0bWFwKHN0
cnVjdCBrdm1fbWVtb3J5X3Nsb3QNCj4gPiA+ID4gKm1lbXNsb3QpDQo+ID4gPiA+ICtzdGF0aWMg
aW50IGt2bV9hbGxvY19kaXJ0eV9iaXRtYXAoc3RydWN0IGt2bV9tZW1vcnlfc2xvdA0KPiA+ID4g
PiArKm1lbXNsb3QpDQo+ID4gPg0KPiA+ID4gVGhpcyBjaGFuZ2Ugc2VlbXMgaXJyZWxldmFudC4u
DQo+ID4gPg0KPiA+ID4gPiAgew0KPiA+ID4gPiAgCXVuc2lnbmVkIGxvbmcgZGlydHlfYnl0ZXMg
PSAyICoga3ZtX2RpcnR5X2JpdG1hcF9ieXRlcyhtZW1zbG90KTsNCj4gPiA+ID4NCj4gPiA+ID4g
QEAgLTEwOTQsOCArMTA5NCwxMSBAQCBpbnQgX19rdm1fc2V0X21lbW9yeV9yZWdpb24oc3RydWN0
IGt2bQ0KPiA+ID4gPiAqa3ZtLA0KPiA+ID4gPg0KPiA+ID4gPiAgCS8qIEFsbG9jYXRlIHBhZ2Ug
ZGlydHkgYml0bWFwIGlmIG5lZWRlZCAqLw0KPiA+ID4gPiAgCWlmICgobmV3LmZsYWdzICYgS1ZN
X01FTV9MT0dfRElSVFlfUEFHRVMpDQo+ICYmICFuZXcuZGlydHlfYml0bWFwKSB7DQo+ID4gPiA+
IC0JCWlmIChrdm1fY3JlYXRlX2RpcnR5X2JpdG1hcCgmbmV3KSA8IDApDQo+ID4gPiA+ICsJCWlm
IChrdm1fYWxsb2NfZGlydHlfYml0bWFwKCZuZXcpKQ0KPiA+ID4NCj4gPiA+IFNhbWUgaGVyZS4N
Cj4gPg0KPiA+IHMva3ZtX2NyZWF0ZV9kaXJ0eV9iaXRtYXAva3ZtX2FsbG9jX2RpcnR5X2JpdG1h
cCBpcyBTZWFuJ3Mgc3VnZ2VzdGlvbg0KPiA+IHRvIG1ha2UgaXQgY2xlYXIgdGhhdCB0aGUgaGVs
cGVyIGlzIG9ubHkgcmVzcG9uc2libGUgZm9yIGFsbG9jYXRpb24sDQo+ID4gdGhlbiBzZXQgYWxs
IHRoZSBiaXRtYXAgYml0cyB0byAxIHVzaW5nIGJpdG1hcF9zZXQgYWZ0ZXJ3YXJkcywgd2hpY2gN
Cj4gPiBzZWVtcyByZWFzb25hYmxlLiBEbyB5b3Ugc3RpbGwgdGhpbmsgaXQncyBiZXR0ZXIgdG8g
a2VlcCB0aGlzIG5hbWUgdW50b3VjaGVkPw0KPiANCj4gTm8gc3Ryb25nIG9waW5pb24sIGZlZWwg
ZnJlZSB0byB0YWtlIHlvdXIgcHJlZmVyZW5jZSAoYmVjYXVzZSB3ZSd2ZSBnb3QgdGhyZWUNCj4g
aGVyZSBhbmQgaWYgeW91IGxpa2UgaXQgdG9vIHRoZW4gaXQncyBhbHJlYWR5IDI6MSA6KS4NCj4g
DQo+ID4NCj4gPiA+DQo+ID4gPiA+ICAJCQlnb3RvIG91dF9mcmVlOw0KPiA+ID4gPiArDQo+ID4g
PiA+ICsJCWlmIChrdm0tPm1hbnVhbF9kaXJ0eV9sb2dfcHJvdGVjdCAmDQo+ID4gPiBLVk1fRElS
VFlfTE9HX0lOSVRJQUxMWV9TRVQpDQo+ID4gPg0KPiA+ID4gKE1heWJlIHRpbWUgdG8gaW50cm9k
dWNlIGEgaGVscGVyIHRvIHNob3J0ZW4gdGhpcyBjaGVjay4gOikNCj4gPg0KPiA+IFllYWgsIGJ1
dCBjb3VsZCB0aGlzIGJlIGRvbmUgb24gdG9wIG9mIHRoaXMgcGF0Y2g/DQo+IA0KPiBZb3UncmUg
Z29pbmcgdG8gcmVwb3N0IGFmdGVyIGFsbCwgcmlnaHQ/ICBJZiBzbywgSU1PIGl0J3MgZWFzaWVy
IHRvIGp1c3QgYWRkIHRoZQ0KPiBoZWxwZXIgaW4gdGhlIHNhbWUgcGF0Y2guDQoNCk9LLCB3aWxs
IGRvIGluIHYzLg0KDQpSZWdhcmRzLA0KSmF5IFpob3UNCg0KPiANCj4gVGhhbmtzLA0KPiANCj4g
LS0NCj4gUGV0ZXIgWHUNCg0K
