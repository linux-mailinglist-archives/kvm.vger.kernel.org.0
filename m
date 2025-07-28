Return-Path: <kvm+bounces-53525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 122CAB134E9
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 08:31:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 223661896E0D
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 06:32:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F322221578;
	Mon, 28 Jul 2025 06:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="sWeTO7Vl"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79202E36E6;
	Mon, 28 Jul 2025 06:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753684302; cv=none; b=XQbvWauB5mPHqng02UEoel7qjTyuyWAUrDFIlOJFpV7zUFJj/fvXbd2xOMh3iXYJ4kh6NRo77+B3A5zFreuWXsEa0ruyBRXygXlsfD96Iv1pCvn1NOLW6YEErc1dfXWe6EwfdRrSCIUTojtv2jnZWGlySQAg4PAv8NEvx5j8mOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753684302; c=relaxed/simple;
	bh=phI48AhMXD/BxUSODMFpthLY09etg9VpnOBNsRs6VIc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=enPccmckZ/E08+mTGMqwsMSApOunczcl/2ofbKMMfjsnct3TMltz9HkftsFDMiGDALdiENf56zLqV8j9/1Du4C4uZ7w6LnwthjaDNZsiKp5Raq5udJMbmgmF8hVqM4IULpRYejPoI6SN/YSytCXvMy2vd6tRyGgVmEdeFseYZ6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=sWeTO7Vl; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 56S6UTQV053138
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Sun, 27 Jul 2025 23:30:30 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 56S6UTQV053138
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1753684232;
	bh=jDMFGzQKMMeXd6c8aeZfqsxoy83lf5w/1RFASuHFPNc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sWeTO7VlLiC+WAGj3VjOH0j17gRpBNgtw/9UFqYuFVb+7cv0c0zchg/gymVdAWGGY
	 zzUIblTEwG+EOsGmrQeONuHzyDqOU1xiKKNMBMdFk/HnCSxXPsAqCStcT3aH90CrZ3
	 jkisEpxFU0giiBMHhZiu974DUuZ2wx676D38rxrVUR7bKT2Sem3Xwdi4x1svH9JH3v
	 pHz1spA5bAIP3pQi5A/fFgcxeurOLFAVwGwoW3NnupYTpTE2OuixbCwexSSAazEpH3
	 w3y080Wy4r3MuwVoWxBj23jckHyQGpJqP9TJ/DF9Qrfu/vKtmQ9EWNVmTYwbJnjXhg
	 NKxcU6+cNuLqA==
Message-ID: <c3a54990-9cd6-4d8a-baa0-11b4e8d4a23b@zytor.com>
Date: Sun, 27 Jul 2025 23:30:28 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 21/23] KVM: nVMX: Enable CET support for nested guest
To: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, seanjc@google.com,
        pbonzini@redhat.com, dave.hansen@intel.com
Cc: rick.p.edgecombe@intel.com, mlevitsk@redhat.com, john.allen@amd.com,
        weijiang.yang@intel.com, minipli@grsecurity.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20250704085027.182163-1-chao.gao@intel.com>
 <20250704085027.182163-22-chao.gao@intel.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <20250704085027.182163-22-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

> @@ -2515,6 +2537,30 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
>   	}
>   }
>   
> +static inline void cet_vmcs_fields_get(struct kvm_vcpu *vcpu, u64 *ssp,
> +				       u64 *s_cet, u64 *ssp_tbl)
> +{
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK)) {
> +		*ssp = vmcs_readl(GUEST_SSP);
> +		*ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
> +	}
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_IBT) ||
> +	    guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK))
> +		*s_cet = vmcs_readl(GUEST_S_CET);
> +}
> +
> +static inline void cet_vmcs_fields_set(struct kvm_vcpu *vcpu, u64 ssp,
> +				       u64 s_cet, u64 ssp_tbl)
> +{
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK)) {
> +		vmcs_writel(GUEST_SSP, ssp);
> +		vmcs_writel(GUEST_INTR_SSP_TABLE, ssp_tbl);
> +	}
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_IBT) ||
> +	    guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK))
> +		vmcs_writel(GUEST_S_CET, s_cet);
> +}
> +
>   static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>   {
>   	struct hv_enlightened_vmcs *hv_evmcs = nested_vmx_evmcs(vmx);


The order of the arguments is a bit of weird to me, I would move s_cet
before ssp.  Then it is consistent with the order in
https://lore.kernel.org/kvm/20250704085027.182163-13-chao.gao@intel.com/


> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -181,6 +181,9 @@ struct nested_vmx {
>   	 */
>   	u64 pre_vmenter_debugctl;
>   	u64 pre_vmenter_bndcfgs;
> +	u64 pre_vmenter_ssp;
> +	u64 pre_vmenter_s_cet;
> +	u64 pre_vmenter_ssp_tbl;
>   
>   	/* to migrate it to L1 if L2 writes to L1's CR8 directly */
>   	int l1_tpr_threshold;

Same here.

