Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4131AB961
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 09:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438382AbgDPHIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 03:08:50 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44804 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2438012AbgDPHIq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 03:08:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587020923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dz5gDB85aL6/zikZdtE8CeS2U/5bGoLuqgszWpif83o=;
        b=BHwYbtpBvEojDGM+w11ytCAe26xxqw7X0QiSIihJ6PNKSxKRConmqEXj70N2XAm1QBpHo7
        7GRItik1UqlaohaEeUgk4X5+K9MQzGbk13q0+M4YI+kPP2sLPekcxbJSKARWlfwfW2HrZH
        UoDwxHK1w+43tsRQdZUOq9LgUg1nFmQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-COc1uACBM2GcQoQp5EczVQ-1; Thu, 16 Apr 2020 03:08:42 -0400
X-MC-Unique: COc1uACBM2GcQoQp5EczVQ-1
Received: by mail-wr1-f69.google.com with SMTP id d17so1227701wrr.17
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 00:08:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=dz5gDB85aL6/zikZdtE8CeS2U/5bGoLuqgszWpif83o=;
        b=uFH5OaYfuzd/SOD1HilV9ayabceQV0PJxU3kFU1i1RyZzv1c+02mlh63zfKS9spu67
         fDwWGVU/pncAMqd9sVloFZiZKgahtU3VDLBPtAXYckWHor8LxjOv1EHlYV95p8k4jyjC
         02uTXXvLQGgESBtj7H7ZN2YfcKcnA0gFmFvOWFPwnHq9wKVfgMrA6xXqSvmtqdQOoMEJ
         CLD0ojeZgsFtC0J//o6n3F58pcHHVaJXbXYehx43XqnHaD0znoQYg0auz7GjNzH+wA5J
         XTmVBgDvXdElD2cPV8R7gTPpKjC2iqFbGefjQLjqgS4HJ+pjQNZLx6zorUmoquYKKoKA
         8x8Q==
X-Gm-Message-State: AGi0PubO3KKqaqKeGKaFZZHwHHijTxqFKC8avJVyvquGV4FhRckIqPFn
        9oiHGrEw78IbfamYsPsH8/MmjS08cpy02eInJvLMRjd0G8/1O5TBJ0+qr47EmJkGqYwyHDKK79z
        5/L/1nDo4YZlt
X-Received: by 2002:adf:ef51:: with SMTP id c17mr32541724wrp.130.1587020921251;
        Thu, 16 Apr 2020 00:08:41 -0700 (PDT)
X-Google-Smtp-Source: APiQypLSrkKxuB2KgvVe6MGFWbyAiUMyD0TSD9MLc2Abj5XzVplapMobkGguZokaHGBCI+E+EoXkbg==
X-Received: by 2002:adf:ef51:: with SMTP id c17mr32541674wrp.130.1587020920667;
        Thu, 16 Apr 2020 00:08:40 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id n124sm2497847wma.11.2020.04.16.00.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 00:08:40 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: nVMX: Remove non-functional "support" for CR3 target values
