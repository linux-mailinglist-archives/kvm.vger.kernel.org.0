Return-Path: <kvm+bounces-23323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E206B948B55
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 10:30:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E0A128261D
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 08:30:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75E821BD016;
	Tue,  6 Aug 2024 08:30:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD45165EEF;
	Tue,  6 Aug 2024 08:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722933022; cv=none; b=ln34Asvc+bt8B+7IfizL5dTkBIHWoPbC5CMsmUdozGKuGkeWk77cYdTRYnsfLFE4yK95hrUYf2Omu80a+0Db5VxE5ZCF185uXUrHuY4UoflFJ8Wx8uF5FqOrLiPkGpfwpcZcb0tbqxd0hTzNI6D5Z+8kDyCxMZ5stf6mM0/sj+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722933022; c=relaxed/simple;
	bh=4OzqHMMs20NWc0Q9CyTqUOw3Z1niloilmacbTy6Cvvg=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=eTIsfAArKVUazgjTva6OS9ZaaCJ5lpW7ykuYR3SZVqTW8XLYbE9HNHa2MD6OaX3JD6kr3/K7cJnxe9w+GxlvgD6lBrlMBljnL2qWN+3PKbYty/zYd1ctNNqa6jHNHetjhU5/mjCFV/6Qyy2dLUheKwIFFEowGK2DYhdhYcFOMTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WdRM42kRVzcd6S;
	Tue,  6 Aug 2024 16:30:08 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id 6334C1403D4;
	Tue,  6 Aug 2024 16:30:14 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 6 Aug 2024 16:30:13 +0800
