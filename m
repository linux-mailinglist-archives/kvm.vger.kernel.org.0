Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 622806522B
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 09:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbfGKHFY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 03:05:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:51470 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728057AbfGKHFY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 03:05:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 00:05:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,476,1557212400"; 
   d="scan'208";a="174068871"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Jul 2019 00:05:22 -0700
Received: from fmsmsx119.amr.corp.intel.com (10.18.124.207) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 11 Jul 2019 00:05:22 -0700
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 FMSMSX119.amr.corp.intel.com (10.18.124.207) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 11 Jul 2019 00:05:21 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.110]) by
 SHSMSX152.ccr.corp.intel.com ([169.254.6.22]) with mapi id 14.03.0439.000;
 Thu, 11 Jul 2019 14:59:40 +0800
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
Subject: RE: [RFC v1 06/18] intel_iommu: support virtual command emulation
 and pasid request
Thread-Topic: [RFC v1 06/18] intel_iommu: support virtual command emulation
 and pasid request
Thread-Index: AQHVM+ylOC+MxRu5MEOwKVcZdjCE5KbBHCcAgAKbkLCAAGXpgIAA486w
Date:   Thu, 11 Jul 2019 06:59:40 +0000
Message-ID: <A2975661238FB949B60364EF0F2C257439F2C65C@SHSMSX104.ccr.corp.intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
 <1562324511-2910-7-git-send-email-yi.l.liu@intel.com>
 <20190709031902.GD5178@xz-x1>
 <A2975661238FB949B60364EF0F2C257439F2A65F@SHSMSX104.ccr.corp.intel.com>
 <20190711011305.GJ5178@xz-x1>
