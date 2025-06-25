Return-Path: <kvm+bounces-50623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF53EAE788D
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 09:31:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 232E1179A2C
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 07:31:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAC9B208961;
	Wed, 25 Jun 2025 07:31:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E18316E863;
	Wed, 25 Jun 2025 07:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750836680; cv=none; b=eYxQyeuyM5lMxdqjbsIu/vtbpqNG5SCKbdSaCIV7TGL5xjQstPE5BDdiwEawlvNi+85z4cRwKr2kEUkvg6e4a7IP1wuEjhp106UiKmZhUQrlBU3XkxFdQtBx4LTg4K21XKJW5bXF01GJJ/AlatFztf/N+9tz7cHksRZX78FCsto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750836680; c=relaxed/simple;
	bh=wZKM+fYh50WO5mrYfbUL+DCmiFuOWt42YqhN3P0fFkM=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=k8ZBELejSq/37F810gEIBb/ke14VPSur9Q/J7LcOLrjN7Cdmi15oboXbH1z3kxI9vGP4hbsygrIdA/9eHnsewNxX5zmXU4YWglUBzOqa25WmHoqtyVcpg2ynvY53qFbwnHgpFAW3BL1q1ra8V3kO/vLFcuEyg1y8om4tX5ytRS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4bRtk85HJbz1QBnj;
	Wed, 25 Jun 2025 15:29:36 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 97CD9180042;
	Wed, 25 Jun 2025 15:31:14 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 25 Jun 2025 15:31:13 +0800
Subject: Re: [PATCH v4 2/3] migration: qm updates BAR configuration
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, Jonathan Cameron <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
References: <20250610063251.27526-1-liulongfang@huawei.com>
 <20250610063251.27526-3-liulongfang@huawei.com>
 <191c54da8764416c904c6ca8f120b155@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <0c5a1f58-644d-4612-24c7-c218fce1138b@huawei.com>
Date: Wed, 25 Jun 2025 15:31:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <191c54da8764416c904c6ca8f120b155@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2025/6/24 15:06, Shameerali Kolothum Thodi wrote:
> 
> 
>> -----Original Message-----
>> From: liulongfang <liulongfang@huawei.com>
>> Sent: Tuesday, June 10, 2025 7:33 AM
>> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
>> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
>> <jonathan.cameron@huawei.com>
>> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
>> Subject: [PATCH v4 2/3] migration: qm updates BAR configuration
>>
>> On the new hardware platform, the configuration region for the
>> live migration function of the accelerator device is no longer
>> placed in the VF, but is instead placed in the PF.
>>
>> Therefore, the configuration region of the live migration function
>> needs to be opened when the QM driver is loaded. When the QM driver
>> is uninstalled, the driver needs to clear this configuration.
>>
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> ---
>>  drivers/crypto/hisilicon/qm.c | 29 +++++++++++++++++++++++++++++
>>  1 file changed, 29 insertions(+)
>>
>> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
>> index d3f5d108b898..0a8888304e15 100644
>> --- a/drivers/crypto/hisilicon/qm.c
>> +++ b/drivers/crypto/hisilicon/qm.c
>> @@ -242,6 +242,9 @@
>>  #define QM_QOS_MAX_CIR_U		6
>>  #define QM_AUTOSUSPEND_DELAY		3000
>>
>> +#define QM_MIG_REGION_SEL		0x100198
>> +#define QM_MIG_REGION_EN		0x1
>> +
>>   /* abnormal status value for stopping queue */
>>  #define QM_STOP_QUEUE_FAIL		1
>>  #define	QM_DUMP_SQC_FAIL		3
>> @@ -3004,11 +3007,36 @@ static void qm_put_pci_res(struct hisi_qm *qm)
>>  	pci_release_mem_regions(pdev);
>>  }
>>
>> +static void hisi_mig_region_clear(struct hisi_qm *qm)
>> +{
>> +	u32 val;
>> +
>> +	/* Clear migration region set of PF */
>> +	if (qm->fun_type == QM_HW_PF && qm->ver > QM_HW_V3) {
> 
> Is this going to be same for all future hardware's like OM_HW_V5, OM_HW_V6 etc?
> Otherwise it is better you make it specific to OM_HW_V4. I think
> the above checking  is repeated throughout this series and there is no guarantee
> that future hardware will have the same changes only. So better make it specific.
>

We confirmed with hardware team that the subsequent implementations will continue
to use this approach.

Thanks.
Longfang.

> Thanks,
> Shameer
> 
> 
>> +		val = readl(qm->io_base + QM_MIG_REGION_SEL);
>> +		val &= ~BIT(0);
>> +		writel(val, qm->io_base + QM_MIG_REGION_SEL);
>> +	}
>> +}
>> +
>> +static void hisi_mig_region_enable(struct hisi_qm *qm)
>> +{
>> +	u32 val;
>> +
>> +	/* Select migration region of PF */
>> +	if (qm->fun_type == QM_HW_PF && qm->ver > QM_HW_V3) {
>> +		val = readl(qm->io_base + QM_MIG_REGION_SEL);
>> +		val |= QM_MIG_REGION_EN;
>> +		writel(val, qm->io_base + QM_MIG_REGION_SEL);
>> +	}
>> +}
>> +
>>  static void hisi_qm_pci_uninit(struct hisi_qm *qm)
>>  {
>>  	struct pci_dev *pdev = qm->pdev;
>>
>>  	pci_free_irq_vectors(pdev);
>> +	hisi_mig_region_clear(qm);
>>  	qm_put_pci_res(qm);
>>  	pci_disable_device(pdev);
>>  }
>> @@ -5630,6 +5658,7 @@ int hisi_qm_init(struct hisi_qm *qm)
>>  		goto err_free_qm_memory;
>>
>>  	qm_cmd_init(qm);
>> +	hisi_mig_region_enable(qm);
>>
>>  	return 0;
>>
>> --
>> 2.24.0
> 
> .
> 

