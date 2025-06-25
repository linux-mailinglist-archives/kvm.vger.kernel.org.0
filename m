Return-Path: <kvm+bounces-50626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C1009AE78CF
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 09:39:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 73053189E324
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 07:39:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38E0920B81D;
	Wed, 25 Jun 2025 07:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b="USqBzc7s"
X-Original-To: kvm@vger.kernel.org
Received: from sg-3-17.ptr.tlmpb.com (sg-3-17.ptr.tlmpb.com [101.45.255.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBA51DFD86
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 07:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750837113; cv=none; b=FZM+qjRs4TAnN1zzvqfEDboHFvoE9RNxyNO/h+wp/yz+q5ieXc6H9dudOXmOewrSPs0KuZSZdCzF5+qVaw6dsJ1R5CKY+hxTAdp2MLPwFLHAjVUkVNaC2a8vAb0GORd51qeMSEwItAnPC/P6q9N8bceTQn/aq6Vxzz4SbGBiiBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750837113; c=relaxed/simple;
	bh=SnMkTEfPjKinQQUJ9SjEb/GZPamQROt4gk0GU0pFhvY=;
	h=Cc:In-Reply-To:References:Content-Type:To:Subject:Date:Message-Id:
	 From:Mime-Version; b=kxhYYRtxpLZ713SpEJWWvXgFBGBI+ioI3RWTpMdLmeCjFzkWnu7F6HCc7/w9q1Eshe9KCLO155zspkA3WkmxrbDXjvPVhV39Cgq/r9ZWpkFtlrGCSBLK3QbsNOp1sWljTOauOpGNFFLZjGcTk8KV4qiFPAkjpq6RozUuF/wN2WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com; spf=pass smtp.mailfrom=lanxincomputing.com; dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b=USqBzc7s; arc=none smtp.client-ip=101.45.255.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lanxincomputing.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=lanxincomputing-com.20200927.dkim.feishu.cn; t=1750837105;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=23blSFdrb8/fbPehCaYr2JhyqpZwpwwsJFLPuTL/tn4=;
 b=USqBzc7sxYVUbueSjJ/yzfbbkLm/Z/zcL6hJVpmKZ1qWYj2gzVJiLmmAL5Y0kJ3PLDTfgy
 6c4hvJQs5X2UMuAC54IeoJii2QDymw04t0g0rrHlup/f+lw80S5z1kCW8ZbR7ovHy1O/j1
 8iE9liV1XQcqSs/rU3/kp+gUB1FiWgjr1DSX0+4mrHaOKB1uZIMTEt4vVRgL54icSELKX4
 yBquXc3a3uevZc7x4u0uTsc3CltsYSaRHBSGEeSWlOD2i5m0yoJTsXBvUPm+vQeZqYPsCT
 wOhGIKsm3iFa8mRjI0NuXAuf/uN/w2UGZaOj5Fyl6BdEYlAfAG7BuUSGkeBXKg==
Cc: "Palmer Dabbelt" <palmer@dabbelt.com>, 
	"Paul Walmsley" <paul.walmsley@sifive.com>, 
	"Alexandre Ghiti" <alex@ghiti.fr>, 
	"Andrew Jones" <ajones@ventanamicro.com>, 
	"Anup Patel" <anup@brainfault.org>, <kvm@vger.kernel.org>, 
	<kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>, 
	<linux-kernel@vger.kernel.org>, "Atish Patra" <atishp@rivosinc.com>
In-Reply-To: <20250618113532.471448-6-apatel@ventanamicro.com>
References: <20250618113532.471448-1-apatel@ventanamicro.com> <20250618113532.471448-6-apatel@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: "Anup Patel" <apatel@ventanamicro.com>, 
	"Atish Patra" <atish.patra@linux.dev>
Subject: Re: [PATCH v3 05/12] RISC-V: KVM: Don't flush TLB when PTE is unchanged
Date: Wed, 25 Jun 2025 15:38:20 +0800
Message-Id: <adb4afad-19a1-404d-bec0-d0dc535d98c4@lanxincomputing.com>
User-Agent: Mozilla Thunderbird
X-Original-From: Nutty Liu <liujingqi@lanxincomputing.com>
X-Lms-Return-Path: <lba+2685ba76e+9d6ce5+vger.kernel.org+liujingqi@lanxincomputing.com>
From: "Nutty Liu" <liujingqi@lanxincomputing.com>
Content-Language: en-US
Received: from [127.0.0.1] ([139.226.59.215]) by smtp.feishu.cn with ESMTPS; Wed, 25 Jun 2025 15:38:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

On 6/18/2025 7:35 PM, Anup Patel wrote:
> The gstage_set_pte() and gstage_op_pte() should flush TLB only when
> a leaf PTE changes so that unnecessary TLB flushes can be avoided.
>
> Reviewed-by: Atish Patra <atishp@rivosinc.com>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>   arch/riscv/kvm/mmu.c | 14 +++++++++-----
>   1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 1087ea74567b..29f1bd853a66 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -167,9 +167,11 @@ static int gstage_set_pte(struct kvm *kvm, u32 level,
>   		ptep = &next_ptep[gstage_pte_index(addr, current_level)];
>   	}
>   
> -	set_pte(ptep, *new_pte);
> -	if (gstage_pte_leaf(ptep))
> -		gstage_remote_tlb_flush(kvm, current_level, addr);
> +	if (pte_val(*ptep) != pte_val(*new_pte)) {
> +		set_pte(ptep, *new_pte);
> +		if (gstage_pte_leaf(ptep))
> +			gstage_remote_tlb_flush(kvm, current_level, addr);
> +	}
>   
>   	return 0;
>   }
> @@ -229,7 +231,7 @@ static void gstage_op_pte(struct kvm *kvm, gpa_t addr,
>   			  pte_t *ptep, u32 ptep_level, enum gstage_op op)
>   {
>   	int i, ret;
> -	pte_t *next_ptep;
> +	pte_t old_pte, *next_ptep;
>   	u32 next_ptep_level;
>   	unsigned long next_page_size, page_size;
>   
> @@ -258,11 +260,13 @@ static void gstage_op_pte(struct kvm *kvm, gpa_t addr,
>   		if (op == GSTAGE_OP_CLEAR)
>   			put_page(virt_to_page(next_ptep));
>   	} else {
> +		old_pte = *ptep;
>   		if (op == GSTAGE_OP_CLEAR)
>   			set_pte(ptep, __pte(0));
>   		else if (op == GSTAGE_OP_WP)
>   			set_pte(ptep, __pte(pte_val(ptep_get(ptep)) & ~_PAGE_WRITE));
> -		gstage_remote_tlb_flush(kvm, ptep_level, addr);
> +		if (pte_val(*ptep) != pte_val(old_pte))
> +			gstage_remote_tlb_flush(kvm, ptep_level, addr);
>   	}
>   }
>   

Reviewed-by: Nutty Liu <liujingqi@lanxincomputing.com>

Thanks,
Nutty

