Return-Path: <kvm+bounces-1088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C04C77E4B83
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 23:09:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1CF81C20B6E
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 22:09:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25BF32A8C4;
	Tue,  7 Nov 2023 22:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="kazyfy9M"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CCF2F87F;
	Tue,  7 Nov 2023 22:09:44 +0000 (UTC)
Received: from mail.alien8.de (mail.alien8.de [IPv6:2a01:4f9:3051:3f93::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B96583;
	Tue,  7 Nov 2023 14:09:43 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B818940E0192;
	Tue,  7 Nov 2023 22:09:40 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id MbibT-UAAQK9; Tue,  7 Nov 2023 22:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1699394978; bh=lOT/q2YMdfMaABo1869FPWc3E5BoFcxVu/riUnoyNfE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kazyfy9MvcfPtPI2fIHIuAgO8cNbKnOJerf7UFZ/vmwZ29AYomlihQKkFnCazWCGE
	 YnYFf2u+olFhHZl0nOc+C04jfE4t4ELuytMz89ibcTlyzbxSesC2ikJPfhOrC9SMfH
	 NE3mWDHSg5XeYHz2Zbj6kgduVhP0L++xlw3A21u0vAVVfwkAcdoTtBePO1fv9iFA8U
	 hO86aq6Y6f/3aLrVVaPX7CcMEUaOcp5uhcV1ImIwXDskHjLaARwQh+2WluChaABDrX
	 xc7Nf/k1xM2aPa8QYnQ2Lv68Asnz5tCVW+cBvrO+TuqbnR2TRHsjM6bG74aTSNO1ta
	 DfjNwkQecY8Rei72kk5mtZweOCD/p2gZLMRSioP68LcYUxfDA+zWhNx3jtPU7zZWTm
	 8cgb+STwIH65xamLBIGqLS679KW+fIGgv1+0j9tqMZFHMRFtL70r5NdbUMx7VfvvUf
	 YWcnYEPnH/uhjvMHdDBC36OEsVmm0Unt5Zup1Q3okckHBj4W0h2ShoC5ZJmo53tpFU
	 VTp/UWmukqbi4EkmCBYupQg4lwmzfl1AJDNE9De28cSLOmzUjhdZB39PFgGn/5qKqQ
	 SeS3sEMDv5G5hFV8jy96ohxCIdkFggvbyOWpxz9cUPmGv5ddsWN0RecxElZR+UNYgp
	 SAWqknNy5TXbnANuc6EsHRq4=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id F14EB40E0191;
	Tue,  7 Nov 2023 22:08:57 +0000 (UTC)
Date: Tue, 7 Nov 2023 23:08:52 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Kalra, Ashish" <ashish.kalra@amd.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev, linux-mm@kvack.org,
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
	jarkko@kernel.org, nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
	liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v10 06/50] x86/sev: Add the host SEV-SNP initialization
 support
Message-ID: <20231107220852.GGZUq1dHJ2q9LYV2oG@fat_crate.local>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-7-michael.roth@amd.com>
 <20231107163142.GAZUpmbt/i3himIf+E@fat_crate.local>
 <4a2016d6-dc1f-ff68-9827-0b72b7c8eac2@amd.com>
 <20231107191931.GCZUqNwxP8JcSbjZ0/@fat_crate.local>
 <20231107202757.GEZUqdzYyzVBHTBhZX@fat_crate.local>
 <250f5513-91c0-d0b5-cb59-439e26ba16dc@amd.com>
 <20231107212740.GFZUqrzK7yzy41dRKp@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231107212740.GFZUqrzK7yzy41dRKp@fat_crate.local>

Ontop. Only build-tested.

---
diff --git a/arch/x86/include/asm/iommu.h b/arch/x86/include/asm/iommu.h
index 2fd52b65deac..3be2451e7bc8 100644
--- a/arch/x86/include/asm/iommu.h
+++ b/arch/x86/include/asm/iommu.h
@@ -10,6 +10,7 @@ extern int force_iommu, no_iommu;
 extern int iommu_detected;
 extern int iommu_merge;
 extern int panic_on_overflow;
+extern bool amd_iommu_snp_en;
 
 #ifdef CONFIG_SWIOTLB
 extern bool x86_swiotlb_enable;
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 8b9ed72489e4..9237c327ad6d 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -196,23 +196,15 @@ static __init int __snp_rmptable_init(void)
 
 static int __init snp_rmptable_init(void)
 {
-	int family, model;
-
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!amd_iommu_snp_en)
 		return 0;
 
-	family = boot_cpu_data.x86;
-	model  = boot_cpu_data.x86_model;
-
 	/*
 	 * RMP table entry format is not architectural and it can vary by processor and
 	 * is defined by the per-processor PPR. Restrict SNP support on the known CPU
 	 * model and family for which the RMP table entry format is currently defined for.
 	 */
-	if (family != 0x19 || model > 0xaf)
-		goto nosnp;
-
-	if (amd_iommu_snp_enable())
+	if (boot_cpu_data.x86 != 0x19 || boot_cpu_data.x86_model > 0xaf)
 		goto nosnp;
 
 	if (__snp_rmptable_init())
@@ -228,12 +220,10 @@ static int __init snp_rmptable_init(void)
 }
 
 /*
- * This must be called after the PCI subsystem. This is because amd_iommu_snp_enable()
- * is called to ensure the IOMMU supports the SEV-SNP feature, which can only be
- * called after subsys_initcall().
+ * This must be called after the IOMMU has been initialized.
  *
  * NOTE: IOMMU is enforced by SNP to ensure that hypervisor cannot program DMA
  * directly into guest private memory. In case of SNP, the IOMMU ensures that
  * the page(s) used for DMA are hypervisor owned.
  */
