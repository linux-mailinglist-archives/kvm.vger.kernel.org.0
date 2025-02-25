Return-Path: <kvm+bounces-39083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 83870A434EC
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 07:08:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6B9CE7A4DDA
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 06:07:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12988256C67;
	Tue, 25 Feb 2025 06:07:57 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1C933981;
	Tue, 25 Feb 2025 06:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740463676; cv=none; b=hCW8MPayMqcHH9odHqoTiKR7SKEvRQpFlDXibsgJolQvmhR2Zk23qvlL5VkeYIdFqezXg8fmmh8J3cfry1w7WLaYo95t9ECJzdGvkLcVOQUGGl7HI1UGzBldZBXkBEPV6QZ5rQQ4a0PLqk+TS+sN48FJnP09af37m52eUkPHmiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740463676; c=relaxed/simple;
	bh=s0KR5NFOSbI3uPWqY8ch+TeQyRQ+DhGs6ESH2KL3cH0=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=OkYlGVggVFgEfGgjna5qWrFUvgRgAdKwqXKzH8D4Bme9kPlT8GjkELcqempET9UNDeXX0KKLw8BA47Dkki02cjc0hv9NItDTAyZpfT3gyeuUL3rKN0a4pKLipQH7sN0zrNjza2/jZ3KA2JM8cnOlGno69g1Y2MqtYSobdd9YJiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Z26VV67NDzJ1FM;
	Tue, 25 Feb 2025 14:03:46 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id 9E62914037C;
	Tue, 25 Feb 2025 14:07:49 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemg500006.china.huawei.com (7.202.181.43) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 25 Feb 2025 14:07:49 +0800
Subject: Re: [PATCH 3/3] migration: adapt to new migration configuration
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, Jonathan Cameron <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
References: <20250218021507.40740-1-liulongfang@huawei.com>
 <20250218021507.40740-4-liulongfang@huawei.com>
 <23e896a0788f4fc59b25b58be059a0f8@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <ed716078-edfe-4f8b-3728-3287ba722c40@huawei.com>
Date: Tue, 25 Feb 2025 14:07:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <23e896a0788f4fc59b25b58be059a0f8@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemg500006.china.huawei.com (7.202.181.43)

On 2025/2/18 18:58, Shameerali Kolothum Thodi wrote:
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
>> Subject: [PATCH 3/3] migration: adapt to new migration configuration
>>
>> On the new hardware platform, the migration region is moved from
>> VF to PF. the driver also needs to be modified accordingly to adapt
>> to the new hardware device.
>>
>> Use PF's io base directly on the new hardware platform. and no mmap
>> operation is required.
>> If it is on an old platform, the driver needs to be compatible with
>> the old solution.
> 
> 
> I see that you have used "new hardware platform" everywhere and I think
> it is better we make it more specific, like QM_HW_V4?
> 
> Also it is not clear to me, what happens if you try migration between
> QM_HW_V3 <--> QM_HW_V4? Is that going to be success or we are
> failing it somewhere? I see only the dev_id check in vf_qm_check_match().
> 

The hardware platforms that support live migration are begin from QM_HW_V3.
Before that, there is no support for live migration. After that, all migration
configuration registers  will be placed in the PF configuration space.
Therefore.so there is no need to make special configurations for QM_HW_V4.

Thanks.
Longfang.

> Thanks,
> Shameer
> 
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> ---
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 165 ++++++++++++------
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |   7 +
>>  2 files changed, 119 insertions(+), 53 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> index 599905dbb707..cf5a807c2199 100644
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
>> @@ -238,20 +290,6 @@ static int qm_set_regs(struct hisi_qm *qm, struct
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
>> @@ -470,6 +508,10 @@ static int vf_qm_load_data(struct
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
>> @@ -544,6 +586,10 @@ static int vf_qm_state_save(struct
>> hisi_acc_vf_core_device *hisi_acc_vdev,
>>  		return ret;
>>  	}
>>
>> +	ret = qm_get_xqc_regs(hisi_acc_vdev, vf_data);
>> +	if (ret)
>> +		return -EINVAL;
>> +
>>  	ret = vf_qm_read_data(vf_qm, vf_data);
>>  	if (ret)
>>  		return -EINVAL;
>> @@ -1131,34 +1177,46 @@ static int hisi_acc_vf_qm_init(struct
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
>> +		 * In the new HW platform, the migration function register
>> space is in BAR2 of PF,
>> +		 * and each VF occupies 8KB address space.
>> +		 */
>> +		vf_qm->io_base = pf_qm->io_base +
>> QM_MIG_REGION_OFFSET +
>> +				hisi_acc_vdev->vf_id *
>> QM_MIG_REGION_SIZE;
>> +		vf_qm->fun_type = QM_HW_PF;
>> +	}
>>  	vf_qm->pdev = vf_dev;
>>  	mutex_init(&vf_qm->mailbox_lock);
>>
>> @@ -1488,7 +1546,8 @@ static void hisi_acc_vfio_pci_close_device(struct
>> vfio_device *core_vdev)
>>
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
>> index 245d7537b2bc..b01eb54525d3 100644
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> @@ -50,6 +50,13 @@
>>  #define QM_EQC_DW0		0X8000
>>  #define QM_AEQC_DW0		0X8020
>>
>> +#define QM_MIG_REGION_OFFSET	0x180000
>> +#define QM_MIG_REGION_SIZE	0x2000
>> +
>> +#define QM_SUB_VERSION_ID		0x100210
>> +#define QM_EQC_PF_DW0		0x1c00
>> +#define QM_AEQC_PF_DW0		0x1c20
>> +
>>  struct acc_vf_data {
>>  #define QM_MATCH_SIZE offsetofend(struct acc_vf_data, qm_rsv_state)
>>  	/* QM match information */
>> --
>> 2.24.0
> 
> .
> 

