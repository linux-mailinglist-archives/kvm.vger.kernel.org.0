Return-Path: <kvm+bounces-53944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A1129B1AAFA
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 00:33:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A01518A3495
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 22:34:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 726B5290D85;
	Mon,  4 Aug 2025 22:33:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C12FF24469E
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 22:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754346812; cv=none; b=Jzi1YhCu6bzfg50Dt3wDO+vl8gPguNy7WhcYMOOAPnjiqoIwE/HoKyyOnrkKjvXvF6LgHveBQyxt/EW8ayYWChqidGxaRfVHeWPout2VutpnFm9lgCh2IU6AjKddVvQjSVE8n3+S3UR0xmsQwfVOJdZpqSD/MB1eesbyDvvDMog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754346812; c=relaxed/simple;
	bh=NA5sV2NlM/4MwyTHD9LYT5Oy+9/XpWpvjRh/HCuvcbQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ofkQ5zEcD/UF1ToED5PTeBey+w7Ud0NGQ76jUbYcvdXSc/gKvh87Wtq/NsDyZrdJCeuD+QnALAt/17VPAId8t3DUqqYRr5NKLXVLfisumzOx6RfaEn83mBduar1mIbYb+cAhOL7cz2Rq7EhPYnG9tLDbUdG+/va0G0MDsF2lijg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1CFF91E4D;
	Mon,  4 Aug 2025 15:33:21 -0700 (PDT)
Received: from [10.57.5.104] (unknown [10.57.5.104])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 56D5E3F673;
	Mon,  4 Aug 2025 15:33:28 -0700 (PDT)
Message-ID: <f3b39fdc-e063-4d47-95dd-d4158f139053@arm.com>
Date: Mon, 4 Aug 2025 23:33:27 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH kvmtool 09/10] vfio/iommufd: Add viommu and vdevice
 objects
Content-Language: en-GB
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Will Deacon <will@kernel.org>
Cc: kvm@vger.kernel.org, Steven Price <steven.price@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
 <20250525074917.150332-9-aneesh.kumar@kernel.org>
 <aH4yMUWTuVtgqD7T@willie-the-truck> <yq5att31brz2.fsf@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <yq5att31brz2.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24/07/2025 15:09, Aneesh Kumar K.V wrote:
