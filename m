Return-Path: <kvm+bounces-56808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A9E4B43672
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 11:00:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8606586D88
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 09:00:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2EE52D3233;
	Thu,  4 Sep 2025 09:00:19 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 239B12D375D;
	Thu,  4 Sep 2025 09:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756976419; cv=none; b=Xtz92OtuePl+vXzj8dQqkVP0Pq1tZll7m6f38aKOK1LMjdCg9crRH2d+taGBBDc7L3qbgUuofeu6osodqlephDxVg8uOw92R1Vih4mGmfBpBNl886n9ac2ULsn//Tb5GmM4L3CwEnoTnwHQsMRyheOqj+jbtRBcOcOVKBcEVnTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756976419; c=relaxed/simple;
	bh=ZxHp9rvXp3A5BFA/iyuoW2TlsxQ7kn4hKMLyxjrZ7Tg=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=tyVMUKqC5ToDXymKC4ekbEj470erW9lW1aPsOTSvyAqdTpr3CL8TKSTfEin9yV2JS/F8BUJ2bCVcF+iAdycS0RP3VC048HzVObihCms6B2h5EALdGhMlSdSdFQrFll6lcPiLHd2LhORvYBDAt4yo3m7Xc4O9mP+1oZK8TOgu3QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8CxaNEYVblohpoGAA--.13967S3;
	Thu, 04 Sep 2025 17:00:08 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJDxQ+QPVblou5t9AA--.4589S3;
	Thu, 04 Sep 2025 17:00:03 +0800 (CST)
Subject: Re: [PATCH] LoongArch: KVM: remove unused returns.
To: Huacai Chen <chenhuacai@kernel.org>, cuitao <cuitao@kylinos.cn>
Cc: yangtiezhu@loongson.cn, kernel@xen0n.name, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 zhaotianrui@loongson.cn
References: <462e346b-424d-263d-19a8-766d578d9781@loongson.cn>
 <20250904081356.1310984-1-cuitao@kylinos.cn>
 <CAAhV-H4QDs+zruvKVkDgWnMoObhoHiWOL7x4=Q2PRTnnqkNnsw@mail.gmail.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <5bd70387-0dc0-fe66-5c5a-5914dd32d6bc@loongson.cn>
Date: Thu, 4 Sep 2025 16:57:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H4QDs+zruvKVkDgWnMoObhoHiWOL7x4=Q2PRTnnqkNnsw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxQ+QPVblou5t9AA--.4589S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9xXoWrZr17Gr47Gr4DWw1fKryDJwc_yoWDKwb_Wa
	9ak3s2kw1ktF43K3Wvkw45CasxKw4DC34DtrWkJr1Sq34xXayDGrs5Cr17u3W3XayIvwnx
	uFyYgayxXw1a9osvyTuYvTs0mTUanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUb3AYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8JVWxJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0
	oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI0UMc02F4
	0EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_
	Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbI
	xvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_
	Jw0_GFylx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1V
	AY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAI
	cVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIev
	Ja73UjIFyTuYvjxUcVc_UUUUU



On 2025/9/4 下午4:20, Huacai Chen wrote:
> On Thu, Sep 4, 2025 at 4:14 PM cuitao <cuitao@kylinos.cn> wrote:
>>
>> Thanks for the review.
>>
>> My initial idea was to remove the switch-case structure.
>> However, after checking the case value KVM_FEATURE_STEAL_TIME,
>> I found there are 13 parallel definitions—and it is unclear when
>> this part of the development will be completed later. Therefore,
>> I temporarily retained the switch-case structure.
>>
>> Now, I have updated the patch according to your suggestion:
>> - Replaced `switch` with `if` since there is only one case.
>> - Removed the redundant semicolon after the block.
>>
>> Please see the updated patch below.
> It has been applied, don't make useless effort.
> https://github.com/chenhuacai/linux/commit/f5d35375a6546bcc5d0993e3a48cdbc3a7217544
I think that it is unnecessary to replace `switch` with `if` here:)

One thing is that the change is big for such thing, and also there may 
be new case condition in future, just maybe.

Regards
Bibo Mao
> 
> Huacai
> 
>>
>> Thanks,
>> Tiezhu


