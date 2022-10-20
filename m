Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B4460687E
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 20:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiJTS4H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 14:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiJTS4G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 14:56:06 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCE5140E72
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 11:56:00 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id a6-20020a17090abe0600b0020d7c0c6650so4437103pjs.0
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 11:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=U+GGz5cs6hQAFRLKvg/c++wcB+18G9YsW5wnzvDbtyI=;
        b=mQKurXd6X2fxz5dq5pygXq35eBKeBz8u7D2O5XWogjvjd6bdXWLr50m06TTW2M3xAL
         MHFMaobUygsgOXVqNn8C9J3GTpLo/2ru5Vs/1gRxYdCUB6ML95D35LwfXru1Ym5OJMfe
         t/O5Q9HH9NVFv0ILOphzSyzk4LxyO/oG8KLbdB6O1djijlebbJFhetEcisqgtiztEjbW
         CZTXueHEpgGRmzTlvzYR1MsaEGlUjTQPlZAZ717B+Hi+jOjnigva6kNDFL+lPA8o5UBC
         UsOHTgUKATW9/dGGh8slK0YryuDRqVZXmGYhrlF5TmKHmHRCGSaVfU1sCBMSi57DfqI1
         98DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U+GGz5cs6hQAFRLKvg/c++wcB+18G9YsW5wnzvDbtyI=;
        b=gW/ITUC+/ANBum9u9koqibZnyDaTDmBLqCqnAbYNFg/yzJYWYplVvZ16m1J3uuVwzH
         bWVJvDr9Js74HJr3elS21A6f6OYjYbNInlTLqsi+/0BSvCL2z7iip5DOfGJfXbXuydaP
         jenMPsm6+3Qowy4FT4H1YrosZgfMDFtH1R39kVRlhLOdQMuRAkP+FXEiyUHzGizFPuli
         vQqDJNtabQBt2yEhQ7p5R2q2o1v/H/5d+5TRr9pVNUZEO8crrLELHbyWGWk4gQfxWfog
         KAoVGVedUsfUHwYe8+GnDBz1urvKsI6zvRhqz5gfwKp8k7+kB27zrlJyRWBBr4IjUIH2
         V0FQ==
X-Gm-Message-State: ACrzQf0bKLHksuuRBJKvxatR7cW5/2f/4ZvzzAPt5Xc0vh4F8Bfd/43x
        PELL0Nfzki+mY719qFrgRCMm1w==
X-Google-Smtp-Source: AMsMyM7AgXDQVI9oU5fG5DPrUCLE/EokAN/FCz0qmN85vL9ngXAlXG1lAqcxsiLleL4NdmBryfxQEQ==
X-Received: by 2002:a17:902:ca02:b0:17f:762e:2dd2 with SMTP id w2-20020a170902ca0200b0017f762e2dd2mr15453755pld.91.1666292159665;
        Thu, 20 Oct 2022 11:55:59 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b1-20020a17090a10c100b0020063e7d63asm160490pje.30.2022.10.20.11.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 11:55:59 -0700 (PDT)
Date:   Thu, 20 Oct 2022 18:55:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 14/16] svm: rewerite vm entry macros
Message-ID: <Y1GZu5ztBadhFphk@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
 <20221020152404.283980-15-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020152404.283980-15-mlevitsk@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 20, 2022, Maxim Levitsky wrote:

Changelog please.  This patch in particular is extremely difficult to review
without some explanation of what is being done, and why.

If it's not too much trouble, splitting this over multiple patches would be nice.

> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  lib/x86/svm_lib.h | 58 +++++++++++++++++++++++++++++++++++++++
>  x86/svm.c         | 51 ++++++++++------------------------
>  x86/svm.h         | 70 ++---------------------------------------------
>  x86/svm_tests.c   | 24 ++++++++++------
>  4 files changed, 91 insertions(+), 112 deletions(-)
> 
> diff --git a/lib/x86/svm_lib.h b/lib/x86/svm_lib.h
> index 27c3b137..59db26de 100644
> --- a/lib/x86/svm_lib.h
> +++ b/lib/x86/svm_lib.h
> @@ -71,4 +71,62 @@ u8* svm_get_io_bitmap(void);
>  #define MSR_BITMAP_SIZE 8192
>  
>  
> +struct svm_extra_regs

Why not just svm_gprs?  This could even include RAX by grabbing it from the VMCB
after VMRUN.

> +{
> +    u64 rbx;
> +    u64 rcx;
> +    u64 rdx;
> +    u64 rbp;
> +    u64 rsi;
> +    u64 rdi;
> +    u64 r8;
> +    u64 r9;
> +    u64 r10;
> +    u64 r11;
> +    u64 r12;
> +    u64 r13;
> +    u64 r14;
> +    u64 r15;

Tab instead of spaces.

> +};
> +
> +#define SWAP_GPRS(reg) \
> +		"xchg %%rcx, 0x08(%%" reg ")\n\t"       \

No need for 2-tab indentation.

