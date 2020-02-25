Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7950B16B72D
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 02:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbgBYB3O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 20:29:14 -0500
Received: from mga18.intel.com ([134.134.136.126]:28784 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728011AbgBYB3N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 20:29:13 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 17:29:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,482,1574150400"; 
   d="scan'208";a="241177888"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga006.jf.intel.com with ESMTP; 24 Feb 2020 17:29:12 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 24 Feb 2020 17:29:12 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 24 Feb 2020 17:29:11 -0800
Received: from shsmsx154.ccr.corp.intel.com (10.239.6.54) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 24 Feb 2020 17:29:11 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.5]) by
 SHSMSX154.ccr.corp.intel.com ([169.254.7.141]) with mapi id 14.03.0439.000;
 Tue, 25 Feb 2020 09:29:09 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Chia-I Wu <olvaffe@gmail.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Gurchetan Singh" <gurchetansingh@chromium.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        "ML dri-devel" <dri-devel@lists.freedesktop.org>
Subject: RE: [RFC PATCH 0/3] KVM: x86: honor guest memory type
Thread-Topic: [RFC PATCH 0/3] KVM: x86: honor guest memory type
Thread-Index: AQHV4rTrI5AbOd4/PkCv4vZnvR6EuagZISQAgAAKbYCAAMs9AIAAnj+AgAAgCACAAAK0AIAAAeyAgAXrxoCAAaZGgIAAIIsAgADkwxCAABT4UIAAx02AgACimmD//8gUAIAAAZSAgACPE8CAACuogIAAJ5gAgAWxe0A=
Date:   Tue, 25 Feb 2020 01:29:09 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D79A7BE@SHSMSX104.ccr.corp.intel.com>
References: <d3a6fac6-3831-3b8e-09b6-bfff4592f235@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D78D6F4@SHSMSX104.ccr.corp.intel.com>
 <CAPaKu7RyTbuTPf0Tp=0DAD80G-RySLrON8OQsHJzhAYDh7zHuA@mail.gmail.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D78EE65@SHSMSX104.ccr.corp.intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D78EF58@SHSMSX104.ccr.corp.intel.com>
 <CAPaKu7RFY3nar9hmAdx6RYdZFPK3Cdg1O3cS+OvsEOT=yupyrQ@mail.gmail.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D792415@SHSMSX104.ccr.corp.intel.com>
 <CAPaKu7RHu5rz1Dvkvp4SDrZ0fAYq37xwRqUsdAiOmRTOz2sFTw@mail.gmail.com>
 <CAPaKu7RaF3+amPwdVBLj6q1na7JWUYuuWDN5XPwNYFB8Hpqi+w@mail.gmail.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D79359E@SHSMSX104.ccr.corp.intel.com>
 <20200221155939.GG12665@linux.intel.com>
 <CAPaKu7Qjnur=ntTXmGn7L38UaCoNjf6avWBk7xTvO6eDkZbWFQ@mail.gmail.com>
In-Reply-To: <CAPaKu7Qjnur=ntTXmGn7L38UaCoNjf6avWBk7xTvO6eDkZbWFQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMzU3OGNhOTQtMjAzNC00YzJmLWJjMDAtM2YxZDE1ZjAwM2M1IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiUkZ0TjZUamxMcU5ENHluMlp6TUM4ZDZmK1hpQ01yN2FiVU1hNVp6M1ROZlpvaVFxZ21JUFBWK0x4UkdwbTRLOCJ9
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

