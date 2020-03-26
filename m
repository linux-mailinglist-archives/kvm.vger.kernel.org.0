Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 372C4193FD2
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 14:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgCZNd6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 09:33:58 -0400
Received: from mga14.intel.com ([192.55.52.115]:54507 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726318AbgCZNd6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 09:33:58 -0400
IronPort-SDR: IpWJiGHASVy4Uve0KAXrLwpJ0t5KtuYIK3X3Iy0SPtDbPYCzerZ2mNGMgxT1ggB6GnEY3ACXAY
 ljFCz4qLnZ3A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 06:33:57 -0700
IronPort-SDR: Wm/XX0opBYzaUiFHMReid3KeCq2jH5fmbTcZ0zciVI7rHMJ7ErVzDg22xDdqbJIilA09gyz8Z8
 i9Gm9IbrXR8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,308,1580803200"; 
   d="scan'208";a="448627547"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga006.fm.intel.com with ESMTP; 26 Mar 2020 06:33:57 -0700
Received: from fmsmsx153.amr.corp.intel.com (10.18.125.6) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 26 Mar 2020 06:33:57 -0700
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 FMSMSX153.amr.corp.intel.com (10.18.125.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 26 Mar 2020 06:33:57 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.206]) by
 SHSMSX152.ccr.corp.intel.com ([169.254.6.155]) with mapi id 14.03.0439.000;
 Thu, 26 Mar 2020 21:33:53 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Peter Xu <peterx@redhat.com>
CC:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
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
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: RE: [PATCH v1 20/22] intel_iommu: propagate PASID-based iotlb
 invalidation to host
Thread-Topic: [PATCH v1 20/22] intel_iommu: propagate PASID-based iotlb
 invalidation to host
Thread-Index: AQHWAEW3X+65yqyUwUiucJlWzaqkgqhXjwWAgAHAhkCAAREEgP//9nsAgAAFmQCAAIZuwA==
Date:   Thu, 26 Mar 2020 13:33:52 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A20455C@SHSMSX104.ccr.corp.intel.com>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-21-git-send-email-yi.l.liu@intel.com>
 <20200324183423.GE127076@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A2022C5@SHSMSX104.ccr.corp.intel.com>
 <A2975661238FB949B60364EF0F2C25743A203E63@SHSMSX104.ccr.corp.intel.com>
 <20200326130248.GB422390@xz-x1> <20200326132250.GC422390@xz-x1>
In-Reply-To: <20200326132250.GC422390@xz-x1>
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

