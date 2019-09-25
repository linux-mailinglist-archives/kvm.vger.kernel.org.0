Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA34EBD97A
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 10:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633992AbfIYIC1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 04:02:27 -0400
Received: from mga17.intel.com ([192.55.52.151]:55094 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437609AbfIYIC1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 04:02:27 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 01:02:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,547,1559545200"; 
   d="scan'208";a="340335542"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga004.jf.intel.com with ESMTP; 25 Sep 2019 01:02:25 -0700
Received: from fmsmsx102.amr.corp.intel.com (10.18.124.200) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 25 Sep 2019 01:02:25 -0700
Received: from shsmsx101.ccr.corp.intel.com (10.239.4.153) by
 FMSMSX102.amr.corp.intel.com (10.18.124.200) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 25 Sep 2019 01:02:24 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.32]) by
 SHSMSX101.ccr.corp.intel.com ([169.254.1.92]) with mapi id 14.03.0439.000;
 Wed, 25 Sep 2019 16:02:23 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Peter Xu <peterx@redhat.com>
CC:     Lu Baolu <baolu.lu@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
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
Thread-Index: AQHVcgo/pYehEUSjBUSa7tc1tTv1E6c5H56AgAAQYQCAATS/kIAAyIAAgABFVACAAIvPkP//gbuAgACG17A=
Date:   Wed, 25 Sep 2019 08:02:23 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D58F5F5@SHSMSX104.ccr.corp.intel.com>
References: <20190923122454.9888-1-baolu.lu@linux.intel.com>
 <20190923122715.53de79d0@jacob-builder>
 <20190923202552.GA21816@araj-mobl1.jf.intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D58D1F1@SHSMSX104.ccr.corp.intel.com>
 <dfd9b7a2-5553-328a-08eb-16c8a3a2644e@linux.intel.com>
 <20190925065640.GO28074@xz-x1>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D58F4A3@SHSMSX104.ccr.corp.intel.com>
 <20190925074507.GP28074@xz-x1>
