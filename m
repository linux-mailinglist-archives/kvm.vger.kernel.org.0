Return-Path: <kvm+bounces-54968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB947B2BCCE
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 11:16:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25C493AB3E2
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 09:15:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0ADB31AF17;
	Tue, 19 Aug 2025 09:14:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666A831A058;
	Tue, 19 Aug 2025 09:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755594889; cv=none; b=NheQDMWnSSE7+6dv3cr39Dz6zGIw5F+9R8IuJc9kr9wPn3TX58rzXeaVoLUIEKbXF3B47mRxFMAF5U56OUbi+I73vs74zmSJEnEL3kyz2hEdUUBKmy8kDSTO8yqoxZhNacbrEZMubxXKVgFWa7mrD4DuMHou7/8xUuIoWldu9GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755594889; c=relaxed/simple;
	bh=ClbpmKELQs/W84VYcLqgFx3EiddF/uKfEZixGB+b4CM=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=m6+64ZK+GOo6dRHY904MaGIgChgbJoCjpmHkFGbYD8u1AmylN/tijGSNSUAnPh5H3RevhGtLiJNO/6FdZ6XkizmG5fxGKP4f14kXR/DHqoLbMa8+66iXT8xwqOF2AZ11ubSr131FEsD+rIbTLxy1PvISeQImXzyvRsw5OmQvVzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c5kMy5jBCz13NMN;
	Tue, 19 Aug 2025 17:11:10 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id BDB5D140278;
	Tue, 19 Aug 2025 17:14:42 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 19 Aug 2025 17:14:42 +0800
Subject: Re: [PATCH v7 0/3] update live migration configuration region
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<herbert@gondor.apana.org.au>, <shameerali.kolothum.thodi@huawei.com>,
	<jonathan.cameron@huawei.com>
CC: <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
References: <20250805065106.898298-1-liulongfang@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <b9c290a4-c1ba-6e5f-631c-c80dbda76d56@huawei.com>
Date: Tue, 19 Aug 2025 17:14:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250805065106.898298-1-liulongfang@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2025/8/5 14:51, Longfang Liu wrote:
> On the new hardware platform, the configuration register space
> of the live migration function is set on the PF, while on the
> old platform, this part is placed on the VF.
> 
> Change v6 -> v7
> 	Update the comment of the live migration configuration scheme.
> 
> Change v5 -> v6
> 	Update VF device properties
> 
> Change v4 -> v5
> 	Remove BAR length alignment
> 
> Change v3 -> v4
> 	Rebase on kernel 6.15
> 
> Change v2 -> v3
> 	Put the changes of Pre_Copy into another bugfix patchset.
> 
> Change v1 -> v2
> 	Delete the vf_qm_state read operation in Pre_Copy
> 
> Longfang Liu (3):
>   migration: update BAR space size
>   migration: qm updates BAR configuration
>   migration: adapt to new migration configuration
> 
>  drivers/crypto/hisilicon/qm.c                 |  29 +++
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 200 ++++++++++++------
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |   7 +
>  3 files changed, 174 insertions(+), 62 deletions(-)
> 

Hello, Alex.
Could this patchset be merged into the next branch?

Thanks.
Longfang.

