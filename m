Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E27AA2B41
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2019 02:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbfH3ACB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 20:02:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:58438 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726416AbfH3ACB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 20:02:01 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Aug 2019 17:02:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,445,1559545200"; 
   d="scan'208";a="172067948"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga007.jf.intel.com with ESMTP; 29 Aug 2019 17:01:59 -0700
Received: from fmsmsx115.amr.corp.intel.com (10.18.116.19) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 29 Aug 2019 17:01:59 -0700
Received: from shsmsx153.ccr.corp.intel.com (10.239.6.53) by
 fmsmsx115.amr.corp.intel.com (10.18.116.19) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 29 Aug 2019 17:01:59 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.112]) by
 SHSMSX153.ccr.corp.intel.com ([169.254.12.215]) with mapi id 14.03.0439.000;
 Fri, 30 Aug 2019 08:01:57 +0800
From:   "Kang, Luwei" <luwei.kang@intel.com>
To:     Jim Mattson <jmattson@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3JjbcOhcg==?= <rkrcmar@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Borislav Petkov" <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: RE: [RFC v1 1/9] KVM: x86: Add base address parameter for
 get_fixed_pmc function
Thread-Topic: [RFC v1 1/9] KVM: x86: Add base address parameter for
 get_fixed_pmc function
Thread-Index: AQHVXiwTvN9l0Wf/9ESeUncX5js89qcR9eUAgADWJzA=
Date:   Fri, 30 Aug 2019 00:01:56 +0000
Message-ID: <82D7661F83C1A047AF7DC287873BF1E1737F7871@SHSMSX104.ccr.corp.intel.com>
References: <1567056849-14608-1-git-send-email-luwei.kang@intel.com>
 <1567056849-14608-2-git-send-email-luwei.kang@intel.com>
 <CALMp9eS0-OfAR1=mrvABrOg85V+-yM64KuOff3A1_wCKDYZNxw@mail.gmail.com>
