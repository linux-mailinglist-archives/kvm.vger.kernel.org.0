Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC1519AC09
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 14:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732543AbgDAMwF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 08:52:05 -0400
Received: from mga06.intel.com ([134.134.136.31]:17420 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732296AbgDAMwF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 08:52:05 -0400
IronPort-SDR: wfVLoYYsZe4IK3FbAViubC//Jq9rte9S+OMuaUQiJK/HFl4z26ET1W8bPKI58wf3OeOkaBIRcF
 pKQ/GWOEE2Ug==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2020 05:52:04 -0700
IronPort-SDR: mARSEAqYVJ6C6D6b35OEX3tlAKOtDWH3rdn0XTNobRLr1MupdzSy7Ipt8iOv4A8rs6pJN1Xo26
 c6oQZydb8TkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,331,1580803200"; 
   d="scan'208";a="395967696"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga004.jf.intel.com with ESMTP; 01 Apr 2020 05:52:03 -0700
Received: from fmsmsx154.amr.corp.intel.com (10.18.116.70) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 1 Apr 2020 05:52:03 -0700
Received: from shsmsx108.ccr.corp.intel.com (10.239.4.97) by
 FMSMSX154.amr.corp.intel.com (10.18.116.70) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 1 Apr 2020 05:52:03 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX108.ccr.corp.intel.com ([169.254.8.7]) with mapi id 14.03.0439.000;
 Wed, 1 Apr 2020 20:51:59 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Auger Eric <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
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
Subject: RE: [PATCH v1 5/8] vfio/type1: Report 1st-level/stage-1 format to
 userspace
Thread-Topic: [PATCH v1 5/8] vfio/type1: Report 1st-level/stage-1 format to
 userspace
Thread-Index: AQHWAEUcqZEEdiOKbEGofjWp2Yic+6hjfq+AgAC/vLA=
Date:   Wed, 1 Apr 2020 12:51:58 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A21DB4E@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
 <1584880325-10561-6-git-send-email-yi.l.liu@intel.com>
 <cb68e9ab-77b0-7e97-a661-4836962041d9@redhat.com>
In-Reply-To: <cb68e9ab-77b0-7e97-a661-4836962041d9@redhat.com>
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

SGkgRXJpYywNCg0KPiBGcm9tOiBBdWdlciBFcmljIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IFdlZG5lc2RheSwgQXByaWwgMSwgMjAyMCA0OjUxIFBNDQo+IFRvOiBMaXUsIFlpIEwg
PHlpLmwubGl1QGludGVsLmNvbT47IGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tDQo+IFN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggdjEgNS84XSB2ZmlvL3R5cGUxOiBSZXBvcnQgMXN0LWxldmVsL3N0YWdl
LTEgZm9ybWF0IHRvDQo+IHVzZXJzcGFjZQ0KPiANCj4gSGkgWWksDQo+IE9uIDMvMjIvMjAgMToz
MiBQTSwgTGl1LCBZaSBMIHdyb3RlOg0KPiA+IEZyb206IExpdSBZaSBMIDx5aS5sLmxpdUBpbnRl
bC5jb20+DQo+ID4NCj4gPiBWRklPIGV4cG9zZXMgSU9NTVUgbmVzdGluZyB0cmFuc2xhdGlvbiAo
YS5rLmEgZHVhbCBzdGFnZSB0cmFuc2xhdGlvbikNCj4gPiBjYXBhYmlsaXR5IHRvIHVzZXJzcGFj
ZS4gVGh1cyBhcHBsaWNhdGlvbnMgbGlrZSBRRU1VIGNvdWxkIHN1cHBvcnQNCj4gPiB2SU9NTVUg
d2l0aCBoYXJkd2FyZSdzIG5lc3RpbmcgdHJhbnNsYXRpb24gY2FwYWJpbGl0eSBmb3IgcGFzcy10
aHJvdWdoDQo+ID4gZGV2aWNlcy4gQmVmb3JlIHNldHRpbmcgdXAgbmVzdGluZyB0cmFuc2xhdGlv
biBmb3IgcGFzcy10aHJvdWdoIGRldmljZXMsDQo+ID4gUUVNVSBhbmQgb3RoZXIgYXBwbGljYXRp
b25zIG5lZWQgdG8gbGVhcm4gdGhlIHN1cHBvcnRlZCAxc3QtbHZsL3N0YWdlLTENCj4gPiB0cmFu
c2xhdGlvbiBzdHJ1Y3R1cmUgZm9ybWF0IGxpa2UgcGFnZSB0YWJsZSBmb3JtYXQuDQo+ID4NCj4g
PiBUYWtlIHZTVkEgKHZpcnR1YWwgU2hhcmVkIFZpcnR1YWwgQWRkcmVzc2luZykgYXMgYW4gZXhh
bXBsZSwgdG8gc3VwcG9ydA0KPiA+IHZTVkEgZm9yIHBhc3MtdGhyb3VnaCBkZXZpY2VzLCBRRU1V
IHNldHVwIG5lc3RpbmcgdHJhbnNsYXRpb24gZm9yIHBhc3MtDQo+ID4gdGhyb3VnaCBkZXZpY2Vz
LiBUaGUgZ3Vlc3QgcGFnZSB0YWJsZSBhcmUgY29uZmlndXJlZCB0byBob3N0IGFzIDFzdC1sdmwv
DQo+ID4gc3RhZ2UtMSBwYWdlIHRhYmxlLiBUaGVyZWZvcmUsIGd1ZXN0IGZvcm1hdCBzaG91bGQg
YmUgY29tcGF0aWJsZSB3aXRoDQo+ID4gaG9zdCBzaWRlLg0KPiA+DQo+ID4gVGhpcyBwYXRjaCBy
ZXBvcnRzIHRoZSBzdXBwb3J0ZWQgMXN0LWx2bC9zdGFnZS0xIHBhZ2UgdGFibGUgZm9ybWF0IG9u
IHRoZQ0KPiA+IGN1cnJlbnQgcGxhdGZvcm0gdG8gdXNlcnNwYWNlLiBRRU1VIGFuZCBvdGhlciBh
bGlrZSBhcHBsaWNhdGlvbnMgc2hvdWxkDQo+ID4gdXNlIHRoaXMgZm9ybWF0IGluZm8gd2hlbiB0
cnlpbmcgdG8gc2V0dXAgSU9NTVUgbmVzdGluZyB0cmFuc2xhdGlvbiBvbg0KPiA+IGhvc3QgSU9N
TVUuDQo+ID4NCj4gPiBDYzogS2V2aW4gVGlhbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+ID4g
Q0M6IEphY29iIFBhbiA8amFjb2IuanVuLnBhbkBsaW51eC5pbnRlbC5jb20+DQo+ID4gQ2M6IEFs
ZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+ID4gQ2M6IEVyaWMg
QXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4NCj4gPiBDYzogSmVhbi1QaGlsaXBwZSBCcnVj
a2VyIDxqZWFuLXBoaWxpcHBlQGxpbmFyby5vcmc+DQo+ID4gU2lnbmVkLW9mZi1ieTogTGl1IFlp
IEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy92ZmlvL3ZmaW9f
aW9tbXVfdHlwZTEuYyB8IDU2DQo+ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrDQo+ID4gIGluY2x1ZGUvdWFwaS9saW51eC92ZmlvLmggICAgICAgfCAgMSArDQo+ID4g
IDIgZmlsZXMgY2hhbmdlZCwgNTcgaW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvdmZpby92ZmlvX2lvbW11X3R5cGUxLmMgYi9kcml2ZXJzL3ZmaW8vdmZpb19pb21t
dV90eXBlMS5jDQo+ID4gaW5kZXggOWFhMmE2Ny4uODJhOWUwYiAxMDA2NDQNCj4gPiAtLS0gYS9k
cml2ZXJzL3ZmaW8vdmZpb19pb21tdV90eXBlMS5jDQo+ID4gKysrIGIvZHJpdmVycy92ZmlvL3Zm
aW9faW9tbXVfdHlwZTEuYw0KPiA+IEBAIC0yMjM0LDExICsyMjM0LDY2IEBAIHN0YXRpYyBpbnQg
dmZpb19pb21tdV90eXBlMV9wYXNpZF9mcmVlKHN0cnVjdA0KPiB2ZmlvX2lvbW11ICppb21tdSwN
Cj4gPiAgCXJldHVybiByZXQ7DQo+ID4gIH0NCj4gPg0KPiA+ICtzdGF0aWMgaW50IHZmaW9faW9t
bXVfZ2V0X3N0YWdlMV9mb3JtYXQoc3RydWN0IHZmaW9faW9tbXUgKmlvbW11LA0KPiA+ICsJCQkJ
CSB1MzIgKnN0YWdlMV9mb3JtYXQpDQo+IHZmaW9fcGFzaWRfZm9ybWF0KCkgdG8gYmUgaG9tb2dl
bmVvdXMgd2l0aCB2ZmlvX3Bnc2l6ZV9iaXRtYXAoKSB3aGljaA0KPiBkb2VzIHRoZSBzYW1lIGtp
bmQgb2YgZW51bWVyYXRpb24gb2YgdGhlIHZmaW9faW9tbXUgZG9tYWlucw0KDQp5ZXMsIHNpbWls
YXIuDQoNCj4gPiArew0KPiA+ICsJc3RydWN0IHZmaW9fZG9tYWluICpkb21haW47DQo+ID4gKwl1
MzIgZm9ybWF0ID0gMCwgdG1wX2Zvcm1hdCA9IDA7DQo+ID4gKwlpbnQgcmV0Ow0KPiByZXQgPSAt
RUlOVkFMOw0KDQpnb3QgaXQuDQoNCj4gPiArDQo+ID4gKwltdXRleF9sb2NrKCZpb21tdS0+bG9j
ayk7DQo+ID4gKwlpZiAobGlzdF9lbXB0eSgmaW9tbXUtPmRvbWFpbl9saXN0KSkgew0KPiBnb3Rv
IG91dF91bmxvY2s7DQoNCnJpZ2h0Lg0KPiA+ICsJCW11dGV4X3VubG9jaygmaW9tbXUtPmxvY2sp
Ow0KPiA+ICsJCXJldHVybiAtRUlOVkFMOw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCWxpc3RfZm9y
X2VhY2hfZW50cnkoZG9tYWluLCAmaW9tbXUtPmRvbWFpbl9saXN0LCBuZXh0KSB7DQo+ID4gKwkJ
aWYgKGlvbW11X2RvbWFpbl9nZXRfYXR0cihkb21haW4tPmRvbWFpbiwNCj4gPiArCQkJRE9NQUlO
X0FUVFJfUEFTSURfRk9STUFULCAmZm9ybWF0KSkgew0KPiBJIGNhbiBmaW5kIERPTUFJTl9BVFRS
X1BBU0lEX0ZPUk1BVCBpbiBKYWNvYidzIHY5IGJ1dCBub3QgaW4gdjEwDQoNCm9vcHMsIEkgZ3Vl
c3MgaGUgc29tZWhvdyBtaXNzZWQuIHlvdSBtYXkgZmluZCBpdCBpbiBiZWxvdyBsaW5rLg0KDQpo
dHRwczovL2dpdGh1Yi5jb20vbHV4aXMxOTk5L2xpbnV4LXZzdmEvY29tbWl0L2JmMTRiMTFhMTJm
NzRkNThhZDNlZTYyNmE1ZDg5MWRlMzk1MDgyZWINCg0KPiA+ICsJCQlyZXQgPSAtRUlOVkFMOw0K
PiBjb3VsZCBiZSByZW1vdmVkDQoNCnN1cmUuDQoNCj4gPiArCQkJZm9ybWF0ID0gMDsNCj4gPiAr
CQkJZ290byBvdXRfdW5sb2NrOw0KPiA+ICsJCX0NCj4gPiArCQkvKg0KPiA+ICsJCSAqIGZvcm1h
dCBpcyBhbHdheXMgbm9uLXplcm8gKHRoZSBmaXJzdCBmb3JtYXQgaXMNCj4gPiArCQkgKiBJT01N
VV9QQVNJRF9GT1JNQVRfSU5URUxfVlREIHdoaWNoIGlzIDEpLiBGb3INCj4gPiArCQkgKiB0aGUg
cmVhc29uIG9mIHBvdGVudGlhbCBkaWZmZXJlbnQgYmFja2VkIElPTU1VDQo+ID4gKwkJICogZm9y
bWF0cywgaGVyZSB3ZSBleHBlY3QgdG8gaGF2ZSBpZGVudGljYWwgZm9ybWF0cw0KPiA+ICsJCSAq
IGluIHRoZSBkb21haW4gbGlzdCwgbm8gbWl4ZWQgZm9ybWF0cyBzdXBwb3J0Lg0KPiA+ICsJCSAq
IHJldHVybiAtRUlOVkFMIHRvIGZhaWwgdGhlIGF0dGVtcHQgb2Ygc2V0dXANCj4gPiArCQkgKiBW
RklPX1RZUEUxX05FU1RJTkdfSU9NTVUgaWYgbm9uLWlkZW50aWNhbCBmb3JtYXRzDQo+ID4gKwkJ
ICogYXJlIGRldGVjdGVkLg0KPiA+ICsJCSAqLw0KPiA+ICsJCWlmICh0bXBfZm9ybWF0ICYmIHRt
cF9mb3JtYXQgIT0gZm9ybWF0KSB7DQo+ID4gKwkJCXJldCA9IC1FSU5WQUw7DQo+IGNvdWxkIGJl
IHJlbW92ZWQNCg0KZ290IGl0Lg0KDQo+ID4gKwkJCWZvcm1hdCA9IDA7DQo+ID4gKwkJCWdvdG8g
b3V0X3VubG9jazsNCj4gPiArCQl9DQo+ID4gKw0KPiA+ICsJCXRtcF9mb3JtYXQgPSBmb3JtYXQ7
DQo+ID4gKwl9DQo+ID4gKwlyZXQgPSAwOw0KPiA+ICsNCj4gPiArb3V0X3VubG9jazoNCj4gPiAr
CWlmIChmb3JtYXQpDQo+IGlmICghcmV0KSA/IHRoZW4geW91IGNhbiByZW1vdmUgdGhlIGZvcm1h
dCA9IDAgaW4gY2FzZSBvZiBlcnJvci4NCg0Kb2gsIHllcy4NCg0KPiA+ICsJCSpzdGFnZTFfZm9y
bWF0ID0gZm9ybWF0Ow0KPiA+ICsJbXV0ZXhfdW5sb2NrKCZpb21tdS0+bG9jayk7DQo+ID4gKwly
ZXR1cm4gcmV0Ow0KPiA+ICt9DQo+ID4gKw0KPiA+ICBzdGF0aWMgaW50IHZmaW9faW9tbXVfaW5m
b19hZGRfbmVzdGluZ19jYXAoc3RydWN0IHZmaW9faW9tbXUgKmlvbW11LA0KPiA+ICAJCQkJCSBz
dHJ1Y3QgdmZpb19pbmZvX2NhcCAqY2FwcykNCj4gPiAgew0KPiA+ICAJc3RydWN0IHZmaW9faW5m
b19jYXBfaGVhZGVyICpoZWFkZXI7DQo+ID4gIAlzdHJ1Y3QgdmZpb19pb21tdV90eXBlMV9pbmZv
X2NhcF9uZXN0aW5nICpuZXN0aW5nX2NhcDsNCj4gPiArCXUzMiBmb3JtYXRzID0gMDsNCj4gPiAr
CWludCByZXQ7DQo+ID4gKw0KPiA+ICsJcmV0ID0gdmZpb19pb21tdV9nZXRfc3RhZ2UxX2Zvcm1h
dChpb21tdSwgJmZvcm1hdHMpOw0KPiA+ICsJaWYgKHJldCkgew0KPiA+ICsJCXByX3dhcm4oIkZh
aWxlZCB0byBnZXQgc3RhZ2UtMSBmb3JtYXRcbiIpOw0KPiB0cmFjZSB0cmlnZ2VyZWQgYnkgdXNl
cnNwYWNlIHRvIGJlIHJlbW92ZWQ/DQoNCnN1cmUuDQoNCj4gPiArCQlyZXR1cm4gcmV0Ow0KPiA+
ICsJfQ0KPiA+DQo+ID4gIAloZWFkZXIgPSB2ZmlvX2luZm9fY2FwX2FkZChjYXBzLCBzaXplb2Yo
Km5lc3RpbmdfY2FwKSwNCj4gPiAgCQkJCSAgIFZGSU9fSU9NTVVfVFlQRTFfSU5GT19DQVBfTkVT
VElORywgMSk7DQo+ID4gQEAgLTIyNTQsNiArMjMwOSw3IEBAIHN0YXRpYyBpbnQgdmZpb19pb21t
dV9pbmZvX2FkZF9uZXN0aW5nX2NhcChzdHJ1Y3QNCj4gdmZpb19pb21tdSAqaW9tbXUsDQo+ID4g
IAkJLyogbmVzdGluZyBpb21tdSB0eXBlIHN1cHBvcnRzIFBBU0lEIHJlcXVlc3RzIChhbGxvYy9m
cmVlKSAqLw0KPiA+ICAJCW5lc3RpbmdfY2FwLT5uZXN0aW5nX2NhcGFiaWxpdGllcyB8PSBWRklP
X0lPTU1VX1BBU0lEX1JFUVM7DQo+IFdoYXQgaXMgdGhlIG1lYW5pbmcgZm9yIEFSTT8NCg0KSSB0
aGluayBpdCdzIGp1c3QgYSBzb2Z0d2FyZSBjYXBhYmlsaXR5IGV4cG9zZWQgdG8gdXNlcnNwYWNl
LCBvbg0KdXNlcnNwYWNlIHNpZGUsIGl0IGhhcyBhIGNob2ljZSB0byB1c2UgaXQgb3Igbm90LiA6
LSkgVGhlIHJlYXNvbg0KZGVmaW5lIGl0IGFuZCByZXBvcnQgaXQgaW4gY2FwIG5lc3RpbmcgaXMg
dGhhdCBJJ2QgbGlrZSB0byBtYWtlDQp0aGUgcGFzaWQgYWxsb2MvZnJlZSBiZSBhdmFpbGFibGUg
anVzdCBmb3IgSU9NTVUgd2l0aCB0eXBlDQpWRklPX0lPTU1VX1RZUEUxX05FU1RJTkcuIFBsZWFz
ZSBmZWVsIGZyZWUgdGVsbCBtZSBpZiBpdCBpcyBub3QNCmdvb2QgZm9yIEFSTS4gV2UgY2FuIGZp
bmQgYSBwcm9wZXIgd2F5IHRvIHJlcG9ydCB0aGUgYXZhaWxhYmlsaXR5Lg0KDQo+ID4gIAl9DQo+
ID4gKwluZXN0aW5nX2NhcC0+c3RhZ2UxX2Zvcm1hdHMgPSBmb3JtYXRzOw0KPiBhcyBzcG90dGVk
IGJ5IEtldmluLCBzaW5jZSBhIHNpbmdsZSBmb3JtYXQgaXMgc3VwcG9ydGVkLCByZW5hbWUNCg0K
b2ssIEkgd2FzIGJlbGlldmluZyBpdCBtYXkgYmUgcG9zc2libGUgb24gQVJNIG9yIHNvLiA6LSkg
d2lsbA0KcmVuYW1lIGl0Lg0KDQpJJ2xsIHJlZmluZSB0aGUgcGF0Y2ggcGVyIHlvdXIgYWJvdmUg
Y29tbWVudHMuDQoNClJlZ2FyZHMsDQpZaSBMaXUNCg0K
