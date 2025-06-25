Return-Path: <kvm+bounces-50630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65872AE78EF
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 09:43:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BAE593AA05C
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 07:43:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9DD8207A26;
	Wed, 25 Jun 2025 07:43:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3157139E;
	Wed, 25 Jun 2025 07:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750837403; cv=none; b=mDZapTGcynEfnXHQ0zW7CL7NyaTgeroLyewEDTkJqEF+ou0XIQ3iDjOYPHj50yo8FAEBMYZ7YLdifQgkoSyyKRxgKsFCEIrdFIUIMurZFjSc8YbSF1tm+VeiiKKbJWr25v9bcZCyJDl77dvgCmcZxxeWIN2DeUilStMH6j0WkuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750837403; c=relaxed/simple;
	bh=++IdVS8QY1ff1jGoCjv4IWD6NFBm/G08CeXNZSMmotE=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Ls0RZpj7yJ5bv7NyP+ibiAKbx+l5jH9TPWWJE93V0S4Jb8vvYE088iNFiXNJLAbNP6avFpLIWs1dSRMVh9U21bwrPhgLaUkH4o4rVy2irluBryHkx8J0X/gYI/HivamzpcnbsOy3HuvIOWCNROeUymikWiHqh0C3S2Vz8lod/WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4bRtzy3RRbz2BdVd;
	Wed, 25 Jun 2025 15:41:34 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 3567F1400CF;
	Wed, 25 Jun 2025 15:43:11 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 25 Jun 2025 15:43:10 +0800
Subject: Re: [PATCH v4 3/3] migration: adapt to new migration configuration
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, Jonathan Cameron <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
References: <20250610063251.27526-1-liulongfang@huawei.com>
 <20250610063251.27526-4-liulongfang@huawei.com>
 <45acec4593174305ac84a0fb37df36be@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <363ff5d8-11d1-fab1-facc-301f2758fef5@huawei.com>
