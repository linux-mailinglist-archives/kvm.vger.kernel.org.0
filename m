Return-Path: <kvm+bounces-61449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E68CC1E06B
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 02:31:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0B55D349E96
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 01:31:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C53501A5B92;
	Thu, 30 Oct 2025 01:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="P3Ia09CS"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D896837A3D8;
	Thu, 30 Oct 2025 01:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761787860; cv=none; b=uhCmklzlCVyLfqcCKnEyVhQvhkN/j7Qr8vFTUh7iD2BSbHmGbDw/2ykmn1TxT8iVNDDmzw41LPbhJj92rQ69s/4xhpPQSc0eYkjqX9xyQSjjHbSzq+OEAN5hO8cTHZrCBKoNJI69Pjf7z00YVl3xb3p8xci63QIq31MUEMjvNXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761787860; c=relaxed/simple;
	bh=A8gDmF+Om9HTvdq0Ixpq78Bk9hC7lsgL4siwEchBVCU=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=SffDRtw9pKMztdY0n8m6ctkE/QdpedtkHFy7CYf8ggJ4Bl80lJRmVKXlvaROZPQxJbvK34PN84KEE49cttoYIXV4L+5kjBFnd6irQnTQwDmuCax4c47eYfI/1gu9v+lmKiyePcMxa20yj2+L34ALJ9pZuiITLwgs57Oq1CRgi3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=P3Ia09CS; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=JnruyETCqV2Cq8faQLSx9eTVX7WhLs33xmIAAQ2Psd0=;
	b=P3Ia09CSTkIOIrU0SmML1rpG7AcXDiec0+hynOO3n2VvETPqpp107LriH9a7LvH961GUE9Ln3
	vJiraoaBURErP5AhMR3aC+L2v0p/3R1LHisEfPuH/+MeTUoRY47F6ZBoRBk1mVOWob7hfirAep/
	DF1AWDS2NmDJ+AaBrwgUM24=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4cxml437KXz1prQN;
	Thu, 30 Oct 2025 09:30:24 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 28DBA140279;
	Thu, 30 Oct 2025 09:30:54 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 30 Oct 2025 09:30:53 +0800
Subject: Re: [PATCH v11 1/2] crypto: hisilicon - qm updates BAR configuration
To: Alex Williamson <alex@shazbot.org>
CC: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<herbert@gondor.apana.org.au>, <shameerkolothum@gmail.com>,
	<jonathan.cameron@huawei.com>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>
References: <20251029122441.3063127-1-liulongfang@huawei.com>
 <20251029122441.3063127-2-liulongfang@huawei.com>
 <20251029072617.38e23c7c@shazbot.org>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <6c177f1c-91fc-13e5-20b1-0c4cdedac824@huawei.com>
Date: Thu, 30 Oct 2025 09:30:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251029072617.38e23c7c@shazbot.org>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2025/10/29 21:26, Alex Williamson wrote:
> On Wed, 29 Oct 2025 20:24:40 +0800
> Longfang Liu <liulongfang@huawei.com> wrote:
> 
>> On new platforms greater than QM_HW_V3, the configuration region for the
>> live migration function of the accelerator device is no longer
>> placed in the VF, but is instead placed in the PF.
>>
>> Therefore, the configuration region of the live migration function
>> needs to be opened when the QM driver is loaded. When the QM driver
>> is uninstalled, the driver needs to clear this configuration.
>>
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> Reviewed-by: Shameer Kolothum <shameerkolothum@gmail.com>
>> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
>> ---
>>  drivers/crypto/hisilicon/qm.c | 27 +++++++++++++++++++++++++++
>>  include/linux/hisi_acc_qm.h   |  3 +++
>>  2 files changed, 30 insertions(+)
>>
>> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
>> index a5b96adf2d1e..f0fd0c3698eb 100644
>> --- a/drivers/crypto/hisilicon/qm.c
>> +++ b/drivers/crypto/hisilicon/qm.c
>> @@ -3019,11 +3019,36 @@ static void qm_put_pci_res(struct hisi_qm *qm)
>>  	pci_release_mem_regions(pdev);
>>  }
>>  
>> +static void hisi_mig_region_clear(struct hisi_qm *qm)
>> +{
>> +	u32 val;
>> +
>> +	/* Clear migration region set of PF */
>> +	if (qm->fun_type == QM_HW_PF && qm->ver > QM_HW_V3) {
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
> 
> Same as commented last time:
> 
> https://lore.kernel.org/all/20251027222011.05bac6bd@shazbot.org/
>

OK, I'll fix this and update the version.

Thanks.
Longfang.

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
>> @@ -5725,6 +5750,7 @@ int hisi_qm_init(struct hisi_qm *qm)
>>  		goto err_free_qm_memory;
>>  
>>  	qm_cmd_init(qm);
>> +	hisi_mig_region_enable(qm);
>>  
>>  	return 0;
>>  
>> @@ -5863,6 +5889,7 @@ static int qm_rebuild_for_resume(struct hisi_qm *qm)
>>  	}
>>  
>>  	qm_cmd_init(qm);
>> +	hisi_mig_region_enable(qm);
>>  	hisi_qm_dev_err_init(qm);
>>  	/* Set the doorbell timeout to QM_DB_TIMEOUT_CFG ns. */
>>  	writel(QM_DB_TIMEOUT_SET, qm->io_base + QM_DB_TIMEOUT_CFG);
>> diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
>> index c4690e365ade..aa0129d20c51 100644
>> --- a/include/linux/hisi_acc_qm.h
>> +++ b/include/linux/hisi_acc_qm.h
>> @@ -99,6 +99,9 @@
>>  
>>  #define QM_DEV_ALG_MAX_LEN		256
>>  
>> +#define QM_MIG_REGION_SEL		0x100198
>> +#define QM_MIG_REGION_EN		0x1
>> +
>>  /* uacce mode of the driver */
>>  #define UACCE_MODE_NOUACCE		0 /* don't use uacce */
>>  #define UACCE_MODE_SVA			1 /* use uacce sva mode */
> 
> .
> 

