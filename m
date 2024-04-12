Return-Path: <kvm+bounces-14373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B1198A2423
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 05:03:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F388BB219A2
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 03:03:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D280E14AB2;
	Fri, 12 Apr 2024 03:02:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5F3125BA;
	Fri, 12 Apr 2024 03:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712890978; cv=none; b=rr2DN+lxTkUBzV/mwFlsLIZ3wIdTT6J2nbtkSH9zuZHttK6+kfXkuMRgJJqlanog+E8lMJ43q70RmHZN7KKB4zqoIkhGquUCz2UF0tUUdhKkXrPCWRBeFdQ1krtPNbQNr81vqnRi7HD7IJ6hK5evBDwteYxKX0GiWg+NX7Tbs2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712890978; c=relaxed/simple;
	bh=mksHlutSXcQUklVG/Sm4Rj52riQY7SIjyLfdHrSpKqs=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=eP7L9CfuodQqN7zp+EO37gl3gIo0lFg/waWod/8tWjBLXnXYTyGduPkF0XK+lUKF0/cHrKEwa82w0nNqad302nYfZPJIHtdkseraEI7OZoRLbjahXmCR4pdzhf2KhNqC5e8idTMF8Nkc51LMWq63eYFbJG7WlC4uFpN4KhBLTR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4VG1Z34nHXz1S5M8;
	Fri, 12 Apr 2024 11:02:03 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id 8E4DC180063;
	Fri, 12 Apr 2024 11:02:51 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 12 Apr 2024 11:02:51 +0800
Subject: Re: [PATCH v4 4/4] Documentation: add debugfs description for hisi
 migration
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
References: <20240402032432.41004-1-liulongfang@huawei.com>
 <20240402032432.41004-5-liulongfang@huawei.com>
 <20240404140750.78549701.alex.williamson@redhat.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <699fed1e-51c0-2d74-0f1f-6f45813f4cb4@huawei.com>
Date: Fri, 12 Apr 2024 11:02:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240404140750.78549701.alex.williamson@redhat.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600005.china.huawei.com (7.193.23.191)

On 2024/4/5 4:07, Alex Williamson wrote:
> On Tue, 2 Apr 2024 11:24:32 +0800
> Longfang Liu <liulongfang@huawei.com> wrote:
> 
>> Add a debugfs document description file to help users understand
>> how to use the hisilicon accelerator live migration driver's
>> debugfs.
>>
>> Update the file paths that need to be maintained in MAINTAINERS
>>
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> ---
>>  .../ABI/testing/debugfs-hisi-migration        | 34 +++++++++++++++++++
>>  MAINTAINERS                                   |  1 +
>>  2 files changed, 35 insertions(+)
>>  create mode 100644 Documentation/ABI/testing/debugfs-hisi-migration
>>
>> diff --git a/Documentation/ABI/testing/debugfs-hisi-migration b/Documentation/ABI/testing/debugfs-hisi-migration
>> new file mode 100644
>> index 000000000000..3d7339276e6f
>> --- /dev/null
>> +++ b/Documentation/ABI/testing/debugfs-hisi-migration
>> @@ -0,0 +1,34 @@
>> +What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/data
>> +Date:		Apr 2024
>> +KernelVersion:  6.9
> 
> At best 6.10 with a merge window in May.
> 
>> +Contact:	Longfang Liu <liulongfang@huawei.com>
>> +Description:	Read the live migration data of the vfio device.
>> +		These data include device status data, queue configuration
>> +		data and some task configuration data.
>> +		The output format of the data is defined by the live
>> +		migration driver.
> 
> "Dumps the device debug migration buffer, state must first be saved
> using the 'save' attribute."
> 
>> +
>> +What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/attr
>> +Date:		Apr 2024
>> +KernelVersion:  6.9
>> +Contact:	Longfang Liu <liulongfang@huawei.com>
>> +Description:	Read the live migration attributes of the vfio device.
>> +		it include device status attributes and data length attributes
>> +		The output format of the attributes is defined by the live
>> +		migration driver.
> 
> AFAICT from the previous patch, this attribute is useless.
> 
>> +
>> +What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/cmd_state
>> +Date:		Apr 2024
>> +KernelVersion:  6.9
>> +Contact:	Longfang Liu <liulongfang@huawei.com>
>> +Description:	Used to obtain the device command sending and receiving
>> +		channel status. If successful, returns the command value.
>> +		If failed, return error log.
>> +
> 
> Seems like it statically returns "OK" plus the actual value.
> 
> 
>> +What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/save
>> +Date:		Apr 2024
>> +KernelVersion:  6.9
>> +Contact:	Longfang Liu <liulongfang@huawei.com>
>> +Description:	Trigger the Hisilicon accelerator device to perform
>> +		the state saving operation of live migration through the read
>> +		operation, and output the operation log results.
> 
> These interfaces are confusing, attr and data only work if there has
> either been a previous save OR the user migration process closed saving
> or resuming fds in the interim, and the user doesn't know which one
> they get.  Note that debug_migf isn't even discarded between
> open/close, only cmd and save require the device to be opened by a
> user, data and attr might continue to return data from some previous
> user save, resume, or debugfs save.
>

data: Indicates the device migration data obtained after the migration is completed.
This data is saved in debug_migf. The user reads it through "cat" and
presents it to the user in the form of hexadecimal pure data.

attr: Indicates the configuration parameters of the migration process after the
migration is completed. These parameters are saved in vfio device and debug_migf.
The user reads it through "cat" and presents it to the user in the form of key-value
pairs such as <attribute name, attribute value>.

Save is an action process. After "cat" it, a migration save operation will be
performed and the result data will be updated to debug_migf.

There is still a big difference between data and attr, and the data formats are
also different. Not merging makes it easier for users to obtain information.
If you feel confused about save, it is recommended to use migrate_save.

Thanks,
Longfang.

> 
> 
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 7625911ec2f1..8c2d13b13273 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -23072,6 +23072,7 @@ M:	Longfang Liu <liulongfang@huawei.com>
>>  M:	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
>>  L:	kvm@vger.kernel.org
>>  S:	Maintained
>> +F:	Documentation/ABI/testing/debugfs-hisi-migration
>>  F:	drivers/vfio/pci/hisilicon/
>>  
>>  VFIO MEDIATED DEVICE DRIVERS
> 
> .
> 

