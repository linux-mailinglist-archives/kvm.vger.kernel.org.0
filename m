Return-Path: <kvm+bounces-50051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 05C8AAE185D
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 11:59:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9DAA84A1394
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 09:59:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C23D2280A35;
	Fri, 20 Jun 2025 09:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b="Yeyt9eQC"
X-Original-To: kvm@vger.kernel.org
Received: from sg-3-14.ptr.tlmpb.com (sg-3-14.ptr.tlmpb.com [101.45.255.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2472C280A27
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 09:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750413532; cv=none; b=a8h+iJ0BrP0PpDOJpIDtz6Bu7RzXGnebVRS2YmDF7prPelnH8aMlegQotxfrSn6DRBm8h4hcgzVTHNQ7qT5SI5Ke6xDF0wg2K/vzoCQkPhAGjhAcg9IfRk/TYiZCwsKkNYCaYQMxjprD0KUfBH6xB1NRdAGL12o9AEecLAb91OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750413532; c=relaxed/simple;
	bh=rKaljkqEUrjUUYISCTJvN0+VAGfaDFBRT5j3tv3rmRA=;
	h=Message-Id:Content-Type:In-Reply-To:Subject:Date:References:To:Cc:
	 From:Mime-Version; b=p4wr+qB58CXPEXBKT/WY0plxKBcy/+aa0Ht9FK+uEqSvNdGO+rmEpZFgBuZcGIDMB0FgdOgRL1DFDBL3aoBnedXC7t+KBs10nUEq4z6NeOGQ3RBGI1CQzEdze6vjjkO5ybupJ+Vd0yTnoRKdlqZ9pzfjqPBWu8I1QY/h+cvvHXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com; spf=pass smtp.mailfrom=lanxincomputing.com; dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b=Yeyt9eQC; arc=none smtp.client-ip=101.45.255.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lanxincomputing.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=lanxincomputing-com.20200927.dkim.feishu.cn; t=1750413523;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=lva+y9NB39YGFOB+2A2HkG7HC06lS3LbJWgBT7uypq8=;
 b=Yeyt9eQCUIPOIMBgdiTlkn39j5upI7p97RnORCsqR3eq1k4XsnU5SMeULErSGmHZ606uAS
 6wIjfQ3Vt1Yme4fclC/oHjfUQK/2wtd6WpyQuXvuptrGS3BYNfHDD7ut3HynILEmzTT/1T
 rrnYyqUxwWx0gI2HqhG1qsRIe/533Cvd36qzwiymqHd3jwUMp58SkO6zqJ/SAKChpGQL4F
 c7gXZp0jLjUn2bORe3+IV5R2t50OQwMyuDsg7mVslvHUJye7bdQhFmQ4WS2jaSL/F1v6HV
 ED9JqaK8TCk+w/66wOS1hSfLGWGsJW17KqZLJ2BwleuG7fS30iMZqAz9YZcABw==
Message-Id: <2acb706f-fb20-45ef-a8c8-762e193ca548@lanxincomputing.com>
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <65752029ed1ae331a9ac867a6fef2e63a797569e.1750164414.git.zhouquan@iscas.ac.cn>
Content-Transfer-Encoding: 7bit
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+2685530d1+006e4f+vger.kernel.org+liujingqi@lanxincomputing.com>
Subject: Re: [PATCH 5/5] KVM: riscv: selftests: Add bfloat16 extension to get-reg-list test
Date: Fri, 20 Jun 2025 17:58:38 +0800
References: <cover.1750164414.git.zhouquan@iscas.ac.cn> <65752029ed1ae331a9ac867a6fef2e63a797569e.1750164414.git.zhouquan@iscas.ac.cn>
To: <zhouquan@iscas.ac.cn>, <anup@brainfault.org>, <ajones@ventanamicro.com>, 
	<atishp@atishpatra.org>, <paul.walmsley@sifive.com>, 
	<palmer@dabbelt.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-riscv@lists.infradead.org>, 
	<kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>
From: "Nutty Liu" <liujingqi@lanxincomputing.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [127.0.0.1] ([180.165.3.105]) by smtp.feishu.cn with ESMTPS; Fri, 20 Jun 2025 17:58:40 +0800
Content-Language: en-US
X-Original-From: Nutty Liu <liujingqi@lanxincomputing.com>

On 6/17/2025 9:10 PM, zhouquan@iscas.ac.cn wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
>
> The KVM RISC-V allows Zfbfmin/Zvfbfmin/Zvfbfwma extensions for Guest/VM
> so add them to get-reg-list test.
>
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> ---
>   tools/testing/selftests/kvm/riscv/get-reg-list.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> index ebdc34b58bad..e5a07e000b66 100644
> --- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> @@ -80,6 +80,7 @@ bool filter_reg(__u64 reg)
>   	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZCF:
>   	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZCMOP:
>   	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZFA:
> +	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZFBFMIN:
>   	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZFH:
>   	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZFHMIN:
>   	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICBOM:
> @@ -104,6 +105,8 @@ bool filter_reg(__u64 reg)
>   	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZTSO:
>   	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZVBB:
>   	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZVBC:
> +	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZVFBFMIN:
> +	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZVFBFWMA:
>   	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZVFH:
>   	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZVFHMIN:
>   	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZVKB:
> @@ -535,6 +538,7 @@ static const char *isa_ext_single_id_to_str(__u64 reg_off)
>   		KVM_ISA_EXT_ARR(ZCF),
>   		KVM_ISA_EXT_ARR(ZCMOP),
>   		KVM_ISA_EXT_ARR(ZFA),
> +		KVM_ISA_EXT_ARR(ZFBFMIN),
>   		KVM_ISA_EXT_ARR(ZFH),
>   		KVM_ISA_EXT_ARR(ZFHMIN),
>   		KVM_ISA_EXT_ARR(ZICBOM),
> @@ -559,6 +563,8 @@ static const char *isa_ext_single_id_to_str(__u64 reg_off)
>   		KVM_ISA_EXT_ARR(ZTSO),
>   		KVM_ISA_EXT_ARR(ZVBB),
>   		KVM_ISA_EXT_ARR(ZVBC),
> +		KVM_ISA_EXT_ARR(ZVFBFMIN),
> +		KVM_ISA_EXT_ARR(ZVFBFWMA),
>   		KVM_ISA_EXT_ARR(ZVFH),
>   		KVM_ISA_EXT_ARR(ZVFHMIN),
>   		KVM_ISA_EXT_ARR(ZVKB),
> @@ -1138,6 +1144,7 @@ KVM_ISA_EXT_SIMPLE_CONFIG(zcd, ZCD);
>   KVM_ISA_EXT_SIMPLE_CONFIG(zcf, ZCF);
>   KVM_ISA_EXT_SIMPLE_CONFIG(zcmop, ZCMOP);
>   KVM_ISA_EXT_SIMPLE_CONFIG(zfa, ZFA);
> +KVM_ISA_EXT_SIMPLE_CONFIG(zfbfmin, ZFBFMIN);
>   KVM_ISA_EXT_SIMPLE_CONFIG(zfh, ZFH);
>   KVM_ISA_EXT_SIMPLE_CONFIG(zfhmin, ZFHMIN);
>   KVM_ISA_EXT_SUBLIST_CONFIG(zicbom, ZICBOM);
> @@ -1162,6 +1169,8 @@ KVM_ISA_EXT_SIMPLE_CONFIG(zkt, ZKT);
>   KVM_ISA_EXT_SIMPLE_CONFIG(ztso, ZTSO);
>   KVM_ISA_EXT_SIMPLE_CONFIG(zvbb, ZVBB);
>   KVM_ISA_EXT_SIMPLE_CONFIG(zvbc, ZVBC);
> +KVM_ISA_EXT_SIMPLE_CONFIG(zvfbfmin, ZVFBFMIN);
> +KVM_ISA_EXT_SIMPLE_CONFIG(zvfbfwma, ZVFBFWMA);
>   KVM_ISA_EXT_SIMPLE_CONFIG(zvfh, ZVFH);
>   KVM_ISA_EXT_SIMPLE_CONFIG(zvfhmin, ZVFHMIN);
>   KVM_ISA_EXT_SIMPLE_CONFIG(zvkb, ZVKB);
> @@ -1213,6 +1222,7 @@ struct vcpu_reg_list *vcpu_configs[] = {
>   	&config_zcf,
>   	&config_zcmop,
>   	&config_zfa,
> +	&config_zfbfmin,
>   	&config_zfh,
>   	&config_zfhmin,
>   	&config_zicbom,
> @@ -1237,6 +1247,8 @@ struct vcpu_reg_list *vcpu_configs[] = {
>   	&config_ztso,
>   	&config_zvbb,
>   	&config_zvbc,
> +	&config_zvfbfmin,
> +	&config_zvfbfwma,
>   	&config_zvfh,
>   	&config_zvfhmin,
>   	&config_zvkb,

Reviewed-by: Nutty Liu<liujingqi@lanxincomputing.com>

Thanks,
Nutty

