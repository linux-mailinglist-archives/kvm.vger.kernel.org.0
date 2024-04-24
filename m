Return-Path: <kvm+bounces-15748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9C798AFF53
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 05:16:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D796E1C22159
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 03:16:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FC4D13048C;
	Wed, 24 Apr 2024 03:15:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266F185C59;
	Wed, 24 Apr 2024 03:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928558; cv=none; b=FPBnMhqNvegUtQhxa4KEgAHLAoln6r9k9Mok+tNPTBH1uKZnsQEekIw+V9WcnJprMCmrYSLFeoDgSCWAL6AdM5wLdiOWYyYe/L/vumqY+GC1gHelkkH/1Z/f7abqC+Ek56oIqgZeoZTb0UeXDsTFirIvDyt05PHHivqrz0/wP/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928558; c=relaxed/simple;
	bh=dcHVWos3X8Sq2uqwNLNEHEYF8vLg5ufwaIyAt9kH2xA=;
	h=Subject:From:To:CC:References:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Je9Eso/d342wxCnC8jmRYihMF/WC/HX0QA366Rf+nwuQJkMP2yM3EtBZTqu4J1gobOSJA1DFjMpkdYOrDsV3WINuvNbR18416qWpknagLQYb2eJRUvaCbMKVhbJq14Ka065GMy87d7te56GE0x5IBoYG+q7gcCpZUypFgBfQU4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4VPPHC6mGHzcZyP;
	Wed, 24 Apr 2024 11:14:47 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id 602C418007F;
	Wed, 24 Apr 2024 11:15:52 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 24 Apr 2024 11:15:51 +0800
