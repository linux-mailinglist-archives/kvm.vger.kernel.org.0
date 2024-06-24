Return-Path: <kvm+bounces-20353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF136914048
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 04:00:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9297328262A
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 02:00:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44CE94C7D;
	Mon, 24 Jun 2024 02:00:51 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED5793C28;
	Mon, 24 Jun 2024 02:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719194450; cv=none; b=cIjcW8LSHESO75i5rmyd8H7ThFUYi1DSiF5dK0S3aLgg1MmwttZRCyq7Uz4AtNTRHwXiZl8oTCU7T719MT23nFeaxs9D6z3xGosZcO8wlTEITV18c8bqKgqDTLK8qRbpm1APh30+VaWt5ImZ3EUkgawnE2VQXQBFz210VVaRE7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719194450; c=relaxed/simple;
	bh=WNTOL2deU4sjAQ6Sy+NpnRiyC1RKvVIi8+SbkbHKB/0=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=diXaj7gLn8C/sCfVF5ua0Jyn69rxtL27srp74waX5HZ3YLjnSJ9M3VbU3WAEkAVQ3+fIERImmw7JpQpQ2mMTApatKWmrIC1bjYsQ/PHYKPBgQzpe3n4fyxvD29sL6gPy6M9GEta1NlnIZ9NqhSsutaP3lDYfnaq7H/tSxmzbQa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8DxP_BO03hmymQJAA--.37988S3;
	Mon, 24 Jun 2024 10:00:46 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxacZL03hmvY0uAA--.45232S3;
	Mon, 24 Jun 2024 10:00:45 +0800 (CST)
Subject: Re: [PATCH v3 4/4] LoongArch: KVM: Add VM LBT feature detection
 support
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240527074644.836699-1-maobibo@loongson.cn>
 <20240527074644.836699-5-maobibo@loongson.cn>
 <CAAhV-H7wdMH=fdGhtxcJ9zY+H-PKT2q0rgrsEPm+LhBgCqNsjQ@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <1e56fc1a-351e-9d66-3954-9fe1642139a3@loongson.cn>
Date: Mon, 24 Jun 2024 10:00:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H7wdMH=fdGhtxcJ9zY+H-PKT2q0rgrsEPm+LhBgCqNsjQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxacZL03hmvY0uAA--.45232S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxXr4DZF15Kr4kAF4UWr4xXwc_yoWrXr4kpr
	yjyFs8GFWrGr1xC3Z5tws09r43ZF4xCr4xuFy7tFW3ArnI9ryxGryvkrZxCFy5X3yrWa4I
	9F1vyF47uF12y3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI0UMc
	02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAF
	wI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4
	CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JV
	WxJwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU7tx6
	UUUUU



On 2024/6/23 下午6:14, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Mon, May 27, 2024 at 3:46 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> Before virt machine or vcpu is created, vmm need check supported
>> features from KVM. Here ioctl command KVM_HAS_DEVICE_ATTR is added
>> for VM, and macro KVM_LOONGARCH_VM_FEAT_CTRL is added to check
>> supported feature.
>>
>> Three sub-features relative with LBT are added, in later any new
>> feature can be added if it is used for vmm. The sub-features is
>>   KVM_LOONGARCH_VM_FEAT_X86BT
>>   KVM_LOONGARCH_VM_FEAT_ARMBT
>>   KVM_LOONGARCH_VM_FEAT_MIPSBT
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/include/uapi/asm/kvm.h |  6 ++++
>>   arch/loongarch/kvm/vm.c               | 44 ++++++++++++++++++++++++++-
>>   2 files changed, 49 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
>> index 656aa6a723a6..ed12e509815c 100644
>> --- a/arch/loongarch/include/uapi/asm/kvm.h
>> +++ b/arch/loongarch/include/uapi/asm/kvm.h
>> @@ -91,6 +91,12 @@ struct kvm_fpu {
>>   #define KVM_IOC_CSRID(REG)             LOONGARCH_REG_64(KVM_REG_LOONGARCH_CSR, REG)
>>   #define KVM_IOC_CPUCFG(REG)            LOONGARCH_REG_64(KVM_REG_LOONGARCH_CPUCFG, REG)
>>
>> +/* Device Control API on vm fd */
>> +#define KVM_LOONGARCH_VM_FEAT_CTRL     0
>> +#define  KVM_LOONGARCH_VM_FEAT_X86BT   0
>> +#define  KVM_LOONGARCH_VM_FEAT_ARMBT   1
>> +#define  KVM_LOONGARCH_VM_FEAT_MIPSBT  2
> I think LBT should be vcpu features rather than vm features, which is
> the same like CPUCFG and FP/SIMD.
yes, LBT is part of vcpu feature. Only when VMM check validity about 
LBT, it is too late if it is vcpu feature. It is only checkable after 
vcpu is created also, that is too late for qemu VMM.

However if it is VM feature, this feature can be checked even if VM or 
VCPU is not created.

So here is LBt is treated as VM capability also, You can check function
kvm_vm_ioctl_check_extension() on other architectures, 
KVM_CAP_GUEST_DEBUG_HW_BPS/KVM_CAP_ARM_PMU_V3 are also VM features.

> 
> Moreover, this patch can be merged to the 2nd one.
Sure, I will merge it with 2nd patch.

Regards
Bibo Mao

> 
> Huacai
> 
>> +
>>   /* Device Control API on vcpu fd */
>>   #define KVM_LOONGARCH_VCPU_CPUCFG      0
>>   #define KVM_LOONGARCH_VCPU_PVTIME_CTRL 1
>> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
>> index 6b2e4f66ad26..09e05108c68b 100644
>> --- a/arch/loongarch/kvm/vm.c
>> +++ b/arch/loongarch/kvm/vm.c
>> @@ -99,7 +99,49 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>          return r;
>>   }
>>
>> +static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>> +{
>> +       switch (attr->attr) {
>> +       case KVM_LOONGARCH_VM_FEAT_X86BT:
>> +               if (cpu_has_lbt_x86)
>> +                       return 0;
>> +               return -ENXIO;
>> +       case KVM_LOONGARCH_VM_FEAT_ARMBT:
>> +               if (cpu_has_lbt_arm)
>> +                       return 0;
>> +               return -ENXIO;
>> +       case KVM_LOONGARCH_VM_FEAT_MIPSBT:
>> +               if (cpu_has_lbt_mips)
>> +                       return 0;
>> +               return -ENXIO;
>> +       default:
>> +               return -ENXIO;
>> +       }
>> +}
>> +
>> +static int kvm_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>> +{
>> +       switch (attr->group) {
>> +       case KVM_LOONGARCH_VM_FEAT_CTRL:
>> +               return kvm_vm_feature_has_attr(kvm, attr);
>> +       default:
>> +               return -ENXIO;
>> +       }
>> +}
>> +
>>   int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>>   {
>> -       return -ENOIOCTLCMD;
>> +       struct kvm *kvm = filp->private_data;
>> +       void __user *argp = (void __user *)arg;
>> +       struct kvm_device_attr attr;
>> +
>> +       switch (ioctl) {
>> +       case KVM_HAS_DEVICE_ATTR:
>> +               if (copy_from_user(&attr, argp, sizeof(attr)))
>> +                       return -EFAULT;
>> +
>> +               return kvm_vm_has_attr(kvm, &attr);
>> +       default:
>> +               return -EINVAL;
>> +       }
>>   }
>> --
>> 2.39.3
>>


