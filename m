Return-Path: <kvm+bounces-50622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BA89AE787F
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 09:26:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01D3D3A38CB
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 07:25:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ADD31E5B63;
	Wed, 25 Jun 2025 07:26:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803771F9F51;
	Wed, 25 Jun 2025 07:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750836373; cv=none; b=T8XMbBW+e4U1dU6UNewbGtOgiIZpL3k5G8/pk2rZqu31ozvK1Wbzqc97gPWFwn28ug/VoaG35r5zSeOFpSnbYVB5pIGuG2HZUJil5c5qae5wC7HdDuxgMijl0ET3kCgCUvYzdghQcuEdqR4uryvOpgPUaw+LL8Of9GvOL8pXYBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750836373; c=relaxed/simple;
	bh=v5qrOwQLCu8zoibqZN3Xk22dHEesaX60PG3K++b3fYw=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=JGGjqeVTG3eRw3WUqKwkFBOEEiBIS+Bzfhh8P08Gh2DxDQ/cRyXMNyxOzk5ceqRLoliZUB4w6ZOhxeQptwg9B+4y09bBHIzURbjW/fZBgTAPfxx2VDlDmaM8NfQJAYOBysZ6XNr1xLveYij1PiTRNBG4zmsdZeGwuHBIJATJ2CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4bRtbQ245dz1d1q0;
	Wed, 25 Jun 2025 15:23:46 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id A95E1140258;
	Wed, 25 Jun 2025 15:26:06 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 25 Jun 2025 15:26:06 +0800
Subject: Re: [PATCH v4 1/3] migration: update BAR space size
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, Jonathan Cameron <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
References: <20250610063251.27526-1-liulongfang@huawei.com>
 <20250610063251.27526-2-liulongfang@huawei.com>
 <3ec5ffdee2f64c74a82093c06612f59b@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <e8ec5644-fe10-5a03-5386-fbec6d35ed61@huawei.com>
Date: Wed, 25 Jun 2025 15:26:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <3ec5ffdee2f64c74a82093c06612f59b@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2025/6/24 15:03, Shameerali Kolothum Thodi wrote:
> 
> 
>> -----Original Message-----
>> From: liulongfang <liulongfang@huawei.com>
>> Sent: Tuesday, June 10, 2025 7:33 AM
>> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
>> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
>> <jonathan.cameron@huawei.com>
>> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
>> Subject: [PATCH v4 1/3] migration: update BAR space size
>>
>> On the new hardware platform, the live migration configuration region
>> is moved from VF to PF. The VF's own configuration space is
>> restored to the complete 64KB, and there is no need to divide the
>> size of the BAR configuration space equally.
>>
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> ---
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 36 ++++++++++++++-----
>>  1 file changed, 27 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> index 2149f49aeec7..b16115f590fd 100644
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> @@ -1250,6 +1250,28 @@ static struct hisi_qm *hisi_acc_get_pf_qm(struct
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
>> +	 * On the old HW_V3 device, the ACC VF device BAR2
>> +	 * region encompasses both functional register space
>> +	 * and migration control register space.
>> +	 * only the functional region should be report to Guest.
>> +	 *
>> +	 * On the new HW device, the migration control register
>> +	 * has been moved to the PF device BAR2 region.
>> +	 * The VF device BAR2 is entirely functional register space.
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
>> @@ -1260,8 +1282,9 @@ static int hisi_acc_pci_rw_access_check(struct
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
>> @@ -1282,8 +1305,9 @@ static int hisi_acc_vfio_pci_mmap(struct
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
> I think I have commented on this before. The above PAGE_ALIGN will change the 
> behavior on HW_V3 with 64K PAGE_SIZE kernel. The end will become 64K which
> is not what we want on HW_V3. Could you please check that again.
>

OK, Continue to pass the actual length to the Guest.

Thanks,
Longfang.

> Thanks,
> Shameer
> 
>>  		req_len = vma->vm_end - vma->vm_start;
>>  		pgoff = vma->vm_pgoff &
>>  			((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
>> @@ -1330,7 +1354,6 @@ static long hisi_acc_vfio_pci_ioctl(struct
>> vfio_device *core_vdev, unsigned int
>>  	if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
>>  		struct vfio_pci_core_device *vdev =
>>  			container_of(core_vdev, struct vfio_pci_core_device,
>> vdev);
>> -		struct pci_dev *pdev = vdev->pdev;
>>  		struct vfio_region_info info;
>>  		unsigned long minsz;
>>
>> @@ -1345,12 +1368,7 @@ static long hisi_acc_vfio_pci_ioctl(struct
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

