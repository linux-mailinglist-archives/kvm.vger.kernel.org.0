Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 902ECF887B
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 07:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbfKLG11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 01:27:27 -0500
Received: from mga03.intel.com ([134.134.136.65]:20134 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725795AbfKLG11 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 01:27:27 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Nov 2019 22:27:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,295,1569308400"; 
   d="scan'208";a="253432080"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Nov 2019 22:27:25 -0800
Received: from FMSMSX110.amr.corp.intel.com (10.18.116.10) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 11 Nov 2019 22:27:25 -0800
Received: from shsmsx154.ccr.corp.intel.com (10.239.6.54) by
 fmsmsx110.amr.corp.intel.com (10.18.116.10) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 11 Nov 2019 22:27:25 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.127]) by
 SHSMSX154.ccr.corp.intel.com ([169.254.7.200]) with mapi id 14.03.0439.000;
 Tue, 12 Nov 2019 14:27:23 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Peter Xu <peterx@redhat.com>
CC:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: RE: [RFC v2 10/22] intel_iommu: add virtual command capability
 support
Thread-Topic: [RFC v2 10/22] intel_iommu: add virtual command capability
 support
Thread-Index: AQHVimsyhY7jFLVgM0KoETku2fYgDqd2IwOAgAgCthD//5SLgIAJdMGA
Date:   Tue, 12 Nov 2019 06:27:22 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A0F64FB@SHSMSX104.ccr.corp.intel.com>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <1571920483-3382-11-git-send-email-yi.l.liu@intel.com>
 <20191101180544.GF8888@xz-x1.metropole.lan>
 <A2975661238FB949B60364EF0F2C25743A0EF337@SHSMSX104.ccr.corp.intel.com>
 <20191106140055.GA29717@xz-x1>
