Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C10E919D8E0
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 16:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390999AbgDCOUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 10:20:37 -0400
Received: from mga06.intel.com ([134.134.136.31]:58802 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727927AbgDCOUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 10:20:37 -0400
IronPort-SDR: Z95eFaf4+zxP4gGtimyvZuLHTbtMKnf1bivmylgLHv2kDAKMWEc2g+xXRwnQpXX5pZhOaoSzk8
 jbibPjSX8dzw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2020 07:20:23 -0700
IronPort-SDR: 2rpQ7rIuR4YUY0xutP8EPYCYieB6vL0BcBNl35QFYD1nMs86yI801vsSY3VF1kc6yr5wB5UD2u
 Xfc9cs/52umA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,339,1580803200"; 
   d="scan'208";a="250182018"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga003.jf.intel.com with ESMTP; 03 Apr 2020 07:20:23 -0700
Received: from fmsmsx102.amr.corp.intel.com (10.18.124.200) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 3 Apr 2020 07:20:22 -0700
Received: from shsmsx108.ccr.corp.intel.com (10.239.4.97) by
 FMSMSX102.amr.corp.intel.com (10.18.124.200) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 3 Apr 2020 07:20:22 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX108.ccr.corp.intel.com ([169.254.8.7]) with mapi id 14.03.0439.000;
 Fri, 3 Apr 2020 22:20:19 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Peter Xu <peterx@redhat.com>, Jason Wang <jasowang@redhat.com>
CC:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
Subject: RE: [PATCH v2 00/22] intel_iommu: expose Shared Virtual Addressing
 to VMs
Thread-Topic: [PATCH v2 00/22] intel_iommu: expose Shared Virtual Addressing
 to VMs
Thread-Index: AQHWBkpi4SFlYLfwBEaCXIDf+JnUMqhk//QAgABXcoCAAiHikA==
Date:   Fri, 3 Apr 2020 14:20:18 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A220CF8@SHSMSX104.ccr.corp.intel.com>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <984e6f47-2717-44fb-7ff2-95ca61d1858f@redhat.com>
 <20200402134601.GJ7174@xz-x1>
In-Reply-To: <20200402134601.GJ7174@xz-x1>
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

PiBGcm9tOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBB
cHJpbCAyLCAyMDIwIDk6NDYgUE0NCj4gVG86IEphc29uIFdhbmcgPGphc293YW5nQHJlZGhhdC5j
b20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjIgMDAvMjJdIGludGVsX2lvbW11OiBleHBvc2Ug
U2hhcmVkIFZpcnR1YWwgQWRkcmVzc2luZyB0bw0KPiBWTXMNCj4gDQo+IE9uIFRodSwgQXByIDAy
LCAyMDIwIGF0IDA0OjMzOjAyUE0gKzA4MDAsIEphc29uIFdhbmcgd3JvdGU6DQo+ID4gPiBUaGUg
Y29tcGxldGUgUUVNVSBzZXQgY2FuIGJlIGZvdW5kIGluIGJlbG93IGxpbms6DQo+ID4gPiBodHRw
czovL2dpdGh1Yi5jb20vbHV4aXMxOTk5L3FlbXUuZ2l0OiBzdmFfdnRkX3YxMF92Mg0KPiA+DQo+
ID4NCj4gPiBIaSBZaToNCj4gPg0KPiA+IEkgY291bGQgbm90IGZpbmQgdGhlIGJyYW5jaCB0aGVy
ZS4NCj4gDQo+IEphc29uLA0KPiANCj4gSGUgdHlwZWQgd3JvbmcuLi4gSXQncyBhY3R1YWxseSAo
SSBmb3VuZCBpdCBteXNlbGYpOg0KPiANCj4gaHR0cHM6Ly9naXRodWIuY29tL2x1eGlzMTk5OS9x
ZW11L3RyZWUvc3ZhX3Z0ZF92MTBfcWVtdV92Mg0KdGhhbmtzLCByZWFsbHkgYSBzaWxseSB0eXBl
IG1pc3Rha2UuDQoNClJlZ2FyZHMsDQpZaSBMaXUNCg==
