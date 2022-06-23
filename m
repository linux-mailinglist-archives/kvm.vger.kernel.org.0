Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52921558A57
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 22:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiFWUss (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 16:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiFWUsr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 16:48:47 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37BF52E5A
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 13:48:43 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id y77so1045027oia.3
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 13:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ghBL8B+VYZnSMGW+02Rnd6WA6Oi+9/f0M5wCqFvghoc=;
        b=I9cx70w3Sipdo0o6uZKXEUMrdV3T9V9/ZX8sHn3O+6S/yQCOtShpuI5fGHWVJhe336
         Sd9hvaUatZk8dcRCKJzrK2r03U0fEEd2ZXfi+8LgFDC4UrT3wsS5tDiu7zFu4ay0LJ6O
         nza81P3M6EWdtEm8MkjNp1/ZY9uRZnyM0IGXPvck5eNqh96r/wXuNlpmPlK/U77E7uqK
         qUB210+F4cpA0GZqiHqbiTb4AVMsQiR2ZhWknTQbWEfDj9gvBHXr4jl3NusX2YUgJTRs
         EMB7H6mRNPu1NhC9bwE54cEQe1/0A2kIyWnuPCXdlb+FX07YNO8Ly5aluWVj6q6zbz3Y
         Dktw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ghBL8B+VYZnSMGW+02Rnd6WA6Oi+9/f0M5wCqFvghoc=;
        b=Vi/jvVXoeYz/W6P5T7d2InU96UgSNWewFhGT12j3gs74EvN20H0jkZgFFKYysBAjwj
         ue6FlTRHTtPECS5InBNn9BF/2tblJ+wILQ1NzCPco4tUdG6uKYIBHc/4+OHJmvK+w2hh
         vMNp4wBktBT9pkJQJgSS1O/QSzn8yGDIsIr5/eeUiUqSXA12yxBsz01VTa74z2yTkJjy
         CBtBjwnQhlvZMKZS04xydXcHi4loxL5cg05AwUD5pmMKmruMh1ZmIXY2bFKWdNIiW3io
         Ko+aJTBiTEvpTfaOoZWPGF8b3H7miyezTpvFmSFNXzNztsDC2WNalNM+SWgo17tyjaMR
         n3Fw==
X-Gm-Message-State: AJIora8RIRJo33ZF7SCWRvCWH/X7/LdH4DW3iRjjL/vUM3oPz/heglHU
        anj9vjT+uiXd7g/0hKOIWlnIX10XFtO8YCLriyFQUQ==
X-Google-Smtp-Source: AGRyM1tZUukGk0WYWTaAZndO4B+WbhHEg6ly52tuKeWVNEAYvaI1LeACu0B1pFOWVO8T/AOqt/jklnrY6m4gzyywiXA=
X-Received: by 2002:a05:6808:140b:b0:335:30a3:25df with SMTP id
 w11-20020a056808140b00b0033530a325dfmr2262308oiv.110.1656017322863; Thu, 23
 Jun 2022 13:48:42 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <8f4eef289aba5067582d0d3535299c22a4e5c4c4.1655761627.git.ashish.kalra@amd.com>
In-Reply-To: <8f4eef289aba5067582d0d3535299c22a4e5c4c4.1655761627.git.ashish.kalra@amd.com>
From:   Marc Orr <marcorr@google.com>
Date:   Thu, 23 Jun 2022 13:48:31 -0700
Message-ID: <CAA03e5FgfVQbz=pvMeBpOHENe5Rf_7UvE3iAqcgm=9nmwGEEBw@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 03/49] x86/sev: Add the host SEV-SNP
 initialization support
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        "Roth, Michael" <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, jarkko@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 4:02 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> The memory integrity guarantees of SEV-SNP are enforced through a new
> structure called the Reverse Map Table (RMP). The RMP is a single data
> structure shared across the system that contains one entry for every 4K
> page of DRAM that may be used by SEV-SNP VMs. The goal of RMP is to
> track the owner of each page of memory. Pages of memory can be owned by
> the hypervisor, owned by a specific VM or owned by the AMD-SP. See APM2
> section 15.36.3 for more detail on RMP.
>
> The RMP table is used to enforce access control to memory. The table itself
> is not directly writable by the software. New CPU instructions (RMPUPDATE,
> PVALIDATE, RMPADJUST) are used to manipulate the RMP entries.
>
> Based on the platform configuration, the BIOS reserves the memory used
> for the RMP table. The start and end address of the RMP table must be
> queried by reading the RMP_BASE and RMP_END MSRs. If the RMP_BASE and
> RMP_END are not set then disable the SEV-SNP feature.
>
> The SEV-SNP feature is enabled only after the RMP table is successfully
> initialized.
>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/include/asm/disabled-features.h |   8 +-
>  arch/x86/include/asm/msr-index.h         |   6 +
>  arch/x86/kernel/sev.c                    | 144 +++++++++++++++++++++++
>  3 files changed, 157 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
> index 36369e76cc63..c1be3091a383 100644
> --- a/arch/x86/include/asm/disabled-features.h
> +++ b/arch/x86/include/asm/disabled-features.h
> @@ -68,6 +68,12 @@
>  # define DISABLE_TDX_GUEST     (1 << (X86_FEATURE_TDX_GUEST & 31))
>  #endif
>
> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +# define DISABLE_SEV_SNP       0
> +#else
> +# define DISABLE_SEV_SNP       (1 << (X86_FEATURE_SEV_SNP & 31))
> +#endif
> +
>  /*
>   * Make sure to add features to the correct mask
>   */
> @@ -91,7 +97,7 @@
>                          DISABLE_ENQCMD)
>  #define DISABLED_MASK17        0
>  #define DISABLED_MASK18        0
> -#define DISABLED_MASK19        0
> +#define DISABLED_MASK19        (DISABLE_SEV_SNP)
>  #define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 20)
>
>  #endif /* _ASM_X86_DISABLED_FEATURES_H */
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 9e2e7185fc1d..57a8280e283a 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -507,6 +507,8 @@
>  #define MSR_AMD64_SEV_ENABLED          BIT_ULL(MSR_AMD64_SEV_ENABLED_BIT)
>  #define MSR_AMD64_SEV_ES_ENABLED       BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
>  #define MSR_AMD64_SEV_SNP_ENABLED      BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
> +#define MSR_AMD64_RMP_BASE             0xc0010132
> +#define MSR_AMD64_RMP_END              0xc0010133
>
>  #define MSR_AMD64_VIRT_SPEC_CTRL       0xc001011f
>
> @@ -581,6 +583,10 @@
>  #define MSR_AMD64_SYSCFG               0xc0010010
>  #define MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT       23
>  #define MSR_AMD64_SYSCFG_MEM_ENCRYPT   BIT_ULL(MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT)
> +#define MSR_AMD64_SYSCFG_SNP_EN_BIT            24
> +#define MSR_AMD64_SYSCFG_SNP_EN                BIT_ULL(MSR_AMD64_SYSCFG_SNP_EN_BIT)
> +#define MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT       25
> +#define MSR_AMD64_SYSCFG_SNP_VMPL_EN   BIT_ULL(MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT)

