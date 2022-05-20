Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A56DF52E1EE
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 03:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344435AbiETBYp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 21:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240777AbiETBYn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 21:24:43 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 342792CDEE
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 18:24:42 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id a9so4471310pgv.12
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 18:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=EFGW6KkwvyY4pQb6+GcqplYjxXlO6yZ13EE/09wmTnc=;
        b=TI6lTngyykFfvljrDLE4Pa5ypaSRcLJnl9IAzY25aN01OhcPFu4uW2bOL3O1xhYzxI
         LupT/aqYQ9bCN+AaYRdZkne92MvzQZA3N3B9bTA9TyETdKNrTe4WyIerRd0F5SfbjFQ7
         ZyQ07KG+FSOdlMKklCNdiuV4NMNuWPQNi2YMcnuO2lhnWirISKNZWUv33S2IbC5yrzf/
         nHurKgWtdIcYFm0bKuJMPzRekdGBeI1/QGJY3FgKeBfZVyoSLQIi354kSLtNLlTJuhxG
         CAjYscNZrNCP37ZNGR5eSYPJtIhBhy5wKRXpnnF9hn19ETyHJClBRSt+2SLJ9pgZeqQF
         sahw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=EFGW6KkwvyY4pQb6+GcqplYjxXlO6yZ13EE/09wmTnc=;
        b=jvP5ruXKAH+4xFI3RDvanggdq09SgkWJrC4wJmPy5bC9Ms5lllZwxKqJjREEeXZaor
         nibhdZed5VbWF2LyIv0dxzgW9v00Lp6ErWxzje6/8rqSXhxMZCSt/pTydwMHafxL9fSu
         W3LVm0vdBkaGRR5uh9bzAHodcXi8rjC1I7kbtSVB6GJgHRt3N/6QnM7AKQ1JTPMSHSI2
         mm9gdvvV4iSHifOXNi+5Frn0TLMwsv/uMqdbaHP+znt3ShUgaEoVobVjCCg/oi9OtuUB
         wp2eQxSjYqiQySOKRh7jFk71Qs6ecnK5bMtXqpAaCl9rcN0a/pMXQWQeMuRJxjCYAU8M
         OIZg==
X-Gm-Message-State: AOAM531NmKqgT8f78eKHRKkAi7f60pzt6UBEWNqW46V+QkKNRfPWDNKV
        ekC5vQFGK7b3KCvDl9cW/WMvUw==
X-Google-Smtp-Source: ABdhPJxQQ4zdCljbCK2lum+5DPvq5tArBDIZ1+hRcJo2nqBaO0J/3a+zpKX9d2WoKT0Lw7zNyl7H1A==
X-Received: by 2002:a05:6a00:ad2:b0:4f1:2734:a3d9 with SMTP id c18-20020a056a000ad200b004f12734a3d9mr7398933pfl.61.1653009881457;
        Thu, 19 May 2022 18:24:41 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p17-20020a170902c71100b0015e8d4eb28fsm4300576plp.217.2022.05.19.18.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 18:24:40 -0700 (PDT)
Date:   Fri, 20 May 2022 01:24:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lei Wang <lei4.wang@intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, chenyi.qiang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 8/8] KVM: VMX: Enable PKS for nested VM
Message-ID: <Yobt1XwOfb5M6Dfa@google.com>
References: <20220424101557.134102-1-lei4.wang@intel.com>
 <20220424101557.134102-9-lei4.wang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220424101557.134102-9-lei4.wang@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nit, use "KVM: nVMX:" for the shortlog scope.

On Sun, Apr 24, 2022, Lei Wang wrote:
> @@ -2433,6 +2437,10 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>  		if (kvm_mpx_supported() && vmx->nested.nested_run_pending &&
>  		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
>  			vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
> +
> +		if (vmx->nested.nested_run_pending &&
> +		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS))
> +			vmcs_write64(GUEST_IA32_PKRS, vmcs12->guest_ia32_pkrs);

As mentioned in the BNDCFGS thread, this does the wrong thing for SMM.  But, after
a lot of thought, handling this in nested_vmx_enter_non_root_mode() would be little
more than a band-aid, and a messy one at that, because KVM's SMM emulation is
horrifically broken with respect to nVMX.

