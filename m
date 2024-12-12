Return-Path: <kvm+bounces-33539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 12FD89EDD2E
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 02:46:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 70367188A067
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 01:46:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A5DB7DA9E;
	Thu, 12 Dec 2024 01:46:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026EF3C38;
	Thu, 12 Dec 2024 01:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733967984; cv=none; b=EwBBObIjWhPl8rEzDPPUqMDShwuGp1yTcxxPr/7b2FC9X8j565Nx4H28a7U7ZfV64InU+POyyP9o1CbOyz98HG5gv4wrL32bWu8kb1i+n2Qrd4dfyhGuhNmLe5vGMGZ/wGaBXjSL2KE8YsEFG+RDPfTaxk3jKx4Je//ib4wMc30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733967984; c=relaxed/simple;
	bh=wdwWUlRD6JAjorcxXWF9EI+cJkEk2aRX2tTel5dpuX0=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=OPaFGTbseSmmVPWFBX+C4YoLiTXIzkBzdTJKV+yIK9oGSPyZUKT3uLtdPDkFJZlntz0Kow3Fj7XqeSZfQwWpM56FTJlmdUhVPf0ZykI+mSnX7CSTurmXCOgw2FxYak3a05DTg8QtPTL1mL5/kS2bHllxzUYxQJkmfLmFxCiO9zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Y7wH44R3pz1T6wf;
	Thu, 12 Dec 2024 09:43:44 +0800 (CST)
Received: from dggemv703-chm.china.huawei.com (unknown [10.3.19.46])
	by mail.maildlp.com (Postfix) with ESMTPS id C937C1A016C;
	Thu, 12 Dec 2024 09:46:11 +0800 (CST)
Received: from kwepemn100017.china.huawei.com (7.202.194.122) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 12 Dec 2024 09:46:11 +0800
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemn100017.china.huawei.com (7.202.194.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 12 Dec 2024 09:46:10 +0800
Subject: Re: [PATCH 4/5] hisi_acc_vfio_pci: bugfix the problem of uninstalling
 driver
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: <alex.williamson@redhat.com>, <shameerali.kolothum.thodi@huawei.com>,
	<jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
References: <20241206093312.57588-1-liulongfang@huawei.com>
 <20241206093312.57588-5-liulongfang@huawei.com>
 <20241209134953.GA1888283@ziepe.ca>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <ba7e1150-1e57-9762-1b87-3a85c3928064@huawei.com>
Date: Thu, 12 Dec 2024 09:46:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241209134953.GA1888283@ziepe.ca>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemn100017.china.huawei.com (7.202.194.122)

On 2024/12/9 21:49, Jason Gunthorpe wrote:
> On Fri, Dec 06, 2024 at 05:33:11PM +0800, Longfang Liu wrote:
>> In a live migration scenario. If the number of VFs at the
>> destination is greater than the source, the recovery operation
>> will fail and qemu will not be able to complete the process and
>> exit after shutting down the device FD.
>>
>> This will cause the driver to be unable to be unloaded normally due
>> to abnormal reference counting of the live migration driver caused
>> by the abnormal closing operation of fd.
>>
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> ---
>>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 1 +
>>  1 file changed, 1 insertion(+)
> 
> This one needs a fixes line and probably cc stable
>

OK.

Thanks.
Longfang

> Jason
> 
> .
> 

