Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A543DEF81E
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 10:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730592AbfKEJJa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 04:09:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:52937 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730555AbfKEJJa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 04:09:30 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Nov 2019 01:09:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,270,1569308400"; 
   d="scan'208";a="227032956"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by fmsmga004.fm.intel.com with ESMTP; 05 Nov 2019 01:09:28 -0800
Received: from fmsmsx124.amr.corp.intel.com (10.18.125.39) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 5 Nov 2019 01:09:28 -0800
Received: from shsmsx108.ccr.corp.intel.com (10.239.4.97) by
 fmsmsx124.amr.corp.intel.com (10.18.125.39) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 5 Nov 2019 01:09:28 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.127]) by
 SHSMSX108.ccr.corp.intel.com ([169.254.8.41]) with mapi id 14.03.0439.000;
 Tue, 5 Nov 2019 17:09:26 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Peter Xu <peterx@redhat.com>
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
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC v2 00/22] intel_iommu: expose Shared Virtual Addressing to
 VM
Thread-Topic: [RFC v2 00/22] intel_iommu: expose Shared Virtual Addressing
 to VM
Thread-Index: AQHVimsks8KvEm+7BkaEbflXH8cdg6d6zfsAgAGOP8A=
Date:   Tue, 5 Nov 2019 09:09:26 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A0EE2B5@SHSMSX104.ccr.corp.intel.com>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <20191104172242.GD26023@xz-x1.metropole.lan>
In-Reply-To: <20191104172242.GD26023@xz-x1.metropole.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYTAyNTUyN2EtYTA0MS00YjgxLTg0ZDktZjY2NWI1MDc0YTUwIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiNUpyMjZOeVBsa2gxSitKVllpSHltZ3dvRUZ6ZWFITXhHTGNmOUpKSnJiajRnNmJmZk5cL1pBN3FqQXl2UGVMQ0YifQ==
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQZXRlciBYdSBbbWFpbHRvOnBldGVyeEByZWRoYXQuY29tXQ0KPiBTZW50OiBUdWVz
ZGF5LCBOb3ZlbWJlciA1LCAyMDE5IDE6MjMgQU0NCj4gVG86IExpdSwgWWkgTCA8eWkubC5saXVA
aW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1JGQyB2MiAwMC8yMl0gaW50ZWxfaW9tbXU6IGV4
cG9zZSBTaGFyZWQgVmlydHVhbCBBZGRyZXNzaW5nIHRvIFZNDQo+IA0KPiBPbiBUaHUsIE9jdCAy
NCwgMjAxOSBhdCAwODozNDoyMUFNIC0wNDAwLCBMaXUgWWkgTCB3cm90ZToNCj4gPiBTaGFyZWQg
dmlydHVhbCBhZGRyZXNzIChTVkEpLCBhLmsuYSwgU2hhcmVkIHZpcnR1YWwgbWVtb3J5IChTVk0p
IG9uDQo+ID4gSW50ZWwgcGxhdGZvcm1zIGFsbG93IGFkZHJlc3Mgc3BhY2Ugc2hhcmluZyBiZXR3
ZWVuIGRldmljZSBETUEgYW5kIGFwcGxpY2F0aW9ucy4NCj4gPiBTVkEgY2FuIHJlZHVjZSBwcm9n
cmFtbWluZyBjb21wbGV4aXR5IGFuZCBlbmhhbmNlIHNlY3VyaXR5Lg0KPiA+IFRoaXMgc2VyaWVz
IGlzIGludGVuZGVkIHRvIGV4cG9zZSBTVkEgY2FwYWJpbGl0eSB0byBWTXMuIGkuZS4gc2hhcmVk
DQo+ID4gZ3Vlc3QgYXBwbGljYXRpb24gYWRkcmVzcyBzcGFjZSB3aXRoIHBhc3N0aHJ1IGRldmlj
ZXMuIFRoZSB3aG9sZSBTVkENCj4gPiB2aXJ0dWFsaXphdGlvbiByZXF1aXJlcyBRRU1VL1ZGSU8v
SU9NTVUgY2hhbmdlcy4gVGhpcyBzZXJpZXMgaW5jbHVkZXMNCj4gPiB0aGUgUUVNVSBjaGFuZ2Vz
LCBmb3IgVkZJTyBhbmQgSU9NTVUgY2hhbmdlcywgdGhleSBhcmUgaW4gc2VwYXJhdGUNCj4gPiBz
ZXJpZXMgKGxpc3RlZCBpbiB0aGUgIlJlbGF0ZWQgc2VyaWVzIikuDQo+ID4NClsuLi5dDQo+DQo+
IFlpLA0KPiANCj4gV291bGQgeW91IG1pbmQgdG8gYWx3YXlzIG1lbnRpb24gd2hhdCB0ZXN0cyB5
b3UgaGF2ZSBiZWVuIGRvbmUgd2l0aCB0aGUNCj4gcGF0Y2hzZXQgaW4gdGhlIGNvdmVyIGxldHRl
cj8gIEl0J2xsIGJlIGZpbmUgdG8gc2F5IHRoYXQgeW91J3JlIHJ1bm5pbmcgdGhpcyBhZ2FpbnN0
IEZQR0FzDQo+IHNvIG5vIG9uZSBjb3VsZCByZWFsbHkgcmV0ZXN0IGl0LCBidXQgc3RpbGwgaXQg
d291bGQgYmUgZ29vZCB0byBrbm93IHRoYXQgYXMgd2VsbC4gIEl0J2xsDQo+IGV2ZW4gYmUgYmV0
dGVyIHRvIG1lbnRpb24gdGhhdCB3aGljaCBwYXJ0IG9mIHRoZSBzZXJpZXMgaXMgdG90YWxseSB1
bnRlc3RlZCBpZiB5b3UgYXJlDQo+IGF3YXJlIG9mLg0KDQpTdXJlLCBJIHNob3VsZCBoYXZlIGlu
Y2x1ZGVkIHRoZSB0ZXN0IHBhcnRzLiBXaWxsIGRvIGluIG5leHQgdmVyc2lvbi4NCg0KVGhhbmtz
LA0KWWkgTGl1DQo=
