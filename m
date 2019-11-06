Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9934F1640
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 13:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbfKFMqo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 07:46:44 -0500
Received: from mga01.intel.com ([192.55.52.88]:44617 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728140AbfKFMqo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 07:46:44 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 04:46:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,274,1569308400"; 
   d="scan'208";a="353470530"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by orsmga004.jf.intel.com with ESMTP; 06 Nov 2019 04:46:42 -0800
Received: from fmsmsx155.amr.corp.intel.com (10.18.116.71) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 6 Nov 2019 04:46:25 -0800
Received: from shsmsx108.ccr.corp.intel.com (10.239.4.97) by
 FMSMSX155.amr.corp.intel.com (10.18.116.71) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 6 Nov 2019 04:46:25 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.127]) by
 SHSMSX108.ccr.corp.intel.com ([169.254.8.41]) with mapi id 14.03.0439.000;
 Wed, 6 Nov 2019 20:46:20 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Peter Xu <peterx@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>
CC:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: RE: [RFC v2 09/22] vfio/pci: add iommu_context notifier for pasid
 alloc/free
Thread-Topic: [RFC v2 09/22] vfio/pci: add iommu_context notifier for pasid
 alloc/free
Thread-Index: AQHVimsw6XlsA5+cTkCxXGelXmRQYKdxCjoAgAUNx4CACBIgYA==
Date:   Wed, 6 Nov 2019 12:46:19 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A0EF357@SHSMSX104.ccr.corp.intel.com>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <1571920483-3382-10-git-send-email-yi.l.liu@intel.com>
 <20191029121544.GS3552@umbus.metropole.lan>
 <20191101172349.GE8888@xz-x1.metropole.lan>
