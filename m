Return-Path: <kvm+bounces-25134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D4609605B2
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 11:35:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22E421F230B4
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 09:35:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 701DC19DF65;
	Tue, 27 Aug 2024 09:35:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C10B13BAE4;
	Tue, 27 Aug 2024 09:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724751329; cv=none; b=Ix0F9yfitdg9juFyZDosHKdRs5ZjOlsmT5M4PyBiJrlwHnde2Vc3VvjXyMk6Emq2F6mLOWlxeFej0HeLkCL76w480vvyjQ4LfMfxjpfkEszFHkciuDraqFrYgLPbFd/uCvIcALZliJTOTHn6FxsQgKwvjlRG884zDmlYt4RMNwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724751329; c=relaxed/simple;
	bh=xtE1GK/9j/0iqiAPcbdJYyz5fgF+PtuY3yJdo5UC2+M=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=B7VCpz12c6jdedwXLgiTKeIIEjtTGygvlfZRnm5BlZsYoxP2xIkXvvRShEJzHKyKZf/kc4ugTbOeYRhpsK3vQPBjEtMYyssog+0965aQbFJCnMZQL9jd11grzVtLfjBPjmUdNTARFGedvaPpj4rbaFFeIQc0vI1foo615iYasCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4WtMmQ16RSz1xvll;
	Tue, 27 Aug 2024 17:33:26 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id 518431400F4;
	Tue, 27 Aug 2024 17:35:23 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 27 Aug 2024 17:35:22 +0800
Subject: Re: [PATCH v8 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon
 migration driver
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
References: <20240806122928.46187-1-liulongfang@huawei.com>
 <20240806122928.46187-4-liulongfang@huawei.com>
 <20240826150635.113aba4c.alex.williamson@redhat.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <f881566f-ba70-7809-2486-786de6ebf543@huawei.com>
Date: Tue, 27 Aug 2024 17:35:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240826150635.113aba4c.alex.williamson@redhat.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600005.china.huawei.com (7.193.23.191)

On 2024/8/27 5:06, Alex Williamson wrote:
> On Tue, 6 Aug 2024 20:29:27 +0800
> Longfang Liu <liulongfang@huawei.com> wrote:
> 
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
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 209 ++++++++++++++++++
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |   6 +
>>  2 files changed, 215 insertions(+)
>>
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> index a8c53952d82e..379657904f86 100644
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> @@ -627,15 +627,30 @@ static void hisi_acc_vf_disable_fd(struct hisi_acc_vf_migration_file *migf)
>>  	mutex_unlock(&migf->lock);
>>  }
>>  
>> +static void hisi_acc_debug_migf_copy(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>> +	struct hisi_acc_vf_migration_file *src_migf)
>> +{
>> +	struct hisi_acc_vf_migration_file *dst_migf = hisi_acc_vdev->debug_migf;
>> +
>> +	if (!dst_migf)
>> +		return;
>> +
>> +	dst_migf->total_length = src_migf->total_length;
>> +	memcpy(&dst_migf->vf_data, &src_migf->vf_data,
>> +		sizeof(struct acc_vf_data));
>> +}
>> +
>>  static void hisi_acc_vf_disable_fds(struct hisi_acc_vf_core_device *hisi_acc_vdev)
>>  {
>>  	if (hisi_acc_vdev->resuming_migf) {
>> +		hisi_acc_debug_migf_copy(hisi_acc_vdev, hisi_acc_vdev->resuming_migf);
>>  		hisi_acc_vf_disable_fd(hisi_acc_vdev->resuming_migf);
>>  		fput(hisi_acc_vdev->resuming_migf->filp);
>>  		hisi_acc_vdev->resuming_migf = NULL;
>>  	}
>>  
>>  	if (hisi_acc_vdev->saving_migf) {
>> +		hisi_acc_debug_migf_copy(hisi_acc_vdev, hisi_acc_vdev->saving_migf);
>>  		hisi_acc_vf_disable_fd(hisi_acc_vdev->saving_migf);
>>  		fput(hisi_acc_vdev->saving_migf->filp);
>>  		hisi_acc_vdev->saving_migf = NULL;
>> @@ -1294,6 +1309,191 @@ static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int
>>  	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
>>  }
>>  
>> +static int hisi_acc_vf_debug_check(struct seq_file *seq, struct vfio_device *vdev)
>> +{
>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
>> +	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
>> +	int ret;
>> +
>> +	lockdep_assert_held(&hisi_acc_vdev->state_mutex);
>> +	if (!vdev->mig_ops) {
>> +		seq_printf(seq, "%s\n", "device does not support live migration!\n");
>> +		return -EINVAL;
>> +	}
> 
> I don't think it's possible for this to be called with this condition,
> the debugfs files are only registered when this exists.
> 
> Also, we don't need %s for a fixed string, nor do we need multiple new
> lines.  Please fix throughout.
>

Yes, I looked at the creation process. The debugfs directory only exists
when mig_ops is enabled.
The judgment here is not required.

>> +
>> +	/*
>> +	 * When the device is not opened, the io_base is not mapped.
>> +	 * The driver cannot perform device read and write operations.
>> +	 */
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
>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
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
> 
> This debugfs entry seems pretty pointless to me.  Also we polled for
> the device to be ready in debug_check, so if the channel is not ready
> aren't we more likely to see any error (without a seq_printf) in the
> first error branch?
>

This cmd channel check is a means to assist problem location.
The accelerator IO device has some special exception errors,
which will cause the bus to become unresponsive and cause a long
period of silence.
In another scenario, after the live migration command is started,
dirty pages may be generated very quickly, causing the migration
to be silent for a long time.
The cmd channel check here is to deal with this type of problem and
is used to determine whether the bus is abnormal or dirty pages
are being migrated.

>> +
>> +	return 0;
>> +}
>> +
>> +static int hisi_acc_vf_dev_read(struct seq_file *seq, void *data)
>> +{
>> +	struct device *vf_dev = seq->private;
>> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
>> +	struct vfio_device *vdev = &core_device->vdev;
>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
>> +	size_t vf_data_sz = offsetofend(struct acc_vf_data, padding);
>> +	struct acc_vf_data *vf_data = NULL;
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
>> +		 "data     size: %lu\n",
>> +		 hisi_acc_vdev->vf_qm_state,
>> +		 hisi_acc_vdev->dev_opened,
>> +		 sizeof(struct acc_vf_data));
> 
> This function called hisi_acc_vf_debug_check() which requires the
> device to be opened, therefore except for the race where the unlock
> allowed the device to close, what is the purpose of printing the opened
> state here?  We can also tell from the hex dump the size of the data,
> so why is that value printed here?  vf_qm_state appears to be a state
> value rather than a bool, so labeling it as "ready" doesn't make much
> sense.  The arbitrary white space also doesn't make much sense.
>

The purpose of vf_qm_state is not to indicate whether the current device
is open. It refers to whether the VF device in the VM has a
device driver loaded.

The operation process of live migration is different when the driver
is loaded and when the driver is not loaded.
If the driver is not loaded, then the current IO device must not be
running tasks, so the data migration of the IO device can be directly
skipped during live migration.
Therefore, this status is very useful.

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
>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
>> +	size_t vf_data_sz = offsetofend(struct acc_vf_data, padding);
>> +	struct hisi_acc_vf_migration_file *debug_migf = hisi_acc_vdev->debug_migf;
>> +
>> +	/* Check whether the live migration operation has been performed */
>> +	if (debug_migf->total_length < QM_MATCH_SIZE) {
>> +		seq_printf(seq, "%s\n", "device not migrated!\n");
>> +		return -EAGAIN;
>> +	}
>> +
>> +	seq_hex_dump(seq, "Mig Data:", DUMP_PREFIX_OFFSET, 16, 1,
>> +			(unsigned char *)&debug_migf->vf_data,
>> +			vf_data_sz, false);
> 
> Why doesn't this stop at total_length?
>

Next is the address data of the device.
The address data cannot be directly output to the log.

>> +
>> +	seq_printf(seq,
>> +		 "acc device:\n"
>> +		 "device  ready: %u\n"
>> +		 "device  opened: %d\n"
>> +		 "data     size: %lu\n",
>> +		 hisi_acc_vdev->vf_qm_state,
>> +		 hisi_acc_vdev->dev_opened,
>> +		 debug_migf->total_length);
> 
> Again, "ready" seems more like a "state" value, here opened could be
> false, but why do we care(?), size could be inferred from the hex dump,
> and white spaces are arbitrary.
>

The spaces can be modified to keep the output results aligned.

When dev_opened here only has log, you can know whether the dump
operation was read before or after qemu was closed.

This detailed information is still necessary when only logs are used
for problem analysis.

>> +
>> +	return 0;
>> +}
>> +
>> +static int hisi_acc_vfio_debug_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
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
>> +	vfio_dev_migration = debugfs_lookup("migration", vdev->debug_root);
> 
> Test this before anything is allocated or assigned.
>

