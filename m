Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14639198C76
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 08:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgCaGmY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 02:42:24 -0400
Received: from mga07.intel.com ([134.134.136.100]:28670 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbgCaGmY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 02:42:24 -0400
IronPort-SDR: 1dD4FeNwZRORgnTmh3EpD+TdNY/CXdXU+tNSVJJ149qze4l11V44IBHFtPZ63wQAsLWjJ5HmGP
 LsyHEafe6OKw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 23:42:23 -0700
IronPort-SDR: xoUG/BhU2jnZANEA8VZ2vxIgwIIacw3H+Zl+q0axYIZTylRMpn12afeVr1+JanZKvVh2UMDPKG
 3Xheiq5zLXSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,327,1580803200"; 
   d="scan'208";a="359407571"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga001.fm.intel.com with ESMTP; 30 Mar 2020 23:42:23 -0700
Received: from fmsmsx113.amr.corp.intel.com (10.18.116.7) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Mar 2020 23:42:23 -0700
Received: from shsmsx107.ccr.corp.intel.com (10.239.4.96) by
 FMSMSX113.amr.corp.intel.com (10.18.116.7) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Mar 2020 23:42:23 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX107.ccr.corp.intel.com ([169.254.9.191]) with mapi id 14.03.0439.000;
 Tue, 31 Mar 2020 14:42:19 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
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
Thread-Index: AQHWAEVGhyrNdpmwzkqkYesGE5wb06hhx4yAgACGaqA=
Date:   Tue, 31 Mar 2020 06:42:18 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A21A6F8@SHSMSX104.ccr.corp.intel.com>
References: <1584880394-11184-1-git-send-email-yi.l.liu@intel.com>
 <1584880394-11184-2-git-send-email-yi.l.liu@intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D801277@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D801277@SHSMSX104.ccr.corp.intel.com>
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

PiBGcm9tOiBUaWFuLCBLZXZpbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+IFNlbnQ6IFR1ZXNk
YXksIE1hcmNoIDMxLCAyMDIwIDI6MzkgUE0NCj4gVG86IExpdSwgWWkgTCA8eWkubC5saXVAaW50
ZWwuY29tPjsgYWxleC53aWxsaWFtc29uQHJlZGhhdC5jb207DQo+IFN1YmplY3Q6IFJFOiBbUEFU
Q0ggdjEgMS8yXSB2ZmlvL3BjaTogRXhwb3NlIFBDSWUgUEFTSUQgY2FwYWJpbGl0eSB0byBndWVz
dA0KPiANCj4gPiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gPiBTZW50
OiBTdW5kYXksIE1hcmNoIDIyLCAyMDIwIDg6MzMgUE0NCj4gPg0KPiA+IEZyb206IExpdSBZaSBM
IDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4NCj4gPiBUaGlzIHBhdGNoIGV4cG9zZXMgUENJZSBQ
QVNJRCBjYXBhYmlsaXR5IHRvIGd1ZXN0LiBFeGlzdGluZyB2ZmlvX3BjaQ0KPiA+IGRyaXZlciBo
aWRlcyBpdCBmcm9tIGd1ZXN0IGJ5IHNldHRpbmcgdGhlIGNhcGFiaWxpdHkgbGVuZ3RoIGFzIDAg
aW4NCj4gPiBwY2lfZXh0X2NhcF9sZW5ndGhbXS4NCj4gPg0KPiA+IFRoaXMgY2FwYWJpbGl0eSBp
cyByZXF1aXJlZCBmb3IgdlNWQSBlbmFibGluZyBvbiBwYXNzLXRocm91Z2ggUENJZQ0KPiA+IGRl
dmljZXMuDQo+IA0KPiBzaG91bGQgdGhpcyBiZSBbUEFUQ0ggMi8yXSwgYWZ0ZXIgeW91IGhhdmUg
dGhlIGVtdWxhdGlvbiBpbiBwbGFjZT8NCg0Kb2gsIHllcywgSSBjYW4gcmUtc2VxdWVuY2UgaXQu
DQoNCj4gYW5kIGl0IG1pZ2h0IGJlIHdvcnRoeSBvZiBub3RpbmcgdGhhdCBQUkkgaXMgYWxyZWFk
eSBleHBvc2VkLCB0bw0KPiBhdm9pZCBjb25mdXNpb24gZnJvbSBvbmUgbGlrZSBtZSB0aGF0IHdo
eSB0d28gY2FwYWJpbGl0aWVzIGFyZQ0KPiBlbXVsYXRlZCBpbiB0aGlzIHNlcmllcyB3aGlsZSBv
bmx5IG9uZSBpcyBiZWluZyBleHBvc2VkLiDwn5iKDQoNCmdvdCBpdC4gaXQgd291bGQgYmUgaGVs
cGZ1bC4gdGhhbmtzLg0KDQpSZWdhcmRzLA0KWWkgTGl1DQo=
