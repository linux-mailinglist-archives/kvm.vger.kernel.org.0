Return-Path: <kvm+bounces-65085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 579CEC9A5F4
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 07:52:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFD753A2F0F
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 06:52:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD81D301460;
	Tue,  2 Dec 2025 06:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ZwWuYbG5"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F239C2F9D83;
	Tue,  2 Dec 2025 06:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764658314; cv=none; b=XRcB58bR1kIG1iFnqEotcxJAyZNfabyfXvSvPhkH/dObBiCuKlhPyjVJfJ/lW9X7DT+we9CWI805rMlwodXYQNiogWRTXtkiN7CQojxeoTFv5AT60weoOrUnB6R3C59lxIxgP+D4SeBaWok19PhGdDIRci4dSQ7aoTpn65bmuFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764658314; c=relaxed/simple;
	bh=1gWTQq98bOypJjboTaFYpJ4wa3iFoj+/sxC2R7JCTkU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=t900QcWewqoVHylaCGuiEs3bjUWkN4gypQmv0V5wdpx7RAMYx4ORaxMd13rdGRAvEEPQpk212vAiO4aKdUg7nSRBi7YJlxgXfIE6wOUQhEYulLA3sNbbSY7L+kdUnncKWQBdwtBbxtrYmxesOhHAb1H9JR/GQrL7lb4UBbIjdWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ZwWuYbG5; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=cATUQiJc9npGbI4jT9r+I8H4PuqTS2f1GZLrT/FePi4=;
	b=ZwWuYbG5Q4xPmpss4QVApiJLmjWp+n8LiM6hKr9n7ChT+CJ5bPOvx3acW7pqU4MdJPlyNGvOE
	RAaXTbV5rP9YfYneFFiGuebJEYbII+gELeXeBLd/+g18aQDBLsWWn1iQq1/0slm4c3ka2XzXU+g
	BKMoenxgpkm/nrnPz5JyzAM=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4dLBGS2cKRzRhVh;
	Tue,  2 Dec 2025 14:49:52 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 080F3180BCE;
	Tue,  2 Dec 2025 14:51:44 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Tue, 2 Dec 2025 14:51:43 +0800
Message-ID: <3b41d540-37d1-4b92-91a3-f4094f7ad792@huawei.com>
Date: Tue, 2 Dec 2025 14:51:42 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] arm64/sysreg: Add HDBSS related register
 information
To: Marc Zyngier <maz@kernel.org>, Tian Zheng <zhengtian10@huawei.com>
CC: <oliver.upton@linux.dev>, <catalin.marinas@arm.com>, <corbet@lwn.net>,
	<pbonzini@redhat.com>, <will@kernel.org>, <linux-kernel@vger.kernel.org>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <yezhenyu2@huawei.com>,
	<xiexiangyou@huawei.com>, <zhengchuan@huawei.com>, <joey.gouly@arm.com>,
	<kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
	<suzuki.poulose@arm.com>
References: <20251121092342.3393318-1-zhengtian10@huawei.com>
 <20251121092342.3393318-2-zhengtian10@huawei.com>
 <86wm3iqlz8.wl-maz@kernel.org>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <86wm3iqlz8.wl-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr100010.china.huawei.com (7.202.195.125)



在 2025/11/22 20:40, Marc Zyngier 写道:
> On Fri, 21 Nov 2025 09:23:38 +0000,
> Tian Zheng <zhengtian10@huawei.com> wrote:
>>
>> From: eillon <yezhenyu2@huawei.com>
>>
>> The ARM architecture added the HDBSS feature and descriptions of
>> related registers (HDBSSBR/HDBSSPROD) in the DDI0601(ID121123) version,
>> add them to Linux.
>>
>> Signed-off-by: eillon <yezhenyu2@huawei.com>
>> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
>> ---
>>   arch/arm64/include/asm/esr.h     |  2 ++
>>   arch/arm64/include/asm/kvm_arm.h |  1 +
>>   arch/arm64/tools/sysreg          | 28 ++++++++++++++++++++++++++++
>>   3 files changed, 31 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
>> index e1deed824464..a6f3cf0b9b86 100644
>> --- a/arch/arm64/include/asm/esr.h
>> +++ b/arch/arm64/include/asm/esr.h
>> @@ -159,6 +159,8 @@
>>   #define ESR_ELx_CM 		(UL(1) << ESR_ELx_CM_SHIFT)
>>
>>   /* ISS2 field definitions for Data Aborts */
>> +#define ESR_ELx_HDBSSF_SHIFT	(11)
>> +#define ESR_ELx_HDBSSF		(UL(1) << ESR_ELx_HDBSSF_SHIFT)
>>   #define ESR_ELx_TnD_SHIFT	(10)
>>   #define ESR_ELx_TnD 		(UL(1) << ESR_ELx_TnD_SHIFT)
>>   #define ESR_ELx_TagAccess_SHIFT	(9)
>> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
>> index 1da290aeedce..b71122680a03 100644
>> --- a/arch/arm64/include/asm/kvm_arm.h
>> +++ b/arch/arm64/include/asm/kvm_arm.h
>> @@ -124,6 +124,7 @@
>>   			 TCR_EL2_ORGN0_MASK | TCR_EL2_IRGN0_MASK)
>>
>>   /* VTCR_EL2 Registers bits */
>> +#define VTCR_EL2_HDBSS		(1UL << 45)
> 
> I think it is time to convert VTCR_EL2 to the sysreg infrastructure
> instead of adding extra bits here.
> 

Hello Marc, I noticed you added VTCR_EL2 to the sysreg infrastructure in 
this patch:

https://lore.kernel.org/linux-arm-kernel/20251129144525.2609207-3-maz@kernel.org/

Once this patch is merged upstream, I will remove my local definition.

> 	M.
> 


