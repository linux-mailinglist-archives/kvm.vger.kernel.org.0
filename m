Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5538616411B
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 11:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgBSKA7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 05:00:59 -0500
Received: from mga12.intel.com ([192.55.52.136]:21816 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbgBSKA6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 05:00:58 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 02:00:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,459,1574150400"; 
   d="scan'208";a="283068554"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Feb 2020 02:00:58 -0800
Received: from fmsmsx155.amr.corp.intel.com (10.18.116.71) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 19 Feb 2020 02:00:57 -0800
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 FMSMSX155.amr.corp.intel.com (10.18.116.71) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 19 Feb 2020 02:00:57 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.5]) by
 SHSMSX152.ccr.corp.intel.com ([169.254.6.158]) with mapi id 14.03.0439.000;
 Wed, 19 Feb 2020 18:00:55 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Chia-I Wu <olvaffe@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Gurchetan Singh <gurchetansingh@chromium.org>,
        "Gerd Hoffmann" <kraxel@redhat.com>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Subject: RE: [RFC PATCH 0/3] KVM: x86: honor guest memory type
Thread-Topic: [RFC PATCH 0/3] KVM: x86: honor guest memory type
Thread-Index: AQHV4rTrI5AbOd4/PkCv4vZnvR6EuagZISQAgAAKbYCAAMs9AIAAtW4AgAejUqA=
Date:   Wed, 19 Feb 2020 10:00:54 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D78D724@SHSMSX104.ccr.corp.intel.com>
References: <20200213213036.207625-1-olvaffe@gmail.com>
 <8fdb85ea-6441-9519-ae35-eaf91ffe8741@redhat.com>
 <CAPaKu7T8VYXTMc1_GOzJnwBaZSG214qNoqRr8c7Z4Lb3B7dtTg@mail.gmail.com>
 <b82cd76c-0690-c13b-cf2c-75d7911c5c61@redhat.com>
 <CAPaKu7TDtFwF5czdpke1v7NWKf61kw_jVp-E1qQPqs-qbZYnMw@mail.gmail.com>
In-Reply-To: <CAPaKu7TDtFwF5czdpke1v7NWKf61kw_jVp-E1qQPqs-qbZYnMw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMjdlMmMwYzAtMDE2Yi00MjMzLWJmMDgtNzM3MTQ2NTRhNmE3IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiZmI0YklaRVZUdFdFa3AzOHdMcjE2RlVZRWtFQ1VLcGlhWTA0a2hScDBtTVwvUE9adDlGZEU5d1ZZVllobEF4a2oifQ==
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

