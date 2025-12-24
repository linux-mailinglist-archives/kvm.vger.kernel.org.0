Return-Path: <kvm+bounces-66669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BC3F3CDB93D
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 08:25:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 22D3230245FD
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 07:25:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFA9E32D0F5;
	Wed, 24 Dec 2025 07:25:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B8F013AF2;
	Wed, 24 Dec 2025 07:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766561136; cv=none; b=OaFr+qp9uLcVOS0IYvP8TIO0NyWWVwGJOqV/jaYL0m9TSuT0l4a1NF2OYFnDdk8kecokZn3RXq6xuD4cnkVnMe+4n9HUwYcgAz+XOQngYIPhVnIj2mhiEhaBz7+QoqdUO2cwU91f9udwO0HJEWg73yDa2iXhC1E4h+GA5wU2ae4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766561136; c=relaxed/simple;
	bh=roKfmp8VG3VFIQt7JH87tUWwRj4pEI0VEaEpfSdkD4M=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=VKrA3Sei+GQ5k74jmaUHbVzN5OkX2egs14v0U8JpWNJLbp7gtt2+mk+caND6ma1ebGKmQyLjbSW1+MgVXxmDIADZ403sfFoxuaM2nZ/1/eO3OClGQBFQUn/duvc7XsfTo3ZHT0l0s9el6VinpEuO1XmvMPeq/Wz+qwGmrWdOpoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.239])
	by gateway (Coremail) with SMTP id _____8CxrsNilUtpSbACAA--.9200S3;
	Wed, 24 Dec 2025 15:25:22 +0800 (CST)
Received: from [10.20.42.239] (unknown [10.20.42.239])
	by front1 (Coremail) with SMTP id qMiowJDxysFflUtpBC0EAA--.9984S3;
	Wed, 24 Dec 2025 15:25:22 +0800 (CST)
Subject: Re: [PATCH v4 2/3] LongArch: KVM: Add irqfd set dmsintc msg irq
To: Huacai Chen <chenhuacai@kernel.org>
Cc: maobibo@loongson.cn, kvm@vger.kernel.org, loongarch@lists.linux.dev,
 kernel@xen0n.name, linux-kernel@vger.kernel.org
References: <20251218111822.975455-1-gaosong@loongson.cn>
 <20251218111822.975455-3-gaosong@loongson.cn>
 <CAAhV-H4oZJ-t2_sWQ+nkimv6htrBw5-rgG+Omuy2z2chWzK_MA@mail.gmail.com>
From: gaosong <gaosong@loongson.cn>
Message-ID: <4c34fb99-d8d6-826c-3f41-831f2587039b@loongson.cn>
Date: Wed, 24 Dec 2025 15:25:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H4oZJ-t2_sWQ+nkimv6htrBw5-rgG+Omuy2z2chWzK_MA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID:qMiowJDxysFflUtpBC0EAA--.9984S3
X-CM-SenderInfo: 5jdr20tqj6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3GFyrZr4rKrWxtFWkKrykWFX_yoW7Wr4xpF
	ZxAan8ur4rJr17XrZ2g390vr13ArsYgr12grW29asakFnIvr1kJr18Jr9rCFyYga18GF4I
	q3ZxK3W5Za1Ut3cCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv
	67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw
	1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8cz
	VUUUUUU==

Hi,

