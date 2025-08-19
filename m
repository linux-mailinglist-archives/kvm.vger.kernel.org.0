Return-Path: <kvm+bounces-54967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BF540B2BCC8
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 11:15:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A85461893AEF
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 09:13:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B26031A043;
	Tue, 19 Aug 2025 09:13:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7101F37D3;
	Tue, 19 Aug 2025 09:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755594781; cv=none; b=ZBV2wMncqr1KYlDewfEGcxsfDoHxxpcwNFGcwOIV4blAcuyui+tAeIwT5r0bc/2Cx36RJ66Oa7dLo1zNNCWLtXm3EU1XlAkLAYCss4aTMQOVKKBvxy52UOsdH9tUkaxxCBDAFaGvZBvwAUdxXJAdU7ur69eHpBCbXbGNL3BSyJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755594781; c=relaxed/simple;
	bh=hXe6cu82I37r/ZgzXhcA4iE+0B4LveUt+ziarZH2QgU=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ssSujr7W9Y/UJ8CNpFRGhmGJjK7yeqyqKZnoi9xG6FqO59vri9hr+GkBA3ZoU26reNjZ1Vi5fxyKIcE+2zmeelo1/SMh44odMLUG+HKgXEk2oKkVsheCwpyU+uJ6fGyKdvuDrrPtxdOHnUiIKiSvOowW2BFvSGfcbNDpw2p7JCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c5kPt6G8Fz14MbM;
	Tue, 19 Aug 2025 17:12:50 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 3A46C1402EB;
	Tue, 19 Aug 2025 17:12:54 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 19 Aug 2025 17:12:53 +0800
Subject: Re: [PATCH v7 2/3] migration: qm updates BAR configuration
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<herbert@gondor.apana.org.au>, <shameerali.kolothum.thodi@huawei.com>,
	<jonathan.cameron@huawei.com>
CC: <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
References: <20250805065106.898298-1-liulongfang@huawei.com>
 <20250805065106.898298-3-liulongfang@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <d369be68-918a-dcad-e5dd-fd70ec42516c@huawei.com>
Date: Tue, 19 Aug 2025 17:12:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250805065106.898298-3-liulongfang@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2025/8/5 14:51, Longfang Liu wrote:
> On new platforms greater than QM_HW_V3, the configuration region for the
> live migration function of the accelerator device is no longer
> placed in the VF, but is instead placed in the PF.
> 
> Therefore, the configuration region of the live migration function
> needs to be opened when the QM driver is loaded. When the QM driver
> is uninstalled, the driver needs to clear this configuration.
> 
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> 
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  drivers/crypto/hisilicon/qm.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
> index 7c41f9593d03..b5ce9b1e9c56 100644
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

Hello, Herbert. There is a patch in this patchset that modifies the crypto subsystem.
Could this patch be merged into the crypto next branch?

Thanks.
Longfang.

