Return-Path: <kvm+bounces-19049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A49598FFC43
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 08:32:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13831283DD8
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 06:32:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58D7D15278C;
	Fri,  7 Jun 2024 06:31:57 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 377A711CBD;
	Fri,  7 Jun 2024 06:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717741916; cv=none; b=kYuBCHP+zsxKUZvDEh8y1mKsOste9lt7GfeE2D/T9AOMatx1kpsPxoQM4/0OK+mwKuMQAAoIWCT3o7wh5GEERwYAzHJm9EBWQKggER/B182iEVKSP/ZwtMPtyDFUMhrBl+lPWP6aQufOd7/BiV3qjI4v9BOipvU2EymbmWwtlvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717741916; c=relaxed/simple;
	bh=QDHzOLTAdeWI3TAuBU5P2DHGh7lul8I2Bjthzgv3HLc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=FukuaZdfLxzgoAI17coAgPj0futYv2wjH704FZb/N5SkAIfq0zZ4XRZNzyNL5HEshZ9t+xvev4naCS7fDiwOhAUqGueHrb+NtuHzYronyqV+zhQvxALUzQRwWjrkIx5cVWXZx7kqmmRXif4ETNY+ul3v1L7zCFQ1atYZ4Rxr02k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxHutRqWJmKYcEAA--.19029S3;
	Fri, 07 Jun 2024 14:31:45 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxVcVOqWJmV94XAA--.48551S3;
	Fri, 07 Jun 2024 14:31:44 +0800 (CST)
Subject: Re: [PATCH] LoongArch: KVM: Add feature passing from user space
To: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240606074850.2651896-1-maobibo@loongson.cn>
 <9bb552c8-fe86-43dc-9c4e-0b95c99fb25c@xen0n.name>
 <2774b010-8033-2167-474a-cb1b29b27d2b@loongson.cn>
 <ca286a23-f22b-092c-20d0-6ab20fd0883f@loongson.cn>
 <CAAhV-H4R7GO33jggAHsq0A6qLejdhnht5eBLs3OSasCkcYwJmQ@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <fb5a5fb6-5c40-7d18-bb8d-2da3747480ff@loongson.cn>
Date: Fri, 7 Jun 2024 14:31:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H4R7GO33jggAHsq0A6qLejdhnht5eBLs3OSasCkcYwJmQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8BxVcVOqWJmV94XAA--.48551S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3Ww47Jry3Jw1kCw45GF47ZFc_yoW7tw4Dpr
	yjyFs8GF4UJryxCw1vq3s8Wrnxtr4xGr1IgF17t3yUAFn09F17Jr18KFyDCF95Jw18X3WI
	qF15ta43ZFyYv3cCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE
	14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
	AE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU25Ef
	UUUUU



