Return-Path: <kvm+bounces-19835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E58290C1B2
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 04:06:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE3E3282DCB
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 02:06:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 671301C2A3;
	Tue, 18 Jun 2024 02:06:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF9241AACB;
	Tue, 18 Jun 2024 02:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718676395; cv=none; b=A/S5OjJOV8C2QYlahorRDtZUpRrr+HFiNd5Po2HbkOJ7X2GgMFqG2KZ+DeJ5/sQ7Hw1cadEhoZZnGOJLM0Q//b8xsDh3P9Hv0akWnzlXGQ42UaTfh6U3SgdIUmlk0H06vXy5GQS3o78gbhBbd7JWlJwrhCp/BLnmYVmpZ0DQdzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718676395; c=relaxed/simple;
	bh=VYCCYlKWXeUhSxO6sMCybR/FclqdgxrQaf06urbyiRA=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=FI+9n4L/JFxNGvIhGECoafDldbrepVcFtUR3+BDNxlNVRnZJAFFaPXM2PB8UtcYf34zPLjRrpyw7ZBCPAQoADjUV+bNknpIk/sSKgiF6kIx1r8f7DIwqtQoHMkMnnxkcqqp3a0Xx99UexLs4xZL8SN+EpLLeweDJuSL8pJpgU50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8CxyOmk63BmTcgHAA--.18134S3;
	Tue, 18 Jun 2024 10:06:28 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxhsWf63BmXq8mAA--.17247S3;
	Tue, 18 Jun 2024 10:06:26 +0800 (CST)
Subject: Re: [PATCH -next] LoongArch: KVM: Remove unneeded semicolon
To: Yang Li <yang.lee@linux.alibaba.com>, zhaotianrui@loongson.cn,
 chenhuacai@kernel.org
Cc: kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
References: <20240618010013.66332-1-yang.lee@linux.alibaba.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <2812c8ae-62c2-1ac5-087d-202891a513b6@loongson.cn>
Date: Tue, 18 Jun 2024 10:06:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240618010013.66332-1-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxhsWf63BmXq8mAA--.17247S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9xXoWruF4xKr1rGr4xKF18uFy3GFX_yoW3KFg_uF
	WxJw4I9rZ5Jay8u3Wjgw4rGa4rXw1kJFZYvFyUZr1fGan8JrWrZrZYgas5Aw1vqrW7CFZx
	AaykX3Z8Cw1jvosvyTuYvTs0mTUanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUbxkYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwA2z4x0Y4vEx4A2jsIE14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AK
	xVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzV
	AYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r
	4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8zwZ7UU
	UUU==



On 2024/6/18 上午9:00, Yang Li wrote:
> ./arch/loongarch/kvm/exit.c:764:2-3: Unneeded semicolon
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=9343
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>   arch/loongarch/kvm/exit.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> index c86e099af5ca..a68573e091c0 100644
> --- a/arch/loongarch/kvm/exit.c
> +++ b/arch/loongarch/kvm/exit.c
> @@ -761,7 +761,7 @@ static void kvm_handle_service(struct kvm_vcpu *vcpu)
>   	default:
>   		ret = KVM_HCALL_INVALID_CODE;
>   		break;
> -	};
> +	}
>   
>   	kvm_write_reg(vcpu, LOONGARCH_GPR_A0, ret);
>   }
> 
Reviewed-by: Bibo Mao <maobibo@loongson.cn>


