Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B20A1654E3
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 03:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbgBTCNX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 21:13:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:46813 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727506AbgBTCNW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 21:13:22 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 18:13:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,462,1574150400"; 
   d="scan'208";a="259123005"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga004.fm.intel.com with ESMTP; 19 Feb 2020 18:13:21 -0800
Received: from fmsmsx162.amr.corp.intel.com (10.18.125.71) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 19 Feb 2020 18:13:21 -0800
Received: from shsmsx107.ccr.corp.intel.com (10.239.4.96) by
 fmsmsx162.amr.corp.intel.com (10.18.125.71) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 19 Feb 2020 18:13:20 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.5]) by
 SHSMSX107.ccr.corp.intel.com ([169.254.9.46]) with mapi id 14.03.0439.000;
 Thu, 20 Feb 2020 10:13:18 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Chia-I Wu <olvaffe@gmail.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Gurchetan Singh <gurchetansingh@chromium.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        "ML dri-devel" <dri-devel@lists.freedesktop.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Subject: RE: [RFC PATCH 0/3] KVM: x86: honor guest memory type
Thread-Topic: [RFC PATCH 0/3] KVM: x86: honor guest memory type
Thread-Index: AQHV4rTrI5AbOd4/PkCv4vZnvR6EuagZISQAgAAKbYCAAMs9AIAAtW4AgAejUqCAABeQAIAA+IVw
Date:   Thu, 20 Feb 2020 02:13:18 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D78EEA2@SHSMSX104.ccr.corp.intel.com>
References: <20200213213036.207625-1-olvaffe@gmail.com>
 <8fdb85ea-6441-9519-ae35-eaf91ffe8741@redhat.com>
 <CAPaKu7T8VYXTMc1_GOzJnwBaZSG214qNoqRr8c7Z4Lb3B7dtTg@mail.gmail.com>
 <b82cd76c-0690-c13b-cf2c-75d7911c5c61@redhat.com>
 <CAPaKu7TDtFwF5czdpke1v7NWKf61kw_jVp-E1qQPqs-qbZYnMw@mail.gmail.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D78D724@SHSMSX104.ccr.corp.intel.com>
 <CAPaKu7Qa6yzRxB10ufNxu+F5S3_GkwofKCm66aB9H4rdWj8fFQ@mail.gmail.com>
In-Reply-To: <CAPaKu7Qa6yzRxB10ufNxu+F5S3_GkwofKCm66aB9H4rdWj8fFQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNGQ5MWRhMzUtZWE1Yy00ZWQwLWE1ZTUtMTE0NzcyNGEyMjY1IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiNzVUQkhobFd5RUtkcDVoM0Job0syNUFCcjh6NG1FdXRpNitlT1RrK0hcLzl6XC9jXC9aYlloM2U2cng3WUZHUWVIMyJ9
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

