Return-Path: <kvm+bounces-71848-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WHAAD/gmn2mPZAQAu9opvQ
	(envelope-from <kvm+bounces-71848-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 17:44:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id D6D7719AE03
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 17:44:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A0182300D376
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 16:43:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C25D61917FB;
	Wed, 25 Feb 2026 16:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XNcQLQYS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97819285C9F
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 16:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772037804; cv=none; b=Jl4bPtnsXxcqdvbaQPS7+E8tnNtovEaRJB/ZdsciV+L95HywR4aJ5PrYmTpuSUm2Hl/RCIXyWhVlSvbHTjp1qLXZe1w7N8NeSXEiOJJ065/1N35PvkGr8HxWM61MiHRRS+gNsSCPGg846pMglQ/XihxuZGFhQ3vjUtILdFx6jes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772037804; c=relaxed/simple;
	bh=fC7aLCPeizrmUUGVJtxBWexufaZTOHnTFKYEkv9AaYg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aA4/1vvdptJnyer0pBYunG42fEJTteE6gt7l5GnCmX4Zuetil0t7RSJQOc83euD2Yp+lo0dcBKlJd4Yqp5NeVwQFxUz5ejOrx57s7NObYi3triDKzVTDY3pIxzPWz97zZ0sXUz944ACpJib31LWBaEQkGoXRB/MimdRuyAS2eGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XNcQLQYS; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-436e8758b91so4754072f8f.0
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 08:43:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772037801; x=1772642601; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=UxHyDol6OD3wDUJix93HFRgeqz6eIfaj/s0joeajaQE=;
        b=XNcQLQYSHksdWemIoRxjwX5n/cbztqKGNCBAB/f3UYj4HdOM4Eh4dSMeL3nsDWFdKd
         h3Lsez/FvonEA6qb1ztGcRfxsic/TJaUAZTSqCACWEQh+ggYZ09MVExVBO+e1Z7gikst
         9vXgZIzGP7JaQ5JjpTVakIo+pQQb6JB4izv5xaF2PWcRMvfULUIOVECjKTETb0oKSC/Z
         VMtNriNO5Vq9btKcaoiC8vjNF5rqZnZp/CEYWNL1MiDwU0JqNWYS7TOSBrDkcEmLBazq
         7UWnrxy3SYhsH+vaFS90Lje/wCJrlsPRo87BjilmGSj3XeopVml76zmbzGXpLGi49YRR
         zhfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772037801; x=1772642601;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UxHyDol6OD3wDUJix93HFRgeqz6eIfaj/s0joeajaQE=;
        b=THg47YDOfknYhkvJ12I61x/8ZHK7eo0CbLg8wsLaXV0vAPRz8YqnxNglyaTTMJ7bUd
         /K1da3A5wEhNMUj+EjgzSxuJAPHGZfuisMIDjEsygdk7cp63MzrT61TXd1Y000qrTl5k
         myQ68HDnCqrT5yW/P9xAGoPbClVsRBeKTq30ZohBQBwOPdQ6+BbL3Wf6Mn9x2UN3jpqD
         mugJoJQOP6o+6kpIwfQYrh4IE9ruknG05Q+8Hg4/VsjgQ8eKDFatH6fgnKN+1nSl71qj
         l0qMhbw8XzD9u+uECoFVuOmacNgL/gctDYRVMQeVtLPkkn7nH8nKg1omVd1k5KjBBmyP
         s0Ug==
X-Forwarded-Encrypted: i=1; AJvYcCX4jn+MxJov7fGSGiuz6tkb1qw3SfxK2EU7UGagA1+SxQzFzFS8q54gAfeGTdHvWg2Qf6M=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZgPKd9XpkbMSIIMATcrRwWn2nIBeP+owugYgNEWImiAbOjCJZ
	M0CfMPMx5kuCMsK2MwrCIqlpKiqLejrwfmt8ZO4N+qiL/vi581NeThP0OIPkHYnG15k=
X-Gm-Gg: ATEYQzx41BS7Z75QmVtygqqVd240s9tmZl16E0F9NWfEELKimczRfJi7GP7XS6lRXye
	c+xOX6wsbza8tUuNIvkYBAfa9AoApJQAYi7T7tFnNLMSB46v4D1+4dNicvNiZZgAlInaBff/40h
	4lp+8lEUmKtH5IOZ4fbZZWp812NXAvQtGQMGnLrx0YDV2lUViF4ZlFEsnCiedIRFc3vVMOnG5b+
	NbWkLP5UiDSCXdJrZEBu7ijxOFIav/u49XYYTvX8eRjq2j/ZltCoc23x2/m1/UOG8dsb2VZgNfT
	UbVpvckz+RiwtdbE+YkIt9U1bGOh9Ih0ppcXrVgG1E1Vm4fAj0v2hMLWm7bSfEwBoq8DViRE2nr
	Mm+s6dbKx7xjiM1vm8TOrOigLjm5ZMV7hNHIVy54oY1KRCB9UfctQv7FNLYS6f2i5Ps4bR9JRaG
	aY+gQ2NkqFDoAIrNBkyIaF29a49yviLeQAiOobBpWeSMGqR9cvjYG3LGRT0Q==
X-Received: by 2002:a05:6000:420b:b0:431:a50:6e97 with SMTP id ffacd0b85a97d-439942ed0damr2009260f8f.34.1772037800983;
        Wed, 25 Feb 2026 08:43:20 -0800 (PST)
Received: from [192.168.0.20] (nborisov.ddns.nbis.net. [185.218.67.59])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970d3fdd0sm33814030f8f.19.2026.02.25.08.43.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 08:43:20 -0800 (PST)
Message-ID: <c3ee8425-d3ec-4c1d-bcbb-87320a548281@suse.com>
Date: Wed, 25 Feb 2026 18:43:18 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: x86: synthesize CPUID bits only if CPU capability
 is set
To: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>, seanjc@google.com,
 bp@alien8.de, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, jmattson@google.com,
 binbin.wu@linux.intel.com, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>,
 "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
 <linux-kernel@vger.kernel.org>
References: <20260209153108.70667-2-clopez@suse.de>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
Autocrypt: addr=nik.borisov@suse.com; keydata=
 xsFNBGcrpvIBEAD5cAR5+qu30GnmPrK9veWX5RVzzbgtkk9C/EESHy9Yz0+HWgCVRoNyRQsZ
 7DW7vE1KhioDLXjDmeu8/0A8u5nFMqv6d1Gt1lb7XzSAYw7uSWXLPEjFBtz9+fBJJLgbYU7G
 OpTKy6gRr6GaItZze+r04PGWjeyVUuHZuncTO7B2huxcwIk9tFtRX21gVSOOC96HcxSVVA7X
 N/LLM2EOL7kg4/yDWEhAdLQDChswhmdpHkp5g6ytj9TM8bNlq9I41hl/3cBEeAkxtb/eS5YR
 88LBb/2FkcGnhxkGJPNB+4Siku7K8Mk2Y6elnkOctJcDvk29DajYbQnnW4nhfelZuLNupb1O
 M0912EvzOVI0dIVgR+xtosp66bYTOpX4Xb0fylED9kYGiuEAeoQZaDQ2eICDcHPiaLzh+6cc
 pkVTB0sXkWHUsPamtPum6/PgWLE9vGI5s+FaqBaqBYDKyvtJfLK4BdZng0Uc3ijycPs3bpbQ
 bOnK9LD8TYmYaeTenoNILQ7Ut54CCEXkP446skUMKrEo/HabvkykyWqWiIE/UlAYAx9+Ckho
 TT1d2QsmsAiYYWwjU8igXBecIbC0uRtF/cTfelNGrQwbICUT6kJjcOTpQDaVyIgRSlUMrlNZ
 XPVEQ6Zq3/aENA8ObhFxE5PLJPizJH6SC89BMKF3zg6SKx0qzQARAQABzSZOaWtvbGF5IEJv
 cmlzb3YgPG5pay5ib3Jpc292QHN1c2UuY29tPsLBkQQTAQoAOxYhBDuWB8EJLBUZCPjT3SRn
 XZEnyhfsBQJnK6byAhsDBQsJCAcCAiICBhUKCQgLAgQWAgMBAh4HAheAAAoJECRnXZEnyhfs
 XbIQAJxuUnelGdXbSbtovBNm+HF3LtT0XnZ0+DoR0DemUGuA1bZAlaOXGr5mvVbTgaoGUQIJ
 3Ejx3UBEG7ZSJcfJobB34w1qHEDO0pN9orGIFT9Bic3lqhawD2r85QMcWwjsZH5FhyRx7P2o
 DTuUClLMO95GuHYQngBF2rHHl8QMJPVKsR18w4IWAhALpEApxa3luyV7pAAqKllfCNt7tmed
 uKmclf/Sz6qoP75CvEtRbfAOqYgG1Uk9A62C51iAPe35neMre3WGLsdgyMj4/15jPYi+tOUX
 Tc7AAWgc95LXyPJo8069MOU73htZmgH4OYy+S7f+ArXD7h8lTLT1niff2bCPi6eiAQq6b5CJ
 Ka4/27IiZo8tm1XjLYmoBmaCovqx5y5Xt2koibIWG3ZGD2I+qRwZ0UohKRH6kKVHGcrmCv0J
 YO8yIprxgoYmA7gq21BpTqw3D4+8xujn/6LgndLKmGESM1FuY3ymXgj5983eqaxicKpT9iq8
 /a1j31tms4azR7+6Dt8H4SagfN6VbJ0luPzobrrNFxUgpjR4ZyQQ++G7oSRdwjfIh1wuCF6/
 mDUNcb6/kA0JS9otiC3omfht47yQnvod+MxFk1lTNUu3hePJUwg1vT1te3vO5oln8lkUo9BU
 knlYpQ7QA2rDEKs+YWqUstr4pDtHzwQ6mo0rqP+zzsFNBGcrpvIBEADGYTFkNVttZkt6e7yA
 LNkv3Q39zQCt8qe7qkPdlj3CqygVXfw+h7GlcT9fuc4kd7YxFys4/Wd9icj9ZatGMwffONmi
 LnUotIq2N7+xvc4Xu76wv+QJpiuGEfCDB+VdZOmOzUPlmMkcJc/EDSH4qGogIYRu72uweKEq
 VfBI43PZIGpGJ7TjS3THX5WVI2YNSmuwqxnQF/iVqDtD2N72ObkBwIf9GnrOgxEyJ/SQq2R0
 g7hd6IYk7SOKt1a8ZGCN6hXXKzmM6gHRC8fyWeTqJcK4BKSdX8PzEuYmAJjSfx4w6DoxdK5/
 9sVrNzaVgDHS0ThH/5kNkZ65KNR7K2nk45LT5Crjbg7w5/kKDY6/XiXDx7v/BOR/a+Ryo+lM
 MffN3XSnAex8cmIhNINl5Z8CAvDLUtItLcbDOv7hdXt6DSyb65CdyY8JwOt6CWno1tdjyDEG
 5ANwVPYY878IFkOJLRTJuUd5ltybaSWjKIwjYJfIXuoyzE7OL63856MC/Os8PcLfY7vYY2LB
 cvKH1qOcs+an86DWX17+dkcKD/YLrpzwvRMur5+kTgVfXcC0TAl39N4YtaCKM/3ugAaVS1Mw
 MrbyGnGqVMqlCpjnpYREzapSk8XxbO2kYRsZQd8J9ei98OSqgPf8xM7NCULd/xaZLJUydql1
 JdSREId2C15jut21aQARAQABwsF2BBgBCgAgFiEEO5YHwQksFRkI+NPdJGddkSfKF+wFAmcr
 pvICGwwACgkQJGddkSfKF+xuuxAA4F9iQc61wvAOAidktv4Rztn4QKy8TAyGN3M8zYf/A5Zx
 VcGgX4J4MhRUoPQNrzmVlrrtE2KILHxQZx5eQyPgixPXri42oG5ePEXZoLU5GFRYSPjjTYmP
 ypyTPN7uoWLfw4TxJqWCGRLsjnkwvyN3R4161Dty4Uhzqp1IkNhl3ifTDYEvbnmHaNvlvvna
 7+9jjEBDEFYDMuO/CA8UtoVQXjy5gtOhZZkEsptfwQYc+E9U99yxGofDul7xH41VdXGpIhUj
 4wjd3IbgaCiHxxj/M9eM99ybu5asvHyMo3EFPkyWxZsBlUN/riFXGspG4sT0cwOUhG2ZnExv
 XXhOGKs/y3VGhjZeCDWZ+0ZQHPCL3HUebLxW49wwLxvXU6sLNfYnTJxdqn58Aq4sBXW5Un0Q
 vfbd9VFV/bKFfvUscYk2UKPi9vgn1hY38IfmsnoS8b0uwDq75IBvup9pYFyNyPf5SutxhFfP
 JDjakbdjBoYDWVoaPbp5KAQ2VQRiR54lir/inyqGX+dwzPX/F4OHfB5RTiAFLJliCxniKFsM
 d8eHe88jWjm6/ilx4IlLl9/MdVUGjLpBi18X7ejLz3U2quYD8DBAGzCjy49wJ4Di4qQjblb2
 pTXoEyM2L6E604NbDu0VDvHg7EXh1WwmijEu28c/hEB6DwtzslLpBSsJV0s1/jE=
In-Reply-To: <20260209153108.70667-2-clopez@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[14];
	TAGGED_FROM(0.00)[bounces-71848-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nik.borisov@suse.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,suse.com:mid,suse.com:dkim,suse.com:email]
X-Rspamd-Queue-Id: D6D7719AE03
X-Rspamd-Action: no action



On 9.02.26 г. 17:31 ч., Carlos López wrote:
> KVM incorrectly synthesizes CPUID bits for KVM-only leaves, as the
> following branch in kvm_cpu_cap_init() is never taken:
> 
>      if (leaf < NCAPINTS)
>          kvm_cpu_caps[leaf] &= kernel_cpu_caps[leaf];
> 
> This means that bits set via SYNTHESIZED_F() for KVM-only leaves are
> unconditionally set. This for example can cause issues for SEV-SNP
> guests running on Family 19h CPUs, as TSA_SQ_NO and TSA_L1_NO are
> always enabled by KVM in 80000021[ECX]. When userspace issues a
> SNP_LAUNCH_UPDATE command to update the CPUID page for the guest, SNP
> firmware will explicitly reject the command if the page sets sets these
> bits on vulnerable CPUs.
> 
> To fix this, check in SYNTHESIZED_F() that the corresponding X86
> capability is set before adding it to to kvm_cpu_cap_features.
> 
> Fixes: 31272abd5974 ("KVM: SVM: Advertise TSA CPUID bits to guests")
> Link: https://lore.kernel.org/all/20260208164233.30405-1-clopez@suse.de/
> Signed-off-by: Carlos López <clopez@suse.de>

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>

> ---
> v2: fix SYNTHESIZED_F() instead of using SCATTERED_F() for TSA bits
>   arch/x86/kvm/cpuid.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 88a5426674a1..5f41924987c7 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -770,7 +770,10 @@ do {									\
>   #define SYNTHESIZED_F(name)					\
>   ({								\
>   	kvm_cpu_cap_synthesized |= feature_bit(name);		\
> -	F(name);						\
> +								\
> +	BUILD_BUG_ON(X86_FEATURE_##name >= MAX_CPU_FEATURES);	\
> +	if (boot_cpu_has(X86_FEATURE_##name))			\
> +		F(name);					\
>   })
>   
>   /*


