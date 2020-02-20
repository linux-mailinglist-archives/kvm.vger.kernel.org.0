Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80012165523
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 03:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbgBTCiI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 21:38:08 -0500
Received: from mga12.intel.com ([192.55.52.136]:54420 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727211AbgBTCiH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 21:38:07 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 18:38:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,462,1574150400"; 
   d="scan'208";a="269414196"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga002.fm.intel.com with ESMTP; 19 Feb 2020 18:38:07 -0800
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 19 Feb 2020 18:38:06 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.5]) by
 SHSMSX152.ccr.corp.intel.com ([169.254.6.158]) with mapi id 14.03.0439.000;
 Thu, 20 Feb 2020 10:38:04 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>, Chia-I Wu <olvaffe@gmail.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        "kvm list" <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Gurchetan Singh <gurchetansingh@chromium.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        ML dri-devel <dri-devel@lists.freedesktop.org>
Subject: RE: [RFC PATCH 0/3] KVM: x86: honor guest memory type
Thread-Topic: [RFC PATCH 0/3] KVM: x86: honor guest memory type
Thread-Index: AQHV4rTrI5AbOd4/PkCv4vZnvR6EuagZISQAgAAKbYCAAMs9AIAAnj+AgAAgCACAAAK0AIAAAeyAgAXrxoCAAaZGgIAAIIsAgADkwxCAABT4UA==
Date:   Thu, 20 Feb 2020 02:38:04 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D78EF58@SHSMSX104.ccr.corp.intel.com>
References: <20200213213036.207625-1-olvaffe@gmail.com>
 <8fdb85ea-6441-9519-ae35-eaf91ffe8741@redhat.com>
 <CAPaKu7T8VYXTMc1_GOzJnwBaZSG214qNoqRr8c7Z4Lb3B7dtTg@mail.gmail.com>
 <b82cd76c-0690-c13b-cf2c-75d7911c5c61@redhat.com>
 <20200214195229.GF20690@linux.intel.com>
 <CAPaKu7Q4gehyhEgG_Nw=tiZiTh+7A8-uuXq1w4he6knp6NWErQ@mail.gmail.com>
 <CALMp9eRwTxdqxAcobZ7sYbD=F8Kga=jR3kaz-OEYdA9fV0AoKQ@mail.gmail.com>
 <20200214220341.GJ20690@linux.intel.com>
 <d3a6fac6-3831-3b8e-09b6-bfff4592f235@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D78D6F4@SHSMSX104.ccr.corp.intel.com>
 <CAPaKu7RyTbuTPf0Tp=0DAD80G-RySLrON8OQsHJzhAYDh7zHuA@mail.gmail.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D78EE65@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D78EE65@SHSMSX104.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNGI4Yzk2N2ItZDY1OS00Mjk1LThmNmItZmE0NzY3YzE4ZjdjIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiT2huajlkdHd6eUd4UmFzbm5BTmZiQVwvNjBBR0VkY1dpQW1WNmpaNGlwQ2h4aFVUYzRibjBQRGhGS0ZYNEJvcEcifQ==
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBUaWFuLCBLZXZpbg0KPiBTZW50OiBUaHVyc2RheSwgRmVicnVhcnkgMjAsIDIwMjAg
MTA6MDUgQU0NCj4gDQo+ID4gRnJvbTogQ2hpYS1JIFd1IDxvbHZhZmZlQGdtYWlsLmNvbT4NCj4g
PiBTZW50OiBUaHVyc2RheSwgRmVicnVhcnkgMjAsIDIwMjAgMzozNyBBTQ0KPiA+DQo+ID4gT24g
V2VkLCBGZWIgMTksIDIwMjAgYXQgMTo1MiBBTSBUaWFuLCBLZXZpbiA8a2V2aW4udGlhbkBpbnRl
bC5jb20+IHdyb3RlOg0KPiA+ID4NCj4gPiA+ID4gRnJvbTogUGFvbG8gQm9uemluaQ0KPiA+ID4g
PiBTZW50OiBXZWRuZXNkYXksIEZlYnJ1YXJ5IDE5LCAyMDIwIDEyOjI5IEFNDQo+ID4gPiA+DQo+
ID4gPiA+IE9uIDE0LzAyLzIwIDIzOjAzLCBTZWFuIENocmlzdG9waGVyc29uIHdyb3RlOg0KPiA+
ID4gPiA+PiBPbiBGcmksIEZlYiAxNCwgMjAyMCBhdCAxOjQ3IFBNIENoaWEtSSBXdSA8b2x2YWZm
ZUBnbWFpbC5jb20+DQo+IHdyb3RlOg0KPiA+ID4gPiA+Pj4gQUZBSUNULCBpdCBpcyBjdXJyZW50
bHkgYWxsb3dlZCBvbiBBUk0gKHZlcmlmaWVkKSBhbmQgQU1EIChub3QNCj4gPiA+ID4gPj4+IHZl
cmlmaWVkLCBidXQgc3ZtX2dldF9tdF9tYXNrIHJldHVybnMgMCB3aGljaCBzdXBwb3NlZGx5IG1l
YW5zDQo+ID4gdGhlDQo+ID4gPiA+IE5QVA0KPiA+ID4gPiA+Pj4gZG9lcyBub3QgcmVzdHJpY3Qg
d2hhdCB0aGUgZ3Vlc3QgUEFUIGNhbiBkbykuICBUaGlzIGRpZmYgd291bGQgZG8gdGhlDQo+ID4g
PiA+ID4+PiB0cmljayBmb3IgSW50ZWwgd2l0aG91dCBuZWVkaW5nIGFueSB1YXBpIGNoYW5nZToN
Cj4gPiA+ID4gPj4gSSB3b3VsZCBiZSBjb25jZXJuZWQgYWJvdXQgSW50ZWwgQ1BVIGVycmF0YSBz
dWNoIGFzIFNLWDQwIGFuZA0KPiBTS1g1OS4NCj4gPiA+ID4gPiBUaGUgcGFydCBLVk0gY2FyZXMg
YWJvdXQsICNNQywgaXMgYWxyZWFkeSBhZGRyZXNzZWQgYnkgZm9yY2luZyBVQw0KPiBmb3INCj4g
PiA+ID4gTU1JTy4NCj4gPiA+ID4gPiBUaGUgZGF0YSBjb3JydXB0aW9uIGlzc3VlIGlzIG9uIHRo
ZSBndWVzdCBrZXJuZWwgdG8gY29ycmVjdGx5IHVzZSBXQw0KPiA+ID4gPiA+IGFuZC9vciBub24t
dGVtcG9yYWwgd3JpdGVzLg0KPiA+ID4gPg0KPiA+ID4gPiBXaGF0IGFib3V0IGNvaGVyZW5jeSBh
Y3Jvc3MgbGl2ZSBtaWdyYXRpb24/ICBUaGUgdXNlcnNwYWNlIHByb2Nlc3MNCj4gPiB3b3VsZA0K
PiA+ID4gPiB1c2UgY2FjaGVkIGFjY2Vzc2VzLCBhbmQgYWxzbyBhIFdCSU5WRCBjb3VsZCBwb3Rl
bnRpYWxseSBjb3JydXB0IGd1ZXN0DQo+ID4gPiA+IG1lbW9yeS4NCj4gPiA+ID4NCj4gPiA+DQo+
ID4gPiBJbiBzdWNoIGNhc2UgdGhlIHVzZXJzcGFjZSBwcm9jZXNzIHBvc3NpYmx5IHNob3VsZCBj
b25zZXJ2YXRpdmVseSB1c2UNCj4gPiA+IFVDIG1hcHBpbmcsIGFzIGlmIGZvciBNTUlPIHJlZ2lv
bnMgb24gYSBwYXNzdGhyb3VnaCBkZXZpY2UuIEhvd2V2ZXINCj4gPiA+IHRoZXJlIHJlbWFpbnMg
YSBwcm9ibGVtLiB0aGUgZGVmaW5pdGlvbiBvZiBLVk1fTUVNX0RNQSBpbXBsaWVzDQo+ID4gPiBm
YXZvcmluZyBndWVzdCBzZXR0aW5nLCB3aGljaCBjb3VsZCBiZSB3aGF0ZXZlciB0eXBlIGluIGNv
bmNlcHQuIFRoZW4NCj4gPiA+IGFzc3VtaW5nIFVDIGlzIGFsc28gcHJvYmxlbWF0aWMuIEknbSBu
b3Qgc3VyZSB3aGV0aGVyIGludmVudGluZyBhbm90aGVyDQo+ID4gPiBpbnRlcmZhY2UgdG8gcXVl
cnkgZWZmZWN0aXZlIG1lbW9yeSB0eXBlIGZyb20gS1ZNIGlzIGEgZ29vZCBpZGVhLiBUaGVyZQ0K
PiA+ID4gaXMgbm8gZ3VhcmFudGVlIHRoYXQgdGhlIGd1ZXN0IHdpbGwgdXNlIHNhbWUgdHlwZSBm
b3IgZXZlcnkgcGFnZSBpbiB0aGUNCj4gPiA+IHNhbWUgc2xvdCwgdGhlbiBzdWNoIGludGVyZmFj
ZSBtaWdodCBiZSBtZXNzeS4gQWx0ZXJuYXRpdmVseSwgbWF5YmUNCj4gPiA+IHdlIGNvdWxkIGp1
c3QgaGF2ZSBhbiBpbnRlcmZhY2UgZm9yIEtWTSB1c2Vyc3BhY2UgdG8gZm9yY2UgbWVtb3J5IHR5
cGUNCj4gPiA+IGZvciBhIGdpdmVuIHNsb3QsIGlmIGl0IGlzIG1haW5seSB1c2VkIGluIHBhcmEt
dmlydHVhbGl6ZWQgc2NlbmFyaW9zIChlLmcuDQo+ID4gPiB2aXJ0aW8tZ3B1KSB3aGVyZSB0aGUg
Z3Vlc3QgaXMgZW5saWdodGVuZWQgdG8gdXNlIGEgZm9yY2VkIHR5cGUgKGUuZy4gV0MpPw0KPiA+
IEtWTSBmb3JjaW5nIHRoZSBtZW1vcnkgdHlwZSBmb3IgYSBnaXZlbiBzbG90IHNob3VsZCB3b3Jr
IHRvby4gIEJ1dCB0aGUNCj4gPiBpZ25vcmUtZ3Vlc3QtcGF0IGJpdCBzZWVtcyB0byBiZSBJbnRl
bC1zcGVjaWZpYy4gIFdlIHdpbGwgbmVlZCB0bw0KPiA+IGRlZmluZSBob3cgdGhlIHNlY29uZC1s
ZXZlbCBwYWdlIGF0dHJpYnV0ZXMgY29tYmluZSB3aXRoIHRoZSBndWVzdA0KPiA+IHBhZ2UgYXR0
cmlidXRlcyBzb21laG93Lg0KPiANCj4gb2gsIEknbSBub3QgYXdhcmUgb2YgdGhhdCBkaWZmZXJl
bmNlLiB3aXRob3V0IGFuIGlwYXQtZXF1aXZhbGVudA0KPiBjYXBhYmlsaXR5LCBJJ20gbm90IHN1
cmUgaG93IHRvIGZvcmNpbmcgcmFuZG9tIHR5cGUgaGVyZS4gSWYgeW91IGxvb2sgYXQNCj4gdGFi
bGUgMTEtNyBpbiBJbnRlbCBTRE0sIG5vbmUgb2YgTVRSUiAoRVBUKSBtZW1vcnkgdHlwZSBjYW4g
bGVhZCB0bw0KPiBjb25zaXN0ZW50IGVmZmVjdGl2ZSB0eXBlIHdoZW4gY29tYmluaW5nIHdpdGgg
cmFuZG9tIFBBVCB2YWx1ZS4gU28NCj4gIGl0IGlzIGRlZmluaXRlbHkgYSBkZWFkIGVuZC4NCj4g
DQo+ID4NCj4gPiBLVk0gc2hvdWxkIGluIHRoZW9yeSBiZSBhYmxlIHRvIHRlbGwgdGhhdCB0aGUg
dXNlcnNwYWNlIHJlZ2lvbiBpcw0KPiA+IG1hcHBlZCB3aXRoIGEgY2VydGFpbiBtZW1vcnkgdHlw
ZSBhbmQgY2FuIGZvcmNlIHRoZSBzYW1lIG1lbW9yeSB0eXBlDQo+ID4gb250byB0aGUgZ3Vlc3Qu
ICBUaGUgdXNlcnNwYWNlIGRvZXMgbm90IG5lZWQgdG8gYmUgaW52b2x2ZWQuICBCdXQgdGhhdA0K
PiA+IHNvdW5kcyB2ZXJ5IHNsb3c/ICBUaGlzIG1heSBiZSBhIGR1bWIgcXVlc3Rpb24sIGJ1dCB3
b3VsZCBpdCBoZWxwIHRvDQo+ID4gYWRkIEtWTV9TRVRfRE1BX0JVRiBhbmQgbGV0IEtWTSBuZWdv
dGlhdGUgdGhlIG1lbW9yeSB0eXBlIHdpdGggdGhlDQo+ID4gaW4ta2VybmVsIEdQVSBkcml2ZXJz
Pw0KPiA+DQo+ID4NCj4gDQo+IEtWTV9TRVRfRE1BX0JVRiBsb29rcyBtb3JlIHJlYXNvbmFibGUu
IEJ1dCBJIGd1ZXNzIHdlIGRvbid0IG5lZWQNCj4gS1ZNIHRvIGJlIGF3YXJlIG9mIHN1Y2ggbmVn
b3RpYXRpb24uIFdlIGNhbiBjb250aW51ZSB5b3VyIG9yaWdpbmFsDQo+IHByb3Bvc2FsIHRvIGhh
dmUgS1ZNIHNpbXBseSBmYXZvciBndWVzdCBtZW1vcnkgdHlwZSAobWF5YmUgc3RpbGwgY2FsbA0K
PiBLVk1fTUVNX0RNQSkuIE9uIHRoZSBvdGhlciBoYW5kLCBRZW11IHNob3VsZCBqdXN0IG1tYXAg
b24gdGhlDQo+IGZkIGhhbmRsZSBvZiB0aGUgZG1hYnVmIHBhc3NlZCBmcm9tIHRoZSB2aXJ0aW8t
Z3B1IGRldmljZSBiYWNrZW5kLCAgZS5nLg0KPiB0byBjb25kdWN0IG1pZ3JhdGlvbi4gVGhhdCB3
YXkgdGhlIG1tYXAgcmVxdWVzdCBpcyBmaW5hbGx5IHNlcnZlZCBieQ0KPiBEUk0gYW5kIHVuZGVy
bHlpbmcgR1BVIGRyaXZlcnMsIHdpdGggcHJvcGVyIHR5cGUgZW5mb3JjZWQgYXV0b21hdGljYWxs
eS4NCj4gDQoNClRoaW5raW5nIG1vcmUgcG9zc2libHkgd2UgZG9uJ3QgbmVlZCBpbnRyb2R1Y2Ug
bmV3IGludGVyZmFjZSB0byBLVk0uDQpBcyBsb25nIGFzIFFlbXUgdXNlcyBkbWFidWYgaW50ZXJm
YWNlIHRvIG1tYXAgdGhlIHNwZWNpZmljIHJlZ2lvbiwNCktWTSBjYW4gc2ltcGx5IGNoZWNrIG1l
bW9yeSB0eXBlIGluIGhvc3QgcGFnZSB0YWJsZSBnaXZlbiBodmEgb2YgYSANCm1lbXNsb3QuIElm
IHRoZSB0eXBlIGlzIFVDIG9yIFdDLCBpdCBpbXBsaWVzIHRoYXQgdXNlcnNwYWNlIHdhbnRzIGEg
DQpub24tY29oZXJlbnQgbWFwcGluZyB3aGljaCBzaG91bGQgYmUgcmVmbGVjdGVkIGluIHRoZSBn
dWVzdCBzaWRlIHRvby4NCkluIHN1Y2ggY2FzZSwgS1ZNIGNhbiBnbyB0byBub24tY29oZW5yZW50
IERNQSBwYXRoIGFuZCBmYXZvciBndWVzdCANCm1lbW9yeSB0eXBlIGF1dG9tYXRpY2FsbHkuIA0K
DQpUaGFua3MNCktldmluDQo=
