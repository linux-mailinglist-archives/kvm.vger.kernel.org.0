Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2708453516E
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 17:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347921AbiEZPat (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 11:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239962AbiEZPar (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 11:30:47 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3192BABF49
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 08:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653579046; x=1685115046;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0lnQ4nHxfRPq3ArHXSxq+UEHMg2bs5snWjO7sT6IjNc=;
  b=Z+XZ16+TmKJVLdknUTQGqHtWz3GwDi60F36uOSLOVrEsPjs1lINLhEXE
   78wZzRDxGsFpvYcECM/z4Il96uJi1Lony3Q7LQjYBd5Igr4bdvGCM2x15
   Ha8tTEgmt+sYncRaFk5sFV9wBXAuHaQbmyseyDcEZqQq1I/qFft9QlJgq
   xO7tvSmKy5WwdWqa93iTcT2oIBy9ApVO5MRjXwYhSjmrSWCXVu1znofRa
   mUAENAb4qluQb3ZjetJpXlYo3JkzDbGyi0sP5HN1CfWiwI4iC5DYwBT6u
   Iprmklu+z09uNKZ8dP0XrefdphXNxWzBqwVJ6fKCejRB3vBJV/VzESfN4
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10359"; a="254686954"
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="254686954"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2022 08:30:45 -0700
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="603152610"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.255.31.239]) ([10.255.31.239])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2022 08:30:44 -0700
Message-ID: <d9a0a7a5-bd67-7b59-0148-689fb585b6b5@intel.com>
Date:   Thu, 26 May 2022 23:30:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [kvm-unit-tests PATCH v2] x86: vpmu: Add tests for Arch LBR
 support
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>
References: <1629961999-23407-1-git-send-email-weijiang.yang@intel.com>
 <98c67c7b-5121-9c05-d534-18ca2777e79c@gmail.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <98c67c7b-5121-9c05-d534-18ca2777e79c@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/26/2022 5:48 PM, Like Xu wrote:
> Hi weijiang, would you help update the status of this test ?

Hi, Like,

This unit tests app can pass both on Arch LBR capable platform or legacy 
platform

with v12 arch-lbr KVM series +  qemu series, see below results:

=========================================================

Arch LBR capable platform(SPR):

Start Arch LBR testing...
PASS: The number of guest LBR entries is good.
PASS: Invalid Arch LBR control can trigger #GP.
PASS: Unsupported Arch LBR depth can trigger #GP.
PASS: Write to depth MSR can reset record MSRs to 0s.
PASS: The saved(XSAVES) LBR records do match the original values.
PASS: The restored(XRSTORS) LBR records do match the original values.
SUMMARY: 6 tests
PASS pmu_lbr (6 tests)

===========================================================

Legacy platform:

PMU version:             2
LBR version:             5
PASS: The number of guest LBR entries is good.
PASS: The guest LBR MSR_LBR_TOS value is good.
PASS: The guest LBR FROM_IP/TO_IP values are good.
SUMMARY: 3 tests
PASS pmu_lbr (3 tests)

