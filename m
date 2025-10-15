Return-Path: <kvm+bounces-60067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 053C2BDD611
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 10:26:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1CF2B19A2F3D
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 08:26:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E87C12F549C;
	Wed, 15 Oct 2025 08:25:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71C9C2C3251;
	Wed, 15 Oct 2025 08:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760516753; cv=none; b=cgt25BrAXWaOWxhGoWfDfcWspqdt2faTfdhZSxjIaaXhtEpL8DKVrIX/uVnGlhWZ86pCem92vFrhHCvO5BhOACkjc3UFHU3nBN1p/sOBXAPy/fqo7cIabTx3isOUp+dR2ZAA9vBxYan3kUK/GujFAiBTtQoN+94Pr4syp/ZDo9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760516753; c=relaxed/simple;
	bh=OV98e7sU33CKo669HFo0ka/WOogyx2gNF1nWJJAE8qc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Mpky9HFu5tNCitvO5CJFDk3iXPhAVdKzO5PBC+9pHcHzEyVHf6beHpjJgKDlRmR6ln+3swaoWa/Zm9oRfyAUireI1Nj8+eu61f4Gq47GNK5pBY1uQISG4MTqkvyrp6bjHECODntw/e3MAlo8cNBtt73ExA677q2v5ziqir7OQ1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Axjr+FWu9orFcWAA--.46240S3;
	Wed, 15 Oct 2025 16:25:41 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJCx2sCBWu9o2DLlAA--.24557S3;
	Wed, 15 Oct 2025 16:25:40 +0800 (CST)
Subject: Re: [PATCH v3] LoongArch: KVM: Add AVEC support
To: Song Gao <gaosong@loongson.cn>, chenhuacai@kernel.org
Cc: kvm@vger.kernel.org, loongarch@lists.linux.dev, kernel@xen0n.name,
 linux-kernel@vger.kernel.org
References: <20251015060626.3915824-1-gaosong@loongson.cn>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <28fff8cb-d436-78c7-1836-2fc0f71f806b@loongson.cn>
Date: Wed, 15 Oct 2025 16:23:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251015060626.3915824-1-gaosong@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCx2sCBWu9o2DLlAA--.24557S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3Jw1xJr18Xr43trWxtw45XFc_yoWxAFyUpF
	yDAF4DWFWrKr1xK3W5t3ZI9r13Xrs7K34agry2krW3Kr12qr98Zr4kKr9rAFyrX3yrJFyI
	9Fn3Cwn5uan0qwcCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27wAqx4
	xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v2
	6r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67
	vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAF
	wI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc4
	0Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AK
	xVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr
	1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU24SoDUUU
	U



