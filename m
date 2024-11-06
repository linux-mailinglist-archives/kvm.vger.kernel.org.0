Return-Path: <kvm+bounces-30885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C654E9BE23E
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:19:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 576B31F23673
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:19:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9B8E1D9591;
	Wed,  6 Nov 2024 09:19:17 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058C81D88CA;
	Wed,  6 Nov 2024 09:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730884757; cv=none; b=fkYW7TeoGEDMNx7+JKl1ABHeo+0MAdTTNdO2imjqvBpPYHjW3yNejPCeRegiS/8p1BLtanW7MLoXlWQW7MJzQjIGNU10QaCvgiJs8oriWHRMWezLSVLvDIoQzeINfN6ilUjxHSbvHUHSNx8rL6gRlemuFXhuyo+r38skLTYdC/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730884757; c=relaxed/simple;
	bh=aPBpGNBltL4jyTmmsP1dPNr/0mjy6Sxfb1NLZHJwMAA=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=taPVZX4Knwk61pbqdmurxp/hCGn/zB/AN3fW8mAu8FUeXtko/vwdrD11y35t6fpscZnC1FlTWbk4jiliYsJ51pJET3f58O7TNPgCNot4JI/eDmffa93HXsqAUILbEE/0YaiLR8k26AuxJmLW8XOUfoSI5lyVRfcawkXco16BrOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Xk02y0cjHzpXxQ;
	Wed,  6 Nov 2024 17:17:14 +0800 (CST)
