Return-Path: <kvm+bounces-61371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25B8DC17E9D
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 02:29:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44E433B8DA6
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 01:28:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D02A92DC780;
	Wed, 29 Oct 2025 01:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="Rh2h3P/u"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFB927B4F9;
	Wed, 29 Oct 2025 01:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761701267; cv=none; b=OYuSmoXx/MpzqEBhL4ViLSimgpXmACVdaO8EA9CTpsV0Jp3j76bsBLAD8QprB005k6OXb0UW5jq3sxTfBzRMom5f4DTBdom+LY+29J4UsL2awrZ7oydeLwxcTKrdvO0xX0mu4yBs4uPVNDjmWUU5ePG3LodkymVt2x3AcN1CMbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761701267; c=relaxed/simple;
	bh=AeoIR1O92sueCuPWtIPaNisee7nzHa7lAjDh1HvPhgM=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=rmnDt/d5rLhVIrBwPb6EDjybO1TDHDlzzxy6oXHBW5CWmRSKYiKhrFFmUlvLT+3t3VQukrC4OWlwGhYZfvH9OEvBiGPtRYhr9gFRVLQAAyRDn9u0YVpAph00nNqsJ02ZFwGuiqAIoGcbaF5oedv5zbVwiJoU+qDmo6L8PU+8y5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=Rh2h3P/u; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=bDqIAts4jibD+zQb3HA1KFtfk/kBxNEx4gllEhDvXNk=;
	b=Rh2h3P/uEikw1esYaSO0UAB/O8ItksRbpcMJdfMbtWmlPh2ChsKmB2JXQzN4VXhYQ+sS4fRIE
	6vrKPYHD3wCChlfV5NwoOKpDloatyMgCjN4uB0jmDtbB8vBhswVwn3ogUWRQI01qK3g9+5AeV5S
	v1QnX9PV44GsZl8oSty/oSM=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4cx8jr28Yjz1K97v;
	Wed, 29 Oct 2025 09:27:12 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 437CD14011B;
	Wed, 29 Oct 2025 09:27:40 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 29 Oct 2025 09:27:39 +0800
Subject: Re: [PATCH v10 2/2] hisi_acc_vfio_pci: adapt to new migration
 configuration
To: Alex Williamson <alex@shazbot.org>
CC: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<herbert@gondor.apana.org.au>, <shameerkolothum@gmail.com>,
	<jonathan.cameron@huawei.com>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>
References: <20251017091057.3770403-1-liulongfang@huawei.com>
 <20251017091057.3770403-3-liulongfang@huawei.com>
 <20251027222007.5e176e42@shazbot.org>
 <734cd156-26c1-50f7-f0fa-db76beaab745@huawei.com>
 <20251028153857.67329c09@shazbot.org>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <588d3f10-5764-ee66-11f1-38918ff1b4c9@huawei.com>
