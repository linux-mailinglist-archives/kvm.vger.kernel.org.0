Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBB2E553693
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 17:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353089AbiFUPrS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350742AbiFUPrR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:47:17 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7C12CDFF
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 08:47:15 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id a13so13197172lfr.10
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 08:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=42GgnITWZh+b27jV3AHdl/DcQ5SE6yXvLOohhw0wUcY=;
        b=SiYYiKh+7WeBHFlQsw/+kDElxLAgY+jlDHm4oP5BJZgjLcb8W7uWr4IN16eQuTbike
         vr9BX/EKIc3FyjWPFfMLiGvnBWJK2RI4K91w7rQ+dpS5BJ3bYy+uWgZ0Jd7+RdaT4hwc
         xcov1YB9CpkzL/Z83RLV2pcQ7J1fq4jmVdu8lWDbHuF+3BKHIKPbQ/9qWZ9/oWj3Buv8
         WaB8Jn70W1Tyn2wmmrcoq1wQGfe/7XS3RqUgo3A4gSBJp1REGYy3B0+47+NKLr3BsP3P
         SeTnvwH6JqmNdo1MXdvMXFeJ6okrrguXVqPk4nkbBYYEKgm4Q3qCgyMthiiwfrPX42/k
         hF1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=42GgnITWZh+b27jV3AHdl/DcQ5SE6yXvLOohhw0wUcY=;
        b=vH80u9KoP7fh/Jexvm5TIqqSCX+voIy8jw5oFdGQo6/b48PWRQs9xuFlVlrgx1AOHB
         bGc9bmcZdE/Gmt6fIhyo6HWztTicelb6yKuVJ99mUsML7htMWZiBCG94N6+0/iY64qjO
         qmkg4GgF/TsmHIMaGvig4ANPgAGO4ctEC9JtAwQYd05uQYrVG/7fEEqr57OVewfVWoi9
         KbVIl8r0kTr4fy5icSeHnxtxl44B9lgeakaclC5qzUz55n5AfZeFbJMS4/845m1FCsOa
         76G0kxl7dwSsYTgqWTZYOQ6UV6qKxne44icFRCNUY0E09A/aZvdjVwnE3+Cbkyaf9ger
         PF9Q==
X-Gm-Message-State: AJIora83kZuzuiid81t967uKYnwsU8ciBSrpFE8G6XpCdFEbp6/TCjpf
        Ox9s6xAsXnhtLdSMeCyiX9ExC1ExHXeXbgVqFGpFNQ==
X-Google-Smtp-Source: AGRyM1tXLM5b/7UGEzV3s2TEIi9gqmYUh5eMhvGr1LwrVT1KFBhJKS+pOIuj5hFBOxXlAtlAmlGjZ2EnQMC6+FRweC0=
X-Received: by 2002:a05:6512:a94:b0:47f:6621:cf2a with SMTP id
 m20-20020a0565120a9400b0047f6621cf2amr8965752lfu.193.1655826433880; Tue, 21
 Jun 2022 08:47:13 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <8f4eef289aba5067582d0d3535299c22a4e5c4c4.1655761627.git.ashish.kalra@amd.com>
In-Reply-To: <8f4eef289aba5067582d0d3535299c22a4e5c4c4.1655761627.git.ashish.kalra@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 21 Jun 2022 09:47:02 -0600
Message-ID: <CAMkAt6qXSMf5zadv+rwHUp5hTHRJQzi66fJYEcU0QpMg1y7aXw@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 03/49] x86/sev: Add the host SEV-SNP
 initialization support
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
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
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Marc Orr <marcorr@google.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>, jarkko@kernel.org
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

On Mon, Jun 20, 2022 at 5:02 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
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

Since in get_rmptable_info() `rmp_sz = rmp_end - rmp_base + 1;` should
this be `rmptable_end = rmptable_start + sz - 1;`?

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