> +		"xchg %%rdx, 0x10(%%" reg ")\n\t"       \
> +		"xchg %%rbp, 0x18(%%" reg ")\n\t"       \
> +		"xchg %%rsi, 0x20(%%" reg ")\n\t"       \
> +		"xchg %%rdi, 0x28(%%" reg ")\n\t"       \
> +		"xchg %%r8,  0x30(%%" reg ")\n\t"       \
> +		"xchg %%r9,  0x38(%%" reg ")\n\t"       \
> +		"xchg %%r10, 0x40(%%" reg ")\n\t"       \
> +		"xchg %%r11, 0x48(%%" reg ")\n\t"       \
> +		"xchg %%r12, 0x50(%%" reg ")\n\t"       \
> +		"xchg %%r13, 0x58(%%" reg ")\n\t"       \
> +		"xchg %%r14, 0x60(%%" reg ")\n\t"       \
> +		"xchg %%r15, 0x68(%%" reg ")\n\t"       \
> +		\

Extra line.

> +		"xchg %%rbx, 0x00(%%" reg ")\n\t"       \

Why is RBX last here, but first in the struct?  Ah, because the initial swap uses
RBX as the scratch register.  Why use RAX for the post-VMRUN swap?  AFAICT, that's
completely arbitrary.

> +
> +

> +#define __SVM_VMRUN(vmcb, regs, label)          \
> +		asm volatile (                          \

Unnecessarily deep indentation.

> +			"vmload %%rax\n\t"                  \
> +			"push %%rax\n\t"                    \
> +			"push %%rbx\n\t"                    \
> +			SWAP_GPRS("rbx")                    \
> +			".global " label "\n\t"             \
> +			label ": vmrun %%rax\n\t"           \
> +			"vmsave %%rax\n\t"                  \
> +			"pop %%rax\n\t"                     \
> +			SWAP_GPRS("rax")                    \
> +			"pop %%rax\n\t"                     \
> +			:                                   \
> +			: "a" (virt_to_phys(vmcb)),         \
> +			  "b"(regs)                         \
> +			/* clobbers*/                       \
> +			: "memory"                          \
> +		);

If we're going to rewrite this, why not turn it into a proper assembly routine?
E.g. the whole test_run() noinline thing just so that vmrun_rip isn't redefined
is gross.

> diff --git a/x86/svm.c b/x86/svm.c
> index 37b4cd38..9484a6d1 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -76,11 +76,11 @@ static void test_thunk(struct svm_test *test)
>  	vmmcall();
>  }
>  
> -struct regs regs;
> +struct svm_extra_regs regs;
>  
> -struct regs get_regs(void)
> +struct svm_extra_regs* get_regs(void)
>  {
> -	return regs;
> +	return &regs;

This isn't strictly necessary, is it?  I.e. avoiding the copy can be done in a
separate patch, no?

> @@ -2996,7 +2998,7 @@ static void svm_lbrv_test1(void)
>  
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
>  	DO_BRANCH(host_branch1);
> -	SVM_BARE_VMRUN;
> +	SVM_VMRUN(vmcb,regs);

Space after the comma.  Multiple cases below too.

>  	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
>  
>  	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> @@ -3011,6 +3013,8 @@ static void svm_lbrv_test1(void)
>  
>  static void svm_lbrv_test2(void)
>  {
> +	struct svm_extra_regs* regs = get_regs();
> +
>  	report(true, "Test that without LBRV enabled, guest LBR state does 'leak' to the host(2)");
>  
>  	vmcb->save.rip = (ulong)svm_lbrv_test_guest2;
> @@ -3019,7 +3023,7 @@ static void svm_lbrv_test2(void)
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
>  	DO_BRANCH(host_branch2);
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
> -	SVM_BARE_VMRUN;
> +	SVM_VMRUN(vmcb,regs);
>  	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
>  
> @@ -3035,6 +3039,8 @@ static void svm_lbrv_test2(void)
>  
>  static void svm_lbrv_nested_test1(void)
>  {
> +	struct svm_extra_regs* regs = get_regs();
> +
>  	if (!lbrv_supported()) {
>  		report_skip("LBRV not supported in the guest");
>  		return;
> @@ -3047,7 +3053,7 @@ static void svm_lbrv_nested_test1(void)
>  
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
>  	DO_BRANCH(host_branch3);
> -	SVM_BARE_VMRUN;
> +	SVM_VMRUN(vmcb,regs);
>  	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
>  
> @@ -3068,6 +3074,8 @@ static void svm_lbrv_nested_test1(void)
>  
>  static void svm_lbrv_nested_test2(void)
>  {
> +	struct svm_extra_regs* regs = get_regs();
> +
>  	if (!lbrv_supported()) {
>  		report_skip("LBRV not supported in the guest");
>  		return;
> @@ -3083,7 +3091,7 @@ static void svm_lbrv_nested_test2(void)
>  
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
>  	DO_BRANCH(host_branch4);
> -	SVM_BARE_VMRUN;
> +	SVM_VMRUN(vmcb,regs);
>  	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
>  
> -- 
> 2.26.3
> 
