Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237054B382A
	for <lists+kvm@lfdr.de>; Sat, 12 Feb 2022 22:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbiBLVNP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Feb 2022 16:13:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiBLVNO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Feb 2022 16:13:14 -0500
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F48F606F6
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 13:13:10 -0800 (PST)
Received: by mail-oo1-xc2e.google.com with SMTP id o192-20020a4a2cc9000000b00300af40d795so14671030ooo.13
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 13:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RrNYNGXA4l0M3XhlK7GC0sT5wzKfXCN4bMss2DyxquM=;
        b=YjofXyU8TLSuIMKyBnslpu9OL5BsErVkjzQVCGUDvw5uX6AnajIMpElwC/Vx97o3t0
         yTgmbTQ/e5w6IAd2pZ44jDhgmWnEYz2CY3tjlYLb6ypNKxzGimNixgtYI55pIkvbIP/X
         CvZINJCGq+Taz1peSfMeWBkvYIN9copCZVYPmEfv8ybc32zBpCl5FWW7M5ZoIPEb3blU
         uzBK7Th7zgGNEwmaK2E2MF14Is0svYkdxI9G4BFZ1JSyjKkCRMDLjGAkdv8OLFnnq5SB
         +9vyjfcdxpDXtaF7x5gy6Bc/yl6VkYT7kl42ZZx3gW3W/7jW/ALiM6qkltxcmMrvuBph
         qjWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RrNYNGXA4l0M3XhlK7GC0sT5wzKfXCN4bMss2DyxquM=;
        b=owZDk7E1RGGTmEDDtYf78BdxFZzE0BsVSXJ4DtsdpomNc2Ta5LU72IGBnVwVOtvHLZ
         vXYcXpt9ZsI1FGIdv3m0qK3jwTGU05OfA0VdxCLgGzdfeBzeNle5ZV7AX1T0YA8bfIWf
         g/QbZQBIAN9xwKXGC9ytX/1YGJAHLLreV9klyJrrHVYs7G+Ii43RRdMCuou60WjzdhGZ
         LnOqWP3/FNO0LJQ4CFow2t6vzuMH5DQax5d+5/aTDct/eTED3SipYEOktsqcirEhipvc
         0+v7srsbuL0cVGimwd3eUyARKvDFmb/cH9gjW8BNNb6TmNUt5TC1+7Z61tX9GJe85Q+N
         QvYw==
X-Gm-Message-State: AOAM531GrD/BPuW3GX4OfNUXeCVCkB+UsTbuxCO2RcDPFomdNFQFKoSX
        OrQTZwV7MKtZYbPRR4Tmx8O816KTdROBNJ7u/42mlQ==
X-Google-Smtp-Source: ABdhPJxPh9RrHLHc+NyxSJ1BHf5VjNPE3EYvP5EAR+N72ALXeA9efAGFb7Ixe2fQvbYl46iUHT49Jz5hv6D9zfBInDk=
X-Received: by 2002:a05:6870:12d0:: with SMTP id 16mr1954493oam.304.1644700389279;
 Sat, 12 Feb 2022 13:13:09 -0800 (PST)
