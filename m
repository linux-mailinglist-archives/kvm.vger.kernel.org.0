Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94C0F158833
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 03:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727618AbgBKC1A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 21:27:00 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:47836 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727493AbgBKC1A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 21:27:00 -0500
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 7425392B010A867031DC;
        Tue, 11 Feb 2020 10:26:56 +0800 (CST)
Received: from dggeme765-chm.china.huawei.com (10.3.19.111) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 11 Feb 2020 10:26:51 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme765-chm.china.huawei.com (10.3.19.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Tue, 11 Feb 2020 10:26:51 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Tue, 11 Feb 2020 10:26:51 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Wanpeng Li <kernellwp@gmail.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] KVM: Pre-allocate 1 cpumask variable per cpu for
 both pv tlb and pv ipis
Thread-Topic: [PATCH v2 2/2] KVM: Pre-allocate 1 cpumask variable per cpu for
 both pv tlb and pv ipis
Thread-Index: AdXggrZmg97Y1seqSJWOii/1n81pMQ==
Date:   Tue, 11 Feb 2020 02:26:51 +0000
Message-ID: <5d472766470e44e1b91fe1e5b2f247f8@huawei.com>
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

SGk6DQo+RnJvbTogV2FucGVuZyBMaSA8d2FucGVuZ2xpQHRlbmNlbnQuY29tPg0KPg0KPlRoaXMg
cGF0Y2ggZml4ZXMgaXQgYnkgcHJlLWFsbG9jYXRlIDEgY3B1bWFzayB2YXJpYWJsZSBwZXIgY3B1
IGFuZCB1c2UgaXQgZm9yIGJvdGggcHYgdGxiIGFuZCBwdiBpcGlzLi4NCj4NCj5SZXBvcnRlZC1i
eTogTmljayBEZXNhdWxuaWVycyA8bmRlc2F1bG5pZXJzQGdvb2dsZS5jb20+DQo+QWNrZWQtYnk6
IE5pY2sgRGVzYXVsbmllcnMgPG5kZXNhdWxuaWVyc0Bnb29nbGUuY29tPg0KPkNjOiBQZXRlciBa
aWpsc3RyYSA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+DQo+Q2M6IE5pY2sgRGVzYXVsbmllcnMgPG5k
ZXNhdWxuaWVyc0Bnb29nbGUuY29tPg0KPlNpZ25lZC1vZmYtYnk6IFdhbnBlbmcgTGkgPHdhbnBl
bmdsaUB0ZW5jZW50LmNvbT4NCg0KTG9va3MgZmluZSBmb3IgbWUuIFRoYW5rcy4NClJldmlld2Vk
LWJ5OiBNaWFvaGUgTGluIDxsaW5taWFvaGVAaHVhd2VpLmNvbT4NCg0K
