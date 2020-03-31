Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD62198C6B
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 08:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgCaGjX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 02:39:23 -0400
Received: from mga07.intel.com ([134.134.136.100]:28508 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbgCaGjX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 02:39:23 -0400
IronPort-SDR: ijbFEAnOFA6aAqKAc7e6q79vADZvDOOt85LliRZCTsN9U+0zP5X7Gf3YJNW7MpbWyrLhzrt6gV
 yRboFobt0XkA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 23:39:23 -0700
IronPort-SDR: VDQZGdHuZ+1PFwSUA+ILgQLpAd7KdC3fkCIpiH96TcGXcuw5XKWseA8BOj3zLUNfeHiIgHSdZq
 tej94aLxQAUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,327,1580803200"; 
   d="scan'208";a="448556829"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga005.fm.intel.com with ESMTP; 30 Mar 2020 23:39:22 -0700
Received: from fmsmsx111.amr.corp.intel.com (10.18.116.5) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Mar 2020 23:39:22 -0700
Received: from shsmsx102.ccr.corp.intel.com (10.239.4.154) by
 fmsmsx111.amr.corp.intel.com (10.18.116.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Mar 2020 23:39:22 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 shsmsx102.ccr.corp.intel.com ([169.254.2.138]) with mapi id 14.03.0439.000;
 Tue, 31 Mar 2020 14:39:18 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>
CC:     "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>
Subject: RE: [PATCH v1 1/2] vfio/pci: Expose PCIe PASID capability to guest
Thread-Topic: [PATCH v1 1/2] vfio/pci: Expose PCIe PASID capability to guest
Thread-Index: AQHWAEVGBRqYALAjtUSFrIBsXSoVTKhiTLlg
Date:   Tue, 31 Mar 2020 06:39:17 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D801277@SHSMSX104.ccr.corp.intel.com>
References: <1584880394-11184-1-git-send-email-yi.l.liu@intel.com>
 <1584880394-11184-2-git-send-email-yi.l.liu@intel.com>
In-Reply-To: <1584880394-11184-2-git-send-email-yi.l.liu@intel.com>
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

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogU3VuZGF5LCBN
YXJjaCAyMiwgMjAyMCA4OjMzIFBNDQo+IA0KPiBGcm9tOiBMaXUgWWkgTCA8eWkubC5saXVAaW50
ZWwuY29tPg0KPiANCj4gVGhpcyBwYXRjaCBleHBvc2VzIFBDSWUgUEFTSUQgY2FwYWJpbGl0eSB0
byBndWVzdC4gRXhpc3RpbmcgdmZpb19wY2kNCj4gZHJpdmVyIGhpZGVzIGl0IGZyb20gZ3Vlc3Qg
Ynkgc2V0dGluZyB0aGUgY2FwYWJpbGl0eSBsZW5ndGggYXMgMCBpbg0KPiBwY2lfZXh0X2NhcF9s
ZW5ndGhbXS4NCj4gDQo+IFRoaXMgY2FwYWJpbGl0eSBpcyByZXF1aXJlZCBmb3IgdlNWQSBlbmFi
bGluZyBvbiBwYXNzLXRocm91Z2ggUENJZQ0KPiBkZXZpY2VzLg0KDQpzaG91bGQgdGhpcyBiZSBb
UEFUQ0ggMi8yXSwgYWZ0ZXIgeW91IGhhdmUgdGhlIGVtdWxhdGlvbiBpbiBwbGFjZT8NCg0KYW5k
IGl0IG1pZ2h0IGJlIHdvcnRoeSBvZiBub3RpbmcgdGhhdCBQUkkgaXMgYWxyZWFkeSBleHBvc2Vk
LCB0bw0KYXZvaWQgY29uZnVzaW9uIGZyb20gb25lIGxpa2UgbWUgdGhhdCB3aHkgdHdvIGNhcGFi
aWxpdGllcyBhcmUNCmVtdWxhdGVkIGluIHRoaXMgc2VyaWVzIHdoaWxlIG9ubHkgb25lIGlzIGJl
aW5nIGV4cG9zZWQuIPCfmIoNCg0KPiANCj4gQ2M6IEtldmluIFRpYW4gPGtldmluLnRpYW5AaW50
ZWwuY29tPg0KPiBDQzogSmFjb2IgUGFuIDxqYWNvYi5qdW4ucGFuQGxpbnV4LmludGVsLmNvbT4N
Cj4gQ2M6IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+IENj
OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+IENjOiBKZWFuLVBoaWxpcHBl
IEJydWNrZXIgPGplYW4tcGhpbGlwcGVAbGluYXJvLm9yZz4NCj4gU2lnbmVkLW9mZi1ieTogTGl1
IFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL3ZmaW8vcGNpL3Zm
aW9fcGNpX2NvbmZpZy5jIHwgMiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCsp
LCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92ZmlvL3BjaS92Zmlv
X3BjaV9jb25maWcuYw0KPiBiL2RyaXZlcnMvdmZpby9wY2kvdmZpb19wY2lfY29uZmlnLmMNCj4g
aW5kZXggOTBjMGI4MC4uNGI5YWY5OSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy92ZmlvL3BjaS92
ZmlvX3BjaV9jb25maWcuYw0KPiArKysgYi9kcml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNpX2NvbmZp
Zy5jDQo+IEBAIC05NSw3ICs5NSw3IEBAIHN0YXRpYyBjb25zdCB1MTYNCj4gcGNpX2V4dF9jYXBf
bGVuZ3RoW1BDSV9FWFRfQ0FQX0lEX01BWCArIDFdID0gew0KPiAgCVtQQ0lfRVhUX0NBUF9JRF9M
VFJdCT0JUENJX0VYVF9DQVBfTFRSX1NJWkVPRiwNCj4gIAlbUENJX0VYVF9DQVBfSURfU0VDUENJ
XQk9CTAsCS8qIG5vdCB5ZXQgKi8NCj4gIAlbUENJX0VYVF9DQVBfSURfUE1VWF0JPQkwLAkvKiBu
b3QgeWV0ICovDQo+IC0JW1BDSV9FWFRfQ0FQX0lEX1BBU0lEXQk9CTAsCS8qIG5vdCB5ZXQgKi8N
Cj4gKwlbUENJX0VYVF9DQVBfSURfUEFTSURdCT0JUENJX0VYVF9DQVBfUEFTSURfU0laRU9GLA0K
PiAgfTsNCj4gDQo+ICAvKg0KPiAtLQ0KPiAyLjcuNA0KDQo=
