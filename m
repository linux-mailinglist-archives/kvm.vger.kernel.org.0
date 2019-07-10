Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9EFB6462B
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 14:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbfGJM3T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 08:29:19 -0400
Received: from mga03.intel.com ([134.134.136.65]:5827 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbfGJM3T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 08:29:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jul 2019 05:29:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,474,1557212400"; 
   d="scan'208";a="167714214"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga007.fm.intel.com with ESMTP; 10 Jul 2019 05:29:17 -0700
Received: from fmsmsx154.amr.corp.intel.com (10.18.116.70) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 10 Jul 2019 05:29:17 -0700
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 FMSMSX154.amr.corp.intel.com (10.18.116.70) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 10 Jul 2019 05:29:17 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.110]) by
 SHSMSX152.ccr.corp.intel.com ([169.254.6.22]) with mapi id 14.03.0439.000;
 Wed, 10 Jul 2019 20:29:15 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Peter Xu <zhexu@redhat.com>
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
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: RE: [RFC v1 02/18] linux-headers: import vfio.h from kernel
Thread-Topic: [RFC v1 02/18] linux-headers: import vfio.h from kernel
Thread-Index: AQHVM+yh2rNFaB2oxk6WEbspcoSec6bBBYMAgALIrGA=
Date:   Wed, 10 Jul 2019 12:29:15 +0000
Message-ID: <A2975661238FB949B60364EF0F2C257439F2A747@SHSMSX104.ccr.corp.intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
 <1562324511-2910-3-git-send-email-yi.l.liu@intel.com>
 <20190709015800.GA566@xz-x1>
In-Reply-To: <20190709015800.GA566@xz-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYTY1NTQ5ZmMtY2NjNi00OGM0LWExOTktYWFjN2M3ZjE2ODE4IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiSVdybks4WWRkZUp6dnVGWG0zYmExRjg1alI2SUh2YVZYRkFySGtyZk9NXC9WejBXQ3paR1lxaGtcL2phdng2NGVmIn0=
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBrdm0tb3duZXJAdmdlci5rZXJuZWwub3JnIFttYWlsdG86a3ZtLW93bmVyQHZnZXIu
a2VybmVsLm9yZ10gT24gQmVoYWxmDQo+IE9mIFBldGVyIFh1DQo+IFNlbnQ6IFR1ZXNkYXksIEp1
bHkgOSwgMjAxOSA5OjU4IEFNDQo+IFRvOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4N
Cj4gU3ViamVjdDogUmU6IFtSRkMgdjEgMDIvMThdIGxpbnV4LWhlYWRlcnM6IGltcG9ydCB2Zmlv
LmggZnJvbSBrZXJuZWwNCj4gDQo+IE9uIEZyaSwgSnVsIDA1LCAyMDE5IGF0IDA3OjAxOjM1UE0g
KzA4MDAsIExpdSBZaSBMIHdyb3RlOg0KPiA+IFRoaXMgcGF0Y2ggaW1wb3J0cyB0aGUgdklPTU1V
IHJlbGF0ZWQgZGVmaW5pdGlvbnMgZnJvbSBrZXJuZWwNCj4gPiB1YXBpL3ZmaW8uaC4gZS5nLiBw
YXNpZCBhbGxvY2F0aW9uLCBndWVzdCBwYXNpZCBiaW5kLCBndWVzdCBwYXNpZA0KPiA+IHRhYmxl
IGJpbmQgYW5kIGd1ZXN0IGlvbW11IGNhY2hlIGludmFsaWRhdGlvbi4NCj4gPg0KPiA+IENjOiBL
ZXZpbiBUaWFuIDxrZXZpbi50aWFuQGludGVsLmNvbT4NCj4gPiBDYzogSmFjb2IgUGFuIDxqYWNv
Yi5qdW4ucGFuQGxpbnV4LmludGVsLmNvbT4NCj4gPiBDYzogUGV0ZXIgWHUgPHBldGVyeEByZWRo
YXQuY29tPg0KPiA+IENjOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+ID4g
Q2M6IFlpIFN1biA8eWkueS5zdW5AbGludXguaW50ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6
IExpdSBZaSBMIDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogSmFjb2Ig
UGFuIDxqYWNvYi5qdW4ucGFuQGxpbnV4LmludGVsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBZ
aSBTdW4gPHlpLnkuc3VuQGxpbnV4LmludGVsLmNvbT4NCj4gDQo+IEp1c3QgYSBub3RlIHRoYXQg
aW4gdGhlIGxhc3QgdmVyc2lvbiB5b3UgY2FuIHVzZSBzY3JpcHRzL3VwZGF0ZS1saW51eC1oZWFk
ZXJzLnNoIHRvDQo+IHVwZGF0ZSB0aGUgaGVhZGVycy4gIEZvciB0aGlzIFJGQyBpdCdzIHBlcmZl
Y3RseSBmaW5lLg0KDQp5ZXAsIHRoYW5rcyBmb3IgdGhlIHJlbWluZC4NCg0KPiAtLQ0KPiBQZXRl
ciBYdQ0KDQpSZWdhcmRzLA0KWWkgTGl1DQo=
