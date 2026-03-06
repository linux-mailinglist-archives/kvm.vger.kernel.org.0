Return-Path: <kvm+bounces-73079-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4C+WIuDxqmncYwEAu9opvQ
	(envelope-from <kvm+bounces-73079-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 16:25:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 21DE5223BDB
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 16:25:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 98D5730A9A98
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 15:19:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B170D35EDBD;
	Fri,  6 Mar 2026 15:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="OMx32v+z"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2DC35E93E;
	Fri,  6 Mar 2026 15:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772810382; cv=none; b=U0TI5iQhDJ9mw1PIOmyvHXrXDqIWNz3ZrsLNll+uOTfizFoUXMrwjZ2OHzBingH2kFmyTJJkmQHs95RjPBiJRWa/h+Njgj3HO2KOWwANXJmJQMFWxfXD6zqS1kmdPP9LaExlK4FoGOnWCAwaqtLf3n9455EaI9sqX2XJmE38efQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772810382; c=relaxed/simple;
	bh=v3LKzXkodj+l36OKp4RxCqnK9t1FiiIFsZZAQCR36zY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZxEbtfazt8g7PaX4NceA+nwP+rx8ipwgroWvZNapj7BIz7COPgWy9i26ZZPamatm57MDrdsckvus+5yIPKhLDQDXFh6rGZjh8rqMpVsp5Qhre0/t4D1xNprLrZ3vB35AOzRah5r+a1DI1D7npmqDyCiidm3milse7r61ZkEBX6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=OMx32v+z; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 3D96E40E00DA;
	Fri,  6 Mar 2026 15:19:38 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id b9Ab6cX9k1Fv; Fri,  6 Mar 2026 15:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1772810369; bh=W5O495qAOhtPn0LOsows19z8Qw78XamX4AmZRX7hjBs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OMx32v+zrjQfoYchuF3hG1CNfGktt9l7c0T4vOVOC8fPuSZ/LmsoX62THQBws8Mqt
	 XR63izvAzOiGJy4IE0xwD7kS+PG4f6feoNsi18mGIiof4LXfzjpyUWVIObzfF8A1zs
	 RkPlYf8rUfcPor1KYFZ8ylz/UvxKE5+183u6feaA3ZbqzWh3nf7j2vAD5EpIIphh8S
	 X5ciZWmZZLFd8r2RsQCtifjvsRHa7rIt6WHb4TyfBcJJFa3gSCM8zKoQ/sVdB92iLa
	 w0iJcj5n7Zcdg0LKMwmxGt336rF9mwwkdDu6/UUBh/BktNEJa5B0qQIalaYzKAnmR+
	 5PZ7Llz66EOywXQOiUu2XoYq64/tovlq3xoIKg6vBMjwO+D32p6IU2Ll+4BsuR0aSc
	 nq38JZ2fMWruACgSABQUCQB7Jycc1unRTulk66EymGMMADNMheJCTgQt0PFuND2Y+d
	 95NxkQsdyPWeYFI51pvkElDJpUbZ5TtCsaJ+EYnnakZbcR42wTsFdXa4yw3jGASN7D
	 UxiwJ/tfyTZSkcdGbbsrE8cd9XTa5KRkXZx9guFdyuKtrvj9TuVlyJ2C0LIYlt1Ovl
	 POfz326u/KgkKuw39pR2ETnYa65xyMEB0n7oIix2tko3P8nn6GNkMUNZKssKdSduyR
	 V7SznCDyP3y0PBliniu/+lYw=
Received: from zn.tnic (pd9530d5e.dip0.t-ipconnect.de [217.83.13.94])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 450F240E00DE;
	Fri,  6 Mar 2026 15:18:56 +0000 (UTC)
Date: Fri, 6 Mar 2026 16:18:49 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, seanjc@google.com,
	peterz@infradead.org, thomas.lendacky@amd.com,
	herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org,
	pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
	KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com,
	Nathan.Fontenot@amd.com, jackyli@google.com, pgonda@google.com,
	rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
	pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
	dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
	darwi@linutronix.de, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev
Subject: Re: [PATCH v2 2/7] x86/sev: add support for enabling RMPOPT
Message-ID: <20260306151849.GJaarwWSaWnnRh9ffB@fat_crate.local>
References: <cover.1772486459.git.ashish.kalra@amd.com>
 <85aec55af41957678d214e9629eb6249b064fa87.1772486459.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <85aec55af41957678d214e9629eb6249b064fa87.1772486459.git.ashish.kalra@amd.com>
X-Rspamd-Queue-Id: 21DE5223BDB
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[alien8.de,none];
	R_DKIM_ALLOW(-0.20)[alien8.de:s=alien8];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73079-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[33];
	DKIM_TRACE(0.00)[alien8.de:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bp@alien8.de,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.994];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,fat_crate.local:mid]
X-Rspamd-Action: no action

On Mon, Mar 02, 2026 at 09:35:55PM +0000, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> The new RMPOPT instruction sets bits in a per-CPU RMPOPT table, which
> indicates whether specific 1GB physical memory regions contain SEV-SNP

"... which indicate... "

> guest memory.
> 
> Per-CPU RMPOPT tables support at most 2 TB of addressable memory for
> RMP optimizations.
> 
> Initialize the per-CPU RMPOPT table base to the starting physical
> address. This enables RMP optimization for up to 2 TB of system RAM on
> all CPUs.

...

> +static void __configure_rmpopt(void *val)
> +{
> +	u64 rmpopt_base = ((u64)val & PUD_MASK) | MSR_AMD64_RMPOPT_ENABLE;
> +
> +	wrmsrq(MSR_AMD64_RMPOPT_BASE, rmpopt_base);
> +}
> +
> +static __init void configure_and_enable_rmpopt(void)

If the sub-helper is called __configure_rmpopt() then this should be called
"configure_rmpopt", without the prepended underscores.

> +	phys_addr_t pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), PUD_SIZE);
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT)) {
> +		pr_debug("RMPOPT not supported on this platform\n");
> +		return;
> +	}
> +
> +	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP)) {
> +		pr_debug("RMPOPT optimizations not enabled as SNP support is not enabled\n");
> +		return;
> +	}

Zap this one - snp_rmptable_init() already checked it.

Also, zap those pr_debugs - you have that information elsewhere already.

> +
> +	if (!(rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)) {

You can't test this one - you need to test the result of
setup_segmented_rmptable() and whether it did set up the segmented RMP
properly. Only then you can continue here.

> +		pr_info("RMPOPT optimizations not enabled, segmented RMP required\n");

This looks like pr_notice() to me.

> +		return;
> +	}

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

