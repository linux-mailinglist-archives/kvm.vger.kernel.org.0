Return-Path: <kvm+bounces-26099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C6824970FD7
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 09:31:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E92A1F2279F
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 07:31:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6358E1B143D;
	Mon,  9 Sep 2024 07:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E2nJSC1f"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C501AED5E
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 07:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725866951; cv=none; b=ivLOIAdCa/PUITVzTEtL8t6s18Hm34hYkP3E+/5GE+kbxwZ1Ba7qc8qnhdWIMrkNJSkK9Eg8PNVd5XfmI/V1DsGwGyXiPzu6BEWRr60LQbHZ7SRYoykjm4iPYSOQNIviug24G63B7VRlxrdiztrp4Zkma0/TYDQlNUYrPJNGb1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725866951; c=relaxed/simple;
	bh=q3AEtTy1x+nFp52E/2YooMpzD+YU5PDsLu4InDt8oyc=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ba/kxvmzIKrsz/WDbRF2xD/hLGd7FwX9gZZxOLe+DkPuspgUxVInaPcY21yk9BY5mxqKRHQR9a9JIEzNlZbJ5ENc3zmeSggIs18cl0ekfM/hmdrALcpjaUHEgqJKkZ6yJCFyZiMxTK2ryr624c6qXur/6mGevSPd+HfDMDd3DwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E2nJSC1f; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725866949; x=1757402949;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=q3AEtTy1x+nFp52E/2YooMpzD+YU5PDsLu4InDt8oyc=;
  b=E2nJSC1fYsknhEb7CMCAmWvvLR3sQie4GtxZk8rEoPZGsDQrQArtsTDC
   JPiXIYM7qQ2k+NbYZX4ipERPvQ8Yf8re59pR6QrNyqOShbuO8h1GyI7Em
   jVE8MDwfstvPaZYWZrVpCDuNyOUNYb8OInYUd9qOLa0VbFeIZ/01P39FA
   oXp5UtwcDjbqJcpDHp/4xAhrFW7eEeSXzACJtJVmSWRlMLT+MKMc6pg2e
   4Z2lfsIO/UGhuS0iesF/O95W1/ibkRIMG4Cjoo8bPT6AT1CSMZNVispGQ
   Jj7P8MXeVMKIsbVwHo6mWgwBZ8YhGcQ2feFpJ/S60VvM4s1ddDZiOMuPj
   g==;
X-CSE-ConnectionGUID: uVW3D4kSRt6TiNhWIO4uZQ==
X-CSE-MsgGUID: w2eWpGqNQcic2HuLZNEk8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11189"; a="24091709"
X-IronPort-AV: E=Sophos;i="6.10,213,1719903600"; 
   d="scan'208";a="24091709"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 00:29:08 -0700
X-CSE-ConnectionGUID: 1ieEP/QDQBO8wzgG5o8OiQ==
X-CSE-MsgGUID: anNJAjRsSTm2+SDKeekH0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,213,1719903600"; 
   d="scan'208";a="97288844"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.125.248.220]) ([10.125.248.220])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 00:29:06 -0700
Message-ID: <7afa4278-3c86-435a-a9c3-b65122607719@linux.intel.com>
Date: Mon, 9 Sep 2024 15:29:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
 iommu@lists.linux.dev
Subject: Re: [PATCH 1/2] iommufd: Avoid duplicated
 __iommu_group_set_core_domain() call
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com
References: <20240908114256.979518-1-yi.l.liu@intel.com>
 <20240908114256.979518-2-yi.l.liu@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20240908114256.979518-2-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/9/8 19:42, Yi Liu wrote:
> For the fault-capable hwpts, the iommufd_hwpt_detach_device() calls both
> iommufd_fault_domain_detach_dev() and iommu_detach_group(). This would have
> duplicated __iommu_group_set_core_domain() call since both functions call
> it in the end. This looks no harm as the __iommu_group_set_core_domain()
> returns if the new domain equals to the existing one. But it makes sense to
> avoid such duplicated calls in caller side.
> 
> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
> ---
>   drivers/iommu/iommufd/iommufd_private.h | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Thanks,
baolu

