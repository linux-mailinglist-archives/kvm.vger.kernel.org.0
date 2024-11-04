Return-Path: <kvm+bounces-30449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 75C3C9BAD78
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 08:54:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34D692815A6
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 07:54:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9C2118C028;
	Mon,  4 Nov 2024 07:54:21 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393DF189F45;
	Mon,  4 Nov 2024 07:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730706861; cv=none; b=T2EE42o8YTPXeEowVxbkb2pcDpHRsV05IySnKrf/8v3One1oNuOPR4s9VTXV60U1+0QAdQygcf8P4MVx6mwwQqLDqR9gZdSFTp480nW/LpLlQ5/LDZ9XYnuArY5syMNvDYmQTb4FlOfnqHsrfAYaBYrov0kMyW1Hh0p2zKivDEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730706861; c=relaxed/simple;
	bh=PODyVMssel/ISe3IoFyW46AnrvUkDfEdi5NZKl3E2g0=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=bg2RxvjHtbQb3bwfmdfIYQg7/XbSpRFwMFnd07fTD8L9FtM+nsEsVqTtTsUxu4UuzXskxYoeHRGlvCIQgNVeCq7MHMVb1j1cszdtMy87e64EMPIgOzd1PLQnWqwuBLPKRwPx2cq4iE8tfsul8ByzzvefGR/jJG6lKT2cNwzWP9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4XhkGD2HwYz1jwXY;
	Mon,  4 Nov 2024 15:52:36 +0800 (CST)
Received: from dggemv703-chm.china.huawei.com (unknown [10.3.19.46])
	by mail.maildlp.com (Postfix) with ESMTPS id 752DE1401F3;
	Mon,  4 Nov 2024 15:54:14 +0800 (CST)
