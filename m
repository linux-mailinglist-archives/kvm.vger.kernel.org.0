Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B66EA2AC96A
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 00:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730481AbgKIXgT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 18:36:19 -0500
Received: from mga14.intel.com ([192.55.52.115]:46876 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729706AbgKIXgS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 18:36:18 -0500
IronPort-SDR: /hkUzJS2uFo17/YvbUEq0cfw1ktoq5nq4om1RHRlFZL88kYlA48kWKLTrNdmeMiYqf2GjefeBY
 4Ics6RWAmJnw==
X-IronPort-AV: E=McAfee;i="6000,8403,9800"; a="169103327"
X-IronPort-AV: E=Sophos;i="5.77,464,1596524400"; 
   d="scan'208";a="169103327"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2020 15:36:18 -0800
IronPort-SDR: y5ErnoSy3mc0U3fBsBaPC9CJ31r33RAtCzc023jlMtBKG6YuPk8PMOlkBb054ebL2bo8r2Tu/d
 vBbhNhxEGL8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,464,1596524400"; 
   d="scan'208";a="365651292"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 09 Nov 2020 15:36:17 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 9 Nov 2020 15:36:17 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 9 Nov 2020 15:36:16 -0800
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.1713.004;
 Mon, 9 Nov 2020 15:36:16 -0800
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Jim Mattson <jmattson@google.com>
CC:     Qian Cai <cai@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
        <linux-tip-commits@vger.kernel.org>, Boris Petkov <bp@alien8.de>,
        "Borislav Petkov" <bp@suse.de>, x86 <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [tip: ras/core] x86/mce: Enable additional error logging on
 certain Intel CPUs
Thread-Topic: [tip: ras/core] x86/mce: Enable additional error logging on
 certain Intel CPUs
Thread-Index: AQHWsQncdZGZz6bl20aw0A24zT9Gy6nA6f4A//98jeCAAI8FgP//fTQAgACQpAD//3uPYA==
Date:   Mon, 9 Nov 2020 23:36:16 +0000
Message-ID: <bece344ae6944368bf5a9a60e9145bd4@intel.com>
References: <20201030190807.GA13884@agluck-desk2.amr.corp.intel.com>
 <160431588828.397.16468104725047768957.tip-bot2@tip-bot2>
 <3f863634cd75824907e8ccf8164548c2ef036f20.camel@redhat.com>
 <bfc274fc27724ea39ecac1e7ac834ed8@intel.com>
 <CALMp9eTFaiYkTnVe8xKzg40E4nZ3rAOii0O06bTy0+oLNjyKhA@mail.gmail.com>
 <a22b5468e1c94906b72c4d8bc83c0f64@intel.com>
 <CALMp9eS+SYmPP3OzdK0-Bs1wSBJ4MU_POZe3i5fi3Fd+FTshYw@mail.gmail.com>
In-Reply-To: <CALMp9eS+SYmPP3OzdK0-Bs1wSBJ4MU_POZe3i5fi3Fd+FTshYw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBJIHdvdWxkbid0IGV4cGVjdCBhbGwgaHlwZXJ2aXNvcnMgdG8gbmVjZXNzYXJpbHkgc2V0IENQ
VUlELjAxSDpFQ1hbYml0DQo+IDMxXS4gQXJjaGl0ZWN0dXJhbGx5LCBvbiBJbnRlbCBDUFVzLCB0
aGF0IGJpdCBpcyBzaW1wbHkgZGVmaW5lZCBhcw0KPiAibm90IHVzZWQuIiBUaGVyZSBpcyBubyBk
b2N1bWVudGVkIGNvbnRyYWN0IGJldHdlZW4gSW50ZWwgYW5kDQo+IGh5cGVydmlzb3IgdmVuZG9y
cyByZWdhcmRpbmcgdGhlIHVzZSBvZiB0aGF0IGJpdC4gKEFNRCwgb24gdGhlIG90aGVyDQo+IGhh
bmQsICpkb2VzKiBkb2N1bWVudCB0aGF0IGJpdCBhcyAicmVzZXJ2ZWQgZm9yIHVzZSBieSBoeXBl
cnZpc29yIHRvDQo+IGluZGljYXRlIGd1ZXN0IHN0YXR1cy4iKQ0KDQpNYXliZSBubyBjb250cmFj
dCAuLi4gYnV0IGEgYnVuY2ggb2YgcGxhY2VzIChtYW55IG9mIHRoZW0gaW4gSW50ZWwNCnNwZWNp
ZmljIGNvZGUpIHRoYXQgY2hlY2sgZm9yIGl0LiAgUGVyaGFwcyBJIHNob3VsZCBwb2tlIHRoZSBv
d25lcnMNCm9mIHRoZSBJbnRlbCBTRE0gdG8gYWNjZXB0IHRoZSBpbmV2aXRhYmxlLg0KDQokIGdp
dCBncmVwICJib290X2NwdV9oYXMoWDg2X0ZFQVRVUkVfSFlQRVJWSVNPUiINCmFyY2gveDg2L2V2
ZW50cy9jb3JlLmM6IGlmIChib290X2NwdV9oYXMoWDg2X0ZFQVRVUkVfSFlQRVJWSVNPUikpIHsN
CmFyY2gveDg2L2V2ZW50cy9pbnRlbC9jb3JlLmM6ICAgaWYgKCFib290X2NwdV9oYXMoWDg2X0ZF
QVRVUkVfSFlQRVJWSVNPUikpDQphcmNoL3g4Ni9ldmVudHMvaW50ZWwvY29yZS5jOiAgICAgICAg
ICAgaW50IGFzc3VtZSA9IDMgKiAhYm9vdF9jcHVfaGFzKFg4Nl9GRUFUVVJFX0hZUEVSVklTT1Ip
Ow0KYXJjaC94ODYvZXZlbnRzL2ludGVsL2NzdGF0ZS5jOiBpZiAoYm9vdF9jcHVfaGFzKFg4Nl9G
RUFUVVJFX0hZUEVSVklTT1IpKQ0KYXJjaC94ODYvZXZlbnRzL2ludGVsL3VuY29yZS5jOiBpZiAo
Ym9vdF9jcHVfaGFzKFg4Nl9GRUFUVVJFX0hZUEVSVklTT1IpKQ0KYXJjaC94ODYva2VybmVsL2Fw
aWMvYXBpYy5jOiAgICBpZiAoYm9vdF9jcHVfaGFzKFg4Nl9GRUFUVVJFX0hZUEVSVklTT1IpKQ0K
YXJjaC94ODYva2VybmVsL2NwdS9idWdzLmM6ICAgICBpZiAoYm9vdF9jcHVfaGFzKFg4Nl9GRUFU
VVJFX0hZUEVSVklTT1IpKQ0KYXJjaC94ODYva2VybmVsL2NwdS9idWdzLmM6ICAgICBlbHNlIGlm
IChib290X2NwdV9oYXMoWDg2X0ZFQVRVUkVfSFlQRVJWSVNPUikpDQphcmNoL3g4Ni9rZXJuZWwv
Y3B1L2J1Z3MuYzogICAgIGlmIChib290X2NwdV9oYXMoWDg2X0ZFQVRVUkVfSFlQRVJWSVNPUikp
IHsNCmFyY2gveDg2L2tlcm5lbC9jcHUvYnVncy5jOiAgICAgaWYgKGJvb3RfY3B1X2hhcyhYODZf
RkVBVFVSRV9IWVBFUlZJU09SKSkgew0KYXJjaC94ODYva2VybmVsL2NwdS9pbnRlbC5jOiAgICBp
ZiAoYm9vdF9jcHVfaGFzKFg4Nl9GRUFUVVJFX0hZUEVSVklTT1IpKQ0KYXJjaC94ODYva2VybmVs
L2NwdS9tc2h5cGVydi5jOiBpZiAoIWJvb3RfY3B1X2hhcyhYODZfRkVBVFVSRV9IWVBFUlZJU09S
KSkNCmFyY2gveDg2L2tlcm5lbC9jcHUvdm13YXJlLmM6ICogSWYgIWJvb3RfY3B1X2hhcyhYODZf
RkVBVFVSRV9IWVBFUlZJU09SKSwgdm13YXJlX2h5cGVyY2FsbF9tb2RlDQphcmNoL3g4Ni9rZXJu
ZWwvY3B1L3Ztd2FyZS5jOiAgIGlmIChib290X2NwdV9oYXMoWDg2X0ZFQVRVUkVfSFlQRVJWSVNP
UikpIHsNCmFyY2gveDg2L2tlcm5lbC9qYWlsaG91c2UuYzogICAgICAgICFib290X2NwdV9oYXMo
WDg2X0ZFQVRVUkVfSFlQRVJWSVNPUikpDQphcmNoL3g4Ni9rZXJuZWwva3ZtLmM6ICBpZiAoYm9v
dF9jcHVfaGFzKFg4Nl9GRUFUVVJFX0hZUEVSVklTT1IpKQ0KYXJjaC94ODYva2VybmVsL3BhcmF2
aXJ0LmM6ICAgICBpZiAoIWJvb3RfY3B1X2hhcyhYODZfRkVBVFVSRV9IWVBFUlZJU09SKSkNCmFy
Y2gveDg2L2tlcm5lbC90c2MuYzogIGlmIChib290X2NwdV9oYXMoWDg2X0ZFQVRVUkVfSFlQRVJW
SVNPUikgfHwNCmFyY2gveDg2L21tL2luaXRfNjQuYzogIGlmICghYm9vdF9jcHVfaGFzKFg4Nl9G
RUFUVVJFX0hZUEVSVklTT1IpKSB7DQpkcml2ZXJzL2FjcGkvcHJvY2Vzc29yX2lkbGUuYzogIGlm
IChib290X2NwdV9oYXMoWDg2X0ZFQVRVUkVfSFlQRVJWSVNPUikpDQpkcml2ZXJzL2dwdS9kcm0v
YW1kL2FtZGdwdS9hbWRncHVfdmlydC5oOiAgICAgICByZXR1cm4gYm9vdF9jcHVfaGFzKFg4Nl9G
RUFUVVJFX0hZUEVSVklTT1IpOw0KZHJpdmVycy9ncHUvZHJtL2k5MTUvaTkxNV9tZW1jcHkuYzog
ICAgICAgICAhYm9vdF9jcHVfaGFzKFg4Nl9GRUFUVVJFX0hZUEVSVklTT1IpKQ0KZHJpdmVycy9n
cHUvZHJtL3JhZGVvbi9yYWRlb25fZGV2aWNlLmM6IHJldHVybiBib290X2NwdV9oYXMoWDg2X0ZF
QVRVUkVfSFlQRVJWSVNPUik7DQpkcml2ZXJzL3Zpc29yYnVzL3Zpc29yY2hpcHNldC5jOiAgICAg
ICAgaWYgKGJvb3RfY3B1X2hhcyhYODZfRkVBVFVSRV9IWVBFUlZJU09SKSkgew0KDQotVG9ueQ0K
