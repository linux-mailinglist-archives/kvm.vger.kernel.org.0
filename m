Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68D736D7B51
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 13:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237908AbjDEL3a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 07:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237907AbjDEL3Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 07:29:25 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B91B527F
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 04:29:20 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-4fa3c1a7a41so316907a12.2
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 04:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680694159;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yiy/yuoSNHLTP2g0kWK+iynp1hgQYX2IcbSZcMLPcD0=;
        b=rxZdxoCJjE2OZQVO76Mm2mYkQv99sJ4LBn3lwF9i1ZyGfAlFnvD6cGrait2/v33scQ
         XmGsqbnz2phSmoceJpIPAc+mq0G1VfWvgF4U3nQw3lVY0brI1bHHgvwpO/rNjZK+QkVP
         sr9AzuK4xQn/Jt2i73T0P9IYJKneCyjWGusz8hHOenAuHTWKSrOb+JAPxgq6YxWIteq2
         uOO0toneZWV7e1F2kzVaU2sd9YJr6CmM4Qdr/IM50rSPdbpgExrqukAzdVzC3PkBHsXI
         Tg7nqRlZmcadquaOOBNF6odjkmIMsOx6FudWLhl7g/wRFgoAmVE7Nd8x2Xr7ixW6qwi5
         LOyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680694159;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yiy/yuoSNHLTP2g0kWK+iynp1hgQYX2IcbSZcMLPcD0=;
        b=qZr9NCOI+/Yu8Wkb7b7dwdcMi7cRW8gROux6GipAr6w2043abKeo/Jm42pY1ya4Top
         2NAEYwWTMYNa89E15kzCh6HBa+oqt/qsfpCcj4V2wxcVeG0epzY4xCEHFuR7lCIWxOWc
         emH2zapHXzyVeQ8dC21sYw4XVSl0QawvTp3Ofv9qTS6jdiP4epIOR+vmRgTPX9qkbs97
         wHh8xQKCjZC223vtid7uW3o9MOeRZeYNrMMUcUXc9+jo3yCf5oT3nRJRjUeHd65n5s9L
         jb0HbzCv8KrjF5W4mJNUkLACtAK8Y1rqPnTCCkOS7zaaZEb8ULQtpf/C7Lq7qQHxjB6z
         8Z9g==
X-Gm-Message-State: AAQBX9erMHEbYsPdqCGPFEVstqOD3LhGl71SZCpO20cOi7jsi/uOzthZ
        UANnyL0zEcVcdK7HUzn/pGjCqQ==
X-Google-Smtp-Source: AKy350ZWlW8gRBR1cg1FMuROkrhNzHRvgc8+brb+r3erf/CHid/zb2Bqx5x9X2ULkIERyBmr4v3W0Q==
X-Received: by 2002:aa7:cf8e:0:b0:4fa:57bf:141a with SMTP id z14-20020aa7cf8e000000b004fa57bf141amr1360422edx.32.1680694158734;
        Wed, 05 Apr 2023 04:29:18 -0700 (PDT)
Received: from ?IPV6:2003:f6:af39:8900:5941:dee7:da1a:b514? (p200300f6af3989005941dee7da1ab514.dip0.t-ipconnect.de. [2003:f6:af39:8900:5941:dee7:da1a:b514])
        by smtp.gmail.com with ESMTPSA id o13-20020a50c90d000000b004f9ca99cf5csm6953193edh.92.2023.04.05.04.29.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 04:29:18 -0700 (PDT)
Message-ID: <8ce083e1-ae19-c9be-4d10-95c5237fce4e@grsecurity.net>
Date:   Wed, 5 Apr 2023 13:29:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [kvm-unit-tests PATCH v4 5/9] x86/access: Add forced emulation
 support
Content-Language: en-US, de-DE
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20230404165341.163500-1-seanjc@google.com>
 <20230404165341.163500-6-seanjc@google.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <20230404165341.163500-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.04.23 18:53, Sean Christopherson wrote:
> From: Mathias Krause <minipli@grsecurity.net>

I saw you did some additional changes. Comments below...

