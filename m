Return-Path: <kvm+bounces-632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 673127E1A3F
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 07:29:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C4431C20A8A
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 06:29:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2013ABA4B;
	Mon,  6 Nov 2023 06:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8343F2F58
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 06:29:19 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919ADF2;
	Sun,  5 Nov 2023 22:29:15 -0800 (PST)
Received: from kwepemm000005.china.huawei.com (unknown [172.30.72.55])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4SP1ZP4P4Kz1P7x5;
	Mon,  6 Nov 2023 14:26:05 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemm000005.china.huawei.com (7.193.23.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Mon, 6 Nov 2023 14:28:42 +0800
Subject: Re: [PATCH v18 2/2] Documentation: add debugfs description for vfio
To: =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clegoate@redhat.com>,
	<alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <bcreeley@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>
References: <20231028075447.41939-1-liulongfang@huawei.com>
 <20231028075447.41939-3-liulongfang@huawei.com>
 <356dd79e-9079-4bbc-9b64-9468b6f7b6a7@redhat.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <f0f1d157-a07a-c5ea-1353-a3400897f278@huawei.com>
Date: Mon, 6 Nov 2023 14:28:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <356dd79e-9079-4bbc-9b64-9468b6f7b6a7@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.121.110]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm000005.china.huawei.com (7.193.23.27)
X-CFilter-Loop: Reflected

On 2023/10/30 14:51, Cédric Le Goater write:
> On 10/28/23 09:54, Longfang Liu wrote:
>> 1.Add an debugfs document description file to help users understand
>> how to use the accelerator live migration driver's debugfs.
>> 2.Update the file paths that need to be maintained in MAINTAINERS
> 
> Should we have 2 patches instead ?
>

It is also good to add a separate patch.

Thanks,
Longfang.

> Anyhow,
> 
> Reviewed-by: Cédric Le Goater <clg@redhat.com>
> 
> Thanks,
> 
> C.
> 
> 
>>
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> ---
>>   Documentation/ABI/testing/debugfs-vfio | 25 +++++++++++++++++++++++++
>>   MAINTAINERS                            |  1 +
>>   2 files changed, 26 insertions(+)
>>   create mode 100644 Documentation/ABI/testing/debugfs-vfio
>>
>> diff --git a/Documentation/ABI/testing/debugfs-vfio b/Documentation/ABI/testing/debugfs-vfio
>> new file mode 100644
>> index 000000000000..445e9f58f924
>> --- /dev/null
>> +++ b/Documentation/ABI/testing/debugfs-vfio
>> @@ -0,0 +1,25 @@
>> +What:        /sys/kernel/debug/vfio
>> +Date:        Oct 2023
>> +KernelVersion:  6.7
>> +Contact:    Longfang Liu <liulongfang@huawei.com>
>> +Description:    This debugfs file directory is used for debugging
>> +        of vfio devices, it's a common directory for all vfio devices.
>> +        Vfio core will create a device subdirectory under this
>> +        directory.
>> +
>> +What:        /sys/kernel/debug/vfio/<device>/migration
>> +Date:        Oct 2023
>> +KernelVersion:  6.7
>> +Contact:    Longfang Liu <liulongfang@huawei.com>
>> +Description:    This debugfs file directory is used for debugging
>> +        of vfio devices that support live migration.
>> +        The debugfs of each vfio device that supports live migration
>> +        could be created under this directory.
>> +
>> +What:        /sys/kernel/debug/vfio/<device>/migration/state
>> +Date:        Oct 2023
>> +KernelVersion:  6.7
>> +Contact:    Longfang Liu <liulongfang@huawei.com>
>> +Description:    Read the live migration status of the vfio device.
>> +        The contents of the state file reflects the migration state
>> +        relative to those defined in the vfio_device_mig_state enum
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index b19995690904..a6be3b4219c7 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -22591,6 +22591,7 @@ L:    kvm@vger.kernel.org
>>   S:    Maintained
>>   T:    git https://github.com/awilliam/linux-vfio.git
>>   F:    Documentation/ABI/testing/sysfs-devices-vfio-dev
>> +F:    Documentation/ABI/testing/debugfs-vfio
>>   F:    Documentation/driver-api/vfio.rst
>>   F:    drivers/vfio/
>>   F:    include/linux/vfio.h
> 
> .
> 

