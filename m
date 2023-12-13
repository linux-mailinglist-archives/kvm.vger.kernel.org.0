Return-Path: <kvm+bounces-4330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B787481121C
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 13:52:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F910281D42
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 12:52:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95CCC2C198;
	Wed, 13 Dec 2023 12:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e1VvnWDP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7729D3277
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 04:52:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702471933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bJEv3Wgqf4ketU6WFDuIdEXMdIFFad1fKIX/8Z1IzcQ=;
	b=e1VvnWDP3Z4eFvd20X2t0dQoynVFy6dukEfrXJ50tBdhdDoqfETyUNpp1o33UjOOEFl3sR
	89pE0Oiy3qPzqoOHGoSW//DL8pS+rm7sQAs6K6cQTkOsC0ooFQVUR/KCqlaqwEbw72PZCR
	uZhD7938lT9S7oOxJVy0aWo4aLMnDzI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-495-bRGskfC2Pn6hytV9RV7BlQ-1; Wed, 13 Dec 2023 07:52:12 -0500
X-MC-Unique: bRGskfC2Pn6hytV9RV7BlQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-333405020f3so5291895f8f.1
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 04:52:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702471930; x=1703076730;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bJEv3Wgqf4ketU6WFDuIdEXMdIFFad1fKIX/8Z1IzcQ=;
        b=JuKjD2pHqtDw0yPxxlZWgLheBJNyawWhko0suw7bMm9aRgodB1skTh0jfq82TwBZmg
         0DuKebwdIp/YNkMKpRsZV2fDSqZvK3C6cyMMBZIw3h78aZbm0RZ4Opq6/gFFTZBPn1Uu
         ByvqIg6kpoBWMOto5RYQJjSJ5CkS2IHRK49zkV72WXHWDPgpSu62aUPc5033yPf9Xjdy
         gPhJCPvLqwJA+D/8CRo59Qqg7JO5vh5ps7rEg69EsRV7/vecSvB8TCuTJiGo2J74J4DS
         Ab0wzfLsyXUa2yujczOmPiOk/2GMU6OOX/UOZifxwMq5+ITk/Ig70BOJJkm4b76DddEP
         P7Vw==
X-Gm-Message-State: AOJu0YwqkByUM/iIZUh1aHjStRb+xlzLNjKkD2p6vBEGdZ9D7U4S3zA0
	NO44sPIVHFTe6hh9nCW/X2Ohabfz0SnzbXs2yVm7/p2J02yLYcmQCcRokHKIuPUmOUZ3WmTdB2G
	BAtL/ksWyg6sm
X-Received: by 2002:adf:fd46:0:b0:336:975:1832 with SMTP id h6-20020adffd46000000b0033609751832mr4108933wrs.9.1702471930069;
        Wed, 13 Dec 2023 04:52:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHsiuI3U3USlVbrEOowWazssqrIJRsCiZR7plKklR2Gi3O2ESNv8XGdBBceH98jEgWRta30fA==
X-Received: by 2002:adf:fd46:0:b0:336:975:1832 with SMTP id h6-20020adffd46000000b0033609751832mr4108893wrs.9.1702471929744;
        Wed, 13 Dec 2023 04:52:09 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id h3-20020a5d4303000000b0033629538fa2sm4664964wrq.18.2023.12.13.04.52.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Dec 2023 04:52:09 -0800 (PST)
Message-ID: <addcbff6-5db9-446a-a0a2-78f3be7f33db@redhat.com>
Date: Wed, 13 Dec 2023 13:52:07 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 05/50] x86/speculation: Do not enable Automatic IBRS
 if SEV SNP is enabled
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, seanjc@google.com,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
 vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
 tony.luck@intel.com, marcorr@google.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
 jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
 pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com,
 Kim Phillips <kim.phillips@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-6-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20231016132819.1002933-6-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/23 15:27, Michael Roth wrote:
> From: Kim Phillips <kim.phillips@amd.com>
> 
> Without SEV-SNP, Automatic IBRS protects only the kernel. But when
> SEV-SNP is enabled, the Automatic IBRS protection umbrella widens to all
> host-side code, including userspace. This protection comes at a cost:
> reduced userspace indirect branch performance.
> 
> To avoid this performance loss, don't use Automatic IBRS on SEV-SNP
> hosts. Fall back to retpolines instead.
> 
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>
> [mdr: squash in changes from review discussion]
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Queued, thanks.

Paolo

> ---
>   arch/x86/kernel/cpu/common.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 382d4e6b848d..11fae89b799e 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -1357,8 +1357,13 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
>   	/*
>   	 * AMD's AutoIBRS is equivalent to Intel's eIBRS - use the Intel feature
>   	 * flag and protect from vendor-specific bugs via the whitelist.
> +	 *
> +	 * Don't use AutoIBRS when SNP is enabled because it degrades host
> +	 * userspace indirect branch performance.
>   	 */
> -	if ((ia32_cap & ARCH_CAP_IBRS_ALL) || cpu_has(c, X86_FEATURE_AUTOIBRS)) {
> +	if ((ia32_cap & ARCH_CAP_IBRS_ALL) ||
> +	    (cpu_has(c, X86_FEATURE_AUTOIBRS) &&
> +	     !cpu_feature_enabled(X86_FEATURE_SEV_SNP))) {
>   		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
>   		if (!cpu_matches(cpu_vuln_whitelist, NO_EIBRS_PBRSB) &&
>   		    !(ia32_cap & ARCH_CAP_PBRSB_NO))


