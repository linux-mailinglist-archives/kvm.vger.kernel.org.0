Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 816C03E3F26
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 06:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbhHIEz7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 00:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233018AbhHIEz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 00:55:58 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D114BC061760
        for <kvm@vger.kernel.org>; Sun,  8 Aug 2021 21:55:37 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id fa24-20020a17090af0d8b0290178bfa69d97so386535pjb.0
        for <kvm@vger.kernel.org>; Sun, 08 Aug 2021 21:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:cc:from:organization:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WkiZ4rB2YBKL4hmIyzeMWey7JxyKtCV2fGgooQ3allQ=;
        b=GSBwpGsJeH3YBIh1Eg+QG8ilnLJWsReGrCzZU8UBrCZajTe0X/qJioRBfib1o3cAqH
         HpLk3v/UqZ0WJpggW9rHYNtrtNU+ZBDs371+Q72uNsQFkYLNBKbF1mZHf6sfVYf819KG
         js8WmUCU29rmajNjFAiM52vrvqP2+1ZFPCLr+kOcElmzY1sw6fHZIo8wVEGyu/8h1TQs
         LS2n5OKPZZwTPoYJFXCz0coMtHUdUSJK9UWaax7xT6DdboQ2Eh52tW/gLKtoSFZrHMjn
         KaknQJ0LRZhB08XV2+V2qEoQoCi70nUk0G4bSTf0QgKem2adF22lNpxfwqpGVk/4L9Zp
         5RBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:cc:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=WkiZ4rB2YBKL4hmIyzeMWey7JxyKtCV2fGgooQ3allQ=;
        b=Df3PG3sYImgMway36NheUQwVTcbYwjYXoSzXjCUBRxiUJQsxV4V5zmKoRVhqpccU0x
         0J64yF99fqa3uClXKV4Mx8SE2hDLxr9yZKvAJzJmifL52pvbLU2F7pLJ6+lWu0ImM6IF
         IMfdeBhhr1c6HmD052MR2JLu563Kxl8RrL1LG31/MrzC0HhXfq+QQGRGwBTxr9rH7wX5
         g1MEvNiG6tSGz26OMQFdu1mV3GCwgTX5o0I2VQirA7fjglAX5PwFVbCf8sTEp33XZiA8
         IXSzMw/VWilqGxCqys8uODDxlU3YBz1MNfQXrnquZLhY/ia6X0HwCbG1SdeohWtW2N1S
         A+uA==
X-Gm-Message-State: AOAM531y68DjOuJeITKoKMeAIe4KbUtCbJ6lIvw10Yfvdpz5oGDvV8OX
        pVEpXsvDYK/bKJzXs5ICc6A=
X-Google-Smtp-Source: ABdhPJwlUsIKejltIh11ZjYqJ47jk7jcFjgMkOGsS8uYhYmBl4P0zpqXO74HJKS0QZurhNVRtT6SkQ==
X-Received: by 2002:a17:90a:b387:: with SMTP id e7mr32979293pjr.77.1628484937399;
        Sun, 08 Aug 2021 21:55:37 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id p190sm18830408pfb.4.2021.08.08.21.55.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Aug 2021 21:55:37 -0700 (PDT)
To:     Yang Weijiang <weijiang.yang@intel.com>
References: <1628235832-26608-1-git-send-email-weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, "Wang Wei (Intel VMM)" <wei.w.wang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [kvm-unit-tests PATCH] x86: Add Arch LBR unit-test application
Message-ID: <c5ffb720-48ea-b4e8-6a47-dca78a726a7c@gmail.com>
Date:   Mon, 9 Aug 2021 12:55:28 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1628235832-26608-1-git-send-email-weijiang.yang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/8/2021 3:43 pm, Yang Weijiang wrote:
> This unit-test app targets to check whehter Arch LBR is enabled

s/whehter/whether/

