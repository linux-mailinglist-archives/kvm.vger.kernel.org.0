Return-Path: <kvm+bounces-8339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E45684E152
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 14:03:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9268B1F2191C
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 13:03:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C2AF763F7;
	Thu,  8 Feb 2024 13:03:38 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B12A762F6;
	Thu,  8 Feb 2024 13:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707397417; cv=none; b=peK0vedKu3QfKN1Zg0NidbgBNnEuYeuDve2aFoq78DjBHO4QZOMStpq4JI9Kl4803BITIeMjuXkYCoMSTPZdu9pozQxN0fCk+KbenXzPeQI55MGxMgHOazk/oqxHZgFJAedUSO9pWZ+6w+zV/CWjg81az4zXpNFq8QqXUS2L2lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707397417; c=relaxed/simple;
	bh=iOp3+dbM3c1sC7NzV8kzPUUvv/ulKdEkRcOTriHT1PM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FoWOMKNNLDBggk/FTrw9xXjpdRtUMkgY/SRlVHfqDR7ejLAIRExS8v2yEVwpRdl9hf0v9DsBjXDnXe9K7+LrHlMHPVK3VJuLKbhQ2xK1m8iZIn9CGzJSGImkmjCNO1q+N68EpRV4ahbzHTbGJ1KjQ4Fy5CFutN5GnRU2xoRue4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BCFD0DA7;
	Thu,  8 Feb 2024 05:04:16 -0800 (PST)
Received: from arm.com (RQ4T19M611.cambridge.arm.com [10.1.31.53])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9EEA93F5A1;
	Thu,  8 Feb 2024 05:03:29 -0800 (PST)
Date: Thu, 8 Feb 2024 13:03:27 +0000
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
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v6 2/4] mm: introduce new flag to indicate wc safe
Message-ID: <ZcTRH1rzfPbuQ_qj@arm.com>
References: <20240207204652.22954-1-ankita@nvidia.com>
 <20240207204652.22954-3-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240207204652.22954-3-ankita@nvidia.com>

On Thu, Feb 08, 2024 at 02:16:50AM +0530, ankita@nvidia.com wrote:
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index f5a97dec5169..884c068a79eb 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -391,6 +391,20 @@ extern unsigned int kobjsize(const void *objp);
>  # define VM_UFFD_MINOR		VM_NONE
>  #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
>  
> +/*
> + * This flag is used to connect VFIO to arch specific KVM code. It
> + * indicates that the memory under this VMA is safe for use with any
> + * non-cachable memory type inside KVM. Some VFIO devices, on some
> + * platforms, are thought to be unsafe and can cause machine crashes if
> + * KVM does not lock down the memory type.
> + */
> +#ifdef CONFIG_64BIT
> +#define VM_VFIO_ALLOW_WC_BIT	39
> +#define VM_VFIO_ALLOW_WC	BIT(VM_VFIO_ALLOW_WC_BIT)
> +#else
> +#define VM_VFIO_ALLOW_WC	VM_NONE
> +#endif

Adding David Hildenbrand to this thread as well since we briefly
discussed potential alternatives (not sure we came to any conclusion).

-- 
Catalin

