Return-Path: <kvm+bounces-29642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F075B9AE685
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 15:32:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8720EB264A1
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 13:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDCF21F80A3;
	Thu, 24 Oct 2024 13:26:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEACE1F76CD;
	Thu, 24 Oct 2024 13:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729776413; cv=none; b=lT+PFnEUpUtd8Y1mee8e6nDk1wNg2PDcOsdUtKXHKFUoX5k5+2mlFTy1nU8GH8tS0MMj90Fw3uDrMIjZJChFdSH1+o6t7yZ5mgg+BILzYsd9SsFxnr9/BN9GXOt5FCI7Q/y7GkrkwX5Ux2OldLwTc/e3qq8G2yy7vLiXpeOi6eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729776413; c=relaxed/simple;
	bh=cHcuVz0Fdokou6dsDf6U+CYbC8Lz1JhJlstYhQjuyS8=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=abdlt5I2+HBMTTa7dgnTbldJL7u3z/1Y+zCmvHeviRKrOxZw8zBOo2CaF3trRRkxr3E+Sx71J3JuNFFWRjxt7v5i4AuSbjHaEiaonPT6CeyYc715FuTp0E8e+TbzV65P0PRD5RhB8+ADWCdibhzg8Hu1IU1FCd41LTBbLKN0y3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XZ69F4kK8z2FbGJ;
	Thu, 24 Oct 2024 21:25:21 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id 3FBC8180043;
	Thu, 24 Oct 2024 21:26:46 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 24 Oct 2024 21:26:45 +0800
Subject: Re: [PATCH v10 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon
 migration driver
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, Jonathan Cameron <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
References: <20241016012308.14108-1-liulongfang@huawei.com>
 <20241016012308.14108-4-liulongfang@huawei.com>
 <bedd3623de984a6fafd24a2c85f6c05e@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <ca83846e-d322-634c-67b3-12ad9ba5814f@huawei.com>
Date: Thu, 24 Oct 2024 21:26:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <bedd3623de984a6fafd24a2c85f6c05e@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600005.china.huawei.com (7.193.23.191)

On 2024/10/24 21:12, Shameerali Kolothum Thodi wrote:
> 
> 
>> -----Original Message-----
>> From: liulongfang <liulongfang@huawei.com>
>> Sent: Wednesday, October 16, 2024 2:23 AM
>> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
>> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
>> <jonathan.cameron@huawei.com>
>> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
>> Subject: [PATCH v10 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon
>> migration driver
> 
> [..]
>  
>> @@ -1342,6 +1538,7 @@ static int hisi_acc_vfio_pci_migrn_init_dev(struct
>> vfio_device *core_vdev)
>>  	hisi_acc_vdev->pf_qm = pf_qm;
>>  	hisi_acc_vdev->vf_dev = pdev;
>>  	mutex_init(&hisi_acc_vdev->state_mutex);
>> +	mutex_init(&hisi_acc_vdev->open_mutex);
>>
>>  	core_vdev->migration_flags = VFIO_MIGRATION_STOP_COPY |
>> VFIO_MIGRATION_PRE_COPY;
>>  	core_vdev->mig_ops = &hisi_acc_vfio_pci_migrn_state_ops;
>> @@ -1413,6 +1610,9 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev
>> *pdev, const struct pci_device
>>  	ret = vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
>>  	if (ret)
>>  		goto out_put_vdev;
>> +
>> +	if (ops == &hisi_acc_vfio_pci_migrn_ops)
>> +		hisi_acc_vfio_debug_init(hisi_acc_vdev);
> 
> As commented earlier, the ops check can be moved to the debug_init() function 
> and you can remove ops check for the debug_exit() below. You may have to
> rearrange the functions to avoid the compiler error you mentioned in previous
> version to do so.
>

OK, I'll put it into debug_init in the next version.

>>  	return 0;
>>
>>  out_put_vdev:
>> @@ -1423,8 +1623,11 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev
>> *pdev, const struct pci_device
>>  static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
>>  {
>>  	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>> hisi_acc_drvdata(pdev);
>> +	struct vfio_device *vdev = &hisi_acc_vdev->core_device.vdev;
>>
>>  	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
>> +	if (vdev->ops == &hisi_acc_vfio_pci_migrn_ops)
>> +		hisi_acc_vf_debugfs_exit(hisi_acc_vdev);
> 
> As mentioned above remove the ops check here.
> 

OK.

> With the above ones checked and  fixed,
> Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> .
> 

Thanks,
Longfang.

