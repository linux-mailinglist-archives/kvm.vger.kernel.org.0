Return-Path: <kvm+bounces-1136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CB417E5040
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 07:15:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 163E7281410
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 06:15:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF6C7D268;
	Wed,  8 Nov 2023 06:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="IUXL2eqk"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB305CA70;
	Wed,  8 Nov 2023 06:15:05 +0000 (UTC)
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2397FD41;
	Tue,  7 Nov 2023 22:15:05 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 544A240E01AA;
	Wed,  8 Nov 2023 06:15:02 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id EHip46odZLin; Wed,  8 Nov 2023 06:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1699424099; bh=Siw88j4EN9rm3CCkm9p9kBj7DtmN6TqUD8LWLvzmcHw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IUXL2eqk5iLpWnofHuVYCsP6OCPH/V28fpddsfAb1c80YKs4+RqnST/ctXMB+LDRV
	 U7+qji0J1fuqA6tKsG2M6v716OrADMZPIAq1BRaI6qT4sycj6JuLU8m36R2DGMVFKO
	 mUwDg1kOt6pFcSoG7armcB4E7RNcE4K7qxrnIQzfqD46dRfPYkdPu1eiKCzD9Ky2sY
	 tMm9AqRCnBlw6mVVL48rRg3HEM3dM+KssgEJ5sYV9Z7b3d9fyVg4+AusCxTs/wb54b
	 bOyvODvw7C1CIGk8ZO3Rhn7/eyk3IMdtf2JtQtLaF4ExnhEizRrChjG6sPgudGPn+B
	 JzidoulbJu60FTJfRqNgAdNCYgl3Pqguk/tKWjdnwRf1NfEfKXkk/qh69Bcwr50/QJ
	 dickcZ2iV1b4J/TskV2N4ne4jPBWPGJSWkZGq4LdPlYS/11VmkkySj9Y0kLF6F7EQZ
	 OCQIT5lXqmwhRFg1iDeev1s8oH56rmw68ft3k+5kSmwtyuz64DjhD8lld0DNMqdtnN
	 8QArxkMPMKTDT8PEuMhAHhFqyV5XGB10heb5B4VDJrjWb57AnINBp8n0PZHuERbWzl
	 M0hg+46dZ44U8KcNNwqw4OgKxla8lzhR86yKCpqV1ku9qkzZY2UpHkPY5zCBfF+A5/
	 /3q8YGTcgTjG23Z2bCwe9PPU=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D946840E014B;
	Wed,  8 Nov 2023 06:14:18 +0000 (UTC)
Date: Wed, 8 Nov 2023 07:14:13 +0100
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
Message-ID: <20231108061413.GAZUsnNVcmYZNMw2Kr@fat_crate.local>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-7-michael.roth@amd.com>
 <20231107163142.GAZUpmbt/i3himIf+E@fat_crate.local>
 <4a2016d6-dc1f-ff68-9827-0b72b7c8eac2@amd.com>
 <20231107191931.GCZUqNwxP8JcSbjZ0/@fat_crate.local>
 <20231107202757.GEZUqdzYyzVBHTBhZX@fat_crate.local>
 <250f5513-91c0-d0b5-cb59-439e26ba16dc@amd.com>
 <20231107212740.GFZUqrzK7yzy41dRKp@fat_crate.local>
 <20231107220852.GGZUq1dHJ2q9LYV2oG@fat_crate.local>
 <4b68fd05-5d21-0472-42c3-6cf6f1f9f967@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4b68fd05-5d21-0472-42c3-6cf6f1f9f967@amd.com>

On Tue, Nov 07, 2023 at 04:33:41PM -0600, Kalra, Ashish wrote:
> We will still need some method to tell the IOMMU driver if SNP
> support/feature is disabled by this function, for example, when CPU family
> and model is not supported by SNP and we jump to no_snp label.

See below.

> The reliable way for this to work is to ensure snp_rmptable_init() is called
> before IOMMU initialization and then IOMMU initialization depends on SNP
> feature flag setup by snp_rmptable_init() to enable SNP support on IOMMU or
> not.

Yes, this whole SNP initialization needs to be reworked and split this
way:

- early detection work which needs to be done once goes to
  bsp_init_amd(): that's basically your early_detect_mem_encrypt() stuff
  which needs to happen exactly only once and early.

- Any work like:

	 c->x86_phys_bits -= (cpuid_ebx(0x8000001f) >> 6) & 0x3f;

  and the like which needs to happen on each AP, gets put in a function
  which gets called by init_amd().

By the time IOMMU gets to init, you already know whether it should
enable SNP and check X86_FEATURE_SEV_SNP.

Finally, you call __snp_rmptable_init() which does the *per-CPU* init
work which is still pending.

Ok?

Ontop of the previous ontop patch:

---
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 6cc2074fcea3..a9c95e5d6b06 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -674,8 +674,19 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
 		if (!(msr & MSR_K7_HWCR_SMMLOCK))
 			goto clear_sev;
 
-		if (cpu_has(c, X86_FEATURE_SEV_SNP) && !early_rmptable_check())
-			goto clear_snp;
+		if (cpu_has(c, X86_FEATURE_SEV_SNP)) {
+			/*
+			 * RMP table entry format is not architectural and it can vary by processor
+			 * and is defined by the per-processor PPR. Restrict SNP support on the known
+			 * CPU model and family for which the RMP table entry format is currently
+			 * defined for.
+			 */
+			if (c->x86 != 0x19 || c->x86_model > 0xaf)
+				goto clear_snp;
+
+			if (!early_rmptable_check())
+				goto clear_snp;
+		}
 
 		return;
 
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 9237c327ad6d..5a71df9ae4cb 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -199,14 +199,6 @@ static int __init snp_rmptable_init(void)
 	if (!amd_iommu_snp_en)
 		return 0;
 
-	/*
-	 * RMP table entry format is not architectural and it can vary by processor and
-	 * is defined by the per-processor PPR. Restrict SNP support on the known CPU
-	 * model and family for which the RMP table entry format is currently defined for.
-	 */
-	if (boot_cpu_data.x86 != 0x19 || boot_cpu_data.x86_model > 0xaf)
-		goto nosnp;
-
 	if (__snp_rmptable_init())
 		goto nosnp;
 
-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

