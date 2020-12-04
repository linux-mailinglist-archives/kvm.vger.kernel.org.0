Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304A32CE7E9
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 07:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbgLDGJh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 01:09:37 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:8941 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725550AbgLDGJh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 01:09:37 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CnMhY5W3czhmTV;
        Fri,  4 Dec 2020 14:08:29 +0800 (CST)
Received: from [10.174.187.37] (10.174.187.37) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Fri, 4 Dec 2020 14:08:26 +0800
Subject: Re: [PATCH v2 1/2] KVM: arm64: Some fixes of PV-time interface
 document
To:     Marc Zyngier <maz@kernel.org>
References: <20200817110728.12196-1-zhukeqian1@huawei.com>
 <20200817110728.12196-2-zhukeqian1@huawei.com>
 <3eddcebd87f09c1d48bf43e1b43ce390@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        Steven Price <steven.price@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>
From:   zhukeqian <zhukeqian1@huawei.com>
Message-ID: <c1e3c3c7-a86d-f64f-cd18-3a0788d9938e@huawei.com>
Date:   Fri, 4 Dec 2020 14:08:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <3eddcebd87f09c1d48bf43e1b43ce390@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.37]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020/12/3 23:04, Marc Zyngier wrote:
> On 2020-08-17 12:07, Keqian Zhu wrote:
>> Rename PV_FEATURES to PV_TIME_FEATURES.
>>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> Reviewed-by: Andrew Jones <drjones@redhat.com>
>> Reviewed-by: Steven Price <steven.price@arm.com>
>> ---
>>  Documentation/virt/kvm/arm/pvtime.rst | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/arm/pvtime.rst
>> b/Documentation/virt/kvm/arm/pvtime.rst
>> index 687b60d..94bffe2 100644
>> --- a/Documentation/virt/kvm/arm/pvtime.rst
>> +++ b/Documentation/virt/kvm/arm/pvtime.rst
>> @@ -3,7 +3,7 @@
>>  Paravirtualized time support for arm64
>>  ======================================
>>
>> -Arm specification DEN0057/A defines a standard for paravirtualised time
>> +Arm specification DEN0057/A defines a standard for paravirtualized time
>>  support for AArch64 guests:
> 
> nit: I do object to this change (some of us are British! ;-).
Oh, I will pay attention to this. Thanks!

Keqian
> 
>         M.
