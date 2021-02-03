Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A06CF30D507
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 09:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbhBCIRG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 03:17:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25378 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232332AbhBCIQx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 03:16:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612340127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9nYU0rmNi/FVTvyhUMIrhswL5GXbiPPLw7/MBjuZUqE=;
        b=UNI8EDRnnBJv8BfJxeXoKxegbfsT958KmU9LfTznccwyqdoWgnwuJL0brFgNaacLx+tXIS
        ITBEvtVzI6SMm2eqeJldKKvpSx5ELSjwy/8tioTXsiQ8zxxjcFr8OcuXAi3vKf6p7PR6jQ
        yruvB2i3vU/CbcOeJ+6CF4mkB6x+WUk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-q67QdXfDMv2ep8dk6hT00w-1; Wed, 03 Feb 2021 03:15:25 -0500
X-MC-Unique: q67QdXfDMv2ep8dk6hT00w-1
Received: by mail-ed1-f72.google.com with SMTP id bd22so5098151edb.4
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 00:15:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9nYU0rmNi/FVTvyhUMIrhswL5GXbiPPLw7/MBjuZUqE=;
        b=UWFXaanIDDGmGna7vd2cM+z3aQxKZFyw50T0nTGEF6SVMicO0JrPh5pzJVbrlCVH/8
         XncJEOF/nVvqy5aV6c5MdC2J08UhRMv8aKYwyOMFcPfhcjyElFKMQvRoOmL30kQZTNjw
         WDyoKn2o097ldIsaDeY7hDQrCNf/PxFpKnbI/3CAsk0V5Eq2PSE1J0UhdP4HxEsUHw8y
         YDaG0wkgWOsTGQRe6+3/r6uH9+AO1XrUd63dpibzc6txRuNLtkLFNhIDWhrNpeg8pP6M
         TFCsktMawxQCzomV+4wYjxMnVdw0OlzK9SNL+JcYa8YJvHMrbH7ftMJ+1IUzqlQrMGMa
         3Pgg==
X-Gm-Message-State: AOAM533zFGE6KNjdEU+60Y4XEZNWpCoyQ/SYNodz6+qcGMWIemFpsVY6
        8iXn+IeHMkjgo8e4gJFDE4UqsKrg50ajsRUY/okYRiYoPvnO+jW7zdcLnDXE+/A2Y83MkmXgHKE
        hxQbhWrVhwk0X
X-Received: by 2002:a17:906:e18:: with SMTP id l24mr2006453eji.500.1612340123685;
        Wed, 03 Feb 2021 00:15:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJydWd5a7AIAdf+LfaU4I5gqZBQna9jriK4TwEgQzbcexzgLkG1qu4TOKJgq27oZIESuxi24Cw==
X-Received: by 2002:a17:906:e18:: with SMTP id l24mr2006444eji.500.1612340123519;
        Wed, 03 Feb 2021 00:15:23 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x20sm623977ejv.66.2021.02.03.00.15.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 00:15:22 -0800 (PST)
Subject: Re: [PATCH 2/3] nVMX: Add helper functions to set/unset host
 RFLAGS.TF on the VMRUN instruction
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com
References: <20210203012842.101447-1-krish.sadhukhan@oracle.com>
 <20210203012842.101447-3-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7599c931-e5a1-1a49-afe9-763b73175866@redhat.com>
Date:   Wed, 3 Feb 2021 09:15:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210203012842.101447-3-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/21 02:28, Krish Sadhukhan wrote:
> Add helper functions to set host RFLAGS.TF immediately before the VMRUN
> instruction. These will be used  by the next patch to test Single Stepping
> on the VMRUN instruction from the host's perspective.
> 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

I think you can use prepare_gif_clear to set RFLAGS.TF and the exception 
handler can:

1) look for VMRUN at the interrupted EIP.  If it is there store the 
VMRUN address and set a flag.

2) on the next #DB (flag set), store the EIP and clear the flag

