Return-Path: <kvm+bounces-52438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A85AB0532D
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 09:29:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC38416A491
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 07:29:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0D6B2D5425;
	Tue, 15 Jul 2025 07:25:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0BA18CC13;
	Tue, 15 Jul 2025 07:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752564323; cv=none; b=FNEiOnuOZ5X08NrtfZlf4bUk40uPM0PzNwYA5uBSeyKls6huePn8M9PzvA+6IArO349vEGgW+b2jtrT2AQtfOyGOj1g8Z7giQ9spUdN/HuAbNRtaeuvkB15B5x5AP9H/Q/YB/tKeZF8vzkmLrrnJl03ZQq9mZJnUwDI+0LukkA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752564323; c=relaxed/simple;
	bh=mIoe7Yg945ug2fEX/gESM6Jlx2VTUiE4LDyKjQfRssY=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ajMgxnySBibSKAjfJFfav8jfClWHv04GGGIY1QYbBBw3kL9D2Z7y1wwODVvbaIDLoQcVHQEDvBKAUSOlE2A3ut6tE9CPiIM4+kTwTPAt0KOl6vrCs5GZalZhzkKg+R+NQoJ+AJXiTEM1Fr/+rd09en/KYiEalUv/SivS3Hwu7OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4bh9Zm2PdTzXfDH;
	Tue, 15 Jul 2025 15:20:48 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id C1696180B64;
	Tue, 15 Jul 2025 15:25:16 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 15 Jul 2025 15:25:16 +0800
Subject: Re: [PATCH v5 1/3] migration: update BAR space size
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, Jonathan Cameron <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
References: <20250630085402.7491-1-liulongfang@huawei.com>
 <20250630085402.7491-2-liulongfang@huawei.com>
 <b9579c5738f64e9c8e6488cc0492ee17@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <74673bae-191a-b17d-d0e8-01ad07cdf180@huawei.com>
Date: Tue, 15 Jul 2025 15:25:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <b9579c5738f64e9c8e6488cc0492ee17@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2025/7/8 16:02, Shameerali Kolothum Thodi wrote:
> 
> 
>> -----Original Message-----
>> From: liulongfang <liulongfang@huawei.com>
>> Sent: Monday, June 30, 2025 9:54 AM
>> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
>> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
>> <jonathan.cameron@huawei.com>
>> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
>> Subject: [PATCH v5 1/3] migration: update BAR space size
>>
>> On new platforms greater than QM_HW_V3, the live migration
>> configuration
>> region is moved from VF to PF. The VF's own configuration space is
>> restored to the complete 64KB, and there is no need to divide the
>> size of the BAR configuration space equally.
>>
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> ---
> 
> See one minor comment below.
> 
> LGTM:
> Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> 
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 36 ++++++++++++++-----
>>  1 file changed, 27 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> index 2149f49aeec7..1ddc9dbadb70 100644
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
>> +	 * On the old QM_HW_V3 device, the ACC VF device BAR2
>> +	 * region encompasses both functional register space
>> +	 * and migration control register space.
>> +	 * only the functional region should be report to Guest.
>> +	 *
>> +	 * On the new HW device, the migration control register
>> +	 * has been moved to the PF device BAR2 region.
>> +	 * The VF device BAR2 is entirely functional register space.
>> +	 */
> 
> Nit: May be move the above comment about new HW to the below
> check  is better.
>

OK.

Thanks.
Longfang.

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
>> +		end = hisi_acc_get_resource_len(vdev, index);
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

