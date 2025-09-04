Return-Path: <kvm+bounces-56740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 00880B4322C
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:17:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 71C691C24BD2
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 06:17:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C364E25B1FF;
	Thu,  4 Sep 2025 06:17:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EBC0259CBD;
	Thu,  4 Sep 2025 06:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756966643; cv=none; b=aP2FB0FX6wzMk/gSRyN7mpK46dQ8zseW2yzfgJEA9AjJMpFqM9rm+oRDGULuL7WDRaVv992xd2H5V5ycH8/SwVhQYpGqnGhUi+iCVD7Drf+gZKBxK0EGB+IY9TZiLLRJDdCu49gz6E4y0c8d2HCpjx4ATCZKF9AU1OcsCKBPn2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756966643; c=relaxed/simple;
	bh=QJP7VVZZyM+qnHALZSZbtVOoHUDNhZ1aAqXZh4XrcyI=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=NfNxptSeEEtFPNNBRbL06rU+lZYuEkvKUhtir3WaVHZL2Nis3Hkigbz/tU5ves4TZ6v7mP4CiLQdXU6w5wE9hrDfd1NDZ7dh/hZZHdXmr2VV/1OaYarGgw5Nke8+d/y+UF7xatBvhbNgoXuwFTuJz1oqf+V1GJ7FVAylxQdnVMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Cx6tHrLrloxIkGAA--.13909S3;
	Thu, 04 Sep 2025 14:17:15 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJBxzsHiLrlocUl9AA--.40817S3;
	Thu, 04 Sep 2025 14:17:08 +0800 (CST)
Subject: Re: [PATCH] LoongArch: KVM: remove unused returns.
To: cuitao <cuitao@kylinos.cn>, zhaotianrui@loongson.cn,
 chenhuacai@kernel.org, loongarch@lists.linux.dev
Cc: kernel@xen0n.name, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250904042622.1291085-1-cuitao@kylinos.cn>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <c70e595e-c1ab-2c8a-3f46-3862ecd6e0b8@loongson.cn>
Date: Thu, 4 Sep 2025 14:15:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250904042622.1291085-1-cuitao@kylinos.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxzsHiLrlocUl9AA--.40817S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9xXoWruFWfZrWktF4kAFW7tryfXwc_yoW3GFc_Jw
	17J392krs5Jay8ua13trn5G3WSqw4kJFn3urnrZr1fJwn8Jrs8ZrWqgw1rAryvqFsrAF4r
	taykZF9Ikw1jyosvyTuYvTs0mTUanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUbx8YFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8JVWxJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0
	oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI0UMc02F4
	0EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_
	Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbI
	xvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AK
	xVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrx
	kI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v2
	6r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8Jw
	CI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07j1WlkUUUUU
	=



On 2025/9/4 下午12:26, cuitao wrote:
> The default branch has already handled all undefined cases,
> so the final return statement is redundant.
> 
> Signed-off-by: cuitao <cuitao@kylinos.cn>
> ---
>   arch/loongarch/kvm/exit.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> index 2ce41f93b2a4..e501867740b1 100644
> --- a/arch/loongarch/kvm/exit.c
> +++ b/arch/loongarch/kvm/exit.c
> @@ -778,9 +778,7 @@ static long kvm_save_notify(struct kvm_vcpu *vcpu)
>   		return 0;
>   	default:
>   		return KVM_HCALL_INVALID_CODE;
> -	};
> -
> -	return KVM_HCALL_INVALID_CODE;
> +	}
>   };
>   
>   /*
> 
Reviewed-by: Bibo Mao <maobibo@loongson.cn>


