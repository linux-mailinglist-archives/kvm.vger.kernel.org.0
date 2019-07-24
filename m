Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA22672DCA
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 13:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbfGXLjn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 07:39:43 -0400
Received: from foss.arm.com ([217.140.110.172]:39622 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727128AbfGXLjm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 07:39:42 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4F13E337;
        Wed, 24 Jul 2019 04:39:41 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9585C3F71A;
        Wed, 24 Jul 2019 04:39:40 -0700 (PDT)
Subject: Re: [PATCH 3/3] KVM: arm/arm64: vgic: introduce vgic_cpu pending
 status and lowest_priority
To:     Xiangyou Xie <xiexiangyou@huawei.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
References: <20190724090437.49952-1-xiexiangyou@huawei.com>
 <20190724090437.49952-4-xiexiangyou@huawei.com>
From:   Marc Zyngier <marc.zyngier@arm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=marc.zyngier@arm.com; prefer-encrypt=mutual; keydata=
 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
 Z46HaNmN2hZS/oJ69c1DI5Rcww==
Organization: ARM Ltd
Message-ID: <c43d7331-a30b-5c0f-47ce-a5d9a1840a63@arm.com>
Date:   Wed, 24 Jul 2019 12:39:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190724090437.49952-4-xiexiangyou@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/07/2019 10:04, Xiangyou Xie wrote:
> During the halt polling process, vgic_cpu->ap_list_lock is frequently
> obtained andreleased, (kvm_vcpu_check_block->kvm_arch_vcpu_runnable->
> kvm_vgic_vcpu_pending_irq).This action affects the performance of virq
> interrupt injection, because vgic_queue_irq_unlock also attempts to get
> vgic_cpu->ap_list_lock and add irq to vgic_cpu ap_list.

Numbers. Give me numbers. Please.

> 
> The irq pending state and the minimum priority introduced by the patch,
> kvm_vgic_vcpu_pending_irq do not need to traverse vgic_cpu ap_list, only
> the check pending state and priority.
> 
> Signed-off-by: Xiangyou Xie <xiexiangyou@huawei.com>
> ---
>  include/kvm/arm_vgic.h   |  5 +++++
>  virt/kvm/arm/vgic/vgic.c | 40 ++++++++++++++++++++++------------------
>  2 files changed, 27 insertions(+), 18 deletions(-)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index ce372a0..636db29 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -337,6 +337,11 @@ struct vgic_cpu {
>  
>  	/* Cache guest interrupt ID bits */
>  	u32 num_id_bits;
> +
> +	/* Minimum of priority in all irqs */
> +	u8 lowest_priority;

In all IRQs? That are in every possible state?

> +	/* Irq pending flag */
> +	bool pending;

What does pending mean here? Strictly pending? or covering the other
states of an interrupt (Active, Active+Pending)?

>  };
>  
>  extern struct static_key_false vgic_v2_cpuif_trap;
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index deb8471..767dfe0 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -398,6 +398,12 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
>  	 * now in the ap_list.
>  	 */
>  	vgic_get_irq_kref(irq);
> +
> +	if (!irq->active) {

Why not active? What if the interrupt is Active+Pending? What is the
rational for this? This applies to the whole of this patch.

> +		vcpu->arch.vgic_cpu.pending = true;
> +		if (vcpu->arch.vgic_cpu.lowest_priority > irq->priority)
> +			vcpu->arch.vgic_cpu.lowest_priority = irq->priority;
> +	}
>  	list_add_tail(&irq->ap_list, &vcpu->arch.vgic_cpu.ap_list_head);
>  	irq->vcpu = vcpu;
>  
> @@ -618,6 +624,9 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
>  retry:
>  	raw_spin_lock(&vgic_cpu->ap_list_lock);
>  
> +	vgic_cpu->lowest_priority = U8_MAX;
> +	vgic_cpu->pending = false;
> +
>  	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
>  		struct kvm_vcpu *target_vcpu, *vcpuA, *vcpuB;
>  		bool target_vcpu_needs_kick = false;
> @@ -649,6 +658,11 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
>  		}
>  
>  		if (target_vcpu == vcpu) {
> +			if (!irq->active) {
> +				vgic_cpu->pending = true;
> +				if (vgic_cpu->lowest_priority > irq->priority)
> +					vgic_cpu->lowest_priority = irq->priority;
> +			}
>  			/* We're on the right CPU */
>  			raw_spin_unlock(&irq->irq_lock);
>  			continue;
> @@ -690,6 +704,11 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
>  
>  			list_del(&irq->ap_list);
>  			irq->vcpu = target_vcpu;
> +			if (!irq->active) {
> +				new_cpu->pending = true;
> +				if (new_cpu->lowest_priority > irq->priority)
> +					new_cpu->lowest_priority = irq->priority;
> +			}
>  			list_add_tail(&irq->ap_list, &new_cpu->ap_list_head);
>  			target_vcpu_needs_kick = true;
>  		}
> @@ -930,9 +949,6 @@ void kvm_vgic_put(struct kvm_vcpu *vcpu)
>  int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
>  {
>  	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> -	struct vgic_irq *irq;
> -	bool pending = false;
> -	unsigned long flags;
>  	struct vgic_vmcr vmcr;
>  
>  	if (!vcpu->kvm->arch.vgic.enabled)
> @@ -943,22 +959,10 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
>  
>  	vgic_get_vmcr(vcpu, &vmcr);
>  
> -	raw_spin_lock_irqsave(&vgic_cpu->ap_list_lock, flags);
> -
> -	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
> -		raw_spin_lock(&irq->irq_lock);
> -		pending = irq_is_pending(irq) && irq->enabled &&
> -			  !irq->active &&
> -			  irq->priority < vmcr.pmr;
> -		raw_spin_unlock(&irq->irq_lock);
> -
> -		if (pending)
> -			break;
> -	}
> -
> -	raw_spin_unlock_irqrestore(&vgic_cpu->ap_list_lock, flags);
> +	if (vgic_cpu->pending && vgic_cpu->lowest_priority < vmcr.pmr)
> +		return true;

And here we go. You've dropped the lock, and yet are evaluating two
unrelated fields that could be changed by a parallel injection or the
vcpu entering/exiting the guest.

I'm sure you get better performance. I'm also pretty sure this is
completely unsafe.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
