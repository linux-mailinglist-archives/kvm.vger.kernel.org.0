Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3AAC1974DA
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 09:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbgC3HHE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 03:07:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:19018 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728489AbgC3HHE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 03:07:04 -0400
IronPort-SDR: rgnGcx1VDGn/lB3lrD/vaXOZNpIjsz73+XdiWiQdKqNeZJRyvqvou0bvlil9SnDAb6BUqwPI3J
 ntroWfpocq+A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 00:07:03 -0700
IronPort-SDR: QGN8eDhpxmi/o3hHa5+yq50mypEFuY+72r+aSQs8PFbOrAJ69yeDj6sfHrtMzT7MDEr7bmGGCN
 avTg5f1g5EcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,323,1580803200"; 
   d="scan'208";a="251798831"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga006.jf.intel.com with ESMTP; 30 Mar 2020 00:07:03 -0700
Received: from fmsmsx153.amr.corp.intel.com (10.18.125.6) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Mar 2020 00:07:02 -0700
Received: from shsmsx105.ccr.corp.intel.com (10.239.4.158) by
 FMSMSX153.amr.corp.intel.com (10.18.125.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Mar 2020 00:07:03 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX105.ccr.corp.intel.com ([169.254.11.213]) with mapi id 14.03.0439.000;
 Mon, 30 Mar 2020 15:06:59 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Auger Eric <eric.auger@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        "Cornelia Huck" <cohuck@redhat.com>
Subject: RE: [PATCH v1 02/22] header file update VFIO/IOMMU vSVA APIs
Thread-Topic: [PATCH v1 02/22] header file update VFIO/IOMMU vSVA APIs
Thread-Index: AQHWAEWzGPuJuT4J30ONAJq1EYpf86hfSKQAgAF557A=
Date:   Mon, 30 Mar 2020 07:06:59 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A217A6A@SHSMSX104.ccr.corp.intel.com>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-3-git-send-email-yi.l.liu@intel.com>
 <288fdc64-9701-3e3e-2412-acc655f18b7a@redhat.com>
In-Reply-To: <288fdc64-9701-3e3e-2412-acc655f18b7a@redhat.com>
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

SGkgRXJpYywNCg0KPiBGcm9tOiBBdWdlciBFcmljIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IE1vbmRheSwgTWFyY2ggMzAsIDIwMjAgMTI6MzMgQU0NCj4gVG86IExpdSwgWWkgTCA8
eWkubC5saXVAaW50ZWwuY29tPjsgcWVtdS1kZXZlbEBub25nbnUub3JnOw0KPiBTdWJqZWN0OiBS
ZTogW1BBVENIIHYxIDAyLzIyXSBoZWFkZXIgZmlsZSB1cGRhdGUgVkZJTy9JT01NVSB2U1ZBIEFQ
SXMNCj4gDQo+IEhpIFlpLA0KPiANCj4gT24gMy8yMi8yMCAxOjM1IFBNLCBMaXUgWWkgTCB3cm90
ZToNCj4gPiBUaGUga2VybmVsIHVhcGkvbGludXgvaW9tbXUuaCBoZWFkZXIgZmlsZSBpbmNsdWRl
cyB0aGUgZXh0ZW5zaW9ucyBmb3INCj4gPiB2U1ZBIHN1cHBvcnQuIGUuZy4gYmluZCBncGFzaWQs
IGlvbW11IGZhdWx0IHJlcG9ydCByZWxhdGVkIHVzZXINCj4gPiBzdHJ1Y3R1cmVzIGFuZCBldGMu
DQo+ID4NCj4gPiBOb3RlOiB0aGlzIHNob3VsZCBiZSByZXBsYWNlZCB3aXRoIGEgZnVsbCBoZWFk
ZXIgZmlsZXMgdXBkYXRlIHdoZW4gdGhlDQo+ID4gdlNWQSB1UEFQSSBpcyBzdGFibGUuDQo+IA0K
PiBVbnRpbCB0aGlzIGdldHMgdXBzdHJlYW1lZCwgbWF5YmUgYWRkIHRoZSBicmFuY2ggYWdhaW5z
dCB3aGljaCB5b3UgdXBkYXRlZCB0aGUNCj4gaGVhZGVycz8NCg0KZ29vZCBwb2ludCwgSSBjYW4g
YWRkIGl0IGhlcmUgaW4gdjMuLi4ganVzdCBzZW50IG91dCB2Mi4NCg0KVGhhbmtzLA0KWWkgTGl1
DQoNCg==
