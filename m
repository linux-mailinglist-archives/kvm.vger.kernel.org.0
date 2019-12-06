Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08EF7114B78
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 04:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbfLFDli (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 22:41:38 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:43370 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726097AbfLFDlh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 22:41:37 -0500
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 59C5C27F401CBA088E90;
        Fri,  6 Dec 2019 11:41:34 +0800 (CST)
Received: from dggeme764-chm.china.huawei.com (10.3.19.110) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 6 Dec 2019 11:41:34 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme764-chm.china.huawei.com (10.3.19.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Fri, 6 Dec 2019 11:41:33 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Fri, 6 Dec 2019 11:41:33 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Wanpeng Li <kernellwp@gmail.com>
CC:     Liran Alon <liran.alon@oracle.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] KVM: vmx: remove unreachable statement in
 vmx_get_msr_feature()
Thread-Topic: [PATCH] KVM: vmx: remove unreachable statement in
 vmx_get_msr_feature()
Thread-Index: AdWr5U1VkRpYj0RCSySPadjbFxdshg==
Date:   Fri, 6 Dec 2019 03:41:33 +0000
Message-ID: <6c7423896f6f49f2a2b439afe809db08@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.189.20]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

V2FucGVuZyBMaSA8a2VybmVsbHdwQGdtYWlsLmNvbT4gd3JvdGU6DQo+Pg0KPj4gPg0KPj4gPkkg
cGVyc29uYWxseSBqdXN0IHByZWZlciB0byByZW1vdmUgdGhlIOKAnGRlZmF1bHTigJ0gY2FzZSBh
bmQgY2hhbmdlIHRoaXMg4oCccmV0dXJuIDA74oCdIHRvIOKAnHJldHVybiAxO+KAnS4NCj4+ID5C
dXQgaXTigJlzIGEgbWF0dGVyIG9mIHRhc3RlIG9mIGNvdXJzZS4NCj4+ID4NCj4+IFllcy4gQXMg
d2hhdCAiIFR1cm5pcCBncmVlbnMsIGFsbCBoYXZlIGxvdmUgIiBzYWlkLiBeX14NCj4NCj5BY3R1
YWxseSBpdCBpcyBhIGdyZWF0IGFwcHJlY2lhdGVkIHRvIGludHJvZHVjZSBzb21ldGhpbmcgbW9y
ZSB1c2VmdWwgaW5zdGVhZCBvZiB0b25zIG9mIGNsZWFudXBzLCBJIHNhdyBndXlzIGRpZCBvbmUg
Y2xlYW51cCBhbmQgY2FuIGluY3VyIHNldmVyYWwgYnVncyBiZWZvcmUuDQo+DQpJJ2QgbGlrZSB0
byBpbnRyb2R1Y2Ugc29tZXRoaW5nIG1vcmUgdXNlZnVsLCBidXQgc2lkZSBjb3JuZXIgY2xlYW51
cHMgbWF5IGJlIGhhcmQgdG8NCmZvdW5kIG91dCBzb21ldGhpbmcgdG8gaW50cm9kdWNlLiBBbmQg
c3VjaCBjbGVhbnVwcyBjYW4gYWxzbyBiZSB2YWxpZGF0ZWQgYnkgY29kZSBpbnNwZWN0aW9uDQp0
byBhdm9pZCBzb21ldGhpbmcgYmFkLiBNYW55IHRoYW5rcy4NCg0K
