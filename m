Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD45BD926
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 09:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633961AbfIYHcx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 03:32:53 -0400
Received: from mga05.intel.com ([192.55.52.43]:32052 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405164AbfIYHcx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 03:32:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 00:32:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,547,1559545200"; 
   d="scan'208";a="364246016"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga005.jf.intel.com with ESMTP; 25 Sep 2019 00:32:51 -0700
Received: from shsmsx103.ccr.corp.intel.com (10.239.4.69) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 25 Sep 2019 00:32:51 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.32]) by
 SHSMSX103.ccr.corp.intel.com ([169.254.4.140]) with mapi id 14.03.0439.000;
 Wed, 25 Sep 2019 15:32:49 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>, Peter Xu <peterx@redhat.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: RE: [RFC PATCH 2/4] iommu/vt-d: Add first level page table
 interfaces
Thread-Topic: [RFC PATCH 2/4] iommu/vt-d: Add first level page table
 interfaces
Thread-Index: AQHVcgpDf16VDDZMQk6x5RWfK5mI2qc5MXAAgABWBICAAcJfAIAAh6Ig//+HOwCAABizAIAAjr3w
Date:   Wed, 25 Sep 2019 07:32:48 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D58F4EA@SHSMSX104.ccr.corp.intel.com>
References: <20190923122454.9888-1-baolu.lu@linux.intel.com>
 <20190923122454.9888-3-baolu.lu@linux.intel.com>
 <20190923203102.GB21816@araj-mobl1.jf.intel.com>
 <9cfe6042-f0fb-ea5e-e134-f6f5bb9eb7b0@linux.intel.com>
 <20190925043050.GK28074@xz-x1>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D58F018@SHSMSX104.ccr.corp.intel.com>
 <20190925052402.GM28074@xz-x1>
 <1713f03c-4d47-34ad-f36d-882645c36389@linux.intel.com>