> for guest. XSAVES/XRSTORS are used to accelerate LBR MSR save/restore.

This test just verifies that LBR records are not changed or lost before and after
the XSAVES/XRSTORS operations instead of measuring the acceleration.

Please add more sub-testcases:
- Sanity checks about valid MSR_ARCH_LBR_CTL_bitmask;
- On a software write to IA32_LBR_DEPTH, all LBR entries are reset to 0;
- LBR from the nested VM since you added the nested support (not in immediate need);
- Check the #DB/#SMI behavior about both leagcy and Arch LBR logging;

> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>   x86/Makefile.x86_64 |   1 +
>   x86/pmu_arch_lbr.c  | 221 ++++++++++++++++++++++++++++++++++++++++++++
>   x86/unittests.cfg   |   6 ++
>   3 files changed, 228 insertions(+)
>   create mode 100644 x86/pmu_arch_lbr.c
> 
> diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
> index 8134952..0727830 100644
> --- a/x86/Makefile.x86_64
> +++ b/x86/Makefile.x86_64
> @@ -24,6 +24,7 @@ tests += $(TEST_DIR)/vmware_backdoors.flat
>   tests += $(TEST_DIR)/rdpru.flat
>   tests += $(TEST_DIR)/pks.flat
>   tests += $(TEST_DIR)/pmu_lbr.flat
> +tests += $(TEST_DIR)/pmu_arch_lbr.flat

Why separate into two files considering some basic test codes can be reused ?

>   
>   ifneq ($(fcf_protection_full),)
>   tests += $(TEST_DIR)/cet.flat
> diff --git a/x86/pmu_arch_lbr.c b/x86/pmu_arch_lbr.c
> new file mode 100644
> index 0000000..9a1e562
> --- /dev/null
> +++ b/x86/pmu_arch_lbr.c
> @@ -0,0 +1,221 @@
> +#include "asm-generic/page.h"
> +#include "x86/processor.h"
> +#include "x86/msr.h"
> +#include "x86/desc.h"
> +#include "bitops.h"
> +
> +#define MSR_ARCH_LBR_CTL                0x000014ce
> +#define MSR_ARCH_LBR_DEPTH              0x000014cf
> +#define MSR_ARCH_LBR_FROM_0             0x00001500
> +#define MSR_ARCH_LBR_TO_0               0x00001600
> +#define MSR_ARCH_LBR_INFO_0             0x00001200
> +
> +#define MSR_IA32_XSS                    0x00000da0
> +
> +#define IA32_XSS_ARCH_LBR               (1UL << 15)
> +#define CR4_OSXSAVE_BIT                 (1UL << 18)
> +#define CPUID_EDX_ARCH_LBR              (1UL << 19)
> +
> +#define ARCH_LBR_CTL_BITS               0x3f0003
> +#define MAX_LBR_DEPTH                   32
> +
> +#define XSAVES		".byte 0x48,0x0f,0xc7,0x2f\n\t"
> +#define XRSTORS		".byte 0x48,0x0f,0xc7,0x1f\n\t"
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
> +	struct arch_lbr_entry lbr_records[MAX_LBR_DEPTH];
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
> +u64 lbr_from[MAX_LBR_DEPTH], lbr_to[MAX_LBR_DEPTH], lbr_info[MAX_LBR_DEPTH];
> +
> +u64 lbr_ctl, lbr_depth;
> +
> +volatile int count;
> +
> +static __attribute__((noinline)) int compute_flag(int i)
> +{
> +	if (i % 10 < 4)
> +		return i + 1;
> +	return 0;
> +}
> +
> +static __attribute__((noinline)) int lbr_test(void)
> +{
> +	int i;
> +	int flag;
> +	volatile double x = 1212121212, y = 121212;
> +
> +	for (i = 0; i < 200000000; i++) {
> +		flag = compute_flag(i);
> +		count++;
> +		if (flag)
> +			x += x / y + y / x;
> +	}
> +	return 0;
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
> +static void clear_lbr_records(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < lbr_depth; ++i) {
> +		wrmsr(MSR_ARCH_LBR_FROM_0 + i, 0);
> +		wrmsr(MSR_ARCH_LBR_TO_0 + i, 0);
> +		wrmsr(MSR_ARCH_LBR_INFO_0 + i, 0);
> +	}
> +}

