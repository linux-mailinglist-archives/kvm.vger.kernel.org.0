Return-Path: <kvm+bounces-69564-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KIkSD4iMe2mlFQIAu9opvQ
	(envelope-from <kvm+bounces-69564-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 17:36:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 92DB4B2416
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 17:36:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 080303011F1D
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 16:30:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 889D63446AF;
	Thu, 29 Jan 2026 16:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Nstv9PYM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C7F313281
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 16:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769704220; cv=pass; b=Bo05HLVIbfRg5zAze/LytBzDr0hLfvAVW7JrMH+sGCWnigulWSk452UVb4EYTr7XxcwAw8L9cbTy0kd1PHl9KrKAHOdMgJx6zVKh71Qm8FCoSxkDcrx38koh1E7Us5tJxaJTWiXnp7diBpVLZ2nEX0P1UJjHMxji9YS00X8t9a8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769704220; c=relaxed/simple;
	bh=h/Cx93hJfrTfffFA6Rug9AC4SNMrQ7BqZU5kiWeUNTs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=biS1Li2v+0AeT9imH2f5wQoWehvPcLe2Edpx/1a0BWwMKCOMzgicmcuYzEqkhS3c9ZhcN53JqinVwfL2pTfbaM7evg9gKNE5cA+wm49DehIltWfJKkFBo2ohi87roLnvYjoKzG+yo/jtF2CAYzsFVKUCaGV2oF88fn5J7OubhH4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Nstv9PYM; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5014b5d8551so516491cf.0
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 08:30:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769704216; cv=none;
        d=google.com; s=arc-20240605;
        b=WY7EJUz6w0is0mRZyXXrFtf/A/OtCCrSmioDoLWQCpf4vJZd9RrmpznzrQmEo8NOTO
         DkWf+I4W48ciP8e8vMznl5blRkP/6Nrn63pP8m+KW//HtY8zjwWNzObmgte8Ult0H6Bo
         pjaJ1PvtXARWu3QXUS0nB4RrnUiOX1mb9fuhbKGW3Q0xpBdCQGFBYZWt22rb6eI6d13u
         sWe19PfyXK4sbFs1B7nG9PvOv4KkaW5t8+PLacD+FKEweTnL8UJWWj01g0UQzAKKIHNn
         xgDvy4sx0aGXrsjHD+s9F/WBPWYDbNvtd232p8pjfVpLJYFltxLDGAMMFQ2m9NSERaAY
         rfMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=vQMIKkFFYhu4sIg3A2teqJk96QiqeuS9EHouVKYLx8Q=;
        fh=4lWOFIaT10c9XbvfqaDID94YVlzFHhGf0nTKBanOjxk=;
        b=G0rWuBZ5/TIMxkWOEjhuCtLCkNgKPz5TKpKCxhHnqu3ch/1kFqTPb1MKfpKJRKVSpO
         YpaYxQW7ETpDj8xFr4uoFPNdGZFyfhL3ljWe0d1YfXU3mW+5R4XEHwzAs2Br0zBdbrad
         gbiM4/EcY6II3kW4AWIYUjW/1VNq6y2I1fmzwy8nUcZ5Vz6hBbvn6vSDzZO1RZoRzI8M
         RRySc+yRfr1YXrto5rKqRtuBZNejRNR6jwYgdn1/3EHJlARliMF3X45ApakBqdvnwshZ
         AGMG3YI493qwn05S4VCNvQuB+6hdZu0KrGxkWWrc41aUtpJgzbdQ1zd5N7W8gk5NR4aA
         KbQg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769704216; x=1770309016; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vQMIKkFFYhu4sIg3A2teqJk96QiqeuS9EHouVKYLx8Q=;
        b=Nstv9PYMrLcjZuljzuZ7++SMHnxYLvDL219++Rbou7MHK1OTPLFjttdDzHIDdDYzad
         iJskUEtrOSeViS39Rbhwgf79bjcJsyz4xwKKRodbG2eswgDBz/tmsbQXNPWHoiE6NxUJ
         H/cg2U/easN4G51QJzgv4Zj6a/jmp5lHjcm9tb6u08Ju3y8VK++TVW42MXZIT/uwel6s
         1xStIbNbY/U4BrkNJ053mT0DfyiJCsxTzi8Q1c57TqAANm2aYExdXaEOhgNeZP47Y9xz
         lzYCubvnWukvOdKzny7H1/iIZS4LUofLKsGWtkqUYqeKaZ/qayoSs9FH0AixyapLZ4w8
         5bzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769704216; x=1770309016;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vQMIKkFFYhu4sIg3A2teqJk96QiqeuS9EHouVKYLx8Q=;
        b=eHYM+abgFE3KSX6IJmnLMIlwpjxxTMBo1zBtkV9wP6xey8TRw4X+2pqlrVuOL8/17d
         JNZCTw2iod1rdf7X1v4FxsOnI788DyGECYpozliHiXQhfBPTccoOtGdGPo2PNnPpcdI+
         4wFrqhLISCgvYf8AJtpqOvaCgEZleAOEgN2EkWrfcOhRGNGvU/da6203FcG5J/Em78DG
         wE3k6MGpIBlQmqpSi693jAAJ6LHnu/fQtCYjXQgKwbHeMRmQoBlpsa1kNyLYzxOWulvQ
         MtmzmzwfXmLnT2KznREd1ZDDEHju7AqVIKkUQ9/rm0pbGr2wP8YyOwF2y9ayUZX5ZwV+
         FKvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUW4iEF8sux4b1zU2AkYm0ZsaZkfHKiIT4tHUJkePBp8hlHnvx93VRxewJxHQuNEBvJz2k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhlujSH8cqKNoQ8OeD7fXu9TStly87LOb11J0ifbkufhXGanhp
	8B3MVdHGdUDGWIcldnw99NRZtg0W+5jGOCkfzu/P/dZW+4SzXwdiQwe+/8w0kdR5+cuTJPxPfJG
	G2TNhK7OZnjUVToI6r/Gr/jKGIOch1fyxzVIDIt8d
X-Gm-Gg: AZuq6aJ9I+aXyk7109G0e/wasVfFszh3eocASEFdyHzpvAtc3uyV4xxm7zcncY4/kX6
	6TctM8DcO+N8vXGwOEtmS+00afl/UHEkZISGLHqNvqA7GW7dlaVKorcFT8iNmvvDqA/DVBa5ku6
	5KNm+x12iDgp1hIcOx4AxlS2P10xYyOYKaK80sKffYf2TVeL9xUNISo023EP+Pfpkklvdo7QNya
	FP1efWQqG5xrRCwkaXsdKGOJ3LqM4pJF5K87PamwBsDUsiUMGjSfoUoMDbXu3czc3SfyXlX
X-Received: by 2002:ac8:7c47:0:b0:503:2d8f:4cd9 with SMTP id
 d75a77b69052e-503b67573e4mr13934781cf.16.1769704215926; Thu, 29 Jan 2026
 08:30:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-14-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-14-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 29 Jan 2026 16:29:39 +0000
X-Gm-Features: AZwV_Qg32GvW0ZtRM3k8KTI45TetsfMdg8KQdbLbqMmnl_DQjJAfz20-iM3f-6Q
Message-ID: <CA+EHjTw_4WJgiS7vTUprvJOjdNrnW=sjhazCkU9eQW8BUYuZZw@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69564-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 92DB4B2416
X-Rspamd-Action: no action

Hi Marc,

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> Instead of hacking the RES1 bits at runtime, move them into the
> register descriptors. This makes it significantly nicer.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/config.c | 36 +++++++++++++++++++++++++++++-------
>  1 file changed, 29 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 7063fffc22799..d5871758f1fcc 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -30,6 +30,7 @@ struct reg_bits_to_feat_map {
>  #define        RES0_WHEN_E2H1  BIT(7)  /* RES0 when E2H=1 and not supported */
>  #define        RES1_WHEN_E2H0  BIT(8)  /* RES1 when E2H=0 and not supported */
>  #define        RES1_WHEN_E2H1  BIT(9)  /* RES1 when E2H=1 and not supported */
> +#define        FORCE_RESx      BIT(10) /* Unconditional RESx */
>
>         unsigned long   flags;
>
> @@ -107,6 +108,11 @@ struct reg_feat_map_desc {
>   */
>  #define NEEDS_FEAT(m, ...)     NEEDS_FEAT_FLAG(m, 0, __VA_ARGS__)
>
> +/* Declare fixed RESx bits */
> +#define FORCE_RES0(m)          NEEDS_FEAT_FLAG(m, FORCE_RESx, enforce_resx)
> +#define FORCE_RES1(m)          NEEDS_FEAT_FLAG(m, FORCE_RESx | AS_RES1, \
> +                                               enforce_resx)
> +
>  /*
>   * Declare the dependency between a non-FGT register, a set of
>   * feature, and the set of individual bits it contains. This generates

nit: features

> @@ -230,6 +236,15 @@ struct reg_feat_map_desc {
>  #define FEAT_HCX               ID_AA64MMFR1_EL1, HCX, IMP
>  #define FEAT_S2PIE             ID_AA64MMFR3_EL1, S2PIE, IMP
>
> +static bool enforce_resx(struct kvm *kvm)
> +{
> +       /*
> +        * Returning false here means that the RESx bits will be always
> +        * addded to the fixed set bit. Yes, this is counter-intuitive.

nit: added

> +        */
> +       return false;
> +}

I see what you're doing here, but it took me a while to get it and
convince myself that there aren't any bugs (my self couldn't find any
bugs, but I wouldn't trust him that much). You already introduce a new
flag, FORCE_RESx. Why not just check that directly in the
compute_resx_bits() loop, before the check for CALL_FUNC?

+ if (map[i].flags & FORCE_RESx)
+     match = false;
+ else if (map[i].flags & CALL_FUNC)
...

The way it is now, to understand FORCE_RES0, you must trace a flag, a
macro expansion, and a function pointer, just to set a boolean to
false.

Cheers,
/fuad


> +
>  static bool not_feat_aa64el3(struct kvm *kvm)
>  {
>         return !kvm_has_feat(kvm, FEAT_AA64EL3);
> @@ -1009,6 +1024,8 @@ static const struct reg_bits_to_feat_map hcr_feat_map[] = {
>                    HCR_EL2_TWEDEn,
>                    FEAT_TWED),
>         NEEDS_FEAT_FIXED(HCR_EL2_E2H, compute_hcr_e2h),
> +       FORCE_RES0(HCR_EL2_RES0),
> +       FORCE_RES1(HCR_EL2_RES1),
>  };
>
>  static const DECLARE_FEAT_MAP(hcr_desc, HCR_EL2,
> @@ -1029,6 +1046,8 @@ static const struct reg_bits_to_feat_map sctlr2_feat_map[] = {
>                    SCTLR2_EL1_CPTM      |
>                    SCTLR2_EL1_CPTM0,
>                    FEAT_CPA2),
> +       FORCE_RES0(SCTLR2_EL1_RES0),
> +       FORCE_RES1(SCTLR2_EL1_RES1),
>  };
>
>  static const DECLARE_FEAT_MAP(sctlr2_desc, SCTLR2_EL1,
> @@ -1054,6 +1073,8 @@ static const struct reg_bits_to_feat_map tcr2_el2_feat_map[] = {
>                    TCR2_EL2_E0POE,
>                    FEAT_S1POE),
>         NEEDS_FEAT(TCR2_EL2_PIE, FEAT_S1PIE),
> +       FORCE_RES0(TCR2_EL2_RES0),
> +       FORCE_RES1(TCR2_EL2_RES1),
>  };
>
>  static const DECLARE_FEAT_MAP(tcr2_el2_desc, TCR2_EL2,
> @@ -1131,6 +1152,8 @@ static const struct reg_bits_to_feat_map sctlr_el1_feat_map[] = {
>                    SCTLR_EL1_A          |
>                    SCTLR_EL1_M,
>                    FEAT_AA64EL1),
> +       FORCE_RES0(SCTLR_EL1_RES0),
> +       FORCE_RES1(SCTLR_EL1_RES1),
>  };
>
>  static const DECLARE_FEAT_MAP(sctlr_el1_desc, SCTLR_EL1,
> @@ -1165,6 +1188,8 @@ static const struct reg_bits_to_feat_map mdcr_el2_feat_map[] = {
>                    MDCR_EL2_TDE         |
>                    MDCR_EL2_TDRA,
>                    FEAT_AA64EL1),
> +       FORCE_RES0(MDCR_EL2_RES0),
> +       FORCE_RES1(MDCR_EL2_RES1),
>  };
>
>  static const DECLARE_FEAT_MAP(mdcr_el2_desc, MDCR_EL2,
> @@ -1203,6 +1228,8 @@ static const struct reg_bits_to_feat_map vtcr_el2_feat_map[] = {
>                    VTCR_EL2_SL0         |
>                    VTCR_EL2_T0SZ,
>                    FEAT_AA64EL1),
> +       FORCE_RES0(VTCR_EL2_RES0),
> +       FORCE_RES1(VTCR_EL2_RES1),
>  };
>
>  static const DECLARE_FEAT_MAP(vtcr_el2_desc, VTCR_EL2,
> @@ -1214,7 +1241,8 @@ static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
>         u64 mask = 0;
>
>         for (int i = 0; i < map_size; i++)
> -               mask |= map[i].bits;
> +               if (!(map[i].flags & FORCE_RESx))
> +                       mask |= map[i].bits;
>
>         if (mask != ~resx)
>                 kvm_err("Undefined %s behaviour, bits %016llx\n",
> @@ -1447,28 +1475,22 @@ struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg)
>                 break;
>         case HCR_EL2:
>                 resx = compute_reg_resx_bits(kvm, &hcr_desc, 0, 0);
> -               resx.res1 |= HCR_EL2_RES1;
>                 break;
>         case SCTLR2_EL1:
>         case SCTLR2_EL2:
>                 resx = compute_reg_resx_bits(kvm, &sctlr2_desc, 0, 0);
> -               resx.res1 |= SCTLR2_EL1_RES1;
>                 break;
>         case TCR2_EL2:
>                 resx = compute_reg_resx_bits(kvm, &tcr2_el2_desc, 0, 0);
> -               resx.res1 |= TCR2_EL2_RES1;
>                 break;
>         case SCTLR_EL1:
>                 resx = compute_reg_resx_bits(kvm, &sctlr_el1_desc, 0, 0);
> -               resx.res1 |= SCTLR_EL1_RES1;
>                 break;
>         case MDCR_EL2:
>                 resx = compute_reg_resx_bits(kvm, &mdcr_el2_desc, 0, 0);
> -               resx.res1 |= MDCR_EL2_RES1;
>                 break;
>         case VTCR_EL2:
>                 resx = compute_reg_resx_bits(kvm, &vtcr_el2_desc, 0, 0);
> -               resx.res1 |= VTCR_EL2_RES1;
>                 break;
>         default:
>                 WARN_ON_ONCE(1);
> --
> 2.47.3
>

