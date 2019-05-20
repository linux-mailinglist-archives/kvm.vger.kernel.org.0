Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 152AE23FD4
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 20:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfETSBI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 14:01:08 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:11288 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbfETSBI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 14:01:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1558375266; x=1589911266;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:mime-version:
   content-transfer-encoding;
  bh=XUIChiQs/1OntduJ1ZuYTtrZ8MBU3jxohmfQVqCjLmc=;
  b=l83wTo8FkSDVmCJoA+3BYKTt4B+CpQauqT+8XrBJyyXBeJBbHbNXkd8K
   jY8NBMQj8OENnX1UbgC8spCHstpk8MOx6QmtSS05KdyOdFaCKPIttz7GT
   5jEYdiEfkUP2fBuhZQJqVsTx0VMFvbbu2aQlWC/BVuK409/0Hsq9EKl5m
   4=;
X-IronPort-AV: E=Sophos;i="5.60,492,1549929600"; 
   d="scan'208";a="402864763"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 20 May 2019 18:01:05 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (8.14.7/8.14.7) with ESMTP id x4KI10OV055101
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Mon, 20 May 2019 18:01:01 GMT
Received: from EX13D01EUB003.ant.amazon.com (10.43.166.248) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 20 May 2019 18:01:00 +0000
Received: from EX13D01EUB003.ant.amazon.com (10.43.166.248) by
 EX13D01EUB003.ant.amazon.com (10.43.166.248) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 20 May 2019 18:00:59 +0000
Received: from EX13D01EUB003.ant.amazon.com ([10.43.166.248]) by
 EX13D01EUB003.ant.amazon.com ([10.43.166.248]) with mapi id 15.00.1367.000;
 Mon, 20 May 2019 18:00:59 +0000
From:   "Raslan, KarimAllah" <karahmed@amazon.de>
To:     "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
        "andre.przywara@arm.com" <andre.przywara@arm.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "christoffer.dall@arm.com" <christoffer.dall@arm.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "julien.thierry@arm.com" <julien.thierry@arm.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>
Subject: Re: [RFC PATCH] KVM: arm/arm64: Enable direct irqfd MSI injection
Thread-Topic: [RFC PATCH] KVM: arm/arm64: Enable direct irqfd MSI injection
Thread-Index: AQHVDyJHR8A/dRSYf0eZnuco+a/IvaZ0Ta6A
Date:   Mon, 20 May 2019 18:00:58 +0000
Message-ID: <1558375257.12877.23.camel@amazon.de>
References: <1552833373-19828-1-git-send-email-yuzenghui@huawei.com>
         <86o969z42z.wl-marc.zyngier@arm.com>
         <20190318133040.1cfad9a4@why.wild-wind.fr.eu.org>
         <20190515173832.62afdd90@donnerap.cambridge.arm.com>
         <864l5u7tla.wl-marc.zyngier@arm.com>
         <f61ed9f7-2bfc-8d6d-fac7-efc6329e9726@huawei.com>
