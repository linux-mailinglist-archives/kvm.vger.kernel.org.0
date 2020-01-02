Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE57C12E1B8
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2020 03:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbgABCbg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jan 2020 21:31:36 -0500
Received: from mga03.intel.com ([134.134.136.65]:43271 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727509AbgABCbg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jan 2020 21:31:36 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Jan 2020 18:31:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,385,1571727600"; 
   d="scan'208";a="214027892"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga008.jf.intel.com with ESMTP; 01 Jan 2020 18:31:34 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 1 Jan 2020 18:31:34 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 1 Jan 2020 18:31:34 -0800
Received: from shsmsx107.ccr.corp.intel.com (10.239.4.96) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 1 Jan 2020 18:31:33 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.197]) by
 SHSMSX107.ccr.corp.intel.com ([169.254.9.210]) with mapi id 14.03.0439.000;
 Thu, 2 Jan 2020 10:31:32 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>, Peter Xu <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5 0/9] Use 1st-level for IOVA translation
Thread-Topic: [PATCH v5 0/9] Use 1st-level for IOVA translation
Thread-Index: AQHVui4+6HcDuwA4D0+pjZyofYKB+6fV/qOAgAC12FA=
Date:   Thu, 2 Jan 2020 02:31:32 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A16466C@SHSMSX104.ccr.corp.intel.com>
References: <20191224074502.5545-1-baolu.lu@linux.intel.com>
 <8b40dd00-3bec-1fd9-9ba7-0db9fd727e52@linux.intel.com>