PiBGcm9tOiBDaGlhLUkgV3UgPG9sdmFmZmVAZ21haWwuY29tPg0KPiBTZW50OiBUaHVyc2RheSwg
RmVicnVhcnkgMjAsIDIwMjAgMzoxOCBBTQ0KPiANCj4gT24gV2VkLCBGZWIgMTksIDIwMjAgYXQg
MjowMCBBTSBUaWFuLCBLZXZpbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+IHdyb3RlOg0KPiA+DQo+
ID4gPiBGcm9tOiBDaGlhLUkgV3UNCj4gPiA+IFNlbnQ6IFNhdHVyZGF5LCBGZWJydWFyeSAxNSwg
MjAyMCA1OjE1IEFNDQo+ID4gPg0KPiA+ID4gT24gRnJpLCBGZWIgMTQsIDIwMjAgYXQgMjoyNiBB
TSBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPg0KPiB3cm90ZToNCj4gPiA+ID4N
Cj4gPiA+ID4gT24gMTMvMDIvMjAgMjM6MTgsIENoaWEtSSBXdSB3cm90ZToNCj4gPiA+ID4gPg0K
PiA+ID4gPiA+IFRoZSBidWcgeW91IG1lbnRpb25lZCB3YXMgcHJvYmFibHkgdGhpcyBvbmUNCj4g
PiA+ID4gPg0KPiA+ID4gPiA+ICAgaHR0cHM6Ly9idWd6aWxsYS5rZXJuZWwub3JnL3Nob3dfYnVn
LmNnaT9pZD0xMDQwOTENCj4gPiA+ID4NCj4gPiA+ID4gWWVzLCBpbmRlZWQuDQo+ID4gPiA+DQo+
ID4gPiA+ID4gRnJvbSB3aGF0IEkgY2FuIHRlbGwsIHRoZSBjb21taXQgYWxsb3dlZCB0aGUgZ3Vl
c3RzIHRvIGNyZWF0ZSBjYWNoZWQNCj4gPiA+ID4gPiBtYXBwaW5ncyB0byBNTUlPIHJlZ2lvbnMg
YW5kIGNhdXNlZCBNQ0VzLiAgVGhhdCBpcyBkaWZmZXJlbnQgdGhhbg0KPiB3aGF0DQo+ID4gPiA+
ID4gSSBuZWVkLCB3aGljaCBpcyB0byBhbGxvdyBndWVzdHMgdG8gY3JlYXRlIHVuY2FjaGVkIG1h
cHBpbmdzIHRvDQo+IHN5c3RlbQ0KPiA+ID4gPiA+IHJhbSAoaS5lLiwgIWt2bV9pc19tbWlvX3Bm
bikgd2hlbiB0aGUgaG9zdCB1c2Vyc3BhY2UgYWxzbyBoYXMNCj4gPiA+IHVuY2FjaGVkDQo+ID4g
PiA+ID4gbWFwcGluZ3MuICBCdXQgaXQgaXMgdHJ1ZSB0aGF0IHRoaXMgc3RpbGwgYWxsb3dzIHRo
ZSB1c2Vyc3BhY2UgJiBndWVzdA0KPiA+ID4gPiA+IGtlcm5lbCB0byBjcmVhdGUgY29uZmxpY3Rp
bmcgbWVtb3J5IHR5cGVzLg0KPiA+ID4gPg0KPiA+ID4gPiBSaWdodCwgdGhlIHF1ZXN0aW9uIGlz
IHdoZXRoZXIgdGhlIE1DRXMgd2VyZSB0aWVkIHRvIE1NSU8gcmVnaW9ucw0KPiA+ID4gPiBzcGVj
aWZpY2FsbHkgYW5kIGlmIHNvIHdoeS4NCj4gPiA+ID4NCj4gPiA+ID4gQW4gaW50ZXJlc3Rpbmcg
cmVtYXJrIGlzIGluIHRoZSBmb290bm90ZSBvZiB0YWJsZSAxMS03IGluIHRoZSBTRE0uDQo+ID4g
PiA+IFRoZXJlLCBmb3IgdGhlIE1UUlIgKEVQVCBmb3IgdXMpIG1lbW9yeSB0eXBlIFVDIHlvdSBj
YW4gcmVhZDoNCj4gPiA+ID4NCj4gPiA+ID4gICBUaGUgVUMgYXR0cmlidXRlIGNvbWVzIGZyb20g
dGhlIE1UUlJzIGFuZCB0aGUgcHJvY2Vzc29ycyBhcmUgbm90DQo+ID4gPiA+ICAgcmVxdWlyZWQg
dG8gc25vb3AgdGhlaXIgY2FjaGVzIHNpbmNlIHRoZSBkYXRhIGNvdWxkIG5ldmVyIGhhdmUNCj4g
PiA+ID4gICBiZWVuIGNhY2hlZC4gVGhpcyBhdHRyaWJ1dGUgaXMgcHJlZmVycmVkIGZvciBwZXJm
b3JtYW5jZSByZWFzb25zLg0KPiA+ID4gPg0KPiA+ID4gPiBUaGVyZSBhcmUgdHdvIHBvc3NpYmls
aXRpZXM6DQo+ID4gPiA+DQo+ID4gPiA+IDEpIHRoZSBmb290bm90ZSBkb2Vzbid0IGFwcGx5IHRv
IFVDIG1vZGUgY29taW5nIGZyb20gRVBUIHBhZ2UgdGFibGVzLg0KPiA+ID4gPiBUaGF0IHdvdWxk
IG1ha2UgeW91ciBjaGFuZ2Ugc2FmZS4NCj4gPiA+ID4NCj4gPiA+ID4gMikgdGhlIGZvb3Rub3Rl
IGFsc28gYXBwbGllcyB3aGVuIHRoZSBVQyBhdHRyaWJ1dGUgY29tZXMgZnJvbSB0aGUgRVBUDQo+
ID4gPiA+IHBhZ2UgdGFibGVzIHJhdGhlciB0aGFuIHRoZSBNVFJScy4gIEluIHRoYXQgY2FzZSwg
dGhlIGhvc3Qgc2hvdWxkIHVzZQ0KPiA+ID4gPiBVQyBhcyB0aGUgRVBUIHBhZ2UgYXR0cmlidXRl
IGlmIGFuZCBvbmx5IGlmIGl0J3MgY29uc2lzdGVudCB3aXRoIHRoZSBob3N0DQo+ID4gPiA+IE1U
UlJzOyBpdCB3b3VsZCBiZSBtb3JlIG9yIGxlc3MgaW1wb3NzaWJsZSB0byBob25vciBVQyBpbiB0
aGUgZ3Vlc3QNCj4gPiA+IE1UUlJzLg0KPiA+ID4gPiBJbiB0aGF0IGNhc2UsIHNvbWV0aGluZyBs
aWtlIHRoZSBwYXRjaCBiZWxvdyB3b3VsZCBiZSBuZWVkZWQuDQo+ID4gPiA+DQo+ID4gPiA+IEl0
IGlzIG5vdCBjbGVhciBmcm9tIHRoZSBtYW51YWwgd2h5IHRoZSBmb290bm90ZSB3b3VsZCBub3Qg
YXBwbHkgdG8gV0M7DQo+ID4gPiB0aGF0DQo+ID4gPiA+IGlzLCB0aGUgbWFudWFsIGRvZXNuJ3Qg
c2F5IGV4cGxpY2l0bHkgdGhhdCB0aGUgcHJvY2Vzc29yIGRvZXMgbm90IGRvDQo+ID4gPiBzbm9v
cGluZw0KPiA+ID4gPiBmb3IgYWNjZXNzZXMgdG8gV0MgbWVtb3J5LiAgQnV0IEkgZ3Vlc3MgdGhh
dCBtdXN0IGJlIHRoZSBjYXNlLCB3aGljaCBpcw0KPiA+ID4gd2h5IEkNCj4gPiA+ID4gdXNlZCBN
VFJSX1RZUEVfV1JDT01CIGluIHRoZSBwYXRjaCBiZWxvdy4NCj4gPiA+ID4NCj4gPiA+ID4gRWl0
aGVyIHdheSwgd2Ugd291bGQgaGF2ZSBhbiBleHBsYW5hdGlvbiBvZiB3aHkgY3JlYXRpbmcgY2Fj
aGVkDQo+IG1hcHBpbmcNCj4gPiA+IHRvDQo+ID4gPiA+IE1NSU8gcmVnaW9ucyB3b3VsZCwgYW5k
IHdoeSBpbiBwcmFjdGljZSB3ZSdyZSBub3Qgc2VlaW5nIE1DRXMgZm9yDQo+IGd1ZXN0DQo+ID4g
PiBSQU0NCj4gPiA+ID4gKHRoZSBndWVzdCB3b3VsZCBoYXZlIHNldCBXQiBmb3IgdGhhdCBtZW1v
cnkgaW4gaXRzIE1UUlJzLCBub3QgVUMpLg0KPiA+ID4gPg0KPiA+ID4gPiBPbmUgdGhpbmcgeW91
IGRpZG4ndCBzYXk6IGhvdyB3b3VsZCB1c2Vyc3BhY2UgdXNlIEtWTV9NRU1fRE1BPw0KPiBPbg0K
PiA+ID4gd2hpY2gNCj4gPiA+ID4gcmVnaW9ucyB3b3VsZCBpdCBiZSBzZXQ/DQo+ID4gPiBJdCB3
aWxsIGJlIHNldCBmb3Igc2htZW1zIHRoYXQgYXJlIG1hcHBlZCBXQy4NCj4gPiA+DQo+ID4gPiBH
UFUvRFJNIGRyaXZlcnMgYWxsb2NhdGUgc2htZW1zIGFzIERNQS1hYmxlIGdwdSBidWZmZXJzIGFu
ZCBhbGxvdw0KPiB0aGUNCj4gPiA+IHVzZXJzcGFjZSB0byBtYXAgdGhlbSBjYWNoZWQgb3IgV0Mg
KEk5MTVfTU1BUF9XQyBvcg0KPiA+ID4gQU1ER1BVX0dFTV9DUkVBVEVfQ1BVX0dUVF9VU1dDIGZv
ciBleGFtcGxlKS4gIFdoZW4gYSBzaG1lbQ0KPiBpcw0KPiA+ID4gbWFwcGVkDQo+ID4gPiBXQyBh
bmQgaXMgbWFkZSBhdmFpbGFibGUgdG8gdGhlIGd1ZXN0LCB3ZSB3b3VsZCBsaWtlIHRoZSBhYmls
aXR5IHRvDQo+ID4gPiBtYXAgdGhlIHJlZ2lvbiBXQyBpbiB0aGUgZ3Vlc3QuDQo+ID4NCj4gPiBD
dXJpb3VzLi4uIEhvdyBpcyBzdWNoIHNsb3QgZXhwb3NlZCB0byB0aGUgZ3Vlc3Q/IEEgcmVzZXJ2
ZWQgbWVtb3J5DQo+ID4gcmVnaW9uPyBJcyBpdCBzdGF0aWMgb3IgbWlnaHQgYmUgZHluYW1pY2Fs
bHkgYWRkZWQ/DQo+IFRoZSBwbGFuIGlzIGZvciB2aXJ0aW8tZ3B1IGRldmljZSB0byByZXNlcnZl
IGEgaHVnZSBtZW1vcnkgcmVnaW9uIGluDQo+IHRoZSBndWVzdC4gIE1lbXNsb3RzIG1heSBiZSBh
ZGRlZCBkeW5hbWljYWxseSBvciBzdGF0aWNhbGx5IHRvIGJhY2sNCj4gdGhlIHJlZ2lvbi4NCg0K
c28gdGhlIHJlZ2lvbiBpcyBtYXJrZWQgYXMgRTgyMF9SRVNFUlZFRCB0byBwcmV2ZW50IGd1ZXN0
IGtlcm5lbCANCmZyb20gdXNpbmcgaXQgZm9yIG90aGVyIHB1cnBvc2UgYW5kIHRoZW4gdmlydGlv
LWdwdSBkZXZpY2Ugd2lsbCByZXBvcnQNCnZpcnRpby1ncHUgZHJpdmVyIG9mIHRoZSBleGFjdCBs
b2NhdGlvbiBvZiB0aGUgcmVnaW9uIHRocm91Z2ggaXRzIG93bg0KaW50ZXJmYWNlPw0KDQo+IA0K
PiBEeW5hbWljOiB0aGUgaG9zdCBhZGRzIGEgMTZNQiBHUFUgYWxsb2NhdGlvbiBhcyBhIG1lbXNs
b3QgYXQgYSB0aW1lLg0KPiBUaGUgZ3Vlc3Qga2VybmVsIHN1YmFsbG9jYXRlcyBmcm9tIHRoZSAx
Nk1CIHBvb2wuDQo+IA0KPiBTdGF0aWM6IHRoZSBob3N0IGNyZWF0ZXMgYSBodWdlIFBST1RfTk9O
RSBtZW1mZCBhbmQgYWRkcyBpdCBhcyBhDQo+IG1lbXNsb3QuICBHUFUgYWxsb2NhdGlvbnMgYXJl
IG1yZW1hcCgpZWQgaW50byB0aGUgbWVtZmQgcmVnaW9uIHRvDQo+IHByb3ZpZGUgdGhlIHJlYWwg
bWFwcGluZy4NCj4gDQo+IFRoZXNlIG9wdGlvbnMgYXJlIGNvbnNpZGVyZWQgYmVjYXVzZSB0aGUg
bnVtYmVyIG9mIG1lbXNsb3RzIGFyZQ0KPiBsaW1pdGVkOiAzMiBvbiBBUk0gYW5kIDUwOSBvbiB4
ODYuICBJZiB0aGUgbnVtYmVyIG9mIG1lbXNsb3RzIGNvdWxkIGJlDQo+IG1hZGUgbGFyZ2VyICg0
MDk2IG9yIG1vcmUpLCB3ZSB3b3VsZCBhbHNvIGNvbnNpZGVyIGFkZGluZyBlYWNoDQo+IGluZGl2
aWR1YWwgR1BVIGFsbG9jYXRpb24gYXMgYSBtZW1zbG90Lg0KPiANCj4gVGhlc2UgYXJlIGFjdHVh
bGx5IHF1ZXN0aW9ucyB3ZSBuZWVkIGZlZWRiYWNrLiAgQmVzaWRlcywgR1BVDQo+IGFsbG9jYXRp
b25zIGNhbiBiZSBhc3N1bWVkIHRvIGJlIGtlcm5lbCBkbWEtYnVmcyBpbiB0aGlzIGNvbnRleHQu
ICBJDQo+IHdvbmRlciBpZiBpdCBtYWtlcyBzZW5zZSB0byBoYXZlIGEgdmFyaWF0aW9uIG9mDQo+
IEtWTV9TRVRfVVNFUl9NRU1PUllfUkVHSU9OIHRoYXQgdGFrZXMgZG1hLWJ1ZnMuDQoNCkkgZmVl
bCBpdCBtYWtlcyBtb3JlIHNlbnNlLg0KDQpUaGFua3MNCktldmluDQo=
