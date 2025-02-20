Return-Path: <kvm+bounces-38679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 16FD4A3D928
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 12:49:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 871A9188D6C8
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 11:49:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5C101F3FF5;
	Thu, 20 Feb 2025 11:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PLwi2UjO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2741F1510;
	Thu, 20 Feb 2025 11:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740052153; cv=none; b=F33yGrOV43lc6wpZBvzrlym1OlGBYESHE/uvew7jWYEmf6gp6FNQiJdInBli9UTekogQAWaA8EAhv3rALk+kXcM+2jsJMzt8AUqmvUdr5m1zEowhb0U/geS7yVpE18eyZngcgubtCr0IBKU1yRZX9WnMnfs0hlxrKEB2miR6VsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740052153; c=relaxed/simple;
	bh=/wqrT11uk28gB2f6F7P7h24DAJ2UTfq0Tb/FDk+sJtw=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=g854alnbVmJFlgBohPw63pHJVM5Fyj6hNVciowFk2/RPO1C1iJKt7SBgwm4cvofgMguJcsjFZQAH82k97RGMGq3QeWboGLgj7p2OIlU9/FQV/42K0vHNdHWCqViki0Da2odwLo5e4xZ/FNGzxqxcdZJCvy3EzCUIcU787ERkJIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PLwi2UjO; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740052153; x=1771588153;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/wqrT11uk28gB2f6F7P7h24DAJ2UTfq0Tb/FDk+sJtw=;
  b=PLwi2UjOyH4L3sC1kaKjQPq0kOtzeINBYEvAYZ1AeflO3B51vIWFn/+a
   5rdcv7NBhdHKQebSzM0nWOPSZ64UeT52LyE3oYYo2biaO59fFgMnlhmBW
   S2H/t06J1GVr4XxD19CcqKppHjDFjNRgmjQczo9ZVTIGSfG6G46dDGuUD
   4nhXfeFIgn0BEhPaStAERq/ORdAkJx7csN+tFuM6j6cRIMX+jJIuJjGes
   iyEcOLc0DBoeQ1+QTJ7psu0P23HtIdVpN9SALv7w75NiLsxeV+8ah9DM9
   NxQcPdj1Uh0KMPs9MiHgw61HTjjjZCfYUw789gpzwg+TlGHLMezZpnMIN
   Q==;
X-CSE-ConnectionGUID: AqtslgcmRJe1lFKZa/FkxA==
X-CSE-MsgGUID: xCG4tfT6RfWu3FQjw7vsnA==
X-IronPort-AV: E=McAfee;i="6700,10204,11350"; a="40840582"
X-IronPort-AV: E=Sophos;i="6.13,301,1732608000"; 
   d="scan'208";a="40840582"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 03:49:12 -0800
X-CSE-ConnectionGUID: lBRoIMKBRlCv4wpxJyJpYQ==
X-CSE-MsgGUID: e1CJ07BvRDSfCLalEtB1Ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,301,1732608000"; 
   d="scan'208";a="120000397"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.240.48]) ([10.124.240.48])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 03:49:04 -0800
Message-ID: <c57977e2-d109-4a38-903e-8af6a7567a60@linux.intel.com>
Date: Thu, 20 Feb 2025 19:49:01 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, Zhangfei Gao <zhangfei.gao@linaro.org>,
 "acpica-devel@lists.linux.dev" <acpica-devel@lists.linux.dev>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
 Joerg Roedel <joro@8bytes.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 Len Brown <lenb@kernel.org>,
 "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 "Moore, Robert" <robert.moore@intel.com>, Robin Murphy
 <robin.murphy@arm.com>, Sudeep Holla <sudeep.holla@arm.com>,
 Will Deacon <will@kernel.org>, Alex Williamson <alex.williamson@redhat.com>,
 Donald Dutile <ddutile@redhat.com>, Eric Auger <eric.auger@redhat.com>,
 Hanjun Guo <guohanjun@huawei.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Jerry Snitselaar <jsnitsel@redhat.com>, Moritz Fischer <mdf@kernel.org>,
 Michael Shavit <mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>,
 "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
 Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v4 00/12] Initial support for SMMUv3 nested translation
