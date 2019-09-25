Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEEB5BD770
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 06:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388554AbfIYEif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 00:38:35 -0400
Received: from mga06.intel.com ([134.134.136.31]:14675 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725784AbfIYEif (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 00:38:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Sep 2019 21:38:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,546,1559545200"; 
   d="scan'208";a="218860750"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by fmsmga002.fm.intel.com with ESMTP; 24 Sep 2019 21:38:34 -0700
Received: from fmsmsx120.amr.corp.intel.com (10.18.124.208) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 24 Sep 2019 21:38:34 -0700
Received: from shsmsx105.ccr.corp.intel.com (10.239.4.158) by
 fmsmsx120.amr.corp.intel.com (10.18.124.208) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 24 Sep 2019 21:38:33 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.32]) by
 SHSMSX105.ccr.corp.intel.com ([169.254.11.23]) with mapi id 14.03.0439.000;
 Wed, 25 Sep 2019 12:38:32 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Peter Xu <peterx@redhat.com>, Lu Baolu <baolu.lu@linux.intel.com>
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
Thread-Index: AQHVcgpDf16VDDZMQk6x5RWfK5mI2qc5MXAAgABWBICAAcJfAIAAh6Ig
Date:   Wed, 25 Sep 2019 04:38:31 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D58F018@SHSMSX104.ccr.corp.intel.com>
References: <20190923122454.9888-1-baolu.lu@linux.intel.com>
 <20190923122454.9888-3-baolu.lu@linux.intel.com>
 <20190923203102.GB21816@araj-mobl1.jf.intel.com>
 <9cfe6042-f0fb-ea5e-e134-f6f5bb9eb7b0@linux.intel.com>
 <20190925043050.GK28074@xz-x1>
In-Reply-To: <20190925043050.GK28074@xz-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYzQ2YjFmYTQtN2U3ZS00MGI3LThiZjAtMTllNDY5ZWQ3NDk4IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoicDZcL3hYOGtZT3JCSEMzcERMQ3VHWnlLM09aRlZXS1BhM3dmbE14MmxrY2xBYzZcL3hKeHBEYjRUeEtXbGE2Q29wIn0=
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
ZXNkYXksIFNlcHRlbWJlciAyNSwgMjAxOSAxMjozMSBQTQ0KPiANCj4gT24gVHVlLCBTZXAgMjQs
IDIwMTkgYXQgMDk6Mzg6NTNBTSArMDgwMCwgTHUgQmFvbHUgd3JvdGU6DQo+ID4gPiA+IGludGVs
X21tbWFwX3JhbmdlKGRvbWFpbiwgYWRkciwgZW5kLCBwaHlzX2FkZHIsIHByb3QpDQo+ID4gPg0K
PiA+ID4gTWF5YmUgdGhpbmsgb2YgYSBkaWZmZXJlbnQgbmFtZS4uPyBtbW1hcCBzZWVtcyBhIGJp
dCB3ZWlyZCA6LSkNCj4gPg0KPiA+IFllcy4gSSBkb24ndCBsaWtlIGl0IGVpdGhlci4gSSd2ZSB0
aG91Z2h0IGFib3V0IGl0IGFuZCBoYXZlbid0DQo+ID4gZmlndXJlZCBvdXQgYSBzYXRpc2ZpZWQg
b25lLiBEbyB5b3UgaGF2ZSBhbnkgc3VnZ2VzdGlvbnM/DQo+IA0KPiBIb3cgYWJvdXQgYXQgbGVh
c3Qgc3BsaXQgdGhlIHdvcmQgdXNpbmcgIl8iPyAgTGlrZSAibW1fbWFwIiwgdGhlbg0KPiBhcHBs
eSBpdCB0byBhbGwgdGhlICJtbW0qIiBwcmVmaXhlcy4gIE90aGVyd2lzZSBpdCdsbCBiZSBlYXNp
bHkNCj4gbWlzcmVhZCBhcyBtbWFwKCkgd2hpY2ggaXMgdG90YWxseSBpcnJlbGV2YW50IHRvIHRo
aXMuLi4NCj4gDQoNCndoYXQgaXMgdGhlIHBvaW50IG9mIGtlZXBpbmcgJ21tJyBoZXJlPyByZXBs
YWNlIGl0IHdpdGggJ2lvbW11Jz8NCg0KVGhhbmtzDQpLZXZpbg0K
