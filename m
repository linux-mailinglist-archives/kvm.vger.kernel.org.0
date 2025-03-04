Return-Path: <kvm+bounces-40024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E80D2A4DE0B
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 13:35:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 922293B3A89
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 12:34:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1652220371B;
	Tue,  4 Mar 2025 12:34:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2139B201110;
	Tue,  4 Mar 2025 12:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741091642; cv=none; b=M7wIUfYe1kbe1cesvxX1zrOHV5SJYZr8ABD/JgtiEe5lAye1r/5oYDZk/+tMARfwFQHlDk3ahytW0FLeLtvBd1FXR8OTAFk+2ITplHP1en+YqxeOkflqTyLW64Jq8NhR4JnPD61LDz9677ob57+rgfVsQDBH2/Wy3Q45xwhLb/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741091642; c=relaxed/simple;
	bh=wZMrCzrBLmXDpRPE3xXhK917Wn3p73CuR6VacidG2gM=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=iX3v5S4r9MHqszgu/q0h5vAnibDGS1T1ufPCn1+QogQv4id5dU40aSjGcA0d7+WY+wTB3qo3ZKd1+36CjAr9+2VJcCW0Hr9YXTSrU3N0i/ckrNYCDZs9QZj3HV/LiWWVjEd2qDuBCNgKNEFx8y2rAPOvP4lw6QhOlR679kPxFvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Z6Znb2vybz1R63X;
	Tue,  4 Mar 2025 20:32:19 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id 0F23E1A016C;
	Tue,  4 Mar 2025 20:33:57 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemg500006.china.huawei.com (7.202.181.43) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 4 Mar 2025 20:33:56 +0800
Subject: Re: [PATCH v2 0/3] update live migration configuration region
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, Jonathan Cameron <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
References: <20250304120528.63605-1-liulongfang@huawei.com>
 <0b5399e306f841b794120e6ca91c1edd@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <bcc0f7bd-8e84-3f10-9985-91741c688fd8@huawei.com>
Date: Tue, 4 Mar 2025 20:33:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <0b5399e306f841b794120e6ca91c1edd@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemg500006.china.huawei.com (7.202.181.43)

On 2025/3/4 20:26, Shameerali Kolothum Thodi wrote:
> 
> 
>> -----Original Message-----
>> From: liulongfang <liulongfang@huawei.com>
>> Sent: Tuesday, March 4, 2025 12:05 PM
>> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
>> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
>> <jonathan.cameron@huawei.com>
>> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
>> Subject: [PATCH v2 0/3] update live migration configuration region
>>
>> On the new hardware platform, the configuration register space
>> of the live migration function is set on the PF, while on the
>> old platform, this part is placed on the VF.
>>
>> Change v1 -> v2
>> 	Delete the vf_qm_state read operation in Pre_Copy
> 
> If I understand correctly, previously this was discussed in your bug fix series here,
> https://lore.kernel.org/all/fa8cd8c1cdbe4849b445ffd8f4894515@huawei.com/
> 
> And why we are having it here in this new hardware support series now?
> 
> Could we please move all the existing bug fixes in one series and support for
> new platform in another series, please.
> 
> Thanks,
> Shameer
> 
> .
> 

OK, I'll separate it out and put it in the bugfix patchset

Thanks.
Longfang.

