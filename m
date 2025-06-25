Return-Path: <kvm+bounces-50617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E939AAE776E
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 08:50:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B12301BC53BE
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 06:50:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B44431F91F6;
	Wed, 25 Jun 2025 06:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b="ZRmaBLso"
X-Original-To: kvm@vger.kernel.org
Received: from sg-3-13.ptr.tlmpb.com (sg-3-13.ptr.tlmpb.com [101.45.255.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2697208961
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 06:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750834150; cv=none; b=MrRpKzDzZV3ZL2BXhFs7/Kf2LsjyKjg8bvKyZAsy2ehWpgQfI45KXR4ZAxPsOgRK88KViZavwVduLfE5lzzHtgXHpjIGS2JtQZuMtFChy0dP5fnmhTr33fdf+jIS5Lfso78Z57itjydQ5KS2Pg1cAEhaT9GlPlA7ES8PeKPo0vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750834150; c=relaxed/simple;
	bh=jwVptLLBAwfAJw/T1q4BqxPHevuRYF1SgKSqnOOBkgw=;
	h=To:Content-Type:From:Mime-Version:Subject:In-Reply-To:Cc:Date:
	 Message-Id:References; b=JTlthU+J9UiwSgqeavCyYHvweRK8Cvm2IBzil9zKGZgWuuMs27cgX6D0jqDJyNzk+UoRJIZrbZh3cTjjUB0R1MogyH5mY8tLiSLBD4kzPl91mf/oISnu0q+QQhg9iRU2HqHBN6tEY+jssg1MB5QiL9mlzq+leweMAqjl9IlIOfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com; spf=pass smtp.mailfrom=lanxincomputing.com; dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b=ZRmaBLso; arc=none smtp.client-ip=101.45.255.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lanxincomputing.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=lanxincomputing-com.20200927.dkim.feishu.cn; t=1750834135;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ZdyKk+Fy17cw6lY7tU2GyRG5lXYFtVObREE3n5Owp1c=;
 b=ZRmaBLsoa5fT3LhiTZLX+QT+5M+0CHX9SmRIWOxTDYA+vr7DlGO/tt1JxhGhAaB7nEDA+I
 W7+9Fak9aDRliKuut9Rg1z5MFRa2l2RqSZeNFNmAV8HW3xoE2Aak6JO7uAb5YlZSRLdZoV
 43GBfWowPzSu5KZyPyCHjvVDFasuKYOuSuOetkIpPDvxnFGZTFD4BHAhufFsjr0EggIVRS
 Wj1dFyt5jWeKJNSHl09TVQl0yWiLs9UA7BXHZHHLu2995s8uFrWe/l71FrxesP/QiL1PZr
 OU5zoFNR5XfDc29Q4WdiaOac8Wd5I4ih2ORfHxEmed875M+LdIhXRQWz7vO3pQ==
To: "Anup Patel" <apatel@ventanamicro.com>, 
	"Atish Patra" <atish.patra@linux.dev>
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
X-Original-From: Nutty Liu <liujingqi@lanxincomputing.com>
From: "Nutty Liu" <liujingqi@lanxincomputing.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [127.0.0.1] ([139.226.59.215]) by smtp.feishu.cn with ESMTPS; Wed, 25 Jun 2025 14:48:52 +0800
Subject: Re: [PATCH v3 01/12] RISC-V: KVM: Check kvm_riscv_vcpu_alloc_vector_context() return value
Content-Transfer-Encoding: 7bit
In-Reply-To: <20250618113532.471448-2-apatel@ventanamicro.com>
Cc: "Palmer Dabbelt" <palmer@dabbelt.com>, 
	"Paul Walmsley" <paul.walmsley@sifive.com>, 
	"Alexandre Ghiti" <alex@ghiti.fr>, 
	"Andrew Jones" <ajones@ventanamicro.com>, 
	"Anup Patel" <anup@brainfault.org>, <kvm@vger.kernel.org>, 
	<kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>, 
	<linux-kernel@vger.kernel.org>
Date: Wed, 25 Jun 2025 14:48:50 +0800
Message-Id: <f8fecbf5-6c6b-4cc3-8694-356b17be8c70@lanxincomputing.com>
X-Lms-Return-Path: <lba+2685b9bd5+cfd651+vger.kernel.org+liujingqi@lanxincomputing.com>
References: <20250618113532.471448-1-apatel@ventanamicro.com> <20250618113532.471448-2-apatel@ventanamicro.com>
Content-Language: en-US

On 6/18/2025 7:35 PM, Anup Patel wrote:
> The kvm_riscv_vcpu_alloc_vector_context() does return an error code
> upon failure so don't ignore this in kvm_arch_vcpu_create().
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>   arch/riscv/kvm/vcpu.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 303aa0a8a5a1..b467dc1f4c7f 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -148,8 +148,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>   
>   	spin_lock_init(&vcpu->arch.reset_state.lock);
>   
> -	if (kvm_riscv_vcpu_alloc_vector_context(vcpu))
> -		return -ENOMEM;
> +	rc = kvm_riscv_vcpu_alloc_vector_context(vcpu);
> +	if (rc)
> +		return rc;
>   
>   	/* Setup VCPU timer */
>   	kvm_riscv_vcpu_timer_init(vcpu);

Reviewed-by: Nutty Liu<liujingqi@lanxincomputing.com>

Thanks,
Nutty

