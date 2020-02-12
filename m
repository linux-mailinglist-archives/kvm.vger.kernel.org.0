Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4B1F15A18F
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 08:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbgBLHPX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 02:15:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:44643 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728148AbgBLHPX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 02:15:23 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Feb 2020 23:15:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,428,1574150400"; 
   d="scan'208";a="347463606"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga001.fm.intel.com with ESMTP; 11 Feb 2020 23:15:22 -0800
Received: from fmsmsx112.amr.corp.intel.com (10.18.116.6) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 11 Feb 2020 23:15:22 -0800
Received: from shsmsx105.ccr.corp.intel.com (10.239.4.158) by
 FMSMSX112.amr.corp.intel.com (10.18.116.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 11 Feb 2020 23:15:21 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.5]) by
 SHSMSX105.ccr.corp.intel.com ([169.254.11.138]) with mapi id 14.03.0439.000;
 Wed, 12 Feb 2020 15:15:14 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Peter Xu <peterx@redhat.com>
CC:     David Gibson <david@gibson.dropbear.id.au>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "Yi Sun" <yi.y.sun@linux.intel.com>
Subject: RE: [RFC v3 03/25] hw/iommu: introduce IOMMUContext
Thread-Topic: [RFC v3 03/25] hw/iommu: introduce IOMMUContext
Thread-Index: AQHV1p1ISlCEZJtKwkqCei/mecuDIagDpFsAgADzWWCAES39gIABZmlA
Date:   Wed, 12 Feb 2020 07:15:13 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A1BA4D8@SHSMSX104.ccr.corp.intel.com>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
 <1580300216-86172-4-git-send-email-yi.l.liu@intel.com>
 <20200131040644.GG15210@umbus.fritz.box>
 <A2975661238FB949B60364EF0F2C25743A199306@SHSMSX104.ccr.corp.intel.com>
 <20200211165843.GG984290@xz-x1>
