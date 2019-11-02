Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32F7AECDA8
	for <lists+kvm@lfdr.de>; Sat,  2 Nov 2019 08:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfKBHfZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Nov 2019 03:35:25 -0400
Received: from mga04.intel.com ([192.55.52.120]:5806 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726014AbfKBHfY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Nov 2019 03:35:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Nov 2019 00:35:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,258,1569308400"; 
   d="scan'208";a="204080629"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga003.jf.intel.com with ESMTP; 02 Nov 2019 00:35:23 -0700
Received: from fmsmsx153.amr.corp.intel.com (10.18.125.6) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 2 Nov 2019 00:35:23 -0700
Received: from shsmsx108.ccr.corp.intel.com (10.239.4.97) by
 FMSMSX153.amr.corp.intel.com (10.18.125.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 2 Nov 2019 00:35:22 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.127]) by
 SHSMSX108.ccr.corp.intel.com ([169.254.8.41]) with mapi id 14.03.0439.000;
 Sat, 2 Nov 2019 15:35:21 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Wang <jasowang@redhat.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>
CC:     "tianyu.lan@intel.com" <tianyu.lan@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
Subject: RE: [RFC v2 00/22] intel_iommu: expose Shared Virtual Addressing to
 VM
Thread-Topic: [RFC v2 00/22] intel_iommu: expose Shared Virtual Addressing
 to VM
Thread-Index: AQHVimskKWib+KQlOUaXXMOVBk8bu6dql/6AgACL3iCACInPAIAAoJWAgAEjFoCAAIoK8P//f5WAgAABiYCAAg37kA==
Date:   Sat, 2 Nov 2019 07:35:19 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D5E2309@SHSMSX104.ccr.corp.intel.com>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <367adad0-eb05-c950-21d7-755fffacbed6@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D5D0619@SHSMSX104.ccr.corp.intel.com>
 <fa994379-a847-0ffe-5043-40a2aefecf43@redhat.com>
 <A2975661238FB949B60364EF0F2C25743A0EACA6@SHSMSX104.ccr.corp.intel.com>
 <960389b5-2ef4-8921-fc28-67c9a6398c43@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D5E17C7@SHSMSX104.ccr.corp.intel.com>
 <18534f1b-3488-994b-73e2-17e7d8ccb4c2@redhat.com>
 <4fae7d47-93c6-1278-b55e-ec06fa3ca7f1@redhat.com>
