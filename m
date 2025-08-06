Return-Path: <kvm+bounces-54080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C32EB1BEE0
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 04:44:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 15EDA189F9E7
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 02:44:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2EF01C862D;
	Wed,  6 Aug 2025 02:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DlOcXnww"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F9224B29;
	Wed,  6 Aug 2025 02:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754448256; cv=none; b=afE53b3eiQW09W7DWRA1x96s7NMJNMquI+5NUc5IV2yvV+NwMZiRPI/aWUbsd8I8ONg769Bs2Y6S0aq263DX3pbH7zlabQVtpLHTVCzIlDcoYTrLLFYgNTqYSDhXv+VyJd6au2SfWjSerTM5HGIaosPDkXM3RN7cuhLgQ+j12iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754448256; c=relaxed/simple;
	bh=9/kYiwVnEywEoZScpVLycI/TyZVjq+5sJkwzc/cyyYs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=myUDhlF/EFYuCzhCSHYIywCYgceGupmQuWi+2h9T5NQt/8W7HyrVwPN+K2B195hHAMpMONUSh8PjfkVCBPNVJcjcKUIlixw54bBN9hqouIuIS5W6760N9kHCCYr42LpKrWMzgXvVpnJZksuq73P7UZT6o4KPxYNRFKSXIxBfBAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DlOcXnww; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754448254; x=1785984254;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9/kYiwVnEywEoZScpVLycI/TyZVjq+5sJkwzc/cyyYs=;
  b=DlOcXnww7Epk5rUQ7jbjzRjX0a2Y0Z688pVqwGXa5hhF+AROPj0TJU3h
   RQz/Sbs2mgU9Nr6xPzeX0PyfTq/TtztJ5T2UQhPr09M7/QtQwj3SxE2CO
   T8diW86EP1LTL3o7CAppP/R+HDw4X2P9EBVkTn09QLkaotSLUjcaiIutV
   1VzDhjvNcy5sDEkX18LlUtOhPdKYk4OlriPQJkTVK9RP4Qmxr87t8srNu
   noVwixlE2asjTkfcAzPmZY9WygkATfuqP7bLWwurNCrkZLtl9M5fsK1Mo
   GmP20I2CkBLiWEo2X1t8X4b1w/q56+s4h/B89u63iRnpRL/2C66DftzAP
   Q==;
X-CSE-ConnectionGUID: iD6KIyY6TpSIAmEbWgawOA==
X-CSE-MsgGUID: tYoxKy1tTl+jiYHCAQQyaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11513"; a="44350426"
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="44350426"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2025 19:44:13 -0700
X-CSE-ConnectionGUID: 0BEB7fFLQ9SQKUXTm0rlBw==
X-CSE-MsgGUID: HwyNf/pMQmi/ZaVZ8nHq9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="164559636"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2025 19:44:10 -0700
Message-ID: <3abaf43b-0b81-46e9-a313-0120d30541cc@linux.intel.com>
Date: Wed, 6 Aug 2025 10:41:41 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/16] Fix incorrect iommu_groups with PCIe ACS
To: Ethan Zhao <etzhao1900@gmail.com>, Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
 <a692448d-48b8-4af3-bf88-2cc913a145ca@gmail.com>
 <20250802151816.GC184255@nvidia.com>
 <1684792a-97d6-4383-a0d2-f342e69c91ff@gmail.com>
 <20250805123555.GI184255@nvidia.com>
 <964c8225-d3fc-4b60-9ee5-999e08837988@gmail.com>
 <20250805144301.GO184255@nvidia.com>
 <6ca56de5-01df-4636-9c6a-666ccc10b7ff@gmail.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <6ca56de5-01df-4636-9c6a-666ccc10b7ff@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/6/25 10:22, Ethan Zhao wrote:
> On 8/5/2025 10:43 PM, Jason Gunthorpe wrote:
>> On Tue, Aug 05, 2025 at 10:41:03PM +0800, Ethan Zhao wrote:
>>
>>>>> My understanding, iommu has no logic yet to handle the egress control
>>>>> vector configuration case,
>>>>
>>>> We don't support it at all. If some FW leaves it configured then it
>>>> will work at the PCI level but Linux has no awarness of what it is
>>>> doing.
>>>>
>>>> Arguably Linux should disable it on boot, but we don't..
>>> linux tool like setpci could access PCIe configuration raw data, so
>>> does to the ACS control bits. that is boring.
>>
>> Any change to ACS after boot is "not supported" - iommu groups are one
>> time only using boot config only. If someone wants to customize ACS
>> they need to use the new config_acs kernel parameter.
> That would leave ACS to boot time configuration only. Linux never
> limits tools to access(write) hardware directly even it could do that.
> Would it be better to have interception/configure-able policy for such
> hardware access behavior in kernel like what hypervisor does to MSR etc ?

A root user could even clear the BME or MSE bits of a device's PCIe
configuration space, even if the device is already bound to a driver and
operating normally. I don't think there's a mechanism to prevent that
from happening, besides permission enforcement. I believe that the same
applies to the ACS control.

>>
>>>>> The static groups were created according to
>>>>> FW DRDB tables,
>>>>
>>>> ?? iommu_groups have nothing to do with FW tables.
>>> Sorry, typo, ACPI drhd table.
>>
>> Same answer, AFAIK FW tables have no effect on iommu_groups 
> My understanding, FW tables are part of the description about device 
> topology and iommu-device relationship. did I really misunderstand
> something ?

The ACPI/DMAR table describes the platform's IOMMU topology, not the
device topology, which is described by the PCI bus. So, the firmware
table doesn't impact the iommu_group.

Thanks,
baolu

