Return-Path: <kvm+bounces-50052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 770FEAE1861
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 11:59:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F339B3AA63B
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 09:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 460F12836B0;
	Fri, 20 Jun 2025 09:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b="Km4FNtyV"
X-Original-To: kvm@vger.kernel.org
Received: from lf-1-17.ptr.blmpb.com (lf-1-17.ptr.blmpb.com [103.149.242.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE89280A27
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 09:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.149.242.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750413557; cv=none; b=hIpk2HKiUn6N87miAiLusqizd2kjdVdAYkCkfHtJAEUiIj+C/I+4p2y+aXA3kDLWTkzK4hVM+y8NgAQg7dkHn0rx4t2kptufxqjmGaqOXVW3rNJfs2QZFLF/g2+d6HVH6UVTm5Fm7ufHzaZ0M+hQ38MhgIlsoTGH+ultKT+0QpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750413557; c=relaxed/simple;
	bh=behs4AX21Izj48SjT6T4oG3pPpVVpt1LKhlwYqGqHbE=;
	h=In-Reply-To:To:From:Mime-Version:Subject:Message-Id:Cc:References:
	 Date:Content-Type; b=ujPSR3CXgIDqpB5VJD/FkCA6xs6E4d+IAlmZYJqqzmfPEovXw6raSH2Y0wQQEQrFEQMtGy8Zh0Iwn7Xpkz1y6f9DOvFQ68z4EhCF2QY/eg6oJkAIL9LYzSmbipFExjtV+j9FEYLBxdu5WVtQ+OS8+qMw56KBZNT6QVBqa7IdQ40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com; spf=pass smtp.mailfrom=lanxincomputing.com; dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b=Km4FNtyV; arc=none smtp.client-ip=103.149.242.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lanxincomputing.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=lanxincomputing-com.20200927.dkim.feishu.cn; t=1750413498;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=FVhWcbFwI9NYT8NXzHPcEd8gEtJB2JUO9bsshkN9xEc=;
 b=Km4FNtyVFfhKs2cnZKAq8JiccVO1YIzAr6CensXwObqAJYs27KLkXKu4J9fFX2Nq8UXuRr
 SscAwL6yrbl7vdo/9Q9+p6cKnTBIYdxVKStFP22WAQEPCyVPESFsncrfQ1JGi/usqoslbN
 9/DUAblAB9wsTBJeGRNLNwxLtowjgPgLyQ1WZIAhncOTzmKlZVm1/RXbwfKJx3CvON+KR+
 +BlKOmgtuAJH/uoBoPbxC7TkrtD1rgYipyu3Rwwh7+yZjgMjmXb6+hzs2jngQd9qpUXlQc
 ubNCar8kPU5uWBjxWEQjecC7VV4xFjhSLTRl7nUSNSZlr8QUl0ZmxmEFRAkBIQ==
X-Lms-Return-Path: <lba+2685530b8+2b57de+vger.kernel.org+liujingqi@lanxincomputing.com>
Content-Language: en-US
In-Reply-To: <3591f5aed544f9026d8375651936e006b57defdb.1750164414.git.zhouquan@iscas.ac.cn>
To: <zhouquan@iscas.ac.cn>, <anup@brainfault.org>, <ajones@ventanamicro.com>, 
	<atishp@atishpatra.org>, <paul.walmsley@sifive.com>, 
	<palmer@dabbelt.com>
From: "Nutty Liu" <liujingqi@lanxincomputing.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [PATCH 4/5] KVM: riscv: selftests: Add Zicbop extension to get-reg-list test
Message-Id: <ad888bc6-33c7-42d3-b5d1-be191dcded0e@lanxincomputing.com>
X-Original-From: Nutty Liu <liujingqi@lanxincomputing.com>
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>, <linux-riscv@lists.infradead.org>, 
	<kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>
References: <cover.1750164414.git.zhouquan@iscas.ac.cn> <3591f5aed544f9026d8375651936e006b57defdb.1750164414.git.zhouquan@iscas.ac.cn>
User-Agent: Mozilla Thunderbird
Date: Fri, 20 Jun 2025 17:58:13 +0800
Content-Type: text/plain; charset=UTF-8
Received: from [127.0.0.1] ([180.165.3.105]) by smtp.feishu.cn with ESMTPS; Fri, 20 Jun 2025 17:58:15 +0800

On 6/17/2025 9:10 PM, zhouquan@iscas.ac.cn wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
>
> The KVM RISC-V allows Zicbop extension for Guest/VM
> so add them to get-reg-list test.
>
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> ---
>   tools/testing/selftests/kvm/riscv/get-reg-list.c | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> index a0b7dabb5040..ebdc34b58bad 100644
> --- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> @@ -83,6 +83,7 @@ bool filter_reg(__u64 reg)
>   	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZFH:
>   	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZFHMIN:
>   	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICBOM:
> +	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICBOP:
>   	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICBOZ:
>   	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICCRSE:
>   	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICNTR:
> @@ -253,6 +254,8 @@ static const char *config_id_to_str(const char *prefix, __u64 id)
>   		return "KVM_REG_RISCV_CONFIG_REG(isa)";
>   	case KVM_REG_RISCV_CONFIG_REG(zicbom_block_size):
>   		return "KVM_REG_RISCV_CONFIG_REG(zicbom_block_size)";
> +	case KVM_REG_RISCV_CONFIG_REG(zicbop_block_size):
> +		return "KVM_REG_RISCV_CONFIG_REG(zicbop_block_size)";
>   	case KVM_REG_RISCV_CONFIG_REG(zicboz_block_size):
>   		return "KVM_REG_RISCV_CONFIG_REG(zicboz_block_size)";
>   	case KVM_REG_RISCV_CONFIG_REG(mvendorid):
> @@ -535,6 +538,7 @@ static const char *isa_ext_single_id_to_str(__u64 reg_off)
>   		KVM_ISA_EXT_ARR(ZFH),
>   		KVM_ISA_EXT_ARR(ZFHMIN),
>   		KVM_ISA_EXT_ARR(ZICBOM),
> +		KVM_ISA_EXT_ARR(ZICBOP),
>   		KVM_ISA_EXT_ARR(ZICBOZ),
>   		KVM_ISA_EXT_ARR(ZICCRSE),
>   		KVM_ISA_EXT_ARR(ZICNTR),
> @@ -864,6 +868,11 @@ static __u64 zicbom_regs[] = {
>   	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICBOM,
>   };
>   
> +static __u64 zicbop_regs[] = {
> +	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_CONFIG | KVM_REG_RISCV_CONFIG_REG(zicbop_block_size),
> +	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICBOP,
> +};
> +
>   static __u64 zicboz_regs[] = {
>   	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_CONFIG | KVM_REG_RISCV_CONFIG_REG(zicboz_block_size),
>   	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICBOZ,
> @@ -1012,6 +1021,8 @@ static __u64 vector_regs[] = {
>   	 .regs = sbi_sta_regs, .regs_n = ARRAY_SIZE(sbi_sta_regs),}
>   #define SUBLIST_ZICBOM \
>   	{"zicbom", .feature = KVM_RISCV_ISA_EXT_ZICBOM, .regs = zicbom_regs, .regs_n = ARRAY_SIZE(zicbom_regs),}
> +#define SUBLIST_ZICBOP \
> +	{"zicbop", .feature = KVM_RISCV_ISA_EXT_ZICBOP, .regs = zicbop_regs, .regs_n = ARRAY_SIZE(zicbop_regs),}
>   #define SUBLIST_ZICBOZ \
>   	{"zicboz", .feature = KVM_RISCV_ISA_EXT_ZICBOZ, .regs = zicboz_regs, .regs_n = ARRAY_SIZE(zicboz_regs),}
>   #define SUBLIST_AIA \
> @@ -1130,6 +1141,7 @@ KVM_ISA_EXT_SIMPLE_CONFIG(zfa, ZFA);
>   KVM_ISA_EXT_SIMPLE_CONFIG(zfh, ZFH);
>   KVM_ISA_EXT_SIMPLE_CONFIG(zfhmin, ZFHMIN);
>   KVM_ISA_EXT_SUBLIST_CONFIG(zicbom, ZICBOM);
> +KVM_ISA_EXT_SUBLIST_CONFIG(zicbop, ZICBOP);
>   KVM_ISA_EXT_SUBLIST_CONFIG(zicboz, ZICBOZ);
>   KVM_ISA_EXT_SIMPLE_CONFIG(ziccrse, ZICCRSE);
>   KVM_ISA_EXT_SIMPLE_CONFIG(zicntr, ZICNTR);
> @@ -1204,6 +1216,7 @@ struct vcpu_reg_list *vcpu_configs[] = {
>   	&config_zfh,
>   	&config_zfhmin,
>   	&config_zicbom,
> +	&config_zicbop,
>   	&config_zicboz,
>   	&config_ziccrse,
>   	&config_zicntr,

Reviewed-by: Nutty Liu<liujingqi@lanxincomputing.com>

Thanks,
Nutty

