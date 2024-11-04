Return-Path: <kvm+bounces-30451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DD3F79BAD8F
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 09:00:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C04F281F9D
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 08:00:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A9E91A0B07;
	Mon,  4 Nov 2024 08:00:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648CA18A93F;
	Mon,  4 Nov 2024 08:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730707231; cv=none; b=hr76pY5kYmBlc0R2rvsD4c9wwZ6y1NZICmHFrQkuhna6MRKXk6X/otpPxBcgCKgiQKrQYXWENNDIBXJMw8vAlGv3KT+SdnQQVpkdnNuBSDGAQ8BetCX2xDeun6L/e/P/lKpNVqmm9H1pEb56ewxqd/UlXC80njaaow576aOcpqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730707231; c=relaxed/simple;
	bh=AdGbmYTuxw465OdvTXQSCs61a1R0cZiPSHg1LjSX4/Q=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Xf9gRlXRb04Zf1xjqssyaBFqU9HBTfKzOBmQM0I2OfZqP7WcNxQttr4qTvlsh10Z0ABBG+zr1yHH75GwpKjVa1SpT6qBcf2OyPIRPDZo87AfqI4SGyxRtQxZPhtN/Rw7cl589BX6vnbTCsQomVoe/5hbiQ5okvq1eBhehZptf2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4XhkPD019zzyVPF;
	Mon,  4 Nov 2024 15:58:39 +0800 (CST)
Received: from dggemv711-chm.china.huawei.com (unknown [10.1.198.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 67BEC18010F;
	Mon,  4 Nov 2024 16:00:24 +0800 (CST)
Received: from kwepemn100017.china.huawei.com (7.202.194.122) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 4 Nov 2024 16:00:12 +0800
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemn100017.china.huawei.com (7.202.194.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 4 Nov 2024 16:00:12 +0800
Subject: Re: [PATCH v11 4/4] Documentation: add debugfs description for hisi
 migration
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
References: <20241025090143.64472-1-liulongfang@huawei.com>
 <20241025090143.64472-5-liulongfang@huawei.com>
 <20241031160952.3b93d4af.alex.williamson@redhat.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <f56da6a9-5b4d-fb3e-d96e-bd46991443fd@huawei.com>
Date: Mon, 4 Nov 2024 16:00:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241031160952.3b93d4af.alex.williamson@redhat.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemn100017.china.huawei.com (7.202.194.122)

On 2024/11/1 6:09, Alex Williamson wrote:
> On Fri, 25 Oct 2024 17:01:43 +0800
> Longfang Liu <liulongfang@huawei.com> wrote:
> 
>> Add a debugfs document description file to help users understand
>> how to use the hisilicon accelerator live migration driver's
>> debugfs.
>>
>> Update the file paths that need to be maintained in MAINTAINERS
>>
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
>> ---
>>  .../ABI/testing/debugfs-hisi-migration        | 25 +++++++++++++++++++
>>  1 file changed, 25 insertions(+)
>>  create mode 100644 Documentation/ABI/testing/debugfs-hisi-migration
>>
>> diff --git a/Documentation/ABI/testing/debugfs-hisi-migration b/Documentation/ABI/testing/debugfs-hisi-migration
>> new file mode 100644
>> index 000000000000..89e4fde5ec6a
>> --- /dev/null
>> +++ b/Documentation/ABI/testing/debugfs-hisi-migration
>> @@ -0,0 +1,25 @@
>> +What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/dev_data
>> +Date:		Oct 2024
>> +KernelVersion:  6.12
> 
> We're currently targeting v6.13, which is likely Jan 2025.  Thanks,
>

OK!

Thanks.
Longfang.

> Alex
> 
>> +Contact:	Longfang Liu <liulongfang@huawei.com>
>> +Description:	Read the configuration data and some status data
>> +		required for device live migration. These data include device
>> +		status data, queue configuration data, some task configuration
>> +		data and device attribute data. The output format of the data
>> +		is defined by the live migration driver.
>> +
>> +What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/migf_data
>> +Date:		Oct 2024
>> +KernelVersion:  6.12
>> +Contact:	Longfang Liu <liulongfang@huawei.com>
>> +Description:	Read the data from the last completed live migration.
>> +		This data includes the same device status data as in "dev_data".
>> +		The migf_data is the dev_data that is migrated.
>> +
>> +What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/cmd_state
>> +Date:		Oct 2024
>> +KernelVersion:  6.12
>> +Contact:	Longfang Liu <liulongfang@huawei.com>
>> +Description:	Used to obtain the device command sending and receiving
>> +		channel status. Returns failure or success logs based on the
>> +		results.
> 
> 
> .
> 

