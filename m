Return-Path: <kvm+bounces-30588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A2139BC2CC
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 02:54:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC3CC1C21EC1
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 01:54:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C757938DE5;
	Tue,  5 Nov 2024 01:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wq/Pfkod"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CAD364BA
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 01:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730771626; cv=none; b=gg/fmKY+F/xh89KoqjZEli1912gNXNPhu8X/IAUl48RkvcZ2ohYErF5PhwaM7ZIVu+w/fry3EcPUAavyM87JC79sizCQ8X9hTPyCQHUOhGG+868a7h8BgVYcs+vXJlQMhwXcCp5bJ3t1rk0NuPchuLgzJE77DkkQR+8WF2TWunM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730771626; c=relaxed/simple;
	bh=wCUYHguh3oqlTDzEym1AOqgeYXKxv2SoincBX4NhB3A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S3e+2iAh9CSV7j+VTlGywqbwv4ybLVbBsF+v9NRTHsh02S/ABQcYfriUQvEZZFhsq8zQaEYuUUWNf7ktYh05qHwfWcr+8kHii+jS9K1JGx/2xoPlCLMmVlw9ISpWDDO1CsbWZfKMCP6QKH25gfDNkonbKP4M7PbDH7xnE7DRl/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wq/Pfkod; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730771625; x=1762307625;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wCUYHguh3oqlTDzEym1AOqgeYXKxv2SoincBX4NhB3A=;
  b=Wq/Pfkodv+Low8K55slOq+Ip/oJfOpxEOV4D4eoVyqmR6H+XgQS4ru3C
   Go8UNGScs9aPY29P79TpNr/iNYYWUDHVLQKvZ08F4o7rccvVJS+ls+kd2
   lFrnRGipivvxUZeqxWOp27UfIPEfXSLef3WEJOpmm653abPftKnB7/Jbc
   9Vg1ecbc1jO9Jqw1kDXMDfDINCJOXBEo54wz11mIDnEBdJpaAbvjEPm/B
   AVlZEPZPNDY3+/Rlxn1AX9iw6AOU9Y6qhV98HnWQuXYbd4yrFGxA2rX+J
   pkRcBNE2SSdjkQQA4IsthO+AAnkOWl4DqZd1R7z+I6tOwDy0vj8G4kSvp
   w==;
X-CSE-ConnectionGUID: vKiNrIaCRCSKpCy1HoFtpw==
X-CSE-MsgGUID: EUwnYBd1SKOO3oCC8XTtag==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="47962860"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="47962860"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 17:53:44 -0800
X-CSE-ConnectionGUID: O/q/fdnnTs6J3+gaCfdhrQ==
X-CSE-MsgGUID: c+lZ+OnrRTmnIVYo+2QmJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,258,1725346800"; 
   d="scan'208";a="88659559"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 17:53:41 -0800
Message-ID: <d1af0bf2-d518-4127-a946-618486ecd92b@linux.intel.com>
Date: Tue, 5 Nov 2024 09:52:55 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/13] iommu/vt-d: Refactor the pasid setup helpers
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com
Cc: alex.williamson@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, vasant.hegde@amd.com, will@kernel.org
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-4-yi.l.liu@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20241104131842.13303-4-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/24 21:18, Yi Liu wrote:
> As iommu driver is going to support pasid replacement, the new pasid replace
> helpers need to config the pasid entry as well. Hence, there are quite a few
> code to be shared with existing pasid setup helpers. This moves the pasid
> config codes into helpers which can be used by existing pasid setup helpers
> and the future new pasid replace helpers.
> 
> No functional change is intended.
> 
> Suggested-by: Lu Baolu<baolu.lu@linux.intel.com>
> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
> ---
>   drivers/iommu/intel/pasid.c | 169 ++++++++++++++++++++++--------------
>   1 file changed, 105 insertions(+), 64 deletions(-)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

