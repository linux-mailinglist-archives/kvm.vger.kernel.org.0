Return-Path: <kvm+bounces-72282-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qA9IGSYeo2mC9wQAu9opvQ
	(envelope-from <kvm+bounces-72282-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 17:56:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E7BC61C482A
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 17:56:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A9F80308F622
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 16:55:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73F3930ACF6;
	Sat, 28 Feb 2026 16:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="c3qlUlfS"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2527C2DCF67;
	Sat, 28 Feb 2026 16:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772297744; cv=none; b=ZMQfNujj+MYaIChcI/LMVpgPp+oEM+dS91MtXFAUMbU+hbpMi2UsbnL4eeXGc2DjaR9R3nMdym8jD1g8iJySPzpmcDbOSsjAeSNd6BaYfLd4IW5Wse1YhKCqR+FIH6VfZW8N9Rm8MaIvGis2uh43EQPry4B5bni2EDNV2psKsQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772297744; c=relaxed/simple;
	bh=pJWgYLvx/o28zleZ5wc8tQ2bKZ3nRyj8rgBcxupaMPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kupAWmYgk26KFh/dxiwBeT05uKLY31M2UmOIJoUJA7Ve/tST9UunLlD2z7nzL/uMQlbx9hSL+e3WZ9mygpvMSfMVrDcc4cTzPlBf2Au86d7LzsvbUPL5c3tsyBtgA37QbBgKuIvarCqLu4/JsZHlrTTsBUvBc4myhxx3z6MZBMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=c3qlUlfS; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5029240E0140;
	Sat, 28 Feb 2026 16:55:33 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id aYl68t990iRQ; Sat, 28 Feb 2026 16:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1772297728; bh=LgzTOolTZA+TA6G3THdvY3XWd7GGtR72T44606Tonfo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c3qlUlfS40Ds+Zh17b7flDIdQ9irw2eVV8GBVAlQsk2n0C+2H+rSMPGpYPm9vlw9E
	 Fw+gTxXC/r1S8Y1t/zTQLmP5NoeS0q94TEOK0Bu2ti7AKAcCqpUlWZiJPjwY+JQj/9
	 t9Mro/wvlCXn+r7FSqXzpJlgaCNZCKfQ3f99A39uH3cRuhhQj3rFr+cuGPU9Xytm/P
	 zpVTtxWPQcpEvoZrw7P1kF4WrNWMrSEnzYwHSopf9r/RNryhCce+89OcsDJi7vJ0rM
	 LyPIYoZPHhKvJJS6ChuwG3fmetqPxh5zizeGUCPvq3FNTcpfZp3uZVEWKhToYOjSL6
	 CeYijPAG3hbb8cV2kneqk6k0CJcAbI0bfqNij7KA00DPhsscZFGUJk633+h6qs2K6a
	 Iktg4VwXYx09XGvCl0HSu+Mr7cT/4oawRx9EZGdTQguF7kpj7PawdwH4IUOIVXksdI
	 oo/OpkSsIWFbR8+n4bF4kWngste8yYU2hnphrM3MlhKxhjxW/S/ludzh/3wXb42tQU
	 smfeJTGh89+1HXiZd88Dygh7SLQh5NC7Q4EWAOEOiGKKUlFFbWLW3USrFZ4ysrmuH8
	 ASVXPjUmtf/10OZ+fmK1QhZyXZnFFlbQn1KLWPZg8XMM1eU/eNHmUAa6iUvR2x3vig
	 dYAyehqK3tsCkHeptp+f/2dE=
Received: from zn.tnic (pd9530d5e.dip0.t-ipconnect.de [217.83.13.94])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 8D6C140E00DA;
	Sat, 28 Feb 2026 16:55:15 +0000 (UTC)
Date: Sat, 28 Feb 2026 17:55:06 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Kim Phillips <kim.phillips@amd.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev, x86@kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Naveen Rao <naveen.rao@amd.com>,
	David Kaplan <david.kaplan@amd.com>
Subject: Re: [PATCH v2 2/3] KVM: SEV: Add support for IBPB-on-Entry
Message-ID: <20260228165506.GAaaMd6nQ56E7i5Cqg@fat_crate.local>
References: <20260203222405.4065706-1-kim.phillips@amd.com>
 <20260203222405.4065706-3-kim.phillips@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260203222405.4065706-3-kim.phillips@amd.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[alien8.de,none];
	R_DKIM_ALLOW(-0.20)[alien8.de:s=alien8];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72282-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,fat_crate.local:mid,alien8.de:dkim]