>
> On 26/8/2021 3:13 pm, Yang Weijiang wrote:
>> The added code is to check whether basic Arch LBR function is supported
>> in guest, including read/write to LBR record MSRs, validation of 
>> control/
>> depth MSRs, write to depth MSR resetting all record MSRs and 
>> xsaves/xrstors
>> support for guest Arch LBR. The purpose of the code is to do basic 
>> checks for
>> Arch LBR, not to make everything around Arch LBR be tested.
>>
>> Change in v2:
>> - Per Like's review feedback, changed below things:
>>    1. Combined Arch LBR tests with existing LBR tests.
>>    2. Added sanity check tests for control & depth MSRs.
>>    3. Added test for write depth MSR to reset all record MSRs.
>> - Added more test checkpoints in output report.
>> - Refactored part of the code.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>   x86/pmu_lbr.c | 292 +++++++++++++++++++++++++++++++++++++++++++++++---
>>   1 file changed, 275 insertions(+), 17 deletions(-)
>>
>> diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
>> index 3bd9e9f..6c22cad 100644
>> --- a/x86/pmu_lbr.c
>> +++ b/x86/pmu_lbr.c
>> @@ -1,19 +1,88 @@
>> +#include "asm-generic/page.h"
>>   #include "x86/msr.h"
>>   #include "x86/processor.h"
>>   #include "x86/desc.h"
>> +#include "bitops.h"
>>     #define N 1000000
>> -#define MAX_NUM_LBR_ENTRY      32
>> -#define DEBUGCTLMSR_LBR      (1UL <<  0)
>> -#define PMU_CAP_LBR_FMT      0x3f
>> +#define MAX_NUM_LBR_ENTRY    32
>> +#define DEBUGCTLMSR_LBR     (1UL <<  0)
>> +#define PMU_CAP_LBR_FMT     0x3f
>>     #define MSR_LBR_NHM_FROM    0x00000680
>>   #define MSR_LBR_NHM_TO        0x000006c0
>>   #define MSR_LBR_CORE_FROM    0x00000040
>> -#define MSR_LBR_CORE_TO    0x00000060
>> +#define MSR_LBR_CORE_TO     0x00000060
>>   #define MSR_LBR_TOS        0x000001c9
>>   #define MSR_LBR_SELECT        0x000001c8
>>   +#define MSR_ARCH_LBR_CTL       0x000014ce
>> +#define MSR_ARCH_LBR_DEPTH     0x000014cf
>> +#define MSR_ARCH_LBR_FROM_0    0x00001500
>> +#define MSR_ARCH_LBR_TO_0      0x00001600
>> +#define MSR_ARCH_LBR_INFO_0    0x00001200
>> +
>> +#define MSR_IA32_XSS           0x00000da0
>> +
>> +#define IA32_XSS_ARCH_LBR      (1UL << 15)
>> +#define CR4_OSXSAVE_BIT        (1UL << 18)
>> +#define CPUID_EDX_ARCH_LBR     (1UL << 19)
>> +
>> +#define ARCH_LBR_CTL_BITS      0x3f0003
>> +
>> +#define XSAVES        ".byte 0x48,0x0f,0xc7,0x2f\n\t"
>> +#define XRSTORS       ".byte 0x48,0x0f,0xc7,0x1f\n\t"
>> +
>> +static int run_arch_lbr_test(void);
>> +
>> +struct xstate_header {
>> +    u64 xfeatures;
>> +    u64 xcomp_bv;
>> +    u64 reserved[6];
>> +} __attribute__((packed));
>> +
>> +struct arch_lbr_entry {
>> +    u64 lbr_from;
>> +    u64 lbr_to;
>> +    u64 lbr_info;
>> +}__attribute__((packed));
>> +
>> +struct arch_lbr_struct {
>> +    u64 lbr_ctl;
>> +    u64 lbr_depth;
>> +    u64 ler_from;
>> +    u64 ler_to;
>> +    u64 ler_info;
>> +    struct arch_lbr_entry lbr_records[MAX_NUM_LBR_ENTRY];
>> +}__attribute__((packed));
>> +
>> +struct xsave_struct {
>> +    u8 fpu_sse[512];
>> +    struct xstate_header xstate_hdr;
>> +    struct arch_lbr_struct records;
>> +} __attribute__((packed));
>> +
>> +u8 __attribute__((__aligned__(64))) xsave_buffer[PAGE_SIZE];
>> +
>> +struct xsave_struct *test_buf = (struct xsave_struct *)xsave_buffer;
>> +
>> +union cpuid10_eax {
>> +    struct {
>> +        unsigned int version_id:8;
>> +        unsigned int num_counters:8;
>> +        unsigned int bit_width:8;
>> +        unsigned int mask_length:8;
>> +    } split;
>> +    unsigned int full;
>> +} eax;
>> +
>> +u32 lbr_from, lbr_to;
>> +u64 lbr_ctl, lbr_depth;
>> +
>> +u64 arch_lbr_from[MAX_NUM_LBR_ENTRY];
>> +u64 arch_lbr_to[MAX_NUM_LBR_ENTRY];
>> +u64 arch_lbr_info[MAX_NUM_LBR_ENTRY];
>> +
>>   volatile int count;
>>     static __attribute__((noinline)) int compute_flag(int i)
>> @@ -38,36 +107,225 @@ static __attribute__((noinline)) int 
>> lbr_test(void)
>>       return 0;
>>   }
>>   -union cpuid10_eax {
>> -    struct {
>> -        unsigned int version_id:8;
>> -        unsigned int num_counters:8;
>> -        unsigned int bit_width:8;
>> -        unsigned int mask_length:8;
>> -    } split;
>> -    unsigned int full;
>> -} eax;
>> -
>> -u32 lbr_from, lbr_to;
>> -
>>   static void init_lbr(void *index)
>>   {
>>       wrmsr(lbr_from + *(int *) index, 0);
>>       wrmsr(lbr_to + *(int *)index, 0);
>>   }
>>   +static void test_lbr_depth(void *data)
>> +{
>> +    wrmsr(MSR_ARCH_LBR_DEPTH, *(int *)data);
>> +}
>> +
>> +static void test_lbr_control(void *data)
>> +{
>> +    wrmsr(MSR_ARCH_LBR_CTL, *(int *)data);
>> +}
>> +
>>   static bool test_init_lbr_from_exception(u64 index)
>>   {
>>       return test_for_exception(GP_VECTOR, init_lbr, &index);
>>   }
>>   +static bool test_lbr_depth_from_exception(u64 data)
>> +{
>> +    return test_for_exception(GP_VECTOR, test_lbr_depth, &data);
>> +}
>> +
>> +static bool test_lbr_control_from_exception(u64 data)
>> +{
>> +    return test_for_exception(GP_VECTOR, test_lbr_control, &data);
>> +}
>> +
>> +static inline void xrstors(struct xsave_struct *fx, unsigned long  
>> mask)
>> +{
>> +        u32 lmask = mask;
>> +        u32 hmask = mask >> 32;
>> +
>> +        asm volatile(XRSTORS
>> +                     : : "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
>> +                     : "memory");
>> +}
>> +
>> +static inline int xsaves(struct xsave_struct *fx, unsigned long mask)
>> +{
>> +        u32 lmask = mask;
>> +        u32 hmask = mask >> 32;
>> +    int err = 0;
>> +
>> +        asm volatile(XSAVES
>> +                     : [err] "=r" (err)  : "D" (fx), "m" (*fx), "a" 
>> (lmask), "d" (hmask)
>> +                     : "memory");
>> +    return err;
>> +}
>> +
>> +static int test_clear_lbr_records(void)
>> +{
>> +    int i;
>> +
>> +    for (i = 0; i < lbr_depth; ++i) {
>> +        if (rdmsr(MSR_ARCH_LBR_FROM_0 + i) != 0 ||
>> +            rdmsr(MSR_ARCH_LBR_TO_0 + i) != 0 ||
>> +            rdmsr(MSR_ARCH_LBR_INFO_0 + i) != 0)
>> +            break;
>> +    }
>> +
>> +    return (i == lbr_depth) ? 0 : -1;
>> +
>> +}
>> +
>> +static bool check_xsaves_records(void)
>> +{
>> +    int i;
>> +    struct arch_lbr_entry *records = test_buf->records.lbr_records;
>> +
>> +    for (i = 0; i < lbr_depth; ++i) {
>> +        if (arch_lbr_from[i] != (*(records + i)).lbr_from ||
>> +            arch_lbr_to[i] != (*(records + i)).lbr_to ||
>> +            arch_lbr_info[i] != (*(records + i)).lbr_info)
>> +            break;
>> +    }
>> +
>> +    return i == lbr_depth;
>> +}
>> +
>> +static bool check_msrs_records(void)
>> +{
>> +    int i;
>> +
>> +    for (i = 0; i < lbr_depth; ++i) {
>> +        if (arch_lbr_from[i] != rdmsr(MSR_ARCH_LBR_FROM_0 + i) ||
>> +            arch_lbr_to[i] != rdmsr(MSR_ARCH_LBR_TO_0 + i) ||
>> +            arch_lbr_info[i] != rdmsr(MSR_ARCH_LBR_INFO_0 + i))
>> +            break;
>> +    }
>> +
>> +    return i == lbr_depth;
>> +}
>> +
>> +static void test_with_xsaves(void)
>> +{
>> +    u32 cr4;
>> +
>> +    /* Only test Arch LBR save/restore, ignore other features.*/
>> +    wrmsr(MSR_IA32_XSS, IA32_XSS_ARCH_LBR);
>> +
>> +    cr4 = read_cr4();
>> +    write_cr4(cr4 | CR4_OSXSAVE_BIT);
>> +
>> +    xsaves(test_buf, IA32_XSS_ARCH_LBR | 0x3);
>> +
>> +    report(check_xsaves_records(),
>> +           "The saved(XSAVES) LBR records do match the original 
>> values.");
>> +
>> +    wrmsr(MSR_ARCH_LBR_DEPTH, lbr_depth);
>> +
>> +    xrstors(test_buf, IA32_XSS_ARCH_LBR | 0x3);
>> +
>> +    report(check_msrs_records(),
>> +           "The restored(XRSTORS) LBR records do match the original 
>> values.");
>> +}
>> +
>> +static int test_arch_lbr_entry(void)
>> +{
>> +    int max, ret = -1;
>> +
>> +    lbr_from = MSR_ARCH_LBR_FROM_0;
>> +    lbr_to = MSR_ARCH_LBR_TO_0;
>> +
>> +    if (test_init_lbr_from_exception(0)) {
>> +        printf("Arch LBR on this platform is not supported!\n");
>> +        return ret;
>> +    }
>> +
>> +    for (max = 0; max < lbr_depth; max++) {
>> +        if (test_init_lbr_from_exception(max))
>> +            break;
>> +    }
>> +
>> +    if (max == lbr_depth) {
>> +        report(true, "The number of guest LBR entries is good.");
>> +        ret = 0;
>> +    }
>> +
>> +    return ret;
>> +}
>> +
>> +static int run_arch_lbr_test(void)
>> +{
>> +    struct cpuid id;
>> +    int i;
>> +
>> +    printf("Start Arch LBR testing...\n");
>> +    id = raw_cpuid(0xd, 1);
>> +    if (!(id.a & 0x8)) {
>> +        printf("XSAVES is not supported!.\n");
>> +        return report_summary();
>> +    }
>> +
>> +    id = cpuid(0x1c);
>> +    lbr_depth = (fls(id.a & 0xff) + 1)*8;
>> +
>> +    if (test_arch_lbr_entry()) {
>> +        printf("Arch LBR entry test failed!.\n");
>> +        return report_summary();
>> +    }
>> +
>> +    report(test_lbr_control_from_exception(ARCH_LBR_CTL_BITS | 0xfff0),
>> +           "Invalid Arch LBR control can trigger #GP.");
>> +    report(test_lbr_depth_from_exception(lbr_depth + 0x10),
>> +           "Unsupported Arch LBR depth can trigger #GP.");
>> +
>> +    wrmsr(MSR_ARCH_LBR_DEPTH, lbr_depth);
>> +    report(!test_clear_lbr_records(),
>> +           "Write to depth MSR can reset record MSRs to 0s.");
>> +
>> +    lbr_ctl = ARCH_LBR_CTL_BITS;
>> +    wrmsr(MSR_ARCH_LBR_CTL, lbr_ctl);
>> +
>> +    lbr_test();
>> +
>> +    /* Disable Arch LBR sampling before run sanity checks. */
>> +    lbr_ctl &= ~0x1;
>> +    wrmsr(MSR_ARCH_LBR_CTL, lbr_ctl);
>> +
>> +    /*
>> +     * Save Arch LBR records from MSRs for following comparison with 
>> the
>> +     * values from xsaves/xrstors.
>> +     */
>> +    for (i = 0; i < lbr_depth; ++i) {
>> +        if (!(arch_lbr_from[i] = rdmsr(MSR_ARCH_LBR_FROM_0 + i)) ||
>> +            !(arch_lbr_to[i] = rdmsr(MSR_ARCH_LBR_TO_0 + i)) ||
>> +            !(arch_lbr_info[i] = rdmsr(MSR_ARCH_LBR_INFO_0 + i)))
>> +            break;
>> +    }
>> +
>> +    if (i != lbr_depth) {
>> +        printf("Invalid Arch LBR records.\n");
>> +        return report_summary();
>> +    }
>> +
>> +    test_with_xsaves();
>> +
>> +    return 0;
>> +}
>> +
>>   int main(int ac, char **av)
>>   {
>> -    struct cpuid id = cpuid(10);
>> +    struct cpuid id;
>>       u64 perf_cap;
>>       int max, i;
>>         setup_vm();
>> +
>> +    id = cpuid(0x7);
>> +    if ((id.d & CPUID_EDX_ARCH_LBR)) {
>> +        run_arch_lbr_test();
>> +        return report_summary();
>> +    }
>> +
>> +    id = cpuid(10);
>>       perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
>>       eax.full = id.a;
