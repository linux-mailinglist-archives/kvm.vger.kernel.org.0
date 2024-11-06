Return-Path: <kvm+bounces-30913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEB649BE482
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 11:43:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 37121B21A53
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:43:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEC9E1DE2DC;
	Wed,  6 Nov 2024 10:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X0Hy/5fi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B151DD523
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 10:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730889803; cv=none; b=nB4gcF7buEJqX3o9pv1QJYNg+uanE6P6Ikk2vXqsEtNN141kG/YlaUlquHlljNbPL+x8XN6+5dAReQ9cn+A5oHXA9OEWXVSShY41r2pcnT/BTVnFSTyQrBec/WKunwMgZpQfMNsj+F9LFhwauLr35isgnEn22KgkCUwjie/xrGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730889803; c=relaxed/simple;
	bh=Edkbbb4tcN3wNLpoj3JeRWNG8hFSMldUEMsJqgCzuE8=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=WkihbwUeli/q5adG+TpMqT5voq0iCJWZPiZOWI0UWNugzcFMlmmJcgpo2+P5WRNQpXFavbxURTn8r0/N1gnU2FxjbTsYMDlr1QquTZCwNzckMD3UZPW8XjsmzuuKxq1v+zTWMxGcamUfNyPj3cXMfEKF6aGub3RDK+H2Tc/ioHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X0Hy/5fi; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730889802; x=1762425802;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Edkbbb4tcN3wNLpoj3JeRWNG8hFSMldUEMsJqgCzuE8=;
  b=X0Hy/5fiNdG/4TQDeSXcGUL2/oZXt/0P8Dp3kFKqSOmLEetnVsGkNG5u
   BhvpwyrEKFfuQ4t4Du2iWZ2O05JV6gllBvM6vlBrO8rvqnJzstIvQxGsE
   4ZXaUQKJrlWjOcLRKLBKWq+QQgfwUdy98mqV5sqUiVfEM6ENJ1AJaoR/P
   n3cDe/yUCldzG50iDdKP57Etick3hVgcsYd5p06FZBmuh5TJyO95v0GYt
   zotmd9oc7krsvm60UVP6sMo5PH/NtFZEdvbp5TqbREPKGA/mi338j24aV
   aJiKNgAlehzp0vq0+l2j+1AQarsfk1FYV7HXsR0UCp37q3ljPjQtHcz9q
   w==;
X-CSE-ConnectionGUID: gyWBUo08QsmHA38Dp/LpGQ==
X-CSE-MsgGUID: vMZ8YxbrTdaqT3aRniqeKA==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="30108718"
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="30108718"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 02:43:22 -0800
X-CSE-ConnectionGUID: 1PxrW8lKRESlek5xU+1fSw==
X-CSE-MsgGUID: Bu/bGMUtQkqrLFx9wsqN+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="84821792"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.240.228]) ([10.124.240.228])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 02:43:18 -0800
Message-ID: <032683aa-ddf1-43c2-9249-6e334d303e8a@linux.intel.com>
Date: Wed, 6 Nov 2024 18:43:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "eric.auger@redhat.com" <eric.auger@redhat.com>,
 "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
 "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
 "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
 "will@kernel.org" <will@kernel.org>
Subject: Re: [PATCH v4 04/13] iommu/vt-d: Add pasid replace helpers
To: "Tian, Kevin" <kevin.tian@intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
 "joro@8bytes.org" <joro@8bytes.org>, "jgg@nvidia.com" <jgg@nvidia.com>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-5-yi.l.liu@intel.com>
 <BN9PR11MB5276B9F6A5D42D30579E05E28C532@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d218eb1c-ca02-4975-bd6a-310a81b3d88c@intel.com>
 <BN9PR11MB52766A4A2C15C9C58F9513128C532@BN9PR11MB5276.namprd11.prod.outlook.com>
 <30114c7f-de39-4023-819f-134ee3b74467@intel.com>
 <BN9PR11MB52769251CB1CE4FFCF4E1DE68C532@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB52769251CB1CE4FFCF4E1DE68C532@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024/11/6 18:05, Tian, Kevin wrote:
>> From: Liu, Yi L<yi.l.liu@intel.com>
>> Sent: Wednesday, November 6, 2024 6:02 PM
>>
>> On 2024/11/6 17:51, Tian, Kevin wrote:
>>>> From: Liu, Yi L<yi.l.liu@intel.com>
>>>> Sent: Wednesday, November 6, 2024 5:31 PM
>>>>
>>>> On 2024/11/6 15:31, Tian, Kevin wrote:
>>>>>> From: Liu, Yi L<yi.l.liu@intel.com>
>>>>>> Sent: Monday, November 4, 2024 9:19 PM
>>>>>>
>>>>>> +
>>>>>> +	spin_lock(&iommu->lock);
>>>>>> +	pte = intel_pasid_get_entry(dev, pasid);
>>>>>> +	if (!pte) {
>>>>>> +		spin_unlock(&iommu->lock);
>>>>>> +		return -ENODEV;
>>>>>> +	}
>>>>>> +
>>>>>> +	if (!pasid_pte_is_present(pte)) {
>>>>>> +		spin_unlock(&iommu->lock);
>>>>>> +		return -EINVAL;
>>>>>> +	}
>>>>>> +
>>>>>> +	old_did = pasid_get_domain_id(pte);
>>>>> probably should pass the old domain in and check whether the
>>>>> domain->did is same as the one in the pasid entry and warn otherwise.
>>>> this would be a sw bug. 🙂 Do we really want to catch every bug by warn? 🙂
>>>>
>>> this one should not happen. If it does, something severe jumps out...
>> yes. that's why I doubt if it's valuable to do it. It should be a vital
>> bug that bring us this warn. or instead of passing id old domain, how
>> about just old_did? We use the passed in did instead of using the did
>> from pte.
>>
> My personal feeling - it's worth as such rare bug once happening
> would be very difficult to debug. the warning provides useful hint.

Agreed!

