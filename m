Return-Path: <kvm+bounces-16803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F7418BDD2D
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 10:29:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B4A591F212EA
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 08:29:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6891F13CA87;
	Tue,  7 May 2024 08:29:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924C813CAA2;
	Tue,  7 May 2024 08:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715070560; cv=none; b=tK8IZheWaLJND5oxcewkzjZNVXb2T8mkHv8iOCZw1smJvbAvsi8s7DUgWAkRs4E1TVwEUNhqg4bEsTi2f7GqKHwYCbx7+PJHVn7yBKlNGey2IUcTYyX2Raxxldttu0qZZkm2kiVhSlDVb5UxfZoqwRPmW7QryyIcu3+21lazuRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715070560; c=relaxed/simple;
	bh=BDRkaqmw0hsT2fSlH5pNZvdmFYex5/RER6NwKDco1t4=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=KDTttXwj/MhJmP4pKX1AWtAgAtphtSLHqQOQ4S0rSiptW7NrhuR1BRhcJBrhDALyx/cQnUFVdPWGUpwQcW7NpNBL4rpzOLtFeQ5MPyTSh1WQ3kKaPBppdk0KsILEkUoJRK4vGyqQ6ANWRv0MnrdML2PGlScl4+WkGeSPC9vVL1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4VYWYT69vCzYskv;
	Tue,  7 May 2024 16:25:17 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id D486018007D;
	Tue,  7 May 2024 16:29:06 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 7 May 2024 16:29:06 +0800
Subject: Re: [PATCH v6 2/5] hisi_acc_vfio_pci: modify the register location of
 the XQC address
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
References: <20240425132322.12041-1-liulongfang@huawei.com>
 <20240425132322.12041-3-liulongfang@huawei.com>
 <20240503101138.7921401f.alex.williamson@redhat.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <bc4fd179-265a-cbd8-afcb-358748ece897@huawei.com>
Date: Tue, 7 May 2024 16:29:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240503101138.7921401f.alex.williamson@redhat.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600005.china.huawei.com (7.193.23.191)

On 2024/5/4 0:11, Alex Williamson wrote:
> On Thu, 25 Apr 2024 21:23:19 +0800
> Longfang Liu <liulongfang@huawei.com> wrote:
> 
>> According to the latest hardware register specification. The DMA
>> addresses of EQE and AEQE are not at the front of their respective
>> register groups, but start from the second.
>> So, previously fetching the value starting from the first register
>> would result in an incorrect address.
>>
>> Therefore, the register location from which the address is obtained
>> needs to be modified.
> 
> How does this affect migration?  Has it ever worked?  Does this make

The general HiSilicon accelerator task will only use SQE and CQE.
EQE is only used when user running kernel mode task and uses interrupt mode.
AEQE is only used when user running task exceptions occur and software reset
is required.

The DMA addresses of these four queues are written to the device by the device
driver through the mailbox command during driver initialization.
The DMA addresses of EQE and AEQE are migrated through the device register.

EQE and AEQE are not used in general task, after the live migration is completed,
this DMA address error will not be found. until we added a new kernel-mode test case
that we discovered that this address was abnormal.

> the migration data incompatible?
>

This address only affects the kernel mode interrupt mode task function and device
exception recovery function.
They do not affect live migration functionality

> Fixes: ???
> 

OK!

Thanks.
Longfang.
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> ---
>>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 8 ++++----
>>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h | 3 +++
>>  2 files changed, 7 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> index 45351be8e270..0c7e31076ff4 100644
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> @@ -516,12 +516,12 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>  		return -EINVAL;
>>  
>>  	/* Every reg is 32 bit, the dma address is 64 bit. */
>> -	vf_data->eqe_dma = vf_data->qm_eqc_dw[1];
>> +	vf_data->eqe_dma = vf_data->qm_eqc_dw[QM_XQC_ADDR_HIGH];
>>  	vf_data->eqe_dma <<= QM_XQC_ADDR_OFFSET;
>> -	vf_data->eqe_dma |= vf_data->qm_eqc_dw[0];
>> -	vf_data->aeqe_dma = vf_data->qm_aeqc_dw[1];
>> +	vf_data->eqe_dma |= vf_data->qm_eqc_dw[QM_XQC_ADDR_LOW];
>> +	vf_data->aeqe_dma = vf_data->qm_aeqc_dw[QM_XQC_ADDR_HIGH];
>>  	vf_data->aeqe_dma <<= QM_XQC_ADDR_OFFSET;
>> -	vf_data->aeqe_dma |= vf_data->qm_aeqc_dw[0];
>> +	vf_data->aeqe_dma |= vf_data->qm_aeqc_dw[QM_XQC_ADDR_LOW];
>>  
>>  	/* Through SQC_BT/CQC_BT to get sqc and cqc address */
>>  	ret = qm_get_sqc(vf_qm, &vf_data->sqc_dma);
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> index 5bab46602fad..f887ab98581c 100644
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> @@ -38,6 +38,9 @@
>>  #define QM_REG_ADDR_OFFSET	0x0004
>>  
>>  #define QM_XQC_ADDR_OFFSET	32U
>> +#define QM_XQC_ADDR_LOW	0x1
>> +#define QM_XQC_ADDR_HIGH	0x2
>> +
>>  #define QM_VF_AEQ_INT_MASK	0x0004
>>  #define QM_VF_EQ_INT_MASK	0x000c
>>  #define QM_IFC_INT_SOURCE_V	0x0020
> 
> .
> 