"On a software write to IA32_LBR_DEPTH, all LBR entries are reset to 0."

> +
> +static bool check_xsaves_records(void)
> +{
> +	int i;
> +	struct arch_lbr_entry *records = test_buf->records.lbr_records;
> +
> +	for (i = 0; i < lbr_depth; ++i) {
> +		if (lbr_from[i] != (*(records + i)).lbr_from ||
> +		    lbr_to[i] != (*(records + i)).lbr_to ||
> +		    lbr_info[i] != (*(records + i)).lbr_info)
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
> +		if (lbr_from[i] != rdmsr(MSR_ARCH_LBR_FROM_0 + i) ||
> +		    lbr_to[i] != rdmsr(MSR_ARCH_LBR_TO_0 + i) ||
> +		    lbr_info[i] != rdmsr(MSR_ARCH_LBR_INFO_0 + i))
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
> +	       "The LBR records in XSAVES area match the MSR values!");
> +
> +	clear_lbr_records();
> +
> +	xrstors(test_buf, IA32_XSS_ARCH_LBR | 0x3);
> +
> +	report(check_msrs_records(),
> +	       "The restored LBR MSR values match the original ones!");
> +}
> +
> +int main(int ac, char **av)
> +{
> +	struct cpuid id;
> +	int i;
> +
> +	id = cpuid(0x7);
> +	if (!(id.d & CPUID_EDX_ARCH_LBR)) {
> +		printf("No Arch LBR is detected!\n");
> +		return report_summary();
> +	}
> +
> +	id = raw_cpuid(0xd, 1);
> +	if (!(id.a & 0x8)) {
> +		printf("XSAVES is not supported!.\n");
> +		return report_summary();
> +	}
> +
> +	setup_vm();
> +
> +	id = cpuid(0x1c);
> +	lbr_depth = (fls(id.a & 0xff) + 1)*8;
> +
> +	wrmsr(MSR_ARCH_LBR_DEPTH, lbr_depth);

Need to check if all LBR entries are reset to 0 to avoid contamination.

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
> +	 * LBR records are kept at this point, need to save them
> +	 * ASAP, otherwise they could be reset to 0s.

How ? LBR has just been disabled, so why is it possible to reset it to 0s.

> +	 */
> +	for (i = 0; i < lbr_depth; ++i) {
> +		if (!(lbr_from[i] = rdmsr(MSR_ARCH_LBR_FROM_0 + i)) ||
> +		    !(lbr_to[i] = rdmsr(MSR_ARCH_LBR_TO_0 + i)) ||
> +		    !(lbr_info[i] = rdmsr(MSR_ARCH_LBR_INFO_0 + i)))
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
> +	return report_summary();
> +}
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index d5efab0..88b2203 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -185,6 +185,12 @@ extra_params = -cpu host,migratable=no
>   check = /sys/module/kvm/parameters/ignore_msrs=N
>   check = /proc/sys/kernel/nmi_watchdog=0
>   
> +[pmu_arch_lbr]
> +file = pmu_arch_lbr.flat
> +extra_params = -cpu host,lbr-fmt=0x3f

Ugh, please keep using "migratable=no"

> +check = /sys/module/kvm/parameters/ignore_msrs=N
> +check = /proc/sys/kernel/nmi_watchdog=0

For nmi_watchdog=1, the Arch LBR test should pass as well.

> +
>   [vmware_backdoors]
>   file = vmware_backdoors.flat
>   extra_params = -machine vmport=on -cpu max
> 
