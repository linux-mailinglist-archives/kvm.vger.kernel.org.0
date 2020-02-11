Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A349215880E
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 02:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgBKBzO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 20:55:14 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2566 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727523AbgBKBzO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 20:55:14 -0500
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id C93CE470880F7CC2C6E1;
        Tue, 11 Feb 2020 09:55:11 +0800 (CST)
Received: from dggeme715-chm.china.huawei.com (10.1.199.111) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 11 Feb 2020 09:55:11 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme715-chm.china.huawei.com (10.1.199.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Tue, 11 Feb 2020 09:55:11 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Tue, 11 Feb 2020 09:55:11 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Wanpeng Li <kernellwp@gmail.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] KVM: Introduce pv check helpers
Thread-Topic: [PATCH v2 1/2] KVM: Introduce pv check helpers
Thread-Index: AdXgfkm1R6Aez6ipz0iYtvOK3MHP9A==
Date:   Tue, 11 Feb 2020 01:55:11 +0000
Message-ID: <dc7a5abe33db48f19333bd5da4673743@huawei.com>
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

SGk6DQpXYW5wZW5nIExpIDxrZXJuZWxsd3BAZ21haWwuY29tPiB3cm90ZToNCj4gSW50cm9kdWNl
IHNvbWUgcHYgY2hlY2sgaGVscGVycyBmb3IgY29uc2lzdGVuY3kuDQo+DQo+IFN1Z2dlc3RlZC1i
eTogVml0YWx5IEt1em5ldHNvdiA8dmt1em5ldHNAcmVkaGF0LmNvbT4NCj4gU2lnbmVkLW9mZi1i
eTogV2FucGVuZyBMaSA8d2FucGVuZ2xpQHRlbmNlbnQuY29tPg0KPiAtLS0NCj4gIGFyY2gveDg2
L2tlcm5lbC9rdm0uYyB8IDM0ICsrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0NCj4g
IDEgZmlsZSBjaGFuZ2VkLCAyNCBpbnNlcnRpb25zKCspLCAxMCBkZWxldGlvbnMoLSkNCg0KTG9v
a3MgZ29vZCBmb3IgbWUuIFRoYW5rcy4NClJldmlld2VkLWJ5OiBNaWFvaGUgTGluIDxsaW5taWFv
aGVAaHVhd2VpLmNvbT4NCg0K
