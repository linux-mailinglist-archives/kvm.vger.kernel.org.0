Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F853651DF
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 08:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbfGKGdv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 02:33:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:30319 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726997AbfGKGdu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 02:33:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jul 2019 23:33:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,476,1557212400"; 
   d="scan'208";a="167938850"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga007.fm.intel.com with ESMTP; 10 Jul 2019 23:33:50 -0700
Received: from fmsmsx123.amr.corp.intel.com (10.18.125.38) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 10 Jul 2019 23:33:49 -0700
Received: from shsmsx108.ccr.corp.intel.com (10.239.4.97) by
 fmsmsx123.amr.corp.intel.com (10.18.125.38) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 10 Jul 2019 23:33:48 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.110]) by
 SHSMSX108.ccr.corp.intel.com ([169.254.8.174]) with mapi id 14.03.0439.000;
 Thu, 11 Jul 2019 14:25:48 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Peter Xu <zhexu@redhat.com>
CC:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "tianyu.lan@intel.com" <tianyu.lan@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: RE: [RFC v1 04/18] intel_iommu: add "sm_model" option
Thread-Topic: [RFC v1 04/18] intel_iommu: add "sm_model" option
Thread-Index: AQHVM+ykW0tId7lQvkS+qMkTYXVuu6bBCoMAgAK56DCAAFabgIAA322Q
Date:   Thu, 11 Jul 2019 06:25:47 +0000
Message-ID: <A2975661238FB949B60364EF0F2C257439F2C5FD@SHSMSX104.ccr.corp.intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
 <1562324511-2910-5-git-send-email-yi.l.liu@intel.com>
 <20190709021554.GB5178@xz-x1>
 <A2975661238FB949B60364EF0F2C257439F2A6D3@SHSMSX104.ccr.corp.intel.com>
 <20190711010347.GI5178@xz-x1>
