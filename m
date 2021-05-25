Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38D838FF72
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 12:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhEYKns (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 06:43:48 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:2953 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbhEYKne (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 May 2021 06:43:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1621939325; x=1653475325;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=tUT6RGQzMtfL1WXUZu6ijJGzZF98Qy6ogSzIyCGVpp4=;
  b=DH+ykjKngD9ATbH5Jo/MJLCYoiKgF0ZiULhJ9ZmLiztALAhcZNoWFYJO
   L9WUU6roochqAosGVSCnnM0mWcjm4hGLgNRRy8iPE5QqHcaE1mabOzSDL
   /RJ26fTN2MCswCiT2fMUWaYdu5Ds6EIxHr/ffA/l8/7Rikq6m2JKVgOZL
   E=;
X-IronPort-AV: E=Sophos;i="5.82,328,1613433600"; 
   d="scan'208";a="114447996"
Subject: Re: [PATCH v3 09/12] KVM: VMX: Remove vmx->current_tsc_ratio and
 decache_tsc_multiplier()
Thread-Topic: [PATCH v3 09/12] KVM: VMX: Remove vmx->current_tsc_ratio and
 decache_tsc_multiplier()
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-16425a8d.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 25 May 2021 10:41:52 +0000
Received: from EX13MTAUEE001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-16425a8d.us-east-1.amazon.com (Postfix) with ESMTPS id 295DE100C54;
        Tue, 25 May 2021 10:41:47 +0000 (UTC)
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.226) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 25 May 2021 10:41:46 +0000
Received: from EX13D18EUA001.ant.amazon.com (10.43.165.58) by
 EX13D08UEB001.ant.amazon.com (10.43.60.245) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 25 May 2021 10:41:46 +0000
Received: from EX13D18EUA001.ant.amazon.com ([10.43.165.58]) by
 EX13D18EUA001.ant.amazon.com ([10.43.165.58]) with mapi id 15.00.1497.018;
 Tue, 25 May 2021 10:41:46 +0000
From:   "Stamatis, Ilias" <ilstam@amazon.com>
To:     "seanjc@google.com" <seanjc@google.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "zamsden@gmail.com" <zamsden@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Thread-Index: AQHXTivfZrJO8fNe80G3shVQMiBIQary7y4AgAAOQgCAAQnvgA==
Date:   Tue, 25 May 2021 10:41:45 +0000
Message-ID: <8a13dedc5bc118072d1e79d8af13b5026de736b3.camel@amazon.com>
References: <20210521102449.21505-1-ilstam@amazon.com>
         <20210521102449.21505-10-ilstam@amazon.com>
         <2b3bc8aff14a09c4ea4a1b648f750b5ffb1a15a0.camel@redhat.com>
         <YKv0KA+wJNCbfc/M@google.com>
In-Reply-To: <YKv0KA+wJNCbfc/M@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.65]
Content-Type: text/plain; charset="utf-8"
Content-ID: <ABB45646647AB54CB670EC0547BEB513@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIxLTA1LTI0IGF0IDE4OjQ0ICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBNb24sIE1heSAyNCwgMjAyMSwgTWF4aW0gTGV2aXRza3kgd3JvdGU6DQo+ID4g
T24gRnJpLCAyMDIxLTA1LTIxIGF0IDExOjI0ICswMTAwLCBJbGlhcyBTdGFtYXRpcyB3cm90ZToN
Cj4gPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jIGIvYXJjaC94ODYva3Zt
L3ZteC92bXguYw0KPiA+ID4gaW5kZXggNGI3MDQzMWMyZWRkLi43YzUyYzY5N2NmZTMgMTAwNjQ0
DQo+ID4gPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+ID4gPiArKysgYi9hcmNoL3g4
Ni9rdm0vdm14L3ZteC5jDQo+ID4gPiBAQCAtMTM5Miw5ICsxMzkyLDggQEAgdm9pZCB2bXhfdmNw
dV9sb2FkX3ZtY3Moc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBpbnQgY3B1LA0KPiA+ID4gICAgIH0N
Cj4gPiA+IA0KPiA+ID4gICAgIC8qIFNldHVwIFRTQyBtdWx0aXBsaWVyICovDQo+ID4gPiAtICAg
aWYgKGt2bV9oYXNfdHNjX2NvbnRyb2wgJiYNCj4gPiA+IC0gICAgICAgdm14LT5jdXJyZW50X3Rz
Y19yYXRpbyAhPSB2Y3B1LT5hcmNoLnRzY19zY2FsaW5nX3JhdGlvKQ0KPiA+ID4gLSAgICAgICAg
ICAgZGVjYWNoZV90c2NfbXVsdGlwbGllcih2bXgpOw0KPiA+ID4gKyAgIGlmIChrdm1faGFzX3Rz
Y19jb250cm9sKQ0KPiA+ID4gKyAgICAgICAgICAgdm1jc193cml0ZTY0KFRTQ19NVUxUSVBMSUVS
LCB2Y3B1LT5hcmNoLnRzY19zY2FsaW5nX3JhdGlvKTsNCj4gPiANCj4gPiBUaGlzIG1pZ2h0IGhh
dmUgYW4gb3ZlcmhlYWQgb2Ygd3JpdGluZyB0aGUgVFNDIHNjYWxpbmcgcmF0aW8gZXZlbiBpZg0K
PiA+IGl0IGlzIHVuY2hhbmdlZC4gSSBoYXZlbid0IG1lYXN1cmVkIGhvdyBleHBlbnNpdmUgdm1y
ZWFkL3Ztd3JpdGVzIGFyZSBidXQNCj4gPiBhdCBsZWFzdCB3aGVuIG5lc3RlZCwgdGhlIHZtcmVh
ZHMvdm13cml0ZXMgY2FuIGJlIHZlcnkgZXhwZW5zaXZlIChpZiB0aGV5DQo+ID4gY2F1c2UgYSB2
bWV4aXQpLg0KPiA+IA0KPiA+IFRoaXMgaXMgd2h5IEkgdGhpbmsgdGhlICd2bXgtPmN1cnJlbnRf
dHNjX3JhdGlvJyBleGlzdHMgLSB0byBoYXZlDQo+ID4gYSBjYWNoZWQgdmFsdWUgb2YgVFNDIHNj
YWxlIHJhdGlvIHRvIGF2b2lkIGVpdGhlciAndm1yZWFkJ2luZw0KPiA+IG9yICd2bXdyaXRlJ2lu
ZyBpdCB3aXRob3V0IGEgbmVlZC4NCg0KUmlnaHQuIEkgdGhvdWdodCB0aGUgb3ZlcmhlYWQgbWln
aHQgbm90IGJlIHRoYXQgc2lnbmlmaWNhbnQgc2luY2Ugd2UncmUgZG9pbmcNCmxvdHMgb2Ygdm13
cml0ZXMgb24gdm1lbnRyeS92bWV4aXQgYW55d2F5LCBidXQgeWVhaCwgd2h5IGludHJvZHVjZSBh
bnkga2luZCBvZg0KZXh0cmEgb3ZlcmhlYWQgYW55d2F5Lg0KDQpJJ20gZmluZSB3aXRoIHRoaXMg
cGFydGljdWxhciBwYXRjaCBnZXR0aW5nIGRyb3BwZWQuIEl0J3Mgbm90IGRpcmVjdGx5IHJlbGF0
ZWQgDQp0byB0aGUgc2VyaWVzIGFueXdheS4NCg0KPiANCj4gWWVzLCBidXQgaXRzIGV4aXN0ZW5j
ZSBpcyBhIGNvbXBsZXRlIGhhY2suICB2bXgtPmN1cnJlbnRfdHNjX3JhdGlvIGhhcyB0aGUgc2Ft
ZQ0KPiBzY29wZSBhcyB2Y3B1LT5hcmNoLnRzY19zY2FsaW5nX3JhdGlvLCBpLmUuIHZteCA9PSB2
Y3B1ID09IHZjcHUtPmFyY2guICBVbmxpa2UNCj4gcGVyLVZNQ1MgdHJhY2tpbmcsIGl0IHNob3Vs
ZCBub3QgYmUgdXNlZnVsLCBrZXl3b3JkICJzaG91bGQiLg0KPiANCj4gV2hhdCBJIG1lYW50IGJ5
IG15IGVhcmxpZXIgY29tbWVudDoNCj4gDQo+ICAgSXRzIHVzZSBpbiB2bXhfdmNwdV9sb2FkX3Zt
Y3MoKSBpcyBiYXNpY2FsbHkgIndyaXRlIHRoZSBWTUNTIGlmIHdlIGZvcmdvdCB0bw0KPiAgIGVh
cmxpZXIiLCB3aGljaCBpcyBhbGwga2luZHMgb2Ygd3JvbmcuDQo+IA0KPiBpcyB0aGF0IHZteF92
Y3B1X2xvYWRfdm1jcygpIHNob3VsZCBuZXZlciB3cml0ZSB2bWNzLlRTQ19NVUxUSVBMSUVSLiAg
VGhlIGNvcnJlY3QNCj4gYmVoYXZpb3IgaXMgdG8gc2V0IHRoZSBmaWVsZCBhdCBWTUNTIGluaXRp
YWxpemF0aW9uLCBhbmQgdGhlbiBpbW1lZGlhdGVseSBzZXQgaXQNCj4gd2hlbmV2ZXIgdGhlIHJh
dGlvIGlzIGNoYW5nZWQsIGUuZy4gb24gbmVzdGVkIHRyYW5zaXRpb24sIGZyb20gdXNlcnNwYWNl
LCBldGMuLi4NCj4gSW4gb3RoZXIgd29yZHMsIG15IHVuY2xlYXIgZmVlZGJhY2sgd2FzIHRvIG1h
a2UgaXQgb2Jzb2xldGUgKGFuZCBkcm9wIGl0KSBieQ0KPiBmaXhpbmcgdGhlIHVuZGVybHlpbmcg
bWVzcywgbm90IHRvIGp1c3QgZHJvcCB0aGUgb3B0aW1pemF0aW9uIGhhY2suDQoNCkkgdW5kZXJz
dG9vZCB0aGlzIGFuZCByZXBsaWVkIGVhcmxpZXIuIFRoZSByaWdodCBwbGFjZSBmb3IgdGhlIGh3
IG11bHRpcGxpZXINCmZpZWxkIHRvIGJlIHVwZGF0ZWQgaXMgaW5zaWRlIHNldF90c2Nfa2h6KCkg
aW4gY29tbW9uIGNvZGUgd2hlbiB0aGUgcmF0aW8NCmNoYW5nZXMuIEhvd2V2ZXIsIHRoaXMgcmVx
dWlyZXMgYWRkaW5nIGFub3RoZXIgdmVuZG9yIGNhbGxiYWNrIGV0Yy4gQXMgYWxsDQp0aGlzIGlz
IGZ1cnRoZXIgcmVmYWN0b3JpbmcgSSBiZWxpZXZlIGl0J3MgYmV0dGVyIHRvIGxlYXZlIHRoaXMg
c2VyaWVzIGFzIGlzIC0NCmllIG9ubHkgdG91Y2hpbmcgY29kZSB0aGF0IGlzIGRpcmVjdGx5IHJl
bGF0ZWQgdG8gbmVzdGVkIFRTQyBzY2FsaW5nIGFuZCBub3QNCnRyeSB0byBkbyBldmVyeXRoaW5n
IGFzIHBhcnQgb2YgdGhlIHNhbWUgc2VyaWVzLiBUaGlzIG1ha2VzIHRlc3RpbmcgZWFzaWVyDQp0
b28uIFdlIGNhbiBzdGlsbCBpbXBsZW1lbnQgdGhlc2UgY2hhbmdlcyBsYXRlci4NCg0KVGhhbmtz
LA0KSWxpYXMNCg0K
