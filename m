Return-Path: <kvm+bounces-5751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A470825C21
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 22:28:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF8D01F2273A
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 21:28:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7A0C2E3E1;
	Fri,  5 Jan 2024 21:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="fzKXy1xy"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4992E225A6;
	Fri,  5 Jan 2024 21:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 2998E40E016C;
	Fri,  5 Jan 2024 21:28:30 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id U_6ilrElvZTJ; Fri,  5 Jan 2024 21:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1704490107; bh=wMp96QnJYgVKjGepckhcJBPd5Px0XtoqLOg4+sLtFFg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fzKXy1xy/auYCMgCgKvhP0tdfu5oMOyhYcxsf1lyiNxWQUuHmyGCwGXLiTBjIiAmL
	 Y3p0YP6b10Ty/jlWXnz51CKkuqQM6RYjO2GWJCF8OPBF8zknpHJk3OivWNvJZW3brP
	 U9TZj0r5TVc/OR6yMsXu0IzFK6LyFsU2aJ52kLbUH7pcUPkInjNUKQAYSjqZhw7s01
	 Y5h4hxQH7OrsofIN3DWJmouWAWDTp6ZrqCzoC9yAGbLD1Hgam2kCUj/hn8Hj9mQT1Q
	 7SNGbnZ5sFnKq2Dx2pirNVfnlMx3+Me5slVtE6xHYDxG9OAyLiTRTF3IBjFsGCZELS
	 5IGJwqlC0lkni1DkwpRn8VOBZ6gYJ5YYQLbD+IfPACQ63YKDEAmNZ3dZgCI0z8aMIe
	 9t3rcSzNZuXqxnLldZu0eqB+hBabF+BtxO7uwEND4txRyVTzgkoEF1gfhxzJ70RVv2
	 Kckcc3C/5t2LpGfj/qnVtAz8eew/OgfiaXXCOiBOnSrFGhlAL9wmfndamKxYNONgKg
	 HR+CAp2zzwmfOxM4HFuf9fmh6Y3lTnmMoGbr8+xE+Nj/JsPIs7UTo8ZE93c+6IpePo
	 q0erZiBiXX2+RFqj3E4QgcP/nPS7rULkzbjKaBnYnrMsDQ+Xn+wSofHUKhEA+eDroK
	 xV/HB2aPCmRMXHB792jfhFqQ=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8C5C840E0177;
	Fri,  5 Jan 2024 21:27:48 +0000 (UTC)
Date: Fri, 5 Jan 2024 22:27:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: Michael Roth <michael.roth@amd.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
	linux-mm@kvack.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
	ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
	rientjes@google.com, tobin@ibm.com, vbabka@suse.cz,
	kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v1 04/26] x86/sev: Add the host SEV-SNP initialization
 support
Message-ID: <20240105212742.GFZZh0TpMZEmah1bBH@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-5-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231230161954.569267-5-michael.roth@amd.com>

On Sat, Dec 30, 2023 at 10:19:32AM -0600, Michael Roth wrote:
> +static int __init __snp_rmptable_init(void)

I already asked a year ago:

https://lore.kernel.org/all/Y9ubi0i4Z750gdMm@zn.tnic/

why is the __ version - __snp_rmptable_init - carved out but crickets.
It simply gets ignored. :-\

So let me do it myself, diff below.

Please add to the next version:

Co-developed-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>

after incorporating all the changes.

Thx.

---
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 566bb6f39665..feed65f80776 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -155,19 +155,25 @@ bool snp_probe_rmptable_info(void)
  * described in the SNP_INIT_EX firmware command description in the SNP
  * firmware ABI spec.
  */
-static int __init __snp_rmptable_init(void)
+static int __init snp_rmptable_init(void)
 {
-	u64 rmptable_size;
 	void *rmptable_start;
+	u64 rmptable_size;
 	u64 val;
 
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return 0;
+
+	if (!amd_iommu_snp_en)
+		return 0;
+
 	if (!probed_rmp_size)
-		return 1;
+		goto nosnp;
 
 	rmptable_start = memremap(probed_rmp_base, probed_rmp_size, MEMREMAP_WB);
 	if (!rmptable_start) {
 		pr_err("Failed to map RMP table\n");
-		return 1;
+		goto nosnp;
 	}
 
 	/*
@@ -195,20 +201,6 @@ static int __init __snp_rmptable_init(void)
 	rmptable = (struct rmpentry *)rmptable_start;
 	rmptable_max_pfn = rmptable_size / sizeof(struct rmpentry) - 1;
 
-	return 0;
-}
-
-static int __init snp_rmptable_init(void)
-{
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
-		return 0;
-
-	if (!amd_iommu_snp_en)
-		return 0;
-
-	if (__snp_rmptable_init())
-		goto nosnp;
-
 	cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "x86/rmptable_init:online", __snp_enable, NULL);
 
 	return 0;

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

