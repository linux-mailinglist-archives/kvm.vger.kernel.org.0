Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9384440F77
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 17:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbhJaQi6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 12:38:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60245 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229725AbhJaQi5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 Oct 2021 12:38:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635698185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wVq22xC51kdx10I7Z3TCBhCOu+wtFrVAqIwjXEZRDFw=;
        b=hD9DxkIQ8m5Jo4vKwQZsv+Ze9X32Q9v5Fd02f0DRva5MR31q8182Eip4GynTY/BaL6V9+v
        EiHcfNIniEs0YTrCymAnhXvh+ptDJnlZmQABlc9qoBuErSrdUchHsf51YV1vkMmI+7kcHJ
        HtP9lEGANmgmUnfRsVINcXSk3iYUcSU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-bwvTj_fDMiy7vbcMWXUZfg-1; Sun, 31 Oct 2021 12:36:22 -0400
X-MC-Unique: bwvTj_fDMiy7vbcMWXUZfg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1F191808302;
        Sun, 31 Oct 2021 16:36:18 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7EEC160BF4;
        Sun, 31 Oct 2021 16:35:58 +0000 (UTC)
Message-ID: <9addad02d861e20fc4e8a3c3efa983502ae2248c.camel@redhat.com>
Subject: Re: [PATCH v2 38/43] KVM: Drop defunct kvm_arch_vcpu_(un)blocking()
 hooks
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
Date:   Sun, 31 Oct 2021 18:35:57 +0200
In-Reply-To: <20211009021236.4122790-39-seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
         <20211009021236.4122790-39-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> Remove kvm_arch_vcpu_(un)blocking() now that all implementations are nops.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/arm64/kvm/arm.c                | 10 ----------
>  arch/mips/include/asm/kvm_host.h    |  2 --
>  arch/powerpc/include/asm/kvm_host.h |  2 --
>  arch/s390/include/asm/kvm_host.h    |  2 --
>  arch/x86/include/asm/kvm-x86-ops.h  |  2 --
>  arch/x86/include/asm/kvm_host.h     | 13 -------------
>  include/linux/kvm_host.h            |  2 --
>  virt/kvm/kvm_main.c                 |  4 ----
>  8 files changed, 37 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 9ff0e85a9f16..444d6f5a980a 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -357,16 +357,6 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
>  	return kvm_timer_is_pending(vcpu);
>  }
>  
> -void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
> -{
> -
> -}
> -
> -void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
> -{
> -
> -}
> -
>  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  {
>  	struct kvm_s2_mmu *mmu;
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
> index 72b90d45a46e..28110f71089b 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -895,8 +895,6 @@ static inline void kvm_arch_free_memslot(struct kvm *kvm,
>  					 struct kvm_memory_slot *slot) {}
>  static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
> -static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
> -static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>  
>  #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
>  int kvm_arch_flush_remote_tlb(struct kvm *kvm);
> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> index 4a195c161592..0dfee6866541 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -863,7 +863,5 @@ static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
>  static inline void kvm_arch_flush_shadow_all(struct kvm *kvm) {}
>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>  static inline void kvm_arch_exit(void) {}
> -static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
> -static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>  
>  #endif /* __POWERPC_KVM_HOST_H__ */
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index a22c9266ea05..25ed4ec66f4a 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -1007,7 +1007,5 @@ static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
>  static inline void kvm_arch_flush_shadow_all(struct kvm *kvm) {}
>  static inline void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>  		struct kvm_memory_slot *slot) {}
> -static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
> -static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>  
>  #endif
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index c2b007171abd..f2c38acdcad6 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -96,8 +96,6 @@ KVM_X86_OP(handle_exit_irqoff)
>  KVM_X86_OP_NULL(request_immediate_exit)
>  KVM_X86_OP(sched_in)
>  KVM_X86_OP_NULL(update_cpu_dirty_logging)
> -KVM_X86_OP_NULL(vcpu_blocking)
> -KVM_X86_OP_NULL(vcpu_unblocking)
>  KVM_X86_OP_NULL(update_pi_irte)
>  KVM_X86_OP_NULL(start_assignment)
>  KVM_X86_OP_NULL(apicv_post_state_restore)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 76a8dddc1a48..bebd42926321 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1445,9 +1445,6 @@ struct kvm_x86_ops {
>  	const struct kvm_pmu_ops *pmu_ops;
>  	const struct kvm_x86_nested_ops *nested_ops;
>  
> -	void (*vcpu_blocking)(struct kvm_vcpu *vcpu);
> -	void (*vcpu_unblocking)(struct kvm_vcpu *vcpu);
> -
>  	int (*update_pi_irte)(struct kvm *kvm, unsigned int host_irq,
>  			      uint32_t guest_irq, bool set);
>  	void (*start_assignment)(struct kvm *kvm);
> @@ -1904,16 +1901,6 @@ static inline bool kvm_irq_is_postable(struct kvm_lapic_irq *irq)
>  		irq->delivery_mode == APIC_DM_LOWEST);
>  }
>  
> -static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
> -{
> -	static_call_cond(kvm_x86_vcpu_blocking)(vcpu);
> -}
> -
> -static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
> -{
> -	static_call_cond(kvm_x86_vcpu_unblocking)(vcpu);
> -}
> -
>  static inline int kvm_cpu_get_apicid(int mps_cpu)
>  {
>  #ifdef CONFIG_X86_LOCAL_APIC
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index c5961a361c73..6a84b020daa6 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -966,8 +966,6 @@ void kvm_sigset_deactivate(struct kvm_vcpu *vcpu);
>  
>  void kvm_vcpu_halt(struct kvm_vcpu *vcpu);
>  bool kvm_vcpu_block(struct kvm_vcpu *vcpu);
> -void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu);
> -void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu);
>  bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu);
>  void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
>  int kvm_vcpu_yield_to(struct kvm_vcpu *target);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index c1850b60f38b..96de905e26e4 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3210,8 +3210,6 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  
>  	vcpu->stat.generic.blocking = 1;
>  
> -	kvm_arch_vcpu_blocking(vcpu);
> -
>  	prepare_to_rcuwait(wait);
>  	for (;;) {
>  		set_current_state(TASK_INTERRUPTIBLE);
> @@ -3224,8 +3222,6 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  	}
>  	finish_rcuwait(wait);
>  
> -	kvm_arch_vcpu_unblocking(vcpu);
> -
>  	vcpu->stat.generic.blocking = 0;
>  
>  	return waited;

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>