Subject: Re: [PATCH v4 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon
 migration driver
From: liulongfang <liulongfang@huawei.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
References: <20240402032432.41004-1-liulongfang@huawei.com>
 <20240402032432.41004-4-liulongfang@huawei.com>
 <20240404140735.2174528d.alex.williamson@redhat.com>
 <23028a83-5433-7bb1-82fa-b5547790749f@huawei.com>
Message-ID: <ad75be79-7590-4b16-3c95-0fc375596432@huawei.com>
Date: Wed, 24 Apr 2024 11:15:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <23028a83-5433-7bb1-82fa-b5547790749f@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600005.china.huawei.com (7.193.23.191)

On 2024/4/12 16:15, liulongfang wrote:
> On 2024/4/5 4:07, Alex Williamson wrote:
>> On Tue, 2 Apr 2024 11:24:31 +0800
>> Longfang Liu <liulongfang@huawei.com> wrote:
>>
>>> On the debugfs framework of VFIO, if the CONFIG_VFIO_DEBUGFS macro is
>>> enabled, the debug function is registered for the live migration driver
>>> of the HiSilicon accelerator device.
>>>
>>> After registering the HiSilicon accelerator device on the debugfs
>>> framework of live migration of vfio, a directory file "hisi_acc"
>>> of debugfs is created, and then three debug function files are
>>> created in this directory:
>>>
>>>    vfio
>>>     |
>>>     +---<dev_name1>
>>>     |    +---migration
>>>     |        +--state
>>>     |        +--hisi_acc
>>>     |            +--attr
>>>     |            +--data
>>>     |            +--save
>>>     |            +--cmd_state
>>>     |
>>>     +---<dev_name2>
>>>          +---migration
>>>              +--state
>>>              +--hisi_acc
>>>                  +--attr
>>>                  +--data
>>>                  +--save
>>>                  +--cmd_state
>>>
>>> data file: used to get the migration data from the driver
>>> attr file: used to get device attributes parameters from the driver
>>> save file: used to read the data of the live migration device and save
>>> it to the driver.
>>> cmd_state: used to get the cmd channel state for the device.
>>>
>>> +----------------+        +--------------+       +---------------+
>>> | migration dev  |        |   src  dev   |       |   dst  dev    |
>>> +-------+--------+        +------+-------+       +-------+-------+
>>>         |                        |                       |
>>>         |                        |                       |
>>>         |                        |                       |
>>>         |                        |                       |
>>>   save  |                 +------v-------+       +-------v-------+
>>>         |                 |  saving_mif  |       | resuming_migf |
>>>         |                 |     file     |       |     file      |
>>>         |                 +------+-------+       +-------+-------+
>>>         |                        |                       |
>>>         |        mutex           |                       |
>>> +-------v--------+               |                       |
>>> |                |               |                       |
>>> | debug_migf file<---------------+-----------------------+
>>> |                |             copy
>>> +-------+--------+
>>>         |
>>>    cat  |
>>>         |
>>> +-------v--------+
>>> |     user       |
>>> +----------------+
>>>
>>> In debugfs scheme. The driver creates a separate debug_migf file.
>>> It is completely separated from the two files of live migration,
>>> thus preventing debugfs data from interfering with migration data.
>>> Moreover, it only performs read operations on the device.
>>>
>>> For serialization of debugfs:
>>> First, it only writes data when performing a debugfs save operation.
>>
>> This distinction between "writing" and "copying" is very confusing.
>>
> 
> "Writing" means reading data from the device and writing it to debug_migf.
> "Copying" is to copy the data that has been saved in other migf files to
> debug_migf.
> The destination of both operations is the same.
> The data sources are different.
> 
>>> Second, it is only copied from the file on the migration device
>>> when the live migration is complete.
>>
>> Why does it do this at all?  If you're looking for a postmortem of the
>> user generated buffer, that should be explicitly stated.
>>
> 
> debug_migf is a data buffer. Used to cache debugfs data for users
> 
>>> These two operations are mutually exclusive through mutex.
>>
>> The mutual exclusion between debugfs operations is not the concern, the
>> question is whether there's serialization that prevents the debugfs
>> operations from interfering with the user migration flow.  Nothing here
>> seems to prevent concurrent use of the debugfs interface proposed here
>> with a user migration.
>>
> 
> Reading data directly from the device does not cause any problems.
> The device supports concurrent requests for read operations.
> Therefore, there is no mutual exclusion between the debugfs save
> operation and the user migration operation.
> 
>>>
>>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>>> ---
>>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 204 ++++++++++++++++++
>>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  11 +
>>>  2 files changed, 215 insertions(+)
>>>
>>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>> index bf358ba94b5d..9f563a31a2a1 100644
>>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>> @@ -15,6 +15,7 @@
>>>  #include <linux/anon_inodes.h>
>>>  
>>>  #include "hisi_acc_vfio_pci.h"
>>> +#include "../../vfio.h"
>>
>> This include seems not to be required.
>>
> 
> OK, let me modify it and verify it.
> 
>>>  
>>>  /* Return 0 on VM acc device ready, -ETIMEDOUT hardware timeout */
>>>  static int qm_wait_dev_not_ready(struct hisi_qm *qm)
>>> @@ -618,6 +619,22 @@ hisi_acc_check_int_state(struct hisi_acc_vf_core_device *hisi_acc_vdev)
>>>  	}
>>>  }
>>>  
>>> +static void hisi_acc_vf_migf_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>> +	struct hisi_acc_vf_migration_file *src_migf)
>>
>> Seems this should be named something relative to debug since it's only
>> purpose is to copy the migration file to the debug migration file.
> 
> How about hisi_acc_debug_migf_copy?
> 
>>
>>> +{
>>> +	struct hisi_acc_vf_migration_file *dst_migf = hisi_acc_vdev->debug_migf;
>>> +
>>> +	if (!dst_migf)
>>> +		return;
>>> +
>>> +	mutex_lock(&hisi_acc_vdev->enable_mutex);
>>> +	dst_migf->disabled = src_migf->disabled;
>>
>> In the cases where this is called, the caller is about to call
>> hisi_acc_vf_disable_fd() which sets disabled = true and then
>> hisi_acc_vf_debug_save() doesn't touch the value!  What does it even
>> mean to copy this value, let alone print it as part of the debugfs
>> output later?
>>
> 
> Yes, the disable assignment of debug_migf needs to be processed
> in hisi_acc_vf_debug_save.
> 
>>
>>> +	dst_migf->total_length = src_migf->total_length;
>>> +	memcpy(&dst_migf->vf_data, &src_migf->vf_data,
>>> +		    sizeof(struct acc_vf_data));
>>> +	mutex_unlock(&hisi_acc_vdev->enable_mutex);
>>> +}
>>> +
>>>  static void hisi_acc_vf_disable_fd(struct hisi_acc_vf_migration_file *migf)
>>>  {
>>>  	mutex_lock(&migf->lock);
>>> @@ -630,12 +647,14 @@ static void hisi_acc_vf_disable_fd(struct hisi_acc_vf_migration_file *migf)
>>>  static void hisi_acc_vf_disable_fds(struct hisi_acc_vf_core_device *hisi_acc_vdev)
>>>  {
>>>  	if (hisi_acc_vdev->resuming_migf) {
>>> +		hisi_acc_vf_migf_save(hisi_acc_vdev, hisi_acc_vdev->resuming_migf);
>>>  		hisi_acc_vf_disable_fd(hisi_acc_vdev->resuming_migf);
>>>  		fput(hisi_acc_vdev->resuming_migf->filp);
>>>  		hisi_acc_vdev->resuming_migf = NULL;
>>>  	}
>>>  
>>>  	if (hisi_acc_vdev->saving_migf) {
>>> +		hisi_acc_vf_migf_save(hisi_acc_vdev, hisi_acc_vdev->saving_migf);
>>
>> Why are these buffers copied to the debug_migf in this case?  This can
>> happen asynchronous to accessing the debugfs migration file and there's
>> no serialization.
>>
> 
> We can try to copy when accessing debugfs.
>

I tried migrating the file to save data when accessing debugfs.
This solution will not work. resuming_migf and saving_migf will be
kfree after completing the migration, and their data will no longer
be saved.
Therefore, the data needs to be saved to debug_migf when calling "hisi_acc_vf_disable_fd".

In addition, reading the migration status data of device can be read directly during
debugfs access, without using debug_migf.

Thanks,
Longfang.

>>>  		hisi_acc_vf_disable_fd(hisi_acc_vdev->saving_migf);
>>>  		fput(hisi_acc_vdev->saving_migf->filp);
>>>  		hisi_acc_vdev->saving_migf = NULL;
>>> @@ -1144,6 +1163,7 @@ static int hisi_acc_vf_qm_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
>>>  	if (!vf_qm->io_base)
>>>  		return -EIO;
>>>  
>>> +	mutex_init(&hisi_acc_vdev->enable_mutex);
>>>  	vf_qm->fun_type = QM_HW_VF;
>>>  	vf_qm->pdev = vf_dev;
>>>  	mutex_init(&vf_qm->mailbox_lock);
>>> @@ -1294,6 +1314,181 @@ static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int
>>>  	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
>>>  }
>>>  
>>> +static int hisi_acc_vf_debug_check(struct seq_file *seq, struct vfio_device *vdev)
>>> +{
>>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
>>> +	struct hisi_acc_vf_migration_file *migf = hisi_acc_vdev->debug_migf;
>>> +	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
>>> +	int ret;
>>> +
>>
>> lockdep_assert_held(...)
>>
>>> +	if (!vdev->mig_ops || !migf) {
>>> +		seq_printf(seq, "%s\n", "device does not support live migration!");
>>> +		return -EINVAL;
>>
>> Isn't the -EINVAL sufficient?
>>
> 
> Which one do you think is better?
> 
>>> +	}
>>> +
>>> +	/**
>>> +	 * When the device is not opened, the io_base is not mapped.
>>> +	 * The driver cannot perform device read and write operations.
>>> +	 */
>>> +	if (hisi_acc_vdev->dev_opened != DEV_OPEN) {
>>
>> Why are we assigning and testing a bool against and enum?!
>>
> 
> OK, change to true and false assignment.
> 
>>> +		seq_printf(seq, "%s\n", "device not opened!");
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	ret = qm_wait_dev_not_ready(vf_qm);
>>> +	if (ret) {
>>> +		seq_printf(seq, "%s\n", "VF device not ready!");
>>> +		return -EINVAL;
>>
>> -EBUSY?  Again, not sure why we need the seq_printf() in addition to
>> the error value.
>>
> 
> OK, -EBUSY is better.
> seq_printf() allows users to directly obtain the cause of the
> error without checking dmesg.
> 
> 
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int hisi_acc_vf_debug_cmd(struct seq_file *seq, void *data)
>>> +{
>>> +	struct device *vf_dev = seq->private;
>>> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
>>> +	struct vfio_device *vdev = &core_device->vdev;
>>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
>>> +	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
>>> +	u64 value;
>>> +	int ret;
>>> +
>>> +	mutex_lock(&hisi_acc_vdev->enable_mutex);
>>> +	ret = hisi_acc_vf_debug_check(seq, vdev);
>>> +	if (ret) {
>>> +		mutex_unlock(&hisi_acc_vdev->enable_mutex);
>>> +		return 0;
>>
>> Why do we squash the error return here and throughout?
>>
> seq_printf() gives the user a failure message.
> This can be changed to "return ret;"
> 
>>> +	}
>>> +
>>> +	value = readl(vf_qm->io_base + QM_MB_CMD_SEND_BASE);
>>> +	mutex_unlock(&hisi_acc_vdev->enable_mutex);
>>> +	seq_printf(seq, "%s:0x%llx\n", "mailbox cmd channel state is OK", value);
>>
>> We didn't test the value, what makes the state OK?  Can this readl() or
>> those in qm_wait_dev_not_ready() interfere with the main device flow?
>>
> 
> If the cmd channel is normal, it will return a non-all-F value.
> Add exception checking in the next version.
> 
> cmd channel read operation will not affect the main migration process.
> 
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int hisi_acc_vf_debug_save(struct seq_file *seq, void *data)
>>> +{
>>> +	struct device *vf_dev = seq->private;
>>> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
>>> +	struct vfio_device *vdev = &core_device->vdev;
>>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
>>> +	struct hisi_acc_vf_migration_file *migf = hisi_acc_vdev->debug_migf;
>>> +	struct acc_vf_data *vf_data = &migf->vf_data;
>>> +	int ret;
>>> +
>>> +	mutex_lock(&hisi_acc_vdev->enable_mutex);
>>> +	ret = hisi_acc_vf_debug_check(seq, vdev);
>>> +	if (ret) {
>>> +		mutex_unlock(&hisi_acc_vdev->enable_mutex);
>>> +		return 0;
>>> +	}
>>> +
>>> +	vf_data->vf_qm_state = QM_READY;
>>> +	ret = vf_qm_read_data(&hisi_acc_vdev->vf_qm, vf_data);
>>> +	if (ret) {
>>> +		mutex_unlock(&hisi_acc_vdev->enable_mutex);
>>> +		seq_printf(seq, "%s\n", "failed to save device data!");
>>> +		return 0;
>>> +	}
>>> +
>>> +	migf->total_length = sizeof(struct acc_vf_data);
>>> +	mutex_unlock(&hisi_acc_vdev->enable_mutex);
>>> +	seq_printf(seq, "%s\n", "successful to save device data!");
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int hisi_acc_vf_data_read(struct seq_file *seq, void *data)
>>> +{
>>> +	struct device *vf_dev = seq->private;
>>> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
>>> +	struct vfio_device *vdev = &core_device->vdev;
>>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
>>> +	struct hisi_acc_vf_migration_file *debug_migf = hisi_acc_vdev->debug_migf;
>>> +	size_t vf_data_sz = offsetofend(struct acc_vf_data, padding);
>>> +
>>> +	if (debug_migf && debug_migf->total_length)
>>> +		seq_hex_dump(seq, "Mig Data:", DUMP_PREFIX_OFFSET, 16, 1,
>>> +				(unsigned char *)&debug_migf->vf_data,
>>> +				vf_data_sz, false);
>>> +	else
>>> +		seq_printf(seq, "%s\n", "device not migrated!");
>>
>> "device state not saved"?  Although I don't recall why this doesn't
>> just return an errno.
>>
> 
> OK, those who exit directly without migration will be processed according
> to the error mode and an error code will be returned.
> 
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int hisi_acc_vf_attr_read(struct seq_file *seq, void *data)
>>> +{
>>> +	struct device *vf_dev = seq->private;
>>> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
>>> +	struct vfio_device *vdev = &core_device->vdev;
>>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
>>> +	struct hisi_acc_vf_migration_file *debug_migf = hisi_acc_vdev->debug_migf;
>>> +
>>> +	if (debug_migf && debug_migf->total_length) {
>>> +		seq_printf(seq,
>>> +			 "acc device:\n"
>>> +			 "device  state: %d\n"
>>> +			 "device  ready: %u\n"
>>> +			 "data    valid: %d\n"
>>> +			 "data     size: %lu\n",
>>> +			 hisi_acc_vdev->mig_state,
>>
>> This is redundant to migration/state, however note
> 
> OK!
> 
>> hisi_acc_vfio_pci_get_device_state() protects the value with state
>> mutex while reading it.
>>
>>> +			 hisi_acc_vdev->vf_qm_state,
>>
>> What's the purpose of this, it's ready or not, what does that mean?
>>
> 
> If this status is not ready, the live migration process will exit directly.
> It indicates that there are two possible exceptions:
> 1. The acc device driver in the VM does not have insmod.
> 2. The acc device driver in the VM is insmoded, but the cmd channel is abnormal.
> 
>>> +			 debug_migf->disabled,
>>
>> What's the purpose of this?
> 
> Get the enable status of migf file in the driver.
> 
>>
>>> +			 debug_migf->total_length);
>>
>> Why not just have this printed or inferred via the above data_read
>> function, this all seems unnecessary.
>>
> 
> This is used to obtain some key status of the live migration driver.
> It is more important than data in problem location.
> So it is output in key-value pairs.
> 
> The above data is directly output in the form of hexadecimal data.
> It is used for more detailed analysis when there are no abnormalities
> in the key status.
> 
>>> +	} else {
>>> +		seq_printf(seq, "%s\n", "device not migrated!");
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int hisi_acc_vfio_debug_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
>>> +{
>>> +	struct vfio_device *vdev = &hisi_acc_vdev->core_device.vdev;
>>> +	struct dentry *vfio_dev_migration = NULL;
>>> +	struct dentry *vfio_hisi_acc = NULL;
>>> +	struct device *dev = vdev->dev;
>>> +	void *migf = NULL;
>>> +
>>> +	if (!debugfs_initialized())
>>> +		return 0;
>>> +
>>> +	migf = kzalloc(sizeof(struct hisi_acc_vf_migration_file), GFP_KERNEL);
>>> +	if (!migf)
>>> +		return -ENOMEM;
>>> +	hisi_acc_vdev->debug_migf = migf;
>>> +
>>> +	vfio_dev_migration = debugfs_lookup("migration", vdev->debug_root);
>>
>> Fails to build without CONFIG_DEBUG_FS=y  There should be a dependency
>> on CONFIG_VFIO_DEBUGFS here somewhere.
>>
> 
> Yes, the driver needs to add "!IS_ENABLED(CONFIG_VFIO_DEBUGFS)"
> behind "debugfs_initialized()" above.
> 
>>> +	if (!vfio_dev_migration) {
>>> +		kfree(migf);
>>
>> hisi_acc_vdev->debug_migf still points at this freed buffer, the return
>> value of this function is not tested, allows a use-after-free in
>> all of the below debugfs interfaces.
>>
> 
> Yes, there needs to add "hisi_acc_vdev->debug_migf = NULL"
> 
>>> +		dev_err(dev, "failed to lookup migration debugfs file!\n");
>>> +		return -ENODEV;
>>> +	}
>>> +
>>> +	vfio_hisi_acc = debugfs_create_dir("hisi_acc", vfio_dev_migration);
>>> +	debugfs_create_devm_seqfile(dev, "data", vfio_hisi_acc,
>>> +				  hisi_acc_vf_data_read);
>>> +	debugfs_create_devm_seqfile(dev, "attr", vfio_hisi_acc,
>>> +				  hisi_acc_vf_attr_read);
>>> +	debugfs_create_devm_seqfile(dev, "cmd_state", vfio_hisi_acc,
>>> +				  hisi_acc_vf_debug_cmd);
>>> +	debugfs_create_devm_seqfile(dev, "save", vfio_hisi_acc,
>>> +				  hisi_acc_vf_debug_save);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static void hisi_acc_vf_debugfs_exit(struct hisi_acc_vf_core_device *hisi_acc_vdev)
>>> +{
>>> +	if (!debugfs_initialized())
>>> +		return;
>>> +
>>> +	kfree(hisi_acc_vdev->debug_migf);
>>
>> Double free if the lookup in init fails.
>>
> 
> After adding "hisi_acc_vdev->debug_migf = NULL" above.
> These processing codes need to be added here:
> 
> if (hisi_acc_vdev->debug_migf)
> 	kfree(hisi_acc_vdev->debug_migf);
> 
>>> +}
>>> +
>>>  static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
>>>  {
>>>  	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(core_vdev);
>>> @@ -1311,9 +1506,11 @@ static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
>>>  			return ret;
>>>  		}
>>>  		hisi_acc_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
>>> +		hisi_acc_vdev->dev_opened = DEV_OPEN;
>>
>>  = true!
>>
> 
> OK, the next version will not use enumeration values. will use true/false assignment.
> 
>>>  	}
>>>  
>>>  	vfio_pci_core_finish_enable(vdev);
>>> +
>>>  	return 0;
>>>  }
>>>  
>>> @@ -1322,7 +1519,10 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
>>>  	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(core_vdev);
>>>  	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
>>>  
>>> +	hisi_acc_vdev->dev_opened = DEV_CLOSE;
>>> +	mutex_lock(&hisi_acc_vdev->enable_mutex);
>>>  	iounmap(vf_qm->io_base);
>>> +	mutex_unlock(&hisi_acc_vdev->enable_mutex);
>>>  	vfio_pci_core_close_device(core_vdev);
>>>  }
>>>  
>>> @@ -1413,6 +1613,9 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
>>>  	ret = vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
>>>  	if (ret)
>>>  		goto out_put_vdev;
>>> +
>>> +	if (ops == &hisi_acc_vfio_pci_migrn_ops)
>>> +		hisi_acc_vfio_debug_init(hisi_acc_vdev);
>>>  	return 0;
>>>  
>>>  out_put_vdev:
>>> @@ -1425,6 +1628,7 @@ static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
>>>  	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
>>>  
>>>  	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
>>> +	hisi_acc_vf_debugfs_exit(hisi_acc_vdev);
>>>  	vfio_put_device(&hisi_acc_vdev->core_device.vdev);
>>>  }
>>>  
>>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>>> index 7a9dc87627cd..3a20d81d105c 100644
>>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>>> @@ -52,6 +52,11 @@
>>>  #define QM_EQC_DW0		0X8000
>>>  #define QM_AEQC_DW0		0X8020
>>>  
>>> +enum acc_dev_state {
>>> +	DEV_CLOSE = 0x0,
>>> +	DEV_OPEN,
>>> +};
>>> +
>>>  struct acc_vf_data {
>>>  #define QM_MATCH_SIZE offsetofend(struct acc_vf_data, qm_rsv_state)
>>>  	/* QM match information */
>>> @@ -114,5 +119,11 @@ struct hisi_acc_vf_core_device {
>>>  	int vf_id;
>>>  	struct hisi_acc_vf_migration_file *resuming_migf;
>>>  	struct hisi_acc_vf_migration_file *saving_migf;
>>> +
>>> +	/* To make sure the device is enabled */
>>> +	struct mutex enable_mutex;
>>> +	bool dev_opened;
>>> +	/* For debugfs */
>>> +	struct hisi_acc_vf_migration_file *debug_migf;
>>>  };
>>>  #endif /* HISI_ACC_VFIO_PCI_H */
>>
>> .
>>
> Thank you very much for your careful inspection.
> I will revise the inspection issues you mentioned above
> one by one and publish them in the next version.
> 
> Thanks again!
> Longfang.
> 
> .
> 

