Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9F8EBB21D
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 12:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729502AbfIWKTf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 06:19:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52816 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728229AbfIWKTf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 06:19:35 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BC15181DE7
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 10:19:33 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id n3so4673522wrt.9
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 03:19:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1a91++YbD3RujnJRDdtbEUvS+KVM0xi0deKueDtkPZ8=;
        b=YnKz+nvrj7wc4yde0u3jk0H1PhkxHvSUFBNHY9Xt90sw6Vn30FRFcRBtNajPCo6JEi
         Exjd504s0ApidopYbH3bY3nGGIUly3VdmJOyawUJIZSadWrU1L4ilwwxbHgfCMBwczG6
         LNpIizo7nGJRoHgz0Pj23lFyu6F77y03EUg175xa3oQ9s5e2zIDC7IUYs6cUcrqTkuEP
         l2Ugy343E0/1EiaDwdJIMbrY+PUUn9TMJtp8jAiEVl++3Z2WcgC+/5xJ4GRNhXJlsIMK
         Hg+MmFLrmi73y8j+17tkTYgQj0iZVnryYfbTGX8Bj5g69967dDeZNcmjZ3X/9vUpZeZ5
         q+hA==
X-Gm-Message-State: APjAAAVXVHXo57pYwZe380x3EoAs9nemNmrhtcksRiCWq6VlIN33kxoX
        2zJxilOs/3hK/BKxiF5AJfC8WRpZ9+Cxws5y2SPvCWXmnOSBaAtGQiEJmZuUbIiSvzOkIXNNOEM
        a1u8zmjHg2PcB
X-Received: by 2002:a5d:66ce:: with SMTP id k14mr10519107wrw.258.1569233972179;
        Mon, 23 Sep 2019 03:19:32 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwGKGVp+19ZtOboxMxuYwQ0whx72ye+Wrl0pGTL4x+riLZcinDE7qsszYxXFXZW5LYwxczCrA==
X-Received: by 2002:a5d:66ce:: with SMTP id k14mr10519084wrw.258.1569233971737;
        Mon, 23 Sep 2019 03:19:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id e18sm10236305wrv.63.2019.09.23.03.19.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2019 03:19:31 -0700 (PDT)
Subject: Re: [PATCH 02/17] KVM: monolithic: x86: convert the kvm_x86_ops
 methods to external functions
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-3-aarcange@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <9b188fb8-b930-047f-d1c0-fe27cbe27338@redhat.com>
Date:   Mon, 23 Sep 2019 12:19:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190920212509.2578-3-aarcange@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/09/19 23:24, Andrea Arcangeli wrote:
> diff --git a/arch/x86/kvm/svm_ops.c b/arch/x86/kvm/svm_ops.c
> new file mode 100644
> index 000000000000..2aaabda92179
> --- /dev/null
> +++ b/arch/x86/kvm/svm_ops.c
> @@ -0,0 +1,672 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + *  arch/x86/kvm/svm_ops.c
> + *
> + *  Copyright 2019 Red Hat, Inc.
> + */
> +
> +int kvm_x86_ops_cpu_has_kvm_support(void)
> +{
> +	return has_svm();
> +}

Can you just rename all the functions in vmx/ and svm.c, instead of
adding forwarders?

Thanks,

Paolo