In-Reply-To: <20200416000739.9012-1-sean.j.christopherson@intel.com>
References: <20200416000739.9012-1-sean.j.christopherson@intel.com>
Date:   Thu, 16 Apr 2020 09:08:38 +0200
Message-ID: <875zdzx5zd.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Remove all references to cr3_target_value[0-3] and replace the fields
> in vmcs12 with "dead_space" to preserve the vmcs12 layout.  KVM doesn't
> support emulating CR3-target values, despite a variety of code that
> implies otherwise, as KVM unconditionally reports '0' for the number of
> supported CR3-target values.
>
> This technically fixes a bug where KVM would incorrectly allow VMREAD
> and VMWRITE to nonexistent fields, i.e. cr3_target_value[0-3].  Per
> Intel's SDM, the number of supported CR3-target values reported in
> VMX_MISC also enumerates the existence of the associated VMCS fields:
>
>   If a future implementation supports more than 4 CR3-target values, they
>   will be encoded consecutively following the 4 encodings given here.
>
> Alternatively, the "bug" could be fixed by actually advertisting support
> for 4 CR3-target values, but that'd likely just enable kvm-unit-tests
> given that no one has complained about lack of support for going on ten
> years, e.g. KVM, Xen and HyperV don't use CR3-target values.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>
> Krish's patch to allow L1 to disable unrestricted guest got me poking
> around the related code.  That led me into nested_vmx_exit_handled_cr()
> and handle_cr().  handle_cr() does WARN_ON_ONCE(enable_unrestricted_guest)
> in the MOV-to-CR3 path, as KVM should never enable CR3-exiting for L1.
> But the CR3-target matching nested_vmx_exit_handled_cr() meant that it
> would be possible to trigger the warn by enabling CR3-exiting in L1 with
> a valid list of CR3-targets.  I got so far as to write a patch and a unit
> test, and then I checked MSR_IA32_VMX_MISC under KVM...
>
> AFAICT, properly emulating CR3-targets would be a trivial patch.  But, I
> don't think there would be any meaningful users, e.g. Xen is the one
> hypervisor (that I am aware of) that runs with EPT disabled for certain
> use cases, and even Xen doesn't bother with CR3-targets.  On the other
> hand, the odds of introducing a bug of one form or another seem high.
>
> Amusing side note, Xen's only reference to vmcs.CR3_TARGET_VALUE* is in
> its vmcs_dump_vcpu(), which explains why KVM's dump_vmcs() bothers to spit
> out the unused CR3-target fields :-).
>
>  Documentation/virt/kvm/nested-vmx.rst |  5 +----
>  arch/x86/kvm/vmx/evmcs.c              |  8 --------
>  arch/x86/kvm/vmx/nested.c             | 17 -----------------
>  arch/x86/kvm/vmx/vmcs12.c             |  4 ----
>  arch/x86/kvm/vmx/vmcs12.h             | 10 ++--------
>  arch/x86/kvm/vmx/vmx.c                |  9 ---------
>  6 files changed, 3 insertions(+), 50 deletions(-)


'git grep CR3_TARGET_VALUE' tells me we also have stuff in selftests:

tools/testing/selftests/kvm/include/evmcs.h:    case CR3_TARGET_VALUE0:
tools/testing/selftests/kvm/include/evmcs.h:    case CR3_TARGET_VALUE1:
tools/testing/selftests/kvm/include/evmcs.h:    case CR3_TARGET_VALUE2:
tools/testing/selftests/kvm/include/evmcs.h:    case CR3_TARGET_VALUE3:
tools/testing/selftests/kvm/include/evmcs.h:    case CR3_TARGET_VALUE0:
tools/testing/selftests/kvm/include/evmcs.h:    case CR3_TARGET_VALUE1:
tools/testing/selftests/kvm/include/evmcs.h:    case CR3_TARGET_VALUE2:
tools/testing/selftests/kvm/include/evmcs.h:    case CR3_TARGET_VALUE3:
tools/testing/selftests/kvm/include/x86_64/vmx.h:       CR3_TARGET_VALUE0               = 0x00006008,
tools/testing/selftests/kvm/include/x86_64/vmx.h:       CR3_TARGET_VALUE1               = 0x0000600a,
tools/testing/selftests/kvm/include/x86_64/vmx.h:       CR3_TARGET_VALUE2               = 0x0000600c,
tools/testing/selftests/kvm/include/x86_64/vmx.h:       CR3_TARGET_VALUE3               = 0x0000600e,

we should probably clean it up al well.

