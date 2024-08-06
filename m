Return-Path: <kvm+bounces-23324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75D34948B70
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 10:38:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A72441C23146
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 08:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C786F1BD4F4;
	Tue,  6 Aug 2024 08:38:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A281BB696;
	Tue,  6 Aug 2024 08:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722933486; cv=none; b=k0nDxCFZJkNpt/Y09D/qD3x+jBPiqgB04lgUo5MaSo9r6ypshJqUWI/nIgOTXPxMczq3UjxqC3UsBlcHNxTyRrl9xJt+8TE/b999Xin0WzpKF1KWVWc65vAYmvbrTWyT4Ywtdqvkv85qd7lDFPKuTvcWvNwKRddH7VqeUQMo/lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722933486; c=relaxed/simple;
	bh=VPu/rXzZq8g+XxSQ3U883uFuFMe3J/6kQDDuYUb77Ng=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=r7kqizIW66QfKwuyHhCLiyXvoSFcABCBqJS/cHesf/3YNw8c5K8hPRJrBilvO1NxxXFpC4KrrtKm0OwCwBEzI7gRuK2k5D6M5A6x+gdKjY3PAKHwlKzWTc32wVfe+UnEqxjhBKE9MUsb7gMPzHtgXMMEvywpeKG1xCQ83UNdaW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WdRX22k7Wzcd4J;
	Tue,  6 Aug 2024 16:37:54 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id 69C4A180AE6;
	Tue,  6 Aug 2024 16:38:00 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 6 Aug 2024 16:37:59 +0800
Subject: Re: [PATCH v7 4/4] Documentation: add debugfs description for hisi
 migration
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, Jonathan Cameron <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
References: <20240730121438.58455-1-liulongfang@huawei.com>
 <20240730121438.58455-5-liulongfang@huawei.com>
 <6b13310df6df42faba08eb7335c4b33b@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <26fbc580-c626-db9f-44b5-40f7e47b7928@huawei.com>
Date: Tue, 6 Aug 2024 16:37:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <6b13310df6df42faba08eb7335c4b33b@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600005.china.huawei.com (7.193.23.191)

On 2024/8/5 17:09, Shameerali Kolothum Thodi wrote:
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
>> Subject: [PATCH v7 4/4] Documentation: add debugfs description for hisi
>> migration
>>
>> Add a debugfs document description file to help users understand
>> how to use the hisilicon accelerator live migration driver's
>> debugfs.
>>
>> Update the file paths that need to be maintained in MAINTAINERS
>>
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> ---
>>  .../ABI/testing/debugfs-hisi-migration        | 25 +++++++++++++++++++
>>  1 file changed, 25 insertions(+)
>>  create mode 100644 Documentation/ABI/testing/debugfs-hisi-migration
>>
>> diff --git a/Documentation/ABI/testing/debugfs-hisi-migration
>> b/Documentation/ABI/testing/debugfs-hisi-migration
>> new file mode 100644
>> index 000000000000..053f3ebba9b1
>> --- /dev/null
>> +++ b/Documentation/ABI/testing/debugfs-hisi-migration
>> @@ -0,0 +1,25 @@
>> +What:
>> 	/sys/kernel/debug/vfio/<device>/migration/hisi_acc/dev_data
>> +Date:		Jul 2024
>> +KernelVersion:  6.11
>> +Contact:	Longfang Liu <liulongfang@huawei.com>
>> +Description:	Read the configuration data and some status data
>> +		required for device live migration. These data include device
>> +		status data, queue configuration data, some task
>> configuration
>> +		data and device attribute data. The output format of the data
>> +		is defined by the live migration driver.
>> +
>> +What:
>> 	/sys/kernel/debug/vfio/<device>/migration/hisi_acc/migf_data
>> +Date:		Jul 2024
>> +KernelVersion:  6.11
>> +Contact:	Longfang Liu <liulongfang@huawei.com>
>> +Description:	Read the data from the last completed live migration.
>> +		This data includes the same device status data as in
>> "dev_data".
>> +		And some device status data after the migration is
>> completed.
> 
> Actually what info is different from dev_data here? Only that it is the
> dev_data after a migration is attempted/completed, right?
>

Yes, the only difference is: The mig_data is the dev_data that is migrated.

Thanks.
Longfang.

> Thanks,
> Shameer
> 
>> +
>> +What:
>> 	/sys/kernel/debug/vfio/<device>/migration/hisi_acc/cmd_state
>> +Date:		Jul 2024
>> +KernelVersion:  6.11
>> +Contact:	Longfang Liu <liulongfang@huawei.com>
>> +Description:	Used to obtain the device command sending and receiving
>> +		channel status. Returns failure or success logs based on the
>> +		results.
>> --
>> 2.24.0
> 
> .
> 

