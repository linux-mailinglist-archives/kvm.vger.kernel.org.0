Return-Path: <kvm+bounces-73347-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +EEbKIgOr2njNAIAu9opvQ
	(envelope-from <kvm+bounces-73347-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 19:16:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 49C2523E76B
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 19:16:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 335D63048930
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 18:13:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85C3C30BBA9;
	Mon,  9 Mar 2026 18:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iIHlBjcZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799902FFDDE
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 18:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773079972; cv=none; b=h4bfe/k1+klqhJS8OdiW4UiooCMIPD0w5DEKL5LD1RAhZiTaoRQ587ZdanVc0nhKoXpAMoA3A19JgxUWnEO6agivVmC3Jaw3aDctkb5IJRF7LrHDeRwcJB0hCWZ235eBrxCy03Xn0aJGGjVwz3pLi+4itSBzUIjdxT7/vjRGzIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773079972; c=relaxed/simple;
	bh=kqVuC9royASKdXGEsbezJWeT793uIzmXoD+McdcWmqs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mh4y2x4K24R6NIkFOdSJm2TE+2D/AosNaE+xSebhHdiG9qMORLA4P6tTwu5u6MXu6YGF0EBe8pqsj0fXihkc52QNDWAcSGaDuoU4QCfHTrNkcSg40IjP2ltbB/UJetDx/L3DkMld52ToKovKvkxwFzuV05bSz51aE1pNx9QGtOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iIHlBjcZ; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8cd79e43da3so205578185a.1
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 11:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1773079970; x=1773684770; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NEjfrceVoPpsyMxRtYpKXw6OfR+Lo42WgLugVLi/t74=;
        b=iIHlBjcZFA3eKGuINev70eyVZobAXEHEaLBvqZPlPRZt7P8k7i38hKC5MMuzRi7GHP
         jKn0mLAcs4vOcfXLJTeXmpXpB4WQjndiENQMZ9Iq9zu66uo+YCB4b5SsG0xTotF2IkTK
         wF1CC5ShVu8IQsqIsXwIfm/UOj+djj1MkyGJOqGJia4MOv0Rg5FdTV225uf5+aTZYeN2
         aXnaukbk+9xSgQotXmYh48E76KmWLbCSt0s1fr3tKQXE0OGAh0qiy6dgO1P5nNGWknCI
         6OIIlIoFUJmoqDMO3IZTgHBF2PQodOthpLf/nX1DiSlI5+7E9n4vhiNYa67ArryJOIad
         HUmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773079970; x=1773684770;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NEjfrceVoPpsyMxRtYpKXw6OfR+Lo42WgLugVLi/t74=;
        b=HqFiZpPAjUcHFCy/MorXGHU394wRWlARRP1QxVq7MjzlfcYBL/ELMQIzVIspF1ujNT
         05Okw/VceQJ3CGWC7N8HRXZYxs1GqQmgqHBxSYQ0poVQtRn78ZO1dLUFIeXOp/mtJ0ib
         gmrO4Mlv22wJzKYjSJfs8aQ4AKUaD87drEFKbLHigd/ycEL5qgjyXLoyQ8S8ostgq6KL
         ziXSdnrUo2YhxSV1KKJ5MSeeotTLEj+flckI/wpYRIQTFIbBfgdZufzIYYuawO8OTPtm
         Em3dI6VqhOTN/TBj/Td539iFEH8PMUv3kC3wJVwAJarej49lMcUZiSH5LInwVPsidwf2
         uYUQ==
X-Forwarded-Encrypted: i=1; AJvYcCXaiJQCgdDUSZq8sFBdpfLNXemP8/3hUckcjxv5sKtxZrFuQxaxq0e+yA4DocqPGBcZHsE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnCGM3IDr6s/mgSd1zH+uVAADDlkN//g3t2/2m4U4bt5O8qatG
	DMG8zEGe6r/6OxUKvDMyVU8V00ZGOfqhkDf4xVp49ygw1J5VEiAimM7HqBMoP0+jvRbqolUKkN4
	0ZsLG
X-Gm-Gg: ATEYQzxYxu2VYTuD1AbEh2+xj8HplycsOSAOA4y0yW70LEX4Bphffrv8mHiVSSCB9sQ
	msEKSmGun1EAw/L2rsPSXHM4iGr/meMqwXs8X2BpzG1hPAO5M/cJ81a1XoFbXRSFLtG7bipZ0ah
	P4ZWSSQe84cPZbO7wz2tGhgMUWl181FFMcQJ5DGjngoDf77zSAthT7G8VhP7NP+/osbYuNfqmT/
	xNhGTMMKLE44CXQxSKTOKp5D4gAbM8zWtuGXasY1xBG1wEyRpeXcni2bh2lWwpV45jMeCVFdzUe
	PKKrGRYGbzTWRXJt2TwBmEA7sEGzQnV7ZFzzAkMdXIg3Cbd4vGFryuorHUnMvz7SO3F5joSAdjm
	62jKvutiBufiZdmz0Dx28EhhoxGc0WcceIwi9V81NsUhgtD+R0IGqLVzjXh24Ge9DtHhlipBxqq
	pg56hgZeGhB6T+l5FDx6ozn4L+PPSMxFQbXKssFahC66A00T0cM8zju56lZ7OVfHDyDZdR
X-Received: by 2002:a05:620a:1a8b:b0:8cd:8938:effd with SMTP id af79cd13be357-8cd8938f3b6mr551924085a.1.1773079970375;
        Mon, 09 Mar 2026 11:12:50 -0700 (PDT)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cd6f49649esm719044285a.12.2026.03.09.11.12.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 11:12:49 -0700 (PDT)
Message-ID: <c632b868-3c0c-4a9a-b592-1af0429c6033@linaro.org>
Date: Mon, 9 Mar 2026 11:12:48 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] system/kvm: Make kvm_irqchip*notifier()
 declaration non target-specific
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20260309174941.67624-1-philmd@linaro.org>
 <20260309174941.67624-2-philmd@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Autocrypt: addr=pierrick.bouvier@linaro.org; keydata=
 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
 ZtfdHNZotF092MIH0IQC3poExQpV/WBYFAI=
