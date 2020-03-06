Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E952A17B468
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 03:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgCFCXA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 21:23:00 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2599 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726178AbgCFCW7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 21:22:59 -0500
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 307FD2A25DEFBEA4D7A0;
        Fri,  6 Mar 2020 10:22:58 +0800 (CST)
Received: from dggeme752-chm.china.huawei.com (10.3.19.98) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 6 Mar 2020 10:22:57 +0800
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme752-chm.china.huawei.com (10.3.19.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Fri, 6 Mar 2020 10:22:57 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1713.004;
 Fri, 6 Mar 2020 10:22:57 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     "hpa@zytor.com" <hpa@zytor.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH] KVM: x86: small optimization for is_mtrr_mask calculation
Thread-Topic: [PATCH] KVM: x86: small optimization for is_mtrr_mask
 calculation
Thread-Index: AdXzXdBJSc7pa5yVRvaRRlGuRkJn5g==
Date:   Fri, 6 Mar 2020 02:22:57 +0000
Message-ID: <4e9d847ea5d54e4fa83f3bb910242e16@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.221.158]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

aHBhQHp5dG9yLmNvbSB3cm90ZToNCj4+T24gTWFyY2ggNSwgMjAyMCA2OjA1OjQwIFBNIFBTVCwg
bGlubWlhb2hlIDxsaW5taWFvaGVAaHVhd2VpLmNvbT4gd3JvdGU6DQo+PkhpLA0KPj5QYW9sbyBC
b256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPiB3cm90ZToNCj4+TWFueSB0aGFua3MgZm9yIHN1
Z2dlc3Rpb24uIFdoYXQgZG8geW91IG1lYW4gaXMgbGlrZSB0aGlzID8NCj4+DQo+PglpbmRleCA9
IChtc3IgLSAweDIwMCkgPj4gMTsNCj4+CWlzX210cnJfbWFzayA9IG1zciAmIDE7DQo+Pg0KPj5U
aGFua3MgYWdhaW4uDQo+DQo+WW91IHJlYWxpemUgdGhhdCB0aGUgY29tcGlsZXIgd2lsbCBwcm9i
YWJseSBwcm9kdWNlIGV4YWN0bHkgdGhlIHNhbWUgY29kZSwgcmlnaHQ/IEFzIHN1Y2gsIGl0IGlz
IGFib3V0IG1ha2luZyB0aGUgY29kZSBlYXN5IGZvciB0aGUgaHVtYW4gcmVhZGVyLg0KPg0KPkV2
ZW4gaWYgaXQgZGlkbid0LCB0aGlzIGNvZGUgaXMgYXMgZmFyIGZyb20gcGVyZm9ybWFuY2UgY3Jp
dGljYWwgYXMgb25lIGNhbiBwb3NzaWJseSBnZXQuDQoNClllcCwgaXQgbG9va3MgZ2FpbiBsaXR0
bGUuIFRoYW5rcy4NCg0K
