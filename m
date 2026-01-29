Return-Path: <kvm+bounces-69530-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aGT0B3c4e2k5CgIAu9opvQ
	(envelope-from <kvm+bounces-69530-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 11:37:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AC527AEE34
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 11:37:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 48C5830A703E
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 10:31:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BF823815D2;
	Thu, 29 Jan 2026 10:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ylgOJRGl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D7B3803FD
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 10:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769682696; cv=pass; b=H1uoEGoDEuQNiKE2upCL9ImzpnPZlzFBZgqI9xOoGFTWdGq3Nf96p7zMCDbIncSrw3OKmX2L6zk9jgvU5o0sHCI89wDMQ8YTkhG5ermJ8VzsB2lwzglDcYL1BIGE54NVJ1Z+Wpno2+BwWIcPbeh+IAcg6ndXkSZVM1KMT0bSHrE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769682696; c=relaxed/simple;
	bh=kvQm0PMPge02EX/21kcgDn7eBjAxgiKovy6R6OS32r8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CCqdKCNCsNZc3ym5Z99iP3bOWQAjs7VFOKuIs6SePL8RYTfS3xsf0V1RRP5Yv8ibcOrUO1wq1pOVkd8A5r/W6Jq9abcaoy7ZvCmuFv4WNBHWXYUOxLyxBbOKa4+SpTR6vmq+DBGBRQ7F5LzHuyMFYGwtjDkCTcXCAvxwQP8iSZg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ylgOJRGl; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-50299648ae9so356611cf.1
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 02:31:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769682693; cv=none;
        d=google.com; s=arc-20240605;
        b=gA/S4JM156MsvY9JKmxzbhoWKOj8yBbKDXW8A6pGeuum9oPeGi8gmj9T55/V8Uh6dF
         up0UHtPVfoJKNn4wV57k12XqEqL1R0nEOrV6g9NRWuc6G0W/CYcFyPoeWThLGaJpWaZz
         hkFrMbPpCFyYcU8pz72PmAo5rXGMfj0TwQDcn8oFxHDSPN6NOVzih97tIHUy8Ok78XJW
         6GDGMpfQgQlKAVkYp6aRIap+21EQoRKw/jJukL1jHe4BPTHtQ7Ii9jeaUCsuLISzui/C
         voYXRehFoPHsygYvRng2kghDQzBT7bppx+FM6MKNEQAYIQXWy85sneNmhJoUT+wHR5TW
         nMow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=zO6ULjWkwKOa6nt1pqPrr7dCq2tIVIRxD42Sn5fil18=;
        fh=dhcm/rH5WzIuQPLp/yO4JqoRC6to9YBZadWagTGjHcY=;
        b=c6KGbZpBqTsh9fjl08i+d6s/8MgdiT3JGqXr2/TBTMoYb7VMyPauOIDGyRk2S1bl8I
         xOMDQIjshvlM3gPX74QwkGSV8CU0eZCUmTcgJnbzM+7y/VPr0t9Mp2zePgHX5WJ758oI
         Aze9xIv43XJCR2kgqa2WmAWDR2Em4pm16DcyS0O4fxxnWpnus1EgB/84onP6iyxgGIvP
         PNdC34py2TO8/yDN2gmJwcz8NnWxfBUTGILdT7GhuTSqD9WbbieleDX3QYJUvT6BhvlZ
         TcIWsvfweKJTH00m58rUFLx2otwu/6bTG+9CbYtsCDpp16EagYAnTLH/wa8G+zB65FJi
         x0PQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769682693; x=1770287493; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zO6ULjWkwKOa6nt1pqPrr7dCq2tIVIRxD42Sn5fil18=;
        b=ylgOJRGlCy6/SX+rLf22cUz20C4CJvMbuDyZRRVLw6LvbijAmUFDfjWfDLWslVLyhu
         k/HZ2AMevRwFCJ1yNfiV/K+DqDR27lr8JnDO4yvODHJV39S+83v3cwZ44/tG8RzJF4a+
         CDMnDXlvXmZgVLAyDR+8CV2GXkqqY3iq8J0Qnc2Ylsp9v29iBzg8kUm1vtmHzuQ0iqiC
         Maw6/HfftctzalNWKYYm0bbMAKB4YUYS1dVnmqoLXFbb1H7iZ2JCb96PqSzg6Fz2Ffzf
         7hUApw5qcHnl6BuZ0k5KcX63HdgErYjkbOcI8Ahs7itS4wLG3fEJu+1CuCeLD0T0YOmb
         577g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769682693; x=1770287493;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zO6ULjWkwKOa6nt1pqPrr7dCq2tIVIRxD42Sn5fil18=;
        b=cRnMKqbLE1O6hRTOBWDI4Q4bwXahltTJeKIh3rL8ZhRCEqPGpuxzAiO1LkOy3A6OOW
         ue2A1PfOZQnNOI2/A4ERHSgIGicfUoQazknu0/pRrrnMUS5WqCZubXJ9wVfoVK9ioxLp
         8HpyMQuJooSVz61OORRnHdOMAQflOj+CFQB1wct+aW5fXj2L0ahNYY6bfl09bUb3yJqr
         upfin+H6f4T4bN8BiYKvujg0tXDlp5eWu1bWfSWr3dJ0qdhMvSYg/W268B7E3U4cGbf9
         TXPhjBHKUv2q7PoEdC053f5LyiI5VHL8FEFnsDyz/8VTy0FwOzzgCaiptV6fxHbTHVym
         XimQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvoOdegY9GN7YiQdXWOp87lattVWASKEbnLyhWNqH2YH5cp8E+c+tBLHw0C8YaHDefHuQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyR08filWJQnP8wsPw7s8LqioSXA0OQhIz2wHbMDue1c9fOH0f6
	F+TgijdZOwf94WNxi3l3waDLyg3Cq9pXTZ/XaSrVy4ISY4JGLJomZCddoPQEOQirMPGeOg2PKdJ
	vcIrKLbx77eFWCT8qAn7skG0Qr+8s7l/kBa2yV5SF
X-Gm-Gg: AZuq6aL+3nGKyvAShw3mzokX0YzIA5FlpCpacxHVHOtUJzsq7wvUtvZsztLVmLvAWas
	+aR4c6apgN6hNF+PME2K0vxGTUmgjsvVqULMsz+y0DmGhUq5freytgyux/OKI5xH1fZR2nGviZM
	RJXWsO7MRv0ACY6iTX/t6eT/N/n1exj6ramugJcR8cOi3TOlAm1vYA5Z4dVA8mQycReqeqLq5vu
	tNTXHl5iYQjaEeoGhqQFZmEaA/rvosMiX+1jg1zRuCkuopEdAEJEcMHPC/q8bRa32CBAA37
X-Received: by 2002:ac8:7c47:0:b0:503:2d8f:4cd9 with SMTP id
 d75a77b69052e-503b67573e4mr10564691cf.16.1769682692446; Thu, 29 Jan 2026
 02:31:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-13-maz@kernel.org>
 <CA+EHjTzL6bNZ=sZoub3GY=VZ2bJ+4bFr4jkuiMMBCEqXuAkQPA@mail.gmail.com> <86bjicbu9f.wl-maz@kernel.org>
In-Reply-To: <86bjicbu9f.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 29 Jan 2026 10:30:56 +0000
X-Gm-Features: AZwV_QgqI3U9H1Cbj8nMPhTIPfiH9Gdegl3zrhuYCGMvoUDbuda-PJQ9wfvc9AI
Message-ID: <CA+EHjTwjTa6QbKONdSNKR2GP8L8qy2q8yF-eyomQBkamUykc+Q@mail.gmail.com>
Subject: Re: [PATCH 12/20] KVM: arm64: Add RESx_WHEN_E2Hx constraints as
 configuration flags
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69530-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: AC527AEE34
X-Rspamd-Action: no action

Hi Marc,

On Thu, 29 Jan 2026 at 10:14, Marc Zyngier <maz@kernel.org> wrote:
>
> Hey Fuad,
>
> On Wed, 28 Jan 2026 17:43:40 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > "Thanks" to VHE, SCTLR_EL2 radically changes shape depending on the
> > > value of HCR_EL2.E2H, as a lot of the bits that didn't have much
> > > meaning with E2H=0 start impacting EL0 with E2H=1.
> > >
> > > This has a direct impact on the RESx behaviour of these bits, and
> > > we need a way to express them.
> > >
> > > For this purpose, introduce a set of 4 new constaints that, when
> > > the controlling feature is not present, force the RESx value to
> > > be either 0 or 1 depending on the value of E2H.
> > >
> > > This allows diverging RESx values depending on the value of E2H,
> > > something that is required by a bunch of SCTLR_EL2 bits.
> > >
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/config.c | 24 +++++++++++++++++++++---
> > >  1 file changed, 21 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> > > index 1990cebc77c66..7063fffc22799 100644
> > > --- a/arch/arm64/kvm/config.c
> > > +++ b/arch/arm64/kvm/config.c
> > > @@ -26,6 +26,10 @@ struct reg_bits_to_feat_map {
> > >  #define        MASKS_POINTER   BIT(3)  /* Pointer to fgt_masks struct instead of bits */
> > >  #define        AS_RES1         BIT(4)  /* RES1 when not supported */
> > >  #define        REQUIRES_E2H1   BIT(5)  /* Add HCR_EL2.E2H RES1 as a pre-condition */
> > > +#define        RES0_WHEN_E2H0  BIT(6)  /* RES0 when E2H=0 and not supported */
> > > +#define        RES0_WHEN_E2H1  BIT(7)  /* RES0 when E2H=1 and not supported */
> > > +#define        RES1_WHEN_E2H0  BIT(8)  /* RES1 when E2H=0 and not supported */
> > > +#define        RES1_WHEN_E2H1  BIT(9)  /* RES1 when E2H=1 and not supported */
> > >
> > >         unsigned long   flags;
> > >
> > > @@ -1298,10 +1302,24 @@ struct resx compute_resx_bits(struct kvm *kvm,
> > >                         match &= !e2h0;
> > >
> > >                 if (!match) {
> > > +                       u64 bits = reg_feat_map_bits(&map[i]);
> > > +
> > > +                       if (e2h0) {
> > > +                               if      (map[i].flags & RES1_WHEN_E2H0)
> > > +                                       resx.res1 |= bits;
> > > +                               else if (map[i].flags & RES0_WHEN_E2H0)
> > > +                                       resx.res0 |= bits;
> > > +                       } else {
> > > +                               if      (map[i].flags & RES1_WHEN_E2H1)
> > > +                                       resx.res1 |= bits;
> > > +                               else if (map[i].flags & RES0_WHEN_E2H1)
> > > +                                       resx.res0 |= bits;
> > > +                       }
> > > +
> > >                         if (map[i].flags & AS_RES1)
> > > -                               resx.res1 |= reg_feat_map_bits(&map[i]);
> > > -                       else
> > > -                               resx.res0 |= reg_feat_map_bits(&map[i]);
> > > +                               resx.res1 |= bits;
> > > +                       else if (!(resx.res1 & bits))
> > > +                               resx.res0 |= bits;
> >
> > The logic here feels a bit more complex than necessary, specifically
> > regarding the interaction between the E2H checks and the fallthrough
> > to AS_RES1.
> >
> > Although AS_RES1 and RES0_WHEN_E2H0 are mutually exclusive in
> > practice, the current structure technically permits a scenario where
> > both res0 and res1 get set if the flags are mixed (the e2h0 block sets
> > res0, and the AS_RES1 block falls through and sets res1). This cannot
> > be ruled out by looking at this function alone.
> >
> >   It might be cleaner (and safer) to determine the res1 first, and
> > then apply the masks. Something like:
> >
> > +                       bool is_res1 = false;
> > +
> > +                       if (map[i].flags & AS_RES1)
> > +                               is_res1 = true;
> > +                       else if (e2h0)
> > +                               is_res1 = (map[i].flags & RES1_WHEN_E2H0);
> > +                       else
> > +                               is_res1 = (map[i].flags & RES1_WHEN_E2H1);
> > ...
>
> I think you have just put your finger on something that escaped me so
> far. You are totally right that the code as written today is ugly, and
> the trick to work out that we need to account the bits as RES0 is
> awful.
>
> But it additionally outlines something else: since RES0 is an implicit
> property (we don't specify a flag for it), RES0_WHEN_E2Hx could also
> be implicit properties. I couldn't find an example where anything
> would break. This would also avoid the combination with AS_RES1 by
> construction.
>
> >
> > This also brings up a side point: given the visual similarity of these
> > flags, it is quite easy to make a typo and accidentally combine
> > incompatible flags (e.g., AS_RES1 | RESx_WHEN_E2Hx, or RES0_WHEN_E2H0
> > | RES1_WHEN_E2H0), would it be worth adding a check to warn on
> > obviously invalid combinations?
> >
> > Or maybe even redefining AS_RES1 to be
> > (RES1_WHEN_E2H1|RES1_WHEN_E2H0), which is what it is conceptually.
> > That could simplify this code even further:
> >
> > +                       if (e2h0)
> > +                               is_res1 = (map[i].flags & RES1_WHEN_E2H0);
> > +                       else
> > +                               is_res1 = (map[i].flags & RES1_WHEN_E2H1);
>
> While that would work, I think this is a step too far. Eventually, we
> should be able to sanitise things outside of NV, and RES1 should not
> depend on E2H at all in this case.
>
> I ended up with the following hack, completely untested (needs
> renumbering, and the rest of SCTLR_EL2 repainted). Let me know what
> you think.
>
> Thanks,
>
>         M.
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 562513a4683e2..204e5aeda4d24 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -26,8 +26,6 @@ struct reg_bits_to_feat_map {
>  #define        MASKS_POINTER   BIT(3)  /* Pointer to fgt_masks struct instead of bits */
>  #define        AS_RES1         BIT(4)  /* RES1 when not supported */
>  #define        REQUIRES_E2H1   BIT(5)  /* Add HCR_EL2.E2H RES1 as a pre-condition */
> -#define        RES0_WHEN_E2H0  BIT(6)  /* RES0 when E2H=0 and not supported */
> -#define        RES0_WHEN_E2H1  BIT(7)  /* RES0 when E2H=1 and not supported */
>  #define        RES1_WHEN_E2H0  BIT(8)  /* RES1 when E2H=0 and not supported */
>  #define        RES1_WHEN_E2H1  BIT(9)  /* RES1 when E2H=1 and not supported */
>
> @@ -1375,22 +1373,15 @@ struct resx compute_resx_bits(struct kvm *kvm,
>
>                 if (!match) {
>                         u64 bits = reg_feat_map_bits(&map[i]);
> +                       bool res1;
>
> -                       if (e2h0) {
> -                               if      (map[i].flags & RES1_WHEN_E2H0)
> -                                       resx.res1 |= bits;
> -                               else if (map[i].flags & RES0_WHEN_E2H0)
> -                                       resx.res0 |= bits;
> -                       } else {
> -                               if      (map[i].flags & RES1_WHEN_E2H1)
> -                                       resx.res1 |= bits;
> -                               else if (map[i].flags & RES0_WHEN_E2H1)
> -                                       resx.res0 |= bits;
> -                       }
> -
> -                       if (map[i].flags & AS_RES1)
> +                       res1  = (map[i].flags & AS_RES1);
> +                       res1 |= e2h0 && (map[i].flags & RES1_WHEN_E2H0);
> +                       res1 |= !e2h0 && (map[i].flags & RES1_WHEN_E2H1);
> +
> +                       if (res1)
>                                 resx.res1 |= bits;
> -                       else if (!(resx.res1 & bits))
> +                       else
>                                 resx.res0 |= bits;
>                 }
>         }

LGTM. Treating RES0 as the implicit default simplifies the logic and
makes invalid combinations impossible by construction, which is what
we want, as well as being easier to read.

Thanks,
/fuad

>
> --
> Without deviation from the norm, progress is not possible.