OK.

Thanks.
Longfang.

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
> 
> Why does this function return an int when the only caller ignores the
> return value?
> 
>> +
>> +static void hisi_acc_vf_debugfs_exit(struct hisi_acc_vf_core_device *hisi_acc_vdev)
>> +{
>> +	if (!debugfs_initialized() ||
>> +	    !IS_ENABLED(CONFIG_VFIO_DEBUGFS))
>> +		return;
> 
> Do we really need to test these on the exit path?  debug_migf would not
> be allocated.
> 
>> +
>> +	if (hisi_acc_vdev->debug_migf)
>> +		kfree(hisi_acc_vdev->debug_migf);
> 
> I suppose this is not set NULL because this is only called in the
> device remove path.
> 
>> +}
>> +
>>  static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
>>  {
>>  	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(core_vdev);
>> @@ -1311,9 +1511,11 @@ static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
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
>> @@ -1322,7 +1524,10 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
>>  	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(core_vdev);
>>  	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
>>  
>> +	mutex_lock(&hisi_acc_vdev->state_mutex);
>> +	hisi_acc_vdev->dev_opened = false;
>>  	iounmap(vf_qm->io_base);
>> +	mutex_unlock(&hisi_acc_vdev->state_mutex);
> 
> Co-opting the state_mutex to protect dev_opened is rather sketchy.
> 
>>  	vfio_pci_core_close_device(core_vdev);
>>  }
>>  
>> @@ -1413,6 +1618,9 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
>>  	ret = vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
>>  	if (ret)
>>  		goto out_put_vdev;
>> +
>> +	if (ops == &hisi_acc_vfio_pci_migrn_ops)
>> +		hisi_acc_vfio_debug_init(hisi_acc_vdev);
> 
> Call this unconditionally and test hisi_acc_vdev->mig_ops in the
> debug_init function.  That way init and exit are symmetric.
> 
>>  	return 0;
>>  
>>  out_put_vdev:
>> @@ -1425,6 +1633,7 @@ static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
>>  	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
>>  
>>  	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
>> +	hisi_acc_vf_debugfs_exit(hisi_acc_vdev);
>>  	vfio_put_device(&hisi_acc_vdev->core_device.vdev);
>>  }
>>  
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
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
> 
> Poor structure packing.
> 
>>  };
>>  #endif /* HISI_ACC_VFIO_PCI_H */
> 
> 
> .
> 

