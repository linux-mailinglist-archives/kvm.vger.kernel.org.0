Return-Path: <kvm+bounces-62146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E9514C38DD5
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 03:26:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 247CA3B8B15
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 02:26:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2256242D7D;
	Thu,  6 Nov 2025 02:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="PxU8X9ab"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C783C38;
	Thu,  6 Nov 2025 02:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762395993; cv=none; b=R0g69z5AbfPhFEXaOV5HOamY4PC9t0HZR9o5bG/AlN3MaWCn/HeDutfG7LBJHaC8Kw/sUvnZNMyqeN7yjPWLUAVFIkN+gJb6MtopqYkcgISfhub24LZyYiKlQYWJhQoPaGvQDtrY3M3hjJUSKh/4OskjRrYko0ZeMAo6UKz9C6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762395993; c=relaxed/simple;
	bh=h11H5wkM9ur+m6QwSQpYG0dlXYV2lDeGb7LhuWHxCI4=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=kvNEIJzmOAskVVP3d2uLRxfIXLAL1XfegxsQhORNqqzzXPuf6PU3MQ6TxXG2fjMC4IcbsP94ZSh2R2+cjBnLU5BRjFSbkngSY+lKWMeXMwLZjbQatMSmjacy9gl66OhSXx66gCLBSlv+zy+v82oOztwdkpH6MSfH+99BTAYUblk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=PxU8X9ab; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4eRyeZfQFp+latL98Ldfp3uBLlWIsOh2ouj3V9Mpzos=;
	b=PxU8X9abgBP3U+ytYjuICLEqefCFNEIiwu3JBoSYA9P66YWKQi1GHpZgn9guAD7dkJWu9NRvn
	TCnyb85qJmLS4zc5mOm+CR8itzsxwfNvxBg8NMh5CX7QtfXwmLOVpknn37boE7dXWBCw3Et8F/J
	c26GuYuA8Axqztvfk9V4feE=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4d25cf3FbczmVWV;
	Thu,  6 Nov 2025 10:24:50 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 44E7A1A0188;
	Thu,  6 Nov 2025 10:26:26 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 6 Nov 2025 10:26:25 +0800
Subject: Re: [PATCH v12 2/2] hisi_acc_vfio_pci: adapt to new migration
 configuration
To: Alex Williamson <alex@shazbot.org>
CC: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<herbert@gondor.apana.org.au>, <shameerkolothum@gmail.com>,
	<jonathan.cameron@huawei.com>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20251030015744.131771-1-liulongfang@huawei.com>
 <20251030015744.131771-3-liulongfang@huawei.com>
 <20251105153233.59a504ae.alex@shazbot.org>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <7d1bef79-2cd0-9784-6dd9-d7a995ec3238@huawei.com>
Date: Thu, 6 Nov 2025 10:26:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251105153233.59a504ae.alex@shazbot.org>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2025/11/6 6:32, Alex Williamson wrote:
> On Thu, 30 Oct 2025 09:57:44 +0800
> Longfang Liu <liulongfang@huawei.com> wrote:
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> index 91002ceeebc1..419a378c3d1d 100644
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> @@ -50,8 +50,10 @@
>>  #define QM_QUE_ISO_CFG_V	0x0030
>>  #define QM_PAGE_SIZE		0x0034
>>  
>> -#define QM_EQC_DW0		0X8000
>> -#define QM_AEQC_DW0		0X8020
>> +#define QM_EQC_VF_DW0		0X8000
>> +#define QM_AEQC_VF_DW0		0X8020
>> +#define QM_EQC_PF_DW0		0x1c00
>> +#define QM_AEQC_PF_DW0		0x1c20
>>  
>>  #define ACC_DRV_MAJOR_VER 1
>>  #define ACC_DRV_MINOR_VER 0
>> @@ -59,6 +61,22 @@
>>  #define ACC_DEV_MAGIC_V1	0XCDCDCDCDFEEDAACC
>>  #define ACC_DEV_MAGIC_V2	0xAACCFEEDDECADEDE
>>  
>> +#define QM_MIG_REGION_OFFSET		0x180000
>> +#define QM_MIG_REGION_SIZE		0x2000
>> +
>> +/**
>> + * On HW_ACC_MIG_VF_CTRL mode, the configuration domain supporting live
>> + * migration functionality is located in the latter 32KB of the VF's BAR2.
>> + * The Guest is only provided with the first 32KB of the VF's BAR2.
>> + * On HW_ACC_MIG_PF_CTRL mode, the configuration domain supporting live
>> + * migration functionality is located in the PF's BAR2, and the entire 64KB
>> + * of the VF's BAR2 is allocated to the Guest.
>> + */
>> +enum hw_drv_mode {
>> +	HW_ACC_MIG_VF_CTRL = 0,
>> +	HW_ACC_MIG_PF_CTRL,
>> +};
>> +
>>  struct acc_vf_data {
>>  #define QM_MATCH_SIZE offsetofend(struct acc_vf_data, qm_rsv_state)
>>  	/* QM match information */
>> @@ -125,6 +143,7 @@ struct hisi_acc_vf_core_device {
>>  	struct pci_dev *vf_dev;
>>  	struct hisi_qm *pf_qm;
>>  	struct hisi_qm vf_qm;
>> +	int drv_mode;
> 
> I can fix this on commit rather than send a new version, but is there
> any reason we wouldn't make use of the enum here:
> 
> 	enum hw_drv_mode drv_mode;
> 
> ?  Thanks,
>

I didn't use the enum type here due to my habit of declaring enum variables with
integer types.
If needed, please directly modify it to use the enum type definition.

Thanks.
Longfang.

> Alex
> 
>>  	/*
>>  	 * vf_qm_state represents the QM_VF_STATE register value.
>>  	 * It is set by Guest driver for the ACC VF dev indicating
> 
> .
> 

