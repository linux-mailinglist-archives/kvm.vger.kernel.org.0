Return-Path: <kvm+bounces-69410-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cI6zDEliemlZ5gEAu9opvQ
	(envelope-from <kvm+bounces-69410-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 20:23:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 6702CA8244
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 20:23:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3CCD2300D0C0
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:23:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D1931D5CC9;
	Wed, 28 Jan 2026 19:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="TxXOY99i"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4581A234964;
	Wed, 28 Jan 2026 19:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769628225; cv=none; b=ulRNdtFleFYN69c2pbnE83//ubXzA1t4uhNs0s68yoF6JqQtKMxk7Ys55u2Rzi04X6kPAyvSUr7iH0St19RvPA0OSn1DFbCf3rncuBfK0s9/y7NDJlp7wg1QjmwFLvyWmodrgk3Fxx0eTJc2d/82CCb3mzmiRO5q3LRZOHtH8Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769628225; c=relaxed/simple;
	bh=f918SBpHxU0kmiz8ei8dlKq+2sgT9qBkWx+ZUPqWEK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OEkfj1ees5M880SWpoK+IAj7x6UXTXz6MrXw3Z8IlUyIq6jf5hILoR/cvEjkLhe+hWn0xbJYHo3ni5/nNfwCvDtPA4LW0Di69MOv/ZkFG8YFIj8A96b16ip68YQB+nbbJxWODXzoWwL7GAURTcq+vJpJvOsYLDprcuAypKVOIQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=TxXOY99i; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D54AE40E02E5;
	Wed, 28 Jan 2026 19:23:38 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Q5R-tb0sNnLl; Wed, 28 Jan 2026 19:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1769628213; bh=0iXIJf5ui59avapL1UdeVJxi1X7KHJ85L7Vgo8qNZD4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TxXOY99i/2wGSEz/aFja6eTQWhDAv2bEgEQiA9LDQJHkLLxEu5cD+xxNr6hOFW+Z4
	 b52qBEcNt07Mbov1ecCsy2+HmNMzp4ZGM4xoDubsg1/TK4x6pat6nZaKP0tTTIeqRz
	 tqMQxEp6fyxUgZheF93MUq59dr5lUMXFqhyW0LwDoJ0M321FlZu6LTM9tx1J/bNG/C
	 bAVd422SUez+IUWc/ivhajf/yRALQ3D1xbqU0BYErerpX7Z2hU2wZUEemu70J5YmCU
	 64PUVK+eQmOWkBEVKsx2RTObqF+PInUnWJOKZxmxSjPPG5CFscqt9H/7zWFiyShIyO
	 83YmktlOZ7TRzJx8X5zIdm+zgucVMns9xx3KFe6h+AsFIsPHhCSaQV5tu1YTCQAR9n
	 Q0VjtSkjXlrLBmluvycVJlDI510qbP8eLOcusv+I6iq+FA6Y4131X8yBHZMgxZ56mM
	 Vi4mo08d3ZwZtH/VIbdQlhBxeqIuMVCHlJpfuU90C0i7b+uf7nljOEFQK18hldP0+Z
	 NEm1loTor9rHKRvSKa+hQRYyhqLeLK4T0htkab7BgOeunw9Zt/IbIrEb5Ts61amd/h
	 jSVJowpFtUpgZ+V6ZLlHs5H28W9zft3sBQWL1FWnsD9S1iNy13QLlj2vvuwYbNG0KO
	 T9TCF6nComS2aAG4PLpyT314=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 8889D40E00DA;
	Wed, 28 Jan 2026 19:23:19 +0000 (UTC)
Date: Wed, 28 Jan 2026 20:23:12 +0100
From: Borislav Petkov <bp@alien8.de>
To: Kim Phillips <kim.phillips@amd.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev, x86@kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Naveen Rao <naveen.rao@amd.com>,
	David Kaplan <david.kaplan@amd.com>, stable@kernel.org
Subject: Re: [PATCH 1/2] KVM: SEV: IBPB-on-Entry guest support
Message-ID: <20260128192312.GQaXpiIL4YFmQB2LKL@fat_crate.local>
References: <20260126224205.1442196-1-kim.phillips@amd.com>
 <20260126224205.1442196-2-kim.phillips@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260126224205.1442196-2-kim.phillips@amd.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[alien8.de,none];
	R_DKIM_ALLOW(-0.20)[alien8.de:s=alien8];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69410-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_TRACE(0.00)[alien8.de:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bp@alien8.de,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,alien8.de:email,alien8.de:dkim,fat_crate.local:mid]
X-Rspamd-Queue-Id: 6702CA8244
X-Rspamd-Action: no action

On Mon, Jan 26, 2026 at 04:42:04PM -0600, Kim Phillips wrote:
> The SEV-SNP IBPB-on-Entry feature does not require a guest-side
> implementation. The feature was added in Zen5 h/w, after the first
> SNP Zen implementation, and thus was not accounted for when the
> initial set of SNP features were added to the kernel.
> 
> In its abundant precaution, commit 8c29f0165405 ("x86/sev: Add SEV-SNP
> guest feature negotiation support") included SEV_STATUS' IBPB-on-Entry
> bit as a reserved bit, thereby masking guests from using the feature.
> 
> Unmask the bit, to allow guests to take advantage of the feature on
> hypervisor kernel versions that support it: Amend the SEV_STATUS MSR
> SNP_RESERVED_MASK to exclude bit 23 (IbpbOnEntry).

Do not explain what the patch does.

> Fixes: 8c29f0165405 ("x86/sev: Add SEV-SNP guest feature negotiation support")
> Cc: Nikunj A Dadhania <nikunj@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> CC: Borislav Petkov (AMD) <bp@alien8.de>
> CC: Michael Roth <michael.roth@amd.com>
> Cc: stable@kernel.org

I guess...

> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 4d3566bb1a93..9016a6b00bc7 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -735,7 +735,10 @@
>  #define MSR_AMD64_SNP_SMT_PROT		BIT_ULL(MSR_AMD64_SNP_SMT_PROT_BIT)
>  #define MSR_AMD64_SNP_SECURE_AVIC_BIT	18
>  #define MSR_AMD64_SNP_SECURE_AVIC	BIT_ULL(MSR_AMD64_SNP_SECURE_AVIC_BIT)
> -#define MSR_AMD64_SNP_RESV_BIT		19
> +#define MSR_AMD64_SNP_RESERVED_BITS19_22 GENMASK_ULL(22, 19)
> +#define MSR_AMD64_SNP_IBPB_ON_ENTRY_BIT	23
> +#define MSR_AMD64_SNP_IBPB_ON_ENTRY	BIT_ULL(MSR_AMD64_SNP_IBPB_ON_ENTRY_BIT)

Why isn't this part of SNP_FEATURES_PRESENT?

If this feature doesn't require guest-side support, then it is trivially
present, no?

> +#define MSR_AMD64_SNP_RESV_BIT		24
>  #define MSR_AMD64_SNP_RESERVED_MASK	GENMASK_ULL(63, MSR_AMD64_SNP_RESV_BIT)
>  #define MSR_AMD64_SAVIC_CONTROL		0xc0010138
>  #define MSR_AMD64_SAVIC_EN_BIT		0
> -- 

I guess this is a fix of sorts and I could take it in now once all review
comments have been addressed...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

