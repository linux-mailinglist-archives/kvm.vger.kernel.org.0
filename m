Return-Path: <kvm+bounces-21925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FD6E937624
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 11:51:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CAA4283E37
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 09:51:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA52884052;
	Fri, 19 Jul 2024 09:51:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1139942076;
	Fri, 19 Jul 2024 09:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721382697; cv=none; b=dX8VzqSXtRPYD/3lQVYRY2/ymhS3g07XA10XF4qJxGrVxAx5bxNnEUvgW8DmXqiuSCBEDzggZaKNugX59Rn4RoVp3R7icLMP6og7Rz9TsCQ6eEebAlJQSJwQTj+1wioRw25hbS+hrBwPE9QeqHsUvdZCtHmo+heWro9i0b0ZMc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721382697; c=relaxed/simple;
	bh=OML8S7YO0nIRZYJ0aGixURY0bk9lAxc0GK7RcbQodYc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lTeVKj2C5YK13LnfM05+Fqr6NEQm7KPoihrMs4RQHcQ35BBm/h5z7T/MAwvI7UVxz74VyvpQnagj3P1ay/M+NHAEpHYI3RoIDNTsQQZaeuOwr1SgiKxbN7Z1zPiQHDLu0b6Ncoeo3RDM0UICCm962+R6UURK6GT32jfDo6PoPhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from [192.168.12.218] (unknown [121.237.44.107])
	by APP-01 (Coremail) with SMTP id qwCowACXeU7aNppm0N1LBA--.722S2;
	Fri, 19 Jul 2024 17:50:20 +0800 (CST)
Message-ID: <a78bb55e-ae7d-47ad-a3fc-f4662f42625f@iscas.ac.cn>
Date: Fri, 19 Jul 2024 17:50:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] riscv: perf: add guest vs host distinction
To: Andrew Jones <ajones@ventanamicro.com>
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-perf-users@vger.kernel.org, anup@brainfault.org,
 atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, mark.rutland@arm.com,
 alexander.shishkin@linux.intel.com, jolsa@kernel.org
References: <cover.1721271251.git.zhouquan@iscas.ac.cn>
 <8e2d2f60fc30d64b6c69b38184a1b640c7b30003.1721271251.git.zhouquan@iscas.ac.cn>
 <20240718-e689be134be5b958b1eec65a@orel>
Content-Language: en-US
From: Quan Zhou <zhouquan@iscas.ac.cn>
In-Reply-To: <20240718-e689be134be5b958b1eec65a@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:qwCowACXeU7aNppm0N1LBA--.722S2
X-Coremail-Antispam: 1UD129KBjvJXoWxArWfZF18ZFWkKw1UKFy3Arb_yoW5Kry8pr
	4DCFnxKFWUXryIg34SqFs8WF1Yqr1rXay29rW2k345Cr9FvF98J3WDKwn8CryrArykXFy0
	yF1qqFsxuws8ta7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkqb7Iv0xC_Zr1lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwV
	C2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7
	MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
	0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0E
	wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JV
	WxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
	cVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8fwIDUUUUU==
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiBgoDBmaZ7vP5RgABsV



On 2024/7/19 00:53, Andrew Jones wrote:
> On Thu, Jul 18, 2024 at 07:23:41PM GMT, zhouquan@iscas.ac.cn wrote:
>> From: Quan Zhou <zhouquan@iscas.ac.cn>
>>
>> Introduce basic guest support in perf, enabling it to distinguish
>> between PMU interrupts in the host or guest, and collect
>> fundamental information.
>>
>> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
>> ---
>>   arch/riscv/include/asm/perf_event.h |  7 ++++++
>>   arch/riscv/kernel/perf_callchain.c  | 38 +++++++++++++++++++++++++++++
>>   2 files changed, 45 insertions(+)
>>
>> diff --git a/arch/riscv/include/asm/perf_event.h b/arch/riscv/include/asm/perf_event.h
>> index 665bbc9b2f84..5866d028aee5 100644
>> --- a/arch/riscv/include/asm/perf_event.h
>> +++ b/arch/riscv/include/asm/perf_event.h
>> @@ -8,13 +8,20 @@
>>   #ifndef _ASM_RISCV_PERF_EVENT_H
>>   #define _ASM_RISCV_PERF_EVENT_H
>>   
>> +#ifdef CONFIG_PERF_EVENTS
>>   #include <linux/perf_event.h>
>>   #define perf_arch_bpf_user_pt_regs(regs) (struct user_regs_struct *)regs
>>   
>> +extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
>> +extern unsigned long perf_misc_flags(struct pt_regs *regs);
>> +#define perf_misc_flags(regs) perf_misc_flags(regs)
>> +
>>   #define perf_arch_fetch_caller_regs(regs, __ip) { \
> 
> Arm has this outside the #ifdef CONFIG_PERF_EVENTS, but it doesn't
> look like it should be.
> 

Yes, Arm makes perf_arch_fetch_caller_regs independent of 
CONFIG_PERF_EVENTS. What is the rationale behind this? I'm
not clear on this point. It's reasonable to have them inside
for riscv, right?

>>   	(regs)->epc = (__ip); \
>>   	(regs)->s0 = (unsigned long) __builtin_frame_address(0); \
>>   	(regs)->sp = current_stack_pointer; \
>>   	(regs)->status = SR_PP; \
>>   }
>> +#endif
>> +
>>   #endif /* _ASM_RISCV_PERF_EVENT_H */
>> diff --git a/arch/riscv/kernel/perf_callchain.c b/arch/riscv/kernel/perf_callchain.c
>> index 3348a61de7d9..c673dc6d9bd2 100644
>> --- a/arch/riscv/kernel/perf_callchain.c
>> +++ b/arch/riscv/kernel/perf_callchain.c
>> @@ -58,6 +58,11 @@ void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
>>   {
>>   	unsigned long fp = 0;
>>   
>> +	if (perf_guest_state()) {
>> +		/* TODO: We don't support guest os callchain now */
>> +		return;
>> +	}
>> +
>>   	fp = regs->s0;
>>   	perf_callchain_store(entry, regs->epc);
>>   
>> @@ -74,5 +79,38 @@ static bool fill_callchain(void *entry, unsigned long pc)
>>   void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
>>   			   struct pt_regs *regs)
>>   {
>> +	if (perf_guest_state()) {
>> +		/* TODO: We don't support guest os callchain now */
>> +		return;
>> +	}
>> +
>>   	walk_stackframe(NULL, regs, fill_callchain, entry);
>>   }
>> +
>> +unsigned long perf_instruction_pointer(struct pt_regs *regs)
>> +{
>> +	if (perf_guest_state())
>> +		return perf_guest_get_ip();
>> +
>> +	return instruction_pointer(regs);
>> +}
>> +
>> +unsigned long perf_misc_flags(struct pt_regs *regs)
>> +{
>> +	unsigned int guest_state = perf_guest_state();
>> +	int misc = 0;
> 
> Should use unsigned long for misc.
> 

Okay, I'll fix it.

Thanks,
Quan

>> +
>> +	if (guest_state) {
>> +		if (guest_state & PERF_GUEST_USER)
>> +			misc |= PERF_RECORD_MISC_GUEST_USER;
>> +		else
>> +			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
>> +	} else {
>> +		if (user_mode(regs))
>> +			misc |= PERF_RECORD_MISC_USER;
>> +		else
>> +			misc |= PERF_RECORD_MISC_KERNEL;
>> +	}
>> +
>> +	return misc;
>> +}
>> -- 
>> 2.34.1
>>
> 
> Thanks,
> drew


