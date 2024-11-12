Return-Path: <kvm+bounces-31588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DADE19C505C
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 09:16:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 92CFD1F229D6
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:16:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC01A20B210;
	Tue, 12 Nov 2024 08:15:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B75E79C4;
	Tue, 12 Nov 2024 08:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731399356; cv=none; b=LaMD0DMsOfoHDTsw8E5DugC0js7b1BwHXTpjOGobuxHs8XE17zcjF2nOCfwliLrC87+LwFlz3McjfVKeqWoo7FrHzdkOFqGtAriVAtUWQ3NB4kNggYGTjdDIoHtJP+DiP2tj63zDcYFDzqImGw84I7aSBuXVNRwzY9GZ+Q2ByIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731399356; c=relaxed/simple;
	bh=X2pqQTR1ih3jbpnM0w6zWU4zqT80DyMPwYiUZjm8MvE=;
	h=Subject:From:To:CC:References:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=rJ7XnhADobeSeLflwr7/O/TUewf3qjfJCCtJ1M9uRpymzr+ACLuFxtG7BQ5PnoRLT/8w7agBKwTZQC+FDbzWn1yY02DS3BeLPbvizGtYsrKqDrPg4anJx5PXokL0U9QnJCzV4l2jNBZKyK3VP5IOWGkHnFCoRMUYJKfPiHJKhvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4XnfMG2Cjyz1jy0R;
	Tue, 12 Nov 2024 16:14:02 +0800 (CST)
Received: from dggemv711-chm.china.huawei.com (unknown [10.1.198.66])
	by mail.maildlp.com (Postfix) with ESMTPS id B63A1180043;
	Tue, 12 Nov 2024 16:15:50 +0800 (CST)
Received: from kwepemn100017.china.huawei.com (7.202.194.122) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 12 Nov 2024 16:15:50 +0800
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemn100017.china.huawei.com (7.202.194.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 12 Nov 2024 16:15:49 +0800
Subject: Re: [PATCH v14 0/4] debugfs to hisilicon migration driver
From: liulongfang <liulongfang@huawei.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
References: <20241108065538.45710-1-liulongfang@huawei.com>
 <20241108140121.1032a68a.alex.williamson@redhat.com>
 <b546eed4-3b5f-36f3-4a7f-fc97306bbbe3@huawei.com>
Message-ID: <0deb2283-cf1c-9ca8-9863-f35c7de6d588@huawei.com>
Date: Tue, 12 Nov 2024 16:15:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <b546eed4-3b5f-36f3-4a7f-fc97306bbbe3@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemn100017.china.huawei.com (7.202.194.122)

On 2024/11/11 21:59, liulongfang wrote:
> On 2024/11/9 5:01, Alex Williamson wrote:
>> On Fri, 8 Nov 2024 14:55:34 +0800
>> Longfang Liu <liulongfang@huawei.com> wrote:
>>
>>> Add a debugfs function to the hisilicon migration driver in VFIO to
>>> provide intermediate state values and data during device migration.
>>>
>>> When the execution of live migration fails, the user can view the
>>> status and data during the migration process separately from the
>>> source and the destination, which is convenient for users to analyze
>>> and locate problems.
>>>
>>> Changes v13 -> v14
>>> 	Bugfix the parameter problem of seq_puts()
>>
>> Should we assume this one is at least compile tested?  Thanks,
>>
>> Alex
>>
> Yes, the patch needs to be fully tested..
> I use the latest kernel6.12 and openEuler file system.
> The verification test found that there is no problem with seq_printf()
> and seq_puts(). But there is something wrong with the memory allocated
> by "migf" and it needs to be fixed.
>

"migf" issue:

void *migf = NULL;
migf = kzalloc(sizeof(struct hisi_acc_vf_migration_file), GFP_KERNEL);

modified since last review:
void *migf = NULL;
migf = kzalloc(sizeof(*migf), GFP_KERNEL);

The length after kzalloc allocates memory is wrong.
We need to modify the definition of "migf" as follows:

struct hisi_acc_vf_migration_file *migf = NULL;
migf = kzalloc(sizeof(*migf), GFP_KERNEL);

It has been modified in the next version v15.
And completed its functional testing using the latest
kernel 6.12 and openEuler file system.

Thanks.
Longfang.

> Thanks.
> Longfang.
> 
>>>
>>> Changes v12 -> v13
>>> 	Replace seq_printf() with seq_puts()
>>>
>>> Changes v11 -> v12
>>> 	Update comments and delete unnecessary logs
>>>
>>> Changes v10 -> v11
>>> 	Update conditions for debugfs registration
>>>
>>> Changes v9 -> v10
>>> 	Optimize symmetry processing of mutex
>>>
>>> Changes v8 -> v9
>>> 	Added device enable mutex
>>>
>>> Changes v7 -> v8
>>> 	Delete unnecessary information
>>>
>>> Changes v6 -> v7
>>> 	Remove redundant kernel error log printing and
>>> 	remove unrelated bugfix code
>>>
>>> Changes v5 -> v6
>>> 	Modify log output calling error
>>>
>>> Changes v4 -> v5
>>> 	Adjust the descriptioniptionbugfs file directory
>>>
>>> Changes v3 -> v4
>>> 	Rebased on kernel6.9
>>>
>>> Changes 2 -> v3
>>> 	Solve debugfs serialization problem.
>>>
>>> Changes v1 -> v2
>>> 	Solve the racy problem of io_base.
>>>
>>> Longfang Liu (4):
>>>   hisi_acc_vfio_pci: extract public functions for container_of
>>>   hisi_acc_vfio_pci: create subfunction for data reading
>>>   hisi_acc_vfio_pci: register debugfs for hisilicon migration driver
>>>   Documentation: add debugfs description for hisi migration
>>>
>>>  .../ABI/testing/debugfs-hisi-migration        |  25 ++
>>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 266 ++++++++++++++++--
>>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  19 ++
>>>  3 files changed, 279 insertions(+), 31 deletions(-)
>>>  create mode 100644 Documentation/ABI/testing/debugfs-hisi-migration
>>>
>>
>>
>> .
>>
> 
> .
> 

