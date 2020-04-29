Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4FD1BD886
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 11:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgD2Jm1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 05:42:27 -0400
Received: from mga03.intel.com ([134.134.136.65]:28882 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbgD2Jm1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Apr 2020 05:42:27 -0400
IronPort-SDR: xo69ecEk8AS8Rob5m1F3N5C8TJTAs+pf7aKWbkgKqCK6Up+vmEbPjeH3vfgIYVy7QmHui1HlF5
 e2Mv6vqvvCtg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 02:42:26 -0700
IronPort-SDR: P06UT7RnxCCt6Y3kfEANTRC7thNGtb/63Kl1unPMvlxEbJQAHDUTgwecjvpu4IcWNc9KJAWSwK
 hggMV3UGORpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,331,1583222400"; 
   d="scan'208";a="246796960"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga007.jf.intel.com with ESMTP; 29 Apr 2020 02:42:25 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 29 Apr 2020 02:42:25 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 29 Apr 2020 02:42:25 -0700
Received: from shsmsx154.ccr.corp.intel.com (10.239.6.54) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 29 Apr 2020 02:42:24 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX154.ccr.corp.intel.com ([169.254.7.214]) with mapi id 14.03.0439.000;
 Wed, 29 Apr 2020 17:42:21 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@mellanox.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "megha.dey@linux.intel.com" <megha.dey@linux.intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
Thread-Topic: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
Thread-Index: AQHWGDVStT24LxQ110qc/YDRWdRX86iDuewAgACI/wCAAD7wgIAAnasAgAFwKICAAOPOMIAAQj8AgACkdbD//7b+gIACl9WQgACeIICAAI58gIAAiiEAgAAWu4CAAAC9AIADZPhQ
Date:   Wed, 29 Apr 2020 09:42:20 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D8E34AA@SHSMSX104.ccr.corp.intel.com>
References: <20200423191217.GD13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8960F9@SHSMSX104.ccr.corp.intel.com>
 <20200424124444.GJ13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8A808B@SHSMSX104.ccr.corp.intel.com>
 <20200424181203.GU13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8C5486@SHSMSX104.ccr.corp.intel.com>
 <20200426191357.GB13640@mellanox.com> <20200426214355.29e19d33@x1.home>
 <20200427115818.GE13640@mellanox.com> <20200427071939.06aa300e@x1.home>
 <20200427132218.GG13640@mellanox.com>
In-Reply-To: <20200427132218.GG13640@mellanox.com>
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

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BtZWxsYW5veC5jb20+DQo+IFNlbnQ6IE1vbmRh
eSwgQXByaWwgMjcsIDIwMjAgOToyMiBQTQ0KPiANCj4gT24gTW9uLCBBcHIgMjcsIDIwMjAgYXQg
MDc6MTk6MzlBTSAtMDYwMCwgQWxleCBXaWxsaWFtc29uIHdyb3RlOg0KPiANCj4gPiA+IEl0IGlz
IG5vdCB0cml2aWFsIG1hc2tpbmcuIEl0IGlzIGEgMjAwMCBsaW5lIHBhdGNoIGRvaW5nIGNvbXBy
ZWhlbnNpdmUNCj4gPiA+IGVtdWxhdGlvbi4NCj4gPg0KPiA+IE5vdCBzdXJlIHdoYXQgeW91J3Jl
IHJlZmVycmluZyB0bywgSSBzZWUgYWJvdXQgMzAgbGluZXMgb2YgY29kZSBpbg0KPiA+IHZkY21f
dmlkeGRfY2ZnX3dyaXRlKCkgdGhhdCBzcGVjaWZpY2FsbHkgaGFuZGxlIHdyaXRlcyB0byB0aGUg
NCBCQVJzIGluDQo+ID4gY29uZmlnIHNwYWNlIGFuZCBtYXliZSBhIGNvdXBsZSBodW5kcmVkIGxp
bmVzIG9mIGNvZGUgaW4gdG90YWwgaGFuZGxpbmcNCj4gPiBjb25maWcgc3BhY2UgZW11bGF0aW9u
LiAgVGhhbmtzLA0KPiANCj4gTG9vayBhcm91bmQgdmlkeGRfZG9fY29tbWFuZCgpDQo+IA0KPiBJ
ZiBJIHVuZGVyc3RhbmQgdGhpcyBmbG93IHByb3Blcmx5Li4NCj4gDQoNCkhpLCBKYXNvbiwNCg0K
SSBndWVzcyB0aGUgMjAwMCBsaW5lcyBtb3N0bHkgcmVmZXIgdG8gdGhlIGNoYW5nZXMgaW4gbWRl
di5jIGFuZCB2ZGV2LmMuIA0KV2UgZGlkIGEgYnJlYWstZG93biBhbW9uZyB0aGVtOg0KDQoxKSB+
MTUwIExPQyBmb3IgdmRldiBpbml0aWFsaXphdGlvbg0KMikgfjE1MCBMT0MgZm9yIGNmZyBzcGFj
ZSBlbXVsYXRpb24NCjMpIH4yMzAgTE9DIGZvciBtbWlvIHIvdyBlbXVsYXRpb24NCjQpIH41MDAg
TE9DIGZvciBjb250cm9sbGluZyB0aGUgd29yayBxdWV1ZSAodmlkeGRfZG9fY29tbWFuZCksIA0K
dHJpZ2dlcmVkIGJ5IHdyaXRlIGVtdWxhdGlvbiBvZiBJRFhEX0NNRF9PRkZTRVQgcmVnaXN0ZXIN
CjUpIHRoZSByZW1haW5pbmcgbGluZXMgYXJlIGFsbCBhYm91dCB2ZmlvLW1kZXYgcmVnaXN0cmF0
aW9uL2NhbGxiYWNrcywNCmZvciByZXBvcnRpbmcgbW1pby9pcnEgcmVzb3VyY2UsIGV2ZW50ZmQs
IG1tYXAsIGV0Yy4NCg0KMS8yLzMpIGFyZSBwdXJlIGRldmljZSBlbXVsYXRpb24sIHdoaWNoIGNv
dW50cyBmb3IgfjUwMCBMT0MuIA0KDQo0KSBuZWVkcyBiZSBpbiB0aGUga2VybmVsIHJlZ2FyZGxl
c3Mgb2Ygd2hpY2ggdUFQSSBpcyB1c2VkLCBiZWNhdXNlIGl0DQp0YWxrcyB0byB0aGUgcGh5c2lj
YWwgd29yayBxdWV1ZSAoZW5hYmxlLCBkaXNhYmxlLCBkcmFpbiwgYWJvcnQsIHJlc2V0LCBldGMu
KQ0KDQpUaGVuIGlmIGp1c3QgdGFsa2luZyBhYm91dCB+NTAwIExPQyBlbXVsYXRpb24gY29kZSBs
ZWZ0IGluIHRoZSBrZXJuZWwsIA0KaXMgaXQgc3RpbGwgYSBiaWcgY29uY2VybiB0byB5b3U/IPCf
mIoNCg0KVGhhbmtzDQpLZXZpbg0K
