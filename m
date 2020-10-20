Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC0A12944A8
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 23:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392075AbgJTVmk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 17:42:40 -0400
Received: from mga12.intel.com ([192.55.52.136]:60056 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388389AbgJTVmj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 17:42:39 -0400
IronPort-SDR: oWD7aJO+9aCaVz8E4yZqY035NKu8Tqf96B1+Rl9lQFL0Drp4+HOYz3MxT7Z84+cpPBx+gfIcU1
 b1eNTMAwLQ2g==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="146575206"
X-IronPort-AV: E=Sophos;i="5.77,399,1596524400"; 
   d="scan'208";a="146575206"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 14:42:39 -0700
IronPort-SDR: p1qpXFKXDb6ZKvxCPPzZGTQl33oS8ZOfjW+Oq5TSQy+hmj+JsVia46fdvB/0jU9/6/89hb9ReG
 zuojuQr7TA3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,399,1596524400"; 
   d="scan'208";a="522518874"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 20 Oct 2020 14:42:38 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 20 Oct 2020 14:42:37 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 20 Oct 2020 14:42:37 -0700
Received: from orsmsx612.amr.corp.intel.com ([10.22.229.25]) by
 ORSMSX612.amr.corp.intel.com ([10.22.229.25]) with mapi id 15.01.1713.004;
 Tue, 20 Oct 2020 14:42:37 -0700
From:   "Dey, Megha" <megha.dey@intel.com>
To:     David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>
CC:     "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v3 02/18] iommu/vt-d: Add DEV-MSI support
Thread-Topic: [PATCH v3 02/18] iommu/vt-d: Add DEV-MSI support
Thread-Index: AQHWi7fVjGnhq3I0CUS9WCqUlcZf6qmCDfKAgAvggQCAE02SMA==
Date:   Tue, 20 Oct 2020 21:42:37 +0000
Message-ID: <c53ae7b0d2304bd9b49f305d4e0e9645@intel.com>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
         <160021246905.67751.1674517279122764758.stgit@djiang5-desk3.ch.intel.com>
         <87zh57glow.fsf@nanos.tec.linutronix.de>
 <8c035e92ec982d5ac257aeef4ec1f6f1f5d8c5c8.camel@infradead.org>
In-Reply-To: <8c035e92ec982d5ac257aeef4ec1f6f1f5d8c5c8.camel@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCkhpIERhdmlkLA0KIA0KPiBPbiBXZWQsIDIwMjAtMDktMzAgYXQgMjA6MzIgKzAyMDAsIFRo
b21hcyBHbGVpeG5lciB3cm90ZToNCj4gPiBPbiBUdWUsIFNlcCAxNSAyMDIwIGF0IDE2OjI3LCBE
YXZlIEppYW5nIHdyb3RlOg0KPiA+ID4gQEAgLTEzMDMsOSArMTMwMywxMCBAQCBzdGF0aWMgdm9p
ZA0KPiBpbnRlbF9pcnFfcmVtYXBwaW5nX3ByZXBhcmVfaXJ0ZShzdHJ1Y3QgaW50ZWxfaXJfZGF0
YSAqZGF0YSwNCj4gPiA+ICAJY2FzZSBYODZfSVJRX0FMTE9DX1RZUEVfSFBFVDoNCj4gPiA+ICAJ
Y2FzZSBYODZfSVJRX0FMTE9DX1RZUEVfUENJX01TSToNCj4gPiA+ICAJY2FzZSBYODZfSVJRX0FM
TE9DX1RZUEVfUENJX01TSVg6DQo+ID4gPiArCWNhc2UgWDg2X0lSUV9BTExPQ19UWVBFX0RFVl9N
U0k6DQo+ID4gPiAgCQlpZiAoaW5mby0+dHlwZSA9PSBYODZfSVJRX0FMTE9DX1RZUEVfSFBFVCkN
Cj4gPiA+ICAJCQlzZXRfaHBldF9zaWQoaXJ0ZSwgaW5mby0+ZGV2aWQpOw0KPiA+ID4gLQkJZWxz
ZQ0KPiA+ID4gKwkJZWxzZSBpZiAoaW5mby0+dHlwZSAhPSBYODZfSVJRX0FMTE9DX1RZUEVfREVW
X01TSSkNCj4gPiA+ICAJCQlzZXRfbXNpX3NpZChpcnRlLA0KPiA+ID4gIAkJCW1zaV9kZXNjX3Rv
X3BjaV9kZXYoaW5mby0+ZGVzYykpOw0KPiA+DQo+ID4gR2FoLiB0aGlzIHN0YXJ0cyB0byBiZWNv
bWUgdW5yZWFkYWJsZS4NCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2lvbW11L2ludGVs
L2lycV9yZW1hcHBpbmcuYw0KPiBiL2RyaXZlcnMvaW9tbXUvaW50ZWwvaXJxX3JlbWFwcGluZy5j
DQo+ID4gaW5kZXggOGY0Y2U3MjU3MGNlLi4wYzFlYThjZWVjMzEgMTAwNjQ0DQo+ID4gLS0tIGEv
ZHJpdmVycy9pb21tdS9pbnRlbC9pcnFfcmVtYXBwaW5nLmMNCj4gPiArKysgYi9kcml2ZXJzL2lv
bW11L2ludGVsL2lycV9yZW1hcHBpbmcuYw0KPiA+IEBAIC0xMjcxLDYgKzEyNzEsMTYgQEAgc3Rh
dGljIHN0cnVjdCBpcnFfY2hpcCBpbnRlbF9pcl9jaGlwID0gew0KPiA+ICAJLmlycV9zZXRfdmNw
dV9hZmZpbml0eQk9IGludGVsX2lyX3NldF92Y3B1X2FmZmluaXR5LA0KPiA+ICB9Ow0KPiA+DQo+
ID4gK3N0YXRpYyB2b2lkIGlydGVfcHJlcGFyZV9tc2coc3RydWN0IG1zaV9tc2cgKm1zZywgaW50
IGluZGV4LCBpbnQgc3ViaGFuZGxlKQ0KPiA+ICt7DQo+ID4gKwltc2ctPmFkZHJlc3NfaGkgPSBN
U0lfQUREUl9CQVNFX0hJOw0KPiA+ICsJbXNnLT5kYXRhID0gc3ViX2hhbmRsZTsNCj4gPiArCW1z
Zy0+YWRkcmVzc19sbyA9IE1TSV9BRERSX0JBU0VfTE8gfCBNU0lfQUREUl9JUl9FWFRfSU5UIHwN
Cj4gPiArCQkJICBNU0lfQUREUl9JUl9TSFYgfA0KPiA+ICsJCQkgIE1TSV9BRERSX0lSX0lOREVY
MShpbmRleCkgfA0KPiA+ICsJCQkgIE1TSV9BRERSX0lSX0lOREVYMihpbmRleCk7DQo+ID4gK30N
Cj4gPiArDQo+ID4gIHN0YXRpYyB2b2lkIGludGVsX2lycV9yZW1hcHBpbmdfcHJlcGFyZV9pcnRl
KHN0cnVjdCBpbnRlbF9pcl9kYXRhICpkYXRhLA0KPiA+ICAJCQkJCSAgICAgc3RydWN0IGlycV9j
ZmcgKmlycV9jZmcsDQo+ID4gIAkJCQkJICAgICBzdHJ1Y3QgaXJxX2FsbG9jX2luZm8gKmluZm8s
DQo+ID4gQEAgLTEzMTIsMTkgKzEzMjIsMTggQEAgc3RhdGljIHZvaWQNCj4gaW50ZWxfaXJxX3Jl
bWFwcGluZ19wcmVwYXJlX2lydGUoc3RydWN0IGludGVsX2lyX2RhdGEgKmRhdGEsDQo+ID4gIAkJ
YnJlYWs7DQo+ID4NCj4gPiAgCWNhc2UgWDg2X0lSUV9BTExPQ19UWVBFX0hQRVQ6DQo+ID4gKwkJ
c2V0X2hwZXRfc2lkKGlydGUsIGluZm8tPmhwZXRfaWQpOw0KPiA+ICsJCWlydGVfcHJlcGFyZV9t
c2cobXNnLCBpbmRleCwgc3ViX2hhbmRsZSk7DQo+ID4gKwkJYnJlYWs7DQo+ID4gKw0KPiA+ICAJ
Y2FzZSBYODZfSVJRX0FMTE9DX1RZUEVfTVNJOg0KPiA+ICAJY2FzZSBYODZfSVJRX0FMTE9DX1RZ
UEVfTVNJWDoNCj4gPiAtCQlpZiAoaW5mby0+dHlwZSA9PSBYODZfSVJRX0FMTE9DX1RZUEVfSFBF
VCkNCj4gPiAtCQkJc2V0X2hwZXRfc2lkKGlydGUsIGluZm8tPmhwZXRfaWQpOw0KPiA+IC0JCWVs
c2UNCj4gPiAtCQkJc2V0X21zaV9zaWQoaXJ0ZSwgaW5mby0+bXNpX2Rldik7DQo+ID4gLQ0KPiA+
IC0JCW1zZy0+YWRkcmVzc19oaSA9IE1TSV9BRERSX0JBU0VfSEk7DQo+ID4gLQkJbXNnLT5kYXRh
ID0gc3ViX2hhbmRsZTsNCj4gPiAtCQltc2ctPmFkZHJlc3NfbG8gPSBNU0lfQUREUl9CQVNFX0xP
IHwNCj4gTVNJX0FERFJfSVJfRVhUX0lOVCB8DQo+ID4gLQkJCQkgIE1TSV9BRERSX0lSX1NIViB8
DQo+ID4gLQkJCQkgIE1TSV9BRERSX0lSX0lOREVYMShpbmRleCkgfA0KPiA+IC0JCQkJICBNU0lf
QUREUl9JUl9JTkRFWDIoaW5kZXgpOw0KPiA+ICsJCXNldF9tc2lfc2lkKGlydGUsIGluZm8tPm1z
aV9kZXYpOw0KPiA+ICsJCWlydGVfcHJlcGFyZV9tc2cobXNnLCBpbmRleCwgc3ViX2hhbmRsZSk7
DQo+ID4gKwkJYnJlYWs7DQo+ID4gKw0KPiA+ICsJY2FzZSBYODZfSVJRX0FMTE9DX1RZUEVfREVW
X01TSToNCj4gPiArCQlpcnRlX3ByZXBhcmVfbXNnKG1zZywgaW5kZXgsIHN1Yl9oYW5kbGUpOw0K
PiA+ICAJCWJyZWFrOw0KPiA+DQo+ID4gIAlkZWZhdWx0Og0KPiA+DQo+ID4gSG1tPw0KPiANCj4g
SXQnZCBnZXQgYSBiaXQgbmljZXIgaWYgeW91ICphbHdheXMqIGRpZCB0aGUgaXJ0ZV9wcmVwYXJl
X21zZygpIHBhcnQgdG8NCj4gZ2VuZXJhdGUgdGhlIE1TSSBtZXNzYWdlLiBMZXQgdGhlIElPQVBJ
QyBkcml2ZXIgc3dpenpsZSB0aGF0IGludG8gdGhlDQo+IElPQVBJQyBSVEUgZm9yIGl0c2VsZi4g
WW91IGhhdmUgbm8gYnVzaW5lc3MgY29tcG9zaW5nIGFuIElPQVBJQyBSVEUNCj4gaGVyZS4NCj4g
DQo+IFRoZW4geW91ciBzd2l0Y2ggc3RhdGVtZW50IGlzICpvbmx5KiBmb3Igc2V0dGluZyB0aGUg
U0lEIGluIHRoZSBJUlRFDQo+IGFwcHJvcHJpYXRlbHkuDQoNCkkgZG9u4oCZdCB0aGluayBJIGZ1
bGx5IHVuZGVyc3RhbmQgd2hhdCBuZWVkcyB0byBiZSBkb25lLCBidXQgaWYgd2UgbW92ZSB0aGUg
SU9BUElDIFJURSBjb25maWd1cmUgaW50byB0aGUgSU9BUElDIGRyaXZlciwgd291bGRuJ3QgdGhh
dCBtZWFuIHRoYXQgdGhlIElPQVBJQyBkcml2ZXIgc2hvdWxkIGJlIGF3YXJlIG9mIGludGVycnVw
dCByZW1hcHBpbmc/DQoNClJpZ2h0IG5vdyBJT0FQSUMgY2FzZSBoZXJlIGNvbmZpZ3VyZXMgYW4g
UlRFIGVudHJ5LCBhbmQgdGhlIE1TSSByZWxhdGVkIGNhc2VzIGNvbmZpZ3VyZSB0aGUgbXNpIG1l
c3NhZ2UodGhyb3VnaCB0aGUgaXJ0ZV9wcmVwYXJlX21zZygpKS4gU28gdW5sZXNzIGlydGVfcHJl
cGFyZV9tc2cgc29tZWhvdyBldmVuIGNvbmZpZ3VyZXMgSU9BUElDIG1lc3NhZ2UsIHdlIGNhbm5v
dCBhbHdheXMgZG8gaXJ0ZV9wcmVwYXJlX21zZyByaWdodD8gDQoNCkl0IHdvdWxkIGJlIGdyZWF0
IGlmIHlvdSBjb3VsZCBwcm92aWRlIHNvbWUgaW5zaWdodCBoZXJlIPCfmIogDQoNClRoYW5rcywN
Ck1lZ2hhDQo=