In-Reply-To: <8b40dd00-3bec-1fd9-9ba7-0db9fd727e52@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMWYzNWFjNDMtMTRlYS00ZjgwLWE1ZDMtYjdhY2U4NjlmMmM5IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoicldPcldjQUpQUExcL3ZLRkczaWRlWUx5T01GUkVxWkxlY2VoRlBXUXlBY05OTktpb08xeTBieG5HTjYwOTZTQjMifQ==
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMdSBCYW9sdSBbbWFpbHRvOmJhb2x1Lmx1QGxpbnV4LmludGVsLmNvbV0NCj4gU2Vu
dDogVGh1cnNkYXksIEphbnVhcnkgMiwgMjAyMCA3OjM4IEFNDQo+IFRvOiBKb2VyZyBSb2VkZWwg
PGpvcm9AOGJ5dGVzLm9yZz47IERhdmlkIFdvb2Rob3VzZSA8ZHdtdzJAaW5mcmFkZWFkLm9yZz47
DQo+IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+IFN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggdjUgMC85XSBVc2UgMXN0LWxldmVsIGZvciBJT1ZBIHRyYW5zbGF0aW9u
DQo+IA0KPiBPbiAxMi8yNC8xOSAzOjQ0IFBNLCBMdSBCYW9sdSB3cm90ZToNCj4gPiBJbnRlbCBW
VC1kIGluIHNjYWxhYmxlIG1vZGUgc3VwcG9ydHMgdHdvIHR5cGVzIG9mIHBhZ2UgdGFibGVzIGZv
ciBETUENCj4gPiB0cmFuc2xhdGlvbjogdGhlIGZpcnN0IGxldmVsIHBhZ2UgdGFibGUgYW5kIHRo
ZSBzZWNvbmQgbGV2ZWwgcGFnZQ0KPiA+IHRhYmxlLiBUaGUgZmlyc3QgbGV2ZWwgcGFnZSB0YWJs
ZSB1c2VzIHRoZSBzYW1lIGZvcm1hdCBhcyB0aGUgQ1BVIHBhZ2UNCj4gPiB0YWJsZSwgd2hpbGUg
dGhlIHNlY29uZCBsZXZlbCBwYWdlIHRhYmxlIGtlZXBzIGNvbXBhdGlibGUgd2l0aA0KPiA+IHBy
ZXZpb3VzIGZvcm1hdHMuIFRoZSBzb2Z0d2FyZSBpcyBhYmxlIHRvIGNob29zZSBhbnkgb25lIG9m
IHRoZW0gZm9yDQo+ID4gRE1BIHJlbWFwcGluZyBhY2NvcmRpbmcgdG8gdGhlIHVzZSBjYXNlLg0K
PiA+DQo+ID4gVGhpcyBwYXRjaHNldCBhaW1zIHRvIG1vdmUgSU9WQSAoSS9PIFZpcnR1YWwgQWRk
cmVzcykgdHJhbnNsYXRpb24gdG8NCj4gPiAxc3QtbGV2ZWwgcGFnZSB0YWJsZSBpbiBzY2FsYWJs
ZSBtb2RlLiBUaGlzIHdpbGwgc2ltcGxpZnkgdklPTU1VDQo+ID4gKElPTU1VIHNpbXVsYXRlZCBi
eSBWTSBoeXBlcnZpc29yKSBkZXNpZ24gYnkgdXNpbmcgdGhlIHR3by1zdGFnZQ0KPiA+IHRyYW5z
bGF0aW9uLCBhLmsuYS4gbmVzdGVkIG1vZGUgdHJhbnNsYXRpb24uDQo+ID4NCj4gPiBBcyBJbnRl
bCBWVC1kIGFyY2hpdGVjdHVyZSBvZmZlcnMgY2FjaGluZyBtb2RlLCBndWVzdCBJT1ZBIChHSU9W
QSkNCj4gPiBzdXBwb3J0IGlzIGN1cnJlbnRseSBpbXBsZW1lbnRlZCBpbiBhIHNoYWRvdyBwYWdl
IG1hbm5lci4gVGhlIGRldmljZQ0KPiA+IHNpbXVsYXRpb24gc29mdHdhcmUsIGxpa2UgUUVNVSwg
aGFzIHRvIGZpZ3VyZSBvdXQgR0lPVkEtPkdQQSBtYXBwaW5ncw0KPiA+IGFuZCB3cml0ZSB0aGVt
IHRvIGEgc2hhZG93ZWQgcGFnZSB0YWJsZSwgd2hpY2ggd2lsbCBiZSB1c2VkIGJ5IHRoZQ0KPiA+
IHBoeXNpY2FsIElPTU1VLiBFYWNoIHRpbWUgd2hlbiBtYXBwaW5ncyBhcmUgY3JlYXRlZCBvciBk
ZXN0cm95ZWQgaW4NCj4gPiB2SU9NTVUsIHRoZSBzaW11bGF0aW9uIHNvZnR3YXJlIGhhcyB0byBp
bnRlcnZlbmUuIEhlbmNlLCB0aGUgY2hhbmdlcw0KPiA+IG9uIEdJT1ZBLT5HUEEgY291bGQgYmUg
c2hhZG93ZWQgdG8gaG9zdC4NCj4gPg0KPiA+DQo+ID4gICAgICAgLi0tLS0tLS0tLS0tLg0KPiA+
ICAgICAgIHwgIHZJT01NVSAgIHwNCj4gPiAgICAgICB8LS0tLS0tLS0tLS18ICAgICAgICAgICAg
ICAgICAuLS0tLS0tLS0tLS0tLS0tLS0tLS0uDQo+ID4gICAgICAgfCAgICAgICAgICAgfElPVExC
IGZsdXNoIHRyYXAgfCAgICAgICAgUUVNVSAgICAgICAgfA0KPiA+ICAgICAgIC4tLS0tLS0tLS0t
LS4gKG1hcC91bm1hcCkgICAgIHwtLS0tLS0tLS0tLS0tLS0tLS0tLXwNCj4gPiAgICAgICB8R0lP
VkEtPkdQQSB8LS0tLS0tLS0tLS0tLS0tLT58ICAgIC4tLS0tLS0tLS0tLS0uICB8DQo+ID4gICAg
ICAgJy0tLS0tLS0tLS0tJyAgICAgICAgICAgICAgICAgfCAgICB8IEdJT1ZBLT5IUEEgfCAgfA0K
PiA+ICAgICAgIHwgICAgICAgICAgIHwgICAgICAgICAgICAgICAgIHwgICAgJy0tLS0tLS0tLS0t
LScgIHwNCj4gPiAgICAgICAnLS0tLS0tLS0tLS0nICAgICAgICAgICAgICAgICB8ICAgICAgICAg
ICAgICAgICAgICB8DQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAg
ICAgICAgICAgICAgICAgICAgfA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICctLS0tLS0tLS0tLS0tLS0tLS0tLScNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgfA0KPiA+ICAgICAgICAgICAgICA8LS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4gICAgICAgICAgICAgIHwNCj4gPiAgICAgICAg
ICAgICAgdiBWRklPL0lPTU1VIEFQSQ0KPiA+ICAgICAgICAuLS0tLS0tLS0tLS0uDQo+ID4gICAg
ICAgIHwgIHBJT01NVSAgIHwNCj4gPiAgICAgICAgfC0tLS0tLS0tLS0tfA0KPiA+ICAgICAgICB8
ICAgICAgICAgICB8DQo+ID4gICAgICAgIC4tLS0tLS0tLS0tLS4NCj4gPiAgICAgICAgfEdJT1ZB
LT5IUEEgfA0KPiA+ICAgICAgICAnLS0tLS0tLS0tLS0nDQo+ID4gICAgICAgIHwgICAgICAgICAg
IHwNCj4gPiAgICAgICAgJy0tLS0tLS0tLS0tJw0KPiA+DQo+ID4gSW4gVlQtZCAzLjAsIHNjYWxh
YmxlIG1vZGUgaXMgaW50cm9kdWNlZCwgd2hpY2ggb2ZmZXJzIHR3by1sZXZlbA0KPiA+IHRyYW5z
bGF0aW9uIHBhZ2UgdGFibGVzIGFuZCBuZXN0ZWQgdHJhbnNsYXRpb24gbW9kZS4gUmVnYXJkcyB0
byBHSU9WQQ0KPiA+IHN1cHBvcnQsIGl0IGNhbiBiZSBzaW1wbGlmaWVkIGJ5IDEpIG1vdmluZyB0
aGUgR0lPVkEgc3VwcG9ydCBvdmVyDQo+ID4gMXN0LWxldmVsIHBhZ2UgdGFibGUgdG8gc3RvcmUg
R0lPVkEtPkdQQSBtYXBwaW5nIGluIHZJT01NVSwNCj4gPiAyKSBiaW5kaW5nIHZJT01NVSAxc3Qg
bGV2ZWwgcGFnZSB0YWJsZSB0byB0aGUgcElPTU1VLCAzKSB1c2luZyBwSU9NTVUNCj4gPiBzZWNv
bmQgbGV2ZWwgZm9yIEdQQS0+SFBBIHRyYW5zbGF0aW9uLCBhbmQgNCkgZW5hYmxlIG5lc3RlZCAo
YS5rLmEuDQo+ID4gZHVhbC1zdGFnZSkgdHJhbnNsYXRpb24gaW4gaG9zdC4gQ29tcGFyZWQgd2l0
aCBjdXJyZW50IHNoYWRvdyBHSU9WQQ0KPiA+IHN1cHBvcnQsIHRoZSBuZXcgYXBwcm9hY2ggbWFr
ZXMgdGhlIHZJT01NVSBkZXNpZ24gc2ltcGxlciBhbmQgbW9yZQ0KPiA+IGVmZmljaWVudCBhcyB3
ZSBvbmx5IG5lZWQgdG8gZmx1c2ggdGhlIHBJT01NVSBJT1RMQiBhbmQgcG9zc2libGUNCj4gPiBk
ZXZpY2UtSU9UTEIgd2hlbiBhbiBJT1ZBIG1hcHBpbmcgaW4gdklPTU1VIGlzIHRvcm4gZG93bi4N
Cj4gPg0KPiA+ICAgICAgIC4tLS0tLS0tLS0tLS4NCj4gPiAgICAgICB8ICB2SU9NTVUgICB8DQo+
ID4gICAgICAgfC0tLS0tLS0tLS0tfCAgICAgICAgICAgICAgICAgLi0tLS0tLS0tLS0tLg0KPiA+
ICAgICAgIHwgICAgICAgICAgIHxJT1RMQiBmbHVzaCB0cmFwIHwgICBRRU1VICAgIHwNCj4gPiAg
ICAgICAuLS0tLS0tLS0tLS0uICAgICh1bm1hcCkgICAgICB8LS0tLS0tLS0tLS18DQo+ID4gICAg
ICAgfEdJT1ZBLT5HUEEgfC0tLS0tLS0tLS0tLS0tLS0+fCAgICAgICAgICAgfA0KPiA+ICAgICAg
ICctLS0tLS0tLS0tLScgICAgICAgICAgICAgICAgICctLS0tLS0tLS0tLScNCj4gPiAgICAgICB8
ICAgICAgICAgICB8ICAgICAgICAgICAgICAgICAgICAgICB8DQo+ID4gICAgICAgJy0tLS0tLS0t
LS0tJyAgICAgICAgICAgICAgICAgICAgICAgfA0KPiA+ICAgICAgICAgICAgIDwtLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gPiAgICAgICAgICAgICB8ICAgICAgVkZJTy9JT01NVQ0K
PiA+ICAgICAgICAgICAgIHwgIGNhY2hlIGludmFsaWRhdGlvbiBhbmQNCj4gPiAgICAgICAgICAg
ICB8IGd1ZXN0IGdwZCBiaW5kIGludGVyZmFjZXMNCj4gPiAgICAgICAgICAgICB2DQo+ID4gICAg
ICAgLi0tLS0tLS0tLS0tLg0KPiA+ICAgICAgIHwgIHBJT01NVSAgIHwNCj4gPiAgICAgICB8LS0t
LS0tLS0tLS18DQo+ID4gICAgICAgLi0tLS0tLS0tLS0tLg0KPiA+ICAgICAgIHxHSU9WQS0+R1BB
IHw8LS0tRmlyc3QgbGV2ZWwNCj4gPiAgICAgICAnLS0tLS0tLS0tLS0nDQo+ID4gICAgICAgfCBH
UEEtPkhQQSAgfDwtLS1TY29uZCBsZXZlbA0KPiA+ICAgICAgICctLS0tLS0tLS0tLScNCj4gPiAg
ICAgICAnLS0tLS0tLS0tLS0nDQo+ID4NCj4gPiBUaGlzIHBhdGNoIGFwcGxpZXMgdGhlIGZpcnN0
IGxldmVsIHBhZ2UgdGFibGUgZm9yIElPVkEgdHJhbnNsYXRpb24NCj4gPiB1bmxlc3MgdGhlIERP
TUFJTl9BVFRSX05FU1RJTkcgZG9tYWluIGF0dHJpYnV0aW9uIGhhcyBiZWVuIHNldC4NCj4gPiBT
ZXR0aW5nIG9mIHRoaXMgYXR0cmlidXRpb24gbWVhbnMgdGhlIHNlY29uZCBsZXZlbCB3aWxsIGJl
IHVzZWQgdG8gbWFwDQo+ID4gZ1BBIChndWVzdCBwaHlzaWNhbCBhZGRyZXNzKSB0byBoUEEgKGhv
c3QgcGh5c2ljYWwgYWRkcmVzcyksIGFuZCB0aGUNCj4gPiBtYXBwaW5ncyBiZXR3ZWVuIGdWQSAo
Z3Vlc3QgdmlydHVhbCBhZGRyZXNzKSBhbmQgZ1BBIHdpbGwgYmUNCj4gPiBtYWludGFpbmVkIGJ5
IHRoZSBndWVzdCB3aXRoIHRoZSBwYWdlIHRhYmxlIGFkZHJlc3MgYmluZGluZyB0byBob3N0J3MN
Cj4gPiBmaXJzdCBsZXZlbC4NCj4gPg0KPiA+IEJhc2VkLW9uLWlkZWEtYnk6IEFzaG9rIFJhajxh
c2hvay5yYWpAaW50ZWwuY29tPg0KPiA+IEJhc2VkLW9uLWlkZWEtYnk6IEtldmluIFRpYW48a2V2
aW4udGlhbkBpbnRlbC5jb20+DQo+ID4gQmFzZWQtb24taWRlYS1ieTogTGl1IFlpIEw8eWkubC5s
aXVAaW50ZWwuY29tPg0KPiA+IEJhc2VkLW9uLWlkZWEtYnk6IEphY29iIFBhbjxqYWNvYi5qdW4u
cGFuQGxpbnV4LmludGVsLmNvbT4NCj4gPiBCYXNlZC1vbi1pZGVhLWJ5OiBTYW5qYXkgS3VtYXI8
c2FuamF5Lmsua3VtYXJAaW50ZWwuY29tPg0KPiA+IEJhc2VkLW9uLWlkZWEtYnk6IEx1IEJhb2x1
PGJhb2x1Lmx1QGxpbnV4LmludGVsLmNvbT4NCj4gDQo+IFF1ZXVlZCBhbGwgcGF0Y2hlcyBmb3Ig
djUuNi4NCg0KUmV2aWV3ZWQtYnk6IExpdSBZaSBMIDx5aS5sLmxpdUBpbnRlbC5jb20+DQoNCkFo
YSwgbG9va3MgbGlrZSBJIGZvcmdvdCB0byBnaXZlIG15IFJldmlld2VkLWJ5IGFmdGVyIG9mZmxp
bmUgcmV2aWV3Li4NClllYWgsIHRoaXMgcGF0Y2hzZXQgbG9va3MgZ29vZCB0byBtZS4NCg0KUmVn
YXJkcywNCllpIExpdQ0KDQo+IFRoYW5rcywNCj4gLWJhb2x1DQo=
