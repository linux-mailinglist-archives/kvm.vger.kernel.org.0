Return-Path: <kvm+bounces-13142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B1BF8929A9
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 08:54:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 542C71C20EE8
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 07:54:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB6388BE2;
	Sat, 30 Mar 2024 07:54:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FA933D0;
	Sat, 30 Mar 2024 07:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711785240; cv=none; b=C6Sh4x0+lTDWrBV+pC5D3WIpHNMSSodALksqfJJmy1qiOcV/1+snRuS/qE7ddh6GpKGAszIcEyEzW3x85PkXX6njUFjvgUtxj8Oc6ew+JlpcuEl5CGBM63D26a3Xd02pF8xhAaFoZA5H4COdm5Rg4nggFF6uJXLjbTzyuASLpZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711785240; c=relaxed/simple;
	bh=StZXJ05C9OpHcEpSF1nMvaAZXZ5F02kL5AJXpgPbZFs=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=droeQHLoiGvVxwcJOWBKe4/5wuypG7sZB6IjFjDUOUhVAO3nPbM/u8VHmCYz9WV+biXXd5P9TCp2Ntj5wgJpc1FczBrqlkLqSsd/N/yZSoOuobX4+/S1Xt4gEOASoLUOo1h46PBFkZf3xojf1UhB0j7a2dHu8bUQSmh7CkTflNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4V68cQ4HQ5z1xtRL;
	Sat, 30 Mar 2024 15:51:50 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id 2F2AF1402DE;
	Sat, 30 Mar 2024 15:53:54 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sat, 30 Mar 2024 15:53:53 +0800
Subject: Re: [PATCH v3 4/4] Documentation: add debugfs description for hisi
 migration
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>
References: <20240307063608.26729-1-liulongfang@huawei.com>
 <20240307063608.26729-2-liulongfang@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <7e566606-f427-95c0-3016-4f75e0a22b94@huawei.com>
Date: Sat, 30 Mar 2024 15:53:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240307063608.26729-2-liulongfang@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600005.china.huawei.com (7.193.23.191)

On 2024/3/7 14:36, Longfang Liu wrote:
> Add a debugfs document description file to help users understand
> how to use the hisilicon accelerator live migration driver's
> debugfs.
> 
> Update the file paths that need to be maintained in MAINTAINERS
> 
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  .../ABI/testing/debugfs-hisi-migration        | 34 +++++++++++++++++++
>  MAINTAINERS                                   |  1 +
>  2 files changed, 35 insertions(+)
>  create mode 100644 Documentation/ABI/testing/debugfs-hisi-migration
> 
> diff --git a/Documentation/ABI/testing/debugfs-hisi-migration b/Documentation/ABI/testing/debugfs-hisi-migration
> new file mode 100644
> index 000000000000..7111af41ed05
> --- /dev/null
> +++ b/Documentation/ABI/testing/debugfs-hisi-migration
> @@ -0,0 +1,34 @@
> +What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/data
> +Date:		Mar 2024
> +KernelVersion:  6.8
> +Contact:	Longfang Liu <liulongfang@huawei.com>
> +Description:	Read the live migration data of the vfio device.
> +		These data include device status data, queue configuration
> +		data and some task configuration data.
> +		The output format of the data is defined by the live
> +		migration driver.
> +
> +What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/attr
> +Date:		Mar 2024
> +KernelVersion:  6.8
> +Contact:	Longfang Liu <liulongfang@huawei.com>
> +Description:	Read the live migration attributes of the vfio device.
> +		it include device status attributes and data length attributes
> +		The output format of the attributes is defined by the live
> +		migration driver.
> +
> +What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/cmd_state
> +Date:		Mar 2024
> +KernelVersion:  6.8
> +Contact:	Longfang Liu <liulongfang@huawei.com>
> +Description:	Used to obtain the device command sending and receiving
> +		channel status. If successful, returns the command value.
> +		If failed, return error log.
> +
> +What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/save
> +Date:		Mar 2024
> +KernelVersion:  6.8
> +Contact:	Longfang Liu <liulongfang@huawei.com>
> +Description:	Trigger the Hisilicon accelerator device to perform
> +		the state saving operation of live migration through the read
> +		operation, and output the operation log results.
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7625911ec2f1..8c2d13b13273 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -23072,6 +23072,7 @@ M:	Longfang Liu <liulongfang@huawei.com>
>  M:	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
>  L:	kvm@vger.kernel.org
>  S:	Maintained
> +F:	Documentation/ABI/testing/debugfs-hisi-migration
>  F:	drivers/vfio/pci/hisilicon/
>  
>  VFIO MEDIATED DEVICE DRIVERS
> 

Hi, Alex:
Are there any issues with this patchset that need to be modified?

Thanks,

Longfang.