> 
> Add support to force access tests to be handled by the emulator, if
> supported by KVM.  Due to emulation being rather slow, make the forced
> emulation nodefault, i.e. a manual-only testcase.  Note, "manual" just
> means the test runner needs to specify a specific group(s), i.e. the
> test is still easy to enable in CI for compatible setups.
> 
> Manually check for FEP support in the test instead of using the "check"
> option to query the module param, as any non-zero force_emulation_prefix
> value enables FEP (see KVM commit d500e1ed3dc8 ("KVM: x86: Allow clearing
> RFLAGS.RF on forced emulation to test code #DBs") and scripts/runtime.bash
> only supports checking for a single value.
> 
> Defer enabling FEP for the nested VMX variants to a future patch.  KVM has
> a bug related to emulating NOP (yes, NOP) for L2, and the nVMX varaints
                                                                    ~~
typo: variants

> will require additional massaging to propagate the "allow emulation" flag.
> 
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> [sean: make generic fep testcase nodefault instead of impossible]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  x86/access.c      | 38 +++++++++++++++++++++++++++++++-------
>  x86/access.h      |  2 +-
>  x86/access_test.c |  8 +++++---
>  x86/unittests.cfg |  6 ++++++
>  x86/vmx_tests.c   |  2 +-
>  5 files changed, 44 insertions(+), 12 deletions(-)
> 
> diff --git a/x86/access.c b/x86/access.c
> index 1677d52e..4a3ca265 100644
> --- a/x86/access.c
> +++ b/x86/access.c
> @@ -82,7 +82,9 @@ enum {
>  	AC_CPU_CR4_SMEP_BIT,
>  	AC_CPU_CR4_PKE_BIT,
>  
> -	NR_AC_FLAGS
> +	AC_FEP_BIT,
> +
> +	NR_AC_FLAGS,
>  };
>  
>  #define AC_PTE_PRESENT_MASK   (1 << AC_PTE_PRESENT_BIT)
> @@ -121,6 +123,8 @@ enum {
>  #define AC_CPU_CR4_SMEP_MASK  (1 << AC_CPU_CR4_SMEP_BIT)
>  #define AC_CPU_CR4_PKE_MASK   (1 << AC_CPU_CR4_PKE_BIT)
>  
> +#define AC_FEP_MASK           (1 << AC_FEP_BIT)
> +
>  const char *ac_names[] = {
>  	[AC_PTE_PRESENT_BIT] = "pte.p",
>  	[AC_PTE_ACCESSED_BIT] = "pte.a",
> @@ -152,6 +156,7 @@ const char *ac_names[] = {
>  	[AC_CPU_CR0_WP_BIT] = "cr0.wp",
>  	[AC_CPU_CR4_SMEP_BIT] = "cr4.smep",
>  	[AC_CPU_CR4_PKE_BIT] = "cr4.pke",
> +	[AC_FEP_BIT] = "fep",
>  };
>  
>  static inline void *va(pt_element_t phys)
> @@ -799,10 +804,13 @@ static int ac_test_do_access(ac_test_t *at)
>  
>  	if (F(AC_ACCESS_TWICE)) {
>  		asm volatile ("mov $fixed2, %%rsi \n\t"
> -			      "mov (%[addr]), %[reg] \n\t"
> +			      "cmp $0, %[fep] \n\t"
> +			      "jz 1f \n\t"
> +			      KVM_FEP
> +			      "1: mov (%[addr]), %[reg] \n\t"
>  			      "fixed2:"
>  			      : [reg]"=r"(r), [fault]"=a"(fault), "=b"(e)
> -			      : [addr]"r"(at->virt)
> +			      : [addr]"r"(at->virt), [fep]"r"(F(AC_FEP))
>  			      : "rsi");
>  		fault = 0;
>  	}
> @@ -823,9 +831,15 @@ static int ac_test_do_access(ac_test_t *at)
>  		      "jnz 2f \n\t"
>  		      "cmp $0, %[write] \n\t"
>  		      "jnz 1f \n\t"
> -		      "mov (%[addr]), %[reg] \n\t"
> +		      "cmp $0, %[fep] \n\t"
> +		      "jz 0f \n\t"
> +		      KVM_FEP
> +		      "0: mov (%[addr]), %[reg] \n\t"
>  		      "jmp done \n\t"
> -		      "1: mov %[reg], (%[addr]) \n\t"
> +		      "1: cmp $0, %[fep] \n\t"
> +		      "jz 0f \n\t"
> +		      KVM_FEP
> +		      "0: mov %[reg], (%[addr]) \n\t"
>  		      "jmp done \n\t"
>  		      "2: call *%[addr] \n\t"
>  		      "done: \n"
> @@ -843,6 +857,7 @@ static int ac_test_do_access(ac_test_t *at)
>  			[write]"r"(F(AC_ACCESS_WRITE)),
>  			[user]"r"(F(AC_ACCESS_USER)),
>  			[fetch]"r"(F(AC_ACCESS_FETCH)),
> +			[fep]"r"(F(AC_FEP)),
>  			[user_ds]"i"(USER_DS),
>  			[user_cs]"i"(USER_CS),
>  			[user_stack_top]"r"(user_stack + sizeof user_stack),
> @@ -1209,12 +1224,17 @@ const ac_test_fn ac_test_cases[] =
>  	check_effective_sp_permissions,
>  };
>  
> -void ac_test_run(int pt_levels)
> +void ac_test_run(int pt_levels, bool force_emulation)
>  {
>  	ac_test_t at;
>  	ac_pt_env_t pt_env;
>  	int i, tests, successes;
>  
> +	if (force_emulation && !is_fep_available()) {
> +		report_skip("Forced emulation prefix (FEP) not available\n");

Trailing "\n" isn't needed, report_skip() already emits one.

> +		return;
> +	}
> +
>  	printf("run\n");
>  	tests = successes = 0;
>  
> @@ -1232,6 +1252,9 @@ void ac_test_run(int pt_levels)
>  		invalid_mask |= AC_PTE_BIT36_MASK;
>  	}
>  
> +	if (!force_emulation)
> +		invalid_mask |= AC_FEP_MASK;
> +
>  	ac_env_int(&pt_env, pt_levels);
>  	ac_test_init(&at, 0xffff923400000000ul, &pt_env);
>  
> @@ -1292,5 +1315,6 @@ void ac_test_run(int pt_levels)
>  
>  	printf("\n%d tests, %d failures\n", tests, tests - successes);
>  
> -	report(successes == tests, "%d-level paging tests", pt_levels);
> +	report(successes == tests, "%d-level paging tests%s", pt_levels,
> +	       force_emulation ? " (with forced emulation)" : "");
>  }
> diff --git a/x86/access.h b/x86/access.h
> index 9a6c5628..206a1c86 100644
> --- a/x86/access.h
> +++ b/x86/access.h
> @@ -4,6 +4,6 @@
>  #define PT_LEVEL_PML4 4
>  #define PT_LEVEL_PML5 5
>  
> -void ac_test_run(int page_table_levels);
> +void ac_test_run(int page_table_levels, bool force_emulation);
>  
>  #endif // X86_ACCESS_H

> \ No newline at end of file

Maybe fix that while already touching the file?

> diff --git a/x86/access_test.c b/x86/access_test.c
> index 2ac649d2..025294da 100644
> --- a/x86/access_test.c
> +++ b/x86/access_test.c
> @@ -3,10 +3,12 @@
>  #include "x86/vm.h"
>  #include "access.h"
>  
> -int main(void)
> +int main(int argc, const char *argv[])
>  {
> +	bool force_emulation = argc >= 2 && !strcmp(argv[1], "force_emulation");
> +
>  	printf("starting test\n\n");
> -	ac_test_run(PT_LEVEL_PML4);
> +	ac_test_run(PT_LEVEL_PML4, force_emulation);
>  
>  #ifndef CONFIG_EFI
>  	/*
> @@ -16,7 +18,7 @@ int main(void)
>  	if (this_cpu_has(X86_FEATURE_LA57)) {
>  		printf("starting 5-level paging test.\n\n");
>  		setup_5level_page_table();
> -		ac_test_run(PT_LEVEL_PML5);
> +		ac_test_run(PT_LEVEL_PML5, force_emulation);
>  	}
>  #endif
>  
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index f324e32d..6194e0ea 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -143,6 +143,12 @@ file = access_test.flat
>  arch = x86_64
>  extra_params = -cpu max
>  
> +[access_fep]
> +file = access_test.flat
> +arch = x86_64
> +extra_params = -cpu max -append force_emulation
> +groups = nodefault
> +
>  [access-reduced-maxphyaddr]
>  file = access_test.flat
>  arch = x86_64
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 7bba8165..617b97b3 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -10460,7 +10460,7 @@ static void atomic_switch_overflow_msrs_test(void)
>  
>  static void vmx_pf_exception_test_guest(void)
>  {
> -	ac_test_run(PT_LEVEL_PML4);
> +	ac_test_run(PT_LEVEL_PML4, false);
>  }
>  
>  typedef void (*invalidate_tlb_t)(void *data);
