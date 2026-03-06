Return-Path: <kvm+bounces-72990-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WL2LDodxqmmmRgEAu9opvQ
	(envelope-from <kvm+bounces-72990-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 07:17:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C18C21BFB0
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 07:17:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 779683038523
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 06:17:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB25D370D54;
	Fri,  6 Mar 2026 06:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b="Zoloxuc3"
X-Original-To: kvm@vger.kernel.org
Received: from sg-1-36.ptr.blmpb.com (sg-1-36.ptr.blmpb.com [118.26.132.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AD6351C3B
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 06:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772777852; cv=none; b=YKbwToQgBcP5QRPLQZk6pix14/0a7SknBNLj8aUfxm9NSAZAPTkl3038mJGeQ9ziAvw5g75lty3Bunk7HWM/QZb/iL4Ycx1JAmc4CMgQz6g0kIXSj79Vb5IwgLHRe/2kgwzpYTRvAf6mYReCi6Ra1CyJuVlFIPFTSSwpOJFuVlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772777852; c=relaxed/simple;
	bh=Fli6r8wlAgbwy/oIcoJwpmBmU/A92Zm0IYOtfBLNhZg=;
	h=References:Cc:Date:Mime-Version:Content-Type:From:Subject:To:
	 Message-Id:In-Reply-To; b=OXBP3vqsR3k9DEDQ5uYljaCIAIJJ4LtYeyrC3kztvzKhvRkvdSSTtzPYh18/k5djm0wwk6v3dD+ZwjR2EQb/9fGbKqYTonQSXgT7gUey+yU8pLniiBT37WpA2crslOWgRcn0dSxpGcQ5UDLN3GcZ11tnCMGwj0P/knk7gvcre3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com; spf=pass smtp.mailfrom=lanxincomputing.com; dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b=Zoloxuc3; arc=none smtp.client-ip=118.26.132.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lanxincomputing.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=lanxincomputing-com.20200927.dkim.feishu.cn; t=1772777841;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=yN5rn7GLGptMebKvf73Ps4IUabQw/g3Ysx/1ALo9Qq0=;
 b=Zoloxuc3N7cEjeP6U8Yuka1GJ65GRmmQwebEQHEgrN93vgwgSp3ho86TEthu+OjI0nK7t0
 Tyl+XuGQ+Ap9YqbdlG99cH35KTxIgJGYgKYFZClnsLxq3YqErV/JshkFGz/UKTNXHCBBby
 fbBv9WkwtIIYY1IOaAEcjZT4N2cAqJH4xx0KK4y0B6UuTRvGWownCTShj0yPR5e/x801fv
 7JlL3BZNRruNU7KOE/g+43fmpV3Zv3l5e/o9Ds0NSTTTa8tFhzk4I5wo8FnpzhvWbH7XKh
 SHKq2eKk7ZXAHt9gd6WxLerFsDkLDz/aZWJlSISkOJDH0FleOUX+tdHlPbbyMQ==
User-Agent: Mozilla Thunderbird
Received: from [127.0.0.1] ([61.181.102.80]) by smtp.feishu.cn with ESMTPS; Fri, 06 Mar 2026 14:17:19 +0800
References: <20260305235416.4147213-1-xin@zytor.com>
X-Lms-Return-Path: <lba+269aa7170+0e4f03+vger.kernel.org+xiangwencheng@lanxincomputing.com>
Cc: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>, 
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<x86@kernel.org>, <hpa@zytor.com>
Date: Fri, 6 Mar 2026 14:17:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
From: "BillXiang" <xiangwencheng@lanxincomputing.com>
Subject: Re: [PATCH v1] KVM: VMX: Remove unnecessary parentheses
Content-Transfer-Encoding: 7bit
To: "Xin Li (Intel)" <xin@zytor.com>, <kvm@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
Message-Id: <1795684a-b453-440e-88bb-035993d9deab@lanxincomputing.com>
In-Reply-To: <20260305235416.4147213-1-xin@zytor.com>
X-Original-From: BillXiang <xiangwencheng@lanxincomputing.com>
Content-Language: en-US
X-Rspamd-Queue-Id: 8C18C21BFB0
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[lanxincomputing-com.20200927.dkim.feishu.cn:s=s1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_NA(0.00)[lanxincomputing.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72990-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[lanxincomputing-com.20200927.dkim.feishu.cn:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xiangwencheng@lanxincomputing.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,zytor.com:email]
X-Rspamd-Action: no action

On 3/6/2026 7:54 AM, Xin Li (Intel) wrote:
> From: Xin Li <xin@zytor.com>
> 
> Drop redundant parentheses; & takes precedence over &&.

I would not recommend relying on default operator precedence.

> 
> Signed-off-by: Xin Li <xin@zytor.com>
> ---
>   arch/x86/kvm/vmx/capabilities.h | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index 4e371c93ae16..0dad9e7c4ff4 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -107,7 +107,7 @@ static inline bool cpu_has_load_perf_global_ctrl(void)
>   
>   static inline bool cpu_has_load_cet_ctrl(void)
>   {
> -	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_CET_STATE);
> +	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_CET_STATE;
>   }
>   
>   static inline bool cpu_has_save_perf_global_ctrl(void)
> @@ -162,7 +162,7 @@ static inline bool cpu_has_vmx_ept(void)
>   static inline bool vmx_umip_emulated(void)
>   {
>   	return !boot_cpu_has(X86_FEATURE_UMIP) &&
> -	       (vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_DESC);
> +	       vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_DESC;
>   }
>   
>   static inline bool cpu_has_vmx_rdtscp(void)
> @@ -376,9 +376,9 @@ static inline bool cpu_has_vmx_invvpid_global(void)
>   
>   static inline bool cpu_has_vmx_intel_pt(void)
>   {
> -	return (vmcs_config.misc & VMX_MISC_INTEL_PT) &&
> -		(vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_PT_USE_GPA) &&
> -		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_RTIT_CTL);
> +	return vmcs_config.misc & VMX_MISC_INTEL_PT &&
> +	       vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_PT_USE_GPA &&
> +	       vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_RTIT_CTL;
>   }

Removing the parentheses could significantly reduce code readability here.

>   
>   /*
> 
> base-commit: 5128b972fb2801ad9aca54d990a75611ab5283a9

