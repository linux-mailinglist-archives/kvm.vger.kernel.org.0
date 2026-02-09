Return-Path: <kvm+bounces-70576-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KK1rFA9oiWm68QQAu9opvQ
	(envelope-from <kvm+bounces-70576-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 05:52:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AF69D10BA2A
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 05:52:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 742893014577
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 04:51:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 062FE266B67;
	Mon,  9 Feb 2026 04:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TjhGeTot"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C038230D0F
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 04:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770612662; cv=none; b=qSX0Jy/ARHj0prRrXzifjyUZ4CSrIUc5/HtQFilAREm5H9bmBSi+djWwgDaagVs5+ASSsbsDL3k2LTViksMaAH56tgQVR/6PX6jkxXr7smmM/eudnXWhcgOguPAsbJZNuq5EP8/Nt8vIa7Czk3zwpaY2P2/jsMewyN8ET5vAaq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770612662; c=relaxed/simple;
	bh=L3dSri1nMA7TnxAbdkZLBznl01U+fdQWjuX3ER6E4dY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TffdE6rUvyBmlQiLGVHiKuyIJJ1OD6qff4xqyS7rKFXnBpn4NrHw3kzwqQBWPXRQEBabdp22VM7QTQxpSKDbUGv+votOKLENOnHZxwZwJKyc/ylNzILBaaU3FCroG70OnB4xY0OnQMqojTru/4M+R1zCqTYn1lvScESJJe7ovN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TjhGeTot; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-bc17d39ccd2so1412864a12.3
        for <kvm@vger.kernel.org>; Sun, 08 Feb 2026 20:51:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770612661; x=1771217461; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sYxljEzI4qhILVqWZJsPbUTbIJXqqc+i0wg7PjR7g5w=;
        b=TjhGeTotvxybJH1JNpl7smTIJf7uVNaA0NOvyoqAEim3Z4HEIJIPPdOzUesEIMKoWC
         Al4VEdTVrCCVWpEWPaBji0GxovP/rUEd8bciYYeAWCP1vFp/YV7dbzEMORVOTnsjQNBV
         Ni+mSPxbVyctT1fkPK024Iwe3qWvJIkeNCu1n6hxlPIDi8Py8kVlBloNbW+qlD5DURMy
         ljECdfrMTw+h7Rn7V3MIhaX7TAcn/3/0Ya79fVu2cgnh/ukV/dt9C+29al4yNqdHrOyJ
         VRXN2CMxtxH2ArTH3QD+zRtwyUZdcJkeIvBOQ0fz4/3ZrvMY8JGNNdjFCOx3AmHPuUbO
         avww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770612661; x=1771217461;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sYxljEzI4qhILVqWZJsPbUTbIJXqqc+i0wg7PjR7g5w=;
        b=UHr0n+H6CxSk936I5BWMEX9ErAPhIF7S6o55wluiagJbtVbt+84Ewyqm61dz0Bt5m0
         ZCRmLfM3QKuHWpVgXp4Ei8l3B2L9HHZpT/KGGxZuYXm8UXJbZnx8tqkRMxg7UUEpDBih
         W4haNOWCa11B3qwsEtNPVMVmuD4dcgBuDf6Gw06KUWM0BYZs8bvOZGqN8OeWz2vl1f5P
         C691fxzGNoMu/PGybXMhroeCTM4XlNxmKgHdocF7KDY6rCqvSPQoliqkmeQey+3VaLAu
         VdGQtJNX9TFeFOhWdJDePJK5cmJ1VAmn7XEWDyvUyTXv0Qh+t5ePWk0X63wB2HuD2I7c
         A0tg==
X-Forwarded-Encrypted: i=1; AJvYcCUgJkmxNuIz54RE1rZsJvn9q2bd6GoB+Xdb9wpr7eIuif6SKB9iZLQBspS/AA+tQYp+Xtk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhnNPA2H6e70hgsCBV3BtwsAHDGe4Luj5J0Xf6Ec30a9hp1Nc3
	+kf/ilfQ8G9fi1mNbsM6LScAEK0LeJYUFAeCosbqYKqN9Bx9ton/xnV0wlg7re7UTwNSGdw5UM7
	QrgungTY=
X-Gm-Gg: AZuq6aKecxJlpJMbBS+k4gwBYP1BlWLxST0kTVTummSJnyGfD+stw90P1SYu4IxgwQk
	zNDylodclKgbztrXOHV+abIsuACHOmysJxBlj72zrnBRHpDMZLVIVmJIQN3uvYhNthoziCuewqw
	UXYI669vL6WWFN+LiCH/+TiAetU6anVPE5/VdTyaMqdFJWs9PP/J7D7AZVzIAlQXESpVO0iIDMU
	co4Hxi+LvrAx6bWVNtHVcFiXxjiTEFq3KCbkJlO42ILNFxRIFbEKO83ZCww/BtcbqmOAdcdiMHr
	hVNmA7paz4eq1VXdPQGpCIEhJYgM1BWO2fll73iQdFGa3DhMr91fGkT3M3vM1FJeykGqG/GbDwN
	SBiWTrADG+0D0Rpk8ODEpSNuOdqm1gbpZ6iHSU1rCJpvqFE0cKsaCiRZ7+lO6Bi2o9nKvCnw+nU
	ITg85W0SaxJgAfNCuS3G+Z7CHRh78wly2C80EsUUNAWwBFeI6LpuMvtGPRPEApSLQ=
X-Received: by 2002:a05:6a21:9206:b0:38d:f084:e349 with SMTP id adf61e73a8af0-393ad36aa0amr9240615637.54.1770612661289;
        Sun, 08 Feb 2026 20:51:01 -0800 (PST)
Received: from ?IPV6:2001:8003:e109:dd00:9c4:a3d:914:f9b? ([2001:8003:e109:dd00:9c4:a3d:914:f9b])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6dcb526676sm7792821a12.12.2026.02.08.20.50.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Feb 2026 20:51:00 -0800 (PST)
Message-ID: <962bb0ea-0dc0-4cf7-91d0-0269ac645bcb@linaro.org>
Date: Mon, 9 Feb 2026 14:50:54 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/12] target/arm: extract helper-sve.h from helper.h
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: anjo@rev.ng, Jim MacArthur <jim.macarthur@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, kvm@vger.kernel.org, qemu-arm@nongnu.org
References: <20260206042150.912578-1-pierrick.bouvier@linaro.org>
 <20260206042150.912578-5-pierrick.bouvier@linaro.org>
From: Richard Henderson <richard.henderson@linaro.org>
Content-Language: en-US
In-Reply-To: <20260206042150.912578-5-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[linaro.org:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70576-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[richard.henderson@linaro.org,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linaro.org:email,linaro.org:dkim,linaro.org:mid]
X-Rspamd-Queue-Id: AF69D10BA2A
X-Rspamd-Action: no action

On 2/6/26 14:21, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   target/arm/helper-sve.h                            | 14 ++++++++++++++
>   target/arm/helper.h                                |  1 -
>   target/arm/tcg/{helper-sve.h => helper-sve-defs.h} |  0
>   target/arm/tcg/gengvec64.c                         |  3 ++-
>   target/arm/tcg/sve_helper.c                        |  3 +++
>   target/arm/tcg/translate-a64.c                     |  1 +
>   target/arm/tcg/translate-sme.c                     |  2 ++
>   target/arm/tcg/translate-sve.c                     |  2 ++
>   target/arm/tcg/vec_helper.c                        |  1 +
>   9 files changed, 25 insertions(+), 2 deletions(-)
>   create mode 100644 target/arm/helper-sve.h
>   rename target/arm/tcg/{helper-sve.h => helper-sve-defs.h} (100%)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

