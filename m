Return-Path: <kvm+bounces-39082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C678FA434DE
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 07:00:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 817B93B69AD
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 06:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57F57256C68;
	Tue, 25 Feb 2025 06:00:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252771DFDE;
	Tue, 25 Feb 2025 06:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740463228; cv=none; b=qi0zGObUukYdQ4d4JeS3aRBlqKHfjrHHh2xG/69yDYgdnrPb/LkmvLUrOt22BNb5dLnBvoGB7TvWriLzMWp32LKoWAbnmHkdXoZ+qFwLANK3AYPrel6m8Ta/DRqDN7TELQp+AFRG8eiTy7t/D4BDqsv7fHSGBVz7eNRh/yjQwLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740463228; c=relaxed/simple;
	bh=GiCntbztcJoYYRu+cvSL1nLThkSKrwrJZdfQBGs+u14=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=bQZvg+CGlTp1IzFFXYPIQp1zfgAs2pjSrEoYvcShB52gGBM03tS7rf0hsg0UQip7SKw9osnV1GQR1jpYQaFD50DqSy95U0ZhVdR40dbSyItbxYDoFchyRWMYz1IOPBFdDXE4LloqIyc4fZHk4uhthgoDYJ+3qfHsMZe6BgZErls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Z26M147Hlz21p6T;
	Tue, 25 Feb 2025 13:57:17 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id A3B231401F3;
	Tue, 25 Feb 2025 14:00:21 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemg500006.china.huawei.com (7.202.181.43) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 25 Feb 2025 14:00:21 +0800
Subject: Re: [PATCH 1/3] migration: update BAR space size
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, Jonathan Cameron <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
References: <20250218021507.40740-1-liulongfang@huawei.com>
 <20250218021507.40740-2-liulongfang@huawei.com>
 <e756bb3a8ee94cf78a28231afb1eeb92@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <dc5c2f1a-181e-4f91-0f8a-ede622b9d1dc@huawei.com>
Date: Tue, 25 Feb 2025 14:00:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <e756bb3a8ee94cf78a28231afb1eeb92@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemg500006.china.huawei.com (7.202.181.43)

