Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B3E43E56E
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 17:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhJ1Ptf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 11:49:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35517 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230410AbhJ1Pta (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Oct 2021 11:49:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635436023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CbmNsSUrvGPtUZE+MWwRLOXXOyUhB+AbdYKB6eOYzgI=;
        b=A2+MzG9VRxzCdP01FQTteiGI9DnLvYndC+MU2PY5uYdrJ4eyo+H24bptCO3kLCDW46xB3o
        eUQQQPSL8ewMKaUSiXq56bwh/DkLDZMPxdnEhY/jIFf0q6owCjXifBICI3D/7g9qw78Dj1
        +djfTCMGZhinv3PRXE0McP1ZdEbZmxQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-qmR5zb0kMGqaJpP-fhah4A-1; Thu, 28 Oct 2021 11:47:01 -0400
X-MC-Unique: qmR5zb0kMGqaJpP-fhah4A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00705802682;
        Thu, 28 Oct 2021 15:46:58 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 193772637D;
        Thu, 28 Oct 2021 15:46:48 +0000 (UTC)
Message-ID: <412931e082b33403c8778cae7376325871ab0d54.camel@redhat.com>
Subject: Re: [PATCH v2 34/43] KVM: x86: Remove defunct pre_block/post_block
 kvm_x86_ops hooks
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Date:   Thu, 28 Oct 2021 18:46:11 +0300
In-Reply-To: <20211009021236.4122790-35-seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
         <20211009021236.4122790-35-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> Drop kvm_x86_ops' pre/post_block() now that all implementations are nops.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  2 --
>  arch/x86/include/asm/kvm_host.h    | 12 ------------
>  arch/x86/kvm/vmx/vmx.c             | 13 -------------
>  arch/x86/kvm/x86.c                 |  6 +-----
>  4 files changed, 1 insertion(+), 32 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index cefe1d81e2e8..c2b007171abd 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -96,8 +96,6 @@ KVM_X86_OP(handle_exit_irqoff)
>  KVM_X86_OP_NULL(request_immediate_exit)
>  KVM_X86_OP(sched_in)
>  KVM_X86_OP_NULL(update_cpu_dirty_logging)
> -KVM_X86_OP_NULL(pre_block)
> -KVM_X86_OP_NULL(post_block)
>  KVM_X86_OP_NULL(vcpu_blocking)
>  KVM_X86_OP_NULL(vcpu_unblocking)
>  KVM_X86_OP_NULL(update_pi_irte)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 328103a520d3..76a8dddc1a48 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1445,18 +1445,6 @@ struct kvm_x86_ops {
>  	const struct kvm_pmu_ops *pmu_ops;
>  	const struct kvm_x86_nested_ops *nested_ops;
>  
> -	/*
> -	 * Architecture specific hooks for vCPU blocking due to
> -	 * HLT instruction.
> -	 * Returns for .pre_block():
> -	 *    - 0 means continue to block the vCPU.
> -	 *    - 1 means we cannot block the vCPU since some event
> -	 *        happens during this period, such as, 'ON' bit in
> -	 *        posted-interrupts descriptor is set.
> -	 */
> -	int (*pre_block)(struct kvm_vcpu *vcpu);
> -	void (*post_block)(struct kvm_vcpu *vcpu);
> -
>  	void (*vcpu_blocking)(struct kvm_vcpu *vcpu);
>  	void (*vcpu_unblocking)(struct kvm_vcpu *vcpu);
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index a24f19874716..13e732a818f3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7462,16 +7462,6 @@ void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
>  		secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_ENABLE_PML);
>  }
>  
> -static int vmx_pre_block(struct kvm_vcpu *vcpu)
> -{
> -	return 0;
> -}
> -
> -static void vmx_post_block(struct kvm_vcpu *vcpu)
> -{
> -
> -}
> -
>  static void vmx_setup_mce(struct kvm_vcpu *vcpu)
>  {
>  	if (vcpu->arch.mcg_cap & MCG_LMCE_P)
> @@ -7665,9 +7655,6 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>  	.cpu_dirty_log_size = PML_ENTITY_NUM,
>  	.update_cpu_dirty_logging = vmx_update_cpu_dirty_logging,
>  
> -	.pre_block = vmx_pre_block,
> -	.post_block = vmx_post_block,
> -
>  	.pmu_ops = &intel_pmu_ops,
>  	.nested_ops = &vmx_nested_ops,
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 909e932a7ae7..9643f23c28c7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9898,8 +9898,7 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
>  {
>  	bool hv_timer;
>  
> -	if (!kvm_arch_vcpu_runnable(vcpu) &&
> -	    (!kvm_x86_ops.pre_block || static_call(kvm_x86_pre_block)(vcpu) == 0)) {
> +	if (!kvm_arch_vcpu_runnable(vcpu)) {
>  		/*
>  		 * Switch to the software timer before halt-polling/blocking as
>  		 * the guest's timer may be a break event for the vCPU, and the
> @@ -9921,9 +9920,6 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
>  		if (hv_timer)
>  			kvm_lapic_switch_to_hv_timer(vcpu);
>  
> -		if (kvm_x86_ops.post_block)
> -			static_call(kvm_x86_post_block)(vcpu);
> -
>  		if (!kvm_check_request(KVM_REQ_UNHALT, vcpu))
>  			return 1;
>  	}

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

