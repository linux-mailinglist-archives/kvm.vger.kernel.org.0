Return-Path: <kvm+bounces-54975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E1B47B2BF7B
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 12:56:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D049D4E3FA1
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 10:56:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F19BF32A3CE;
	Tue, 19 Aug 2025 10:56:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14930322DC8;
	Tue, 19 Aug 2025 10:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755600982; cv=none; b=LmVkBrbk9/kAlTkqqGhRfp5zXJwwNXGUPbCw55PRe/HPFl4HPVYduJkbZAmkFkbgWMVpf9dC+uNd2xxj4Tl4YUQV1t//O+CfwK9tlnUOsNeOhIhJNSEpmIipRIkhupTLeysad9EX4+CaV/DgQGbAyWLmDbGSxm6efweR4gW+GVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755600982; c=relaxed/simple;
	bh=T4Dc2kphFQ4WYKvQPZlldiIWip/n3vLC0hZwrnmaSI8=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Zyad10VwsljlLKiX0IyDGZSlX7FZNO4k/UGFcdr1FnBcND3/vuf6BxzJXgb/ajlWd2RWVkYPY5Bj6QiFWVuEiHlC9zyMxu6ry1hqNAmPuYKrjhHlc0Bp1ENlcf8yC+m+Jl3fXU6Qj8P2sgjS2eT5CHnDf79GZCXIWdCEcOB67pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c5mj74HzZz14MfL;
	Tue, 19 Aug 2025 18:56:11 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id F246A140158;
	Tue, 19 Aug 2025 18:56:14 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 19 Aug 2025 18:56:14 +0800
Subject: Re: [PATCH v7 2/3] migration: qm updates BAR configuration
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
References: <20250805065106.898298-1-liulongfang@huawei.com>
 <20250805065106.898298-3-liulongfang@huawei.com>
 <d369be68-918a-dcad-e5dd-fd70ec42516c@huawei.com>
 <aKRJpStZKhy8_5-V@gondor.apana.org.au>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <390b3bbb-34d1-04d1-6797-7d726b89cee3@huawei.com>
Date: Tue, 19 Aug 2025 18:56:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <aKRJpStZKhy8_5-V@gondor.apana.org.au>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2025/8/19 17:53, Herbert Xu wrote:
> On Tue, Aug 19, 2025 at 05:12:52PM +0800, liulongfang wrote:
>>
>> Hello, Herbert. There is a patch in this patchset that modifies the crypto subsystem.
>> Could this patch be merged into the crypto next branch?
> 
> Does it depend on the other patches?
>

This patch does not depend on any other patches.

Thanks.
Longfang.

> Cheers,
> 

