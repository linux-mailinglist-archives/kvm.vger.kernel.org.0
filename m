Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8496E535D20
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 11:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350272AbiE0JV2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 May 2022 05:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350060AbiE0JVZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 May 2022 05:21:25 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5209BE8;
        Fri, 27 May 2022 02:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653643283; x=1685179283;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zHXAnmnNFh6AJbxJIi8Vnul7mXoMJj9XvJp1nZaLWoc=;
  b=EqfoVQ8n1kjP0IexoRqMt8RxiNu8WV584qX9r6EkONnhihWBvjWY1sBh
   /4NTYOFwrb1bu2DenDqTMQuNapwzZphfVGzvyiOYfqmdnHW5KefXbJLmU
   ESUM/jHBKsdxEDnAOfMd2RMXYyY7CoWfh0wYIWPH2/DAPglJNUrqmwsM8
   I4gqt+GrNsI6UilpQevS6lGp1LRrAC0U+dXUkmDCuU0VzQZVXXqyWVZ+i
   yRYko+nYsgq7mNLmWHKpKxa5WfSTIXgHm+s6eC3uDDDQIA+5bkf5RDkKw
   L4biu57q4WryGRZzup96OxKsrGvGOsLjautOL270KcHRRLPUyXZpJ11oM
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10359"; a="337477593"
X-IronPort-AV: E=Sophos;i="5.91,255,1647327600"; 
   d="scan'208";a="337477593"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2022 02:21:20 -0700
X-IronPort-AV: E=Sophos;i="5.91,255,1647327600"; 
   d="scan'208";a="705039012"
Received: from leiwang7-mobl.ccr.corp.intel.com (HELO [10.254.211.236]) ([10.254.211.236])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2022 02:21:18 -0700
Message-ID: <4750f3e3-e5f4-245e-8a98-8b35dc447293@intel.com>
Date:   Fri, 27 May 2022 17:21:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.1
Subject: Re: [PATCH v7 3/8] KVM: X86: Expose IA32_PKRS MSR
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, chenyi.qiang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220424101557.134102-1-lei4.wang@intel.com>
 <20220424101557.134102-4-lei4.wang@intel.com> <Yo1YKoUOPOLpZnqn@google.com>
From:   "Wang, Lei" <lei4.wang@intel.com>
In-Reply-To: <Yo1YKoUOPOLpZnqn@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/25/2022 6:11 AM, Sean Christopherson wrote:
> Nit, something like:
>
>    KVM: X86: Virtualize and pass-through IA32_PKRS MSR when supported
>
> because "expose" doesn't precisely cover the pass-through behavior

Will change it.

> Eh, I don't think this comment adds anything.  And practically speaking, whether
> or not X86_FEATURE_PKS is reported by kvm_cpu_cap_has() and/or guest_cpuid_has()
> is irrelevant.  If KVM is loading PKRS on exit, then the VMCS needs to hold an
> up-to-date value.  E.g. if for some reason KVM enables the control even if PKS
> isn't exposed to the guest (see below), this code still needs to refresh the value.
Will remove the irrelevant statement, just left the "Update the host 
pkrs vmcs field before vcpu runs."

> No need for an intermediate host_pkrs.  I.e. this can simply be:
>
> 	if (vm_exit_controls_get(vmx) & VM_EXIT_LOAD_IA32_PKRS)
> 		vmx_set_host_pkrs(host_state, get_current_pkrs());
OK, will write the code in one line.

> Nit, please align the lines that are inside a pair of parantheses, i.e.
My mistake, will align the lines.

> A comment on the caching patch, please use kvm_pkrs_read() to follow the GPR, RIP,
> PDPTR, etc... terminology (CR0/3/4 got grandfathered in).
Will rename the function.

> Nit, please move this to after the capability checks.  Does not affect functionality
> at all, but logically it doesn't make sense to check for a valid value of a register
> that doesn't exist.
Make sense, will move it.

> The caching patch should add kvm_write_pkrs().  And in there, I think I'd vote for
> a WARN_ON_ONCE() that the incoming value doesn't set bits 63:32.  It's redundant
> with kvm_pkrs_valid()
Will add a new function at the caching patch.

> Ugh, toggling the entry/exit controls here won't do the correct thing if L2 is
> active.  The MSR intercept logic works because it always operates on vmcs01's bitmap.
>
> Let's keep this as simple as possible and set the controls if they're supported.
> KVM will waste a few cycles on entry/exit if PKS is supported in the host but not
> exposed to the guest, but that's not the end of the world.  If we want to optimize
> that, then we can do that in the future and in a more generic way.
>
> So this becomes:
>
> 	if (kvm_cpu_cap_has(X86_FEATURE_PKS))
> 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PKRS, MSR_TYPE_RW,
> 					  !guest_cpuid_has(vcpu, X86_FEATURE_PKS));
>
> And please hoist that up to be next to the handling of X86_FEATURE_XFD to try and
> bunch together code that does similar things.
>
> The last edge case to deal with is if only one of the controls is supported, e.g. if
> an L0 hypervisor is being evil.  Big surprise, BNDCFGS doesn't get this right and
> needs a bug fix patch, e.g. it could retain the guest's value after exit, or host's
> value after entry.  It's a silly case because it basically requires broken host
> "hardware", but it'd be nice to get it right in KVM.  And that'd also be a good
> opportunity to handle all of the pairs, i.e. clear the bits during setup_vmcs_config()
> instead of checking both the entry and exit flags in cpu_has_load_*().
>
> So for this series, optimistically assume my idea will pan out and a
> adjust_vm_entry_exit_pair() helper will exit by the time this is fully baked.
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6927f6e8ec31..53e12e6006af 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2434,6 +2434,16 @@ static bool cpu_has_sgx(void)
>          return cpuid_eax(0) >= 0x12 && (cpuid_eax(0x12) & BIT(0));
>   }
>
> +static __init void adjust_vm_entry_exit_pair(u32 *entry_controls, u32 entry_bit,
> +                                            u32 *exit_controls, u32 exit_bit)
> +{
> +       if ((*entry_controls & entry_bit) && (*exit_controls & exit_bit))
> +               return;
> +
> +       *entry_controls &= ~entry_bit;
> +       *exit_controls &= ~exit_bit;
> +}
> +
>   static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
>                                        u32 msr, u32 *result)
>   {
> @@ -2614,6 +2624,9 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>                                  &_vmentry_control) < 0)
>                  return -EIO;
>
> +       adjust_vm_entry_exit_pair(&_vmentry_control, VM_ENTRY_LOAD_IA32_PKRS,
> +                                 &_vmexit_control, VM_EXIT_LOAD_IA32_PKRS);
> +
>          /*
>           * Some cpus support VM_{ENTRY,EXIT}_IA32_PERF_GLOBAL_CTRL but they
>           * can't be used due to an errata where VM Exit may incorrectly clear
> @@ -7536,6 +7549,9 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>                  vmx_set_intercept_for_msr(vcpu, MSR_IA32_XFD_ERR, MSR_TYPE_R,
>                                            !guest_cpuid_has(vcpu, X86_FEATURE_XFD));
>
> +       if (kvm_cpu_cap_has(X86_FEATURE_PKS))
> +               vmx_set_intercept_for_msr(vcpu, MSR_IA32_PKRS, MSR_TYPE_RW,
> +                                         !guest_cpuid_has(vcpu, X86_FEATURE_PKS));
>
>          set_cr4_guest_host_mask(vmx);
Thanks for your suggestions, will try your helper.

> Please put this with the other !init_event stuff, e.g. look for MSR_IA32_XSS.
Will do it.


