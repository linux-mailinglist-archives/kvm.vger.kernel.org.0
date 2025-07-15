Return-Path: <kvm+bounces-52434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7323CB052A7
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 09:20:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D08CD1885B7E
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 07:20:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49B702D4B6C;
	Tue, 15 Jul 2025 07:16:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236A32D46D1;
	Tue, 15 Jul 2025 07:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752563815; cv=none; b=EeY6cJSYarhbdt3B3RstEbx+RAsstcKHJCjN66yIeMeg7CJY7ZftMmU3BATcu4oggOr4vSCTDNI4c/SYnEFjgf0neAgPAxnXYxVkDB+gFyZDLBkEmvNgBVHu7PNz/7L5xushRIKD3mvJ0wZjcNgTbPlfk55BbNGAyOl5uOnS66c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752563815; c=relaxed/simple;
	bh=wbmUo5AwtHs+1+ZHmA06YETYNo0IRxYtOBKSKAYaJZM=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=V0oEuyidGoxczDT3vOCaFFte2vVF2P91muJd/O++jKkqLAToKeQ+ykHiJyShEw7UVkDozNqom4n82/wB0/VT9wWPV8z/cyCNQ1Q7vJ1gVi7IQ6feNVTbZSKxnbw92icp6P3LtQUTophsCf+n68Xqq2dCTa1rmAuV7bmnXYYXFgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4bh9NZ1bS7z14Lyk;
	Tue, 15 Jul 2025 15:11:58 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 81D5F1800B1;
	Tue, 15 Jul 2025 15:16:44 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 15 Jul 2025 15:16:43 +0800
Subject: Re: [PATCH v5 2/3] migration: qm updates BAR configuration
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, Jonathan Cameron <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
References: <20250630085402.7491-1-liulongfang@huawei.com>
 <20250630085402.7491-3-liulongfang@huawei.com>
 <a4ff64ceeab1405ab6ebb8ed89c35407@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <83d47119-61ef-5a4e-fc93-fd50540756ec@huawei.com>
Date: Tue, 15 Jul 2025 15:16:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <a4ff64ceeab1405ab6ebb8ed89c35407@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2025/7/8 16:18, Shameerali Kolothum Thodi wrote:
> 
> 
>> -----Original Message-----
>> From: liulongfang <liulongfang@huawei.com>
>> Sent: Monday, June 30, 2025 9:54 AM
>> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
>> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
>> <jonathan.cameron@huawei.com>
>> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
>> Subject: [PATCH v5 2/3] migration: qm updates BAR configuration
>>
>> On new platforms greater than QM_HW_V3, the configuration region for
>> the
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
> May adding a  comment for above functions  will be helpful.
> 
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
> 
> Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> 
> You need to CC QM driver maintainers for this.
>

OK, thanks.
Longfang.

> Thanks,
> SHameer
> .
> 