To: "Tian, Kevin" <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
References: <20241113164316.GL35230@nvidia.com>
 <6ed97a10-853f-429e-8506-94b218050ad3@linux.intel.com>
 <20241115175522.GA35230@nvidia.com> <20250122192622.GA965540@nvidia.com>
 <284dd081-8d53-45ef-ae18-78b0388c98ca@linux.intel.com>
 <f7b6c833-b6c1-4154-9b77-13553e501f2b@linux.intel.com>
 <20250213184317.GB3886819@nvidia.com>
 <bc9f4477-7976-4955-85dc-3e05ebe95ead@linux.intel.com>
 <20250214124150.GF3886819@nvidia.com>
 <58e7fbee-6688-4a49-8b7a-f0e81e6562db@linux.intel.com>
 <20250218130333.GA4099685@nvidia.com>
 <f7e30bd8-ae1f-42fe-a8a6-2b448a474044@linux.intel.com>
 <BN9PR11MB5276EAD07C3B32517D339DF28CC52@BN9PR11MB5276.namprd11.prod.outlook.com>
 <7027fb3a-dfb4-40ae-ac9c-5ea1dcd57746@linux.intel.com>
 <BN9PR11MB52764E131435DF44370653CD8CC42@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB52764E131435DF44370653CD8CC42@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/2/20 14:51, Tian, Kevin wrote:
>> From: Baolu Lu<baolu.lu@linux.intel.com>
>> Sent: Thursday, February 20, 2025 10:11 AM
>>
>> On 2/19/25 16:34, Tian, Kevin wrote:
>>>> From: Baolu Lu<baolu.lu@linux.intel.com>
>>>> Sent: Wednesday, February 19, 2025 10:10 AM
>>>>
>>>> On 2/18/25 21:03, Jason Gunthorpe wrote:
>>>>> On Sat, Feb 15, 2025 at 05:53:13PM +0800, Baolu Lu wrote:
>>>>>> On 2/14/25 20:41, Jason Gunthorpe wrote:
>>>>>>> On Fri, Feb 14, 2025 at 01:39:52PM +0800, Baolu Lu wrote:
>>>>>>>
>>>>>>>> When the IOMMU is working in scalable mode, PASID and PRI are
>>>> supported.
>>>>>>>> ATS will always be enabled, even if the identity domain is attached to
>>>>>>>> the device, because the PASID might use PRI, which depends on ATS
>>>>>>>> functionality. This might not be the best choice, but it is the
>>>>>>>> simplest and functional.
>>>>>>> The arm driver keeps track of things and enables ATS when PASIDs are
>>>>>>> present
>>>>>> I am not aware of any VT-d hardware implementation that supports
>>>>>> scalable mode but not PASID. If there were one, it would be worthwhile
>>>>>> to add an optimization to avoid enabling ATS during probe if PASID is
>>>>>> not supported.
>>>>> I mean domains attached to PASIDs that need PRI/ATS/etc
>>>> Yeah, that's a better solution. The PCI PRI/ATS features are only
>>>> enabled when a domain that requires them is attached to it. I will
>>>> consider it in the Intel driver later.
>>>>
>>> I didn't get the connection here. ATS can run w/o PASID per PCIe
>>> spec. Why do we want to add a dependency on PASID here?
>> It's due to PRI, which depends on ATS. The original topic is: when an
>> identity domain is attached to the device and the device has no PASID
>> support, then ATS might be disabled because ATS isn't supposed to
>> provide much benefit in this case.
> PRI depends on ATS but PASID is optional.
> 
> ATS has no benefit (or even more cost) with identity domain but again
> it has nothing to do with PASID.
> 
>> Otherwise, ATS should be enabled because:
>>
>> - It benefits performance when the domain is a paging domain.
>> - A domain attached to a PASID might use PRI, thus requiring ATS to be
>>     on.
> Above talks about the domain type. Nothing specific to PASID.
> 
>> The proposed solution is to use a reference count for ATS enablement,
>> similar to how we handle iopf in another series. ATS is enabled as long
>> as any domain requires it and disabled if no domain requires it.
>>
> I'm fine with using reference count for ATS enablement based on
> the domain type, but just didn't get the role of PASID in this discussion.

Sorry that I didn't make it clear. Let me try again.

PASID is mentioned in this discussion because it makes things different.

Without PASID support, only a single domain is attached to the device.
ATS enablement can then be determined based on the domain type.
Specifically:

- For an identity domain, ATS could be disabled.
- For other domains, ATS is enabled.

With PASID support, multiple domains can be attached to the device, and
each domain may have different ATS requirements.  Therefore, we cannot
simply determine the ATS status in the RID domain attach/detach paths. A
better solution is to use the reference count, as mentioned above.

Thanks,
baolu

