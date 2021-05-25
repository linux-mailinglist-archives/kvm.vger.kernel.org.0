Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674E3390943
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 20:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbhEYSyg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 14:54:36 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:46407 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbhEYSyf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 May 2021 14:54:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1621968786; x=1653504786;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=BDPaE5R8X1BFz8LnXrRB4FZyqV8pQyWm/jR4572xAiE=;
  b=Xqb4LG3CqfoUoSWskB4NdaOOVW+x6iWH5T6kaGQ31wCeJj6gSrjkiYMC
   jZxVs+b9oItdAJadLOcR/uwyL6i11mGHI50h6Fbjl+/ZtUZl4nCntMLGK
   211rXkLY2QB5or8MeHA8Of0oyq2OorUx2FFzcAamAxExmohYPryWMObu0
   w=;
X-IronPort-AV: E=Sophos;i="5.82,329,1613433600"; 
   d="scan'208";a="116009369"
Subject: Re: [PATCH v3 09/12] KVM: VMX: Remove vmx->current_tsc_ratio and
 decache_tsc_multiplier()
Thread-Topic: [PATCH v3 09/12] KVM: VMX: Remove vmx->current_tsc_ratio and
 decache_tsc_multiplier()
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-98acfc19.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 25 May 2021 18:52:58 +0000
Received: from EX13MTAUEB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-98acfc19.us-east-1.amazon.com (Postfix) with ESMTPS id 810E5A0267;
        Tue, 25 May 2021 18:52:55 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 25 May 2021 18:52:53 +0000
Received: from EX13D18EUA001.ant.amazon.com (10.43.165.58) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 25 May 2021 18:52:52 +0000
Received: from EX13D18EUA001.ant.amazon.com ([10.43.165.58]) by
 EX13D18EUA001.ant.amazon.com ([10.43.165.58]) with mapi id 15.00.1497.018;
 Tue, 25 May 2021 18:52:51 +0000
From:   "Stamatis, Ilias" <ilstam@amazon.com>
To:     "seanjc@google.com" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "zamsden@gmail.com" <zamsden@gmail.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Thread-Index: AQHXTivfZrJO8fNe80G3shVQMiBIQary7y4AgAAOQgCAAQnvgIAAWdaAgAAwoQA=
Date:   Tue, 25 May 2021 18:52:51 +0000
Message-ID: <248b20deaa1119881f089115cc768963c5af3c20.camel@amazon.com>
References: <20210521102449.21505-1-ilstam@amazon.com>
         <20210521102449.21505-10-ilstam@amazon.com>
         <2b3bc8aff14a09c4ea4a1b648f750b5ffb1a15a0.camel@redhat.com>
         <YKv0KA+wJNCbfc/M@google.com>
         <8a13dedc5bc118072d1e79d8af13b5026de736b3.camel@amazon.com>
         <YK0emU2NjWZWBovh@google.com>