Received: from dggemv711-chm.china.huawei.com (unknown [10.1.198.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 3F847140133;
	Wed,  6 Nov 2024 17:19:08 +0800 (CST)
Received: from kwepemn100017.china.huawei.com (7.202.194.122) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 17:19:08 +0800
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemn100017.china.huawei.com (7.202.194.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 6 Nov 2024 17:19:07 +0800
Subject: Re: [PATCH v12 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon
 migration driver
To: Alex Williamson <alex.williamson@redhat.com>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
CC: "jgg@nvidia.com" <jgg@nvidia.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
References: <20241105035254.24636-1-liulongfang@huawei.com>
 <20241105035254.24636-4-liulongfang@huawei.com>
 <fc776543a1d14531b28b5fa693925518@huawei.com>
 <20241105112108.14255a9e.alex.williamson@redhat.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <2374a9ff-e069-2b2c-debe-e0114df16233@huawei.com>
Date: Wed, 6 Nov 2024 17:19:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241105112108.14255a9e.alex.williamson@redhat.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemn100017.china.huawei.com (7.202.194.122)

On 2024/11/6 2:21, Alex Williamson wrote:
> On Tue, 5 Nov 2024 08:55:51 +0000
> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:
> 
>>> -----Original Message-----
>>> From: liulongfang <liulongfang@huawei.com>
>>> Sent: Tuesday, November 5, 2024 3:53 AM
>>> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
>>> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
>>> <jonathan.cameron@huawei.com>
>>> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>>> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
>>> Subject: [PATCH v12 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon
>>> migration driver  
>>
>> Hi,
>>
>> Few minor comments below. Please don't re-spin just for these yet.
>> Please wait for others to review as well.
>>
>> Thanks,
>> Shameer
>>
>>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>> index a8c53952d82e..7728c9745b9d 100644
>>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>> @@ -627,15 +627,30 @@ static void hisi_acc_vf_disable_fd(struct
>>> hisi_acc_vf_migration_file *migf)
>>>  	mutex_unlock(&migf->lock);
>>>  }
>>>
>>> +static void hisi_acc_debug_migf_copy(struct hisi_acc_vf_core_device
>>> *hisi_acc_vdev,
>>> +	struct hisi_acc_vf_migration_file *src_migf)  
>>
>> Alignment should match open parenthesis here.
> 
> I might also shorten the first line to 80 chars by putting "static" or
> "static void" on a line by itself, but we're getting into personal
> preference at that point and this driver already has lines exceeding 80
> columns.
>

Okay, I put static void on a separate line,
and the following two are aligned.

>>> +{
>>> +	struct hisi_acc_vf_migration_file *dst_migf = hisi_acc_vdev-  
>>>> debug_migf;  
>>> +
>>> +	if (!dst_migf)
>>> +		return;
>>> +
>>> +	dst_migf->total_length = src_migf->total_length;
>>> +	memcpy(&dst_migf->vf_data, &src_migf->vf_data,
>>> +		sizeof(struct acc_vf_data));  
>>
>> Here too, alignment not correct. It is better to run,
>> ./scripts/checkpatch --strict on these patches if you haven't done already.
> 
> Yup.  Only those two were missed as far as I see, but checkpatch does
> warn several places where we should use seq_puts() rather than
> seq_printf() for cases of printing a constant format without additional
> arguments.  For example "device not opened!\n" is the first one below
> but there are others.
>

OK!
I will use "./scripts/checkpatch --strict" to handle it,
and replace seq_printf() with seq_puts()

>>> +}
>>> +
>>>  static void hisi_acc_vf_disable_fds(struct hisi_acc_vf_core_device
>>> *hisi_acc_vdev)
>>>  {
>>>  	if (hisi_acc_vdev->resuming_migf) {
>>> +		hisi_acc_debug_migf_copy(hisi_acc_vdev, hisi_acc_vdev-  
>>>> resuming_migf);  
>>>  		hisi_acc_vf_disable_fd(hisi_acc_vdev->resuming_migf);
>>>  		fput(hisi_acc_vdev->resuming_migf->filp);
>>>  		hisi_acc_vdev->resuming_migf = NULL;
>>>  	}
>>>
>>>  	if (hisi_acc_vdev->saving_migf) {
>>> +		hisi_acc_debug_migf_copy(hisi_acc_vdev, hisi_acc_vdev-  
>>>> saving_migf);  
>>>  		hisi_acc_vf_disable_fd(hisi_acc_vdev->saving_migf);
>>>  		fput(hisi_acc_vdev->saving_migf->filp);
>>>  		hisi_acc_vdev->saving_migf = NULL;
>>> @@ -1294,6 +1309,129 @@ static long hisi_acc_vfio_pci_ioctl(struct
>>> vfio_device *core_vdev, unsigned int
>>>  	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
>>>  }
>>>
>>> +static int hisi_acc_vf_debug_check(struct seq_file *seq, struct vfio_device
>>> *vdev)
>>> +{
>>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>>> hisi_acc_get_vf_dev(vdev);
>>> +	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
>>> +	int ret;
>>> +
>>> +	lockdep_assert_held(&hisi_acc_vdev->open_mutex);
>>> +	/*
>>> +	 * When the device is not opened, the io_base is not mapped.
>>> +	 * The driver cannot perform device read and write operations.
>>> +	 */
>>> +	if (!hisi_acc_vdev->dev_opened) {
>>> +		seq_printf(seq, "device not opened!\n");
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	ret = qm_wait_dev_not_ready(vf_qm);
>>> +	if (ret) {
>>> +		seq_printf(seq, "VF device not ready!\n");
>>> +		return -EBUSY;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int hisi_acc_vf_debug_cmd(struct seq_file *seq, void *data)
>>> +{
>>> +	struct device *vf_dev = seq->private;
>>> +	struct vfio_pci_core_device *core_device =
>>> dev_get_drvdata(vf_dev);
>>> +	struct vfio_device *vdev = &core_device->vdev;
>>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>>> hisi_acc_get_vf_dev(vdev);
>>> +	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
>>> +	u64 value;
>>> +	int ret;
>>> +
>>> +	mutex_lock(&hisi_acc_vdev->open_mutex);
>>> +	ret = hisi_acc_vf_debug_check(seq, vdev);
>>> +	if (ret) {
>>> +		mutex_unlock(&hisi_acc_vdev->open_mutex);
>>> +		return ret;
>>> +	}
>>> +
>>> +	value = readl(vf_qm->io_base + QM_MB_CMD_SEND_BASE);
>>> +	if (value == QM_MB_CMD_NOT_READY) {
>>> +		mutex_unlock(&hisi_acc_vdev->open_mutex);
>>> +		seq_printf(seq, "mailbox cmd channel not ready!\n");
>>> +		return -EINVAL;
>>> +	}
>>> +	mutex_unlock(&hisi_acc_vdev->open_mutex);
>>> +	seq_printf(seq, "mailbox cmd channel ready!\n");
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int hisi_acc_vf_dev_read(struct seq_file *seq, void *data)
>>> +{
>>> +	struct device *vf_dev = seq->private;
>>> +	struct vfio_pci_core_device *core_device =
>>> dev_get_drvdata(vf_dev);
>>> +	struct vfio_device *vdev = &core_device->vdev;
>>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>>> hisi_acc_get_vf_dev(vdev);
>>> +	size_t vf_data_sz = offsetofend(struct acc_vf_data, padding);
>>> +	struct acc_vf_data *vf_data;
>>> +	int ret;
>>> +
>>> +	mutex_lock(&hisi_acc_vdev->open_mutex);
>>> +	ret = hisi_acc_vf_debug_check(seq, vdev);
>>> +	if (ret) {
>>> +		mutex_unlock(&hisi_acc_vdev->open_mutex);
>>> +		return ret;
>>> +	}
>>> +
>>> +	mutex_lock(&hisi_acc_vdev->state_mutex);
>>> +	vf_data = kzalloc(sizeof(struct acc_vf_data), GFP_KERNEL);
>>> +	if (!vf_data) {
>>> +		ret = -ENOMEM;
>>> +		goto mutex_release;
>>> +	}
>>> +
>>> +	vf_data->vf_qm_state = hisi_acc_vdev->vf_qm_state;
>>> +	ret = vf_qm_read_data(&hisi_acc_vdev->vf_qm, vf_data);
>>> +	if (ret)
>>> +		goto migf_err;
>>> +
>>> +	seq_hex_dump(seq, "Dev Data:", DUMP_PREFIX_OFFSET, 16, 1,
>>> +		     (const void *)vf_data, vf_data_sz, false);
>>> +
>>> +	seq_printf(seq,
>>> +		   "guest driver load: %u\n"
>>> +		   "data size: %lu\n",
>>> +		   hisi_acc_vdev->vf_qm_state,
>>> +		   sizeof(struct acc_vf_data));  
>>
>> There was a suggestion to add a comment here to describe vf_qm_state better.
>> May be something like,
>>
>> vf_qm_state here indicates whether the Guest has loaded the driver for the ACC VF
>> device or not.
> 
> I think the comment ended up at the declaration of vf_qm_state in the
> header file:
>>> @@ -107,9 +114,17 @@ struct hisi_acc_vf_core_device {
>>  	struct pci_dev *vf_dev;
>>  	struct hisi_qm *pf_qm;
>>  	struct hisi_qm vf_qm;
>> +	/*
>> +	 * Record whether a driver is added to the acc device in Guest OS.
>> +	 * The value of QM_VF_STATE is set by the acc device driver.
>> +	 * The migration driver queries through the QM_VF_STATE register.
>> +	 */
>>  	u32 vf_qm_state;
>>  	int vf_id;
>>  	struct hisi_acc_vf_migration_file *resuming_migf;
>>  	struct hisi_acc_vf_migration_file *saving_migf;
>> +
>> +	/* An extra buffer for reporting migration data via debugfs */
>> +	struct hisi_acc_vf_migration_file *debug_migf;
>>  };
>>  #endif /* HISI_ACC_VFIO_PCI_H */
> 
> Is that satisfactory?
>
Okay, I'll update the comment.

>>> +
>>> +migf_err:
>>> +	kfree(vf_data);
>>> +mutex_release:
>>> +	mutex_unlock(&hisi_acc_vdev->state_mutex);
>>> +	mutex_unlock(&hisi_acc_vdev->open_mutex);
>>> +
>>> +	return ret;
>>> +}
>>> +
>>> +static int hisi_acc_vf_migf_read(struct seq_file *seq, void *data)
>>> +{
>>> +	struct device *vf_dev = seq->private;
>>> +	struct vfio_pci_core_device *core_device =
>>> dev_get_drvdata(vf_dev);
>>> +	struct vfio_device *vdev = &core_device->vdev;
>>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>>> hisi_acc_get_vf_dev(vdev);
>>> +	size_t vf_data_sz = offsetofend(struct acc_vf_data, padding);
>>> +	struct hisi_acc_vf_migration_file *debug_migf = hisi_acc_vdev-  
>>>> debug_migf;  
>>> +
>>> +	/* Check whether the live migration operation has been performed
>>> */
>>> +	if (debug_migf->total_length < QM_MATCH_SIZE) {
>>> +		seq_printf(seq, "device not migrated!\n");
>>> +		return -EAGAIN;
>>> +	}
>>> +
>>> +	seq_hex_dump(seq, "Mig Data:", DUMP_PREFIX_OFFSET, 16, 1,
>>> +		     (const void *)&debug_migf->vf_data, vf_data_sz, false);
>>> +	seq_printf(seq, "migrate data length: %lu\n", debug_migf-  
>>>> total_length);  
>>> +
>>> +	return 0;
>>> +}
>>> +
>>>  static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
>>>  {
>>>  	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>>> hisi_acc_get_vf_dev(core_vdev);
>>> @@ -1305,12 +1443,16 @@ static int hisi_acc_vfio_pci_open_device(struct
>>> vfio_device *core_vdev)
>>>  		return ret;
>>>
>>>  	if (core_vdev->mig_ops) {
>>> +		mutex_lock(&hisi_acc_vdev->open_mutex);
>>>  		ret = hisi_acc_vf_qm_init(hisi_acc_vdev);
>>>  		if (ret) {
>>> +			mutex_unlock(&hisi_acc_vdev->open_mutex);
>>>  			vfio_pci_core_disable(vdev);
>>>  			return ret;
>>>  		}
>>>  		hisi_acc_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
>>> +		hisi_acc_vdev->dev_opened = true;
>>> +		mutex_unlock(&hisi_acc_vdev->open_mutex);
>>>  	}
>>>
>>>  	vfio_pci_core_finish_enable(vdev);
>>> @@ -1322,7 +1464,10 @@ static void hisi_acc_vfio_pci_close_device(struct
>>> vfio_device *core_vdev)
>>>  	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>>> hisi_acc_get_vf_dev(core_vdev);
>>>  	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
>>>
>>> +	mutex_lock(&hisi_acc_vdev->open_mutex);
>>> +	hisi_acc_vdev->dev_opened = false;
>>>  	iounmap(vf_qm->io_base);
>>> +	mutex_unlock(&hisi_acc_vdev->open_mutex);
>>>  	vfio_pci_core_close_device(core_vdev);
>>>  }
>>>
>>> @@ -1342,6 +1487,7 @@ static int hisi_acc_vfio_pci_migrn_init_dev(struct
>>> vfio_device *core_vdev)
>>>  	hisi_acc_vdev->pf_qm = pf_qm;
>>>  	hisi_acc_vdev->vf_dev = pdev;
>>>  	mutex_init(&hisi_acc_vdev->state_mutex);
>>> +	mutex_init(&hisi_acc_vdev->open_mutex);
>>>
>>>  	core_vdev->migration_flags = VFIO_MIGRATION_STOP_COPY |
>>> VFIO_MIGRATION_PRE_COPY;
>>>  	core_vdev->mig_ops = &hisi_acc_vfio_pci_migrn_state_ops;
>>> @@ -1387,6 +1533,48 @@ static const struct vfio_device_ops
>>> hisi_acc_vfio_pci_ops = {
>>>  	.detach_ioas = vfio_iommufd_physical_detach_ioas,
>>>  };
>>>
>>> +static void hisi_acc_vfio_debug_init(struct hisi_acc_vf_core_device
>>> *hisi_acc_vdev)
>>> +{
>>> +	struct vfio_device *vdev = &hisi_acc_vdev->core_device.vdev;
>>> +	struct dentry *vfio_dev_migration = NULL;
>>> +	struct dentry *vfio_hisi_acc = NULL;
>>> +	struct device *dev = vdev->dev;
>>> +	void *migf = NULL;
>>> +
>>> +	if (!debugfs_initialized() ||
>>> +	    !IS_ENABLED(CONFIG_VFIO_DEBUGFS))
>>> +		return;
>>> +
>>> +	if (vdev->ops != &hisi_acc_vfio_pci_migrn_ops)
>>> +		return;
>>> +
>>> +	vfio_dev_migration = debugfs_lookup("migration", vdev-  
>>>> debug_root);  
>>> +	if (!vfio_dev_migration) {
>>> +		dev_err(dev, "failed to lookup migration debugfs file!\n");
>>> +		return;
>>> +	}
>>> +
>>> +	migf = kzalloc(sizeof(struct hisi_acc_vf_migration_file),
>>> GFP_KERNEL);
> 
> checkpatch --strict also advises this could be written as:
> 
> 	migf = kzalloc(sizeof(*migf), GFP_KERNEL);
> 
> There's another one above with acc_vf_data.  I'd consider these
> optional, but I think it is good practice and is more consistent with
> existing allocations in this file.
>

OK, I will modify the two "kzalloc" together.

>>> +	if (!migf)
>>> +		return;
>>> +	hisi_acc_vdev->debug_migf = migf;
>>> +
>>> +	vfio_hisi_acc = debugfs_create_dir("hisi_acc", vfio_dev_migration);
>>> +	debugfs_create_devm_seqfile(dev, "dev_data", vfio_hisi_acc,
>>> +				    hisi_acc_vf_dev_read);
>>> +	debugfs_create_devm_seqfile(dev, "migf_data", vfio_hisi_acc,
>>> +				    hisi_acc_vf_migf_read);
>>> +	debugfs_create_devm_seqfile(dev, "cmd_state", vfio_hisi_acc,
>>> +				    hisi_acc_vf_debug_cmd);
>>> +}
>>> +
>>> +static void hisi_acc_vf_debugfs_exit(struct hisi_acc_vf_core_device
>>> *hisi_acc_vdev)
>>> +{
>>> +	/* If migrn_ops is not used, kfree(NULL) is valid */  
>>
>> The above comment is not required. Please remove.
> 
> I don't have a problem with it, but I'll let the two of you decide as
> co-owners of the file.  Thanks,
> 
> Alex
>

OK, I'll delete it.

Thanks.
Longfang.

> 
>>> +	kfree(hisi_acc_vdev->debug_migf);
>>> +	hisi_acc_vdev->debug_migf = NULL;
>>> +}
>>> +  
>>
> 
> 
> .
> 

