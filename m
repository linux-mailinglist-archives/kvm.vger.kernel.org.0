Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3415A133D57
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 09:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbgAHIhx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 03:37:53 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2921 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726313AbgAHIhx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 03:37:53 -0500
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 7B7B13D67110E36FE76C;
        Wed,  8 Jan 2020 16:37:49 +0800 (CST)
Received: from dggeme766-chm.china.huawei.com (10.3.19.112) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 8 Jan 2020 16:37:49 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme766-chm.china.huawei.com (10.3.19.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 8 Jan 2020 16:37:48 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Wed, 8 Jan 2020 16:37:48 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86/mmu: Fix a benign Bitwise vs. Logical OR mixup
Thread-Topic: [PATCH] KVM: x86/mmu: Fix a benign Bitwise vs. Logical OR mixup
Thread-Index: AdXF/gTC8Mase5IDSN6uFk3TkzmHmw==
Date:   Wed, 8 Jan 2020 08:37:48 +0000
Message-ID: <09ad7e0c69264929a5508eab8833abdc@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.221.158]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGmjug0KPg0KPlVzZSBhIExvZ2ljYWwgT1IgaW4gX19pc19yc3ZkX2JpdHNfc2V0KCkgdG8gY29t
YmluZSB0aGUgdHdvIHJlc2VydmVkIGJpdCBjaGVja3MsIHdoaWNoIGFyZSBvYnZpb3VzbHkgaW50
ZW5kZWQgdG8gYmUgbG9naWNhbCBzdGF0ZW1lbnRzLiAgU3dpdGNoaW5nIHRvIGEgTG9naWNhbCBP
UiBpcyBmdW5jdGlvbmFsbHkgYSBub3AsIGJ1dCBhbGxvd3MgdGhlIGNvbXBpbGVyIHRvIGJldHRl
ciBvcHRpbWl6ZSB0aGUgY2hlY2tzLg0KPg0KPlNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3Bo
ZXJzb24gPHNlYW4uai5jaHJpc3RvcGhlcnNvbkBpbnRlbC5jb20+DQo+LS0tDQo+IGFyY2gveDg2
L2t2bS9tbXUvbW11LmMgfCAyICstDQo+IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwg
MSBkZWxldGlvbigtKQ0KPg0KPmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vbW11L21tdS5jIGIv
YXJjaC94ODYva3ZtL21tdS9tbXUuYyBpbmRleCA3MjY5MTMwZWE1ZTIuLjcyZTg0NTcwOTAyNyAx
MDA2NDQNCj4tLS0gYS9hcmNoL3g4Ni9rdm0vbW11L21tdS5jDQo+KysrIGIvYXJjaC94ODYva3Zt
L21tdS9tbXUuYw0KPkBAIC0zOTcwLDcgKzM5NzAsNyBAQCBfX2lzX3JzdmRfYml0c19zZXQoc3Ry
dWN0IHJzdmRfYml0c192YWxpZGF0ZSAqcnN2ZF9jaGVjaywgdTY0IHB0ZSwgaW50IGxldmVsKSAg
ew0KPiAJaW50IGJpdDcgPSAocHRlID4+IDcpICYgMSwgbG93NiA9IHB0ZSAmIDB4M2Y7DQo+IA0K
Pi0JcmV0dXJuIChwdGUgJiByc3ZkX2NoZWNrLT5yc3ZkX2JpdHNfbWFza1tiaXQ3XVtsZXZlbC0x
XSkgfA0KPisJcmV0dXJuIChwdGUgJiByc3ZkX2NoZWNrLT5yc3ZkX2JpdHNfbWFza1tiaXQ3XVts
ZXZlbC0xXSkgfHwNCj4gCQkoKHJzdmRfY2hlY2stPmJhZF9tdF94d3IgJiAoMXVsbCA8PCBsb3c2
KSkgIT0gMCk7ICB9DQo+IA0KPi0tDQo+Mi4yNC4xDQoNCk9uIHRoZSBjYWxsIGNoYWluIHdhbGtf
c2hhZG93X3BhZ2VfZ2V0X21taW9fc3B0ZSAtLT4gaXNfc2hhZG93X3plcm9fYml0c19zZXQgLS0+
IF9faXNfcnN2ZF9iaXRzX3NldCwgdGhlDQpyZXR1cm4gdmFsdWUgaXMgdXNlZCBhczoNCglyZXNl
cnZlZCB8PSBpc19zaGFkb3dfemVyb19iaXRzX3NldCh2Y3B1LT5hcmNoLm1tdSwgc3B0ZSwNCgkJ
aXRlcmF0b3IubGV2ZWwpOw0KDQpCdXQgdGhpcyBzZWVtcyBvayBiZWNhdXNlIHZhbCByZXNlcnZl
ZCBpcyBib29sIHR5cGUuDQoNClRoYW5rcy4NCg==
