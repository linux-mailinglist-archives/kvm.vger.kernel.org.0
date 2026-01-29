Return-Path: <kvm+bounces-69584-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YHdhNY6be2m5HAIAu9opvQ
	(envelope-from <kvm+bounces-69584-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 18:40:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 81755B3110
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 18:40:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E581430041F3
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 17:40:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 395C63542D4;
	Thu, 29 Jan 2026 17:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R3i9cZ6i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09F3353EF8
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 17:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769708427; cv=pass; b=FtdVmsnUnmD4pP/o5Ug37lQZPF18Tjv/qduxfdB+j4sa4Mb3d/l4dFcL5lPvuaDRtVPpcbcigpknUIJeieaHY1jpNQ44G4QQpwNDK/leaMCm6UZ38/Axhz/ebzDOtzYyC5mj4DiURg+nhHc6eBCahsSiF2MCA0bayXD1uoZbVLk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769708427; c=relaxed/simple;
	bh=xdVu8OJgzy9v9aQHZ3Bnvas9n3HUplybL2o+SRSYzgY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i8DyTp8mfRFoN5Uy+qec1TwZOYTwyH9ZxTaldgzd4IEl4DZA7thaQ314tnqK7ocm3gvm/0hR3cMi7bHOQ+lpei0gfWPVcCPhEf6G5vRYdZezonYRa61Sfw/mtkazHMyN5F7jfkGgd5FFP27M7ZFJHW3jJI2mCtvuti8ShYhh/EA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R3i9cZ6i; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5033b0b6eabso675091cf.1
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 09:40:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769708423; cv=none;
        d=google.com; s=arc-20240605;
        b=RoIXhTVEq0OADHFIv+NkhBp2l0L+PbEiBzNNHQlaM0hRFv7ShMU6Gzco8jf1djhL5r
         tN7rlVtPv1Bcd4etbh2+LaV2uEmr5wAfx3dqW4tD7Y3qZ//ELG4VQyx6mGbRVGbECSfD
         Xa0chlu4Jw0IakyFfZMjLlXDyxZKF7tX2yUc8+828v7Bm5yeWd6QQcpzyqYAdhFCaXmF
         3H7PwQwEMXaUu7gQboPC+DDvbU07A8UMldT/EVI1FI/5No/GeAONNmO+Z3fjMwqnhxi7
         Yu5hnSSql/ClcYOYLvxyIzd0x78kCprY3H+J0NmUrP1BzoeysVj+8nnLVjBhLR9djugd
         HtCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=C9PI9Qi8HDlLbV57o548904J5pG00v1lKuCCnBvJ6co=;
        fh=nvWKNGjiyMKjX5uczgOHxQeq/Bm1Ucyau27Z9oMq/ic=;
        b=PkSXnnFN0zgokpf+XweNABFUxHlA+S+siVTZt76g+egvJ3o2/0zTebK+eUnDzwSAfB
         7cYE5jxVTzA3jPB9GKPpl1TIkIJC99BQKHx+voA8tawgW3b4AvfIk7cYn4W12n0d6+KI
         w6Zge6JER+LvcKY64bNndKNHVxFusEk+ecrX5hYgQr+1ueMh1NFZ4s0tl+gPKbwWCrQ5
         1due/R3EjywOTI7xaDdVrB3t7wvNgjrk5sRizbYuVY/imAAH6dPPUOJxXg7EgQray+sG
         hJ5444Lls1vqKoI6wxDT4pqDozrFOzEM3rlKl78Xpgmm1Y9IEavYO2TYjnvXYKASMfvC
         nmyg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769708423; x=1770313223; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=C9PI9Qi8HDlLbV57o548904J5pG00v1lKuCCnBvJ6co=;
        b=R3i9cZ6iHPdo2hXxhpC9aN3CSHvttxTDFNdWWRAChYGPsl4K9QCegAnXqX3qE+P3tM
         UzUprHbswIxQ0yaK8lQhDGx9DaG4uwk+D+g9+MS03FshW13mxfPFfxP3awchChdMij6k
         7Him1Lm7XPSXz2e4UTMoWYKLGf6U1JZiTMT+N6x3VMLRpkRpznWbv+CSMbxPFcpv3kIB
         zl/2WEd3/AniJpWK9bkw2By0h6gsZo9rwGMjqX/AgYLts45meLdkshbADYm6iTUF6sNr
         mJvnuFKJxx4e20/3oEivx62fa4NqUhUXDkp5oSPV5rppL08n8V0clVYN0DIzmP3/1Hy3
         +VWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769708423; x=1770313223;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C9PI9Qi8HDlLbV57o548904J5pG00v1lKuCCnBvJ6co=;
        b=b1HJ8RbJfrXb5mUdVKDFSJfkhco8QwfBmChODyWj0zMaPHBqa+2dr2U2d6SVQl1AXO
         AEiFyu7X9930pTcT0v5lM/Z1zyueniSiqyQ5YLxcMQFIuINy0O1UWsGu8HqE28j2pQIy
         cy+YwNG8Qfna9dVS7edS6eY6oBzchcbaMuamXxGD6m68yKvL+qYbhnyys6JU09ih0lYe
         yqT6v+p3pOl8zVDUoniIDAnVGp0eKZYY+v+FV/fTWSJbzs1fPNCNZUj5wKPLUSAbMRqH
         Be68icfeiVixlwRpsPItvgYtIE6iTuyjGuS8pns/WO8O6ZXSjijm54o54XkVxbgB7L2d
         6BQg==
X-Forwarded-Encrypted: i=1; AJvYcCX4mgKwY7SEoA0FWsTe+wHyO1svzTNLNsMWZ3La56gxURLuJOWDVbtl9JjRYibT/aDBHqk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUe/iKBWe8bkafRA45S8loqoxMjDUDwEr1IVNj3z/N6CuqK/sz
	cI4j/JGVylnxN5CO/6q3Tns+TwpU+779BxsfT9XDD9XKHrefJodydMn7KPCdI/14m65giUI9djW
	g11cbDMXUknAhNxnG2zv5oV3jF0jX19PQSQtdbuI2
X-Gm-Gg: AZuq6aL61Z20y8SIYx94t83GFui403S+7py74xo9ilfO2Uty3EQZEWp4z1lMlgarUcA
	DIZ6fUYuuZfNFFAiahEKAZDuNklskOtmUl1uxOlHW4HD8JCltfGOXr1oCaRV1aTKVLAQ7c/cMfZ
	McIAHtQIZW57put03lMufWW8PqM9ih+LJKUydt3GxIbEhEjdHBYqCFzBU5QGzHzv/1ZjohWO5EH
	AGMVen2Nq3Vm4F75wKBy7Q19P2gLCvKMCk4R6GrYxbz48Z1TZHibZYbPTMgu/s+NEvLl93l
X-Received: by 2002:ac8:5a43:0:b0:4f1:9c6e:cf1c with SMTP id
 d75a77b69052e-504310b4cecmr11694721cf.17.1769708422703; Thu, 29 Jan 2026
 09:40:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-14-maz@kernel.org>
 <CA+EHjTw_4WJgiS7vTUprvJOjdNrnW=sjhazCkU9eQW8BUYuZZw@mail.gmail.com> <86a4xwbakk.wl-maz@kernel.org>
In-Reply-To: <86a4xwbakk.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 29 Jan 2026 17:39:45 +0000
X-Gm-Features: AZwV_QgS_ySXSV2SHoit8uIkCqZLoVSe3rfHiqo21RvB3vOxbqAI8dmocE5xOnU
Message-ID: <CA+EHjTyf5Zhb2JFbg6jv1opCX=GV9_PMNiMo=0fCc9cYxzEAiw@mail.gmail.com>
Subject: Re: [PATCH 13/20] KVM: arm64: Move RESx into individual register descriptors
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69584-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 81755B3110
X-Rspamd-Action: no action

...
> > I see what you're doing here, but it took me a while to get it and
> > convince myself that there aren't any bugs (my self couldn't find any
> > bugs, but I wouldn't trust him that much). You already introduce a new
> > flag, FORCE_RESx. Why not just check that directly in the
> > compute_resx_bits() loop, before the check for CALL_FUNC?
> >
> > + if (map[i].flags & FORCE_RESx)
> > +     match = false;
> > + else if (map[i].flags & CALL_FUNC)
> > ...
> >
> > The way it is now, to understand FORCE_RES0, you must trace a flag, a
> > macro expansion, and a function pointer, just to set a boolean to
> > false.
>
> With that scheme, you'd write something like:
>
> +#define FORCE_RES0(m)          NEEDS_FEAT_FLAG(m, FORCE_RESx)
>
> This construct would need a new __NEEDS_FEAT_0() macro that doesn't
> take any argument other than flags. Something like below (untested).
>
>         M.

LGTM. Not tested either. I plan to test the series once I'm done reviewing it.

Thanks,
/fuad

>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 9485e1f2dc0b7..364bdd1e5be51 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -79,6 +79,12 @@ struct reg_feat_map_desc {
>                 .match = (fun),                         \
>         }
>
> +#define __NEEDS_FEAT_0(m, f, w, ...)                   \
> +       {                                               \
> +               .w      = (m),                          \
> +               .flags = (f),                           \
> +       }
> +
>  #define __NEEDS_FEAT_FLAG(m, f, w, ...)                        \
>         CONCATENATE(__NEEDS_FEAT_, COUNT_ARGS(__VA_ARGS__))(m, f, w, __VA_ARGS__)
>
> @@ -95,9 +101,8 @@ struct reg_feat_map_desc {
>  #define NEEDS_FEAT(m, ...)     NEEDS_FEAT_FLAG(m, 0, __VA_ARGS__)
>
>  /* Declare fixed RESx bits */
> -#define FORCE_RES0(m)          NEEDS_FEAT_FLAG(m, FORCE_RESx, enforce_resx)
> -#define FORCE_RES1(m)          NEEDS_FEAT_FLAG(m, FORCE_RESx | AS_RES1, \
> -                                               enforce_resx)
> +#define FORCE_RES0(m)          NEEDS_FEAT_FLAG(m, FORCE_RESx)
> +#define FORCE_RES1(m)          NEEDS_FEAT_FLAG(m, FORCE_RESx | AS_RES1)
>
>  /*
>   * Declare the dependency between a non-FGT register, a set of
> @@ -221,15 +226,6 @@ struct reg_feat_map_desc {
>  #define FEAT_HCX               ID_AA64MMFR1_EL1, HCX, IMP
>  #define FEAT_S2PIE             ID_AA64MMFR3_EL1, S2PIE, IMP
>
> -static bool enforce_resx(struct kvm *kvm)
> -{
> -       /*
> -        * Returning false here means that the RESx bits will be always
> -        * addded to the fixed set bit. Yes, this is counter-intuitive.
> -        */
> -       return false;
> -}
> -
>  static bool not_feat_aa64el3(struct kvm *kvm)
>  {
>         return !kvm_has_feat(kvm, FEAT_AA64EL3);
> @@ -996,7 +992,7 @@ static const struct reg_bits_to_feat_map hcr_feat_map[] = {
>         NEEDS_FEAT(HCR_EL2_TWEDEL       |
>                    HCR_EL2_TWEDEn,
>                    FEAT_TWED),
> -       NEEDS_FEAT_FLAG(HCR_EL2_E2H, RES1_WHEN_E2H1, enforce_resx),
> +       NEEDS_FEAT_FLAG(HCR_EL2_E2H, RES1_WHEN_E2H1 | FORCE_RESx),
>         FORCE_RES0(HCR_EL2_RES0),
>         FORCE_RES1(HCR_EL2_RES1),
>  };
> @@ -1362,7 +1358,9 @@ struct resx compute_resx_bits(struct kvm *kvm,
>                 if (map[i].flags & exclude)
>                         continue;
>
> -               if (map[i].flags & CALL_FUNC)
> +               if (map[i].flags & FORCE_RESx)
> +                       match = false;
> +               else if (map[i].flags & CALL_FUNC)
>                         match = map[i].match(kvm);
>                 else
>                         match = idreg_feat_match(kvm, &map[i]);
>
> --
> Without deviation from the norm, progress is not possible.

