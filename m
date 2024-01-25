Return-Path: <kvm+bounces-6981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E7A2D83BB60
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 09:12:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B1861F215CC
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 08:12:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 782761759E;
	Thu, 25 Jan 2024 08:12:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE1C17551;
	Thu, 25 Jan 2024 08:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706170334; cv=none; b=Zl3/tusXh2fLCXG+nyFiwzC2/j1i4U7EVxDrPgaFuiQwU/WUC3qmz/oar5LV3vX0CSUXSABRpWBubRIiHShVL7Wc4jOgVC17PcEd/aTN1GejLPmcvvL8oIdrFByGfLFOKBNYHBxtjcMUMGzcuP7vOGXPC9C0LWgUMdbXByM0V6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706170334; c=relaxed/simple;
	bh=I2fHAq42LqYmEoDLvPKCloJ+PeKaM0SJ2tT5lbcL5YM=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Xmiy3Y86tx/o8LMa3WHf8u8poptSuTAR0QJxvaSzCnz4JPXVocn5KD8cJ/N7Y74BCoBiAtRDcr6oE7hgPcOqwwkFbE24QlX0FuSBXCFDyL729azdULS4ymmS3C7DAt/2SBOqAnwdagy+UvmUUcuxetQQ1MkdJDSalZuOm4toAmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4TLD6p2YgGzNlXl;
	Thu, 25 Jan 2024 16:11:14 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id 29CAC18007D;
	Thu, 25 Jan 2024 16:12:08 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Jan 2024 16:12:07 +0800
Subject: Re: [PATCH 0/3] add debugfs to hisilicon migration driver
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>
References: <20240125075525.42168-1-liulongfang@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <ca04c04f-7e5e-1365-5eeb-74f22dfe8793@huawei.com>
Date: Thu, 25 Jan 2024 16:12:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240125075525.42168-1-liulongfang@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600005.china.huawei.com (7.193.23.191)

On 2024/1/25 15:55, Longfang Liu wrote:
> Add a debugfs function to the hisilicon migration driver in VFIO to
> provide intermediate state values and data during device migration.
> 
> When the execution of live migration fails, the user can view the
> status and data during the migration process separately from the
> source and the destination, which is convenient for users to analyze
> and locate problems.
> 
> Longfang Liu (3):
>   hisi_acc_vfio_pci: extract public functions for container_of


This patch was previously reviewed and added Reviewed-by: Jason Gunthorpe.

As the first version of this set of patches, I removed it and sent it again.

Thanks.

Longfang.

>   hisi_acc_vfio_pci: register debugfs for hisilicon migration driver
>   Documentation: add debugfs description for hisi migration
> 
>  .../ABI/testing/debugfs-hisi-migration        |  34 +++
>  MAINTAINERS                                   |   1 +
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 211 +++++++++++++++++-
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |   5 +
>  4 files changed, 241 insertions(+), 10 deletions(-)
>  create mode 100644 Documentation/ABI/testing/debugfs-hisi-migration
> 

