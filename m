Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD843A7AAF
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 11:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhFOJgC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 05:36:02 -0400
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:8411 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbhFOJgC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 05:36:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1623749638; x=1655285638;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VNnNHnWZdd95xtQsjyTO5HHAqNNIJPNUWQTCeHbEVi0=;
  b=S0boYeMytHasxanffuLMRBCBtXDIlmHNaNXn8lpbNqYB/YC9kupb5nQm
   D5oRmPpl8U96GZUtjw6EarWBUJnvP9J3POGIq5UEMgTr/sy+uYgf2zTVr
   Hh5LYOxltseDZcIPapgY7Triob9/ziCJu3AceAH8kVadVcxdaV1PBX5lu
   E=;
X-IronPort-AV: E=Sophos;i="5.83,275,1616457600"; 
   d="scan'208";a="6680131"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 15 Jun 2021 09:33:49 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (Postfix) with ESMTPS id C58AAA20FF;
        Tue, 15 Jun 2021 09:33:45 +0000 (UTC)
Received: from EX13D08UEE001.ant.amazon.com (10.43.62.126) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 15 Jun 2021 09:33:44 +0000
Received: from EX13D18EUA001.ant.amazon.com (10.43.165.58) by
 EX13D08UEE001.ant.amazon.com (10.43.62.126) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 15 Jun 2021 09:33:44 +0000
Received: from EX13D18EUA001.ant.amazon.com ([10.43.165.58]) by
 EX13D18EUA001.ant.amazon.com ([10.43.165.58]) with mapi id 15.00.1497.018;
 Tue, 15 Jun 2021 09:33:43 +0000
From:   "Stamatis, Ilias" <ilstam@amazon.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
CC:     "jmattson@google.com" <jmattson@google.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "zamsden@gmail.com" <zamsden@gmail.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Subject: Re: [PATCH v4 00/11] KVM: Implement nested TSC scaling
Thread-Topic: [PATCH v4 00/11] KVM: Implement nested TSC scaling
Thread-Index: AQHXUl9IK3DwWR2B+EmNcn/om5/gnKsU4FUAgAAN7wA=
Date:   Tue, 15 Jun 2021 09:33:43 +0000
Message-ID: <f3d9acf6be9d3fad0282b2771a146bc997611920.camel@amazon.com>
References: <20210526184418.28881-1-ilstam@amazon.com>
         <cbb1272d6fc5713b5d53972ae55c1220f903595f.camel@amazon.com>
