Return-Path: <kvm+bounces-57958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EAF6CB827E3
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 03:29:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0B033BD136
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 01:29:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A88522258C;
	Thu, 18 Sep 2025 01:29:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0049E21FF23;
	Thu, 18 Sep 2025 01:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758158968; cv=none; b=MPf1DY8UG9j4lsn80PDXh/42y0V684ecigEovLT+bWu1d9T25GlXY8MyG+n7zQ8VDxItFewSPhCE8JChjP9/31Pp/ts93DAYa+LULG9pwxCism8psRIDQaayMeWk/LC7Cww9mMpCFSZEWu88FdYCAMjOhaJpeU+vM/l4YMsreBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758158968; c=relaxed/simple;
	bh=ez2fkr5dONlmOttC6XN1ljEu3vqfMLgMBZdN4KT3BjY=;
	h=Subject:From:To:CC:References:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=npKYMWo5NyE+IUnlU+VtpcylVoHNuOKiSYUqGXeTQL/U0rY9WFgZTmRhlDsr/UE1OjO3EKom6lDt5vEEE4uDgLI+Rt5WOtnZmDwGYe9o4LMeoZLHf65b2IRyQxJT3qhkcUSldMGaLXZBUz03QsdokzNwWTdakd/PGODr3Ka2bzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4cRykW0Dz1z27jVG;
	Thu, 18 Sep 2025 09:30:27 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 9D3651A016C;
	Thu, 18 Sep 2025 09:29:16 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Sep 2025 09:29:15 +0800
Subject: Re: [PATCH v9 2/2] hisi_acc_vfio_pci: adapt to new migration
 configuration
From: liulongfang <liulongfang@huawei.com>
To: Shameer Kolothum <shameerkolothum@gmail.com>
CC: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
References: <20250902022505.2034408-1-liulongfang@huawei.com>
 <20250902022505.2034408-3-liulongfang@huawei.com>
 <CAHy=t2_0X4_wqc+zm3Zk8aUPXmsOR57wiGmzR65PFHSa=gTrPA@mail.gmail.com>
 <bb9f8f5a-0cf0-98ef-d7b0-be132b8ce63f@huawei.com>