-fs_initcall(snp_rmptable_init);
+device_initcall(snp_rmptable_init);
diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index e2857109e966..353d68b25fe2 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -148,6 +148,4 @@ struct dev_table_entry *get_dev_table(struct amd_iommu *iommu);
 
 extern u64 amd_iommu_efr;
 extern u64 amd_iommu_efr2;
-
-extern bool amd_iommu_snp_en;
 #endif
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 1c9924de607a..9e72cd8413bb 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3255,6 +3255,35 @@ static bool __init detect_ivrs(void)
 	return true;
 }
 
+#ifdef CONFIG_KVM_AMD_SEV
+static void iommu_snp_enable(void)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return;
+
+	/*
+	 * The SNP support requires that IOMMU must be enabled, and is
+	 * not configured in the passthrough mode.
+	 */
+	if (no_iommu || iommu_default_passthrough()) {
+		pr_err("SNP: IOMMU is disabled or configured in passthrough mode, SNP cannot be supported");
+		return;
+	}
+
+	amd_iommu_snp_en = check_feature_on_all_iommus(FEATURE_SNP);
+	if (!amd_iommu_snp_en)
+		return;
+
+	pr_info("SNP enabled\n");
+
+	/* Enforce IOMMU v1 pagetable when SNP is enabled. */
+	if (amd_iommu_pgtable != AMD_IOMMU_V1) {
+		pr_warn("Force to using AMD IOMMU v1 page table due to SNP\n");
+		amd_iommu_pgtable = AMD_IOMMU_V1;
+	}
+}
+#endif
+
 /****************************************************************************
  *
  * AMD IOMMU Initialization State Machine
@@ -3290,6 +3319,7 @@ static int __init state_next(void)
 		break;
 	case IOMMU_ENABLED:
 		register_syscore_ops(&amd_iommu_syscore_ops);
+		iommu_snp_enable();
 		ret = amd_iommu_init_pci();
 		init_state = ret ? IOMMU_INIT_ERROR : IOMMU_PCI_INIT;
 		break;
@@ -3802,40 +3832,4 @@ int amd_iommu_pc_set_reg(struct amd_iommu *iommu, u8 bank, u8 cntr, u8 fxn, u64
 	return iommu_pc_get_set_reg(iommu, bank, cntr, fxn, value, true);
 }
 
-#ifdef CONFIG_KVM_AMD_SEV
-int amd_iommu_snp_enable(void)
-{
-	/*
-	 * The SNP support requires that IOMMU must be enabled, and is
-	 * not configured in the passthrough mode.
-	 */
-	if (no_iommu || iommu_default_passthrough()) {
-		pr_err("SNP: IOMMU is disabled or configured in passthrough mode, SNP cannot be supported");
-		return -EINVAL;
-	}
-
-	/*
-	 * Prevent enabling SNP after IOMMU_ENABLED state because this process
-	 * affect how IOMMU driver sets up data structures and configures
-	 * IOMMU hardware.
-	 */
-	if (init_state > IOMMU_ENABLED) {
-		pr_err("SNP: Too late to enable SNP for IOMMU.\n");
-		return -EINVAL;
-	}
-
-	amd_iommu_snp_en = check_feature_on_all_iommus(FEATURE_SNP);
-	if (!amd_iommu_snp_en)
-		return -EINVAL;
-
-	pr_info("SNP enabled\n");
-
-	/* Enforce IOMMU v1 pagetable when SNP is enabled. */
-	if (amd_iommu_pgtable != AMD_IOMMU_V1) {
-		pr_warn("Force to using AMD IOMMU v1 page table due to SNP\n");
-		amd_iommu_pgtable = AMD_IOMMU_V1;
-	}
 
-	return 0;
-}
-#endif

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

