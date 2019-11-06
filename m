Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54F39F10D9
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 09:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731275AbfKFIPg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 03:15:36 -0500
Received: from mga06.intel.com ([134.134.136.31]:17577 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729881AbfKFIPg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 03:15:36 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 00:15:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,274,1569308400"; 
   d="scan'208";a="200634902"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga008.fm.intel.com with ESMTP; 06 Nov 2019 00:15:35 -0800
Received: from fmsmsx154.amr.corp.intel.com (10.18.116.70) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 6 Nov 2019 00:15:35 -0800
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 FMSMSX154.amr.corp.intel.com (10.18.116.70) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 6 Nov 2019 00:15:35 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.127]) by
 SHSMSX152.ccr.corp.intel.com ([169.254.6.2]) with mapi id 14.03.0439.000;
 Wed, 6 Nov 2019 16:15:32 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Peter Xu <peterx@redhat.com>
CC:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: RE: [RFC v2 06/22] hw/pci: modify pci_setup_iommu() to set
 PCIIOMMUOps
Thread-Topic: [RFC v2 06/22] hw/pci: modify pci_setup_iommu() to set
 PCIIOMMUOps
Thread-Index: AQHVimsrLg5zO45FAU+j+AEc4se2MKd2JAeAgAe7wGA=
Date:   Wed, 6 Nov 2019 08:15:31 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A0EEF96@SHSMSX104.ccr.corp.intel.com>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <1571920483-3382-7-git-send-email-yi.l.liu@intel.com>
 <20191101180923.GG8888@xz-x1.metropole.lan>
In-Reply-To: <20191101180923.GG8888@xz-x1.metropole.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOTljOGNkYzYtZjRlNS00ODViLWFmZGEtNGEyMzY5YTUzOTg1IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoibEoyYzl2SWEyQ2FcL3RhNHBRenNJMk9EZGJwRW5xSnBzV202Wm1lNVBzTUorMnVyK1FCSVA3bjBMWUV4N2pmUDMifQ==
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQZXRlciBYdSBbbWFpbHRvOnBldGVyeEByZWRoYXQuY29tXQ0KPiBTZW50OiBTYXR1
cmRheSwgTm92ZW1iZXIgMiwgMjAxOSAyOjA5IEFNDQo+IFRvOiBMaXUsIFlpIEwgPHlpLmwubGl1
QGludGVsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtSRkMgdjIgMDYvMjJdIGh3L3BjaTogbW9kaWZ5
IHBjaV9zZXR1cF9pb21tdSgpIHRvIHNldCBQQ0lJT01NVU9wcw0KPiANCj4gT24gVGh1LCBPY3Qg
MjQsIDIwMTkgYXQgMDg6MzQ6MjdBTSAtMDQwMCwgTGl1IFlpIEwgd3JvdGU6DQo+ID4gVGhpcyBw
YXRjaCBtb2RpZmllcyBwY2lfc2V0dXBfaW9tbXUoKSB0byBzZXQgUENJSU9NTVVPcHMgaW5zdGVh
ZCBvZg0KPiA+IG9ubHkgc2V0dGluZyBQQ0lJT01NVUZ1bmMuIFBDSUlPTU1VRnVuYyBpcyBwcmV2
aW91c2x5IHVzZWQgdG8gZ2V0IGFuDQo+ID4gYWRkcmVzcyBzcGFjZSBmb3IgYSBkZXZpY2UgaW4g
dmVuZG9yIHNwZWNpZmljIHdheS4gVGhlIFBDSUlPTU1VT3BzDQo+ID4gc3RpbGwgb2ZmZXJzIHRo
aXMgZnVuY3Rpb25hbGl0eS4gVXNlIFBDSUlPTU1VT3BzIGxlYXZlcyBzcGFjZSB0byBhZGQNCj4g
PiBtb3JlIGlvbW11IHJlbGF0ZWQgdmVuZG9yIHNwZWNpZmljIG9wZXJhdGlvbnMuDQo+ID4NCj4g
PiBDYzogS2V2aW4gVGlhbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+ID4gQ2M6IEphY29iIFBh
biA8amFjb2IuanVuLnBhbkBsaW51eC5pbnRlbC5jb20+DQo+ID4gQ2M6IFBldGVyIFh1IDxwZXRl
cnhAcmVkaGF0LmNvbT4NCj4gPiBDYzogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29t
Pg0KPiA+IENjOiBZaSBTdW4gPHlpLnkuc3VuQGxpbnV4LmludGVsLmNvbT4NCj4gPiBDYzogRGF2
aWQgR2lic29uIDxkYXZpZEBnaWJzb24uZHJvcGJlYXIuaWQuYXU+DQo+ID4gU2lnbmVkLW9mZi1i
eTogTGl1IFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gDQo+IFJldmlld2VkLWJ5OiBQZXRl
ciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQoNClRoYW5rcyBmb3IgdGhlIHJldmlldy4NCg0KUmVn
YXJkcywNCllpIExpdQ0K
