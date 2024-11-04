Return-Path: <kvm+bounces-30471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DD879BAFF0
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 10:39:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FC741C21E70
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 09:39:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A79CA1AE877;
	Mon,  4 Nov 2024 09:39:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E128C1ADFE2;
	Mon,  4 Nov 2024 09:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730713185; cv=none; b=Xev+EUh0MN8oROUbYdDIS4TSF9m3sMsTC+h0CUIi5H3VwKrbUad6cSJqZIWaYSX6yAR3m0Pvt+d0IJtHk+g2mWV7LWKQSMAPpB5lSmJqx71tiE9utjcE8AZyAxUSOPLuZIoxtl7nk34EcSjju+FBLLH78sV+G3blG/DSopWRtvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730713185; c=relaxed/simple;
	bh=W32oNkulwtwhEDioXljJnDxL8PjHM91WVcY5wZM+wMw=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=t5XP/cBFFxtFmQpuG3wU8HE1OafqhTvjPASXDHR6nNJltLmQJw+oxR79vr96f1kA7o45GRzsEXpMeM+R2YawLG2eyS10bC1pFZ+eSPJHBU6rmnwbfccswXr6tkF9jd3olbVDV65aD7rj9ne5tN7aXWtSHOAO2syg4XVVk8+WX6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Xhmdw5jmpz1ypC0;
	Mon,  4 Nov 2024 17:39:48 +0800 (CST)
Received: from dggemv703-chm.china.huawei.com (unknown [10.3.19.46])
	by mail.maildlp.com (Postfix) with ESMTPS id 1FEFC1A016C;
	Mon,  4 Nov 2024 17:39:39 +0800 (CST)
Received: from kwepemn100017.china.huawei.com (7.202.194.122) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 4 Nov 2024 17:39:38 +0800
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemn100017.china.huawei.com (7.202.194.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 4 Nov 2024 17:39:38 +0800
Subject: Re: [PATCH v11 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon
 migration driver
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, "Alex
 Williamson" <alex.williamson@redhat.com>
CC: "jgg@nvidia.com" <jgg@nvidia.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
References: <20241025090143.64472-1-liulongfang@huawei.com>
 <20241025090143.64472-4-liulongfang@huawei.com>
 <20241031160430.59f4b944.alex.williamson@redhat.com>
 <df5129f8-e9c2-b1c0-e2de-9211738d88c4@huawei.com>
 <019a0cab-76b7-a3c0-d93f-5384efea1f67@huawei.com>
 <133e223b22df4ab4b4802163d0c42407@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <d0e80aa2-b44a-1862-bdcb-aa8268cc0fc5@huawei.com>
Date: Mon, 4 Nov 2024 17:39:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <133e223b22df4ab4b4802163d0c42407@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemn100017.china.huawei.com (7.202.194.122)

On 2024/11/4 16:56, Shameerali Kolothum Thodi wrote:
> 
> 
>> -----Original Message-----
>> From: liulongfang <liulongfang@huawei.com>
>> Sent: Monday, November 4, 2024 8:31 AM
>> To: Alex Williamson <alex.williamson@redhat.com>
>> Cc: jgg@nvidia.com; Shameerali Kolothum Thodi
>> <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
>> <jonathan.cameron@huawei.com>; kvm@vger.kernel.org; linux-
>> kernel@vger.kernel.org; linuxarm@openeuler.org
>> Subject: Re: [PATCH v11 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon
>> migration driver
> [...]
> 
>>>>> +
>>>>> +	seq_printf(seq,
>>>>> +		 "acc device:\n"
>>>>> +		 "guest driver load: %u\n"
>>>>> +		 "device opened: %d\n"
>>>>> +		 "migrate data length: %lu\n",
>>>>> +		 hisi_acc_vdev->vf_qm_state,
>>>>> +		 hisi_acc_vdev->dev_opened,
>>>>> +		 debug_migf->total_length);
>>>>
>>>> This debugfs entry is described as returning the data from the last
>>>> migration, but vf_qm_state and dev_opened are relative to the current
>>>> device/guest driver state.  Both seem to have no relevance to the data
>>>> in debug_migf.
>>>>
>>>
>>> The benefit of dev_opened retention is that user can obtain the device
>> status
>>> during the cat migf_data operation.
>>>
>>
>> I will remove dev_opened in the next version.
>> And hisi_acc_vdev->vf_qm_state is changed to debug_migf-
>>> vf_data.vf_qm_state
>> Keep information about whether the device driver in the Guest OS is loaded
>> when live migration occurs.
> 
> I think you already get that when you dump debug_migf->vf_data.
> So not required.
>
OK, vf_qm_state still needs to be deleted.

Thanks,
Longfang.

> Thanks,
> Shameer
> 
> .
> 

