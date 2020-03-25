Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 603E6192408
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 10:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgCYJa7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 05:30:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:60002 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726206AbgCYJa6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 05:30:58 -0400
IronPort-SDR: m/3sXWV8VuEMl0/PARvmaKTGPmD70FLBHnNLKlebEoEyDI8bQiBt9HwqAV+RH5j3Wu3CaAK+Fq
 jDXg9PV2gEsA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 02:30:58 -0700
IronPort-SDR: ENJVQmTRM4coOaTMc6q37SKG5EVC7/GgEuFqqTwkgl5wOlO1p8nb1IlpWBF/2CoqvL7Ri+wk4v
 EmBJPJwiDS7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,303,1580803200"; 
   d="scan'208";a="250358864"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga006.jf.intel.com with ESMTP; 25 Mar 2020 02:30:57 -0700
Received: from fmsmsx123.amr.corp.intel.com (10.18.125.38) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 25 Mar 2020 02:30:54 -0700
Received: from shsmsx153.ccr.corp.intel.com (10.239.6.53) by
 fmsmsx123.amr.corp.intel.com (10.18.125.38) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 25 Mar 2020 02:30:54 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.206]) by
 SHSMSX153.ccr.corp.intel.com ([169.254.12.96]) with mapi id 14.03.0439.000;
 Wed, 25 Mar 2020 17:30:50 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Peter Xu <peterx@redhat.com>
CC:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: RE: [PATCH v1 08/22] vfio: init HostIOMMUContext per-container
Thread-Topic: [PATCH v1 08/22] vfio: init HostIOMMUContext per-container
Thread-Index: AQHWAEW0jB9vKYJM+keTj5bDx+gC8qhWMHmAgAGHKsD//5eLgIABwClw
Date:   Wed, 25 Mar 2020 09:30:50 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A201DC5@SHSMSX104.ccr.corp.intel.com>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-9-git-send-email-yi.l.liu@intel.com>
 <20200323213943.GR127076@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A2006A9@SHSMSX104.ccr.corp.intel.com>
 <20200324144553.GU127076@xz-x1>
In-Reply-To: <20200324144553.GU127076@xz-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
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

