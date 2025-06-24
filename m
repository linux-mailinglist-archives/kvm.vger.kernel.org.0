Return-Path: <kvm+bounces-50445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 15D20AE5A80
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 05:32:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D73017F642
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 03:32:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ACBE824A3;
	Tue, 24 Jun 2025 03:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HYQKctI2"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3028462
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 03:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750735936; cv=none; b=I6nerT2Fre0pYpWrEApE8Cinf3snYwtE+BTjziH4eKXYwG1xgPKEHYeN+AVVgSxqDjKRffr2fHyHP86cUa2RVJSzWnxm9zYVeqouJL9o9MhDYlW5CD6pt5721EbkE3pg9g9zbRbGymGZJnR4XrWOdZY6+Q3XWXquZ4ban8hZQ1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750735936; c=relaxed/simple;
	bh=M6AdOiQsUgSJClzTHfGsZyI4BzAfupJfHcAQ8+AVXU4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QkkFcgzOBOroGP5SEM+agY88Syn+qbHJhQsOMdMYiRFmROCs59ahYdMF2RuFbambeMPiKnQJWv72p/1e0FR/Z9GR3yIXCLKfWABEOSjUJ2mAQJiVEzLasXnO6ru0e8Bv23svFPMjnUKj/gdsm1XCLTsqo6dodZvvJT5lGbmCcLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HYQKctI2; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <78c18dd2-69d4-49f3-a464-b582a00d2f4c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750735932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vHvWN0nBK/1iz0XiFx6EVa3LaybalcP67xeWcGnBLH0=;
	b=HYQKctI2Shhd8seRP+ffCb3LO9nhqD7N5XzbRtBvvmx20rGKyUE0+ZVMEm4lP0TQmosZva
	2v6HcJeeDP3UogmB/VfE/f86E+/hPeX1FEc1PaIGH+KSe+mwYN3w/eo0D5MSCWCIa7Oj6K
	gwhXfltsaeBa8rjqYfcS6KrGrnWVVZY=
Date: Mon, 23 Jun 2025 20:32:07 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 01/12] RISC-V: KVM: Check
 kvm_riscv_vcpu_alloc_vector_context() return value
To: Anup Patel <apatel@ventanamicro.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20250618113532.471448-1-apatel@ventanamicro.com>
 <20250618113532.471448-2-apatel@ventanamicro.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Atish Patra <atish.patra@linux.dev>
In-Reply-To: <20250618113532.471448-2-apatel@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT


On 6/18/25 4:35 AM, Anup Patel wrote:
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


Reviewed-by: Atish Patra <atishp@rivosinc.com>


