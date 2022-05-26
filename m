Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7729534CBC
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 11:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236591AbiEZJs4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 05:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbiEZJsz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 05:48:55 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CC9558B
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 02:48:54 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id o9-20020a17090a0a0900b001df3fc52ea7so3962768pjo.3
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 02:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:cc:in-reply-to:content-transfer-encoding;
        bh=upNI26380bj4IXKgatol2WRzPPPdwbs2s762s6w4I48=;
        b=OzWrdE9sj9UWm0+vS6pfpsALg5KBvQFJZoMuRmwXzA4eaOgfZK1v9tbozNal3M8tb4
         0UujFCtnEYEWVdecY3MxkENhr83AqiYcqQfCbxp4IKYCcxDl8tFjGOvDrwYOfpwhw4l+
         KifN7kOtTE/GWvJUiAoXsPrmHSSh/f7Q+fCHv+5jZg2qelqAtvWlKwdaiiG/lfUiS0x7
         xHOt4HmnstGrBmWEAjgBQoX3M8qt/CcAIUwdHLCv2SHP8oFjnFoYbGr3HWfpIXremkmO
         MBSUEvsjfn388of95sgLXaqOk/kBto+dyS0WKCV0UUt+WmmmGgTWB7j06pQMlP97SWjT
         d95A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:cc:in-reply-to
         :content-transfer-encoding;
        bh=upNI26380bj4IXKgatol2WRzPPPdwbs2s762s6w4I48=;
        b=s92z8KoEcZC++F9EC1K0+HxUxIxyhoz6gMMe9Xo7ITTlClbPn8N6PwhcAklkoBXm8J
         wPVxcWbEs9sWjOXm3p0K5m3KayhhwfKLMf3jcY0+JJAKW1qT8Lv1dhTrCDinnREn+3LU
         5MrKB8g7F0suD/Sf1wJ9y35YiGxc+uV2Qb0Ql38gZ3yW0Fgodz11BzMhxr9I8xlzB9ah
         P7DJrorwI4lwaYpTtP5lIGEvF4KNR09Pia+e8hrDGSdRS2kQK88Kt5PuFKDMrYvjnRT0
         Tf08ta20W9hSZJMF0EvsQRkyBcISh25UZ6Pzlf8MrU7C6Kag0igYN1KA1dSj5a01Ugdx
         nxJA==
X-Gm-Message-State: AOAM533wtUQCDPtjHrjVnOgROMfGH/0DHWTREZj83PVR89atGX4unT8f
        DZM/Lo6V+mpCu5nl/ZyPGv4=
X-Google-Smtp-Source: ABdhPJy/i5KFgRmSuhslIg4fFPuLkGOAYO+KwMcOw0Qkkoh+7kaEq5udREI4++nZMg0V9FHBIEWmZw==
X-Received: by 2002:a17:90b:380f:b0:1e0:9a0:4a99 with SMTP id mq15-20020a17090b380f00b001e009a04a99mr1763806pjb.158.1653558533838;
        Thu, 26 May 2022 02:48:53 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.20])
        by smtp.gmail.com with ESMTPSA id d5-20020aa78685000000b0050dc76281e6sm983993pfo.192.2022.05.26.02.48.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 May 2022 02:48:53 -0700 (PDT)
Message-ID: <98c67c7b-5121-9c05-d534-18ca2777e79c@gmail.com>
Date:   Thu, 26 May 2022 17:48:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [kvm-unit-tests PATCH v2] x86: vpmu: Add tests for Arch LBR
 support
Content-Language: en-US
To:     Yang Weijiang <weijiang.yang@intel.com>
References: <1629961999-23407-1-git-send-email-weijiang.yang@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
Cc:     "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>
In-Reply-To: <1629961999-23407-1-git-send-email-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi weijiang, would you help update the status of this test ?