MIME-Version: 1.0
References: <20220209164420.8894-1-varad.gautam@suse.com> <20220209164420.8894-7-varad.gautam@suse.com>
In-Reply-To: <20220209164420.8894-7-varad.gautam@suse.com>
From:   Marc Orr <marcorr@google.com>
Date:   Sat, 12 Feb 2022 13:12:57 -0800
Message-ID: <CAA03e5E3eNmyErXWMDgPkQ9H5MrEEE854zAcxDbUaDyFumJ5zA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 06/10] lib/x86: Move xsave helpers to lib/
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Joerg Roedel <jroedel@suse.de>, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 9, 2022 at 8:44 AM Varad Gautam <varad.gautam@suse.com> wrote:
>
> Processing CPUID #VC for AMD SEV-ES requires copying xcr0 into GHCB.
> Move the xsave read/write helpers used by xsave testcase to lib/x86
> to share as common code.
>
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> ---
>  lib/x86/xsave.c     | 37 +++++++++++++++++++++++++++++++++++++
>  lib/x86/xsave.h     | 16 ++++++++++++++++
>  x86/Makefile.common |  1 +
>  x86/xsave.c         | 43 +------------------------------------------
>  4 files changed, 55 insertions(+), 42 deletions(-)
>  create mode 100644 lib/x86/xsave.c
>  create mode 100644 lib/x86/xsave.h
>
> diff --git a/lib/x86/xsave.c b/lib/x86/xsave.c
> new file mode 100644
> index 0000000..1c0f16e
> --- /dev/null
> +++ b/lib/x86/xsave.c
> @@ -0,0 +1,37 @@
> +#include "libcflat.h"
> +#include "xsave.h"
> +#include "processor.h"
> +
> +int xgetbv_checking(u32 index, u64 *result)
> +{
> +    u32 eax, edx;
> +
> +    asm volatile(ASM_TRY("1f")
> +            ".byte 0x0f,0x01,0xd0\n\t" /* xgetbv */
> +            "1:"
> +            : "=a" (eax), "=d" (edx)
> +            : "c" (index));
> +    *result = eax + ((u64)edx << 32);
> +    return exception_vector();
> +}
> +
> +int xsetbv_checking(u32 index, u64 value)
> +{
> +    u32 eax = value;
> +    u32 edx = value >> 32;
> +
> +    asm volatile(ASM_TRY("1f")
> +            ".byte 0x0f,0x01,0xd1\n\t" /* xsetbv */
> +            "1:"
> +            : : "a" (eax), "d" (edx), "c" (index));
> +    return exception_vector();
> +}
> +
> +uint64_t get_supported_xcr0(void)
> +{
> +    struct cpuid r;
> +    r = cpuid_indexed(0xd, 0);
> +    printf("eax %x, ebx %x, ecx %x, edx %x\n",
> +            r.a, r.b, r.c, r.d);
> +    return r.a + ((u64)r.d << 32);
> +}
> diff --git a/lib/x86/xsave.h b/lib/x86/xsave.h
> new file mode 100644
> index 0000000..f1851a3
> --- /dev/null
> +++ b/lib/x86/xsave.h
> @@ -0,0 +1,16 @@
> +#ifndef _X86_XSAVE_H_
> +#define _X86_XSAVE_H_
> +
> +#define X86_CR4_OSXSAVE                        0x00040000
> +#define XCR_XFEATURE_ENABLED_MASK       0x00000000
> +#define XCR_XFEATURE_ILLEGAL_MASK       0x00000010
> +
> +#define XSTATE_FP       0x1
> +#define XSTATE_SSE      0x2
> +#define XSTATE_YMM      0x4
> +
> +int xgetbv_checking(u32 index, u64 *result);
> +int xsetbv_checking(u32 index, u64 value);
> +uint64_t get_supported_xcr0(void);
> +
> +#endif
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index 2496d81..aa30948 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -22,6 +22,7 @@ cflatobjs += lib/x86/acpi.o
>  cflatobjs += lib/x86/stack.o
>  cflatobjs += lib/x86/fault_test.o
>  cflatobjs += lib/x86/delay.o
> +cflatobjs += lib/x86/xsave.o
>  ifeq ($(TARGET_EFI),y)
>  cflatobjs += lib/x86/amd_sev.o
>  cflatobjs += lib/x86/amd_sev_vc.o
> diff --git a/x86/xsave.c b/x86/xsave.c
> index 892bf56..bd8fe11 100644
> --- a/x86/xsave.c
> +++ b/x86/xsave.c
> @@ -1,6 +1,7 @@
>  #include "libcflat.h"
>  #include "desc.h"
>  #include "processor.h"
> +#include "xsave.h"
>
>  #ifdef __x86_64__
>  #define uint64_t unsigned long
> @@ -8,48 +9,6 @@
>  #define uint64_t unsigned long long
>  #endif
>
> -static int xgetbv_checking(u32 index, u64 *result)
> -{
> -    u32 eax, edx;
> -
> -    asm volatile(ASM_TRY("1f")
> -            ".byte 0x0f,0x01,0xd0\n\t" /* xgetbv */
> -            "1:"
> -            : "=a" (eax), "=d" (edx)
> -            : "c" (index));
> -    *result = eax + ((u64)edx << 32);
> -    return exception_vector();
> -}
> -
> -static int xsetbv_checking(u32 index, u64 value)
> -{
> -    u32 eax = value;
> -    u32 edx = value >> 32;
> -
> -    asm volatile(ASM_TRY("1f")
> -            ".byte 0x0f,0x01,0xd1\n\t" /* xsetbv */
> -            "1:"
> -            : : "a" (eax), "d" (edx), "c" (index));
> -    return exception_vector();
> -}
> -
> -static uint64_t get_supported_xcr0(void)
> -{
> -    struct cpuid r;
> -    r = cpuid_indexed(0xd, 0);
> -    printf("eax %x, ebx %x, ecx %x, edx %x\n",
> -            r.a, r.b, r.c, r.d);
> -    return r.a + ((u64)r.d << 32);
> -}
> -
> -#define X86_CR4_OSXSAVE                        0x00040000
> -#define XCR_XFEATURE_ENABLED_MASK       0x00000000
> -#define XCR_XFEATURE_ILLEGAL_MASK       0x00000010
> -
> -#define XSTATE_FP       0x1
> -#define XSTATE_SSE      0x2
> -#define XSTATE_YMM      0x4
> -
>  static void test_xsave(void)
>  {
>      unsigned long cr4;
> --
> 2.32.0
>

Reviewed-by: Marc Orr <marcorr@google.com>
