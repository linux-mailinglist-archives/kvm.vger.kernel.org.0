Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A76BF155AD1
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 16:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgBGPhR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 7 Feb 2020 10:37:17 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:45068 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726897AbgBGPhQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 10:37:16 -0500
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id E2BAF42169CDF2579051;
        Fri,  7 Feb 2020 23:37:10 +0800 (CST)
Received: from dggeme715-chm.china.huawei.com (10.1.199.111) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 7 Feb 2020 23:37:10 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme715-chm.china.huawei.com (10.1.199.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Fri, 7 Feb 2020 23:37:10 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Fri, 7 Feb 2020 23:37:10 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Eric Auger <eric.auger@redhat.com>
CC:     "thuth@redhat.com" <thuth@redhat.com>,
        "drjones@redhat.com" <drjones@redhat.com>,
        "wei.huang2@amd.com" <wei.huang2@amd.com>,
        "krish.sadhukhan@oracle.com" <krish.sadhukhan@oracle.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
Subject: Re: [PATCH v5 2/4] selftests: KVM: Remove unused x86_register enum
Thread-Topic: [PATCH v5 2/4] selftests: KVM: Remove unused x86_register enum
Thread-Index: AdXdzCUaPbXzvCH9Sx6jLGTWLt8gGw==
Date:   Fri, 7 Feb 2020 15:37:10 +0000
Message-ID: <d4aeb0ea2a2d4682a7bbdd8b1ef1ed9f@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.221.158]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Eric Auger <eric.auger@redhat.com> writes:
>x86_register enum is not used. Its presence incites us to enumerate GPRs in the same order in other looming structs. So let's remove it.
>
>Signed-off-by: Eric Auger <eric.auger@redhat.com>
>Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Make sense for me. Thanks.

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

