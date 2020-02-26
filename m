Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5344F1706E3
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 19:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgBZSBc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 13:01:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25423 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726688AbgBZSBb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 13:01:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582740090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+j9PbT5QAZpP/mItAsMzoO98L8Enk3oE2QSK5MgUDSA=;
        b=V6azUqV8kb4NhKvTUg3jFInarGDShWPL63njljKqKuk855219GOUyz5ZuZtnwihQx0MoxJ
        gih1YVciQQLE0h+YAYmOhB1zvN/ubCI7BwI4c+s3kLEwnYgcXBnJFRspAlI3Otsbp9kh54
        kp1LoehN+J2Tlv+SUtOPOhEDLTWfTpo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-PRYg-u1gMFWPb99NMb0z8w-1; Wed, 26 Feb 2020 13:01:28 -0500
X-MC-Unique: PRYg-u1gMFWPb99NMb0z8w-1
Received: by mail-wr1-f70.google.com with SMTP id o9so91082wrw.14
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 10:01:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=+j9PbT5QAZpP/mItAsMzoO98L8Enk3oE2QSK5MgUDSA=;
        b=cZQz3oK0kGhBG/Jo2Dfx+uyB1pHg9U1X5uEOCnGbhtap8UZGkglarOUUlIeDzYdCXt
         rcaHhSmw8soqlPA+cxI+NGoMDrbHOlzKDMMSC1e7k6b91CMVVRnit04tPD2WOW40LdXm
         0eTalRHJ5AN3UoGv0S4sOq8Clrq3Ahsl5NYUa3AfugNHEMJnSphi2zJThzqlgfYbYdxB
         TvtSAafrOIMGqa1wLJNI6cKjbyICx3dqPb7vlNqocC8l9SLInKq4vr4UaBwNdmffD7LG
         dl+pKlvWNLMCD1PPg0sPynTiS0Pbm/l8cqz05RxyGqJXlPiI+W6geIzTZr/hHe7dTiP6
         k5Wg==
X-Gm-Message-State: APjAAAUs350sIiGz5r95EdmqbkIMZ3/D1MCn31RuP1SqYxfR2teK0eKr
        w237I3zpGkzM69ONNB8QAVqQx2/U81kSX31RXGax7Zx3pLkG2DDc4HmvYsZ5vmtVAsURPtN5vfR
        kUieQfzkchxZS
X-Received: by 2002:a5d:6411:: with SMTP id z17mr7070226wru.57.1582740087571;
        Wed, 26 Feb 2020 10:01:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqwI/tB5gPzUUtrLtMjPQZmicXa9lh8ssIM/ynrqM2BBE3oMo3Yidd0H5ZVKOIFp8Q1j1UU+fw==
X-Received: by 2002:a5d:6411:: with SMTP id z17mr7070191wru.57.1582740087215;
        Wed, 26 Feb 2020 10:01:27 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id b82sm3669800wmb.16.2020.02.26.10.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 10:01:26 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 12/13] KVM: x86: Add variable to control existence of emulator
