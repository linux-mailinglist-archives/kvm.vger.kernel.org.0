Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38EC248CD3F
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 21:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357742AbiALUsl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 15:48:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357727AbiALUsh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 15:48:37 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397DDC06173F
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 12:48:36 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id a7so3212877plh.1
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 12:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mcTVXOqHX+5BR2FNc4eAnSqSwmFnGm7BGTNE8FpyzEI=;
        b=PHAIk6L3UvzdGhRSKQYzw1kzJmW1nef57DVGZfE2Hoyq/v1X/lOsH1VrNdD6SIMTox
         XtKSVjy8Y82x2HiTyp4VWvGh6vBkY1mChMA/bSLiK6qAh6e5lqLfO7UcK2odjHF6xLs5
         0DTRvDpadmqOWTuQYQ3tCppNiHbLxYex/gKYgkVsKD/Vanr/GeRABYFzNLaHpR5a9MyS
         GYdMSkx+ADCcqqQg7aOJ0XW94540M9P3715lc3ryJyAsL7tdu0Cfy/Ps+JbeAYgNtF6B
         YENkh2yoorl4eHnlEBvWDPQ91dysbyWWXZMUYRHPNITBGFocVERchsphJqGgPoaVjxf9
         dXgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mcTVXOqHX+5BR2FNc4eAnSqSwmFnGm7BGTNE8FpyzEI=;
        b=kGf363LLBxrzrBHE85aa3QRJRLPkLr8O221WLld3uMGH76z50aqvEgIKjPirfto0GF
         1zuU3htuhmhD7mc2hmbMlj64EICF8OjtTcp/Zyr66ASyRaSbZkXu5UvCnHmpBQ9c/mds
         4exmRKjMYYYq0RsUpcVApJrfAbxMDEED3+S4GfFiZAdqKxrEJurGcgSWPQi6RzjtC3bZ
         uuAAlYqAcg3C1jMHzdyo1UdKdxlWgdiyrIAI26/s53tDbNnrPgo7QOfm17fc6cchj7i+
         sfhROVXqlLQTVDmipJKn1fgJyW2/4wZrPguZSNJ+q7y8oCF/pLg41GSREU4ZzzEeCtG2
         hKrA==
X-Gm-Message-State: AOAM531tay8K47zsuOjetWm5nCOlLRKAGO2Kdn/+sKPifLykPJiKa26B
        8Oe8Qr15sz7ZInnqrYF+xKYsAg==
X-Google-Smtp-Source: ABdhPJzZbfQqayWHKgSHcTztIMsCr35K5b4tp2NDjQdQNqjy+k/wHSXCFwfFYLn6TBKEzqzZt3Cx4Q==
X-Received: by 2002:a17:903:52:b0:14a:4951:390a with SMTP id l18-20020a170903005200b0014a4951390amr1471241pla.54.1642020515523;
        Wed, 12 Jan 2022 12:48:35 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u20sm433687pfi.220.2022.01.12.12.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 12:48:34 -0800 (PST)
Date:   Wed, 12 Jan 2022 20:48:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [kvm-unit-tests PATCH v2 3/4] x86: Add a test framework for
 nested_vmx_reflect_vmexit() testing
Message-ID: <Yd8+n+/2GCZtIhaB@google.com>
References: <20211214011823.3277011-1-aaronlewis@google.com>
 <20211214011823.3277011-4-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214011823.3277011-4-aaronlewis@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 14, 2021, Aaron Lewis wrote:
> Set up a test framework that verifies an exception occurring in L2 is
> forwarded to the right place (L0?, L1?, L2?).  To add a test to this
> framework just add the exception and callbacks to the
> vmx_exception_tests array.

The bulk of this patch belongs in patch 04.  It's nearly impossible to properly
review the guts of vmx_exception_test() without seeing how the hooks are actually
used, and it also adds a test without any testcases, which is odd.

The introduction of test_set_guest_restartable() and test_set_guest_finished()
can and should go in a separate patch.  It would be nice if a few existing tests
were converted to use test_set_guest_finished(), but certainly not necessary,
and that might cause too much scope screep.

Exposing exception_mnemonic() should also go in a separate patch.  E.g. if someone
else is working on a test that wants to use exception_mnemonic(), then the two
in-flight series can share a single patch.  That's not very likely to happen in 
KUT, but it's good practice in general.

> This framework tests two things:
>  1) It tests that an exception is handled by L2.
>  2) It tests that an exception is handled by L1.
> To test that this happens, each exception is triggered twice; once with
> just an L2 exception handler registered, and again with both an L2
> exception handler registered and L1's exception bitmap set.  The
> expectation is that the first exception will be handled by L2 and the
> second by L1.
> 
> To implement this support was added to vmx.c to allow more than one
> L2 test be run in a single test.  Previously there was a hard limit of
> only being allowed to set the L2 guest code once in a given test.  That
> is no longer a limitation with the addition of
> test_set_guest_restartable().
> 
> Support was also added to allow the test to complete without running
> through the entirety of the L2 guest code. Calling the function
> test_set_guest_finished() marks the guest code as completed, allowing
> it to end without running to the end.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---

