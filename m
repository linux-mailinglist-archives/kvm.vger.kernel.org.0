Return-Path: <kvm+bounces-31913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A75B9CDAA9
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 09:36:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FB59283770
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 08:36:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1FDA4317C;
	Fri, 15 Nov 2024 08:36:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF932B9B9;
	Fri, 15 Nov 2024 08:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731659807; cv=none; b=quNx8bprjY8KIa8RCitFHjT94eczzdyB1gxL/9wBBaommV5hpt+fkTu4ROCPyr/jSE5BTNfY3yQSQYb87KyQsD1/anOhSlC48jrzgxLr4bp+6n9o/QApZDdlOLvaF0yTX9spUEOrCfS+MMjJOAesFnpAOcNxeWBFiZ8wzHFtVP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731659807; c=relaxed/simple;
	bh=yBNLC7xEa8zcuEG6FfRNCgv+1Enxue8YLc6rBtj3mrI=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=BhoQwHejamHhrPlodEO7/k1eosSuopEN0sKua4fYRvNcuV2FMcERknJOmJ1q0jJ2rY0xQN+D05TVI41/kjfD2PxgLJDxo3sa5iPyJkUc6Mpf9QhUQL1N8PviGG3JOiXDShZnguiKDh9AzY/QGHyAbgHf2CUEFKaQeljAj6D2dNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4XqVgk411dz1T4sW;
	Fri, 15 Nov 2024 16:34:42 +0800 (CST)
Received: from dggemv704-chm.china.huawei.com (unknown [10.3.19.47])
	by mail.maildlp.com (Postfix) with ESMTPS id 9A8471A0188;
	Fri, 15 Nov 2024 16:36:35 +0800 (CST)
Received: from kwepemn100017.china.huawei.com (7.202.194.122) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 15 Nov 2024 16:36:35 +0800
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemn100017.china.huawei.com (7.202.194.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 15 Nov 2024 16:36:34 +0800
Subject: Re: [PATCH v15 0/4] debugfs to hisilicon migration driver
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
References: <20241112073322.54550-1-liulongfang@huawei.com>
 <20241114121225.3ab59ce6.alex.williamson@redhat.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <8a193de7-fffe-a2c8-2964-aa4fe3771f1c@huawei.com>
Date: Fri, 15 Nov 2024 16:36:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241114121225.3ab59ce6.alex.williamson@redhat.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemn100017.china.huawei.com (7.202.194.122)

On 2024/11/15 3:12, Alex Williamson wrote:
> On Tue, 12 Nov 2024 15:33:18 +0800
> Longfang Liu <liulongfang@huawei.com> wrote:
> 
>> Add a debugfs function to the hisilicon migration driver in VFIO to
>> provide intermediate state values and data during device migration.
>>
>> When the execution of live migration fails, the user can view the
>> status and data during the migration process separately from the
>> source and the destination, which is convenient for users to analyze
>> and locate problems.
>>
>> Changes v14 -> v15
>> 	Correct variable declaration type
> 
> Applied to vfio next branch for v6.13.  Thanks,
> 
> Alex
>

Thanks.
Longfang

> 
> .
> 

