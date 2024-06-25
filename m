Return-Path: <kvm+bounces-20444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98BE7915C5B
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 04:41:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D0C06B20CEE
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 02:41:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7584A481A5;
	Tue, 25 Jun 2024 02:40:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BF3C47F46;
	Tue, 25 Jun 2024 02:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719283248; cv=none; b=suDJbvnST0aB81/Cw9SRl4mRyuEY1plGd/+oYbljQLgpdHIh/Pwobm2hHhkSJG35VJ92AkrtLHP4+5phcWrWCLFFKWhspjtHUZ5RB8hfdTbtwJ9CBF+S9OC42LiKGq6L0wzAEv3ksW+uFO7eZuzw9HTaoQSgmH2ih2Cow87Z8Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719283248; c=relaxed/simple;
	bh=MVkyFKBJnQIM0vN25Mcd2/iRn9O2QrFlTBH70BgooXk=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=K+5UWi8oydW/dj1Qz+/66dOtvFAqJ/nVKFkvnF6ZaWr6cuJDefU9ea+48GiKdp9PRqFbwc9ulJ83mUKeZfSjvFuP+g+DI90YBA5KORKnx7p6KmBUiH3vXXWKWVFfqYWAMj4BA8mPwQ65VxVbqhbIAfn0xDmyjpcW/CMvKivyaOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxUPAkLnpmmboJAA--.39308S3;
	Tue, 25 Jun 2024 10:40:36 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Axw8QhLnpmJvcvAA--.37881S3;
	Tue, 25 Jun 2024 10:40:35 +0800 (CST)
Subject: Re: [PATCH v3 4/4] LoongArch: KVM: Add VM LBT feature detection
 support
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240527074644.836699-1-maobibo@loongson.cn>
 <20240527074644.836699-5-maobibo@loongson.cn>
 <CAAhV-H7wdMH=fdGhtxcJ9zY+H-PKT2q0rgrsEPm+LhBgCqNsjQ@mail.gmail.com>
 <1e56fc1a-351e-9d66-3954-9fe1642139a3@loongson.cn>
 <CAAhV-H4xVy7wnj3N=RxA8e_Ah-mVc2SQH3Axz+F_DNo9sM8KHA@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <e553bbb7-9533-0a09-25b5-23a430817f26@loongson.cn>
Date: Tue, 25 Jun 2024 10:40:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H4xVy7wnj3N=RxA8e_Ah-mVc2SQH3Axz+F_DNo9sM8KHA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Axw8QhLnpmJvcvAA--.37881S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxuFWfJr1UKF48Cw13Jw4xGrX_yoW7Xw48pr
	W8AF4DCFW5Gr1Ikw1vqwn0grnIqr4xGr4xWFy7Jay7AFn0kF1xGry0krZ8uFyrJw4rWa4I
	9F1vyay3uF1Yy3cCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE
	14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
	AE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU70Pf
	DUUUU



