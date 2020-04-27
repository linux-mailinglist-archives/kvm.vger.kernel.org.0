Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8791F1BA366
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 14:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgD0MNy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 08:13:54 -0400
Received: from mga18.intel.com ([134.134.136.126]:36255 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726260AbgD0MNy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 08:13:54 -0400
IronPort-SDR: MEqwtxPuxUHZghbiRCrRCvSJPHMVB0PLQFdGR8YGzZesJW28KvA2TDIYqj9hjA80E7OwfblgHv
 CHYSkaydC2jQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 05:13:53 -0700
IronPort-SDR: P+ES3/09k5okbPsjmEe90Y5EXZSSTDQHEDpu6Ju9eLqJiWjAk2/s5gafAER/KhR6uir0Iq7Zq8
 1YaGY2GzkAYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,324,1583222400"; 
   d="scan'208";a="458351210"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga005.fm.intel.com with ESMTP; 27 Apr 2020 05:13:37 -0700
Received: from fmsmsx114.amr.corp.intel.com (10.18.116.8) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 27 Apr 2020 05:13:38 -0700
Received: from shsmsx154.ccr.corp.intel.com (10.239.6.54) by
 FMSMSX114.amr.corp.intel.com (10.18.116.8) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 27 Apr 2020 05:13:37 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX154.ccr.corp.intel.com ([169.254.7.214]) with mapi id 14.03.0439.000;
 Mon, 27 Apr 2020 20:13:34 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@mellanox.com>
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
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Thread-Index: AQHWGDVStT24LxQ110qc/YDRWdRX86iDuewAgACI/wCAAD7wgIAAnasAgAFwKICAAOPOMIAAQj8AgACkdbD//7b+gIACl9WQgACeIICAAWn58A==
Date:   Mon, 27 Apr 2020 12:13:33 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D8D906E@SHSMSX104.ccr.corp.intel.com>
References: <20200421235442.GO11945@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D86EE26@SHSMSX104.ccr.corp.intel.com>
 <20200422115017.GQ11945@mellanox.com> <20200422211436.GA103345@otc-nc-03>
 <20200423191217.GD13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8960F9@SHSMSX104.ccr.corp.intel.com>
 <20200424124444.GJ13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8A808B@SHSMSX104.ccr.corp.intel.com>
 <20200424181203.GU13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8C5486@SHSMSX104.ccr.corp.intel.com>
 <20200426191357.GB13640@mellanox.com>
In-Reply-To: <20200426191357.GB13640@mellanox.com>
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
eSwgQXByaWwgMjcsIDIwMjAgMzoxNCBBTQ0KWy4uLl0NCj4gPiB0ZWNobmljYWxseSBTY2FsYWJs
ZSBJT1YgaXMgZGVmaW5pdGVseSBkaWZmZXJlbnQgZnJvbSBTUi1JT1YuIEl0J3MNCj4gPiBzaW1w
bGVyIGluIGhhcmR3YXJlLiBBbmQgd2UncmUgbm90IGVtdWxhdGluZyBTUi1JT1YuIFRoZSBwb2lu
dA0KPiA+IGlzIGp1c3QgaW4gdXNhZ2Utd2lzZSB3ZSB3YW50IHRvIHByZXNlbnQgYSBjb25zaXN0
ZW50IHVzZXINCj4gPiBleHBlcmllbmNlIGp1c3QgbGlrZSBwYXNzaW5nIHRocm91Z2ggYSBQQ0kg
ZW5kcG9pbnQgKFBGIG9yIFZGKSBkZXZpY2UNCj4gPiB0aHJvdWdoIHZmaW8gZWNvLXN5c3RlbSwg
aW5jbHVkaW5nIHZhcmlvdXMgdXNlcnNwYWNlIFZNTXMgKFFlbXUsDQo+ID4gZmlyZWNyYWNrZXIs
IHJ1c3Qtdm1tLCBldGMuKSwgbWlkZGxld2FyZSAoTGlidmlydCksIGFuZCBoaWdoZXIgbGV2ZWwN
Cj4gPiBtYW5hZ2VtZW50IHN0YWNrcy4NCj4gDQo+IFllcywgSSB1bmRlcnN0YW5kIHlvdXIgZGVz
aXJlLCBidXQgYXQgdGhlIHNhbWUgdGltZSB3ZSBoYXZlIG5vdCBiZWVuDQo+IGRvaW5nIGRldmlj
ZSBlbXVsYXRpb24gaW4gdGhlIGtlcm5lbC4gWW91IHNob3VsZCBhdCBsZWFzdCBiZQ0KPiBmb3J0
aHdyaWdodCBhYm91dCB0aGF0IG1ham9yIGNoYW5nZSBpbiB0aGUgY292ZXIgbGV0dGVycy9ldGMu
DQoNCkkgc2VhcmNoZWQgJ2VtdWxhdGUnIGluIGtlcm5lbC9Eb2N1bWVudGF0aW9uOg0KDQpEb2N1
bWVudGF0aW9uL3NvdW5kL2Fsc2EtY29uZmlndXJhdGlvbi5yc3QgKGVtdWxhdGUgb3NzIG9uIGFs
c2EpDQpEb2N1bWVudGF0aW9uL3NlY3VyaXR5L3RwbS90cG1fdnRwbV9wcm94eS5yc3QgKGVtdWxh
dGUgdmlydHVhbCBUUE0pDQpEb2N1bWVudGF0aW9uL25ldHdvcmtpbmcvZ2VuZXJpYy1oZGxjLnR4
dCAoZW11bGF0ZSBldGggb24gSERMQykNCkRvY3VtZW50YXRpb24vZ3B1L3RvZG8ucnN0IChnZW5l
cmljIGZiZGV2IGVtdWxhdGlvbikNCi4uLg0KDQpJIGJlbGlldmUgdGhlIG1haW4gcmVhc29uIHdo
eSBwdXR0aW5nIHN1Y2ggZW11bGF0aW9ucyBpbiBrZXJuZWwgaXMgDQpiZWNhdXNlIHRob3NlIGVt
dWxhdGVkIGRldmljZSBpbnRlcmZhY2VzIGhhdmUgdGhlaXIgZXN0YWJsaXNoZWQgDQplY28tc3lz
dGVtcyBhbmQgdmFsdWVzIHdoaWNoIHRoZSBrZXJuZWwgc2hvdWxkbid0IGJyZWFrLiBBcyB5b3Ug
DQplbXBoYXNpemUgZWFybGllciwgdGhleSBoYXZlIGdvb2QgcmVhc29ucyBmb3IgZ2V0dGluZyBp
bnRvIGtlcm5lbC4NCg0KVGhlbiBiYWNrIHRvIHRoaXMgY29udGV4dC4gQWxtb3N0IGV2ZXJ5IG5l
d2x5LWJvcm4gTGludXggVk1NDQooZmlyZWNyYWNrZXIsIGNyb3N2bSwgY2xvdWQgaHlwZXJ2aXNv
ciwgYW5kIHNvbWUgcHJvcHJpZXRhcnkgDQppbXBsZW1lbnRhdGlvbnMpIHN1cHBvcnQgb25seSB0
d28gdHlwZXMgb2YgZGV2aWNlczogdmlydGlvIGFuZCANCnZmaW8sIGJlY2F1c2UgdGhleSB3YW50
IHRvIGJlIHNpbXBsZSBhbmQgc2xpbS4gVmlydGlvIHByb3ZpZGVzIGEgDQpiYXNpYyBzZXQgb2Yg
SS9PIGNhcGFiaWxpdGllcyByZXF1aXJlZCBieSBtb3N0IFZNcywgd2hpbGUgdmZpbyBicmluZ3MN
CmFuIHVuaWZpZWQgaW50ZXJmYWNlIGZvciBnYWluaW5nIGFkZGVkIHZhbHVlcyBvciBoaWdoZXIg
cGVyZm9ybWFuY2UNCmZyb20gYXNzaWduZWQgZGV2aWNlcy4gRXZlbiBRZW11IHN1cHBvcnRzIGEg
bWluaW1hbCBjb25maWd1cmF0aW9uIA0KKCdtaWNyb3ZtJykgbm93LCBmb3Igc2ltaWxhciByZWFz
b24uICBTbyB0aGUgdmZpbyBlY28tc3lzdGVtIGlzIA0Kc2lnbmlmaWNhbnQgYW5kIHJlcHJlc2Vu
dHMgYSBtYWpvciB0cmVuZCBpbiB0aGUgdmlydHVhbGl6YXRpb24gc3BhY2UuDQoNClRoZW4gc3Vw
cG9ydGluZyB2ZmlvIGVjby1zeXN0ZW0gaXMgYWN0dWFsbHkgdGhlIHVzYWdlIEdPQUwgDQpvZiB0
aGlzIHBhdGNoIHNlcmllcywgaW5zdGVhZCBvZiBhbiBvcHRpb25hbCB0ZWNobmlxdWUgdG8gYmUg
b3B0ZWQuIA0KdmZpby1wY2kgaXMgdGhlcmUgZm9yIHBhc3NpbmcgdGhyb3VnaCBzdGFuZGFsb25l
IFBDSSBlbmRwb2ludHMgDQooUEYgb3IgVkYpLCBhbmQgdmZpby1tZGV2IGlzIHRoZXJlIGZvciBw
YXNzaW5nIHRocm91Z2ggc21hbGxlciANCnBvcnRpb24gb2YgZGV2aWNlIHJlc291cmNlcyBidXQg
c2hhcmluZyB0aGUgc2FtZSBWRklPIGludGVyZmFjZSANCnRvIGdhaW4gdGhlIHVuaWZvcm0gc3Vw
cG9ydCBpbiB0aGlzIGVjby1zeXN0ZW0uIA0KDQpJIGJlbGlldmUgYWJvdmUgaXMgdGhlIGdvb2Qg
cmVhc29uIGZvciBwdXR0aW5nIGVtdWxhdGlvbiBpbiBpZHhkIA0KZHJpdmVyIGJ5IHVzaW5nIHZm
aW8tbWRldi4gWWVzLCBpdCBkb2VzIGltcGx5IHRoYXQgdGhlcmUgd2lsbCBiZSANCm1vcmUgZW11
bGF0aW9ucyBpbiBrZXJuZWwgd2hlbiBtb3JlIFNjYWxhYmxlLUlPViAob3IgYWxpa2UpIA0KZGV2
aWNlcyBhcmUgaW50cm9kdWNlZC4gQnV0IGFzIGV4cGxhaW5lZCBlYXJsaWVyLCB0aGUgcGNpIGNv
bmZpZyANCnNwYWNlIGVtdWxhdGlvbiBjYW4gYmUgbGFyZ2VseSBjb25zb2xpZGF0ZWQgYW5kIHJl
dXNlZC4gYW5kIA0KdGhlIHJlbWFpbmluZyBkZXZpY2Ugc3BlY2lmaWMgTU1JTyBlbXVsYXRpb24g
aXMgcmVsYXRpdmVseSANCnNpbXBsZSBiZWNhdXNlIHdlIGRlZmluZSB2aXJ0dWFsIGRldmljZSBp
bnRlcmZhY2UgdG8gYmUgc2FtZSANCmFzIG9yIGV2ZW4gc2ltcGxlciB0aGFuIGEgVkYgaW50ZXJm
YWNlLiBPbmx5IGEgc21hbGwgc2V0IG9mIHJlZ2lzdGVycyANCmFyZSBlbXVsYXRlZCBhZnRlciBm
YXN0LXBhdGggcmVzb3VyY2UgaXMgcGFzc2VkIHRocm91Z2gsIGFuZCANCnN1Y2ggc21hbGwgc2V0
IG9mIGNvdXJzZSBuZWVkcyB0byBtZWV0IHRoZSBub3JtYWwgcXVhbGl0eSANCnJlcXVpcmVtZW50
IGZvciBnZXR0aW5nIGludG8gdGhlIGtlcm5lbC4NCg0KV2UnbGwgZGVmaW5pdGVseSBoaWdobGln
aHQgdGhpcyBwYXJ0IGluIGZ1dHVyZSBjb3ZlciBsZXR0ZXIuIPCfmIoNCg0KPiANCj4gPiA+IFRo
ZSBvbmx5IHRoaW5nIHdlIGdldCBvdXQgb2YgdGhpcyBpcyBzb21lb25lIGRvZXNuJ3QgaGF2ZSB0
byB3cml0ZSBhDQo+ID4gPiBpZHhkIGVtdWxhdGlvbiBkcml2ZXIgaW4gcWVtdSwgaW5zdGVhZCB0
aGV5IGhhdmUgdG8gd3JpdGUgaXQgaW4gdGhlDQo+ID4gPiBrZXJuZWwuIEkgZG9uJ3Qgc2VlIGhv
dyB0aGF0IGlzIGEgd2luIGZvciB0aGUgZWNvc3lzdGVtLg0KPiA+DQo+ID4gTm8uIFRoZSBjbGVh
ciB3aW4gaXMgb24gbGV2ZXJhZ2luZyBjbGFzc2ljIFZGSU8gaW9tbXUgYW5kIGl0cyBlY28tc3lz
dGVtDQo+ID4gYXMgZXhwbGFpbmVkIGFib3ZlLg0KPiANCj4gdmRwYSBoYWQgbm8gcHJvYmxlbSBp
bXBsZW1lbnRpbmcgaW9tbXUgc3VwcG9ydCB3aXRob3V0IFZGSU8uIFRoaXMgd2FzDQo+IHRoZWly
IG9yaWdpbmFsIGFyZ3VtZW50IHRvbywgaXQgdHVybmVkIG91dCB0byBiZSBlcnJvbmVvdXMuDQo+
IA0KDQpFdmVyeSB3aGVlbCBjYW4gYmUgcmUtaW52ZW50ZWQuLi4gbXkgZ3V0LWZlZWxpbmcgaXMg
dGhhdCB2ZHBhIGlzIGZvciANCm9mZmxvYWRpbmcgZmFzdC1wYXRoIHZob3N0IG9wZXJhdGlvbnMg
dG8gdGhlIHVuZGVybHlpbmcgYWNjZWxlcmF0b3JzLiANCkl0IGlzIGp1c3QgYSB3ZWxjb21lZC9y
ZWFzb25hYmxlIGV4dGVuc2lvbiB0byB0aGUgZXhpc3RpbmcgdmlydGlvL3Zob3N0IA0KZWNvLXN5
c3RlbS4gRm9yIG90aGVyIHR5cGVzIG9mIGRldmljZXMgc3VjaCBhcyBpZHhkLCB3ZSByZWx5IG9u
IHRoZSB2ZmlvDQplY28tc3lzdGVtIHRvIGNhdGNoIHVwIGZhc3QtZXZvbHZpbmcgVk1NIHNwZWN0
cnVtLg0KDQpUaGFua3MNCktldmluDQo=
