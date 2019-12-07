Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF0E115B76
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 08:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfLGHOF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Dec 2019 02:14:05 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2526 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725869AbfLGHOE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Dec 2019 02:14:04 -0500
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 9DFD3EAF984A1CA80CEC;
        Sat,  7 Dec 2019 15:13:59 +0800 (CST)
Received: from dggeme766-chm.china.huawei.com (10.3.19.112) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 7 Dec 2019 15:13:59 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme766-chm.china.huawei.com (10.3.19.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Sat, 7 Dec 2019 15:13:59 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Sat, 7 Dec 2019 15:13:59 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: arm: fix missing free_percpu_irq in
 kvm_timer_hyp_init()
Thread-Topic: [PATCH] KVM: arm: fix missing free_percpu_irq in
 kvm_timer_hyp_init()
Thread-Index: AdWszcSfbfmyPnL7QOOWA4e8Y3r2BA==
Date:   Sat, 7 Dec 2019 07:13:58 +0000
Message-ID: <c856fab1586545cf9779e06aeaca294a@huawei.com>
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

TWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4gd3JvdGU6DQo+T24gMjAxOS0xMS0yMyAwMjoz
MCwgbGlubWlhb2hlIHdyb3RlOg0KPj4gRnJvbTogTWlhb2hlIExpbiA8bGlubWlhb2hlQGh1YXdl
aS5jb20+DQo+Pg0KPj4gV2hlbiBob3N0X3B0aW1lcl9pcnEgcmVxdWVzdCBpcnEgcmVzb3VyY2Ug
ZmFpbGVkLCB3ZSBmb3JnZXQgdG8gcmVsZWFzZSANCj4+IHRoZSBob3N0X3Z0aW1lcl9pcnEgcmVz
b3VyY2UgYWxyZWFkeSByZXF1ZXN0ZWQuDQo+PiBGaXggdGhpcyBtaXNzaW5nIGlycSByZWxlYXNl
IGFuZCBvdGhlciBzaW1pbGFyIHNjZW5hcmlvLg0KPg0KPlRoYXQncyByZWFsbHkgbm90IGEgYmln
IGRlYWwsIGFzIG5vdGhpbmcgYnV0IEtWTSBjYW4gdXNlIHRoZSB0aW1lcnMgYW55d2F5LCBidXQg
SSBndWVzcyBpdCBkb2Vzbid0IGh1cnQgdG8gYmUgY29ycmVjdC4NCg0KSSB0aGluayBJdCdzIGEg
Z29vZCBwcmFjdGljZSB0byByZWxlYXNlIHRoZSBuZXZlciB1c2VkIHJlc291cmNlcyB0aG91Z2gg
aXQgbWF5IGJlIGhhcm1sZXNzLg0KDQo+Pg0KPj4gLW91dF9mcmVlX2lycToNCj4+ICsNCj4+ICtv
dXRfZnJlZV9wdGltZXJfaXJxOg0KPj4gKwlmcmVlX3BlcmNwdV9pcnEoaG9zdF9wdGltZXJfaXJx
LCBrdm1fZ2V0X3J1bm5pbmdfdmNwdXMoKSk7DQo+PiArb3V0X2Rpc2FibGVfZ2ljX3N0YXRlOg0K
Pj4gKwlpZiAoaGFzX2dpYykNCj4+ICsJCXN0YXRpY19icmFuY2hfZGlzYWJsZSgmaGFzX2dpY19h
Y3RpdmVfc3RhdGUpOw0KPg0KPkdpdmVuIHRoYXQgd2UncmUgZmFpbGluZyB0aGUgaW5pdCBvZiBL
Vk0sIHRoaXMgaXMgdG90YWxseSBzdXBlcmZsdW91cy4gQWxzbywgdGhpcyBzdGF0ZSBpcyBzdGls
bCB2YWxpZCwgbm8gbWF0dGVyIHdoYXQgaGFwcGVucyAodGhlIEdJQyBpcyBub3QgZ29pbmcgYXdh
eSBmcm9tIHVuZGVyIG91ciBmZWV0KS4NCj4NCg0KV291bGQgeW91IGxpa2UgYSB2MiBwYXRjaCB3
aXRob3V0IG91dF9kaXNhYmxlX2dpY19zdGF0ZSBjbGVhbnVwID8gSWYgc28sIEkgd291bGQgc2Vu
ZCBhIG5ldyBvbmUuIEJ1dCBpZiB5b3UNCnRoaW5rIHRoaXMgcGF0Y2ggaXNuJ3Qgd29ydGggdG8g
cGljayB1cCwgSSB3b3VsZCBkcm9wIGl0Lg0KDQpNYW55IHRoYW5rcyBmb3IgeW91ciByZXZpZXcu
DQoNCj4+ICtvdXRfZnJlZV92dGltZXJfaXJxOg0KPj4gIAlmcmVlX3BlcmNwdV9pcnEoaG9zdF92
dGltZXJfaXJxLCBrdm1fZ2V0X3J1bm5pbmdfdmNwdXMoKSk7DQo+PiArDQo=
