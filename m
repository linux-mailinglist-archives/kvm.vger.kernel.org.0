Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9E381562BD
	for <lists+kvm@lfdr.de>; Sat,  8 Feb 2020 03:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgBHCwF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 21:52:05 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2945 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726743AbgBHCwF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 21:52:05 -0500
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 7A9D6AC11E519B18413A;
        Sat,  8 Feb 2020 10:51:59 +0800 (CST)
Received: from dggeme715-chm.china.huawei.com (10.1.199.111) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 8 Feb 2020 10:51:59 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme715-chm.china.huawei.com (10.1.199.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Sat, 8 Feb 2020 10:51:58 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Sat, 8 Feb 2020 10:51:58 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Oliver Upton <oupton@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 1/5] KVM: x86: Mask off reserved bit from #DB exception
 payload
Thread-Topic: [PATCH v3 1/5] KVM: x86: Mask off reserved bit from #DB
 exception payload
Thread-Index: AdXeKhVEuvSZqbJbQxO5cP7+FaX4iQ==
Date:   Sat, 8 Feb 2020 02:51:58 +0000
Message-ID: <66fe8b30b2934746adfb77f15f13b3f5@huawei.com>
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

T2xpdmVyIFVwdG9uIDxvdXB0b25AZ29vZ2xlLmNvbT4gd3JpdGVzOg0KPiBLVk0gZGVmaW5lcyB0
aGUgI0RCIHBheWxvYWQgYXMgY29tcGF0aWJsZSB3aXRoIHRoZSAncGVuZGluZyBkZWJ1ZyBleGNl
cHRpb25zJyBmaWVsZCB1bmRlciBWTVgsIG5vdCBEUjYuIE1hc2sgb2ZmIGJpdCAxMiB3aGVuIGFw
cGx5aW5nIHRoZSBwYXlsb2FkIHRvIERSNiwgYXMgaXQgaXMgcmVzZXJ2ZWQgb24gRFI2IGJ1dCBu
b3QgdGhlICdwZW5kaW5nIGRlYnVnIGV4Y2VwdGlvbnMnIGZpZWxkLg0KPg0KPiBGaXhlczogZjEw
YzcyOWZmOTY1ICgia3ZtOiB2bXg6IERlZmVyIHNldHRpbmcgb2YgRFI2IHVudGlsICNEQiBkZWxp
dmVyeSIpDQo+IFNpZ25lZC1vZmYtYnk6IE9saXZlciBVcHRvbiA8b3VwdG9uQGdvb2dsZS5jb20+
DQo+DQoNCkxvb2tzIGZpbmUgZm9yIG1lLiBUaGFua3MuDQoNClJldmlld2VkLWJ5OiBNaWFvaGUg
TGluIDxsaW5taWFvaGVAaHVhd2VpLmNvbT4NCg0KDQo=
