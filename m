Return-Path: <kvm+bounces-8338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E508F84E147
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 14:01:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 820D81F2185F
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 13:01:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7E247602C;
	Thu,  8 Feb 2024 13:01:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EF78762F1;
	Thu,  8 Feb 2024 13:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707397270; cv=none; b=WfMmf3dInYItR5mB+bdO5ef1zCLpYbdHAt7gWMot7ymf8xxMkVFMPEOV93v73qEdb6jVioACTGLR+JgApEalJ8hO1OWekMZMICruyqotOLEU4ekHGyU15gzFkskBQZpiFoWcaRg2fyp2Dk+W+FWYGYINu3NqPLaYF8GFCCBbOqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707397270; c=relaxed/simple;
	bh=MBMsm5Hty7waMz69tLQDq3T7dLAK/n2/fSO/BF9P+Ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b3XsQwIpeq/FeTdBqzjoqghZxMyDd9FyaAWbqEuR5z+A7XNbZ+oiv4/MasgzeyzDyzsHjmyguTZ3DKRZ+qUIlnf+GQIaQ+qjnnaJks7n8pbmngABtHwbuZL40q4dSbYRWSg3Sk11cjxONsJHk0WUTAdUh+ab77BXQI0Yrygre5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D4C6F1FB;
	Thu,  8 Feb 2024 05:01:48 -0800 (PST)
Received: from arm.com (RQ4T19M611.cambridge.arm.com [10.1.31.53])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CF6FB3F5A1;
	Thu,  8 Feb 2024 05:01:01 -0800 (PST)
Date: Thu, 8 Feb 2024 13:00:59 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: ankita@nvidia.com
Cc: jgg@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	reinette.chatre@intel.com, surenb@google.com, stefanha@redhat.com,
	brauner@kernel.org, will@kernel.org, mark.rutland@arm.com,
	alex.williamson@redhat.com, kevin.tian@intel.com,
	yi.l.liu@intel.com, ardb@kernel.org, akpm@linux-foundation.org,
	andreyknvl@gmail.com, wangjinchao@xfusion.com, gshan@redhat.com,
	ricarkol@google.com, linux-mm@kvack.org, lpieralisi@kernel.org,
	rananta@google.com, ryan.roberts@arm.com, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, kvmarm@lists.linux.dev,
	mochs@nvidia.com, zhiw@nvidia.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 1/4] kvm: arm64: introduce new flag for non-cacheable
 IO memory
Message-ID: <ZcTQi0wWZgvl05LB@arm.com>
References: <20240207204652.22954-1-ankita@nvidia.com>
 <20240207204652.22954-2-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240207204652.22954-2-ankita@nvidia.com>

On Thu, Feb 08, 2024 at 02:16:49AM +0530, ankita@nvidia.com wrote:
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index c651df904fe3..2a893724ee9b 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -717,15 +717,28 @@ void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
>  static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot prot,
>  				kvm_pte_t *ptep)
>  {
> -	bool device = prot & KVM_PGTABLE_PROT_DEVICE;
> -	kvm_pte_t attr = device ? KVM_S2_MEMATTR(pgt, DEVICE_nGnRE) :
> -			    KVM_S2_MEMATTR(pgt, NORMAL);
> +	kvm_pte_t attr;
>  	u32 sh = KVM_PTE_LEAF_ATTR_LO_S2_SH_IS;
>  
> +	switch (prot & (KVM_PGTABLE_PROT_DEVICE |
> +			KVM_PGTABLE_PROT_NORMAL_NC)) {
> +	case 0:
> +		attr = KVM_S2_MEMATTR(pgt, NORMAL);
> +		break;
> +	case KVM_PGTABLE_PROT_DEVICE:
> +		if (prot & KVM_PGTABLE_PROT_X)
> +			return -EINVAL;
> +		attr = KVM_S2_MEMATTR(pgt, DEVICE_nGnRE);
> +		break;
> +	case KVM_PGTABLE_PROT_NORMAL_NC:
> +		attr = KVM_S2_MEMATTR(pgt, NORMAL_NC);
> +		break;

Does it make sense to allow executable here as well? I don't think it's
harmful but not sure there's a use-case for it either.

> +	default:
> +		WARN_ON_ONCE(1);

Return -EINVAL?

-- 
Catalin

