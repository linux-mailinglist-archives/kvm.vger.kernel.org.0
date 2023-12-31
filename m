Return-Path: <kvm+bounces-5409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BF2B820B51
	for <lists+kvm@lfdr.de>; Sun, 31 Dec 2023 12:51:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C501E1C2144A
	for <lists+kvm@lfdr.de>; Sun, 31 Dec 2023 11:51:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 234E0568B;
	Sun, 31 Dec 2023 11:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="cl9kUDyW"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024D54415;
	Sun, 31 Dec 2023 11:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 49E0540E016E;
	Sun, 31 Dec 2023 11:51:01 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 4eg0_SLg_kXx; Sun, 31 Dec 2023 11:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1704023458; bh=rshc7RO4qeTYeDFjVLydvwS1x2ZSFRCAo8/CN5Dns6c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cl9kUDyWnKHtQdd3kIozQ9uHF3eWNBAkA9wIgKNRIu7FMlBgTYVYC8j3eLDIc1+Bp
	 hkCM/Nd7vdnc1b+zGVWwr43REhIvmABVHseMEcIDn96Gx7LzqRXuybrYhAPiUWP5sC
	 Y+JS+4LXvxMsCuf0ZcgEBL4kezJ21Q5JQPftrjJ7263+bAT8WydTNUI14eWvOQUoa7
	 MuR75H5YqKM/aJUMfhpWTNPKtLamIY3o/qMzhEYVBnetBqfMFoLFuqtAMdAJ7Qm4xF
	 gDLIwz6WbJhe2mZ+JdJKrKDpUYNZzAotH/h/jJrAEbfNpKlINtQVMX6dLN+TaGh821
	 L4OAMbOrvvamJrpu7L6HRKkgyktN3uVI9DQeiPnHvDo5oIXW2pxRfgkd2wu4og8eOw
	 XbTSlD3s8+Qgux9YzBYAAuo5MGTkXznhDF6wrO0oI4fN3Cx42URjZxtEG4BYS26kcb
	 FsESawR83FkYNekXbGrwE6ZyGKbm/n+82GK36oZAZLn5vwZcDFw6etAKx0K8ZpHzOi
	 cwjrNNoC0yFFF7VaZjIcsogfnSxgwjbOlvBHIqhRXr0+Q9thC5IdKR3jqal48lWgWP
	 awEOLCZO8cBJ62WGwyz1cZ4+0yOfOkwBMR8MWUkqUW1jPDOP0VpS/nWzvsh8Hh5/dM
	 hi7IT3zlZSgFvThJFDwVQDTw=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BA2A040E00C7;
	Sun, 31 Dec 2023 11:50:18 +0000 (UTC)
Date: Sun, 31 Dec 2023 12:50:12 +0100
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
	Brijesh Singh <brijesh.singh@amd.com>,
	Jarkko Sakkinen <jarkko@profian.com>
Subject: Re: [PATCH v1 01/26] x86/cpufeatures: Add SEV-SNP CPU feature
Message-ID: <20231231115012.GAZZFVdHCWijp7yFls@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-2-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231230161954.569267-2-michael.roth@amd.com>

On Sat, Dec 30, 2023 at 10:19:29AM -0600, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> Add CPU feature detection for Secure Encrypted Virtualization with
> Secure Nested Paging. This feature adds a strong memory integrity
> protection to help prevent malicious hypervisor-based attacks like
> data replay, memory re-mapping, and more.
> 
> Since enabling the SNP CPU feature imposes a number of additional
> requirements on host initialization and handling legacy firmware APIs
> for SEV/SEV-ES guests, only introduce the CPU feature bit so that the
> relevant handling can be added, but leave it disabled via a
> disabled-features mask.
> 
> Once all the necessary changes needed to maintain legacy SEV/SEV-ES
> support are introduced in subsequent patches, the SNP feature bit will
> be unmasked/enabled.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
> Signed-off-by: Ashish Kalra <Ashish.Kalra@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/include/asm/cpufeatures.h       | 1 +
>  arch/x86/include/asm/disabled-features.h | 4 +++-
>  arch/x86/kernel/cpu/amd.c                | 5 +++--
>  tools/arch/x86/include/asm/cpufeatures.h | 1 +
>  4 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 29cb275a219d..9492dcad560d 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -442,6 +442,7 @@
>  #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
>  #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
>  #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
> +#define X86_FEATURE_SEV_SNP		(19*32+ 4) /* AMD Secure Encrypted Virtualization - Secure Nested Paging */
>  #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
>  #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
>  #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* AMD SEV-ES full debug state swap support */
> diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
> index 702d93fdd10e..a864a5b208fa 100644
> --- a/arch/x86/include/asm/disabled-features.h
> +++ b/arch/x86/include/asm/disabled-features.h
> @@ -117,6 +117,8 @@
>  #define DISABLE_IBT	(1 << (X86_FEATURE_IBT & 31))
>  #endif
>  
> +#define DISABLE_SEV_SNP		0

I think you want this here if SEV_SNP should be initially disabled:

diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index a864a5b208fa..5b2fab8ad262 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -117,7 +117,7 @@
 #define DISABLE_IBT	(1 << (X86_FEATURE_IBT & 31))
 #endif
 
-#define DISABLE_SEV_SNP		0
+#define DISABLE_SEV_SNP	(1 << (X86_FEATURE_SEV_SNP & 31))
 
 /*
  * Make sure to add features to the correct mask

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