Entry does to SMM does not modify _any_ state that is not saved in SMRAM.  That
we're having to deal with this crap is a symptom of KVM doing the complete wrong
thing by piggybacking nested_vmx_vmexit() and nested_vmx_enter_non_root_mode().

The SDM's description of CET spells this out very, very clearly:

  On processors that support CET shadow stacks, when the processor enters SMM,
  the processor saves the SSP register to the SMRAM state save area (see Table 31-3)
  and clears CR4.CET to 0. Thus, the initial execution environment of the SMI handler
  has CET disabled and all of the CET state of the interrupted program is still in the
  machine. An SMM that uses CET is required to save the interrupted program’s CET
  state and restore the CET state prior to exiting SMM.

It mostly works because no guest SMM handler does anything with most of the MSRs,
but it's all wildy wrong.  A concrete example of a lurking bug is if vmcs12 uses
the VM-Exit MSR load list, in which case the forced nested_vmx_vmexit() will load
state that is never undone.

So, my very strong vote is to ignore SMM and let someone who actually cares about
SMM fix that mess properly by adding custom flows for exiting/re-entering L2 on
SMI/RSM.

>  	}
>  
>  	if (nested_cpu_has_xsaves(vmcs12))
> @@ -2521,6 +2529,11 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  	if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
>  	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
>  		vmcs_write64(GUEST_BNDCFGS, vmx->nested.vmcs01_guest_bndcfgs);
> +	if (kvm_cpu_cap_has(X86_FEATURE_PKS) &&

ERROR: trailing whitespace
#85: FILE: arch/x86/kvm/vmx/nested.c:3407:
+^Iif (kvm_cpu_cap_has(X86_FEATURE_PKS) && $

> +	    (!vmx->nested.nested_run_pending ||
> +	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS)))
> +		vmcs_write64(GUEST_IA32_PKRS, vmx->nested.vmcs01_guest_pkrs);
> +
>  	vmx_set_rflags(vcpu, vmcs12->guest_rflags);
>  
>  	/* EXCEPTION_BITMAP and CR0_GUEST_HOST_MASK should basically be the
> @@ -2897,6 +2910,10 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
>  					   vmcs12->host_ia32_perf_global_ctrl)))
>  		return -EINVAL;
>  
> +	if ((vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PKRS) &&
> +	    CC(!kvm_pkrs_valid(vmcs12->host_ia32_pkrs)))
> +		return -EINVAL;
> +
>  #ifdef CONFIG_X86_64
>  	ia32e = !!(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE);
>  #else
> @@ -3049,6 +3066,10 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
>  	if (nested_check_guest_non_reg_state(vmcs12))
>  		return -EINVAL;
>  
> +	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS) &&
> +	    CC(!kvm_pkrs_valid(vmcs12->guest_ia32_pkrs)))
> +		return -EINVAL;
> +
>  	return 0;
>  }
>  
> @@ -3384,6 +3405,10 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>  	    (!from_vmentry ||
>  	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
>  		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
> +	if (kvm_cpu_cap_has(X86_FEATURE_PKS) && 
> +	    (!from_vmentry ||

This should be "!vmx->nested.nested_run_pending" instead of "!from_vmentry" to
avoid the unnecessary VMREAD when restoring L2 with a pending VM-Enter. 
	
> +	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS)))
> +		vmx->nested.vmcs01_guest_pkrs = vmcs_read64(GUEST_IA32_PKRS);
>  
>  	/*
>  	 * Overwrite vmcs01.GUEST_CR3 with L1's CR3 if EPT is disabled *and*

...

> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 91723a226bf3..82f79ac46d7b 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -222,6 +222,8 @@ struct nested_vmx {
>  	u64 vmcs01_debugctl;
>  	u64 vmcs01_guest_bndcfgs;
>  

Please pack these together, i.e. don't have a blank line between the various
vmcs01_* fields.

> +	u64 vmcs01_guest_pkrs;
> +
>  	/* to migrate it to L1 if L2 writes to L1's CR8 directly */
>  	int l1_tpr_threshold;
>  
> -- 
> 2.25.1
> 
