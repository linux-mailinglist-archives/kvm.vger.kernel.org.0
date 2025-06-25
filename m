Return-Path: <kvm+bounces-50627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EB14AE78D9
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 09:40:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 099A11891D72
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 07:40:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1601212FA0;
	Wed, 25 Jun 2025 07:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b="hbDZHriF"
X-Original-To: kvm@vger.kernel.org
Received: from sg-3-14.ptr.tlmpb.com (sg-3-14.ptr.tlmpb.com [101.45.255.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0010F72626
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 07:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750837161; cv=none; b=Mt4vkCEQOV40QQPA2mzcZLrLRrSqHlTfKavfTvsc7C0o6hTJfJU3kalwntd3msjta/z0LJWbMJvuZPXOTOUDprUbUx1xVPSg8ruuzJ71S/Uck7oTsH/g6Gno8tR2ruuMPZ3Z2jrNQxNj6zPomip3wqjeFpXWOg/PhSDq0vU09Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750837161; c=relaxed/simple;
	bh=KSsmILTl9vVaQUCL4Yo0ttl8WPUdCefpieSw3zzdAoM=;
	h=To:References:Cc:Subject:Content-Type:From:Message-Id:In-Reply-To:
	 Date:Mime-Version; b=nOJ6QDPDuHd2HTHiwplc6fQRR4UY/m5F6eDuaEHd5F7Kw5T3elEB/YiNQRy2l5y5KCDJp1MyzY5JXGjI/OY0nzBDg0GzcTdm2lYwcqXZ6sA1i2Cb4EUqUWrwbYDIpghM+IF/8oZusukWvBobJmFchElwYz9emzutM/tdjlVXHAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com; spf=pass smtp.mailfrom=lanxincomputing.com; dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b=hbDZHriF; arc=none smtp.client-ip=101.45.255.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lanxincomputing.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=lanxincomputing-com.20200927.dkim.feishu.cn; t=1750837147;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=VYCLNIDhFn58v6NVsiYfx2EHCtJBoqLZUjdlDct+nWU=;
 b=hbDZHriFQtJP3Kr/a7knKEcE8Ehxy3ZjTKmkGvu6zWogQMAYp+Qc6V3AKiG5wfB+dxrfPW
 ClH/moCwn0mDFCYZUK6Oma+66y7LXuxY5b0cn0i/yWLUZeOc6RMhXFoUtHj8/dzZNMALp7
 4uaq+39rK5QSGrpNKDrdK5rvnZC//7WHlcRsYaNwg4qrUiYfJSSz319pZKBoW7V6s3Zo5M
 awJZVx7Pzirap1QrZ+8kNLOUozbcf+j5+PCVMxAQ/snA+H2keDmQEQ7eH6IsDZwbp9fN37
 DKyPj1LqhduV2yJC3CpBOi8kNPGksAzLefkPhdJgdDaPZYWvVJlgXglQ/PCoug==
To: "Anup Patel" <apatel@ventanamicro.com>, 
	"Atish Patra" <atish.patra@linux.dev>
References: <20250618113532.471448-1-apatel@ventanamicro.com> <20250618113532.471448-7-apatel@ventanamicro.com>
User-Agent: Mozilla Thunderbird
Received: from [127.0.0.1] ([139.226.59.215]) by smtp.feishu.cn with ESMTPS; Wed, 25 Jun 2025 15:39:03 +0800
Cc: "Palmer Dabbelt" <palmer@dabbelt.com>, 
	"Paul Walmsley" <paul.walmsley@sifive.com>, 
	"Alexandre Ghiti" <alex@ghiti.fr>, 
	"Andrew Jones" <ajones@ventanamicro.com>, 
	"Anup Patel" <anup@brainfault.org>, <kvm@vger.kernel.org>, 
	<kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>, 
	<linux-kernel@vger.kernel.org>, "Atish Patra" <atishp@rivosinc.com>
Subject: Re: [PATCH v3 06/12] RISC-V: KVM: Implement kvm_arch_flush_remote_tlbs_range()
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
X-Lms-Return-Path: <lba+2685ba799+1d5941+vger.kernel.org+liujingqi@lanxincomputing.com>
From: "Nutty Liu" <liujingqi@lanxincomputing.com>
Message-Id: <87fda112-4ecd-4631-98be-da420aa59dd5@lanxincomputing.com>
Content-Transfer-Encoding: 7bit
In-Reply-To: <20250618113532.471448-7-apatel@ventanamicro.com>
Date: Wed, 25 Jun 2025 15:39:02 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Nutty Liu <liujingqi@lanxincomputing.com>

On 6/18/2025 7:35 PM, Anup Patel wrote:
> The kvm_arch_flush_remote_tlbs_range() expected by KVM core can be
> easily implemented for RISC-V using kvm_riscv_hfence_gvma_vmid_gpa()
> hence provide it.
>
> Also with kvm_arch_flush_remote_tlbs_range() available for RISC-V, the
> mmu_wp_memory_region() can happily use kvm_flush_remote_tlbs_memslot()
> instead of kvm_flush_remote_tlbs().
>
> Reviewed-by: Atish Patra <atishp@rivosinc.com>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>   arch/riscv/include/asm/kvm_host.h | 2 ++
>   arch/riscv/kvm/mmu.c              | 2 +-
>   arch/riscv/kvm/tlb.c              | 8 ++++++++
>   3 files changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index ff1f76d6f177..6162575e2177 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -43,6 +43,8 @@
>   	KVM_ARCH_REQ_FLAGS(5, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>   #define KVM_REQ_STEAL_UPDATE		KVM_ARCH_REQ(6)
>   
> +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
> +
>   #define KVM_HEDELEG_DEFAULT		(BIT(EXC_INST_MISALIGNED) | \
>   					 BIT(EXC_BREAKPOINT)      | \
>   					 BIT(EXC_SYSCALL)         | \
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 29f1bd853a66..a5387927a1c1 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -344,7 +344,7 @@ static void gstage_wp_memory_region(struct kvm *kvm, int slot)
>   	spin_lock(&kvm->mmu_lock);
>   	gstage_wp_range(kvm, start, end);
>   	spin_unlock(&kvm->mmu_lock);
> -	kvm_flush_remote_tlbs(kvm);
> +	kvm_flush_remote_tlbs_memslot(kvm, memslot);
>   }
>   
>   int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
> diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
> index da98ca801d31..f46a27658c2e 100644
> --- a/arch/riscv/kvm/tlb.c
> +++ b/arch/riscv/kvm/tlb.c
> @@ -403,3 +403,11 @@ void kvm_riscv_hfence_vvma_all(struct kvm *kvm,
>   	make_xfence_request(kvm, hbase, hmask, KVM_REQ_HFENCE_VVMA_ALL,
>   			    KVM_REQ_HFENCE_VVMA_ALL, NULL);
>   }
> +
> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 nr_pages)
> +{
> +	kvm_riscv_hfence_gvma_vmid_gpa(kvm, -1UL, 0,
> +				       gfn << PAGE_SHIFT, nr_pages << PAGE_SHIFT,
> +				       PAGE_SHIFT);
> +	return 0;
> +}

Reviewed-by: Nutty Liu <liujingqi@lanxincomputing.com>

Thanks,
Nutty

