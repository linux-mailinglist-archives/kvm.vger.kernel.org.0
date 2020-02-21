Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B33B166C58
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 02:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729537AbgBUBbf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 20 Feb 2020 20:31:35 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2587 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729502AbgBUBbe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 20:31:34 -0500
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id 21462BDAFE3C774C6D18;
        Fri, 21 Feb 2020 09:31:31 +0800 (CST)
Received: from dggeme754-chm.china.huawei.com (10.3.19.100) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 21 Feb 2020 09:31:29 +0800
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme754-chm.china.huawei.com (10.3.19.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Fri, 21 Feb 2020 09:31:28 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1713.004;
 Fri, 21 Feb 2020 09:31:28 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: apic: avoid calculating pending eoi from an
 uninitialized val
Thread-Topic: [PATCH] KVM: apic: avoid calculating pending eoi from an
 uninitialized val
Thread-Index: AdXoVXZpfpesId6ET2iiNj75bnuaGg==
Date:   Fri, 21 Feb 2020 01:31:28 +0000
Message-ID: <91e9222f333648db84cb06c77cbdfb2f@huawei.com>
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

Vitaly Kuznetsov <vkuznets@redhat.com> writes:
>linmiaohe <linmiaohe@huawei.com> writes:
>> When get user eoi value failed, var val would be uninitialized and 
>> result in calculating pending eoi from an uninitialized val. 
>> Initialize var val to 0 to fix this case.
>
>Let me try to suggest an alternative wording,
>
>"When pv_eoi_get_user() fails, 'val' may remain uninitialized and the return value of pv_eoi_get_pending() becomes random. Fix the issue by initializing the variable."

Sounds much better. You're really good at it. :) Thanks.

>>
>>
>Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>
>But why compilers don't complain?

Maybe it's because @val only remain uninitialized when pv_eoi_get_user() failed?

