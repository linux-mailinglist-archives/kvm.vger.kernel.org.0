Return-Path: <kvm+bounces-31830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5550D9C7F8C
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 01:53:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1ACE4284429
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 00:53:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A80C717555;
	Thu, 14 Nov 2024 00:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HXgxwhVo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05574EAD0;
	Thu, 14 Nov 2024 00:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731545577; cv=none; b=Kzt5vDHdW1EIFajYhBwtJw7szDsDzcSlIch4lVGMxNATgKxmJkgCCTuU1gl7IkdtF2KID5KeXoQWjjQt0o2JTCUOJfqrc0LANsuy8mf6nxSjq5LeydWGlltcQOdEeZNEr5E9LtT2a+FUkCF1y/0RlrFbrnnh+qvQ/eT1UARwYXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731545577; c=relaxed/simple;
	bh=h5sSTsp24D65G2XFtPO48h/kyNuKIpKzlGZiJU4kZtI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s+J6J4OA7bGyTegoWrWLVIYYNDHeDqAQQfoV5csxeICJW5fLMuo8cMVbk5dmsBkOZ8tsMzPq/BUZFoTOFkdcavMTPaLjVLoX5hKA4EpZMDHeWRWLVmiH7Y1rqjirE6yUjwv4O+kDxWJekY7bC5EOUKMeIMWzqiwoHIVq/1Q2QmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HXgxwhVo; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731545575; x=1763081575;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=h5sSTsp24D65G2XFtPO48h/kyNuKIpKzlGZiJU4kZtI=;
  b=HXgxwhVoBw/zASnAPqRIXt0MYIdAwLWtZhdPo7/siW6C2ma5CR0WiQKF
   8Jp1qN5PyLz5RKoXYlYoblhLvB7/hzuoAV+A7MiX7H0UghusopWho3r3e
   N5YmtXM25Hn2omlfQ/mbT4XROwhPiI4B/OzWimaBDDMhEzctjOKjqcR76
   6YBufEaMp+Tku36IZgxldhBm+NLtkBc8saf00z5NqPkRrPUC85lyA3ubL
   YN/PlIjxWKv9329V/O5EeVQ2vUDn1xNNgiMAEUinSkVyvWKW5nv7yFZ3L
   xgCMk4wDDItX3fKDjZlqdEasMV378owdE7WC3aDjOfXGAw6KlPAkKdNcB
   w==;
X-CSE-ConnectionGUID: Ra3hAOmQSuCWeHUtMhwE5Q==
X-CSE-MsgGUID: HPhzAt4sQKObYPXSG24nVw==
X-IronPort-AV: E=McAfee;i="6700,10204,11255"; a="42879455"
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="42879455"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 16:52:54 -0800
X-CSE-ConnectionGUID: CE2x8RESTWyiyF9dktIJzw==
X-CSE-MsgGUID: VspIz9jaRZigJjTinNKxEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="88020775"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 16:52:48 -0800
Message-ID: <6ed97a10-853f-429e-8506-94b218050ad3@linux.intel.com>
Date: Thu, 14 Nov 2024 08:51:47 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/12] Initial support for SMMUv3 nested translation
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Zhangfei Gao <zhangfei.gao@linaro.org>, acpica-devel@lists.linux.dev,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
 Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Robert Moore <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>,
 Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Donald Dutile <ddutile@redhat.com>, Eric Auger <eric.auger@redhat.com>,
 Hanjun Guo <guohanjun@huawei.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Jerry Snitselaar <jsnitsel@redhat.com>, Moritz Fischer <mdf@kernel.org>,
 Michael Shavit <mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>,
 patches@lists.linux.dev, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
 Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 Mostafa Saleh <smostafa@google.com>
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <20241112182938.GA172989@nvidia.com>
 <CABQgh9HOHzeRF7JfrXrRAcGB53o29HkW9rnVTf4JefeVWDvzyQ@mail.gmail.com>
 <20241113012359.GB35230@nvidia.com>
 <9df3dd17-375a-4327-b2a8-e9f7690d81b1@linux.intel.com>
 <20241113164316.GL35230@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20241113164316.GL35230@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/14/24 00:43, Jason Gunthorpe wrote:
> On Wed, Nov 13, 2024 at 10:55:41AM +0800, Baolu Lu wrote:
>> On 11/13/24 09:23, Jason Gunthorpe wrote:
>>>> https://github.com/Linaro/linux-kernel-uadk/tree/6.12-wip
>>>> https://github.com/Linaro/qemu/tree/6.12-wip
>>>>
>>>> Still need this hack
>>>> https://github.com/Linaro/linux-kernel-uadk/commit/
>>>> eaa194d954112cad4da7852e29343e546baf8683
>>>>
>>>> One is adding iommu_dev_enable/disable_feature IOMMU_DEV_FEAT_SVA,
>>>> which you have patchset before.
>>> Yes, I have a more complete version of that here someplace. Need some
>>> help on vt-d but hope to get that done next cycle.
>>
>> Can you please elaborate this a bit more? Are you talking about below
>> change
> 
> I need your help to remove IOMMU_DEV_FEAT_IOPF from the intel
> driver. I have a patch series that eliminates it from all the other
> drivers, and I wrote a patch to remove FEAT_SVA from intel..

Yes, sure. Let's make this happen in the next cycle.

FEAT_IOPF could be removed. IOPF manipulation can be handled in the
domain attachment path. A per-device refcount can be implemented. This
count increments with each iopf-capable domain attachment and decrements
with each detachment. PCI PRI is enabled for the first iopf-capable
domain and disabled when the last one is removed. Probably we can also
solve the PF/VF sharing PRI issue.

With iopf moved to the domain attach path and hardware capability checks
to the SVA domain allocation path, FEAT_SVA becomes essentially a no-op.

> 
>> +	ret = iommu_dev_enable_feature(idev->dev, IOMMU_DEV_FEAT_SVA);
>> +	if (ret)
>> +		return ret;
>>
>> in iommufd_fault_iopf_enable()?
>>
>> I have no idea about why SVA is affected when enabling iopf.
> 
> It is ARM not implementing the API correctly. Only SVA turns on the
> page fault reporting mechanism.
> 
> In the new world the page fault reporting should be managed during
> domain attachment. If the domain is fault capable then faults should
> be delivered to that domain. That is the correct time to setup the
> iopf mechanism as well.
> 
> So I fixed that and now ARM and AMD both have no-op implementations of
> IOMMU_DEV_FEAT_IOPF and IOMMU_DEV_FEAT_SVA. Thus I'd like to remove it
> entirely.

Thank you for the explanation.

--
baolu

