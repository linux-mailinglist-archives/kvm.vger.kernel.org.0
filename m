Return-Path: <kvm+bounces-50049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EBDA1AE1850
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 11:52:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E2D1F189DA75
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 09:52:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B3BB27CCF0;
	Fri, 20 Jun 2025 09:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b="A1w8XwHK"
X-Original-To: kvm@vger.kernel.org
Received: from va-2-38.ptr.blmpb.com (va-2-38.ptr.blmpb.com [209.127.231.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D04522A
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 09:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750413116; cv=none; b=KtLLgqniIzvS/OK+VcI66gQL9Zs2Dk+dw8Xwb9qxnDy8nVuTbOg8eXEHpSp6OhJ0RcKQUIfHxTvyStl7eUYhhjLb/S5fGv49yX0hPmJ4fz10wqdr6IoN8TdhktYwdokZ23y2Z3tEVhbtsX5tEsQCkZGKSLHnv7zGQXvFTlebNyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750413116; c=relaxed/simple;
	bh=0fZ4iRaoH+9C+q9P15b02srqkt9Qo6k24PgGAazbP00=;
	h=Content-Type:To:In-Reply-To:Subject:Date:Message-Id:References:Cc:
	 From:Mime-Version; b=mFBxsY4h2Xrzeirj3XA8tdP7sI3UKdj5lFNp1apDdRdFSjUjxbxa5U+wsyGayik38O8LFYwkCWx1iNkY7Jn8F9LmS0kNbxNa8HLw6D1fQboSAS/qirr47SYthrjbH4XjUNhKwzTRfhNs5lf839Ytx8jgnagO+zhSbRwMLztn9Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com; spf=pass smtp.mailfrom=lanxincomputing.com; dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b=A1w8XwHK; arc=none smtp.client-ip=209.127.231.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lanxincomputing.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=lanxincomputing-com.20200927.dkim.feishu.cn; t=1750412410;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=DSXFLaHV+ytdpl3MS+800NYkToDbPrkHYChL5TyTBVY=;
 b=A1w8XwHKyXRXqXK0kiJJfA7qBwtdVqdy/pA72el2dkYJn6d+rFciZdMyDjceeek/Dw3MfZ
 zRD86STxKQ4YQpPzjJyeE57ILW/U07RINDFjTv+1eooJU34VGvBl8mZec+QPll/A3AX5Q7
 YlME64KyfkL2cuGKCUw10BPaZoMKTOL927tukSVh552zm8p4x6EP3HH938i7JEHxRQA1vV
 pLxM9YO+WJaNtn8V5ZRllSZVpk52UUrkEIS8q9NGZ2YV1isBwo00wqUmfdVXWL8LRq95Kz
 9M8uqkOwpRlGG/CPztZfGnYX+sZQaEUDzwc1+OOZNL4yY3wpC55GGDW6xDHLyg==
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
User-Agent: Mozilla Thunderbird
Received: from [127.0.0.1] ([180.165.3.105]) by smtp.feishu.cn with ESMTPS; Fri, 20 Jun 2025 17:40:07 +0800
To: <zhouquan@iscas.ac.cn>, <anup@brainfault.org>, <ajones@ventanamicro.com>, 
	<atishp@atishpatra.org>, <paul.walmsley@sifive.com>, 
	<palmer@dabbelt.com>
In-Reply-To: <e2a040c161f17c1717b64750e774474d8ee8f0d6.1750164414.git.zhouquan@iscas.ac.cn>
Content-Language: en-US
X-Original-From: Nutty Liu <liujingqi@lanxincomputing.com>
X-Lms-Return-Path: <lba+268552c78+6d0d87+vger.kernel.org+liujingqi@lanxincomputing.com>
Subject: Re: [PATCH 2/5] RISC-V: KVM: Allow Zicbop extension for Guest/VM
Date: Fri, 20 Jun 2025 17:40:06 +0800
Message-Id: <655ef636-704d-4a6d-9de7-5eb44282af42@lanxincomputing.com>
References: <cover.1750164414.git.zhouquan@iscas.ac.cn> <e2a040c161f17c1717b64750e774474d8ee8f0d6.1750164414.git.zhouquan@iscas.ac.cn>
Cc: <linux-kernel@vger.kernel.org>, <linux-riscv@lists.infradead.org>, 
	<kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>
From: "Nutty Liu" <liujingqi@lanxincomputing.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

On 6/17/2025 9:10 PM, zhouquan@iscas.ac.cn wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
>
> Extend the KVM ISA extension ONE_REG interface to allow KVM user space
> to detect and enable Zicbop extension for Guest/VM.
>
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> ---
>   arch/riscv/include/uapi/asm/kvm.h | 1 +
>   arch/riscv/kvm/vcpu_onereg.c      | 2 ++
>   2 files changed, 3 insertions(+)
>
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> index 0863ca178066..56959d277e86 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -185,6 +185,7 @@ enum KVM_RISCV_ISA_EXT_ID {
>   	KVM_RISCV_ISA_EXT_ZICCRSE,
>   	KVM_RISCV_ISA_EXT_ZAAMO,
>   	KVM_RISCV_ISA_EXT_ZALRSC,
> +	KVM_RISCV_ISA_EXT_ZICBOP,
>   	KVM_RISCV_ISA_EXT_MAX,
>   };
>   
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index b08a22eaa7a7..d444ec9e9e8e 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -68,6 +68,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
>   	KVM_ISA_EXT_ARR(ZFH),
>   	KVM_ISA_EXT_ARR(ZFHMIN),
>   	KVM_ISA_EXT_ARR(ZICBOM),
> +	KVM_ISA_EXT_ARR(ZICBOP),
>   	KVM_ISA_EXT_ARR(ZICBOZ),
>   	KVM_ISA_EXT_ARR(ZICCRSE),
>   	KVM_ISA_EXT_ARR(ZICNTR),
> @@ -171,6 +172,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
>   	case KVM_RISCV_ISA_EXT_ZFA:
>   	case KVM_RISCV_ISA_EXT_ZFH:
>   	case KVM_RISCV_ISA_EXT_ZFHMIN:
> +	case KVM_RISCV_ISA_EXT_ZICBOP:
>   	case KVM_RISCV_ISA_EXT_ZICCRSE:
>   	case KVM_RISCV_ISA_EXT_ZICNTR:
>   	case KVM_RISCV_ISA_EXT_ZICOND:

Seems 'RISCV_ISA_EXT_ZICBOP' should be declared in 'arch/riscv/include/asm/hwcap.h' ?
Otherwise,
Reviewed-by: Nutty Liu<liujingqi@lanxincomputing.com>

Thanks,
Nutty

