Return-Path: <kvm+bounces-33104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CB96B9E4C2A
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 03:15:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B2791881689
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 02:15:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77A4F46B5;
	Thu,  5 Dec 2024 02:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mHLuNAtk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF565464A
	for <kvm@vger.kernel.org>; Thu,  5 Dec 2024 02:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733364916; cv=none; b=P1wUO844KfmY0Dq461CdAE35B4dV+oQW6OnVzbW1mvj59DDDeV+mVfINfWg2+ebcH7tU8Af3ACyeqYr6gSg7pTCA14P6YY9fgDMKTqhHAxBWEm0AS9tu/ng0sWAsZlzxUKMj+i+k06lIY6yoWDWE+bPvOQm6G/TiYIlGiD5uKnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733364916; c=relaxed/simple;
	bh=+XMr2qI3RgCXJth7UCtE7+gEHUEIQIV1Ynqs7tzEIDU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I9lf1GAiywvurGqmdBZS19BpxxL5iPoPs7QJn9YPggG8UsoU1rTlTi3A4+7EydWnDwCQT2Dq4QT7UhSEE5MpdWpGcSU/HWjWHl7MOefR+iaxluAo8nUuN6K+Jeezj3Tzzc+9fjIkw6XFFywHW4UNSN8MKBU4Jkx1rhU5YQlFnI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mHLuNAtk; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733364914; x=1764900914;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+XMr2qI3RgCXJth7UCtE7+gEHUEIQIV1Ynqs7tzEIDU=;
  b=mHLuNAtkAtl5czBZgbv1LhFR9jPEnF5EslLBNmzToHe79b7vy2YVF04e
   rI3no7xjVmU7mEGoInT+hjlVaiifuZgrJcqeAOg0lwv9wn6ts8iTYrJaX
   DHy2LJzuoFM9bXHM4q4YWjdkwTna6k1+Uix2AQvQbLggJezgeWszvkBOl
   AWwT30sK44KEwEQGyrQas/7F0FJVNRLkrEAfOBWj/dv45gRv/lEuQ0yna
   Yemvc/h+Ob/KsSM4DXJM5rOCt5ZtzB/fMMxQUJ60eEGAiPrhogOon44kq
   J94ZNN6hOb5Sn6z72di0XojdnYXPKs9vODxdHATG6iNKBYG+NMiOhgjIk
   Q==;
X-CSE-ConnectionGUID: jDk7/kR+Sb61kBhVUP0q3w==
X-CSE-MsgGUID: xA6S4WJ0T7eMO6ao18ZVWQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11276"; a="45034342"
X-IronPort-AV: E=Sophos;i="6.12,209,1728975600"; 
   d="scan'208";a="45034342"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2024 18:15:14 -0800
X-CSE-ConnectionGUID: nK5JC30FRNyQHWXSITb5cQ==
X-CSE-MsgGUID: KA/LbP2ES463SJcn4Q+LKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,209,1728975600"; 
   d="scan'208";a="93844581"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2024 18:15:11 -0800
Message-ID: <88b3bd3d-f5e0-436d-a738-32141bae9d15@linux.intel.com>
Date: Thu, 5 Dec 2024 10:13:48 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/7] iommu: Prevent pasid attach if no
 ops->remove_dev_pasid
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com
Cc: eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
 chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, vasant.hegde@amd.com, will@kernel.org
References: <20241204122928.11987-1-yi.l.liu@intel.com>
 <20241204122928.11987-2-yi.l.liu@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20241204122928.11987-2-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/4/24 20:29, Yi Liu wrote:
> driver should implement both set_dev_pasid and remove_dev_pasid op, otherwise
> it is a problem how to detach pasid. In reality, it is impossible that an
> iommu driver implements set_dev_pasid() but no remove_dev_pasid() op. However,
> it is better to check it.
> 
> Move the group check to be the first as dev_iommu_ops() may fail when there
> is no valid group. Also take the chance to remove the dev_has_iommu() check
> as it is duplicated to the group check.
> 
> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
> Signed-off-by: Yi Liu<yi.l.liu@intel.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

