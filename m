Return-Path: <kvm+bounces-43147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6D03A85838
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 11:41:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 526CF4C746B
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 09:41:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 777462989B3;
	Fri, 11 Apr 2025 09:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="FfPVQmoS"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C343E29614F;
	Fri, 11 Apr 2025 09:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744364490; cv=none; b=Cvrr/41Q7zHGG3EIy3H2eCqMEXoWqbhI8p24jIUoG0shb7JoE6h8Jt8piSgtE/deFBLuX82k4/C1e4J2HoOMWOa69TiPjIsUjYKys2Z93BkQcmdQC6Q2iyOKEeEvRpxlSWvhtztHrtAYUzKmNF1MiNMMQIKKD4j7bzPm8HzNEQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744364490; c=relaxed/simple;
	bh=KKMtCS4OfaEbrCgXYT2nPWBhWNifblFN4Ybk+JLl8cc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KHQ2RTVe/Dxh3wvW1Za5vpLCYgwqmMeboHTe+GLKyoYrHJ1iluvLh0gSkq3R9meoWrpMVWjUaHEGoI6QP9GTE/nQvyQguv+eW9+0b48cFjmbG1JeFt2BTKC2LuUStSoO/Pn2+lrt57Fpk/3F7RFAWjhre4y5V/jyjO73Xz0UEYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=FfPVQmoS; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E120140E0245;
	Fri, 11 Apr 2025 09:41:22 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id bZ0Ev7D0tTb4; Fri, 11 Apr 2025 09:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1744364478; bh=wqXS2ZrfKP6z2BItE8uPg3Dcp/UK9RV9tzPDfKXC3RQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FfPVQmoSsjmMOnQfOJi48vW1SJ6OP0xGT+JEDQ9QJMFFUj/Qa01RJynUXLyaHjXXr
	 Dma0hocADYQUIBmD9J0wky/mlxwelifJDvwHQelAe6tGwki6JC4rSDnduy8Jc2Jimp
	 lw7Cvmp0/vN+wf34p8Q9GWu8VaFIUvr9eqtCEkSbq/xlyVxX1xfsNJxevkVorru6Ol
	 7BdInHB/MuJM9KZsvtpzQ604SKSgNgXv79fEO3Lxd3MvvTcqbaaKFWBrsz5jVHJ3Uv
	 q12LbCvw8dFAEPRLCzcd/LxJrF+XCKlWcTnFzaDwNxcQcWBPjuUECPfdeBpcYe7/TY
	 r60LHL5i7Md60VEVaUD+6ScIBLTj4oaD5xJU5x+3kr3jgUI75j0Wcmrynq5AQerzfe
	 7VAT5R1UP+Du4yspOZMwnuJB7DFV5Tl+bqJ5994i8c+mUIHkQ/E+tbu4UWmNB85QXb
	 iOqHdFzpCHOYogLjAm6KhHjMfguQUx51MpVdvvN5IgsevNa1Tthj3d7KJ+QFU7wLlr
	 FwWSeOU7BEzOvtmHTtEXks+PUAnPCgRUXvO46SgnINLN5lG8kx8sRpyeRUjYNq8YJ1
	 GaHiRSNGqcOhPwcl2Jjzp+bfx9mhCz4oCPjImceMO+6tqC/3pGfQqKkkHlrYM5Ctx9
	 vqSaJ/Ml+weGhoU/eXWXampY=
Received: from zn.tnic (p579690ee.dip0.t-ipconnect.de [87.150.144.238])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 68CB340E0244;
	Fri, 11 Apr 2025 09:41:06 +0000 (UTC)
Date: Fri, 11 Apr 2025 11:40:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: Maksim Davydov <davydov-max@yandex-team.ru>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	babu.moger@amd.com, seanjc@google.com, mingo@redhat.com,
	tglx@linutronix.de, dave.hansen@linux.intel.com, hpa@zytor.com,
	jmattson@google.com, pbonzini@redhat.com
Subject: Re: [PATCH v3 1/2] x86: KVM: Advertise FSRS and FSRC on AMD to
 userspace
Message-ID: <20250411094059.GIZ_jjq0DxLhJOEQ9B@fat_crate.local>
References: <20241204134345.189041-1-davydov-max@yandex-team.ru>
 <20241204134345.189041-2-davydov-max@yandex-team.ru>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241204134345.189041-2-davydov-max@yandex-team.ru>

On Wed, Dec 04, 2024 at 04:43:44PM +0300, Maksim Davydov wrote:
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 17b6590748c0..45f87a026bba 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -460,6 +460,8 @@
>  #define X86_FEATURE_NULL_SEL_CLR_BASE	(20*32+ 6) /* Null Selector Clears Base */
>  #define X86_FEATURE_AUTOIBRS		(20*32+ 8) /* Automatic IBRS */
>  #define X86_FEATURE_NO_SMM_CTL_MSR	(20*32+ 9) /* SMM_CTL MSR is not present */
> +#define X86_FEATURE_AMD_FSRS	        (20*32+10) /* AMD Fast short REP STOSB supported */
> +#define X86_FEATURE_AMD_FSRC		(20*32+11) /* AMD Fast short REP CMPSB supported */

Since Intel has the same flags, you should do

	if (cpu_has(c, X86_FEATURE_AMD_FSRS))
		set_cpu_cap(c, X86_FEATURE_FSRS);

and the other one too. Probably in init_amd() so that guest userspace doesn't
need to differentiate between the two and you don't have to do...

>  #define X86_FEATURE_SBPB		(20*32+27) /* Selective Branch Prediction Barrier */
>  #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* MSR_PRED_CMD[IBPB] flushes all branch type predictions */
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 097bdc022d0f..7bc095add8ee 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -799,8 +799,8 @@ void kvm_set_cpu_caps(void)
>  
>  	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
>  		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
> -		F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | 0 /* PrefetchCtlMsr */ |
> -		F(WRMSR_XX_BASE_NS)
> +		F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | F(AMD_FSRS) |
> +		F(AMD_FSRC) | 0 /* PrefetchCtlMsr */ | F(WRMSR_XX_BASE_NS)

... this.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

