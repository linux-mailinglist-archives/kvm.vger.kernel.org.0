Return-Path: <kvm+bounces-70578-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ECm3GeJpiWl08gQAu9opvQ
	(envelope-from <kvm+bounces-70578-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 06:00:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D518D10BB12
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 06:00:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0DE7E300AB1A
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 05:00:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F44B2C0F6D;
	Mon,  9 Feb 2026 05:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UkaOb1h3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B83B2BEFEB
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 05:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770613209; cv=none; b=hXA41mDAHjpNF1g9JLdMZgkCeia4xcDTh1mdVmPcyjtNHe1YVZN6GIgmiISk+gzN7BbwbTmX0XpmeIofQPdeer/wQLjoBkkN86+8LxKSyM3MqCrqu5HU68bIbSEja8kDGDuEgYf7DuTZC+n251oaenaqXrRSkbKPd1aL3/8cFB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770613209; c=relaxed/simple;
	bh=4TZmEmq4LwWt7NwFhalV6haBCQbzM76AF24C9S0yVi0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GpjN9CoRfSgg49GNesh68VK7tJ+l2jf00tP8xeSSSy8h5Eovg+s2/V6ssA4jK5m9vQW4t14FkEh9RwLOWFSPpyrZkY3pLRtEMcqQrBDq2JLclRBli0vrG6SYnixa1zjp2g96nl1OdBfELP8HvZTBdzJynQF9mEvRHzupvFjHnZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UkaOb1h3; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a91215c158so26360855ad.0
        for <kvm@vger.kernel.org>; Sun, 08 Feb 2026 21:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770613209; x=1771218009; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BGE/+xwSc4Hh0s32nfOa3ei12tI+LjHdNW7Uiw62Kqk=;
        b=UkaOb1h3b59ujPM3gUfgOmk/d8Q8PJQuXe3FLlbplCMfSYqY848a7+DgTQiIrCrVrD
         XLfHsTc+m7lgGDXL7cRqurLBDskNGRqpQjjGi0aOyCZdOWzwvyPhWt1ZwtJSTHKkShPw
         fUUM8ScDt7hFMPQbrQJ1qPXQ/tVpr884Y6Gtyd0l3DNJOsYKJeOLmTnpBdjRl3Uzwbst
         Nvh+mk+FhxRb3/Wqwqf9v2L7Zt/GEVFMFJHG9xvfHh5BJwqSDXmCrJK8khRn7eN3Nq/K
         O+33spWNk745SHm314idhG+YvP5SDvAZRTv5IzliJj3ZMtfqi/k3KwcnIRwsEqLIyoI3
         iJrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770613209; x=1771218009;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BGE/+xwSc4Hh0s32nfOa3ei12tI+LjHdNW7Uiw62Kqk=;
        b=IQS7H6W3YB09s7xD/e6Epa8gNQzICqvURNmDNtg1psqh625PZOxzNtjkEZdszB0tv/
         umHXHIAcqfxR+5eCn2ZMxqntojCG0gpor/ciAKNys0EvLBd8SmApvo2If6KrJXht/1lC
         nqC4JAugZjQ3p4wC50sSFEt57lBQiye5KJUEsY/JgGNinMLnJ/rtGskpT79gdMRqTKH4
         A7i3D1C0YdM+lxq0PjpmYi3nU3vabTuMk9ZXp01sjgoi8MIeiPIzYkgkL0AJxti9wcgi
         hr3pkmwDmPTnD8C5ajLvUxC9dmq9a4bbD/OM7S/Dt7aeBIhigLtX5lBuhkKJ1MwqWCFG
         ujnA==
X-Forwarded-Encrypted: i=1; AJvYcCXn8o16wyBNDp4tXnX9NkkR2/PADbAwQu/Q7LxOgwEr3uLnNCasm/linU4qybuynX+WFxg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9BWS1PvvYlkh5eHzQYdXk+UVj7RIGcgANSyo76ihOQn1A/nOb
	ViOlxdUmASFLV9Lc0UMrGlWI2PB42E2mrhkBVxgh8xG9noNfurQgbQCs1eGpoUhbJpI=
X-Gm-Gg: AZuq6aIvaz0iEFeT9QbHbyjjdO4MRYsM3sbLpDr70om5w9EANbUt2f+VrrFRhuxNlgw
	n0Ti1cU5/Bd1R595x5l/6QffmlD7FXzCRUvYEIh+UylM+uNF4MrlvmrdtfPnGuykMqzRz5X+5TP
	NfoSClwv08mI/nbeB9VHGXC1rA7rvv7U2jJg2GfeMFEN2gEzif6zJVVifnCjtH7SXkq116Lr1+j
	t6f2SlipQy9gUHd1Kpml059q7eInRq00tpruD+YcV6dWVKbn6NQWQyu3UMLMO4X32/KYzo8Z+yM
	7k+o1909qBNM8AjzY+0s0wdoncZNNze+pVw3veO3owLg+tjFjtJNnTpiBQC1Fusfndmd7HwK9MS
	5/i3YfB8ujnrCv+tdWPOtaMQ2Dve47oz0/Oh4+aA6UgR6KT73G7KLkDN0idi2E2mEzUjB/WFrFq
	X5Lz4SW4zHzvVPLJWw5P6Bnq1ELBWq5U93YZMbuJGebpS9cTu2T+RcvfSjwqMO81HKB1vqT/cvp
	g==
X-Received: by 2002:a17:903:2ac6:b0:2a9:cb10:42b with SMTP id d9443c01a7336-2a9cb100973mr62690615ad.44.1770613208567;
        Sun, 08 Feb 2026 21:00:08 -0800 (PST)
Received: from ?IPV6:2001:8003:e109:dd00:9c4:a3d:914:f9b? ([2001:8003:e109:dd00:9c4:a3d:914:f9b])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a952217ffdsm104199295ad.88.2026.02.08.21.00.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Feb 2026 21:00:08 -0800 (PST)
Message-ID: <6c5eb308-56e6-487a-ad7b-8f0da70ab7cd@linaro.org>
Date: Mon, 9 Feb 2026 15:00:01 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/12] target/arm/tcg: duplicate tcg/arith_helper.c and
 tcg/crypto_helper.c between user/system
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: anjo@rev.ng, Jim MacArthur <jim.macarthur@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, kvm@vger.kernel.org, qemu-arm@nongnu.org
References: <20260206042150.912578-1-pierrick.bouvier@linaro.org>
 <20260206042150.912578-7-pierrick.bouvier@linaro.org>
