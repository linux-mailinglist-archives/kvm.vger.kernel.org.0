Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A132E47C7
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 11:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439221AbfJYJtl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 05:49:41 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:43828 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2439160AbfJYJtl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 05:49:41 -0400
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id 09E827E0A4A560F52CB7;
        Fri, 25 Oct 2019 17:49:33 +0800 (CST)
Received: from dggeme715-chm.china.huawei.com (10.1.199.111) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 25 Oct 2019 17:49:32 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme715-chm.china.huawei.com (10.1.199.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Fri, 25 Oct 2019 17:49:31 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Fri, 25 Oct 2019 17:49:31 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: avoid unnecessary bitmap clear ops
Thread-Topic: [PATCH] KVM: avoid unnecessary bitmap clear ops
Thread-Index: AdWLGPUbWU4zWQBTHE+yWMGIt2B/2Q==
Date:   Fri, 25 Oct 2019 09:49:31 +0000
Message-ID: <5a9c7a85a5b14542ab773d5a5e454286@huawei.com>
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

DQpPbiAyNS8xMC8xOSAxNzo0MywgUGFvbG8gd3JvdGU6DQo+IE9uIDI1LzEwLzE5IDA0OjI0LCBN
aWFvaGUgTGluIHdyb3RlOg0KPj4gV2hlbiBzZXQgb25lIGJpdCBpbiBiaXRtYXAsIHRoZXJlIGlz
IG5vIG5lZWQgdG8gY2xlYXIgaXQgYmVmb3JlLg0KPg0KPkhpLA0KPg0KPmluIGdlbmVyYWwgdGhl
IExpbnV4IGNvZGluZyBzdHlsZSBwcmVmZXJzOg0KPg0KPglhID0geDsNCj4JaWYgKC4uLik7DQo+
CQlhID0geTsNCj4NCj50bw0KPg0KPglpZiAoLi4uKQ0KPgkJYSA9IHk7DQo+CWVsc2UNCj4JCWEg
PSB4Ow0KPg0KPndoaWNoIGlzIHdoeSB0aGVzZSBsaW5lcyB3ZXJlIHdyaXR0ZW4gdGhpcyB3YXku
DQoNCk1hbnkgdGhhbmtzIGZvciB5b3VyIGV4cGxhbmF0aW9uLiBJIHNlZS4NCkhhdmUgYSBuaWNl
IGRheS4NCg0KPg0KPlRoYW5rcywNCj4NCj5QYW9sbw0KPg0K
