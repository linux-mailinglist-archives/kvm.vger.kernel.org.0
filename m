Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF6FBD910
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 09:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442564AbfIYHVz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 03:21:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:27957 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2442413AbfIYHVz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 03:21:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 00:21:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,547,1559545200"; 
   d="scan'208";a="183169136"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga008.jf.intel.com with ESMTP; 25 Sep 2019 00:21:54 -0700
Received: from fmsmsx118.amr.corp.intel.com (10.18.116.18) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 25 Sep 2019 00:21:53 -0700
Received: from shsmsx153.ccr.corp.intel.com (10.239.6.53) by
 fmsmsx118.amr.corp.intel.com (10.18.116.18) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 25 Sep 2019 00:21:53 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.32]) by
 SHSMSX153.ccr.corp.intel.com ([169.254.12.235]) with mapi id 14.03.0439.000;
 Wed, 25 Sep 2019 15:21:51 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Peter Xu <peterx@redhat.com>, Lu Baolu <baolu.lu@linux.intel.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: RE: [RFC PATCH 0/4] Use 1st-level for DMA remapping in guest
Thread-Topic: [RFC PATCH 0/4] Use 1st-level for DMA remapping in guest
Thread-Index: AQHVcgo/pYehEUSjBUSa7tc1tTv1E6c5H56AgAAQYQCAATS/kIAAyIAAgABFVACAAIvPkA==
Date:   Wed, 25 Sep 2019 07:21:51 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D58F4A3@SHSMSX104.ccr.corp.intel.com>
References: <20190923122454.9888-1-baolu.lu@linux.intel.com>
 <20190923122715.53de79d0@jacob-builder>
 <20190923202552.GA21816@araj-mobl1.jf.intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D58D1F1@SHSMSX104.ccr.corp.intel.com>
 <dfd9b7a2-5553-328a-08eb-16c8a3a2644e@linux.intel.com>
 <20190925065640.GO28074@xz-x1>
In-Reply-To: <20190925065640.GO28074@xz-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNWZmNjcyZDAtZDI5YS00ODVhLWI4ZWItMDVlMDgyZDQwNzRlIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiMkNVbEFZR3BSQ0ZsNUZ0bW8xYTI0RXllYllTZVZRQ3VRZ29SeHh5YkpVTytKdkd5ODZISW9TeFpDMlFsVllWRiJ9
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

PiBGcm9tOiBQZXRlciBYdSBbbWFpbHRvOnBldGVyeEByZWRoYXQuY29tXQ0KPiBTZW50OiBXZWRu
ZXNkYXksIFNlcHRlbWJlciAyNSwgMjAxOSAyOjU3IFBNDQo+IA0KPiBPbiBXZWQsIFNlcCAyNSwg
MjAxOSBhdCAxMDo0ODozMkFNICswODAwLCBMdSBCYW9sdSB3cm90ZToNCj4gPiBIaSBLZXZpbiwN
Cj4gPg0KPiA+IE9uIDkvMjQvMTkgMzowMCBQTSwgVGlhbiwgS2V2aW4gd3JvdGU6DQo+ID4gPiA+
ID4gPiAgICAgICAnLS0tLS0tLS0tLS0nDQo+ID4gPiA+ID4gPiAgICAgICAnLS0tLS0tLS0tLS0n
DQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gVGhpcyBwYXRjaCBzZXJpZXMgb25seSBhaW1zIHRv
IGFjaGlldmUgdGhlIGZpcnN0IGdvYWwsIGEuay5hIHVzaW5nDQo+ID4gPiBmaXJzdCBnb2FsPyB0
aGVuIHdoYXQgYXJlIG90aGVyIGdvYWxzPyBJIGRpZG4ndCBzcG90IHN1Y2ggaW5mb3JtYXRpb24u
DQo+ID4gPg0KPiA+DQo+ID4gVGhlIG92ZXJhbGwgZ29hbCBpcyB0byB1c2UgSU9NTVUgbmVzdGVk
IG1vZGUgdG8gYXZvaWQgc2hhZG93IHBhZ2UNCj4gdGFibGUNCj4gPiBhbmQgVk1FWElUIHdoZW4g
bWFwIGFuIGdJT1ZBLiBUaGlzIGluY2x1ZGVzIGJlbG93IDQgc3RlcHMgKG1heWJlIG5vdA0KPiA+
IGFjY3VyYXRlLCBidXQgeW91IGNvdWxkIGdldCB0aGUgcG9pbnQuKQ0KPiA+DQo+ID4gMSkgR0lP
VkEgbWFwcGluZ3Mgb3ZlciAxc3QtbGV2ZWwgcGFnZSB0YWJsZTsNCj4gPiAyKSBiaW5kaW5nIHZJ
T01NVSAxc3QgbGV2ZWwgcGFnZSB0YWJsZSB0byB0aGUgcElPTU1VOw0KPiA+IDMpIHVzaW5nIHBJ
T01NVSBzZWNvbmQgbGV2ZWwgZm9yIEdQQS0+SFBBIHRyYW5zbGF0aW9uOw0KPiA+IDQpIGVuYWJs
ZSBuZXN0ZWQgKGEuay5hLiBkdWFsIHN0YWdlKSB0cmFuc2xhdGlvbiBpbiBob3N0Lg0KPiA+DQo+
ID4gVGhpcyBwYXRjaCBzZXQgYWltcyB0byBhY2hpZXZlIDEpLg0KPiANCj4gV291bGQgaXQgbWFr
ZSBzZW5zZSB0byB1c2UgMXN0IGxldmVsIGV2ZW4gZm9yIGJhcmUtbWV0YWwgdG8gcmVwbGFjZQ0K
PiB0aGUgMm5kIGxldmVsPw0KPiANCj4gV2hhdCBJJ20gdGhpbmtpbmcgaXMgdGhlIERQREsgYXBw
cyAtIHRoZXkgaGF2ZSBNTVUgcGFnZSB0YWJsZSBhbHJlYWR5DQo+IHRoZXJlIGZvciB0aGUgaHVn
ZSBwYWdlcywgdGhlbiBpZiB0aGV5IGNhbiB1c2UgMXN0IGxldmVsIGFzIHRoZQ0KPiBkZWZhdWx0
IGRldmljZSBwYWdlIHRhYmxlIHRoZW4gaXQgZXZlbiBkb2VzIG5vdCBuZWVkIHRvIG1hcCwgYmVj
YXVzZQ0KPiBpdCBjYW4gc2ltcGx5IGJpbmQgdGhlIHByb2Nlc3Mgcm9vdCBwYWdlIHRhYmxlIHBv
aW50ZXIgdG8gdGhlIDFzdA0KPiBsZXZlbCBwYWdlIHJvb3QgcG9pbnRlciBvZiB0aGUgZGV2aWNl
IGNvbnRleHRzIHRoYXQgaXQgdXNlcy4NCj4gDQoNClRoZW4geW91IG5lZWQgYmVhciB3aXRoIHBv
c3NpYmxlIHBhZ2UgZmF1bHRzIGZyb20gdXNpbmcgQ1BVIHBhZ2UNCnRhYmxlLCB3aGlsZSBtb3N0
IGRldmljZXMgZG9uJ3Qgc3VwcG9ydCBpdCB0b2RheS4gDQoNClRoYW5rcw0KS2V2aW4NCg==
