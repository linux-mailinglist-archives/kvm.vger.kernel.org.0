Return-Path: <kvm+bounces-29347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EBE9B9A9E43
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 11:18:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD07A284146
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 09:18:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6A5F198E63;
	Tue, 22 Oct 2024 09:17:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99DF1198A22;
	Tue, 22 Oct 2024 09:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729588654; cv=none; b=jvePJ7rEHM7oZiQPs/lUx1IgbxhdiLCgY0v+evxi/G/kAHGaHuw2V/Ert46Oa95s5rMUC+E1bbPVfHDblR/qUtNcFclEhGnx+zlITTUye6bk4/FfSSa1bb6/hewvN25fXUrFMmugDiSjjEhilUm3ZsK4d5VN0PLuWFjmg+6wbE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729588654; c=relaxed/simple;
	bh=I5x5SOgGenw7y3wO+bIhVmyuJ+cBlx09KBodnZdxbfA=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=XNGEeedNY7u+8EeqceM6+EtdGV+x89fQLuJaS+tqzaA4Q2pzmtVChfvCnAx2fjCgTDRa1mLDFc2sd9I+1draBVLh+hMShDKOht7QE09UUTk0y5AhNbfdeKXrJBRJ9SQkDu/Y3FH91ubxCEdbLozPJKRpT8TGbefdXeJ7E02LWUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxaeGpbRdn78UEAA--.11221S3;
	Tue, 22 Oct 2024 17:17:29 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMBxveClbRdndjcHAA--.42581S3;
	Tue, 22 Oct 2024 17:17:28 +0800 (CST)
Subject: Re: [PATCH v8 3/3] irqchip/loongson-eiointc: Add extioi virt
 extension support
To: Thomas Gleixner <tglx@linutronix.de>, Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 x86@kernel.org, Song Gao <gaosong@loongson.cn>
References: <20240830093229.4088354-1-maobibo@loongson.cn>
 <20240830093229.4088354-4-maobibo@loongson.cn>
 <CAAhV-H4W4LwL3U2HT+-r+6nH5ZSBBbPYL2wdZJqQF7WNkhOgMw@mail.gmail.com>
 <878qv6y631.ffs@tglx>
From: maobibo <maobibo@loongson.cn>
Message-ID: <2fb27579-5a4d-8bcc-db08-8942960dc07e@loongson.cn>
Date: Tue, 22 Oct 2024 17:17:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <878qv6y631.ffs@tglx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxveClbRdndjcHAA--.42581S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9xXoW7GFy5ZrW5Jw47KFykGF4rJFc_yoWkJwcE9F
	Z7A34Uuw4UXry2ka12yrWakr9xGa4UC3Wvv3yUGr4Iqa43ZrZ8CF4Uur1xWay0qrW0gFn3
	JwsYvr1avw1ruosvyTuYvTs0mTUanT9S1TB71UUUUUJqnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUbqkYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_JrI_Jryl8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1ln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
	xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y
	6r17McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
	1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUXVWUAwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jza0PUUU
	UU=

Hi Huacai/Thomas,

Sorry for the ping message :(

Can this patch be applied int next RC version?

Regards
Bibo Mao

On 2024/10/2 下午9:42, Thomas Gleixner wrote:
> On Wed, Sep 11 2024 at 17:11, Huacai Chen wrote:
>> Hi, Thomas,
>>
>> On Fri, Aug 30, 2024 at 5:32 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>>
>>> Interrupts can be routed to maximal four virtual CPUs with one HW
>>> EIOINTC interrupt controller model, since interrupt routing is encoded with
>>> CPU bitmap and EIOINTC node combined method. Here add the EIOINTC virt
>>> extension support so that interrupts can be routed to 256 vCPUs on
>>> hypervisor mode. CPU bitmap is replaced with normal encoding and EIOINTC
>>> node type is removed, so there are 8 bits for cpu selection, at most 256
>>> vCPUs are supported for interrupt routing.
>> This patch is OK for me now, but seems it depends on the first two,
>> and the first two will get upstream via loongarch-kvm tree. So is that
>> possible to also apply this one to loongarch-kvm with your Acked-by?
> 
> Go ahead.
> 
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> 