> Will Deacon <will@kernel.org> writes:
> 
>> On Sun, May 25, 2025 at 01:19:15PM +0530, Aneesh Kumar K.V (Arm) wrote:
>>> This also allocates a stage1 bypass and stage2 translate table.
>>
>> Please write your commit messages as per Linux kernel guidelines.
>>
>>> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
>>> ---
>>>   builtin-run.c            |   2 +
>>>   include/kvm/kvm-config.h |   1 +
>>>   vfio/core.c              |   4 +-
>>>   vfio/iommufd.c           | 115 ++++++++++++++++++++++++++++++++++++++-
>>
>> [...]
>>
>>>   4 files changed, 119 insertions(+), 3 deletions(-)
>>> diff --git a/vfio/iommufd.c b/vfio/iommufd.c
>>> index 742550705746..39870320e4ac 100644
>>> --- a/vfio/iommufd.c
>>> +++ b/vfio/iommufd.c
>>> @@ -108,6 +108,116 @@ err_out:
>>>   	return ret;
>>>   }
>>>   
>>> +static int iommufd_alloc_s1bypass_hwpt(struct vfio_device *vdev)
>>> +{
>>> +	int ret;
>>> +	unsigned long dev_num;
>>> +	unsigned long guest_bdf;
>>> +	struct vfio_device_bind_iommufd bind;
>>> +	struct vfio_device_attach_iommufd_pt attach_data;
>>> +	struct iommu_hwpt_alloc alloc_hwpt;
>>> +	struct iommu_viommu_alloc alloc_viommu;
>>> +	struct iommu_hwpt_arm_smmuv3 bypass_ste;
>>> +	struct iommu_vdevice_alloc alloc_vdev;
>>> +
>>> +	bind.argsz = sizeof(bind);
>>> +	bind.flags = 0;
>>> +	bind.iommufd = iommu_fd;
>>> +
>>> +	/* now bind the iommufd */
>>> +	if (ioctl(vdev->fd, VFIO_DEVICE_BIND_IOMMUFD, &bind)) {
>>> +		ret = -errno;
>>> +		vfio_dev_err(vdev, "failed to get info");
>>> +		goto err_out;
>>> +	}
>>> +
>>> +	alloc_hwpt.size = sizeof(struct iommu_hwpt_alloc);
>>> +	alloc_hwpt.flags = IOMMU_HWPT_ALLOC_NEST_PARENT;
>>> +	alloc_hwpt.dev_id = bind.out_devid;
>>> +	alloc_hwpt.pt_id = ioas_id;
>>> +	alloc_hwpt.data_type = IOMMU_HWPT_DATA_NONE;
>>> +	alloc_hwpt.data_len = 0;
>>> +	alloc_hwpt.data_uptr = 0;
>>> +
>>> +	if (ioctl(iommu_fd, IOMMU_HWPT_ALLOC, &alloc_hwpt)) {
>>> +		ret = -errno;
>>> +		pr_err("Failed to allocate HWPT");
>>> +		goto err_out;
>>> +	}
>>> +
>>> +	attach_data.argsz = sizeof(attach_data);
>>> +	attach_data.flags = 0;
>>> +	attach_data.pt_id = alloc_hwpt.out_hwpt_id;
>>> +
>>> +	if (ioctl(vdev->fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &attach_data)) {
>>> +		ret = -errno;
>>> +		vfio_dev_err(vdev, "failed to attach to IOAS ");
>>> +		goto err_out;
>>> +	}
>>> +
>>> +	alloc_viommu.size = sizeof(alloc_viommu);
>>> +	alloc_viommu.flags = 0;
>>> +	alloc_viommu.type = IOMMU_VIOMMU_TYPE_ARM_SMMUV3;
>>> +	alloc_viommu.dev_id = bind.out_devid;
>>> +	alloc_viommu.hwpt_id = alloc_hwpt.out_hwpt_id;
>>> +
>>> +	if (ioctl(iommu_fd, IOMMU_VIOMMU_ALLOC, &alloc_viommu)) {
>>> +		ret = -errno;
>>> +		vfio_dev_err(vdev, "failed to allocate VIOMMU %d", ret);
>>> +		goto err_out;
>>> +	}
>>> +#define STRTAB_STE_0_V			(1UL << 0)
>>> +#define STRTAB_STE_0_CFG_S2_TRANS	6
>>> +#define STRTAB_STE_0_CFG_S1_TRANS	5
>>> +#define STRTAB_STE_0_CFG_BYPASS		4
>>> +
>>> +	/* set up virtual ste as bypass ste */
>>> +	bypass_ste.ste[0] = STRTAB_STE_0_V | (STRTAB_STE_0_CFG_BYPASS << 1);
>>> +	bypass_ste.ste[1] = 0x0UL;
>>> +
>>> +	alloc_hwpt.size = sizeof(struct iommu_hwpt_alloc);
>>> +	alloc_hwpt.flags = 0;
>>> +	alloc_hwpt.dev_id = bind.out_devid;
>>> +	alloc_hwpt.pt_id = alloc_viommu.out_viommu_id;
>>> +	alloc_hwpt.data_type = IOMMU_HWPT_DATA_ARM_SMMUV3;
>>> +	alloc_hwpt.data_len = sizeof(bypass_ste);
>>> +	alloc_hwpt.data_uptr = (unsigned long)&bypass_ste;
>>> +
>>> +	if (ioctl(iommu_fd, IOMMU_HWPT_ALLOC, &alloc_hwpt)) {
>>> +		ret = -errno;
>>> +		pr_err("Failed to allocate S1 bypass HWPT %d", ret);
>>> +		goto err_out;
>>> +	}
>>> +
>>> +	alloc_vdev.size = sizeof(alloc_vdev),
>>> +	alloc_vdev.viommu_id = alloc_viommu.out_viommu_id;
>>> +	alloc_vdev.dev_id = bind.out_devid;
>>> +
>>> +	dev_num = vdev->dev_hdr.dev_num;
>>> +	/* kvmtool only do 0 domain, 0 bus and 0 function devices. */
>>> +	guest_bdf = (0ULL << 32) | (0 << 16) | dev_num << 11 | (0 << 8);
>>
>> I don't understand this. Shouldn't the BDF correspond to the virtual
>> configuration space? That's not allocated until later, but just going
>> with 0 isn't going to work.
>>
>> What am I missing?
>>
> 
> As I understand it, kvmtool supports only bus 0 and does not allow
> multifunction devices. Based on that, I derived the guest BDF as follows
> (correcting what was wrong in the original patch):
> 
> guest_bdf = (0ULL << 16) | (0 << 8) | dev_num << 3 | (0 << 0);
> 
> Are you suggesting that this approach is incorrect, and that we can use
> a bus number other than 0?

To put this other way, the emulation of the configuration space is based
on the "dev_num". i.e., CFG address is converted to the offset and
mapped to the "dev_num". So I think what we have here is correct.

Suzuki


