Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79A7E65256
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 09:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbfGKHUf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 03:20:35 -0400
Received: from mga03.intel.com ([134.134.136.65]:64722 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbfGKHUf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 03:20:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 00:20:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,476,1557212400"; 
   d="scan'208";a="189417484"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga004.fm.intel.com with ESMTP; 11 Jul 2019 00:20:34 -0700
Received: from fmsmsx157.amr.corp.intel.com (10.18.116.73) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 11 Jul 2019 00:20:34 -0700
Received: from shsmsx108.ccr.corp.intel.com (10.239.4.97) by
 FMSMSX157.amr.corp.intel.com (10.18.116.73) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 11 Jul 2019 00:20:33 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.110]) by
 SHSMSX108.ccr.corp.intel.com ([169.254.8.174]) with mapi id 14.03.0439.000;
 Thu, 11 Jul 2019 15:13:45 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
CC:     Peter Xu <zhexu@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: RE: [RFC v1 03/18] hw/pci: introduce PCIPASIDOps to PCIDevice
Thread-Topic: [RFC v1 03/18] hw/pci: introduce PCIPASIDOps to PCIDevice
Thread-Index: AQHVM+yjwx3TWeXThE+Y1TsJTJWrjKbBCXeAgAKsLDCAAJRYgIAAu4mg
Date:   Thu, 11 Jul 2019 07:13:44 +0000
Message-ID: <A2975661238FB949B60364EF0F2C257439F2C6BF@SHSMSX104.ccr.corp.intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
 <1562324511-2910-4-git-send-email-yi.l.liu@intel.com>
 <20190709021209.GA5178@xz-x1>
 <A2975661238FB949B60364EF0F2C257439F2A5F2@SHSMSX104.ccr.corp.intel.com>
 <20190711035151.GG13271@umbus.fritz.box>