In-Reply-To: <20200211165843.GG984290@xz-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMzhjOWE0OTEtM2I3My00YTljLTljYzMtYzM4MTc1M2M0N2ZjIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiWlwvOGdpMFZPUWNjU3lvZTF6T05YeTVjUjdKKzBQZnNLcEJtcjIza1o3UVdZRUVkKzhDTVNRTWZPc1pyQmRBczIifQ==
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgUGV0ZXIsDQoNCj4gRnJvbTogUGV0ZXIgWHUgPHBldGVyeEByZWRoYXQuY29tPg0KPiBTZW50
OiBXZWRuZXNkYXksIEZlYnJ1YXJ5IDEyLCAyMDIwIDEyOjU5IEFNDQo+IFRvOiBMaXUsIFlpIEwg
PHlpLmwubGl1QGludGVsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtSRkMgdjMgMDMvMjVdIGh3L2lv
bW11OiBpbnRyb2R1Y2UgSU9NTVVDb250ZXh0DQo+IA0KPiBPbiBGcmksIEphbiAzMSwgMjAyMCBh
dCAxMTo0MjoxM0FNICswMDAwLCBMaXUsIFlpIEwgd3JvdGU6DQo+ID4gPiBJJ20gbm90IHZlcnkg
Y2xlYXIgb24gdGhlIHJlbGF0aW9uc2hpcCBiZXR3ZW4gYW4gSU9NTVVDb250ZXh0IGFuZCBhDQo+
ID4gPiBEdWFsU3RhZ2VJT01NVU9iamVjdC4gIENhbiB0aGVyZSBiZSBtYW55IElPTU1VQ29udGV4
dHMgdG8gYQ0KPiA+ID4gRHVhbFN0YWdlSU9NTVVPQmplY3Q/ICBUaGUgb3RoZXIgd2F5IGFyb3Vu
ZD8gIE9yIGlzIGl0IGp1c3QNCj4gPiA+IHplcm8tb3Itb25lIER1YWxTdGFnZUlPTU1VT2JqZWN0
cyB0byBhbiBJT01NVUNvbnRleHQ/DQo+ID4NCj4gPiBJdCBpcyBwb3NzaWJsZS4gQXMgdGhlIGJl
bG93IHBhdGNoIHNob3dzLCBEdWFsU3RhZ2VJT01NVU9iamVjdCBpcyBwZXIgdmZpbw0KPiA+IGNv
bnRhaW5lci4gSU9NTVVDb250ZXh0IGNhbiBiZSBlaXRoZXIgcGVyLWRldmljZSBvciBzaGFyZWQg
YWNyb3NzIGRldmljZXMsDQo+ID4gaXQgZGVwZW5kcyBvbiB2ZW5kb3Igc3BlY2lmaWMgdklPTU1V
IGVtdWxhdG9ycy4NCj4gDQo+IElzIHRoZXJlIGFuIGV4YW1wbGUgd2hlbiBhbiBJT01NVUNvbnRl
eHQgY2FuIGJlIG5vdCBwZXItZGV2aWNlPw0KDQpObywgSSBkb27igJl0IGhhdmUgc3VjaCBleGFt
cGxlIHNvIGZhci4gQnV0IGFzIElPTU1VQ29udGV4dCBpcyBnb3QgZnJvbQ0KcGNpX2RldmljZV9p
b21tdV9jb250ZXh0KCksICBpbiBjb25jZXB0IGl0IHBvc3NpYmxlIHRvIGJlIG5vdCBwZXItZGV2
aWNlLg0KSXQgaXMga2luZCBvZiBsZWF2ZSB0byB2SU9NTVUgdG8gZGVjaWRlIGlmIGRpZmZlcmVu
dCBkZXZpY2VzIGNvdWxkIHNoYXJlIGENCnNpbmdsZSBJT01NVUNvbnRleHQuDQoNCj4gSXQgbWFr
ZXMgc2Vuc2UgdG8gbWUgdG8gaGF2ZSBhbiBvYmplY3QgdGhhdCBpcyBwZXItY29udGFpbmVyIChp
biB5b3VyDQo+IGNhc2UsIHRoZSBEdWFsU3RhZ2VJT01NVU9iamVjdCwgSUlVQyksIHRoZW4gd2Ug
Y2FuIGNvbm5lY3QgdGhhdCBvYmplY3QNCj4gdG8gYSBkZXZpY2UuICBIb3dldmVyIEknbSBhIGJp
dCBjb25mdXNlZCBvbiB3aHkgd2UndmUgZ290IHR3byBhYnN0cmFjdA0KPiBsYXllcnMgKHRoZSBv
dGhlciBvbmUgaXMgSU9NTVVDb250ZXh0KT8gIFRoYXQgd2FzIHByZXZpb3VzbHkgZm9yIHRoZQ0K
PiB3aG9sZSBTVkEgbmV3IEFQSXMsIG5vdyBpdCdzIGFsbCBtb3ZlZCBvdmVyIHRvIHRoZSBvdGhl
ciBuZXcgb2JqZWN0LA0KPiB0aGVuIElPTU1VQ29udGV4dCBvbmx5IHJlZ2lzdGVyL3VucmVnaXN0
ZXIuLi4NCg0KWW91ciB1bmRlcnN0YW5kaW5nIGlzIGNvcnJlY3QuIEFjdHVhbGx5LCBJIGFsc28g
c3RydWdnbGVkIG9uIGFkZGluZyB0d28NCmFic3RyYWN0IGxheWVyLiBCdXQsIHlvdSBrbm93LCB0
aGVyZSBhcmUgdHdvIGZ1bmN0aW9uIGNhbGxpbmcgcmVxdWlyZW1lbnRzDQphcm91bmQgdlNWQSBl
bmFibGluZy4gRmlyc3Qgb25lIGlzIGV4cGxpY2l0IG1ldGhvZCBmb3IgdklPTU1VIGNhbGxzIGlu
dG8NClZGSU8gKHBhc2lkIGFsbG9jYXRpb24sIGJpbmQgZ3Vlc3QgcGFnZSB0YWJsZSwgY2FjaGUg
aW52YWxpZGF0ZSkuIFNlY29uZA0Kb25lIGlzIGV4cGxpY2l0IG1ldGhvZCBmb3IgVkZJTyBjYWxs
cyBpbnRvIHZJT01NVSAoRE1BIGZhdWx0L1BSUSBpbmplY3Rpb24NCndoaWNoIGlzIG5vdCBpbmNs
dWRlZCBpbiB0aGlzIHNlcmllcyB5ZXQsIGJ1dCB3aWxsIGJlIHVwc3RyZWFtZWQgbGF0ZXIpLiAN
ClNvIEkgYWRkZWQgdGhlIER1YWxTdGFnZUlPTU1VT2JqZWN0IHRvIGNvdmVyIHZJT01NVSB0byBW
RklPIGNhbGxpbmdzLCBhbmQNCklPTU1VQ29udGV4dCB0byBjb3ZlciBWRklPIHRvIHZJT01NVSBj
YWxsaW5ncy4gQXMgSU9NTVVDb250ZXh0IGNvdmVycyBWRklPDQp0byB2SU9NTVUgY2FsbGluZ3Ms
IHNvIEkgbWFkZSBpdCBpbmNsdWRlIHJlZ2lzdGVyL3VucmVnaXN0ZXIuDQoNCj4gQ2FuIHdlIHB1
dCB0aGUgcmVnL3VucmVnDQo+IHByb2NlZHVyZXMgaW50byBEdWFsU3RhZ2VJT01NVU9iamVjdCBh
cyB3ZWxsPyAgVGhlbiB3ZSBkcm9wIHRoZQ0KPiBJT01NVUNvbnRleHQgKG9yIHNheSwga2VlcCBJ
T01NVUNvbnRleHQgYW5kIGRyb3AgRHVhbFN0YWdlSU9NTVVPYmplY3QNCj4gYnV0IGxldCBJT01N
VUNvbnRleHQgdG8gYmUgcGVyLXZmaW8tY29udGFpbmVyLCB0aGUgbWFqb3IgZGlmZmVyZW5jZSBp
cw0KPiB0aGUgbmFtaW5nIGhlcmUsIHNheSwgUEFTSUQgYWxsb2NhdGlvbiBkb2VzIG5vdCBzZWVt
IHRvIGJlIHJlbGF0ZWQgdG8NCj4gZHVhbC1zdGFnZSBhdCBhbGwpLg0KPg0KPiBCZXNpZGVzIHRo
YXQsIG5vdCBzdXJlIEkgcmVhZCBpdCByaWdodC4uLiBidXQgZXZlbiB3aXRoIHlvdXIgY3VycmVu
dA0KPiBzZXJpZXMsIHRoZSBjb250YWluZXItPmlvbW11X2N0eCB3aWxsIGFsd2F5cyBvbmx5IGJl
IGJvdW5kIHRvIHRoZQ0KPiBmaXJzdCBkZXZpY2UgY3JlYXRlZCB3aXRoaW4gdGhhdCBjb250YWlu
ZXIsIHNpbmNlIHlvdSd2ZSBnb3Q6DQo+IA0KPiAgICAgZ3JvdXAgPSB2ZmlvX2dldF9ncm91cChn
cm91cGlkLCBwY2lfZGV2aWNlX2lvbW11X2FkZHJlc3Nfc3BhY2UocGRldiksDQo+ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHBjaV9kZXZpY2VfaW9tbXVfY29udGV4dChwZGV2KSwgZXJycCk7
DQo+IA0KPiBBbmQ6DQo+IA0KPiAgICAgaWYgKHZmaW9fY29ubmVjdF9jb250YWluZXIoZ3JvdXAs
IGFzLCBpb21tdV9jdHgsIGVycnApKSB7DQo+ICAgICAgICAgZXJyb3JfcHJlcGVuZChlcnJwLCAi
ZmFpbGVkIHRvIHNldHVwIGNvbnRhaW5lciBmb3IgZ3JvdXAgJWQ6ICIsDQo+ICAgICAgICAgICAg
ICAgICAgICAgICBncm91cGlkKTsNCj4gICAgICAgICBnb3RvIGNsb3NlX2ZkX2V4aXQ7DQo+ICAg
ICB9DQo+IA0KPiBUaGUgaW9tbXVfY3R4IHdpbGwgYmUgc2V0IHRvIGNvbnRhaW5lci0+aW9tbXVf
Y3R4IGlmIHRoZXJlJ3Mgbm8NCj4gZXhpc3RpbmcgY29udGFpbmVyLg0KDQp5ZXMsIGl0J3MgdHJ1
ZS4gTWF5IG5lZWQgdG8gYWRkIGEgaW9tbXVfY3R4IGxpc3QgaW4gVkZJTyBjb250YWluZXIgb3IN
CmFkZCBjaGVjayBvbiB0aGUgaW5wdXQgaW9tbXVfY3R4IG9mIHZmaW9fZ2V0X2dyb3VwKCkgaWYg
c3RpY2tpbmcgb24gdGhpcw0KZGlyZWN0aW9uLg0KDQpXaGlsZSBjb25zaWRlcmluZyB5b3VyIHN1
Z2dlc3Rpb24gb24gZHJvcHBpbmcgb25lIG9mIHRoZSB0d28gYWJzdHJhY3QNCmxheWVycy4gSSBj
YW1lIHVwIGEgbmV3IHByb3Bvc2FsIGFzIGJlbG93Og0KDQpXZSBtYXkgZHJvcCB0aGUgSU9NTVVD
b250ZXh0IGluIHRoaXMgc2VyaWVzLCBhbmQgcmVuYW1lIER1YWxTdGFnZUlPTU1VT2JqZWN0DQp0
byBIb3N0SU9NTVVDb250ZXh0LCB3aGljaCBpcyBwZXItdmZpby1jb250YWluZXIuIEFkZCBhbiBp
bnRlcmZhY2UgaW4gUENJDQpsYXllcihlLmcuIGFuIGNhbGxiYWNrIGluICBQQ0lEZXZpY2UpIHRv
IGxldCB2SU9NTVUgZ2V0IEhvc3RJT01NVUNvbnRleHQuDQpJIHRoaW5rIHRoaXMgY291bGQgY292
ZXIgdGhlIHJlcXVpcmVtZW50IG9mIHByb3ZpZGluZyBleHBsaWNpdCBtZXRob2QgZm9yDQp2SU9N
TVUgdG8gY2FsbCBpbnRvIFZGSU8gYW5kIHRoZW4gcHJvZ3JhbSBob3N0IElPTU1VLg0KDQpXaGls
ZSBmb3IgdGhlIHJlcXVpcmVtZW50IG9mIFZGSU8gdG8gdklPTU1VIGNhbGxpbmdzIChlLmcuIFBS
USksIEkgdGhpbmsgaXQNCmNvdWxkIGJlIGRvbmUgdmlhIFBDSSBsYXllciBieSBhZGRpbmcgYW4g
b3BlcmF0aW9uIGluIFBDSUlPTU1VT3BzLiBUaG91Z2h0cz8NCg0KVGhhbmtzLA0KWWkgTGl1DQoN
Cg==