Date: Wed, 29 Oct 2025 09:27:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251028153857.67329c09@shazbot.org>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2025/10/29 5:38, Alex Williamson wrote:
> On Tue, 28 Oct 2025 15:04:37 +0800
> liulongfang <liulongfang@huawei.com> wrote:
> 
>> On 2025/10/28 12:20, Alex Williamson wrote:
>>> On Fri, 17 Oct 2025 17:10:57 +0800
>>> Longfang Liu <liulongfang@huawei.com> wrote:
>>>   
>>>> On new platforms greater than QM_HW_V3, the migration region has been
>>>> relocated from the VF to the PF. The VF's own configuration space is
>>>> restored to the complete 64KB, and there is no need to divide the
>>>> size of the BAR configuration space equally. The driver should be
>>>> modified accordingly to adapt to the new hardware device.
>>>>
>>>> On the older hardware platform QM_HW_V3, the live migration configuration
>>>> region is placed in the latter 32K portion of the VF's BAR2 configuration
>>>> space. On the new hardware platform QM_HW_V4, the live migration
>>>> configuration region also exists in the same 32K area immediately following
>>>> the VF's BAR2, just like on QM_HW_V3.
>>>>
>>>> However, access to this region is now controlled by hardware. Additionally,
>>>> a copy of the live migration configuration region is present in the PF's
>>>> BAR2 configuration space. On the new hardware platform QM_HW_V4, when an
>>>> older version of the driver is loaded, it behaves like QM_HW_V3 and uses
>>>> the configuration region in the VF, ensuring that the live migration
>>>> function continues to work normally. When the new version of the driver is
>>>> loaded, it directly uses the configuration region in the PF. Meanwhile,
>>>> hardware configuration disables the live migration configuration region
>>>> in the VF's BAR2: reads return all 0xF values, and writes are silently
>>>> ignored.
>>>>
>>>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>>>> Reviewed-by: Shameer Kolothum <shameerkolothum@gmail.com>
>>>> ---
>>>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 205 ++++++++++++------
>>>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  21 ++
>>>>  2 files changed, 165 insertions(+), 61 deletions(-)
>>>>
>>>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>>> index fde33f54e99e..55233e62cb1d 100644
>>>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>>> @@ -125,6 +125,72 @@ static int qm_get_cqc(struct hisi_qm *qm, u64 *addr)
>>>>  	return 0;
>>>>  }
>>>>  
>>>> +static int qm_get_xqc_regs(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>>> +			   struct acc_vf_data *vf_data)
>>>> +{
>>>> +	struct hisi_qm *qm = &hisi_acc_vdev->vf_qm;
>>>> +	struct device *dev = &qm->pdev->dev;
>>>> +	u32 eqc_addr, aeqc_addr;
>>>> +	int ret;
>>>> +
>>>> +	if (hisi_acc_vdev->drv_mode == HW_ACC_MIG_VF_CTRL) {
>>>> +		eqc_addr = QM_EQC_DW0;
>>>> +		aeqc_addr = QM_AEQC_DW0;
>>>> +	} else {
>>>> +		eqc_addr = QM_EQC_PF_DW0;
>>>> +		aeqc_addr = QM_AEQC_PF_DW0;
>>>> +	}
>>>> +
>>>> +	/* QM_EQC_DW has 7 regs */
>>>> +	ret = qm_read_regs(qm, eqc_addr, vf_data->qm_eqc_dw, 7);
>>>> +	if (ret) {
>>>> +		dev_err(dev, "failed to read QM_EQC_DW\n");
>>>> +		return ret;
>>>> +	}
>>>> +
>>>> +	/* QM_AEQC_DW has 7 regs */
>>>> +	ret = qm_read_regs(qm, aeqc_addr, vf_data->qm_aeqc_dw, 7);
>>>> +	if (ret) {
>>>> +		dev_err(dev, "failed to read QM_AEQC_DW\n");
>>>> +		return ret;
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int qm_set_xqc_regs(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>>> +			   struct acc_vf_data *vf_data)
>>>> +{
>>>> +	struct hisi_qm *qm = &hisi_acc_vdev->vf_qm;
>>>> +	struct device *dev = &qm->pdev->dev;
>>>> +	u32 eqc_addr, aeqc_addr;
>>>> +	int ret;
>>>> +
>>>> +	if (hisi_acc_vdev->drv_mode == HW_ACC_MIG_VF_CTRL) {
>>>> +		eqc_addr = QM_EQC_DW0;
>>>> +		aeqc_addr = QM_AEQC_DW0;
>>>> +	} else {
>>>> +		eqc_addr = QM_EQC_PF_DW0;
>>>> +		aeqc_addr = QM_AEQC_PF_DW0;
>>>> +	}
>>>> +
>>>> +	/* QM_EQC_DW has 7 regs */
>>>> +	ret = qm_write_regs(qm, eqc_addr, vf_data->qm_eqc_dw, 7);
>>>> +	if (ret) {
>>>> +		dev_err(dev, "failed to write QM_EQC_DW\n");
>>>> +		return ret;
>>>> +	}
>>>> +
>>>> +	/* QM_AEQC_DW has 7 regs */
>>>> +	ret = qm_write_regs(qm, aeqc_addr, vf_data->qm_aeqc_dw, 7);
>>>> +	if (ret) {
>>>> +		dev_err(dev, "failed to write QM_AEQC_DW\n");
>>>> +		return ret;
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>>  static int qm_get_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
>>>>  {
>>>>  	struct device *dev = &qm->pdev->dev;
>>>> @@ -167,20 +233,6 @@ static int qm_get_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
>>>>  		return ret;
>>>>  	}
>>>>  
>>>> -	/* QM_EQC_DW has 7 regs */
>>>> -	ret = qm_read_regs(qm, QM_EQC_DW0, vf_data->qm_eqc_dw, 7);
>>>> -	if (ret) {
>>>> -		dev_err(dev, "failed to read QM_EQC_DW\n");
>>>> -		return ret;
>>>> -	}
>>>> -
>>>> -	/* QM_AEQC_DW has 7 regs */
>>>> -	ret = qm_read_regs(qm, QM_AEQC_DW0, vf_data->qm_aeqc_dw, 7);
>>>> -	if (ret) {
>>>> -		dev_err(dev, "failed to read QM_AEQC_DW\n");
>>>> -		return ret;
>>>> -	}
>>>> -
>>>>  	return 0;
>>>>  }
>>>>  
>>>> @@ -239,20 +291,6 @@ static int qm_set_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
>>>>  		return ret;
>>>>  	}
>>>>  
>>>> -	/* QM_EQC_DW has 7 regs */
>>>> -	ret = qm_write_regs(qm, QM_EQC_DW0, vf_data->qm_eqc_dw, 7);
>>>> -	if (ret) {
>>>> -		dev_err(dev, "failed to write QM_EQC_DW\n");
>>>> -		return ret;
>>>> -	}
>>>> -
>>>> -	/* QM_AEQC_DW has 7 regs */
>>>> -	ret = qm_write_regs(qm, QM_AEQC_DW0, vf_data->qm_aeqc_dw, 7);
>>>> -	if (ret) {
>>>> -		dev_err(dev, "failed to write QM_AEQC_DW\n");
>>>> -		return ret;
>>>> -	}
>>>> -
>>>>  	return 0;
>>>>  }
>>>>  
>>>> @@ -522,6 +560,10 @@ static int vf_qm_load_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>>>  		return ret;
>>>>  	}
>>>>  
>>>> +	ret = qm_set_xqc_regs(hisi_acc_vdev, vf_data);
>>>> +	if (ret)
>>>> +		return ret;
>>>> +
>>>>  	ret = hisi_qm_mb(qm, QM_MB_CMD_SQC_BT, qm->sqc_dma, 0, 0);
>>>>  	if (ret) {
>>>>  		dev_err(dev, "set sqc failed\n");
>>>> @@ -589,6 +631,10 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>>>  	vf_data->vf_qm_state = QM_READY;
>>>>  	hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
>>>>  
>>>> +	ret = qm_get_xqc_regs(hisi_acc_vdev, vf_data);
>>>> +	if (ret)
>>>> +		return ret;
>>>> +  
>>>
>>> I'd have thought it'd still make sense that qm_{get,set}_regs() would
>>> handle this subset of registers even though it's split out into helper
>>> functions, now we have the dev_data debugfs failing to fill these
>>> registers.  It's not clear it was worthwhile to split out the xqc
>>> helpers at all here.  
>>
>> Moving the differentiated handling of eqc and aeqc, which results from different drv_mode values,
>> into the helper functions can keep the main business logic code for live migration
>> clean and concise.
> 
> You can keep the helpers if you want, it's already introduced a bug
> here separating the xqc register get/set from all the others though.
> The helpers are also not removing the redundancy of getting the
> register offsets.  It might be better to keep the read/write in the
> get/set function and just add a helper for the offsets:
> 
> static void qm_xqc_reg_offsets(struct hisi_acc_vf_core_device *hisi_acc_vdev,
> 			       u32 *eqc_addr, u32 *aeqc_addr)
> {
> 	if (hisi_acc_vdev->drv_mode == HW_ACC_MIG_VF_CTRL) {
> 		*eqc_addr = QM_EQC_VF_DW0;
> 		*aeqc_addr = QM_AEQC_VF_DW0;
> 	} else {
> 		*eqc_addr = QM_EQC_PF_DW0;
> 		*aeqc_addr = QM_AEQC_PF_DW0;
> 	}
> }
>

OK, this approach indeed helps reduce code redundancy.
I'll make these changes together in the next version.

Thanks,
Longfang.

> Thanks,
> Alex
> 
>>>   
>>>>  	ret = vf_qm_read_data(vf_qm, vf_data);
>>>>  	if (ret)
>>>>  		return ret;
>>>> @@ -1186,34 +1232,52 @@ static int hisi_acc_vf_qm_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
>>>>  {
>>>>  	struct vfio_pci_core_device *vdev = &hisi_acc_vdev->core_device;
>>>>  	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
>>>> +	struct hisi_qm *pf_qm = hisi_acc_vdev->pf_qm;
>>>>  	struct pci_dev *vf_dev = vdev->pdev;
>>>> +	u32 val;
>>>>  
>>>> -	/*
>>>> -	 * ACC VF dev BAR2 region consists of both functional register space
>>>> -	 * and migration control register space. For migration to work, we
>>>> -	 * need access to both. Hence, we map the entire BAR2 region here.
>>>> -	 * But unnecessarily exposing the migration BAR region to the Guest
>>>> -	 * has the potential to prevent/corrupt the Guest migration. Hence,
>>>> -	 * we restrict access to the migration control space from
>>>> -	 * Guest(Please see mmap/ioctl/read/write override functions).
>>>> -	 *
>>>> -	 * Please note that it is OK to expose the entire VF BAR if migration
>>>> -	 * is not supported or required as this cannot affect the ACC PF
>>>> -	 * configurations.
>>>> -	 *
>>>> -	 * Also the HiSilicon ACC VF devices supported by this driver on
>>>> -	 * HiSilicon hardware platforms are integrated end point devices
>>>> -	 * and the platform lacks the capability to perform any PCIe P2P
>>>> -	 * between these devices.
>>>> -	 */
>>>> +	val = readl(pf_qm->io_base + QM_MIG_REGION_SEL);
>>>> +	if (pf_qm->ver > QM_HW_V3 && (val & QM_MIG_REGION_EN))
>>>> +		hisi_acc_vdev->drv_mode = HW_ACC_MIG_PF_CTRL;
>>>> +	else
>>>> +		hisi_acc_vdev->drv_mode = HW_ACC_MIG_VF_CTRL;
>>>>  
>>>> -	vf_qm->io_base =
>>>> -		ioremap(pci_resource_start(vf_dev, VFIO_PCI_BAR2_REGION_INDEX),
>>>> -			pci_resource_len(vf_dev, VFIO_PCI_BAR2_REGION_INDEX));
>>>> -	if (!vf_qm->io_base)
>>>> -		return -EIO;
>>>> +	if (hisi_acc_vdev->drv_mode == HW_ACC_MIG_PF_CTRL) {
>>>> +		/*
>>>> +		 * On hardware platforms greater than QM_HW_V3, the migration function
>>>> +		 * register is placed in the BAR2 configuration region of the PF,
>>>> +		 * and each VF device occupies 8KB of configuration space.
>>>> +		 */
>>>> +		vf_qm->io_base = pf_qm->io_base + QM_MIG_REGION_OFFSET +
>>>> +				 hisi_acc_vdev->vf_id * QM_MIG_REGION_SIZE;
>>>> +	} else {
>>>> +		/*
>>>> +		 * ACC VF dev BAR2 region consists of both functional register space
>>>> +		 * and migration control register space. For migration to work, we
>>>> +		 * need access to both. Hence, we map the entire BAR2 region here.
>>>> +		 * But unnecessarily exposing the migration BAR region to the Guest
>>>> +		 * has the potential to prevent/corrupt the Guest migration. Hence,
>>>> +		 * we restrict access to the migration control space from
>>>> +		 * Guest(Please see mmap/ioctl/read/write override functions).
>>>> +		 *
>>>> +		 * Please note that it is OK to expose the entire VF BAR if migration
>>>> +		 * is not supported or required as this cannot affect the ACC PF
>>>> +		 * configurations.
>>>> +		 *
>>>> +		 * Also the HiSilicon ACC VF devices supported by this driver on
>>>> +		 * HiSilicon hardware platforms are integrated end point devices
>>>> +		 * and the platform lacks the capability to perform any PCIe P2P
>>>> +		 * between these devices.
>>>> +		 */
>>>>  
>>>> +		vf_qm->io_base =
>>>> +			ioremap(pci_resource_start(vf_dev, VFIO_PCI_BAR2_REGION_INDEX),
>>>> +				pci_resource_len(vf_dev, VFIO_PCI_BAR2_REGION_INDEX));
>>>> +		if (!vf_qm->io_base)
>>>> +			return -EIO;
>>>> +	}
>>>>  	vf_qm->fun_type = QM_HW_VF;
>>>> +	vf_qm->ver = pf_qm->ver;
>>>>  	vf_qm->pdev = vf_dev;
>>>>  	mutex_init(&vf_qm->mailbox_lock);
>>>>  
>>>> @@ -1250,6 +1314,28 @@ static struct hisi_qm *hisi_acc_get_pf_qm(struct pci_dev *pdev)
>>>>  	return !IS_ERR(pf_qm) ? pf_qm : NULL;
>>>>  }
>>>>  
>>>> +static size_t hisi_acc_get_resource_len(struct vfio_pci_core_device *vdev,
>>>> +					unsigned int index)
>>>> +{
>>>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>>>> +			hisi_acc_drvdata(vdev->pdev);
>>>> +
>>>> +	/*
>>>> +	 * On the old HW_ACC_MIG_VF_CTRL mode device, the ACC VF device
>>>> +	 * BAR2 region encompasses both functional register space
>>>> +	 * and migration control register space.
>>>> +	 * only the functional region should be report to Guest.
>>>> +	 */
>>>> +	if (hisi_acc_vdev->drv_mode == HW_ACC_MIG_VF_CTRL)
>>>> +		return (pci_resource_len(vdev->pdev, index) >> 1);
>>>> +	/*
>>>> +	 * On the new HW device, the migration control register
>>>> +	 * has been moved to the PF device BAR2 region.
>>>> +	 * The VF device BAR2 is entirely functional register space.
>>>> +	 */
>>>> +	return pci_resource_len(vdev->pdev, index);
>>>> +}
>>>> +
>>>>  static int hisi_acc_pci_rw_access_check(struct vfio_device *core_vdev,
>>>>  					size_t count, loff_t *ppos,
>>>>  					size_t *new_count)
>>>> @@ -1260,8 +1346,9 @@ static int hisi_acc_pci_rw_access_check(struct vfio_device *core_vdev,
>>>>  
>>>>  	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
>>>>  		loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
>>>> -		resource_size_t end = pci_resource_len(vdev->pdev, index) / 2;
>>>> +		resource_size_t end;
>>>>  
>>>> +		end = hisi_acc_get_resource_len(vdev, index);
>>>>  		/* Check if access is for migration control region */
>>>>  		if (pos >= end)
>>>>  			return -EINVAL;
>>>> @@ -1282,8 +1369,9 @@ static int hisi_acc_vfio_pci_mmap(struct vfio_device *core_vdev,
>>>>  	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
>>>>  	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
>>>>  		u64 req_len, pgoff, req_start;
>>>> -		resource_size_t end = pci_resource_len(vdev->pdev, index) / 2;
>>>> +		resource_size_t end;
>>>>  
>>>> +		end = hisi_acc_get_resource_len(vdev, index);
>>>>  		req_len = vma->vm_end - vma->vm_start;
>>>>  		pgoff = vma->vm_pgoff &
>>>>  			((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
>>>> @@ -1330,7 +1418,6 @@ static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int
>>>>  	if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
>>>>  		struct vfio_pci_core_device *vdev =
>>>>  			container_of(core_vdev, struct vfio_pci_core_device, vdev);
>>>> -		struct pci_dev *pdev = vdev->pdev;
>>>>  		struct vfio_region_info info;
>>>>  		unsigned long minsz;
>>>>  
>>>> @@ -1345,12 +1432,7 @@ static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int
>>>>  		if (info.index == VFIO_PCI_BAR2_REGION_INDEX) {
>>>>  			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
>>>>  
>>>> -			/*
>>>> -			 * ACC VF dev BAR2 region consists of both functional
>>>> -			 * register space and migration control register space.
>>>> -			 * Report only the functional region to Guest.
>>>> -			 */
>>>> -			info.size = pci_resource_len(pdev, info.index) / 2;
>>>> +			info.size = hisi_acc_get_resource_len(vdev, info.index);
>>>>  
>>>>  			info.flags = VFIO_REGION_INFO_FLAG_READ |
>>>>  					VFIO_REGION_INFO_FLAG_WRITE |
>>>> @@ -1521,7 +1603,8 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
>>>>  	hisi_acc_vf_disable_fds(hisi_acc_vdev);
>>>>  	mutex_lock(&hisi_acc_vdev->open_mutex);
>>>>  	hisi_acc_vdev->dev_opened = false;
>>>> -	iounmap(vf_qm->io_base);
>>>> +	if (hisi_acc_vdev->drv_mode == HW_ACC_MIG_VF_CTRL)
>>>> +		iounmap(vf_qm->io_base);
>>>>  	mutex_unlock(&hisi_acc_vdev->open_mutex);
>>>>  	vfio_pci_core_close_device(core_vdev);
>>>>  }
>>>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>>>> index 91002ceeebc1..d287abe3dd31 100644
>>>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>>>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>>>> @@ -59,6 +59,26 @@
>>>>  #define ACC_DEV_MAGIC_V1	0XCDCDCDCDFEEDAACC
>>>>  #define ACC_DEV_MAGIC_V2	0xAACCFEEDDECADEDE
>>>>  
>>>> +#define QM_MIG_REGION_OFFSET		0x180000
>>>> +#define QM_MIG_REGION_SIZE		0x2000
>>>> +
>>>> +#define QM_SUB_VERSION_ID		0x100210  
>>>
>>> Above SUB_VERSION_ID isn't used.  
>>
>> Yes, this macro variable needs to be removed.
>>
>>>   
>>>> +#define QM_EQC_PF_DW0			0x1c00
>>>> +#define QM_AEQC_PF_DW0			0x1c20  
>>>
>>> Seems like it'd make sense to define these next to the VF offsets and
>>> perhaps even add "VF" to the existing macros for consistency.  Thanks,
>>>  
>>
>> OK, it's better to distinguish between the old offset variable names with "VF"
>> and the newly added PF offset addresses for clarity
>>
>> Thanks,
>> Longfang.
>>
>>> Alex
>>>   
>>>> +
>>>> +/**
>>>> + * On HW_ACC_MIG_VF_CTRL mode, the configuration domain supporting live
>>>> + * migration functionality is located in the latter 32KB of the VF's BAR2.
>>>> + * The Guest is only provided with the first 32KB of the VF's BAR2.
>>>> + * On HW_ACC_MIG_PF_CTRL mode, the configuration domain supporting live
>>>> + * migration functionality is located in the PF's BAR2, and the entire 64KB
>>>> + * of the VF's BAR2 is allocated to the Guest.
>>>> + */
>>>> +enum hw_drv_mode {
>>>> +	HW_ACC_MIG_VF_CTRL = 0,
>>>> +	HW_ACC_MIG_PF_CTRL,
>>>> +};
>>>> +
>>>>  struct acc_vf_data {
>>>>  #define QM_MATCH_SIZE offsetofend(struct acc_vf_data, qm_rsv_state)
>>>>  	/* QM match information */
>>>> @@ -125,6 +145,7 @@ struct hisi_acc_vf_core_device {
>>>>  	struct pci_dev *vf_dev;
>>>>  	struct hisi_qm *pf_qm;
>>>>  	struct hisi_qm vf_qm;
>>>> +	int drv_mode;
>>>>  	/*
>>>>  	 * vf_qm_state represents the QM_VF_STATE register value.
>>>>  	 * It is set by Guest driver for the ACC VF dev indicating  
>>>
>>> .
>>>   
> 
> .
> 