In-Reply-To: <20190711035151.GG13271@umbus.fritz.box>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMzU3ZDRiODEtNWZhMi00N2VjLTljODYtMDUyMTRiOTBhYmUzIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiQVBnanRma28xeFkwVmp3eXV5ZXlRRDJ1RmlNSUlZNmF2b01pR0hWQk12eDRhVExNc0Q3YXAzV3JFaDN2ZjFaciJ9
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBkYXZpZEBnaWJzb24uZHJvcGJlYXIuaWQuYXUgW21haWx0bzpkYXZpZEBnaWJzb24u
ZHJvcGJlYXIuaWQuYXVdDQo+IFNlbnQ6IFRodXJzZGF5LCBKdWx5IDExLCAyMDE5IDExOjUyIEFN
DQo+IFRvOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtS
RkMgdjEgMDMvMThdIGh3L3BjaTogaW50cm9kdWNlIFBDSVBBU0lET3BzIHRvIFBDSURldmljZQ0K
PiANCj4gT24gV2VkLCBKdWwgMTAsIDIwMTkgYXQgMTE6MDg6MTVBTSArMDAwMCwgTGl1LCBZaSBM
IHdyb3RlOg0KPiA+ID4gRnJvbTogUGV0ZXIgWHUgW21haWx0bzp6aGV4dUByZWRoYXQuY29tXQ0K
PiA+ID4gU2VudDogVHVlc2RheSwgSnVseSA5LCAyMDE5IDEwOjEyIEFNDQo+ID4gPiBUbzogTGl1
LCBZaSBMIDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4gPiBTdWJqZWN0OiBSZTogW1JGQyB2MSAw
My8xOF0gaHcvcGNpOiBpbnRyb2R1Y2UgUENJUEFTSURPcHMgdG8gUENJRGV2aWNlDQo+ID4gPg0K
PiA+ID4gT24gRnJpLCBKdWwgMDUsIDIwMTkgYXQgMDc6MDE6MzZQTSArMDgwMCwgTGl1IFlpIEwg
d3JvdGU6DQo+ID4gPiA+ICt2b2lkIHBjaV9zZXR1cF9wYXNpZF9vcHMoUENJRGV2aWNlICpkZXYs
IFBDSVBBU0lET3BzICpvcHMpDQo+ID4gPiA+ICt7DQo+ID4gPiA+ICsgICAgYXNzZXJ0KG9wcyAm
JiAhZGV2LT5wYXNpZF9vcHMpOw0KPiA+ID4gPiArICAgIGRldi0+cGFzaWRfb3BzID0gb3BzOw0K
PiA+ID4gPiArfQ0KPiA+ID4gPiArDQo+ID4gPiA+ICtib29sIHBjaV9kZXZpY2VfaXNfb3BzX3Nl
dChQQ0lCdXMgKmJ1cywgaW50MzJfdCBkZXZmbikNCj4gPiA+DQo+ID4gPiBOYW1lIHNob3VsZCBi
ZSAicGNpX2RldmljZV9pc19wYXNpZF9vcHNfc2V0Ii4gIE9yIG1heWJlIHlvdSBjYW4gc2ltcGx5
DQo+ID4gPiBkcm9wIHRoaXMgZnVuY3Rpb24gYmVjYXVzZSBhcyBsb25nIGFzIHlvdSBjaGVjayBp
dCBpbiBoZWxwZXIgZnVuY3Rpb25zDQo+ID4gPiBsaWtlIFsxXSBiZWxvdyBhbHdheXMgdGhlbiBp
dCBzZWVtcyBldmVuIHVuZWNlc3NhcnkuDQo+ID4NCj4gPiB5ZXMsIHRoZSBuYW1lIHNob3VsZCBi
ZSAicGNpX2RldmljZV9pc19wYXNpZF9vcHNfc2V0Ii4gSSBub3RpY2VkIHlvdXINCj4gPiBjb21t
ZW50cyBvbiB0aGUgbmVjZXNzaXR5IGluIGFub3RoZXIsIGxldCdzIHRhbGsgaW4gdGhhdCB0aHJl
YWQuIDotKQ0KPiA+DQo+ID4gPiA+ICt7DQo+ID4gPiA+ICsgICAgUENJRGV2aWNlICpkZXY7DQo+
ID4gPiA+ICsNCj4gPiA+ID4gKyAgICBpZiAoIWJ1cykgew0KPiA+ID4gPiArICAgICAgICByZXR1
cm4gZmFsc2U7DQo+ID4gPiA+ICsgICAgfQ0KPiA+ID4gPiArDQo+ID4gPiA+ICsgICAgZGV2ID0g
YnVzLT5kZXZpY2VzW2RldmZuXTsNCj4gPiA+ID4gKyAgICByZXR1cm4gISEoZGV2ICYmIGRldi0+
cGFzaWRfb3BzKTsNCj4gPiA+ID4gK30NCj4gPiA+ID4gKw0KPiA+ID4gPiAraW50IHBjaV9kZXZp
Y2VfcmVxdWVzdF9wYXNpZF9hbGxvYyhQQ0lCdXMgKmJ1cywgaW50MzJfdCBkZXZmbiwNCj4gPiA+
ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdWludDMyX3QgbWluX3Bhc2lk
LCB1aW50MzJfdCBtYXhfcGFzaWQpDQo+ID4gPg0KPiA+ID4gRnJvbSBWVC1kIHNwZWMgSSBzZWUg
dGhhdCB0aGUgdmlydHVhbCBjb21tYW5kICJhbGxvY2F0ZSBwYXNpZCIgZG9lcw0KPiA+ID4gbm90
IGhhdmUgYmRmIGluZm9ybWF0aW9uIHNvIGl0J3MgZ2xvYmFsLCBidXQgaGVyZSB3ZSd2ZSBnb3Qg
YnVzL2RldmZuLg0KPiA+ID4gSSdtIGN1cmlvdXMgaXMgdGhhdCByZXNlcnZlZCBmb3IgQVJNIG9y
IHNvbWUgb3RoZXIgYXJjaD8NCj4gPg0KPiA+IFlvdSBhcmUgcmlnaHQuIFZULWQgc3BlYyBkb2Vz
buKAmXQgaGF2ZSBiZGYgaW5mby4gQnV0IHdlIG5lZWQgdG8gcGFzcyB0aGUNCj4gPiBhbGxvY2F0
aW9uIHJlcXVlc3QgdmlhIHZmaW8uIFNvIHRoaXMgZnVuY3Rpb24gaGFzIGJkZiBpbmZvLiBJbiB2
SU9NTVUgc2lkZSwNCj4gPiBpdCBzaG91bGQgc2VsZWN0IGEgdmZpby1wY2kgZGV2aWNlIGFuZCBp
bnZva2UgdGhpcyBjYWxsYmFjayB3aGVuIGl0IHdhbnRzIHRvDQo+ID4gcmVxdWVzdCBQQVNJRCBh
bGxvYy9mcmVlLg0KPiANCj4gVGhhdCBkb2Vzbid0IHNlZW0gY29uY2VwdHVhbGx5IHJpZ2h0LiAg
SUlVQywgdGhlIHBhc2lkcyAiYmVsb25nIiB0byBhDQo+IHNvcnQgb2YgU1ZNIGNvbnRleHQuICBJ
dCBzZWVtcyB0byBiZSB0aGUgYWxsb2Mgc2hvdWxkIGJlIG9uIHRoYXQNCj4gb2JqZWN0IC0gYW5k
IHRoYXQgb2JqZWN0IHdvdWxkIGFscmVhZHkgaGF2ZSBzb21lIGNvbm5lY3Rpb24gdG8gYW55DQo+
IHJlbGV2YW50IHZmaW8gY29udGFpbmVycy4gIEF0IHRoZSB2ZmlvIGxldmVsIHRoaXMgc2VlbXMg
bGlrZSBpdCBzaG91bGQNCj4gYmUgYSBjb250YWluZXIgb3BlcmF0aW9uIHJhdGhlciB0aGFuIGEg
ZGV2aWNlIG9wZXJhdGlvbi4NCg0KSGkgRGF2aWQsDQoNClllYWgsIEkgYWdyZWUgaXQgc2hvdWxk
IGZpbmFsbHkgYmUgYSBjb250YWluZXIgb3BlcmF0aW9uLiBBY3R1YWxseSwgaW4gdGhlDQpjYWxs
YmFjayBpbXBsZW1lbnRhdGlvbiwgaXQgaXMgYSBjb250YWluZXIgb3BlcmF0aW9uLiBNYXkgcmVm
ZXIgdG8gdGhlDQppbXBsZW1lbnRhdGlvbiBpbiBiZWxvdyBwYXRjaC4gOi0pDQoNCltSRkMgdjEg
MDUvMThdIHZmaW8vcGNpOiBhZGQgcGFzaWQgYWxsb2MvZnJlZSBpbXBsZW1lbnRhdGlvbg0KDQpU
aGFua3MsDQpZaSBMaXUNCg0KPiA+ID4gPiArew0KPiA+ID4gPiArICAgIFBDSURldmljZSAqZGV2
Ow0KPiA+ID4gPiArDQo+ID4gPiA+ICsgICAgaWYgKCFidXMpIHsNCj4gPiA+ID4gKyAgICAgICAg
cmV0dXJuIC0xOw0KPiA+ID4gPiArICAgIH0NCj4gPiA+ID4gKw0KPiA+ID4gPiArICAgIGRldiA9
IGJ1cy0+ZGV2aWNlc1tkZXZmbl07DQo+ID4gPiA+ICsgICAgaWYgKGRldiAmJiBkZXYtPnBhc2lk
X29wcyAmJiBkZXYtPnBhc2lkX29wcy0+YWxsb2NfcGFzaWQpIHsNCj4gPiA+DQo+ID4gPiBbMV0N
Cj4gPiA+DQo+ID4gPiA+ICsgICAgICAgIHJldHVybiBkZXYtPnBhc2lkX29wcy0+YWxsb2NfcGFz
aWQoYnVzLCBkZXZmbiwgbWluX3Bhc2lkLCBtYXhfcGFzaWQpOw0KPiA+DQo+ID4gVGhhbmtzLA0K
PiA+IFlpIExpdQ0KPiANCj4gLS0NCj4gRGF2aWQgR2lic29uCQkJfCBJJ2xsIGhhdmUgbXkgbXVz
aWMgYmFyb3F1ZSwgYW5kIG15IGNvZGUNCj4gZGF2aWQgQVQgZ2lic29uLmRyb3BiZWFyLmlkLmF1
CXwgbWluaW1hbGlzdCwgdGhhbmsgeW91LiAgTk9UIF90aGVfIF9vdGhlcl8NCj4gCQkJCXwgX3dh
eV8gX2Fyb3VuZF8hDQo+IGh0dHA6Ly93d3cub3psYWJzLm9yZy9+ZGdpYnNvbg0K