Message-ID: <b9448065-f2ca-899d-e68a-c17e46546b40@huawei.com>
Date: Thu, 18 Sep 2025 09:29:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <bb9f8f5a-0cf0-98ef-d7b0-be132b8ce63f@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2025/9/11 19:30, liulongfang wrote:
> On 2025/9/11 16:05, Shameer Kolothum wrote:
>> On Tue, 2 Sept 2025 at 03:26, Longfang Liu <liulongfang@huawei.com> wrote:
>>>
>>> On new platforms greater than QM_HW_V3, the migration region has been
>>> relocated from the VF to the PF. The VF's own configuration space is
>>> restored to the complete 64KB, and there is no need to divide the
>>> size of the BAR configuration space equally. The driver should be
>>> modified accordingly to adapt to the new hardware device.
>>>
>>> On the older hardware platform QM_HW_V3, the live migration configuration
>>> region is placed in the latter 32K portion of the VF's BAR2 configuration
>>> space. On the new hardware platform QM_HW_V4, the live migration
>>> configuration region also exists in the same 32K area immediately following
>>> the VF's BAR2, just like on QM_HW_V3.
>>>
>>> However, access to this region is now controlled by hardware. Additionally,
>>> a copy of the live migration configuration region is present in the PF's
>>> BAR2 configuration space. On the new hardware platform QM_HW_V4, when an
>>> older version of the driver is loaded, it behaves like QM_HW_V3 and uses
>>> the configuration region in the VF, ensuring that the live migration
>>> function continues to work normally. When the new version of the driver is
>>> loaded, it directly uses the configuration region in the PF. Meanwhile,
>>> hardware configuration disables the live migration configuration region
>>> in the VF's BAR2: reads return all 0xF values, and writes are silently
>>> ignored.
>>>
>>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>>> Reviewed-by: Shameer Kolothum <shameerkolothum@gmail.com>
>>> ---
>>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 205 ++++++++++++------
>>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  13 ++
>>>  2 files changed, 157 insertions(+), 61 deletions(-)
>>>
>>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>> index 397f5e445136..fcf692a7bd4c 100644
>>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>> @@ -125,6 +125,72 @@ static int qm_get_cqc(struct hisi_qm *qm, u64 *addr)
>>>         return 0;
>>>  }
>>>
>>> +static int qm_get_xqc_regs(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>> +                          struct acc_vf_data *vf_data)
>>> +{
>>> +       struct hisi_qm *qm = &hisi_acc_vdev->vf_qm;
>>> +       struct device *dev = &qm->pdev->dev;
>>> +       u32 eqc_addr, aeqc_addr;
>>> +       int ret;
>>> +
>>> +       if (hisi_acc_vdev->drv_mode == HW_ACC_V3) {
>>> +               eqc_addr = QM_EQC_DW0;
>>> +               aeqc_addr = QM_AEQC_DW0;
>>> +       } else {
>>> +               eqc_addr = QM_EQC_PF_DW0;
>>> +               aeqc_addr = QM_AEQC_PF_DW0;
>>> +       }
>>> +
>>> +       /* QM_EQC_DW has 7 regs */
>>> +       ret = qm_read_regs(qm, eqc_addr, vf_data->qm_eqc_dw, 7);
>>> +       if (ret) {
>>> +               dev_err(dev, "failed to read QM_EQC_DW\n");
>>> +               return ret;
>>> +       }
>>> +
>>> +       /* QM_AEQC_DW has 7 regs */
>>> +       ret = qm_read_regs(qm, aeqc_addr, vf_data->qm_aeqc_dw, 7);
>>> +       if (ret) {
>>> +               dev_err(dev, "failed to read QM_AEQC_DW\n");
>>> +               return ret;
>>> +       }
>>> +
>>> +       return 0;
>>> +}
>>> +
>>> +static int qm_set_xqc_regs(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>> +                          struct acc_vf_data *vf_data)
>>> +{
>>> +       struct hisi_qm *qm = &hisi_acc_vdev->vf_qm;
>>> +       struct device *dev = &qm->pdev->dev;
>>> +       u32 eqc_addr, aeqc_addr;
>>> +       int ret;
>>> +
>>> +       if (hisi_acc_vdev->drv_mode == HW_ACC_V3) {
>>> +               eqc_addr = QM_EQC_DW0;
>>> +               aeqc_addr = QM_AEQC_DW0;
>>> +       } else {
>>> +               eqc_addr = QM_EQC_PF_DW0;
>>> +               aeqc_addr = QM_AEQC_PF_DW0;
>>> +       }
>>> +
>>> +       /* QM_EQC_DW has 7 regs */
>>> +       ret = qm_write_regs(qm, eqc_addr, vf_data->qm_eqc_dw, 7);
>>> +       if (ret) {
>>> +               dev_err(dev, "failed to write QM_EQC_DW\n");
>>> +               return ret;
>>> +       }
>>> +
>>> +       /* QM_AEQC_DW has 7 regs */
>>> +       ret = qm_write_regs(qm, aeqc_addr, vf_data->qm_aeqc_dw, 7);
>>> +       if (ret) {
>>> +               dev_err(dev, "failed to write QM_AEQC_DW\n");
>>> +               return ret;
>>> +       }
>>> +
>>> +       return 0;
>>> +}
>>> +
>>>  static int qm_get_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
>>>  {
>>>         struct device *dev = &qm->pdev->dev;
>>> @@ -167,20 +233,6 @@ static int qm_get_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
>>>                 return ret;
>>>         }
>>>
>>> -       /* QM_EQC_DW has 7 regs */
>>> -       ret = qm_read_regs(qm, QM_EQC_DW0, vf_data->qm_eqc_dw, 7);
>>> -       if (ret) {
>>> -               dev_err(dev, "failed to read QM_EQC_DW\n");
>>> -               return ret;
>>> -       }
>>> -
>>> -       /* QM_AEQC_DW has 7 regs */
>>> -       ret = qm_read_regs(qm, QM_AEQC_DW0, vf_data->qm_aeqc_dw, 7);
>>> -       if (ret) {
>>> -               dev_err(dev, "failed to read QM_AEQC_DW\n");
>>> -               return ret;
>>> -       }
>>> -
>>>         return 0;
>>>  }
>>>
>>> @@ -239,20 +291,6 @@ static int qm_set_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
>>>                 return ret;
>>>         }
>>>
>>> -       /* QM_EQC_DW has 7 regs */
>>> -       ret = qm_write_regs(qm, QM_EQC_DW0, vf_data->qm_eqc_dw, 7);
>>> -       if (ret) {
>>> -               dev_err(dev, "failed to write QM_EQC_DW\n");
>>> -               return ret;
>>> -       }
>>> -
>>> -       /* QM_AEQC_DW has 7 regs */
>>> -       ret = qm_write_regs(qm, QM_AEQC_DW0, vf_data->qm_aeqc_dw, 7);
>>> -       if (ret) {
>>> -               dev_err(dev, "failed to write QM_AEQC_DW\n");
>>> -               return ret;
>>> -       }
>>> -
>>>         return 0;
>>>  }
>>>
>>> @@ -522,6 +560,10 @@ static int vf_qm_load_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>>                 return ret;
>>>         }
>>>
>>> +       ret = qm_set_xqc_regs(hisi_acc_vdev, vf_data);
>>> +       if (ret)
>>> +               return ret;
>>> +
>>>         ret = hisi_qm_mb(qm, QM_MB_CMD_SQC_BT, qm->sqc_dma, 0, 0);
>>>         if (ret) {
>>>                 dev_err(dev, "set sqc failed\n");
>>> @@ -589,6 +631,10 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>>         vf_data->vf_qm_state = QM_READY;
>>>         hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
>>>
>>> +       ret = qm_get_xqc_regs(hisi_acc_vdev, vf_data);
>>> +       if (ret)
>>> +               return ret;
>>> +
>>>         ret = vf_qm_read_data(vf_qm, vf_data);
>>>         if (ret)
>>>                 return ret;
>>> @@ -1186,34 +1232,52 @@ static int hisi_acc_vf_qm_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
>>>  {
>>>         struct vfio_pci_core_device *vdev = &hisi_acc_vdev->core_device;
>>>         struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
>>> +       struct hisi_qm *pf_qm = hisi_acc_vdev->pf_qm;
>>>         struct pci_dev *vf_dev = vdev->pdev;
>>> +       u32 val;
>>>
>>> -       /*
>>> -        * ACC VF dev BAR2 region consists of both functional register space
>>> -        * and migration control register space. For migration to work, we
>>> -        * need access to both. Hence, we map the entire BAR2 region here.
>>> -        * But unnecessarily exposing the migration BAR region to the Guest
>>> -        * has the potential to prevent/corrupt the Guest migration. Hence,
>>> -        * we restrict access to the migration control space from
>>> -        * Guest(Please see mmap/ioctl/read/write override functions).
>>> -        *
>>> -        * Please note that it is OK to expose the entire VF BAR if migration
>>> -        * is not supported or required as this cannot affect the ACC PF
>>> -        * configurations.
>>> -        *
>>> -        * Also the HiSilicon ACC VF devices supported by this driver on
>>> -        * HiSilicon hardware platforms are integrated end point devices
>>> -        * and the platform lacks the capability to perform any PCIe P2P
>>> -        * between these devices.
>>> -        */
>>> +       val = readl(pf_qm->io_base + QM_MIG_REGION_SEL);
>>> +       if (pf_qm->ver > QM_HW_V3 && (val & QM_MIG_REGION_EN))
>>> +               hisi_acc_vdev->drv_mode = HW_ACC_V4;
>>> +       else
>>> +               hisi_acc_vdev->drv_mode = HW_ACC_V3;
>>
>> The check is for > QM_HW_V3 and drv_mode is set to HW_ACC_V4. From our
>> previous discussions I think the expectation is that future hardware will follow
>> this same behaviour. If that is the case, it is better to rename HW_ACC_  to
>> something more specific to this change than use the V3/V4 name.
>>
> 
> If the goal is merely to reflect the context of this change, it would be better to add
> a comment describing this change directly at the variable's declaration.
>

Hi, Shameer:
If there are no further issues, I will continue using the current naming convention and
add comments at the declaration sites.

Thanks.
Longfang.

> 
>>>
>>> -       vf_qm->io_base =
>>> -               ioremap(pci_resource_start(vf_dev, VFIO_PCI_BAR2_REGION_INDEX),
>>> -                       pci_resource_len(vf_dev, VFIO_PCI_BAR2_REGION_INDEX));
>>> -       if (!vf_qm->io_base)
>>> -               return -EIO;
>>> +       if (hisi_acc_vdev->drv_mode == HW_ACC_V4) {
>>> +               /*
>>> +                * On hardware platforms greater than QM_HW_V3, the migration function
>>> +                * register is placed in the BAR2 configuration region of the PF,
>>> +                * and each VF device occupies 8KB of configuration space.
>>> +                */
>>> +               vf_qm->io_base = pf_qm->io_base + QM_MIG_REGION_OFFSET +
>>> +                                hisi_acc_vdev->vf_id * QM_MIG_REGION_SIZE;
>>> +       } else {
>>> +               /*
>>> +                * ACC VF dev BAR2 region consists of both functional register space
>>> +                * and migration control register space. For migration to work, we
>>> +                * need access to both. Hence, we map the entire BAR2 region here.
>>> +                * But unnecessarily exposing the migration BAR region to the Guest
>>> +                * has the potential to prevent/corrupt the Guest migration. Hence,
>>> +                * we restrict access to the migration control space from
>>> +                * Guest(Please see mmap/ioctl/read/write override functions).
>>> +                *
>>> +                * Please note that it is OK to expose the entire VF BAR if migration
>>> +                * is not supported or required as this cannot affect the ACC PF
>>> +                * configurations.
>>> +                *
>>> +                * Also the HiSilicon ACC VF devices supported by this driver on
>>> +                * HiSilicon hardware platforms are integrated end point devices
>>> +                * and the platform lacks the capability to perform any PCIe P2P
>>> +                * between these devices.
>>> +                */
>>>
>>> +               vf_qm->io_base =
>>> +                       ioremap(pci_resource_start(vf_dev, VFIO_PCI_BAR2_REGION_INDEX),
>>> +                               pci_resource_len(vf_dev, VFIO_PCI_BAR2_REGION_INDEX));
>>> +               if (!vf_qm->io_base)
>>> +                       return -EIO;
>>> +       }
>>>         vf_qm->fun_type = QM_HW_VF;
>>> +       vf_qm->ver = pf_qm->ver;
>>
>> I think we were not setting this before. Why now/Who is using this?
>>
> 
> This modification was already present in version v5. If it is not added here,
> abnormal behavior may occur when reading and writing registers, as the different
> types cannot be properly distinguished.
> 
> 
>>>         vf_qm->pdev = vf_dev;
>>>         mutex_init(&vf_qm->mailbox_lock);
>>>
>>> @@ -1250,6 +1314,28 @@ static struct hisi_qm *hisi_acc_get_pf_qm(struct pci_dev *pdev)
>>>         return !IS_ERR(pf_qm) ? pf_qm : NULL;
>>>  }
>>>
>>> +static size_t hisi_acc_get_resource_len(struct vfio_pci_core_device *vdev,
>>> +                                       unsigned int index)
>>> +{
>>> +       struct hisi_acc_vf_core_device *hisi_acc_vdev =
>>> +                       hisi_acc_drvdata(vdev->pdev);
>>> +
>>> +       /*
>>> +        * On the old HW_V3 device, the ACC VF device BAR2
>>> +        * region encompasses both functional register space
>>> +        * and migration control register space.
>>> +        * only the functional region should be report to Guest.
>>> +        */
>>> +       if (hisi_acc_vdev->drv_mode == HW_ACC_V3)
>>> +               return (pci_resource_len(vdev->pdev, index) >> 1);
>>> +       /*
>>> +        * On the new HW device, the migration control register
>>> +        * has been moved to the PF device BAR2 region.
>>> +        * The VF device BAR2 is entirely functional register space.
>>> +        */
>>> +       return pci_resource_len(vdev->pdev, index);
>>
>> Now on a new hardware running,
>>
>> a) Old kernel, BAR2 will be reported as 32M
>> b) New Kernel, BAR2 will be reported as 64M
>>
>> So a  Qemu VM on these will see different BAR sizes for the VFs. Not sure
>> migration will be successful in that case. Have you tried that?
>>
>> I think it will be the same for old HW to new HW migrations as well.
>> I think Alex raised a similar concern for v8.
>>
>> Please double check if these migration use cases matter.
>>
> 
> The concern you raised was previously mentioned by Alex. I have verified it,
> and migration can indeed succeed (provided that the CPU is migratable—on our
> processors, this requires setting CPU's pauth=off).
> Moreover, after migration, the device functions normally.
> 
> Thanks.
> Longfang.
> 
>> Thanks,
>> Shameer
>>
>>> +}
>>> +
>>>  static int hisi_acc_pci_rw_access_check(struct vfio_device *core_vdev,
>>>                                         size_t count, loff_t *ppos,
>>>                                         size_t *new_count)
>>> @@ -1260,8 +1346,9 @@ static int hisi_acc_pci_rw_access_check(struct vfio_device *core_vdev,
>>>
>>>         if (index == VFIO_PCI_BAR2_REGION_INDEX) {
>>>                 loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
>>> -               resource_size_t end = pci_resource_len(vdev->pdev, index) / 2;
>>> +               resource_size_t end;
>>>
>>> +               end = hisi_acc_get_resource_len(vdev, index);
>>>                 /* Check if access is for migration control region */
>>>                 if (pos >= end)
>>>                         return -EINVAL;
>>> @@ -1282,8 +1369,9 @@ static int hisi_acc_vfio_pci_mmap(struct vfio_device *core_vdev,
>>>         index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
>>>         if (index == VFIO_PCI_BAR2_REGION_INDEX) {
>>>                 u64 req_len, pgoff, req_start;
>>> -               resource_size_t end = pci_resource_len(vdev->pdev, index) / 2;
>>> +               resource_size_t end;
>>>
>>> +               end = hisi_acc_get_resource_len(vdev, index);
>>>                 req_len = vma->vm_end - vma->vm_start;
>>>                 pgoff = vma->vm_pgoff &
>>>                         ((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
>>> @@ -1330,7 +1418,6 @@ static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int
>>>         if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
>>>                 struct vfio_pci_core_device *vdev =
>>>                         container_of(core_vdev, struct vfio_pci_core_device, vdev);
>>> -               struct pci_dev *pdev = vdev->pdev;
>>>                 struct vfio_region_info info;
>>>                 unsigned long minsz;
>>>
>>> @@ -1345,12 +1432,7 @@ static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int
>>>                 if (info.index == VFIO_PCI_BAR2_REGION_INDEX) {
>>>                         info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
>>>
>>> -                       /*
>>> -                        * ACC VF dev BAR2 region consists of both functional
>>> -                        * register space and migration control register space.
>>> -                        * Report only the functional region to Guest.
>>> -                        */
>>> -                       info.size = pci_resource_len(pdev, info.index) / 2;
>>> +                       info.size = hisi_acc_get_resource_len(vdev, info.index);
>>>
>>>                         info.flags = VFIO_REGION_INFO_FLAG_READ |
>>>                                         VFIO_REGION_INFO_FLAG_WRITE |
>>> @@ -1521,7 +1603,8 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
>>>         hisi_acc_vf_disable_fds(hisi_acc_vdev);
>>>         mutex_lock(&hisi_acc_vdev->open_mutex);
>>>         hisi_acc_vdev->dev_opened = false;
>>> -       iounmap(vf_qm->io_base);
>>> +       if (hisi_acc_vdev->drv_mode == HW_ACC_V3)
>>> +               iounmap(vf_qm->io_base);
>>>         mutex_unlock(&hisi_acc_vdev->open_mutex);
>>>         vfio_pci_core_close_device(core_vdev);
>>>  }
>>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>>> index 91002ceeebc1..d181cd1a258c 100644
>>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>>> @@ -59,6 +59,18 @@
>>>  #define ACC_DEV_MAGIC_V1       0XCDCDCDCDFEEDAACC
>>>  #define ACC_DEV_MAGIC_V2       0xAACCFEEDDECADEDE
>>>
>>> +#define QM_MIG_REGION_OFFSET           0x180000
>>> +#define QM_MIG_REGION_SIZE             0x2000
>>> +
>>> +#define QM_SUB_VERSION_ID              0x100210
>>> +#define QM_EQC_PF_DW0                  0x1c00
>>> +#define QM_AEQC_PF_DW0                 0x1c20
>>> +
>>> +enum hw_drv_mode {
>>> +       HW_ACC_V3 = 0,
>>> +       HW_ACC_V4,
>>> +};
>>> +
>>>  struct acc_vf_data {
>>>  #define QM_MATCH_SIZE offsetofend(struct acc_vf_data, qm_rsv_state)
>>>         /* QM match information */
>>> @@ -125,6 +137,7 @@ struct hisi_acc_vf_core_device {
>>>         struct pci_dev *vf_dev;
>>>         struct hisi_qm *pf_qm;
>>>         struct hisi_qm vf_qm;
>>> +       int drv_mode;
>>>         /*
>>>          * vf_qm_state represents the QM_VF_STATE register value.
>>>          * It is set by Guest driver for the ACC VF dev indicating
>>> --
>>> 2.33.0
>>>
>> .
>>
> 
> .
> 

