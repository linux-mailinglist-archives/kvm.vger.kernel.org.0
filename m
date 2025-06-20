Return-Path: <kvm+bounces-50048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 79CD1AE184D
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 11:51:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B0B0E1BC5ECF
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 09:51:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7BE1285042;
	Fri, 20 Jun 2025 09:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b="AF1ceC70"
X-Original-To: kvm@vger.kernel.org
Received: from sg-1-21.ptr.blmpb.com (sg-1-21.ptr.blmpb.com [118.26.132.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD25B283C8D
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 09:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750413036; cv=none; b=Euz8KXrMQOLOMSd33mCiGmlv2kEuPNo7cSTfaJ8hx/qMr/2VLtoLRNuMt+7qI5to1IAvd7lOQghApt0fMsdtHuMAfknnOaAf0+40eEuRyzDkpXakY20qfgNKkG7anzssmXkBsi+o7CsJXWXXAhia7+86hoesAQq9PHeVJCG4nAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750413036; c=relaxed/simple;
	bh=wojTjQClLQ48UTC77W0gkindItOoWRV1+r38k6nb3Yc=;
	h=From:Mime-Version:Content-Type:To:Cc:Message-Id:References:
	 Subject:Date:In-Reply-To; b=IoyRCT4sqnME+8J0NTLGg3VB8vmmbxExZ8I5mRKJ4P6R08iT/sJNm1WXpjRt127xtFrpzJpM51nMtu10czXOBHwoBCCYX1iJYz8XOTsKBZ3/O6DyXMHKI99icWSjYAjF8rLjkxODjMJ3OhHzhuC/vg1gvBBFTGH6/svqQ9IJO34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com; spf=pass smtp.mailfrom=lanxincomputing.com; dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b=AF1ceC70; arc=none smtp.client-ip=118.26.132.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lanxincomputing.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=lanxincomputing-com.20200927.dkim.feishu.cn; t=1750412220;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=oeXxAIqzohSWPmedTEZHs1J1ce2tPrIZS+IBTNkDcr8=;
 b=AF1ceC70Y+GV1+D5xXqF8udpzakQZUwAaNT0se6YcyniphkrwbqLYF07pg7LFWVsj6AXhn
 ucJsWNwhk0Pc2leTiU3TP4ZBO0g4f+bhz/5VpimV1wsuuPGV6k2pz9hDJGEoxrE7C7mDpo
 iBduWSrtu80KrA7BPBWMls5kAbnv8Md5ytYL/Jwu2SSRatUNpYL7ykWF4yEIdpdxAaQx/Q
 nVP91BdtnmUaNCozzGXNhqk3byAgjosMXepeX01JU7vEDOugHXFNEn50O1VHKIXNsR5YNo
 bOSZBeeGmtEeFPk5krB62IYteWYdUdyYO7h6qi2K/Bc48uRVg7XsYRo0eBo80w==
From: "Nutty Liu" <liujingqi@lanxincomputing.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Received: from [127.0.0.1] ([180.165.3.105]) by smtp.feishu.cn with ESMTPS; Fri, 20 Jun 2025 17:36:57 +0800
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+268552bba+7b8ac4+vger.kernel.org+liujingqi@lanxincomputing.com>
To: <zhouquan@iscas.ac.cn>, <anup@brainfault.org>, <ajones@ventanamicro.com>, 
	<atishp@atishpatra.org>, <paul.walmsley@sifive.com>, 
	<palmer@dabbelt.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-riscv@lists.infradead.org>, 
	<kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>
Message-Id: <193a6972-2498-4661-8b76-4303819ca0b2@lanxincomputing.com>
Content-Language: en-US
X-Original-From: Nutty Liu <liujingqi@lanxincomputing.com>
References: <cover.1750164414.git.zhouquan@iscas.ac.cn> <553bacc4f66e815975bb8ee0e4696397407b0a82.1750164414.git.zhouquan@iscas.ac.cn>
Subject: Re: [PATCH 1/5] RISC-V: KVM: Provide UAPI for Zicbop block size
Date: Fri, 20 Jun 2025 17:36:55 +0800
In-Reply-To: <553bacc4f66e815975bb8ee0e4696397407b0a82.1750164414.git.zhouquan@iscas.ac.cn>

On 6/17/2025 9:10 PM, zhouquan@iscas.ac.cn wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
>
> We're about to allow guests to use the Zicbop extension.
> KVM userspace needs to know the cache block size in order to
> properly advertise it to the guest. Provide a virtual config
> register for userspace to get it with the GET_ONE_REG API, but
> setting it cannot be supported, so disallow SET_ONE_REG.
>
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> ---
>   arch/riscv/include/uapi/asm/kvm.h |  1 +
>   arch/riscv/kvm/vcpu_onereg.c      | 11 +++++++++++
>   2 files changed, 12 insertions(+)
>
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> index 5f59fd226cc5..0863ca178066 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -55,6 +55,7 @@ struct kvm_riscv_config {
>   	unsigned long mimpid;
>   	unsigned long zicboz_block_size;
>   	unsigned long satp_mode;
> +	unsigned long zicbop_block_size;
>   };
>   
>   /* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index 2e1b646f0d61..b08a22eaa7a7 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -256,6 +256,11 @@ static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
>   			return -ENOENT;
>   		reg_val = riscv_cboz_block_size;
>   		break;
> +	case KVM_REG_RISCV_CONFIG_REG(zicbop_block_size):
> +		if (!riscv_isa_extension_available(vcpu->arch.isa, ZICBOP))
> +			return -ENOENT;
> +		reg_val = riscv_cbop_block_size;
> +		break;
>   	case KVM_REG_RISCV_CONFIG_REG(mvendorid):
>   		reg_val = vcpu->arch.mvendorid;
>   		break;
> @@ -347,6 +352,12 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
>   		if (reg_val != riscv_cboz_block_size)
>   			return -EINVAL;
>   		break;
> +	case KVM_REG_RISCV_CONFIG_REG(zicbop_block_size):
> +		if (!riscv_isa_extension_available(vcpu->arch.isa, ZICBOP))
> +			return -ENOENT;
> +		if (reg_val != riscv_cbop_block_size)

Seems "riscv_cbop_block_size" has not been declared.
Otherwise,
Reviewed-by: Nutty Liu<liujingqi@lanxincomputing.com>

Thanks,
Nutty

> +			return -EINVAL;
> +		break;
>   	case KVM_REG_RISCV_CONFIG_REG(mvendorid):
>   		if (reg_val == vcpu->arch.mvendorid)
>   			break;