> +int kvm_x86_ops_disabled_by_bios(void)
> +{
> +	return is_disabled();
> +}
> +
> +int kvm_x86_ops_hardware_enable(void)
> +{
> +	return svm_hardware_enable();
> +}
> +
> +void kvm_x86_ops_hardware_disable(void)
> +{
> +	svm_hardware_disable();
> +}
> +
> +__init int kvm_x86_ops_check_processor_compatibility(void)
> +{
> +	return svm_check_processor_compat();
> +}
> +
> +__init int kvm_x86_ops_hardware_setup(void)
> +{
> +	return svm_hardware_setup();
> +}
> +
> +void kvm_x86_ops_hardware_unsetup(void)
> +{
> +	svm_hardware_unsetup();
> +}
> +
> +bool kvm_x86_ops_cpu_has_accelerated_tpr(void)
> +{
> +	return svm_cpu_has_accelerated_tpr();
> +}
> +
> +bool kvm_x86_ops_has_emulated_msr(int index)
> +{
> +	return svm_has_emulated_msr(index);
> +}
> +
> +void kvm_x86_ops_cpuid_update(struct kvm_vcpu *vcpu)
> +{
> +	svm_cpuid_update(vcpu);
> +}
> +
> +struct kvm *kvm_x86_ops_vm_alloc(void)
> +{
> +	return svm_vm_alloc();
> +}
> +
> +void kvm_x86_ops_vm_free(struct kvm *kvm)
> +{
> +	svm_vm_free(kvm);
> +}
> +
> +int kvm_x86_ops_vm_init(struct kvm *kvm)
> +{
> +	return avic_vm_init(kvm);
> +}
> +
> +void kvm_x86_ops_vm_destroy(struct kvm *kvm)
> +{
> +	svm_vm_destroy(kvm);
> +}
> +
> +struct kvm_vcpu *kvm_x86_ops_vcpu_create(struct kvm *kvm, unsigned id)
> +{
> +	return svm_create_vcpu(kvm, id);
> +}
> +
> +void kvm_x86_ops_vcpu_free(struct kvm_vcpu *vcpu)
> +{
> +	svm_free_vcpu(vcpu);
> +}
> +
> +void kvm_x86_ops_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> +{
> +	svm_vcpu_reset(vcpu, init_event);
> +}
> +
> +void kvm_x86_ops_prepare_guest_switch(struct kvm_vcpu *vcpu)
> +{
> +	svm_prepare_guest_switch(vcpu);
> +}
> +
> +void kvm_x86_ops_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> +{
> +	svm_vcpu_load(vcpu, cpu);
> +}
> +
> +void kvm_x86_ops_vcpu_put(struct kvm_vcpu *vcpu)
> +{
> +	svm_vcpu_put(vcpu);
> +}
> +
> +void kvm_x86_ops_update_bp_intercept(struct kvm_vcpu *vcpu)
> +{
> +	update_bp_intercept(vcpu);
> +}
> +
> +int kvm_x86_ops_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
> +{
> +	return svm_get_msr(vcpu, msr);
> +}
> +
> +int kvm_x86_ops_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
> +{
> +	return svm_set_msr(vcpu, msr);
> +}
> +
> +u64 kvm_x86_ops_get_segment_base(struct kvm_vcpu *vcpu, int seg)
> +{
> +	return svm_get_segment_base(vcpu, seg);
> +}
> +
> +void kvm_x86_ops_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var,
> +			     int seg)
> +{
> +	svm_get_segment(vcpu, var, seg);
> +}
> +
> +int kvm_x86_ops_get_cpl(struct kvm_vcpu *vcpu)
> +{
> +	return svm_get_cpl(vcpu);
> +}
> +
> +void kvm_x86_ops_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var,
> +			     int seg)
> +{
> +	svm_set_segment(vcpu, var, seg);
> +}
> +
> +void kvm_x86_ops_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
> +{
> +	kvm_get_cs_db_l_bits(vcpu, db, l);
> +}
> +
> +void kvm_x86_ops_decache_cr0_guest_bits(struct kvm_vcpu *vcpu)
> +{
> +	svm_decache_cr0_guest_bits(vcpu);
> +}
> +
> +void kvm_x86_ops_decache_cr3(struct kvm_vcpu *vcpu)
> +{
> +	svm_decache_cr3(vcpu);
> +}
> +
> +void kvm_x86_ops_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
> +{
> +	svm_decache_cr4_guest_bits(vcpu);
> +}
> +
> +void kvm_x86_ops_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
> +{
> +	svm_set_cr0(vcpu, cr0);
> +}
> +
> +void kvm_x86_ops_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> +{
> +	svm_set_cr3(vcpu, cr3);
> +}
> +
> +int kvm_x86_ops_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> +{
> +	return svm_set_cr4(vcpu, cr4);
> +}
> +
> +void kvm_x86_ops_set_efer(struct kvm_vcpu *vcpu, u64 efer)
> +{
> +	svm_set_efer(vcpu, efer);
> +}
> +
> +void kvm_x86_ops_get_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
> +{
> +	svm_get_idt(vcpu, dt);
> +}
> +
> +void kvm_x86_ops_set_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
> +{
> +	svm_set_idt(vcpu, dt);
> +}
> +
> +void kvm_x86_ops_get_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
> +{
> +	svm_get_gdt(vcpu, dt);
> +}
> +
> +void kvm_x86_ops_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
> +{
> +	svm_set_gdt(vcpu, dt);
> +}
> +
> +u64 kvm_x86_ops_get_dr6(struct kvm_vcpu *vcpu)
> +{
> +	return svm_get_dr6(vcpu);
> +}
> +
> +void kvm_x86_ops_set_dr6(struct kvm_vcpu *vcpu, unsigned long value)
> +{
> +	svm_set_dr6(vcpu, value);
> +}
> +
> +void kvm_x86_ops_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
> +{
> +	svm_sync_dirty_debug_regs(vcpu);
> +}
> +
> +void kvm_x86_ops_set_dr7(struct kvm_vcpu *vcpu, unsigned long value)
> +{
> +	svm_set_dr7(vcpu, value);
> +}
> +
> +void kvm_x86_ops_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
> +{
> +	svm_cache_reg(vcpu, reg);
> +}
> +
> +unsigned long kvm_x86_ops_get_rflags(struct kvm_vcpu *vcpu)
> +{
> +	return svm_get_rflags(vcpu);
> +}
> +
> +void kvm_x86_ops_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
> +{
> +	svm_set_rflags(vcpu, rflags);
> +}
> +
> +void kvm_x86_ops_tlb_flush(struct kvm_vcpu *vcpu, bool invalidate_gpa)
> +{
> +	svm_flush_tlb(vcpu, invalidate_gpa);
> +}
> +
> +int kvm_x86_ops_tlb_remote_flush(struct kvm *kvm)
> +{
> +	return kvm_x86_ops->tlb_remote_flush(kvm);
> +}
> +
> +int kvm_x86_ops_tlb_remote_flush_with_range(struct kvm *kvm,
> +					    struct kvm_tlb_range *range)
> +{
> +	return kvm_x86_ops->tlb_remote_flush_with_range(kvm, range);
> +}
> +
> +void kvm_x86_ops_tlb_flush_gva(struct kvm_vcpu *vcpu, gva_t addr)
> +{
> +	svm_flush_tlb_gva(vcpu, addr);
> +}
> +
> +void kvm_x86_ops_run(struct kvm_vcpu *vcpu)
> +{
> +	svm_vcpu_run(vcpu);
> +}
> +
> +int kvm_x86_ops_handle_exit(struct kvm_vcpu *vcpu)
> +{
> +	return handle_exit(vcpu);
> +}
> +
> +int kvm_x86_ops_skip_emulated_instruction(struct kvm_vcpu *vcpu)
> +{
> +	return skip_emulated_instruction(vcpu);
> +}
> +
> +void kvm_x86_ops_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
> +{
> +	svm_set_interrupt_shadow(vcpu, mask);
> +}
> +
> +u32 kvm_x86_ops_get_interrupt_shadow(struct kvm_vcpu *vcpu)
> +{
> +	return svm_get_interrupt_shadow(vcpu);
> +}
> +
> +void kvm_x86_ops_patch_hypercall(struct kvm_vcpu *vcpu,
> +				 unsigned char *hypercall_addr)
> +{
> +	svm_patch_hypercall(vcpu, hypercall_addr);
> +}
> +
> +void kvm_x86_ops_set_irq(struct kvm_vcpu *vcpu)
> +{
> +	svm_set_irq(vcpu);
> +}
> +
> +void kvm_x86_ops_set_nmi(struct kvm_vcpu *vcpu)
> +{
> +	svm_inject_nmi(vcpu);
> +}
> +
> +void kvm_x86_ops_queue_exception(struct kvm_vcpu *vcpu)
> +{
> +	svm_queue_exception(vcpu);
> +}
> +
> +void kvm_x86_ops_cancel_injection(struct kvm_vcpu *vcpu)
> +{
> +	svm_cancel_injection(vcpu);
> +}
> +
> +int kvm_x86_ops_interrupt_allowed(struct kvm_vcpu *vcpu)
> +{
> +	return svm_interrupt_allowed(vcpu);
> +}
> +
> +int kvm_x86_ops_nmi_allowed(struct kvm_vcpu *vcpu)
> +{
> +	return svm_nmi_allowed(vcpu);
> +}
> +
> +bool kvm_x86_ops_get_nmi_mask(struct kvm_vcpu *vcpu)
> +{
> +	return svm_get_nmi_mask(vcpu);
> +}
> +
> +void kvm_x86_ops_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
> +{
> +	svm_set_nmi_mask(vcpu, masked);
> +}
> +
> +void kvm_x86_ops_enable_nmi_window(struct kvm_vcpu *vcpu)
> +{
> +	enable_nmi_window(vcpu);
> +}
> +
> +void kvm_x86_ops_enable_irq_window(struct kvm_vcpu *vcpu)
> +{
> +	enable_irq_window(vcpu);
> +}
> +
> +void kvm_x86_ops_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
> +{
> +	update_cr8_intercept(vcpu, tpr, irr);
> +}
> +
> +bool kvm_x86_ops_get_enable_apicv(struct kvm_vcpu *vcpu)
> +{
> +	return svm_get_enable_apicv(vcpu);
> +}
> +
> +void kvm_x86_ops_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
> +{
> +	svm_refresh_apicv_exec_ctrl(vcpu);
> +}
> +
> +void kvm_x86_ops_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
> +{
> +	svm_hwapic_irr_update(vcpu, max_irr);
> +}
> +
> +void kvm_x86_ops_hwapic_isr_update(struct kvm_vcpu *vcpu, int isr)
> +{
> +	svm_hwapic_isr_update(vcpu, isr);
> +}
> +
> +bool kvm_x86_ops_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_x86_ops->guest_apic_has_interrupt(vcpu);
> +}
> +
> +void kvm_x86_ops_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
> +{
> +	svm_load_eoi_exitmap(vcpu, eoi_exit_bitmap);
> +}
> +
> +void kvm_x86_ops_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
> +{
> +	svm_set_virtual_apic_mode(vcpu);
> +}
> +
> +void kvm_x86_ops_set_apic_access_page_addr(struct kvm_vcpu *vcpu, hpa_t hpa)
> +{
> +	kvm_x86_ops->set_apic_access_page_addr(vcpu, hpa);
> +}
> +
> +void kvm_x86_ops_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
> +{
> +	svm_deliver_avic_intr(vcpu, vector);
> +}
> +
> +int kvm_x86_ops_sync_pir_to_irr(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_lapic_find_highest_irr(vcpu);
> +}
> +
> +int kvm_x86_ops_set_tss_addr(struct kvm *kvm, unsigned int addr)
> +{
> +	return svm_set_tss_addr(kvm, addr);
> +}
> +
> +int kvm_x86_ops_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
> +{
> +	return svm_set_identity_map_addr(kvm, ident_addr);
> +}
> +
> +int kvm_x86_ops_get_tdp_level(struct kvm_vcpu *vcpu)
> +{
> +	return get_npt_level(vcpu);
> +}
> +
> +u64 kvm_x86_ops_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> +{
> +	return svm_get_mt_mask(vcpu, gfn, is_mmio);
> +}
> +
> +int kvm_x86_ops_get_lpage_level(void)
> +{
> +	return svm_get_lpage_level();
> +}
> +
> +bool kvm_x86_ops_rdtscp_supported(void)
> +{
> +	return svm_rdtscp_supported();
> +}
> +
> +bool kvm_x86_ops_invpcid_supported(void)
> +{
> +	return svm_invpcid_supported();
> +}
> +
> +void kvm_x86_ops_set_tdp_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> +{
> +	set_tdp_cr3(vcpu, cr3);
> +}
> +
> +void kvm_x86_ops_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
> +{
> +	svm_set_supported_cpuid(func, entry);
> +}
> +
> +bool kvm_x86_ops_has_wbinvd_exit(void)
> +{
> +	return svm_has_wbinvd_exit();
> +}
> +
> +u64 kvm_x86_ops_read_l1_tsc_offset(struct kvm_vcpu *vcpu)
> +{
> +	return svm_read_l1_tsc_offset(vcpu);
> +}
> +
> +u64 kvm_x86_ops_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
> +{
> +	return svm_write_l1_tsc_offset(vcpu, offset);
> +}
> +
> +void kvm_x86_ops_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2)
> +{
> +	svm_get_exit_info(vcpu, info1, info2);
> +}
> +
> +int kvm_x86_ops_check_intercept(struct kvm_vcpu *vcpu,
> +				struct x86_instruction_info *info,
> +				enum x86_intercept_stage stage)
> +{
> +	return svm_check_intercept(vcpu, info, stage);
> +}
> +
> +void kvm_x86_ops_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> +{
> +	svm_handle_exit_irqoff(vcpu);
> +}
> +
> +bool kvm_x86_ops_mpx_supported(void)
> +{
> +	return svm_mpx_supported();
> +}
> +
> +bool kvm_x86_ops_xsaves_supported(void)
> +{
> +	return svm_xsaves_supported();
> +}
> +
> +bool kvm_x86_ops_umip_emulated(void)
> +{
> +	return svm_umip_emulated();
> +}
> +
> +bool kvm_x86_ops_pt_supported(void)
> +{
> +	return svm_pt_supported();
> +}
> +
> +int kvm_x86_ops_check_nested_events(struct kvm_vcpu *vcpu, bool external_intr)
> +{
> +	return kvm_x86_ops->check_nested_events(vcpu, external_intr);
> +}
> +
> +void kvm_x86_ops_request_immediate_exit(struct kvm_vcpu *vcpu)
> +{
> +	__kvm_request_immediate_exit(vcpu);
> +}
> +
> +void kvm_x86_ops_sched_in(struct kvm_vcpu *kvm, int cpu)
> +{
> +	svm_sched_in(kvm, cpu);
> +}
> +
> +void kvm_x86_ops_slot_enable_log_dirty(struct kvm *kvm,
> +				       struct kvm_memory_slot *slot)
> +{
> +	kvm_x86_ops->slot_enable_log_dirty(kvm, slot);
> +}
> +
> +void kvm_x86_ops_slot_disable_log_dirty(struct kvm *kvm,
> +					struct kvm_memory_slot *slot)
> +{
> +	kvm_x86_ops->slot_disable_log_dirty(kvm, slot);
> +}
> +
> +void kvm_x86_ops_flush_log_dirty(struct kvm *kvm)
> +{
> +	kvm_x86_ops->flush_log_dirty(kvm);
> +}
> +
> +void kvm_x86_ops_enable_log_dirty_pt_masked(struct kvm *kvm,
> +					    struct kvm_memory_slot *slot,
> +					    gfn_t offset, unsigned long mask)
> +{
> +	kvm_x86_ops->enable_log_dirty_pt_masked(kvm, slot, offset, mask);
> +}
> +
> +int kvm_x86_ops_write_log_dirty(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_x86_ops->write_log_dirty(vcpu);
> +}
> +
> +int kvm_x86_ops_pre_block(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_x86_ops->pre_block(vcpu);
> +}
> +
> +void kvm_x86_ops_post_block(struct kvm_vcpu *vcpu)
> +{
> +	kvm_x86_ops->post_block(vcpu);
> +}
> +
> +void kvm_x86_ops_vcpu_blocking(struct kvm_vcpu *vcpu)
> +{
> +	svm_vcpu_blocking(vcpu);
> +}
> +
> +void kvm_x86_ops_vcpu_unblocking(struct kvm_vcpu *vcpu)
> +{
> +	svm_vcpu_unblocking(vcpu);
> +}
> +
> +int kvm_x86_ops_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
> +			       uint32_t guest_irq, bool set)
> +{
> +	return svm_update_pi_irte(kvm, host_irq, guest_irq, set);
> +}
> +
> +void kvm_x86_ops_apicv_post_state_restore(struct kvm_vcpu *vcpu)
> +{
> +	avic_post_state_restore(vcpu);
> +}
> +
> +bool kvm_x86_ops_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
> +{
> +	return svm_dy_apicv_has_pending_interrupt(vcpu);
> +}
> +
> +int kvm_x86_ops_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
> +			     bool *expired)
> +{
> +	return kvm_x86_ops->set_hv_timer(vcpu, guest_deadline_tsc, expired);
> +}
> +
> +void kvm_x86_ops_cancel_hv_timer(struct kvm_vcpu *vcpu)
> +{
> +	kvm_x86_ops->cancel_hv_timer(vcpu);
> +}
> +
> +void kvm_x86_ops_setup_mce(struct kvm_vcpu *vcpu)
> +{
> +	svm_setup_mce(vcpu);
> +}
> +
> +int kvm_x86_ops_get_nested_state(struct kvm_vcpu *vcpu,
> +				 struct kvm_nested_state __user *user_kvm_nested_state,
> +				 unsigned user_data_size)
> +{
> +	return kvm_x86_ops->get_nested_state(vcpu, user_kvm_nested_state,
> +					     user_data_size);
> +}
> +
> +int kvm_x86_ops_set_nested_state(struct kvm_vcpu *vcpu,
> +				 struct kvm_nested_state __user *user_kvm_nested_state,
> +				 struct kvm_nested_state *kvm_state)
> +{
> +	return kvm_x86_ops->set_nested_state(vcpu, user_kvm_nested_state,
> +					     kvm_state);
> +}
> +
> +void kvm_x86_ops_get_vmcs12_pages(struct kvm_vcpu *vcpu)
> +{
> +	kvm_x86_ops->get_vmcs12_pages(vcpu);
> +}
> +
> +int kvm_x86_ops_smi_allowed(struct kvm_vcpu *vcpu)
> +{
> +	return svm_smi_allowed(vcpu);
> +}
> +
> +int kvm_x86_ops_pre_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
> +{
> +	return svm_pre_enter_smm(vcpu, smstate);
> +}
> +
> +int kvm_x86_ops_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
> +{
> +	return svm_pre_leave_smm(vcpu, smstate);
> +}
> +
> +int kvm_x86_ops_enable_smi_window(struct kvm_vcpu *vcpu)
> +{
> +	return enable_smi_window(vcpu);
> +}
> +
> +int kvm_x86_ops_mem_enc_op(struct kvm *kvm, void __user *argp)
> +{
> +	return svm_mem_enc_op(kvm, argp);
> +}
> +
> +int kvm_x86_ops_mem_enc_reg_region(struct kvm *kvm,
> +				   struct kvm_enc_region *argp)
> +{
> +	return svm_register_enc_region(kvm, argp);
> +}
> +
> +int kvm_x86_ops_mem_enc_unreg_region(struct kvm *kvm,
> +				     struct kvm_enc_region *argp)
> +{
> +	return svm_unregister_enc_region(kvm, argp);
> +}
> +
> +int kvm_x86_ops_get_msr_feature(struct kvm_msr_entry *entry)
> +{
> +	return svm_get_msr_feature(entry);
> +}
> +
> +int kvm_x86_ops_nested_enable_evmcs(struct kvm_vcpu *vcpu,
> +				    uint16_t *vmcs_version)
> +{
> +	return nested_enable_evmcs(vcpu, vmcs_version);
> +}
> +
> +uint16_t kvm_x86_ops_nested_get_evmcs_version(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_x86_ops->nested_get_evmcs_version(vcpu);
> +}
> +
> +bool kvm_x86_ops_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
> +{
> +	return svm_need_emulation_on_page_fault(vcpu);
> +}
> +
> +bool kvm_x86_ops_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
> +{
> +	return svm_apic_init_signal_blocked(vcpu);
> +}
> diff --git a/arch/x86/kvm/vmx/vmx_ops.c b/arch/x86/kvm/vmx/vmx_ops.c
> new file mode 100644
> index 000000000000..cdcad73935d9
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/vmx_ops.c
> @@ -0,0 +1,672 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + *  arch/x86/kvm/vmx/vmx_ops.c
> + *
> + *  Copyright 2019 Red Hat, Inc.
> + */
> +
> +__init int kvm_x86_ops_cpu_has_kvm_support(void)
> +{
> +	return cpu_has_kvm_support();
> +}
> +
> +__init int kvm_x86_ops_disabled_by_bios(void)
> +{
> +	return vmx_disabled_by_bios();
> +}
> +
> +int kvm_x86_ops_hardware_enable(void)
> +{
> +	return hardware_enable();
> +}
> +
> +void kvm_x86_ops_hardware_disable(void)
> +{
> +	hardware_disable();
> +}
> +
> +__init int kvm_x86_ops_check_processor_compatibility(void)
> +{
> +	return vmx_check_processor_compat();
> +}
> +
> +__init int kvm_x86_ops_hardware_setup(void)
> +{
> +	return hardware_setup();
> +}
> +
> +void kvm_x86_ops_hardware_unsetup(void)
> +{
> +	hardware_unsetup();
> +}
> +
> +bool kvm_x86_ops_cpu_has_accelerated_tpr(void)
> +{
> +	return report_flexpriority();
> +}
> +
> +bool kvm_x86_ops_has_emulated_msr(int index)
> +{
> +	return vmx_has_emulated_msr(index);
> +}
> +
> +void kvm_x86_ops_cpuid_update(struct kvm_vcpu *vcpu)
> +{
> +	vmx_cpuid_update(vcpu);
> +}
> +
> +struct kvm *kvm_x86_ops_vm_alloc(void)
> +{
> +	return vmx_vm_alloc();
> +}
> +
> +void kvm_x86_ops_vm_free(struct kvm *kvm)
> +{
> +	vmx_vm_free(kvm);
> +}
> +
> +int kvm_x86_ops_vm_init(struct kvm *kvm)
> +{
> +	return vmx_vm_init(kvm);
> +}
> +
> +void kvm_x86_ops_vm_destroy(struct kvm *kvm)
> +{
> +	kvm_x86_ops->vm_destroy(kvm);
> +}
> +
> +struct kvm_vcpu *kvm_x86_ops_vcpu_create(struct kvm *kvm, unsigned id)
> +{
> +	return vmx_create_vcpu(kvm, id);
> +}
> +
> +void kvm_x86_ops_vcpu_free(struct kvm_vcpu *vcpu)
> +{
> +	vmx_free_vcpu(vcpu);
> +}
> +
> +void kvm_x86_ops_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> +{
> +	vmx_vcpu_reset(vcpu, init_event);
> +}
> +
> +void kvm_x86_ops_prepare_guest_switch(struct kvm_vcpu *vcpu)
> +{
> +	vmx_prepare_switch_to_guest(vcpu);
> +}
> +
> +void kvm_x86_ops_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> +{
> +	vmx_vcpu_load(vcpu, cpu);
> +}
> +
> +void kvm_x86_ops_vcpu_put(struct kvm_vcpu *vcpu)
> +{
> +	vmx_vcpu_put(vcpu);
> +}
> +
> +void kvm_x86_ops_update_bp_intercept(struct kvm_vcpu *vcpu)
> +{
> +	update_exception_bitmap(vcpu);
> +}
> +
> +int kvm_x86_ops_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
> +{
> +	return vmx_get_msr(vcpu, msr);
> +}
> +
> +int kvm_x86_ops_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
> +{
> +	return vmx_set_msr(vcpu, msr);
> +}
> +
> +u64 kvm_x86_ops_get_segment_base(struct kvm_vcpu *vcpu, int seg)
> +{
> +	return vmx_get_segment_base(vcpu, seg);
> +}
> +
> +void kvm_x86_ops_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var,
> +			     int seg)
> +{
> +	vmx_get_segment(vcpu, var, seg);
> +}
> +
> +int kvm_x86_ops_get_cpl(struct kvm_vcpu *vcpu)
> +{
> +	return vmx_get_cpl(vcpu);
> +}
> +
> +void kvm_x86_ops_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var,
> +			     int seg)
> +{
> +	vmx_set_segment(vcpu, var, seg);
> +}
> +
> +void kvm_x86_ops_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
> +{
> +	vmx_get_cs_db_l_bits(vcpu, db, l);
> +}
> +
> +void kvm_x86_ops_decache_cr0_guest_bits(struct kvm_vcpu *vcpu)
> +{
> +	vmx_decache_cr0_guest_bits(vcpu);
> +}
> +
> +void kvm_x86_ops_decache_cr3(struct kvm_vcpu *vcpu)
> +{
> +	vmx_decache_cr3(vcpu);
> +}
> +
> +void kvm_x86_ops_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
> +{
> +	vmx_decache_cr4_guest_bits(vcpu);
> +}
> +
> +void kvm_x86_ops_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
> +{
> +	vmx_set_cr0(vcpu, cr0);
> +}
> +
> +void kvm_x86_ops_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> +{
> +	vmx_set_cr3(vcpu, cr3);
> +}
> +
> +int kvm_x86_ops_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> +{
> +	return vmx_set_cr4(vcpu, cr4);
> +}
> +
> +void kvm_x86_ops_set_efer(struct kvm_vcpu *vcpu, u64 efer)
> +{
> +	vmx_set_efer(vcpu, efer);
> +}
> +
> +void kvm_x86_ops_get_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
> +{
> +	vmx_get_idt(vcpu, dt);
> +}
> +
> +void kvm_x86_ops_set_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
> +{
> +	vmx_set_idt(vcpu, dt);
> +}
> +
> +void kvm_x86_ops_get_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
> +{
> +	vmx_get_gdt(vcpu, dt);
> +}
> +
> +void kvm_x86_ops_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
> +{
> +	vmx_set_gdt(vcpu, dt);
> +}
> +
> +u64 kvm_x86_ops_get_dr6(struct kvm_vcpu *vcpu)
> +{
> +	return vmx_get_dr6(vcpu);
> +}
> +
> +void kvm_x86_ops_set_dr6(struct kvm_vcpu *vcpu, unsigned long value)
> +{
> +	vmx_set_dr6(vcpu, value);
> +}
> +
> +void kvm_x86_ops_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
> +{
> +	vmx_sync_dirty_debug_regs(vcpu);
> +}
> +
> +void kvm_x86_ops_set_dr7(struct kvm_vcpu *vcpu, unsigned long value)
> +{
> +	vmx_set_dr7(vcpu, value);
> +}
> +
> +void kvm_x86_ops_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
> +{
> +	vmx_cache_reg(vcpu, reg);
> +}
> +
> +unsigned long kvm_x86_ops_get_rflags(struct kvm_vcpu *vcpu)
> +{
> +	return vmx_get_rflags(vcpu);
> +}
> +
> +void kvm_x86_ops_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
> +{
> +	vmx_set_rflags(vcpu, rflags);
> +}
> +
> +void kvm_x86_ops_tlb_flush(struct kvm_vcpu *vcpu, bool invalidate_gpa)
> +{
> +	vmx_flush_tlb(vcpu, invalidate_gpa);
> +}
> +
> +int kvm_x86_ops_tlb_remote_flush(struct kvm *kvm)
> +{
> +	return kvm_x86_ops->tlb_remote_flush(kvm);
> +}
> +
> +int kvm_x86_ops_tlb_remote_flush_with_range(struct kvm *kvm,
> +					    struct kvm_tlb_range *range)
> +{
> +	return kvm_x86_ops->tlb_remote_flush_with_range(kvm, range);
> +}
> +
> +void kvm_x86_ops_tlb_flush_gva(struct kvm_vcpu *vcpu, gva_t addr)
> +{
> +	vmx_flush_tlb_gva(vcpu, addr);
> +}
> +
> +void kvm_x86_ops_run(struct kvm_vcpu *vcpu)
> +{
> +	vmx_vcpu_run(vcpu);
> +}
> +
> +int kvm_x86_ops_handle_exit(struct kvm_vcpu *vcpu)
> +{
> +	return vmx_handle_exit(vcpu);
> +}
> +
> +int kvm_x86_ops_skip_emulated_instruction(struct kvm_vcpu *vcpu)
> +{
> +	return __skip_emulated_instruction(vcpu);
> +}
> +
> +void kvm_x86_ops_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
> +{
> +	vmx_set_interrupt_shadow(vcpu, mask);
> +}
> +
> +u32 kvm_x86_ops_get_interrupt_shadow(struct kvm_vcpu *vcpu)
> +{
> +	return vmx_get_interrupt_shadow(vcpu);
> +}
> +
> +void kvm_x86_ops_patch_hypercall(struct kvm_vcpu *vcpu,
> +				 unsigned char *hypercall_addr)
> +{
> +	vmx_patch_hypercall(vcpu, hypercall_addr);
> +}
> +
> +void kvm_x86_ops_set_irq(struct kvm_vcpu *vcpu)
> +{
> +	vmx_inject_irq(vcpu);
> +}
> +
> +void kvm_x86_ops_set_nmi(struct kvm_vcpu *vcpu)
> +{
> +	vmx_inject_nmi(vcpu);
> +}
> +
> +void kvm_x86_ops_queue_exception(struct kvm_vcpu *vcpu)
> +{
> +	vmx_queue_exception(vcpu);
> +}
> +
> +void kvm_x86_ops_cancel_injection(struct kvm_vcpu *vcpu)
> +{
> +	vmx_cancel_injection(vcpu);
> +}
> +
> +int kvm_x86_ops_interrupt_allowed(struct kvm_vcpu *vcpu)
> +{
> +	return vmx_interrupt_allowed(vcpu);
> +}
> +
> +int kvm_x86_ops_nmi_allowed(struct kvm_vcpu *vcpu)
> +{
> +	return vmx_nmi_allowed(vcpu);
> +}
> +
> +bool kvm_x86_ops_get_nmi_mask(struct kvm_vcpu *vcpu)
> +{
> +	return vmx_get_nmi_mask(vcpu);
> +}
> +
> +void kvm_x86_ops_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
> +{
> +	vmx_set_nmi_mask(vcpu, masked);
> +}
> +
> +void kvm_x86_ops_enable_nmi_window(struct kvm_vcpu *vcpu)
> +{
> +	enable_nmi_window(vcpu);
> +}
> +
> +void kvm_x86_ops_enable_irq_window(struct kvm_vcpu *vcpu)
> +{
> +	enable_irq_window(vcpu);
> +}
> +
> +void kvm_x86_ops_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
> +{
> +	update_cr8_intercept(vcpu, tpr, irr);
> +}
> +
> +bool kvm_x86_ops_get_enable_apicv(struct kvm_vcpu *vcpu)
> +{
> +	return vmx_get_enable_apicv(vcpu);
> +}
> +
> +void kvm_x86_ops_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
> +{
> +	vmx_refresh_apicv_exec_ctrl(vcpu);
> +}
> +
> +void kvm_x86_ops_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
> +{
> +	vmx_hwapic_irr_update(vcpu, max_irr);
> +}
> +
> +void kvm_x86_ops_hwapic_isr_update(struct kvm_vcpu *vcpu, int isr)
> +{
> +	vmx_hwapic_isr_update(vcpu, isr);
> +}
> +
> +bool kvm_x86_ops_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
> +{
> +	return vmx_guest_apic_has_interrupt(vcpu);
> +}
> +
> +void kvm_x86_ops_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
> +{
> +	vmx_load_eoi_exitmap(vcpu, eoi_exit_bitmap);
> +}
> +
> +void kvm_x86_ops_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
> +{
> +	vmx_set_virtual_apic_mode(vcpu);
> +}
> +
> +void kvm_x86_ops_set_apic_access_page_addr(struct kvm_vcpu *vcpu, hpa_t hpa)
> +{
> +	vmx_set_apic_access_page_addr(vcpu, hpa);
> +}
> +
> +void kvm_x86_ops_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
> +{
> +	vmx_deliver_posted_interrupt(vcpu, vector);
> +}
> +
> +int kvm_x86_ops_sync_pir_to_irr(struct kvm_vcpu *vcpu)
> +{
> +	return vmx_sync_pir_to_irr(vcpu);
> +}
> +
> +int kvm_x86_ops_set_tss_addr(struct kvm *kvm, unsigned int addr)
> +{
> +	return vmx_set_tss_addr(kvm, addr);
> +}
> +
> +int kvm_x86_ops_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
> +{
> +	return vmx_set_identity_map_addr(kvm, ident_addr);
> +}
> +
> +int kvm_x86_ops_get_tdp_level(struct kvm_vcpu *vcpu)
> +{
> +	return get_ept_level(vcpu);
> +}
> +
> +u64 kvm_x86_ops_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> +{
> +	return vmx_get_mt_mask(vcpu, gfn, is_mmio);
> +}
> +
> +int kvm_x86_ops_get_lpage_level(void)
> +{
> +	return vmx_get_lpage_level();
> +}
> +
> +bool kvm_x86_ops_rdtscp_supported(void)
> +{
> +	return vmx_rdtscp_supported();
> +}
> +
> +bool kvm_x86_ops_invpcid_supported(void)
> +{
> +	return vmx_invpcid_supported();
> +}
> +
> +void kvm_x86_ops_set_tdp_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> +{
> +	vmx_set_cr3(vcpu, cr3);
> +}
> +
> +void kvm_x86_ops_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
> +{
> +	vmx_set_supported_cpuid(func, entry);
> +}
> +
> +bool kvm_x86_ops_has_wbinvd_exit(void)
> +{
> +	return cpu_has_vmx_wbinvd_exit();
> +}
> +
> +u64 kvm_x86_ops_read_l1_tsc_offset(struct kvm_vcpu *vcpu)
> +{
> +	return vmx_read_l1_tsc_offset(vcpu);
> +}
> +
> +u64 kvm_x86_ops_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
> +{
> +	return vmx_write_l1_tsc_offset(vcpu, offset);
> +}
> +
> +void kvm_x86_ops_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2)
> +{
> +	vmx_get_exit_info(vcpu, info1, info2);
> +}
> +
> +int kvm_x86_ops_check_intercept(struct kvm_vcpu *vcpu,
> +				struct x86_instruction_info *info,
> +				enum x86_intercept_stage stage)
> +{
> +	return vmx_check_intercept(vcpu, info, stage);
> +}
> +
> +void kvm_x86_ops_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> +{
> +	vmx_handle_exit_irqoff(vcpu);
> +}
> +
> +bool kvm_x86_ops_mpx_supported(void)
> +{
> +	return vmx_mpx_supported();
> +}
> +
> +bool kvm_x86_ops_xsaves_supported(void)
> +{
> +	return vmx_xsaves_supported();
> +}
> +
> +bool kvm_x86_ops_umip_emulated(void)
> +{
> +	return vmx_umip_emulated();
> +}
> +
> +bool kvm_x86_ops_pt_supported(void)
> +{
> +	return vmx_pt_supported();
> +}
> +
> +int kvm_x86_ops_check_nested_events(struct kvm_vcpu *vcpu, bool external_intr)
> +{
> +	return kvm_x86_ops->check_nested_events(vcpu, external_intr);
> +}
> +
> +void kvm_x86_ops_request_immediate_exit(struct kvm_vcpu *vcpu)
> +{
> +	vmx_request_immediate_exit(vcpu);
> +}
> +
> +void kvm_x86_ops_sched_in(struct kvm_vcpu *kvm, int cpu)
> +{
> +	vmx_sched_in(kvm, cpu);
> +}
> +
> +void kvm_x86_ops_slot_enable_log_dirty(struct kvm *kvm,
> +				       struct kvm_memory_slot *slot)
> +{
> +	vmx_slot_enable_log_dirty(kvm, slot);
> +}
> +
> +void kvm_x86_ops_slot_disable_log_dirty(struct kvm *kvm,
> +					struct kvm_memory_slot *slot)
> +{
> +	vmx_slot_disable_log_dirty(kvm, slot);
> +}
> +
> +void kvm_x86_ops_flush_log_dirty(struct kvm *kvm)
> +{
> +	vmx_flush_log_dirty(kvm);
> +}
> +
> +void kvm_x86_ops_enable_log_dirty_pt_masked(struct kvm *kvm,
> +					    struct kvm_memory_slot *slot,
> +					    gfn_t offset, unsigned long mask)
> +{
> +	vmx_enable_log_dirty_pt_masked(kvm, slot, offset, mask);
> +}
> +
> +int kvm_x86_ops_write_log_dirty(struct kvm_vcpu *vcpu)
> +{
> +	return vmx_write_pml_buffer(vcpu);
> +}
> +
> +int kvm_x86_ops_pre_block(struct kvm_vcpu *vcpu)
> +{
> +	return vmx_pre_block(vcpu);
> +}
> +
> +void kvm_x86_ops_post_block(struct kvm_vcpu *vcpu)
> +{
> +	vmx_post_block(vcpu);
> +}
> +
> +void kvm_x86_ops_vcpu_blocking(struct kvm_vcpu *vcpu)
> +{
> +	kvm_x86_ops->vcpu_blocking(vcpu);
> +}
> +
> +void kvm_x86_ops_vcpu_unblocking(struct kvm_vcpu *vcpu)
> +{
> +	kvm_x86_ops->vcpu_unblocking(vcpu);
> +}
> +
> +int kvm_x86_ops_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
> +			       uint32_t guest_irq, bool set)
> +{
> +	return vmx_update_pi_irte(kvm, host_irq, guest_irq, set);
> +}
> +
> +void kvm_x86_ops_apicv_post_state_restore(struct kvm_vcpu *vcpu)
> +{
> +	vmx_apicv_post_state_restore(vcpu);
> +}
> +
> +bool kvm_x86_ops_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
> +{
> +	return vmx_dy_apicv_has_pending_interrupt(vcpu);
> +}
> +
> +int kvm_x86_ops_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
> +			     bool *expired)
> +{
> +	return vmx_set_hv_timer(vcpu, guest_deadline_tsc, expired);
> +}
> +
> +void kvm_x86_ops_cancel_hv_timer(struct kvm_vcpu *vcpu)
> +{
> +	vmx_cancel_hv_timer(vcpu);
> +}
> +
> +void kvm_x86_ops_setup_mce(struct kvm_vcpu *vcpu)
> +{
> +	vmx_setup_mce(vcpu);
> +}
> +
> +int kvm_x86_ops_get_nested_state(struct kvm_vcpu *vcpu,
> +				 struct kvm_nested_state __user *user_kvm_nested_state,
> +				 unsigned user_data_size)
> +{
> +	return kvm_x86_ops->get_nested_state(vcpu, user_kvm_nested_state,
> +					     user_data_size);
> +}
> +
> +int kvm_x86_ops_set_nested_state(struct kvm_vcpu *vcpu,
> +				 struct kvm_nested_state __user *user_kvm_nested_state,
> +				 struct kvm_nested_state *kvm_state)
> +{
> +	return kvm_x86_ops->set_nested_state(vcpu, user_kvm_nested_state,
> +					     kvm_state);
> +}
> +
> +void kvm_x86_ops_get_vmcs12_pages(struct kvm_vcpu *vcpu)
> +{
> +	kvm_x86_ops->get_vmcs12_pages(vcpu);
> +}
> +
> +int kvm_x86_ops_smi_allowed(struct kvm_vcpu *vcpu)
> +{
> +	return vmx_smi_allowed(vcpu);
> +}
> +
> +int kvm_x86_ops_pre_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
> +{
> +	return vmx_pre_enter_smm(vcpu, smstate);
> +}
> +
> +int kvm_x86_ops_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
> +{
> +	return vmx_pre_leave_smm(vcpu, smstate);
> +}
> +
> +int kvm_x86_ops_enable_smi_window(struct kvm_vcpu *vcpu)
> +{
> +	return enable_smi_window(vcpu);
> +}
> +
> +int kvm_x86_ops_mem_enc_op(struct kvm *kvm, void __user *argp)
> +{
> +	return kvm_x86_ops->mem_enc_op(kvm, argp);
> +}
> +
> +int kvm_x86_ops_mem_enc_reg_region(struct kvm *kvm,
> +				   struct kvm_enc_region *argp)
> +{
> +	return kvm_x86_ops->mem_enc_reg_region(kvm, argp);
> +}
> +
> +int kvm_x86_ops_mem_enc_unreg_region(struct kvm *kvm,
> +				     struct kvm_enc_region *argp)
> +{
> +	return kvm_x86_ops->mem_enc_unreg_region(kvm, argp);
> +}
> +
> +int kvm_x86_ops_get_msr_feature(struct kvm_msr_entry *entry)
> +{
> +	return vmx_get_msr_feature(entry);
> +}
> +
> +int kvm_x86_ops_nested_enable_evmcs(struct kvm_vcpu *vcpu,
> +				    uint16_t *vmcs_version)
> +{
> +	return kvm_x86_ops->nested_enable_evmcs(vcpu, vmcs_version);
> +}
> +
> +uint16_t kvm_x86_ops_nested_get_evmcs_version(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_x86_ops->nested_get_evmcs_version(vcpu);
> +}
> +
> +bool kvm_x86_ops_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
> +{
> +	return vmx_need_emulation_on_page_fault(vcpu);
> +}
> +
> +bool kvm_x86_ops_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
> +{
> +	return vmx_apic_init_signal_blocked(vcpu);
> +}
> 