On 2025/10/15 下午2:06, Song Gao wrote:
> Add cpu_has_msgint() to check whether the host cpu supported avec,
> and restore/save CSR_MSGIS0-CSR_MSGIS3.
> 
> Signed-off-by: Song Gao <gaosong@loongson.cn>
> ---
>   arch/loongarch/include/asm/kvm_host.h |  4 ++++
>   arch/loongarch/include/asm/kvm_vcpu.h |  1 +
>   arch/loongarch/include/uapi/asm/kvm.h |  1 +
>   arch/loongarch/kvm/interrupt.c        | 15 +++++++++++++--
>   arch/loongarch/kvm/vcpu.c             | 19 +++++++++++++++++--
>   arch/loongarch/kvm/vm.c               |  4 ++++
>   6 files changed, 40 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
> index 0cecbd038bb3..827e204bdeb3 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -283,6 +283,10 @@ static inline bool kvm_guest_has_lbt(struct kvm_vcpu_arch *arch)
>   	return arch->cpucfg[2] & (CPUCFG2_X86BT | CPUCFG2_ARMBT | CPUCFG2_MIPSBT);
>   }
>   
> +static inline bool cpu_has_msgint(void)
> +{
> +	return read_cpucfg(LOONGARCH_CPUCFG1) & CPUCFG1_MSGINT;
> +}
>   static inline bool kvm_guest_has_pmu(struct kvm_vcpu_arch *arch)
>   {
>   	return arch->cpucfg[6] & CPUCFG6_PMP;
> diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/include/asm/kvm_vcpu.h
> index f1efd7cfbc20..3784ab4ccdb5 100644
> --- a/arch/loongarch/include/asm/kvm_vcpu.h
> +++ b/arch/loongarch/include/asm/kvm_vcpu.h
> @@ -15,6 +15,7 @@
>   #define CPU_PMU				(_ULCAST_(1) << 10)
>   #define CPU_TIMER			(_ULCAST_(1) << 11)
>   #define CPU_IPI				(_ULCAST_(1) << 12)
> +#define CPU_AVEC                        (_ULCAST_(1) << 14)
>   
>   /* Controlled by 0x52 guest exception VIP aligned to estat bit 5~12 */
>   #define CPU_IP0				(_ULCAST_(1))
> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
> index 57ba1a563bb1..de6c3f18e40a 100644
> --- a/arch/loongarch/include/uapi/asm/kvm.h
> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> @@ -104,6 +104,7 @@ struct kvm_fpu {
>   #define  KVM_LOONGARCH_VM_FEAT_PV_IPI		6
>   #define  KVM_LOONGARCH_VM_FEAT_PV_STEALTIME	7
>   #define  KVM_LOONGARCH_VM_FEAT_PTW		8
> +#define  KVM_LOONGARCH_VM_FEAT_MSGINT		9
>   
>   /* Device Control API on vcpu fd */
>   #define KVM_LOONGARCH_VCPU_CPUCFG	0
> diff --git a/arch/loongarch/kvm/interrupt.c b/arch/loongarch/kvm/interrupt.c
> index 8462083f0301..f586f421bc19 100644
> --- a/arch/loongarch/kvm/interrupt.c
> +++ b/arch/loongarch/kvm/interrupt.c
> @@ -21,6 +21,7 @@ static unsigned int priority_to_irq[EXCCODE_INT_NUM] = {
>   	[INT_HWI5]	= CPU_IP5,
>   	[INT_HWI6]	= CPU_IP6,
>   	[INT_HWI7]	= CPU_IP7,
> +	[INT_AVEC]	= CPU_AVEC,
>   };
>   
>   static int kvm_irq_deliver(struct kvm_vcpu *vcpu, unsigned int priority)
> @@ -31,6 +32,11 @@ static int kvm_irq_deliver(struct kvm_vcpu *vcpu, unsigned int priority)
>   	if (priority < EXCCODE_INT_NUM)
>   		irq = priority_to_irq[priority];
>   
> +	if (cpu_has_msgint() && (priority == INT_AVEC)) {
> +		set_gcsr_estat(irq);
> +		return 1;
> +	}
> +
>   	switch (priority) {
>   	case INT_TI:
>   	case INT_IPI:
> @@ -58,6 +64,11 @@ static int kvm_irq_clear(struct kvm_vcpu *vcpu, unsigned int priority)
>   	if (priority < EXCCODE_INT_NUM)
>   		irq = priority_to_irq[priority];
>   
> +	if (cpu_has_msgint() && (priority == INT_AVEC)) {
> +		clear_gcsr_estat(irq);
> +		return 1;
> +	}
> +
>   	switch (priority) {
>   	case INT_TI:
>   	case INT_IPI:
> @@ -83,10 +94,10 @@ void kvm_deliver_intr(struct kvm_vcpu *vcpu)
>   	unsigned long *pending = &vcpu->arch.irq_pending;
>   	unsigned long *pending_clr = &vcpu->arch.irq_clear;
>   
> -	for_each_set_bit(priority, pending_clr, INT_IPI + 1)
> +	for_each_set_bit(priority, pending_clr, EXCCODE_INT_NUM)
>   		kvm_irq_clear(vcpu, priority);
>   
> -	for_each_set_bit(priority, pending, INT_IPI + 1)
> +	for_each_set_bit(priority, pending, EXCCODE_INT_NUM)
>   		kvm_irq_deliver(vcpu, priority);
>   }
>   
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 30e3b089a596..226c735155be 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -657,8 +657,7 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
>   		*v = GENMASK(31, 0);
>   		return 0;
>   	case LOONGARCH_CPUCFG1:
> -		/* CPUCFG1_MSGINT is not supported by KVM */
> -		*v = GENMASK(25, 0);
> +		*v = GENMASK(26, 0);
>   		return 0;
>   	case LOONGARCH_CPUCFG2:
>   		/* CPUCFG2 features unconditionally supported by KVM */
> @@ -726,6 +725,10 @@ static int kvm_check_cpucfg(int id, u64 val)
>   		return -EINVAL;
>   
>   	switch (id) {
> +	case LOONGARCH_CPUCFG1:
> +		if ((val & CPUCFG1_MSGINT) && (!cpu_has_msgint()))
> +			return -EINVAL;
> +		return 0;
>   	case LOONGARCH_CPUCFG2:
>   		if (!(val & CPUCFG2_LLFTP))
>   			/* Guests must have a constant timer */
> @@ -1658,6 +1661,12 @@ static int _kvm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_DMWIN2);
>   	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_DMWIN3);
>   	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_LLBCTL);
> +	if (cpu_has_msgint()) {
> +		kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ISR0);
> +		kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ISR1);
> +		kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ISR2);
> +		kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ISR3);
> +	}
>   
>   	/* Restore Root.GINTC from unused Guest.GINTC register */
>   	write_csr_gintc(csr->csrs[LOONGARCH_CSR_GINTC]);
> @@ -1747,6 +1756,12 @@ static int _kvm_vcpu_put(struct kvm_vcpu *vcpu, int cpu)
>   	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_DMWIN1);
>   	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_DMWIN2);
>   	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_DMWIN3);
> +	if (cpu_has_msgint()) {
> +		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ISR0);
> +		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ISR1);
> +		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ISR2);
> +		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ISR3);
> +	}
>   
>   	vcpu->arch.aux_inuse |= KVM_LARCH_SWCSR_LATEST;
>   
> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
> index a49b1c1a3dd1..ec92e6f3cf92 100644
> --- a/arch/loongarch/kvm/vm.c
> +++ b/arch/loongarch/kvm/vm.c
> @@ -150,6 +150,10 @@ static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kvm_device_attr *attr
>   		if (cpu_has_ptw)
>   			return 0;
>   		return -ENXIO;
> +	case KVM_LOONGARCH_VM_FEAT_MSGINT:
> +		if (cpu_has_msgint())
> +			return 0;
> +		return -ENXIO;
>   	default:
>   		return -ENXIO;
>   	}
> 
> base-commit: 9b332cece987ee1790b2ed4c989e28162fa47860
> 
Reviewed-by: Bibo Mao <maobibo@loongson.cn>