In-Reply-To: <4fae7d47-93c6-1278-b55e-ec06fa3ca7f1@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNTk1MDM1NTItOTQ0Yi00NGQxLTk1NWItMWY3NmRkMTQxNjVhIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiYkJLM1ZGZmxDSE9ISDZuXC9SVXFPelc4azh4UnhYU3p2NWRmcld2K1hKZkdmZkdBNlEzaXFuSEF1eXJSRHhvbjEifQ==
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBXYW5nIFttYWlsdG86amFzb3dhbmdAcmVkaGF0LmNvbV0NCj4gU2VudDog
RnJpZGF5LCBOb3ZlbWJlciAxLCAyMDE5IDQ6MTAgUE0NCj4gDQo+IA0KPiBPbiAyMDE5LzExLzEg
5LiL5Y2INDowNCwgSmFzb24gV2FuZyB3cm90ZToNCj4gPg0KPiA+IE9uIDIwMTkvMTEvMSDkuIvl
jYgzOjQ2LCBUaWFuLCBLZXZpbiB3cm90ZToNCj4gPj4+IEZyb206IEphc29uIFdhbmcgW21haWx0
bzpqYXNvd2FuZ0ByZWRoYXQuY29tXQ0KPiA+Pj4gU2VudDogRnJpZGF5LCBOb3ZlbWJlciAxLCAy
MDE5IDM6MzAgUE0NCj4gPj4+DQo+ID4+Pg0KPiA+Pj4gT24gMjAxOS8xMC8zMSDkuIvljYgxMDow
NywgTGl1LCBZaSBMIHdyb3RlOg0KPiA+Pj4+PiBGcm9tOiBKYXNvbiBXYW5nIFttYWlsdG86amFz
b3dhbmdAcmVkaGF0LmNvbV0NCj4gPj4+Pj4gU2VudDogVGh1cnNkYXksIE9jdG9iZXIgMzEsIDIw
MTkgNTozMyBBTQ0KPiA+Pj4+PiBTdWJqZWN0OiBSZTogW1JGQyB2MiAwMC8yMl0gaW50ZWxfaW9t
bXU6IGV4cG9zZSBTaGFyZWQgVmlydHVhbA0KPiA+Pj4gQWRkcmVzc2luZyB0byBWTQ0KPiA+Pj4+
Pg0KPiA+Pj4+PiBPbiAyMDE5LzEwLzI1IOS4i+WNiDY6MTIsIFRpYW4sIEtldmluIHdyb3RlOg0K
PiA+Pj4+Pj4+IEZyb206IEphc29uIFdhbmcgW21haWx0bzpqYXNvd2FuZ0ByZWRoYXQuY29tXQ0K
PiA+Pj4+Pj4+IFNlbnQ6IEZyaWRheSwgT2N0b2JlciAyNSwgMjAxOSA1OjQ5IFBNDQo+ID4+Pj4+
Pj4NCj4gPj4+Pj4+Pg0KPiA+Pj4+Pj4+IE9uIDIwMTkvMTAvMjQg5LiL5Y2IODozNCwgTGl1IFlp
IEwgd3JvdGU6DQo+ID4+Pj4+Pj4+IFNoYXJlZCB2aXJ0dWFsIGFkZHJlc3MgKFNWQSksIGEuay5h
LCBTaGFyZWQgdmlydHVhbCBtZW1vcnkNCj4gPj4+Pj4+Pj4gKFNWTSkgb24NCj4gPj4+Pj4+Pj4g
SW50ZWwgcGxhdGZvcm1zIGFsbG93IGFkZHJlc3Mgc3BhY2Ugc2hhcmluZyBiZXR3ZWVuIGRldmlj
ZSBETUENCj4gPj4+IGFuZA0KPiA+Pj4+Pj4+IGFwcGxpY2F0aW9ucy4NCj4gPj4+Pj4+Pg0KPiA+
Pj4+Pj4+DQo+ID4+Pj4+Pj4gSW50ZXJlc3RpbmcsIHNvIHRoZSBiZWxvdyBmaWd1cmUgZGVtb25z
dHJhdGVzIHRoZSBjYXNlIG9mIFZNLiBJDQo+ID4+Pj4+Pj4gd29uZGVyIGhvdyBtdWNoIGRpZmZl
cmVuY2VzIGlmIHdlIGNvbXBhcmUgaXQgd2l0aCBkb2luZyBTVk0NCj4gPj4+IGJldHdlZW4NCj4g
Pj4+Pj4+PiBkZXZpY2UgYW5kIGFuIG9yZGluYXJ5IHByb2Nlc3MgKGUuZyBkcGRrKT8NCj4gPj4+
Pj4+Pg0KPiA+Pj4+Pj4+IFRoYW5rcw0KPiA+Pj4+Pj4gT25lIGRpZmZlcmVuY2UgaXMgdGhhdCBv
cmRpbmFyeSBwcm9jZXNzIHJlcXVpcmVzIG9ubHkgc3RhZ2UtMQ0KPiA+Pj4+Pj4gdHJhbnNsYXRp
b24sIHdoaWxlIFZNIHJlcXVpcmVzIG5lc3RlZCB0cmFuc2xhdGlvbi4NCj4gPj4+Pj4gQSBzaWxs
eSBxdWVzdGlvbiwgdGhlbiBJIGJlbGlldmUgdGhlcmUncyBubyBuZWVkIGZvciBWRklPIERNQSBB
UEkNCj4gPj4+Pj4gaW4gdGhpcw0KPiA+Pj4gY2FzZSBjb25zaWRlcg0KPiA+Pj4+PiB0aGUgcGFn
ZSB0YWJsZSBpcyBzaGFyZWQgYmV0d2VlbiBNTVUgYW5kIElPTU1VPw0KPiA+Pj4+IEVjaG8gS2V2
aW4ncyByZXBseS4gV2UgdXNlIG5lc3RlZCB0cmFuc2xhdGlvbiBoZXJlLiBGb3Igc3RhZ2UtMSwN
Cj4gPj4+PiB5ZXMsIG5vDQo+ID4+PiBuZWVkIHRvIHVzZQ0KPiA+Pj4+IFZGSU8gRE1BIEFQSS4g
Rm9yIHN0YWdlLTIsIHdlIHN0aWxsIHVzZSBWRklPIERNQSBBUEkgdG8gcHJvZ3JhbSB0aGUNCj4g
Pj4+IEdQQS0+SFBBDQo+ID4+Pj4gbWFwcGluZyB0byBob3N0LiA6LSkNCj4gPj4+DQo+ID4+PiBD
b29sLCB0d28gbW9yZSBxdWVzdGlvbnM6DQo+ID4+Pg0KPiA+Pj4gLSBDYW4gRVBUIHNoYXJlcyBp
dHMgcGFnZSB0YWJsZSB3aXRoIElPTU1VIEwyPw0KPiA+PiB5ZXMsIHRoZWlyIGZvcm1hdHMgYXJl
IGNvbXBhdGlibGUuDQo+ID4+DQo+ID4+PiAtIFNpbWlsYXIgdG8gRVBULCB3aGVuIEdQQS0+SFBB
IChhY3R1YWxseSBIVkEtPkhQQSkgaXMgbW9kaWZpZWQgYnkNCj4gbW0sDQo+ID4+PiBWRklPIG5l
ZWQgdG8gdXNlIE1NVSBub3RpZmllciBkbyBtb2RpZnkgTDIgYWNjb3JkaW5nbHkgYmVzaWRlcyBE
TUENCj4gQVBJPw0KPiA+Pj4NCj4gPj4gVkZJTyBkZXZpY2VzIG5lZWQgdG8gcGluLWRvd24gZ3Vl
c3QgbWVtb3J5IHBhZ2VzIHRoYXQgYXJlIG1hcHBlZA0KPiA+PiBpbiBJT01NVS4gU28gbm90aWZp
ZXIgaXMgbm90IHJlcXVpcmVkIHNpbmNlIG1tIHdvbid0IGNoYW5nZSB0aGUNCj4gbWFwcGluZw0K
PiA+PiBmb3IgdGhvc2UgcGFnZXMuDQo+ID4NCj4gPg0KPiA+IFRoZSBHVVAgdGVuZHMgdG8gbGVh
ZCBhIGxvdCBvZiBpc3N1ZXMsIHdlIG1heSBjb25zaWRlciB0byBhbGxvdw0KPiA+IHVzZXJzcGFj
ZSB0byBjaG9vc2UgdG8gbm90IHBpbiB0aGVtIGluIHRoZSBmdXR1cmUuDQo+IA0KPiANCj4gQnR3
LCBJJ20gYXNraW5nIHNpbmNlIEkgc2VlIE1NVSBub3RpZmllciBpcyB1c2VkIGJ5IGludGVsLXN2
bS5jIHRvIGZsdXNoDQo+IElPVExCLiAoSSBkb24ndCBzZWUgYW55IHVzZXJzIGluIGtlcm5lbCBz
b3VyY2UgdGhhdCB1c2UgdGhhdCBBUEkgdGhvdWdoDQo+IGUuZyBpbnRlbF9zdm1fYmluZF9tbSgp
KS4NCj4gDQoNCmludGVsLXN2bS5jIHJlcXVpcmVzIE1NVSBub3RpZmllciB0byBpbnZhbGlkYXRl
IElPVExCIHVwb24gYW55IGNoYW5nZQ0Kb24gdGhlIENQVSBwYWdlIHRhYmxlLCB3aGVuIHRoZSBs
YXR0ZXIgaXMgc2hhcmVkIHdpdGggZGV2aWNlIGluIFNWQQ0KY2FzZS4gQnV0IGZvciBWRklPIHVz
YWdlLCB3aGljaCBpcyBiYXNlZCBvbiBzdGFnZTIsIHRoZSBtYXAvdW5tYXAgDQpyZXF1ZXN0cyBl
eHBsaWNpdGx5IGNvbWUgZnJvbSB1c2Vyc3BhY2UuIHRoZXJlIGlzIG5vIG5lZWQgdG8gc3luYyB3
aXRoDQptbS4NCg0KVGhhbmtzDQpLZXZpbg0K
