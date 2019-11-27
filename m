Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91AEC10A90E
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 04:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfK0DaL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Nov 2019 22:30:11 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2462 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726454AbfK0DaL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Nov 2019 22:30:11 -0500
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 983BD91351143F91A5AC;
        Wed, 27 Nov 2019 11:30:07 +0800 (CST)
Received: from dggeme714-chm.china.huawei.com (10.1.199.110) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 27 Nov 2019 11:30:06 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme714-chm.china.huawei.com (10.1.199.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 27 Nov 2019 11:30:07 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Wed, 27 Nov 2019 11:30:06 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Haiwei Li <lihaiwei.kernel@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: SVM: Fix "error" isn't initialized
Thread-Topic: [PATCH] KVM: SVM: Fix "error" isn't initialized
Thread-Index: AdWk0V/ezR/D5Gv1EUeQk58gmO3fng==
Date:   Wed, 27 Nov 2019 03:30:06 +0000
Message-ID: <3b418fab6b804c6cba48e372cce875c1@huawei.com>
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

DQo+IEZyb206IEhhaXdlaSBMaSA8bGloYWl3ZWlAdGVuY2VudC5jb20+DQo+IFN1YmplY3Q6IFtQ
QVRDSF0gaW5pdGlhbGl6ZSAnZXJyb3InDQo+DQo+IFRoZXJlIGFyZSBhIGJ1bmNoIG9mIGVycm9y
IHBhdGhzIHdlcmUgImVycm9yIiBpc24ndCBpbml0aWFsaXplZC4NCkhpLA0KSW4gY2FzZSBlcnJv
ciBjYXNlLCBzZXZfZ3Vlc3RfZGZfZmx1c2goKSBkbyBub3Qgc2V0IHRoZSBlcnJvci4NCkNhbiB5
b3Ugc2V0IHRoZSB2YWx1ZSBvZiBlcnJvciB0byByZWZsZWN0IHdoYXQgZXJyb3IgaGFwcGVuZWQN
CmluIHNldl9ndWVzdF9kZl9mbHVzaCgpPw0KVGhlIGN1cnJlbnQgZml4IG1heSBsb29rcyBjb25m
dXNlZCB3aGVuIHByaW50ICJERl9GTFVTSCBmYWlsZWQiIHdpdGgNCmVycm9yID0gMC4NClRoYW5r
cy4gDQoNClBTOiBUaGlzIGlzIGp1c3QgbXkgcGVyc29uYWwgcG9pbnQuDQo+DQo+IFNpZ25lZC1v
ZmYtYnk6IEhhaXdlaSBMaSA8bGloYWl3ZWlAdGVuY2VudC5jb20+DQo+IFJlcG9ydGVkLWJ5OiBE
YW4gQ2FycGVudGVyIDxkYW4uY2FycGVudGVyQG9yYWNsZS5jb20+DQo+LS0tIGEvYXJjaC94ODYv
a3ZtL3N2bS5jDQo+KysrIGIvYXJjaC94ODYva3ZtL3N2bS5jDQo+QEAgLTYyOTQsNyArNjI5NCw4
IEBAIHN0YXRpYyBpbnQgZW5hYmxlX3NtaV93aW5kb3coc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0K
Pg0KPiBzdGF0aWMgaW50IHNldl9mbHVzaF9hc2lkcyh2b2lkKQ0KPiB7DQo+LQlpbnQgcmV0LCBl
cnJvcjsNCj4rCWludCByZXQ7DQo+KwlpbnQgZXJyb3IgPSAwOw0KPg0KPiAJLyoNCj4gCSAqIERF
QUNUSVZBVEUgd2lsbCBjbGVhciB0aGUgV0JJTlZEIGluZGljYXRvciBjYXVzaW5nIERGX0ZMVVNI
IHRvIGZhaWwsDQo=
