Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E08219D91F
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 16:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403976AbgDCO3q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 10:29:46 -0400
Received: from mga06.intel.com ([134.134.136.31]:59302 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403885AbgDCO3q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 10:29:46 -0400
IronPort-SDR: C0ASCOFmEn+F5s67LuNYG5bhyWtVbkbnrkxJpnL1UrCGOeSn7oDHpTEUvN0aY/Ssnc7J5jsYZn
 sWrzlf/5E9Mw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2020 07:29:45 -0700
IronPort-SDR: OMgZC6PTstbqz4oW7leK+A6kOGnGt9CtuIg3gW/itn1kSN4CEhbzAw8SFNRQ/fES//hZ8XWK7l
 X/5AmojS/cJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,340,1580803200"; 
   d="scan'208";a="329180601"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga001.jf.intel.com with ESMTP; 03 Apr 2020 07:29:44 -0700
Received: from FMSMSX110.amr.corp.intel.com (10.18.116.10) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 3 Apr 2020 07:29:44 -0700
Received: from shsmsx102.ccr.corp.intel.com (10.239.4.154) by
 fmsmsx110.amr.corp.intel.com (10.18.116.10) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 3 Apr 2020 07:29:44 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 shsmsx102.ccr.corp.intel.com ([169.254.2.138]) with mapi id 14.03.0439.000;
 Fri, 3 Apr 2020 22:29:40 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Peter Xu <peterx@redhat.com>
CC:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>
Subject: RE: [PATCH v2 15/22] intel_iommu: bind/unbind guest page table to
 host
Thread-Topic: [PATCH v2 15/22] intel_iommu: bind/unbind guest page table to
 host
Thread-Index: AQHWBkplKGJEo59YsUeJrUOkrr1+EKhloPgAgAHaffA=
Date:   Fri, 3 Apr 2020 14:29:39 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A220D4A@SHSMSX104.ccr.corp.intel.com>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <1585542301-84087-16-git-send-email-yi.l.liu@intel.com>
 <20200402180920.GD103677@xz-x1>
In-Reply-To: <20200402180920.GD103677@xz-x1>
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

PiBGcm9tOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+IFNlbnQ6IEZyaWRheSwgQXBy
aWwgMywgMjAyMCAyOjA5IEFNDQo+IFRvOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4N
Cj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MiAxNS8yMl0gaW50ZWxfaW9tbXU6IGJpbmQvdW5iaW5k
IGd1ZXN0IHBhZ2UgdGFibGUgdG8gaG9zdA0KPiANCj4gT24gU3VuLCBNYXIgMjksIDIwMjAgYXQg
MDk6MjQ6NTRQTSAtMDcwMCwgTGl1IFlpIEwgd3JvdGU6DQo+ID4gK3N0YXRpYyBpbnQgdnRkX2Jp
bmRfZ3Vlc3RfcGFzaWQoSW50ZWxJT01NVVN0YXRlICpzLCBWVERCdXMgKnZ0ZF9idXMsDQo+ID4g
KyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaW50IGRldmZuLCBpbnQgcGFzaWQsIFZU
RFBBU0lERW50cnkgKnBlLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFZU
RFBBU0lET3Agb3ApIHsNCj4gPiArICAgIFZUREhvc3RJT01NVUNvbnRleHQgKnZ0ZF9kZXZfaWN4
Ow0KPiA+ICsgICAgSG9zdElPTU1VQ29udGV4dCAqaW9tbXVfY3R4Ow0KPiA+ICsgICAgRHVhbElP
TU1VU3RhZ2UxQmluZERhdGEgKmJpbmRfZGF0YTsNCj4gPiArICAgIHN0cnVjdCBpb21tdV9ncGFz
aWRfYmluZF9kYXRhICpnX2JpbmRfZGF0YTsNCj4gPiArICAgIGludCByZXQgPSAtMTsNCj4gPiAr
DQo+ID4gKyAgICB2dGRfZGV2X2ljeCA9IHZ0ZF9idXMtPmRldl9pY3hbZGV2Zm5dOw0KPiA+ICsg
ICAgaWYgKCF2dGRfZGV2X2ljeCkgew0KPiA+ICsgICAgICAgIC8qIG1lYW5zIG5vIG5lZWQgdG8g
Z28gZnVydGhlciwgZS5nLiBmb3IgZW11bGF0ZWQgZGV2aWNlcyAqLw0KPiA+ICsgICAgICAgIHJl
dHVybiAwOw0KPiA+ICsgICAgfQ0KPiA+ICsNCj4gPiArICAgIGlvbW11X2N0eCA9IHZ0ZF9kZXZf
aWN4LT5pb21tdV9jdHg7DQo+ID4gKyAgICBpZiAoIWlvbW11X2N0eCkgew0KPiA+ICsgICAgICAg
IHJldHVybiAtRUlOVkFMOw0KPiA+ICsgICAgfQ0KPiA+ICsNCj4gPiArICAgIGlmICghKGlvbW11
X2N0eC0+c3RhZ2UxX2Zvcm1hdHMNCj4gPiArICAgICAgICAgICAgICYgSU9NTVVfUEFTSURfRk9S
TUFUX0lOVEVMX1ZURCkpIHsNCj4gPiArICAgICAgICBlcnJvcl9yZXBvcnRfb25jZSgiSU9NTVUg
U3RhZ2UgMSBmb3JtYXQgaXMgbm90IGNvbXBhdGlibGUhXG4iKTsNCj4gPiArICAgICAgICByZXR1
cm4gLUVJTlZBTDsNCj4gPiArICAgIH0NCj4gPiArDQo+ID4gKyAgICBiaW5kX2RhdGEgPSBnX21h
bGxvYzAoc2l6ZW9mKCpiaW5kX2RhdGEpKTsNCj4gPiArICAgIGJpbmRfZGF0YS0+cGFzaWQgPSBw
YXNpZDsNCj4gPiArICAgIGdfYmluZF9kYXRhID0gJmJpbmRfZGF0YS0+YmluZF9kYXRhLmdwYXNp
ZF9iaW5kOw0KPiA+ICsNCj4gPiArICAgIGdfYmluZF9kYXRhLT5mbGFncyA9IDA7DQo+ID4gKyAg
ICBnX2JpbmRfZGF0YS0+dnRkLmZsYWdzID0gMDsNCj4gPiArICAgIHN3aXRjaCAob3ApIHsNCj4g
PiArICAgIGNhc2UgVlREX1BBU0lEX0JJTkQ6DQo+ID4gKyAgICAgICAgZ19iaW5kX2RhdGEtPnZl
cnNpb24gPSBJT01NVV9VQVBJX1ZFUlNJT047DQo+ID4gKyAgICAgICAgZ19iaW5kX2RhdGEtPmZv
cm1hdCA9IElPTU1VX1BBU0lEX0ZPUk1BVF9JTlRFTF9WVEQ7DQo+ID4gKyAgICAgICAgZ19iaW5k
X2RhdGEtPmdwZ2QgPSB2dGRfcGVfZ2V0X2ZscHRfYmFzZShwZSk7DQo+ID4gKyAgICAgICAgZ19i
aW5kX2RhdGEtPmFkZHJfd2lkdGggPSB2dGRfcGVfZ2V0X2ZsX2F3KHBlKTsNCj4gPiArICAgICAg
ICBnX2JpbmRfZGF0YS0+aHBhc2lkID0gcGFzaWQ7DQo+ID4gKyAgICAgICAgZ19iaW5kX2RhdGEt
PmdwYXNpZCA9IHBhc2lkOw0KPiA+ICsgICAgICAgIGdfYmluZF9kYXRhLT5mbGFncyB8PSBJT01N
VV9TVkFfR1BBU0lEX1ZBTDsNCj4gPiArICAgICAgICBnX2JpbmRfZGF0YS0+dnRkLmZsYWdzID0N
Cj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAoVlREX1NNX1BBU0lEX0VOVFJZX1NS
RV9CSVQocGUtPnZhbFsyXSkNCj4gPiArID8gMSA6IDApDQo+IA0KPiBUaGlzIGV2YWx1YXRlcyB0
byAxIGlmIFZURF9TTV9QQVNJRF9FTlRSWV9TUkVfQklUKHBlLT52YWxbMl0pLCBvciAwLg0KPiBE
byB5b3Ugd2FudCB0byB1c2UgSU9NTVVfU1ZBX1ZURF9HUEFTSURfU1JFIGluc3RlYWQgb2YgMT8g
IFNhbWUgcXVlc3Rpb24gdG8NCj4gYWxsIHRoZSByZXN0Lg0KDQpvb3BzLCB5ZXMgaXQgaXMuIHlv
dSBhcmUgcmlnaHQuIHRoYW5rcyBmb3IgY2F0Y2hpbmcgaXQuIER1cmluZyB2ZXJpZmljYXRpb24s
IG9ubHkNCnRoZSBTUkUgYml0IGlzIHVzZWQsIHNvIGl0J3Mgbm90IHNwb3R0ZWQgaW4gdGVzdGlu
Zy4NCg0KUmVnYXJkcywNCllpIExpdQ0K
