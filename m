Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD9126459C
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 13:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfGJLIS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 07:08:18 -0400
Received: from mga04.intel.com ([192.55.52.120]:35357 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbfGJLIS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 07:08:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jul 2019 04:08:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,474,1557212400"; 
   d="scan'208";a="364444601"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga005.fm.intel.com with ESMTP; 10 Jul 2019 04:08:17 -0700
Received: from fmsmsx113.amr.corp.intel.com (10.18.116.7) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 10 Jul 2019 04:08:17 -0700
Received: from shsmsx101.ccr.corp.intel.com (10.239.4.153) by
 FMSMSX113.amr.corp.intel.com (10.18.116.7) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 10 Jul 2019 04:08:17 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.110]) by
 SHSMSX101.ccr.corp.intel.com ([169.254.1.134]) with mapi id 14.03.0439.000;
 Wed, 10 Jul 2019 19:08:15 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Peter Xu <zhexu@redhat.com>
CC:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: RE: [RFC v1 03/18] hw/pci: introduce PCIPASIDOps to PCIDevice
Thread-Topic: [RFC v1 03/18] hw/pci: introduce PCIPASIDOps to PCIDevice
Thread-Index: AQHVM+yjwx3TWeXThE+Y1TsJTJWrjKbBCXeAgAKsLDA=
Date:   Wed, 10 Jul 2019 11:08:15 +0000
Message-ID: <A2975661238FB949B60364EF0F2C257439F2A5F2@SHSMSX104.ccr.corp.intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
 <1562324511-2910-4-git-send-email-yi.l.liu@intel.com>
 <20190709021209.GA5178@xz-x1>
