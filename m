Return-Path: <kvm+bounces-47517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C0390AC19AF
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:29:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D8631C041A7
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:30:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1C572DCBF8;
	Fri, 23 May 2025 01:29:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3E02DCBE0;
	Fri, 23 May 2025 01:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747963790; cv=none; b=mpdYBEMvDq5wua2OvOFykBndi9Sr7CkU0Xjvk5NHVID7nMkFCNjaDuCqW3pBOr4v839cZhqANY5BpGfcBa9de0aUYKgbnbWfnsbguxx94PNqCRq43XbZ5FLXfrtR3dssUiM9+KDNVEqcNBMxd+an1jM7bF9siWsacR1p/reCpWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747963790; c=relaxed/simple;
	bh=O+hUIWP8sqbo2B16dVbYBn0GNPjiXFkJsYcdWxxh0LM=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=iMimTJ8WyXxQI/tUROIu8KGhqbLMuROnO9MTQifWVzM+HlrPIQu81W+JB00cR3fZ3iyupp8ppyPbz+nuPOvS2uT4gGwMEERq1UtE3QI4J+4mOWpS+4BvpsSDWvu72Lqak2FQQeh64F8SPL4HZuhlWKcHu3d6LepU3bSLCONVcvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4b3SGZ72CDznfdq;
	Fri, 23 May 2025 09:28:22 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id 471EE1400E3;
	Fri, 23 May 2025 09:29:38 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemg500006.china.huawei.com (7.202.181.43) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 23 May 2025 09:29:37 +0800
Subject: Re: [PATCH v8 0/6] bugfix some driver issues
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
References: <20250510081155.55840-1-liulongfang@huawei.com>
 <20250520093948.7885dbe0.alex.williamson@redhat.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <5b68caec-dfae-8711-6e93-8728a9ad095b@huawei.com>
Date: Fri, 23 May 2025 09:29:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250520093948.7885dbe0.alex.williamson@redhat.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemg500006.china.huawei.com (7.202.181.43)

On 2025/5/20 23:39, Alex Williamson write:
> On Sat, 10 May 2025 16:11:49 +0800
> Longfang Liu <liulongfang@huawei.com> wrote:
> 
>> As the test scenarios for the live migration function become
>> more and more extensive. Some previously undiscovered driver
>> issues were found.
>> Update and fix through this patchset.
>>
>> Change v7 -> v8
>> 	Handle the return value of sub-functions.
>>
>> Change v6 -> v7
>> 	Update function return values.
>>
>> Change v5 -> v6
>> 	Remove redundant vf_qm_state status checks.
>>
>> Change v4 -> v5
>> 	Update version matching strategy
>>
>> Change v3 -> v4
>> 	Modify version matching scheme
>>
>> Change v2 -> v3
>> 	Modify the magic digital field segment
>>
>> Change v1 -> v2
>> 	Add fixes line for patch comment
>>
>> Longfang Liu (6):
>>   hisi_acc_vfio_pci: fix XQE dma address error
>>   hisi_acc_vfio_pci: add eq and aeq interruption restore
>>   hisi_acc_vfio_pci: bugfix cache write-back issue
>>   hisi_acc_vfio_pci: bugfix the problem of uninstalling driver
>>   hisi_acc_vfio_pci: bugfix live migration function without VF device
>>     driver
>>   hisi_acc_vfio_pci: update function return values.
>>
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 121 +++++++++++++-----
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  14 +-
>>  2 files changed, 101 insertions(+), 34 deletions(-)
>>
> 
> Applied to vfio next branch for v6.16.  Thanks,
> 
> Alex
>

Thank you very much!
Longfang.

> 
> .
> 

