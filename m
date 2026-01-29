Return-Path: <kvm+bounces-69586-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EEmOGGKee2nOGAIAu9opvQ
	(envelope-from <kvm+bounces-69586-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 18:52:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 8888DB33F1
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 18:52:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C5370300D0D7
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 17:52:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09F1F3559E3;
	Thu, 29 Jan 2026 17:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L3jYyhN0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DA5347BA5
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 17:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769709134; cv=pass; b=JVnPnUbKh4YjlyceuTjSxcP+3qu3TUconmM2uuO/mzyv/6XnADVe2twddgsEZXixUxi1xEZw764eU8rW4Uz+oA0onR4PZxlV8NoG90uRTvgxYI4vTe8BT1ZgW00BHvZmp6Nz5MMsc+iXeyL/REZkXMCCx9E7f7MZVbC+iDzCzhI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769709134; c=relaxed/simple;
	bh=9Ak46LEVCwhOJ4dFCTIpVOefYezUL+JMSUS/w3aykog=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nXkr3+VKkHCpVEcsBca/+Cp89Y31ShJRQ/FvkHctvHMvmWfeS9hLxCKNy54rYxQwBZeIdSI3dQGetCMz97/WPz/LbEXsLXD6cwlXlDidrjzIf34Dgqh9tP53wb9lfIYhpogC/zplgoRA1LvKGPmm7a0O2I4ilRY+foBU7Gj3duM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L3jYyhN0; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5033b64256dso1851cf.0
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 09:52:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769709131; cv=none;
        d=google.com; s=arc-20240605;
        b=kxYC8BZCrTID55g0YWjMHh2wF1X2O7YKLOnOchfpaJN5ex52/SJ1ngxyLvAHV2ZMoH
         d2u7ETyKl0TNa3qrLL/SnxG5+3Ca/+nBbt3u0hyyTohCrqnz6SFzvgJvAG0vr47mIRro
         3Cw0HPuEYcGxXeTVLJBqLvmJwsU71ZZh6tLCAP3QWMZSmmn6/EePARPE5Hi7taUpWAm7
         TaiUKWXc6clMiDKPiRvYrv3rOBgHijLknBTtkS19xAXYP4oCvgbpQRNVwbf2hc5zbItj
         mXxNnKGoGBQSVTOoAttQ/sIaL6XxLxjJuXhDfXE/5ILbtRcsBCd25+nFjTi3Usv1w4BH
         T2BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=rFkUGWSSI69uP0vyiVno+p+O/XXB1AsOCXVbUdPg2U0=;
        fh=MiZ/0JnhaR1a8cHpvJjTisDse3CgQ+uPswvI4cfw5Jw=;
        b=b2AuFNZYEFek5nnQTt4n4jchJe2j7O/hcoWZCE+AugqNboZDoJWCQLqdzpKwJT8ET0
         vg9cIXFY8ej0Qg+9Lr3T7TWgB0z4Vs+F2cCf+LxeSOyxxCzgB10+rTla3HOp+GHHjOme
         c2othgwzeQJ8BQzdQYg8UafDx30TCrQplQixRD0G1jQSayoP+Hs9hUSpDaDM33MpIwf7
         D+5rtE3GvabDWGYz6NdfeFCwZqhDiG1w42uOkmZEqyRcW3ZGl4YFs5Oq3HHy7xoLr5E2
         vmrgJFol/8Oo+YK/H8BzzxRUKVZWKKqYv0OZAo5DoYMHHtJp7FRRsmhuNL6iymhiGq1i
         b1mQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769709131; x=1770313931; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rFkUGWSSI69uP0vyiVno+p+O/XXB1AsOCXVbUdPg2U0=;
        b=L3jYyhN0nMEjLbb8d5sOa74TFfvX3cFSQtm0waBJvyYaCHS03Ty7/pPelzVCWNmxX6
         wUI3U9s8LXYa6A7kBvJaAkktbtHrIJgpKeELrsxA9cMQ+QgrQx8Dd5BFPuorVv04/7xr
         SscENUrmyXgJpHlA63LlEErx56bLf9QbDtvYLsknVBrAMEZSxSyZ2VrQbkO4awl0FLN4
         hvj8u0UncwRP/ECTYoPFvk7GBFGthq/u1uk7Tpi8+edzUH0TN9P+wEpGBp/ZKzWYE0gy
         d9jGo+cTqhWoN6otDw+QD6A+uKy19wd/jOV7hZ2ioJfCMOzmqNmaKWuI9JOx5j19LhGw
         QTvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769709131; x=1770313931;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rFkUGWSSI69uP0vyiVno+p+O/XXB1AsOCXVbUdPg2U0=;
        b=ZjPzdXcgrKarKekSr4Q54rP7OXFaQyI9tn7A5k1TdilsAW9cGEHCblIqO/Pc2CMvs1
         lVVyHN6VJUQGILrUFV4TpFrFBjUCPLNKoljS8cLIgKaiNrJ8pRL0oD1Rvbgc0eoDRuVq
         KIvMhbDoCxi1j5/UQbWSFHsh/EvW9EcbzuUqEkmD55ybCZozH+jdxMr1I1jvehiUJf+B
         B18kG5cKfee78izPkGEVADAQJ1aJhtOw/gDRQxSeqiuURUTLTa1niUKp8PrMaKM3+a5/
         dVO+lmaJr58sJwHABpsnDfJxHj1gHov1vizxGonWjKFbgVlTnDP0A3lMO1SxMi1b6tvU
         lTdg==
X-Forwarded-Encrypted: i=1; AJvYcCX6FFFyr6aIrJGAsZ35UkMcDtWkomDr9uORKc4PTFXPzjr5bE0/aW/QHoir/ml8CVgO8EE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwH54ik4fvxXkQ9GeDf2wPvgWo1SE3rY1n6WWgeO5RKGTR9S67h
	ZXxPvv9KRmp/JYOJvZ9smHDfRmHWT1zzbP57LIOxS1yk/boW31FT25iSfhHjnwLB1wrmHGbxMCo
	c0NZkWU9eAgUEV4DmroDeZY3/u5zLPKDYvueIArUE
X-Gm-Gg: AZuq6aLdYT8f++NHkV83zKp6oFeJ+JTVIHdpEDZIsduzg1uIAi6qVLmL2QG5GCYbQT9
	wdi0SMKQPj//crAAqIZ8ceMtTOW05DeUr7FoYsgDM4wK5xobw3JFB0WkhCkPWxxUoAYutiRhDAE
	ce4/M0QZBBQvSNXzCUL/1qht4clZYrWziGJQZuR+KqScnjWEhH+/Ky26hJNJh1iLUcztQGdhxPn
	EMFKlorloxRJQmEl5yJW0TIZbv8B9ZVCxYasnMSB9e2VBphZrGTMhapxat/1Lw+ZZn/fx5c
X-Received: by 2002:ac8:7fcd:0:b0:4ed:8103:8c37 with SMTP id
 d75a77b69052e-503b6705a55mr15283421cf.12.1769709129198; Thu, 29 Jan 2026
 09:52:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-19-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-19-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 29 Jan 2026 17:51:32 +0000
X-Gm-Features: AZwV_QhPQvIsUhtu0m4Xb8tRLlQCeNpAfaZsDAJefW0mGcGoCi3YrpM0LthDHFU
Message-ID: <CA+EHjTxJbWkCcNimSGYHSgjYSp4xGuEk1cwf4Dc5giQAM74Bhg@mail.gmail.com>
Subject: Re: [PATCH 18/20] KVM: arm64: Remove all traces of HCR_EL2.MIOCNCE
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69586-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8888DB33F1
X-Rspamd-Action: no action

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> MIOCNCE had the potential to eat your data, and also was never
> implemented by anyone. It's been retrospectively removed from
> the architecture, and we're happy to follow that lead.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

The field HCR_EL2.MIOCNCE is deprecated and made RES0.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad






> ---
>  arch/arm64/kvm/config.c | 1 -
>  arch/arm64/tools/sysreg | 3 +--
>  2 files changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index f892098b70c0b..eebafb90bcf62 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -944,7 +944,6 @@ static const struct reg_bits_to_feat_map hcr_feat_map[] = {
>                    HCR_EL2_FMO          |
>                    HCR_EL2_ID           |
>                    HCR_EL2_IMO          |
> -                  HCR_EL2_MIOCNCE      |
>                    HCR_EL2_PTW          |
>                    HCR_EL2_SWIO         |
>                    HCR_EL2_TACR         |
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 650d7d477087e..724e6ad966c20 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -3834,8 +3834,7 @@ Field     43      NV1
>  Field  42      NV
>  Field  41      API
>  Field  40      APK
> -Res0   39
> -Field  38      MIOCNCE
> +Res0   39:38
>  Field  37      TEA
>  Field  36      TERR
>  Field  35      TLOR
> --
> 2.47.3
>

