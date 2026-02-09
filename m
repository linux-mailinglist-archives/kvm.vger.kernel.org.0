Return-Path: <kvm+bounces-70632-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0KEtEC0gimkAHgAAu9opvQ
	(envelope-from <kvm+bounces-70632-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 18:58:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F0330113506
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 18:58:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3FDD83008302
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 17:58:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40956388868;
	Mon,  9 Feb 2026 17:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AVzIrf4q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDD33859F7
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 17:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770659879; cv=none; b=bt6vhG2wwdFM/19YYIja4y4UzJL7Jswl0UX9sxXevYpVDewyRNwNk42uml1Ae8mHnyZjHMa+RJDCGDjia3SC4cRdA4VTCvpMbF+W5q+7yLTpeIHQD5LEV/ZHtM/roiLUAr7P9YlQTHQzLx/WqJIk5/NZhBxTrd2RpK3ZRPNHoeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770659879; c=relaxed/simple;
	bh=3NyXFa+S89ymbQkKUMeDnz0h6yIR4gp82l+doxmHYoU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XmmDMI9g2Hpw5bpUGHOO4Z9/bUaWtOrKfM6oWa13ZEdmaDFDu/M7vROvc0a9RGHLHb34Y+gRfaQrQQ/u72Z2Ih4siyk8YRy/finJbevpH3GtlkN4VRmz2LrB++HH5BeWkubW4PWhzRqYrY9ejyv499TMZBH5fxttgnTG1YjVoNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AVzIrf4q; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8230c33f477so2100666b3a.2
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 09:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770659878; x=1771264678; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=goZOlZLCqcIlvHYlFxEFSnDWqilzIfXz2/b0/0428dk=;
        b=AVzIrf4qu6KhmCP24capWrU3X0TqF1BUdxICzDHhvdfACLGRxfCv5wnN7wWmT7IMZ5
         v4hTvQIgKDKIMuKX5g3rH0rBthi+7u6kJ7MRRfScs51qqjl/sv+ytXBuEwj5ogZCCldh
         t8r4SKVeq3P5oAMvUPOlsAPbOawPRrapc6gmRFNNz9W3gF3LPX+VvEvP/E3pOSP20lYk
         bAQBC+qKTk860tzx4mtasQeXWRyk///mObvxQBBrZFKc9zbY14e7vsvf9TzE0tVQhq0I
         MgwNiszCGhTA4S/GMaZWMobloc1vhWpXaCF3xMbwUNSEq8MxiHTeK0TVHxTPaoqZDq3S
         t/Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770659878; x=1771264678;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=goZOlZLCqcIlvHYlFxEFSnDWqilzIfXz2/b0/0428dk=;
        b=J/yS1oZlnxoyeD1M9ieS0Sz97p2sfwGzBNIJZHwnOAYyESkHnAhwWic9Y7dNT1REw/
         +2+YaSWYIzNe6Mazth+lZAUlXTKIFdlJhL8SN06z7yhYwWm/Hk0XE/4h61GatjN/Usqu
         y5wlqPK3UVti40eIx/T85N/KGoJ1kqeqZWvbQw1Akg9bTv6y3pAdA8yPqjwTMdl7JCgQ
         6FOe/7wYVPMjO/Z6qZ7kLYiBcvlIGaVvpJhZSRt/401ATh16dNnP4q+usWUgcjb7QCsL
         YSBa7GeQfjibSC3yp6UDdh/a4mqWwDyM6bv/R1WxGIvhAKHwYexx/2STgZlWGLWaMWqc
         IOCQ==
X-Forwarded-Encrypted: i=1; AJvYcCUd/HTUDDZuN+zrNH0rbqe3EuMcZxR6fA2U9y/oiibWKTMABjxHi8kc8Xz9gZnOrGge0wM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwChTS65FzxoS/m6JOuZL2sXluVyyG8MzNZ2dk0yRPaT/ohQ8p9
	SylMHOoNP56q3JkwduFku9yLo5l126CEdC5V2uXVq+qD2hu4xCkTCH4UQox0elsU6NibK6YZlIl
	9OCuh
X-Gm-Gg: AZuq6aLd7cMbPlvIMWV/d5B/L0mG7UUjokiBnaQL8Kpwq64i/hYvWlGd7btp0F2vr9v
	c9szbrLUA1nr9693fzkvqUG7pknfFBXrovPUS4NLuA0RfzNbhUVe5RGMFa6W/usdcpPlE5izWiD
	0QrBAfyP2cho2V8+iUrlcC3zGbtIrhHfcrLLzXQhDkQegCYCngw+VcqcwLVJQ6Y3IwIfCWoj116
	kyNmeZJAsqBZBYtr+TOD/EDXVy8roEDvy88i/fLU7hUuuRWeDL0NXiY4CMwijTfHcIoUhnoLM0z
	VXhPlyNKn1iN0lHKh2Yy2B5+xvXuPfpT/plNN4M1CB1AIMkVSKMkhxXIwYaQTxW6mDUMOAYqbsR
	JzCbW8Zd8TyV7goxO6SM8HJn2elgtL1hbHWx/GoEgqwOq4VrHdVjvWRdrMEgoORkY0644J1yRdu
	Xidz8Mxc5d4Zd8asy9kr+MzTOj76YW1DEYQZiBgWbKx3fXhIYdznXYy66r
X-Received: by 2002:aa7:888f:0:b0:81f:41c8:765a with SMTP id d2e1a72fcca58-8244160089amr11519701b3a.4.1770659878485;
        Mon, 09 Feb 2026 09:57:58 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824418b60easm11015905b3a.55.2026.02.09.09.57.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Feb 2026 09:57:58 -0800 (PST)
Message-ID: <c0b0691b-3cef-4ec7-8d68-227420167481@linaro.org>
Date: Mon, 9 Feb 2026 09:57:56 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/12] target/arm/tcg: duplicate tcg/arith_helper.c and
 tcg/crypto_helper.c between user/system