In-Reply-To: <20191106140055.GA29717@xz-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNTViYzYwMDgtMjI1Yy00MDY3LWFjYzgtMTQ5OTQ4MThjNDVhIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiSHMwNDRoeTBjR0lHZzFjelhKcjE3RzJMcE0xTHlNdjBZdTFhWkI1Q1UrOHljbDgxb0JhbHlucmVGQWJzMzByaSJ9
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwg
Tm92ZW1iZXIgNiwgMjAxOSAxMDowMSBQTQ0KPiBUbzogTGl1LCBZaSBMIDx5aS5sLmxpdUBpbnRl
bC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUkZDIHYyIDEwLzIyXSBpbnRlbF9pb21tdTogYWRkIHZp
cnR1YWwgY29tbWFuZCBjYXBhYmlsaXR5IHN1cHBvcnQNCj4gDQo+IE9uIFdlZCwgTm92IDA2LCAy
MDE5IGF0IDEyOjQwOjQxUE0gKzAwMDAsIExpdSwgWWkgTCB3cm90ZToNCj4gPiA+DQo+ID4gPiBE
byB5b3Uga25vdyB3aGF0IHNob3VsZCBoYXBwZW4gb24gYmFyZS1tZXRhbCBmcm9tIHNwZWMtd2lz
ZSB0aGF0IHdoZW4NCj4gPiA+IHRoZSBndWVzdCBlLmcuIHdyaXRlcyAyIGJ5dGVzIHRvIHRoZXNl
IG1taW8gcmVnaW9ucz8NCj4gPg0KPiA+IEkndmUgbm8gaWRlYSB0byB5b3VyIHF1ZXN0aW9uLiBJ
dCBpcyBub3QgYSBiYXJlLW1ldGFsIGNhcGFiaWxpdHkuIFBlcnNvbmFsbHksIEkNCj4gPiBwcmVm
ZXIgdG8gaGF2ZSBhIHRvZ2dsZSBiaXQgdG8gbWFyayB0aGUgZnVsbCB3cml0dGVuIG9mIGEgY21k
IHRvIFZNQ0RfUkVHLg0KPiA+IFJlYXNvbiBpcyB0aGF0IHdlIGhhdmUgbm8gY29udHJvbCBvbiBn
dWVzdCBzb2Z0d2FyZS4gSXQgbWF5IHdyaXRlIG5ldyBjbWQNCj4gPiB0byBWQ01EX1JFRyBpbiBh
IGJhZCBtYW5uZXIuIGUuZy4gd3JpdGUgaGlnaCAzMiBiaXRzIGZpcnN0IGFuZCB0aGVuIHdyaXRl
IHRoZQ0KPiA+IGxvdyAzMiBiaXRzLiBUaGVuIGl0IHdpbGwgaGF2ZSB0d28gdHJhcHMuIEFwcGFy
ZW50bHksIGZvciB0aGUgZmlyc3QgdHJhcCwgaXQgZmlsbHMNCj4gPiBpbiB0aGUgVkNNRF9SRUcg
YW5kIG5vIG5lZWQgdG8gaGFuZGxlIGl0IHNpbmNlIGl0IGlzIG5vdCBhIGZ1bGwgd3JpdHRlbi4g
SSdtDQo+ID4gY2hlY2tpbmcgaXQgYW5kIGV2YWx1YXRpbmcgaXQuIEhvdyBkbyB5b3UgdGhpbmsg
b24gaXQ/DQo+IA0KPiBPaCBJIGp1c3Qgbm90aWNlZCB0aGF0IHZ0ZF9tZW1fb3BzLm1pbl9hY2Nl
c3Nfc2l6ZT09NCBub3cgc28gd3JpdHRpbmcNCj4gMkIgc2hvdWxkIG5ldmVyIGhhcHBlbiBhdCBs
ZWFzdC4gIFRoZW4gd2UnbGwgYmFpbCBvdXQgYXQNCj4gbWVtb3J5X3JlZ2lvbl9hY2Nlc3NfdmFs
aWQoKS4gIFNlZW1zIGZpbmUuDQoNCmdvdCBpdC4NCg0KPiANCj4gPg0KPiA+ID4NCj4gPiA+ID4g
KyAgICAgICAgaWYgKCF2dGRfaGFuZGxlX3ZjbWRfd3JpdGUocywgdmFsKSkgew0KPiA+ID4gPiAr
ICAgICAgICAgICAgdnRkX3NldF9sb25nKHMsIGFkZHIsIHZhbCk7DQo+ID4gPiA+ICsgICAgICAg
IH0NCj4gPiA+ID4gKyAgICAgICAgYnJlYWs7DQo+ID4gPiA+ICsNCj4gPiA+ID4gICAgICBkZWZh
dWx0Og0KPiA+ID4gPiAgICAgICAgICBpZiAoc2l6ZSA9PSA0KSB7DQo+ID4gPiA+ICAgICAgICAg
ICAgICB2dGRfc2V0X2xvbmcocywgYWRkciwgdmFsKTsNCj4gPiA+ID4gQEAgLTM2MTcsNyArMzc2
OSw4IEBAIHN0YXRpYyB2b2lkIHZ0ZF9pbml0KEludGVsSU9NTVVTdGF0ZSAqcykNCj4gPiA+ID4g
ICAgICAgICAgICAgIHMtPmVjYXAgfD0gVlREX0VDQVBfU01UUyB8IFZURF9FQ0FQX1NSUyB8IFZU
RF9FQ0FQX1NMVFM7DQo+ID4gPiA+ICAgICAgICAgIH0gZWxzZSBpZiAoIXN0cmNtcChzLT5zY2Fs
YWJsZV9tb2RlLCAibW9kZXJuIikpIHsNCj4gPiA+ID4gICAgICAgICAgICAgIHMtPmVjYXAgfD0g
VlREX0VDQVBfU01UUyB8IFZURF9FQ0FQX1NSUyB8IFZURF9FQ0FQX1BBU0lEDQo+ID4gPiA+IC0g
ICAgICAgICAgICAgICAgICAgICAgIHwgVlREX0VDQVBfRkxUUyB8IFZURF9FQ0FQX1BTUzsNCj4g
PiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgfCBWVERfRUNBUF9GTFRTIHwgVlREX0VDQVBf
UFNTIHwgVlREX0VDQVBfVkNTOw0KPiA+ID4gPiArICAgICAgICAgICAgcy0+dmNjYXAgfD0gVlRE
X1ZDQ0FQX1BBUzsNCj4gPiA+ID4gICAgICAgICAgfQ0KPiA+ID4gPiAgICAgIH0NCj4gPiA+ID4N
Cj4gPiA+DQo+ID4gPiBbLi4uXQ0KPiA+ID4NCj4gPiA+ID4gKyNkZWZpbmUgVlREX1ZDTURfQ01E
X01BU0sgICAgICAgICAgIDB4ZmZVTA0KPiA+ID4gPiArI2RlZmluZSBWVERfVkNNRF9QQVNJRF9W
QUxVRSh2YWwpICAgKCgodmFsKSA+PiA4KSAmIDB4ZmZmZmYpDQo+ID4gPiA+ICsNCj4gPiA+ID4g
KyNkZWZpbmUgVlREX1ZDUlNQX1JTTFQodmFsKSAgICAgICAgICgodmFsKSA8PCA4KQ0KPiA+ID4g
PiArI2RlZmluZSBWVERfVkNSU1BfU0ModmFsKSAgICAgICAgICAgKCgodmFsKSAmIDB4MykgPDwg
MSkNCj4gPiA+ID4gKw0KPiA+ID4gPiArI2RlZmluZSBWVERfVkNNRF9VTkRFRklORURfQ01EICAg
ICAgICAgMVVMTA0KPiA+ID4gPiArI2RlZmluZSBWVERfVkNNRF9OT19BVkFJTEFCTEVfUEFTSUQg
ICAgMlVMTA0KPiA+ID4NCj4gPiA+IEFjY29yZGluZyB0byAxMC40LjQ0IC0gc2hvdWxkIHRoaXMg
YmUgMT8NCj4gPg0KPiA+IEl0J3MgMiBub3cgcGVyIFZULWQgc3BlYyAzLjEgKDIwMTkgSnVuZSku
IEkgc2hvdWxkIGhhdmUgbWVudGlvbmVkIGl0IGluIHRoZSBjb3Zlcg0KPiA+IGxldHRlci4uLg0K
PiANCj4gV2VsbCB5b3UncmUgcmlnaHQuLi4gSSBob3BlIHRoZXJlIHdvbid0IGJlIG90aGVyICJt
YWpvciIgdGhpbmdzIGdldA0KPiBjaGFuZ2VkIG90aGVyd2lzZSBpdCdsbCBiZSByZWFsbHkgYSBw
YWluIG9mIHdvcmtpbmcgb24gYWxsIG9mIHRoZXNlDQo+IGJlZm9yZSB0aGluZ3Mgc2V0dGxlLi4u
DQoNCkFzIGZhciBhcyBJIGtub3csIG9ubHkgdGhpcyBwYXJ0IGhhcyBzaWduaWZpY2FudCBjaGFu
Z2UuIE90aGVyIHBhcnRzIGFyZSBjb25zaXN0ZW50Lg0KSSdsbCBtZW50aW9uIHNwZWMgdmVyc2lv
biBuZXh0IHRpbWUgaW4gdGhlIGNvdmVyIGxldHRlci4NCg0KVGhhbmtzLA0KWWkgTGl1DQoNCg==
