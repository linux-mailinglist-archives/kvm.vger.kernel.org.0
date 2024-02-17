Return-Path: <kvm+bounces-8953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F23F4858D98
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 08:10:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E1E11C2128C
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 07:10:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4A791CD0B;
	Sat, 17 Feb 2024 07:10:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB501CAAA;
	Sat, 17 Feb 2024 07:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708153803; cv=none; b=sUplhQWmh/FKHoZXp3oUz9bGrqYNvgSVZnwXEBmLZHAVTWMCljQadd8FVXz9zk+qHJEian+KW4TZkRgdjpOMHVgrDDJUv5YlIfwtlPD+lFEvF4jlw0JRrK9QdSHFkL+ZgiGxt9jpD16bWwV3yWgQKplIiFj3N1DbAkiNy4OPxMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708153803; c=relaxed/simple;
	bh=W8PdJJxLl0MqVVEXq2QIYBAz9pv9xaN7DYpn755uHQs=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=FVHafSnR5QI6w3UIL/BqnC0mZ2tnR54BN72KOrN/jDlo2cJ+ihFdTkPgpLceSXv22WDAaRT0qlG1NrsqGwGxn3K5CzERO/X2b+OBdMy3ixVjwPxPW3eMA+agxD7ScEvCANSh/hR3AV3bHtIzG8NrLJkdoYOHe9KEXUEx+3DHNO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4TcKDY6w2sz1xnNy;
	Sat, 17 Feb 2024 14:50:05 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id 14F44140485;
	Sat, 17 Feb 2024 14:51:24 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sat, 17 Feb 2024 14:51:21 +0800
Subject: Re: [PATCH v2 2/3] hisi_acc_vfio_pci: register debugfs for hisilicon
 migration driver
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, Jonathan Cameron <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
References: <20240204085610.17720-1-liulongfang@huawei.com>
 <20240204085610.17720-3-liulongfang@huawei.com>
 <0337a36286244e28b26895b24a7b36d3@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <a8a27893-0349-d8b7-1849-08f7f3826e41@huawei.com>
Date: Sat, 17 Feb 2024 14:51:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <0337a36286244e28b26895b24a7b36d3@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600005.china.huawei.com (7.193.23.191)

