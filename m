Return-Path: <kvm+bounces-70675-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IOR/Onh1immmKgAAu9opvQ
	(envelope-from <kvm+bounces-70675-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 01:02:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A410115827
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 01:02:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 73F263027D9C
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 00:01:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8518D1AE877;
	Tue, 10 Feb 2026 00:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pHWDORWD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3815632
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 00:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770681712; cv=none; b=IMynIUNJQGZt9NvI0F52Yu5YNlC3RSxhGd4x7uuj76/+zY9+tlgX/tcO5cjC8On1tWuwY4LU7zh7uWOwWC3Fny/ewyC3j1YngwuH7DcPw2LOVIJcX/MDG5ZJB0zil+RsSxLsahg2GsX2yepLAKcohiAOlHDqKBIgTF+dVQKU6lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770681712; c=relaxed/simple;
	bh=Xydrik1OrCuJc4PVEh6IdxUgcjad69Yqy28GLGdjDIg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gepxNxWddLSY+blNMqSVo8lRcO9SNoOH5yI0IdZijCdDQcUE1sGMlZqlU3AK5ZJCdjJOD+jL8Vq5k8w00ZZk1phzApL5cMihmxjoizRit7rrGSam2SE5veyBAmhG37FSjap/OX02Ys4sAdahGtz9cCfPz8b7p5sx3a27mDywrlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pHWDORWD; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a7a9b8ed69so1540095ad.2
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 16:01:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770681711; x=1771286511; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=wxSE1umC0cwB40v2IhEo0OCZVDQ+Sr9vwYOq0ucWta0=;
        b=pHWDORWDDYV5ePe6z9Av4dp+fQEEZ04x/6/BxsZo0M5/7YDoOpnUlQXnjxJMEqllcj
         tyP5evXYIcMHxmXfps4/FVKddhvoI8ngMFspeGVrXgq+M41lPUrsqh49UfJsUMTPCHHh
         PKsU2EtBOLA4DnLNe995uy4q1cR7uwf4nj0DT6jaZIZdc5Fal0JCqSSODlqK5YcLykFR
         s2Lq6tGP12af6bhz0uGNzj7bRGQjsKxbVfjJyWVwp048E3V8nppczJvf+MW38XZ3XEBw
         JrBrV0qBbcSMAAvRyU1yWEqQIa/oVmoI3UNOhrsiv2y+nBEZBO5sado5EFkDDwiTK10/
         A56A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770681711; x=1771286511;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wxSE1umC0cwB40v2IhEo0OCZVDQ+Sr9vwYOq0ucWta0=;
        b=js3G8nu0QdDRH7L4wDQHciB3AvqpWluhco3nTTH6C/MTte/LzzWKdoSTL4QL6PVdxZ
         sPwmI1y99CAsJJRcJp5JF9/2Yl9VSo8sMnRyK0TJxquw4UhcxlSyZ8XjYwoE6dc8+4oh
         P+m4Otz+r0Qrgp6vtLtXl4NI+qOZTkk7bgO5Dcm8HRROQBpuMqZhHVeCMK/BrdwYUSmL
         Xs11PQioa/U2NKqImqmundk5GYfH8rf5uxgOIAK/8kpksWZ8ZhqKjEYpTdPaZDt++roA
         85/5V7XX+NKh01gSSN/mOz9geJ0zr70RTvMy3q3pv0cRkTnTGswfzeCxTwMQUOlezj8c
         amKA==
X-Forwarded-Encrypted: i=1; AJvYcCVsBveNVwFCQFYD4dpK9D5Y30oZbKw3QpM9Zk1n97C7jEi80iA5XcmyYJFzsUgvVf7zid8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYNkE7wFFSiL1WaGF1n3c5lMq63chwth2QJ3ETDAE2/NkLxwmZ
	AXPTFf/x8zuNpR8eqKWpvw0OYdRJ1ug9kFwdOiF8gsQD7A5TOX/L/mhYni4/DbLaUAk=
X-Gm-Gg: AZuq6aJBCkeyMMMlnsaSxpgen784KngD0FTyhOnZx7fZCbZmkFpmmU9f0qWCvAB5jlQ
	3/8bg4B14gvgoBYrPRdnYdma7vfIFCeAWwEU1QMeVCCHgcP1dl8B9dW/RdA+h4KE9fKfzAIjBOE
	91XOKV4hJuNa9n8NvIsOSL7ntGd9gV58VqkUBhxwy/tZPE6qvJvRt6j4UUPNPyErbNzwjBnadjV
	ZsKDuYzU4991vI8HviYPBFTA0RKjRIANC3Gm27vGAd7ZPF/wbL0YZBIeinKHuDjVsuj0zrySIlw
	0II7Xmotu1WMtiQGKCUFmaOXuHUfJtIBlgMS+i/hniwuaqYeuwKzA0yAMV4UGKM4GPUasz1n39j
	EUGkBmYHUUOhA1nqygaH0L0JCdFbKnKGCBAS1HUbfb81AWLxv+o+91UdgKBJNlj03qsUasrCFqb
	PdWvUdHBkHqSbe0w0bI7Rlh+OxAnn/zitUP+zkK78QnSIxGyHbT7prOq5dMquzxGxkYZes
X-Received: by 2002:a17:902:e890:b0:2aa:d320:e979 with SMTP id d9443c01a7336-2aad320ec62mr88475255ad.11.1770681710880;
        Mon, 09 Feb 2026 16:01:50 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824416ca5edsm11297065b3a.28.2026.02.09.16.01.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Feb 2026 16:01:50 -0800 (PST)
Message-ID: <51df2f42-1fbd-42f5-976e-0ec51d06fc4f@linaro.org>
Date: Mon, 9 Feb 2026 16:01:49 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/12] target/arm/tcg: duplicate tcg/arith_helper.c and
 tcg/crypto_helper.c between user/system
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
 <c0b0691b-3cef-4ec7-8d68-227420167481@linaro.org>
 <b23e5d00-19cd-4eca-9cff-38ec78f87929@linaro.org>
 <11a09f7d-5274-4ac5-b6f2-90d9490751a4@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Content-Language: en-US
Autocrypt: addr=pierrick.bouvier@linaro.org; keydata=
 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
 ZtfdHNZotF092MIH0IQC3poExQpV/WBYFAI=
In-Reply-To: <11a09f7d-5274-4ac5-b6f2-90d9490751a4@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[linaro.org:+];
	TAGGED_FROM(0.00)[bounces-70675-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6A410115827
X-Rspamd-Action: no action

On 2/9/26 3:45 PM, Richard Henderson wrote:
> On 2/10/26 04:09, Pierrick Bouvier wrote:
>> Does a simple #define tcg_use_softmmu false/true is enough for you, or do you expect to
>> see proper ifdef blocks in all tcg-target.c.inc?
> 
> Just the #define, so that both paths are always compiled, even if dead-code eliminated.
> 
> 
> r~

Good, thanks.

