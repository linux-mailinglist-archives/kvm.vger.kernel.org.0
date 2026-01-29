Return-Path: <kvm+bounces-69585-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IFVfK0mde2nOGAIAu9opvQ
	(envelope-from <kvm+bounces-69585-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 18:47:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A657B331A
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 18:47:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B7D5830777B2
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 17:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DFEE354AC7;
	Thu, 29 Jan 2026 17:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tRHKENYT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BD32C15BA
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 17:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769708642; cv=pass; b=X3pUPXqm9603yECUjcNzI2lAcAOxXqijpH8i1WAJUEXYsZHZhEQ8UH+5Qjz4KLIUCoBMWfcp/aa7D4Zoe7Df0FChUA8iQ1wtUlII/yhnNozLu1XXjIAo9hVUfjDHksngWaQBxwEFgNaovUU/1q7FxR5XK23YG2Tm9OpWwzfx8f0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769708642; c=relaxed/simple;
	bh=Qm7IrBwcroMf4JNK902e+KjqQCbztMqp90GzMr7Ke1U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uEoM51VDUerOEzdPYTx/+pvAmqqQxmXedDnzOPACpq6iK3Nqlro324iTH7kddUPiQUsx0mc3KLIGk3ZaoFOZ/Xx5Tp0Kuj1kuT2bdW7+C0ZnLcn3FQNKpYGlnWSiXJieez7hzwPRVAMawjohO1EEIs/OWgg/1CUvhvxasWvpQ24=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tRHKENYT; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5033b64256dso6391cf.0
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 09:44:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769708640; cv=none;
        d=google.com; s=arc-20240605;
        b=I3O5f72mEB7WWW3yGVeR7fmMvywZDDi3AhroH+6Jpx+macye/cnDjypYdh1xInnIBM
         NMUGK1fITBFUD0ojC1NrtRd/OEywINgtFouYHhoC9ehSy6pYAB+XkAwfoUUPwnOJ4Cx5
         tjt8kTvv+vQnu19alN5xvePZE7WszSi5jIfXsIMk1UVQAO4YV1X81rispn2kE/3Am4Jo
         3c/nZWCthtBUxK7PIiT2att119gjCbPkGDLniyGnttB0utZR+TJ65EX9E3T9+fkitVb+
         0AYYB5t4ijtenSYen3ctj25sbMnuz9VSn1xDJjRhbrr9NbQecjzL5FYQO9JZxdk+ASZk
         GjpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=BPx3FQm16cHh/4wjy/zL7AjgWXFPiOJBez90RRz9q3A=;
        fh=mRkmCxwEUPekh2SimShOtBjKmIjUH6DuGreq/iReAzs=;
        b=Azei/tNk0jaAf3B8YROMogyMG0XEKJRWmM2FAD9lBaW+OujQb9VN4O/UEuwD6XGiYH
         apPGroJbjpf7QlpbM/5z5usu0Nt76gTlQRsGgHfBFNBjGKI4zm8hJf3OdsaiCW0K4Pft
         GCnmSnTR5+m++dYynmmhbmBwzxo3rgwsEWWWrxKJo2UAsx3ss24cxCk5Q08ESONRk7Kt
         K4ZZV3nkmpo93Gx5Qzc2vU9VWHpQXBuoAW5xZTCGPmBlDZBUQxaDkjI1NkkU81Zzc1SN
         pq01EYU1ihhzk6R32irJbo/vKMuqTMxjTIowbHlGZJ12xtkVQwfDjwqowvt+Resc4Glu
         BRtw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769708640; x=1770313440; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BPx3FQm16cHh/4wjy/zL7AjgWXFPiOJBez90RRz9q3A=;
        b=tRHKENYTvwEM9fh9ZehZhWvgW9BmTfpCi/kk7OJaVI2BwlGeviVOFXTgXp0k3FFJ+T
         sNiCac5RuiVeZWD1BlmkUBGK1Vc7Thodo6Ye1xbrRP+KJ8Isk98cIzBCfzfv7/QbMUnB
         eACMy8BuYaS4jzxkVqc3dRl97e/j+btB5V/tY8wi1Ip9Jwe7KmpRI0Bg5q7TEcK9kxrj
         l9NFBrGBG70O3FqKJ5YxAGj5pKNzA18z27TnHFO02ufMyRFzC6Z8oiDex+q9rWKhrGWj
         7iiXTZF4OlblZqpADSdOd5FER6Mswmy+lq9qpsKMVXS8EFsm2UFd+GWCCWiCN9tqmEIh
         D3ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769708640; x=1770313440;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BPx3FQm16cHh/4wjy/zL7AjgWXFPiOJBez90RRz9q3A=;
        b=kMn7AxRwQeOSGiW6nABmuxnpGfqyFrIeP03ldUBAB5oC97QbR4sQQVYNl/n34f4/5Z
         gjneEiHu2yqU/HiN/AKc6EunFLOO0t76z6tQYM49ZO16myB0jaTh7nhzcspkzsM5NIbA
         1HynlCX+ofEH4/+MkCc4n9X5/hqDZD0VRTh8CLv2jHRyyPDXitF602MZxbivepim+6jx
         UWLO0FU/xyGZv8GQqVEHVTFgx3BXsqlDUfXLwOyDjQbtwDC9bqYsn6j/eEklIvs2Ji3A
         /yLnY8ovNXN06bW9hSy8GK2zZJjgPM5uk+Qufct7Eo5AvSCfVmIWNL4MCSIiQb/3X7kH
         uUNA==
X-Forwarded-Encrypted: i=1; AJvYcCWl6K7A8jLjEl9YHZMelNFdKlqkdyjlC5K/YBUfpWkaosWg6h3y0kv/h71V7HXvEqvgIK8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMdeFkzxJEWIBvQtfOHcEP7fvrwBv39QFdqmIPpZQ3gtiZFxE+
	+JNu+4wT1aga3a6Hi8admIF13dW2UnwLkWZdmm+91B9dwD3trLBt+SeDS6RALZQ5COj6EjQ77MJ
	hTxjDzJggkKZ0GMNxiRh+YeDwHKzsDbGgFe13dCQt
X-Gm-Gg: AZuq6aL8WxQe4C0CK0jB5QEOcRbA8KSzUS5n0tPwzqbh3COHLeg0tn969V7Qy0oDLSg
	NfAoMwX8SfVFKKnuQMS+Cic+1eo1FDLM88txe8Lp+kYS7tSZTdA+DUavsJ3TnkCFBZixy7zg0aP
	bukBJlmG1jRtrTw3436nfQTpVP9BZSifu8cmQ21sgikgNSI351e5pat5jR311lCzkAUrNLkEVEJ
	32BJvQK3ZDJMb4Z0lbavik0+/ztqt2vttmsa3qvRQr/SHtabYbZ1I4Cex+vQuvzsQo6ze8s
X-Received: by 2002:ac8:7c45:0:b0:4ff:bfdd:3f46 with SMTP id
 d75a77b69052e-504310ac4a2mr11679881cf.15.1769708639982; Thu, 29 Jan 2026
 09:43:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-18-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-18-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 29 Jan 2026 17:43:23 +0000
X-Gm-Features: AZwV_QhgZBr5ml0xnQ-vrwj2DQaUpUwkeGPKKe1ptuTmjpFjMzKIrzIPGRs2pns
Message-ID: <CA+EHjTzvwhu4zkLmn4AtA0GZuUy85LDnZ-YUesw1PeoJPqdt_A@mail.gmail.com>
Subject: Re: [PATCH 17/20] KVM: arm64: Remove all traces of FEAT_TME
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69585-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1A657B331A
X-Rspamd-Action: no action

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> FEAT_TME has been dropped from the architecture. Retrospectively.
> I'm sure someone is crying somewhere, but most of us won't.

:'-(

Please don't do a web search for my name and "Transactional Memory".

> Clean-up time.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

I checked and it is indeed withdrawn. So with a heavy heart:

Reviewed-by: Fuad Tabba <tabba@google.com>

RIP,
/fuad







> ---
>  arch/arm64/kvm/config.c                         |  7 -------
>  arch/arm64/kvm/nested.c                         |  5 -----
>  arch/arm64/tools/sysreg                         | 12 +++---------
>  tools/perf/Documentation/perf-arm-spe.txt       |  1 -
>  tools/testing/selftests/kvm/arm64/set_id_regs.c |  1 -
>  5 files changed, 3 insertions(+), 23 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 0c037742215ac..f892098b70c0b 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -184,7 +184,6 @@ struct reg_feat_map_desc {
>  #define FEAT_RME               ID_AA64PFR0_EL1, RME, IMP
>  #define FEAT_MPAM              ID_AA64PFR0_EL1, MPAM, 1
>  #define FEAT_S2FWB             ID_AA64MMFR2_EL1, FWB, IMP
> -#define FEAT_TME               ID_AA64ISAR0_EL1, TME, IMP
>  #define FEAT_TWED              ID_AA64MMFR1_EL1, TWED, IMP
>  #define FEAT_E2H0              ID_AA64MMFR4_EL1, E2H0, IMP
>  #define FEAT_SRMASK            ID_AA64MMFR4_EL1, SRMASK, IMP
> @@ -997,7 +996,6 @@ static const struct reg_bits_to_feat_map hcr_feat_map[] = {
>         NEEDS_FEAT(HCR_EL2_FIEN, feat_rasv1p1),
>         NEEDS_FEAT(HCR_EL2_GPF, FEAT_RME),
>         NEEDS_FEAT(HCR_EL2_FWB, FEAT_S2FWB),
> -       NEEDS_FEAT(HCR_EL2_TME, FEAT_TME),
>         NEEDS_FEAT(HCR_EL2_TWEDEL       |
>                    HCR_EL2_TWEDEn,
>                    FEAT_TWED),
> @@ -1109,11 +1107,6 @@ static const struct reg_bits_to_feat_map sctlr_el1_feat_map[] = {
>         NEEDS_FEAT(SCTLR_EL1_EnRCTX, FEAT_SPECRES),
>         NEEDS_FEAT(SCTLR_EL1_DSSBS, FEAT_SSBS),
>         NEEDS_FEAT(SCTLR_EL1_TIDCP, FEAT_TIDCP1),
> -       NEEDS_FEAT(SCTLR_EL1_TME0       |
> -                  SCTLR_EL1_TME        |
> -                  SCTLR_EL1_TMT0       |
> -                  SCTLR_EL1_TMT,
> -                  FEAT_TME),
>         NEEDS_FEAT(SCTLR_EL1_TWEDEL     |
>                    SCTLR_EL1_TWEDEn,
>                    FEAT_TWED),
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 75a23f1c56d13..96e899dbd9192 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1505,11 +1505,6 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
>         u64 orig_val = val;
>
>         switch (reg) {
> -       case SYS_ID_AA64ISAR0_EL1:
> -               /* Support everything but TME */
> -               val &= ~ID_AA64ISAR0_EL1_TME;
> -               break;
> -
>         case SYS_ID_AA64ISAR1_EL1:
>                 /* Support everything but LS64 and Spec Invalidation */
>                 val &= ~(ID_AA64ISAR1_EL1_LS64  |
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 969a75615d612..650d7d477087e 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -1856,10 +1856,7 @@ UnsignedEnum     31:28   RDM
>         0b0000  NI
>         0b0001  IMP
>  EndEnum
> -UnsignedEnum   27:24   TME
> -       0b0000  NI
> -       0b0001  IMP
> -EndEnum
> +Res0   27:24
>  UnsignedEnum   23:20   ATOMIC
>         0b0000  NI
>         0b0010  IMP
> @@ -2432,10 +2429,7 @@ Field    57      EPAN
>  Field  56      EnALS
>  Field  55      EnAS0
>  Field  54      EnASR
> -Field  53      TME
> -Field  52      TME0
> -Field  51      TMT
> -Field  50      TMT0
> +Res0   53:50
>  Field  49:46   TWEDEL
>  Field  45      TWEDEn
>  Field  44      DSSBS
> @@ -3840,7 +3834,7 @@ Field     43      NV1
>  Field  42      NV
>  Field  41      API
>  Field  40      APK
> -Field  39      TME
> +Res0   39
>  Field  38      MIOCNCE
>  Field  37      TEA
>  Field  36      TERR
> diff --git a/tools/perf/Documentation/perf-arm-spe.txt b/tools/perf/Documentation/perf-arm-spe.txt
> index 8b02e5b983fa9..201a82bec0de4 100644
> --- a/tools/perf/Documentation/perf-arm-spe.txt
> +++ b/tools/perf/Documentation/perf-arm-spe.txt
> @@ -176,7 +176,6 @@ and inv_event_filter are:
>    bit 10    - Remote access (FEAT_SPEv1p4)
>    bit 11    - Misaligned access (FEAT_SPEv1p1)
>    bit 12-15 - IMPLEMENTATION DEFINED events (when implemented)
> -  bit 16    - Transaction (FEAT_TME)
>    bit 17    - Partial or empty SME or SVE predicate (FEAT_SPEv1p1)
>    bit 18    - Empty SME or SVE predicate (FEAT_SPEv1p1)
>    bit 19    - L2D access (FEAT_SPEv1p4)
> diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> index c4815d3658167..73de5be58bab0 100644
> --- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
> +++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> @@ -91,7 +91,6 @@ static const struct reg_ftr_bits ftr_id_aa64isar0_el1[] = {
>         REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR0_EL1, SM3, 0),
>         REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR0_EL1, SHA3, 0),
>         REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR0_EL1, RDM, 0),
> -       REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR0_EL1, TME, 0),
>         REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR0_EL1, ATOMIC, 0),
>         REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR0_EL1, CRC32, 0),
>         REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR0_EL1, SHA2, 0),
> --
> 2.47.3
>

