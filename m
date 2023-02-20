Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD17369D486
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 21:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbjBTUMv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 15:12:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232501AbjBTUMs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 15:12:48 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD9F1F4A3;
        Mon, 20 Feb 2023 12:12:42 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id r27so927688lfe.10;
        Mon, 20 Feb 2023 12:12:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+/VKjY4djrhBk+dfikrcBNoMLfWCF8AwtLt4+hCrIOM=;
        b=KzFa9OoOCrk+4WU9nfOwUyAx0CiKA3aobGFPIQPZBPJmuefqwe42K2kF0xWOkzYTtG
         d2DF5A1jKYvHnE05ctZRLP45bM0lZqF2XaTRVU4Q+xDMCtVryOnIv6l7fmrHaOphsSdW
         3T4LMxvrnzslVMXuWaIzEkTaGRNszmP1DoWkkSWwsI96W8kq8Kvs9H7oojKK9RUqS3wm
         2IKQSwS82BOSDxXX50y0c1e3vmLrWQqszb61no3SFPIsu7sWB6BZAGg/P1dM4cqTqR1e
         wPGGiMmDqDRMwV0+zXU5uwyFYPaD9Zi34EdUzqJPAf10v7J+5MoSk7pTYXoqpYP3mbTv
         02ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+/VKjY4djrhBk+dfikrcBNoMLfWCF8AwtLt4+hCrIOM=;
        b=OkFMJ3MShLtoXJ+RcKn3SUiadhtKrrh4QAb9LaMyzTK2qez7G+b+FUJswgkcITAKHO
         KavrT3L1+6X2d0665AeDrnY5JyJSX8SzOVzwn0KJiXW6WVo4/viVS6jVMkQQdmfw/FY4
         YYwd4zu2RFR6iS1feLnQMjG2teGzD29TzfzXPlW6edyDb+r4BP8eyW7A6Ys3F8TtICNv
         EKI45epdXeNRoYOi2222wOvlwo5QANKji1O24jVGXKDBu/SbqcKWEgkejSuElpEGYmsO
         lA69CZd1zVBXR4Cqqzr1+f4tdHZR7CxmHEOPMZ5FqdGJX/kMdiDoLYAAco7mNHb18jpE
         tPdg==
X-Gm-Message-State: AO0yUKUhCbLNLkPrijdKEN8AglduSoWo/cEcuebtWSgJFjWfK8rOpBmC
        TxRis6jcaO7vdMSpIjIv1L8=
X-Google-Smtp-Source: AK7set/S1scvei2S2myvDfULJMWNcKG7pP25K+/YTiBVkm1bt9GlH99Pc+7gxOC2WrtwBWCuSTAq7A==
X-Received: by 2002:ac2:599a:0:b0:4b6:e4c8:8a4e with SMTP id w26-20020ac2599a000000b004b6e4c88a4emr840669lfn.0.1676923960571;
        Mon, 20 Feb 2023 12:12:40 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id t4-20020ac243a4000000b004dbebb3a6fasm231498lfl.175.2023.02.20.12.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 12:12:40 -0800 (PST)
Date:   Mon, 20 Feb 2023 22:12:36 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH RFC v8 11/56] x86/sev: Add the host SEV-SNP
 initialization support
Message-ID: <20230220221236.00002a80@gmail.com>
In-Reply-To: <20230220183847.59159-12-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
        <20230220183847.59159-12-michael.roth@amd.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Feb 2023 12:38:02 -0600
Michael Roth <michael.roth@amd.com> wrote:

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
> The RMP table is used to enforce access control to memory. The table
> itself is not directly writable by the software. New CPU instructions
> (RMPUPDATE, PVALIDATE, RMPADJUST) are used to manipulate the RMP
> entries.
> 
> Based on the platform configuration, the BIOS reserves the memory used
> for the RMP table. The start and end address of the RMP table must be
> queried by reading the RMP_BASE and RMP_END MSRs. If the RMP_BASE and
> RMP_END are not set then disable the SEV-SNP feature.
> 
> The SEV-SNP feature is enabled only after the RMP table is successfully
> initialized.
> 
> Also set SYSCFG.MFMD when enabling SNP as SEV-SNP FW >= 1.51 requires
> that SYSCFG.MFMD must be se
> 
                           ^ unfinished sentence.