In-Reply-To: <YK0emU2NjWZWBovh@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.129]
Content-Type: text/plain; charset="utf-8"
Content-ID: <15A06B23F6431C4FBD40F21833F37AD3@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIxLTA1LTI1IGF0IDE1OjU4ICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIE1heSAyNSwgMjAyMSwgU3RhbWF0aXMsIElsaWFzIHdyb3RlOg0KPiA+
IE9uIE1vbiwgMjAyMS0wNS0yNCBhdCAxODo0NCArMDAwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3
cm90ZToNCj4gPiA+IFllcywgYnV0IGl0cyBleGlzdGVuY2UgaXMgYSBjb21wbGV0ZSBoYWNrLiAg
dm14LT5jdXJyZW50X3RzY19yYXRpbyBoYXMgdGhlIHNhbWUNCj4gPiA+IHNjb3BlIGFzIHZjcHUt
PmFyY2gudHNjX3NjYWxpbmdfcmF0aW8sIGkuZS4gdm14ID09IHZjcHUgPT0gdmNwdS0+YXJjaC4g
IFVubGlrZQ0KPiA+ID4gcGVyLVZNQ1MgdHJhY2tpbmcsIGl0IHNob3VsZCBub3QgYmUgdXNlZnVs
LCBrZXl3b3JkICJzaG91bGQiLg0KPiA+ID4gDQo+ID4gPiBXaGF0IEkgbWVhbnQgYnkgbXkgZWFy
bGllciBjb21tZW50Og0KPiA+ID4gDQo+ID4gPiAgIEl0cyB1c2UgaW4gdm14X3ZjcHVfbG9hZF92
bWNzKCkgaXMgYmFzaWNhbGx5ICJ3cml0ZSB0aGUgVk1DUyBpZiB3ZSBmb3Jnb3QgdG8NCj4gPiA+
ICAgZWFybGllciIsIHdoaWNoIGlzIGFsbCBraW5kcyBvZiB3cm9uZy4NCj4gPiA+IA0KPiA+ID4g
aXMgdGhhdCB2bXhfdmNwdV9sb2FkX3ZtY3MoKSBzaG91bGQgbmV2ZXIgd3JpdGUgdm1jcy5UU0Nf
TVVMVElQTElFUi4gIFRoZSBjb3JyZWN0DQo+ID4gPiBiZWhhdmlvciBpcyB0byBzZXQgdGhlIGZp
ZWxkIGF0IFZNQ1MgaW5pdGlhbGl6YXRpb24sIGFuZCB0aGVuIGltbWVkaWF0ZWx5IHNldCBpdA0K
PiA+ID4gd2hlbmV2ZXIgdGhlIHJhdGlvIGlzIGNoYW5nZWQsIGUuZy4gb24gbmVzdGVkIHRyYW5z
aXRpb24sIGZyb20gdXNlcnNwYWNlLCBldGMuLi4NCj4gPiA+IEluIG90aGVyIHdvcmRzLCBteSB1
bmNsZWFyIGZlZWRiYWNrIHdhcyB0byBtYWtlIGl0IG9ic29sZXRlIChhbmQgZHJvcCBpdCkgYnkN
Cj4gPiA+IGZpeGluZyB0aGUgdW5kZXJseWluZyBtZXNzLCBub3QgdG8ganVzdCBkcm9wIHRoZSBv
cHRpbWl6YXRpb24gaGFjay4NCj4gPiANCj4gPiBJIHVuZGVyc3Rvb2QgdGhpcyBhbmQgcmVwbGll
ZCBlYXJsaWVyLiBUaGUgcmlnaHQgcGxhY2UgZm9yIHRoZSBodyBtdWx0aXBsaWVyDQo+ID4gZmll
bGQgdG8gYmUgdXBkYXRlZCBpcyBpbnNpZGUgc2V0X3RzY19raHooKSBpbiBjb21tb24gY29kZSB3
aGVuIHRoZSByYXRpbw0KPiA+IGNoYW5nZXMuIEhvd2V2ZXIsIHRoaXMgcmVxdWlyZXMgYWRkaW5n
IGFub3RoZXIgdmVuZG9yIGNhbGxiYWNrIGV0Yy4gQXMgYWxsDQo+ID4gdGhpcyBpcyBmdXJ0aGVy
IHJlZmFjdG9yaW5nIEkgYmVsaWV2ZSBpdCdzIGJldHRlciB0byBsZWF2ZSB0aGlzIHNlcmllcyBh
cyBpcyAtDQo+ID4gaWUgb25seSB0b3VjaGluZyBjb2RlIHRoYXQgaXMgZGlyZWN0bHkgcmVsYXRl
ZCB0byBuZXN0ZWQgVFNDIHNjYWxpbmcgYW5kIG5vdA0KPiA+IHRyeSB0byBkbyBldmVyeXRoaW5n
IGFzIHBhcnQgb2YgdGhlIHNhbWUgc2VyaWVzLg0KPiANCj4gQnV0IGl0IGRpcmVjdGx5IGltcGFj
dHMgeW91ciBjb2RlLCBlLmcuIHRoZSBuZXN0ZWQgZW50ZXIvZXhpdCBmbG93cyB3b3VsZCBuZWVk
DQo+IHRvIGRhbmNlIGFyb3VuZCB0aGUgZGVjYWNoZSBzaWxsaW5lc3MuICBBbmQgSSBiZWxpZXZl
IGl0IGV2ZW4gbW9yZSBkaXJlY3RseQ0KPiBpbXBhY3RzIHRoaXMgc2VyaWVzOiBrdm1fc2V0X3Rz
Y19raHooKSBmYWlscyB0byBoYW5kbGUgdGhlIGNhc2Ugd2hlcmUgdXNlcnNwYWNlDQo+IGludm9r
ZXMgS1ZNX1NFVF9UU0NfS0haIHdoaWxlIEwyIGlzIGFjdGl2ZS4NCg0KR29vZCBjYXRjaCENCg0K
PiANCj4gPiBUaGlzIG1ha2VzIHRlc3RpbmcgZWFzaWVyIHRvby4NCj4gDQo+IEhtbSwgc29ydCBv
Zi4gIFllcywgdGhlIGZld2VyIHBhdGNoZXMvbW9kaWZpY2F0aW9ucyBpbiBhIHNlcmllcyBkZWZp
bml0ZWx5IG1ha2VzDQo+IHRoZSBzZXJpZXMgaXRzZWxmIGVhc2llciB0byB0ZXN0LiAgQnV0IHN0
ZXBwaW5nIGJhY2sgYW5kIGxvb2tpbmcgYXQgdGhlIHRvdGFsDQo+IGNvc3Qgb2YgdGVzdGluZywg
SSB3b3VsZCBhcmd1ZSB0aGF0IHB1bnRpbmcgcmVsYXRlZCBjaGFuZ2VzIHRvIGEgbGF0ZXIgdGlt
ZQ0KPiBpbmNyZWFzZXMgdGhlIG92ZXJhbGwgY29zdC4gIEUuZy4gaWYgc29tZW9uZSBlbHNlIHBp
Y2tzIHVwIHRoZSBjbGVhbiB1cCB3b3JrLA0KPiB0aGVuIHRoZXkgaGF2ZSB0byByZWRvIG1vc3Qs
IGlmIG5vdCBhbGwsIG9mIHRoZSB0ZXN0aW5nIHRoYXQgeW91IGFyZSBhbHJlYWR5DQo+IGRvaW5n
LCBpbmNsdWRpbmcgZ2V0dGluZyBhY2Nlc3MgdG8gdGhlIHByb3BlciBoYXJkd2FyZSwgdW5kZXJz
dGFuZGluZyB3aGF0IHRlc3RzDQo+IHRvIHByaW9yaXRpemUsIGV0Yy4uLiAgV2hlcmVhcyBhZGRp
bmcgb25lIG1vcmUgcGF0Y2ggdG8geW91ciBzZXJpZXMgaXMgYW4NCj4gaW5jcmVtZW50YWwgY29z
dCBzaW5jZSB5b3UgYWxyZWFkeSBoYXZlIHRoZSBoYXJkd2FyZSBzZXR1cCwga25vdyB3aGljaCB0
ZXN0cyB0bw0KPiBydW4sIGV0Yy4uLg0KPiANCj4gPiBXZSBjYW4gc3RpbGwgaW1wbGVtZW50IHRo
ZXNlIGNoYW5nZXMgbGF0ZXIuDQo+IA0KPiBXZSBjYW4sIGJ1dCB3ZSBzaG91bGRuJ3QuICBTaW1w
bHkgZHJvcHBpbmcgdm14LT5jdXJyZW50X3RzY19yYXRpbyBpcyBub3QgYW4NCj4gb3B0aW9uOyBp
dCBrbm93aW5nbHkgaW50cm9kdWNlcyBhIChtaW5vcikgcGVyZm9ybWFuY2UgcmVncmVzc2lvbiwg
Zm9yIG5vIHJlYXNvbg0KPiBvdGhlciB0aGFuIHdhbnRpbmcgdG8gYXZvaWQgY29kZSBjaHVybi4g
IFBpbGluZyBtb3JlIHN0dWZmIG9uIHRvcCBvZiB0aGUgZmxhd2VkDQo+IGRlY2FjaGUgbG9naWMg
aXMgaW1wb2xpdGUsIGFzIGl0IGFkZHMgbW9yZSB3b3JrIGZvciB0aGUgcGVyc29uIHRoYXQgZW5k
cyB1cA0KPiBkb2luZyB0aGUgY2xlYW51cC4gIEkgd291bGQgMTAwJSBhZ3JlZSBpZiB0aGlzIHdl
cmUgYSBzaWduaWZpY2FudCBjbGVhbnVwIGFuZC9vcg0KPiBjb21wbGV0ZWx5IHVucmVsYXRlZCwg
YnV0IElNTyB0aGF0J3Mgbm90IHRoZSBjYXNlLg0KPiANCj4gQ29tcGlsZSB0ZXN0ZWQgb25seS4u
Lg0KDQpUaGFuayB5b3UuIA0KDQo+IA0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1
ZGUvYXNtL2t2bS14ODYtb3BzLmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm0teDg2LW9wcy5o
DQo+IGluZGV4IDAyOWM5NjE1Mzc4Zi4uMzRhZDdhMTc0NThhIDEwMDY0NA0KPiAtLS0gYS9hcmNo
L3g4Ni9pbmNsdWRlL2FzbS9rdm0teDg2LW9wcy5oDQo+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUv
YXNtL2t2bS14ODYtb3BzLmgNCj4gQEAgLTkwLDYgKzkwLDcgQEAgS1ZNX1g4Nl9PUF9OVUxMKGhh
c193YmludmRfZXhpdCkNCj4gIEtWTV9YODZfT1AoZ2V0X2wyX3RzY19vZmZzZXQpDQo+ICBLVk1f
WDg2X09QKGdldF9sMl90c2NfbXVsdGlwbGllcikNCj4gIEtWTV9YODZfT1Aod3JpdGVfdHNjX29m
ZnNldCkNCj4gK0tWTV9YODZfT1Aod3JpdGVfdHNjX211bHRpcGxpZXIpDQo+ICBLVk1fWDg2X09Q
KGdldF9leGl0X2luZm8pDQo+ICBLVk1fWDg2X09QKGNoZWNrX2ludGVyY2VwdCkNCj4gIEtWTV9Y
ODZfT1AoaGFuZGxlX2V4aXRfaXJxb2ZmKQ0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVk
ZS9hc20va3ZtX2hvc3QuaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgNCj4gaW5k
ZXggZjA5OTI3N2I5OTNkLi5hMzM0Y2U3NzQxYWIgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2lu
Y2x1ZGUvYXNtL2t2bV9ob3N0LmgNCj4gKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hv
c3QuaA0KPiBAQCAtMTMwOCw2ICsxMzA4LDcgQEAgc3RydWN0IGt2bV94ODZfb3BzIHsNCj4gICAg
ICAgICB1NjQgKCpnZXRfbDJfdHNjX29mZnNldCkoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsNCj4g
ICAgICAgICB1NjQgKCpnZXRfbDJfdHNjX211bHRpcGxpZXIpKHN0cnVjdCBrdm1fdmNwdSAqdmNw
dSk7DQo+ICAgICAgICAgdm9pZCAoKndyaXRlX3RzY19vZmZzZXQpKHN0cnVjdCBrdm1fdmNwdSAq
dmNwdSwgdTY0IG9mZnNldCk7DQo+ICsgICAgICAgdm9pZCAoKndyaXRlX3RzY19tdWx0aXBsaWVy
KShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHU2NCBtdWx0aXBsaWVyKTsNCj4gDQo+ICAgICAgICAg
LyoNCj4gICAgICAgICAgKiBSZXRyaWV2ZSBzb21ld2hhdCBhcmJpdHJhcnkgZXhpdCBpbmZvcm1h
dGlvbi4gIEludGVuZGVkIHRvIGJlIHVzZWQNCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9z
dm0vc3ZtLmMgYi9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jDQo+IGluZGV4IGIxOGY2MDQ2MzA3My4u
OTE0YWZjY2ViNDZkIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jDQo+ICsr
KyBiL2FyY2gveDg2L2t2bS9zdm0vc3ZtLmMNCj4gQEAgLTExMDMsNiArMTEwMywxNCBAQCBzdGF0
aWMgdm9pZCBzdm1fd3JpdGVfdHNjX29mZnNldChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHU2NCBv
ZmZzZXQpDQo+ICAgICAgICAgdm1jYl9tYXJrX2RpcnR5KHN2bS0+dm1jYiwgVk1DQl9JTlRFUkNF
UFRTKTsNCj4gIH0NCj4gDQo+ICtzdGF0aWMgdm9pZCBzdm1fd3JpdGVfdHNjX211bHRpcGxpZXIo
c3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1NjQgbDFfbXVsdGlwbGllcikNCj4gK3sNCj4gKyAgICAg
ICAvKg0KPiArICAgICAgICAqIEhhbmRsZWQgd2hlbiBsb2FkaW5nIGd1ZXN0IHN0YXRlIHNpbmNl
IHRoZSByYXRpbyBpcyBwcm9ncmFtbWVkIHZpYQ0KPiArICAgICAgICAqIE1TUl9BTUQ2NF9UU0Nf
UkFUSU8sIG5vdCBhIGZpZWxkIGluIHRoZSBWTUNCLg0KPiArICAgICAgICAqLw0KPiArfQ0KPiAr
DQoNCk9rLCB3aGF0IEkgd2FudGVkIHRvIGF2b2lkIHJlYWxseSBpcyBoYXZpbmcgdG8gZGlnIGlu
dG8gU1ZNIGNvZGUgYW5kIHNlZSB3aGVyZQ0KZXhhY3RseSBpdCBzZXRzIHRoZSBUU0MgbXVsdGlw
bGllciBvciBoYXZpbmcgdG8gaW1wbGVtZW50DQpzdm1fd3JpdGVfdHNjX211bHRpcGxpZXIgYXMg
SSBrbmV3IEFNRCB1c2VzIGFuIE1TUiBpbnN0ZWFkIG9mIGEgVk1DQiBmaWVsZC4NCg0KQnV0IGlm
IHdlIGFyZSBmaW5lIHdpdGggaW50cm9kdWNpbmcgdGhpcyBhcyBpcyBhYm92ZSAoZm9yIG5vdykg
SSB3aWxsIGluY2x1ZGUgDQp0aGlzIGluIHRoZSBzZXJpZXMsIGFwcGx5IHRoZSBvdGhlciBzbWFs
bCBjaGFuZ2VzIHN1Z2dlc3RlZCBhbmQgcmUtcG9zdCB0aGUgDQpwYXRjaGVzLg0KDQoNCg0K
