Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 528D0190E47
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 14:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbgCXNDe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 09:03:34 -0400
Received: from mga04.intel.com ([192.55.52.120]:5267 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727111AbgCXNDe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 09:03:34 -0400
IronPort-SDR: EJ1AXaTt6k2K3SkUW0EskHByITpUjej70FrOFolAhNen67S7h1+Ez1vnd67LVGSzL3mpfOXqsG
 46o3g1ZyjROA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2020 06:03:34 -0700
IronPort-SDR: 5ThqQqo8aI1d7ydTssgOC1bEa6RdoLha2dI7wvT8h2UeFE+JX5/bMcCTEJZiCxvi7f3PmNa5s8
 dBOxzakRjMAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,300,1580803200"; 
   d="scan'208";a="447868723"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga006.fm.intel.com with ESMTP; 24 Mar 2020 06:03:34 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 24 Mar 2020 06:03:33 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 24 Mar 2020 06:03:33 -0700
Received: from shsmsx102.ccr.corp.intel.com (10.239.4.154) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 24 Mar 2020 06:03:33 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.206]) by
 shsmsx102.ccr.corp.intel.com ([169.254.2.50]) with mapi id 14.03.0439.000;
 Tue, 24 Mar 2020 21:03:29 +0800
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
Subject: RE: [PATCH v1 08/22] vfio: init HostIOMMUContext per-container
Thread-Topic: [PATCH v1 08/22] vfio: init HostIOMMUContext per-container
Thread-Index: AQHWAEW0jB9vKYJM+keTj5bDx+gC8qhWMHmAgAGHKsA=
Date:   Tue, 24 Mar 2020 13:03:28 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A2006A9@SHSMSX104.ccr.corp.intel.com>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-9-git-send-email-yi.l.liu@intel.com>
 <20200323213943.GR127076@xz-x1>
In-Reply-To: <20200323213943.GR127076@xz-x1>
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

PiBGcm9tOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIE1h
cmNoIDI0LCAyMDIwIDU6NDAgQU0NCj4gVG86IExpdSwgWWkgTCA8eWkubC5saXVAaW50ZWwuY29t
Pg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYxIDA4LzIyXSB2ZmlvOiBpbml0IEhvc3RJT01NVUNv
bnRleHQgcGVyLWNvbnRhaW5lcg0KPiANCj4gT24gU3VuLCBNYXIgMjIsIDIwMjAgYXQgMDU6MzY6
MDVBTSAtMDcwMCwgTGl1IFlpIEwgd3JvdGU6DQo+ID4gQWZ0ZXIgY29uZmlybWluZyBkdWFsIHN0
YWdlIERNQSB0cmFuc2xhdGlvbiBzdXBwb3J0IHdpdGgga2VybmVsIGJ5DQo+ID4gY2hlY2tpbmcg
VkZJT19UWVBFMV9ORVNUSU5HX0lPTU1VLCBWRklPIGluaXRzIEhvc3RJT01NVUNvbnRldCBpbnN0
YW5jZQ0KPiA+IGFuZCBleHBvc2VzIGl0IHRvIFBDSSBsYXllci4gVGh1cyB2SU9NTVUgZW11YWx0
b3JzIG1heSBtYWtlIHVzZSBvZg0KPiA+IHN1Y2ggY2FwYWJpbGl0eSBieSBsZXZlcmFnaW5nIHRo
ZSBtZXRob2RzIHByb3ZpZGVkIGJ5IEhvc3RJT01NVUNvbnRleHQuDQo+ID4NCj4gPiBDYzogS2V2
aW4gVGlhbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+ID4gQ2M6IEphY29iIFBhbiA8amFjb2Iu
anVuLnBhbkBsaW51eC5pbnRlbC5jb20+DQo+ID4gQ2M6IFBldGVyIFh1IDxwZXRlcnhAcmVkaGF0
LmNvbT4NCj4gPiBDYzogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPg0KPiA+IENj
OiBZaSBTdW4gPHlpLnkuc3VuQGxpbnV4LmludGVsLmNvbT4NCj4gPiBDYzogRGF2aWQgR2lic29u
IDxkYXZpZEBnaWJzb24uZHJvcGJlYXIuaWQuYXU+DQo+ID4gQ2M6IEFsZXggV2lsbGlhbXNvbiA8
YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogTGl1IFlpIEwg
PHlpLmwubGl1QGludGVsLmNvbT4NCj4gPiAtLS0NCj4gPiAgaHcvdmZpby9jb21tb24uYyAgICAg
ICAgICAgICAgICAgICAgICB8IDgwICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
DQo+ID4gIGh3L3ZmaW8vcGNpLmMgICAgICAgICAgICAgICAgICAgICAgICAgfCAxMyArKysrKysN
Cj4gPiAgaW5jbHVkZS9ody9pb21tdS9ob3N0X2lvbW11X2NvbnRleHQuaCB8ICAzICsrDQo+ID4g
IGluY2x1ZGUvaHcvdmZpby92ZmlvLWNvbW1vbi5oICAgICAgICAgfCAgNCArKw0KPiA+ICA0IGZp
bGVzIGNoYW5nZWQsIDEwMCBpbnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvaHcv
dmZpby9jb21tb24uYyBiL2h3L3ZmaW8vY29tbW9uLmMNCj4gPiBpbmRleCBjMjc2NzMyLi5lNGY1
ZjEwIDEwMDY0NA0KPiA+IC0tLSBhL2h3L3ZmaW8vY29tbW9uLmMNCj4gPiArKysgYi9ody92Zmlv
L2NvbW1vbi5jDQo+ID4gQEAgLTExNzksMTAgKzExNzksNTUgQEAgc3RhdGljIGludCB2ZmlvX2dl
dF9pb21tdV90eXBlKFZGSU9Db250YWluZXINCj4gKmNvbnRhaW5lciwNCj4gPiAgICAgIHJldHVy
biAtRUlOVkFMOw0KPiA+ICB9DQo+ID4NCj4gPiArc3RhdGljIGludCB2ZmlvX2hvc3RfaWN4X3Bh
c2lkX2FsbG9jKEhvc3RJT01NVUNvbnRleHQgKmhvc3RfaWN4LA0KPiANCj4gSSdtIG5vdCBzdXJl
IGFib3V0IEFsZXgsIGJ1dCAuLi4gaWN4IGlzIGNvbmZ1c2luZyB0byBtZS4gIE1heWJlICJjdHgi
DQo+IGFzIHlvdSBhbHdheXMgdXNlZD8NCg0KQXQgZmlyc3QgSSB1c2VkIHZmaW9faG9zdF9pb21t
dV9jdHhfcGFzaWRfYWxsb2MoKSwgZm91bmQgaXQgaXMgbG9uZywgc28gSQ0Kc3dpdGNoZWQgdG8g
ImljeCIgd2hpY2ggbWVhbnMgaW9tbXVfY29udGV4dC4gTWF5YmUgdGhlIGZvcm1lciBvbmUNCmxv
b2tzIGJldHRlciBhcyBpdCBnaXZlcyBtb3JlIHByZWNpc2UgaW5mby4NCg0KUmVnYXJkcywNCllp
IExpdQ0K
