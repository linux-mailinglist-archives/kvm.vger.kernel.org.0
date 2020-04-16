Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75651AB5C8
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 04:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731562AbgDPCQW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 22:16:22 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2335 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728397AbgDPCQU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 22:16:20 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 39A5686E337A8F2A7A88;
        Thu, 16 Apr 2020 10:16:10 +0800 (CST)
Received: from [127.0.0.1] (10.166.213.7) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Thu, 16 Apr 2020
 10:15:59 +0800
Subject: Re: [PATCH] x86/kvm: make steal_time static
To:     Paolo Bonzini <pbonzini@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <x86@kernel.org>, <hpa@zytor.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Hulk Robot <hulkci@huawei.com>
References: <20200415084939.6367-1-yanaijie@huawei.com>
 <d1700173-29c1-2e7c-46bd-471876d96762@redhat.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <35c3890e-0c45-0dac-e9f0-f2a9446a387d@huawei.com>
Date:   Thu, 16 Apr 2020 10:15:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <d1700173-29c1-2e7c-46bd-471876d96762@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.166.213.7]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2020/4/15 22:42, Paolo Bonzini 写道:
> On 15/04/20 10:49, Jason Yan wrote:
>> Fix the following sparse warning:
>>
>> arch/x86/kernel/kvm.c:58:1: warning: symbol '__pcpu_scope_steal_time'
>> was not declared. Should it be static?
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> ---
>>   arch/x86/kernel/kvm.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>> index 6efe0410fb72..f75010cde5d5 100644
>> --- a/arch/x86/kernel/kvm.c
>> +++ b/arch/x86/kernel/kvm.c
>> @@ -55,7 +55,7 @@ static int __init parse_no_stealacc(char *arg)
>>   early_param("no-steal-acc", parse_no_stealacc);
>>   
>>   static DEFINE_PER_CPU_DECRYPTED(struct kvm_vcpu_pv_apf_data, apf_reason) __aligned(64);
>> -DEFINE_PER_CPU_DECRYPTED(struct kvm_steal_time, steal_time) __aligned(64) __visible;
>> +static DEFINE_PER_CPU_DECRYPTED(struct kvm_steal_time, steal_time) __aligned(64) __visible;
>>   static int has_steal_clock = 0;
>>   
>>   /*
>>
> 
> Queued, thanks.
> 

Sorry that I found 14e581c381b9 ("x86/kvm: Make steal_time visible")
said that it is used by assembler code but I didn't find where.
Please drop this patch if it's true.

Sorry to make this trouble again.

Thanks,

Jason

> Paolo
> 
> 
> .
> 

