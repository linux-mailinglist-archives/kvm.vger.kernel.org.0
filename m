Return-Path: <kvm+bounces-26446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C28569747AE
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 03:16:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 69E911F271DB
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 01:16:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F9B21EB46;
	Wed, 11 Sep 2024 01:16:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2DA5748A
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 01:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726017399; cv=none; b=Irv7IjnH0ZHCqtXR+lhKkmkAbgDieuaoLh/HVjQ5AlzLoCLCChaspDZms+2MVzyX12KY8DEYrfFNaDMrqlLPkafGI/nTquNBtH4EH+EumY7vY/2/uWDOaiYYZBX/bRbCHK1cTRP4YLaWYqsvPLZbqjzFfGRdjOi9Q0KfRZIjn58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726017399; c=relaxed/simple;
	bh=XwyQAVtAZaEvOWwouWGwtCl977uv2I3CIM3Eg53oY0Y=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=rW32d9O92d26PIs+24UB3a37xnBJDkk9FRPpQ7RndnqIbN5nC7Meotnej6U7gqXzLmIc64uowyYnu4rw+WAXGe3PgzUON0Y/kFvS+R3g3zpR+8M1wkMyMKp/lIow47iiXkPUZ9Ou6PS90ZABW9bBQUCN/fV8/ByZ0BvmrJvuiro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.184])
	by gateway (Coremail) with SMTP id _____8AxKOlx7+BmhkEEAA--.8993S3;
	Wed, 11 Sep 2024 09:16:33 +0800 (CST)
Received: from [10.20.42.184] (unknown [10.20.42.184])
	by front1 (Coremail) with SMTP id qMiowMBxn+Rv7+BmNGgDAA--.19724S3;
	Wed, 11 Sep 2024 09:16:32 +0800 (CST)
Subject: Re: [RFC PATCH V2 1/5] include: Add macro definitions needed for
 interrupt controller kvm emulation
To: Cornelia Huck <cohuck@redhat.com>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Song Gao <gaosong@loongson.cn>,
 Jiaxun Yang <jiaxun.yang@flygoat.com>, Huacai Chen <chenhuacai@kernel.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
 Bibo Mao <maobibo@loongson.cn>
References: <cover.1725969898.git.lixianglai@loongson.cn>
 <2182eb694629ee3f2859e441b8076d62d3606ee2.1725969898.git.lixianglai@loongson.cn>
 <87cylbvcts.fsf@redhat.com>
From: lixianglai <lixianglai@loongson.cn>
Message-ID: <ba11190f-9001-552a-68bb-2c8ab0c8b826@loongson.cn>
Date: Wed, 11 Sep 2024 09:16:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <87cylbvcts.fsf@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-CM-TRANSID:qMiowMBxn+Rv7+BmNGgDAA--.19724S3
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW7Cr1xGw18uFy7Xry3GF13WrX_yoW8XF1xpa
	9rC3Z09r4kJryxA3ZxXa47ZFy3Ja95GF92qFy3G34FywnxX3W8Xw1xKw1kXFyUKr1rKFWU
	Xr43K3WYg3WUZrcCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPYb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWU
	AwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l
	4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
	42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jOa93UUUUU=

Hi Cornelia Huck:
> On Tue, Sep 10 2024, Xianglai Li <lixianglai@loongson.cn> wrote:
>
>> Add macro definitions needed for interrupt controller kvm emulation.
>>
>> Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
>> ---
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Song Gao <gaosong@loongson.cn>
>> Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
>> Cc: Huacai Chen <chenhuacai@kernel.org>
>> Cc: "Michael S. Tsirkin" <mst@redhat.com>
>> Cc: Cornelia Huck <cohuck@redhat.com>
>> Cc: kvm@vger.kernel.org
>> Cc: Bibo Mao <maobibo@loongson.cn>
>> Cc: Xianglai Li <lixianglai@loongson.cn>
>>
>>   include/hw/intc/loongarch_extioi.h    | 38 ++++++++++++++++--
>>   include/hw/intc/loongarch_ipi.h       | 15 +++++++
>>   include/hw/intc/loongarch_pch_pic.h   | 58 +++++++++++++++++++++++++--
>>   include/hw/intc/loongson_ipi.h        |  1 -
>>   include/hw/intc/loongson_ipi_common.h |  2 +
>>   include/hw/loongarch/virt.h           | 15 +++++++
>>   linux-headers/asm-loongarch/kvm.h     | 18 +++++++++
>>   linux-headers/linux/kvm.h             |  6 +++
>>   8 files changed, 146 insertions(+), 7 deletions(-)
> The parts you need to split out into a separate patch are the changes
> under linux-headers/ (because they get updated via a script); the
> changes under include/hw/ are internal to QEMU and should go where it
> makes sense (probably with the actual changes in .c files, but I didn't
> check what the patch actually does.)
Ok, I'll correct it in the next version.
Thanks!
Xianglai.


