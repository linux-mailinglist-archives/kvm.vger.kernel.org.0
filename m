Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C947430B28
	for <lists+kvm@lfdr.de>; Fri, 31 May 2019 11:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfEaJML (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 May 2019 05:12:11 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:38837 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfEaJML (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 May 2019 05:12:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1559293929; x=1590829929;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:mime-version:
   content-transfer-encoding;
  bh=3bNclZB2YOLq54Np5GxnnxbsdVXRE+YAkevMXFYDtao=;
  b=NWHIMt9E7qZZ/H4ghJmywogxnaXUc7Bl8zZr/3rkv+hyVkEQsGzx7wA3
   oKqYs2Nmo4lRKVpGSS6sfbB4oFe2AlRL1o8MgZ589FOvg6o5My9USobhJ
   bWd3i1FMlqXzvCZS94kOVtlz0zbMgTn6jkjBXSvB5rKC7u8Gj4KVQE8GH
   E=;
X-IronPort-AV: E=Sophos;i="5.60,534,1549929600"; 
   d="scan'208";a="735510865"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 31 May 2019 09:12:08 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 406B524270A;
        Fri, 31 May 2019 09:12:05 +0000 (UTC)
Received: from EX13D01EUB004.ant.amazon.com (10.43.166.180) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 31 May 2019 09:12:04 +0000
Received: from EX13D01EUB003.ant.amazon.com (10.43.166.248) by
 EX13D01EUB004.ant.amazon.com (10.43.166.180) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 31 May 2019 09:12:04 +0000
Received: from EX13D01EUB003.ant.amazon.com ([10.43.166.248]) by
 EX13D01EUB003.ant.amazon.com ([10.43.166.248]) with mapi id 15.00.1367.000;
 Fri, 31 May 2019 09:12:03 +0000
From:   "Raslan, KarimAllah" <karahmed@amazon.de>
To:     "Sironi, Filippo" <sironi@amazon.de>,
        "Graf, Alexander" <graf@amazon.com>
CC:     "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>,
        "Marc.Zyngier@arm.com" <Marc.Zyngier@arm.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH v2 1/2] KVM: Start populating /sys/hypervisor with KVM
 entries
Thread-Topic: [PATCH v2 1/2] KVM: Start populating /sys/hypervisor with KVM
 entries
Thread-Index: AQHVF5A0AEnBVqds/UWWKNg1ZPSkZKaE8rAA
Date:   Fri, 31 May 2019 09:12:03 +0000
Message-ID: <1559293922.14762.2.camel@amazon.de>
References: <1539078879-4372-1-git-send-email-sironi@amazon.de>
         <1557847002-23519-1-git-send-email-sironi@amazon.de>
         <1557847002-23519-2-git-send-email-sironi@amazon.de>
         <e976f31b-2ccd-29ba-6a32-2edde49f867f@amazon.com>
         <3D2C4EE3-1C2E-4032-9964-31A066E542AA@amazon.de>
         <6b3dadf9-6240-6440-b784-50bec605bf2c@amazon.com>
In-Reply-To: <6b3dadf9-6240-6440-b784-50bec605bf2c@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.53]
Content-Type: text/plain; charset="utf-8"
Content-ID: <2CCBC2BB6465434FA03C3C01B59CEAA9@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDE5LTA1LTMxIGF0IDExOjA2ICswMjAwLCBBbGV4YW5kZXIgR3JhZiB3cm90ZToN
Cj4gT24gMTcuMDUuMTkgMTc6NDEsIFNpcm9uaSwgRmlsaXBwbyB3cm90ZToNCj4gPiANCj4gPiA+
IA0KPiA+ID4gT24gMTYuIE1heSAyMDE5LCBhdCAxNTo1MCwgR3JhZiwgQWxleGFuZGVyIDxncmFm
QGFtYXpvbi5jb20+IHdyb3RlOg0KPiA+ID4gDQo+ID4gPiBPbiAxNC4wNS4xOSAwODoxNiwgRmls
aXBwbyBTaXJvbmkgd3JvdGU6DQo+ID4gPiA+IA0KPiA+ID4gPiBTdGFydCBwb3B1bGF0aW5nIC9z
eXMvaHlwZXJ2aXNvciB3aXRoIEtWTSBlbnRyaWVzIHdoZW4gd2UncmUgcnVubmluZyBvbg0KPiA+
ID4gPiBLVk0uIFRoaXMgaXMgdG8gcmVwbGljYXRlIGZ1bmN0aW9uYWxpdHkgdGhhdCdzIGF2YWls
YWJsZSB3aGVuIHdlJ3JlDQo+ID4gPiA+IHJ1bm5pbmcgb24gWGVuLg0KPiA+ID4gPiANCj4gPiA+
ID4gU3RhcnQgd2l0aCAvc3lzL2h5cGVydmlzb3IvdXVpZCwgd2hpY2ggdXNlcnMgcHJlZmVyIG92
ZXINCj4gPiA+ID4gL3N5cy9kZXZpY2VzL3ZpcnR1YWwvZG1pL2lkL3Byb2R1Y3RfdXVpZCBhcyBh
IHdheSB0byByZWNvZ25pemUgYSB2aXJ0dWFsDQo+ID4gPiA+IG1hY2hpbmUsIHNpbmNlIGl0J3Mg
YWxzbyBhdmFpbGFibGUgd2hlbiBydW5uaW5nIG9uIFhlbiBIVk0gYW5kIG9uIFhlbiBQVg0KPiA+
ID4gPiBhbmQsIG9uIHRvcCBvZiB0aGF0IGRvZXNuJ3QgcmVxdWlyZSByb290IHByaXZpbGVnZXMg
YnkgZGVmYXVsdC4NCj4gPiA+ID4gTGV0J3MgY3JlYXRlIGFyY2gtc3BlY2lmaWMgaG9va3Mgc28g
dGhhdCBkaWZmZXJlbnQgYXJjaGl0ZWN0dXJlcyBjYW4NCj4gPiA+ID4gcHJvdmlkZSBkaWZmZXJl
bnQgaW1wbGVtZW50YXRpb25zLg0KPiA+ID4gPiANCj4gPiA+ID4gU2lnbmVkLW9mZi1ieTogRmls
aXBwbyBTaXJvbmkgPHNpcm9uaUBhbWF6b24uZGU+DQo+ID4gPiBJIHRoaW5rIHRoaXMgbmVlZHMg
c29tZXRoaW5nIGFraW4gdG8NCj4gPiA+IA0KPiA+ID4gICBodHRwczovL3d3dy5rZXJuZWwub3Jn
L2RvYy9Eb2N1bWVudGF0aW9uL0FCSS9zdGFibGUvc3lzZnMtaHlwZXJ2aXNvci14ZW4NCj4gPiA+
IA0KPiA+ID4gdG8gZG9jdW1lbnQgd2hpY2ggZmlsZXMgYXJlIGF2YWlsYWJsZS4NCj4gPiA+IA0K
PiA+ID4gPiANCj4gPiA+ID4gLS0tDQo+ID4gPiA+IHYyOg0KPiA+ID4gPiAqIG1vdmUgdGhlIHJl
dHJpZXZhbCBvZiB0aGUgVk0gVVVJRCBvdXQgb2YgdXVpZF9zaG93IGFuZCBpbnRvDQo+ID4gPiA+
ICAga3ZtX3BhcmFfZ2V0X3V1aWQsIHdoaWNoIGlzIGEgd2VhayBmdW5jdGlvbiB0aGF0IGNhbiBi
ZSBvdmVyd3JpdHRlbg0KPiA+ID4gPiANCj4gPiA+ID4gZHJpdmVycy9LY29uZmlnICAgICAgICAg
ICAgICB8ICAyICsrDQo+ID4gPiA+IGRyaXZlcnMvTWFrZWZpbGUgICAgICAgICAgICAgfCAgMiAr
Kw0KPiA+ID4gPiBkcml2ZXJzL2t2bS9LY29uZmlnICAgICAgICAgIHwgMTQgKysrKysrKysrKysr
KysNCj4gPiA+ID4gZHJpdmVycy9rdm0vTWFrZWZpbGUgICAgICAgICB8ICAxICsNCj4gPiA+ID4g
ZHJpdmVycy9rdm0vc3lzLWh5cGVydmlzb3IuYyB8IDMwICsrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKw0KPiA+ID4gPiA1IGZpbGVzIGNoYW5nZWQsIDQ5IGluc2VydGlvbnMoKykNCj4gPiA+
ID4gY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMva3ZtL0tjb25maWcNCj4gPiA+ID4gY3JlYXRl
IG1vZGUgMTAwNjQ0IGRyaXZlcnMva3ZtL01ha2VmaWxlDQo+ID4gPiA+IGNyZWF0ZSBtb2RlIDEw
MDY0NCBkcml2ZXJzL2t2bS9zeXMtaHlwZXJ2aXNvci5jDQo+ID4gPiA+IA0KPiA+ID4gWy4uLl0N
Cj4gPiA+IA0KPiA+ID4gPiANCj4gPiA+ID4gKw0KPiA+ID4gPiArX193ZWFrIGNvbnN0IGNoYXIg
Kmt2bV9wYXJhX2dldF91dWlkKHZvaWQpDQo+ID4gPiA+ICt7DQo+ID4gPiA+ICsJcmV0dXJuIE5V
TEw7DQo+ID4gPiA+ICt9DQo+ID4gPiA+ICsNCj4gPiA+ID4gK3N0YXRpYyBzc2l6ZV90IHV1aWRf
c2hvdyhzdHJ1Y3Qga29iamVjdCAqb2JqLA0KPiA+ID4gPiArCQkJIHN0cnVjdCBrb2JqX2F0dHJp
YnV0ZSAqYXR0ciwNCj4gPiA+ID4gKwkJCSBjaGFyICpidWYpDQo+ID4gPiA+ICt7DQo+ID4gPiA+
ICsJY29uc3QgY2hhciAqdXVpZCA9IGt2bV9wYXJhX2dldF91dWlkKCk7DQo+ID4gPiA+ICsJcmV0
dXJuIHNwcmludGYoYnVmLCAiJXNcbiIsIHV1aWQpOw0KPiA+ID4gVGhlIHVzdWFsIHJldHVybiB2
YWx1ZSBmb3IgdGhlIFhlbiAvc3lzL2h5cGVydmlzb3IgaW50ZXJmYWNlIGlzDQo+ID4gPiAiPGRl
bmllZD4iLiBXb3VsZG4ndCBpdCBtYWtlIHNlbnNlIHRvIGZvbGxvdyB0aGF0IHBhdHRlcm4gZm9y
IHRoZSBLVk0NCj4gPiA+IG9uZSB0b28/IEN1cnJlbnRseSwgaWYgd2UgY2FuIG5vdCBkZXRlcm1p
bmUgdGhlIFVVSUQgdGhpcyB3aWxsIGp1c3QNCj4gPiA+IHJldHVybiAobnVsbCkuDQo+ID4gPiAN
Cj4gPiA+IE90aGVyd2lzZSwgbG9va3MgZ29vZCB0byBtZS4gQXJlIHlvdSBhd2FyZSBvZiBhbnkg
b3RoZXIgZmlsZXMgd2Ugc2hvdWxkDQo+ID4gPiBwcm92aWRlPyBBbHNvLCBpcyB0aGVyZSBhbnkg
cmVhc29uIG5vdCB0byBpbXBsZW1lbnQgQVJNIGFzIHdlbGwgd2hpbGUgYXQgaXQ/DQo+ID4gPiAN
Cj4gPiA+IEFsZXgNCj4gPiBUaGlzIG9yaWdpbmF0ZWQgZnJvbSBhIGN1c3RvbWVyIHJlcXVlc3Qg
dGhhdCB3YXMgdXNpbmcgL3N5cy9oeXBlcnZpc29yL3V1aWQuDQo+ID4gTXkgZ3Vlc3MgaXMgdGhh
dCB3ZSB3b3VsZCB3YW50IHRvIGV4cG9zZSAidHlwZSIgYW5kICJ2ZXJzaW9uIiBtb3ZpbmcNCj4g
PiBmb3J3YXJkIGFuZCB0aGF0J3Mgd2hlbiB3ZSBoeXBlcnZpc29yIGhvb2tzIHdpbGwgYmUgdXNl
ZnVsIG9uIHRvcA0KPiA+IG9mIGFyY2ggaG9va3MuDQo+ID4gDQo+ID4gT24gYSBkaWZmZXJlbnQg
bm90ZSwgYW55IGlkZWEgaG93IHRvIGNoZWNrIHdoZXRoZXIgdGhlIE9TIGlzIHJ1bm5pbmcNCj4g
PiB2aXJ0dWFsaXplZCBvbiBLVk0gb24gQVJNIGFuZCBBUk02ND8gIGt2bV9wYXJhX2F2YWlsYWJs
ZSgpIGlzbid0IGFuDQo+IA0KPiANCj4gWWVhaCwgQVJNIGRvZXNuJ3QgaGF2ZSBhbnkgS1ZNIFBW
IEZXSVcuIEkgYWxzbyBjYW4ndCBmaW5kIGFueSBleHBsaWNpdCANCj4gaGludCBwYXNzZWQgaW50
byBndWVzdHMgdGhhdCB3ZSBhcmUgaW5kZWVkIHJ1bm5pbmcgaW4gS1ZNLiBUaGUgY2xvc2VzdCAN
Cj4gdGhpbmcgSSBjYW4gc2VlIGlzIHRoZSBTTUJJT1MgcHJvZHVjdCBpZGVudGlmaWVyIGluIFFF
TVUgd2hpY2ggZ2V0cyANCj4gcGF0Y2hlZCB0byAiS1ZNIFZpcnR1YWwgTWFjaGluZSIuIE1heWJl
IHdlJ2xsIGhhdmUgdG8gZG8gd2l0aCB0aGF0IGZvciANCj4gdGhlIHNha2Ugb2YgYmFja3dhcmRz
IGNvbXBhdGliaWxpdHkgLi4uDQoNCkhvdyBhYm91dCAicHNjaV9vcHMuY29uZHVpdCIgKFBTQ0lf
Q09ORFVJVF9IVkMgdnMgUFNDSV9DT05EVUlUX1NNQyk/DQoNCj4gDQo+IA0KPiA+IA0KPiA+IG9w
dGlvbiBhbmQgdGhlIHNhbWUgaXMgdHJ1ZSBmb3IgUzM5MCB3aGVyZSBrdm1fcGFyYV9hdmFpbGFi
bGUoKQ0KPiA+IGFsd2F5cyByZXR1cm5zIHRydWUgYW5kIGl0IHdvdWxkIGV2ZW4gaWYgYSBLVk0g
ZW5hYmxlZCBrZXJuZWwgd291bGQNCj4gPiBiZSBydW5uaW5nIG9uIGJhcmUgbWV0YWwuDQo+IA0K
PiANCj4gRm9yIHMzOTAsIHlvdSBjYW4gZmlndXJlIHRoZSB0b3BvbG9neSBvdXQgdXNpbmcgdGhl
IHN0aHlpIGluc3RydWN0aW9uLiANCj4gSSdtIG5vdCBzdXJlIGlmIHRoZXJlIGlzIGEgbmljZSBp
bi1rZXJuZWwgQVBJIHRvIGxldmVyYWdlIHRoYXQgdGhvdWdoLiANCj4gSW4gZmFjdCwga3ZtX3Bh
cmFfYXZhaWxhYmxlKCkgcHJvYmFibHkgc2hvdWxkIGNoZWNrIHN0aHlpIG91dHB1dCB0byANCj4g
ZGV0ZXJtaW5lIHdoZXRoZXIgd2UgcmVhbGx5IGNhbiB1c2UgaXQsIG5vPyBDaHJpc3RpYW4/DQo+
IA0KPiANCj4gQWxleA0KPiANCj4gDQo+ID4gDQo+ID4gDQo+ID4gSSB0aGluayB3ZSB3aWxsIG5l
ZWQgYW5vdGhlciBhcmNoIGhvb2sgdG8gY2FsbCBhIGZ1bmN0aW9uIHRoYXQgc2F5cw0KPiA+IHdo
ZXRoZXIgdGhlIE9TIGlzIHJ1bm5pbmcgdmlydHVhbGl6ZWQgb24gS1ZNLg0KPiA+IA0KPiA+ID4g
DQo+ID4gPiA+IA0KPiA+ID4gPiArfQ0KPiA+ID4gPiArDQo+ID4gPiA+ICtzdGF0aWMgc3RydWN0
IGtvYmpfYXR0cmlidXRlIHV1aWQgPSBfX0FUVFJfUk8odXVpZCk7DQo+ID4gPiA+ICsNCj4gPiA+
ID4gK3N0YXRpYyBpbnQgX19pbml0IHV1aWRfaW5pdCh2b2lkKQ0KPiA+ID4gPiArew0KPiA+ID4g
PiArCWlmICgha3ZtX3BhcmFfYXZhaWxhYmxlKCkpDQo+ID4gPiA+ICsJCXJldHVybiAwOw0KPiA+
ID4gPiArCXJldHVybiBzeXNmc19jcmVhdGVfZmlsZShoeXBlcnZpc29yX2tvYmosICZ1dWlkLmF0
dHIpOw0KPiA+ID4gPiArfQ0KPiA+ID4gPiArDQo+ID4gPiA+ICtkZXZpY2VfaW5pdGNhbGwodXVp
ZF9pbml0KTsNCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVz
ZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hs
YWVnZXIsIFJhbGYgSGVyYnJpY2gKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRl
bmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAyMzcg
ODc5CgoK