In-Reply-To: <20190711010347.GI5178@xz-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNWIwMWQwMjctOWEyYi00NWJhLWE4ZjEtZjk5ZmJmZWUwMjJlIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiaExNenhVVFNcL2p2alk1Z3Jmb053ZmFibzlnSElBdFYyS1B6REppcHRlNjVndXppSFBIWTlKU3NscmVNdTliZ00ifQ==
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQZXRlciBYdSBbbWFpbHRvOnpoZXh1QHJlZGhhdC5jb21dDQo+IFNlbnQ6IFRodXJz
ZGF5LCBKdWx5IDExLCAyMDE5IDk6MDQgQU0NCj4gVG86IExpdSwgWWkgTCA8eWkubC5saXVAaW50
ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1JGQyB2MSAwNC8xOF0gaW50ZWxfaW9tbXU6IGFkZCAi
c21fbW9kZWwiIG9wdGlvbg0KPiANCj4gT24gV2VkLCBKdWwgMTAsIDIwMTkgYXQgMTI6MTQ6NDRQ
TSArMDAwMCwgTGl1LCBZaSBMIHdyb3RlOg0KPiA+ID4gRnJvbTogUGV0ZXIgWHUgW21haWx0bzp6
aGV4dUByZWRoYXQuY29tXQ0KPiA+ID4gU2VudDogVHVlc2RheSwgSnVseSA5LCAyMDE5IDEwOjE2
IEFNDQo+ID4gPiBUbzogTGl1LCBZaSBMIDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4gPiBTdWJq
ZWN0OiBSZTogW1JGQyB2MSAwNC8xOF0gaW50ZWxfaW9tbXU6IGFkZCAic21fbW9kZWwiIG9wdGlv
bg0KPiA+ID4NCj4gPiA+IE9uIEZyaSwgSnVsIDA1LCAyMDE5IGF0IDA3OjAxOjM3UE0gKzA4MDAs
IExpdSBZaSBMIHdyb3RlOg0KPiA+ID4gPiBJbnRlbCBWVC1kIDMuMCBpbnRyb2R1Y2VzIHNjYWxh
YmxlIG1vZGUsIGFuZCBpdCBoYXMgYSBidW5jaCBvZg0KPiA+ID4gPiBjYXBhYmlsaXRpZXMgcmVs
YXRlZCB0byBzY2FsYWJsZSBtb2RlIHRyYW5zbGF0aW9uLCB0aHVzIHRoZXJlIGFyZQ0KPiA+ID4g
PiBtdWx0aXBsZSBjb21iaW5hdGlvbnMuIFdoaWxlIHRoaXMgdklPTU1VIGltcGxlbWVudGF0aW9u
IHdhbnRzDQo+ID4gPiA+IHNpbXBsaWZ5IGl0IGZvciB1c2VyIGJ5IHByb3ZpZGluZyB0eXBpY2Fs
IGNvbWJpbmF0aW9ucy4NCj4gPiA+ID4gVXNlciBjb3VsZCBjb25maWcgaXQgYnkgInNtX21vZGVs
IiBvcHRpb24uIFRoZSB1c2FnZSBpcyBhcw0KPiA+ID4gPiBiZWxvdzoNCj4gPiA+ID4NCj4gPiA+
ID4gIi1kZXZpY2UgaW50ZWwtaW9tbXUseC1zY2FsYWJsZS1tb2RlPW9uLHNtX21vZGVsPVsibGVn
YWN5Inwic2NhbGFibGUiXSINCj4gPiA+DQo+ID4gPiBJcyBpdCBhIHJlcXVpcmVtZW50IHRvIHNw
bGl0IGludG8gdHdvIHBhcmFtZXRlcnMsIGluc3RlYWQgb2YganVzdA0KPiA+ID4gZXhwb3Npbmcg
ZXZlcnl0aGluZyBhYm91dCBzY2FsYWJsZSBtb2RlIHdoZW4geC1zY2FsYWJsZS1tb2RlIGlzIHNl
dD8NCj4gPg0KPiA+IHllcywgaXQgaXMuIFNjYWxhYmxlIG1vZGUgaGFzIG11bHRpcGxlIGNhcGFi
aWxpdGllcy4gQW5kIHdlIHdhbnQgdG8NCj4gPiBzdXBwb3J0IHRoZSBtb3N0IHR5cGljYWwgY29t
YmluYXRpb25zIHRvIHNpbXBsaWZ5IHNvZnR3YXJlLiBlLmcuDQo+ID4gY3VycmVudCBzY2FsYWJs
ZSBtb2RlIHZJT01NVSBleHBvc2VzIG9ubHkgMm5kIGxldmVsIHRyYW5zbGF0aW9uIHRvDQo+ID4g
Z3Vlc3QsIGFuZCBndWVzdCBJT1ZBIHN1cHBvcnQgaXMgdmlhIHNoYWRvd2luZyBndWVzdCAybmQg
bGV2ZWwgcGFnZQ0KPiA+IHRhYmxlLiBXZSBoYXZlIHBsYW4gdG8gbW92ZSBJT1ZBIGZyb20gMm5k
IGxldmVsIHBhZ2UgdGFibGUgdG8gMXN0DQo+ID4gbGV2ZWwgcGFnZSB0YWJsZSwgdGh1cyBndWVz
dCBJT1ZBIGNhbiBiZSBzdXBwb3J0ZWQgd2l0aCBuZXN0ZWQNCj4gPiB0cmFuc2xhdGlvbi4gQW5k
IHRoaXMgYWxzbyBhZGRyZXNzZXMgdGhlIGNvLWV4aXN0ZW5jZSBpc3N1ZSBvZiBndWVzdA0KPiA+
IFNWQSBhbmQgZ3Vlc3QgSU9WQS4gU28gaW4gZnV0dXJlIHdlIHdpbGwgaGF2ZSBzY2FsYWJsZSBt
b2RlIHZJT01NVQ0KPiA+IGV4cG9zZSAxc3QgbGV2ZWwgdHJhbnNsYXRpb24gb25seS4gVG8gZGlm
ZmVyZW50aWF0ZSB0aGlzIGNvbmZpZyB3aXRoIGN1cnJlbnQgdklPTU1VLA0KPiB3ZSBuZWVkIGFu
IGV4dHJhIG9wdGlvbiB0byBjb250cm9sIGl0LiBCdXQgeWVzLCBpdCBpcyBzdGlsbCBzY2FsYWJs
ZSBtb2RlIHZJT01NVS4NCj4gPiBqdXN0IGhhcyBkaWZmZXJlbnQgY2FwYWJpbGl0eSBleHBvc2Vk
IHRvIGd1ZXN0Lg0KPiANCj4gSSBzZWUuICBUaGFua3MgZm9yIGV4cGxhaW5pbmcuDQoNCnlvdSBh
cmUgd2VsY29tZS4gOi0pDQoNCj4gDQo+ID4NCj4gPiBCVFcuIGRvIHlvdSBrbm93IGlmIEkgY2Fu
IGFkZCBzdWItb3B0aW9ucyB1bmRlciAieC1zY2FsYWJsZS1tb2RlIj8gSQ0KPiA+IHRoaW5rIHRo
YXQgbWF5IGRlbW9uc3RyYXRlIHRoZSBkZXBlbmRlbmN5IGJldHRlci4NCj4gDQo+IEknbSBub3Qg
YW4gZXhwZXJ0IG9mIHRoYXQsIGJ1dCBJIHRoaW5rIGF0IGxlYXN0IHdlIGNhbiBtYWtlIGl0IGEg
c3RyaW5nIHBhcmFtZXRlcg0KPiBkZXBlbmRzIG9uIHdoYXQgeW91IHByZWZlciwgdGhlbiB3ZSBj
YW4gZG8gIngtc2NhbGFibGUtbW9kZT1sZWdhY3l8bW9kZXJuIi4gIE9yDQo+IGtlZXAgdGhpcyB3
b3VsZCBiZSBmaW5lIHRvby4NCg0KaG1tbSwgaXQncyBhIGdvb2QgaWRlYS4gSWYgd2UgYWdyZWUg
dG8gY2hhbmdlIHgtc2NhbGFibGUtbW9kZSB0byBiZSBhIHN0cmluZw0KcGFyYW1ldGVyLiBJIHRo
aW5rIEkgY2FuIGNoYW5nZSBpdC4NCg0KPiA+DQo+ID4gPiA+DQo+ID4gPiA+ICAtICJsZWdhY3ki
OiBnaXZlcyBzdXBwb3J0IGZvciBTTCBwYWdlIHRhYmxlDQo+ID4gPiA+ICAtICJzY2FsYWJsZSI6
IGdpdmVzIHN1cHBvcnQgZm9yIEZMIHBhZ2UgdGFibGUsIHBhc2lkLCB2aXJ0dWFsDQo+ID4gPiA+
IGNvbW1hbmQNCj4gPiA+ID4gIC0gZGVmYXVsdCB0byBiZSAibGVnYWN5IiBpZiAieC1zY2FsYWJs
ZS1tb2RlPW9uIHdoaWxlIG5vIHNtX21vZGVsIGlzDQo+ID4gPiA+ICAgIGNvbmZpZ3VyZWQNCj4g
PiA+ID4NCj4gPiA+ID4gQ2M6IEtldmluIFRpYW4gPGtldmluLnRpYW5AaW50ZWwuY29tPg0KPiA+
ID4gPiBDYzogSmFjb2IgUGFuIDxqYWNvYi5qdW4ucGFuQGxpbnV4LmludGVsLmNvbT4NCj4gPiA+
ID4gQ2M6IFBldGVyIFh1IDxwZXRlcnhAcmVkaGF0LmNvbT4NCj4gPiA+ID4gQ2M6IFlpIFN1biA8
eWkueS5zdW5AbGludXguaW50ZWwuY29tPg0KPiA+ID4gPiBTaWduZWQtb2ZmLWJ5OiBMaXUgWWkg
TCA8eWkubC5saXVAaW50ZWwuY29tPg0KPiA+ID4gPiBTaWduZWQtb2ZmLWJ5OiBZaSBTdW4gPHlp
Lnkuc3VuQGxpbnV4LmludGVsLmNvbT4NCj4gPiA+ID4gLS0tDQo+ID4gPiA+ICBody9pMzg2L2lu
dGVsX2lvbW11LmMgICAgICAgICAgfCAyOCArKysrKysrKysrKysrKysrKysrKysrKysrKystDQo+
ID4gPiA+ICBody9pMzg2L2ludGVsX2lvbW11X2ludGVybmFsLmggfCAgMiArKw0KPiA+ID4gPiBp
bmNsdWRlL2h3L2kzODYvaW50ZWxfaW9tbXUuaCAgfCAgMSArDQo+ID4gPiA+ICAzIGZpbGVzIGNo
YW5nZWQsIDMwIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPiA+ID4NCj4gPiA+ID4g
ZGlmZiAtLWdpdCBhL2h3L2kzODYvaW50ZWxfaW9tbXUuYyBiL2h3L2kzODYvaW50ZWxfaW9tbXUu
YyBpbmRleA0KPiA+ID4gPiA0NGIxMjMxLi4zMTYwYTA1IDEwMDY0NA0KPiA+ID4gPiAtLS0gYS9o
dy9pMzg2L2ludGVsX2lvbW11LmMNCj4gPiA+ID4gKysrIGIvaHcvaTM4Ni9pbnRlbF9pb21tdS5j
DQo+ID4gPiA+IEBAIC0zMDE0LDYgKzMwMTQsNyBAQCBzdGF0aWMgUHJvcGVydHkgdnRkX3Byb3Bl
cnRpZXNbXSA9IHsNCj4gPiA+ID4gICAgICBERUZJTkVfUFJPUF9CT09MKCJjYWNoaW5nLW1vZGUi
LCBJbnRlbElPTU1VU3RhdGUsDQo+ID4gPiA+IGNhY2hpbmdfbW9kZSwNCj4gPiA+IEZBTFNFKSwN
Cj4gPiA+ID4gICAgICBERUZJTkVfUFJPUF9CT09MKCJ4LXNjYWxhYmxlLW1vZGUiLCBJbnRlbElP
TU1VU3RhdGUsDQo+ID4gPiA+IHNjYWxhYmxlX21vZGUsDQo+ID4gPiBGQUxTRSksDQo+ID4gPiA+
ICAgICAgREVGSU5FX1BST1BfQk9PTCgiZG1hLWRyYWluIiwgSW50ZWxJT01NVVN0YXRlLCBkbWFf
ZHJhaW4sDQo+ID4gPiA+IHRydWUpLA0KPiA+ID4gPiArICAgIERFRklORV9QUk9QX1NUUklORygi
c21fbW9kZWwiLCBJbnRlbElPTU1VU3RhdGUsIHNtX21vZGVsKSwNCj4gPiA+DQo+ID4gPiBDYW4g
ZG8gJ3MvLS9fLycgdG8gZm9sbG93IHRoZSByZXN0IGlmIHdlIG5lZWQgaXQuDQo+ID4NCj4gPiBE
byB5b3UgbWVhbiBzdWItb3B0aW9ucyBhZnRlciAieC1zY2FsYWJsZS1tb2RlIj8NCj4gDQo+IE5v
LCBJIG9ubHkgbWVhbiAic20tbW9kZWwiLiA6KQ0KDQpnb3QgaXQuIGlmIHdlIG1vZGlmeSB4LXNj
YWxhYmxlLW1vZGUgdG8gYmUgc3RyaW5nLCB0aGVuIHNtLW1vZGVsIHdvdWxkIGJlDQpyZW1vdmVk
Lg0KDQpSZWdhcmRzLA0KWWkgTGl1DQoNCj4gUmVnYXJkcywNCj4gDQo+IC0tDQo+IFBldGVyIFh1
DQo=