In-Reply-To: <20190709021209.GA5178@xz-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMzYwNjgwYWYtYmI1ZS00MjA5LWFjNzAtNzQzMzFlMDhkY2M3IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiWTNTRXpzdWdBdGdMMmxweVF6VlNXTFpmblNWYkk4Tnh2RlNnb0JtalJ2SUh1M1VQU1BnS3liU3UzVmNhQVp3dCJ9
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQZXRlciBYdSBbbWFpbHRvOnpoZXh1QHJlZGhhdC5jb21dDQo+IFNlbnQ6IFR1ZXNk
YXksIEp1bHkgOSwgMjAxOSAxMDoxMiBBTQ0KPiBUbzogTGl1LCBZaSBMIDx5aS5sLmxpdUBpbnRl
bC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUkZDIHYxIDAzLzE4XSBody9wY2k6IGludHJvZHVjZSBQ
Q0lQQVNJRE9wcyB0byBQQ0lEZXZpY2UNCj4gDQo+IE9uIEZyaSwgSnVsIDA1LCAyMDE5IGF0IDA3
OjAxOjM2UE0gKzA4MDAsIExpdSBZaSBMIHdyb3RlOg0KPiA+ICt2b2lkIHBjaV9zZXR1cF9wYXNp
ZF9vcHMoUENJRGV2aWNlICpkZXYsIFBDSVBBU0lET3BzICpvcHMpDQo+ID4gK3sNCj4gPiArICAg
IGFzc2VydChvcHMgJiYgIWRldi0+cGFzaWRfb3BzKTsNCj4gPiArICAgIGRldi0+cGFzaWRfb3Bz
ID0gb3BzOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICtib29sIHBjaV9kZXZpY2VfaXNfb3BzX3NldChQ
Q0lCdXMgKmJ1cywgaW50MzJfdCBkZXZmbikNCj4gDQo+IE5hbWUgc2hvdWxkIGJlICJwY2lfZGV2
aWNlX2lzX3Bhc2lkX29wc19zZXQiLiAgT3IgbWF5YmUgeW91IGNhbiBzaW1wbHkNCj4gZHJvcCB0
aGlzIGZ1bmN0aW9uIGJlY2F1c2UgYXMgbG9uZyBhcyB5b3UgY2hlY2sgaXQgaW4gaGVscGVyIGZ1
bmN0aW9ucw0KPiBsaWtlIFsxXSBiZWxvdyBhbHdheXMgdGhlbiBpdCBzZWVtcyBldmVuIHVuZWNl
c3NhcnkuDQoNCnllcywgdGhlIG5hbWUgc2hvdWxkIGJlICJwY2lfZGV2aWNlX2lzX3Bhc2lkX29w
c19zZXQiLiBJIG5vdGljZWQgeW91cg0KY29tbWVudHMgb24gdGhlIG5lY2Vzc2l0eSBpbiBhbm90
aGVyLCBsZXQncyB0YWxrIGluIHRoYXQgdGhyZWFkLiA6LSkNCg0KPiA+ICt7DQo+ID4gKyAgICBQ
Q0lEZXZpY2UgKmRldjsNCj4gPiArDQo+ID4gKyAgICBpZiAoIWJ1cykgew0KPiA+ICsgICAgICAg
IHJldHVybiBmYWxzZTsNCj4gPiArICAgIH0NCj4gPiArDQo+ID4gKyAgICBkZXYgPSBidXMtPmRl
dmljZXNbZGV2Zm5dOw0KPiA+ICsgICAgcmV0dXJuICEhKGRldiAmJiBkZXYtPnBhc2lkX29wcyk7
DQo+ID4gK30NCj4gPiArDQo+ID4gK2ludCBwY2lfZGV2aWNlX3JlcXVlc3RfcGFzaWRfYWxsb2Mo
UENJQnVzICpidXMsIGludDMyX3QgZGV2Zm4sDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgdWludDMyX3QgbWluX3Bhc2lkLCB1aW50MzJfdCBtYXhfcGFzaWQpDQo+IA0K
PiBGcm9tIFZULWQgc3BlYyBJIHNlZSB0aGF0IHRoZSB2aXJ0dWFsIGNvbW1hbmQgImFsbG9jYXRl
IHBhc2lkIiBkb2VzDQo+IG5vdCBoYXZlIGJkZiBpbmZvcm1hdGlvbiBzbyBpdCdzIGdsb2JhbCwg
YnV0IGhlcmUgd2UndmUgZ290IGJ1cy9kZXZmbi4NCj4gSSdtIGN1cmlvdXMgaXMgdGhhdCByZXNl
cnZlZCBmb3IgQVJNIG9yIHNvbWUgb3RoZXIgYXJjaD8NCg0KWW91IGFyZSByaWdodC4gVlQtZCBz
cGVjIGRvZXNu4oCZdCBoYXZlIGJkZiBpbmZvLiBCdXQgd2UgbmVlZCB0byBwYXNzIHRoZQ0KYWxs
b2NhdGlvbiByZXF1ZXN0IHZpYSB2ZmlvLiBTbyB0aGlzIGZ1bmN0aW9uIGhhcyBiZGYgaW5mby4g
SW4gdklPTU1VIHNpZGUsDQppdCBzaG91bGQgc2VsZWN0IGEgdmZpby1wY2kgZGV2aWNlIGFuZCBp
bnZva2UgdGhpcyBjYWxsYmFjayB3aGVuIGl0IHdhbnRzIHRvDQpyZXF1ZXN0IFBBU0lEIGFsbG9j
L2ZyZWUuDQoNCj4gPiArew0KPiA+ICsgICAgUENJRGV2aWNlICpkZXY7DQo+ID4gKw0KPiA+ICsg
ICAgaWYgKCFidXMpIHsNCj4gPiArICAgICAgICByZXR1cm4gLTE7DQo+ID4gKyAgICB9DQo+ID4g
Kw0KPiA+ICsgICAgZGV2ID0gYnVzLT5kZXZpY2VzW2RldmZuXTsNCj4gPiArICAgIGlmIChkZXYg
JiYgZGV2LT5wYXNpZF9vcHMgJiYgZGV2LT5wYXNpZF9vcHMtPmFsbG9jX3Bhc2lkKSB7DQo+IA0K
PiBbMV0NCj4gDQo+ID4gKyAgICAgICAgcmV0dXJuIGRldi0+cGFzaWRfb3BzLT5hbGxvY19wYXNp
ZChidXMsIGRldmZuLCBtaW5fcGFzaWQsIG1heF9wYXNpZCk7DQoNClRoYW5rcywNCllpIExpdQ0K
