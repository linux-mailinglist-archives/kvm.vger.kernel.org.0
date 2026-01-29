Return-Path: <kvm+bounces-69569-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SFnyAuiQe2nOGAIAu9opvQ
	(envelope-from <kvm+bounces-69569-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 17:55:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E861B27EA
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 17:55:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C5FB93003822
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 16:55:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02D3D346766;
	Thu, 29 Jan 2026 16:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UUVKGhil"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B8D342CB1
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 16:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769705699; cv=pass; b=mzOwZ+Pfhqp6+ezs5XEUeZcFcrv7VkOPjdBg1hi1BkkVbqLw7Yhz41XDdbj7EYa0KIQ++JD9hGp2b+YKbh4OG0D1GOePF1V86wZ6Ic7IC0tAENrlRU2iLhYnpKWTbOCyzXfLrpDUNg+Qg1h1QyuGgqUdkKqJuXtwNrQVZQe2p6Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769705699; c=relaxed/simple;
	bh=4G47EEjFhfQZfbYifopHjluz9xuiDm0HdG8jST5wUwY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lcK27EYqWIAedOWTmnk46DCY2ZVGPmnj804W23ALV+5uGm53rGLuOqVtoCEFAqn+EgnyoJGNwNnm5LcKTBWEpwaBJpY5DwnOb21ji+ZTNZEss6IyzLXKdmDyyljQ1lNQ2vGVQBMrHFmYhH62eJCAgMOHkLcbM7t4phWKn90QEQ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UUVKGhil; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5033b64256dso453911cf.0
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 08:54:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769705697; cv=none;
        d=google.com; s=arc-20240605;
        b=SohrY6bEKk/4ri0nqhIpoT/bkLifr+5UbV9rAFP3ZPFCy8VZQ/Z6TzQcYD0Z4xsEVV
         OeJgG4cHUUvqcw1B5hKy0W1QHVIMLezEtJeJRUaOdrwIKpJjc3/dGtpMAdKZaiH0KvCw
         1fWFLcQmtLGoCtClS4kY2TJMPk2jwpEJxdu6WfcNy1eBHRljlIPiBy/WqiSw2ma5dy1u
         FRArbb6G+CjIiM9+4L7aOtjKtbf2SYfokgmreSNvmQMgmb72X5x1XeobFAgn4hxfmHNL
         JGxCMgW2YDpKIhP1yJ9ooGE5OwUVGyfTzJQyjMfPuhXHiBYR5DFLsLSJkMV7E0d1pBfu
         EWKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=lGnprIM0uOwwzce7Mf6HJCnNaV9WLSnSkIbwPkk6n4U=;
        fh=VU0SCt9FZPaCwVz0XvIEUVKqiw71qJV8t1e+gxEJRZs=;
        b=LYhPZgibdaQcNEuqPrlcjgug3M8XAggmldULxHLfJUxeSNYoLaMDPyO3XKMo8HmnC7
         SdsFRmCCJdcZO6TaFcgm54qRBdq31aUY0JfcYXp+cn0DcPpKUYBrxRvcl8eFxN45xQ2y
         /MfY1jzxMTt4nQnMlAerzjNKDhNquTNb+JTOwKRE1jZrYvfSu9sMJMmeeYB9NiiBY8gX
         nFnRhCyHg79ruAzFf8XP9ynpfx7pzu6+0cJkyEdfbQ3l19QIskhdoPAvsZ6qSTQK5HIv
         5+ZvDElh59MCbTngo0Rckji4NehUE5HKCHZq0o9QBgrUiFoC6GzDcawDxkZotxFhiXro
         9WCQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769705697; x=1770310497; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lGnprIM0uOwwzce7Mf6HJCnNaV9WLSnSkIbwPkk6n4U=;
        b=UUVKGhil9PWw18ITRM0mSOyx859uso1nov52Nuclq5q6r1dGJVCO/DvwezKyvEkA5U
         vZBRZNrK1msEA+vikTBef5flCzXbpPMFDUF5bnprXlzsXVhNO95O7DHoh5xy2HubcQZs
         ifHDkYzntS2tjE9Mm3BYPkpcqwawrddApF8/J1zVdG26UwLi3HOZsyZFRstUt7TyjFDY
         uyaXACu8g7Yf2+h6fbt1KahTjioSsmsezgyHp1bExVPZwjjWTs8mLItDAUhQ5GYQWcbC
         gBd4wcc8ZFjbb82tLUYjiQpWaCtR6WU/lQgc3Nbk/JATA6qxtK09D3nf3KTz9mnX+mpN
         P67g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769705697; x=1770310497;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lGnprIM0uOwwzce7Mf6HJCnNaV9WLSnSkIbwPkk6n4U=;
        b=oUGyOKUVCt2MAUX7ePgmWy7JOoEsSVnwc6QaPG8KG+J+46PB05dCLW4fN6CWSq8cgR
         kHd0dvkiF9Xzt8mAMKGU8saBTOjNIAHncyHcqU6lacWKrpLkjS8q8MbbOD1uUMaqxWK8
         HrFL9/+II8Ol1kQxKlx9O8zSgPfVxDG3RK6jheDJvkAPV6j0g+fIgb9gfv7gzYPC2Np3
         wZGmbN6r6e+xF/yCUeW5Mo1+N2vxNGga7FgUg4y/QwpOwm2HJh7YWpTAdOxTloHGTP2j
         QFsant5pxx+oXhSm8kchln8DtSSHWnKCwXM3i4rqZfN9s3zZcHhpwX9AZrCry5W+TG8D
         VCeQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwqd0aINycRbf5sxDyvKNLOJfgV8kLdxozCgwP+Hqbin6MQ/1Jq50L+9pyXmvM+idFXlE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6qbLU09an77rCJCpmKtpVQhEPRVCwuvVegWglGlmSx6vwaEBg
	LAUDUtJL05wjodzdbU6h3bsMRoLYeXcNX63eQLtcpkGY2E1lmyoxvaKo/H5bG96FoQ6hiNDWqME
	mXDZG4vVBKd9EJ+bVgAcw5loyaJfkHtY9Lhuf01iP
X-Gm-Gg: AZuq6aKmFftOWbrgQPJ+2gr1zvt4dFewBAOaTEMDqGIgEupVKyCSOEl1r6wqYl5w7W3
	2gypNn4Hgc6fFMfhFcdhhZWM4bVFtFZRJbVC84dVg9jhj+Sls3mzjXXTQG7MYaE1M+vWBHvz7QX
	rZ3HU2W6+1/M+r8dGbw8W+4K+iJ5jdPeLEzwA/KzWDOeAHKJp1PonGhMH1K3T1PfBbjixJCAAoL
	13YydGT0W1yGstO5cpo/adcHeDKqemyyilajSk4HKQjmoBoUNw4b6V7/lL1AqPlXiavq7+K
X-Received: by 2002:ac8:7c45:0:b0:4ff:bfdd:3f46 with SMTP id
 d75a77b69052e-504310ac4a2mr11072831cf.15.1769705696188; Thu, 29 Jan 2026
 08:54:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-16-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-16-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 29 Jan 2026 16:54:19 +0000
X-Gm-Features: AZwV_QieftfkWMiOf6SsY4TTgpSg92NfpZxoIL88Ar5MLjnc5YDmaX24FaMexnE
Message-ID: <CA+EHjTx7MzcU2pnbmFsbUsiy2b2HY=MRhZ_sG5YxYiTbz6VUNg@mail.gmail.com>
Subject: Re: [PATCH 15/20] KVM: arm64: Get rid of FIXED_VALUE altogether
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
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	NEURAL_HAM(-0.00)[-1.000];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-69569-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+]
X-Rspamd-Queue-Id: 2E861B27EA
X-Rspamd-Action: no action

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> We have now killed every occurrences of FIXED_VALUE, and we can therefore
> drop the whole infrastructure. Good riddance.