> RMP table entry format is non-architectural and it can vary by processor
> and is defined by the PPR. Restrict SNP support on the known CPU model
> and family for which the RMP table entry format is currently defined
> for.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/include/asm/disabled-features.h |   8 +-
>  arch/x86/include/asm/msr-index.h         |  11 +-
>  arch/x86/kernel/sev.c                    | 175 +++++++++++++++++++++++
>  3 files changed, 192 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
> index 33d2cd04d254..9b5a2cc8064a 100644
> --- a/arch/x86/include/asm/disabled-features.h
> +++ b/arch/x86/include/asm/disabled-features.h
> @@ -87,6 +87,12 @@
>  # define DISABLE_TDX_GUEST	(1 << (X86_FEATURE_TDX_GUEST & 31))
>  #endif
>  
> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +# define DISABLE_SEV_SNP	0
> +#else
> +# define DISABLE_SEV_SNP	(1 << (X86_FEATURE_SEV_SNP & 31))
> +#endif
> +
>  /*
>   * Make sure to add features to the correct mask
>   */
> @@ -110,7 +116,7 @@
>  			 DISABLE_ENQCMD)
>  #define DISABLED_MASK17	0
>  #define DISABLED_MASK18	0
> -#define DISABLED_MASK19	0
> +#define DISABLED_MASK19	(DISABLE_SEV_SNP)
>  #define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 20)
>  
>  #endif /* _ASM_X86_DISABLED_FEATURES_H */
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 10ac52705892..35100c630617 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -565,6 +565,8 @@
>  #define MSR_AMD64_SEV_ENABLED		BIT_ULL(MSR_AMD64_SEV_ENABLED_BIT)
>  #define MSR_AMD64_SEV_ES_ENABLED	BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
>  #define MSR_AMD64_SEV_SNP_ENABLED	BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
> +#define MSR_AMD64_RMP_BASE		0xc0010132
> +#define MSR_AMD64_RMP_END		0xc0010133
>  
>  #define MSR_AMD64_VIRT_SPEC_CTRL	0xc001011f
>  
> @@ -649,7 +651,14 @@
>  #define MSR_K8_TOP_MEM2			0xc001001d
>  #define MSR_AMD64_SYSCFG		0xc0010010
>  #define MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT	23
> -#define MSR_AMD64_SYSCFG_MEM_ENCRYPT	BIT_ULL(MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT)
> +#define MSR_AMD64_SYSCFG_MEM_ENCRYPT		BIT_ULL(MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT)
> +#define MSR_AMD64_SYSCFG_SNP_EN_BIT		24
> +#define MSR_AMD64_SYSCFG_SNP_EN		BIT_ULL(MSR_AMD64_SYSCFG_SNP_EN_BIT)
> +#define MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT	25
> +#define MSR_AMD64_SYSCFG_SNP_VMPL_EN		BIT_ULL(MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT)
> +#define MSR_AMD64_SYSCFG_MFDM_BIT		19
> +#define MSR_AMD64_SYSCFG_MFDM			BIT_ULL(MSR_AMD64_SYSCFG_MFDM_BIT)
						^ an extra tab?
