Return-Path: <kvm+bounces-9384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4526485F7A0
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 12:59:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 763591C23B7A
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 11:59:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A90846544;
	Thu, 22 Feb 2024 11:59:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CDD940BEE;
	Thu, 22 Feb 2024 11:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708603153; cv=none; b=tU/Os0j9opCA+7VsfLEvKjH1XHOExjrPmwzqiP+hJqELfSoW4MPs38yLZ6fujeqoq2GKNrqRIIBay2J6EWiM6BzwD4mlBYCjYwXGVnt3uk5BrzAvQ916/QUN35xPjY4aB0nBJtfeyRO7KJs/Zv9KCtAYL/7dyjozgaU8hjyKDtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708603153; c=relaxed/simple;
	bh=lAlR1MpRJtgLUp8F9iTL0liBr+p7INogvN8UsHKVfI0=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=s5tOmYVXjAUiaVAoeNkYWY8ZoJKATg5zB1YNtwuCwH/x5AU2M30yHmBkpTIMm8GS1+Tcc8VNezlP6SocFWqSUSVyBBEGpyDO3PpRPEMmNjkJuKO2p47xnXzjL7lRzWQBfoO8c5NRExlrWLRFUULFkobs8DVpBANICLyM0I/JKqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8Ax++gLN9dlaTMQAA--.22337S3;
	Thu, 22 Feb 2024 19:59:07 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxnhMJN9dl1sg+AA--.43078S3;
	Thu, 22 Feb 2024 19:59:05 +0800 (CST)
Subject: Re: [PATCH for-6.8 v4 2/3] LoongArch: KVM: Rename _kvm_get_cpucfg to
 _kvm_get_cpucfg_mask
To: WANG Xuerui <kernel@xen0n.name>, Paolo Bonzini <pbonzini@redhat.com>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 WANG Xuerui <git@xen0n.name>
References: <20240222105109.2042732-1-kernel@xen0n.name>
 <20240222105109.2042732-3-kernel@xen0n.name>
From: maobibo <maobibo@loongson.cn>
Message-ID: <9e738ae8-8209-f194-9d4e-692c8b107ba5@loongson.cn>
Date: Thu, 22 Feb 2024 19:59:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240222105109.2042732-3-kernel@xen0n.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8BxnhMJN9dl1sg+AA--.43078S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7uw1fCF45Gw4DuFy5Aw17XFc_yoW8Xr45pF
	47Can0gr4FyF17Wa4vy3yDK3y7XrZrKryxtF92k34vkFs8tr10qrW8KrZ2qr15C3s3AF48
	XayftF4YvanrA3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	tVWrXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWxJVW8Jr1lIxAIcVC2z280aVCY1x02
	67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8EeHDUUUUU==



On 2024/2/22 下午6:51, WANG Xuerui wrote:
> From: WANG Xuerui <git@xen0n.name>
> 
> The function is not actually a getter of guest CPUCFG, but rather
> validation of the input CPUCFG ID plus information about the supported
> bit flags of that CPUCFG leaf. So rename it to avoid confusion.
> 
> Signed-off-by: WANG Xuerui <git@xen0n.name>
> ---
>   arch/loongarch/kvm/vcpu.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 7fd32de6656b..9f63bbaf19c1 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -298,7 +298,7 @@ static int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 val)
>   	return ret;
>   }
>   
> -static int _kvm_get_cpucfg(int id, u64 *v)
> +static int _kvm_get_cpucfg_mask(int id, u64 *v)
>   {
>   	if (id < 0 || id >= KVM_MAX_CPUCFG_REGS)
>   		return -EINVAL;
> @@ -339,7 +339,7 @@ static int kvm_check_cpucfg(int id, u64 val)
>   	u64 mask = 0;
>   	int ret;
>   
> -	ret = _kvm_get_cpucfg(id, &mask);
> +	ret = _kvm_get_cpucfg_mask(id, &mask);
>   	if (ret)
>   		return ret;
>   
> @@ -567,7 +567,7 @@ static int kvm_loongarch_get_cpucfg_attr(struct kvm_vcpu *vcpu,
>   	uint64_t val;
>   	uint64_t __user *uaddr = (uint64_t __user *)attr->addr;
>   
> -	ret = _kvm_get_cpucfg(attr->attr, &val);
> +	ret = _kvm_get_cpucfg_mask(attr->attr, &val);
>   	if (ret)
>   		return ret;
>   
> 
Reviewed-by: Bibo Mao <maobibo@loongson.cn>