In-Reply-To: <20260309174941.67624-2-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 49C2523E76B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-73347-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[linaro.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linaro.org:dkim,linaro.org:email,linaro.org:mid,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 3/9/26 10:49 AM, Philippe Mathieu-Daudé wrote:
> Commit 3607715a308 ("kvm: Introduce KVM irqchip change notifier")
> restricted the kvm_irqchip*notifier() declarations to target-specific
> files, guarding them under the NEED_CPU_H (later renamed as
> COMPILING_PER_TARGET) #ifdef check.
> 
> This however prohibit building the kvm-stub.c file once:
> 
>    ../accel/stubs/kvm-stub.c:70:6: error: no previous prototype for function 'kvm_irqchip_add_change_notifier' [-Werror,-Wmissing-prototypes]
>       70 | void kvm_irqchip_add_change_notifier(Notifier *n)
>          |      ^
>    ../accel/stubs/kvm-stub.c:74:6: error: no previous prototype for function 'kvm_irqchip_remove_change_notifier' [-Werror,-Wmissing-prototypes]
>       74 | void kvm_irqchip_remove_change_notifier(Notifier *n)
>          |      ^
>    ../accel/stubs/kvm-stub.c:78:6: error: no previous prototype for function 'kvm_irqchip_change_notify' [-Werror,-Wmissing-prototypes]
>       78 | void kvm_irqchip_change_notify(void)
>          |      ^
> 
> Since nothing in these prototype declarations is target specific,
> move them around to be generically available, allowing to build
> kvm-stub.c once for all targets in the next commit.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   include/system/kvm.h | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>