In-Reply-To: <20190711011305.GJ5178@xz-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNDkxOGE3MDItOTIzMi00ZTNjLTgyMTgtZDdmMjAwYjMzYWNkIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoidVZkdG5kaG1UbGc1R0d5STdjam04a1E4a3V1VHpuVEp6cCs3YlNxcjNEYThHNGRvVkVTdVVQSHIrZGJISjY3ZiJ9
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQZXRlciBYdSBbbWFpbHRvOnpoZXh1QHJlZGhhdC5jb21dDQo+IFNlbnQ6IFRodXJz
ZGF5LCBKdWx5IDExLCAyMDE5IDk6MTMgQU0NCj4gVG86IExpdSwgWWkgTCA8eWkubC5saXVAaW50
ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1JGQyB2MSAwNi8xOF0gaW50ZWxfaW9tbXU6IHN1cHBv
cnQgdmlydHVhbCBjb21tYW5kIGVtdWxhdGlvbiBhbmQNCj4gcGFzaWQgcmVxdWVzdA0KPiANCj4g
T24gV2VkLCBKdWwgMTAsIDIwMTkgYXQgMTE6NTE6MTdBTSArMDAwMCwgTGl1LCBZaSBMIHdyb3Rl
Og0KPiANCj4gWy4uLl0NCj4gDQo+ID4gPiA+ICsgICAgICAgIHMtPnZjcnNwID0gMTsNCj4gPiA+
ID4gKyAgICAgICAgdnRkX3NldF9xdWFkX3JhdyhzLCBETUFSX1ZDUlNQX1JFRywNCj4gPiA+ID4g
KyAgICAgICAgICAgICAgICAgICAgICAgICAoKHVpbnQ2NF90KSBzLT52Y3JzcCkpOw0KPiA+ID4N
Cj4gPiA+IERvIHdlIHJlYWxseSBuZWVkIHRvIGVtdWxhdGUgdGhlICJJbiBQcm9ncmVzcyIgbGlr
ZSB0aGlzPyAgVGhlIHZjcHUgaXMNCj4gPiA+IGJsb2NrZWQgaGVyZSBhZnRlciBhbGwsIGFuZCBB
RkFJQ1QgYWxsIHRoZSByZXN0IG9mIHZjcHVzIHNob3VsZCBub3QNCj4gPiA+IGFjY2VzcyB0aGVz
ZSByZWdpc3RlcnMgYmVjYXVzZSBvYnZpb3VzbHkgdGhlc2UgcmVnaXN0ZXJzIGNhbm5vdCBiZQ0K
PiA+ID4gYWNjZXNzZWQgY29uY3VycmVudGx5Li4uDQo+ID4NCj4gPiBPdGhlciB2Y3B1cyBzaG91
bGQgcG9sbCB0aGUgSVAgYml0IGJlZm9yZSBzdWJtaXR0aW5nIHZjbWRzLiBBcyBJUCBiaXQNCj4g
PiBpcyBzZXQsIG90aGVyIHZjcHVzIHdpbGwgbm90IGFjY2VzcyB0aGVzZSBiaXRzLiBidXQgaWYg
bm90LCB0aGV5IG1heSBzdWJtaXQNCj4gPiBuZXcgdmNtZHMsIHdoaWxlIHdlIG9ubHkgaGF2ZSAx
IHJlc3BvbnNlIHJlZ2lzdGVyLCB0aGF0IGlzIG5vdCB3ZQ0KPiA+IHN1cHBvcnQuIFRoYXQncyB3
aHkgd2UgbmVlZCB0byBzZXQgSVAgYml0Lg0KPiANCj4gSSBzdGlsbCBkb24ndCB0aGluayBhbm90
aGVyIENQVSBjYW4gdXNlIHRoaXMgcmVnaXN0ZXIgZXZlbiBpZiBpdA0KPiBwb2xsZWQgd2l0aCBJ
UD09MC4uLiAgVGhlIHJlYXNvbiBpcyBzaW1wbHkgYXMgeW91IGRlc2NyaWJlZCAtIHdlIG9ubHkN
Cj4gaGF2ZSBvbmUgcGFpciBvZiBWQ01EL1ZSU1BEIHJlZ2lzdGVycyBzbyBJTUhPIHRoZSBndWVz
dCBJT01NVSBkcml2ZXINCj4gbXVzdCBoYXZlIGEgbG9jayAocHJvYmFibHkgYSBtdXRleCkgdG8g
Z3VhcmFudGVlIHNlcXVlbnRpYWwgYWNjZXNzIG9mDQo+IHRoZXNlIHJlZ2lzdGVycyBvdGhlcndp
c2UgcmFjZSBjYW4gaGFwcGVuLg0KDQpHb3QgaXQuIFNvIHRoZSBjYXNlIGhlcmUgaXM6IG90aGVy
IHZjcHVzIHdpbGwgbm90IGJlIGFibGUgdG8gYWNjZXNzIHRoZSBWQ01ELw0KVlJTUCBkdWUgdGhl
IGxvY2sgaW4gZ3Vlc3QgaW9tbXUgZHJpdmVyLiBTbyBJUCBiaXQgaXMgb25seSB1c2VkIHRvIGJs
b2NrIGFueQ0KZnVydGhlciBWQ01EcyBmcm9tIHRoZSBzYW1lIHZjcHUgd2hpY2ggZ2FpbmVkIHRo
ZSBsb2NrLiBCdXQgd2UgYXJlIGVtdWxhdGluZw0KVkNNRC9WUlNQIGluIGEgc3luY2hyb25pemUg
bWFubmVyLCBzbyB2Y3B1IGhhcyBubyB3YXkgdG8gc3VibWl0IG5ldyBWQ01Ecw0KYmVmb3JlIGEg
cHJpb3IgVk1DRCBpcyBjb21wbGV0ZWQuDQoNCj4gPg0KPiA+ID4NCj4gPiA+IEkgdGhpbmsgdGhl
IElQIGJpdCBpcyB1c2VmdWwgd2hlbiBzb21lIG5ldyB2Y21kIHdvdWxkIHRha2UgcGxlbnR5IG9m
DQo+ID4gPiB0aW1lIHNvIHRoYXQgd2UgY2FuIGRvIHRoZSBsb25nIHZjbWRzIGluIGFzeW5jIHdh
eS4gIEhvd2V2ZXIgaGVyZSBpdA0KPiA+ID4gc2VlbXMgbm90IHRoZSBjYXNlPw0KPiA+DQo+ID4g
bm8sIHNvIGZhciwgaXQgaXMgc3luY2hyb25pemUgd2F5LiBBcyBtZW50aW9uZWQgYWJvdmUsIElQ
IGJpdCBpcyB0byBlbnN1cmUNCj4gPiBvbmx5IG9uZSB2Y21kIGlzIGhhbmRsZWQgZm9yIGEgdGlt
ZS4gT3RoZXIgdmNwdXMgd29uJ3QgYmUgYWJsZSB0byBzdWJtaXQNCj4gPiB2Y21kcyBiZWZvcmUg
SVAgaXMgY2xlYXJlZC4NCj4gDQo+IFsuLi5dDQo+IA0KPiA+ID4gPiBAQCAtMTkyLDYgKzE5OCw3
IEBADQo+ID4gPiA+ICAjZGVmaW5lIFZURF9FQ0FQX1NSUyAgICAgICAgICAgICAgICAoMVVMTCA8
PCAzMSkNCj4gPiA+ID4gICNkZWZpbmUgVlREX0VDQVBfUEFTSUQgICAgICAgICAgICAgICgxVUxM
IDw8IDQwKQ0KPiA+ID4gPiAgI2RlZmluZSBWVERfRUNBUF9TTVRTICAgICAgICAgICAgICAgKDFV
TEwgPDwgNDMpDQo+ID4gPiA+ICsjZGVmaW5lIFZURF9FQ0FQX1ZDUyAgICAgICAgICAgICAgICAo
MVVMTCA8PCA0NCkNCj4gPiA+ID4gICNkZWZpbmUgVlREX0VDQVBfU0xUUyAgICAgICAgICAgICAg
ICgxVUxMIDw8IDQ2KQ0KPiA+ID4gPiAgI2RlZmluZSBWVERfRUNBUF9GTFRTICAgICAgICAgICAg
ICAgKDFVTEwgPDwgNDcpDQo+ID4gPiA+DQo+ID4gPiA+IEBAIC0zMTQsNiArMzIxLDI5IEBAIHR5
cGVkZWYgZW51bSBWVERGYXVsdFJlYXNvbiB7DQo+ID4gPiA+DQo+ID4gPiA+ICAjZGVmaW5lIFZU
RF9DT05URVhUX0NBQ0hFX0dFTl9NQVggICAgICAgMHhmZmZmZmZmZlVMDQo+ID4gPiA+DQo+ID4g
PiA+ICsvKiBWQ0NBUF9SRUcgKi8NCj4gPiA+ID4gKyNkZWZpbmUgVlREX1ZDQ0FQX1BBUyAgICAg
ICAgICAgICAgICgxVUwgPDwgMCkNCj4gPiA+ID4gKyNkZWZpbmUgVlREX01JTl9IUEFTSUQgICAg
ICAgICAgICAgIDIwMA0KPiA+ID4NCj4gPiA+IENvbW1lbnQgdGhpcyB2YWx1ZSBhIGJpdD8NCj4g
Pg0KPiA+IFRoZSBiYXNpYyBpZGVhIGlzIHRvIGxldCBoeXBlcnZpc29yIHRvIHNldCBhIHJhbmdl
IGZvciBhdmFpbGFibGUgUEFTSURzIGZvcg0KPiA+IFZNcy4gT25lIG9mIHRoZSByZWFzb25zIGlz
IFBBU0lEICMwIGlzIHJlc2VydmVkIGJ5IFJJRF9QQVNJRCB1c2FnZS4NCj4gPiBXZSBoYXZlIG5v
IGlkZWEgaG93IG1hbnkgcmVzZXJ2ZWQgUEFTSURzIGluIGZ1dHVyZSwgc28gaGVyZSBqdXN0IGEN
Cj4gPiBldmFsdWF0ZWQgdmFsdWUuIEhvbmVzdGx5LCBzZXQgaXQgYXMgIjEiIGlzIGVub3VnaCBh
dCBjdXJyZW50IHN0YWdlLg0KPiANCj4gVGhhdCdsbCBiZSBhIHZlcnkgbmljZSBpbml0aWFsIGNv
bW1lbnQgZm9yIHRoYXQgKEkgbWVhbiwgcHV0IGl0IGludG8NCj4gdGhlIHBhdGNoLCBvZiBjb3Vy
c2UgOikuDQoNCkdvdCBpdC4gd2lsbCBhZGQgaXQgaW4gbmV4dCB2ZXJzaW9uLg0KDQpUaGFua3Ms
DQpZaSBMaXUNCg==
