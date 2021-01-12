Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6495C2F3FE0
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 01:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389829AbhALXFR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 18:05:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387506AbhALXFR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 18:05:17 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA50AC061786
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 15:04:36 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id t6so2282583plq.1
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 15:04:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v1y2JVqCb741cmu9LZuZGtYl6ezSqlmS2NO+PbgJcrE=;
        b=E1mXvxzk9lFQ60sBuZtwVcXftdzZaWEesX9atAHPf2+5V+fniOkt4xAElXTBKxQtn6
         HpKmdECzhGBYVPLhCDndpKQBGUAjr1DAtYyMlNGzqONmf6zV73OtPjj8EgjlENpUtC/H
         wmx1U/ZVdsd0daacq8f+697tjvK4h6H7D73R3zTtkukn0t/B+BPSmIHNxpoq/ivrJ3qY
         gPyT8eYjT+8qZMUaOn81GvpdOHY5JQptlF/Y5XVWt6N3moV81hLIvJM9EbK04UGDaS99
         3xskjlOQ2qY49IaNAn0mUP0m/zgJJTLDnpiEANCyL8LRDvxSrewx+MlgkApZXiWVYQtz
         86Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v1y2JVqCb741cmu9LZuZGtYl6ezSqlmS2NO+PbgJcrE=;
        b=LtjF0f39Mzj2lD5buF9DOKAO1np+gWMF/RzLIyb924RYeoFhFFmu4SBpCoBMTZ1pXW
         oGB7uTFifNsFsyzNBMniD97YPx3PhB5LChOYaaL8o0jcy0JLf5/LrMsvPJmztiYOBzQZ
         M183aF2X/yesInOmYVHPY6EXIA3EDhhCeOkLHpJuL0FtFa8kdTjC1dliPvBLc2ziiVJB
         MHF2uXJFOyLua0smpYGl0CekvRX5rmqQuLzcUDtpEgBZbEcOxkCpo1e4lzI6lYgOqqWc
         1blFRVujziwNiyj05s/Y1acdUw36Y+57Zk3ZwmtbEvTnHQGDMIeEXDQ2H1zwokURRC2g
         wUQA==
X-Gm-Message-State: AOAM533A9slfU3GSMQ+8RzY94BEbhFW2ZPO95CDtqLGSU49bqP5NovmP
        /HZN/l2r2HM9gPWIIliVE3ahy4rJY5Tmrw==
X-Google-Smtp-Source: ABdhPJz5cajbnHF3HFOFRmfElI/dBw7nMPNyK50lnlrRJKVbflmuxgiVizlUCvce59SzMFZJxAelMA==
X-Received: by 2002:a17:90a:c087:: with SMTP id o7mr1422026pjs.205.1610492675976;
        Tue, 12 Jan 2021 15:04:35 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id x16sm167656pfp.62.2021.01.12.15.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 15:04:35 -0800 (PST)
Date:   Tue, 12 Jan 2021 15:04:28 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Jason Baron <jbaron@akamai.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, peterz@infradead.org,
        aarcange@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: x86: introduce definitions to support static
 calls for kvm_x86_ops
Message-ID: <X/4q/OKvW9RKQ+gk@google.com>
References: <cover.1610379877.git.jbaron@akamai.com>
 <ce483ce4a1920a3c1c4e5deea11648d75f2a7b80.1610379877.git.jbaron@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce483ce4a1920a3c1c4e5deea11648d75f2a7b80.1610379877.git.jbaron@akamai.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 11, 2021, Jason Baron wrote:
> Use static calls to improve kvm_x86_ops performance. Introduce the
> definitions that will be used by a subsequent patch to actualize the
> savings.
> 
> Note that all kvm_x86_ops are covered here except for 'pmu_ops' and
> 'nested ops'. I think they can be covered by static calls in a simlilar
> manner, but were omitted from this series to reduce scope and because
> I don't think they have as large of a performance impact.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Signed-off-by: Jason Baron <jbaron@akamai.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 65 +++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/x86.c              |  5 ++++
>  2 files changed, 70 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3ab7b46..e947522 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1087,6 +1087,65 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
>  	return dest_mode_logical ? APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;
>  }
>  
> +/*
> + * static calls cover all kvm_x86_ops except for functions under pmu_ops and
> + * nested_ops.
> + */
> +#define FOREACH_KVM_X86_OPS(F) \
> +	F(hardware_enable); F(hardware_disable); F(hardware_unsetup);	       \
> +	F(cpu_has_accelerated_tpr); F(has_emulated_msr);		       \
> +	F(vcpu_after_set_cpuid); F(vm_init); F(vm_destroy); F(vcpu_create);    \
> +	F(vcpu_free); F(vcpu_reset); F(prepare_guest_switch); F(vcpu_load);    \
> +	F(vcpu_put); F(update_exception_bitmap); F(get_msr); F(set_msr);       \
> +	F(get_segment_base); F(get_segment); F(get_cpl); F(set_segment);       \
> +	F(get_cs_db_l_bits); F(set_cr0); F(is_valid_cr4); F(set_cr4);	       \
> +	F(set_efer); F(get_idt); F(set_idt); F(get_gdt); F(set_gdt);	       \
> +	F(sync_dirty_debug_regs); F(set_dr7); F(cache_reg); F(get_rflags);     \
> +	F(set_rflags); F(tlb_flush_all); F(tlb_flush_current);		       \
> +	F(tlb_remote_flush); F(tlb_remote_flush_with_range); F(tlb_flush_gva); \
> +	F(tlb_flush_guest); F(run); F(handle_exit);			       \
> +	F(skip_emulated_instruction); F(update_emulated_instruction);	       \
> +	F(set_interrupt_shadow); F(get_interrupt_shadow); F(patch_hypercall);  \
> +	F(set_irq); F(set_nmi); F(queue_exception); F(cancel_injection);       \
> +	F(interrupt_allowed); F(nmi_allowed); F(get_nmi_mask); F(set_nmi_mask);\
> +	F(enable_nmi_window); F(enable_irq_window); F(update_cr8_intercept);   \
> +	F(check_apicv_inhibit_reasons); F(pre_update_apicv_exec_ctrl);	       \
> +	F(refresh_apicv_exec_ctrl); F(hwapic_irr_update); F(hwapic_isr_update);\
> +	F(guest_apic_has_interrupt); F(load_eoi_exitmap);		       \
> +	F(set_virtual_apic_mode); F(set_apic_access_page_addr);		       \
> +	F(deliver_posted_interrupt); F(sync_pir_to_irr); F(set_tss_addr);      \
> +	F(set_identity_map_addr); F(get_mt_mask); F(load_mmu_pgd);	       \
> +	F(has_wbinvd_exit); F(write_l1_tsc_offset); F(get_exit_info);	       \
> +	F(check_intercept); F(handle_exit_irqoff); F(request_immediate_exit);  \
> +	F(sched_in); F(slot_enable_log_dirty); F(slot_disable_log_dirty);      \
> +	F(flush_log_dirty); F(enable_log_dirty_pt_masked);		       \
> +	F(cpu_dirty_log_size); F(pre_block); F(post_block); F(vcpu_blocking);  \
> +	F(vcpu_unblocking); F(update_pi_irte); F(apicv_post_state_restore);    \
> +	F(dy_apicv_has_pending_interrupt); F(set_hv_timer); F(cancel_hv_timer);\
> +	F(setup_mce); F(smi_allowed); F(pre_enter_smm); F(pre_leave_smm);      \
> +	F(enable_smi_window); F(mem_enc_op); F(mem_enc_reg_region);	       \
> +	F(mem_enc_unreg_region); F(get_msr_feature);			       \
> +	F(can_emulate_instruction); F(apic_init_signal_blocked);	       \
> +	F(enable_direct_tlbflush); F(migrate_timers); F(msr_filter_changed);   \
> +	F(complete_emulated_msr)

What about adding a dedicated .h file for this beast?  Then it won't be so
painful to do one function per line.  As is, updates to kvm_x86_ops will be
messy.

And add yet another macro layer (or maybe just tweak this one?) so that the
caller controls the line ending?  I suppose you could also just use a comma, but
that's a bit dirty...

That would also allow using this to declare vmx_x86_ops and svm_x86_ops, which
would need a comma insteat of a semi-colon.  There have a been a few attempts to
add a bit of automation to {vmx,svm}_x86_ops, this seems like it would be good
motivation to go in a different direction and declare/define all ops, e.g. the
VMX/SVM code could simply do something like:

#define DECLARE_VMX_X86_OP(func) \
	.func = vmx_##func

static struct kvm_x86_ops vmx_x86_ops __initdata = {
	.vm_size = sizeof(struct kvm_vmx),
	.vm_init = vmx_vm_init,

	.pmu_ops = &intel_pmu_ops,
	.nested_ops = &vmx_nested_ops,

	FOREACH_KVM_X86_OPS(DECLARE_VMX_X86_OP)
};

