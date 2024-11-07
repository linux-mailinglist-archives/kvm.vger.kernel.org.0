Return-Path: <kvm+bounces-31052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 725029BFCC5
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 03:53:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F52C1C212E5
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 02:53:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A50E1126C1E;
	Thu,  7 Nov 2024 02:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X6fv/Xve"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353172207A
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 02:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730947991; cv=none; b=USRFH60Mf35HGWTOpktkh8WAJxP/ItS/+Qt5+IuJAeGQgybpZzNWxKc5nMnQzi+dCn9hglocB7PUp817yT0Ksvw0Q2OPgT7XjeRfXqnCeoeifQKfIqhIquM3RYokDUjYT8qXPkOT/We8+APnJEZ7u+2UF1+7tNrHxP+b8QmuJLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730947991; c=relaxed/simple;
	bh=9Cnj/C8vZ2+3PVgYBk0wKAhkXB96hGEEmPN+X5v9GYc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ovTjQUSEMx+36yLOS+LKKOyQNQn4JQunqLtHMobdQpKV49Go5i83EDs17/5yq2/HQuU7USRBGrfLmeoDmWjTlu95/y3B5ln/7SnmmEyQhTeShldAgqMOFLRQ42YJ9YHUcma/+F8O7l6s8dvs8Vrw0YvUXSxc/zmElmoOhTBUWXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X6fv/Xve; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730947990; x=1762483990;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9Cnj/C8vZ2+3PVgYBk0wKAhkXB96hGEEmPN+X5v9GYc=;
  b=X6fv/Xve6eJWlhiVxC9dNOoZy6e/o1MK2nkJiJ/mBuG933VRtgTedwPi
   oXtMpL+E7maqVp3BTTgXrgyBSkjSDXZkIhChPH7UzQ7FZkzT5JZ+AlAgr
   JdXdi+JaXQyL/O/xfIzD0yNEaI2N2FAFylATpm4nFp65ZdBmk/om+isr8
   9t7lxvX3Yg6RtkWjYelYjNxScse60Rl4rU6bw0wQC8+eLn6WOzTKQJxI8
   fJoB1MglDLBKw0/hWz6wcO2GCgipGia7CeMuz5KZGO9Tx3PZBitsRD4eD
   alfwzYVwPENj3rTZSiCQhA9LZ6eNzH320kI1eOTatG5tR684q9sBew/sH
   w==;
X-CSE-ConnectionGUID: i25iN63UQyCxxZ/pBC160g==
X-CSE-MsgGUID: myCTDNpXQhSAf55ccWUNzA==
X-IronPort-AV: E=McAfee;i="6700,10204,11248"; a="42177400"
X-IronPort-AV: E=Sophos;i="6.11,264,1725346800"; 
   d="scan'208";a="42177400"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 18:53:09 -0800
X-CSE-ConnectionGUID: PDGZenlmReOmKFoSM7Gkeg==
X-CSE-MsgGUID: xUUiR8s6QCWfysyKu3H/vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,264,1725346800"; 
   d="scan'208";a="88852257"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 18:53:07 -0800
Message-ID: <268b3ac1-2ccf-4489-9358-889f01216b59@linux.intel.com>
Date: Thu, 7 Nov 2024 10:52:17 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/13] iommu/vt-d: Add pasid replace helpers
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com
Cc: alex.williamson@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, vasant.hegde@amd.com, willy@infradead.org
References: <20241106154606.9564-1-yi.l.liu@intel.com>
 <20241106154606.9564-5-yi.l.liu@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20241106154606.9564-5-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/24 23:45, Yi Liu wrote:
> +int intel_pasid_replace_first_level(struct intel_iommu *iommu,
> +				    struct device *dev, pgd_t *pgd,
> +				    u32 pasid, u16 did, u16 old_did,
> +				    int flags)
> +{
> +	struct pasid_entry *pte;
> +
> +	if (!ecap_flts(iommu->ecap)) {
> +		pr_err("No first level translation support on %s\n",
> +		       iommu->name);
> +		return -EINVAL;
> +	}
> +
> +	if ((flags & PASID_FLAG_FL5LP) && !cap_fl5lp_support(iommu->cap)) {
> +		pr_err("No 5-level paging support for first-level on %s\n",
> +		       iommu->name);
> +		return -EINVAL;
> +	}
> +
> +	spin_lock(&iommu->lock);
> +	pte = intel_pasid_get_entry(dev, pasid);
> +	if (!pte) {
> +		spin_unlock(&iommu->lock);
> +		return -ENODEV;
> +	}
> +
> +	if (!pasid_pte_is_present(pte)) {
> +		spin_unlock(&iommu->lock);
> +		return -EINVAL;
> +	}
> +
> +	WARN_ON(old_did != pasid_get_domain_id(pte));
> +
> +	pasid_pte_config_first_level(iommu, pte, pgd, did, flags);
> +	spin_unlock(&iommu->lock);
> +
> +	intel_pasid_flush_present(iommu, dev, pasid, old_did, pte);
> +	intel_iommu_drain_pasid_prq(dev, pasid);
> +
> +	return 0;
> +}

pasid_pte_config_first_level() causes the pasid entry to transition from
present to non-present and then to present. In this case, calling
intel_pasid_flush_present() is not accurate, as it is only intended for
pasid entries transitioning from present to present, according to the
specification.

It's recommended to move pasid_clear_entry(pte) and
pasid_set_present(pte) out to the caller, so ...

For setup case (pasid from non-present to present):

- pasid_clear_entry(pte)
- pasid_pte_config_first_level(pte)
- pasid_set_present(pte)
- cache invalidations

For replace case (pasid from present to present)

- pasid_pte_config_first_level(pte)
- cache invalidations

The same applies to other types of setup and replace.

--
baolu

