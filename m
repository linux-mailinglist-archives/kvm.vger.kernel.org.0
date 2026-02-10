Return-Path: <kvm+bounces-70699-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id I0/kLoTMimndNwAAu9opvQ
	(envelope-from <kvm+bounces-70699-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 07:13:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 2204F1174AF
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 07:13:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 43156300DCE3
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 06:13:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72628309F09;
	Tue, 10 Feb 2026 06:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="S3WTERyQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9330212D1F1
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 06:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770703998; cv=none; b=GFtImrOW8C3uHlD8xsLOgsO8mWZvMyNPkAa+U6WMvzCRNcg2ZiuM8eM+5dWa19Ni9cMkGB9Pi1XBHeA6WAz70l+slukJjf+vspqDyyrtOk3ef0zCC+qGFJvrj/JvyDc1van67LbzcJgKqebUnur1E7PYMDtUeDPJjW4cb8UIKBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770703998; c=relaxed/simple;
	bh=ghkygzXGJu9lo57PA+4obI58Ovh/PNnxF1KTSKbJjbg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sc6S8fVmKZrWtuBoG9xoQgviflAi4zfZsjH5/A2rmEI9EErWDQrbrnWFDfszA8b3hY4ou2Lew8N1fJ9yEPHKra/SVwTcRzFyS17smD25GPhgBO81xozaLXgNHZZe+ZRxfZ2ozxuMHKkSD7mebsu5v6hmWbvS5U2hRfbxYWlvpOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=S3WTERyQ; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-48039fdc8aeso2667255e9.3
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 22:13:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770703996; x=1771308796; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vHXJqY+bTMA7NO4H8MagDdzCFLfd9bAwBJC4v1JfjVE=;
        b=S3WTERyQftWUDZQy+DcHiF2M321m/3jdPuVac8ptmisU5kXmfr5Nep56ezbnnfjTCk
         4rpojfOAmjrmt149eM61qJFDFazJFtuU85q8mK2CDv4YuSZSuoH+vtnTsoEvKUrHhsvJ
         zKWpI5LA6uhYFDn4CiggvIr9IA5suCluwJVvrxrfwJs5RZHBu88XSF5m0ppnZycqleVg
         FnHUrLNLO5sDpSBne55KgR+1Z7w6yHagM1uCzPdS8VUjetR/sWOfGa/KZoanLToaaqto
         cRqeXzuxZI7j209veNFGDMaHfVxKVXStK5VVMsQBjKxAGXUjLfbn8Szsfnmw/ajI4rcm
         aEvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770703996; x=1771308796;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vHXJqY+bTMA7NO4H8MagDdzCFLfd9bAwBJC4v1JfjVE=;
        b=RLS6bA09DW2Ice0DCL+bn8bFgwzGQKp/jZ0eYEiAWJm+OKQoXtPuY2xToAI5y44g+M
         HeE1lMB1ouuXKzDX6Az5aqJFW5rH7mrw0v/c7ZijuGbXuhV2hIJrT/F2V10stmpPAxr6
         NDEghoRg2V5S5UwbacoRfgn08JLgObQIVF8+qwjn938rZDWtnB0cciV4qE7QZgz351jE
         NDO+nYFfn7NDC30P9+Yec5YrGk7oUQnvbVDqMWpgMCxN5jul2xqnKBEf5Dh2vLDFidzJ
         ETOY90TVz5W+BXiXe2PBfG8bAQIrmyzyk6z7T5N3MgZTz2FMXTWOtzw9yNMPGz8Hb+1I
         Cvug==
X-Forwarded-Encrypted: i=1; AJvYcCUcYVlt3iEA2Oda3n317CmLwll482cvYBPmxedW9/l5tXGMAJdWFpHv2FYAacIsChEabNo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZD/TrpFCqMyTOfDA7N4mkopo3DZPkrnZhfRhwHSlm5/iyJCC7
	ZA3vpu0tqy2n8nkSxJbd9ctQ+2mVpV0Vm1+lQhOJFDAFc1zhUhbxK6p6alZ1iK9Fl/Q=
X-Gm-Gg: AZuq6aIuaBdIAugJIXaK207xrgocax9ASCN9PoZP/5Zp7yg6LEJfRa7rR+lvGD5dGh6
	fczpsyA/Q6fNuZUpy9eE4fey79cyEQQMSrSLQbPBlydSRAPgq4rMLMRlQQVvdFVvsFvig2y3hSz
	n3PT5V/AqUoRFsCYTprsJCr1QUuUYmtXpNBgirNpoDBmWY+uSiSer4PUOTLdDeG1wdL/oQ7+yIc
	mDn4jelhMVOCgHxY7tj0ADU+yKqUlBgY3Pxc+DmKOymhfD24BWBcxEgHyVAT0Ed2gS4N5gbo2DU
	MfNsqSKuA3Hortu7KdP4q7OO1A3P1AbsJ0vCMPBWUsKbUw8Y7Bl+Nji7/tFow0fTtad73G7TmIM
	coIxcE1wB5h8TCJss4gbIZOPKIapDhYzsVov6Ym9HPNDfA0VD8mhyw6EOAPZmkC8tcrT9ZOryd4
	Ou9CdEwqmfBLAR6MYoZNEY+EyylLyd4oN/P3APL7DD5tX4TMNlqljY7WzfsNm2R/r8TPXzq8ikE
	avm
X-Received: by 2002:a05:600c:c167:b0:483:348a:d3f3 with SMTP id 5b1f17b1804b1-483348ad74emr119554145e9.18.1770703995930;
        Mon, 09 Feb 2026 22:13:15 -0800 (PST)
Received: from [192.168.69.210] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4834d482480sm40606385e9.0.2026.02.09.22.13.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Feb 2026 22:13:15 -0800 (PST)
Message-ID: <4a30491c-cd44-43fa-ae01-5c67f4b8bcb6@linaro.org>
Date: Tue, 10 Feb 2026 07:13:13 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/12] target/arm/tcg/translate.h: replace target_ulong
 with vaddr
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: anjo@rev.ng, Richard Henderson <richard.henderson@linaro.org>,
 Jim MacArthur <jim.macarthur@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, kvm@vger.kernel.org, qemu-arm@nongnu.org
References: <20260206042150.912578-1-pierrick.bouvier@linaro.org>
 <20260206042150.912578-12-pierrick.bouvier@linaro.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Content-Language: en-US
In-Reply-To: <20260206042150.912578-12-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[linaro.org:+];
	TAGGED_FROM(0.00)[bounces-70699-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[philmd@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2204F1174AF
X-Rspamd-Action: no action

On 6/2/26 05:21, Pierrick Bouvier wrote:
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/tcg/translate.h | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