On 26/8/2021 3:13 pm, Yang Weijiang wrote:
> The added code is to check whether basic Arch LBR function is supported
> in guest, including read/write to LBR record MSRs, validation of control/
> depth MSRs, write to depth MSR resetting all record MSRs and xsaves/xrstors
> support for guest Arch LBR. The purpose of the code is to do basic checks for
> Arch LBR, not to make everything around Arch LBR be tested.
> 
> Change in v2:
> - Per Like's review feedback, changed below things:
>    1. Combined Arch LBR tests with existing LBR tests.
>    2. Added sanity check tests for control & depth MSRs.
>    3. Added test for write depth MSR to reset all record MSRs.
> - Added more test checkpoints in output report.
> - Refactored part of the code.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>   x86/pmu_lbr.c | 292 +++++++++++++++++++++++++++++++++++++++++++++++---
>   1 file changed, 275 insertions(+), 17 deletions(-)
> 
> diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
> index 3bd9e9f..6c22cad 100644
> --- a/x86/pmu_lbr.c
> +++ b/x86/pmu_lbr.c
> @@ -1,19 +1,88 @@
> +#include "asm-generic/page.h"
>   #include "x86/msr.h"
>   #include "x86/processor.h"
>   #include "x86/desc.h"
> +#include "bitops.h"
>   
>   #define N 1000000
> -#define MAX_NUM_LBR_ENTRY	  32
> -#define DEBUGCTLMSR_LBR	  (1UL <<  0)
> -#define PMU_CAP_LBR_FMT	  0x3f
> +#define MAX_NUM_LBR_ENTRY	32
> +#define DEBUGCTLMSR_LBR 	(1UL <<  0)
> +#define PMU_CAP_LBR_FMT 	0x3f
>   
>   #define MSR_LBR_NHM_FROM	0x00000680
>   #define MSR_LBR_NHM_TO		0x000006c0
>   #define MSR_LBR_CORE_FROM	0x00000040
> -#define MSR_LBR_CORE_TO	0x00000060
> +#define MSR_LBR_CORE_TO 	0x00000060
>   #define MSR_LBR_TOS		0x000001c9
>   #define MSR_LBR_SELECT		0x000001c8
>   
> +#define MSR_ARCH_LBR_CTL       0x000014ce
> +#define MSR_ARCH_LBR_DEPTH     0x000014cf
> +#define MSR_ARCH_LBR_FROM_0    0x00001500
> +#define MSR_ARCH_LBR_TO_0      0x00001600
> +#define MSR_ARCH_LBR_INFO_0    0x00001200
> +
> +#define MSR_IA32_XSS           0x00000da0
> +
> +#define IA32_XSS_ARCH_LBR      (1UL << 15)
> +#define CR4_OSXSAVE_BIT        (1UL << 18)
> +#define CPUID_EDX_ARCH_LBR     (1UL << 19)
> +
> +#define ARCH_LBR_CTL_BITS      0x3f0003
> +
> +#define XSAVES        ".byte 0x48,0x0f,0xc7,0x2f\n\t"
> +#define XRSTORS       ".byte 0x48,0x0f,0xc7,0x1f\n\t"
> +
> +static int run_arch_lbr_test(void);
> +
> +struct xstate_header {
> +	u64 xfeatures;
> +	u64 xcomp_bv;
> +	u64 reserved[6];
> +} __attribute__((packed));
> +
> +struct arch_lbr_entry {
> +	u64 lbr_from;
> +	u64 lbr_to;
> +	u64 lbr_info;
> +}__attribute__((packed));
> +
> +struct arch_lbr_struct {
> +	u64 lbr_ctl;
> +	u64 lbr_depth;
> +	u64 ler_from;
> +	u64 ler_to;
> +	u64 ler_info;
> +	struct arch_lbr_entry lbr_records[MAX_NUM_LBR_ENTRY];
> +}__attribute__((packed));
> +
> +struct xsave_struct {
> +	u8 fpu_sse[512];
> +	struct xstate_header xstate_hdr;
> +	struct arch_lbr_struct records;
> +} __attribute__((packed));
> +
> +u8 __attribute__((__aligned__(64))) xsave_buffer[PAGE_SIZE];
> +
> +struct xsave_struct *test_buf = (struct xsave_struct *)xsave_buffer;
> +
> +union cpuid10_eax {
> +	struct {
> +		unsigned int version_id:8;
> +		unsigned int num_counters:8;
> +		unsigned int bit_width:8;
> +		unsigned int mask_length:8;
> +	} split;
> +	unsigned int full;
> +} eax;
> +
> +u32 lbr_from, lbr_to;
> +u64 lbr_ctl, lbr_depth;
> +
> +u64 arch_lbr_from[MAX_NUM_LBR_ENTRY];
> +u64 arch_lbr_to[MAX_NUM_LBR_ENTRY];
> +u64 arch_lbr_info[MAX_NUM_LBR_ENTRY];
> +
>   volatile int count;
>   
>   static __attribute__((noinline)) int compute_flag(int i)
> @@ -38,36 +107,225 @@ static __attribute__((noinline)) int lbr_test(void)
>   	return 0;
>   }
>   
> -union cpuid10_eax {
> -	struct {
> -		unsigned int version_id:8;
> -		unsigned int num_counters:8;
> -		unsigned int bit_width:8;
> -		unsigned int mask_length:8;
> -	} split;
> -	unsigned int full;
> -} eax;
> -
> -u32 lbr_from, lbr_to;
> -
>   static void init_lbr(void *index)
>   {
>   	wrmsr(lbr_from + *(int *) index, 0);
>   	wrmsr(lbr_to + *(int *)index, 0);
>   }
>   
> +static void test_lbr_depth(void *data)
> +{
> +	wrmsr(MSR_ARCH_LBR_DEPTH, *(int *)data);
> +}
> +
> +static void test_lbr_control(void *data)
> +{
> +	wrmsr(MSR_ARCH_LBR_CTL, *(int *)data);
> +}
> +
>   static bool test_init_lbr_from_exception(u64 index)
>   {
>   	return test_for_exception(GP_VECTOR, init_lbr, &index);
>   }
>   
> +static bool test_lbr_depth_from_exception(u64 data)
> +{
> +	return test_for_exception(GP_VECTOR, test_lbr_depth, &data);
> +}
> +
> +static bool test_lbr_control_from_exception(u64 data)
> +{
> +	return test_for_exception(GP_VECTOR, test_lbr_control, &data);
> +}
> +
> +static inline void xrstors(struct xsave_struct *fx, unsigned long  mask)
> +{
> +        u32 lmask = mask;
> +        u32 hmask = mask >> 32;
> +
> +        asm volatile(XRSTORS
> +                     : : "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
> +                     : "memory");
> +}
> +
> +static inline int xsaves(struct xsave_struct *fx, unsigned long mask)
> +{
> +        u32 lmask = mask;
> +        u32 hmask = mask >> 32;
> +	int err = 0;
> +
> +        asm volatile(XSAVES
> +                     : [err] "=r" (err)  : "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
> +                     : "memory");
> +	return err;
> +}
> +
> +static int test_clear_lbr_records(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < lbr_depth; ++i) {
> +		if (rdmsr(MSR_ARCH_LBR_FROM_0 + i) != 0 ||
> +		    rdmsr(MSR_ARCH_LBR_TO_0 + i) != 0 ||
> +		    rdmsr(MSR_ARCH_LBR_INFO_0 + i) != 0)
> +			break;
> +	}
> +
> +	return (i == lbr_depth) ? 0 : -1;
> +
> +}
> +
> +static bool check_xsaves_records(void)
> +{
> +	int i;
> +	struct arch_lbr_entry *records = test_buf->records.lbr_records;
> +
> +	for (i = 0; i < lbr_depth; ++i) {
> +		if (arch_lbr_from[i] != (*(records + i)).lbr_from ||
> +		    arch_lbr_to[i] != (*(records + i)).lbr_to ||
> +		    arch_lbr_info[i] != (*(records + i)).lbr_info)
> +			break;
> +	}
> +
> +	return i == lbr_depth;
> +}
> +
> +static bool check_msrs_records(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < lbr_depth; ++i) {
> +		if (arch_lbr_from[i] != rdmsr(MSR_ARCH_LBR_FROM_0 + i) ||
> +		    arch_lbr_to[i] != rdmsr(MSR_ARCH_LBR_TO_0 + i) ||
> +		    arch_lbr_info[i] != rdmsr(MSR_ARCH_LBR_INFO_0 + i))
> +			break;
> +	}
> +
> +	return i == lbr_depth;
> +}
> +
> +static void test_with_xsaves(void)
> +{
> +	u32 cr4;
> +
> +	/* Only test Arch LBR save/restore, ignore other features.*/
> +	wrmsr(MSR_IA32_XSS, IA32_XSS_ARCH_LBR);
> +
> +	cr4 = read_cr4();
> +	write_cr4(cr4 | CR4_OSXSAVE_BIT);
> +
> +	xsaves(test_buf, IA32_XSS_ARCH_LBR | 0x3);
> +
> +	report(check_xsaves_records(),
> +	       "The saved(XSAVES) LBR records do match the original values.");
> +
> +	wrmsr(MSR_ARCH_LBR_DEPTH, lbr_depth);
> +
> +	xrstors(test_buf, IA32_XSS_ARCH_LBR | 0x3);
> +
> +	report(check_msrs_records(),
> +	       "The restored(XRSTORS) LBR records do match the original values.");
> +}
> +
> +static int test_arch_lbr_entry(void)
> +{
> +	int max, ret = -1;
> +
> +	lbr_from = MSR_ARCH_LBR_FROM_0;
> +	lbr_to = MSR_ARCH_LBR_TO_0;
> +
> +	if (test_init_lbr_from_exception(0)) {
> +		printf("Arch LBR on this platform is not supported!\n");
> +		return ret;
> +	}
> +
> +	for (max = 0; max < lbr_depth; max++) {
> +		if (test_init_lbr_from_exception(max))
> +			break;
> +	}
> +
> +	if (max == lbr_depth) {
> +		report(true, "The number of guest LBR entries is good.");
> +		ret = 0;
> +	}
> +
> +	return ret;
> +}
> +
> +static int run_arch_lbr_test(void)
> +{
> +	struct cpuid id;
> +	int i;
> +
> +	printf("Start Arch LBR testing...\n");
> +	id = raw_cpuid(0xd, 1);
> +	if (!(id.a & 0x8)) {
> +		printf("XSAVES is not supported!.\n");
> +		return report_summary();
> +	}
> +
> +	id = cpuid(0x1c);
> +	lbr_depth = (fls(id.a & 0xff) + 1)*8;
> +
> +	if (test_arch_lbr_entry()) {
> +		printf("Arch LBR entry test failed!.\n");
> +		return report_summary();
> +	}
> +
> +	report(test_lbr_control_from_exception(ARCH_LBR_CTL_BITS | 0xfff0),
> +	       "Invalid Arch LBR control can trigger #GP.");
> +	report(test_lbr_depth_from_exception(lbr_depth + 0x10),
> +	       "Unsupported Arch LBR depth can trigger #GP.");
> +
> +	wrmsr(MSR_ARCH_LBR_DEPTH, lbr_depth);
> +	report(!test_clear_lbr_records(),
> +	       "Write to depth MSR can reset record MSRs to 0s.");
> +
> +	lbr_ctl = ARCH_LBR_CTL_BITS;
> +	wrmsr(MSR_ARCH_LBR_CTL, lbr_ctl);
> +
> +	lbr_test();
> +
> +	/* Disable Arch LBR sampling before run sanity checks. */
> +	lbr_ctl &= ~0x1;
> +	wrmsr(MSR_ARCH_LBR_CTL, lbr_ctl);
> +
> +	/*
> +	 * Save Arch LBR records from MSRs for following comparison with the
> +	 * values from xsaves/xrstors.
> +	 */
> +	for (i = 0; i < lbr_depth; ++i) {
> +		if (!(arch_lbr_from[i] = rdmsr(MSR_ARCH_LBR_FROM_0 + i)) ||
> +		    !(arch_lbr_to[i] = rdmsr(MSR_ARCH_LBR_TO_0 + i)) ||
> +		    !(arch_lbr_info[i] = rdmsr(MSR_ARCH_LBR_INFO_0 + i)))
> +			break;
> +	}
> +
> +	if (i != lbr_depth) {
> +		printf("Invalid Arch LBR records.\n");
> +		return report_summary();
> +	}
> +
> +	test_with_xsaves();
> +
> +	return 0;
> +}
> +
>   int main(int ac, char **av)
>   {
> -	struct cpuid id = cpuid(10);
> +	struct cpuid id;
>   	u64 perf_cap;
>   	int max, i;
>   
>   	setup_vm();
> +
> +	id = cpuid(0x7);
> +	if ((id.d & CPUID_EDX_ARCH_LBR)) {
> +		run_arch_lbr_test();
> +		return report_summary();
> +	}
> +
> +	id = cpuid(10);
>   	perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
>   	eax.full = id.a;
>   
