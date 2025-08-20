Return-Path: <kvm+bounces-55218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D45DAB2E83C
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 00:45:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7946BA07591
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 22:45:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BBD62D480E;
	Wed, 20 Aug 2025 22:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YEmmwkbb"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C53E229B2A;
	Wed, 20 Aug 2025 22:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755729923; cv=none; b=mL4WQJ8G9m3tWP2lOZ9bTdVoQBqjSz0Nbh+mP9KOQMGiImZP7bGbE/hVgk4VfeOfy7N1XppT5/0s/Zit2G2nEXlvqKnKOR5brUfrkVMSYxayvetGV48GTbB8shvpJgP8ARyzEz5EV83qro8im7LIEv5MxW1rFkM+YKDJUBZJ3iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755729923; c=relaxed/simple;
	bh=dOc9PDPMBqmiptZkMu4FCamWCTbHdvtW3swVBPYcP4Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M0Sxretfr5+MMWLrj6781HkqaNdsMq1XuAobUrRUNMqZITf/gzSSGQ0nHLN8sQYS5UEpokXEWVnFCXqupzmZkPAkbjGDVabU0T3q/JQeEwZfT9IAMt12thQVkyQbrkjW34YeMWhBOC8COCLDSBKJFtIDD8LLh4Qsmwi3IYeIijM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YEmmwkbb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=z5KzQpKSCrGkNRK0A+Nuu0QJ5XEq+csvMXy8Q4LEMVg=; b=YEmmwkbbJreasT2XkCNJqiDGee
	2J0PubICP/04xFPkYU+ZmpxqNl7SgmwCKpEnW0fhr6ONFZaqJXLFRhJtoZ9PGBp7Bcjq82RBt9dTZ
	Sh4O5pKx24/T/fyQuCAxi1S9pWOtIrJNQw49iNThpl4nX2y8530LW+lgXl7HNGhkZS9hTUfcdJPR+
	tiSiwckQbVMYRhaxNZzPAxSR+nxZ1TM3ry10XScmLLSENKhcyQMvs42p0AWRg3KhHpbhOvs1/Jsb5
	693rcy+FbvNnOg57iaBZKN3krLR4gVAGtMkO+3hhRMdUPwuExLKqZRMDKS81rGz51aBzjblcB+ONN
	AKq1R2EA==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uorYQ-0000000F7RY-0GFl;
	Wed, 20 Aug 2025 22:45:14 +0000
Message-ID: <5dff05c1-474e-4fff-a19b-7c17b4db6173@infradead.org>
Date: Wed, 20 Aug 2025 15:45:13 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/2] KVM: SEV: Add SEV-SNP CipherTextHiding support
To: Ashish Kalra <Ashish.Kalra@amd.com>, corbet@lwn.net, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, herbert@gondor.apana.org
Cc: akpm@linux-foundation.org, rostedt@goodmis.org, paulmck@kernel.org,
 michael.roth@amd.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1755721927.git.ashish.kalra@amd.com>
 <95abc49edfde36d4fb791570ea2a4be6ad95fd0d.1755721927.git.ashish.kalra@amd.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <95abc49edfde36d4fb791570ea2a4be6ad95fd0d.1755721927.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/20/25 1:50 PM, Ashish Kalra wrote:
> @@ -3064,10 +3070,32 @@ void __init sev_hardware_setup(void)
>  out:
>  	if (sev_enabled) {
>  		init_args.probe = true;
> +
> +		if (sev_is_snp_ciphertext_hiding_supported())
> +			init_args.max_snp_asid = min(nr_ciphertext_hiding_asids,
> +						     min_sev_asid - 1);
> +
>  		if (sev_platform_init(&init_args))
>  			sev_supported = sev_es_supported = sev_snp_supported = false;
>  		else if (sev_snp_supported)
>  			sev_snp_supported = is_sev_snp_initialized();
> +
> +		if (sev_snp_supported)
> +			nr_ciphertext_hiding_asids = init_args.max_snp_asid;
> +
> +		/*
> +		 * If ciphertext hiding is enabled, the joint SEV-ES/SEV-SNP
> +		 * ASID range is partitioned into separate SEV-ES and SEV-SNP
> +		 * ASID ranges, with the SEV-SNP range being [1..max_snp_asid]
> +		 * and the SEV-ES range being [max_snp_asid..max_sev_es_asid].

		                              [max_snp_asid + 1..max_sev_es_asid]
?

> +		 * Note, SEV-ES may effectively be disabled if all ASIDs from
> +		 * the joint range are assigned to SEV-SNP.
> +		 */
-- 
~Randy