In-Reply-To: <20190925074507.GP28074@xz-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZGFjODZhMmEtMmY5NC00ODJkLTg1ODUtOTg0YTk0NmJmNjBhIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoia3NsWWs5YUtWSHl2OVhjZEpxVjlLUGxERm8yVkFKU2hZZGVOZWVtOXgrWGhiOWZOamw0VkQ0Q3k2UE8xZmtWcCJ9
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
ZXNkYXksIFNlcHRlbWJlciAyNSwgMjAxOSAzOjQ1IFBNDQo+IA0KPiBPbiBXZWQsIFNlcCAyNSwg
MjAxOSBhdCAwNzoyMTo1MUFNICswMDAwLCBUaWFuLCBLZXZpbiB3cm90ZToNCj4gPiA+IEZyb206
IFBldGVyIFh1IFttYWlsdG86cGV0ZXJ4QHJlZGhhdC5jb21dDQo+ID4gPiBTZW50OiBXZWRuZXNk
YXksIFNlcHRlbWJlciAyNSwgMjAxOSAyOjU3IFBNDQo+ID4gPg0KPiA+ID4gT24gV2VkLCBTZXAg
MjUsIDIwMTkgYXQgMTA6NDg6MzJBTSArMDgwMCwgTHUgQmFvbHUgd3JvdGU6DQo+ID4gPiA+IEhp
IEtldmluLA0KPiA+ID4gPg0KPiA+ID4gPiBPbiA5LzI0LzE5IDM6MDAgUE0sIFRpYW4sIEtldmlu
IHdyb3RlOg0KPiA+ID4gPiA+ID4gPiA+ICAgICAgICctLS0tLS0tLS0tLScNCj4gPiA+ID4gPiA+
ID4gPiAgICAgICAnLS0tLS0tLS0tLS0nDQo+ID4gPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+ID4g
PiBUaGlzIHBhdGNoIHNlcmllcyBvbmx5IGFpbXMgdG8gYWNoaWV2ZSB0aGUgZmlyc3QgZ29hbCwg
YS5rLmEgdXNpbmcNCj4gPiA+ID4gPiBmaXJzdCBnb2FsPyB0aGVuIHdoYXQgYXJlIG90aGVyIGdv
YWxzPyBJIGRpZG4ndCBzcG90IHN1Y2ggaW5mb3JtYXRpb24uDQo+ID4gPiA+ID4NCj4gPiA+ID4N
Cj4gPiA+ID4gVGhlIG92ZXJhbGwgZ29hbCBpcyB0byB1c2UgSU9NTVUgbmVzdGVkIG1vZGUgdG8g
YXZvaWQgc2hhZG93IHBhZ2UNCj4gPiA+IHRhYmxlDQo+ID4gPiA+IGFuZCBWTUVYSVQgd2hlbiBt
YXAgYW4gZ0lPVkEuIFRoaXMgaW5jbHVkZXMgYmVsb3cgNCBzdGVwcyAobWF5YmUNCj4gbm90DQo+
ID4gPiA+IGFjY3VyYXRlLCBidXQgeW91IGNvdWxkIGdldCB0aGUgcG9pbnQuKQ0KPiA+ID4gPg0K
PiA+ID4gPiAxKSBHSU9WQSBtYXBwaW5ncyBvdmVyIDFzdC1sZXZlbCBwYWdlIHRhYmxlOw0KPiA+
ID4gPiAyKSBiaW5kaW5nIHZJT01NVSAxc3QgbGV2ZWwgcGFnZSB0YWJsZSB0byB0aGUgcElPTU1V
Ow0KPiA+ID4gPiAzKSB1c2luZyBwSU9NTVUgc2Vjb25kIGxldmVsIGZvciBHUEEtPkhQQSB0cmFu
c2xhdGlvbjsNCj4gPiA+ID4gNCkgZW5hYmxlIG5lc3RlZCAoYS5rLmEuIGR1YWwgc3RhZ2UpIHRy
YW5zbGF0aW9uIGluIGhvc3QuDQo+ID4gPiA+DQo+ID4gPiA+IFRoaXMgcGF0Y2ggc2V0IGFpbXMg
dG8gYWNoaWV2ZSAxKS4NCj4gPiA+DQo+ID4gPiBXb3VsZCBpdCBtYWtlIHNlbnNlIHRvIHVzZSAx
c3QgbGV2ZWwgZXZlbiBmb3IgYmFyZS1tZXRhbCB0byByZXBsYWNlDQo+ID4gPiB0aGUgMm5kIGxl
dmVsPw0KPiA+ID4NCj4gPiA+IFdoYXQgSSdtIHRoaW5raW5nIGlzIHRoZSBEUERLIGFwcHMgLSB0
aGV5IGhhdmUgTU1VIHBhZ2UgdGFibGUgYWxyZWFkeQ0KPiA+ID4gdGhlcmUgZm9yIHRoZSBodWdl
IHBhZ2VzLCB0aGVuIGlmIHRoZXkgY2FuIHVzZSAxc3QgbGV2ZWwgYXMgdGhlDQo+ID4gPiBkZWZh
dWx0IGRldmljZSBwYWdlIHRhYmxlIHRoZW4gaXQgZXZlbiBkb2VzIG5vdCBuZWVkIHRvIG1hcCwg
YmVjYXVzZQ0KPiA+ID4gaXQgY2FuIHNpbXBseSBiaW5kIHRoZSBwcm9jZXNzIHJvb3QgcGFnZSB0
YWJsZSBwb2ludGVyIHRvIHRoZSAxc3QNCj4gPiA+IGxldmVsIHBhZ2Ugcm9vdCBwb2ludGVyIG9m
IHRoZSBkZXZpY2UgY29udGV4dHMgdGhhdCBpdCB1c2VzLg0KPiA+ID4NCj4gPg0KPiA+IFRoZW4g
eW91IG5lZWQgYmVhciB3aXRoIHBvc3NpYmxlIHBhZ2UgZmF1bHRzIGZyb20gdXNpbmcgQ1BVIHBh
Z2UNCj4gPiB0YWJsZSwgd2hpbGUgbW9zdCBkZXZpY2VzIGRvbid0IHN1cHBvcnQgaXQgdG9kYXku
DQo+IA0KPiBSaWdodCwgSSB3YXMganVzdCB0aGlua2luZyBhbG91ZC4gIEFmdGVyIGFsbCBuZWl0
aGVyIGRvIHdlIGhhdmUgSU9NTVUNCj4gaGFyZHdhcmUgdG8gc3VwcG9ydCAxc3QgbGV2ZWwgKG9y
IGFtIEkgd3Jvbmc/KS4uLiAgSXQncyBqdXN0IHRoYXQgd2hlbg0KDQpZb3UgYXJlIHJpZ2h0LiBD
dXJyZW50IFZULWQgc3VwcG9ydHMgb25seSAybmQgbGV2ZWwuDQoNCj4gdGhlIDFzdCBsZXZlbCBp
cyByZWFkeSBpdCBzaG91bGQgc291bmQgZG9hYmxlIGJlY2F1c2UgSUlVQyBQUkkgc2hvdWxkDQo+
IGJlIGFsd2F5cyB3aXRoIHRoZSAxc3QgbGV2ZWwgc3VwcG9ydCBubyBtYXR0ZXIgb24gSU9NTVUg
c2lkZSBvciB0aGUNCj4gZGV2aWNlIHNpZGU/DQoNCk5vLiBQUkkgaXMgbm90IHRpZWQgdG8gMXN0
IG9yIDJuZCBsZXZlbC4gQWN0dWFsbHkgZnJvbSBkZXZpY2UgcC5vLnYsIGl0J3MNCmp1c3QgYSBw
cm90b2NvbCB0byB0cmlnZ2VyIHBhZ2UgZmF1bHQsIGJ1dCB0aGUgZGV2aWNlIGRvZXNuJ3QgY2Fy
ZSB3aGV0aGVyDQp0aGUgcGFnZSBmYXVsdCBpcyBvbiAxc3Qgb3IgMm5kIGxldmVsIGluIHRoZSBJ
T01NVSBzaWRlLiBUaGUgb25seQ0KcmVsZXZhbnQgcGFydCBpcyB0aGF0IGEgUFJJIHJlcXVlc3Qg
Y2FuIGhhdmUgUEFTSUQgdGFnZ2VkIG9yIGNsZWFyZWQuDQpXaGVuIGl0J3MgdGFnZ2VkIHdpdGgg
UEFTSUQsIHRoZSBJT01NVSB3aWxsIGxvY2F0ZSB0aGUgdHJhbnNsYXRpb24NCnRhYmxlIHVuZGVy
IHRoZSBnaXZlbiBQQVNJRCAoZWl0aGVyIDFzdCBvciAybmQgbGV2ZWwgaXMgZmluZSwgYWNjb3Jk
aW5nDQp0byBQQVNJRCBlbnRyeSBzZXR0aW5nKS4gV2hlbiBubyBQQVNJRCBpcyBpbmNsdWRlZCwg
dGhlIElPTU1VIGxvY2F0ZXMNCnRoZSB0cmFuc2xhdGlvbiBmcm9tIGRlZmF1bHQgZW50cnkgKGUu
Zy4gUEFTSUQjMCBvciBhbnkgUEFTSUQgY29udGFpbmVkDQppbiBSSUQyUEFTSUQgaW4gVlQtZCku
DQoNCllvdXIga25vd2xlZGdlIGhhcHBlbmVkIHRvIGJlIGNvcnJlY3QgaW4gZGVwcmVjYXRlZCBF
Q1MgbW9kZS4gQXQNCnRoYXQgdGltZSwgdGhlcmUgaXMgb25seSBvbmUgMm5kIGxldmVsIHBlciBj
b250ZXh0IGVudHJ5IHdoaWNoIGRvZXNuJ3QNCnN1cHBvcnQgcGFnZSBmYXVsdCwgYW5kIHRoZXJl
IGlzIG9ubHkgb25lIDFzdCBsZXZlbCBwZXIgUEFTSUQgZW50cnkgd2hpY2gNCnN1cHBvcnRzIHBh
Z2UgZmF1bHQuIFRoZW4gUFJJIGNvdWxkIGJlIGluZGlyZWN0bHkgY29ubmVjdGVkIHRvIDFzdCBs
ZXZlbCwNCmJ1dCB0aGlzIGp1c3QgY2hhbmdlZCB3aXRoIG5ldyBzY2FsYWJsZSBtb2RlLg0KDQpB
bm90aGVyIG5vdGUgaXMgdGhhdCB0aGUgUFJJIGNhcGFiaWxpdHkgb25seSBpbmRpY2F0ZXMgdGhh
dCBhIGRldmljZSBpcw0KY2FwYWJsZSBvZiBoYW5kbGluZyBwYWdlIGZhdWx0cywgYnV0IG5vdCB0
aGF0IGEgZGV2aWNlIGNhbiB0b2xlcmF0ZQ0KcGFnZSBmYXVsdCBmb3IgYW55IG9mIGl0cyBETUEg
YWNjZXNzLiBJZiB0aGUgbGF0dGVyIGlzIGZhc2xlLCB1c2luZyBDUFUgDQpwYWdlIHRhYmxlIGZv
ciBEUERLIHVzYWdlIGlzIHN0aWxsIHJpc2t5IChhbmQgc3BlY2lmaWMgdG8gZGV2aWNlIGJlaGF2
aW9yKQ0KDQo+IA0KPiBJJ20gYWN0dWFsbHkgbm90IHN1cmUgYWJvdXQgd2hldGhlciBteSB1bmRl
cnN0YW5kaW5nIGhlcmUgaXMNCj4gY29ycmVjdC4uLiBJIHRob3VnaHQgdGhlIHBhc2lkIGJpbmRp
bmcgcHJldmlvdXNseSB3YXMgb25seSBmb3Igc29tZQ0KPiB2ZW5kb3Iga2VybmVsIGRyaXZlcnMg
YnV0IG5vdCBhIGdlbmVyYWwgdGhpbmcgdG8gdXNlcnNwYWNlLiAgSSBmZWVsDQo+IGxpa2UgdGhh
dCBzaG91bGQgYmUgZG9hYmxlIGluIHRoZSBmdXR1cmUgb25jZSB3ZSd2ZSBnb3Qgc29tZSBuZXcN
Cj4gc3lzY2FsbCBpbnRlcmZhY2UgcmVhZHkgdG8gZGVsaXZlciAxc3QgbGV2ZWwgcGFnZSB0YWJs
ZSAoZS5nLiwgdmlhDQo+IHZmaW8/KSB0aGVuIGFwcGxpY2F0aW9ucyBsaWtlIERQREsgc2VlbXMg
dG8gYmUgYWJsZSB0byB1c2UgdGhhdCB0b28NCj4gZXZlbiBkaXJlY3RseSB2aWEgYmFyZSBtZXRh
bC4NCj4gDQoNCnVzaW5nIDFzdCBsZXZlbCBmb3IgdXNlcnNwYWNlIGlzIGRpZmZlcmVudCBmcm9t
IHN1cHBvcnRpbmcgRE1BIHBhZ2UNCmZhdWx0IGluIHVzZXJzcGFjZS4gVGhlIGZvcm1lciBpcyBw
dXJlbHkgYWJvdXQgd2hpY2ggc3RydWN0dXJlIHRvDQprZWVwIHRoZSBtYXBwaW5nLiBJIHRoaW5r
IHdlIG1heSBkbyB0aGUgc2FtZSB0aGluZyBmb3IgYm90aCBiYXJlDQptZXRhbCBhbmQgZ3Vlc3Qg
KHVzaW5nIDJuZCBsZXZlbCBvbmx5IGZvciBHUEEgd2hlbiBuZXN0ZWQgaXMgZW5hYmxlZA0Kb24g
dGhlIElPTU1VKS4gQnV0IHJldXNpbmcgQ1BVIHBhZ2UgdGFibGUgZm9yIHVzZXJzcGFjZSBpcyBt
b3JlDQp0cmlja3kuIDotKQ0KDQpUaGFua3MNCktldmluDQo=