In-Reply-To: <20191101172349.GE8888@xz-x1.metropole.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYWI2YzNiMDUtOGQxNS00NzVmLTk1YTUtZWE5NWZiMTBhNjc4IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiS1dJeFZiNmlBeTgyYmVWUnFqTnF2Qm9JNVZWWmpDem0yb1diSHJiMVErQllNNis5NE0xVWRpdEk4MEM3YnFcL3YifQ==
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQZXRlciBYdQ0KPiBTZW50OiBTYXR1cmRheSwgTm92ZW1iZXIgMiwgMjAxOSAxOjI2
IEFNDQo+IFRvOiBEYXZpZCBHaWJzb24gPGRhdmlkQGdpYnNvbi5kcm9wYmVhci5pZC5hdT4NCj4g
U3ViamVjdDogUmU6IFtSRkMgdjIgMDkvMjJdIHZmaW8vcGNpOiBhZGQgaW9tbXVfY29udGV4dCBu
b3RpZmllciBmb3IgcGFzaWQgYWxsb2MvZnJlZQ0KPiANCj4gT24gVHVlLCBPY3QgMjksIDIwMTkg
YXQgMDE6MTU6NDRQTSArMDEwMCwgRGF2aWQgR2lic29uIHdyb3RlOg0KPiA+ID4gK3VuaW9uIElP
TU1VQ1RYUEFTSURSZXFEZXNjIHsNCj4gPiA+ICsgICAgc3RydWN0IHsNCj4gPiA+ICsgICAgICAg
IHVpbnQzMl90IG1pbl9wYXNpZDsNCj4gPiA+ICsgICAgICAgIHVpbnQzMl90IG1heF9wYXNpZDsN
Cj4gPiA+ICsgICAgICAgIGludDMyX3QgYWxsb2NfcmVzdWx0OyAvKiBwYXNpZCBhbGxvY2F0ZWQg
Zm9yIHRoZSBhbGxvYyByZXF1ZXN0ICovDQo+ID4gPiArICAgIH07DQo+ID4gPiArICAgIHN0cnVj
dCB7DQo+ID4gPiArICAgICAgICB1aW50MzJfdCBwYXNpZDsgLyogcGFzaWQgdG8gYmUgZnJlZSAq
Lw0KPiA+ID4gKyAgICAgICAgaW50IGZyZWVfcmVzdWx0Ow0KPiA+ID4gKyAgICB9Ow0KPiA+ID4g
K307DQo+ID4NCj4gPiBBcGFydCBmcm9tIHRoZXByb2JsZW0gd2l0aCB3cml0YWJsZSBmaWVsZHMs
IHVzaW5nIGEgYmlnIHVuaW9uIGZvcg0KPiA+IGV2ZW50IGRhdGEgaXMgcHJldHR5IHVnbHkuICBJ
ZiB5b3UgbmVlZCB0aGlzIGRpZmZlcmVudCBpbmZvcm1hdGlvbiBmb3INCj4gPiB0aGUgZGlmZmVy
ZW50IGV2ZW50cywgaXQgbWlnaHQgbWFrZSBtb3JlIHNlbnNlIHRvIGhhdmUgYSBzZXBhcmF0ZQ0K
PiA+IG5vdGlmaWVyIGNoYWluIHdpdGggYSBzZXBhcmF0ZSBjYWxsIGludGVyZmFjZSBmb3IgZWFj
aCBldmVudCB0eXBlLA0KPiA+IHJhdGhlciB0aGFuIHRyeWluZyB0byBtdWx0aXBsZXggdGhlbSB0
b2dldGhlci4NCj4gDQo+IEkgaGF2ZSBubyBpc3N1ZSBvbiB0aGUgdW5pb24gZGVmaW5paW9uLCBo
b3dldmVyIEkgZG8gYWdyZWUgdGhhdCBpdCdzIGENCj4gYml0IGF3a3dhcmQgdG8gcmVnaXN0ZXIg
b25lIG5vdGlmaWVyIGZvciBlYWNoIGV2ZW50Lg0KDQpHb3QgaXQuIFdvdWxkIGZpeCBpdCBpbiBu
ZXh0IHZlcnNpb24uDQoNCj4gSW5zdGVhZCBvZiBpbnRyb2R1Y2luZyBldmVuIG1vcmUgbm90aWZp
ZXIgY2hhaW5zLCBJJ20gdGhpbmtpbmcgd2hldGhlcg0KPiB3ZSBjYW4gc2ltcGx5IHByb3ZpZGUg
YSBzaW5nbGUgbm90aWZpZXIgaG9vayBmb3IgYWxsIHRoZSBmb3VyIGV2ZW50cy4NCj4gQWZ0ZXIg
YWxsIEkgZG9uJ3Qgc2VlIGluIHdoYXQgY2FzZSB3ZSdsbCBvbmx5IHJlZ2lzdGVyIHNvbWUgb2Yg
dGhlDQo+IGV2ZW50cywgbGlrZSB3ZSBjYW4ndCByZWdpc3RlciBhbGxvY19wYXNpZCgpIHdpdGhv
dXQgcmVnaXN0ZXJpbmcgdG8NCj4gZnJlZV9wYXNpZCgpIGJlY2F1c2Ugb3RoZXJ3aXNlIGl0IGRv
ZXMgbm90IG1ha2Ugc2Vuc2UuLiAgQW5kIGFsc28geW91DQo+IGhhdmUgdGhlIHdyYXBwZXIgc3Ry
dWN0ICgiSU9NTVVDVFhFdmVudERhdGEiKSB3aGljaCBjb250YWlucyB0aGUgZXZlbnQNCj4gdHlw
ZSwgc28gdGhlIG5vdGlmeSgpIGhvb2sgd2lsbCBrbm93IHdoaWNoIG1lc3NhZ2UgaXMgdGhpcy4N
Cg0KSSdtIGluIHdpdGggdGhpcyBwcm9wb3NhbC4gVGhpcyBtYWtlcyB0aGUgbm90aWZpZXIgY2hh
aW4gc21hbGxlci4NCg0KPiBBIHNpZGUgbm90ZSBpcyB0aGF0IEkgdGhpbmsgeW91IGRvbid0IG5l
ZWQgdGhlDQo+IElPTU1VQ1RYRXZlbnREYXRhLmxlbmd0aC4gIElmIHlvdSBzZWUgdGhlIGNvZGUs
IHZ0ZF9iaW5kX2d1ZXN0X3Bhc2lkKCkNCj4gZG9lcyBub3QgZXZlbiBpbml0aWFsaXplIGxlbmd0
aCByaWdodCBub3csIGFuZCBJIHRoaW5rIGl0IGNvdWxkIHN0aWxsDQo+IHdvcmsgb25seSBiZWNh
dXNlIG5vbmUgb2YgdGhlIHZmaW8gbm90aWZ5KCkgaG9vaw0KPiAoZS5nLiB2ZmlvX2lvbW11X3Bh
c2lkX2JpbmRfbm90aWZ5KSBjaGVja3MgdGhhdCBsZW5ndGguLi4NCg0KeWVzLCB3aWxsIGZpeCBp
dC4NCg0KPiAtLQ0KPiBQZXRlciBYdQ0K
