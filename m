Return-Path: <kvm+bounces-50047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D78A0AE1846
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 11:51:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BFF9176E6F
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 09:51:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFE36284B2F;
	Fri, 20 Jun 2025 09:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b="ahss/Lio"
X-Original-To: kvm@vger.kernel.org
Received: from lf-1-16.ptr.blmpb.com (lf-1-16.ptr.blmpb.com [103.149.242.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B7C283C92
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 09:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.149.242.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750413035; cv=none; b=DHWI8wCMdLd2JEX+0E+Xaj4/bmgeFFvPqrgPpUGwn/Q+F24h4boZhccoIxQ/2bt0gRP/gz6N7JJUGv2ITaNyMRl1TJPi8fRyz3i4ATSAbzJgvKXnfrltDUbNgNFcgTqZUvisqnEcz4gtrV+b2Lqusv65kq++uT3tFVc0Cc6hMSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750413035; c=relaxed/simple;
	bh=VenEYCmf5+Cq+F3aAXFyGG+0DCgLJ/B+npgqLEJSSaY=;
	h=Mime-Version:Content-Type:Date:Message-Id:In-Reply-To:Subject:
	 References:To:Cc:From; b=qdp8E1PblP4uUkJE8QnAEkxEX4Vm9eQrIw2uQzfMbhJ62ITaksZtkogc3nJPItppqG117WGy92AeRY9Hcqq2O8XhuVjtSlM0f9BEfqFpZia/pKK3JlySvLl53qQYHTvqP09PvqGN35xBzKh2sv7TvMJZvkT37lnBgfYLmCcMUOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com; spf=pass smtp.mailfrom=lanxincomputing.com; dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b=ahss/Lio; arc=none smtp.client-ip=103.149.242.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lanxincomputing.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=lanxincomputing-com.20200927.dkim.feishu.cn; t=1750412979;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=RUHHvhpWyqtsBfoigWTcvYU+iHd7K6l5Yp1DjgDh7AU=;
 b=ahss/Lio4bMsKuefCMkJwlpMefSVD8gPXtmHvRyXbcDszSC7bouYBCIZ7fQr93OAEWZDWx
 tyDmQ9xx7xbkftZs0nW/bSFMccWTVrA9zn0hDUXai5Lj3V0uiqIFhofqVwaNFo/t2Hbwcq
 BmmrP5PpLwIhSivq4I8QpSabfYSQC6LxAOY1SO7n8uqE3pVozjY3pofWTadRDO8eq2Fxud
 8L05RyhYISrdlr90Q8X4K+d8zltgE7nMrwHusMlgBdVbc0P9P4ogx2vpI5sVC76T65omoj
 qsY0ubgG0/GTA606dKE+oVv+LWOG4yuzEt+875u0JWVfcyvZJz1UQswDlOtJFQ==
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: 7bit
Date: Fri, 20 Jun 2025 17:49:35 +0800
Message-Id: <e2b5fcd8-cb72-43ff-802a-57983880e377@lanxincomputing.com>
In-Reply-To: <effe218d368a37e397b6526f876b33322dbb6e20.1750164414.git.zhouquan@iscas.ac.cn>
X-Original-From: Nutty Liu <liujingqi@lanxincomputing.com>
Subject: Re: [PATCH 3/5] RISC-V: KVM: Allow bfloat16 extension for Guest/VM
X-Lms-Return-Path: <lba+268552eb1+4be682+vger.kernel.org+liujingqi@lanxincomputing.com>
Content-Language: en-US
Received: from [127.0.0.1] ([180.165.3.105]) by smtp.feishu.cn with ESMTPS; Fri, 20 Jun 2025 17:49:36 +0800
References: <cover.1750164414.git.zhouquan@iscas.ac.cn> <effe218d368a37e397b6526f876b33322dbb6e20.1750164414.git.zhouquan@iscas.ac.cn>
To: <zhouquan@iscas.ac.cn>, <anup@brainfault.org>, <ajones@ventanamicro.com>, 
	<atishp@atishpatra.org>, <paul.walmsley@sifive.com>, 
	<palmer@dabbelt.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-riscv@lists.infradead.org>, 
	<kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>
From: "Nutty Liu" <liujingqi@lanxincomputing.com>

On 6/17/2025 9:10 PM, zhouquan@iscas.ac.cn wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
>
> Extend the KVM ISA extension ONE_REG interface to allow KVM user space
> to detect and enable Zfbmin/Zvfbfmin/Zvfbfwma extension for Guest/VM.
>
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> ---
>   arch/riscv/include/uapi/asm/kvm.h | 3 +++
>   arch/riscv/kvm/vcpu_onereg.c      | 6 ++++++
>   2 files changed, 9 insertions(+)
>
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> index 56959d277e86..79a5ac86597c 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -186,6 +186,9 @@ enum KVM_RISCV_ISA_EXT_ID {
>   	KVM_RISCV_ISA_EXT_ZAAMO,
>   	KVM_RISCV_ISA_EXT_ZALRSC,
>   	KVM_RISCV_ISA_EXT_ZICBOP,
> +	KVM_RISCV_ISA_EXT_ZFBFMIN,
> +	KVM_RISCV_ISA_EXT_ZVFBFMIN,
> +	KVM_RISCV_ISA_EXT_ZVFBFWMA,
>   	KVM_RISCV_ISA_EXT_MAX,
>   };
>   
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index d444ec9e9e8e..2ba3f2c942ee 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -65,6 +65,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
>   	KVM_ISA_EXT_ARR(ZCF),
>   	KVM_ISA_EXT_ARR(ZCMOP),
>   	KVM_ISA_EXT_ARR(ZFA),
> +	KVM_ISA_EXT_ARR(ZFBFMIN),
>   	KVM_ISA_EXT_ARR(ZFH),
>   	KVM_ISA_EXT_ARR(ZFHMIN),
>   	KVM_ISA_EXT_ARR(ZICBOM),
> @@ -89,6 +90,8 @@ static const unsigned long kvm_isa_ext_arr[] = {
>   	KVM_ISA_EXT_ARR(ZTSO),
>   	KVM_ISA_EXT_ARR(ZVBB),
>   	KVM_ISA_EXT_ARR(ZVBC),
> +	KVM_ISA_EXT_ARR(ZVFBFMIN),
> +	KVM_ISA_EXT_ARR(ZVFBFWMA),
>   	KVM_ISA_EXT_ARR(ZVFH),
>   	KVM_ISA_EXT_ARR(ZVFHMIN),
>   	KVM_ISA_EXT_ARR(ZVKB),
> @@ -170,6 +173,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
>   	case KVM_RISCV_ISA_EXT_ZCF:
>   	case KVM_RISCV_ISA_EXT_ZCMOP:
>   	case KVM_RISCV_ISA_EXT_ZFA:
> +	case KVM_RISCV_ISA_EXT_ZFBFMIN:
>   	case KVM_RISCV_ISA_EXT_ZFH:
>   	case KVM_RISCV_ISA_EXT_ZFHMIN:
>   	case KVM_RISCV_ISA_EXT_ZICBOP:
> @@ -192,6 +196,8 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
>   	case KVM_RISCV_ISA_EXT_ZTSO:
>   	case KVM_RISCV_ISA_EXT_ZVBB:
>   	case KVM_RISCV_ISA_EXT_ZVBC:
> +	case KVM_RISCV_ISA_EXT_ZVFBFMIN:
> +	case KVM_RISCV_ISA_EXT_ZVFBFWMA:
>   	case KVM_RISCV_ISA_EXT_ZVFH:
>   	case KVM_RISCV_ISA_EXT_ZVFHMIN:
>   	case KVM_RISCV_ISA_EXT_ZVKB:

Reviewed-by: Nutty Liu<liujingqi@lanxincomputing.com>

Thanks,
Nutty

