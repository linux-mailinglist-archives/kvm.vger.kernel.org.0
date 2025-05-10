Return-Path: <kvm+bounces-46104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B3F5AB21C9
	for <lists+kvm@lfdr.de>; Sat, 10 May 2025 09:46:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3161B4C378B
	for <lists+kvm@lfdr.de>; Sat, 10 May 2025 07:46:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ECEA1E7660;
	Sat, 10 May 2025 07:46:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C541E0B86;
	Sat, 10 May 2025 07:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746863185; cv=none; b=SoYtCFddCR4gxUrBKBMTmQNSZK66FosBlQ6HGh7fWaexBBDBTPUzT2cWcdJV+IWxJjT2x5Q2TKAZ6pV0Vc6zGdl6bRAoLeCOGVGND9tCwNp82Vgnm0Bgpr8YzIxnsd7yDaDK+e68FRJ+u//bg/y7JQ9JXhkFiQ7bF5Ak5WEd0wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746863185; c=relaxed/simple;
	bh=np0DaZ3kQtyZ8X0ulRKMltdlhXrvfRJ+lXFN+7rI0b0=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Bf8R1jll0xeRs8DiCkkRxTSqfJgutqrj+1RNKLvgaWTIiCCvjPhIAMZz/svgrlrPMNYGqo8yQylBuUgF98fqPgh5HnmLJPfz6DaA6zkhRUlrdiDFCzaAFlwWchP14z/kv2RUlgkpWmWmkEklzBjU2FzRxpPIyT+Y5L46nSlaE3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4ZvdDz6lNgznfXM;
	Sat, 10 May 2025 15:44:51 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id AC7911400CA;
	Sat, 10 May 2025 15:46:09 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemg500006.china.huawei.com (7.202.181.43) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 10 May 2025 15:46:09 +0800
Subject: Re: [PATCH v7 6/6] hisi_acc_vfio_pci: update function return values.
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, Jonathan Cameron <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
References: <20250411035907.57488-1-liulongfang@huawei.com>
 <20250411035907.57488-7-liulongfang@huawei.com>
 <ed4f09039ffb45f3a3d5b418c92ae6ad@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <c60625eb-eb48-d504-7334-70e375b4a202@huawei.com>
Date: Sat, 10 May 2025 15:46:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ed4f09039ffb45f3a3d5b418c92ae6ad@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemg500006.china.huawei.com (7.202.181.43)

on 2025/4/15 17:25, Shameerali Kolothum Thodi wrote:
> 
> 
>> -----Original Message-----
>> From: liulongfang <liulongfang@huawei.com>
>> Sent: Friday, April 11, 2025 4:59 AM
>> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
>> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
>> <jonathan.cameron@huawei.com>
>> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
>> Subject: [PATCH v7 6/6] hisi_acc_vfio_pci: update function return values.
>>
>> In this driver file, many functions call sub-functions and use ret
>> to store the error code of the sub-functions.
>> However, instead of directly returning ret to the caller, they use a
>> converted error code, which prevents the end-user from clearly
>> understanding the root cause of the error.
>> Therefore, the code needs to be modified to directly return the error
>> code from the sub-functions.
>>
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> ---
>>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 16 ++++++++--------
>>  1 file changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> index d12a350440d3..c63e302ac092 100644
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> @@ -392,7 +392,7 @@ static int vf_qm_check_match(struct
>> hisi_acc_vf_core_device *hisi_acc_vdev,
>>  	ret = vf_qm_version_check(vf_data, dev);
>>  	if (ret) {
>>  		dev_err(dev, "failed to match ACC_DEV_MAGIC\n");
>> -		return -EINVAL;
>> +		return ret;
>>  	}
>>
>>  	if (vf_data->dev_id != hisi_acc_vdev->vf_dev->device) {
>> @@ -404,7 +404,7 @@ static int vf_qm_check_match(struct
>> hisi_acc_vf_core_device *hisi_acc_vdev,
>>  	ret = qm_get_vft(vf_qm, &vf_qm->qp_base);
>>  	if (ret <= 0) {
>>  		dev_err(dev, "failed to get vft qp nums\n");
>> -		return -EINVAL;
>> +		return ret;
>>  	}
>>
>>  	if (ret != vf_data->qp_num) {
>> @@ -501,7 +501,7 @@ static int vf_qm_load_data(struct
>> hisi_acc_vf_core_device *hisi_acc_vdev,
>>  	ret = qm_write_regs(qm, QM_VF_STATE, &vf_data->vf_qm_state, 1);
>>  	if (ret) {
>>  		dev_err(dev, "failed to write QM_VF_STATE\n");
>> -		return -EINVAL;
>> +		return ret;
>>  	}
>>  	hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
>>
>> @@ -542,7 +542,7 @@ static int vf_qm_read_data(struct hisi_qm *vf_qm,
>> struct acc_vf_data *vf_data)
>>
>>  	ret = qm_get_regs(vf_qm, vf_data);
>>  	if (ret)
>> -		return -EINVAL;
>> +		return ret;
>>
>>  	/* Every reg is 32 bit, the dma address is 64 bit. */
>>  	vf_data->eqe_dma = vf_data->qm_eqc_dw[QM_XQC_ADDR_HIGH];
>> @@ -556,13 +556,13 @@ static int vf_qm_read_data(struct hisi_qm
>> *vf_qm, struct acc_vf_data *vf_data)
>>  	ret = qm_get_sqc(vf_qm, &vf_data->sqc_dma);
>>  	if (ret) {
>>  		dev_err(dev, "failed to read SQC addr!\n");
>> -		return -EINVAL;
>> +		return ret;
>>  	}
>>
>>  	ret = qm_get_cqc(vf_qm, &vf_data->cqc_dma);
>>  	if (ret) {
>>  		dev_err(dev, "failed to read CQC addr!\n");
>> -		return -EINVAL;
>> +		return ret;
>>  	}
>>
>>  	return 0;
>> @@ -588,7 +588,7 @@ static int vf_qm_state_save(struct
>> hisi_acc_vf_core_device *hisi_acc_vdev,
>>
>>  	ret = vf_qm_read_data(vf_qm, vf_data);
>>  	if (ret)
>> -		return -EINVAL;
>> +		return ret;
>>
>>  	migf->total_length = sizeof(struct acc_vf_data);
>>  	/* Save eqc and aeqc interrupt information */
>> @@ -1379,7 +1379,7 @@ static int hisi_acc_vf_debug_check(struct seq_file
>> *seq, struct vfio_device *vde
>>  	ret = qm_wait_dev_not_ready(vf_qm);
>>  	if (ret) {
>>  		seq_puts(seq, "VF device not ready!\n");
>> -		return -EBUSY;
>> +		return ret;
>>  	}
>>
>>  	return 0;
> 
> Any reason you avoided few other instances here?
>

In the next version, I will add the modification.

Thank you.
Longfang.

> 1. qemu_set_regs() --> hisi_qm_wait_mb_ready() -->ret -EBUSY;
> 2. vf_qm_cache_wb() ret -EINVAL on -ETIMEOUT.
> 
> With the above addressed,
> 
> Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> 
> Thanks,
> Shameer
> 
> .
> 