PiBGcm9tOiBDaGlhLUkgV3UNCj4gU2VudDogU2F0dXJkYXksIEZlYnJ1YXJ5IDE1LCAyMDIwIDU6
MTUgQU0NCj4gDQo+IE9uIEZyaSwgRmViIDE0LCAyMDIwIGF0IDI6MjYgQU0gUGFvbG8gQm9uemlu
aSA8cGJvbnppbmlAcmVkaGF0LmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBPbiAxMy8wMi8yMCAyMzox
OCwgQ2hpYS1JIFd1IHdyb3RlOg0KPiA+ID4NCj4gPiA+IFRoZSBidWcgeW91IG1lbnRpb25lZCB3
YXMgcHJvYmFibHkgdGhpcyBvbmUNCj4gPiA+DQo+ID4gPiAgIGh0dHBzOi8vYnVnemlsbGEua2Vy
bmVsLm9yZy9zaG93X2J1Zy5jZ2k/aWQ9MTA0MDkxDQo+ID4NCj4gPiBZZXMsIGluZGVlZC4NCj4g
Pg0KPiA+ID4gRnJvbSB3aGF0IEkgY2FuIHRlbGwsIHRoZSBjb21taXQgYWxsb3dlZCB0aGUgZ3Vl
c3RzIHRvIGNyZWF0ZSBjYWNoZWQNCj4gPiA+IG1hcHBpbmdzIHRvIE1NSU8gcmVnaW9ucyBhbmQg
Y2F1c2VkIE1DRXMuICBUaGF0IGlzIGRpZmZlcmVudCB0aGFuIHdoYXQNCj4gPiA+IEkgbmVlZCwg
d2hpY2ggaXMgdG8gYWxsb3cgZ3Vlc3RzIHRvIGNyZWF0ZSB1bmNhY2hlZCBtYXBwaW5ncyB0byBz
eXN0ZW0NCj4gPiA+IHJhbSAoaS5lLiwgIWt2bV9pc19tbWlvX3Bmbikgd2hlbiB0aGUgaG9zdCB1
c2Vyc3BhY2UgYWxzbyBoYXMNCj4gdW5jYWNoZWQNCj4gPiA+IG1hcHBpbmdzLiAgQnV0IGl0IGlz
IHRydWUgdGhhdCB0aGlzIHN0aWxsIGFsbG93cyB0aGUgdXNlcnNwYWNlICYgZ3Vlc3QNCj4gPiA+
IGtlcm5lbCB0byBjcmVhdGUgY29uZmxpY3RpbmcgbWVtb3J5IHR5cGVzLg0KPiA+DQo+ID4gUmln
aHQsIHRoZSBxdWVzdGlvbiBpcyB3aGV0aGVyIHRoZSBNQ0VzIHdlcmUgdGllZCB0byBNTUlPIHJl
Z2lvbnMNCj4gPiBzcGVjaWZpY2FsbHkgYW5kIGlmIHNvIHdoeS4NCj4gPg0KPiA+IEFuIGludGVy
ZXN0aW5nIHJlbWFyayBpcyBpbiB0aGUgZm9vdG5vdGUgb2YgdGFibGUgMTEtNyBpbiB0aGUgU0RN
Lg0KPiA+IFRoZXJlLCBmb3IgdGhlIE1UUlIgKEVQVCBmb3IgdXMpIG1lbW9yeSB0eXBlIFVDIHlv
dSBjYW4gcmVhZDoNCj4gPg0KPiA+ICAgVGhlIFVDIGF0dHJpYnV0ZSBjb21lcyBmcm9tIHRoZSBN
VFJScyBhbmQgdGhlIHByb2Nlc3NvcnMgYXJlIG5vdA0KPiA+ICAgcmVxdWlyZWQgdG8gc25vb3Ag
dGhlaXIgY2FjaGVzIHNpbmNlIHRoZSBkYXRhIGNvdWxkIG5ldmVyIGhhdmUNCj4gPiAgIGJlZW4g
Y2FjaGVkLiBUaGlzIGF0dHJpYnV0ZSBpcyBwcmVmZXJyZWQgZm9yIHBlcmZvcm1hbmNlIHJlYXNv
bnMuDQo+ID4NCj4gPiBUaGVyZSBhcmUgdHdvIHBvc3NpYmlsaXRpZXM6DQo+ID4NCj4gPiAxKSB0
aGUgZm9vdG5vdGUgZG9lc24ndCBhcHBseSB0byBVQyBtb2RlIGNvbWluZyBmcm9tIEVQVCBwYWdl
IHRhYmxlcy4NCj4gPiBUaGF0IHdvdWxkIG1ha2UgeW91ciBjaGFuZ2Ugc2FmZS4NCj4gPg0KPiA+
IDIpIHRoZSBmb290bm90ZSBhbHNvIGFwcGxpZXMgd2hlbiB0aGUgVUMgYXR0cmlidXRlIGNvbWVz
IGZyb20gdGhlIEVQVA0KPiA+IHBhZ2UgdGFibGVzIHJhdGhlciB0aGFuIHRoZSBNVFJScy4gIElu
IHRoYXQgY2FzZSwgdGhlIGhvc3Qgc2hvdWxkIHVzZQ0KPiA+IFVDIGFzIHRoZSBFUFQgcGFnZSBh
dHRyaWJ1dGUgaWYgYW5kIG9ubHkgaWYgaXQncyBjb25zaXN0ZW50IHdpdGggdGhlIGhvc3QNCj4g
PiBNVFJSczsgaXQgd291bGQgYmUgbW9yZSBvciBsZXNzIGltcG9zc2libGUgdG8gaG9ub3IgVUMg
aW4gdGhlIGd1ZXN0DQo+IE1UUlJzLg0KPiA+IEluIHRoYXQgY2FzZSwgc29tZXRoaW5nIGxpa2Ug
dGhlIHBhdGNoIGJlbG93IHdvdWxkIGJlIG5lZWRlZC4NCj4gPg0KPiA+IEl0IGlzIG5vdCBjbGVh
ciBmcm9tIHRoZSBtYW51YWwgd2h5IHRoZSBmb290bm90ZSB3b3VsZCBub3QgYXBwbHkgdG8gV0M7
DQo+IHRoYXQNCj4gPiBpcywgdGhlIG1hbnVhbCBkb2Vzbid0IHNheSBleHBsaWNpdGx5IHRoYXQg
dGhlIHByb2Nlc3NvciBkb2VzIG5vdCBkbw0KPiBzbm9vcGluZw0KPiA+IGZvciBhY2Nlc3NlcyB0
byBXQyBtZW1vcnkuICBCdXQgSSBndWVzcyB0aGF0IG11c3QgYmUgdGhlIGNhc2UsIHdoaWNoIGlz
DQo+IHdoeSBJDQo+ID4gdXNlZCBNVFJSX1RZUEVfV1JDT01CIGluIHRoZSBwYXRjaCBiZWxvdy4N
Cj4gPg0KPiA+IEVpdGhlciB3YXksIHdlIHdvdWxkIGhhdmUgYW4gZXhwbGFuYXRpb24gb2Ygd2h5
IGNyZWF0aW5nIGNhY2hlZCBtYXBwaW5nDQo+IHRvDQo+ID4gTU1JTyByZWdpb25zIHdvdWxkLCBh
bmQgd2h5IGluIHByYWN0aWNlIHdlJ3JlIG5vdCBzZWVpbmcgTUNFcyBmb3IgZ3Vlc3QNCj4gUkFN
DQo+ID4gKHRoZSBndWVzdCB3b3VsZCBoYXZlIHNldCBXQiBmb3IgdGhhdCBtZW1vcnkgaW4gaXRz
IE1UUlJzLCBub3QgVUMpLg0KPiA+DQo+ID4gT25lIHRoaW5nIHlvdSBkaWRuJ3Qgc2F5OiBob3cg
d291bGQgdXNlcnNwYWNlIHVzZSBLVk1fTUVNX0RNQT8gIE9uDQo+IHdoaWNoDQo+ID4gcmVnaW9u
cyB3b3VsZCBpdCBiZSBzZXQ/DQo+IEl0IHdpbGwgYmUgc2V0IGZvciBzaG1lbXMgdGhhdCBhcmUg
bWFwcGVkIFdDLg0KPiANCj4gR1BVL0RSTSBkcml2ZXJzIGFsbG9jYXRlIHNobWVtcyBhcyBETUEt
YWJsZSBncHUgYnVmZmVycyBhbmQgYWxsb3cgdGhlDQo+IHVzZXJzcGFjZSB0byBtYXAgdGhlbSBj
YWNoZWQgb3IgV0MgKEk5MTVfTU1BUF9XQyBvcg0KPiBBTURHUFVfR0VNX0NSRUFURV9DUFVfR1RU
X1VTV0MgZm9yIGV4YW1wbGUpLiAgV2hlbiBhIHNobWVtIGlzDQo+IG1hcHBlZA0KPiBXQyBhbmQg
aXMgbWFkZSBhdmFpbGFibGUgdG8gdGhlIGd1ZXN0LCB3ZSB3b3VsZCBsaWtlIHRoZSBhYmlsaXR5
IHRvDQo+IG1hcCB0aGUgcmVnaW9uIFdDIGluIHRoZSBndWVzdC4NCg0KQ3VyaW91cy4uLiBIb3cg
aXMgc3VjaCBzbG90IGV4cG9zZWQgdG8gdGhlIGd1ZXN0PyBBIHJlc2VydmVkIG1lbW9yeQ0KcmVn
aW9uPyBJcyBpdCBzdGF0aWMgb3IgbWlnaHQgYmUgZHluYW1pY2FsbHkgYWRkZWQ/DQoNClRoYW5r
cw0KS2V2aW4NCg==
