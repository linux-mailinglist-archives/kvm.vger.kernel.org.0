Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6139452EA4
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 11:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233820AbhKPKHs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 05:07:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233829AbhKPKH0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 05:07:26 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAAE2C061767
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 02:04:28 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id q12so5448001pgh.5
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 02:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=oG9TWqcJEpyFfu54m5HeL8IeDLpFQAxLKB8I8m0eRnY=;
        b=RIAaWguwxRMGjVcj2BYVVqFwWnkbamDddh7nNKOJIsrPTdv4DmVY5f+/IHVRgFw4pK
         FWQZxjwuIBUDZezfr3pC5n9NoyO0tGR9tjIYlqm6tWztKBcUmAcELwxylpsQna9WqkYf
         N1/noulTbxLHdYujXy8ug8g9bFUYCw5ofVYDi9tFi4QBe3Oi0Aap2wf1r7VcjZJvPhbC
         8v0LUVQ3EmWw5uZpwUypGTyPuFW660FBi/nrmRy/T2V5iLiS24rQD8zXvyurGGrVHkkt
         pZG02Fvjv1td2Wg90X7LEaW6yQUR4TCh44pd4K+U/lMCu+FHmwbcRD8M1n2pvoabFN3L
         0zjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=oG9TWqcJEpyFfu54m5HeL8IeDLpFQAxLKB8I8m0eRnY=;
        b=4GejYaQo7+AG+gla9Y8U/3i0hmHYp4sHjByUgG7QHSINYayeDr573xMrxSNUDwo8px
         0iChqZpefmf29UDHkMV7DyaDy6bLwOTSLXRb3uZ6DV4KwXJ8LeBIbMmLijAzKDJI/zlM
         eQticj8cQ20Xb/3m7cTK3oY4X4otIAJBEls8UKuN0JFxFC8V5e63EoLxaPJ1Y3aZLTQ5
         8XQ0HHo8KRe+Pga5oxCsloz2f1iZvnegDkYjRJJ7S278zdie8P1fD14eanxz5Ewe+/Jw
         mnCqCM8PBxI6nDHwv8Agp2G1yz7LQxY0JufhXeJEIe0BGV5bzjsTEFOAi4WvBRi26t9l
         r9EQ==
X-Gm-Message-State: AOAM531Ye7WAnOGLKaznQJ7rDg2/o8vmmn3qPjZFRpXHLsK7O4sUFCpv
        2CDxBY9kA0FdrnLtcaZgECHkmo/rsWI=
X-Google-Smtp-Source: ABdhPJwFWLeOzDYl7QdeA+arpympgVtAZf418hOFrzXw1TbYL6TlcsGvlbGrtRFSUb4W9b+Dsg5Sdg==
X-Received: by 2002:a62:1c58:0:b0:49f:d674:e506 with SMTP id c85-20020a621c58000000b0049fd674e506mr39069936pfc.66.1637057068286;
        Tue, 16 Nov 2021 02:04:28 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d6sm17242358pfh.190.2021.11.16.02.04.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 02:04:27 -0800 (PST)
Message-ID: <d0e12764-d426-d38f-5530-a1ee9795a285@gmail.com>
Date:   Tue, 16 Nov 2021 18:04:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH] x86/pmu: Test PMU virtualization on
 emulated instructions
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Eric Hankland <ehankland@google.com>, kvm@vger.kernel.org,
        "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org)" 
        <pbonzini@redhat.com>