nit: The alignment here looks off. The rest of the file left-aligns
the macro definition column under a comment header. The bad alignment
can be viewed on the github version of this patch:
https://github.com/AMDESE/linux/commit/5101daef92f448c046207b701c0c420b1fce3eaf

>  #define MSR_K8_INT_PENDING_MSG         0xc0010055
>  /* C1E active bits in int pending message */
>  #define K8_INTP_C1E_ACTIVE_MASK                0x18000000
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index f01f4550e2c6..3a233b5d47c5 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -22,6 +22,8 @@
>  #include <linux/efi.h>
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
> +#include <linux/cpumask.h>
> +#include <linux/iommu.h>
>
>  #include <asm/cpu_entry_area.h>
>  #include <asm/stacktrace.h>
> @@ -38,6 +40,7 @@
>  #include <asm/apic.h>
>  #include <asm/cpuid.h>
>  #include <asm/cmdline.h>
> +#include <asm/iommu.h>
>
>  #define DR7_RESET_VALUE        0x400
>
> @@ -57,6 +60,12 @@
>  #define AP_INIT_CR0_DEFAULT            0x60000010
>  #define AP_INIT_MXCSR_DEFAULT          0x1f80
>
> +/*
> + * The first 16KB from the RMP_BASE is used by the processor for the
> + * bookkeeping, the range need to be added during the RMP entry lookup.
> + */
> +#define RMPTABLE_CPU_BOOKKEEPING_SZ    0x4000
> +
>  /* For early boot hypervisor communication in SEV-ES enabled guests */
>  static struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
>
> @@ -69,6 +78,10 @@ static struct ghcb *boot_ghcb __section(".data");
>  /* Bitmap of SEV features supported by the hypervisor */
>  static u64 sev_hv_features __ro_after_init;
>
> +static unsigned long rmptable_start __ro_after_init;
> +static unsigned long rmptable_end __ro_after_init;
> +
> +
>  /* #VC handler runtime per-CPU data */
>  struct sev_es_runtime_data {
>         struct ghcb ghcb_page;
> @@ -2218,3 +2231,134 @@ static int __init snp_init_platform_device(void)
>         return 0;
>  }
>  device_initcall(snp_init_platform_device);
> +
> +#undef pr_fmt
> +#define pr_fmt(fmt)    "SEV-SNP: " fmt
> +
> +static int __snp_enable(unsigned int cpu)
> +{
> +       u64 val;
> +
> +       if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +               return 0;
> +
> +       rdmsrl(MSR_AMD64_SYSCFG, val);
> +
> +       val |= MSR_AMD64_SYSCFG_SNP_EN;
> +       val |= MSR_AMD64_SYSCFG_SNP_VMPL_EN;
> +
> +       wrmsrl(MSR_AMD64_SYSCFG, val);
> +
> +       return 0;
> +}
> +
> +static __init void snp_enable(void *arg)
> +{
> +       __snp_enable(smp_processor_id());
> +}
> +
> +static bool get_rmptable_info(u64 *start, u64 *len)
> +{
> +       u64 calc_rmp_sz, rmp_sz, rmp_base, rmp_end, nr_pages;
> +
> +       rdmsrl(MSR_AMD64_RMP_BASE, rmp_base);
> +       rdmsrl(MSR_AMD64_RMP_END, rmp_end);
> +
> +       if (!rmp_base || !rmp_end) {
> +               pr_info("Memory for the RMP table has not been reserved by BIOS\n");
> +               return false;
> +       }
> +
> +       rmp_sz = rmp_end - rmp_base + 1;
> +
> +       /*
> +        * Calculate the amount the memory that must be reserved by the BIOS to
> +        * address the full system RAM. The reserved memory should also cover the
> +        * RMP table itself.
> +        *
> +        * See PPR Family 19h Model 01h, Revision B1 section 2.1.4.2 for more
> +        * information on memory requirement.
> +        */
> +       nr_pages = totalram_pages();
> +       calc_rmp_sz = (((rmp_sz >> PAGE_SHIFT) + nr_pages) << 4) + RMPTABLE_CPU_BOOKKEEPING_SZ;
> +
> +       if (calc_rmp_sz > rmp_sz) {
> +               pr_info("Memory reserved for the RMP table does not cover full system RAM (expected 0x%llx got 0x%llx)\n",
> +                       calc_rmp_sz, rmp_sz);
> +               return false;
> +       }
> +
> +       *start = rmp_base;
> +       *len = rmp_sz;
> +
> +       pr_info("RMP table physical address 0x%016llx - 0x%016llx\n", rmp_base, rmp_end);
> +
> +       return true;
> +}
> +
> +static __init int __snp_rmptable_init(void)
> +{
> +       u64 rmp_base, sz;
> +       void *start;
> +       u64 val;
> +
> +       if (!get_rmptable_info(&rmp_base, &sz))
> +               return 1;
> +
> +       start = memremap(rmp_base, sz, MEMREMAP_WB);
> +       if (!start) {
> +               pr_err("Failed to map RMP table 0x%llx+0x%llx\n", rmp_base, sz);
> +               return 1;
> +       }
> +
> +       /*
> +        * Check if SEV-SNP is already enabled, this can happen if we are coming from
> +        * kexec boot.
> +        */
> +       rdmsrl(MSR_AMD64_SYSCFG, val);
> +       if (val & MSR_AMD64_SYSCFG_SNP_EN)
> +               goto skip_enable;
> +
> +       /* Initialize the RMP table to zero */
> +       memset(start, 0, sz);
> +
> +       /* Flush the caches to ensure that data is written before SNP is enabled. */
> +       wbinvd_on_all_cpus();
> +
> +       /* Enable SNP on all CPUs. */
> +       on_each_cpu(snp_enable, NULL, 1);
> +
> +skip_enable:
> +       rmptable_start = (unsigned long)start;
> +       rmptable_end = rmptable_start + sz;
> +
> +       return 0;
> +}
> +
> +static int __init snp_rmptable_init(void)
> +{
> +       if (!boot_cpu_has(X86_FEATURE_SEV_SNP))
> +               return 0;
> +
> +       if (!iommu_sev_snp_supported())
> +               goto nosnp;
> +
> +       if (__snp_rmptable_init())
> +               goto nosnp;
> +
> +       cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "x86/rmptable_init:online", __snp_enable, NULL);
> +
> +       return 0;
> +
> +nosnp:
> +       setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
> +       return 1;

Seems odd that we're returning 1 here, rather than 0. I tried to
figure out how the initcall return values are used and failed. My
impression was 0 means success and a negative number means failure.
But maybe this is normal.

> +}
> +
> +/*
> + * This must be called after the PCI subsystem. This is because before enabling
> + * the SNP feature we need to ensure that IOMMU supports the SEV-SNP feature.
> + * The iommu_sev_snp_support() is used for checking the feature, and it is
> + * available after subsys_initcall().
> + */
> +fs_initcall(snp_rmptable_init);
> --
> 2.25.1
>
