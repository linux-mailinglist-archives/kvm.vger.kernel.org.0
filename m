Return-Path: <kvm+bounces-52436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9161EB0531B
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 09:28:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF9E33A462B
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 07:27:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB60A2749F0;
	Tue, 15 Jul 2025 07:23:17 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E182356BC;
	Tue, 15 Jul 2025 07:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752564197; cv=none; b=Ro6Zzg8CWlwEjRLM5W5Z2WpImTLlj1aw4JjQ5wwyuJb9B9lXIF+9AwsU3SWhgQbT0079w3QWaEnGZE5iZTLiqql6efBD7BIp68ce5s3niRqFw82nAxUiHyRvVUuI0iT+2wZA2SrooYKpu4rRUh1bTLvBYIs+zitNT6LhAW8TX6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752564197; c=relaxed/simple;
	bh=lml+OoGdyoRK+hmvByrWxM0CD5HdufSCxdLKr+WWkXY=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=rzSUdA8GtYT2kgHW3JMsKry/NfscNcsCCvHwXrBlkwVDyTmYgP1PXSi/i+Q/UlW7DJbaH15ybBW0v8zzR6ge1Vwq6hWfyySOZ+BjPfeWwUzMiBNpqSXLPxG2xPkF8gVNMzG+gayG0/MMvEP05HtApxqSMB3l83tYR82re8ELLq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4bh9Xm4DjszHrSx;
	Tue, 15 Jul 2025 15:19:04 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 578281401F3;
	Tue, 15 Jul 2025 15:23:11 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 15 Jul 2025 15:23:10 +0800
Subject: Re: [PATCH v5 2/3] migration: qm updates BAR configuration
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <herbert@gondor.apana.org.au>, Linux Crypto Mailing
 List <linux-crypto@vger.kernel.org>
References: <20250630085402.7491-1-liulongfang@huawei.com>
 <20250630085402.7491-3-liulongfang@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <7694ee87-2852-3759-1360-6349f46e7d70@huawei.com>
Date: Tue, 15 Jul 2025 15:23:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250630085402.7491-3-liulongfang@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2025/6/30 16:54, Longfang Liu wrote:
> On new platforms greater than QM_HW_V3, the configuration region for the
> live migration function of the accelerator device is no longer
> placed in the VF, but is instead placed in the PF.
> 
> Therefore, the configuration region of the live migration function
> needs to be opened when the QM driver is loaded. When the QM driver
> is uninstalled, the driver needs to clear this configuration.
> 
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  drivers/crypto/hisilicon/qm.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>

Hello, Herbert. There is a patch in this patchset that modifies the crypto subsystem.
Could you help review it?

Thanks.
Longfang.

> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
> index d3f5d108b898..0a8888304e15 100644
> --- a/drivers/crypto/hisilicon/qm.c
> +++ b/drivers/crypto/hisilicon/qm.c
> @@ -242,6 +242,9 @@
>  #define QM_QOS_MAX_CIR_U		6
>  #define QM_AUTOSUSPEND_DELAY		3000
>  
> +#define QM_MIG_REGION_SEL		0x100198
> +#define QM_MIG_REGION_EN		0x1
> +
>   /* abnormal status value for stopping queue */
>  #define QM_STOP_QUEUE_FAIL		1
>  #define	QM_DUMP_SQC_FAIL		3
> @@ -3004,11 +3007,36 @@ static void qm_put_pci_res(struct hisi_qm *qm)
>  	pci_release_mem_regions(pdev);
>  }
>  
> +static void hisi_mig_region_clear(struct hisi_qm *qm)
> +{
> +	u32 val;
> +
> +	/* Clear migration region set of PF */
> +	if (qm->fun_type == QM_HW_PF && qm->ver > QM_HW_V3) {
> +		val = readl(qm->io_base + QM_MIG_REGION_SEL);
> +		val &= ~BIT(0);
> +		writel(val, qm->io_base + QM_MIG_REGION_SEL);
> +	}
> +}
> +
> +static void hisi_mig_region_enable(struct hisi_qm *qm)
> +{
> +	u32 val;
> +
> +	/* Select migration region of PF */
> +	if (qm->fun_type == QM_HW_PF && qm->ver > QM_HW_V3) {
> +		val = readl(qm->io_base + QM_MIG_REGION_SEL);
> +		val |= QM_MIG_REGION_EN;
> +		writel(val, qm->io_base + QM_MIG_REGION_SEL);
> +	}
> +}
> +
>  static void hisi_qm_pci_uninit(struct hisi_qm *qm)
>  {
>  	struct pci_dev *pdev = qm->pdev;
>  
>  	pci_free_irq_vectors(pdev);
> +	hisi_mig_region_clear(qm);
>  	qm_put_pci_res(qm);
>  	pci_disable_device(pdev);
>  }
> @@ -5630,6 +5658,7 @@ int hisi_qm_init(struct hisi_qm *qm)
>  		goto err_free_qm_memory;
>  
>  	qm_cmd_init(qm);
> +	hisi_mig_region_enable(qm);
>  
>  	return 0;
>  
> 

