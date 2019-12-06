Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80DB0114EC4
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 11:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbfLFKK6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 05:10:58 -0500
Received: from foss.arm.com ([217.140.110.172]:38228 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbfLFKK5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 05:10:57 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E175DDA7;
        Fri,  6 Dec 2019 02:10:56 -0800 (PST)
Received: from [10.1.194.43] (e112269-lin.cambridge.arm.com [10.1.194.43])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EA3713F718;
        Fri,  6 Dec 2019 02:10:54 -0800 (PST)
Subject: Re: [PATCH] KVM: arm: get rid of unused arg in cpu_init_hyp_mode()
To:     linmiaohe <linmiaohe@huawei.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        "christoffer.dall@arm.com" <christoffer.dall@arm.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "will@kernel.org" <will@kernel.org>,
        "andre.przywara@arm.com" <andre.przywara@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Cc:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <8efe4ab7f8c44c48a70378247c511edc@huawei.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <11f06523-54ce-7025-a6ba-58c29769da60@arm.com>
Date:   Fri, 6 Dec 2019 10:10:53 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <8efe4ab7f8c44c48a70378247c511edc@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/11/2019 07:20, linmiaohe wrote:
>> From: Miaohe Lin <linmiaohe@huawei.com>
>>
>> As arg dummy is not really needed, there's no need to pass NULL when calling cpu_init_hyp_mode(). So clean it up.

It looks like the requirement for this dummy arg was removed in
67f691976662 ("arm64: kvm: allows kvm cpu hotplug"). FWIW:

Reviewed-by: Steven Price <steven.price@arm.com>

>> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
>> ---
>> virt/kvm/arm/arm.c | 4 ++--
>> 1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c index 86c6aa1cb58e..a5470f1b1a19 100644
>> --- a/virt/kvm/arm/arm.c
>> +++ b/virt/kvm/arm/arm.c
>> @@ -1315,7 +1315,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
>> 	}
>> }
>>
>> -static void cpu_init_hyp_mode(void *dummy)
>> +static void cpu_init_hyp_mode(void)
>> {
>> 	phys_addr_t pgd_ptr;
>> 	unsigned long hyp_stack_ptr;
>> @@ -1349,7 +1349,7 @@ static void cpu_hyp_reinit(void)
>> 	if (is_kernel_in_hyp_mode())
>> 		kvm_timer_init_vhe();
>> 	else
>> -		cpu_init_hyp_mode(NULL);
>> +		cpu_init_hyp_mode();
>>
>> 	kvm_arm_init_debug();
>>
> friendly ping ...
> 

