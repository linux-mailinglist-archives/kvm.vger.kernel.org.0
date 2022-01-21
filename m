Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E47C4964AF
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 19:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242591AbiAUSAG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 13:00:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiAUSAF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 13:00:05 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8636DC06173B
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 10:00:05 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id f8so8746896pgf.8
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 10:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v85lRG8sRjq/kx7Rqoj4Hif1SSh/rvErnjKWtx8VBVU=;
        b=Bz/IN/yNwGc6AybFEUD4oLN+Opm0CnszF8TpOnZWWKUhvWi6ePj3KhxE93gEoMBX+a
         y+04s9Eot40MWi1zDTQfSi3Rh8hghcCCBDEYGbR1FlKD39NqzDGiiHPOMctx6dEqK6u/
         oYEbBB1CiNTL0vIz2xzKdcqNpa/Vi+lJcA6DWuThCFcUdP4Q5ojhlhR4pbufv8J33O89
         Qin2PxHOuZs0qXXyXFl7B+U+FQUuC+5RGCZfzOTO2zd5TKREZZbU6Oq4ovhOJtrMk5tj
         qYukN9K/HfKwv1KlVQl7VWpe1mDazWdQUwvH0oAHyfWftAM/J6w4ER0IGqwA5hza+5Uc
         CruQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v85lRG8sRjq/kx7Rqoj4Hif1SSh/rvErnjKWtx8VBVU=;
        b=Qz5ENS31wcj+/+LGjH62SP1kS7Hncn6f+fM4HecqxOA9RpxE99T1Y1G1aLkYSUbqOx
         ZJ0EPNv94+Ydl5OoleB4/4ZIq6DPxu/rtfqc7Rpa0gaBmMhZIANccBKnhEmHSbK7IIuB
         5doTS0MXgyjckqJRwIz0SJFxp5xWO0Pt3JxKA45rDVZ1ZyyJPoOoZ7mSZ83BkgkKT5I7
         +Nf+GGwZiNIVtGty2zCZMnV2WxFznclcWfBjem8MiSYPZXrMWaLQlErwtWUDdgEAQzDp
         bpUZvE8Khio0+w21abwBSSoMSJwf2VVetUHRsxrToR1XzkSmN5kGnfP6IMeXs33o4YEq
         L0hg==
X-Gm-Message-State: AOAM531AXEsH5rj3LKCfpP7hi+SiOc29RYLz86zW8MYQWAvHFzZqMyDw
        dFlHsmMj6guxArUNDynraJzMxJA2gBjaSA==
X-Google-Smtp-Source: ABdhPJzDyG6N0Pr+p65ACCNXzwTBmJ3hMoD3Qm0w3ugeYZHJkzBUWTuTFN2BMRO848R56tXX+GUyYg==
X-Received: by 2002:a63:6cc5:: with SMTP id h188mr3636254pgc.401.1642788004763;
        Fri, 21 Jan 2022 10:00:04 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o5sm7447321pfk.172.2022.01.21.10.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 10:00:04 -0800 (PST)
Date:   Fri, 21 Jan 2022 18:00:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [kvm-unit-tests PATCH v4 3/3] x86: Add test coverage for
 nested_vmx_reflect_vmexit() testing
Message-ID: <Yer0oCazOfKXs4t3@google.com>
References: <20220121155855.213852-1-aaronlewis@google.com>
 <20220121155855.213852-4-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121155855.213852-4-aaronlewis@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 21, 2022, Aaron Lewis wrote:
> Add a framework and test cases to ensure exceptions that occur in L2 are
> forwarded to the correct place by nested_vmx_reflect_vmexit().
> 
> Add testing for exceptions: #GP, #UD, #DE, #DB, #BP, and #AC.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Change-Id: I0196071571671f06165983b5055ed7382fa3e1fb

Don't forget to strip the Change-Id before posting.

