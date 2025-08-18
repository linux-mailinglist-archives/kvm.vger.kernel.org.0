Return-Path: <kvm+bounces-54871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 63B86B29A99
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 09:14:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6BE4179606
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 07:12:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3217278E7E;
	Mon, 18 Aug 2025 07:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.spacemit.com header.i=@linux.spacemit.com header.b="l9qdOH6S"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE9027877F
	for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 07:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755501144; cv=none; b=IuW17gzddbD++hZgws+Hq40z1AwQdzUslAD6NI1qkJAeW3LC+p0sZrvT8oD+fakK65HGeDhswmFJyZd+eb+YK56BLf8TkYFgDCzyNt9HfBO5Iigm/1hJ5LM+UH/Z/WEuk881vK4XaeU6W0Vn1i/zXr59gOxrP/oicMy96DCKwRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755501144; c=relaxed/simple;
	bh=16BbQFcv29+6Uk4By1bC4nzIcQZgln+mYt1XP6RjV/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hxCMmry3GUzPzRB6h5Gu42ldNuMsReyzApLnSE3Unt5DK6xsiIsTjoyDMeHoD4g4fuhnEDYC07xn7xrpcCAdhMi5fbbCDvl6inSaWEzTHKquTBRLOW36ZkJvC7rzHKCsaoUlwyLgVkf7PP1Nf69T79iwFJNT6VHh+JUUPPvw4CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.spacemit.com; spf=none smtp.mailfrom=linux.spacemit.com; dkim=pass (1024-bit key) header.d=linux.spacemit.com header.i=@linux.spacemit.com header.b=l9qdOH6S; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.spacemit.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.spacemit.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.spacemit.com;
	s=mxsw2412; t=1755501033;
	bh=DIyLi8TReoN+5AF3jvUXWckVHC2MAP2cCVjZaPo6GQw=;
	h=Date:From:To:Subject:Message-ID:MIME-Version;
	b=l9qdOH6SuVBnYSZj+wjxhn+mvv9XN/PmDpQhQAMuNdM5hmG0h5t3vvtwMW+1zoWG5
	 Yib/VO077FBPGrtxgZQPyc0aPqSc9Hg7cqAR8s/6fqWF1dNsmW1FIM10jju4bLs3pB
	 rQiiOdhiP/WuA3gsrbZXNFkjpoI5MoedclxU+OkU=