Subject: Re: [PATCH v7 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon
 migration driver
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, Jonathan Cameron <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
References: <20240730121438.58455-1-liulongfang@huawei.com>
 <20240730121438.58455-4-liulongfang@huawei.com>
 <d3df247106fb4d38b4b9cfbfc956f6dc@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <28e40811-b02b-2c59-a165-72e96727a4fd@huawei.com>
Date: Tue, 6 Aug 2024 16:30:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <d3df247106fb4d38b4b9cfbfc956f6dc@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600005.china.huawei.com (7.193.23.191)

On 2024/8/5 16:51, Shameerali Kolothum Thodi wrote:
> 
> 
>> -----Original Message-----
>> From: liulongfang <liulongfang@huawei.com>
>> Sent: Tuesday, July 30, 2024 1:15 PM
>> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
>> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
>> <jonathan.cameron@huawei.com>
>> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
>> Subject: [PATCH v7 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon
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
>>     |            +--dev_data
>>     |            +--migf_data
>>     |            +--cmd_state
>>     |
>>     +---<dev_name2>
>>          +---migration
>>              +--state
>>              +--hisi_acc
>>                  +--dev_data
>>                  +--migf_data
>>                  +--cmd_state
>>
>> dev_data file: read device data that needs to be migrated from the
>> current device in real time
>> migf_data file: read the migration data of the last live migration
>> from the current driver.
>> cmd_state: used to get the cmd channel state for the device.
>>
>> +----------------+        +--------------+       +---------------+
>> | migration dev  |        |   src  dev   |       |   dst  dev    |
>> +-------+--------+        +------+-------+       +-------+-------+
>>         |                        |                       |
>>         |                 +------v-------+       +-------v-------+
>>         |                 |  saving_migf |       | resuming_migf |
>>   read  |                 |     file     |       |     file      |
>>         |                 +------+-------+       +-------+-------+
>>         |                        |          copy         |
>>         |                        +------------+----------+
>>         |                                     |
>> +-------v--------+                    +-------v--------+
>> |   data buffer  |                    |   debug_migf   |
>> +-------+--------+                    +-------+--------+
>>         |                                     |
>>    cat  |                                 cat |
>> +-------v--------+                    +-------v--------+
>> |   dev_data     |                    |   migf_data    |
>> +----------------+                    +----------------+
>>
>> When accessing debugfs, user can obtain the most recent status data
>> of the device through the "dev_data" file. It can read recent
>> complete status data of the device. If the current device is being
>> migrated, it will wait for it to complete.
>> The data for the last completed migration function will be stored
>> in debug_migf. Users can read it via "migf_data".
>>
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> ---
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 220 ++++++++++++++++++
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |   6 +
>>  2 files changed, 226 insertions(+)
>>
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> index a8c53952d82e..ae8946901e73 100644
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> @@ -627,15 +627,31 @@ static void hisi_acc_vf_disable_fd(struct
>> hisi_acc_vf_migration_file *migf)
>>  	mutex_unlock(&migf->lock);
>>  }
>>
>> +static void hisi_acc_debug_migf_copy(struct hisi_acc_vf_core_device
>> *hisi_acc_vdev,
>> +	struct hisi_acc_vf_migration_file *src_migf)
>> +{
>> +	struct hisi_acc_vf_migration_file *dst_migf = hisi_acc_vdev-
>>> debug_migf;
>> +
>> +	if (!dst_migf)
>> +		return;
>> +
>> +	dst_migf->disabled = true;
> 
> This is always set to true, then why bother printing this as part of migf_data
> below?.  See also comments on "disabled" below. Is there any value in giving 
> this info to user?
> 
>> +	dst_migf->total_length = src_migf->total_length;
>> +	memcpy(&dst_migf->vf_data, &src_migf->vf_data,
>> +		sizeof(struct acc_vf_data));
>> +}
>> +
>>  static void hisi_acc_vf_disable_fds(struct hisi_acc_vf_core_device
>> *hisi_acc_vdev)
>>  {
>>  	if (hisi_acc_vdev->resuming_migf) {
>> +		hisi_acc_debug_migf_copy(hisi_acc_vdev, hisi_acc_vdev-
>>> resuming_migf);
>>  		hisi_acc_vf_disable_fd(hisi_acc_vdev->resuming_migf);
>>  		fput(hisi_acc_vdev->resuming_migf->filp);
>>  		hisi_acc_vdev->resuming_migf = NULL;
>>  	}
>>
>>  	if (hisi_acc_vdev->saving_migf) {
>> +		hisi_acc_debug_migf_copy(hisi_acc_vdev, hisi_acc_vdev-
>>> saving_migf);
>>  		hisi_acc_vf_disable_fd(hisi_acc_vdev->saving_migf);
>>  		fput(hisi_acc_vdev->saving_migf->filp);
>>  		hisi_acc_vdev->saving_migf = NULL;
>> @@ -1294,6 +1310,201 @@ static long hisi_acc_vfio_pci_ioctl(struct
>> vfio_device *core_vdev, unsigned int
>>  	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
>>  }
>>
>> +static int hisi_acc_vf_debug_check(struct seq_file *seq, struct vfio_device
>> *vdev)
>> +{
>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>> hisi_acc_get_vf_dev(vdev);
>> +	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
>> +	int ret;
>> +
>> +	if (!vdev->mig_ops) {
>> +		seq_printf(seq, "%s\n", "device does not support live
>> migration!\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	/*
>> +	 * When the device is not opened, the io_base is not mapped.
>> +	 * The driver cannot perform device read and write operations.
>> +	 */
> 
> I think it is better you make sure the lock is held in this function before
> checking this. Use lockdep_assert_held(lock).
>

OK.

>> +	if (!hisi_acc_vdev->dev_opened) {
>> +		seq_printf(seq, "%s\n", "device not opened!\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	ret = qm_wait_dev_not_ready(vf_qm);
>> +	if (ret) {
>> +		seq_printf(seq, "%s\n", "VF device not ready!\n");
>> +		return -EBUSY;
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
>> +	mutex_lock(&hisi_acc_vdev->state_mutex);
>> +	ret = hisi_acc_vf_debug_check(seq, vdev);
>> +	if (ret) {
>> +		mutex_unlock(&hisi_acc_vdev->state_mutex);
>> +		return ret;
>> +	}
>> +
>> +	value = readl(vf_qm->io_base + QM_MB_CMD_SEND_BASE);
>> +	if (value == QM_MB_CMD_NOT_READY) {
>> +		mutex_unlock(&hisi_acc_vdev->state_mutex);
>> +		seq_printf(seq, "mailbox cmd channel not ready!\n");
>> +		return -EINVAL;
>> +	}
>> +	mutex_unlock(&hisi_acc_vdev->state_mutex);
>> +	seq_printf(seq, "mailbox cmd channel ready!\n");
>> +
>> +	return 0;
>> +}
>> +
>> +static int hisi_acc_vf_dev_read(struct seq_file *seq, void *data)
>> +{
>> +	struct device *vf_dev = seq->private;
>> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
>> +	struct vfio_device *vdev = &core_device->vdev;
>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>> hisi_acc_get_vf_dev(vdev);
>> +	size_t vf_data_sz = offsetofend(struct acc_vf_data, padding);
>> +	struct acc_vf_data *vf_data = NULL;
>> +	bool migf_state;
>> +	int ret;
>> +
>> +	vf_data = kzalloc(sizeof(struct acc_vf_data), GFP_KERNEL);
>> +	if (!vf_data)
>> +		return -ENOMEM;
>> +
>> +	mutex_lock(&hisi_acc_vdev->state_mutex);
>> +	ret = hisi_acc_vf_debug_check(seq, vdev);
>> +	if (ret) {
>> +		mutex_unlock(&hisi_acc_vdev->state_mutex);
>> +		goto migf_err;
>> +	}
>> +
>> +	vf_data->vf_qm_state = hisi_acc_vdev->vf_qm_state;
>> +	ret = vf_qm_read_data(&hisi_acc_vdev->vf_qm, vf_data);
>> +	if (ret) {
>> +		mutex_unlock(&hisi_acc_vdev->state_mutex);
>> +		goto migf_err;
>> +	}
>> +
>> +	if (hisi_acc_vdev->resuming_migf)
>> +		migf_state = hisi_acc_vdev->resuming_migf->disabled;
>> +	else if (hisi_acc_vdev->saving_migf)
>> +		migf_state = hisi_acc_vdev->saving_migf->disabled;
>> +	else
>> +		migf_state = true;
> 
> I am still not sure what information we are getting from this "disabled". The value 
> "true" means the migf file is released, isn't it? How is that equivalent to report as "data
> valid" below? Also "migf_state" is misleading here.
>

As a result of our discussion, this information should not be used currently. I will delete
it directly in the next version

Thanks.
Longfang.

> Thanks,
> Shameer
> 
>> +	mutex_unlock(&hisi_acc_vdev->state_mutex);
>> +
>> +	seq_hex_dump(seq, "Dev Data:", DUMP_PREFIX_OFFSET, 16, 1,
>> +			(unsigned char *)vf_data,
>> +			vf_data_sz, false);
>> +
>> +	seq_printf(seq,
>> +		 "acc device:\n"
>> +		 "device  ready: %u\n"
>> +		 "device  opened: %d\n"
>> +		 "data    valid: %d\n"
>> +		 "data     size: %lu\n",
>> +		 hisi_acc_vdev->vf_qm_state,
>> +		 hisi_acc_vdev->dev_opened,
>> +		 migf_state,
>> +		 sizeof(struct acc_vf_data));
>> +
>> +migf_err:
>> +	kfree(vf_data);
>> +
>> +	return ret;
>> +}
>> +
>> +static int hisi_acc_vf_migf_read(struct seq_file *seq, void *data)
>> +{
>> +	struct device *vf_dev = seq->private;
>> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
>> +	struct vfio_device *vdev = &core_device->vdev;
>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>> hisi_acc_get_vf_dev(vdev);
>> +	size_t vf_data_sz = offsetofend(struct acc_vf_data, padding);
>> +	struct hisi_acc_vf_migration_file *debug_migf = hisi_acc_vdev-
>>> debug_migf;
>> +
>> +	/* Check whether the live migration operation has been performed
>> */
>> +	if (debug_migf->total_length < QM_MATCH_SIZE) {
>> +		seq_printf(seq, "%s\n", "device not migrated!\n");
>> +		return -EAGAIN;
>> +	}
>> +
>> +	seq_hex_dump(seq, "Mig Data:", DUMP_PREFIX_OFFSET, 16, 1,
>> +			(unsigned char *)&debug_migf->vf_data,
>> +			vf_data_sz, false);
>> +
>> +	seq_printf(seq,
>> +		 "acc device:\n"
>> +		 "device  ready: %u\n"
>> +		 "device  opened: %d\n"
>> +		 "data    valid: %d\n"
>> +		 "data     size: %lu\n",
>> +		 hisi_acc_vdev->vf_qm_state,
>> +		 hisi_acc_vdev->dev_opened,
>> +		 debug_migf->disabled,
>> +		 debug_migf->total_length);
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
>> +	if (!debugfs_initialized() ||
>> +	    !IS_ENABLED(CONFIG_VFIO_DEBUGFS))
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
>> +		hisi_acc_vdev->debug_migf = NULL;
>> +		dev_err(dev, "failed to lookup migration debugfs file!\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	vfio_hisi_acc = debugfs_create_dir("hisi_acc", vfio_dev_migration);
>> +	debugfs_create_devm_seqfile(dev, "dev_data", vfio_hisi_acc,
>> +				  hisi_acc_vf_dev_read);
>> +	debugfs_create_devm_seqfile(dev, "migf_data", vfio_hisi_acc,
>> +				  hisi_acc_vf_migf_read);
>> +	debugfs_create_devm_seqfile(dev, "cmd_state", vfio_hisi_acc,
>> +				  hisi_acc_vf_debug_cmd);
>> +
>> +	return 0;
>> +}
>> +
>> +static void hisi_acc_vf_debugfs_exit(struct hisi_acc_vf_core_device
>> *hisi_acc_vdev)
>> +{
>> +	if (!debugfs_initialized() ||
>> +	    !IS_ENABLED(CONFIG_VFIO_DEBUGFS))
>> +		return;
>> +
>> +	if (hisi_acc_vdev->debug_migf)
>> +		kfree(hisi_acc_vdev->debug_migf);
>> +}
>> +
>>  static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
>>  {
>>  	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>> hisi_acc_get_vf_dev(core_vdev);
>> @@ -1311,9 +1522,11 @@ static int hisi_acc_vfio_pci_open_device(struct
>> vfio_device *core_vdev)
>>  			return ret;
>>  		}
>>  		hisi_acc_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
>> +		hisi_acc_vdev->dev_opened = true;
>>  	}
>>
>>  	vfio_pci_core_finish_enable(vdev);
>> +
>>  	return 0;
>>  }
>>
>> @@ -1322,7 +1535,10 @@ static void hisi_acc_vfio_pci_close_device(struct
>> vfio_device *core_vdev)
>>  	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>> hisi_acc_get_vf_dev(core_vdev);
>>  	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
>>
>> +	mutex_lock(&hisi_acc_vdev->state_mutex);
>> +	hisi_acc_vdev->dev_opened = false;
>>  	iounmap(vf_qm->io_base);
>> +	mutex_unlock(&hisi_acc_vdev->state_mutex);
>>  	vfio_pci_core_close_device(core_vdev);
>>  }
>>
>> @@ -1413,6 +1629,9 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev
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
>> @@ -1425,6 +1644,7 @@ static void hisi_acc_vfio_pci_remove(struct pci_dev
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
>> index 5bab46602fad..f86f3b88b09e 100644
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> @@ -32,6 +32,7 @@
>>  #define QM_SQC_VFT_BASE_MASK_V2		GENMASK(15, 0)
>>  #define QM_SQC_VFT_NUM_SHIFT_V2		45
>>  #define QM_SQC_VFT_NUM_MASK_V2		GENMASK(9, 0)
>> +#define QM_MB_CMD_NOT_READY	0xffffffff
>>
>>  /* RW regs */
>>  #define QM_REGS_MAX_LEN		7
>> @@ -111,5 +112,10 @@ struct hisi_acc_vf_core_device {
>>  	int vf_id;
>>  	struct hisi_acc_vf_migration_file *resuming_migf;
>>  	struct hisi_acc_vf_migration_file *saving_migf;
>> +
>> +	/* To make sure the device is opened */
>> +	bool dev_opened;
>> +	/* To save migration data */
>> +	struct hisi_acc_vf_migration_file *debug_migf;
>>  };
>>  #endif /* HISI_ACC_VFIO_PCI_H */
>> --
>> 2.24.0
> 
> .
> 