...

> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 9fcdcae..0353b69 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -368,6 +368,13 @@ arch = x86_64
>  groups = vmx nested_exception
>  check = /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr=Y
>  
> +[vmx_exception_test]
> +file = vmx.flat
> +extra_params = -cpu max,+vmx -append vmx_exception_test
> +arch = x86_64
> +groups = vmx nested_exception
> +timeout = 10

Why add a new test case instead of folding this into "vmx"?  It's quite speedy.
The "vmx" bucket definitely needs some cleanup, but I don't thinking adding a bunch
of one-off tests is the way forward.

> +
>  [debug]
>  file = debug.flat
>  arch = x86_64
> diff --git a/x86/vmx.c b/x86/vmx.c
> index f4fbb94..9908746 100644
> --- a/x86/vmx.c
> +++ b/x86/vmx.c
> @@ -1895,6 +1895,23 @@ void test_set_guest(test_guest_func func)
>  	v2_guest_main = func;
>  }
>  
> +/*
> + * Set the target of the first enter_guest call and reset the RIP so 'func'
> + * will start from the beginning.  This can be called multiple times per test.
> + */
> +void test_set_guest_restartable(test_guest_func func)

Hmm, "restartable" is somewhat confusing as it implies that other guests aren't
restartable, and sometimes people refer to resuming a guest after a VM-Exit as
"restarting" the guest.  Maybe test_override_guest()?  


