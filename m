Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B44AC19F055
	for <lists+kvm@lfdr.de>; Mon,  6 Apr 2020 08:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgDFG3h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 02:29:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:33202 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726486AbgDFG3h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Apr 2020 02:29:37 -0400
IronPort-SDR: OcmwFdCSyM50eK6y86cGoaZMn2oORlS0fFjfH/CPr7qX4mnhCST10SCu6bbfHNuef5e2KOULaQ
 sa/9It9lQZ9w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2020 23:29:36 -0700
IronPort-SDR: 7e5L34Y+rt3E7GG9GfybLo7T4EOEtglNQ7+WMHvNTxahyFk7KZ5UFlI+0W46C7I61/CGt+apdu
 m0aSTz8EJbJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,350,1580803200"; 
   d="scan'208";a="285778220"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga002.fm.intel.com with ESMTP; 05 Apr 2020 23:29:36 -0700
Received: from fmsmsx113.amr.corp.intel.com (10.18.116.7) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sun, 5 Apr 2020 23:29:36 -0700
Received: from shsmsx102.ccr.corp.intel.com (10.239.4.154) by
 FMSMSX113.amr.corp.intel.com (10.18.116.7) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sun, 5 Apr 2020 23:29:36 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 shsmsx102.ccr.corp.intel.com ([169.254.2.138]) with mapi id 14.03.0439.000;
 Mon, 6 Apr 2020 14:29:32 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Auger Eric <eric.auger@redhat.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "jean-philippe.brucker@arm.com" <jean-philippe.brucker@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
CC:     "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "zhangfei.gao@gmail.com" <zhangfei.gao@gmail.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [PATCH v10 04/11] vfio/pci: Add VFIO_REGION_TYPE_NESTED region
 type
Thread-Topic: [PATCH v10 04/11] vfio/pci: Add VFIO_REGION_TYPE_NESTED region
 type
Thread-Index: AQHV/tNxynbYpV5vT0iLn8klxfIfp6hkUe3A//995QCAB+uK0A==
Date:   Mon, 6 Apr 2020 06:29:32 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A222F4C@SHSMSX104.ccr.corp.intel.com>
References: <20200320161911.27494-1-eric.auger@redhat.com>
 <20200320161911.27494-5-eric.auger@redhat.com>
 <A2975661238FB949B60364EF0F2C25743A21DBDF@SHSMSX104.ccr.corp.intel.com>
 <893039be-265a-8c70-8e48-74122d9857de@redhat.com>
In-Reply-To: <893039be-265a-8c70-8e48-74122d9857de@redhat.com>
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

SGkgRXJpYywNCj4gRnJvbTogQXVnZXIgRXJpYyA8ZXJpYy5hdWdlckByZWRoYXQuY29tPg0KPiBT
ZW50OiBXZWRuZXNkYXksIEFwcmlsIDEsIDIwMjAgOTozMSBQTQ0KPiBUbzogTGl1LCBZaSBMIDx5
aS5sLmxpdUBpbnRlbC5jb20+OyBlcmljLmF1Z2VyLnByb0BnbWFpbC5jb207IGlvbW11QGxpc3Rz
LmxpbnV4LQ0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYxMCAwNC8xMV0gdmZpby9wY2k6IEFkZCBW
RklPX1JFR0lPTl9UWVBFX05FU1RFRCByZWdpb24NCj4gdHlwZQ0KPiANCj4gSGkgWWksDQo+IA0K
PiBPbiA0LzEvMjAgMzoxOCBQTSwgTGl1LCBZaSBMIHdyb3RlOg0KPiA+IEhpIEVyaWMsDQo+ID4N
Cj4gPiBKdXN0IGN1cmlvdXMgYWJvdXQgeW91ciBwbGFuIG9uIHRoaXMgcGF0Y2gsIEkganVzdCBo
ZWFyZCBteSBjb2xsZWFndWUNCj4gPiB3b3VsZCBsaWtlIHRvIHJlZmVyZW5jZSB0aGUgZnVuY3Rp
b25zIGZyb20gdGhpcyBwYXRjaCBpbiBoaXMgZHNhIGRyaXZlciB3b3JrLg0KPiANCj4gV2VsbCBJ
IGludGVuZCB0byByZXNwaW4gdW50aWwgc29tZWJvZHkgdGVsbHMgbWUgaXQgaXMgY29tcGxldGVs
eSB2YWluIG9yIGRlYWQgZm9sbG93cy4NCj4gSm9raW5nIGFzaWRlLCBmZWVsIGZyZWUgdG8gZW1i
ZWQgaXQgaW4gYW55IHNlcmllcyBpdCB3b3VsZCBiZSBiZW5lZmljaWFsIHRvLCBqdXN0IHBsZWFz
ZQ0KPiBjYyBtZSBpbiBjYXNlIGNvZGUgZGl2ZXJnZXMuDQoNCmdvdCBpdC4gUGxlYXNlIGFsc28g
Y2MgbWUgaW4gZnV0dXJlIHZlcnNpb24uIDotKQ0KDQpSZWdhcmRzLA0KWWkgTGl1DQoNCg==
