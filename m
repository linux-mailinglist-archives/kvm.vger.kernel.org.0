Return-Path: <kvm+bounces-71340-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MD4RFwzalmlJpgIAu9opvQ
	(envelope-from <kvm+bounces-71340-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 10:38:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D10B15D69A
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 10:38:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1DED93006905
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 09:38:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02E5B31AF2D;
	Thu, 19 Feb 2026 09:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wZZ/G/gE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C049145FE0
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 09:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771493895; cv=pass; b=Z8r9+AK5IfNUFPv/VAbuNc91zEGszx+enbHdZC8mplLqrfmb8yi/sUfWvmZupJVZg/1JChUEQrw/z8wPOmGnx6eP28NYmr8YTwN4P4YtVWUn38U4Cbzkl1QKZsoCe68VXLAknpVBCrkc2b8AatI1yxfj/1K4mO1fK/cx8sGzyP4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771493895; c=relaxed/simple;
	bh=gpuxha4eRNUboHr/8D8+pnu56CeGJjt6qpHHARu8F6s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j1E9/g1KagtGydKcpHGxzLEVwsy/vMTXxtW+xLDieUiWCg17odQuj7LNmpOsYVxatpfZ1sDblb7PM3agtthlockEwq2QZ3bAbIqh7o89ZA9FTP0333P+/4qLR7K0LfSR72J8T4i0wmfemO9eb6ZP+Qhi+a80Co0il5ZwY7NuZFs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wZZ/G/gE; arc=pass smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-64ae222d978so692298d50.1
        for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 01:38:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771493893; cv=none;
        d=google.com; s=arc-20240605;
        b=TZsvr8bcloEPVDOABH6g+SqkC9+/McynQtkyooq9kTRFJuZZUsc6DPUayLaZhMtWEV
         97r7ttuJ3MIztK34tmM2FLwiwgSHARNvyAfa6zrIBVoK8fO4bt7wQM2nsE7hp895YybJ
         xSl+Xl9LwnElGs0ofGkWfYwoIJk10IJCY891O10HKzs9HPEBzHB3GsT5MmqgefajSfwp
         e46fXk3MmvHe0tTmyp0MPT1LZgoGiNlp0JeYqvspcVy4xIkjg51AxHYDFDrypyiv6z2Z
         stqEKOp0uthr9URDXzrzeht4Qv3Yo+ZFQEuPQQWZmw7XC+T4KS7DDWJ+p92iX95Lb9zl
         tB5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gpuxha4eRNUboHr/8D8+pnu56CeGJjt6qpHHARu8F6s=;
        fh=6CYNPJtQyJdhmAT6DfLnReMg+ygVgGSQHBvE6Us++/A=;
        b=OeHna3XDhfjaYNZEwFU2I1nyCL6sqF/1a31VU+v9R0LqZiNpFEBVRO8NP4qiok8M6O
         KM4xVf5zcQQg8jCgYm+tI1wietc+d0/OPZ/8V5cfQ63co1ikx9JFrTlRHpXuu1cQ54KU
         2KbK93DduJVUiuW2u9ZBGIER7WB1hAe7NFiornp3zOh6fe7ueylkW1ywXBrV7/Du2cfb
         C8qGoEYaGTbBKpbh6/klnsH0biP71irlchiNLvgeyv9IPgvvjcPiMCfAh+i1dKsW7D5R
         TVqDMdMtZ/2vyM37g3wiWuiDIC6ERtzPXOli+f4gl9HzlCm6VpclFE73JynTeVPFeKbx
         z/7A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771493893; x=1772098693; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gpuxha4eRNUboHr/8D8+pnu56CeGJjt6qpHHARu8F6s=;
        b=wZZ/G/gEVBM1y8MojEtLeVX/lEHXHS3xdvf4dbpQyRiO8+vJlzV9Qd3CHkBTL8FmeU
         2QK7vLT8qTh8pMvGu+t6Rixk2t1KejyIgcuYOrDWv1ggEiVPB30bwJ1N3N3/aqa0x8vy
         noBBCIsw3Xf0gQ15c1g5756Z9iT9Vmec8mBC2eeIqPvS3k1MdH1XnCROW6cN09QuFwdF
         f2fZXVak+2/z6T/Nh74A71tamdiUMTG/eq3QO3jCGFShV0wbI0ChvLKP92lmKqvyzf0y
         UqYC0O8bLdTtpTZVXK7k9j6QMwPlPZhaVOu8yclvM5ma+ib+A6tOC7OYilBbuJS27kVH
         pjoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771493893; x=1772098693;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gpuxha4eRNUboHr/8D8+pnu56CeGJjt6qpHHARu8F6s=;
        b=AnaLad7DtgYUycv69JYlLEPngicgXkRv+1OrBMEEyKIvsrbXYKHrVQTs/V9X1w7GsO
         e5PymkViMy5zGCMpyALoyW0ppdD/KsxxNvXf7/dMgFtQi1zdHuyAZJ7eAOn2clx/MT43
         tIZpQg+ytu0A2Y6wuNCgbVmTiOeTLg4Qc5UHc9lqDZw2KC7Q8B0L57X79sJTKam/hMDc
         f1BcgOFUmU1cpHgx+hDDpeabk/L3XiAitjyVGnL2jrk13J7FhEdrOPTVcv3Zxi+oNjQh
         UxtduxneWetxjH/Pb6liW+BgfC55oo2yLutHfg3EX+B4P5dhHOBWCk3QdlI0fNa9eP3h
         LuRw==
X-Forwarded-Encrypted: i=1; AJvYcCVt3wUiZSDOLwag7xx0QGCgaXoZEk+MGFbHxumTdFxfj8VtwUPRQxgrLu2XfpPEX+I3Kxw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzA353YdTozbt6wUe1SBPEAl4VdD9kowDhYapLwjT5dRvue59aD
	f2V5nKvbbD8JvWLLwpXDFYpL/67LFpoEbEONj0Erhjl5gpSMLnSnAc9ykoR9Goy7m53+QPJ0kKl
	InfK+VBEOIAcJvrBSoSZ4yBQuxtVc8bgAIjciaSWW2A==
X-Gm-Gg: AZuq6aKfbVbEv75JZfgjZ0wIKH3i9o2kBL9+eN7zQVNlRcNvGEPhsxp38+8KZ6fOkA1
	OTWXl1FPvPYyTKYoFoJKVAe5OyFQRrkvziiHOgPCeXhLtcu/BgxyQ1q0oLpPbz3Gplh5EkmhT8x
	AfX0Bb+h9ewqYQ/qLh6ew6+YN3zGE5bdEgc9ySeyAWmUAMZ2k52LJbH8hvNLr11PUIELqbihvH/
	3fK8wQYg1e5n3B+nj5aUVwet/PYNCCorLY+OXu9iAe2js70SMXx8n4fWCRpJ4i8yxXjfEEnew5Q
	gh6AcMFPvf26IhUixecr24eVQEv6/IiZhpBN+8joN+2jpvHLVVUKcxT02RYbtsi/p6ayle0vxiM
	CCg==
X-Received: by 2002:a53:b6d1:0:b0:64a:d607:30d7 with SMTP id
 956f58d0204a3-64c614c5a1emr1352603d50.78.1771493892946; Thu, 19 Feb 2026
 01:38:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260219040150.2098396-1-pierrick.bouvier@linaro.org>
In-Reply-To: <20260219040150.2098396-1-pierrick.bouvier@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 19 Feb 2026 09:38:01 +0000
X-Gm-Features: AZwV_QgPxQm_4WHz5YVXddgB8CRBzKT1jW4-rQRItT93j70YpskswASSwVfG8rI
Message-ID: <CAFEAcA__tnvy9dUUPrEG8jynGGSp9iz0H7Q2MFGdw4--NDH-ng@mail.gmail.com>
Subject: Re: [PATCH v4 00/14] target/arm: single-binary
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Cc: qemu-devel@nongnu.org, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, kvm@vger.kernel.org, 
	Richard Henderson <richard.henderson@linaro.org>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, anjo@rev.ng, 
	Jim MacArthur <jim.macarthur@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71340-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peter.maydell@linaro.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,linaro.org:email,linaro.org:dkim]
X-Rspamd-Queue-Id: 8D10B15D69A
X-Rspamd-Action: no action

On Thu, 19 Feb 2026 at 04:02, Pierrick Bouvier
<pierrick.bouvier@linaro.org> wrote:
>
> This series continues cleaning target/arm, especially tcg folder.
>
> For now, it contains some cleanups in headers, and it splits helpers per
> category, thus removing several usage of TARGET_AARCH64.
> First version was simply splitting 32 vs 64-bit helpers, and Richard asked
> to split per sub category.

Thanks, I've applied this to target-arm.next. Patchew says the
last patch here is the same as it was in v4, so I've copied
the R-by tags from Richard and Philippe across.

-- PMM

