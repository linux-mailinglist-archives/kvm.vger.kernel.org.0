Return-Path: <kvm+bounces-5744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA95C825B08
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 20:20:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7959128573F
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 19:20:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2E6D35F18;
	Fri,  5 Jan 2024 19:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="aB0j7KDK"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2119735EFF;
	Fri,  5 Jan 2024 19:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4CE2040E0196;
	Fri,  5 Jan 2024 19:20:09 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 0HqsHS1C0SBX; Fri,  5 Jan 2024 19:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1704482406; bh=/a0UKaTZTMHEDAeTcb9/TUYxxz2I8dAfWxoQjcoX6lk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aB0j7KDKQj5CmPpTDfG8fpfAgLxkhkEPYfftoiRN375Q2eqjmbXSZoLvE1rkW77ur
	 PBB7Bhkm7hV1hQ5zqE7y3eiSezd+C2GUrHWdxLKpJpHpKDRTaCVdwrUyJBicvK7y8b
	 n4xfyrSeqlVW7GPisHaI/41JrTno/0pm91uwlQfYucfSvFu3lIcoHt0v19OfT2Bpk7
	 6gCCZP0zsZRj0YxlIHFJtx2RHMUgIT7eEb0Bm/RzsR5NE03ncesHWgxCtBXEXDZOI2
	 CgnqiDwNGwZk8xiO+nVW+VLrYMh72Ol3PSuzDEjl26zuhx8gqXscQJGNHR8BIpe82d
	 fpJj5Fkn//3ajL6hD+dFCKilsF+JYuFLqu9nI6qEAmio/sCcjgB8foNEgyRkjCJlEk
	 +GT0bLOv49gpGqT3M3tji45NaKScH5oEnYcAC9+6CGNnz1P9JSThezuZuoL4qINjn8
	 qaUKvknOiIm8IfGkVPGmohdF4wyw8rwWoEq/dvhO84tm3vYhb12ACwTiqUX+/959h5
	 h26Lgcl/UzvbK3ECtWX85yXyO1KjvTWvCQqJMeV9MetLGDerh1p2AKYryaJb1hCY2C
	 o1VJqEql+2MuC/k6EYSHlWU/sx+3wxccHJ3FwwEYYtMGqQwcO7gv59LDp4dCIlNMub
	 AFpDI4YqDo5B71rG79b35ceM=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 49A5040E00C5;
	Fri,  5 Jan 2024 19:19:28 +0000 (UTC)
Date: Fri, 5 Jan 2024 20:19:21 +0100
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
Message-ID: <20240105191921.GHZZhWObgbgXxP/kkB@fat_crate.local>
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
> +{
> +	u64 rmptable_size;
> +	void *rmptable_start;
> +	u64 val;

...

Ontop:

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index ce7ede9065ed..566bb6f39665 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -150,6 +150,11 @@ bool snp_probe_rmptable_info(void)
 	return true;
 }
 
+/*
+ * Do the necessary preparations which are verified by the firmware as
+ * described in the SNP_INIT_EX firmware command description in the SNP
+ * firmware ABI spec.
+ */
 static int __init __snp_rmptable_init(void)
 {
 	u64 rmptable_size;

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

