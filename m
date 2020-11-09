Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 291C82AC80D
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730324AbgKIWJL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:09:11 -0500
Received: from mga12.intel.com ([192.55.52.136]:40676 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgKIWJL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:09:11 -0500
IronPort-SDR: E8wx47jbtfJISQnehsPbhwGJn+DzpDUdCX0tIeQcBwPs7NhduHOiI/LxHRhktQ+5Gx2exe7fis
 D8GNTn8fWv1Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9800"; a="149159709"
X-IronPort-AV: E=Sophos;i="5.77,464,1596524400"; 
   d="scan'208";a="149159709"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2020 14:09:10 -0800
IronPort-SDR: mQI2yGa2ahYt3jSSfoD/vi3GJ9vubhkdb2KQNDBoeq5tjBMQ+1SshO3mRbUOCncxzufnOC5v6o
 SO9Af1mVf5eQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,464,1596524400"; 
   d="scan'208";a="398432646"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 09 Nov 2020 14:09:10 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 9 Nov 2020 14:09:09 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 9 Nov 2020 14:09:09 -0800
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.1713.004;
 Mon, 9 Nov 2020 14:09:09 -0800
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Qian Cai <cai@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
        <linux-tip-commits@vger.kernel.org>
CC:     Boris Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        x86 <x86@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [tip: ras/core] x86/mce: Enable additional error logging on
 certain Intel CPUs
Thread-Topic: [tip: ras/core] x86/mce: Enable additional error logging on
 certain Intel CPUs
Thread-Index: AQHWsQncdZGZz6bl20aw0A24zT9Gy6nA6f4A//98jeA=
Date:   Mon, 9 Nov 2020 22:09:08 +0000
Message-ID: <bfc274fc27724ea39ecac1e7ac834ed8@intel.com>
References: <20201030190807.GA13884@agluck-desk2.amr.corp.intel.com>
         <160431588828.397.16468104725047768957.tip-bot2@tip-bot2>
 <3f863634cd75824907e8ccf8164548c2ef036f20.camel@redhat.com>
In-Reply-To: <3f863634cd75824907e8ccf8164548c2ef036f20.camel@redhat.com>
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

V2hhdCBkb2VzIEtWTSBkbyB3aXRoIG1vZGVsIHNwZWNpZmljIE1TUnM/DQoNCkxvb2tzIGxpa2Ug
eW91IGxldCB0aGUgZ3Vlc3QgYmVsaWV2ZSBpdCB3YXMgcnVubmluZyBvbiBvbmUgb2YgU2FuZHkg
QnJpZGdlLCBJdnkgQnJpZGdlLCBIYXN3ZWxsIChYZW9uKS4NCg0KU28sIHRoZSBjb3JlIE1DRSBj
b2RlIHRyaWVkIHRvIGVuYWJsZSBleHRlbmRlZCBlcnJvciByZXBvcnRpbmcuDQoNCklmIHRoZXJl
IGlzIGEgbW9kZSB0byBoYXZlIEtWTSBsZXQgdGhlIGd1ZXN0IHRoaW5rIHRoYXQgaXQgcmVhZC93
cm90ZSBNU1IgMHgxN0YsDQpidXQgYWN0dWFsbHksIGRvZXNuJ3QgZG8gaXQgLi4uIHRoYXQgd291
bGQgc2VlbSB0byBiZSBhIHJlYXNvbmFibGUgdGhpbmcgdG8gZG8gaGVyZS4NCg0KLVRvbnkNCg==
