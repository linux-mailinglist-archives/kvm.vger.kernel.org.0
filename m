Return-Path: <kvm+bounces-69262-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2CQ0Hzf/eGmOuQEAu9opvQ
	(envelope-from <kvm+bounces-69262-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 19:08:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D121598CD0
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 19:08:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F2DD3307D2BE
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 18:06:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6A92325492;
	Tue, 27 Jan 2026 18:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2uWuWKww"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1A63254A8
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 18:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769537216; cv=pass; b=W//75vBGI4vHP89/1UpuUiVzezdfK/sU6XRJlRBxbwMLqr4eIXccl4VFI3nAAXB+NeVN0aM7UM8rs4cUaFp4BAOpYi9OrhuHRN+H7bGWCaGUBCNOr+G3WfMnWhVUkAqAYIMfN+Nfar3jsfkwNrYdyVPAdo4AeIYqhk2QhqTys+M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769537216; c=relaxed/simple;
	bh=FdDMKZN5A9ilbMPhYJZHvxzQCJptewoM58zrvbTDYAA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dFnon1qxqprX/bZJNvp75qgbNKDMiOhvvh1CfhFmaWsawub+KVPm7Y/VyqU8lgn1gLYCw9IGismkJwNvdLQAk/Wxkp0WIJ6EdAiPTK13TbVzgcuZsIk+X6sXATmGtjpu7iavGoQkjV962VAhMIloD+e5YUf1k9fdwcPt3ZgZJRU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2uWuWKww; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5014b5d8551so22941cf.0
        for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 10:06:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769537214; cv=none;
        d=google.com; s=arc-20240605;
        b=HPpFFo6QIKCghSg7cUb1SGnsIdok09NH36GrSKshi/tJB7XlKEmbRKWA4AteTnVA2D
         /auYqSFXK8mHqMrlc0nRh0K5JCRtnpySAt+DbS/CGMEUDshE815XjRNz8eHdgsSg3aHc
         Nyzz7wgtjnN90nFDG+Y3lqCvmx7NdwSgSEy9ApNlC1eW3fszXFLXF1nKz6wzJA7vNPPT
         0TaD8Fkka+aW38FuVP3XB+rPz6BC6lgU1dsgzQof9e2uLxFmb/jcUPXjtWF70LgbJEwr
         2hYBNwtN/zYVPQiSC6RKVYVSgeRc2C/evm0L2ote8IOjxWJB64D299HsgQJTxPXo5tLy
         BVfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=fxlVnf19hj6wgXG/633VtKF1hJb/wU2Bd3Aj6hrMbwA=;
        fh=B9egXdpSQWgA2BTgZGkSqm/36LiVY2bpg6DK2eV/WIY=;
        b=ghbMjb7KF8jU0TX0QwgKqGXWNt1NvlOjrS9yJsMI8Wp/UjQgYDIIFS+UH4PhyYV8z9
         9EJcBZcOH9BxMRRtdoqZL3oJmaBYaLCTEBCKN875JcK/dSbxs0mY9J1o8IYcYXLGFbCf
         i//kx4JN1kxvnQDb1lI6FCf5eYXUwKhhp6dBPy6h57A4N3aflq4h4s2ORNMt225g6ETP
         WhTCV3kJBqSBBRSzEyHJpRLe55wPaYeXcRETLP4r/l1WudMWDEwEIfMf98PPfK1PjtPx
         5Pu7coSSklqTTZwP8HKnIQ1049pQS8k5S8U56RiGoqcwxPxx+VOXtyVLXz6tRD/WsMsx
         kiDg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769537214; x=1770142014; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fxlVnf19hj6wgXG/633VtKF1hJb/wU2Bd3Aj6hrMbwA=;
        b=2uWuWKww74CHA9qPTOy6mF5ku3qDkj1siLC4uicyUsrGS0iunq7kJFKez453bmA+Wf
         hjJZ21fm5tF2kh2y8zIe34SEfDLSeuT84JnmE3In/148hk2+eII1FNMf8FyWTv0/5sCG
         KeyFVRO24XdomMUB3lT8DFG7uRQif22JySZj3xlgMKbPfwrTLgdS24pNl66uNY7zMNwd
         fGCjbKYpo/GeeCGxnD5cWUSsQGrN4nvDNq+AxGy6BdaIlbtPSq5xnaWWkbwOaXvQivar
         vFMzJ4NX3er0NMczbWCtTednv33R/KqyDTH1KNmjUasKbGpcBsrmGQfMRGVmok7HfdlJ
         +1mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769537214; x=1770142014;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fxlVnf19hj6wgXG/633VtKF1hJb/wU2Bd3Aj6hrMbwA=;
        b=xDME4ytRlKjDwRaS1M/2tERLojp9X+aka8WFeNsJPo5xjVpAoR2wpLljVk1qnLe0Oz
         EllLNV9M0PKYLZXLu+jmC75wQwJR3gTd+wGTMX5I4j4wfKHeVV+s3KwJhr4/joL0j0vn
         IlVrkbA4RbB9TvzZESfsDscdc3VGZ6fZ8Dnt+qtFfo53+D3AzofBjU2feaqKNQHYYEZi
         MkfEtnzQOt2gyA8XMGVq1QswZHdPq/tBIRsLXoNogSp0OG/UUNfHr/ZqQc6zWqKpDLcO
         zcbQpO5OKIz13owSYsnjadQQBZObq7coImpC+P5ZVTnLUG54SBEz3wpliywlQGa82nMK
         mT1w==
X-Forwarded-Encrypted: i=1; AJvYcCUaOejPAswZOc+lHQhJwOQm2tkUHxJ3oCdcn+mwUtzQztL26UYzjqOL66o3zwVV8nTxDEg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGqtu1GI+/MK4LLTJdspSrt/5d0XWT51UNYRpZz5M05hZKQok3
	v3XXUIbDLfYcPR7LlrXAdZVBh4GfgP3K/73CC7Flom8T+plVBsR070IV46G1RtR8er3dVx/I4iM
	YVo3Ia12b/SJp1/2wU3QAOxIeAh7rARR5hMEa3its
X-Gm-Gg: AZuq6aLkfr/9aNRxMBHJxJ8Lem7CW9RFGb+lfJeN8UpgUWpDwRRGyCPnsPPoZhEVE+g
	95jxYuGs3VSWE+/ZogtuIeOpfYspHn/AKlkb5uWhcjemTcoSmmFigKnqruLdfYClPkbFpa5WGB/
	Ac3JnFG6FWijrKBxAUzLCUOtkb3h1PJg6E3YEHxSi5y1q1wwe3i/BwxFQ8wswqUehWm0JmqdBdQ
	NgWn2EMleCeihwMP637kMUm4rUtLxQtE19BftZIFig85m1Zk38ajj5jdi2+PBO6plRP/o5Q
X-Received: by 2002:ac8:5702:0:b0:4ed:70d6:6618 with SMTP id
 d75a77b69052e-503340e2460mr5795521cf.10.1769537213238; Tue, 27 Jan 2026
 10:06:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-9-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-9-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 27 Jan 2026 18:06:16 +0000
X-Gm-Features: AZwV_QjgCatYzl0uSF32P0svXsC6cgFGj2o9l3SKTnzzzCjPpV9QVQWXrqlbFrM
Message-ID: <CA+EHjTzCpT4VYQkcmmn7AOAyROA9e=ohKfj53kSvf804DWWODg@mail.gmail.com>
Subject: Re: [PATCH 08/20] KVM: arm64: Correctly handle SCTLR_EL1 RES1 bits
 for unsupported features
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69262-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D121598CD0
X-Rspamd-Action: no action

Hi Marc,

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> A bunch of SCTLR_EL1 bits must be set to RES1 when the controlling

nit: controlling

> feature is not present. Add the AS_RES1 qualifier where needed.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Otherwise, it matches the Arm Arm.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad



> ---
>  arch/arm64/kvm/config.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 6a4674fabf865..68ed5af2b4d53 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -1085,27 +1085,28 @@ static const DECLARE_FEAT_MAP(tcr2_el2_desc, TCR2_EL2,
>                               tcr2_el2_feat_map, FEAT_TCR2);
>
>  static const struct reg_bits_to_feat_map sctlr_el1_feat_map[] = {
> -       NEEDS_FEAT(SCTLR_EL1_CP15BEN    |
> -                  SCTLR_EL1_ITD        |
> -                  SCTLR_EL1_SED,
> -                  FEAT_AA32EL0),
> +       NEEDS_FEAT(SCTLR_EL1_CP15BEN, FEAT_AA32EL0),
> +       NEEDS_FEAT_FLAG(SCTLR_EL1_ITD   |
> +                       SCTLR_EL1_SED,
> +                       AS_RES1, FEAT_AA32EL0),
>         NEEDS_FEAT(SCTLR_EL1_BT0        |
>                    SCTLR_EL1_BT1,
>                    FEAT_BTI),
>         NEEDS_FEAT(SCTLR_EL1_CMOW, FEAT_CMOW),
> -       NEEDS_FEAT(SCTLR_EL1_TSCXT, feat_csv2_2_csv2_1p2),
> -       NEEDS_FEAT(SCTLR_EL1_EIS        |
> -                  SCTLR_EL1_EOS,
> -                  FEAT_ExS),
> +       NEEDS_FEAT_FLAG(SCTLR_EL1_TSCXT,
> +                       AS_RES1, feat_csv2_2_csv2_1p2),
> +       NEEDS_FEAT_FLAG(SCTLR_EL1_EIS   |
> +                       SCTLR_EL1_EOS,
> +                       AS_RES1, FEAT_ExS),
>         NEEDS_FEAT(SCTLR_EL1_EnFPM, FEAT_FPMR),
>         NEEDS_FEAT(SCTLR_EL1_IESB, FEAT_IESB),
>         NEEDS_FEAT(SCTLR_EL1_EnALS, FEAT_LS64),
>         NEEDS_FEAT(SCTLR_EL1_EnAS0, FEAT_LS64_ACCDATA),
>         NEEDS_FEAT(SCTLR_EL1_EnASR, FEAT_LS64_V),
>         NEEDS_FEAT(SCTLR_EL1_nAA, FEAT_LSE2),
> -       NEEDS_FEAT(SCTLR_EL1_LSMAOE     |
> -                  SCTLR_EL1_nTLSMD,
> -                  FEAT_LSMAOC),
> +       NEEDS_FEAT_FLAG(SCTLR_EL1_LSMAOE        |
> +                       SCTLR_EL1_nTLSMD,
> +                       AS_RES1, FEAT_LSMAOC),
>         NEEDS_FEAT(SCTLR_EL1_EE, FEAT_MixedEnd),
>         NEEDS_FEAT(SCTLR_EL1_E0E, feat_mixedendel0),
>         NEEDS_FEAT(SCTLR_EL1_MSCEn, FEAT_MOPS),
> @@ -1121,7 +1122,8 @@ static const struct reg_bits_to_feat_map sctlr_el1_feat_map[] = {
>         NEEDS_FEAT(SCTLR_EL1_NMI        |
>                    SCTLR_EL1_SPINTMASK,
>                    FEAT_NMI),
> -       NEEDS_FEAT(SCTLR_EL1_SPAN, FEAT_PAN),
> +       NEEDS_FEAT_FLAG(SCTLR_EL1_SPAN,
> +                       AS_RES1, FEAT_PAN),
>         NEEDS_FEAT(SCTLR_EL1_EPAN, FEAT_PAN3),
>         NEEDS_FEAT(SCTLR_EL1_EnDA       |
>                    SCTLR_EL1_EnDB       |
> --
> 2.47.3
>

