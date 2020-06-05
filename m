Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C74D1EF09F
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 06:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgFEEjo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 00:39:44 -0400
Received: from mx24.baidu.com ([111.206.215.185]:60194 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725968AbgFEEjo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 00:39:44 -0400
X-Greylist: delayed 954 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Jun 2020 00:39:42 EDT
Received: from BJHW-Mail-Ex14.internal.baidu.com (unknown [10.127.64.37])
        by Forcepoint Email with ESMTPS id 5A5E9675E2089BB4C91E;
        Fri,  5 Jun 2020 12:23:42 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BJHW-Mail-Ex14.internal.baidu.com (10.127.64.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Fri, 5 Jun 2020 12:23:41 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Fri, 5 Jun 2020 12:23:36 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     "like.xu@intel.com" <like.xu@intel.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "xiaoyao.li@intel.com" <xiaoyao.li@intel.com>,
        "wei.huang2@amd.com" <wei.huang2@amd.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdW3Y2XSBLVk06IFg4Njogc3VwcG9ydCBBUEVSRi9N?=
 =?utf-8?Q?PERF_registers?=
Thread-Topic: [PATCH][v6] KVM: X86: support APERF/MPERF registers
Thread-Index: AQHWOtrZ4X/t3pkmBEG7o3WCZUgoeKjIxz2AgAChEWA=
Date:   Fri, 5 Jun 2020 04:23:36 +0000
Message-ID: <c21c6ffa19b6483ea57feab3f98f279c@baidu.com>
References: <1591321466-2046-1-git-send-email-lirongqing@baidu.com>
 <be39b88c-bfb7-0634-c53b-f00d8fde643c@intel.com>
In-Reply-To: <be39b88c-bfb7-0634-c53b-f00d8fde643c@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.27]
x-baidu-bdmsfe-datecheck: 1_BJHW-Mail-Ex14_2020-06-05 12:23:42:248
x-baidu-bdmsfe-viruscheck: BJHW-Mail-Ex14_GRAY_Inside_WithoutAtta_2020-06-05
 12:23:42:216
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IFh1LCBMaWtlIFttYWls
dG86bGlrZS54dUBpbnRlbC5jb21dDQo+IOWPkemAgeaXtumXtDogMjAyMOW5tDbmnIg15pelIDEw
OjMyDQo+IOaUtuS7tuS6ujogTGksUm9uZ3FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPg0KPiDm
ioTpgIE6IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGt2bUB2Z2VyLmtlcm5lbC5vcmc7
IHg4NkBrZXJuZWwub3JnOw0KPiBocGFAenl0b3IuY29tOyBicEBhbGllbjguZGU7IG1pbmdvQHJl
ZGhhdC5jb207IHRnbHhAbGludXRyb25peC5kZTsNCj4gam1hdHRzb25AZ29vZ2xlLmNvbTsgd2Fu
cGVuZ2xpQHRlbmNlbnQuY29tOyB2a3V6bmV0c0ByZWRoYXQuY29tOw0KPiBzZWFuLmouY2hyaXN0
b3BoZXJzb25AaW50ZWwuY29tOyBwYm9uemluaUByZWRoYXQuY29tOyB4aWFveWFvLmxpQGludGVs
LmNvbTsNCj4gd2VpLmh1YW5nMkBhbWQuY29tDQo+IOS4u+mimDogUmU6IFtQQVRDSF1bdjZdIEtW
TTogWDg2OiBzdXBwb3J0IEFQRVJGL01QRVJGIHJlZ2lzdGVycw0KPiANCj4gSGkgUm9uZ1Fpbmcs
DQo+IA0KPiBPbiAyMDIwLzYvNSA5OjQ0LCBMaSBSb25nUWluZyB3cm90ZToNCj4gPiBHdWVzdCBr
ZXJuZWwgcmVwb3J0cyBhIGZpeGVkIGNwdSBmcmVxdWVuY3kgaW4gL3Byb2MvY3B1aW5mbywgdGhp
cyBpcw0KPiA+IGNvbmZ1c2VkIHRvIHVzZXIgd2hlbiB0dXJibyBpcyBlbmFibGUsIGFuZCBhcGVy
Zi9tcGVyZiBjYW4gYmUgdXNlZCB0bw0KPiA+IHNob3cgY3VycmVudCBjcHUgZnJlcXVlbmN5IGFm
dGVyIDdkNTkwNWRjMTRhDQo+ID4gIih4ODYgLyBDUFU6IEFsd2F5cyBzaG93IGN1cnJlbnQgQ1BV
IGZyZXF1ZW5jeSBpbiAvcHJvYy9jcHVpbmZvKSINCj4gPiBzbyBndWVzdCBzaG91bGQgc3VwcG9y
dCBhcGVyZi9tcGVyZiBjYXBhYmlsaXR5DQo+ID4NCj4gPiBUaGlzIHBhdGNoIGltcGxlbWVudHMg
YXBlcmYvbXBlcmYgYnkgdGhyZWUgbW9kZTogbm9uZSwgc29mdHdhcmUNCj4gPiBlbXVsYXRpb24s
IGFuZCBwYXNzLXRocm91Z2gNCj4gPg0KPiA+IE5vbmU6IGRlZmF1bHQgbW9kZSwgZ3Vlc3QgZG9l
cyBub3Qgc3VwcG9ydCBhcGVyZi9tcGVyZg0KPiBzL05vbmUvTm90ZQ0KPiA+DQo+ID4gU29mdHdh
cmUgZW11bGF0aW9uOiB0aGUgcGVyaW9kIG9mIGFwZXJmL21wZXJmIGluIGd1ZXN0IG1vZGUgYXJl
DQo+ID4gYWNjdW11bGF0ZWQgYXMgZW11bGF0ZWQgdmFsdWUNCj4gPg0KPiA+IFBhc3MtdGhvdWdo
OiBpdCBpcyBvbmx5IHN1aXRhYmxlIGZvciBLVk1fSElOVFNfUkVBTFRJTUUsIEJlY2F1c2UgdGhh
dA0KPiA+IGhpbnQgZ3VhcmFudGVlcyB3ZSBoYXZlIGEgMToxIHZDUFU6Q1BVIGJpbmRpbmcgYW5k
IGd1YXJhbnRlZWQgbm8NCj4gPiBvdmVyLWNvbW1pdC4NCj4gVGhlIGZsYWcgIktWTV9ISU5UU19S
RUFMVElNRSAwIiAoaW4gdGhlIERvY3VtZW50YXRpb24vdmlydC9rdm0vY3B1aWQucnN0KQ0KPiBp
cyBjbGFpbWVkIGFzICJndWVzdCBjaGVja3MgdGhpcyBmZWF0dXJlIGJpdCB0byBkZXRlcm1pbmUg
dGhhdCB2Q1BVcyBhcmUgbmV2ZXINCj4gcHJlZW1wdGVkIGZvciBhbiB1bmxpbWl0ZWQgdGltZSBh
bGxvd2luZyBvcHRpbWl6YXRpb25zIi4NCj4gDQo+IEkgY291bGRuJ3Qgc2VlIGl0cyByZWxhdGlv
bnNoaXAgd2l0aCAiMToxIHZDUFU6IHBDUFUgYmluZGluZyIuDQo+IFRoZSBwYXRjaCBkb2Vzbid0
IGNoZWNrIHRoaXMgZmxhZyBhcyB3ZWxsIGZvciB5b3VyIHBhc3MtdGhyb3VnaCBwdXJwb3NlLg0K
PiANCj4gVGhhbmtzLA0KPiBMaWtlIFh1DQoNCg0KSSB0aGluayB0aGlzIGlzIHVzZXIgc3BhY2Ug
am9icyB0byBiaW5kIEhJTlRfUkVBTFRJTUUgYW5kIG1wZXJmIHBhc3N0aHJvdWdoLCBLVk0ganVz
dCBkbyB3aGF0IHVzZXJzcGFjZSB3YW50cy4NCg0KYW5kIHRoaXMgZ2l2ZXMgdXNlciBzcGFjZSBh
IHBvc3NpYmlsaXR5LCBndWVzdCBoYXMgcGFzc3Rocm91Z2ggbXBlcmZhcGVyZiB3aXRob3V0IEhJ
TlRfUkVBTFRJTUUsIGd1ZXN0IGNhbiBnZXQgY29hcnNlIGNwdSBmcmVxdWVuY3kgd2l0aG91dCBw
ZXJmb3JtYW5jZSBlZmZlY3QgaWYgZ3Vlc3QgY2FuIGVuZHVyZSBlcnJvciBmcmVxdWVuY3kgb2Nj
YXNpb25hbGx5DQoNCg0KLUxpIA0KDQo=