> +
>  #define MSR_K8_INT_PENDING_MSG		0xc0010055
>  /* C1E active bits in int pending message */
>  #define K8_INTP_C1E_ACTIVE_MASK		0x18000000
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index a428c62330d3..e54e412c9916 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -22,6 +22,9 @@
>  #include <linux/efi.h>
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
> +#include <linux/cpumask.h>
> +#include <linux/iommu.h>
> +#include <linux/amd-iommu.h>
>  
>  #include <asm/cpu_entry_area.h>
>  #include <asm/stacktrace.h>
> @@ -38,6 +41,7 @@
>  #include <asm/apic.h>
>  #include <asm/cpuid.h>
>  #include <asm/cmdline.h>
> +#include <asm/iommu.h>
>  
>  #define DR7_RESET_VALUE        0x400
>  
> @@ -57,6 +61,12 @@
>  #define AP_INIT_CR0_DEFAULT		0x60000010
>  #define AP_INIT_MXCSR_DEFAULT		0x1f80
>  
> +/*
> + * The first 16KB from the RMP_BASE is used by the processor for the
> + * bookkeeping, the range needs to be added during the RMP entry lookup.
> + */
> +#define RMPTABLE_CPU_BOOKKEEPING_SZ	0x4000
> +
>  /* For early boot hypervisor communication in SEV-ES enabled guests */
>  static struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
>  
> @@ -69,6 +79,9 @@ static struct ghcb *boot_ghcb __section(".data");
>  /* Bitmap of SEV features supported by the hypervisor */
>  static u64 sev_hv_features __ro_after_init;
>  
> +static unsigned long rmptable_start __ro_after_init;
> +static unsigned long rmptable_end __ro_after_init;
> +
>  /* #VC handler runtime per-CPU data */
>  struct sev_es_runtime_data {
>  	struct ghcb ghcb_page;
> @@ -2260,3 +2273,165 @@ static int __init snp_init_platform_device(void)
>  	return 0;
>  }
>  device_initcall(snp_init_platform_device);
> +
> +#undef pr_fmt
> +#define pr_fmt(fmt)	"SEV-SNP: " fmt
> +
> +static int __mfd_enable(unsigned int cpu)
> +{
> +	u64 val;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return 0;
> +
> +	rdmsrl(MSR_AMD64_SYSCFG, val);
> +
> +	val |= MSR_AMD64_SYSCFG_MFDM;
> +
> +	wrmsrl(MSR_AMD64_SYSCFG, val);
> +
> +	return 0;
> +}
> +
> +static __init void mfd_enable(void *arg)
> +{
> +	__mfd_enable(smp_processor_id());
> +}
> +
> +static int __snp_enable(unsigned int cpu)
> +{
> +	u64 val;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return 0;
> +
> +	rdmsrl(MSR_AMD64_SYSCFG, val);
> +
> +	val |= MSR_AMD64_SYSCFG_SNP_EN;
> +	val |= MSR_AMD64_SYSCFG_SNP_VMPL_EN;
> +
> +	wrmsrl(MSR_AMD64_SYSCFG, val);
> +
> +	return 0;
> +}
> +
> +static __init void snp_enable(void *arg)
> +{
> +	__snp_enable(smp_processor_id());
> +}
> +
> +static bool get_rmptable_info(u64 *start, u64 *len)
> +{
> +	u64 calc_rmp_sz, rmp_sz, rmp_base, rmp_end;
> +
> +	rdmsrl(MSR_AMD64_RMP_BASE, rmp_base);
> +	rdmsrl(MSR_AMD64_RMP_END, rmp_end);
> +
> +	if (!rmp_base || !rmp_end) {
> +		pr_err("Memory for the RMP table has not been reserved by BIOS\n");
> +		return false;
> +	}
> +
> +	rmp_sz = rmp_end - rmp_base + 1;
> +
> +	/*
> +	 * Calculate the amount the memory that must be reserved by the BIOS to
> +	 * address the whole RAM. The reserved memory should also cover the
> +	 * RMP table itself.
> +	 */
> +	calc_rmp_sz = (((rmp_sz >> PAGE_SHIFT) + totalram_pages()) << 4)
> +		      + RMPTABLE_CPU_BOOKKEEPING_SZ;
> +
> +	if (calc_rmp_sz > rmp_sz) {
> +		pr_err("Memory reserved for the RMP table does not cover full system RAM (expected 0x%llx got 0x%llx)\n",
> +		       calc_rmp_sz, rmp_sz);
> +		return false;
> +	}
> +
> +	*start = rmp_base;
> +	*len = rmp_sz;
> +
> +	pr_info("RMP table physical address [0x%016llx - 0x%016llx]\n", rmp_base, rmp_end);
> +
> +	return true;
> +}
> +
> +static __init int snp_rmptable_init(void)
> +{
> +	u64 rmp_base, sz;
> +	void *start;
> +	u64 val;
> +
> +	if (!get_rmptable_info(&rmp_base, &sz))
> +		return 1;
> +
> +	start = memremap(rmp_base, sz, MEMREMAP_WB);
> +	if (!start) {
> +		pr_err("Failed to map RMP table addr 0x%llx size 0x%llx\n", rmp_base, sz);
> +		return 1;
> +	}
> +
> +	/*
> +	 * Check if SEV-SNP is already enabled, this can happen in case of
> +	 * kexec boot.
> +	 */
> +	rdmsrl(MSR_AMD64_SYSCFG, val);
> +	if (val & MSR_AMD64_SYSCFG_SNP_EN)
> +		goto skip_enable;
> +
> +	memset(start, 0, sz);
> +
> +	/* Flush the caches to ensure that data is written before SNP is enabled. */
> +	wbinvd_on_all_cpus();
> +
> +	/* MFDM must be enabled on all the CPUs prior to enabling SNP. */
> +	on_each_cpu(mfd_enable, NULL, 1);
> +
> +	/* Enable SNP on all CPUs. */
> +	on_each_cpu(snp_enable, NULL, 1);
> +
> +skip_enable:
> +	rmptable_start = (unsigned long)start;
> +	rmptable_end = rmptable_start + sz - 1;
> +
> +	return 0;
> +}
> +
> +static int __init snp_host_init(void)
> +{
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return 0;
> +
> +	/*
> +	 * RMP table entry format is not architectural and it can vary by processor and
> +	 * is defined by the per-processor PPR. Restrict SNP support on the known CPU
> +	 * model and family for which the RMP table entry format is currently defined for.
> +	 */
> +	if (boot_cpu_data.x86 != 0x19 || boot_cpu_data.x86_model > 0xaf)
> +		goto nosnp;
> +
> +	if (amd_iommu_snp_enable())
> +		goto nosnp;
> +
> +	if (snp_rmptable_init())
> +		goto nosnp;
> +
> +	cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "x86/rmptable_init:online", __snp_enable, NULL);
> +
> +	return 0;
> +
> +nosnp:
> +	setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
> +	return -ENODEV;
> +}
> +
> +/*
> + * This must be called after the PCI subsystem. This is because amd_iommu_snp_enable()
> + * is called to ensure the IOMMU supports the SEV-SNP feature, which can only be
> + * called after subsys_initcall().
> + *
> + * NOTE: IOMMU is enforced by SNP to ensure that hypervisor cannot program DMA
> + * directly into guest private memory. In case of SNP, the IOMMU ensures that
> + * the page(s) used for DMA are hypervisor owned.
> + */
> +fs_initcall(snp_host_init);

