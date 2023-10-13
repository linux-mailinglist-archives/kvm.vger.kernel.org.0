Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2417F7C7FC5
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 10:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbjJMIQd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 04:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjJMIQb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 04:16:31 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FAD0C9;
        Fri, 13 Oct 2023 01:16:29 -0700 (PDT)
Received: from kwepemm000005.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4S6K3R34hqzvPvX;
        Fri, 13 Oct 2023 16:11:47 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemm000005.china.huawei.com (7.193.23.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Fri, 13 Oct 2023 16:16:26 +0800
Subject: Re: [PATCH v16 2/2] Documentation: add debugfs description for vfio
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <jonathan.cameron@huawei.com>, <bcreeley@amd.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>
References: <20230926093356.56014-1-liulongfang@huawei.com>
 <20230926093356.56014-3-liulongfang@huawei.com>
 <20231003132635.7df44c44.alex.williamson@redhat.com>
From:   liulongfang <liulongfang@huawei.com>
Message-ID: <dbd0de80-1646-87b7-5d97-48a5bd7a174b@huawei.com>
Date:   Fri, 13 Oct 2023 16:16:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20231003132635.7df44c44.alex.williamson@redhat.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.121.110]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm000005.china.huawei.com (7.193.23.27)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/10/4 3:26, Alex Williamson wrote:
> On Tue, 26 Sep 2023 17:33:56 +0800
> liulongfang <liulongfang@huawei.com> wrote:
> 
>> From: Longfang Liu <liulongfang@huawei.com>
>>
>> 1.Add an debugfs document description file to help users understand
>> how to use the accelerator live migration driver's debugfs.
>> 2.Update the file paths that need to be maintained in MAINTAINERS
>>
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> ---
>>  Documentation/ABI/testing/debugfs-vfio | 25 +++++++++++++++++++++++++
>>  MAINTAINERS                            |  1 +
>>  2 files changed, 26 insertions(+)
>>  create mode 100644 Documentation/ABI/testing/debugfs-vfio
>>
>> diff --git a/Documentation/ABI/testing/debugfs-vfio b/Documentation/ABI/testing/debugfs-vfio
>> new file mode 100644
>> index 000000000000..7959ec5ac445
>> --- /dev/null
>> +++ b/Documentation/ABI/testing/debugfs-vfio
>> @@ -0,0 +1,25 @@
>> +What:		/sys/kernel/debug/vfio
>> +Date:		Sep 2023
>> +KernelVersion:  6.7
>> +Contact:	Longfang Liu <liulongfang@huawei.com>
>> +Description:	This debugfs file directory is used for debugging
>> +		of vfio devices, it's a common directory for all vfio devices.
>> +		Vfio core will create a device subdirectory under this
>> +		directory.
>> +
>> +What:		/sys/kernel/debug/vfio/<device>/migration
>> +Date:		Sep 2023
>> +KernelVersion:  6.7
>> +Contact:	Longfang Liu <liulongfang@huawei.com>
>> +Description:	This debugfs file directory is used for debugging
>> +		of vfio devices that support live migration.
>> +		The debugfs of each vfio device that supports live migration
>> +		could be created under this directory.
>> +
>> +What:		/sys/kernel/debug/vfio/<device>/migration/state
>> +Date:		Sep 2023
>> +KernelVersion:  6.7
>> +Contact:	Longfang Liu <liulongfang@huawei.com>
>> +Description:	Read the live migration status of the vfio device.
>> +		The status of these live migrations includes:
>> +		ERROR, RUNNING, STOP, STOP_COPY, RESUMING.
> 
> This is another area that's doomed to be out of sync, it's already not
> updated for P2P states.  Better to avoid the problem and say something
> like "The contents of the state file reflects the migration state
> relative to those defined in the vfio_device_mig_state enum".
> 
> Also, as suggested last time, October is a more realistic date.  Thanks,
> 

OK, I will modify it in the next version

Thanks
Longfang.

> Alex
> 
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 7b1306615fc0..bd01ca674c60 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -22304,6 +22304,7 @@ L:	kvm@vger.kernel.org
>>  S:	Maintained
>>  T:	git https://github.com/awilliam/linux-vfio.git
>>  F:	Documentation/ABI/testing/sysfs-devices-vfio-dev
>> +F:	Documentation/ABI/testing/debugfs-vfio
>>  F:	Documentation/driver-api/vfio.rst
>>  F:	drivers/vfio/
>>  F:	include/linux/vfio.h
> 
> .
> 