References: <20211112235652.1127814-1-jmattson@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <20211112235652.1127814-1-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/11/2021 7:56 am, Jim Mattson wrote:
> Add tests of "instructions retired" and "branch instructions retired,"
> to ensure that these events count emulated instructions.
> 
> Signed-off-by: Eric Hankland <ehankland@google.com>
> [jmattson:
>    - Added command-line parameter to conditionally run the new tests.
>    - Added pmu-emulation test to unittests.cfg
> ]
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>   x86/pmu.c         | 80 +++++++++++++++++++++++++++++++++++++++++++++++
>   x86/unittests.cfg |  7 +++++
>   2 files changed, 87 insertions(+)
> 
> diff --git a/x86/pmu.c b/x86/pmu.c
> index ec61ac956a55..a159333b0c73 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -33,6 +33,12 @@
>   
>   #define N 1000000
>   
> +#define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
> +// These values match the number of instructions and branches in the
> +// assembly block in check_emulated_instr().
> +#define EXPECTED_INSTR 17
> +#define EXPECTED_BRNCH 5
> +
>   typedef struct {
>   	uint32_t ctr;
>   	uint32_t config;
> @@ -468,6 +474,77 @@ static void check_running_counter_wrmsr(void)
>   	report_prefix_pop();
>   }
>   
> +static void check_emulated_instr(void)
> +{
> +	uint64_t status, instr_start, brnch_start;
> +	pmu_counter_t brnch_cnt = {
> +		.ctr = MSR_IA32_PERFCTR0,
> +		/* branch instructions */
> +		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[5].unit_sel,
> +		.count = 0,
> +	};
> +	pmu_counter_t instr_cnt = {
> +		.ctr = MSR_IA32_PERFCTR0 + 1,
> +		/* instructions */
> +		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel,
> +		.count = 0,
> +	};
> +	report_prefix_push("emulated instruction");
> +
> +	wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
> +	      rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
> +
> +	start_event(&brnch_cnt);
> +	start_event(&instr_cnt);
> +
> +	brnch_start = -EXPECTED_BRNCH;
> +	instr_start = -EXPECTED_INSTR;
> +	wrmsr(MSR_IA32_PERFCTR0, brnch_start);
> +	wrmsr(MSR_IA32_PERFCTR0 + 1, instr_start);
> +	// KVM_FEP is a magic prefix that forces emulation so
> +	// 'KVM_FEP "jne label\n"' just counts as a single instruction.
> +	asm volatile(
> +		"mov $0x0, %%eax\n"
> +		"cmp $0x0, %%eax\n"
> +		KVM_FEP "jne label\n"
> +		KVM_FEP "jne label\n"
> +		KVM_FEP "jne label\n"
> +		KVM_FEP "jne label\n"
> +		KVM_FEP "jne label\n"
> +		"mov $0xa, %%eax\n"
> +		"cpuid\n"
> +		"mov $0xa, %%eax\n"
> +		"cpuid\n"
> +		"mov $0xa, %%eax\n"
> +		"cpuid\n"
> +		"mov $0xa, %%eax\n"
> +		"cpuid\n"
> +		"mov $0xa, %%eax\n"
> +		"cpuid\n"
> +		"label:\n"
> +		:
> +		:
> +		: "eax", "ebx", "ecx", "edx");
> +
> +	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
> +
> +	stop_event(&brnch_cnt);
> +	stop_event(&instr_cnt);
> +
> +	// Check that the end count - start count is at least the expected
> +	// number of instructions and branches.
> +	report(instr_cnt.count - instr_start >= EXPECTED_INSTR,
> +	       "instruction count");
> +	report(brnch_cnt.count - brnch_start >= EXPECTED_BRNCH,
> +	       "branch count");
> +	// Additionally check that those counters overflowed properly.
> +	status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
> +	report(status & 1, "instruction counter overflow");
> +	report(status & 2, "branch counter overflow");
> +
> +	report_prefix_pop();
> +}
> +
>   static void check_counters(void)
>   {
>   	check_gp_counters();
> @@ -563,6 +640,9 @@ int main(int ac, char **av)
>   
>   	check_counters();
>   
> +	if (ac > 1 && !strcmp(av[1], "emulation"))
> +		check_emulated_instr();
> +
>   	if (rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES) {
>   		gp_counter_base = MSR_IA32_PMC0;
>   		report_prefix_push("full-width writes");
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 3000e53c790f..2aedb24dc4ff 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -185,6 +185,13 @@ extra_params = -cpu host,migratable=no
>   check = /sys/module/kvm/parameters/ignore_msrs=N
>   check = /proc/sys/kernel/nmi_watchdog=0
>   
> +[pmu_emulation]
> +file = pmu.flat
> +arch = x86_64
> +extra_params = -cpu max -append emulation
> +check = /sys/module/kvm_intel/parameters/force_emulation_prefix=Y

It's "/sys/module/kvm/parameters/force_emulation_prefix=Y",

If it's N, we need a output like "FAIL: check_emulated_instr"
rather than:

Unhandled exception 6 #UD at ip 0000000000401387
error_code=0000      rflags=00010046      cs=00000008
rax=0000000000000000 rcx=00000000000000c2 rdx=00000000ffffffff rbx=00000000009509f4
rbp=0000000000513730 rsi=0000000000000020 rdi=0000000000000034
  r8=0000000000000000  r9=0000000000000020 r10=000000000000000d r11=0000000000000000
r12=000000000000038e r13=0000000000000002 r14=0000000000513d80 r15=0000000000008603
cr0=0000000080010011 cr2=0000000000000000 cr3=0000000001007000 cr4=0000000000000020
cr8=0000000000000000
	STACK: @401387 400384

> +check = /proc/sys/kernel/nmi_watchdog=0
> +
>   [vmware_backdoors]
>   file = vmware_backdoors.flat
>   extra_params = -machine vmport=on -cpu max
> 