From: Richard Henderson <richard.henderson@linaro.org>
Content-Language: en-US
In-Reply-To: <20260206042150.912578-7-pierrick.bouvier@linaro.org>
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
	TAGGED_FROM(0.00)[bounces-70578-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[linaro.org:mid,linaro.org:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D518D10BB12
X-Rspamd-Action: no action

On 2/6/26 14:21, Pierrick Bouvier wrote:
> In next commit, we'll apply same helper pattern for base helpers
> remaining.
> 
> Our new helper pattern always include helper-*-common.h, which ends up
> including include/tcg/tcg.h, which contains one occurrence of
> CONFIG_USER_ONLY.
> Thus, common files not being duplicated between system and target
> relying on helpers will fail to compile. Existing occurrences are:
> - target/arm/tcg/arith_helper.c
> - target/arm/tcg/crypto_helper.c
> 
> There is a single occurrence of CONFIG_USER_ONLY, for defining variable
> tcg_use_softmmu. The fix seemed simple, always define it.
> However, it prevents some dead code elimination which ends up triggering:
> include/qemu/osdep.h:283:35: error: call to 'qemu_build_not_reached_always' declared with attribute error: code path is reachable
>    283 | #define qemu_build_not_reached()  qemu_build_not_reached_always()
>        |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> tcg/x86_64/tcg-target.c.inc:1907:45: note: in expansion of macro 'qemu_build_not_reached'
>   1907 | # define x86_guest_base (*(HostAddress *)({ qemu_build_not_reached(); NULL; }))
>        |                                             ^~~~~~~~~~~~~~~~~~~~~~
> tcg/x86_64/tcg-target.c.inc:1934:14: note: in expansion of macro 'x86_guest_base'
>   1934 |         *h = x86_guest_base;
>        |              ^~~~~~~~~~~~~~
> 
> So, roll your eyes, then rollback code, and simply duplicate the two
> files concerned. We could also do a "special include trick" to prevent
> pulling helper-*-common.h but it would be sad since the whole point of
> the series up to here is to have something coherent using the exact same
> pattern.

tcg_use_softmmu is a stub, waiting for softmmu to be enabled for user-only.
Which is a long way away.

It's also not used outside of tcg/, which means we should move it to tcg/tcg-internal.h.


r~

