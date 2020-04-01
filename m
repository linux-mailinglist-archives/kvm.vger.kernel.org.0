Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 297F919AC71
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 15:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732565AbgDANOA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 09:14:00 -0400
Received: from mga03.intel.com ([134.134.136.65]:40967 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732439AbgDANOA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 09:14:00 -0400
IronPort-SDR: AY5xfFEq/CCVKecAfh6tz433tmtIfFRGbE522/ujSHAm4F6/AEv5DvEeiFt6UoIqQxWtnqJl2g
 nBGeGqt2BPQw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2020 06:13:59 -0700
IronPort-SDR: rZNdtC/kYipPD2Ebjt/Fz5xT+31tfE0O32t4WmAu6TY4ZirdoB03QiwzWTZF7D3dDO40r9csoJ
 MErX6EAbTlbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,331,1580803200"; 
   d="scan'208";a="295328694"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Apr 2020 06:13:58 -0700
Received: from fmsmsx153.amr.corp.intel.com (10.18.125.6) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 1 Apr 2020 06:13:58 -0700
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 FMSMSX153.amr.corp.intel.com (10.18.125.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 1 Apr 2020 06:13:58 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX152.ccr.corp.intel.com ([169.254.6.209]) with mapi id 14.03.0439.000;
 Wed, 1 Apr 2020 21:13:54 +0800
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
Subject: RE: [PATCH v1 3/8] vfio/type1: Report PASID alloc/free support to
 userspace
Thread-Topic: [PATCH v1 3/8] vfio/type1: Report PASID alloc/free support to
 userspace
Thread-Index: AQHWAEUdmZ6qeWVhq0GPreoHiPHgtahjjLGAgAC7stA=
Date:   Wed, 1 Apr 2020 13:13:53 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A21DBAF@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
 <1584880325-10561-4-git-send-email-yi.l.liu@intel.com>
 <1b720777-8334-936e-5edb-802b3dae7b05@redhat.com>
In-Reply-To: <1b720777-8334-936e-5edb-802b3dae7b05@redhat.com>
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
IFNlbnQ6IFdlZG5lc2RheSwgQXByaWwgMSwgMjAyMCA1OjQxIFBNDQo+IFRvOiBMaXUsIFlpIEwg
PHlpLmwubGl1QGludGVsLmNvbT47IGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tDQo+IFN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggdjEgMy84XSB2ZmlvL3R5cGUxOiBSZXBvcnQgUEFTSUQgYWxsb2MvZnJl
ZSBzdXBwb3J0IHRvDQo+IHVzZXJzcGFjZQ0KPiANCj4gWWksDQo+IE9uIDMvMjIvMjAgMTozMiBQ
TSwgTGl1LCBZaSBMIHdyb3RlOg0KPiA+IEZyb206IExpdSBZaSBMIDx5aS5sLmxpdUBpbnRlbC5j
b20+DQo+ID4NCj4gPiBUaGlzIHBhdGNoIHJlcG9ydHMgUEFTSUQgYWxsb2MvZnJlZSBhdmFpbGFi
aWxpdHkgdG8gdXNlcnNwYWNlIChlLmcuDQo+ID4gUUVNVSkgdGh1cyB1c2Vyc3BhY2UgY291bGQg
ZG8gYSBwcmUtY2hlY2sgYmVmb3JlIHV0aWxpemluZyB0aGlzIGZlYXR1cmUuDQo+ID4NCj4gPiBD
YzogS2V2aW4gVGlhbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+ID4gQ0M6IEphY29iIFBhbiA8
amFjb2IuanVuLnBhbkBsaW51eC5pbnRlbC5jb20+DQo+ID4gQ2M6IEFsZXggV2lsbGlhbXNvbiA8
YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+ID4gQ2M6IEVyaWMgQXVnZXIgPGVyaWMuYXVn
ZXJAcmVkaGF0LmNvbT4NCj4gPiBDYzogSmVhbi1QaGlsaXBwZSBCcnVja2VyIDxqZWFuLXBoaWxp
cHBlQGxpbmFyby5vcmc+DQo+ID4gU2lnbmVkLW9mZi1ieTogTGl1IFlpIEwgPHlpLmwubGl1QGlu
dGVsLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy92ZmlvL3ZmaW9faW9tbXVfdHlwZTEuYyB8
IDI4ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gPiAgaW5jbHVkZS91YXBpL2xpbnV4
L3ZmaW8uaCAgICAgICB8ICA4ICsrKysrKysrDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgMzYgaW5z
ZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmZpby92ZmlvX2lvbW11
X3R5cGUxLmMNCj4gPiBiL2RyaXZlcnMvdmZpby92ZmlvX2lvbW11X3R5cGUxLmMgaW5kZXggZTQw
YWZjMC4uZGRkMWZmZSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3ZmaW8vdmZpb19pb21tdV90
eXBlMS5jDQo+ID4gKysrIGIvZHJpdmVycy92ZmlvL3ZmaW9faW9tbXVfdHlwZTEuYw0KPiA+IEBA
IC0yMjM0LDYgKzIyMzQsMzAgQEAgc3RhdGljIGludCB2ZmlvX2lvbW11X3R5cGUxX3Bhc2lkX2Zy
ZWUoc3RydWN0DQo+IHZmaW9faW9tbXUgKmlvbW11LA0KPiA+ICAJcmV0dXJuIHJldDsNCj4gPiAg
fQ0KPiA+DQo+ID4gK3N0YXRpYyBpbnQgdmZpb19pb21tdV9pbmZvX2FkZF9uZXN0aW5nX2NhcChz
dHJ1Y3QgdmZpb19pb21tdSAqaW9tbXUsDQo+ID4gKwkJCQkJIHN0cnVjdCB2ZmlvX2luZm9fY2Fw
ICpjYXBzKQ0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3QgdmZpb19pbmZvX2NhcF9oZWFkZXIgKmhlYWRl
cjsNCj4gPiArCXN0cnVjdCB2ZmlvX2lvbW11X3R5cGUxX2luZm9fY2FwX25lc3RpbmcgKm5lc3Rp
bmdfY2FwOw0KPiA+ICsNCj4gPiArCWhlYWRlciA9IHZmaW9faW5mb19jYXBfYWRkKGNhcHMsIHNp
emVvZigqbmVzdGluZ19jYXApLA0KPiA+ICsJCQkJICAgVkZJT19JT01NVV9UWVBFMV9JTkZPX0NB
UF9ORVNUSU5HLCAxKTsNCj4gPiArCWlmIChJU19FUlIoaGVhZGVyKSkNCj4gPiArCQlyZXR1cm4g
UFRSX0VSUihoZWFkZXIpOw0KPiA+ICsNCj4gPiArCW5lc3RpbmdfY2FwID0gY29udGFpbmVyX29m
KGhlYWRlciwNCj4gPiArCQkJCXN0cnVjdCB2ZmlvX2lvbW11X3R5cGUxX2luZm9fY2FwX25lc3Rp
bmcsDQo+ID4gKwkJCQloZWFkZXIpOw0KPiA+ICsNCj4gPiArCW5lc3RpbmdfY2FwLT5uZXN0aW5n
X2NhcGFiaWxpdGllcyA9IDA7DQo+ID4gKwlpZiAoaW9tbXUtPm5lc3RpbmcpIHsNCj4gPiArCQkv
KiBuZXN0aW5nIGlvbW11IHR5cGUgc3VwcG9ydHMgUEFTSUQgcmVxdWVzdHMgKGFsbG9jL2ZyZWUp
ICovDQo+ID4gKwkJbmVzdGluZ19jYXAtPm5lc3RpbmdfY2FwYWJpbGl0aWVzIHw9IFZGSU9fSU9N
TVVfUEFTSURfUkVRUzsNCj4gU3VwcG9ydGluZyBuZXN0aW5nIGRvZXMgbm90IG5lY2Vzc2FyaWx5
IG1lYW4gc3VwcG9ydGluZyBQQVNJRC4NCg0KaGVyZSBJIHRoaW5rIHRoZSBQQVNJRCBpcyBzb21l
aG93IElEcyBpbiBrZXJuZWwgd2hpY2ggY2FuIGJlIHVzZWQgdG8NCnRhZyB2YXJpb3VzIGFkZHJl
c3Mgc3BhY2VzIHByb3ZpZGVkIGJ5IGd1ZXN0IHNvZnR3YXJlLiBJIHRoaW5rIHRoaXMNCmlzIHdo
eSB3ZSBpbnRyb2R1Y2VkIHRoZSBpb2FzaWQuIDotKSBDdXJyZW50IGltcGxlbWVudGF0aW9uIGlz
IGRvaW5nDQpQQVNJRCBhbGxvYy9mcmVlIGluIHZmaW8uDQoNCj4gPiArCX0NCj4gPiArDQo+ID4g
KwlyZXR1cm4gMDsNCj4gPiArfQ0KPiA+ICsNCj4gPiAgc3RhdGljIGxvbmcgdmZpb19pb21tdV90
eXBlMV9pb2N0bCh2b2lkICppb21tdV9kYXRhLA0KPiA+ICAJCQkJICAgdW5zaWduZWQgaW50IGNt
ZCwgdW5zaWduZWQgbG9uZyBhcmcpICB7IEBAIC0NCj4gMjI4Myw2ICsyMzA3LDEwIEBADQo+ID4g
c3RhdGljIGxvbmcgdmZpb19pb21tdV90eXBlMV9pb2N0bCh2b2lkICppb21tdV9kYXRhLA0KPiA+
ICAJCWlmIChyZXQpDQo+ID4gIAkJCXJldHVybiByZXQ7DQo+ID4NCj4gPiArCQlyZXQgPSB2Zmlv
X2lvbW11X2luZm9fYWRkX25lc3RpbmdfY2FwKGlvbW11LCAmY2Fwcyk7DQo+ID4gKwkJaWYgKHJl
dCkNCj4gPiArCQkJcmV0dXJuIHJldDsNCj4gPiArDQo+ID4gIAkJaWYgKGNhcHMuc2l6ZSkgew0K
PiA+ICAJCQlpbmZvLmZsYWdzIHw9IFZGSU9fSU9NTVVfSU5GT19DQVBTOw0KPiA+DQo+ID4gZGlm
ZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC92ZmlvLmggYi9pbmNsdWRlL3VhcGkvbGludXgv
dmZpby5oDQo+ID4gaW5kZXggMjk4YWM4MC4uODgzNzIxOSAxMDA2NDQNCj4gPiAtLS0gYS9pbmNs
dWRlL3VhcGkvbGludXgvdmZpby5oDQo+ID4gKysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L3ZmaW8u
aA0KPiA+IEBAIC03NDgsNiArNzQ4LDE0IEBAIHN0cnVjdCB2ZmlvX2lvbW11X3R5cGUxX2luZm9f
Y2FwX2lvdmFfcmFuZ2Ugew0KPiA+ICAJc3RydWN0CXZmaW9faW92YV9yYW5nZSBpb3ZhX3Jhbmdl
c1tdOw0KPiA+ICB9Ow0KPiA+DQo+ID4gKyNkZWZpbmUgVkZJT19JT01NVV9UWVBFMV9JTkZPX0NB
UF9ORVNUSU5HICAyDQo+ID4gKw0KPiA+ICtzdHJ1Y3QgdmZpb19pb21tdV90eXBlMV9pbmZvX2Nh
cF9uZXN0aW5nIHsNCj4gPiArCXN0cnVjdAl2ZmlvX2luZm9fY2FwX2hlYWRlciBoZWFkZXI7DQo+
ID4gKyNkZWZpbmUgVkZJT19JT01NVV9QQVNJRF9SRVFTCSgxIDw8IDApDQo+IFBBU0lEX1JFUVMg
c291bmRzIGEgYml0IGZhciBmcm9tIHRoZSBjbGFpbWVkIGhvc3QgbWFuYWdlZCBhbGxvYy9mcmVl
DQo+IGNhcGFiaWxpdHkuDQo+IFZGSU9fSU9NTVVfU1lTVEVNX1dJREVfUEFTSUQ/DQoNCk9oLCB5
ZXAuIEkgY2FuIHJlbmFtZSBpdC4NCg0KUmVnYXJkcywNCllpIExpdQ0K