On 2024/6/7 上午11:58, Huacai Chen wrote:
> Hi, Bibo,
> 
> 
> On Thu, Jun 6, 2024 at 8:05 PM maobibo <maobibo@loongson.cn> wrote:
>>
>>
>>
>> On 2024/6/6 下午7:54, maobibo wrote:
>>> Xuerui,
>>>
>>> Thanks for your reviewing.
>>> I reply inline.
>>>
>>> On 2024/6/6 下午7:20, WANG Xuerui wrote:
>>>> Hi,
>>>>
>>>> On 6/6/24 15:48, Bibo Mao wrote:
>>>>> Currently features defined in cpucfg CPUCFG_KVM_FEATURE comes from
>>>>> kvm kernel mode only. Some features are defined in user space VMM,
>>>>
>>>> "come from kernel side only. But currently KVM is not aware of
>>>> user-space VMM features which makes it hard to employ optimizations
>>>> that are both (1) specific to the VM use case and (2) requiring
>>>> cooperation from user space."
>>> Will modify in next version.
>>>>
>>>>> however KVM module does not know. Here interface is added to update
>>>>> register CPUCFG_KVM_FEATURE from user space, only bit 24 - 31 is valid.
>>>>>
>>>>> Feature KVM_LOONGARCH_VCPU_FEAT_VIRT_EXTIOI is added from user mdoe.
>>>>> FEAT_VIRT_EXTIOI is virt EXTIOI extension which can route interrupt
>>>>> to 256 VCPUs rather than 4 CPUs like real hw.
>>>>
>>>> "A new feature bit ... is added which can be set from user space.
>>>> FEAT_... indicates that the VM EXTIOI can route interrupts to 256
>>>> vCPUs, rather than 4 like with real HW."
>>> will modify in next version.
>>>
>>>>
>>>> (Am I right in paraphrasing the "EXTIOI" part?)
>>>>
>>>>>
>>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>>>> ---
>>>>>    arch/loongarch/include/asm/kvm_host.h  |  4 +++
>>>>>    arch/loongarch/include/asm/loongarch.h |  5 ++++
>>>>>    arch/loongarch/include/uapi/asm/kvm.h  |  2 ++
>>>>>    arch/loongarch/kvm/exit.c              |  1 +
>>>>>    arch/loongarch/kvm/vcpu.c              | 36 +++++++++++++++++++++++---
>>>>>    5 files changed, 44 insertions(+), 4 deletions(-)
>>>>>
>>>>> diff --git a/arch/loongarch/include/asm/kvm_host.h
>>>>> b/arch/loongarch/include/asm/kvm_host.h
>>>>> index 88023ab59486..8fa50d757247 100644
>>>>> --- a/arch/loongarch/include/asm/kvm_host.h
>>>>> +++ b/arch/loongarch/include/asm/kvm_host.h
>>>>> @@ -135,6 +135,9 @@ enum emulation_result {
>>>>>    #define KVM_LARCH_HWCSR_USABLE    (0x1 << 4)
>>>>>    #define KVM_LARCH_LBT        (0x1 << 5)
>>>>> +#define KVM_LOONGARCH_USR_FEAT_MASK            \
>>>>> +    BIT(KVM_LOONGARCH_VCPU_FEAT_VIRT_EXTIOI)
>>>>> +
>>>>>    struct kvm_vcpu_arch {
>>>>>        /*
>>>>>         * Switch pointer-to-function type to unsigned long
>>>>> @@ -210,6 +213,7 @@ struct kvm_vcpu_arch {
>>>>>            u64 last_steal;
>>>>>            struct gfn_to_hva_cache cache;
>>>>>        } st;
>>>>> +    unsigned int usr_features;
>>>>>    };
>>>>>    static inline unsigned long readl_sw_gcsr(struct loongarch_csrs
>>>>> *csr, int reg)
>>>>> diff --git a/arch/loongarch/include/asm/loongarch.h
>>>>> b/arch/loongarch/include/asm/loongarch.h
>>>>> index 7a4633ef284b..4d9837512c19 100644
>>>>> --- a/arch/loongarch/include/asm/loongarch.h
>>>>> +++ b/arch/loongarch/include/asm/loongarch.h
>>>>> @@ -167,9 +167,14 @@
>>>>>    #define CPUCFG_KVM_SIG            (CPUCFG_KVM_BASE + 0)
>>>>>    #define  KVM_SIGNATURE            "KVM\0"
>>>>> +/*
>>>>> + * BIT 24 - 31 is features configurable by user space vmm
>>>>> + */
>>>>>    #define CPUCFG_KVM_FEATURE        (CPUCFG_KVM_BASE + 4)
>>>>>    #define  KVM_FEATURE_IPI        BIT(1)
>>>>>    #define  KVM_FEATURE_STEAL_TIME        BIT(2)
>>>>> +/* With VIRT_EXTIOI feature, interrupt can route to 256 VCPUs */
>>>>> +#define  KVM_FEATURE_VIRT_EXTIOI    BIT(24)
>>>>>    #ifndef __ASSEMBLY__
>>>>
>>>> What about assigning a new CPUCFG leaf ID for separating the two kinds
>>>> of feature flags very cleanly?
>>> For compatible issue like new kernel on old KVM host, to add a new
>>> CPUCFG leaf ID, a new feature need be defined on existing
>>> CPUCFG_KVM_FEATURE register. Such as:
>>>      #define  KVM_FEATURE_EXTEND_CPUCFG        BIT(3)
>>>
>>> VM need check feature KVM_FEATURE_EXTEND_CPUCFG at first, and then read
>>> the new CPUCFG leaf ID if feature EXTEND_CPUCFG is enabled.
>>>
>>> That maybe makes it complicated since feature bit is enough now.
>> The default return value is zero with old kvm host, it is possible to
>> use a new CPUCFG leaf ID. Both methods are ok for me.
>>
>> Huacai,
>> What is your optnion about this?
> I don't think we need a new leaf, but is this feature detection
> duplicated with EXTIOI_VIRT_FEATURES here?
> https://lore.kernel.org/lkml/871q5a2lo8.ffs@tglx/T/#t
It is for compatible consideration. The result is unknown on old 
hypervisor if new kernel accesses newly added IOCSR register 
EXTIOI_VIRT_FEATURES.

For cpucfg instruction it is returns zero if it is not supported, 
however there is no such spec for iocsr read or write instruction.

Regards
Bibo
> 
> Huacai
> 
>>
>> Regards
>> Bibo Mao
>>>>
>>>>> @@ -896,7 +907,24 @@ static int kvm_loongarch_vcpu_get_attr(struct
>>>>> kvm_vcpu *vcpu,
>>>>>    static int kvm_loongarch_cpucfg_set_attr(struct kvm_vcpu *vcpu,
>>>>>                         struct kvm_device_attr *attr)
>>>>>    {
>>>>> -    return -ENXIO;
>>>>> +    u64 __user *user = (u64 __user *)attr->addr;
>>>>> +    u64 val, valid_flags;
>>>>> +
>>>>> +    switch (attr->attr) {
>>>>> +    case CPUCFG_KVM_FEATURE:
>>>>> +        if (get_user(val, user))
>>>>> +            return -EFAULT;
>>>>> +
>>>>> +        valid_flags = KVM_LOONGARCH_USR_FEAT_MASK;
>>>>> +        if (val & ~valid_flags)
>>>>> +            return -EINVAL;
>>>>> +
>>>>> +        vcpu->arch.usr_features |= val;
>>>>
>>>> Isn't this usage of "|=" instead of "=" implying that the feature bits
>>>> could not get disabled after being enabled earlier, for whatever reason?
>>> yes, "=" is better. Will modify in next version.
>>>
>>> Regards
>>> Bibo Mao
>>>>
>>>>> +        return 0;
>>>>> +
>>>>> +    default:
>>>>> +        return -ENXIO;
>>>>> +    }
>>>>>    }
>>>>>    static int kvm_loongarch_vcpu_set_attr(struct kvm_vcpu *vcpu,
>>>>>
>>>>> base-commit: 2df0193e62cf887f373995fb8a91068562784adc
>>>>
>>>
>>
>>


