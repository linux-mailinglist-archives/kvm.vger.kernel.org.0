Return-Path: <kvm+bounces-7175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD1A683DD99
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 16:35:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D5872853F0
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 15:35:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2295D1D522;
	Fri, 26 Jan 2024 15:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="e1N5s1Dc"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58301CF94;
	Fri, 26 Jan 2024 15:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706283342; cv=none; b=FHfuZAflJqgguHhf1L9ckFdIkEZ0f7iyafLVLrJvbWxhfdUhcmyzr4sRICYjfzDCvM3+q2VhNcmwnAHB1BJcmCv3S5XabDbWVLnBAR9QWRlrdnpoa13cf36gj8GyYSLgXJCh0kaGtKyFneP+nqbzdFHua6HmcP+zVWocuzKO9DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706283342; c=relaxed/simple;
	bh=Q1gySN7TT9h0jHMhyfEM8IvkE1u4CiHb4/JNQ9iYKDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gDqLZVDlL95K2j1kQ7QZXS6HPks5C5Ar7mgpS7M2rqtB3jcgdOB+vKqeAtQW/ryomY/VPp2R7AcK6x4VPseucOzHgF7E0oAEswLbV0YPwM4KBfp43uZnJ0+GnWlNXh29s9I93p+uT/nDHZMLD+rivGslGysG4lv3D9dGY+wU5ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=e1N5s1Dc; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 01BE740E016C;
	Fri, 26 Jan 2024 15:35:37 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id GaR2USFls6AC; Fri, 26 Jan 2024 15:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1706283334; bh=P7Oe6KlLPTo7Wpl5+l3vTi17r9sFPMt5tYVi1N17yxE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e1N5s1DcEV7OiU5ueEYz3Jxa4whCu+ho0B6R1fOpyyV+Iv+KlFHIhB9EW9cLnU0Ln
	 zva+78aCi2XO9l9jtkUIqqWPS+3xzfiB8Yvlr3S34dn3sIn4gSxL3uyVLrY7J9lDCs
	 NOG1rnlnfuOSQNqMZgr4kbkKNL8i+V9Bo8F3tNfhufb9DnPpUjs+TT5+evf2sGLyjS
	 i8nfDJflpmurujqBU7N92Bc7SpVkczSbBq9xp1xljfk46HlzCivDoZQpeyErkUFZiE
	 94QEUkF118r3VnQlWKugUtvQu7tNF+JUI91yJChdl8ltXa8AR3u6lVp4D/zzuxqgEi
	 MNVoV5Fb1TTudu8Gb/AAX0dl0RW1TPy+Y6xQ1sGbX8O/OvRnWmDheR5aCWKuHfip5g
	 R+LHCSSifjGrgrmVZVypkn+7PxMJFrf3rVJIxOH791SzmggCT9Vt5pj3F2/ZrYTMlb
	 P8WnVnvXwlSt7mvO17dEIZcNtBgKPsf7RG4R062ogzhkZSdu1XAzI+bfRRqJNsRerp
	 cwJKPQZxDWk8SWv+UyMnNO4W5xDrPnuElc8jmGgdFNcZlucu4hVIMuZDyGJTDvjbMO
	 qHa3FNM0namjZivxU/Rj3ymRYCZLeq0P2GGQxYYMsq6f8QFN5HAxtQ1+LASrFWoH55
	 hfiAarXcIepWsdBBMxjYqSU4=
Received: from zn.tnic (pd953033e.dip0.t-ipconnect.de [217.83.3.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2982F40E0196;
	Fri, 26 Jan 2024 15:34:58 +0000 (UTC)
Date: Fri, 26 Jan 2024 16:34:51 +0100
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
	pankaj.gupta@amd.com, liam.merwick@oracle.com
Subject: Re: [PATCH v2 11/25] x86/sev: Adjust directmap to avoid inadvertant
 RMP faults
Message-ID: <20240126153451.GDZbPRG3KxaQik-0aY@fat_crate.local>
References: <20240126041126.1927228-1-michael.roth@amd.com>
 <20240126041126.1927228-12-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240126041126.1927228-12-michael.roth@amd.com>

On Thu, Jan 25, 2024 at 10:11:11PM -0600, Michael Roth wrote:
> +static int adjust_direct_map(u64 pfn, int rmp_level)
> +{
> +	unsigned long vaddr = (unsigned long)pfn_to_kaddr(pfn);
> +	unsigned int level;
> +	int npages, ret;
> +	pte_t *pte;

Again, something I asked the last time but no reply:

Looking at Documentation/arch/x86/x86_64/mm.rst, the direct map starts
at page_offset_base so this here should at least check

	if (vaddr < __PAGE_OFFSET)
		return 0;

I'm not sure about the upper end. Right now, the adjusting should not
happen only for the direct map but also for the whole kernel address
space range because we don't want to cause any mismatch between page
mappings anywhere.

Which means, this function should be called adjust_kernel_map() or so...

Hmmm.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

