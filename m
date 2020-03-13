Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3ACF1848B2
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 15:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgCMOCW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 10:02:22 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35199 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726729AbgCMOCW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Mar 2020 10:02:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584108141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3i7hBK/HmnhrILaRr2C1Odzb1IOSSspXK3muq9nJqKM=;
        b=I4Tk5SDyVv6zq5+lKl17kNO7Nv8QEix8O3lpbHDNTwUfHURmLBp10Zw36i7ImV/kg6FPrV
        02wj9Mfi3YQVTVKP6iR9HepHo4MB08p/QMSqQV/N1+sE8L1uJ0JXozFJWlEfaCRZ31uw5X
        XeZlHJtivspZtCuTR/67HdfP5dz8bxY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-nNY5EARsOZmBHBjbu_wHXQ-1; Fri, 13 Mar 2020 10:02:19 -0400
X-MC-Unique: nNY5EARsOZmBHBjbu_wHXQ-1
Received: by mail-wr1-f72.google.com with SMTP id t4so1357021wrv.9
        for <kvm@vger.kernel.org>; Fri, 13 Mar 2020 07:02:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=3i7hBK/HmnhrILaRr2C1Odzb1IOSSspXK3muq9nJqKM=;
        b=rDwz06sgQfkbM06Qg9F2Daj+9Wbf8u/FIJwCkwVEipqqPtoH3Mk8hdQd3/fnRexa3B
         eTgKXik9GbdN81m3i8JjRcEtgBdLNfwAfY+EV0f7yUQLkB9RVo4VdiUw+BOEcnyPQ92y
         SdbFshN6XelkRWGou2wc/k5KYPEfFrl1WjLREaXUXpN9QBPe1rpUTuw01xhroSQSeuWx
         /BuARMmzobN9nLC9WDkDzvkXnsqHVwEmfmwGPclMY9J/qj7n5haQmoP2hfsouzw7NB2L
         epOdLyvtZ4+YoogaZCPYacOWZRFiS9UdJ/sBei2SR870eHgx7lp5/GtDhFaD8G1SHupx
         akJw==
X-Gm-Message-State: ANhLgQ3ZruMZyFKP9YJUDosnJ3IIozyGtumLyUSmyJ0dbugIuT/3xc0f
        MlUBFVenmE9Dn/m+mJMS5sC3KgXVHMvikjMuucmwctsmN2PFUNBsZym2YsvouO+j0rvi1pF3fc8
        qKc5e3T3Z1Wit
X-Received: by 2002:a7b:c5da:: with SMTP id n26mr10667917wmk.138.1584108138406;
        Fri, 13 Mar 2020 07:02:18 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vs+hDDOrm44+SR+aBz6r8AgrG8mz8l1qzVsX9PfsqZEyl51N/a1cTIyusInSsiP03l9NBZtNA==
X-Received: by 2002:a7b:c5da:: with SMTP id n26mr10667891wmk.138.1584108138098;
        Fri, 13 Mar 2020 07:02:18 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id f15sm16977174wmj.25.2020.03.13.07.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 07:02:15 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH 08/10] KVM: nVMX: Rename exit_reason to vm_exit_reason for nested VM-Exit
In-Reply-To: <20200312184521.24579-9-sean.j.christopherson@intel.com>
References: <20200312184521.24579-1-sean.j.christopherson@intel.com> <20200312184521.24579-9-sean.j.christopherson@intel.com>
Date:   Fri, 13 Mar 2020 15:01:55 +0100
Message-ID: <87k13onyjw.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Use "vm_exit_reason" when passing around the full exit reason for nested
> VM-Exits to make it clear that it's not just the basic exit reason.  The
> basic exit reason (bits 15:0 of vmcs.VM_EXIT_REASON) is colloquially
> referred to as simply "exit reason", e.g. vmx_handle_vmexit() tracks the
> basic exit reason in a local variable named "exit_reason".
>

Would it make sense to stop using 'exit_reason' without a prefix (full,
basic,...) completely?

> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 29 +++++++++++++++--------------
>  arch/x86/kvm/vmx/nested.h |  2 +-
>  2 files changed, 16 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 86b12a2918c5..c775feca3eb0 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -328,19 +328,19 @@ static void nested_ept_inject_page_fault(struct kvm_vcpu *vcpu,
>  {
>  	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -	u32 exit_reason;
> +	u32 vm_exit_reason;
>  	unsigned long exit_qualification = vcpu->arch.exit_qualification;
>  
>  	if (vmx->nested.pml_full) {
> -		exit_reason = EXIT_REASON_PML_FULL;
> +		vm_exit_reason = EXIT_REASON_PML_FULL;
>  		vmx->nested.pml_full = false;
>  		exit_qualification &= INTR_INFO_UNBLOCK_NMI;
>  	} else if (fault->error_code & PFERR_RSVD_MASK)
> -		exit_reason = EXIT_REASON_EPT_MISCONFIG;
> +		vm_exit_reason = EXIT_REASON_EPT_MISCONFIG;
>  	else
> -		exit_reason = EXIT_REASON_EPT_VIOLATION;
> +		vm_exit_reason = EXIT_REASON_EPT_VIOLATION;
>  
> -	nested_vmx_vmexit(vcpu, exit_reason, 0, exit_qualification);
> +	nested_vmx_vmexit(vcpu, vm_exit_reason, 0, exit_qualification);
>  	vmcs12->guest_physical_address = fault->address;
>  }
>  
> @@ -3919,11 +3919,11 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
>   * which already writes to vmcs12 directly.
>   */
>  static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
> -			   u32 exit_reason, u32 exit_intr_info,
> +			   u32 vm_exit_reason, u32 exit_intr_info,
>  			   unsigned long exit_qualification)
>  {
>  	/* update exit information fields: */
> -	vmcs12->vm_exit_reason = exit_reason;
> +	vmcs12->vm_exit_reason = vm_exit_reason;
>  	vmcs12->exit_qualification = exit_qualification;
>  	vmcs12->vm_exit_intr_info = exit_intr_info;
>  
> @@ -4252,7 +4252,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
>   * and modify vmcs12 to make it see what it would expect to see there if
>   * L2 was its real guest. Must only be called when in L2 (is_guest_mode())
>   */
> -void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
> +void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
>  		       u32 exit_intr_info, unsigned long exit_qualification)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -4272,9 +4272,9 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
>  	if (likely(!vmx->fail)) {
>  		sync_vmcs02_to_vmcs12(vcpu, vmcs12);
>  
> -		if (exit_reason != -1)
> -			prepare_vmcs12(vcpu, vmcs12, exit_reason, exit_intr_info,
> -				       exit_qualification);
> +		if (vm_exit_reason != -1)
> +			prepare_vmcs12(vcpu, vmcs12, vm_exit_reason,
> +				       exit_intr_info, exit_qualification);
>  
>  		/*
>  		 * Must happen outside of sync_vmcs02_to_vmcs12() as it will
> @@ -4330,14 +4330,15 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
>  	 */
>  	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
>  
> -	if ((exit_reason != -1) && (enable_shadow_vmcs || vmx->nested.hv_evmcs))
> +	if ((vm_exit_reason != -1) &&
> +	    (enable_shadow_vmcs || vmx->nested.hv_evmcs))
>  		vmx->nested.need_vmcs12_to_shadow_sync = true;
>  
>  	/* in case we halted in L2 */
>  	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
>  
>  	if (likely(!vmx->fail)) {
> -		if ((u16)exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT &&
> +		if ((u16)vm_exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT &&
>  		    nested_exit_intr_ack_set(vcpu)) {
>  			int irq = kvm_cpu_get_interrupt(vcpu);
>  			WARN_ON(irq < 0);
> @@ -4345,7 +4346,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
>  				INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR;
>  		}
>  
> -		if (exit_reason != -1)
> +		if (vm_exit_reason != -1)
>  			trace_kvm_nested_vmexit_inject(vmcs12->vm_exit_reason,
>  						       vmcs12->exit_qualification,
>  						       vmcs12->idt_vectoring_info_field,
> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> index 569cb828b6ca..04584bcbcc8d 100644
> --- a/arch/x86/kvm/vmx/nested.h
> +++ b/arch/x86/kvm/vmx/nested.h
> @@ -25,7 +25,7 @@ void nested_vmx_free_vcpu(struct kvm_vcpu *vcpu);
>  enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>  						     bool from_vmentry);
>  bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu);
> -void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
> +void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
>  		       u32 exit_intr_info, unsigned long exit_qualification);
>  void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu);
>  int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);

Reviewded-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

