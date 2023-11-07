Return-Path: <kvm+bounces-1031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 004067E4613
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 17:32:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2105A1C20D44
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:32:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F25B328CA;
	Tue,  7 Nov 2023 16:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Ir2P9eUe"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F00347B7;
	Tue,  7 Nov 2023 16:32:36 +0000 (UTC)
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EAA82D61;
	Tue,  7 Nov 2023 08:32:35 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id C61F840E01A4;
	Tue,  7 Nov 2023 16:32:32 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id g1-qSrUy7Zvx; Tue,  7 Nov 2023 16:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1699374750; bh=/66xR9WwT2nRxnZsZiVrrkdqU3jUBlpqlG2vSrMefUg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ir2P9eUeMj8FlnblX4WEHf2sRZaTnOn4y3N4kA74rLKXhsZEFIYfRicDarY5Wy8y4
	 lL0smUZvdgqddTRDmeHAp5aZk7Q8Udtan+Fr7JVZ7ekWTfgXPmUe4UZ0TPWXa0KBkI
	 k19fbhPpUVz8NPj3ig6Q3bQH5XfZbnIf6pL64L2c64HA3zqCwUNgE741S4XpFBq5Cg
	 /SmNdQM2iYkZyVqFa7gRc96FBjT4zs2ZSds9cMSmAtCcsrHhyMecsqIHmSxlzmzmAw
	 oriD6xITv5/zgGg4F7JP0NllNQt9XUfY7qWWrYBepJMo3GjmnAoKOL+DXQhI3QaY8R
	 gGq8ZmUtR/jEJOKSEc/0HJFVM2kIlT5AkcCC6bm6ruGnXExeghDeb53oSJdJQpwvA+
	 faRvbpc2Lu0HC+CCR8PSvLqpZ0jWMIk1Zf2pTwMOmg9Jc3BGkl6Vh96cfGPL4qUCVm
	 Cnl36cVAnK5R67SlIw+QRh23Hbd/Pt4GDD3nnLE7s1H6bnUPcZzWz8g9RZGlfJ7COU
	 6lcrAiwbqL4adLdVYZElKNTynazvC0aLKGc9lvxBhpGT3hFKxE7DBB5Jh1RkZxo8CF
	 VBsphHJCfIYnvLAlELR3g6uAoCcaUvcIbgcZuUlKoPC3Jov4o8xSh+K+mVGNfuUUIL
	 A4yoxiNdT0B4LxfLNZkL6NJY=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3430040E0191;
	Tue,  7 Nov 2023 16:31:50 +0000 (UTC)
Date: Tue, 7 Nov 2023 17:31:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
	ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
	tony.luck@intel.com, marcorr@google.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v10 06/50] x86/sev: Add the host SEV-SNP initialization
 support
Message-ID: <20231107163142.GAZUpmbt/i3himIf+E@fat_crate.local>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-7-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231016132819.1002933-7-michael.roth@amd.com>

On Mon, Oct 16, 2023 at 08:27:35AM -0500, Michael Roth wrote:
> +static bool early_rmptable_check(void)
> +{
> +	u64 rmp_base, rmp_size;
> +
> +	/*
> +	 * For early BSP initialization, max_pfn won't be set up yet, wait until
> +	 * it is set before performing the RMP table calculations.
> +	 */
> +	if (!max_pfn)
> +		return true;

This already says that this is called at the wrong point during init.

Right now we have

early_identify_cpu -> early_init_amd -> early_detect_mem_encrypt

which runs only on the BSP but then early_init_amd() is called in
init_amd() too so that it takes care of the APs too.

Which ends up doing a lot of unnecessary work on each AP in
early_detect_mem_encrypt() like calculating the RMP size on each AP
unnecessarily where this needs to happen exactly once.

Is there any reason why this function cannot be moved to init_amd()
where it'll do the normal, per-AP init?

And the stuff that needs to happen once, needs to be called once too.

> +
> +	return snp_get_rmptable_info(&rmp_base, &rmp_size);
> +}
> +
>  static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>  {
>  	u64 msr;
> @@ -659,6 +674,9 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>  		if (!(msr & MSR_K7_HWCR_SMMLOCK))
>  			goto clear_sev;
>  
> +		if (cpu_has(c, X86_FEATURE_SEV_SNP) && !early_rmptable_check())
> +			goto clear_snp;
> +
>  		return;
>  
>  clear_all:
> @@ -666,6 +684,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>  clear_sev:
>  		setup_clear_cpu_cap(X86_FEATURE_SEV);
>  		setup_clear_cpu_cap(X86_FEATURE_SEV_ES);
> +clear_snp:
>  		setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
>  	}
>  }

...

