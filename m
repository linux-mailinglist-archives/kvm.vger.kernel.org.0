Return-Path: <kvm+bounces-50619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B275AE777F
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 08:51:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8ECB4A090D
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 06:51:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C51701FBCB5;
	Wed, 25 Jun 2025 06:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b="kdTrRPX7"
X-Original-To: kvm@vger.kernel.org
Received: from sg-3-18.ptr.tlmpb.com (sg-3-18.ptr.tlmpb.com [101.45.255.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E035A1F55FA
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 06:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750834236; cv=none; b=SPlwISK4pF8SPn5eKVPWKRZAo9UoUYQm7V8lfAtFNfQiMcmVmSftr1DljH0V9V3T6ANLcsEm5vm0vXcobRr/p4xSnPpkV9dWzu97bJ+P78pCtk484IqYELx5yD5Nr0FJBtdV619T8p9qX0pl5/jlHEKmiGh7s1Bv6Jqa/CER7vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750834236; c=relaxed/simple;
	bh=XlABoUydV0sy1H6M2rnUHztx2btJk/yKOHYY5NcuhAA=;
	h=To:In-Reply-To:Date:Mime-Version:References:Content-Type:Cc:From:
	 Message-Id:Subject; b=Z9bBxfJQFMqvvk6TAUPzAXOYkCOHMXVN+rCABXw6B5QLu9nndgl5Ljx8jhvnKe4j/KDO+4XbXMb/FA6nu07kN5ietWnl/jLgGxNzfuf12/G2egq81jRArProEbie4H+e5LVLAM61Al/OOVhYw54MWRNkl0iVLRfxkRJBlAI+6mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com; spf=pass smtp.mailfrom=lanxincomputing.com; dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b=kdTrRPX7; arc=none smtp.client-ip=101.45.255.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lanxincomputing.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=lanxincomputing-com.20200927.dkim.feishu.cn; t=1750834215;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Ik8c1hqRgYzer5tdkB7JgwAmNHMzAh0ECFwpDRHcshI=;
 b=kdTrRPX7l9jj9wagONaE8JwGbAVw8enUSWAQSkl7lDA8lxd78m/5OuG4axM5IYSWMgktYV
 lObLN8+E7Qz0nCRFYd8swpsUsZRfC2MEfDOHXzj86lsqjaR0jafwOJ1daZ7KRlyTRPhnlB
 RExAo/pHkOCUpcle/Pr0G16SUjhpPFrofZTotrfTABjA3q+H8sMZzq08IWSMTZnokLF1dR
 b5OepAA5vx/S7HlgKSMCCMJt2VkSSCXTUuCgEcvCsxCxvwIGSnmed4aaFOSMaq8hkQKjNJ
 oJropYL0TKhPhjU2q5JWlJkFBtWuDJC2gjdbYcIQu2hJWJQc+WfBAPO0byqCJA==
To: "Anup Patel" <apatel@ventanamicro.com>, 
	"Atish Patra" <atish.patra@linux.dev>
In-Reply-To: <20250618113532.471448-3-apatel@ventanamicro.com>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Date: Wed, 25 Jun 2025 14:50:10 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250618113532.471448-1-apatel@ventanamicro.com> <20250618113532.471448-3-apatel@ventanamicro.com>
Received: from [127.0.0.1] ([139.226.59.215]) by smtp.feishu.cn with ESMTPS; Wed, 25 Jun 2025 14:50:12 +0800
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+2685b9c25+f9787f+vger.kernel.org+liujingqi@lanxincomputing.com>
Cc: "Palmer Dabbelt" <palmer@dabbelt.com>, 
	"Paul Walmsley" <paul.walmsley@sifive.com>, 
	"Alexandre Ghiti" <alex@ghiti.fr>, 
	"Andrew Jones" <ajones@ventanamicro.com>, 
	"Anup Patel" <anup@brainfault.org>, <kvm@vger.kernel.org>, 
	<kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>, 
	<linux-kernel@vger.kernel.org>
From: "Nutty Liu" <liujingqi@lanxincomputing.com>
Message-Id: <44722ec6-b08c-40bd-a612-40d723985aa3@lanxincomputing.com>
Subject: Re: [PATCH v3 02/12] RISC-V: KVM: Drop the return value of kvm_riscv_vcpu_aia_init()
User-Agent: Mozilla Thunderbird
X-Original-From: Nutty Liu <liujingqi@lanxincomputing.com>

On 6/18/2025 7:35 PM, Anup Patel wrote:
> The kvm_riscv_vcpu_aia_init() does not return any failure so drop
> the return value which is always zero.
>
> Reviewed-by: Nutty Liu<liujingqi@lanxincomputing.com>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>   arch/riscv/include/asm/kvm_aia.h | 2 +-
>   arch/riscv/kvm/aia_device.c      | 6 ++----
>   arch/riscv/kvm/vcpu.c            | 4 +---
>   3 files changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_aia.h b/arch/riscv/include/asm/kvm_aia.h
> index 3b643b9efc07..0a0f12496f00 100644
> --- a/arch/riscv/include/asm/kvm_aia.h
> +++ b/arch/riscv/include/asm/kvm_aia.h
> @@ -147,7 +147,7 @@ int kvm_riscv_vcpu_aia_rmw_ireg(struct kvm_vcpu *vcpu, unsigned int csr_num,
>   
>   int kvm_riscv_vcpu_aia_update(struct kvm_vcpu *vcpu);
>   void kvm_riscv_vcpu_aia_reset(struct kvm_vcpu *vcpu);
> -int kvm_riscv_vcpu_aia_init(struct kvm_vcpu *vcpu);
> +void kvm_riscv_vcpu_aia_init(struct kvm_vcpu *vcpu);
>   void kvm_riscv_vcpu_aia_deinit(struct kvm_vcpu *vcpu);
>   
>   int kvm_riscv_aia_inject_msi_by_id(struct kvm *kvm, u32 hart_index,
> diff --git a/arch/riscv/kvm/aia_device.c b/arch/riscv/kvm/aia_device.c
> index 806c41931cde..b195a93add1c 100644
> --- a/arch/riscv/kvm/aia_device.c
> +++ b/arch/riscv/kvm/aia_device.c
> @@ -509,12 +509,12 @@ void kvm_riscv_vcpu_aia_reset(struct kvm_vcpu *vcpu)
>   	kvm_riscv_vcpu_aia_imsic_reset(vcpu);
>   }
>   
> -int kvm_riscv_vcpu_aia_init(struct kvm_vcpu *vcpu)
> +void kvm_riscv_vcpu_aia_init(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_vcpu_aia *vaia = &vcpu->arch.aia_context;
>   
>   	if (!kvm_riscv_aia_available())
> -		return 0;
> +		return;
>   
>   	/*
>   	 * We don't do any memory allocations over here because these
> @@ -526,8 +526,6 @@ int kvm_riscv_vcpu_aia_init(struct kvm_vcpu *vcpu)
>   	/* Initialize default values in AIA vcpu context */
>   	vaia->imsic_addr = KVM_RISCV_AIA_UNDEF_ADDR;
>   	vaia->hart_index = vcpu->vcpu_idx;
> -
> -	return 0;
>   }
>   
>   void kvm_riscv_vcpu_aia_deinit(struct kvm_vcpu *vcpu)
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index b467dc1f4c7f..f9fb3dbbe0c3 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -159,9 +159,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>   	kvm_riscv_vcpu_pmu_init(vcpu);
>   
>   	/* Setup VCPU AIA */
> -	rc = kvm_riscv_vcpu_aia_init(vcpu);
> -	if (rc)
> -		return rc;
> +	kvm_riscv_vcpu_aia_init(vcpu);
>   
>   	/*
>   	 * Setup SBI extensions

Reviewed-by: Nutty Liu<liujingqi@lanxincomputing.com>

Thanks,
Nutty