PiBGcm9tOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBN
YXJjaCAyNiwgMjAyMCA5OjIzIFBNDQo+IFRvOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNv
bT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MSAyMC8yMl0gaW50ZWxfaW9tbXU6IHByb3BhZ2F0
ZSBQQVNJRC1iYXNlZCBpb3RsYg0KPiBpbnZhbGlkYXRpb24gdG8gaG9zdA0KPiANCj4gT24gVGh1
LCBNYXIgMjYsIDIwMjAgYXQgMDk6MDI6NDhBTSAtMDQwMCwgUGV0ZXIgWHUgd3JvdGU6DQo+IA0K
PiBbLi4uXQ0KPiANCj4gPiA+ID4gPiA+ICtzdGF0aWMgaW5saW5lIGJvb2wgdnRkX3Bhc2lkX2Nh
Y2hlX3ZhbGlkKA0KPiA+ID4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgVlREUEFT
SURBZGRyZXNzU3BhY2UgKnZ0ZF9wYXNpZF9hcykgew0KPiA+ID4gPiA+ID4gKyAgICByZXR1cm4g
dnRkX3Bhc2lkX2FzLT5pb21tdV9zdGF0ZSAmJg0KPiA+ICAgICAgICAgICAgICAgICAgICAgXl5e
Xl5eXl5eXl5eXl5eXl5eXl5eXl5eXg0KPiA+DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBUaGlzIGNo
ZWNrIGNhbiBiZSBkcm9wcGVkIGJlY2F1c2UgYWx3YXlzIHRydWU/DQo+ID4gPiA+ID4NCj4gPiA+
ID4gPiBJZiB5b3UgYWdyZWUgd2l0aCBib3RoIHRoZSBjaGFuZ2VzLCBwbGVhc2UgYWRkOg0KPiA+
ID4gPiA+DQo+ID4gPiA+ID4gUmV2aWV3ZWQtYnk6IFBldGVyIFh1IDxwZXRlcnhAcmVkaGF0LmNv
bT4NCj4gPiA+ID4NCj4gPiA+ID4gSSB0aGluayB0aGUgY29kZSBzaG91bGQgZW5zdXJlIGFsbCB0
aGUgcGFzaWRfYXMgaW4gaGFzaCB0YWJsZSBpcw0KPiA+ID4gPiB2YWxpZC4gQW5kIHdlIGNhbiBz
aW5jZSBhbGwgdGhlIG9wZXJhdGlvbnMgYXJlIHVuZGVyIHByb3RlY3Rpb24gb2YgaW9tbXVfbG9j
ay4NCj4gPiA+ID4NCj4gPiA+IFBldGVyLA0KPiA+ID4NCj4gPiA+IEkgdGhpbmsgbXkgcmVwbHkg
d2FzIHdyb25nLiBwYXNpZF9hcyBpbiBoYXMgdGFibGUgbWF5IGJlIHN0YWxlIHNpbmNlDQo+ID4g
PiB0aGUgcGVyIHBhc2lkX2FzIGNhY2hlX2dlbiBtYXkgYmUgbm90IGlkZW50aWNhbCB3aXRoIHRo
ZSBjYWNoZV9nZW4NCj4gPiA+IGluIGlvbW11X3N0YXRlLiBlLmcuIHZ0ZF9wYXNpZF9jYWNoZV9y
ZXNldCgpIG9ubHkgaW5jcmVhc2VzIHRoZQ0KPiA+ID4gY2FjaGVfZ2VuIGluIGlvbW11X3N0YXRl
LiBTbyB0aGVyZSB3aWxsIGJlIHBhc2lkX2FzIGluIGhhc2ggdGFibGUNCj4gPiA+IHdoaWNoIGhh
cyBjYWNoZWQgcGFzaWQgZW50cnkgYnV0IGl0cyBjYWNoZV9nZW4gaXMgbm90IGVxdWFsIHRvIHRo
ZQ0KPiA+ID4gb25lIGluIGlvbW11X3N0YXRlLiBGb3Igc3VjaCBwYXNpZF9hcywgd2Ugc2hvdWxk
IHRyZWF0IGl0IGFzIHN0YWxlLg0KPiA+ID4gU28gSSBndWVzcyB0aGUgdnRkX3Bhc2lkX2NhY2hl
X3ZhbGlkKCkgaXMgc3RpbGwgbmVjZXNzYXJ5Lg0KPiA+DQo+ID4gSSBndWVzcyB5b3UgbWlzcmVh
ZCBteSBjb21tZW50LiA6KQ0KPiA+DQo+ID4gSSB3YXMgc2F5aW5nIHRoZSAidnRkX3Bhc2lkX2Fz
LT5pb21tdV9zdGF0ZSIgY2hlY2sgaXMgbm90IG5lZWRlZCwNCj4gPiBiZWNhdXNlIGlvbW11X3N0
YXRlIHdhcyBhbHdheXMgc2V0IGlmIHRoZSBhZGRyZXNzIHNwYWNlIGlzIGNyZWF0ZWQuDQo+ID4g
dnRkX3Bhc2lkX2NhY2hlX3ZhbGlkKCkgaXMgbmVlZGVkLg0KPiA+DQo+ID4gQWxzbywgcGxlYXNl
IGRvdWJsZSBjb25maXJtIHRoYXQgdnRkX3Bhc2lkX2NhY2hlX3Jlc2V0KCkgc2hvdWxkIGRyb3AN
Cj4gPiBhbGwgdGhlIGFkZHJlc3Mgc3BhY2VzIChhcyBJIHRoaW5rIGl0IHNob3VsZCksIG5vdCAi
b25seSBpbmNyZWFzZSB0aGUNCj4gPiBjYWNoZV9nZW4iLiAgSU1ITyB5b3Ugc2hvdWxkIG9ubHkg
aW5jcmVhc2UgdGhlIGNhY2hlX2dlbiBpbiB0aGUgUFNJDQo+ID4gaG9vayAodnRkX3Bhc2lkX2Nh
Y2hlX3BzaSgpKSBvbmx5Lg0KPiANCj4gU29ycnksIEkgbWVhbiBHU0kgKHZ0ZF9wYXNpZF9jYWNo
ZV9nc2kpLCBub3QgUFNJLg0KDQpHb3QgaXQuLiBSZWFsbHkgY29uZnVzZWQgbWUuIDotKSANCg0K
UmVnYXJkcywNCllpIExpdQ0K
