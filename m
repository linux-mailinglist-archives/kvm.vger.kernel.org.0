Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3188448E7E9
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 10:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240036AbiANJ6k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 04:58:40 -0500
Received: from mx24.baidu.com ([111.206.215.185]:33138 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230375AbiANJ6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 04:58:39 -0500
Received: from BJHW-Mail-Ex09.internal.baidu.com (unknown [10.127.64.32])
        by Forcepoint Email with ESMTPS id 1EFA69A41761EACC3207;
        Fri, 14 Jan 2022 17:58:38 +0800 (CST)
Received: from BJHW-MAIL-EX25.internal.baidu.com (10.127.64.40) by
 BJHW-Mail-Ex09.internal.baidu.com (10.127.64.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Fri, 14 Jan 2022 17:58:37 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BJHW-MAIL-EX25.internal.baidu.com (10.127.64.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Fri, 14 Jan 2022 17:58:37 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.020; Fri, 14 Jan 2022 17:58:37 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Wanpeng Li <kernellwp@gmail.com>
CC:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Wang,Guangju" <wangguangju@baidu.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIEtWTTogWDg2OiBzZXQgdmNwdSBwcmVlbXB0ZWQg?=
 =?utf-8?Q?only_if_it_is_preempted?=
Thread-Topic: [PATCH] KVM: X86: set vcpu preempted only if it is preempted
Thread-Index: AQHYB7WMg7j2vnvXFkKy6dq5PabOWqxfHr2AgABDQICAAPSkQIAAC6mAgAHnQWA=
Date:   Fri, 14 Jan 2022 09:58:37 +0000
Message-ID: <6809f1c505c04f43aafc85b7fddcdaa4@baidu.com>
References: <1641988921-3507-1-git-send-email-lirongqing@baidu.com>
 <Yd7S5rEYZg8v93NX@hirez.programming.kicks-ass.net>
 <Yd8QR2KHDfsekvNg@google.com>
 <20220112213129.GO16608@worktop.programming.kicks-ass.net>
 <bb92391dc5de46ac87ff238faf875c7b@baidu.com>
 <CANRm+CwMTqCF7ReVoQKcOVasiXQcnZX7YC_CKJhHg52eBveUDQ@mail.gmail.com>
In-Reply-To: <CANRm+CwMTqCF7ReVoQKcOVasiXQcnZX7YC_CKJhHg52eBveUDQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.206.28]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBTbyBpdCBpcyB0aGUgc2Vjb25kIHRpbWUgZ3V5cyB0YWxrIGFib3V0IHRoaXMsIHdlIHNob3Vs
ZCB0dW5lIHRoZSBkZWRpY2F0ZWQNCj4gc2NlbmFyaW8gbGlrZSBhZHZlcnRpc2UgZ3Vlc3QgS1ZN
X0hJTlRfUkVBTFRJTUUgZmVhdHVyZSBhbmQgbm90IGludGVyY2VwdA0KPiBtd2FpdC9obHQvcGF1
c2Ugc2ltdWx0YW5lb3VzbHkgdG8gZ2V0IHRoZSBiZXN0IHBlcmZvcm1hbmNlLg0KPiANCj4gICAg
IFdhbnBlbmcNCg0KU2ltaWxhciB0byBLVk1fRkVBVFVSRV9TVEVBTF9USU1FDQoNCkl0IGlzIGNv
bnRyYWRpY3Rpb24gdG8gYWR2ZXJ0aXNlIEtWTV9ISU5UX1JFQUxUSU1FIGZlYXR1cmUgYW5kIEtW
TV9GRUFUVVJFX1NURUFMX1RJTUUgZmVhdHVyZSB0byBndWVzdCBhdCB0aGUgc2FtZSB0aW1lDQoN
Ci1MaQ0K
