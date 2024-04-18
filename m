Return-Path: <kvm+bounces-15063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BC958A9633
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 11:30:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB57C1C21DB6
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 09:30:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E32B415ADB1;
	Thu, 18 Apr 2024 09:30:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACC8B152E12;
	Thu, 18 Apr 2024 09:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713432645; cv=none; b=gS+Ri/iybKCpoZhQggx70+hAPVdbN6wmTjMkzGCbRuy/KorFJM3HiM41bJeWQiNbW7FUP1YnyiD9bkTBeVm4DdwUt2mX7rUh3I+q4YELOIjzhkDTCHZWCNVXYf7h1OwAOKaT3UHZUUNFOQXiLID3TEQNYeQ0Hiz1qZm5PLr+1so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713432645; c=relaxed/simple;
	bh=jkUdI1l7jyx9l2Q/C9KSmfjWLcjVVTRQwdO0plAvfWU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W+cTGpTL8LrjhrDW11X2HqBReHxX07RzsPJ6cxZRdlmVEe/kG3JP6omALuekp/Zac+8VyvZZUcg0kTMAxl5AAj6jReemRew9TFaKSJGO6gs0V82SZBGS3idyCa6lM5kBATKgu+hZGEN2RvUNmTjFwd+Y9kgwczUcQNAuUtcb2s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D4500339;
	Thu, 18 Apr 2024 02:31:09 -0700 (PDT)
Received: from [10.57.84.16] (unknown [10.57.84.16])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AA4E33F64C;
	Thu, 18 Apr 2024 02:30:39 -0700 (PDT)
Message-ID: <785075df-4a0e-4cd3-bace-a59db7caa746@arm.com>
Date: Thu, 18 Apr 2024 10:30:38 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 16/43] KVM: arm64: Support timers in realm RECs
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084309.1733783-1-steven.price@arm.com>
 <20240412084309.1733783-17-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240412084309.1733783-17-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/04/2024 09:42, Steven Price wrote:
> The RMM keeps track of the timer while the realm REC is running, but on
> exit to the normal world KVM is responsible for handling the timers.
> 

minor nit: It may be worth mentioning this will be hooked in, when we
add the Realm exit handling.

Otherwise looks good to me.


Suzuki


> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/arch_timer.c  | 45 ++++++++++++++++++++++++++++++++----
>   include/kvm/arm_arch_timer.h |  2 ++
>   2 files changed, 43 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 879982b1cc73..0b2be34a9ba3 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -162,6 +162,13 @@ static void timer_set_cval(struct arch_timer_context *ctxt, u64 cval)
>   
>   static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
>   {
> +	struct kvm_vcpu *vcpu = ctxt->vcpu;
> +
> +	if (kvm_is_realm(vcpu->kvm)) {
> +		WARN_ON(offset);
> +		return;
> +	}
> +
>   	if (!ctxt->offset.vm_offset) {
>   		WARN(offset, "timer %ld\n", arch_timer_ctx_index(ctxt));
>   		return;
> @@ -460,6 +467,21 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
>   	}
>   }
>   
> +void kvm_realm_timers_update(struct kvm_vcpu *vcpu)
> +{
> +	struct arch_timer_cpu *arch_timer = &vcpu->arch.timer_cpu;
> +	int i;
> +
> +	for (i = 0; i < NR_KVM_EL0_TIMERS; i++) {
> +		struct arch_timer_context *timer = &arch_timer->timers[i];
> +		bool status = timer_get_ctl(timer) & ARCH_TIMER_CTRL_IT_STAT;
> +		bool level = kvm_timer_irq_can_fire(timer) && status;
> +
> +		if (level != timer->irq.level)
> +			kvm_timer_update_irq(vcpu, level, timer);
> +	}
> +}
> +
>   /* Only called for a fully emulated timer */
>   static void timer_emulate(struct arch_timer_context *ctx)
>   {
> @@ -831,6 +853,8 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
>   	if (unlikely(!timer->enabled))
>   		return;
>   
> +	kvm_timer_unblocking(vcpu);
> +
>   	get_timer_map(vcpu, &map);
>   
>   	if (static_branch_likely(&has_gic_active_state)) {
> @@ -844,8 +868,6 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
>   		kvm_timer_vcpu_load_nogic(vcpu);
>   	}
>   
> -	kvm_timer_unblocking(vcpu);
> -
>   	timer_restore_state(map.direct_vtimer);
>   	if (map.direct_ptimer)
>   		timer_restore_state(map.direct_ptimer);
> @@ -988,7 +1010,9 @@ static void timer_context_init(struct kvm_vcpu *vcpu, int timerid)
>   
>   	ctxt->vcpu = vcpu;
>   
> -	if (timerid == TIMER_VTIMER)
> +	if (kvm_is_realm(vcpu->kvm))
> +		ctxt->offset.vm_offset = NULL;
> +	else if (timerid == TIMER_VTIMER)
>   		ctxt->offset.vm_offset = &kvm->arch.timer_data.voffset;
>   	else
>   		ctxt->offset.vm_offset = &kvm->arch.timer_data.poffset;
> @@ -1011,13 +1035,19 @@ static void timer_context_init(struct kvm_vcpu *vcpu, int timerid)
>   void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
>   {
>   	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
> +	u64 cntvoff;
>   
>   	for (int i = 0; i < NR_KVM_TIMERS; i++)
>   		timer_context_init(vcpu, i);
>   
> +	if (kvm_is_realm(vcpu->kvm))
> +		cntvoff = 0;
> +	else
> +		cntvoff = kvm_phys_timer_read();
> +
>   	/* Synchronize offsets across timers of a VM if not already provided */
>   	if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags)) {
> -		timer_set_offset(vcpu_vtimer(vcpu), kvm_phys_timer_read());
> +		timer_set_offset(vcpu_vtimer(vcpu), cntvoff);
>   		timer_set_offset(vcpu_ptimer(vcpu), 0);
>   	}
>   
> @@ -1525,6 +1555,13 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>   		return -EINVAL;
>   	}
>   
> +	/*
> +	 * We don't use mapped IRQs for Realms because the RMI doesn't allow
> +	 * us setting the LR.HW bit in the VGIC.
> +	 */
> +	if (vcpu_is_rec(vcpu))
> +		return 0;
> +
>   	get_timer_map(vcpu, &map);
>   
>   	ret = kvm_vgic_map_phys_irq(vcpu,
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index c819c5d16613..d8ab297560d0 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -112,6 +112,8 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>   int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>   int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>   
> +void kvm_realm_timers_update(struct kvm_vcpu *vcpu);
> +
>   u64 kvm_phys_timer_read(void);
>   
>   void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu);