Date: Wed, 25 Jun 2025 15:43:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <45acec4593174305ac84a0fb37df36be@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2025/6/24 15:10, Shameerali Kolothum Thodi wrote:
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
>> Subject: [PATCH v4 3/3] migration: adapt to new migration configuration
>>
>> On the new hardware platform, the migration region has been
>> relocated from the VF to the PF. The driver must also be modified
>> accordingly to adapt to the new hardware device.
>>
>> Utilize the PF's I/O base directly on the new hardware platform,
>> and no mmap operation is required. If it is on an old platform,
>> the driver needs to be compatible with the old solution.
>>
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> ---
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 166 ++++++++++++------
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |   7 +
>>  2 files changed, 120 insertions(+), 53 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> index b16115f590fd..ab815fa4258c 100644
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> @@ -125,6 +125,72 @@ static int qm_get_cqc(struct hisi_qm *qm, u64
>> *addr)
>>  	return 0;
>>  }
>>
>> +static int qm_get_xqc_regs(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>> +			   struct acc_vf_data *vf_data)
>> +{
>> +	struct hisi_qm *qm = &hisi_acc_vdev->vf_qm;
>> +	struct device *dev = &qm->pdev->dev;
>> +	u32 eqc_addr, aeqc_addr;
>> +	int ret;
>> +
>> +	if (qm->ver == QM_HW_V3) {
>> +		eqc_addr = QM_EQC_DW0;
>> +		aeqc_addr = QM_AEQC_DW0;
>> +	} else {
>> +		eqc_addr = QM_EQC_PF_DW0;
>> +		aeqc_addr = QM_AEQC_PF_DW0;
>> +	}
>> +
>> +	/* QM_EQC_DW has 7 regs */
>> +	ret = qm_read_regs(qm, eqc_addr, vf_data->qm_eqc_dw, 7);
>> +	if (ret) {
>> +		dev_err(dev, "failed to read QM_EQC_DW\n");
>> +		return ret;
>> +	}
>> +
>> +	/* QM_AEQC_DW has 7 regs */
>> +	ret = qm_read_regs(qm, aeqc_addr, vf_data->qm_aeqc_dw, 7);
>> +	if (ret) {
>> +		dev_err(dev, "failed to read QM_AEQC_DW\n");
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int qm_set_xqc_regs(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>> +			   struct acc_vf_data *vf_data)
>> +{
>> +	struct hisi_qm *qm = &hisi_acc_vdev->vf_qm;
>> +	struct device *dev = &qm->pdev->dev;
>> +	u32 eqc_addr, aeqc_addr;
>> +	int ret;
>> +
>> +	if (qm->ver == QM_HW_V3) {
>> +		eqc_addr = QM_EQC_DW0;
>> +		aeqc_addr = QM_AEQC_DW0;
>> +	} else {
>> +		eqc_addr = QM_EQC_PF_DW0;
>> +		aeqc_addr = QM_AEQC_PF_DW0;
>> +	}
>> +
>> +	/* QM_EQC_DW has 7 regs */
>> +	ret = qm_write_regs(qm, eqc_addr, vf_data->qm_eqc_dw, 7);
>> +	if (ret) {
>> +		dev_err(dev, "failed to write QM_EQC_DW\n");
>> +		return ret;
>> +	}
>> +
>> +	/* QM_AEQC_DW has 7 regs */
>> +	ret = qm_write_regs(qm, aeqc_addr, vf_data->qm_aeqc_dw, 7);
>> +	if (ret) {
>> +		dev_err(dev, "failed to write QM_AEQC_DW\n");
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>  static int qm_get_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
>>  {
>>  	struct device *dev = &qm->pdev->dev;
>> @@ -167,20 +233,6 @@ static int qm_get_regs(struct hisi_qm *qm, struct
>> acc_vf_data *vf_data)
>>  		return ret;
>>  	}
>>
>> -	/* QM_EQC_DW has 7 regs */
>> -	ret = qm_read_regs(qm, QM_EQC_DW0, vf_data->qm_eqc_dw, 7);
>> -	if (ret) {
>> -		dev_err(dev, "failed to read QM_EQC_DW\n");
>> -		return ret;
>> -	}
>> -
>> -	/* QM_AEQC_DW has 7 regs */
>> -	ret = qm_read_regs(qm, QM_AEQC_DW0, vf_data->qm_aeqc_dw,
>> 7);
>> -	if (ret) {
>> -		dev_err(dev, "failed to read QM_AEQC_DW\n");
>> -		return ret;
>> -	}
>> -
>>  	return 0;
>>  }
>>
>> @@ -239,20 +291,6 @@ static int qm_set_regs(struct hisi_qm *qm, struct
>> acc_vf_data *vf_data)
>>  		return ret;
>>  	}
>>
>> -	/* QM_EQC_DW has 7 regs */
>> -	ret = qm_write_regs(qm, QM_EQC_DW0, vf_data->qm_eqc_dw, 7);
>> -	if (ret) {
>> -		dev_err(dev, "failed to write QM_EQC_DW\n");
>> -		return ret;
>> -	}
>> -
>> -	/* QM_AEQC_DW has 7 regs */
>> -	ret = qm_write_regs(qm, QM_AEQC_DW0, vf_data->qm_aeqc_dw,
>> 7);
>> -	if (ret) {
>> -		dev_err(dev, "failed to write QM_AEQC_DW\n");
>> -		return ret;
>> -	}
>> -
>>  	return 0;
>>  }
>>
>> @@ -522,6 +560,10 @@ static int vf_qm_load_data(struct
>> hisi_acc_vf_core_device *hisi_acc_vdev,
>>  		return ret;
>>  	}
>>
>> +	ret = qm_set_xqc_regs(hisi_acc_vdev, vf_data);
>> +	if (ret)
>> +		return ret;
>> +
>>  	ret = hisi_qm_mb(qm, QM_MB_CMD_SQC_BT, qm->sqc_dma, 0, 0);
>>  	if (ret) {
>>  		dev_err(dev, "set sqc failed\n");
>> @@ -589,6 +631,10 @@ static int vf_qm_state_save(struct
>> hisi_acc_vf_core_device *hisi_acc_vdev,
>>  	vf_data->vf_qm_state = QM_READY;
>>  	hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
>>
>> +	ret = qm_get_xqc_regs(hisi_acc_vdev, vf_data);
>> +	if (ret)
>> +		return ret;
>> +
>>  	ret = vf_qm_read_data(vf_qm, vf_data);
>>  	if (ret)
>>  		return ret;
>> @@ -1186,34 +1232,47 @@ static int hisi_acc_vf_qm_init(struct
>> hisi_acc_vf_core_device *hisi_acc_vdev)
>>  {
>>  	struct vfio_pci_core_device *vdev = &hisi_acc_vdev->core_device;
>>  	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
>> +	struct hisi_qm *pf_qm = hisi_acc_vdev->pf_qm;
>>  	struct pci_dev *vf_dev = vdev->pdev;
>>
>> -	/*
>> -	 * ACC VF dev BAR2 region consists of both functional register space
>> -	 * and migration control register space. For migration to work, we
>> -	 * need access to both. Hence, we map the entire BAR2 region here.
>> -	 * But unnecessarily exposing the migration BAR region to the Guest
>> -	 * has the potential to prevent/corrupt the Guest migration. Hence,
>> -	 * we restrict access to the migration control space from
>> -	 * Guest(Please see mmap/ioctl/read/write override functions).
>> -	 *
>> -	 * Please note that it is OK to expose the entire VF BAR if migration
>> -	 * is not supported or required as this cannot affect the ACC PF
>> -	 * configurations.
>> -	 *
>> -	 * Also the HiSilicon ACC VF devices supported by this driver on
>> -	 * HiSilicon hardware platforms are integrated end point devices
>> -	 * and the platform lacks the capability to perform any PCIe P2P
>> -	 * between these devices.
>> -	 */
>> +	if (pf_qm->ver == QM_HW_V3) {
>> +		/*
>> +		 * ACC VF dev BAR2 region consists of both functional
>> register space
>> +		 * and migration control register space. For migration to
>> work, we
>> +		 * need access to both. Hence, we map the entire BAR2
>> region here.
>> +		 * But unnecessarily exposing the migration BAR region to
>> the Guest
>> +		 * has the potential to prevent/corrupt the Guest migration.
>> Hence,
>> +		 * we restrict access to the migration control space from
>> +		 * Guest(Please see mmap/ioctl/read/write override
>> functions).
>> +		 *
>> +		 * Please note that it is OK to expose the entire VF BAR if
>> migration
>> +		 * is not supported or required as this cannot affect the ACC
>> PF
>> +		 * configurations.
>> +		 *
>> +		 * Also the HiSilicon ACC VF devices supported by this driver
>> on
>> +		 * HiSilicon hardware platforms are integrated end point
>> devices
>> +		 * and the platform lacks the capability to perform any PCIe
>> P2P
>> +		 * between these devices.
>> +		 */
>>
>> -	vf_qm->io_base =
>> -		ioremap(pci_resource_start(vf_dev,
>> VFIO_PCI_BAR2_REGION_INDEX),
>> -			pci_resource_len(vf_dev,
>> VFIO_PCI_BAR2_REGION_INDEX));
>> -	if (!vf_qm->io_base)
>> -		return -EIO;
>> +		vf_qm->io_base =
>> +			ioremap(pci_resource_start(vf_dev,
>> VFIO_PCI_BAR2_REGION_INDEX),
>> +				pci_resource_len(vf_dev,
>> VFIO_PCI_BAR2_REGION_INDEX));
>> +		if (!vf_qm->io_base)
>> +			return -EIO;
>>
>> -	vf_qm->fun_type = QM_HW_VF;
>> +		vf_qm->fun_type = QM_HW_VF;
>> +		vf_qm->ver = pf_qm->ver;
>> +	} else {
>> +		/*
>> +		 * On the new HW device, the migration function register is
> 
> 
> What is the "new HW device"? Please make it specific. Also I think you should
> check it specifically.
>
The term 'new HW device' refers to hardware versions greater than QM_HW_V3.
I can update this statement in the comments.


> One  more question is what will happen if you try to migrate between a 
> QM_HW_V3 <--> QM_HW_V4? Will it succeed or do we need to block it?
>

This migration function region is a configuration register space.
During live migration, only the configuration information read from this space is transferred.
The reading and writing of information are handled by the corresponding driver,
which is adapted to the hardware platform.
Therefore, there are no problem when performing live migration between QM_HW_V3 and QM_HW_V4.

Additionally, we have already tested this scenario, and there are no problem.

Thanks.
Longfang.

> Thanks,
> Shameer
> 
>> placed
>> +		 * in the BAR2 configuration region of the PF, and each VF
>> device
>> +		 * occupies 8KB of configuration space.
>> +		 */
>> +		vf_qm->io_base = pf_qm->io_base +
>> QM_MIG_REGION_OFFSET +
>> +				 hisi_acc_vdev->vf_id *
>> QM_MIG_REGION_SIZE;
>> +		vf_qm->fun_type = QM_HW_PF;
>> +	}
>>  	vf_qm->pdev = vf_dev;
>>  	mutex_init(&vf_qm->mailbox_lock);
>>
>> @@ -1539,7 +1598,8 @@ static void hisi_acc_vfio_pci_close_device(struct
>> vfio_device *core_vdev)
>>  	hisi_acc_vf_disable_fds(hisi_acc_vdev);
>>  	mutex_lock(&hisi_acc_vdev->open_mutex);
>>  	hisi_acc_vdev->dev_opened = false;
>> -	iounmap(vf_qm->io_base);
>> +	if (vf_qm->ver == QM_HW_V3)
>> +		iounmap(vf_qm->io_base);
>>  	mutex_unlock(&hisi_acc_vdev->open_mutex);
>>  	vfio_pci_core_close_device(core_vdev);
>>  }
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> index 91002ceeebc1..348f8bb5b42c 100644
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> @@ -59,6 +59,13 @@
>>  #define ACC_DEV_MAGIC_V1	0XCDCDCDCDFEEDAACC
>>  #define ACC_DEV_MAGIC_V2	0xAACCFEEDDECADEDE
>>
>> +#define QM_MIG_REGION_OFFSET		0x180000
>> +#define QM_MIG_REGION_SIZE		0x2000
>> +
>> +#define QM_SUB_VERSION_ID		0x100210
>> +#define QM_EQC_PF_DW0			0x1c00
>> +#define QM_AEQC_PF_DW0			0x1c20
>> +
>>  struct acc_vf_data {
>>  #define QM_MATCH_SIZE offsetofend(struct acc_vf_data, qm_rsv_state)
>>  	/* QM match information */
>> --
>> 2.24.0
> 
> .
> 