X-Rspamd-Queue-Id: E7BC61C482A
X-Rspamd-Action: no action

Sean, ack for the KVM bits and me taking them thru tip?

On Tue, Feb 03, 2026 at 04:24:04PM -0600, Kim Phillips wrote:
> AMD EPYC 5th generation and above processors support IBPB-on-Entry
> for SNP guests.  By invoking an Indirect Branch Prediction Barrier
> (IBPB) on VMRUN, old indirect branch predictions are prevented
> from influencing indirect branches within the guest.
> 
> SNP guests may choose to enable IBPB-on-Entry by setting
> SEV_FEATURES bit 21 (IbpbOnEntry).
> 
> Host support for IBPB on Entry is indicated by CPUID
> Fn8000_001F[IbpbOnEntry], bit 31.
> 
> If supported, indicate support for IBPB on Entry in
> sev_supported_vmsa_features bit 23 (IbpbOnEntry).
> 
> For more info, refer to page 615, Section 15.36.17 "Side-Channel
> Protection", AMD64 Architecture Programmer's Manual Volume 2: System
> Programming Part 2, Pub. 24593 Rev. 3.42 - March 2024 (see Link).
> 
> Link: https://bugzilla.kernel.org/attachment.cgi?id=306250
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
> v2: Added Tom's Reviewed-by.
> v1: https://lore.kernel.org/kvm/20260126224205.1442196-3-kim.phillips@amd.com/
> 
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  arch/x86/include/asm/svm.h         | 1 +
>  arch/x86/kvm/svm/sev.c             | 9 ++++++++-
>  3 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index c01fdde465de..3ce5dff36f78 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -459,6 +459,7 @@
>  #define X86_FEATURE_ALLOWED_SEV_FEATURES (19*32+27) /* Allowed SEV Features */
>  #define X86_FEATURE_SVSM		(19*32+28) /* "svsm" SVSM present */
>  #define X86_FEATURE_HV_INUSE_WR_ALLOWED	(19*32+30) /* Allow Write to in-use hypervisor-owned pages */
> +#define X86_FEATURE_IBPB_ON_ENTRY	(19*32+31) /* SEV-SNP IBPB on VM Entry */
>  
>  /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
>  #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* No Nested Data Breakpoints */
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index edde36097ddc..eebc65ec948f 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -306,6 +306,7 @@ static_assert((X2AVIC_4K_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AV
>  #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
>  #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
>  #define SVM_SEV_FEAT_SECURE_TSC				BIT(9)
> +#define SVM_SEV_FEAT_IBPB_ON_ENTRY			BIT(21)
>  
>  #define VMCB_ALLOWED_SEV_FEATURES_VALID			BIT_ULL(63)
>  
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index ea515cf41168..8a6d25db0c00 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3165,8 +3165,15 @@ void __init sev_hardware_setup(void)
>  	    cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
>  		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
>  
> -	if (sev_snp_enabled && tsc_khz && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
> +	if (!sev_snp_enabled)
> +		return;
> +	/* the following feature bit checks are SNP specific */
> +
> +	if (tsc_khz && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
>  		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;
> +
> +	if (cpu_feature_enabled(X86_FEATURE_IBPB_ON_ENTRY))
> +		sev_supported_vmsa_features |= SVM_SEV_FEAT_IBPB_ON_ENTRY;
>  }
>  
>  void sev_hardware_unsetup(void)
> -- 
> 2.43.0
> 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

