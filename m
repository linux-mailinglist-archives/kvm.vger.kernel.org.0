Return-Path: <kvm+bounces-70575-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6AWAN35niWm68QQAu9opvQ
	(envelope-from <kvm+bounces-70575-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 05:50:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B3E810B9C7
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 05:50:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F2B9F3008A65
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 04:49:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E75925CC74;
	Mon,  9 Feb 2026 04:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pUTSO20s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED356A33B
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 04:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770612581; cv=none; b=l+RM8AY9W30tjDcP519KBq40WNUiKlc4iO8QIHf4dlgDPjezb+QmX9qxEbwOXZXVVZARjr/H9kAEMbi4leR9ejA4mMAVzxtA3IwJRrUECt0RTZZjGDWgqGd4x7CoppzZtSTvfe0B9iXYxCo5e51XOhqQrttPdSSeeggGI09NRtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770612581; c=relaxed/simple;
	bh=KwkiieoUcjMJkDYY43ogH3AE4wAXRk0Id+oESQsLcQ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dt25FA+6sRti6AKWsDRXDwz33Q1QPKxxISCQfLQa2mAwbTy558pcYHaYqeRHC3ZnB00+qGASoq5NnSGuBoZJ3wVD+fZ8xGhTLh3fH/6qn5/MnRux6hVM5ZkCh0LvSvSU9S6tHw52pt3DU80UEDF8m3I7HXHCf6NigmYmOwFkE+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pUTSO20s; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-81f5381d168so4413128b3a.2
        for <kvm@vger.kernel.org>; Sun, 08 Feb 2026 20:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770612581; x=1771217381; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jkJ5o8AGeg/mqjE1WI0/WGRZFm1PqmyUvMTB3WwatAs=;
        b=pUTSO20sORrEZeH+n16OJHu4FYRHtOnl/j457elFJJzOVmla7DDZPecxdf7zkIJg2z
         n2zYO5H9uirudZBKEWjQV3Rbs+uu98HOtZ65JtP7SwR8AJT1/nS3Ib69oPr4YEcgWS00
         D9j9RGuK16LvBghuWQsu2vc1xfm98nA8VZCG9jsm3wARCy/mY2tdSnxvTSC34spGJZJM
         iszcLlR3y+JDvegd03AjEFlPsG4Jj9IKchRN5MpvwBUgvbOVneGPc3ZdnRNjLGZqY9Fe
         FiXy6vNbX5VapuOeLK5R1KqysArlovtrZFqws8Q+YeoMnTpbWuB2juq+fL8oKzwKMyS+
         DCnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770612581; x=1771217381;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jkJ5o8AGeg/mqjE1WI0/WGRZFm1PqmyUvMTB3WwatAs=;
        b=H9AY+sQQks6AMy+7xIcwfx+ej208PzPiKWhFMNXjPY1KbyasQ1ObFHpPSrJs3oHblc
         043xHJOusSYwwjarhtUlNWdR6yHFPuIYo0qgueQfnMF1W78StJmiTPNDGGyYTaE8kVP4
         b842gQ0nwrxY3IqeNnm8+lPd4AkP969d9qHbuiMk6QWQoTBEXKj+ymkYCOBR01Grz9Jq
         tRi5Ys8P4VWIPtNKzZaxLKD4kZT3eim9f1t+E7dnRaZh4mAJnmwtGmI1OanrXX1dMyG6
         yKRGGmEyhVKBiNxFuoUZV62ZTsURsfQnMZABA4tOXXTt8vtuBixDzWa4UBUtiGee/Vz8
         vqEg==
X-Forwarded-Encrypted: i=1; AJvYcCV+pZU6JBucFhCYpk12DgQSYhnAvvzimpwPtVJBhjs1wcwd08SoLD92KHY1LXZXhsAOyIU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdbDYzoPBNVIq2QrVqWhmtIgDYq6uIzd+SNLmL4CiIIfDsd8aH
	8rom0c3UxgQ20nRrUfVvo/esp1AMwEUEcHN/hmbyHEbQjI8fqwh/lJgd11F/5ax+Akg=
X-Gm-Gg: AZuq6aJz7/lyGfEzICatjOtoRqEn63SyHCOLKiZHwAcL/NAWrbrK1nJmDtXddevvsBK
	j9K41CaGAlnH8ZmcO829S9o/hmW3lFKZ7i33brYLAs9OMrQLG5CjC2VRakOxvT2jINROgBJJzcF
	4MFBW5ZB4qoVWZuENnqDtHgVj1TY17T60C5565SLXXDMTKq4sXs5x6p3YZXpyqazbCOum+BLbM2
	quRMRbFZPTtIUAc3Nplykt8IAZU0X4eANVD0HFzHIMpAx50CiR8nKxAYbrvfaaO1itJcbKLMg1u
	1i8aPIH2uzyfcdzlSDrJpE+eX4CGsns3ErCAMVWK6RlFd0pbcjmGD71jiOduasUCkWe9QHFrci+
	P39IEIOjwVg4tBOpSsT7K1/OeANOA0FsI7O9a+sq5R70QVRU4od1UNOgiPfsnDhYCWRPIW6BTTp
	/Ksg0SGPcJuNB2V8iyozvl4eB7SGjAPEfHECh4jM5C/Xr0wZY2IRVcFBsnwh9quRst2Fd+G+oNC
	g==
X-Received: by 2002:a05:6a00:2c98:b0:81f:50ea:5da1 with SMTP id d2e1a72fcca58-8244161079cmr9706170b3a.2.1770612580898;
        Sun, 08 Feb 2026 20:49:40 -0800 (PST)
Received: from ?IPV6:2001:8003:e109:dd00:9c4:a3d:914:f9b? ([2001:8003:e109:dd00:9c4:a3d:914:f9b])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82441677169sm9503784b3a.6.2026.02.08.20.49.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Feb 2026 20:49:40 -0800 (PST)
Message-ID: <bfc4b21e-cdf7-4afd-b734-ba328f5112aa@linaro.org>
Date: Mon, 9 Feb 2026 14:49:33 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/12] target/arm: extract helper-a64.h from helper.h
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: anjo@rev.ng, Jim MacArthur <jim.macarthur@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, kvm@vger.kernel.org, qemu-arm@nongnu.org
References: <20260206042150.912578-1-pierrick.bouvier@linaro.org>
 <20260206042150.912578-4-pierrick.bouvier@linaro.org>
From: Richard Henderson <richard.henderson@linaro.org>
Content-Language: en-US
In-Reply-To: <20260206042150.912578-4-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[linaro.org:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70575-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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
X-Rspamd-Queue-Id: 7B3E810B9C7
X-Rspamd-Action: no action

On 2/6/26 14:21, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   target/arm/helper-a64.h                            | 14 ++++++++++++++
>   target/arm/helper.h                                |  1 -
>   target/arm/tcg/{helper-a64.h => helper-a64-defs.h} |  0
>   target/arm/tcg/helper-a64.c                        |  4 ++++
>   target/arm/tcg/mte_helper.c                        |  1 +
>   target/arm/tcg/pauth_helper.c                      |  1 +
>   target/arm/tcg/sve_helper.c                        |  1 +
>   target/arm/tcg/translate-a64.c                     |  1 +
>   target/arm/tcg/vec_helper.c                        |  1 +
>   9 files changed, 23 insertions(+), 1 deletion(-)
>   create mode 100644 target/arm/helper-a64.h
>   rename target/arm/tcg/{helper-a64.h => helper-a64-defs.h} (100%)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

