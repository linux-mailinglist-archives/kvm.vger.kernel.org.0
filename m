Return-Path: <kvm+bounces-8849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B3ED8573AF
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 03:10:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7FA331C21E49
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 02:10:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FA94F9DA;
	Fri, 16 Feb 2024 02:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=zytor.com header.i=@zytor.com header.b="oosqOFDB"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3EC9DF46;
	Fri, 16 Feb 2024 02:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708049438; cv=none; b=b/clnPkhwgkBgkxgDt2urG3MVi5IPDVB34A90s0jKeafme7rM/XlpdeLZrEAXG3nbPIileWCSJfmngpMIIkYOmaMDp+ZWXluAVbfMLGWlDGCOTFZo2+pDGnk4zT050uP4aXqLlItLg3X6fuyl1+vjeQ1+0sKQMigtaobXGDdp8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708049438; c=relaxed/simple;
	bh=++nunztG9PFlOmATcFv4cZ3BPs1yQTQ4VwQyd0uLOnw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h3a1HqF0kuCt+gOgDPiPzSwXnismOkThNaRx/8VZttivyIa4nmymull/Z0ypRDe0F0NxL8IDcUezHQsqDCtmRTwMK+prnTF6Itlcidd9cnB1/jOvPkHG7Xt1dGhpyXd7sfDW8sXZfNcIrFC4niWuP38HYuQAF1Mi5wP3o8ZDnBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=oosqOFDB; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.187] ([71.202.196.111])
	(authenticated bits=0)
	by mail.zytor.com (8.17.2/8.17.1) with ESMTPSA id 41G2AK4m1928908
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Thu, 15 Feb 2024 18:10:20 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 41G2AK4m1928908
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024021201; t=1708049421;
	bh=mYAPDjHz1Me1srGHnCSuDyVAEttywyOnankfp7yvd+w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oosqOFDBxrA5GKlO430z8tq4rNpm4Ci2VIdn23OfYBWHLHUUYReiul1nsOlUpYHN0
	 Mw5LXeXc2QR7OwkcLjK47wo/FQ7WkXaPFq9aMf+xtx/FidlgXYdCbZlUPxzC6IFw0j
	 IklunoqAJBUByrTtfxLPYwIVu2LC7zSt5x3e/HTUjt5FJlOxuCYlo/qszTvWr2fAqU
	 0fZq69Jfcv6dCJ1RLr7/wZWtaV5yJirZ/GeSJsFJybU8NvEzFO1Y2hXj2cVnHKWUiy
	 GiNKnegitg2Tj/tqJr6zpA7MXgz3ASWkBnSUqlvz6NuvXmuIGt9texyXRfbvgaX7eA
	 fbaGzV6tf3t7Q==
Message-ID: <a61b113c-613c-41df-80a5-b061889edfdf@zytor.com>
Date: Thu, 15 Feb 2024 18:10:18 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arch/x86/entry_fred: don't set up KVM IRQs if KVM is
 disabled
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
        Max Kellermann <max.kellermann@ionos.com>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Paolo Bonzini
 <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20240215133631.136538-1-max.kellermann@ionos.com>
 <Zc5sMmT20kQmjYiq@google.com>
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <Zc5sMmT20kQmjYiq@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/15/2024 11:55 AM, Sean Christopherson wrote:
> +Paolo and Stephen
> 
> FYI, there's a build failure in -next due to a collision between kvm/next and
> tip/x86/fred.  The above makes everything happy.
> 
> On Thu, Feb 15, 2024, Max Kellermann wrote:
>> When KVM is disabled, the POSTED_INTR_* macros do not exist, and the
>> build fails.
>>
>> Fixes: 14619d912b65 ("x86/fred: FRED entry/exit and dispatch code")
>> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
>> ---
>>   arch/x86/entry/entry_fred.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/x86/entry/entry_fred.c b/arch/x86/entry/entry_fred.c
>> index ac120cbdaaf2..660b7f7f9a79 100644
>> --- a/arch/x86/entry/entry_fred.c
>> +++ b/arch/x86/entry/entry_fred.c
>> @@ -114,9 +114,11 @@ static idtentry_t sysvec_table[NR_SYSTEM_VECTORS] __ro_after_init = {
>>   
>>   	SYSVEC(IRQ_WORK_VECTOR,			irq_work),
>>   
>> +#if IS_ENABLED(CONFIG_KVM)
>>   	SYSVEC(POSTED_INTR_VECTOR,		kvm_posted_intr_ipi),
>>   	SYSVEC(POSTED_INTR_WAKEUP_VECTOR,	kvm_posted_intr_wakeup_ipi),
>>   	SYSVEC(POSTED_INTR_NESTED_VECTOR,	kvm_posted_intr_nested_ipi),
>> +#endif
>>   };
>>   
>>   static bool fred_setup_done __initdata;
>> -- 
>> 2.39.2
> 

We want to minimize #ifdeffery (which is why we didn't add any to
sysvec_table[]), would it be better to simply remove "#if 
IS_ENABLED(CONFIG_KVM)" around the the POSTED_INTR_* macros from the
Linux-next tree?

BTW, kvm_posted_intr_*() are defined to NULL if !IS_ENABLED(CONFIG_KVM).

diff --git a/arch/x86/include/asm/irq_vectors.h 
b/arch/x86/include/asm/irq_vectors.h
index 3a19904c2db6..d18bfb238f66 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -84,11 +84,9 @@
  #define HYPERVISOR_CALLBACK_VECTOR	0xf3

  /* Vector for KVM to deliver posted interrupt IPI */
-#if IS_ENABLED(CONFIG_KVM)
  #define POSTED_INTR_VECTOR		0xf2
  #define POSTED_INTR_WAKEUP_VECTOR	0xf1
  #define POSTED_INTR_NESTED_VECTOR	0xf0
-#endif

  #define MANAGED_IRQ_SHUTDOWN_VECTOR	0xef


