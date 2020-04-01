Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D613019A4EB
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 07:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731766AbgDAFtA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 01:49:00 -0400
Received: from mga12.intel.com ([192.55.52.136]:26449 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731680AbgDAFtA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 01:49:00 -0400
IronPort-SDR: r+3BODFmMufW3RW++NP/1qV/WJiub9X6caTXzDePWiInSV0YZ53BtXB9RPcMDswsSUIGa+i1Zs
 7nqsLadf1mkw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2020 22:48:58 -0700
IronPort-SDR: 7F7PdIS2xCZmhzkXLJ3uAcW5TFuJwjdoFIa5fbsUlAHxTjs+DLBgtElBuNQEzzo3uSmyUEzJO4
 hqka6yWk4X3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,330,1580803200"; 
   d="scan'208";a="238014662"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga007.jf.intel.com with ESMTP; 31 Mar 2020 22:48:57 -0700
Received: from fmsmsx121.amr.corp.intel.com (10.18.125.36) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 31 Mar 2020 22:48:57 -0700
Received: from shsmsx105.ccr.corp.intel.com (10.239.4.158) by
 fmsmsx121.amr.corp.intel.com (10.18.125.36) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 31 Mar 2020 22:48:57 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX105.ccr.corp.intel.com ([169.254.11.213]) with mapi id 14.03.0439.000;
 Wed, 1 Apr 2020 13:48:53 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>
CC:     "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>
Subject: RE: [PATCH v1 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
Thread-Topic: [PATCH v1 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
Thread-Index: AQHWAEUbC4GB74LMekup8jIcF6WIFqhgVMYAgACL5QCAANaCgIAAmyhQgAD31QCAAIZ4AA==
Date:   Wed, 1 Apr 2020 05:48:52 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A21C370@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
 <1584880325-10561-2-git-send-email-yi.l.liu@intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D7FF378@SHSMSX104.ccr.corp.intel.com>
 <A2975661238FB949B60364EF0F2C25743A2184AE@SHSMSX104.ccr.corp.intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D801104@SHSMSX104.ccr.corp.intel.com>
 <A2975661238FB949B60364EF0F2C25743A21B065@SHSMSX104.ccr.corp.intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D803B6A@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D803B6A@SHSMSX104.ccr.corp.intel.com>
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

PiBGcm9tOiBUaWFuLCBLZXZpbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+IFNlbnQ6IFdlZG5l
c2RheSwgQXByaWwgMSwgMjAyMCAxOjQzIFBNDQo+IFRvOiBMaXUsIFlpIEwgPHlpLmwubGl1QGlu
dGVsLmNvbT47IGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tOw0KPiBTdWJqZWN0OiBSRTogW1BB
VENIIHYxIDEvOF0gdmZpbzogQWRkIFZGSU9fSU9NTVVfUEFTSURfUkVRVUVTVChhbGxvYy9mcmVl
KQ0KPiANCj4gPiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gPiBTZW50
OiBUdWVzZGF5LCBNYXJjaCAzMSwgMjAyMCA5OjIyIFBNDQo+ID4NCj4gPiA+IEZyb206IFRpYW4s
IEtldmluIDxrZXZpbi50aWFuQGludGVsLmNvbT4NCj4gPiA+IFNlbnQ6IFR1ZXNkYXksIE1hcmNo
IDMxLCAyMDIwIDE6NDEgUE0NCj4gPiA+IFRvOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNv
bT47IGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tOw0KPiA+ID4gZXJpYy5hdWdlckByZWRoYXQu
Y29tDQo+ID4gPiBTdWJqZWN0OiBSRTogW1BBVENIIHYxIDEvOF0gdmZpbzogQWRkDQo+ID4gVkZJ
T19JT01NVV9QQVNJRF9SRVFVRVNUKGFsbG9jL2ZyZWUpDQo+ID4gPg0KPiA+ID4gPiBGcm9tOiBM
aXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gPiA+ID4gU2VudDogTW9uZGF5LCBNYXJj
aCAzMCwgMjAyMCAxMDozNyBQTQ0KPiA+ID4gPg0KPiA+ID4gPiA+IEZyb206IFRpYW4sIEtldmlu
IDxrZXZpbi50aWFuQGludGVsLmNvbT4NCj4gPiA+ID4gPiBTZW50OiBNb25kYXksIE1hcmNoIDMw
LCAyMDIwIDQ6MzIgUE0NCj4gPiA+ID4gPiBUbzogTGl1LCBZaSBMIDx5aS5sLmxpdUBpbnRlbC5j
b20+OyBhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbTsNCj4gPiA+ID4gPiBTdWJqZWN0OiBSRTog
W1BBVENIIHYxIDEvOF0gdmZpbzogQWRkDQo+ID4gPiA+IFZGSU9fSU9NTVVfUEFTSURfUkVRVUVT
VChhbGxvYy9mcmVlKQ0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBGcm9tOiBMaXUsIFlpIEwgPHlp
LmwubGl1QGludGVsLmNvbT4NCj4gPiA+ID4gPiA+IFNlbnQ6IFN1bmRheSwgTWFyY2ggMjIsIDIw
MjAgODozMiBQTQ0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IEZyb206IExpdSBZaSBMIDx5aS5s
LmxpdUBpbnRlbC5jb20+DQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gRm9yIGEgbG9uZyB0aW1l
LCBkZXZpY2VzIGhhdmUgb25seSBvbmUgRE1BIGFkZHJlc3Mgc3BhY2UgZnJvbQ0KPiA+ID4gPiA+
ID4gcGxhdGZvcm0gSU9NTVUncyBwb2ludCBvZiB2aWV3LiBUaGlzIGlzIHRydWUgZm9yIGJvdGgg
YmFyZQ0KPiA+ID4gPiA+ID4gbWV0YWwgYW5kIGRpcmVjdGVkLSBhY2Nlc3MgaW4gdmlydHVhbGl6
YXRpb24gZW52aXJvbm1lbnQuDQo+ID4gPiA+ID4gPiBSZWFzb24gaXMgdGhlIHNvdXJjZSBJRCBv
ZiBETUEgaW4gUENJZSBhcmUgQkRGIChidXMvZGV2L2ZuYw0KPiA+ID4gPiA+ID4gSUQpLCB3aGlj
aCByZXN1bHRzIGluIG9ubHkgZGV2aWNlIGdyYW51bGFyaXR5DQpbLi4uXQ0KPiA+ID4NCj4gPiA+
ID4NCj4gPiA+ID4gPiA+ICsNCj4gPiA+ID4gPiA+ICsJCXN3aXRjaCAocmVxLmZsYWdzICYgVkZJ
T19QQVNJRF9SRVFVRVNUX01BU0spIHsNCj4gPiA+ID4gPiA+ICsJCWNhc2UgVkZJT19JT01NVV9Q
QVNJRF9BTExPQzoNCj4gPiA+ID4gPiA+ICsJCXsNCj4gPiA+ID4gPiA+ICsJCQlpbnQgcmV0ID0g
MCwgcmVzdWx0Ow0KPiA+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ID4gKwkJCXJlc3VsdCA9DQo+ID4g
dmZpb19pb21tdV90eXBlMV9wYXNpZF9hbGxvYyhpb21tdSwNCj4gPiA+ID4gPiA+ICsNCj4gPiAJ
cmVxLmFsbG9jX3Bhc2lkLm1pbiwNCj4gPiA+ID4gPiA+ICsNCj4gPiAJcmVxLmFsbG9jX3Bhc2lk
Lm1heCk7DQo+ID4gPiA+ID4gPiArCQkJaWYgKHJlc3VsdCA+IDApIHsNCj4gPiA+ID4gPiA+ICsJ
CQkJb2Zmc2V0ID0gb2Zmc2V0b2YoDQo+ID4gPiA+ID4gPiArCQkJCQlzdHJ1Y3QNCj4gPiA+ID4g
PiA+IHZmaW9faW9tbXVfdHlwZTFfcGFzaWRfcmVxdWVzdCwNCj4gPiA+ID4gPiA+ICsJCQkJCWFs
bG9jX3Bhc2lkLnJlc3VsdCk7DQo+ID4gPiA+ID4gPiArCQkJCXJldCA9IGNvcHlfdG9fdXNlcigN
Cj4gPiA+ID4gPiA+ICsJCQkJCSAgICAgICh2b2lkIF9fdXNlciAqKSAoYXJnICsNCj4gPiBvZmZz
ZXQpLA0KPiA+ID4gPiA+ID4gKwkJCQkJICAgICAgJnJlc3VsdCwgc2l6ZW9mKHJlc3VsdCkpOw0K
PiA+ID4gPiA+ID4gKwkJCX0gZWxzZSB7DQo+ID4gPiA+ID4gPiArCQkJCXByX2RlYnVnKCIlczog
UEFTSUQgYWxsb2MgZmFpbGVkXG4iLA0KPiA+ID4gPiA+ID4gX19mdW5jX18pOw0KPiA+ID4gPiA+
ID4gKwkJCQlyZXQgPSAtRUZBVUxUOw0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gbm8sIHRoaXMgYnJh
bmNoIGlzIG5vdCBmb3IgY29weV90b191c2VyIGVycm9yLiBpdCBpcyBhYm91dCBwYXNpZA0KPiA+
ID4gPiA+IGFsbG9jIGZhaWx1cmUuIHlvdSBzaG91bGQgaGFuZGxlIGJvdGguDQo+ID4gPiA+DQo+
ID4gPiA+IEVtbW0sIEkganVzdCB3YW50IHRvIGZhaWwgdGhlIElPQ1RMIGluIHN1Y2ggY2FzZSwg
c28gdGhlIEByZXN1bHQNCj4gPiA+ID4gZmllbGQgaXMgbWVhbmluZ2xlc3MgaW4gdGhlIHVzZXIg
c2lkZS4gSG93IGFib3V0IHVzaW5nIGFub3RoZXINCj4gPiA+ID4gcmV0dXJuIHZhbHVlIChlLmcu
IEVOT1NQQykgdG8gaW5kaWNhdGUgdGhlIElPQ1RMIGZhaWx1cmU/DQo+ID4gPg0KPiA+ID4gSWYg
cGFzaWRfYWxsb2MgZmFpbHMsIHlvdSByZXR1cm4gaXRzIHJlc3VsdCB0byB1c2Vyc3BhY2UgaWYN
Cj4gPiA+IGNvcHlfdG9fdXNlciBmYWlscywgdGhlbiByZXR1cm4gLUVGQVVMVC4NCj4gPiA+DQo+
ID4gPiBob3dldmVyLCBhYm92ZSB5b3UgcmV0dXJuIC1FRkFVTFQgZm9yIHBhc2lkX2FsbG9jIGZh
aWx1cmUsIGFuZCB0aGVuDQo+ID4gPiB0aGUgbnVtYmVyIG9mIG5vdC1jb3BpZWQgYnl0ZXMgZm9y
IGNvcHlfdG9fdXNlci4NCj4gPg0KPiA+IG5vdCBxdWl0ZSBnZXQuIExldCBtZSByZS1wYXN0ZSB0
aGUgY29kZS4gOi0pDQo+ID4NCj4gPiArCQljYXNlIFZGSU9fSU9NTVVfUEFTSURfQUxMT0M6DQo+
ID4gKwkJew0KPiA+ICsJCQlpbnQgcmV0ID0gMCwgcmVzdWx0Ow0KPiA+ICsNCj4gPiArCQkJcmVz
dWx0ID0gdmZpb19pb21tdV90eXBlMV9wYXNpZF9hbGxvYyhpb21tdSwNCj4gPiArCQkJCQkJCXJl
cS5hbGxvY19wYXNpZC5taW4sDQo+ID4gKwkJCQkJCQlyZXEuYWxsb2NfcGFzaWQubWF4KTsNCj4g
PiArCQkJaWYgKHJlc3VsdCA+IDApIHsNCj4gPiArCQkJCW9mZnNldCA9IG9mZnNldG9mKA0KPiA+
ICsJCQkJCXN0cnVjdA0KPiA+IHZmaW9faW9tbXVfdHlwZTFfcGFzaWRfcmVxdWVzdCwNCj4gPiAr
CQkJCQlhbGxvY19wYXNpZC5yZXN1bHQpOw0KPiA+ICsJCQkJcmV0ID0gY29weV90b191c2VyKA0K
PiA+ICsJCQkJCSAgICAgICh2b2lkIF9fdXNlciAqKSAoYXJnICsgb2Zmc2V0KSwNCj4gPiArCQkJ
CQkgICAgICAmcmVzdWx0LCBzaXplb2YocmVzdWx0KSk7DQo+ID4gaWYgY29weV90b191c2VyIGZh
aWxlZCwgcmV0IGlzIHRoZSBudW1iZXIgb2YgdW5jb3BpZWQgYnl0ZXMgYW5kIHdpbGwNCj4gPiBi
ZSByZXR1cm5lZCB0byB1c2Vyc3BhY2UgdG8gaW5kaWNhdGUgZmFpbHVyZS4gdXNlcnNwYWNlIHdp
bGwgbm90IHVzZQ0KPiA+IHRoZSBkYXRhIGluIHJlc3VsdCBmaWVsZC4gcGVyaGFwcywgSSBzaG91
bGQgY2hlY2sgdGhlIHJldCBoZXJlIGFuZA0KPiA+IHJldHVybiAtRUZBVUxUIG9yIGFub3RoZXIg
ZXJybm8sIGluc3RlYWQgb2YgcmV0dXJuIHRoZSBudW1iZXIgb2YNCj4gPiB1bi1jb3BpZWQgYnl0
ZXMuDQo+IA0KPiBoZXJlIHNob3VsZCByZXR1cm4gLUVGQVVMVC4NCg0KZ290IGl0LiBzbyBpZiBh
bnkgZmFpbHVyZSwgdGhlIHJldHVybiB2YWx1ZSBvZiB0aGlzIGlvY3RsIGlzIGEgLUVSUk9SX1ZB
TC4NCg0KPiANCj4gPiArCQkJfSBlbHNlIHsNCj4gPiArCQkJCXByX2RlYnVnKCIlczogUEFTSUQg
YWxsb2MgZmFpbGVkXG4iLA0KPiA+IF9fZnVuY19fKTsNCj4gPiArCQkJCXJldCA9IC1FRkFVTFQ7
DQo+ID4gaWYgdmZpb19pb21tdV90eXBlMV9wYXNpZF9hbGxvYygpIGZhaWxlZCwgbm8gZG91YnQs
IHJldHVybiAtRUZBVUxUIHRvDQo+ID4gdXNlcnNwYWNlIHRvIGluZGljYXRlIGZhaWx1cmUuDQo+
IA0KPiBwYXNpZF9hbGxvYyBoYXMgaXRzIG93biBlcnJvciB0eXBlcyByZXR1cm5lZC4gd2h5IGJs
aW5kbHkgcmVwbGFjZSBpdCB3aXRoIC1FRkFVTFQ/DQoNCnJpZ2h0LCBzaG91bGQgdXNlIGl0cyBv
d24gZXJyb3IgdHlwZXMuDQoNClRoYW5rcywNCllpIExpdQ0K