> +{
> +	assert(current->v2);
> +	v2_guest_main = func;

These two lines can be shared with the existing test_set_guest().  It's kinda silly
since it's just two lines, but it is helpful to show the relationship between the
two helpers.  E.g.

static void __test_set_guest(test_guest_func func)
{
	assert(current->v2);
	v2_guest_main = func;
}

/*
 * Set the target of the first enter_guest call. Can only be called once per
 * test. Must be called before first enter_guest call.
 */
void test_set_guest(test_guest_func func)
{
	TEST_ASSERT_MSG(!v2_guest_main, "Already set guest func.");
	__test_set_guest(func);
}

void test_override_guest(test_guest_func func)
{
	__test_set_guest(func);
	init_vmcs_guest();
}


> +	init_vmcs_guest();
> +	guest_finished = 0;

This seems unnecessary, can't the test simply not set this flag?  Ah, after
running and debugging, the issue is that vmx_l2_ac_test() doesn't do a vmcall()
and so that test runs to completion.  As annoying as I find guest_entry to be, I
do think it's better to leave this alone and add the vmcall() to vmx_l2_ac_test().

> +}
> +
> +void test_set_guest_finished(void)
> +{
> +	guest_finished = 1;
> +}
> +
>  static void check_for_guest_termination(union exit_reason exit_reason)
>  {
>  	if (is_hypercall(exit_reason)) {
> diff --git a/x86/vmx.h b/x86/vmx.h
> index 4423986..5321a7e 100644
> --- a/x86/vmx.h
> +++ b/x86/vmx.h
> @@ -1055,7 +1055,9 @@ void hypercall(u32 hypercall_no);
>  typedef void (*test_guest_func)(void);
>  typedef void (*test_teardown_func)(void *data);
>  void test_set_guest(test_guest_func func);
> +void test_set_guest_restartable(test_guest_func func);
>  void test_add_teardown(test_teardown_func func, void *data);
>  void test_skip(const char *msg);
> +void test_set_guest_finished(void);
>  
>  #endif
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 3d57ed6..018db2f 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -10701,6 +10701,93 @@ static void vmx_pf_vpid_test(void)
>  	__vmx_pf_vpid_test(invalidate_tlb_new_vpid, 1);
>  }
>  
> +struct vmx_exception_test {
> +	u8 vector;
> +	void (*guest_code)(void);
> +	void (*init_test)(void);
> +	void (*uninit_test)(void);

The init/uninit helpers are unnecessary, the #DB test can instead set EFLAGS.TF
from L2 and then rely on test_override_guest() to restore vmcs.GUEST_RFLAGS.  The
#AC test can do the same thing (stuff state without restoring).  It's a little
gross, but it yields much cleaner code in the test loop and we're already relying
on test_override_guest() to restore guest state (RIP).

> +};
> +
> +struct vmx_exception_test vmx_exception_tests[] = {
> +};
> +
> +static u8 vmx_exception_test_vector;
> +
> +static void vmx_exception_handler(struct ex_regs *regs)
> +{
> +	report(regs->vector == vmx_exception_test_vector,
> +	       "Handling %s in L2's exception handler",
> +	       exception_mnemonic(vmx_exception_test_vector));
> +	vmcall();
> +}
> +
> +static void handle_exception_in_l2(u8 vector)
> +{
> +	handler old_handler = handle_exception(vector, vmx_exception_handler);
> +
> +	vmx_exception_test_vector = vector;
> +
> +	enter_guest();
> +	report(vmcs_read(EXI_REASON) == VMX_VMCALL,
> +	       "%s handled by L2", exception_mnemonic(vector));
> +
> +	test_set_guest_finished();

Just call test_set_guest_finished() after all tests run.

> +	handle_exception(vector, old_handler);
> +}
> +
> +static void handle_exception_in_l1(u32 vector)
> +{
> +	handler old_handler = handle_exception(vector, vmx_exception_handler);
> +	u32 old_eb = vmcs_read(EXC_BITMAP);
> +
> +	vmx_exception_test_vector = 0xff;

No need to install the handler or set the vector, just let L2 expode on the
unexpected exception.

> +
> +	vmcs_write(EXC_BITMAP, old_eb | (1u << vector));
> +
> +	enter_guest();
> +
> +	report((vmcs_read(EXI_REASON) == VMX_EXC_NMI) &&
> +	       ((vmcs_read(EXI_INTR_INFO) & 0xff) == vector),
> +	       "%s handled by L1", exception_mnemonic(vector));
> +
> +	test_set_guest_finished();
> +
> +	vmcs_write(EXC_BITMAP, old_eb);
> +	handle_exception(vector, old_handler);
> +}
> +
> +static void vmx_exception_test(void)
> +{
> +	struct vmx_exception_test *t;
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(vmx_exception_tests); i++) {
> +		t = &vmx_exception_tests[i];
> +
> +		TEST_ASSERT(t->guest_code);

Eh, I wouldn't bother, especially once (un)init_test go bye bye.

This is what I ended up with (pulling in code from the next patch):

static void vmx_l2_gp_test(void)
{
	*(volatile u64 *)NONCANONICAL = 0;
}

static void vmx_l2_ud_test(void)
{
	asm volatile ("ud2");
}

static void vmx_l2_de_test(void)
{
	asm volatile (
		"xor %%eax, %%eax\n\t"
		"xor %%ebx, %%ebx\n\t"
		"xor %%edx, %%edx\n\t"
		"idiv %%ebx\n\t"
		::: "eax", "ebx", "edx");
}

static void vmx_l2_bp_test(void)
{
	asm volatile ("int3");
}

static void vmx_l2_db_test(void)
{
	write_rflags(read_rflags() | X86_EFLAGS_TF);
}

static uint64_t usermode_callback(void)
{
	/* Trigger an #AC by writing 8 bytes to a 4-byte aligned address. */
	asm volatile(
		"sub $0x10, %rsp\n\t"
		"movq $0, 0x4(%rsp)\n\t"
		"add $0x10, %rsp\n\t");

	return 0;
}

static void vmx_l2_ac_test(void)
{
	bool raised_vector = false;

	write_cr0(read_cr0() | X86_CR0_AM);
	write_rflags(read_rflags() | X86_EFLAGS_AC);

	run_in_user(usermode_callback, AC_VECTOR, 0, 0, 0, 0, &raised_vector);
	report(raised_vector, "#AC vector raised from usermode in L2");
	vmcall();
}

struct vmx_exception_test {
	u8 vector;
	void (*guest_code)(void);
};

struct vmx_exception_test vmx_exception_tests[] = {
	{ GP_VECTOR, vmx_l2_gp_test },
	{ UD_VECTOR, vmx_l2_ud_test },
	{ DE_VECTOR, vmx_l2_de_test },
	{ DB_VECTOR, vmx_l2_db_test },
	{ BP_VECTOR, vmx_l2_bp_test },
	{ AC_VECTOR, vmx_l2_ac_test },
};

static u8 vmx_exception_test_vector;

static void vmx_exception_handler(struct ex_regs *regs)
{
	report(regs->vector == vmx_exception_test_vector,
	       "Handling %s in L2's exception handler",
	       exception_mnemonic(vmx_exception_test_vector));
	vmcall();
}

static void handle_exception_in_l2(u8 vector)
{
	handler old_handler = handle_exception(vector, vmx_exception_handler);

	vmx_exception_test_vector = vector;

	enter_guest();
	report(vmcs_read(EXI_REASON) == VMX_VMCALL,
	       "%s handled by L2", exception_mnemonic(vector));

	handle_exception(vector, old_handler);
}

static void handle_exception_in_l1(u32 vector)
{
	u32 old_eb = vmcs_read(EXC_BITMAP);

	vmcs_write(EXC_BITMAP, old_eb | (1u << vector));

	enter_guest();

	report((vmcs_read(EXI_REASON) == VMX_EXC_NMI) &&
	       ((vmcs_read(EXI_INTR_INFO) & 0xff) == vector),
	       "%s handled by L1", exception_mnemonic(vector));

	vmcs_write(EXC_BITMAP, old_eb);
}

static void vmx_exception_test(void)
{
	struct vmx_exception_test *t;
	int i;

	for (i = 0; i < ARRAY_SIZE(vmx_exception_tests); i++) {
		t = &vmx_exception_tests[i];

		/*
		 * Override the guest code before each run even though it's the
		 * same code, the VMCS guest state needs to be reinitialized.
		 */
		test_override_guest(t->guest_code);
		handle_exception_in_l2(t->vector);

		test_override_guest(t->guest_code);
		handle_exception_in_l1(t->vector);
	}

	test_set_guest_finished();
}