PiBGcm9tOiBDaGlhLUkgV3UgPG9sdmFmZmVAZ21haWwuY29tPg0KPiBTZW50OiBTYXR1cmRheSwg
RmVicnVhcnkgMjIsIDIwMjAgMjoyMSBBTQ0KPiANCj4gT24gRnJpLCBGZWIgMjEsIDIwMjAgYXQg
Nzo1OSBBTSBTZWFuIENocmlzdG9waGVyc29uDQo+IDxzZWFuLmouY2hyaXN0b3BoZXJzb25AaW50
ZWwuY29tPiB3cm90ZToNCj4gPg0KPiA+IE9uIFRodSwgRmViIDIwLCAyMDIwIGF0IDA5OjM5OjA1
UE0gLTA4MDAsIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+ID4gPiBGcm9tOiBDaGlhLUkgV3UgPG9s
dmFmZmVAZ21haWwuY29tPg0KPiA+ID4gPiBTZW50OiBGcmlkYXksIEZlYnJ1YXJ5IDIxLCAyMDIw
IDEyOjUxIFBNDQo+ID4gPiA+IElmIHlvdSB0aGluayBpdCBpcyB0aGUgYmVzdCBmb3IgS1ZNIHRv
IGluc3BlY3QgaHZhIHRvIGRldGVybWluZSB0aGUNCj4gbWVtb3J5DQo+ID4gPiA+IHR5cGUgd2l0
aCBwYWdlIGdyYW51bGFyaXR5LCB0aGF0IGlzIHJlYXNvbmFibGUgYW5kIHNob3VsZCB3b3JrIGZv
ciB1cw0KPiB0b28uDQo+ID4gPiA+IFRoZSB1c2Vyc3BhY2UgY2FuIGRvIHNvbWV0aGluZyAoZS5n
LiwgYWRkIGEgR1BVIGRyaXZlciBkZXBlbmRlbmN5IHRvDQo+IHRoZQ0KPiA+ID4gPiBoeXBlcnZp
c29yIHN1Y2ggdGhhdCB0aGUgZG1hLWJ1ZiBpcyBpbXBvcnRlZCBhcyBhIEdQVSBtZW1vcnkgYW5k
DQo+IG1hcHBlZA0KPiA+ID4gPiB1c2luZw0KPiA+ID4gPiB2a01hcE1lbW9yeSkgb3IgSSBjYW4g
d29yayB3aXRoIGRtYS1idWYgbWFpbnRhaW5lcnMgdG8gc2VlIGlmIGRtYS0NCj4gYnVmJ3MNCj4g
PiA+ID4gc2VtYW50aWNzIGNhbiBiZSBjaGFuZ2VkLg0KPiA+ID4NCj4gPiA+IEkgdGhpbmsgeW91
IG5lZWQgY29uc2lkZXIgdGhlIGxpdmUgbWlncmF0aW9uIHJlcXVpcmVtZW50IGFzIFBhb2xvIHBv
aW50ZWQNCj4gb3V0Lg0KPiA+ID4gVGhlIG1pZ3JhdGlvbiB0aHJlYWQgbmVlZHMgdG8gcmVhZC93
cml0ZSB0aGUgcmVnaW9uLCB0aGVuIGl0IG11c3QgdXNlIHRoZQ0KPiA+ID4gc2FtZSB0eXBlIGFz
IEdQVSBwcm9jZXNzIGFuZCBndWVzdCB0byByZWFkL3dyaXRlIHRoZSByZWdpb24uIEluIHN1Y2gN
Cj4gY2FzZSwNCj4gPiA+IHRoZSBodmEgbWFwcGVkIGJ5IFFlbXUgc2hvdWxkIGhhdmUgdGhlIGRl
c2lyZWQgdHlwZSBhcyB0aGUgZ3Vlc3QuDQo+IEhvd2V2ZXIsDQo+ID4gPiBhZGRpbmcgR1BVIGRy
aXZlciBkZXBlbmRlbmN5IHRvIFFlbXUgbWlnaHQgdHJpZ2dlciBzb21lIGNvbmNlcm4uIEknbQ0K
PiBub3QNCj4gPiA+IHN1cmUgd2hldGhlciB0aGVyZSBpcyBnZW5lcmljIG1lY2hhbmlzbSB0aG91
Z2gsIHRvIHNoYXJlIGRtYWJ1ZiBmZA0KPiBiZXR3ZWVuIEdQVQ0KPiA+ID4gcHJvY2VzcyBhbmQg
UWVtdSB3aGlsZSBhbGxvd2luZyBRZW11IHRvIGZvbGxvdyB0aGUgZGVzaXJlZCB0eXBlIHcvbw0K
PiB1c2luZw0KPiA+ID4gdmtNYXBNZW1vcnkuLi4NCj4gPg0KPiA+IEFsdGVybmF0aXZlbHksIEtW
TSBjb3VsZCBtYWtlIEtWTV9NRU1fRE1BIGFuZA0KPiBLVk1fTUVNX0xPR19ESVJUWV9QQUdFUw0K
PiA+IG11dHVhbGx5IGV4Y2x1c2l2ZSwgaS5lLiBmb3JjZSBhIHRyYW5zaXRpb24gdG8gV0IgbWVt
dHlwZSBmb3IgdGhlIGd1ZXN0DQo+ID4gKHdpdGggYXBwcm9wcmlhdGUgemFwcGluZykgd2hlbiBt
aWdyYXRpb24gaXMgYWN0aXZhdGVkLiAgSSB0aGluayB0aGF0DQo+ID4gd291bGQgd29yaz8NCj4g
SG0sIHZpcnRpby1ncHUgZG9lcyBub3QgYWxsb3cgbGl2ZSBtaWdyYXRpb24gd2hlbiB0aGUgM0Qg
ZnVuY3Rpb24NCj4gKHZpcmdsPW9uKSBpcyBlbmFibGVkLiAgVGhpcyBpcyB0aGUgcmVsZXZhbnQg
Y29kZSBpbiBxZW11Og0KPiANCj4gICAgIGlmICh2aXJ0aW9fZ3B1X3ZpcmdsX2VuYWJsZWQoZy0+
Y29uZikpIHsNCj4gICAgICAgICBlcnJvcl9zZXRnKCZnLT5taWdyYXRpb25fYmxvY2tlciwgInZp
cmdsIGlzIG5vdCB5ZXQgbWlncmF0YWJsZSIpOw0KPiANCj4gQWx0aG91Z2ggd2UgKHZpcnRpby1n
cHUgYW5kIHZpcmdscmVuZGVyZXIgcHJvamVjdHMpIHBsYW4gdG8gbWFrZSBob3N0DQo+IEdQVSBi
dWZmZXJzIGF2YWlsYWJsZSB0byB0aGUgZ3Vlc3QgdmlhIG1lbXNsb3RzLCB0aG9zZSBidWZmZXJz
IHNob3VsZA0KPiBiZSBjb25zaWRlcmVkIGEgcGFydCBvZiB0aGUgIkdQVSBzdGF0ZSIuICBUaGUg
bWlncmF0aW9uIHRocmVhZCBzaG91bGQNCj4gd29yayB3aXRoIHZpcmdscmVuZGVyZXIgYW5kIGxl
dCB2aXJnbHJlbmRlcmVyIHNhdmUvcmVzdG9yZSB0aGVtLCBpZg0KPiBsaXZlIG1pZ3JhdGlvbiBp
cyB0byBiZSBzdXBwb3J0ZWQuDQoNClRoYW5rcyBmb3IgeW91ciBleHBsYW5hdGlvbi4gWW91ciBS
RkMgbWFrZXMgbW9yZSBzZW5zZSBub3cuDQoNCk9uZSByZW1haW5pbmcgb3BlbiBpcywgYWx0aG91
Z2ggZm9yIGxpdmUgbWlncmF0aW9uIHdlIGNhbiBleHBsaWNpdGx5DQpzdGF0ZSB0aGF0IG1pZ3Jh
dGlvbiB0aHJlYWQgaXRzZWxmIHNob3VsZCBub3QgYWNjZXNzIHRoZSBkbWEtYnVmDQpyZWdpb24s
IGhvdyBjYW4gd2Ugd2FybiBvdGhlciB1c2FnZXMgd2hpY2ggbWF5IHBvdGVudGlhbGx5IHNpbXBs
eQ0Kd2FsayBldmVyeSBtZW1zbG90IGFuZCBhY2Nlc3MgdGhlIGNvbnRlbnQgdGhyb3VnaCB0aGUg
bW1hcC1lZA0KdmlydHVhbCBhZGRyZXNzPyBQb3NzaWJseSB3ZSBtYXkgbmVlZCBhIGZsYWcgdG8g
aW5kaWNhdGUgYSBtZW1zbG90DQp3aGljaCBpcyBtbWFwZWQgb25seSBmb3IgS1ZNIHRvIHJldHJp
ZXZlIGl0cyBwYWdlIHRhYmxlIG1hcHBpbmcNCmJ1dCBub3QgZm9yIGRpcmVjdCBhY2Nlc3MgaW4g
UWVtdS4gDQoNCj4gDQo+IFFFTVUgZGVwZW5kcyBvbiBHUFUgZHJpdmVycyBhbHJlYWR5IHdoZW4g
Y29uZmlndXJlZCB3aXRoDQo+IC0tZW5hYmxlLXZpcmdscmVuZGVyZXIuICBUaGVyZSBpcyB2aG9z
dC11c2VyLWdwdSB0aGF0IGNhbiBtb3ZlIHRoZQ0KPiBkZXBlbmRlbmN5IHRvIGEgR1BVIHByb2Nl
c3MuICBCdXQgdGhlcmUgYXJlIHN0aWxsIGdvaW5nIHRvIGJlIGNhc2VzDQo+IChlLmcuLCBuVmlk
aWEncyBwcm9wcmlldGFyeSBkcml2ZXIgZG9lcyBub3Qgc3VwcG9ydCBkbWEtYnVmKSB3aGVyZQ0K
PiBRRU1VIGNhbm5vdCBhdm9pZCBHUFUgZHJpdmVyIGRlcGVuZGVuY3kuDQo+IA0KPiANCj4gDQo+
IA0KPiA+ID4gTm90ZSB0aGlzIGlzIG9ydGhvZ29uYWwgdG8gd2hldGhlciBpbnRyb2R1Y2luZyBh
IG5ldyB1YXBpIG9yIGltcGxpY2l0bHkNCj4gY2hlY2tpbmcNCj4gPiA+IGh2YSB0byBmYXZvciBn
dWVzdCBtZW1vcnkgdHlwZS4gSXQncyBwdXJlbHkgYWJvdXQgUWVtdSBpdHNlbGYuIElkZWFsbHkN
Cj4gYW55b25lDQo+ID4gPiB3aXRoIHRoZSBkZXNpcmUgdG8gYWNjZXNzIGEgZG1hLWJ1ZiBvYmpl
Y3Qgc2hvdWxkIGZvbGxvdyB0aGUgZXhwZWN0ZWQNCj4gc2VtYW50aWNzLg0KPiA+ID4gSXQncyBp
bnRlcmVzdGluZyB0aGF0IGRtYS1idWYgc3ViLXN5c3RlbSBkb2Vzbid0IHByb3ZpZGUgYSBjZW50
cmFsaXplZA0KPiA+ID4gc3luY2hyb25pemF0aW9uIGFib3V0IG1lbW9yeSB0eXBlIGJldHdlZW4g
bXVsdGlwbGUgbW1hcCBwYXRocy4NCg==
