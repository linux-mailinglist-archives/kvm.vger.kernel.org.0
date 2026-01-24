Return-Path: <kvm+bounces-69050-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WKF9H+gedWkaBAEAu9opvQ
	(envelope-from <kvm+bounces-69050-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 20:35:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D59AF7EBBF
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 20:35:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 42D1C3009FAF
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 19:34:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0563B2749CF;
	Sat, 24 Jan 2026 19:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="VKr5FWU7"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D52F7262E;
	Sat, 24 Jan 2026 19:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769283289; cv=none; b=J5vH9VXzFqnG39dK8p9tkzCOYx7PgO4yQSjJl+IOhSxVO1fGBclL4J+40mYUpZ8Ho6GDNNjgZ2lo9K3PQMSpOr9Od9UO/WiaMVfyGB5gMPNCzmSdlnjAmFGp0G9579ETyNXoC7sZkA+MjCNlWuzKDoFF1C1l8io4SD054qoOIfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769283289; c=relaxed/simple;
	bh=vZj/2QNWPcSMEmMSLXoIU+mhiBgGVY/73rLVhVRWtuc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A5XmHoKVNFJf1Y70nGumyJD724eQU5XbqyENqzRQ6e9Ngin4LQQaWU5WWFsopaafl8TaYMYfdUoWAfbPylBuAZjpnPBKowU1D/9y4xkQcJvBU3/AJukeDnfNAJYQzpF0gRV3VcwgrmkV/xR34skRjTevTG9wX5v8v5F76hV60+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=VKr5FWU7; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 43E4740E0252;
	Sat, 24 Jan 2026 19:34:44 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id MFTyvTON76Os; Sat, 24 Jan 2026 19:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1769283279; bh=a2LO5HHDovr4e2kg9MSvm8KJYnhsMThIzQhhsi/XfP4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VKr5FWU7ULimDzeTAVorifxC32IZgkN7j8FT0r3Qr/iiHMp7zEh8AozHhG3KfvpHW
	 PCGCpjOzYt18BALsQEQvreUxaRlkeLvpJxwK4w6hPeDypWq4yHRNiHBbDM3MHFA/yT
	 SbxHa8U+Rg5GTA6G8xU/oHPTUNQcxjzU92260m/rB1vP1zkv7I7hntXbm2UINmGrzO
	 jx/4ooi2X/BP+DU+yAwLjcIE8bH5zV8Yqu9qkfdTVTjz1j3ZkJmMiMaH3Spc1h8JbX
	 iGf42pk3Y8rjj9YaOv4KLKbSpZROiTqKvggKPw6Zgfl/GtNjvYq/kw+MiUPPsbAKNn
	 efCdxOQGYIUhsFfOw7fdGG7I0DIP7mJlHtq9VzYkG1Ot+jAT/cQT5yCId6Ws7hcZLn
	 6PtQZjS5E4lvdlJybyuwnNVIfqs5WSzgyIvajBi4gzk1hnbzcv5hDGV/YkTerr9Jhu
	 qdY6x3r6L8GpAgyjUCNvLwSapuDv29FOQYZx0Ghv26n1GGDnrhfTmaFGxS9glCqXjW
	 Bw9ZKzaJfhf5M2ZQT3UwXy1FZ1XPK/PzjAu2IOJ1YJqE6EHXmGPRlFi8eHlNpnlwl9
	 HXXs0KPJjk8GZT+UfmAFnTPbXDCXYzDZnuO51rQ+IYrNWSiywEGg1FCiNMaBkdT+Ng
	 vW5KTV1c7VtlVaEzn2ZDR9RA=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 2DA8C40E0219;
	Sat, 24 Jan 2026 19:34:26 +0000 (UTC)
Date: Sat, 24 Jan 2026 20:34:18 +0100
From: Borislav Petkov <bp@alien8.de>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: x86@kernel.org, David Kaplan <david.kaplan@amd.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: Re: [PATCH v6 2/9] x86/bhi: Make clear_bhb_loop() effective on newer
 CPUs
Message-ID: <20260124193418.GGaXUeulAxLp1QwVpM@fat_crate.local>
References: <20251201-vmscape-bhb-v6-0-d610dd515714@linux.intel.com>
 <20251201-vmscape-bhb-v6-2-d610dd515714@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251201-vmscape-bhb-v6-2-d610dd515714@linux.intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[alien8.de,none];
	R_DKIM_ALLOW(-0.20)[alien8.de:s=alien8];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69050-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[alien8.de:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bp@alien8.de,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D59AF7EBBF
X-Rspamd-Action: no action

On Mon, Dec 01, 2025 at 10:19:14PM -0800, Pawan Gupta wrote:
> diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> index 886f86790b4467347031bc27d3d761d5cc286da1..9f6f4a7c5baf1fe4e3ab18b11e25e2fbcc77489d 100644
> --- a/arch/x86/entry/entry_64.S
> +++ b/arch/x86/entry/entry_64.S
> @@ -1536,7 +1536,11 @@ SYM_FUNC_START(clear_bhb_loop)
>  	ANNOTATE_NOENDBR
>  	push	%rbp
>  	mov	%rsp, %rbp
> -	movl	$5, %ecx
> +
> +	/* loop count differs based on BHI_CTRL, see Intel's BHI guidance */
> +	ALTERNATIVE "movl $5,  %ecx; movl $5, %edx",	\
> +		    "movl $12, %ecx; movl $7, %edx", X86_FEATURE_BHI_CTRL

Why isn't this written like this:

in C:

clear_bhb_loop:

	if (cpu_feature_enabled(X86_FEATURE_BHI_CTRL))
		__clear_bhb_loop(12, 7);
	else
		__clear_bhb_loop(5, 5);

and then the __-version is asm and it gets those two arguments from %rdi, and
%rsi instead of more hard-coded, error-prone registers diddling alternative
gunk?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

