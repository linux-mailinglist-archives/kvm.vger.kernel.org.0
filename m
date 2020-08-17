Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F6D2461CB
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 11:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbgHQJDS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 05:03:18 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:57998 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726837AbgHQJDQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 05:03:16 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C7AD0D26D5A74FB8370D;
        Mon, 17 Aug 2020 17:03:11 +0800 (CST)
Received: from [10.174.187.22] (10.174.187.22) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Mon, 17 Aug 2020 17:02:57 +0800
Subject: Re: [PATCH 1/3] KVM: arm64: Some fixes of PV-time interface document
To:     Andrew Jones <drjones@redhat.com>
References: <20200817033729.10848-1-zhukeqian1@huawei.com>
 <20200817033729.10848-2-zhukeqian1@huawei.com>
 <20200817084735.xyfdtgcsuxzwgzyr@kamzik.brq.redhat.com>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Steven Price <steven.price@arm.com>,
        <wanghaibin.wang@huawei.com>
From:   zhukeqian <zhukeqian1@huawei.com>
Message-ID: <2128580f-1a3b-bdb3-e75a-99dcc36c66a3@huawei.com>
Date:   Mon, 17 Aug 2020 17:02:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20200817084735.xyfdtgcsuxzwgzyr@kamzik.brq.redhat.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andrew,

On 2020/8/17 16:47, Andrew Jones wrote:
> On Mon, Aug 17, 2020 at 11:37:27AM +0800, Keqian Zhu wrote:
>> Rename PV_FEATURES tp PV_TIME_FEATURES
>>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>  Documentation/virt/kvm/arm/pvtime.rst | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/arm/pvtime.rst b/Documentation/virt/kvm/arm/pvtime.rst
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
>>  
>>  https://developer.arm.com/docs/den0057/a
>> @@ -19,8 +19,8 @@ Two new SMCCC compatible hypercalls are defined:
>>  
>>  These are only available in the SMC64/HVC64 calling convention as
>>  paravirtualized time is not available to 32 bit Arm guests. The existence of
>> -the PV_FEATURES hypercall should be probed using the SMCCC 1.1 ARCH_FEATURES
>> -mechanism before calling it.
>> +the PV_TIME_FEATURES hypercall should be probed using the SMCCC 1.1
>> +ARCH_FEATURES mechanism before calling it.
>>  
>>  PV_TIME_FEATURES
>>      ============= ========    ==========
>> -- 
>> 1.8.3.1
>>
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>
Thanks for your review.

Also It will be very nice if you have time to review the patch series
supporting pvtime LPT.

Thanks,
Keqian
> 
> .
> 