On 2024/6/24 下午10:02, Huacai Chen wrote:
> On Mon, Jun 24, 2024 at 10:00 AM maobibo <maobibo@loongson.cn> wrote:
>>
>>
>>
>> On 2024/6/23 下午6:14, Huacai Chen wrote:
>>> Hi, Bibo,
>>>
>>> On Mon, May 27, 2024 at 3:46 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>>>
>>>> Before virt machine or vcpu is created, vmm need check supported
>>>> features from KVM. Here ioctl command KVM_HAS_DEVICE_ATTR is added
>>>> for VM, and macro KVM_LOONGARCH_VM_FEAT_CTRL is added to check
>>>> supported feature.
>>>>
>>>> Three sub-features relative with LBT are added, in later any new
>>>> feature can be added if it is used for vmm. The sub-features is
>>>>    KVM_LOONGARCH_VM_FEAT_X86BT
>>>>    KVM_LOONGARCH_VM_FEAT_ARMBT
>>>>    KVM_LOONGARCH_VM_FEAT_MIPSBT
>>>>
>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>>> ---
>>>>    arch/loongarch/include/uapi/asm/kvm.h |  6 ++++
>>>>    arch/loongarch/kvm/vm.c               | 44 ++++++++++++++++++++++++++-
>>>>    2 files changed, 49 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
>>>> index 656aa6a723a6..ed12e509815c 100644
>>>> --- a/arch/loongarch/include/uapi/asm/kvm.h
>>>> +++ b/arch/loongarch/include/uapi/asm/kvm.h
>>>> @@ -91,6 +91,12 @@ struct kvm_fpu {
>>>>    #define KVM_IOC_CSRID(REG)             LOONGARCH_REG_64(KVM_REG_LOONGARCH_CSR, REG)
>>>>    #define KVM_IOC_CPUCFG(REG)            LOONGARCH_REG_64(KVM_REG_LOONGARCH_CPUCFG, REG)
>>>>
>>>> +/* Device Control API on vm fd */
>>>> +#define KVM_LOONGARCH_VM_FEAT_CTRL     0
>>>> +#define  KVM_LOONGARCH_VM_FEAT_X86BT   0
>>>> +#define  KVM_LOONGARCH_VM_FEAT_ARMBT   1
>>>> +#define  KVM_LOONGARCH_VM_FEAT_MIPSBT  2
>>> I think LBT should be vcpu features rather than vm features, which is
>>> the same like CPUCFG and FP/SIMD.
>> yes, LBT is part of vcpu feature. Only when VMM check validity about
>> LBT, it is too late if it is vcpu feature. It is only checkable after
>> vcpu is created also, that is too late for qemu VMM.
> But why do we need so early to detect LBT? Why can the CPUCFG attr be
> implemented in vcpu.c?
To be frankly, I do not know neither.

By my understanding, cpu feature validity checking should be called 
once, so it is put at cpu instance_init() at beginning. Else if the 
checking is put in function kvm_arch_put_registers(), which is called by 
many places if its state is changed, such as vcpu pause/resume, 
migration, creation etc, it is unnecessary.

So LBT feature is part of VM, it is used for feature validity checking 
when starting VM. Also it is part of vcpu, it can be used for 
compatibility or post-migration feature checking. So the CPUCFG attr is 
implemented in vcpu.c

To now, my ability and energy is to following framework and do 
architecture specific; if you have any suggestion with qemu, you can 
submit patches to create new things.

Regards
Bibo Mao
> 
> Huacai
> 
>>
>> However if it is VM feature, this feature can be checked even if VM or
>> VCPU is not created.
>>
>> So here is LBt is treated as VM capability also, You can check function
>> kvm_vm_ioctl_check_extension() on other architectures,
>> KVM_CAP_GUEST_DEBUG_HW_BPS/KVM_CAP_ARM_PMU_V3 are also VM features.
>>
>>>
>>> Moreover, this patch can be merged to the 2nd one.
>> Sure, I will merge it with 2nd patch.
>>
>> Regards
>> Bibo Mao
>>
>>>
>>> Huacai
>>>
>>>> +
>>>>    /* Device Control API on vcpu fd */
>>>>    #define KVM_LOONGARCH_VCPU_CPUCFG      0
>>>>    #define KVM_LOONGARCH_VCPU_PVTIME_CTRL 1
>>>> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
>>>> index 6b2e4f66ad26..09e05108c68b 100644
>>>> --- a/arch/loongarch/kvm/vm.c
>>>> +++ b/arch/loongarch/kvm/vm.c
>>>> @@ -99,7 +99,49 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>>>           return r;
>>>>    }
>>>>
>>>> +static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>>>> +{
>>>> +       switch (attr->attr) {
>>>> +       case KVM_LOONGARCH_VM_FEAT_X86BT:
>>>> +               if (cpu_has_lbt_x86)
>>>> +                       return 0;
>>>> +               return -ENXIO;
>>>> +       case KVM_LOONGARCH_VM_FEAT_ARMBT:
>>>> +               if (cpu_has_lbt_arm)
>>>> +                       return 0;
>>>> +               return -ENXIO;
>>>> +       case KVM_LOONGARCH_VM_FEAT_MIPSBT:
>>>> +               if (cpu_has_lbt_mips)
>>>> +                       return 0;
>>>> +               return -ENXIO;
>>>> +       default:
>>>> +               return -ENXIO;
>>>> +       }
>>>> +}
>>>> +
>>>> +static int kvm_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>>>> +{
>>>> +       switch (attr->group) {
>>>> +       case KVM_LOONGARCH_VM_FEAT_CTRL:
>>>> +               return kvm_vm_feature_has_attr(kvm, attr);
>>>> +       default:
>>>> +               return -ENXIO;
>>>> +       }
>>>> +}
>>>> +
>>>>    int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>>>>    {
>>>> -       return -ENOIOCTLCMD;
>>>> +       struct kvm *kvm = filp->private_data;
>>>> +       void __user *argp = (void __user *)arg;
>>>> +       struct kvm_device_attr attr;
>>>> +
>>>> +       switch (ioctl) {
>>>> +       case KVM_HAS_DEVICE_ATTR:
>>>> +               if (copy_from_user(&attr, argp, sizeof(attr)))
>>>> +                       return -EFAULT;
>>>> +
>>>> +               return kvm_vm_has_attr(kvm, &attr);
>>>> +       default:
>>>> +               return -EINVAL;
>>>> +       }
>>>>    }
>>>> --
>>>> 2.39.3
>>>>
>>