Content-Language: en-US
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: anjo@rev.ng, Jim MacArthur <jim.macarthur@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, kvm@vger.kernel.org, qemu-arm@nongnu.org
References: <20260206042150.912578-1-pierrick.bouvier@linaro.org>
 <20260206042150.912578-7-pierrick.bouvier@linaro.org>
 <6c5eb308-56e6-487a-ad7b-8f0da70ab7cd@linaro.org>
 <e291f290-a188-4106-8648-48d4c464dfed@linaro.org>
 <a6320ab4-7ece-4618-8d73-549df7a34886@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Autocrypt: addr=pierrick.bouvier@linaro.org; keydata=
 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
 ZtfdHNZotF092MIH0IQC3poExQpV/WBYFAI=
In-Reply-To: <a6320ab4-7ece-4618-8d73-549df7a34886@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[linaro.org:+];
	TAGGED_FROM(0.00)[bounces-70632-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: F0330113506
X-Rspamd-Action: no action

On 2/8/26 11:08 PM, Richard Henderson wrote:
> On 2/9/26 15:52, Pierrick Bouvier wrote:
>> On 2/8/26 9:00 PM, Richard Henderson wrote:
>>> On 2/6/26 14:21, Pierrick Bouvier wrote:
>>>> In next commit, we'll apply same helper pattern for base helpers
>>>> remaining.
>>>>
>>>> Our new helper pattern always include helper-*-common.h, which ends up
>>>> including include/tcg/tcg.h, which contains one occurrence of
>>>> CONFIG_USER_ONLY.
>>>> Thus, common files not being duplicated between system and target
>>>> relying on helpers will fail to compile. Existing occurrences are:
>>>> - target/arm/tcg/arith_helper.c
>>>> - target/arm/tcg/crypto_helper.c
>>>>
>>>> There is a single occurrence of CONFIG_USER_ONLY, for defining variable
>>>> tcg_use_softmmu. The fix seemed simple, always define it.
>>>> However, it prevents some dead code elimination which ends up triggering:
>>>> include/qemu/osdep.h:283:35: error: call to 'qemu_build_not_reached_always' declared
>>>> with attribute error: code path is reachable
>>>>      283 | #define qemu_build_not_reached()  qemu_build_not_reached_always()
>>>>          |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>> tcg/x86_64/tcg-target.c.inc:1907:45: note: in expansion of macro 'qemu_build_not_reached'
>>>>     1907 | # define x86_guest_base (*(HostAddress *)({ qemu_build_not_reached(); NULL; }))
>>>>          |                                             ^~~~~~~~~~~~~~~~~~~~~~
>>>> tcg/x86_64/tcg-target.c.inc:1934:14: note: in expansion of macro 'x86_guest_base'
>>>>     1934 |         *h = x86_guest_base;
>>>>          |              ^~~~~~~~~~~~~~
>>>>
>>>> So, roll your eyes, then rollback code, and simply duplicate the two
>>>> files concerned. We could also do a "special include trick" to prevent
>>>> pulling helper-*-common.h but it would be sad since the whole point of
>>>> the series up to here is to have something coherent using the exact same
>>>> pattern.
>>>
>>> tcg_use_softmmu is a stub, waiting for softmmu to be enabled for user-only.
>>> Which is a long way away.
>>>
>>> It's also not used outside of tcg/, which means we should move it to tcg/tcg-internal.h.
>>>
>>
>> Thanks, I didn't think about moving it somewhere else.
>> This does the trick indeed.
> 
> You can also make it always a #define.  The variable for user-only is never set to true.
> 
> 
> r~

Sure, let's go for a define then. :)

Regards,
Pierrick