Indeed.

> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad
> ---
>  arch/arm64/kvm/config.c | 24 +++---------------------
>  1 file changed, 3 insertions(+), 21 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 187d047a9cf4a..28e534f2850ea 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -22,7 +22,7 @@ struct reg_bits_to_feat_map {
>
>  #define        NEVER_FGU       BIT(0)  /* Can trap, but never UNDEF */
>  #define        CALL_FUNC       BIT(1)  /* Needs to evaluate tons of crap */
> -#define        FIXED_VALUE     BIT(2)  /* RAZ/WI or RAO/WI in KVM */
> +#define        FORCE_RESx      BIT(2)  /* Unconditional RESx */
>  #define        MASKS_POINTER   BIT(3)  /* Pointer to fgt_masks struct instead of bits */
>  #define        AS_RES1         BIT(4)  /* RES1 when not supported */
>  #define        REQUIRES_E2H1   BIT(5)  /* Add HCR_EL2.E2H RES1 as a pre-condition */
> @@ -30,7 +30,6 @@ struct reg_bits_to_feat_map {
>  #define        RES0_WHEN_E2H1  BIT(7)  /* RES0 when E2H=1 and not supported */
>  #define        RES1_WHEN_E2H0  BIT(8)  /* RES1 when E2H=0 and not supported */
>  #define        RES1_WHEN_E2H1  BIT(9)  /* RES1 when E2H=1 and not supported */
> -#define        FORCE_RESx      BIT(10) /* Unconditional RESx */
>
>         unsigned long   flags;
>
> @@ -43,7 +42,6 @@ struct reg_bits_to_feat_map {
>                         s8      lo_lim;
>                 };
>                 bool    (*match)(struct kvm *);
> -               bool    (*fval)(struct kvm *, struct resx *);
>         };
>  };
>
> @@ -76,13 +74,6 @@ struct reg_feat_map_desc {
>                 .lo_lim = id ##_## fld ##_## lim        \
>         }
>
> -#define __NEEDS_FEAT_2(m, f, w, fun, dummy)            \
> -       {                                               \
> -               .w      = (m),                          \
> -               .flags = (f) | CALL_FUNC,               \
> -               .fval = (fun),                          \
> -       }
> -
>  #define __NEEDS_FEAT_1(m, f, w, fun)                   \
>         {                                               \
>                 .w      = (m),                          \
> @@ -96,9 +87,6 @@ struct reg_feat_map_desc {
>  #define NEEDS_FEAT_FLAG(m, f, ...)                     \
>         __NEEDS_FEAT_FLAG(m, f, bits, __VA_ARGS__)
>
> -#define NEEDS_FEAT_FIXED(m, ...)                       \
> -       __NEEDS_FEAT_FLAG(m, FIXED_VALUE, bits, __VA_ARGS__, 0)
> -
>  #define NEEDS_FEAT_MASKS(p, ...)                               \
>         __NEEDS_FEAT_FLAG(p, MASKS_POINTER, masks, __VA_ARGS__)
>
> @@ -1306,16 +1294,10 @@ struct resx compute_resx_bits(struct kvm *kvm,
>                 if (map[i].flags & exclude)
>                         continue;
>
> -               switch (map[i].flags & (CALL_FUNC | FIXED_VALUE)) {
> -               case CALL_FUNC | FIXED_VALUE:
> -                       map[i].fval(kvm, &resx);
> -                       continue;
> -               case CALL_FUNC:
> +               if (map[i].flags & CALL_FUNC)
>                         match = map[i].match(kvm);
> -                       break;
> -               default:
> +               else
>                         match = idreg_feat_match(kvm, &map[i]);
> -               }
>
>                 if (map[i].flags & REQUIRES_E2H1)
>                         match &= !e2h0;
> --
> 2.47.3
>