on 2024/2/5 16:52, Shameerali Kolothum Thodi wrote:
> 
> 
>> -----Original Message-----
>> From: liulongfang <liulongfang@huawei.com>
>> Sent: Sunday, February 4, 2024 8:56 AM
>> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
>> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
>> <jonathan.cameron@huawei.com>
>> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
>> Subject: [PATCH v2 2/3] hisi_acc_vfio_pci: register debugfs for hisilicon
>> migration driver
>>
>> On the debugfs framework of VFIO, if the CONFIG_VFIO_DEBUGFS macro is
>> enabled, the debug function is registered for the live migration driver
>> of the HiSilicon accelerator device.
>>
>> After registering the HiSilicon accelerator device on the debugfs
>> framework of live migration of vfio, a directory file "hisi_acc"
>> of debugfs is created, and then three debug function files are
>> created in this directory:
>>
>>    vfio
>>     |
>>     +---<dev_name1>
>>     |    +---migration
>>     |        +--state
>>     |        +--hisi_acc
>>     |            +--attr
>>     |            +--data
>>     |            +--save
>>     |            +--cmd_state
>>     |
>>     +---<dev_name2>
>>          +---migration
>>              +--state
>>              +--hisi_acc
>>                  +--attr
>>                  +--data
>>                  +--save
>>                  +--cmd_state
>>
>> data file: used to get the migration data from the driver
>> attr file: used to get device attributes parameters from the driver
>> save file: used to read the data of the live migration device and save
>> it to the driver.
>> cmd_state: used to get the cmd channel state for the device.
>>
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> ---
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 197 ++++++++++++++++++
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  11 +
>>  2 files changed, 208 insertions(+)
>>
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> index 00a22a990eb8..e51bbb41c2b3 100644
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> @@ -15,6 +15,7 @@
>>  #include <linux/anon_inodes.h>
>>
>>  #include "hisi_acc_vfio_pci.h"
>> +#include "../../vfio.h"
>>
>>  /* Return 0 on VM acc device ready, -ETIMEDOUT hardware timeout */
>>  static int qm_wait_dev_not_ready(struct hisi_qm *qm)
>> @@ -606,6 +607,18 @@ hisi_acc_check_int_state(struct
>> hisi_acc_vf_core_device *hisi_acc_vdev)
>>  	}
>>  }
>>
>> +static void hisi_acc_vf_migf_save(struct hisi_acc_vf_migration_file
>> *dst_migf,
> 
> Can we please rename this to indicate the debug, similar to other debugfs support
> functions here, something like hisi_acc_vf_debug_migf_save()?
>

This function is not exclusive to debugfs and does not need to be renamed.

>> +	struct hisi_acc_vf_migration_file *src_migf)
>> +{
>> +	if (!dst_migf)
>> +		return;
>> +
>> +	dst_migf->disabled = false;
> 
> Is this set to true anywhere for debugfs migf ?
>

I verified this assignment operation and there is no problem.

>> +	dst_migf->total_length = src_migf->total_length;
>> +	memcpy(&dst_migf->vf_data, &src_migf->vf_data,
>> +		    sizeof(struct acc_vf_data));
>> +}
>> +
>>  static void hisi_acc_vf_disable_fd(struct hisi_acc_vf_migration_file *migf)
>>  {
>>  	mutex_lock(&migf->lock);
>> @@ -618,12 +631,16 @@ static void hisi_acc_vf_disable_fd(struct
>> hisi_acc_vf_migration_file *migf)
>>  static void hisi_acc_vf_disable_fds(struct hisi_acc_vf_core_device
>> *hisi_acc_vdev)
>>  {
>>  	if (hisi_acc_vdev->resuming_migf) {
>> +		hisi_acc_vf_migf_save(hisi_acc_vdev->debug_migf,
>> +						hisi_acc_vdev-
>>> resuming_migf);
>>  		hisi_acc_vf_disable_fd(hisi_acc_vdev->resuming_migf);
>>  		fput(hisi_acc_vdev->resuming_migf->filp);
>>  		hisi_acc_vdev->resuming_migf = NULL;
>>  	}
>>
>>  	if (hisi_acc_vdev->saving_migf) {
>> +		hisi_acc_vf_migf_save(hisi_acc_vdev->debug_migf,
>> +						hisi_acc_vdev->saving_migf);
>>  		hisi_acc_vf_disable_fd(hisi_acc_vdev->saving_migf);
>>  		fput(hisi_acc_vdev->saving_migf->filp);
>>  		hisi_acc_vdev->saving_migf = NULL;
>> @@ -1156,6 +1173,7 @@ static int hisi_acc_vf_qm_init(struct
>> hisi_acc_vf_core_device *hisi_acc_vdev)
>>  	if (!vf_qm->io_base)
>>  		return -EIO;
>>
>> +	mutex_init(&hisi_acc_vdev->enable_mutex);
>>  	vf_qm->fun_type = QM_HW_VF;
>>  	vf_qm->pdev = vf_dev;
>>  	mutex_init(&vf_qm->mailbox_lock);
>> @@ -1306,6 +1324,176 @@ static long hisi_acc_vfio_pci_ioctl(struct
>> vfio_device *core_vdev, unsigned int
>>  	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
>>  }
>>
>> +static int hisi_acc_vf_debug_check(struct seq_file *seq, struct vfio_device
>> *vdev)
>> +{
>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>> hisi_acc_get_vf_dev(vdev);
>> +	struct hisi_acc_vf_migration_file *migf = hisi_acc_vdev->debug_migf;
>> +
>> +	if (!vdev->mig_ops || !migf) {
>> +		seq_printf(seq, "%s\n", "device does not support live
>> migration!");
>> +		return -EINVAL;
>> +	}
>> +
>> +	/**
>> +	 * When the device is not opened, the io_base is not mapped.
>> +	 * The driver cannot perform device read and write operations.
>> +	 */
>> +	if (atomic_read(&hisi_acc_vdev->dev_opened) != DEV_OPEN) {
>> +		seq_printf(seq, "%s\n", "device not opened!");
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int hisi_acc_vf_debug_cmd(struct seq_file *seq, void *data)
>> +{
>> +	struct device *vf_dev = seq->private;
>> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
>> +	struct vfio_device *vdev = &core_device->vdev;
>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>> hisi_acc_get_vf_dev(vdev);
>> +	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
>> +	u64 value;
>> +	int ret;
>> +
>> +	mutex_lock(&hisi_acc_vdev->enable_mutex);
>> +	ret = hisi_acc_vf_debug_check(seq, vdev);
>> +	if (ret) {
>> +		mutex_unlock(&hisi_acc_vdev->enable_mutex);
>> +		return 0;
>> +	}
>> +
>> +	ret = qm_wait_dev_not_ready(vf_qm);
>> +	if (ret) {
>> +		mutex_unlock(&hisi_acc_vdev->enable_mutex);
>> +		seq_printf(seq, "%s\n", "VF device not ready!");
>> +		return 0;
>> +	}
>> +
>> +	value = readl(vf_qm->io_base + QM_MB_CMD_SEND_BASE);
>> +	mutex_unlock(&hisi_acc_vdev->enable_mutex);
>> +	seq_printf(seq, "%s:0x%llx\n", "mailbox cmd channel state is OK",
>> value);
>> +
>> +	return 0;
>> +}
>> +
>> +static int hisi_acc_vf_debug_save(struct seq_file *seq, void *data)
>> +{
>> +	struct device *vf_dev = seq->private;
>> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
>> +	struct vfio_device *vdev = &core_device->vdev;
>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>> hisi_acc_get_vf_dev(vdev);
>> +	struct hisi_acc_vf_migration_file *migf = hisi_acc_vdev->debug_migf;
>> +	int ret;
>> +
>> +	mutex_lock(&hisi_acc_vdev->enable_mutex);
>> +	ret = hisi_acc_vf_debug_check(seq, vdev);
>> +	if (ret) {
>> +		mutex_unlock(&hisi_acc_vdev->enable_mutex);
>> +		return 0;
>> +	}
>> +
>> +	ret = vf_qm_state_save(hisi_acc_vdev, migf);
> 
> Are you sure this will not interfere with the core migration APIs as we are not
> holding the state_mutex?. I think Alex also raised a similar concern previously. 

Yes, it is possible that the qemu live migration operation will be executed at the same time
as the debugfs operation.
At this time, the operation of debugfs needs to be disabled.

> Applies to other debugfs interfaces here as well. Please check.
> 
> 
>> +	if (ret) {
>> +		mutex_unlock(&hisi_acc_vdev->enable_mutex);
>> +		seq_printf(seq, "%s\n", "failed to save device data!");
>> +		return 0;
>> +	}
>> +	mutex_unlock(&hisi_acc_vdev->enable_mutex);
>> +	seq_printf(seq, "%s\n", "successful to save device data!");
>> +
>> +	return 0;
>> +}
>> +
>> +static int hisi_acc_vf_data_read(struct seq_file *seq, void *data)
>> +{
>> +	struct device *vf_dev = seq->private;
>> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
>> +	struct vfio_device *vdev = &core_device->vdev;
>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>> hisi_acc_get_vf_dev(vdev);
>> +	struct hisi_acc_vf_migration_file *debug_migf = hisi_acc_vdev-
>>> debug_migf;
>> +	size_t vf_data_sz = offsetofend(struct acc_vf_data, padding);
>> +
>> +	if (debug_migf && debug_migf->total_length)
>> +		seq_hex_dump(seq, "Mig Data:", DUMP_PREFIX_OFFSET, 16,
>> 1,
>> +				(unsigned char *)&debug_migf->vf_data,
>> +				vf_data_sz, false);
>> +	else
>> +		seq_printf(seq, "%s\n", "device not migrated!");
>> +
>> +	return 0;
>> +}
>> +
>> +static int hisi_acc_vf_attr_read(struct seq_file *seq, void *data)
>> +{
>> +	struct device *vf_dev = seq->private;
>> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
>> +	struct vfio_device *vdev = &core_device->vdev;
>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>> hisi_acc_get_vf_dev(vdev);
>> +	struct hisi_acc_vf_migration_file *debug_migf = hisi_acc_vdev-
>>> debug_migf;
>> +
>> +	if (debug_migf && debug_migf->total_length) {
>> +		seq_printf(seq,
>> +			 "acc device:\n"
>> +			 "device  state: %d\n"
>> +			 "device  ready: %u\n"
>> +			 "data    valid: %d\n"
>> +			 "data     size: %lu\n",
>> +			 hisi_acc_vdev->mig_state,
>> +			 hisi_acc_vdev->vf_qm_state,
>> +			 debug_migf->disabled,
>> +			 debug_migf->total_length);
>> +	} else {
>> +		seq_printf(seq, "%s\n", "device not migrated!");
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int hisi_acc_vfio_debug_init(struct hisi_acc_vf_core_device
>> *hisi_acc_vdev)
>> +{
>> +	struct vfio_device *vdev = &hisi_acc_vdev->core_device.vdev;
>> +	struct dentry *vfio_dev_migration = NULL;
>> +	struct dentry *vfio_hisi_acc = NULL;
>> +	struct device *dev = vdev->dev;
>> +	void *migf = NULL;
>> +
>> +	if (!debugfs_initialized())
>> +		return 0;
>> +
>> +	migf = kzalloc(sizeof(struct hisi_acc_vf_migration_file), GFP_KERNEL);
>> +	if (!migf)
>> +		return -ENOMEM;
>> +	hisi_acc_vdev->debug_migf = migf;
>> +
>> +	vfio_dev_migration = debugfs_lookup("migration", vdev-
>>> debug_root);
>> +	if (!vfio_dev_migration) {
>> +		kfree(migf);
>> +		dev_err(dev, "failed to lookup migration debugfs file!\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	vfio_hisi_acc = debugfs_create_dir("hisi_acc", vfio_dev_migration);
>> +	debugfs_create_devm_seqfile(dev, "data", vfio_hisi_acc,
>> +				  hisi_acc_vf_data_read);
>> +	debugfs_create_devm_seqfile(dev, "attr", vfio_hisi_acc,
>> +				  hisi_acc_vf_attr_read);
>> +	debugfs_create_devm_seqfile(dev, "cmd_state", vfio_hisi_acc,
>> +				  hisi_acc_vf_debug_cmd);
>> +	debugfs_create_devm_seqfile(dev, "save", vfio_hisi_acc,
>> +				  hisi_acc_vf_debug_save);
>> +
>> +	return 0;
>> +}
>> +
>> +static void hisi_acc_vf_debugfs_exit(struct hisi_acc_vf_core_device
>> *hisi_acc_vdev)
>> +{
>> +	if (!debugfs_initialized())
>> +		return;
>> +
>> +	kfree(hisi_acc_vdev->debug_migf);
>> +}
>> +
>>  static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
>>  {
>>  	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>> hisi_acc_get_vf_dev(core_vdev);
>> @@ -1323,9 +1511,11 @@ static int hisi_acc_vfio_pci_open_device(struct
>> vfio_device *core_vdev)
>>  			return ret;
>>  		}
>>  		hisi_acc_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
>> +		atomic_set(&hisi_acc_vdev->dev_opened, DEV_OPEN);
>>  	}
>>
>>  	vfio_pci_core_finish_enable(vdev);
>> +
>>  	return 0;
>>  }
>>
>> @@ -1334,7 +1524,10 @@ static void hisi_acc_vfio_pci_close_device(struct
>> vfio_device *core_vdev)
>>  	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>> hisi_acc_get_vf_dev(core_vdev);
>>  	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
>>
>> +	atomic_set(&hisi_acc_vdev->dev_opened, DEV_CLOSE);
>> +	mutex_lock(&hisi_acc_vdev->enable_mutex);
>>  	iounmap(vf_qm->io_base);
>> +	mutex_unlock(&hisi_acc_vdev->enable_mutex);
>>  	vfio_pci_core_close_device(core_vdev);
>>  }
>>
>> @@ -1425,6 +1618,9 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev
>> *pdev, const struct pci_device
>>  	ret = vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
>>  	if (ret)
>>  		goto out_put_vdev;
>> +
>> +	if (ops == &hisi_acc_vfio_pci_migrn_ops)
>> +		hisi_acc_vfio_debug_init(hisi_acc_vdev);
>>  	return 0;
>>
>>  out_put_vdev:
>> @@ -1437,6 +1633,7 @@ static void hisi_acc_vfio_pci_remove(struct pci_dev
>> *pdev)
>>  	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>> hisi_acc_drvdata(pdev);
>>
>>  	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
>> +	hisi_acc_vf_debugfs_exit(hisi_acc_vdev);
>>  	vfio_put_device(&hisi_acc_vdev->core_device.vdev);
>>  }
>>
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> index dcabfeec6ca1..283bd8acdc42 100644
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> @@ -49,6 +49,11 @@
>>  #define QM_EQC_DW0		0X8000
>>  #define QM_AEQC_DW0		0X8020
>>
>> +enum acc_dev_state {
>> +	DEV_CLOSE = 0x0,
>> +	DEV_OPEN,
>> +};
> 
> Do we really need this enum as you can directly use 0 or 1?
>

Use enumeration types to make it easier to understand the functionality of the code.

Thanks,
Longfang.

> Thanks,
> Shameer
> 
>> +
>>  struct acc_vf_data {
>>  #define QM_MATCH_SIZE offsetofend(struct acc_vf_data, qm_rsv_state)
>>  	/* QM match information */
>> @@ -113,5 +118,11 @@ struct hisi_acc_vf_core_device {
>>  	spinlock_t reset_lock;
>>  	struct hisi_acc_vf_migration_file *resuming_migf;
>>  	struct hisi_acc_vf_migration_file *saving_migf;
>> +
>> +	/* To make sure the device is enabled */
>> +	struct mutex enable_mutex;
>> +	atomic_t dev_opened;
>> +	/* For debugfs */
>> +	struct hisi_acc_vf_migration_file *debug_migf;
>>  };
>>  #endif /* HISI_ACC_VFIO_PCI_H */
>> --
>> 2.24.0
> 
> .
> 

