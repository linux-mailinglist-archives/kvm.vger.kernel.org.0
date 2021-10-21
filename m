Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5594363D4
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 16:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhJUOOe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 10:14:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27737 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230436AbhJUOOd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 10:14:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634825537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nArNpwCBveTY1Zh8asuGqbOOeCLw6KmDh8uDhIIa0do=;
        b=Q17kQqyU7WU0246tR2t1JZkqV9Xn6+MOjT3qaY2smb9H0B45nRVHPYQjYkhDy4y4QNvLZ1
        oo0D6eA9wmFi+ptMg/Tr9I5xCFpqwxA/JMVJ0psY8vwhpTd63nC9SN0Lcw3pJ69GSshS3e
        lIUnuy3qDlL3iOuV2MmWwm7UhbZKqF0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-U6yfTT71Ohex1XhJ3byhHQ-1; Thu, 21 Oct 2021 10:12:15 -0400
X-MC-Unique: U6yfTT71Ohex1XhJ3byhHQ-1
Received: by mail-ed1-f72.google.com with SMTP id r25-20020a05640216d900b003dca3501ab4so449440edx.15
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 07:12:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nArNpwCBveTY1Zh8asuGqbOOeCLw6KmDh8uDhIIa0do=;
        b=lb1ZOW4ZJAIS5F8gn1EMYDyMx+jVmdc8lwckzRZ/0jzWJrxBx+SDfHjhFyenPzXW9S
         ifV+xxHLybrmUkdAcC+etx2VtYhqRBEbqyjo3LpAC+yfPZ0UwJ7UUZyvctt+sg5hjySM
         XnOGmJ09YZdhea2N6le3ZZCuflUMgRNL/eMTskfLYHIaYdMHDAZy0uYy0dyUuaEPLglU
         L1Du4AAnT7wrThPvUa0E2aIhJOWrbY+FXt4knJSzefxCMjPAL/QCt0k0+cm0V+LK8fiH
         a/zdHisq029QV1z9YbuyrH3a773fK4JSmB+RYO2DD9YwNOraKJLSfnS4p9PT3H2K0Y4q
         RAlA==
X-Gm-Message-State: AOAM530WKHpw5fSwBiOsBwUxYuMuq8hKY0JgpDjFOTWbn3Im0OEPSDgY
        PJHVMRYEdJgiwCNYwbZLFVYFMFwu8FSIZS7DLlT6ivU9LNub6LUmB5bKaysCYMNmNqOqxXjCTFr
        6LzMAjANRhMJt
X-Received: by 2002:a17:906:2ccf:: with SMTP id r15mr7518569ejr.182.1634825534576;
        Thu, 21 Oct 2021 07:12:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzeLqTGyqphwdFeuMmROC8pp1hnu33Rqilp8MO3FoDICfKXTXZC8j5bnTF3WWxf2PpJNZ/jfg==
X-Received: by 2002:a17:906:2ccf:: with SMTP id r15mr7518535ejr.182.1634825534314;
        Thu, 21 Oct 2021 07:12:14 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id s12sm2899311edj.82.2021.10.21.07.12.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 07:12:13 -0700 (PDT)
Message-ID: <7179dbe7-b5bb-7336-bda7-6207979bc52b@redhat.com>
Date:   Thu, 21 Oct 2021 16:12:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH v3 11/17] x86 UEFI: Convert x86 test cases
 to PIC
Content-Language: en-US
To:     Zixuan Wang <zxwang42@gmail.com>, kvm@vger.kernel.org,
        drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
References: <20211004204931.1537823-1-zxwang42@gmail.com>
 <20211004204931.1537823-12-zxwang42@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211004204931.1537823-12-zxwang42@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/10/21 22:49, Zixuan Wang wrote:
> From: Zixuan Wang <zixuanwang@google.com>
> 
> UEFI loads EFI applications to dynamic runtime addresses, so it requires
> all applications to be compiled as PIC (position independent code). PIC
> does not allow the usage of compile time absolute address.
> 
> This commit converts multiple x86 test cases to PIC so they can compile
> and run in UEFI:
> 
> - x86/cet.efi
> 
> - x86/emulator.c: x86/emulator.c depends on lib/x86/usermode.c. But
> usermode.c contains non-PIC inline assembly code. This commit converts
> lib/x86/usermode.c and x86/emulator.c to PIC, so x86/emulator.c can
> compile and run in UEFI.
> 
> - x86/vmware_backdoors.c: it depends on lib/x86/usermode.c and now works
> without modifications
> 
> - x86/eventinj.c
> 
> - x86/smap.c
> 
> - x86/access.c
> 
> - x86/umip.c
> 
> Signed-off-by: Zixuan Wang <zixuanwang@google.com>
> ---
>   lib/x86/usermode.c  |  3 ++-
>   x86/Makefile.common | 10 +++++-----
>   x86/Makefile.x86_64 |  7 ++++---
>   x86/access.c        |  9 +++++----
>   x86/cet.c           |  8 +++++---
>   x86/emulator.c      |  5 +++--
>   x86/eventinj.c      |  6 ++++--
>   x86/smap.c          |  8 ++++----
>   x86/umip.c          | 10 +++++++---
>   9 files changed, 39 insertions(+), 27 deletions(-)
> 
> diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
> index f032523..c550545 100644
> --- a/lib/x86/usermode.c
> +++ b/lib/x86/usermode.c
> @@ -58,7 +58,8 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
>   			"pushq %[user_stack_top]\n\t"
>   			"pushfq\n\t"
>   			"pushq %[user_cs]\n\t"
> -			"pushq $user_mode\n\t"
> +			"lea user_mode(%%rip), %%rdx\n\t"
> +			"pushq %%rdx\n\t"
>   			"iretq\n"
>   
>   			"user_mode:\n\t"
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index 4859bf3..959379c 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -81,16 +81,16 @@ tests-common = $(TEST_DIR)/vmexit.$(exe) $(TEST_DIR)/tsc.$(exe) \
>                  $(TEST_DIR)/init.$(exe) \
>                  $(TEST_DIR)/hyperv_synic.$(exe) $(TEST_DIR)/hyperv_stimer.$(exe) \
>                  $(TEST_DIR)/hyperv_connections.$(exe) \
> -               $(TEST_DIR)/tsx-ctrl.$(exe)
> +               $(TEST_DIR)/tsx-ctrl.$(exe) \
> +	       $(TEST_DIR)/eventinj.$(exe) \
> +               $(TEST_DIR)/umip.$(exe)
>   
>   # The following test cases are disabled when building EFI tests because they
>   # use absolute addresses in their inline assembly code, which cannot compile
>   # with the '-fPIC' flag
>   ifneq ($(TARGET_EFI),y)
> -tests-common += $(TEST_DIR)/eventinj.$(exe) \
> -                $(TEST_DIR)/smap.$(exe) \
> -                $(TEST_DIR)/realmode.$(exe) \
> -                $(TEST_DIR)/umip.$(exe)
> +tests-common += $(TEST_DIR)/smap.$(exe) \
> +                $(TEST_DIR)/realmode.$(exe)
>   endif
>   
>   test_cases: $(tests-common) $(tests)
> diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
> index aa23b22..7e8a57a 100644
> --- a/x86/Makefile.x86_64
> +++ b/x86/Makefile.x86_64
> @@ -30,20 +30,21 @@ tests += $(TEST_DIR)/intel-iommu.$(exe)
>   tests += $(TEST_DIR)/rdpru.$(exe)
>   tests += $(TEST_DIR)/pks.$(exe)
>   tests += $(TEST_DIR)/pmu_lbr.$(exe)
> +tests += $(TEST_DIR)/emulator.$(exe)
> +tests += $(TEST_DIR)/vmware_backdoors.$(exe)
>   
>   # The following test cases are disabled when building EFI tests because they
>   # use absolute addresses in their inline assembly code, which cannot compile
>   # with the '-fPIC' flag
>   ifneq ($(TARGET_EFI),y)
>   tests += $(TEST_DIR)/access.$(exe)
> -tests += $(TEST_DIR)/emulator.$(exe)
>   tests += $(TEST_DIR)/svm.$(exe)
>   tests += $(TEST_DIR)/vmx.$(exe)
> -tests += $(TEST_DIR)/vmware_backdoors.$(exe)
> +endif
> +
>   ifneq ($(fcf_protection_full),)
>   tests += $(TEST_DIR)/cet.$(exe)
>   endif
> -endif
>   
>   include $(SRCDIR)/$(TEST_DIR)/Makefile.common
>   
> diff --git a/x86/access.c b/x86/access.c
> index 4725bbd..8d620a7 100644
> --- a/x86/access.c
> +++ b/x86/access.c
> @@ -700,7 +700,7 @@ static int ac_test_do_access(ac_test_t *at)
>   
>       if (F(AC_ACCESS_TWICE)) {
>   	asm volatile (
> -	    "mov $fixed2, %%rsi \n\t"
> +	    "lea fixed2(%%rip), %%rsi \n\t"
>   	    "mov (%[addr]), %[reg] \n\t"
>   	    "fixed2:"
>   	    : [reg]"=r"(r), [fault]"=a"(fault), "=b"(e)
> @@ -710,7 +710,7 @@ static int ac_test_do_access(ac_test_t *at)
>   	fault = 0;
>       }
>   
> -    asm volatile ("mov $fixed1, %%rsi \n\t"
> +    asm volatile ("lea fixed1(%%rip), %%rsi \n\t"
>   		  "mov %%rsp, %%rdx \n\t"
>   		  "cmp $0, %[user] \n\t"
>   		  "jz do_access \n\t"
> @@ -719,7 +719,8 @@ static int ac_test_do_access(ac_test_t *at)
>   		  "pushq %[user_stack_top] \n\t"
>   		  "pushfq \n\t"
>   		  "pushq %[user_cs] \n\t"
> -		  "pushq $do_access \n\t"
> +		  "lea do_access(%%rip), %%r8\n\t"
> +		  "pushq %%r8\n\t"
>   		  "iretq \n"
>   		  "do_access: \n\t"
>   		  "cmp $0, %[fetch] \n\t"
> @@ -744,7 +745,7 @@ static int ac_test_do_access(ac_test_t *at)
>   		    [user_cs]"i"(USER_CS),
>   		    [user_stack_top]"r"(user_stack + sizeof user_stack),
>   		    [kernel_entry_vector]"i"(0x20)
> -		  : "rsi");
> +		  : "rsi", "r8");
>   
>       asm volatile (".section .text.pf \n\t"
>   		  "page_fault: \n\t"
> diff --git a/x86/cet.c b/x86/cet.c
> index a21577a..a4b79cb 100644
> --- a/x86/cet.c
> +++ b/x86/cet.c
> @@ -52,7 +52,7 @@ static u64 cet_ibt_func(void)
>   	printf("No endbr64 instruction at jmp target, this triggers #CP...\n");
>   	asm volatile ("movq $2, %rcx\n"
>   		      "dec %rcx\n"
> -		      "leaq 2f, %rax\n"
> +		      "leaq 2f(%rip), %rax\n"
>   		      "jmp *%rax \n"
>   		      "2:\n"
>   		      "dec %rcx\n");
> @@ -67,7 +67,8 @@ void test_func(void) {
>   			"pushq %[user_stack_top]\n\t"
>   			"pushfq\n\t"
>   			"pushq %[user_cs]\n\t"
> -			"pushq $user_mode\n\t"
> +			"lea user_mode(%%rip), %%rax\n\t"
> +			"pushq %%rax\n\t"
>   			"iretq\n"
>   
>   			"user_mode:\n\t"
> @@ -77,7 +78,8 @@ void test_func(void) {
>   			[user_ds]"i"(USER_DS),
>   			[user_cs]"i"(USER_CS),
>   			[user_stack_top]"r"(user_stack +
> -					sizeof(user_stack)));
> +					sizeof(user_stack))
> +			: "rax");
>   }
>   
>   #define SAVE_REGS() \
> diff --git a/x86/emulator.c b/x86/emulator.c
> index 9fda1a0..4d2de24 100644
> --- a/x86/emulator.c
> +++ b/x86/emulator.c
> @@ -262,12 +262,13 @@ static void test_pop(void *mem)
>   
>   	asm volatile("mov %%rsp, %[tmp] \n\t"
>   		     "mov %[stack_top], %%rsp \n\t"
> -		     "push $1f \n\t"
> +		     "lea 1f(%%rip), %%rax \n\t"
> +		     "push %%rax \n\t"
>   		     "ret \n\t"
>   		     "2: jmp 2b \n\t"
>   		     "1: mov %[tmp], %%rsp"
>   		     : [tmp]"=&r"(tmp) : [stack_top]"r"(stack_top)
> -		     : "memory");
> +		     : "memory", "rax");
>   	report(1, "ret");
>   
>   	stack_top[-1] = 0x778899;
> diff --git a/x86/eventinj.c b/x86/eventinj.c
> index 46593c9..0cd68e8 100644
> --- a/x86/eventinj.c
> +++ b/x86/eventinj.c
> @@ -155,9 +155,11 @@ asm("do_iret:"
>   	"pushf"W" \n\t"
>   	"mov %cs, %ecx \n\t"
>   	"push"W" %"R "cx \n\t"
> -	"push"W" $2f \n\t"
> +	"lea"W" 2f(%"R "ip), %"R "bx \n\t"
> +	"push"W" %"R "bx \n\t"
>   
> -	"cmpb $0, no_test_device\n\t"	// see if need to flush
> +	"mov no_test_device(%"R "ip), %bl \n\t"
> +	"cmpb $0, %bl\n\t"		// see if need to flush
>   	"jnz 1f\n\t"
>   	"outl %eax, $0xe4 \n\t"		// flush page
>   	"1: \n\t"
> diff --git a/x86/smap.c b/x86/smap.c
> index ac2c8d5..b3ee16f 100644
> --- a/x86/smap.c
> +++ b/x86/smap.c
> @@ -161,10 +161,10 @@ int main(int ac, char **av)
>   		test = -1;
>   		asm("or $(" xstr(USER_BASE) "), %"R "sp \n"
>   		    "push $44 \n "
> -		    "decl test\n"
> +		    "decl test(%"R "ip)\n"
>   		    "and $~(" xstr(USER_BASE) "), %"R "sp \n"
>   		    "pop %"R "ax\n"
> -		    "movl %eax, test");
> +		    "movl %eax, test(%"R "ip)");
>   		report(pf_count == 0 && test == 44,
>   		       "write to user stack with AC=1");
>   
> @@ -173,10 +173,10 @@ int main(int ac, char **av)
>   		test = -1;
>   		asm("or $(" xstr(USER_BASE) "), %"R "sp \n"
>   		    "push $45 \n "
> -		    "decl test\n"
> +		    "decl test(%"R "ip)\n"
>   		    "and $~(" xstr(USER_BASE) "), %"R "sp \n"
>   		    "pop %"R "ax\n"
> -		    "movl %eax, test");
> +		    "movl %eax, test(%"R "ip)");
>   		report(pf_count == 1 && test == 45 && save == -1,
>   		       "write to user stack with AC=0");
>   
> diff --git a/x86/umip.c b/x86/umip.c
> index c5700b3..8b4e798 100644
> --- a/x86/umip.c
> +++ b/x86/umip.c
> @@ -23,7 +23,10 @@ static void gp_handler(struct ex_regs *regs)
>   
>   #define GP_ASM(stmt, in, clobber)                  \
>       asm volatile (                                 \
> -          "mov" W " $1f, %[expected_rip]\n\t"      \
> +          "push" W " %%" R "ax\n\t"                \
> +	  "lea 1f(%%" R "ip), %%" R "ax\n\t"       \
> +          "mov %%" R "ax, %[expected_rip]\n\t"     \
> +          "pop" W " %%" R "ax\n\t"                 \
>             "movl $2f-1f, %[skip_count]\n\t"         \
>             "1: " stmt "\n\t"                        \
>             "2: "                                    \
> @@ -130,7 +133,8 @@ static int do_ring3(void (*fn)(const char *), const char *arg)
>   		  "push" W " %%" R "dx \n\t"
>   		  "pushf" W "\n\t"
>   		  "push" W " %[user_cs] \n\t"
> -		  "push" W " $1f \n\t"
> +		  "lea 1f(%%" R "ip), %%" R "dx \n\t"
> +		  "push" W " %%" R "dx \n\t"
>   		  "iret" W "\n"
>   		  "1: \n\t"
>   		  "push %%" R "cx\n\t"   /* save kernel SP */
> @@ -144,7 +148,7 @@ static int do_ring3(void (*fn)(const char *), const char *arg)
>   #endif
>   
>   		  "pop %%" R "cx\n\t"
> -		  "mov $1f, %%" R "dx\n\t"
> +		  "lea 1f(%%" R "ip), %%" R "dx\n\t"
>   		  "int %[kernel_entry_vector]\n\t"
>   		  ".section .text.entry \n\t"
>   		  "kernel_entry: \n\t"
> 

I have left this patch out for now, because it breaks 32-bit builds. 
It's not a huge deal and can be redone on top of the rest.

Paolo

