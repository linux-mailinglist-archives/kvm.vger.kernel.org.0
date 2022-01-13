Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6979848D359
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 09:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbiAMIGW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 03:06:22 -0500
Received: from mx22.baidu.com ([220.181.50.185]:34292 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231436AbiAMIGU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 03:06:20 -0500
X-Greylist: delayed 11608 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Jan 2022 03:06:20 EST
Received: from BJHW-Mail-Ex13.internal.baidu.com (unknown [10.127.64.36])
        by Forcepoint Email with ESMTPS id CA052E3ECA070997018B;
        Thu, 13 Jan 2022 16:06:12 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Thu, 13 Jan 2022 16:06:12 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.020; Thu, 13 Jan 2022 16:06:12 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBLVk06IHg4NjogZml4IGt2bV92Y3B1X2lzX3ByZWVt?=
 =?gb2312?Q?pted?=
Thread-Topic: [PATCH] KVM: x86: fix kvm_vcpu_is_preempted
Thread-Index: AQHYB9OMV2TCiAy6TkSx5H613fhU46xgkMew
Date:   Thu, 13 Jan 2022 08:06:12 +0000
Message-ID: <f0be007a87494a9bb645fedc433e9310@baidu.com>
References: <1641986380-10199-1-git-send-email-lirongqing@baidu.com>
 <Yd8FO8O9AQa79sFc@google.com>
In-Reply-To: <Yd8FO8O9AQa79sFc@google.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.206.28]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS3Tyrz+1K28/i0tLS0tDQo+ILeivP7IyzogU2VhbiBDaHJpc3RvcGhlcnNvbiA8
c2VhbmpjQGdvb2dsZS5jb20+DQo+ILeiy83KsbzkOiAyMDIyxOox1MIxM8jVIDA6NDQNCj4gytW8
/sjLOiBMaSxSb25ncWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+DQo+ILOty806IHBib256aW5p
QHJlZGhhdC5jb207IHZrdXpuZXRzQHJlZGhhdC5jb207IHdhbnBlbmdsaUB0ZW5jZW50LmNvbTsN
Cj4gam1hdHRzb25AZ29vZ2xlLmNvbTsgdGdseEBsaW51dHJvbml4LmRlOyBtaW5nb0ByZWRoYXQu
Y29tOyBicEBhbGllbjguZGU7DQo+IHg4NkBrZXJuZWwub3JnOyBocGFAenl0b3IuY29tOyBya3Jj
bWFyQHJlZGhhdC5jb207IGt2bUB2Z2VyLmtlcm5lbC5vcmc7DQo+IGpvcm9AOGJ5dGVzLm9yZw0K
PiDW98ziOiBSZTogW1BBVENIXSBLVk06IHg4NjogZml4IGt2bV92Y3B1X2lzX3ByZWVtcHRlZA0K
PiANCj4gT24gV2VkLCBKYW4gMTIsIDIwMjIsIExpIFJvbmdRaW5nIHdyb3RlOg0KPiA+IEFmdGVy
IHN1cHBvcnQgcGFyYXZpcnR1YWxpemVkIFRMQiBzaG9vdGRvd25zLCBzdGVhbF90aW1lLnByZWVt
cHRlZA0KPiA+IGluY2x1ZGVzIG5vdCBvbmx5IEtWTV9WQ1BVX1BSRUVNUFRFRCwgYnV0IGFsc28g
S1ZNX1ZDUFVfRkxVU0hfVExCDQo+ID4NCj4gPiBhbmQga3ZtX3ZjcHVfaXNfcHJlZW1wdGVkIHNo
b3VsZCB0ZXN0IG9ubHkgd2l0aCBLVk1fVkNQVV9QUkVFTVBURUQNCj4gPg0KPiA+IEZpeGVzOiA4
NThhNDNhYWUyMzY3ICgiS1ZNOiBYODY6IHVzZSBwYXJhdmlydHVhbGl6ZWQgVExCIFNob290ZG93
biIpDQo+ID4gU2lnbmVkLW9mZi1ieTogTGkgUm9uZ1FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29t
Pg0KPiA+IC0tLQ0KPiA+ICBhcmNoL3g4Ni9rZXJuZWwva3ZtLmMgfCA0ICsrLS0NCj4gPiAgMSBm
aWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRp
ZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwva3ZtLmMgYi9hcmNoL3g4Ni9rZXJuZWwva3ZtLmMg
aW5kZXgNCj4gPiA1OWFiYmRhLi5hOTIwMmQ5IDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L2tl
cm5lbC9rdm0uYw0KPiA+ICsrKyBiL2FyY2gveDg2L2tlcm5lbC9rdm0uYw0KPiA+IEBAIC0xMDI1
LDggKzEwMjUsOCBAQCBhc20oDQo+ID4gICIudHlwZSBfX3Jhd19jYWxsZWVfc2F2ZV9fX2t2bV92
Y3B1X2lzX3ByZWVtcHRlZCwgQGZ1bmN0aW9uOyINCj4gPiAgIl9fcmF3X2NhbGxlZV9zYXZlX19f
a3ZtX3ZjcHVfaXNfcHJlZW1wdGVkOiINCj4gPiAgIm1vdnEJX19wZXJfY3B1X29mZnNldCgsJXJk
aSw4KSwgJXJheDsiDQo+ID4gLSJjbXBiCSQwLCAiIF9fc3RyaW5naWZ5KEtWTV9TVEVBTF9USU1F
X3ByZWVtcHRlZCkgIitzdGVhbF90aW1lKCVyYXgpOyINCj4gPiAtInNldG5lCSVhbDsiDQo+ID4g
KyJtb3ZiCSIgX19zdHJpbmdpZnkoS1ZNX1NURUFMX1RJTUVfcHJlZW1wdGVkKQ0KPiAiK3N0ZWFs
X3RpbWUoJXJheCksICVhbDsiDQo+ID4gKyJhbmRiCSQiIF9fc3RyaW5naWZ5KEtWTV9WQ1BVX1BS
RUVNUFRFRCkgIiwgJWFsOyINCj4gDQo+IEV3dywgdGhlIGV4aXN0aW5nIGNvZGUgaXMgc2tldGNo
eS4gIEl0IHJlbGllcyBvbiB0aGUgY29tcGlsZXIgdG8gc3RvcmUgX0Jvb2wvYm9vbA0KPiBpbiBh
IHNpbmdsZSBieXRlIHNpbmNlICVyYXggbWF5IGJlIG5vbi16ZXJvIGZyb20gdGhlIF9fcGVyX2Nw
dV9vZmZzZXQoKSwgYW5kDQo+IG1vZGlmeWluZyAlYWwgZG9lc24ndCB6ZXJvICVyYXhbNjM6OF0u
ICBJIGRvdWJ0IGdjYyBvciBjbGFuZyB1c2UgYW55dGhpbmcgYnV0IGENCj4gc2luZ2xlIGJ5dGUg
b24geDg2LTY0LCBidXQgImFuZGwiIGlzIGp1c3QgYXMgY2hlYXAgc28gSSBkb24ndCBzZWUgYW55
IGhhcm0gaW4gYmVpbmcNCj4gcGFyYW5vaWQuDQo+IA0KQnVpbGQgd2l0aCBnY2MgKEdDQykgNy4z
LjAsICBkaXNhc3NlbWJsZWQgYXMgYmxvdw0KDQpiZWZvcmU6DQpmZmZmZmZmZjgxMDViZGMwIDxf
X3Jhd19jYWxsZWVfc2F2ZV9fX2t2bV92Y3B1X2lzX3ByZWVtcHRlZD46DQpmZmZmZmZmZjgxMDVi
ZGMwOiAgICAgICA0OCA4YiAwNCBmZCBjMCAxNiAxZCAgICBtb3YgICAgLTB4N2RlMmU5NDAoLCVy
ZGksOCksJXJheA0KZmZmZmZmZmY4MTA1YmRjNzogICAgICAgODINCmZmZmZmZmZmODEwNWJkYzg6
ICAgICAgIDgwIGI4IDkwIGMwIDAyIDAwIDAwICAgIGNtcGIgICAkMHgwLDB4MmMwOTAoJXJheCkN
CmZmZmZmZmZmODEwNWJkY2Y6ICAgICAgIDBmIDk1IGMwICAgICAgICAgICAgICAgIHNldG5lICAl
YWwNCmZmZmZmZmZmODEwNWJkZDI6ICAgICAgIGMzICAgICAgICAgICAgICAgICAgICAgIHJldHEN
CmZmZmZmZmZmODEwNWJkZDM6ICAgICAgIDBmIDFmIDAwICAgICAgICAgICAgICAgIG5vcGwgICAo
JXJheCkNCmZmZmZmZmZmODEwNWJkZDY6ICAgICAgIDY2IDJlIDBmIDFmIDg0IDAwIDAwICAgIG5v
cHcgICAlY3M6MHgwKCVyYXgsJXJheCwxKQ0KZmZmZmZmZmY4MTA1YmRkZDogICAgICAgMDAgMDAg
MDANCg0KDQphZnRlcjoNCmZmZmZmZmZmODEwNWJkYzAgPF9fcmF3X2NhbGxlZV9zYXZlX19fa3Zt
X3ZjcHVfaXNfcHJlZW1wdGVkPjoNCmZmZmZmZmZmODEwNWJkYzA6ICAgICAgIDQ4IDhiIDA0IGZk
IGMwIDE2IDFkICAgIG1vdiAgICAtMHg3ZGUyZTk0MCgsJXJkaSw4KSwlcmF4DQpmZmZmZmZmZjgx
MDViZGM3OiAgICAgICA4Mg0KZmZmZmZmZmY4MTA1YmRjODogICAgICAgOGEgODAgOTAgYzAgMDIg
MDAgICAgICAgbW92ICAgIDB4MmMwOTAoJXJheCksJWFsDQpmZmZmZmZmZjgxMDViZGNlOiAgICAg
ICAyNCAwMSAgICAgICAgICAgICAgICAgICBhbmQgICAgJDB4MSwlYWwNCmZmZmZmZmZmODEwNWJk
ZDA6ICAgICAgIGMzICAgICAgICAgICAgICAgICAgICAgIHJldHENCmZmZmZmZmZmODEwNWJkZDE6
ICAgICAgIDBmIDFmIDQ0IDAwIDAwICAgICAgICAgIG5vcGwgICAweDAoJXJheCwlcmF4LDEpDQpm
ZmZmZmZmZjgxMDViZGQ2OiAgICAgICA2NiAyZSAwZiAxZiA4NCAwMCAwMCAgICBub3B3ICAgJWNz
OjB4MCglcmF4LCVyYXgsMSkNCmZmZmZmZmZmODEwNWJkZGQ6ICAgICAgIDAwIDAwIDAwDQoNClRo
YW5rcw0KDQotTGkNCg==