PiBGcm9tOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIE1h
cmNoIDI0LCAyMDIwIDEwOjQ2IFBNDQo+IFRvOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNv
bT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MSAwOC8yMl0gdmZpbzogaW5pdCBIb3N0SU9NTVVD
b250ZXh0IHBlci1jb250YWluZXINCj4gDQo+IE9uIFR1ZSwgTWFyIDI0LCAyMDIwIGF0IDAxOjAz
OjI4UE0gKzAwMDAsIExpdSwgWWkgTCB3cm90ZToNCj4gPiA+IEZyb206IFBldGVyIFh1IDxwZXRl
cnhAcmVkaGF0LmNvbT4NCj4gPiA+IFNlbnQ6IFR1ZXNkYXksIE1hcmNoIDI0LCAyMDIwIDU6NDAg
QU0NCj4gPiA+IFRvOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gPiA+IFN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggdjEgMDgvMjJdIHZmaW86IGluaXQgSG9zdElPTU1VQ29udGV4dA0KPiA+
ID4gcGVyLWNvbnRhaW5lcg0KPiA+ID4NCj4gPiA+IE9uIFN1biwgTWFyIDIyLCAyMDIwIGF0IDA1
OjM2OjA1QU0gLTA3MDAsIExpdSBZaSBMIHdyb3RlOg0KPiA+ID4gPiBBZnRlciBjb25maXJtaW5n
IGR1YWwgc3RhZ2UgRE1BIHRyYW5zbGF0aW9uIHN1cHBvcnQgd2l0aCBrZXJuZWwgYnkNCj4gPiA+
ID4gY2hlY2tpbmcgVkZJT19UWVBFMV9ORVNUSU5HX0lPTU1VLCBWRklPIGluaXRzIEhvc3RJT01N
VUNvbnRldA0KPiA+ID4gPiBpbnN0YW5jZSBhbmQgZXhwb3NlcyBpdCB0byBQQ0kgbGF5ZXIuIFRo
dXMgdklPTU1VIGVtdWFsdG9ycyBtYXkNCj4gPiA+ID4gbWFrZSB1c2Ugb2Ygc3VjaCBjYXBhYmls
aXR5IGJ5IGxldmVyYWdpbmcgdGhlIG1ldGhvZHMgcHJvdmlkZWQgYnkNCj4gSG9zdElPTU1VQ29u
dGV4dC4NCj4gPiA+ID4NCj4gPiA+ID4gQ2M6IEtldmluIFRpYW4gPGtldmluLnRpYW5AaW50ZWwu
Y29tPg0KPiA+ID4gPiBDYzogSmFjb2IgUGFuIDxqYWNvYi5qdW4ucGFuQGxpbnV4LmludGVsLmNv
bT4NCj4gPiA+ID4gQ2M6IFBldGVyIFh1IDxwZXRlcnhAcmVkaGF0LmNvbT4NCj4gPiA+ID4gQ2M6
IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4NCj4gPiA+ID4gQ2M6IFlpIFN1biA8
eWkueS5zdW5AbGludXguaW50ZWwuY29tPg0KPiA+ID4gPiBDYzogRGF2aWQgR2lic29uIDxkYXZp
ZEBnaWJzb24uZHJvcGJlYXIuaWQuYXU+DQo+ID4gPiA+IENjOiBBbGV4IFdpbGxpYW1zb24gPGFs
ZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiA+ID4gPiBTaWduZWQtb2ZmLWJ5OiBMaXUgWWkg
TCA8eWkubC5saXVAaW50ZWwuY29tPg0KPiA+ID4gPiAtLS0NCj4gPiA+ID4gIGh3L3ZmaW8vY29t
bW9uLmMgICAgICAgICAgICAgICAgICAgICAgfCA4MA0KPiArKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKw0KPiA+ID4gPiAgaHcvdmZpby9wY2kuYyAgICAgICAgICAgICAgICAgICAg
ICAgICB8IDEzICsrKysrKw0KPiA+ID4gPiAgaW5jbHVkZS9ody9pb21tdS9ob3N0X2lvbW11X2Nv
bnRleHQuaCB8ICAzICsrDQo+ID4gPiA+ICBpbmNsdWRlL2h3L3ZmaW8vdmZpby1jb21tb24uaCAg
ICAgICAgIHwgIDQgKysNCj4gPiA+ID4gIDQgZmlsZXMgY2hhbmdlZCwgMTAwIGluc2VydGlvbnMo
KykNCj4gPiA+ID4NCj4gPiA+ID4gZGlmZiAtLWdpdCBhL2h3L3ZmaW8vY29tbW9uLmMgYi9ody92
ZmlvL2NvbW1vbi5jIGluZGV4DQo+ID4gPiA+IGMyNzY3MzIuLmU0ZjVmMTAgMTAwNjQ0DQo+ID4g
PiA+IC0tLSBhL2h3L3ZmaW8vY29tbW9uLmMNCj4gPiA+ID4gKysrIGIvaHcvdmZpby9jb21tb24u
Yw0KPiA+ID4gPiBAQCAtMTE3OSwxMCArMTE3OSw1NSBAQCBzdGF0aWMgaW50DQo+ID4gPiA+IHZm
aW9fZ2V0X2lvbW11X3R5cGUoVkZJT0NvbnRhaW5lcg0KPiA+ID4gKmNvbnRhaW5lciwNCj4gPiA+
ID4gICAgICByZXR1cm4gLUVJTlZBTDsNCj4gPiA+ID4gIH0NCj4gPiA+ID4NCj4gPiA+ID4gK3N0
YXRpYyBpbnQgdmZpb19ob3N0X2ljeF9wYXNpZF9hbGxvYyhIb3N0SU9NTVVDb250ZXh0ICpob3N0
X2ljeCwNCj4gPiA+DQo+ID4gPiBJJ20gbm90IHN1cmUgYWJvdXQgQWxleCwgYnV0IC4uLiBpY3gg
aXMgY29uZnVzaW5nIHRvIG1lLiAgTWF5YmUgImN0eCINCj4gPiA+IGFzIHlvdSBhbHdheXMgdXNl
ZD8NCj4gPg0KPiA+IEF0IGZpcnN0IEkgdXNlZCB2ZmlvX2hvc3RfaW9tbXVfY3R4X3Bhc2lkX2Fs
bG9jKCksIGZvdW5kIGl0IGlzIGxvbmcsDQo+ID4gc28gSSBzd2l0Y2hlZCB0byAiaWN4IiB3aGlj
aCBtZWFucyBpb21tdV9jb250ZXh0LiBNYXliZSB0aGUgZm9ybWVyIG9uZQ0KPiA+IGxvb2tzIGJl
dHRlciBhcyBpdCBnaXZlcyBtb3JlIHByZWNpc2UgaW5mby4NCj4gDQo+IHZmaW9faG9zdF9pb21t
dV9jdHhfcGFzaWRfYWxsb2MoKSBpc24ndCB0aGF0IGJhZCBpbWhvLiAgSSdsbCBvbWl0IHRoZSAi
Y3R4IiBpZiBJIHdhbnQNCj4gdG8gbWFrZSBpdCBldmVuIHNob3J0ZXIsIGJ1dCAiaWN4IiBtaWdo
dCBiZSBhbWJpZ3VvdXMuDQoNCkdvdCBpdC4gbGV0IG1lIG1vZGlmeSB0aGUgcHJlZml4Lg0KDQpS
ZWdhcmRzLA0KWWkgTGl1DQo=
