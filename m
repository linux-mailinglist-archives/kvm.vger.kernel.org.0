Return-Path: <kvm+bounces-51646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EE6EAFAA7E
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 06:07:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 831443AB66B
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 04:06:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FA5B25A625;
	Mon,  7 Jul 2025 04:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b="KEyFCThk"
X-Original-To: kvm@vger.kernel.org
Received: from sg-1-13.ptr.blmpb.com (sg-1-13.ptr.blmpb.com [118.26.132.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654002E36F7
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 04:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751861215; cv=none; b=NBux69nbeWAwYxnEUrWKc79tg19AVlxFZMVzY+wOEG0oSJH+oL1Yq/CmmiYy0w/FNmaLm9diSZ1FURapCCtU93pv0KZWUEu1Y8xcnHKKGgOLIAxfVQViWMfghlGz7f8ryFVD30l9HMJNlbwg99IYR97Xz/njMR8PWiIZkfSNCfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751861215; c=relaxed/simple;
	bh=4cUryX0p6wHpXmFh925BLJoApuUpUVuNMRUjnwPvYVI=;
	h=References:Content-Type:Cc:Date:Mime-Version:To:Subject:
	 In-Reply-To:From:Message-Id; b=uvhq27fdLydDTaQpmX0gAPNC24KfivTR68OXoyJNk2fs0Z9j3dYLJ56uHLWpZCa1cNXvsaDjtAabRSPzYzPOOv69Zb8hJfzcgp+IP5npMp8QpTU3bk/7QCEPk1nRQKo4ja7GBvvxcDiSVVyVlfygTvR1TyFj4WVAi8VmhCXm5Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com; spf=pass smtp.mailfrom=lanxincomputing.com; dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b=KEyFCThk; arc=none smtp.client-ip=118.26.132.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lanxincomputing.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=lanxincomputing-com.20200927.dkim.feishu.cn; t=1751861207;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=iWMiLtGM2M9N3Qy5qdoVvMFI8rSYaoOq+MdfZfHPcnI=;
 b=KEyFCThkMV6lpQ0WPgt6TLuoWowshPzUU+KBPLF1rqHqOgntfMqgd1U4AemCDB7cJqC8re
 c3sq4Aekc1Vs9HVjLkPBxkOKwYpegjhjngZzopsA9n018Fb8oj9foA9ZwhixrY2Q+lXWc5
 vBgKV7491bE/4ND6MQwGcYjY7Y+a71hsE/HFPFlaRLprYdb0CPUSRhcvHKiIlN77/jqaMm
 LMe8QGcLMKPwXlsi7XFzcGT4Utg4OiQKOJv3wHCLzjObrd6unGT/kkzpS5JplQSdZaVusj
 TTiXITfKlOJtybgXFdEGjbPUSe9j0xnv6HAjUNSbotzSK9X14WrZVp0VuYjbtQ==
Content-Transfer-Encoding: 7bit
User-Agent: Mozilla Thunderbird
References: <20250707035345.17494-1-apatel@ventanamicro.com> <20250707035345.17494-2-apatel@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8
Cc: "Palmer Dabbelt" <palmer@dabbelt.com>, 
	"Paul Walmsley" <paul.walmsley@sifive.com>, 
	"Alexandre Ghiti" <alex@ghiti.fr>, 
	"Andrew Jones" <ajones@ventanamicro.com>, 
	"Anup Patel" <anup@brainfault.org>, <kvm@vger.kernel.org>, 
	<kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>, 
	<linux-kernel@vger.kernel.org>, "Atish Patra" <atishp@rivosinc.com>, 
	"Heinrich Schuchardt" <heinrich.schuchardt@canonical.com>
Date: Mon, 7 Jul 2025 12:06:41 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+2686b47d5+3f79f5+vger.kernel.org+liujingqi@lanxincomputing.com>
Received: from [127.0.0.1] ([116.237.111.137]) by smtp.feishu.cn with ESMTPS; Mon, 07 Jul 2025 12:06:43 +0800
X-Original-From: Nutty Liu <liujingqi@lanxincomputing.com>
To: "Anup Patel" <apatel@ventanamicro.com>, 
	"Atish Patra" <atish.patra@linux.dev>
Subject: Re: [PATCH v2 1/2] RISC-V: KVM: Disable vstimecmp before exiting to user-space
In-Reply-To: <20250707035345.17494-2-apatel@ventanamicro.com>
Content-Language: en-US
From: "Nutty Liu" <liujingqi@lanxincomputing.com>
Message-Id: <87e96caa-9df6-482c-a0f4-74a97e7ccb5c@lanxincomputing.com>

On 7/7/2025 11:53 AM, Anup Patel wrote:
> If VS-timer expires when no VCPU running on a host CPU then WFI
> executed by such host CPU will be effective NOP resulting in no
> power savings. This is as-per RISC-V Privileged specificaiton
> which says: "WFI is also required to resume execution for locally
> enabled interrupts pending at any privilege level, regardless of
> the global interrupt enable at each privilege level."
>
> To address the above issue, vstimecmp CSR must be set to -1UL over
> here when VCPU is scheduled-out or exits to user space.
>
> Reviewed-by: Atish Patra <atishp@rivosinc.com>
> Tested-by: Atish Patra <atishp@rivosinc.com>
> Tested-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
> Fixes: 8f5cb44b1bae ("RISC-V: KVM: Support sstc extension")
> Fixes: cea8896bd936 ("RISC-V: KVM: Fix kvm_riscv_vcpu_timer_pending() for Sstc")
> Reported-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
> Closes: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2112578
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>   arch/riscv/kvm/vcpu_timer.c | 16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
>
> diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
> index ff672fa71fcc..85a7262115e1 100644
> --- a/arch/riscv/kvm/vcpu_timer.c
> +++ b/arch/riscv/kvm/vcpu_timer.c
> @@ -345,8 +345,24 @@ void kvm_riscv_vcpu_timer_save(struct kvm_vcpu *vcpu)
>   	/*
>   	 * The vstimecmp CSRs are saved by kvm_riscv_vcpu_timer_sync()
>   	 * upon every VM exit so no need to save here.
> +	 *
> +	 * If VS-timer expires when no VCPU running on a host CPU then
> +	 * WFI executed by such host CPU will be effective NOP resulting
> +	 * in no power savings. This is because as-per RISC-V Privileged
> +	 * specificaiton: "WFI is also required to resume execution for
> +	 * locally enabled interrupts pending at any privilege level,
> +	 * regardless of the global interrupt enable at each privilege
> +	 * level."
> +	 *
> +	 * To address the above issue, vstimecmp CSR must be set to -1UL
> +	 * over here when VCPU is scheduled-out or exits to user space.
>   	 */
>   
> +	csr_write(CSR_VSTIMECMP, -1UL);
> +#if defined(CONFIG_32BIT)
> +	csr_write(CSR_VSTIMECMPH, -1UL);
> +#endif
> +
>   	/* timer should be enabled for the remaining operations */
>   	if (unlikely(!t->init_done))
>   		return;

Reviewed-by: Nutty Liu<liujingqi@lanxincomputing.com>

Thanks,
Nutty

