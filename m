Return-Path: <kvm+bounces-30622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 41BE89BC4E3
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:48:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C007FB2200C
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 05:48:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 172DA1F754A;
	Tue,  5 Nov 2024 05:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LB1Kxb2A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99A51C57A5
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 05:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730785688; cv=none; b=r/6+1xSL5dXCMuSn7rEOFF38nnb2qz1Y9EWDU4gAjSVdp5VP5nx1WznJ+sUzVhgh2NZqz+2j0o4lEXa81afcKWZCrwZ8lHLb3uoIF8J4QIcgUbz/o/30jFiMXrVLOEPETClZL523nJV03KlKOH4Wuxf+6Ep78gUuSt5qSo5KzkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730785688; c=relaxed/simple;
	bh=jmEXyz4VwD9eXFBJILlwng64IHSdm8vMkBB9NeY981c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jL9f53oDozukYr4UK0UwRXiP9G/ejumSEsP9WqM4GAApI5KnnasRz1cxy3yGZ6tsG6jLUTKl85kb11aOIiDancrAkN3YRNuktIMLraRCTxQQiwKHrfr/wiyhTbHSbAW3f/Gqb0pWtRXIqoKoB16PqIF+f6j4OYgDX8aFnM/Ah60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LB1Kxb2A; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730785687; x=1762321687;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jmEXyz4VwD9eXFBJILlwng64IHSdm8vMkBB9NeY981c=;
  b=LB1Kxb2AJCu1RDGzPpAqaacEmIjbIl0seiq23xGG2+ee9BgnR93FIwm2
   Ecd/cbfAWNLse6oz5F0+QO5EEr20z1IWLkoOW5Q8bDyT6X/LVh9exw8zi
   tEaicWtBs9V0lgt7HnzwqWWXrxWvi59DWyza34ij9zmV/aEiUKID5OmDu
   o8TU6XoqJNCHcRYZNOnBDj8tzKoCRIS0B5MIYMz/wwK28ygZtgZJZxbf4
   Bm1U/3EDW9vPxmCHIaYrUyfUPD0YZvcmCXPSSv6OjWwS3gZr2NK5bpbyO
   7Tc6UOgPPLZcr4FV1CHGaHkiyU9IWPCVabV087bXzXbi0vfjp56Oy4cWH
   Q==;
X-CSE-ConnectionGUID: xyPjlxeGQkiD+L5TpPlaEQ==
X-CSE-MsgGUID: vcOX2wtDT3GaIoOJc5dINQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="34296034"
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="34296034"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 21:48:07 -0800
X-CSE-ConnectionGUID: 2IWyqnm9TqKKZeDF/qKxQw==
X-CSE-MsgGUID: 1bq5UDDKQP2lUZKxixQBtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="88446957"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 21:48:03 -0800
Message-ID: <edca2671-b6b4-4c61-a30d-48c4bd68317b@linux.intel.com>
Date: Tue, 5 Nov 2024 13:47:17 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/13] iommu/vt-d: Fail SVA domain replacement
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com
Cc: alex.williamson@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, vasant.hegde@amd.com, will@kernel.org
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-11-yi.l.liu@intel.com>
 <0781f329-49a5-4652-ae94-d0bbefa8dbb0@linux.intel.com>
 <2b6a427e-bd3b-436d-9f24-b44d28ec4778@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <2b6a427e-bd3b-436d-9f24-b44d28ec4778@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/5/24 13:30, Yi Liu wrote:
> On 2024/11/5 11:30, Baolu Lu wrote:
>> On 11/4/24 21:18, Yi Liu wrote:
>>> There is no known usage that will attach SVA domain or detach SVA domain
>>> by replacing PASID to or from SVA domain. It is supposed to use the
>>> iommu_sva_{un}bind_device() which invoke the iommu_{at|de} 
>>> tach_device_pasid().
>>> So Intel iommu driver decides to fail the domain replacement if the old
>>> domain or new domain is SVA type.
>>
>> I would suggest dropping this patch.
>>
>> The iommu driver now supports switching SVA domains to and from other
>> types of domains. The current limitation comes from the iommu core,
>> where the SVA interface doesn't use replace.
> 
> I also noticed other iommu drivers (like ARM SMMUv3 and AMD iommu) would
> support SVA replacement. So may we also make intel_svm_set_dev_pasid() be
> able to handle the case in which @old==non-null? At first, it looks to be
> dead code when SVA interface does not use replace. But this may make all
> drivers aligned.

yeah, that works for me.

