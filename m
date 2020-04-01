Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6A619A68E
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 09:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731981AbgDAHta (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 03:49:30 -0400
Received: from mga03.intel.com ([134.134.136.65]:23771 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731904AbgDAHt3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 03:49:29 -0400
IronPort-SDR: 356DoSE3ioZSTV1HBoh56gheFCcdU7F/GaQo+WPcCwOoy39SLqpmgDnCxbO/2cRHRBJwMVfCkH
 2PPX+j6Ly/og==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2020 00:49:28 -0700
IronPort-SDR: viX/72eZgR5TBuE+nmmuBHasyx1Gr5SSmgnAn9iq5110nLD/kkh4G/zh0p2zAcAmIIJyATsGEu
 +PsI3Y15y5uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,330,1580803200"; 
   d="scan'208";a="242153929"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga008.fm.intel.com with ESMTP; 01 Apr 2020 00:49:28 -0700
Received: from fmsmsx123.amr.corp.intel.com (10.18.125.38) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 1 Apr 2020 00:49:28 -0700
Received: from shsmsx107.ccr.corp.intel.com (10.239.4.96) by
 fmsmsx123.amr.corp.intel.com (10.18.125.38) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 1 Apr 2020 00:49:28 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX107.ccr.corp.intel.com ([169.254.9.191]) with mapi id 14.03.0439.000;
 Wed, 1 Apr 2020 15:49:24 +0800
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
Subject: RE: [PATCH v1 7/8] vfio/type1: Add VFIO_IOMMU_CACHE_INVALIDATE
Thread-Topic: [PATCH v1 7/8] vfio/type1: Add VFIO_IOMMU_CACHE_INVALIDATE
Thread-Index: AQHWAEUdcc1u01skwUmp6uBHREsZ66hgnxWAgANUS+A=
Date:   Wed, 1 Apr 2020 07:49:24 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A21D6DF@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
 <1584880325-10561-8-git-send-email-yi.l.liu@intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D7FF9F1@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D7FF9F1@SHSMSX104.ccr.corp.intel.com>
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

PiBGcm9tOiBUaWFuLCBLZXZpbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+IFNlbnQ6IE1vbmRh
eSwgTWFyY2ggMzAsIDIwMjAgODo1OCBQTQ0KPiBUbzogTGl1LCBZaSBMIDx5aS5sLmxpdUBpbnRl
bC5jb20+OyBhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbTsNCj4gU3ViamVjdDogUkU6IFtQQVRD
SCB2MSA3LzhdIHZmaW8vdHlwZTE6IEFkZCBWRklPX0lPTU1VX0NBQ0hFX0lOVkFMSURBVEUNCj4g
DQo+ID4gRnJvbTogTGl1LCBZaSBMIDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4gU2VudDogU3Vu
ZGF5LCBNYXJjaCAyMiwgMjAyMCA4OjMyIFBNDQo+ID4NCj4gPiBGcm9tOiBMaXUgWWkgTCA8eWku
bC5saXVAbGludXguaW50ZWwuY29tPg0KPiA+DQo+ID4gRm9yIFZGSU8gSU9NTVVzIHdpdGggdGhl
IHR5cGUgVkZJT19UWVBFMV9ORVNUSU5HX0lPTU1VLCBndWVzdCAib3ducyINCj4gPiB0aGUNCj4g
PiBmaXJzdC1sZXZlbC9zdGFnZS0xIHRyYW5zbGF0aW9uIHN0cnVjdHVyZXMsIHRoZSBob3N0IElP
TU1VIGRyaXZlciBoYXMNCj4gPiBubyBrbm93bGVkZ2Ugb2YgZmlyc3QtbGV2ZWwvc3RhZ2UtMSBz
dHJ1Y3R1cmUgY2FjaGUgdXBkYXRlcyB1bmxlc3MgdGhlDQo+ID4gZ3Vlc3QgaW52YWxpZGF0aW9u
IHJlcXVlc3RzIGFyZSB0cmFwcGVkIGFuZCBwcm9wYWdhdGVkIHRvIHRoZSBob3N0Lg0KPiA+DQo+
ID4gVGhpcyBwYXRjaCBhZGRzIGEgbmV3IElPQ1RMIFZGSU9fSU9NTVVfQ0FDSEVfSU5WQUxJREFU
RSB0byBwcm9wYWdhdGUNCj4gPiBndWVzdA0KPiA+IGZpcnN0LWxldmVsL3N0YWdlLTEgSU9NTVUg
Y2FjaGUgaW52YWxpZGF0aW9ucyB0byBob3N0IHRvIGVuc3VyZSBJT01NVQ0KPiA+IGNhY2hlIGNv
cnJlY3RuZXNzLg0KPiA+DQo+ID4gV2l0aCB0aGlzIHBhdGNoLCB2U1ZBIChWaXJ0dWFsIFNoYXJl
ZCBWaXJ0dWFsIEFkZHJlc3NpbmcpIGNhbiBiZSB1c2VkDQo+ID4gc2FmZWx5IGFzIHRoZSBob3N0
IElPTU1VIGlvdGxiIGNvcnJlY3RuZXNzIGFyZSBlbnN1cmVkLg0KPiA+DQo+ID4gQ2M6IEtldmlu
IFRpYW4gPGtldmluLnRpYW5AaW50ZWwuY29tPg0KPiA+IENDOiBKYWNvYiBQYW4gPGphY29iLmp1
bi5wYW5AbGludXguaW50ZWwuY29tPg0KPiA+IENjOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2ls
bGlhbXNvbkByZWRoYXQuY29tPg0KPiA+IENjOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhh
dC5jb20+DQo+ID4gQ2M6IEplYW4tUGhpbGlwcGUgQnJ1Y2tlciA8amVhbi1waGlsaXBwZUBsaW5h
cm8ub3JnPg0KPiA+IFNpZ25lZC1vZmYtYnk6IExpdSBZaSBMIDx5aS5sLmxpdUBsaW51eC5pbnRl
bC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQu
Y29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEphY29iIFBhbiA8amFjb2IuanVuLnBhbkBsaW51eC5p
bnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvdmZpby92ZmlvX2lvbW11X3R5cGUxLmMg
fCA0OQ0KPiA+ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4g
IGluY2x1ZGUvdWFwaS9saW51eC92ZmlvLmggICAgICAgfCAyMiArKysrKysrKysrKysrKysrKysN
Cj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCA3MSBpbnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy92ZmlvL3ZmaW9faW9tbXVfdHlwZTEuYw0KPiA+IGIvZHJpdmVycy92Zmlv
L3ZmaW9faW9tbXVfdHlwZTEuYyBpbmRleCBhODc3NzQ3Li45MzdlYzNmIDEwMDY0NA0KPiA+IC0t
LSBhL2RyaXZlcnMvdmZpby92ZmlvX2lvbW11X3R5cGUxLmMNCj4gPiArKysgYi9kcml2ZXJzL3Zm
aW8vdmZpb19pb21tdV90eXBlMS5jDQo+ID4gQEAgLTI0MjMsNiArMjQyMywxNSBAQCBzdGF0aWMg
bG9uZw0KPiA+IHZmaW9faW9tbXVfdHlwZTFfdW5iaW5kX2dwYXNpZChzdHJ1Y3QgdmZpb19pb21t
dSAqaW9tbXUsDQo+ID4gIAlyZXR1cm4gcmV0Ow0KPiA+ICB9DQo+ID4NCj4gPiArc3RhdGljIGlu
dCB2ZmlvX2NhY2hlX2ludl9mbihzdHJ1Y3QgZGV2aWNlICpkZXYsIHZvaWQgKmRhdGEpDQo+IA0K
PiB2ZmlvX2lvbW11X2NhY2hlX2ludl9mbg0KDQpnb3QgaXQuDQoNCj4gPiArew0KPiA+ICsJc3Ry
dWN0IGRvbWFpbl9jYXBzdWxlICpkYyA9IChzdHJ1Y3QgZG9tYWluX2NhcHN1bGUgKilkYXRhOw0K
PiA+ICsJc3RydWN0IGlvbW11X2NhY2hlX2ludmFsaWRhdGVfaW5mbyAqY2FjaGVfaW52X2luZm8g
PQ0KPiA+ICsJCShzdHJ1Y3QgaW9tbXVfY2FjaGVfaW52YWxpZGF0ZV9pbmZvICopIGRjLT5kYXRh
Ow0KPiA+ICsNCj4gPiArCXJldHVybiBpb21tdV9jYWNoZV9pbnZhbGlkYXRlKGRjLT5kb21haW4s
IGRldiwgY2FjaGVfaW52X2luZm8pOyB9DQo+ID4gKw0KPiA+ICBzdGF0aWMgbG9uZyB2ZmlvX2lv
bW11X3R5cGUxX2lvY3RsKHZvaWQgKmlvbW11X2RhdGEsDQo+ID4gIAkJCQkgICB1bnNpZ25lZCBp
bnQgY21kLCB1bnNpZ25lZCBsb25nIGFyZykgIHsgQEAgLQ0KPiAyNjI5LDYgKzI2MzgsNDYgQEAN
Cj4gPiBzdGF0aWMgbG9uZyB2ZmlvX2lvbW11X3R5cGUxX2lvY3RsKHZvaWQgKmlvbW11X2RhdGEs
DQo+ID4gIAkJfQ0KPiA+ICAJCWtmcmVlKGdiaW5kX2RhdGEpOw0KPiA+ICAJCXJldHVybiByZXQ7
DQo+ID4gKwl9IGVsc2UgaWYgKGNtZCA9PSBWRklPX0lPTU1VX0NBQ0hFX0lOVkFMSURBVEUpIHsN
Cj4gPiArCQlzdHJ1Y3QgdmZpb19pb21tdV90eXBlMV9jYWNoZV9pbnZhbGlkYXRlIGNhY2hlX2lu
djsNCj4gPiArCQl1MzIgdmVyc2lvbjsNCj4gPiArCQlpbnQgaW5mb19zaXplOw0KPiA+ICsJCXZv
aWQgKmNhY2hlX2luZm87DQo+ID4gKwkJaW50IHJldDsNCj4gPiArDQo+ID4gKwkJbWluc3ogPSBv
ZmZzZXRvZmVuZChzdHJ1Y3QNCj4gPiB2ZmlvX2lvbW11X3R5cGUxX2NhY2hlX2ludmFsaWRhdGUs
DQo+ID4gKwkJCQkgICAgZmxhZ3MpOw0KPiA+ICsNCj4gPiArCQlpZiAoY29weV9mcm9tX3VzZXIo
JmNhY2hlX2ludiwgKHZvaWQgX191c2VyICopYXJnLCBtaW5zeikpDQo+ID4gKwkJCXJldHVybiAt
RUZBVUxUOw0KPiA+ICsNCj4gPiArCQlpZiAoY2FjaGVfaW52LmFyZ3N6IDwgbWluc3ogfHwgY2Fj
aGVfaW52LmZsYWdzKQ0KPiA+ICsJCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiArDQo+ID4gKwkJLyog
R2V0IHRoZSB2ZXJzaW9uIG9mIHN0cnVjdCBpb21tdV9jYWNoZV9pbnZhbGlkYXRlX2luZm8gKi8N
Cj4gPiArCQlpZiAoY29weV9mcm9tX3VzZXIoJnZlcnNpb24sDQo+ID4gKwkJCSh2b2lkIF9fdXNl
ciAqKSAoYXJnICsgbWluc3opLCBzaXplb2YodmVyc2lvbikpKQ0KPiA+ICsJCQlyZXR1cm4gLUVG
QVVMVDsNCj4gPiArDQo+ID4gKwkJaW5mb19zaXplID0gaW9tbXVfdWFwaV9nZXRfZGF0YV9zaXpl
KA0KPiA+ICsJCQkJCUlPTU1VX1VBUElfQ0FDSEVfSU5WQUwsDQo+ID4gdmVyc2lvbik7DQo+ID4g
Kw0KPiA+ICsJCWNhY2hlX2luZm8gPSBremFsbG9jKGluZm9fc2l6ZSwgR0ZQX0tFUk5FTCk7DQo+
ID4gKwkJaWYgKCFjYWNoZV9pbmZvKQ0KPiA+ICsJCQlyZXR1cm4gLUVOT01FTTsNCj4gPiArDQo+
ID4gKwkJaWYgKGNvcHlfZnJvbV91c2VyKGNhY2hlX2luZm8sDQo+ID4gKwkJCSh2b2lkIF9fdXNl
ciAqKSAoYXJnICsgbWluc3opLCBpbmZvX3NpemUpKSB7DQo+ID4gKwkJCWtmcmVlKGNhY2hlX2lu
Zm8pOw0KPiA+ICsJCQlyZXR1cm4gLUVGQVVMVDsNCj4gPiArCQl9DQo+ID4gKw0KPiA+ICsJCW11
dGV4X2xvY2soJmlvbW11LT5sb2NrKTsNCj4gPiArCQlyZXQgPSB2ZmlvX2lvbW11X2Zvcl9lYWNo
X2Rldihpb21tdSwgdmZpb19jYWNoZV9pbnZfZm4sDQo+ID4gKwkJCQkJICAgIGNhY2hlX2luZm8p
Ow0KPiA+ICsJCW11dGV4X3VubG9jaygmaW9tbXUtPmxvY2spOw0KPiA+ICsJCWtmcmVlKGNhY2hl
X2luZm8pOw0KPiA+ICsJCXJldHVybiByZXQ7DQo+ID4gIAl9DQo+ID4NCj4gPiAgCXJldHVybiAt
RU5PVFRZOw0KPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGludXgvdmZpby5oIGIvaW5j
bHVkZS91YXBpL2xpbnV4L3ZmaW8uaA0KPiA+IGluZGV4IDIyMzViYzYuLjYyY2E3OTEgMTAwNjQ0
DQo+ID4gLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L3ZmaW8uaA0KPiA+ICsrKyBiL2luY2x1ZGUv
dWFwaS9saW51eC92ZmlvLmgNCj4gPiBAQCAtODk5LDYgKzg5OSwyOCBAQCBzdHJ1Y3QgdmZpb19p
b21tdV90eXBlMV9iaW5kIHsNCj4gPiAgICovDQo+ID4gICNkZWZpbmUgVkZJT19JT01NVV9CSU5E
CQlfSU8oVkZJT19UWVBFLCBWRklPX0JBU0UgKyAyMykNCj4gPg0KPiA+ICsvKioNCj4gPiArICog
VkZJT19JT01NVV9DQUNIRV9JTlZBTElEQVRFIC0gX0lPVyhWRklPX1RZUEUsIFZGSU9fQkFTRSAr
IDI0LA0KPiA+ICsgKgkJCXN0cnVjdCB2ZmlvX2lvbW11X3R5cGUxX2NhY2hlX2ludmFsaWRhdGUp
DQo+ID4gKyAqDQo+ID4gKyAqIFByb3BhZ2F0ZSBndWVzdCBJT01NVSBjYWNoZSBpbnZhbGlkYXRp
b24gdG8gdGhlIGhvc3QuIFRoZSBjYWNoZQ0KPiA+ICsgKiBpbnZhbGlkYXRpb24gaW5mb3JtYXRp
b24gaXMgY29udmV5ZWQgYnkgQGNhY2hlX2luZm8sIHRoZSBjb250ZW50DQo+ID4gKyAqIGZvcm1h
dCB3b3VsZCBiZSBzdHJ1Y3R1cmVzIGRlZmluZWQgaW4gdWFwaS9saW51eC9pb21tdS5oLiBVc2Vy
DQo+ID4gKyAqIHNob3VsZCBiZSBhd2FyZSBvZiB0aGF0IHRoZSBzdHJ1Y3QgIGlvbW11X2NhY2hl
X2ludmFsaWRhdGVfaW5mbw0KPiA+ICsgKiBoYXMgYSBAdmVyc2lvbiBmaWVsZCwgdmZpbyBuZWVk
cyB0byBwYXJzZSB0aGlzIGZpZWxkIGJlZm9yZQ0KPiA+ICtnZXR0aW5nDQo+ID4gKyAqIGRhdGEg
ZnJvbSB1c2Vyc3BhY2UuDQo+ID4gKyAqDQo+ID4gKyAqIEF2YWlsYWJpbGl0eSBvZiB0aGlzIElP
Q1RMIGlzIGFmdGVyIFZGSU9fU0VUX0lPTU1VLg0KPiA+ICsgKg0KPiA+ICsgKiByZXR1cm5zOiAw
IG9uIHN1Y2Nlc3MsIC1lcnJubyBvbiBmYWlsdXJlLg0KPiA+ICsgKi8NCj4gPiArc3RydWN0IHZm
aW9faW9tbXVfdHlwZTFfY2FjaGVfaW52YWxpZGF0ZSB7DQo+ID4gKwlfX3UzMiAgIGFyZ3N6Ow0K
PiA+ICsJX191MzIgICBmbGFnczsNCj4gPiArCXN0cnVjdAlpb21tdV9jYWNoZV9pbnZhbGlkYXRl
X2luZm8gY2FjaGVfaW5mbzsNCj4gPiArfTsNCj4gPiArI2RlZmluZSBWRklPX0lPTU1VX0NBQ0hF
X0lOVkFMSURBVEUgICAgICBfSU8oVkZJT19UWVBFLCBWRklPX0JBU0UgKw0KPiA+IDI0KQ0KPiA+
ICsNCj4gPiAgLyogLS0tLS0tLS0gQWRkaXRpb25hbCBBUEkgZm9yIFNQQVBSIFRDRSAoU2VydmVy
IFBPV0VSUEMpIElPTU1VDQo+ID4gLS0tLS0tLS0gKi8NCj4gPg0KPiA+ICAvKg0KPiA+IC0tDQo+
ID4gMi43LjQNCj4gDQo+IFRoaXMgcGF0Y2ggbG9va3MgZ29vZCB0byBtZSBpbiBnZW5lcmFsLiBC
dXQgc2luY2UgdGhlcmUgaXMgc3RpbGwgYSBtYWpvciBvcGVuIGFib3V0DQo+IHZlcnNpb24gY29t
cGF0aWJpbGl0eSwgSSdsbCBob2xkIG15IHItYiB1bnRpbCB0aGF0IG9wZW4gaXMgY2xvc2VkLiDw
n5iKDQo+IA0KDQp0aGFua3MsDQoNClJlZ2FyZHMsDQpZaSBMaXUNCg==
