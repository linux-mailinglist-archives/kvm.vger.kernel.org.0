Return-Path: <kvm+bounces-5730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C6D9825800
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 17:22:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C8311C23339
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 16:22:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 414D13174E;
	Fri,  5 Jan 2024 16:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="B5hW1EV9"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92D4328A7;
	Fri,  5 Jan 2024 16:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id C73DD40E016C;
	Fri,  5 Jan 2024 16:22:28 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 84HtEWuwaCZG; Fri,  5 Jan 2024 16:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1704471746; bh=j+eM5pN/ZJjguSTXrDo3g1D8mHy8zmaIa7AEsjD59Ss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B5hW1EV9vq5JsAI+1K8hZ+f2YqJiyOSKPbVarcMMiw8kX2ro9XqQCODVg4iFe/8fD
	 NbSSivZTtrQT8C7BxFa1r+3wg7vnBfocNEP25TIBX6PPQIUjouhNkLFt5qQDLDZQF3
	 GcrStKGHX+9V3L+8K+veTdS3iX3KgBDOqKjRijz3eaZFMPKLWD5I3S/nUEc7FUtMua
	 OxSJc7LIquZzRfl25m1BfXTbp/+b6CCNX49o01v4+//tf4vZavCs52zR6GK+KOBk1M
	 CMmrYtfB9tmVTYO3ZQfTtEy4GGBumFGc9Ii8TlDcXSOyqbfvndPOB2owY7i6nBe5zb
	 q61eALCQgj6osq0Ey2wjgA75scGAlI46jHRjhfi+3Eml/OR3RND0+0N3t9Koohpr97
	 9b3/yw4hn53CarYV5+2qqXyM14tD7rKlN/IcrMjh55wgT6dN/lJSiUvaXL5B9NMbf+
	 JE3TFAEv3LTJMUaOk4vn/2+DMTrWYpMrgHUwVnC5kLreh3vS5P+EnlK8X0YeFz7mfM
	 MapqpvHY/m07UOKex0RizLW2ykAOU0jdTwauka14ssguCs8KKAs75iH6KxiIHAF2wV
	 ggQIii0tmodflsN7YB/D/WWv8Ci3WR46LazY5XuNEajUAbiv/GEmC6XEodW4IEugwu
	 vYB5DRcBjVXm4N99CMbdoLkc=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 08D6A40E00C5;
	Fri,  5 Jan 2024 16:21:47 +0000 (UTC)
Date: Fri, 5 Jan 2024 17:21:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc: Michael Roth <michael.roth@amd.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
	pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
	jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
	slp@redhat.com, pgonda@google.com, peterz@infradead.org,
	srinivas.pandruvada@linux.intel.com, rientjes@google.com,
	tobin@ibm.com, vbabka@suse.cz, kirill@shutemov.name,
	ak@linux.intel.com, tony.luck@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v1 04/26] x86/sev: Add the host SEV-SNP initialization
 support
Message-ID: <20240105162142.GEZZgslgQCQYI7twat@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-5-michael.roth@amd.com>
 <f60c5fe0-9909-468d-8160-34d5bae39305@linux.microsoft.com>
 <20240105160916.GDZZgprE8T6xbbHJ9E@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240105160916.GDZZgprE8T6xbbHJ9E@fat_crate.local>

On Fri, Jan 05, 2024 at 05:09:16PM +0100, Borislav Petkov wrote:
> On Thu, Jan 04, 2024 at 12:05:27PM +0100, Jeremi Piotrowski wrote:
> > Is there a really good reason to perform the snp_probe_smptable_info() check at this
> > point (instead of in snp_rmptable_init). snp_rmptable_init will also clear the cap
> > on failure, and bsp_init_amd() runs too early to allow for the kernel to allocate the
> > rmptable itself. I pointed out in the previous review that kernel allocation of rmptable
> > is necessary in SNP-host capable VMs in Azure.
> 
> What does that even mean?
> 
> That function is doing some calculations after reading two MSRs. What
> can possibly go wrong?!

That could be one reason perhaps:

"It needs to be called early enough to allow for AutoIBRS to not be disabled
just because SNP is supported. By calling it where it is currently called, the
SNP feature can be cleared if, even though supported, SNP can't be used,
allowing AutoIBRS to be used as a more performant Spectre mitigation."

https://lore.kernel.org/r/8ec38db1-5ccf-4684-bc0d-d48579ebf0d0@amd.com

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

