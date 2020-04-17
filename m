Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8639D1AD441
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 03:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbgDQBuI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 21:50:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:26911 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbgDQBuI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 21:50:08 -0400
IronPort-SDR: yIUzAxKlLKYfTyokKa0BP47k76q/ABHhxOD/8P56so6J+4/l7NpoLGbBMoRq+v7qxNfH0G+wHZ
 p2yuzJoeT5eg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2020 18:50:07 -0700
IronPort-SDR: lFHVMXVUTwZb9ThjoVLW1LuW1/BT4ns7rMaTuOqQ6SOXXrf8f0dGULaa5H4h3AVvK3oxJcMr+u
 +qvX71MQhmFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,393,1580803200"; 
   d="scan'208";a="257427278"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga006.jf.intel.com with ESMTP; 16 Apr 2020 18:50:07 -0700
Received: from fmsmsx111.amr.corp.intel.com (10.18.116.5) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 16 Apr 2020 18:50:00 -0700
Received: from shsmsx106.ccr.corp.intel.com (10.239.4.159) by
 fmsmsx111.amr.corp.intel.com (10.18.116.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 16 Apr 2020 18:49:59 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX106.ccr.corp.intel.com ([169.254.10.89]) with mapi id 14.03.0439.000;
 Fri, 17 Apr 2020 09:49:57 +0800
From:   "Kang, Luwei" <luwei.kang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>
Subject: RE: [PATCH] KVM: VMX: Disable Intel PT before VM-entry
Thread-Topic: [PATCH] KVM: VMX: Disable Intel PT before VM-entry
Thread-Index: AQHV/Nh9FI7fbfgIUkqDZ3DrcNQ1xKhN+YUAgAfwusCACwVbAIABLSawgBlWAwCAAUfHIA==
Date:   Fri, 17 Apr 2020 01:49:57 +0000
Message-ID: <82D7661F83C1A047AF7DC287873BF1E1738C13EE@SHSMSX104.ccr.corp.intel.com>
References: <1584503298-18731-1-git-send-email-luwei.kang@intel.com>
 <20200318154826.GC24357@linux.intel.com>
 <82D7661F83C1A047AF7DC287873BF1E1738A9724@SHSMSX104.ccr.corp.intel.com>
 <20200330172152.GE24988@linux.intel.com>
 <82D7661F83C1A047AF7DC287873BF1E1738B1A1C@SHSMSX104.ccr.corp.intel.com>
 <21fa3505-8198-5f32-9dfd-3c9d9cc5ef7e@redhat.com>
In-Reply-To: <21fa3505-8198-5f32-9dfd-3c9d9cc5ef7e@redhat.com>
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

PiA+PiBBaCwgcmlnaHQuICBXaGF0IGFib3V0IGVuaGFuY2luZyBpbnRlbF9wdF9oYW5kbGVfdm14
KCkgYW5kICdzdHJ1Y3QNCj4gPj4gcHQnIHRvIHJlcGxhY2Ugdm14X29uIHdpdGggYSBmaWVsZCB0
aGF0IGluY29ycG9yYXRlcyB0aGUgS1ZNIG1vZGU/DQo+ID4NCj4gPiBTb21lIGhpc3RvcnkgaXMg
dGhlIGhvc3QgcGVyZiBkaWRuJ3QgZnVsbHkgYWdyZWUgd2l0aCBpbnRyb2R1Y2luZw0KPiA+IEhP
U1RfR1VFU1QgbW9kZSBmb3IgUFQgaW4gS1ZNLg0KPiANCj4gSSBkb24ndCB0aGluayB0aGlzIGlz
IGFjY3VyYXRlLiAgSUlSQyB0aGUgbWFpbnRhaW5lcnMgd2FudGVkIHBhY2tldHMgaW4gdGhlIGhv
c3QtDQo+IHNpZGUgdHJhY2UgdG8gc2lnbmFsIHdoZXJlIHRoZSB0cmFjZSB3YXMgaW50ZXJydXB0
ZWQuICBJbiB0aGUgZW5kIHdlIHNvbHZlZCB0aGUNCj4gaXNzdWUgYnkgMSkgZHJvcHBpbmcgaG9z
dC1vbmx5IG1vZGUgc2luY2UgaXQgY2FuIGJlIGFjaGlldmVkIGluIHVzZXJzcGFjZSAyKQ0KPiBt
YWtpbmcgaG9zdC1ndWVzdCBhbiBvcHQgaW4gZmVhdHVyZS4NCj4gDQo+IEkgdGhpbmsgaXQgd291
bGQgbWFrZSBzZW5zZSB0byByZW5hbWUgdm14X29uIGludG8gdm14X3N0YXRlIGFuZCBtYWtlIGl0
IGFuDQo+IA0KPiBlbnVtIHB0X3ZteF9zdGF0ZSB7DQo+IAlQVF9WTVhfT0ZGLA0KPiAJUFRfVk1Y
X09OX0RJU0FCTEVELA0KPiAJUFRfVk1YX09OX1NZU1RFTSwNCj4gCVBUX1ZNWF9PTl9IT1NUX0dV
RVNUDQo+IH07DQo+IA0KPiBLVk0gd291bGQgcGFzcyB0aGUgZW51bSB0byBpbnRlbF9wdF9oYW5k
bGVfdm14IChvbmUgb2YgUFRfVk1YX09GRiwNCj4gUFRfVk1YX09OX1NZU1RFTSwgUFRfVk1YX09O
X0hPU1RfR1VFU1QpLiAgSW5zaWRlDQo+IGludGVsX3B0X2hhbmRsZV92bXggeW91IGNhbiBkbw0K
PiANCj4gCWlmIChwdF9wbXUudm14KSB7DQo+IAkJV1JJVEVfT05DRShwdC0+dm14X3N0YXRlLCBz
dGF0ZSk7DQo+IAkJcmV0dXJuOw0KPiAJfQ0KPiANCj4gCWxvY2FsX2lycV9zYXZlKGZsYWdzKTsN
Cj4gCVdSSVRFX09OQ0UocHQtPnZteF9zdGF0ZSwNCj4gCQkgICBzdGF0ZSA9PSBQVF9WTVhfT0ZG
ID8gUFRfVk1YX09GRiA6DQo+IFBUX1ZNWF9PTl9ESVNBQkxFRCk7DQo+IAkuLi4NCj4gDQo+IGFu
ZCBpbiBwdF9jb25maWdfc3RhcnQ6DQo+IA0KPiAJLi4uDQo+IAl2bXggPSBSRUFEX09OQ0UocHQt
PnZteF9zdGFydCk7DQo+IAlpZiAodm14ID09IFBUX1ZNWF9PTl9ESVNBQkxFRCkNCj4gICAgICAg
ICAgICAgICAgIHBlcmZfYXV4X291dHB1dF9mbGFnKCZwdC0+aGFuZGxlLCBQRVJGX0FVWF9GTEFH
X1BBUlRJQUwpOw0KPiAgICAgICAgIGVsc2UgaWYgKHZteCA9PSBQVF9WTVhfT05fU1lTVEVNIHx8
DQo+IAkJICEoY3VycmVudC0+ZmxhZ3MgJiBQRl9WQ1BVKSkNCj4gICAgICAgICAgICAgICAgIHdy
bXNybChNU1JfSUEzMl9SVElUX0NUTCwgY3RsKTsNCj4gCS4uLg0KDQpJIHdpbGwgdHJ5IHRoaXMu
IFRoYW5rcy4NCg0KTHV3ZWkgS2FuZw0KDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBQYW9sbw0KDQo=
