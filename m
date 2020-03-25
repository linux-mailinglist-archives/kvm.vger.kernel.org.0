Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5C141925EE
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 11:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbgCYKkO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 06:40:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:43144 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727177AbgCYKkO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 06:40:14 -0400
IronPort-SDR: GXCvk6YSoNNwv2KKolk07BT5HV6bEKYS5uuIydIyyQYsMELiP4+Ay6zGYOKWAYCBXbzVZPoWrf
 PMiJv47bRSRQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 03:40:13 -0700
IronPort-SDR: QlNTJjIzx9iOQk2UUPnC15Dwah5AslmRQPSvLxxIzBwk78OdCgPw9Kj5c9I10BFTGBqliIIaBT
 srMRXJRbS0qQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,304,1580803200"; 
   d="scan'208";a="393587249"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga004.jf.intel.com with ESMTP; 25 Mar 2020 03:40:12 -0700
Received: from fmsmsx112.amr.corp.intel.com (10.18.116.6) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 25 Mar 2020 03:40:12 -0700
Received: from shsmsx151.ccr.corp.intel.com (10.239.6.50) by
 FMSMSX112.amr.corp.intel.com (10.18.116.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 25 Mar 2020 03:40:11 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.206]) by
 SHSMSX151.ccr.corp.intel.com ([169.254.3.201]) with mapi id 14.03.0439.000;
 Wed, 25 Mar 2020 18:40:08 +0800
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
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: RE: [PATCH v1 18/22] vfio: add support for flush iommu stage-1 cache
Thread-Topic: [PATCH v1 18/22] vfio: add support for flush iommu stage-1
 cache
Thread-Index: AQHWAEW38keupAMDxUWxV+Of7sKHqqhXisuAgAGX/eA=
Date:   Wed, 25 Mar 2020 10:40:08 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A201F8D@SHSMSX104.ccr.corp.intel.com>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-19-git-send-email-yi.l.liu@intel.com>
 <20200324181915.GC127076@xz-x1>
In-Reply-To: <20200324181915.GC127076@xz-x1>
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

PiBGcm9tOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwg
TWFyY2ggMjUsIDIwMjAgMjoxOSBBTQ0KPiBUbzogTGl1LCBZaSBMIDx5aS5sLmxpdUBpbnRlbC5j
b20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjEgMTgvMjJdIHZmaW86IGFkZCBzdXBwb3J0IGZv
ciBmbHVzaCBpb21tdSBzdGFnZS0xIGNhY2hlDQo+IA0KPiBPbiBTdW4sIE1hciAyMiwgMjAyMCBh
dCAwNTozNjoxNUFNIC0wNzAwLCBMaXUgWWkgTCB3cm90ZToNCj4gPiBUaGlzIHBhdGNoIGFkZHMg
Zmx1c2hfc3RhZ2UxX2NhY2hlKCkgZGVmaW5pdGlvbiBpbiBIb3N0SU9NVUNvbnRleHRDbGFzcy4N
Cj4gPiBBbmQgYWRkcyBjb3JyZXNwb25kaW5nIGltcGxlbWVudGF0aW9uIGluIFZGSU8uIFRoaXMg
aXMgdG8gZXhwb3NlIGEgd2F5DQo+ID4gZm9yIHZJT01NVSB0byBmbHVzaCBzdGFnZS0xIGNhY2hl
IGluIGhvc3Qgc2lkZSBzaW5jZSBndWVzdCBvd25zDQo+ID4gc3RhZ2UtMSB0cmFuc2xhdGlvbiBz
dHJ1Y3R1cmVzIGluIGR1YWwgc3RhZ2UgRE1BIHRyYW5zbGF0aW9uIGNvbmZpZ3VyYXRpb24uDQo+
ID4NCj4gPiBDYzogS2V2aW4gVGlhbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+ID4gQ2M6IEph
Y29iIFBhbiA8amFjb2IuanVuLnBhbkBsaW51eC5pbnRlbC5jb20+DQo+ID4gQ2M6IFBldGVyIFh1
IDxwZXRlcnhAcmVkaGF0LmNvbT4NCj4gPiBDYzogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRo
YXQuY29tPg0KPiA+IENjOiBZaSBTdW4gPHlpLnkuc3VuQGxpbnV4LmludGVsLmNvbT4NCj4gPiBD
YzogRGF2aWQgR2lic29uIDxkYXZpZEBnaWJzb24uZHJvcGJlYXIuaWQuYXU+DQo+ID4gQ2M6IEFs
ZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+ID4gU2lnbmVkLW9m
Zi1ieTogTGl1IFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gDQo+IEFja2VkLWJ5OiBQZXRl
ciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQoNClRoYW5rcywgUGV0ZXIuDQoNClJlZ2FyZHMsDQpZ
aSBMaXUNCg==
