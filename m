Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D734668B406
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 02:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjBFByM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Feb 2023 20:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjBFByL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Feb 2023 20:54:11 -0500
X-Greylist: delayed 1809 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 05 Feb 2023 17:54:09 PST
Received: from baidu.com (mx21.baidu.com [220.181.3.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFDC1ABDD
        for <kvm@vger.kernel.org>; Sun,  5 Feb 2023 17:54:09 -0800 (PST)
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: RE: [PATCH] KVM: x86: Enable PIT shutdown quirk
Thread-Topic: [PATCH] KVM: x86: Enable PIT shutdown quirk
Thread-Index: AQHZOBEKfsBAYAffHkmBEn97vOu1fK7BISpg
Date:   Mon, 6 Feb 2023 01:23:20 +0000
Message-ID: <2e4432dbe340436095d8cee8bfebe7c5@baidu.com>
References: <1675395710-37220-1-git-send-email-lirongqing@baidu.com>
 <Y91zXD++4pSHKo6c@google.com>
In-Reply-To: <Y91zXD++4pSHKo6c@google.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.206.20]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-FEAS-Client-IP: 172.31.51.54
X-FE-Last-Public-Client-IP: 100.100.100.38
X-FE-Policy-ID: 15:10:21:SYSTEM
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2VhbiBDaHJpc3RvcGhl
cnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+IFNlbnQ6IFNhdHVyZGF5LCBGZWJydWFyeSA0LCAy
MDIzIDQ6NTAgQU0NCj4gVG86IExpLFJvbmdxaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT4NCj4g
Q2M6IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IHg4NkBrZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0hdIEtWTTogeDg2OiBFbmFibGUgUElUIHNodXRkb3duIHF1aXJrDQo+IA0KPiBQbGVhc2Ug
dXNlICJ4ODYva3ZtOiIgZm9yIGd1ZXN0IHNpZGUgY2hhbmdlcy4NCj4gDQo+IE9uIEZyaSwgRmVi
IDAzLCAyMDIzLCBsaXJvbmdxaW5nQGJhaWR1LmNvbSB3cm90ZToNCj4gPiBGcm9tOiBMaSBSb25n
UWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+DQo+ID4NCj4gPiBLVk0gZW11bGF0aW9uIG9mIHRo
ZSBQSVQgaGFzIGEgcXVpcmsgc3VjaCB0aGF0IHRoZSBub3JtYWwgUElUIHNodXRkb3duDQo+ID4g
cGF0aCBkb2Vzbid0IHdvcmssIGJlY2F1c2UgY2xlYXJpbmcgdGhlIGNvdW50ZXIgcmVnaXN0ZXIg
cmVzdGFydHMgdGhlDQo+ID4gdGltZXIuDQo+ID4NCj4gPiBEaXNhYmxlIHRoZSBjb3VudGVyIGNs
ZWFyaW5nIG9uIFBJVCBzaHV0ZG93biBhcyBpbiBIeXBlci1WDQo+ID4NCj4gPiBTaWduZWQtb2Zm
LWJ5OiBMaSBSb25nUWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+DQo+ID4gLS0tDQo+ID4gIGFy
Y2gveDg2L2tlcm5lbC9rdm0uYyB8IDQgKysrKw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNl
cnRpb25zKCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL2t2bS5jIGIv
YXJjaC94ODYva2VybmVsL2t2bS5jIGluZGV4DQo+ID4gMWNjZWFjNS4uMTQ0MTFiNiAxMDA2NDQN
Cj4gPiAtLS0gYS9hcmNoL3g4Ni9rZXJuZWwva3ZtLmMNCj4gPiArKysgYi9hcmNoL3g4Ni9rZXJu
ZWwva3ZtLmMNCj4gPiBAQCAtNDMsNiArNDMsNyBAQA0KPiA+ICAjaW5jbHVkZSA8YXNtL3JlYm9v
dC5oPg0KPiA+ICAjaW5jbHVkZSA8YXNtL3N2bS5oPg0KPiA+ICAjaW5jbHVkZSA8YXNtL2U4MjAv
YXBpLmg+DQo+ID4gKyNpbmNsdWRlIDxsaW51eC9pODI1My5oPg0KPiA+DQo+ID4gIERFRklORV9T
VEFUSUNfS0VZX0ZBTFNFKGt2bV9hc3luY19wZl9lbmFibGVkKTsNCj4gPg0KPiA+IEBAIC05Nzgs
NiArOTc5LDkgQEAgc3RhdGljIHZvaWQgX19pbml0IGt2bV9pbml0X3BsYXRmb3JtKHZvaWQpDQo+
ID4gIAkJCXdybXNybChNU1JfS1ZNX01JR1JBVElPTl9DT05UUk9MLA0KPiA+ICAJCQkgICAgICAg
S1ZNX01JR1JBVElPTl9SRUFEWSk7DQo+ID4gIAl9DQo+ID4gKw0KPiA+ICsJaTgyNTNfY2xlYXJf
Y291bnRlcl9vbl9zaHV0ZG93biA9IGZhbHNlOw0KPiANCj4gQUZBSUNULCB6ZXJvaW5nIHRoZSBj
b3VudGVyIGlzbid0IGFjdHVhbGx5IHN1cHBvc2VkIHRvIHN0b3AgaXQgZnJvbSBjb3VudGluZy4N
Cj4gQ29weSBwYXN0aW5nIGZyb20gdGhlIEtWTSBob3N0LXNpZGUgcGF0Y2hbKl06DQo+IA0KPiAg
IFRoZSBsYXJnZXN0IHBvc3NpYmxlIGluaXRpYWwgY291bnQgaXMgMDsgdGhpcyBpcyBlcXVpdmFs
ZW50IHRvIDIxNiBmb3INCj4gICBiaW5hcnkgY291bnRpbmcgYW5kIDEwNCBmb3IgQkNEIGNvdW50
aW5nLg0KPiANCj4gICBUaGUgQ291bnRlciBkb2VzIG5vdCBzdG9wIHdoZW4gaXQgcmVhY2hlcyB6
ZXJvLiBJbiBNb2RlcyAwLCAxLCA0LCBhbmQgNSB0aGUNCj4gICBDb3VudGVyIOKAmOKAmHdyYXBz
IGFyb3VuZOKAmeKAmSB0byB0aGUgaGlnaGVzdCBjb3VudCwgZWl0aGVyIEZGRkYgaGV4IGZvciBi
aW5hcnkNCj4gY291bnQtDQo+ICAgaW5nIG9yIDk5OTkgZm9yIEJDRCBjb3VudGluZywgYW5kIGNv
bnRpbnVlcyBjb3VudGluZy4NCj4gDQo+ICAgTW9kZSAwIGlzIHR5cGljYWxseSB1c2VkIGZvciBl
dmVudCBjb3VudGluZy4gQWZ0ZXIgdGhlIENvbnRyb2wgV29yZCBpcyB3cml0dGVuLA0KPiAgIE9V
VCBpcyBpbml0aWFsbHkgbG93LCBhbmQgd2lsbCByZW1haW4gbG93IHVudGlsIHRoZSBDb3VudGVy
IHJlYWNoZXMgemVyby4gT1VUDQo+ICAgdGhlbiBnb2VzIGhpZ2ggYW5kIHJlbWFpbnMgaGlnaCB1
bnRpbCBhIG5ldyBjb3VudCBvciBhIG5ldyBNb2RlIDAgQ29udHJvbA0KPiBXb3JkDQo+ICAgaXMg
d3JpdHRlbiBpbnRvIHRoZSBDb3VudGVyLg0KPiANCj4gQ2FuIHdlIHNpbXBseSBkZWxldGUgaTgy
NTNfY2xlYXJfY291bnRlcl9vbl9zaHV0ZG93biBhbmQgdGhlIGNvZGUgaXQNCj4gd3JhcHM/DQo+
IA0KDQpUaGUgZ2l0IGxvZyBkaWQgbm90IHJlY29yZCB3aHkgY291bnRlciByZWdpc3RlciBzaG91
bGQgYmUgemVyb2VkDQoNCkkgd2lsbCB0cnkgdG8gZGVsZXRlIHRoZSB6ZXJvaW5nIGNvdW50ZXIg
cmVnaXN0ZXIgY29kZXMNCg0KVGhhbmtzDQoNCi1MaQ0KDQoNCj4gWypdIGh0dHBzOi8vbG9yZS5r
ZXJuZWwub3JnL2t2bS9ZOTF5THQzRVpMQTMyY3NwQGdvb2dsZS5jb20NCg==