>
> diff --git a/Documentation/virt/kvm/nested-vmx.rst b/Documentation/virt/kvm/nested-vmx.rst
> index 592b0ab6970b..89851cbb7df9 100644
> --- a/Documentation/virt/kvm/nested-vmx.rst
> +++ b/Documentation/virt/kvm/nested-vmx.rst
> @@ -116,10 +116,7 @@ struct shadow_vmcs is ever changed.
>  		natural_width cr4_guest_host_mask;
>  		natural_width cr0_read_shadow;
>  		natural_width cr4_read_shadow;
> -		natural_width cr3_target_value0;
> -		natural_width cr3_target_value1;
> -		natural_width cr3_target_value2;
> -		natural_width cr3_target_value3;
> +		natural_width dead_space[4]; /* Last remnants of cr3_target_value[0-3]. */
>  		natural_width exit_qualification;
>  		natural_width guest_linear_address;
>  		natural_width guest_cr0;
> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
> index 303813423c3e..73f3e07c1852 100644
> --- a/arch/x86/kvm/vmx/evmcs.c
> +++ b/arch/x86/kvm/vmx/evmcs.c
> @@ -160,14 +160,6 @@ const struct evmcs_field vmcs_field_to_evmcs_1[] = {
>  		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL),
>  	EVMCS1_FIELD(VM_ENTRY_MSR_LOAD_ADDR, vm_entry_msr_load_addr,
>  		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL),
> -	EVMCS1_FIELD(CR3_TARGET_VALUE0, cr3_target_value0,
> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL),
> -	EVMCS1_FIELD(CR3_TARGET_VALUE1, cr3_target_value1,
> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL),
> -	EVMCS1_FIELD(CR3_TARGET_VALUE2, cr3_target_value2,
> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL),
> -	EVMCS1_FIELD(CR3_TARGET_VALUE3, cr3_target_value3,
> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL),
>  
>  	/* 32 bit rw */
>  	EVMCS1_FIELD(TPR_THRESHOLD, tpr_threshold,
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index aca57d8da400..aeb56b515c5c 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1785,10 +1785,6 @@ static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx)
>  	 * vmcs12->vm_exit_msr_store_addr = evmcs->vm_exit_msr_store_addr;
>  	 * vmcs12->vm_exit_msr_load_addr = evmcs->vm_exit_msr_load_addr;
>  	 * vmcs12->vm_entry_msr_load_addr = evmcs->vm_entry_msr_load_addr;
> -	 * vmcs12->cr3_target_value0 = evmcs->cr3_target_value0;
> -	 * vmcs12->cr3_target_value1 = evmcs->cr3_target_value1;
> -	 * vmcs12->cr3_target_value2 = evmcs->cr3_target_value2;
> -	 * vmcs12->cr3_target_value3 = evmcs->cr3_target_value3;
>  	 * vmcs12->page_fault_error_code_mask =
>  	 *		evmcs->page_fault_error_code_mask;
>  	 * vmcs12->page_fault_error_code_match =
> @@ -1862,10 +1858,6 @@ static int copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
>  	 * evmcs->vm_exit_msr_store_addr = vmcs12->vm_exit_msr_store_addr;
>  	 * evmcs->vm_exit_msr_load_addr = vmcs12->vm_exit_msr_load_addr;
>  	 * evmcs->vm_entry_msr_load_addr = vmcs12->vm_entry_msr_load_addr;
> -	 * evmcs->cr3_target_value0 = vmcs12->cr3_target_value0;
> -	 * evmcs->cr3_target_value1 = vmcs12->cr3_target_value1;
> -	 * evmcs->cr3_target_value2 = vmcs12->cr3_target_value2;
> -	 * evmcs->cr3_target_value3 = vmcs12->cr3_target_value3;
>  	 * evmcs->tpr_threshold = vmcs12->tpr_threshold;
>  	 * evmcs->virtual_processor_id = vmcs12->virtual_processor_id;
>  	 * evmcs->exception_bitmap = vmcs12->exception_bitmap;
> @@ -5540,15 +5532,6 @@ static bool nested_vmx_exit_handled_cr(struct kvm_vcpu *vcpu,
>  				return true;
>  			break;
>  		case 3:
> -			if ((vmcs12->cr3_target_count >= 1 &&
> -					vmcs12->cr3_target_value0 == val) ||
> -				(vmcs12->cr3_target_count >= 2 &&
> -					vmcs12->cr3_target_value1 == val) ||
> -				(vmcs12->cr3_target_count >= 3 &&
> -					vmcs12->cr3_target_value2 == val) ||
> -				(vmcs12->cr3_target_count >= 4 &&
> -					vmcs12->cr3_target_value3 == val))
> -				return false;
>  			if (nested_cpu_has(vmcs12, CPU_BASED_CR3_LOAD_EXITING))
>  				return true;
>  			break;
> diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
> index 53dfb401316d..c8e51c004f78 100644
> --- a/arch/x86/kvm/vmx/vmcs12.c
> +++ b/arch/x86/kvm/vmx/vmcs12.c
> @@ -115,10 +115,6 @@ const unsigned short vmcs_field_to_offset_table[] = {
>  	FIELD(CR4_GUEST_HOST_MASK, cr4_guest_host_mask),
>  	FIELD(CR0_READ_SHADOW, cr0_read_shadow),
>  	FIELD(CR4_READ_SHADOW, cr4_read_shadow),
> -	FIELD(CR3_TARGET_VALUE0, cr3_target_value0),
> -	FIELD(CR3_TARGET_VALUE1, cr3_target_value1),
> -	FIELD(CR3_TARGET_VALUE2, cr3_target_value2),
> -	FIELD(CR3_TARGET_VALUE3, cr3_target_value3),
>  	FIELD(EXIT_QUALIFICATION, exit_qualification),
>  	FIELD(GUEST_LINEAR_ADDRESS, guest_linear_address),
>  	FIELD(GUEST_CR0, guest_cr0),
> diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
> index d0c6df373f67..80232daf00ff 100644
> --- a/arch/x86/kvm/vmx/vmcs12.h
> +++ b/arch/x86/kvm/vmx/vmcs12.h
> @@ -80,10 +80,7 @@ struct __packed vmcs12 {
>  	natural_width cr4_guest_host_mask;
>  	natural_width cr0_read_shadow;
>  	natural_width cr4_read_shadow;
> -	natural_width cr3_target_value0;
> -	natural_width cr3_target_value1;
> -	natural_width cr3_target_value2;
> -	natural_width cr3_target_value3;
> +	natural_width dead_space[4]; /* Last remnants of cr3_target_value[0-3]. */
>  	natural_width exit_qualification;
>  	natural_width guest_linear_address;
>  	natural_width guest_cr0;
> @@ -263,10 +260,7 @@ static inline void vmx_check_vmcs12_offsets(void)
>  	CHECK_OFFSET(cr4_guest_host_mask, 352);
>  	CHECK_OFFSET(cr0_read_shadow, 360);
>  	CHECK_OFFSET(cr4_read_shadow, 368);
> -	CHECK_OFFSET(cr3_target_value0, 376);
> -	CHECK_OFFSET(cr3_target_value1, 384);
> -	CHECK_OFFSET(cr3_target_value2, 392);
> -	CHECK_OFFSET(cr3_target_value3, 400);
> +	CHECK_OFFSET(dead_space, 376);
>  	CHECK_OFFSET(exit_qualification, 408);
>  	CHECK_OFFSET(guest_linear_address, 416);
>  	CHECK_OFFSET(guest_cr0, 424);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index aa1b8cf7c915..1ba7722445cc 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5711,7 +5711,6 @@ void dump_vmcs(void)
>  	u32 cpu_based_exec_ctrl, pin_based_exec_ctrl, secondary_exec_control;
>  	unsigned long cr4;
>  	u64 efer;
> -	int i, n;
>  
>  	if (!dump_invalid_vmcs) {
>  		pr_warn_ratelimited("set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.\n");
> @@ -5848,14 +5847,6 @@ void dump_vmcs(void)
>  		pr_err("PostedIntrVec = 0x%02x\n", vmcs_read16(POSTED_INTR_NV));
>  	if ((secondary_exec_control & SECONDARY_EXEC_ENABLE_EPT))
>  		pr_err("EPT pointer = 0x%016llx\n", vmcs_read64(EPT_POINTER));
> -	n = vmcs_read32(CR3_TARGET_COUNT);
> -	for (i = 0; i + 1 < n; i += 4)
> -		pr_err("CR3 target%u=%016lx target%u=%016lx\n",
> -		       i, vmcs_readl(CR3_TARGET_VALUE0 + i * 2),
> -		       i + 1, vmcs_readl(CR3_TARGET_VALUE0 + i * 2 + 2));
> -	if (i < n)
> -		pr_err("CR3 target%u=%016lx\n",
> -		       i, vmcs_readl(CR3_TARGET_VALUE0 + i * 2));
>  	if (secondary_exec_control & SECONDARY_EXEC_PAUSE_LOOP_EXITING)
>  		pr_err("PLE Gap=%08x Window=%08x\n",
>  		       vmcs_read32(PLE_GAP), vmcs_read32(PLE_WINDOW));

-- 
Vitaly

