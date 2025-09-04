Return-Path: <kvm+bounces-56744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B8120B43273
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:34:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8710A56460C
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 06:34:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCD5C276020;
	Thu,  4 Sep 2025 06:34:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D733253B5C;
	Thu,  4 Sep 2025 06:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756967686; cv=none; b=XYOmJJ93Oj+fk2twOhRUdlU898CzJBg7NCqnH90oPT4cTi0IymmYOJbsVM9Hr0Lf28/y89ClT4nzWOaJVh+e90Yp9Xa/HExINFUKA/5yEVMwWF2uYhvjVKRAqYtu/ttagfdEkP62rsDWTb8dDva307BRESWh29u0K1GLMreEl5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756967686; c=relaxed/simple;
	bh=YSV9ojTwVUCmOZLAW1nmzCEEdATne0F6waPXQ/CsoRg=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ijazrTj+/o2ZADlywGgFuSeNsPTiZe6g/T91W6mwHItU6xS6vIFWLrJDt0czqSHADbbD+LJqmpsYdGaMGkXXmFFlHh5wlc+3lGhWLQxYApDju/jqPeRGU581+90IfJ48oQ+QMevpw9m7IjGqKXjigaaGEqprdBJVHmJusFsU7fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [113.200.148.30])
	by gateway (Coremail) with SMTP id _____8AxP_D9MrlofYsGAA--.13749S3;
	Thu, 04 Sep 2025 14:34:37 +0800 (CST)
Received: from [10.130.10.66] (unknown [113.200.148.30])
	by front1 (Coremail) with SMTP id qMiowJAxE+T2Mrlo7lF9AA--.3223S3;
	Thu, 04 Sep 2025 14:34:31 +0800 (CST)
Subject: Re: [PATCH] LoongArch: KVM: remove unused returns.
To: cuitao <cuitao@kylinos.cn>, zhaotianrui@loongson.cn, maobibo@loongson.cn,
 chenhuacai@kernel.org, loongarch@lists.linux.dev
Cc: kernel@xen0n.name, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250904042622.1291085-1-cuitao@kylinos.cn>
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Message-ID: <462e346b-424d-263d-19a8-766d578d9781@loongson.cn>
Date: Thu, 4 Sep 2025 14:34:30 +0800
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
X-CM-TRANSID:qMiowJAxE+T2Mrlo7lF9AA--.3223S3
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Coremail-Antispam: 1Uk129KBj93XoW7uFW5CrWkWw4DGrykJF4xuFX_yoW8KFyfpr
	nrArWFkw48Kr93GFZrZ34DWr4UurZ2kr12qFWjyFy8Wr4Dtr4rAr10yr95uF15t3W0vF1I
	qasYgFnIvF4DJ3XCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Fb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27wAqx4
	xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v2
	6r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67
	vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v2
	6r1q6r43MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIx
	AIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2
	KfnxnUUI43ZEXa7IU8vApUUUUUU==

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

In my opinion, there is only one case, no need to use switch case,
the ";" at the end can be removed, the code can be like this:

static long kvm_save_notify(struct kvm_vcpu *vcpu)
{
         unsigned long id, data;

         id   = kvm_read_reg(vcpu, LOONGARCH_GPR_A1);
         data = kvm_read_reg(vcpu, LOONGARCH_GPR_A2);
         if (id == BIT(KVM_FEATURE_STEAL_TIME)) {
                 if (data & ~(KVM_STEAL_PHYS_MASK | KVM_STEAL_PHYS_VALID))
                         return KVM_HCALL_INVALID_PARAMETER;

                 vcpu->arch.st.guest_addr = data;
                 if (!(data & KVM_STEAL_PHYS_VALID))
                         return 0;

                 vcpu->arch.st.last_steal = current->sched_info.run_delay;
                 kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
                 return 0;
         }

         return KVM_HCALL_INVALID_CODE;
}

The following is the diff:

diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index 2ce41f93b2a4..0c18761539fc 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -764,8 +764,7 @@ static long kvm_save_notify(struct kvm_vcpu *vcpu)

         id   = kvm_read_reg(vcpu, LOONGARCH_GPR_A1);
         data = kvm_read_reg(vcpu, LOONGARCH_GPR_A2);
-       switch (id) {
-       case BIT(KVM_FEATURE_STEAL_TIME):
+       if (id == BIT(KVM_FEATURE_STEAL_TIME)) {
                 if (data & ~(KVM_STEAL_PHYS_MASK | KVM_STEAL_PHYS_VALID))
                         return KVM_HCALL_INVALID_PARAMETER;

@@ -776,12 +775,10 @@ static long kvm_save_notify(struct kvm_vcpu *vcpu)
                 vcpu->arch.st.last_steal = current->sched_info.run_delay;
                 kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
                 return 0;
-       default:
-               return KVM_HCALL_INVALID_CODE;
-       };
+       }

         return KVM_HCALL_INVALID_CODE;
-};
+}

  /*
   * kvm_handle_lsx_disabled() - Guest used LSX while disabled in root.

Thanks,
Tiezhu


