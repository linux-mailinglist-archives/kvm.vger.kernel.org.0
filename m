Return-Path: <kvm+bounces-33451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A6289EBAEB
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 21:41:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 67CC61886F1B
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 20:41:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 243F9229B25;
	Tue, 10 Dec 2024 20:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="RJI/Znfz"
X-Original-To: kvm@vger.kernel.org
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF325228C8D;
	Tue, 10 Dec 2024 20:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733863275; cv=none; b=R0hceW9/hwKkJxxWpMfFg4OqgG73Gqq5DZFT+xNLcfBphFBTb/mcdrYWdRUdprajFnzN3Fk245iJCZadxB75nfh7W5VL01YWFQPnlPzcev7Qj7fHGAALU9l3issHWaLDwQ1Ns1on3Cu7IYs22iHW3NPSHP4rQHkszbC+PNc99LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733863275; c=relaxed/simple;
	bh=WzlgaaqUhE+WLmXr70jjwrg28mgcgmJ7MrB6fom+u8o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P6kIyqWvlGM0AgOZtG+LnKD8vP3Mtm6YGT5hLtpAfDNsaGkETovAD9sO7cIVYJwkcHtpr5TAh8nzPQZ4+ibXhdQ6KipE74JQLz+R0C5UkeKPE+9FQsSjqLw+UHcQZujg0I1962oRaElZNYI8eZA3dH2pWEjfE8wuztw9PAcGM8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=RJI/Znfz; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4Y79S75H7nz9sRf;
	Tue, 10 Dec 2024 21:33:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1733862839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vIkYPi7cZvR+Cq3i7sOkgKR+4usrBNWR28vWv5aHXPw=;
	b=RJI/Znfz/PYtHY+3VxJ/HMSqnJ36wtzAvyDFB2T1rYIKsE14oDoiHeQua55B8kNP6ZheUY
	0ObNWeC4U2A5i4QdoVfzwZYn0mfHVgjjOntfEElSRMUohdc7Csa8k1A8QsWQ05KpL1jOVL
	AfTJA9faF8XrAQntuCqQ+mZDOhKnfxuNZbNZXbM+9yPkcmeL6huHFXTcx9LJQc7wJB9Cy8
	5j9iUr+RUyrAdkSFjiwqaHdpbUnMNasW3B01PSyflsAH0uuPYabUhe1MPKccargZsMXRVH
	IowlDdhnI3MUfjux/dcgNCo7h9i6n8HzX3kNSXI2PwxhiMhpipJ3vYbZQPhj0A==
Message-ID: <93a3edef-dde6-4ef6-ae40-39990040a497@mailbox.org>
Date: Tue, 10 Dec 2024 21:33:58 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [REGRESSION] from 74a0e79df68a8042fb84fd7207e57b70722cf825: VFIO
 PCI passthrough no longer works
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 regressions@lists.linux.dev, Tom Lendacky <thomas.lendacky@amd.com>
References: <52914da7-a97b-45ad-86a0-affdf8266c61@mailbox.org>
 <Z1hiiz40nUqN2e5M@google.com>
Content-Language: en-GB
From: Simon Pilkington <simonp.git@mailbox.org>
In-Reply-To: <Z1hiiz40nUqN2e5M@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-MBO-RS-ID: 0cea7763452cf96db1b
X-MBO-RS-META: hqxa4gxhzzjmcxgkgeomtyp99m94k69s

On 10/12/2024 16:47, Sean Christopherson wrote:
> Can you run with the below to see what bits the guest is trying to set (or clear)?
> We could get the same info via tracepoints, but this will likely be faster/easier.
> 
> ---
>  arch/x86/kvm/svm/svm.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index dd15cc635655..5144d0283c9d 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3195,11 +3195,14 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  	case MSR_AMD64_DE_CFG: {
>  		u64 supported_de_cfg;
>  
> -		if (svm_get_feature_msr(ecx, &supported_de_cfg))
> +		if (WARN_ON_ONCE(svm_get_feature_msr(ecx, &supported_de_cfg)))
>  			return 1;
>  
> -		if (data & ~supported_de_cfg)
> +		if (data & ~supported_de_cfg) {
> +			pr_warn("DE_CFG supported = %llx, WRMSR = %llx\n",
> +				supported_de_cfg, data);
>  			return 1;
> +		}
>  
>  		/*
>  		 * Don't let the guest change the host-programmed value.  The
> @@ -3207,8 +3210,11 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  		 * are completely unknown to KVM, and the one bit known to KVM
>  		 * is simply a reflection of hardware capabilities.
>  		 */
> -		if (!msr->host_initiated && data != svm->msr_decfg)
> +		if (!msr->host_initiated && data != svm->msr_decfg) {
> +			pr_warn("DE_CFG current = %llx, WRMSR = %llx\n",
> +				svm->msr_decfg, data);
>  			return 1;
> +		}
>  
>  		svm->msr_decfg = data;
>  		break;
> 
> base-commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4

Relevant dmesg output with some context below. VM locked up as expected.

[   85.834971] vfio-pci 0000:0c:00.0: resetting
[   85.937573] vfio-pci 0000:0c:00.0: reset done
[   86.494210] vfio-pci 0000:0c:00.0: resetting
[   86.494264] vfio-pci 0000:0c:00.1: resetting
[   86.761442] vfio-pci 0000:0c:00.0: reset done
[   86.761480] vfio-pci 0000:0c:00.1: reset done
[   86.762392] vfio-pci 0000:0c:00.0: resetting
[   86.865462] vfio-pci 0000:0c:00.0: reset done
[   86.977360] virbr0: port 1(vnet1) entered learning state
[   88.993052] virbr0: port 1(vnet1) entered forwarding state
[   88.993057] virbr0: topology change detected, propagating
[  103.459114] kvm_amd: DE_CFG current = 0, WRMSR = 2
[  161.442032] virbr0: port 1(vnet1) entered disabled state // VM shut down