In-Reply-To: <CALMp9eS0-OfAR1=mrvABrOg85V+-yM64KuOff3A1_wCKDYZNxw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+IFBFQlMgb3V0cHV0IEludGUgUFQgaW50cm9kdWNlcyBzb21lIG5ldyBNU1JzIChNU1JfUkVM
T0FEX0ZJWEVEX0NUUngpDQo+ID4gZm9yIGZpeGVkIGZ1bmN0aW9uIGNvdW50ZXJzIHRoYXQgdXNl
IGZvciBhdXRvbG9hZCB0aGUgcHJlc2V0IHZhbHVlDQo+ID4gYWZ0ZXIgd3JpdGluZyBvdXQgYSBQ
RUJTIGV2ZW50Lg0KPiA+DQo+ID4gSW50cm9kdWNlIGJhc2UgTVNScyBhZGRyZXNzIHBhcmFtZXRl
ciB0byBtYWtlIHRoaXMgZnVuY3Rpb24gY2FuIGdldA0KPiA+IHBlcmZvcm1hbmNlIG1vbml0b3Ig
Y291bnRlciBzdHJ1Y3R1cmUgYnkgTVNSX1JFTE9BRF9GSVhFRF9DVFJ4DQo+IHJlZ2lzdGVycy4N
Cj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEx1d2VpIEthbmcgPGx1d2VpLmthbmdAaW50ZWwuY29t
Pg0KPiA+IC0tLQ0KPiA+ICBhcmNoL3g4Ni9rdm0vcG11LmggICAgICAgICAgIHwgIDUgKystLS0N
Cj4gPiAgYXJjaC94ODYva3ZtL3ZteC9wbXVfaW50ZWwuYyB8IDE0ICsrKysrKysrKy0tLS0tDQo+
ID4gIDIgZmlsZXMgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkNCj4g
Pg0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vcG11LmggYi9hcmNoL3g4Ni9rdm0vcG11
LmggaW5kZXgNCj4gPiA1ODI2NWY3Li5jNjJhMWZmIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2
L2t2bS9wbXUuaA0KPiA+ICsrKyBiL2FyY2gveDg2L2t2bS9wbXUuaA0KPiA+IEBAIC05MywxMCAr
OTMsOSBAQCBzdGF0aWMgaW5saW5lIHN0cnVjdCBrdm1fcG1jICpnZXRfZ3BfcG1jKHN0cnVjdA0K
PiA+IGt2bV9wbXUgKnBtdSwgdTMyIG1zciwgIH0NCj4gPg0KPiA+ICAvKiByZXR1cm5zIGZpeGVk
IFBNQyB3aXRoIHRoZSBzcGVjaWZpZWQgTVNSICovIC1zdGF0aWMgaW5saW5lIHN0cnVjdA0KPiA+
IGt2bV9wbWMgKmdldF9maXhlZF9wbWMoc3RydWN0IGt2bV9wbXUgKnBtdSwgdTMyIG1zcikNCj4g
PiArc3RhdGljIGlubGluZSBzdHJ1Y3Qga3ZtX3BtYyAqZ2V0X2ZpeGVkX3BtYyhzdHJ1Y3Qga3Zt
X3BtdSAqcG11LCB1MzINCj4gbXNyLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpbnQNCj4gPiArYmFzZSkNCj4gPiAg
ew0KPiA+IC0gICAgICAgaW50IGJhc2UgPSBNU1JfQ09SRV9QRVJGX0ZJWEVEX0NUUjA7DQo+ID4g
LQ0KPiA+ICAgICAgICAgaWYgKG1zciA+PSBiYXNlICYmIG1zciA8IGJhc2UgKyBwbXUtPm5yX2Fy
Y2hfZml4ZWRfY291bnRlcnMpDQo+ID4gICAgICAgICAgICAgICAgIHJldHVybiAmcG11LT5maXhl
ZF9jb3VudGVyc1ttc3IgLSBiYXNlXTsNCj4gDQo+IElJVUMsIHRoZXNlIG5ldyBNU1JzIGFyZW4n
dCBuZXcgZml4ZWQgUE1DcywgYnV0IGFyZSB2YWx1ZXMgdG8gYmUgcmVsb2FkZWQNCj4gaW50byB0
aGUgZXhpc3RpbmcgZml4ZWQgUE1DcyB3aGVuIGEgUEVCUyBldmVudCBoYXMgYmVlbiB3cml0dGVu
LiBUaGlzIGNoYW5nZQ0KPiBtYWtlcyBpdCBsb29rIGxpa2UgeW91IGFyZSBpbnRyb2R1Y2luZyBh
biBhZGRpdGlvbmFsIHNldCBvZiBmaXhlZCBQTUNzLg0KDQpZZXMsIHlvdSBhcmUgcmlnaHQuIFRo
ZXkgYXJlIG5vdCBuZXcgZml4ZWQgY291bnRlcnMuDQpFYWNoIGZpeGVkL2dlbmVyYWwgcHVycG9z
ZSBjb3VudGVycyBoYXZlIGEgImt2bV9wbWMiIHN0cnVjdHVyZSBpbiBLVk0uIFdlIGFscmVhZHkg
aGF2ZSBhIGZ1bmN0aW9uIHRvIGdldCBnZW5lcmFsIHB1cnBvc2UgY291bnRlciBieSBldmVudCBz
ZWxlY3RvcnMgYW5kIGdwIGNvdW50ZXJzLCBhcyBiZWxvdzoNCnBtYyA9IGdldF9ncF9wbWMocG11
LCBtc3IsIE1TUl9JQTMyX1BFUkZDVFIwKQkJLy9ieSBncCBjb3VudGVyDQpwbWMgPSBnZXRfZ3Bf
cG1jKHBtdSwgbXNyLCBNU1JfUDZfRVZOVFNFTDApIAkJLy9ieSBncCBldmVudCBzZWxlY3Rvcg0K
U28gSSBleHRlbmRlZCB0aGUgIiBnZXRfZml4ZWRfcG1jICIgZnVuY3Rpb24gdG8gc3VwcG9ydCBn
ZXQgZml4ZWQgY291bnRlcnMgYnkgTVNSX1JFTE9BRF9GSVhFRF9DVFJ4LiBBY3R1YWxseSwgdGhl
eSBhcmUgYWxsIGdldCAia3ZtX3BtYyIgc3RydWN0dXJlIGJ5IG9mZnNldC4NCg0KVGhhbmtzLA0K
THV3ZWkgS2FuZw0KDQoNCg0K