In-Reply-To: <20200218232953.5724-13-sean.j.christopherson@intel.com>
References: <20200218232953.5724-1-sean.j.christopherson@intel.com> <20200218232953.5724-13-sean.j.christopherson@intel.com>
Date:   Wed, 26 Feb 2020 19:01:25 +0100
Message-ID: <87lfopi5xm.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Add a global variable to control whether or not the emulator is enabled,
> and make all necessary changes to gracefully handle reaching emulation
> paths with the emulator disabled.
>
> Running with VMX's unrestricted guest disabled requires special
> consideration due to its use of kvm_inject_realmode_interrupt().  When
> unrestricted guest is disabled, KVM emulates interrupts and exceptions
> when the processor is in real mode, but does so without going through
> the standard emulator loop.  Ideally, kvm_inject_realmode_interrupt()
> would only log the interrupt and defer actual emulation to the standard
> run loop, but that is a non-trivial change and a waste of resources
> given that unrestricted guest is supported on all CPUs shipped within
> the last decade.  Similarly, dirtying up the event injection stack for
> such a legacy feature is undesirable.  To avoid the conundrum, prevent
> disabling both the emulator and unrestricted guest.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/svm.c              |  2 +-
>  arch/x86/kvm/vmx/vmx.c          |  7 ++++++-
>  arch/x86/kvm/x86.c              | 18 +++++++++++++++---
>  4 files changed, 23 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 0dfe11f30d7f..c4baac32a291 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1050,7 +1050,7 @@ struct kvm_x86_ops {
>  	int (*hardware_enable)(void);
>  	void (*hardware_disable)(void);
>  	int (*check_processor_compatibility)(void);/* __init */
> -	int (*hardware_setup)(void);               /* __init */
> +	int (*hardware_setup)(bool enable_emulator); /* __init */
>  	void (*hardware_unsetup)(void);            /* __exit */
>  	bool (*cpu_has_accelerated_tpr)(void);
>  	bool (*has_emulated_msr)(int index);
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index ae62ea454158..810139b3bfe4 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1350,7 +1350,7 @@ static __init void svm_adjust_mmio_mask(void)
>  	kvm_mmu_set_mmio_spte_mask(mask, mask, PT_WRITABLE_MASK | PT_USER_MASK);
>  }
>  
> -static __init int svm_hardware_setup(void)
> +static __init int svm_hardware_setup(bool enable_emulator)
>  {
>  	int cpu;
>  	struct page *iopm_pages;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 09bb0d98afeb..e05d36f63b73 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7548,7 +7548,7 @@ static bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
>  	return to_vmx(vcpu)->nested.vmxon;
>  }
>  
> -static __init int hardware_setup(void)
> +static __init int hardware_setup(bool enable_emulator)
>  {
>  	unsigned long host_bndcfgs;
>  	struct desc_ptr dt;
> @@ -7595,6 +7595,11 @@ static __init int hardware_setup(void)
>  	if (!cpu_has_virtual_nmis())
>  		enable_vnmi = 0;
>  
> +	if (!enable_emulator && !enable_unrestricted_guest) {
> +		pr_warn("kvm: unrestricted guest disabled, emulator must be enabled\n");
> +		return -EIO;
> +	}
> +
>  	/*
>  	 * set_apic_access_page_addr() is used to reload apic access
>  	 * page upon invalidation.  No need to do anything if not
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7bffdc6f9e1b..f9134e1104c2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -159,6 +159,8 @@ EXPORT_SYMBOL_GPL(enable_vmware_backdoor);
>  static bool __read_mostly force_emulation_prefix = false;
>  module_param(force_emulation_prefix, bool, S_IRUGO);
>  
> +static const bool enable_emulator = true;
> +
>  int __read_mostly pi_inject_timer = -1;
>  module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
>  
> @@ -6474,6 +6476,9 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
>  	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
>  	int ret;
>  
> +	if (WARN_ON_ONCE(!ctxt))
> +		return;
> +
>  	init_emulate_ctxt(ctxt);
>  
>  	ctxt->op_bytes = 2;
> @@ -6791,6 +6796,9 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  	bool writeback = true;
>  	bool write_fault_to_spt = vcpu->arch.write_fault_to_shadow_pgtable;
>  
> +	if (!ctxt)
> +		return internal_emulation_error(vcpu);
> +
>  	vcpu->arch.l1tf_flush_l1d = true;
>  
>  	/*
> @@ -8785,7 +8793,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>  
>  static void __get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
>  {
> -	if (vcpu->arch.emulate_regs_need_sync_to_vcpu) {
> +	if (vcpu->arch.emulate_regs_need_sync_to_vcpu &&
> +	    !(WARN_ON_ONCE(!vcpu->arch.emulate_ctxt))) {
>  		/*
>  		 * We are here if userspace calls get_regs() in the middle of
>  		 * instruction emulation. Registers state needs to be copied
> @@ -8982,6 +8991,9 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
>  	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
>  	int ret;
>  
> +	if (!ctxt)
> +		return internal_emulation_error(vcpu);
> +
>  	init_emulate_ctxt(ctxt);
>  
>  	ret = emulator_task_switch(ctxt, tss_selector, idt_index, reason,
> @@ -9345,7 +9357,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  				GFP_KERNEL_ACCOUNT))
>  		goto fail_free_mce_banks;
>  
> -	if (!alloc_emulate_ctxt(vcpu))
> +	if (enable_emulator && !alloc_emulate_ctxt(vcpu))
>  		goto free_wbinvd_dirty_mask;
>  
>  	vcpu->arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
> @@ -9651,7 +9663,7 @@ int kvm_arch_hardware_setup(void)
>  {
>  	int r;
>  
> -	r = kvm_x86_ops->hardware_setup();
> +	r = kvm_x86_ops->hardware_setup(enable_emulator);
>  	if (r != 0)
>  		return r;

I'm not sure that emulator disablement should _only_ be a global
varaiable, i.e. why can't we do it for some VMs and allow for others?
(we can even run different userspaces for different needs). This,
however, is complementary.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

(I hope we have some userspaces which are already onboard)

-- 
Vitaly