In-Reply-To: <cbb1272d6fc5713b5d53972ae55c1220f903595f.camel@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.35]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D208D4A0FC920D4DA83F99BE8BCADF94@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIxLTA2LTE1IGF0IDA5OjQzICswMTAwLCBJbGlhcyBTdGFtYXRpcyB3cm90ZToN
Cj4gT24gV2VkLCAyMDIxLTA1LTI2IGF0IDE5OjQ0ICswMTAwLCBJbGlhcyBTdGFtYXRpcyB3cm90
ZToNCj4gPiBLVk0gY3VycmVudGx5IHN1cHBvcnRzIGhhcmR3YXJlLWFzc2lzdGVkIFRTQyBzY2Fs
aW5nIGJ1dCBvbmx5IGZvciBMMTsNCj4gPiB0aGUgZmVhdHVyZSBpcyBub3QgZXhwb3NlZCB0byBu
ZXN0ZWQgZ3Vlc3RzLiBUaGlzIHBhdGNoIHNlcmllcyBhZGRzDQo+ID4gc3VwcG9ydCBmb3IgbmVz
dGVkIFRTQyBzY2FsaW5nIGFuZCBhbGxvd3MgYm90aCBMMSBhbmQgTDIgdG8gYmUgc2NhbGVkDQo+
ID4gd2l0aCBkaWZmZXJlbnQgc2NhbGluZyBmYWN0b3JzLiBUaGF0IGlzIGFjaGlldmVkIGJ5ICJt
ZXJnaW5nIiB0aGUgMDEgYW5kDQo+ID4gMDIgdmFsdWVzIHRvZ2V0aGVyLg0KPiA+IA0KPiA+IE1v
c3Qgb2YgdGhlIGxvZ2ljIGluIHRoaXMgc2VyaWVzIGlzIGltcGxlbWVudGVkIGluIGNvbW1vbiBj
b2RlIChieSBkb2luZw0KPiA+IHRoZSBuZWNlc3NhcnkgcmVzdHJ1Y3R1cmluZ3MpLCBob3dldmVy
IHRoZSBwYXRjaGVzIGFkZCBzdXBwb3J0IGZvciBWTVgNCj4gPiBvbmx5LiBBZGRpbmcgc3VwcG9y
dCBmb3IgU1ZNIHNob3VsZCBiZSBlYXN5IGF0IHRoaXMgcG9pbnQgYW5kIE1heGltDQo+ID4gTGV2
aXRza3kgaGFzIHZvbHVudGVlcmVkIHRvIGRvIHRoaXMgKHRoYW5rcyEpLg0KPiA+IA0KPiA+IENo
YW5nZWxvZzoNCj4gPiANCj4gPiBPbmx5IHBhdGNoIDkgbmVlZHMgcmV2aWV3aW5nIGF0IHRoaXMg
cG9pbnQsIGJ1dCBJIGFtIHJlLXNlbmRpbmcgdGhlDQo+ID4gd2hvbGUgc2VyaWVzIGFzIEkgYWxz
byBhcHBsaWVkIG5pdHBpY2tzIHN1Z2dlc3RlZCB0byBzb21lIG9mIHRoZSBvdGhlcg0KPiA+IHBh
dGhjZXMuDQo+ID4gDQo+ID4gdjQ6DQo+ID4gICAtIEFkZGVkIHZlbmRvciBjYWxsYmFja3MgZm9y
IHdyaXRpbmcgdGhlIFRTQyBtdWx0aXBsaWVyDQo+ID4gICAtIE1vdmVkIHRoZSBWTUNTIG11bHRp
cGxpZXIgd3JpdGVzIGZyb20gdGhlIFZNQ1MgbG9hZCBwYXRoIHRvIGNvbW1vbg0KPiA+ICAgICBj
b2RlIHRoYXQgb25seSBnZXRzIGNhbGxlZCBvbiBUU0MgcmF0aW8gY2hhbmdlcw0KPiA+ICAgLSBN
ZXJnZWQgdG9nZXRoZXIgcGF0Y2hlcyAxMCBhbmQgMTEgb2YgdjMNCj4gPiAgIC0gQXBwbGllZCBh
bGwgbml0cGljay1mZWVkYmFjayBvZiB0aGUgcHJldmlvdXMgdmVyc2lvbnMNCj4gPiANCj4gPiB2
MzoNCj4gPiAgIC0gQXBwbGllZCBTZWFuJ3MgZmVlZGJhY2sNCj4gPiAgIC0gUmVmYWN0b3JlZCBw
YXRjaGVzIDcgdG8gMTANCj4gPiANCj4gPiB2MjoNCj4gPiAgIC0gQXBwbGllZCBhbGwgb2YgTWF4
aW0ncyBmZWVkYmFjaw0KPiA+ICAgLSBBZGRlZCBhIG11bF9zNjRfdTY0X3NociBmdW5jdGlvbiBp
biBtYXRoNjQuaA0KPiA+ICAgLSBBZGRlZCBhIHNlcGFyYXRlIGt2bV9zY2FsZV90c2NfbDEgZnVu
Y3Rpb24gaW5zdGVhZCBvZiBwYXNzaW5nIGFuDQo+ID4gICAgIGFyZ3VtZW50IHRvIGt2bV9zY2Fs
ZV90c2MNCj4gPiAgIC0gSW1wbGVtZW50ZWQgdGhlIDAyIGZpZWxkcyBjYWxjdWxhdGlvbnMgaW4g
Y29tbW9uIGNvZGUNCj4gPiAgIC0gTW92ZWQgYWxsIG9mIHdyaXRlX2wxX3RzY19vZmZzZXQncyBs
b2dpYyB0byBjb21tb24gY29kZQ0KPiA+ICAgLSBBZGRlZCBhIGNoZWNrIGZvciB3aGV0aGVyIHRo
ZSBUU0MgaXMgc3RhYmxlIGluIHBhdGNoIDEwDQo+ID4gICAtIFVzZWQgYSByYW5kb20gTDEgZmFj
dG9yIGFuZCBhIG5lZ2F0aXZlIG9mZnNldCBpbiBwYXRjaCAxMA0KPiA+IA0KPiA+IElsaWFzIFN0
YW1hdGlzICgxMSk6DQo+ID4gICBtYXRoNjQuaDogQWRkIG11bF9zNjRfdTY0X3NocigpDQo+ID4g
ICBLVk06IFg4NjogU3RvcmUgTDEncyBUU0Mgc2NhbGluZyByYXRpbyBpbiAnc3RydWN0IGt2bV92
Y3B1X2FyY2gnDQo+ID4gICBLVk06IFg4NjogUmVuYW1lIGt2bV9jb21wdXRlX3RzY19vZmZzZXQo
KSB0bw0KPiA+ICAgICBrdm1fY29tcHV0ZV9sMV90c2Nfb2Zmc2V0KCkNCj4gPiAgIEtWTTogWDg2
OiBBZGQgYSByYXRpbyBwYXJhbWV0ZXIgdG8ga3ZtX3NjYWxlX3RzYygpDQo+ID4gICBLVk06IG5W
TVg6IEFkZCBhIFRTQyBtdWx0aXBsaWVyIGZpZWxkIGluIFZNQ1MxMg0KPiA+ICAgS1ZNOiBYODY6
IEFkZCBmdW5jdGlvbnMgZm9yIHJldHJpZXZpbmcgTDIgVFNDIGZpZWxkcyBmcm9tIGNvbW1vbiBj
b2RlDQo+ID4gICBLVk06IFg4NjogQWRkIGZ1bmN0aW9ucyB0aGF0IGNhbGN1bGF0ZSB0aGUgbmVz
dGVkIFRTQyBmaWVsZHMNCj4gPiAgIEtWTTogWDg2OiBNb3ZlIHdyaXRlX2wxX3RzY19vZmZzZXQo
KSBsb2dpYyB0byBjb21tb24gY29kZSBhbmQgcmVuYW1lDQo+ID4gICAgIGl0DQo+ID4gICBLVk06
IFg4NjogQWRkIHZlbmRvciBjYWxsYmFja3MgZm9yIHdyaXRpbmcgdGhlIFRTQyBtdWx0aXBsaWVy
DQo+ID4gICBLVk06IG5WTVg6IEVuYWJsZSBuZXN0ZWQgVFNDIHNjYWxpbmcNCj4gPiAgIEtWTTog
c2VsZnRlc3RzOiB4ODY6IEFkZCB2bXhfbmVzdGVkX3RzY19zY2FsaW5nX3Rlc3QNCj4gPiANCj4g
PiAgYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtLXg4Ni1vcHMuaCAgICAgICAgICAgIHwgICA1ICst
DQo+ID4gIGFyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmggICAgICAgICAgICAgICB8ICAx
NSArLQ0KPiA+ICBhcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jICAgICAgICAgICAgICAgICAgICAgICAg
fCAgMzUgKystDQo+ID4gIGFyY2gveDg2L2t2bS92bXgvbmVzdGVkLmMgICAgICAgICAgICAgICAg
ICAgICB8ICAzMyArKy0NCj4gPiAgYXJjaC94ODYva3ZtL3ZteC92bWNzMTIuYyAgICAgICAgICAg
ICAgICAgICAgIHwgICAxICsNCj4gPiAgYXJjaC94ODYva3ZtL3ZteC92bWNzMTIuaCAgICAgICAg
ICAgICAgICAgICAgIHwgICA0ICstDQo+ID4gIGFyY2gveDg2L2t2bS92bXgvdm14LmMgICAgICAg
ICAgICAgICAgICAgICAgICB8ICA1NSArKy0tDQo+ID4gIGFyY2gveDg2L2t2bS92bXgvdm14Lmgg
ICAgICAgICAgICAgICAgICAgICAgICB8ICAxMSArLQ0KPiA+ICBhcmNoL3g4Ni9rdm0veDg2LmMg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAxMTQgKysrKysrKy0tDQo+ID4gIGluY2x1ZGUv
bGludXgvbWF0aDY0LmggICAgICAgICAgICAgICAgICAgICAgICB8ICAxOSArKw0KPiA+ICB0b29s
cy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vLmdpdGlnbm9yZSAgICAgICAgfCAgIDEgKw0KPiA+ICB0
b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vTWFrZWZpbGUgICAgICAgICAgfCAgIDEgKw0KPiA+
ICAuLi4va3ZtL3g4Nl82NC92bXhfbmVzdGVkX3RzY19zY2FsaW5nX3Rlc3QuYyAgfCAyNDIgKysr
KysrKysrKysrKysrKysrDQo+ID4gIDEzIGZpbGVzIGNoYW5nZWQsIDQ1MSBpbnNlcnRpb25zKCsp
LCA4NSBkZWxldGlvbnMoLSkNCj4gPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IHRvb2xzL3Rlc3Rpbmcv
c2VsZnRlc3RzL2t2bS94ODZfNjQvdm14X25lc3RlZF90c2Nfc2NhbGluZ190ZXN0LmMNCj4gPiAN
Cj4gDQo+IEhlbGxvLA0KPiANCj4gV2hhdCBpcyB0aGUgc3RhdHVzIG9mIHRoZXNlPyBJIHRoaW5r
IGFsbCBwYXRjaGVzIGhhdmUgYmVlbiByZXZpZXdlZCBhbmQNCj4gYXBwcm92ZWQgYXQgdGhpcyBw
b2ludC4NCj4gDQo+IChUaGVyZSdzIGEgbmV3IHJldmlzaW9uIHY2IG9mIHBhdGNoIDkgdGhhdCBo
YXMgYmVlbiByZXZpZXdlZCB0b28pDQo+IA0KPiBUaGFua3MsDQo+IElsaWFzDQoNCk5ldmVyIG1p
bmQgdGhpcywgSSB3YXMgcHJvYmFibHkgY2hlY2tpbmcgYXQgdGhlIHdyb25nIHBsYWNlLCBJIGp1
c3QgcmVhbGlzZWQNCnRoYXQgdGhleSBoYXZlIGJlZW4gcXVldWVkIHNpbmNlIGxhc3QgRnJpZGF5
Lg0KDQpUaGFua3MhDQo=
