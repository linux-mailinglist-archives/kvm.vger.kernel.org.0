Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B22DB64631
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 14:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbfGJMbn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 08:31:43 -0400
Received: from mga05.intel.com ([192.55.52.43]:61508 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbfGJMbm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 08:31:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jul 2019 05:31:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,474,1557212400"; 
   d="scan'208";a="159752417"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga008.jf.intel.com with ESMTP; 10 Jul 2019 05:31:41 -0700
Received: from shsmsx101.ccr.corp.intel.com (10.239.4.153) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 10 Jul 2019 05:31:41 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.110]) by
 SHSMSX101.ccr.corp.intel.com ([169.254.1.134]) with mapi id 14.03.0439.000;
 Wed, 10 Jul 2019 20:31:39 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Auger Eric <eric.auger@redhat.com>, Peter Xu <zhexu@redhat.com>
CC:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "tianyu.lan@intel.com" <tianyu.lan@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: RE: [RFC v1 02/18] linux-headers: import vfio.h from kernel
Thread-Topic: [RFC v1 02/18] linux-headers: import vfio.h from kernel
Thread-Index: AQHVM+yh2rNFaB2oxk6WEbspcoSec6bBBYMAgABvtYCAAlmbgA==
Date:   Wed, 10 Jul 2019 12:31:39 +0000
Message-ID: <A2975661238FB949B60364EF0F2C257439F2A781@SHSMSX104.ccr.corp.intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
 <1562324511-2910-3-git-send-email-yi.l.liu@intel.com>
 <20190709015800.GA566@xz-x1>
 <b2e9cc9b-2972-f83e-1cb1-ba292b0e99e7@redhat.com>
In-Reply-To: <b2e9cc9b-2972-f83e-1cb1-ba292b0e99e7@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYjcxNTBlMmQtYWRiYS00OTIxLWFhNzMtNWQ5ZjZjYjlmYzE3IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiQldGeVAxam5HYW1vTWtSSnBBc3p2WHB1a0ZXRUx3WFIwK0hiS0xWNFFJc0FrWVlkVU1xNEI4OWxJekRRWlBJeSJ9
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBdWdlciBFcmljIFttYWlsdG86ZXJpYy5hdWdlckByZWRoYXQuY29tXQ0KPiBTZW50
OiBUdWVzZGF5LCBKdWx5IDksIDIwMTkgNDozOCBQTQ0KPiBUbzogUGV0ZXIgWHUgPHpoZXh1QHJl
ZGhhdC5jb20+OyBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU3ViamVjdDogUmU6
IFtSRkMgdjEgMDIvMThdIGxpbnV4LWhlYWRlcnM6IGltcG9ydCB2ZmlvLmggZnJvbSBrZXJuZWwN
Cj4gDQo+IEhpIExpdSwNCj4gDQo+IE9uIDcvOS8xOSAzOjU4IEFNLCBQZXRlciBYdSB3cm90ZToN
Cj4gPiBPbiBGcmksIEp1bCAwNSwgMjAxOSBhdCAwNzowMTozNVBNICswODAwLCBMaXUgWWkgTCB3
cm90ZToNCj4gPj4gVGhpcyBwYXRjaCBpbXBvcnRzIHRoZSB2SU9NTVUgcmVsYXRlZCBkZWZpbml0
aW9ucyBmcm9tIGtlcm5lbA0KPiA+PiB1YXBpL3ZmaW8uaC4gZS5nLiBwYXNpZCBhbGxvY2F0aW9u
LCBndWVzdCBwYXNpZCBiaW5kLCBndWVzdCBwYXNpZA0KPiA+PiB0YWJsZSBiaW5kIGFuZCBndWVz
dCBpb21tdSBjYWNoZSBpbnZhbGlkYXRpb24uDQo+ID4+DQo+ID4+IENjOiBLZXZpbiBUaWFuIDxr
ZXZpbi50aWFuQGludGVsLmNvbT4NCj4gPj4gQ2M6IEphY29iIFBhbiA8amFjb2IuanVuLnBhbkBs
aW51eC5pbnRlbC5jb20+DQo+ID4+IENjOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+
ID4+IENjOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+ID4+IENjOiBZaSBT
dW4gPHlpLnkuc3VuQGxpbnV4LmludGVsLmNvbT4NCj4gPj4gU2lnbmVkLW9mZi1ieTogTGl1IFlp
IEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gPj4gU2lnbmVkLW9mZi1ieTogSmFjb2IgUGFuIDxq
YWNvYi5qdW4ucGFuQGxpbnV4LmludGVsLmNvbT4NCj4gPj4gU2lnbmVkLW9mZi1ieTogWWkgU3Vu
IDx5aS55LnN1bkBsaW51eC5pbnRlbC5jb20+DQo+ID4NCj4gPiBKdXN0IGEgbm90ZSB0aGF0IGlu
IHRoZSBsYXN0IHZlcnNpb24geW91IGNhbiB1c2UNCj4gPiBzY3JpcHRzL3VwZGF0ZS1saW51eC1o
ZWFkZXJzLnNoIHRvIHVwZGF0ZSB0aGUgaGVhZGVycy4gIEZvciB0aGlzIFJGQw0KPiA+IGl0J3Mg
cGVyZmVjdGx5IGZpbmUuDQo+ID4NCj4gDQo+IFlvdSB3aWxsIG5lZWQgdG8gdXBkYXRlIHNjcmlw
dHMvdXBkYXRlLWxpbnV4LWhlYWRlcnMuc2ggdG8gaW1wb3J0IHRoZSBuZXcgaW9tbXUuaA0KPiBo
ZWFkZXIuIFNlZSAiW1JGQyB2NCAwMi8yN10gdXBkYXRlLWxpbnV4LWhlYWRlcnM6IEltcG9ydCBp
b21tdS5oIg0KPiBodHRwczovL3d3dy5tYWlsLWFyY2hpdmUuY29tL3FlbXUtZGV2ZWxAbm9uZ251
Lm9yZy9tc2c2MjAwOTguaHRtbC4NCg0KVGhhbmtzIHZlcnkgbXVjaCBFcmljLiA6LSkNCg0KUmVn
YXJkcywNCllpIExpdQ0K