The finished callback then checks that the EIP was stored and that the 
two EIPs are 3 bytes apart (the length of a VMRUN).

Paolo

> ---
>   x86/svm.c       | 24 ++++++++++++++++++++++--
>   x86/svm.h       |  3 +++
>   x86/svm_tests.c |  1 -
>   3 files changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/x86/svm.c b/x86/svm.c
> index a1808c7..547f62a 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -179,6 +179,17 @@ void vmcb_ident(struct vmcb *vmcb)
>   	}
>   }
>   
> +static bool ss_bp_on_vmrun = false;
> +void set_ss_bp_on_vmrun(void)
> +{
> +	ss_bp_on_vmrun = true;
> +}
> +
> +void unset_ss_bp_on_vmrun(void)
> +{
> +	ss_bp_on_vmrun = false;
> +}
> +
>   struct regs regs;
>   
>   struct regs get_regs(void)
> @@ -215,6 +226,12 @@ struct svm_test *v2_test;
>                   "mov regs, %%r15\n\t"           \
>                   "mov %%r15, 0x1f8(%%rax)\n\t"   \
>                   LOAD_GPR_C                      \
> +                "cmpb $0, %[ss_bp]\n\t"         \
> +                "je 1f\n\t"                     \
> +                "pushf; pop %%r8\n\t"           \
> +                "or $0x100, %%r8\n\t"           \
> +                "push %%r8; popf\n\t"           \
> +                "1: "                           \
>                   "vmrun %%rax\n\t"               \
>                   SAVE_GPR_C                      \
>                   "mov 0x170(%%rax), %%r15\n\t"   \
> @@ -234,7 +251,8 @@ int svm_vmrun(void)
>   	asm volatile (
>   		ASM_VMRUN_CMD
>   		:
> -		: "a" (virt_to_phys(vmcb))
> +		: "a" (virt_to_phys(vmcb)),
> +		[ss_bp]"m"(ss_bp_on_vmrun)
>   		: "memory", "r15");
>   
>   	return (vmcb->control.exit_code);
> @@ -253,6 +271,7 @@ static void test_run(struct svm_test *test)
>   	do {
>   		struct svm_test *the_test = test;
>   		u64 the_vmcb = vmcb_phys;
> +
>   		asm volatile (
>   			"clgi;\n\t" // semi-colon needed for LLVM compatibility
>   			"sti \n\t"
> @@ -266,7 +285,8 @@ static void test_run(struct svm_test *test)
>   			"=b" (the_vmcb)             // callee save register!
>   			: [test] "0" (the_test),
>   			[vmcb_phys] "1"(the_vmcb),
> -			[PREPARE_GIF_CLEAR] "i" (offsetof(struct svm_test, prepare_gif_clear))
> +			[PREPARE_GIF_CLEAR] "i" (offsetof(struct svm_test, prepare_gif_clear)),
> +			[ss_bp]"m"(ss_bp_on_vmrun)
>   			: "rax", "rcx", "rdx", "rsi",
>   			"r8", "r9", "r10", "r11" , "r12", "r13", "r14", "r15",
>   			"memory");
> diff --git a/x86/svm.h b/x86/svm.h
> index a0863b8..d521972 100644
> --- a/x86/svm.h
> +++ b/x86/svm.h
> @@ -391,6 +391,9 @@ void vmcb_ident(struct vmcb *vmcb);
>   struct regs get_regs(void);
>   void vmmcall(void);
>   int svm_vmrun(void);
> +int svm_vmrun1(void);
> +void set_ss_bp_on_vmrun(void);
> +void unset_ss_bp_on_vmrun(void);
>   void test_set_guest(test_guest_func func);
>   
>   extern struct vmcb *vmcb;
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 29a0b59..7bf3624 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -2046,7 +2046,6 @@ static void basic_guest_main(struct svm_test *test)
>   {
>   }
>   
> -
>   #define SVM_TEST_REG_RESERVED_BITS(start, end, inc, str_name, reg, val,	\
>   				   resv_mask)				\
>   {									\
> 