Received: from kwepemn100017.china.huawei.com (7.202.194.122) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 4 Nov 2024 15:54:14 +0800
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemn100017.china.huawei.com (7.202.194.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 4 Nov 2024 15:54:13 +0800
Subject: Re: [PATCH v11 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon
 migration driver
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
References: <20241025090143.64472-1-liulongfang@huawei.com>
 <20241025090143.64472-4-liulongfang@huawei.com>
 <20241031160430.59f4b944.alex.williamson@redhat.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <df5129f8-e9c2-b1c0-e2de-9211738d88c4@huawei.com>
Date: Mon, 4 Nov 2024 15:54:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241031160430.59f4b944.alex.williamson@redhat.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemn100017.china.huawei.com (7.202.194.122)

On 2024/11/1 6:04, Alex Williamson wrote:
> On Fri, 25 Oct 2024 17:01:42 +0800
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
>> Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
>> ---
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 204 ++++++++++++++++++
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |   7 +
>>  2 files changed, 211 insertions(+)
>>
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> index a8c53952d82e..0577d4ddfb34 100644
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
>> @@ -1294,6 +1309,140 @@ static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int
>>  	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
>>  }
>>  
>> +static int hisi_acc_vf_debug_check(struct seq_file *seq, struct vfio_device *vdev)
>> +{
>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
>> +	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
>> +	int ret;
>> +
>> +	lockdep_assert_held(&hisi_acc_vdev->open_mutex);
>> +	/*
>> +	 * When the device is not opened, the io_base is not mapped.
>> +	 * The driver cannot perform device read and write operations.
>> +	 */
>> +	if (!hisi_acc_vdev->dev_opened) {
>> +		seq_printf(seq, "device not opened!\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	ret = qm_wait_dev_not_ready(vf_qm);
>> +	if (ret) {
>> +		seq_printf(seq, "VF device not ready!\n");
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
>> +	mutex_lock(&hisi_acc_vdev->open_mutex);
>> +	ret = hisi_acc_vf_debug_check(seq, vdev);
>> +	if (ret) {
>> +		mutex_unlock(&hisi_acc_vdev->open_mutex);
>> +		return ret;
>> +	}
>> +
>> +	value = readl(vf_qm->io_base + QM_MB_CMD_SEND_BASE);
>> +	if (value == QM_MB_CMD_NOT_READY) {
>> +		mutex_unlock(&hisi_acc_vdev->open_mutex);
>> +		seq_printf(seq, "mailbox cmd channel not ready!\n");
>> +		return -EINVAL;
>> +	}
>> +	mutex_unlock(&hisi_acc_vdev->open_mutex);
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
>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
>> +	size_t vf_data_sz = offsetofend(struct acc_vf_data, padding);
>> +	struct acc_vf_data *vf_data = NULL;
> 
> Nit, this initialization is unnecessary.
>

OK, delete it in next version.

>> +	int ret;
>> +
>> +	mutex_lock(&hisi_acc_vdev->open_mutex);
>> +	ret = hisi_acc_vf_debug_check(seq, vdev);
>> +	if (ret) {
>> +		mutex_unlock(&hisi_acc_vdev->open_mutex);
>> +		return ret;
>> +	}
>> +
>> +	mutex_lock(&hisi_acc_vdev->state_mutex);
>> +	vf_data = kzalloc(sizeof(struct acc_vf_data), GFP_KERNEL);
>> +	if (!vf_data) {
>> +		ret = -ENOMEM;
>> +		goto mutex_release;
>> +	}
>> +
>> +	vf_data->vf_qm_state = hisi_acc_vdev->vf_qm_state;
>> +	ret = vf_qm_read_data(&hisi_acc_vdev->vf_qm, vf_data);
>> +	if (ret)
>> +		goto migf_err;
>> +
>> +	seq_hex_dump(seq, "Dev Data:", DUMP_PREFIX_OFFSET, 16, 1,
>> +			(unsigned char *)vf_data,
> 
> Casting to (const void *) would match the prototype.  This line should
> also wrap to just inside the opening parenthesis of the previous line, 2
> tabs, 5 spaces.
>

OK, I will adjust it in the next version.

>> +			vf_data_sz, false);
>> +
>> +	seq_printf(seq,
>> +		 "acc device:\n"
>> +		 "guest driver load: %u\n"
>> +		 "data size: %lu\n",
>> +		 hisi_acc_vdev->vf_qm_state,
>> +		 sizeof(struct acc_vf_data));
> 
> Same here and throughout, wrap aligned to the relevant parenthesis.
>

OK.

> I know you've described vf_qm_state as indicating whether or not the
> guest driver is loaded, but I still can't figure out how to discern
> that from the code.  It's largely only set based on the return value of
> qm_wait_dev_not_ready(), which tests QM_VF_STATE, and describes the
> function as testing if the device is ready.  Improved comments would
> help future reviews.
>

This QM_VF_STATE register will be written to QM_READY when the acc device
driver is loaded, and QM_NOT_READY will be written after the device
driver is unloaded.

I will add a comment where vf_qm_state is declared.

> What's the purpose of the "acc device:" prefix?
>

OK, it can be deleted.

>> +
>> +migf_err:
>> +	kfree(vf_data);
>> +mutex_release:
>> +	mutex_unlock(&hisi_acc_vdev->open_mutex);
>> +	mutex_unlock(&hisi_acc_vdev->state_mutex);
> 
> Locks should be released in the reverse order they were acquired.
>

OK.

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
>> +		seq_printf(seq, "device not migrated!\n");
>> +		return -EAGAIN;
>> +	}
>> +
>> +	seq_hex_dump(seq, "Mig Data:", DUMP_PREFIX_OFFSET, 16, 1,
>> +			(unsigned char *)&debug_migf->vf_data,
>> +			vf_data_sz, false);
>> +
>> +	seq_printf(seq,
>> +		 "acc device:\n"
>> +		 "guest driver load: %u\n"
>> +		 "device opened: %d\n"
>> +		 "migrate data length: %lu\n",
>> +		 hisi_acc_vdev->vf_qm_state,
>> +		 hisi_acc_vdev->dev_opened,
>> +		 debug_migf->total_length);
> 
> This debugfs entry is described as returning the data from the last
> migration, but vf_qm_state and dev_opened are relative to the current
> device/guest driver state.  Both seem to have no relevance to the data
> in debug_migf.
>

The benefit of dev_opened retention is that user can obtain the device status
during the cat migf_data operation.

And vf_qm_state does need to be retained.
Because adding a driver or not adding a driver to the Guest OS has a great impact
on the results of live migration, it is a key factor. It has a great impact on
the success or failure of live migration.

When adding a driver, live migration will read device status data, and data will
be written back to device after the migration is completed.
When no driver is added, live migration only executes a process. It does not
perform data reading and data recovery operations.

>> +
>> +	return 0;
>> +}
>> +
>>  static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
>>  {
>>  	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(core_vdev);
>> @@ -1305,12 +1454,16 @@ static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
>>  		return ret;
>>  
>>  	if (core_vdev->mig_ops) {
>> +		mutex_lock(&hisi_acc_vdev->open_mutex);
>>  		ret = hisi_acc_vf_qm_init(hisi_acc_vdev);
>>  		if (ret) {
>> +			mutex_unlock(&hisi_acc_vdev->open_mutex);
>>  			vfio_pci_core_disable(vdev);
>>  			return ret;
>>  		}
>>  		hisi_acc_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
>> +		hisi_acc_vdev->dev_opened = true;
>> +		mutex_unlock(&hisi_acc_vdev->open_mutex);
>>  	}
>>  
>>  	vfio_pci_core_finish_enable(vdev);
>> @@ -1322,7 +1475,10 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
>>  	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(core_vdev);
>>  	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
>>  
>> +	mutex_lock(&hisi_acc_vdev->open_mutex);
>> +	hisi_acc_vdev->dev_opened = false;
>>  	iounmap(vf_qm->io_base);
>> +	mutex_unlock(&hisi_acc_vdev->open_mutex);
>>  	vfio_pci_core_close_device(core_vdev);
>>  }
>>  
>> @@ -1342,6 +1498,7 @@ static int hisi_acc_vfio_pci_migrn_init_dev(struct vfio_device *core_vdev)
>>  	hisi_acc_vdev->pf_qm = pf_qm;
>>  	hisi_acc_vdev->vf_dev = pdev;
>>  	mutex_init(&hisi_acc_vdev->state_mutex);
>> +	mutex_init(&hisi_acc_vdev->open_mutex);
>>  
>>  	core_vdev->migration_flags = VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_PRE_COPY;
>>  	core_vdev->mig_ops = &hisi_acc_vfio_pci_migrn_state_ops;
>> @@ -1387,6 +1544,50 @@ static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
>>  	.detach_ioas = vfio_iommufd_physical_detach_ioas,
>>  };
>>  
>> +static void hisi_acc_vfio_debug_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
>> +{
>> +	struct vfio_device *vdev = &hisi_acc_vdev->core_device.vdev;
>> +	struct dentry *vfio_dev_migration = NULL;
>> +	struct dentry *vfio_hisi_acc = NULL;
>> +	struct device *dev = vdev->dev;
>> +	void *migf = NULL;
>> +
>> +	if (!debugfs_initialized() ||
>> +	    !IS_ENABLED(CONFIG_VFIO_DEBUGFS))
>> +		return;
>> +
>> +	if (vdev->ops != &hisi_acc_vfio_pci_migrn_ops)
>> +		return;
>> +
>> +	vfio_dev_migration = debugfs_lookup("migration", vdev->debug_root);
>> +	if (!vfio_dev_migration) {
>> +		dev_err(dev, "failed to lookup migration debugfs file!\n");
>> +		return;
>> +	}
>> +
>> +	migf = kzalloc(sizeof(struct hisi_acc_vf_migration_file), GFP_KERNEL);
>> +	if (!migf)
>> +		return;
>> +	hisi_acc_vdev->debug_migf = migf;
>> +
>> +	vfio_hisi_acc = debugfs_create_dir("hisi_acc", vfio_dev_migration);
>> +	debugfs_create_devm_seqfile(dev, "dev_data", vfio_hisi_acc,
>> +				  hisi_acc_vf_dev_read);
>> +	debugfs_create_devm_seqfile(dev, "migf_data", vfio_hisi_acc,
>> +				  hisi_acc_vf_migf_read);
>> +	debugfs_create_devm_seqfile(dev, "cmd_state", vfio_hisi_acc,
>> +				  hisi_acc_vf_debug_cmd);
>> +}
>> +
>> +static void hisi_acc_vf_debugfs_exit(struct hisi_acc_vf_core_device *hisi_acc_vdev)
>> +{
>> +	/* If migrn_ops is not used, debug_migf is NULL */
>> +	if (hisi_acc_vdev->debug_migf) {
> 
> This test is unnecessary, kfree(NULL) is valid.
>

OK, It will be deleted. Comments will also be updated.

>> +		kfree(hisi_acc_vdev->debug_migf);
>> +		hisi_acc_vdev->debug_migf = NULL;
>> +	}
>> +}
>> +
>>  static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>  {
>>  	struct hisi_acc_vf_core_device *hisi_acc_vdev;
>> @@ -1413,6 +1614,8 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
>>  	ret = vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
>>  	if (ret)
>>  		goto out_put_vdev;
>> +
>> +	hisi_acc_vfio_debug_init(hisi_acc_vdev);
>>  	return 0;
>>  
>>  out_put_vdev:
>> @@ -1425,6 +1628,7 @@ static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
>>  	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
>>  
>>  	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
>> +	hisi_acc_vf_debugfs_exit(hisi_acc_vdev);
>>  	vfio_put_device(&hisi_acc_vdev->core_device.vdev);
>>  }
>>  
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> index 5bab46602fad..2a78ffd060c3 100644
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
>> @@ -99,6 +100,8 @@ struct hisi_acc_vf_migration_file {
>>  struct hisi_acc_vf_core_device {
>>  	struct vfio_pci_core_device core_device;
>>  	u8 match_done;
>> +	/* To make sure the device is opened */
> 
> We can infer that from the field name, it would be more useful to
> comment that io_base is only valid when dev_opened, which is protected
> by open_mutex.
>

OK, the comments will be updated according to your instructions.

>> +	bool dev_opened;
> 
> Seems like open_mutex would fit just as well here and have better
> proximity to the data it protects.
> 

OK, I'm going to move it over here.

>>  
>>  	/* For migration state */
>>  	struct mutex state_mutex;
>> @@ -111,5 +114,9 @@ struct hisi_acc_vf_core_device {
>>  	int vf_id;
>>  	struct hisi_acc_vf_migration_file *resuming_migf;
>>  	struct hisi_acc_vf_migration_file *saving_migf;
>> +
>> +	/* To save migration data */
> 
> Clearly.  Describing it as an extra buffer for reporting migration data
> through debugfs might be more useful.  Thanks,
>

OK, the comments will be updated according to your instructions.

Thanks.
Longfang.

> Alex
> 
>> +	struct hisi_acc_vf_migration_file *debug_migf;
>> +	struct mutex open_mutex;
>>  };
>>  #endif /* HISI_ACC_VFIO_PCI_H */
> 
> 
> .
> 