在 2025/12/19 下午8:55, Huacai Chen 写道:
> Hi, Song,
>
> On Thu, Dec 18, 2025 at 7:43 PM Song Gao <gaosong@loongson.cn> wrote:
>> Add irqfd choice dmsintc to set msi irq by the msg_addr and
>> implement dmsintc set msi irq.
>>
>> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
>> Signed-off-by: Song Gao <gaosong@loongson.cn>
>> ---
>>   arch/loongarch/include/asm/kvm_dmsintc.h |  1 +
>>   arch/loongarch/kvm/intc/dmsintc.c        |  6 ++++
>>   arch/loongarch/kvm/irqfd.c               | 45 ++++++++++++++++++++----
>>   3 files changed, 45 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/loongarch/include/asm/kvm_dmsintc.h b/arch/loongarch/include/asm/kvm_dmsintc.h
>> index 1d4f66996f3c..9b5436a2fcbe 100644
>> --- a/arch/loongarch/include/asm/kvm_dmsintc.h
>> +++ b/arch/loongarch/include/asm/kvm_dmsintc.h
>> @@ -11,6 +11,7 @@ struct loongarch_dmsintc  {
>>          struct kvm *kvm;
>>          uint64_t msg_addr_base;
>>          uint64_t msg_addr_size;
>> +       uint32_t cpu_mask;
>>   };
>>
>>   struct dmsintc_state {
>> diff --git a/arch/loongarch/kvm/intc/dmsintc.c b/arch/loongarch/kvm/intc/dmsintc.c
>> index 3fdea81a08c8..9ecb2e3e352d 100644
>> --- a/arch/loongarch/kvm/intc/dmsintc.c
>> +++ b/arch/loongarch/kvm/intc/dmsintc.c
>> @@ -15,6 +15,7 @@ static int kvm_dmsintc_ctrl_access(struct kvm_device *dev,
>>          void __user *data;
>>          struct loongarch_dmsintc *s = dev->kvm->arch.dmsintc;
>>          u64 tmp;
>> +       u32 cpu_bit;
>>
>>          data = (void __user *)attr->addr;
>>          switch (addr) {
>> @@ -30,6 +31,11 @@ static int kvm_dmsintc_ctrl_access(struct kvm_device *dev,
>>                                  s->msg_addr_base = tmp;
>>                          else
>>                                  return  -EFAULT;
>> +                       s->msg_addr_base = tmp;
>> +                       cpu_bit = find_first_bit((unsigned long *)&(s->msg_addr_base), 64)
>> +                                               - AVEC_CPU_SHIFT;
>> +                       cpu_bit = min(cpu_bit, AVEC_CPU_BIT);
>> +                       s->cpu_mask = GENMASK(cpu_bit - 1, 0) & AVEC_CPU_MASK;
>>                  }
>>                  break;
>>          case KVM_DEV_LOONGARCH_DMSINTC_MSG_ADDR_SIZE:
>> diff --git a/arch/loongarch/kvm/irqfd.c b/arch/loongarch/kvm/irqfd.c
>> index 9a39627aecf0..11f980474552 100644
>> --- a/arch/loongarch/kvm/irqfd.c
>> +++ b/arch/loongarch/kvm/irqfd.c
>> @@ -6,6 +6,7 @@
>>   #include <linux/kvm_host.h>
>>   #include <trace/events/kvm.h>
>>   #include <asm/kvm_pch_pic.h>
>> +#include <asm/kvm_vcpu.h>
>>
>>   static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
>>                  struct kvm *kvm, int irq_source_id, int level, bool line_status)
>> @@ -16,6 +17,41 @@ static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
>>          return 0;
>>   }
>>
>> +static int kvm_dmsintc_set_msi_irq(struct kvm *kvm, u32 addr, int data, int level)
>> +{
>> +       unsigned int virq, dest;
>> +       struct kvm_vcpu *vcpu;
>> +
>> +       virq = (addr >> AVEC_IRQ_SHIFT) & AVEC_IRQ_MASK;
>> +       dest = (addr >> AVEC_CPU_SHIFT) & kvm->arch.dmsintc->cpu_mask;
>> +       if (dest > KVM_MAX_VCPUS)
>> +               return -EINVAL;
>> +       vcpu = kvm_get_vcpu_by_cpuid(kvm, dest);
>> +       if (!vcpu)
>> +               return -EINVAL;
>> +       return kvm_loongarch_deliver_msi_to_vcpu(kvm, vcpu, virq, level);
> kvm_loongarch_deliver_msi_to_vcpu() is used in this patch but defined
> in the last patch, this is not acceptable, you can consider to combine
> these two, and I don't know whether vcpu.c is the best place for it.
how about just change patch3 before patch 2?  and  deined them in 
kvm/interrupt.c ?
>> +}
>> +
>> +static int loongarch_set_msi(struct kvm_kernel_irq_routing_entry *e,
>> +                       struct kvm *kvm, int level)
>> +{
>> +       u64 msg_addr;
>> +
>> +       if (!level)
>> +               return -1;
> Before this patch, this check is in the caller, with this patch it is
> in the callee, is this suitable? This will add a check in
> kvm_arch_set_irq_inatomic().
if check in the caller, like kvm_set_msi,  we also need a check in
kvm_arch_set_irq_inatomic(), like arm64 or riscv.

I will correct it on v5.

Thanks
Song Gao

> Huacai
>
>> +
>> +       msg_addr = (((u64)e->msi.address_hi) << 32) | e->msi.address_lo;
>> +       if (cpu_has_msgint && kvm->arch.dmsintc &&
>> +               msg_addr >= kvm->arch.dmsintc->msg_addr_base &&
>> +               msg_addr < (kvm->arch.dmsintc->msg_addr_base  + kvm->arch.dmsintc->msg_addr_size)) {
>> +               return kvm_dmsintc_set_msi_irq(kvm, msg_addr, e->msi.data, level);
>> +       } else {
>> +               pch_msi_set_irq(kvm, e->msi.data, level);
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>>   /*
>>    * kvm_set_msi: inject the MSI corresponding to the
>>    * MSI routing entry
>> @@ -26,12 +62,7 @@ static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
>>   int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
>>                  struct kvm *kvm, int irq_source_id, int level, bool line_status)
>>   {
>> -       if (!level)
>> -               return -1;
>> -
>> -       pch_msi_set_irq(kvm, e->msi.data, level);
>> -
>> -       return 0;
>> +       return loongarch_set_msi(e, kvm, level);
>>   }
>>
>>   /*
>> @@ -76,7 +107,7 @@ int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
>>                  pch_pic_set_irq(kvm->arch.pch_pic, e->irqchip.pin, level);
>>                  return 0;
>>          case KVM_IRQ_ROUTING_MSI:
>> -               pch_msi_set_irq(kvm, e->msi.data, level);
>> +               loongarch_set_msi(e, kvm, level);
>>                  return 0;
>>          default:
>>                  return -EWOULDBLOCK;
>> --
>> 2.39.3
>>
>>