X-QQ-mid: esmtpsz16t1755501030t18f06d0f
X-QQ-Originating-IP: Yz02jh1oqjelU7qc2kAra1/3BSe5M9Cdk8a1P5ZaNVc=
Received: from = ( [14.123.254.114])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 18 Aug 2025 15:10:28 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 5468809535196601441
EX-QQ-RecipientCnt: 14
Date: Mon, 18 Aug 2025 15:10:28 +0800
From: Troy Mitchell <troy.mitchell@linux.spacemit.com>
To: fangyu.yu@linux.alibaba.com, anup@brainfault.org, atish.patra@linux.dev,
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	alex@ghiti.fr
Cc: guoren@linux.alibaba.com, guoren@kernel.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Troy Mitchell <troy.mitchell@linux.spacemit.com>
Subject: Re: [PATCH V2] RISC-V: KVM: Write hgatp register with valid mode bits
Message-ID: <BA652752F35145B4+aKLR5OHaYZ99CvHb@LT-Guozexi>
References: <20250818054207.21532-1-fangyu.yu@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250818054207.21532-1-fangyu.yu@linux.alibaba.com>
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:linux.spacemit.com:qybglogicsvrsz:qybglogicsvrsz3a-0
X-QQ-XMAILINFO: NDvHpYI+rUKoCcvanv+jDIBUFssVCvhhKrpqbR+7d71n1kdyxCazB81I
	PHlJuKUylrJszCDad1ILvaNCUFiIFycmNKJeLgHrJ3/T3942SSn+hPbANl+/gj7uIkysQX5
	i7XAOijoLUmoncqVX3ypNJ4Repj0/fU9vTAXsgsatAEkFL51tyM4P+G2jqu1EZYpreD7lT4
	mbP05gp4FYOd1pJX2NaFGi/nskN5TtF9K9O8qDtQiYQTA59wpFQ+HCi1K6fX2tmiUDS5cpi
	sZCmj8Un/r3vs6YA9ihA1sdT8kLh7GubiDMCYSc4merQM+YHNQudWeiwduZn4rbafwpJpeq
	I2UmxCbKnTMEochv69bI+unWe1A/cgfwxSUnl7o45T1W7lo9JR3kPZj16TxitxT8WUBqAKP
	+WNiU9XuG1KwTOKzb8dseSbzxfrDvhr69qT4p3Zjr7h7SXYSjBqe44saX8Ws3+L8zm+D7Q3
	qP+0u3ioynRIbswDzhoCJF/4qxo1N5E6C/6Ti5e9+Y+m8etr9hLcAdf9pwmU5LkJKLc03YM
	w5O0yva8ya4pJ45mGGld4qqcJYP11Q6NvdnJt+RRpYr4n35wU4ZJa2QlVyW9cGqyp0ywEG6
	T/3zKHZmJgik7DtKIpxkK0Q25HwUAcfuJVls0yxzH2P3rXgwSGii0gK3WebDaH7uq/f/eES
	gjVl/wQc4mAdjE/ztMAPhKM7nQ5tK5o02q2vv7q6SrSDO1vPcKlTdKbmCBgv7rztyRG39Am
	Q0K8DVVtnheX92tKb46zJ//zUyo5a/qZM9ug//inn+L+OTaHNKm0Aw8WZUhuykZ1DK397Tk
	TssYToPQFE3g96+ij+pHU+DoHuUaoXz2/Jt3N4QwfyCm58ijr4FVCrvQANcv44hVRBnoqwF
	ynMckF6iRSqPuIBxmk2Wd+PKno5tXlFKX7+Y1oB1o7xPaBFv9VQWwGPDxz3q1aerqVij/Op
	/SYwPgTmXPFu+JeAjHsVw4EJBBIHR/1l9t8bLsBySQCSKWcqOxScfeVsKtWy57sMGyOyRTN
	tDXxHZhE0II6z7OBJCAq98IZ2mW8eU0WyAZO7OgmMZlzZiUK3Ec3KrmuMBzzrQpMzTDqI1n
	8TLsK/rdFHbtYnx4IwZUjgmocXt8WGrsw==
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
X-QQ-RECHKSPAM: 0

On Mon, Aug 18, 2025 at 01:42:07PM +0800, fangyu.yu@linux.alibaba.com wrote:
> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> 
> According to the RISC-V Privileged Architecture Spec, when MODE=Bare
> is selected,software must write zero to the remaining fields of hgatp.
> 
> We have detected the valid mode supported by the HW before, So using a
> valid mode to detect how many vmid bits are supported.
> 
> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
With Fixed tag, feel free to add:

Reviewed-by: Troy Mitchell <troy.mitchell@linux.spacemit.com>
> 
> ---
> Changes in v2:
> - Fixed build error since kvm_riscv_gstage_mode() has been modified.
> ---
>  arch/riscv/kvm/vmid.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
> index 3b426c800480..5f33625f4070 100644
> --- a/arch/riscv/kvm/vmid.c
> +++ b/arch/riscv/kvm/vmid.c
> @@ -14,6 +14,7 @@
>  #include <linux/smp.h>
>  #include <linux/kvm_host.h>
>  #include <asm/csr.h>
> +#include <asm/kvm_mmu.h>
>  #include <asm/kvm_tlb.h>
>  #include <asm/kvm_vmid.h>
>  
> @@ -28,7 +29,7 @@ void __init kvm_riscv_gstage_vmid_detect(void)
>  
>  	/* Figure-out number of VMID bits in HW */
>  	old = csr_read(CSR_HGATP);
> -	csr_write(CSR_HGATP, old | HGATP_VMID);
> +	csr_write(CSR_HGATP, (kvm_riscv_gstage_mode << HGATP_MODE_SHIFT) | HGATP_VMID);
>  	vmid_bits = csr_read(CSR_HGATP);
>  	vmid_bits = (vmid_bits & HGATP_VMID) >> HGATP_VMID_SHIFT;
>  	vmid_bits = fls_long(vmid_bits);
> -- 
> 2.49.0
> 
> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