In-Reply-To: <f61ed9f7-2bfc-8d6d-fac7-efc6329e9726@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.155]
Content-Type: text/plain; charset="utf-8"
Content-ID: <45554885682E7B47A0B29C41E2E99350@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDE5LTA1LTIwIGF0IDIzOjMxICswODAwLCBaZW5naHVpIFl1IHdyb3RlOg0KPiBI
aSBNYXJjLA0KPiANCj4gT24gMjAxOS81LzE2IDE1OjIxLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
ID4gDQo+ID4gSGkgQW5kcmUsDQo+ID4gDQo+ID4gT24gV2VkLCAxNSBNYXkgMjAxOSAxNzozODoz
MiArMDEwMCwNCj4gPiBBbmRyZSBQcnp5d2FyYSA8YW5kcmUucHJ6eXdhcmFAYXJtLmNvbT4gd3Jv
dGU6DQo+ID4gPiANCj4gPiA+IA0KPiA+ID4gT24gTW9uLCAxOCBNYXIgMjAxOSAxMzozMDo0MCAr
MDAwMA0KPiA+ID4gTWFyYyBaeW5naWVyIDxtYXJjLnp5bmdpZXJAYXJtLmNvbT4gd3JvdGU6DQo+
ID4gPiANCj4gPiA+IEhpLA0KPiA+ID4gDQo+ID4gPiA+IA0KPiA+ID4gPiBPbiBTdW4sIDE3IE1h
ciAyMDE5IDE5OjM1OjQ4ICswMDAwDQo+ID4gPiA+IE1hcmMgWnluZ2llciA8bWFyYy56eW5naWVy
QGFybS5jb20+IHdyb3RlOg0KPiA+ID4gPiANCj4gPiA+ID4gWy4uLl0NCj4gPiA+ID4gDQo+ID4g
PiA+ID4gDQo+ID4gPiA+ID4gQSBmaXJzdCBhcHByb2FjaCB3b3VsZCBiZSB0byBrZWVwIGEgc21h
bGwgY2FjaGUgb2YgdGhlIGxhc3QgZmV3DQo+ID4gPiA+ID4gc3VjY2Vzc2Z1bCB0cmFuc2xhdGlv
bnMgZm9yIHRoaXMgSVRTLCBjYWNoZSB0aGF0IGNvdWxkIGJlIGxvb2tlZC11cCBieQ0KPiA+ID4g
PiA+IGhvbGRpbmcgYSBzcGlubG9jayBpbnN0ZWFkLiBBIGhpdCBpbiB0aGlzIGNhY2hlIGNvdWxk
IGRpcmVjdGx5IGJlDQo+ID4gPiA+ID4gaW5qZWN0ZWQuIEFueSBjb21tYW5kIHRoYXQgaW52YWxp
ZGF0ZXMgb3IgY2hhbmdlcyBhbnl0aGluZyAoRElTQ0FSRCwNCj4gPiA+ID4gPiBJTlYsIElOVkFM
TCwgTUFQQyB3aXRoIFY9MCwgTUFQRCB3aXRoIFY9MCwgTU9WQUxMLCBNT1ZJKSBzaG91bGQgbnVr
ZQ0KPiA+ID4gPiA+IHRoZSBjYWNoZSBhbHRvZ2V0aGVyLg0KPiA+ID4gPiANCj4gPiA+ID4gQW5k
IHRvIGV4cGxhaW4gd2hhdCBJIG1lYW50IHdpdGggdGhpcywgSSd2ZSBwdXNoZWQgYSBicmFuY2hb
MV0gd2l0aCBhDQo+ID4gPiA+IGJhc2ljIHByb3RvdHlwZS4gSXQgaXMgZ29vZCBlbm91Z2ggdG8g
Z2V0IGEgVk0gdG8gYm9vdCwgYnV0IEkgd291bGRuJ3QNCj4gPiA+ID4gdHJ1c3QgaXQgZm9yIGFu
eXRoaW5nIHNlcmlvdXMganVzdCB5ZXQuDQo+ID4gPiA+IA0KPiA+ID4gPiBJZiBhbnlvbmUgZmVl
bHMgbGlrZSBnaXZpbmcgaXQgYSBnbyBhbmQgY2hlY2sgd2hldGhlciBpdCBoYXMgYW55DQo+ID4g
PiA+IGJlbmVmaXQgcGVyZm9ybWFuY2Ugd2lzZSwgcGxlYXNlIGRvIHNvLg0KPiA+ID4gDQo+ID4g
PiBTbyBJIHRvb2sgYSBzdGFiIGF0IHRoZSBwZXJmb3JtYW5jZSBhc3BlY3QsIGFuZCBpdCB0b29r
IG1lIGEgd2hpbGUgdG8gZmluZA0KPiA+ID4gc29tZXRoaW5nIHdoZXJlIGl0IGFjdHVhbGx5IG1h
a2VzIGEgZGlmZmVyZW5jZS4gVGhlIHRyaWNrIGlzIHRvIGNyZWF0ZSAqYQ0KPiA+ID4gbG90KiBv
ZiBpbnRlcnJ1cHRzLiBUaGlzIGlzIG15IHNldHVwIG5vdzoNCj4gPiA+IC0gR0lDdjMgYW5kIElU
Uw0KPiA+ID4gLSA1LjEuMCBrZXJuZWwgdnMuIDUuMS4wIHBsdXMgTWFyYydzIHJlYmFzZWQgIklU
UyBjYWNoZSIgcGF0Y2hlcyBvbiB0b3ANCj4gPiA+IC0gNCBWQ1BVIGd1ZXN0IG9uIGEgNCBjb3Jl
IG1hY2hpbmUNCj4gPiA+IC0gcGFzc2luZyB0aHJvdWdoIGEgTS4yIE5WTWUgU1NEIChvciBhIFVT
QjMgY29udHJvbGxlcikgdG8gdGhlIGd1ZXN0DQo+ID4gPiAtIHJ1bm5pbmcgRklPIGluIHRoZSBn
dWVzdCwgd2l0aDoNCj4gPiA+ICAgIC0gNEsgYmxvY2sgc2l6ZSwgcmFuZG9tIHJlYWRzLCBxdWV1
ZSBkZXB0aCAxNiwgNCBqb2JzIChzbWFsbCkNCj4gPiA+ICAgIC0gMU0gYmxvY2sgc2l6ZSwgc2Vx
dWVudGlhbCByZWFkcywgUUQgMSwgMSBqb2IgKGJpZykNCj4gPiA+IA0KPiA+ID4gRm9yIHRoZSBO
Vk1lIGRpc2sgSSBzZWUgYSB3aG9wcGluZyAxOSUgcGVyZm9ybWFuY2UgaW1wcm92ZW1lbnQgd2l0
aCBNYXJjJ3MNCj4gPiA+IHNlcmllcyAoZm9yIHRoZSBzbWFsbCBibG9ja3MpLiBGb3IgYSBTQVRB
IFNTRCBjb25uZWN0ZWQgdmlhIFVTQjMuMCBJIHN0aWxsDQo+ID4gPiBzZWUgNiUgaW1wcm92ZW1l
bnQuIEZvciBOVk1lIHRoZXJlIHdlcmUgNTAsMDAwIGludGVycnVwdHMgcGVyIHNlY29uZCBvbg0K
PiA+ID4gdGhlIGhvc3QsIHRoZSBVU0IzIHNldHVwIGNhbWUgb25seSB1cCB0byAxMCwwMDAvcy4g
Rm9yIGJpZyBibG9ja3MgKHdpdGgNCj4gPiA+IElSUXMgaW4gdGhlIGxvdyB0aG91c2FuZHMvcykg
dGhlIHdpbiBpcyBsZXNzLCBidXQgc3RpbGwgYSBtZWFzdXJhYmxlDQo+ID4gPiAzJS4NCj4gPiAN
Cj4gPiBUaGFua3MgZm9yIGhhdmluZyBhIGdvIGF0IHRoaXMsIGFuZCBpZGVudGlmeWluZyB0aGUg
Y2FzZSB3aGVyZSBpdA0KPiA+IGFjdHVhbGx5IG1hdHRlcnMgKEkgd291bGQgaGF2ZSBob3BlZCB0
aGF0IHRoZSBvcmlnaW5hbCByZXBvcnRlciB3b3VsZA0KPiA+IGhhdmUgaGVscGVkIHdpdGggdGhp
cywgYnV0IGhleSwgbmV2ZXIgbWluZCkuIFRoZSByZXN1bHRzIGFyZSBwcmV0dHkNCj4gPiBpbXBy
ZXNzaXZlIChtb3JlIHNvIHRoYW4gSSBhbnRpY2lwYXRlZCksIGFuZCBJIHdvbmRlciB3aGV0aGVy
IHdlIGNvdWxkDQo+ID4gaW1wcm92ZSB0aGluZ3MgZnVydGhlciAoNTBrIGludGVycnVwdHMvcyBp
cyBub3QgdGhhdCBoaWdoIC0tIEkgZ2V0DQo+ID4gbW9yZSB0aGFuIDEwMGsgb24gc29tZSBtYWNo
aW5lcyBqdXN0IGJ5IHBsYXlpbmcgd2l0aCB0aGVpciBzZGNhcmQuLi4pLg0KPiANCj4gSSB0aGlu
ayB0aGUgIm9yaWdpbmFsIHJlcG9ydGVyIiBtdXN0IGZlZWwgZW1iYXJyYXNzZWQgbm93Lg0KPiBB
Y3R1YWxseSwgd2UgaGFkIHRlc3RlZCB5b3VyIHBhdGNoZXMgKGJhc2VkIG9uIGFib3V0IDUuMS4w
LXJjMikgYnV0DQo+IGZhaWxlZCB0byBzZWUgcGVyZm9ybWFuY2UgaW1wcm92ZW1lbnQuIEFuZCBJ
IHN0b3BwZWQgdG8gbW92ZSBvbiwgYW5kDQo+IHRoZW4gdHdvIG1vbnRocyBoYWQgZ29uZS4uLiBP
aCBzb3JyeSENCj4gDQo+IFdlIHJldGVzdCB5b3VyIHBhdGNoZXMgb24gNS4xLjAsIHRoZSByZXN1
bHQgaXMgYXMgYmVsb3cuDQo+IA0KPiBUZXN0IHNldHVwOg0KPiAtIEdJQ3YzIGFuZCBJVFMgKG9u
IFRhaXNoYW4gMjI4MCwgRDA1KQ0KPiAtIHR3byA0LVZDUFUgZ3Vlc3RzIHdpdGggdmhvc3QtbmV0
IGludGVyZmFjZQ0KPiAtIHJ1biBpcGVyZiBpbiBndWVzdHM6DQo+ICAgICAtIGd1ZXN0MTogaXBl
cmYgLXMNCj4gICAgIC0gZ3Vlc3QyOiBpcGVyZiAtYyBndWVzdDEtSVAgLXQgMTANCj4gLSBwaW4g
dmNwdSB0aHJlYWRzIGFuZCB2aG9zdCB0aHJlYWRzIG9uIHRoZSBzYW1lIE5VTUEgbm9kZQ0KPiAN
Cj4gUmVzdWx0Og0KPiArLS0tLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0rDQo+ID4gDQo+ID4gUmVzdWx0ICAgICAgICAgIHwgaW50ZXJydXB0cy9z
IHwgYmFuZHdpZHRoIChHYml0cy9zZWMpIHwNCj4gKy0tLS0tLS0tLS0tLS0tLS0tKy0tLS0tLS0t
LS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tKw0KPiA+IA0KPiA+IDUuMS4wICAgICAgICAg
ICB8ICAgIDI1KyBrICAgICB8ICAgIDEwLjYgR2JpdHMvc2VjICAgICB8DQo+ICstLS0tLS0tLS0t
LS0tLS0tLSstLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSsNCj4gPiANCj4g
PiA1LjEuMCAocGF0Y2hlZCkgfCAgICA0MCsgayAgICAgfCAgICAxMC4yIEdiaXRzL3NlYyAgICAg
fA0KPiArLS0tLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0rDQo+IA0KPiBXZSBnZXQgImludGVycnVwdHMvcyIgZnJvbSAvcHJvYy9pbnRlcnJ1cHRz
IG9uIGlwZXJmIHNlcnZlciwgd2l0aCBzdGFibGUNCj4gbWVhc3VyZWQgcmVzdWx0cy4gQW5kIHdl
IGdldCAiYmFuZHdpZHRoIiBkaXJlY3RseSBmcm9tIGlwZXJmLCBidXQgdGhlDQo+IHJlc3VsdHMg
YXJlIHNvbWV3aGF0ICppbnN0YWJsZSouIEFuZCB0aGUgcmVzdWx0cyByZWFsbHkgY29uZnVzZWQg
bWUgLS0NCj4gd2UgcmVjZWl2ZWQgbW9yZSBpbnRlcnJ1cHRzIGJ1dCBnZXQgYSBzbGlnaHQgbG93
ZXIgcGVyZm9ybWFuY2UsIHdoeT8NCj4gDQo+IFdlIGNvbmZpZ3VyZSB0aGUgdmhvc3QtbmV0IGlu
dGVyZmFjZSB3aXRoIG9ubHkgb25lIHF1ZXVlLCBzbyBJIHRoaW5rIHdlDQo+IGNhbiBydWxlIG91
dCB0aGUgc3Bpbi1sb2NrIGluZmx1ZW5jZS4gQW5kICdwZXJmIGxvY2snIGNvbmZpcm1lZCB0aGlz
Lg0KPiBUaGlzIGlzIGFsbCB0aGF0IEkgY2FuIHByb3ZpZGUgbm93LCBzb3JyeSBpZiBpdCdzIHVz
ZWxlc3MuDQo+IA0KPiBBbHNvLCBvbmUgbWlub3Igbml0IGluIGNvZGU6DQo+IEluIHZnaWNfaXRz
X2NhY2hlX3RyYW5zbGF0aW9uKCksIHdlIHVzZSB2Z2ljX3B1dF9pcnEoKSB0byBldmljdCB0aGUg
TFJVDQo+IGNhY2hlIGVudHJ5LCB3aGlsZSB3ZSdyZSBhbHJlYWR5IGhvbGRpbmcgdGhlIGxwaV9s
aXN0X2xvY2suIEEgZGVhZGxvY2sNCj4gd2lsbCBiZSBjYXVzZWQgaGVyZS4gQnV0IHRoaXMgaXMg
ZWFzeSB0byBmaXguDQo+IA0KPiANCj4gQW55d2F5LCB3ZSBhbHdheXMgaGF2ZSBlbm91Z2ggZW52
aXJvbm1lbnRzIChlLmcuLCBEMDUsIEQwNiwgLi4uKSB0byBkbw0KPiBzb21lIHRlc3RzLiBJZiB5
b3Ugd2FudCB0byBkbyBmdXJ0aGVyIHRlc3RzIG9uIG91ciBib2FyZHMsIHBsZWFzZSBsZXQgbWUN
Cj4ga25vdyA6KQ0KDQpZb3UgYWN0dWFsbHkgbmVlZCBhIGxpdHRsZSBiaXQgbW9yZSBjb250cm9s
IG92ZXIgdGhlIGludGVycnVwdCBwaW5uaW5nIGluIHRoZcKgDQpndWVzdCBhbmQgdGhlIGludGVy
cnVwdCBwaW5uaW5nIG9uIHRoZSBob3N0LiBZb3UgYWxzbyBuZWVkIHRvIGNvbnRyb2wgdkNQVcKg
DQpwaW5uaW5nIG9uIHBDUFVzIHRvIGhhdmUgZGV0ZXJtaW5pc3RpYyBiZW5jaG1hcmsgaGVyZS4N
Cg0KSSBoYXZlIGEgcGF0Y2ggKHdoaWNoIGlzIG5vdCBhcyBwb2xpc2hlZCBhcyB0aGUgb25lIGZy
b20gTWFyYykgdGhhdCBkb2VzIGRpcmVjdMKgDQppbnRlcnJ1cHQgaW5qZWN0aW9uIGFuZCB3ZSBk
byBzZWUgcm91Z2hseSAyMCUtMjUlIGJhbmR3aWR0aCBpbmNyZWFzZS4gU28geWVzLMKgDQpkaXJl
Y3QgaW50ZXJydXB0IGluamVjdGlvbiBpcyBhYnNvbHV0ZWx5IG5lZWRlZC4NCg0KR2VuZXJhbGx5
LCBpZiB5b3UgaGF2ZSB0aGUgaG9zdCBpbnRlcnJ1cHQgaGl0dGluZyBhIENQVSBkaWZmZXJlbnQg
ZnJvbSB0aGUgb25lc8KgDQpydW5uaW5nIHRoZSBndWVzdCB5b3Ugc2VlIGhpZ2hlcsKgYmFuZHdp
ZHRoICh3aXRoIGN1cnJlbnQgdmFuaWxsYSBLVk0pLiBPbmNlIHRoZcKgDQpob3N0IGludGVycnVw
dHMgaGl0IHRoZSBzYW1lIHZDUFUgYXMgdGhlIGd1ZXN0LCBub3QgaGF2aW5nIHRoaXMgZGlyZWN0
IGluamVjdGlvbg0KcGF0aCBzaG93cyBhIGh1Z2UgZHJvcCBpbiBiYW5kd2lkdGguDQoNClNvIGdl
bmVyYWxseSBJIHdvdWxkIHN1Z2dlc3QgdG8gbW92ZSBmb3J3YXJkIHdpdGggZGlyZWN0IGluamVj
dGlvbiBwYXRjaCBhcyBpdMKgDQppcyByZWFsbHkgbmVlZGVkIGluIHBsYXRmb3JtcyB0aGF0IGRv
ZXMgbm90IGhhdmUgInBvc3RlZCBpbnRlcnJ1cHRzIi4NCg0KPiANCj4gDQo+IHRoYW5rcywNCj4g
emVuZ2h1aQ0KPiANCj4gPiANCj4gPiBDb3VsZCB5b3UgZGVzY3JpYmUgaG93IG1hbnkgaW50ZXJy
dXB0IHNvdXJjZXMgZWFjaCBkZXZpY2UgaGFzPyBUaGUNCj4gPiByZWFzb24gSSdtIGFza2luZyBp
cyB0aGF0IHRoZSBjYWNoZSBzaXplIGlzIHByZXR0eSBtdWNoIGhhcmRjb2RlZCBhdA0KPiA+IHRo
ZSBtb21lbnQgKDQgZW50cmllcyBwZXIgdmNwdSksIGFuZCB0aGF0IGNvdWxkIGhhdmUgYW4gaW1w
YWN0IG9uDQo+ID4gcGVyZm9ybWFuY2UgaWYgd2Uga2VlcCBldmljdGluZyBlbnRyaWVzIGluIHRo
ZSBjYWNoZSAobm90ZSB0byBzZWxmOg0KPiA+IGFkZCBzb21lIHN0YXRpc3RpY3MgZm9yIHRoYXQp
Lg0KPiA+IA0KPiA+IEFub3RoZXIgYXJlYSB3aGVyZSB3ZSBjYW4gaW1wcm92ZSB0aGluZ3MgaXMg
dGhhdCBJIHRoaW5rIHRoZQ0KPiA+IGludmFsaWRhdGlvbiBtZWNoYW5pc20gaXMgcHJldHR5IHRy
aWdnZXIgaGFwcHkgKE1PVkkgcmVhbGx5IGRvZXNuJ3QNCj4gPiBuZWVkIHRvIGludmFsaWRhdGUg
dGhlIGNhY2hlKS4gT24gdGhlIG90aGVyIGhhbmQsIEknbSBub3Qgc3VyZSB5b3VyDQo+ID4gZ3Vl
c3QgZG9lcyB0b28gbXVjaCBvZiB0aGF0Lg0KPiA+IA0KPiA+IEZpbmFsbHksIHRoZSBzaW5nbGUg
Y2FjaGUgc3Bpbi1sb2NrIGlzIGJvdW5kIHRvIGJlIGEgYm90dGxlbmVjayBvZiBpdHMNCj4gPiBv
d24gYXQgaGlnaCBpbnRlcnJ1cHQgcmF0ZXMsIGFuZCBJIHdvbmRlciB3aGV0aGVyIHdlIHNob3Vs
ZCBtb3ZlIHRoZQ0KPiA+IHdob2xlIHRoaW5nIG92ZXIgdG8gYW4gUkNVIGZyaWVuZGx5IGRhdGEg
c3RydWN0dXJlICh0aGUgdmdpY19pcnENCj4gPiBzdHJ1Y3R1cmUgcmVhbGx5IGlzbid0IHRoYXQg
ZnJpZW5kbHkpLiBJdCdkIGJlIGdvb2QgdG8gZmluZCBvdXQgaG93DQo+ID4gY29udGVuZGVkIHRo
YXQgc3BpbmxvY2sgaXMgb24geW91ciBzeXN0ZW0uDQo+ID4gDQo+ID4gPiANCj4gPiA+IE5vdyB0
aGF0IEkgaGF2ZSB0aGUgc2V0dXAsIEkgY2FuIHJlcnVuIGV4cGVyaW1lbnRzIHZlcnkgcXVpY2ts
eSAoZ2l2ZW4gSQ0KPiA+ID4gZG9uJ3QgbG9vc2UgYWNjZXNzIHRvIHRoZSBtYWNoaW5lKSwgc28g
bGV0IG1lIGtub3cgaWYgc29tZW9uZSBuZWVkcw0KPiA+ID4gZnVydGhlciB0ZXN0cy4NCj4gPiAN
Cj4gPiBBbm90aGVyIHVzZWZ1bCBkYXRhIHBvaW50IHdvdWxkIGJlIHRoZSBkZWx0YSB3aXRoIGJh
cmUtbWV0YWw6IGhvdyBtdWNoDQo+ID4gb3ZlcmhlYWQgZG8gd2UgaGF2ZSB3aXRoIEtWTSwgd2l0
aCBhbmQgd2l0aG91dCB0aGlzIHBhdGNoIHNlcmllcy4gT2gsDQo+ID4gYW5kIGZvciBlYXNpZXIg
Y29tcGFyaXNvbiwgcGxlYXNlIHdyaXRlIGl0IGFzIGEgdGFibGUgdGhhdCB3ZSBjYW4gZHVtcA0K
PiA+IGluIHRoZSBjb3ZlciBsZXR0ZXIgd2hlbiBJIGFjdHVhbGx5IHBvc3QgdGhlIHNlcmllcyEg
Oy0pDQo+ID4gDQo+ID4gVGhhbmtzLA0KPiA+IA0KPiA+IAlNLg0KPiA+IA0KPiANCgoKCkFtYXpv
biBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJl
cmxpbgpHZXNjaGFlZnRzZnVlaHJlcjogQ2hyaXN0aWFuIFNjaGxhZWdlciwgUmFsZiBIZXJicmlj
aApVc3QtSUQ6IERFIDI4OSAyMzcgODc5CkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJs
b3R0ZW5idXJnIEhSQiAxNDkxNzMgQgoK

