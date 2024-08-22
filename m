Return-Path: <kvm+bounces-24814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E78E395B068
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 10:31:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A34D7286263
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 08:31:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63495181B87;
	Thu, 22 Aug 2024 08:29:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E82B17F4EC;
	Thu, 22 Aug 2024 08:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724315367; cv=none; b=Qy/ZgOz4p/a/nfCdX/wgREUxTJSKU4QEe68QYpEZVIXiCMQYAKuRE0me1WcmPYA1c95ZrtLOq6ShrRbPgGRerwloAU/MVUH4X1v7XTVgc6ZDv/lxYmf/o5hHYT8NzsDnhCCwNBaMcPEo8AigDMMKsIkt1YVvfl07nzRrIepCXJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724315367; c=relaxed/simple;
	bh=AmUawWbJ5Csrxl4kbSCmn+U4bMUPW8G/yy8t4f1Xn+A=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=n4KcxEZtCuFjj0Z2r8K8pY11WIrVOwE51lmOWzRTd8OZIgF0oGA68eYt4gvlLtJxfxIQ7gbpHknIXkTp1pWgq3xJc+MUbGAOjeG2XxOlBshgoPPnch7msICT08C72K4XhML9xO3rKJe7+Wd9H1tq0Vy4ErLEhr5knjZWNEK/vlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WqGW37087z1HGQs;
	Thu, 22 Aug 2024 16:26:07 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id 09C461400FD;
	Thu, 22 Aug 2024 16:29:21 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 22 Aug 2024 16:29:20 +0800
Subject: Re: [PATCH v8 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon
 migration driver
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, Jonathan Cameron <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
References: <20240806122928.46187-1-liulongfang@huawei.com>
 <20240806122928.46187-4-liulongfang@huawei.com>
 <42784fb0fd1c44cf9470c9662e154b88@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <c7f0ae83-9490-c9db-e098-6eb18443599f@huawei.com>
Date: Thu, 22 Aug 2024 16:29:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <42784fb0fd1c44cf9470c9662e154b88@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600005.china.huawei.com (7.193.23.191)

On 2024/8/14 17:39, Shameerali Kolothum Thodi wrote:
> 
> 
>> -----Original Message-----
>> From: liulongfang <liulongfang@huawei.com>
>> Sent: Tuesday, August 6, 2024 1:29 PM
>> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum Thodi
>> <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
>> <jonathan.cameron@huawei.com>
>> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
>> Subject: [PATCH v8 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon
>> migration driver
> ... 
>> +static int hisi_acc_vf_dev_read(struct seq_file *seq, void *data)
>> +{
>> +	struct device *vf_dev = seq->private;
>> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
>> +	struct vfio_device *vdev = &core_device->vdev;
>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>> hisi_acc_get_vf_dev(vdev);
>> +	size_t vf_data_sz = offsetofend(struct acc_vf_data, padding);
>> +	struct acc_vf_data *vf_data = NULL;
>> +	int ret;
>> +
>> +	vf_data = kzalloc(sizeof(struct acc_vf_data), GFP_KERNEL);
>> +	if (!vf_data)
>> +		return -ENOMEM;
>> +
>> +	mutex_lock(&hisi_acc_vdev->state_mutex);
>> +	ret = hisi_acc_vf_debug_check(seq, vdev);
>> +	if (ret) {
>> +		mutex_unlock(&hisi_acc_vdev->state_mutex);
>> +		goto migf_err;
>> +	}
>> +
>> +	vf_data->vf_qm_state = hisi_acc_vdev->vf_qm_state;
>> +	ret = vf_qm_read_data(&hisi_acc_vdev->vf_qm, vf_data);
>> +	if (ret) {
>> +		mutex_unlock(&hisi_acc_vdev->state_mutex);
>> +		goto migf_err;
>> +	}
>> +
>> +	mutex_unlock(&hisi_acc_vdev->state_mutex);
>> +
>> +	seq_hex_dump(seq, "Dev Data:", DUMP_PREFIX_OFFSET, 16, 1,
>> +			(unsigned char *)vf_data,
>> +			vf_data_sz, false);
>> +
>> +	seq_printf(seq,
>> +		 "acc device:\n"
>> +		 "device  ready: %u\n"
>> +		 "device  opened: %d\n"
>> +		 "data     size: %lu\n",
>> +		 hisi_acc_vdev->vf_qm_state,
>> +		 hisi_acc_vdev->dev_opened,
> 
> I think the dev_opened will be always true if it reaches here and can be
> removed from here and from hisi_acc_vf_migf_read() as well.
> 
> Please don't respin just for this. Let us wait for others to review this.
>
Hello£¬Alex Williamson and Jason Gunthorpe£º

Could you take a moment to review this patch?

Thanks,
Longfang.

> Thanks,
> Shameer
> .
> 