> +bool snp_get_rmptable_info(u64 *start, u64 *len)
> +{
> +	u64 max_rmp_pfn, calc_rmp_sz, rmp_sz, rmp_base, rmp_end;
> +
> +	rdmsrl(MSR_AMD64_RMP_BASE, rmp_base);
> +	rdmsrl(MSR_AMD64_RMP_END, rmp_end);
> +
> +	if (!(rmp_base & RMP_ADDR_MASK) || !(rmp_end & RMP_ADDR_MASK)) {
> +		pr_err("Memory for the RMP table has not been reserved by BIOS\n");
> +		return false;
> +	}

If you're masking off bits 0-12 above...

> +
> +	if (rmp_base > rmp_end) {

... why aren't you using the masked out vars further on?

I know, the hw will say, yeah, those bits are 0 but still. IOW, do:

	rmp_base &= RMP_ADDR_MASK;
	rmp_end  &= RMP_ADDR_MASK;

after reading them.

> +		pr_err("RMP configuration not valid: base=%#llx, end=%#llx\n", rmp_base, rmp_end);
> +		return false;
> +	}
> +
> +	rmp_sz = rmp_end - rmp_base + 1;
> +
> +	/*
> +	 * Calculate the amount the memory that must be reserved by the BIOS to
> +	 * address the whole RAM, including the bookkeeping area. The RMP itself
> +	 * must also be covered.
> +	 */
> +	max_rmp_pfn = max_pfn;
> +	if (PHYS_PFN(rmp_end) > max_pfn)
> +		max_rmp_pfn = PHYS_PFN(rmp_end);
> +
> +	calc_rmp_sz = (max_rmp_pfn << 4) + RMPTABLE_CPU_BOOKKEEPING_SZ;
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
> +	return true;
> +}
> +
> +static __init int __snp_rmptable_init(void)
> +{
> +	u64 rmp_base, rmp_size;
> +	void *rmp_start;
> +	u64 val;
> +
> +	if (!snp_get_rmptable_info(&rmp_base, &rmp_size))
> +		return 1;
> +
> +	pr_info("RMP table physical address [0x%016llx - 0x%016llx]\n",

That's "RMP table physical range"

> +		rmp_base, rmp_base + rmp_size - 1);
> +
> +	rmp_start = memremap(rmp_base, rmp_size, MEMREMAP_WB);
> +	if (!rmp_start) {
> +		pr_err("Failed to map RMP table addr 0x%llx size 0x%llx\n", rmp_base, rmp_size);

No need to dump rmp_base and rmp_size again here - you're dumping them
above.

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
> +	/* Initialize the RMP table to zero */

Again: useless comment.

> +	memset(rmp_start, 0, rmp_size);
> +
> +	/* Flush the caches to ensure that data is written before SNP is enabled. */
> +	wbinvd_on_all_cpus();
> +
> +	/* MFDM must be enabled on all the CPUs prior to enabling SNP. */

First of all, use the APM bit name here pls: MtrrFixDramModEn.

And then, for the life of me, I can't find any mention in the APM why
this bit is needed. Neither in "15.36.2 Enabling SEV-SNP" nor in
"15.34.3 Enabling SEV".

Looking at the bit defintions of WrMem an RdMem - read and write
requests get directed to system memory instead of MMIO so I guess you
don't want to be able to write MMIO for certain physical ranges when SNP
is enabled but it'll be good to have this properly explained instead of
a "this must happen" information-less sentence.

> +	on_each_cpu(mfd_enable, NULL, 1);
> +
> +	/* Enable SNP on all CPUs. */

Useless comment.

> +	on_each_cpu(snp_enable, NULL, 1);
> +
> +skip_enable:
> +	rmp_start += RMPTABLE_CPU_BOOKKEEPING_SZ;
> +	rmp_size -= RMPTABLE_CPU_BOOKKEEPING_SZ;
> +
> +	rmptable_start = (struct rmpentry *)rmp_start;
> +	rmptable_max_pfn = rmp_size / sizeof(struct rmpentry) - 1;
> +
> +	return 0;
> +}
> +
> +static int __init snp_rmptable_init(void)
> +{
> +	int family, model;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return 0;
> +
> +	family = boot_cpu_data.x86;
> +	model  = boot_cpu_data.x86_model;

Looks useless - just use boot_cpu_data directly below.

As mentioned here already https://lore.kernel.org/all/Y9ubi0i4Z750gdMm@zn.tnic/

And I already mentioned that for v9:

https://lore.kernel.org/r/20230621094236.GZZJLGDAicp1guNPvD@fat_crate.local

Next time I'm NAKing this patch until you incorporate all review
comments or you give a technical reason why you disagree with them.

> +	/*
> +	 * RMP table entry format is not architectural and it can vary by processor and
> +	 * is defined by the per-processor PPR. Restrict SNP support on the known CPU
> +	 * model and family for which the RMP table entry format is currently defined for.
> +	 */
> +	if (family != 0x19 || model > 0xaf)
> +		goto nosnp;
> +
> +	if (amd_iommu_snp_enable())
> +		goto nosnp;
> +
> +	if (__snp_rmptable_init())
> +		goto nosnp;
> +
> +	cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "x86/rmptable_init:online", __snp_enable, NULL);
> +
> +	return 0;
> +
> +nosnp:
> +	setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
> +	return -ENOSYS;
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
> +fs_initcall(snp_rmptable_init);

This looks backwards. AFAICT, the IOMMU code should call arch code to
enable SNP at the right time, not the other way around - arch code
calling driver code.

Especially if the SNP table enablement depends on some exact IOMMU
init_state:

        if (init_state > IOMMU_ENABLED) {
		pr_err("SNP: Too late to enable SNP for IOMMU.\n");


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