In-Reply-To: <1713f03c-4d47-34ad-f36d-882645c36389@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiY2U4YmU0ZmUtZDYzZS00ZjE4LWExZjctMTJkMzE0OTI5ZWIwIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiQjAzc0c5Y3ZcL01KUnQ3QmQyR2hyUUdDVkVaY3J4TEUzcGJTZjZoYzM4MDdzcGVnXC9Kcm5MZ1RYbXNHcDZGNGVuIn0=
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMdSBCYW9sdSBbbWFpbHRvOmJhb2x1Lmx1QGxpbnV4LmludGVsLmNvbV0NCj4gU2Vu
dDogV2VkbmVzZGF5LCBTZXB0ZW1iZXIgMjUsIDIwMTkgMjo1MiBQTQ0KPiANCj4gSGkgUGV0ZXIg
YW5kIEtldmluLA0KPiANCj4gT24gOS8yNS8xOSAxOjI0IFBNLCBQZXRlciBYdSB3cm90ZToNCj4g
PiBPbiBXZWQsIFNlcCAyNSwgMjAxOSBhdCAwNDozODozMUFNICswMDAwLCBUaWFuLCBLZXZpbiB3
cm90ZToNCj4gPj4+IEZyb206IFBldGVyIFh1IFttYWlsdG86cGV0ZXJ4QHJlZGhhdC5jb21dDQo+
ID4+PiBTZW50OiBXZWRuZXNkYXksIFNlcHRlbWJlciAyNSwgMjAxOSAxMjozMSBQTQ0KPiA+Pj4N
Cj4gPj4+IE9uIFR1ZSwgU2VwIDI0LCAyMDE5IGF0IDA5OjM4OjUzQU0gKzA4MDAsIEx1IEJhb2x1
IHdyb3RlOg0KPiA+Pj4+Pj4gaW50ZWxfbW1tYXBfcmFuZ2UoZG9tYWluLCBhZGRyLCBlbmQsIHBo
eXNfYWRkciwgcHJvdCkNCj4gPj4+Pj4NCj4gPj4+Pj4gTWF5YmUgdGhpbmsgb2YgYSBkaWZmZXJl
bnQgbmFtZS4uPyBtbW1hcCBzZWVtcyBhIGJpdCB3ZWlyZCA6LSkNCj4gPj4+Pg0KPiA+Pj4+IFll
cy4gSSBkb24ndCBsaWtlIGl0IGVpdGhlci4gSSd2ZSB0aG91Z2h0IGFib3V0IGl0IGFuZCBoYXZl
bid0DQo+ID4+Pj4gZmlndXJlZCBvdXQgYSBzYXRpc2ZpZWQgb25lLiBEbyB5b3UgaGF2ZSBhbnkg
c3VnZ2VzdGlvbnM/DQo+ID4+Pg0KPiA+Pj4gSG93IGFib3V0IGF0IGxlYXN0IHNwbGl0IHRoZSB3
b3JkIHVzaW5nICJfIj8gIExpa2UgIm1tX21hcCIsIHRoZW4NCj4gPj4+IGFwcGx5IGl0IHRvIGFs
bCB0aGUgIm1tbSoiIHByZWZpeGVzLiAgT3RoZXJ3aXNlIGl0J2xsIGJlIGVhc2lseQ0KPiA+Pj4g
bWlzcmVhZCBhcyBtbWFwKCkgd2hpY2ggaXMgdG90YWxseSBpcnJlbGV2YW50IHRvIHRoaXMuLi4N
Cj4gPj4+DQo+ID4+DQo+ID4+IHdoYXQgaXMgdGhlIHBvaW50IG9mIGtlZXBpbmcgJ21tJyBoZXJl
PyByZXBsYWNlIGl0IHdpdGggJ2lvbW11Jz8NCj4gPg0KPiA+IEknbSBub3Qgc3VyZSBvZiB3aGF0
IEJhb2x1IHRob3VnaHQsIGJ1dCB0byBtZSAibW0iIG1ha2VzIHNlbnNlIGl0c2VsZg0KPiA+IHRv
IGlkZW50aWZ5IHRoaXMgZnJvbSByZWFsIElPTU1VIHBhZ2UgdGFibGVzIChiZWNhdXNlIElJVUMg
dGhlc2Ugd2lsbA0KPiA+IGJlIE1NVSBwYWdlIHRhYmxlcykuICBXZSBjYW4gY29tZSB1cCB3aXRo
IGJldHRlciBuYW1lcywgYnV0IElNSE8NCj4gPiAiaW9tbXUiIGNhbiBiZSBhIGJpdCBtaXNsZWFk
aW5nIHRvIGxldCBwZW9wbGUgcmVmZXIgdG8gdGhlIDJuZCBsZXZlbA0KPiA+IHBhZ2UgdGFibGUu
DQo+IA0KPiAibW0iIHJlcHJlc2VudHMgYSBDUFUgKGZpcnN0IGxldmVsKSBwYWdlIHRhYmxlOw0K
PiANCj4gdnMuDQo+IA0KPiAiaW8iIHJlcHJlc2VudHMgYW4gSU9NTVUgKHNlY29uZCBsZXZlbCkg
cGFnZSB0YWJsZS4NCj4gDQoNCklPTU1VIGZpcnN0IGxldmVsIGlzIG5vdCBlcXVpdmFsZW50IHRv
IENQVSBwYWdlIHRhYmxlLCB0aG91Z2ggeW91IGNhbg0KdXNlIHRoZSBsYXR0ZXIgYXMgdGhlIGZp
cnN0IGxldmVsIChlLmcuIGluIFNWQSkuIEVzcGVjaWFsbHkgaGVyZSB5b3UgYXJlDQptYWtpbmcg
SU9WQS0+R1BBIGFzIHRoZSBmaXJzdCBsZXZlbCwgd2hpY2ggaXMgbm90IENQVSBwYWdlIHRhYmxl
Lg0KDQpidHcgYm90aCBsZXZlbHMgYXJlIGZvciAiaW8iIGkuZS4gRE1BIHB1cnBvc2VzIGZyb20g
VlQtZCBwLm8udi4gVGhleQ0KYXJlIGp1c3QgaGllcmFyY2hpY2FsIHN0cnVjdHVyZXMgaW1wbGVt
ZW50ZWQgYnkgVlQtZCwgd2l0aCBzbGlnaHRseQ0KZGlmZmVyZW50IGZvcm1hdC4gVGhlIHNwZWNp
ZmljYXRpb24gZG9lc24ndCBsaW1pdCBob3cgeW91IHVzZSB0aGVtIGZvci4NCkluIGEgaHlwb3Ro
ZXRpY2FsIGNhc2UsIGFuIElPTU1VIG1heSBpbXBsZW1lbnQgZXhhY3RseSBzYW1lIENQVS1wYWdl
LQ0KdGFibGUgZm9ybWF0IGFuZCBzdXBwb3J0IHBhZ2UgZmF1bHRzIGZvciBib3RoIGxldmVscy4g
VGhlbiB5b3UgY2FuIGV2ZW4NCmxpbmsgdGhlIENQVSBwYWdlIHRhYmxlIHRvIHRoZSAybmQgbGV2
ZWwgZm9yIHN1cmUuDQoNCk1heWJlIHdlIGp1c3QgbmFtZSBpdCBmcm9tIFZULWQgY29udGV4dCwg
ZS5nLiBpbnRlbF9tYXBfZmlyc3RfbGV2ZWxfcmFuZ2UsDQpJbnRlbF9tYXBfc2Vjb25kX2xldmVs
X3JhbmdlLCBhbmQgdGhlbiByZWdpc3RlciB0aGVtIGFzIGRtYXIgZG9tYWluDQpjYWxsYmFjayBh
cyB5b3UgcmVwbGllZCBpbiBhbm90aGVyIG1haWwuDQoNClRoYW5rcw0KS2V2aW4NCg==