On 2025/2/18 18:20, Shameerali Kolothum Thodi wrote:
> 
> 
>> -----Original Message-----
>> From: liulongfang <liulongfang@huawei.com>
>> Sent: Tuesday, February 18, 2025 2:15 AM
>> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
>> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
>> <jonathan.cameron@huawei.com>
>> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
>> Subject: [PATCH 1/3] migration: update BAR space size
>>
>> On the new hardware platform, the live migration configuration region
>> is moved from VF to PF. The VF's own configuration space is
>> restored to the complete 64KB, and there is no need to divide the
>> size of the BAR configuration space equally.
>>
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> ---
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 41 +++++++++++++++----
>>  1 file changed, 32 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> index 451c639299eb..599905dbb707 100644
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> @@ -1195,6 +1195,33 @@ static struct hisi_qm *hisi_acc_get_pf_qm(struct
>> pci_dev *pdev)
>>  	return !IS_ERR(pf_qm) ? pf_qm : NULL;
>>  }
>>
>> +static size_t hisi_acc_get_resource_len(struct vfio_pci_core_device *vdev,
>> +					unsigned int index)
>> +{
>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>> +			hisi_acc_drvdata(vdev->pdev);
>> +
>> +	/*
>> +	 * ACC VF dev 64KB BAR2 region consists of both functional
>> +	 * register space and migration control register space, each
>> +	 * uses 32KB BAR2 region, on the system with more than 64KB
>> +	 * page size, even if the migration control register space
>> +	 * is written by VM, it will only affects the VF.
>> +	 *
>> +	 * In order to support the live migration function in the
>> +	 * system with a page size above 64KB, the driver needs
>> +	 * to ensure that the VF region size is aligned with the
>> +	 * system page size.
> 
> I didn't get this. Are you referring to kernel with 64K page size? And this is 
> for new hardware or QM_HW_V3 one?
>

This 64KB page refers to the 64KB page size of BAR2.
If the configuration space of the live migration device is not
aligned to the 64KB page (for example, only 32KB on the QM_HW_V3 platform),
when the host kernel page is 64KB, multiple VF devices will fail during VFIO
enumeration.
Therefore, on the new hardware platform, the live migration configuration
space is moved to the PF, which can align the 64KB memory space and solve
this problem.

>> +	 *
>> +	 * On the new hardware platform, the live migration control register
>> +	 * has been moved from VF to PF.
>> +	 */
>> +	if (hisi_acc_vdev->pf_qm->ver == QM_HW_V3)
>> +		return (pci_resource_len(vdev->pdev, index) >> 1);
>> +
>> +	return pci_resource_len(vdev->pdev, index);
>> +}
>> +
>>  static int hisi_acc_pci_rw_access_check(struct vfio_device *core_vdev,
>>  					size_t count, loff_t *ppos,
>>  					size_t *new_count)
>> @@ -1205,8 +1232,9 @@ static int hisi_acc_pci_rw_access_check(struct
>> vfio_device *core_vdev,
>>
>>  	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
>>  		loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
>> -		resource_size_t end = pci_resource_len(vdev->pdev, index) /
>> 2;
>> +		resource_size_t end;
>>
>> +		end = hisi_acc_get_resource_len(vdev, index);
>>  		/* Check if access is for migration control region */
>>  		if (pos >= end)
>>  			return -EINVAL;
>> @@ -1227,8 +1255,9 @@ static int hisi_acc_vfio_pci_mmap(struct
>> vfio_device *core_vdev,
>>  	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
>>  	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
>>  		u64 req_len, pgoff, req_start;
>> -		resource_size_t end = pci_resource_len(vdev->pdev, index) /
>> 2;
>> +		resource_size_t end;
>>
>> +		end = PAGE_ALIGN(hisi_acc_get_resource_len(vdev, index));
> 
> So here, the whole BAR2 will be mapped to Guest in case of QM_HW_V3 &&
> 64K kernel as well, right?
>


Here, the length of BAR2 is mapped to the Guest OS according to the actual
situation of the platform. If it is QM_HW_V3, only 32KB is mapped.
Others are mapped 64KB.

Thanks.

> Thanks,
> Shameer
> 
>>  		req_len = vma->vm_end - vma->vm_start;
>>  		pgoff = vma->vm_pgoff &
>>  			((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
>> @@ -1275,7 +1304,6 @@ static long hisi_acc_vfio_pci_ioctl(struct
>> vfio_device *core_vdev, unsigned int
>>  	if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
>>  		struct vfio_pci_core_device *vdev =
>>  			container_of(core_vdev, struct vfio_pci_core_device,
>> vdev);
>> -		struct pci_dev *pdev = vdev->pdev;
>>  		struct vfio_region_info info;
>>  		unsigned long minsz;
>>
>> @@ -1290,12 +1318,7 @@ static long hisi_acc_vfio_pci_ioctl(struct
>> vfio_device *core_vdev, unsigned int
>>  		if (info.index == VFIO_PCI_BAR2_REGION_INDEX) {
>>  			info.offset =
>> VFIO_PCI_INDEX_TO_OFFSET(info.index);
>>
>> -			/*
>> -			 * ACC VF dev BAR2 region consists of both
>> functional
>> -			 * register space and migration control register
>> space.
>> -			 * Report only the functional region to Guest.
>> -			 */
>> -			info.size = pci_resource_len(pdev, info.index) / 2;
>> +			info.size = hisi_acc_get_resource_len(vdev,
>> info.index);
>>
>>  			info.flags = VFIO_REGION_INFO_FLAG_READ |
>>  					VFIO_REGION_INFO_FLAG_WRITE |
>> --
>> 2.24.0
> 
> .
> 