> ---
>  x86/unittests.cfg |   9 +++-
>  x86/vmx_tests.c   | 129 ++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 137 insertions(+), 1 deletion(-)
> 
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 9a70ba3..6ec7a98 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -288,7 +288,7 @@ arch = i386
>  
>  [vmx]
>  file = vmx.flat
> -extra_params = -cpu max,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -vmx_init_signal_test -vmx_apic_passthrough_tpr_threshold_test -apic_reg_virt_test -virt_x2apic_mode_test -vmx_pf_exception_test -vmx_pf_no_vpid_test -vmx_pf_invvpid_test -vmx_pf_vpid_test"
> +extra_params = -cpu max,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -vmx_init_signal_test -vmx_apic_passthrough_tpr_threshold_test -apic_reg_virt_test -virt_x2apic_mode_test -vmx_pf_exception_test -vmx_pf_no_vpid_test -vmx_pf_invvpid_test -vmx_pf_vpid_test -vmx_exception_test"
>  arch = x86_64
>  groups = vmx
>  
> @@ -390,6 +390,13 @@ arch = x86_64
>  groups = vmx nested_exception
>  check = /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr=Y
>  
> +[vmx_exception_test]
> +file = vmx.flat
> +extra_params = -cpu max,+vmx -append vmx_exception_test
> +arch = x86_64
> +groups = vmx nested_exception
> +timeout = 10

Leave this out (for now), including it in the main "vmx" test is sufficient.
I'm definitely in favor of splitting up the "vmx" behemoth, but it's probably
best to do that in a separate commit/series so that we can waste time bikeshedding
over how to organize things :-)

> +
>  [debug]
>  file = debug.flat
>  arch = x86_64
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 3d57ed6..af6f33b 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -21,6 +21,7 @@
>  #include "smp.h"
>  #include "delay.h"
>  #include "access.h"
> +#include "x86/usermode.h"
>  
>  #define VPID_CAP_INVVPID_TYPES_SHIFT 40
>  
> @@ -10701,6 +10702,133 @@ static void vmx_pf_vpid_test(void)
>  	__vmx_pf_vpid_test(invalidate_tlb_new_vpid, 1);
>  }
>  
> +static void vmx_l2_gp_test(void)
> +{
> +	*(volatile u64 *)NONCANONICAL = 0;
> +}
> +
> +static void vmx_l2_ud_test(void)
> +{
> +	asm volatile ("ud2");
> +}
> +
> +static void vmx_l2_de_test(void)
> +{
> +	asm volatile (
> +		"xor %%eax, %%eax\n\t"
> +		"xor %%ebx, %%ebx\n\t"
> +		"xor %%edx, %%edx\n\t"
> +		"idiv %%ebx\n\t"
> +		::: "eax", "ebx", "edx");
> +}
> +
> +static void vmx_l2_bp_test(void)
> +{
> +	asm volatile ("int3");
> +}
> +
> +static void vmx_l2_db_test(void)
> +{
> +	write_rflags(read_rflags() | X86_EFLAGS_TF);
> +}
> +
> +static uint64_t usermode_callback(void)
> +{
> +	/* Trigger an #AC by writing 8 bytes to a 4-byte aligned address. */
> +	asm volatile(
> +		"sub $0x10, %rsp\n\t"
> +		"movq $0, 0x4(%rsp)\n\t"
> +		"add $0x10, %rsp\n\t");

Sorry, didn't look closely at this before.  This can simply be:

	asm volatile("movq $0, 0x4(%rsp)\n\t");

as the access is expected to fault.  Or if you want to be paranoid about not
overwriting the stack:

	asm volatile("movq $0, -0x4(%rsp)\n\t");

It's probably also a good idea to call out that the stack is aligned on a 16-byte
boundary.  If you were trying to guarnatee alignment, then you would need to use
AND instead of SUB.  E.g.

        asm volatile("push  %rbp\n\t"
                     "movq  %rsp, %rbp\n\t"
                     "andq  $-0x10, %rsp\n\t"
                     "movq  $0, -0x4(%rsp)\n\t"
                     "movq  %rbp, %rsp\n\t"
                     "popq  %rbp\n\t");

But my vote would be to just add a comment, I would consider it a test bug if the
stack isn't properly aligned.

> +
> +	return 0;
> +}
> +
> +static void vmx_l2_ac_test(void)
> +{
> +	bool raised_vector = false;

Nit, hit_ac or so is more intuive.

> +
> +	write_cr0(read_cr0() | X86_CR0_AM);
> +	write_rflags(read_rflags() | X86_EFLAGS_AC);
> +
> +	run_in_user(usermode_callback, AC_VECTOR, 0, 0, 0, 0, &raised_vector);
> +	report(raised_vector, "#AC vector raised from usermode in L2");

And continuing the nits, "Usermode #AC handled in L2".

> +	vmcall();
> +}
> +
