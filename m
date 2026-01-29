Return-Path: <kvm+bounces-69589-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8HD9HlCje2kVHgIAu9opvQ
	(envelope-from <kvm+bounces-69589-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 19:13:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DF726B3702
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 19:13:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8B999301E957
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 18:11:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3271A3563E9;
	Thu, 29 Jan 2026 18:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZJL92gBh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA894356A39
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 18:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769710318; cv=pass; b=DlaQtAg5bnMi2v99cZk4RGDx5YRJ9vxyvsC+gocIERdHw/JRvufDHQYCcykbos5sEE14X33UPjL2OFjQD7Je2H9o26wWJTN0vDR2/s5p6EeaXV+bUw+4gIRlSHex99CJhn3PjjXR52aY7GnP0Evn7l8Gt6BKaAg+3VklTHHaLCo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769710318; c=relaxed/simple;
	bh=M/HTTNEk3HJAJvMAG53DlqOlG2dQLxQZC7cUa1DucD8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m83xRb7SDHo7D4qzn3DuxXF/CAOU7OIF52Pbzg/hmWoJDfPhZ0SOTE4aod9dL4j8NnsNzxxxY6KgE3JuyKuM0FD5dhD01Y0/zGHaoI5UP5B8z38qLoE0vSV5Ga3asGqCyY8wQXdwYIHs8S6ttukthBJwCQjQbZtbxW/J/hrvRH0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZJL92gBh; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5033b64256dso1591cf.0
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 10:11:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769710316; cv=none;
        d=google.com; s=arc-20240605;
        b=Kt303qPGhh6ZsUiGQiNsQXKdj1sCGPmtqzJGQSBN/AT3GH599AkkJBklecvBaLV8MG
         4JduTRQ0Sco/lfZGv/7i7nR3guwkj2YQBc6fpQxFg1UpWKReLs94FZke7sqPfaY4s5hx
         0SetkHEyoCFZmxQ0XEVY8E9+R+9DxIuZjRfbtiHytx+My1CpsOcC9jpG+J8B3m2xXSLy
         cpd7sQG55hOUaEbAeKbilcCXt5mtbqFm71rcEvrDoe3pMVZ6NFdEDA/gEkEkZ5fXhkjt
         dzvUYy8xVxO1RK+0wOZ1lnN2dliRmIVatoZuqPW4eVuqjjAx4q28TeW0M6Hg8bXiMB86
         jEjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=eXMpYReA76VSnWBdSDCeKOepff/FefCdjy4bJ9ZDLq8=;
        fh=NXLM153LDlXwMJkovMp3knu38lmJ2eQ2RAKN5WnsKnQ=;
        b=Dj5FyR5TCYqyFly6/AO7jCHcZkirAJ1UuIjTiqL8NTfL0bedYOK4GA5wMRb7dI9Xg5
         xOaU3TEmkwljycmFuMmsCUNuYFQ887L/+z/x8YaFP6e2eVKav8l802yjTBNykrh8c6Gl
         Rp9lQcJ7e+YdlMiFa98Xw9hIoRbfdWyhE1GsQ7c/LBJB8mEYLws+NCNEqOCwfZ5C46Cc
         Z//IlOAxVfa67MgzCeMfVOEZDvW9gFaxs5SvV1FNwOyohjgRu0YHI+qXfJIb7Tc7Qos6
         B9xHyD3Hq2WHl1G+lsI7c043+tlR+2J+PyPscCoMjd1CiR3MCAW8X/+5StLxLkVJaiL8
         fPEA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769710316; x=1770315116; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eXMpYReA76VSnWBdSDCeKOepff/FefCdjy4bJ9ZDLq8=;
        b=ZJL92gBhqIXofCmKOdXCiFG7q5Fl56h/VXxVZr1pXXwpjt6BBu88vlRmlUcjp15x/F
         OyCsCo4SqK6cdfQstY3eyCSI3kKWtwri4lZLr/0X+ag9+6LltNC+6Ac7PykIUgihN/in
         ycpULydMg/FuU1D7EAi6UGkP12QPrsiNjTiKhATuyRs6593YwZ2juZxqJk8JQjAH86jM
         mOWL+8F28RqqIh5G+YqoMZP+fLma2P841lp0Sk7THtimyQ245zZ4K9pbaJ4C3jP2tuyu
         yAzUuckdARnGQ9z5sH8dAxkqFUdbY8TnOa8uiZJA6rIg+Rtm6e4OxPt6VSa21yUVyJnx
         KjRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769710316; x=1770315116;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eXMpYReA76VSnWBdSDCeKOepff/FefCdjy4bJ9ZDLq8=;
        b=vWKmBM5TxSy/DpQ/z1hIxIZU/4+Shvg1SqyT6pq3u8LGELexLRjP9E8XCvEgIewEa3
         1OpqwQ3yiklsEUN/P3fihfQ1OWybto8IAYyUYX8ET+beGknvN+hIpWkXZSjFWlPEXW1n
         kZQEdEVQa4ssFHw+CqQqrPii4/lIzv1ylQqRqvwk3Zews8HpktAaEmZTqbK9TPe5jxDD
         CeEcP9t7AeQxAQnO4/lZSY37eH59zH6F740X2/8cNeiinfmps72+CB90CY2pX/Rp3Yde
         JqfJygF6w5XlsJYi0/M1FIAg1v2GirBwDs77bo55B9bzB3FeBSI5RK3enV9uer11ZlMw
         8v1g==
X-Forwarded-Encrypted: i=1; AJvYcCX5TpRoby3RyGlSRLpWR6ecS+KwEnx1QUoXU8excBgySytOO7L3M0tOw/hoqKniAVMdfH8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7sEo+irpuoiIZjbNG9hdbiZKz0S6HlyoR3UMcVnQ9echAnJ7r
	PyDREWoT99f0GigPmBMh79SZpgUn4Qja1ss70k8nxrwxh8jxbRZC/rQ8VwEo+vZUAuBKOu9r/af
	rLUHQk75R4nFMcCEWtTgQqudauxESEWhP/jNK2CNE
X-Gm-Gg: AZuq6aKFCwqQRwJ7iCk7t/dqR3rr2drFkMT25ivEAGjlX01yRC7FS38JAlnfv+8jLMC
	waj6OeNPlcnrNnC58i5KLwqc7kNhUQKlGqhcL9MSqQIC6Nc8+YlXFt+Ronj1hkzUrofLT1kk6UU
	LRT5GYoyxyzoaed5VGnoubwLvP1p+C56R0bz4zEGmvMQthO7ZxyTItxFok1lCGBUVv83AAE2LEb
	k6abeyNiRIQ6fp2owlBZ0pDinRH1RFz0qo83YM/kTkRW8IJH8UsMW37d4O6WDYgulR8Cql/
X-Received: by 2002:a05:622a:cb:b0:502:f07e:854c with SMTP id
 d75a77b69052e-505d2963681mr233281cf.6.1769710313749; Thu, 29 Jan 2026
 10:11:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-20-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-20-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 29 Jan 2026 18:11:16 +0000
X-Gm-Features: AZwV_QjF5yiUUIg5uEIM22NwSkF34FaWIG-B5xVFNjuS4Wq4b6ejFit-e1Zvicw
Message-ID: <CA+EHjTztDe27zT6yHFiN+_64Husvs36JBWXZyKQ2N3AjuW63gQ@mail.gmail.com>
Subject: Re: [PATCH 19/20] KVM: arm64: Add sanitisation to SCTLR_EL2
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
	TAGGED_FROM(0.00)[bounces-69589-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: DF726B3702
X-Rspamd-Action: no action

Hi Marc,

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> Sanitise SCTLR_EL2 the usual way. The most important aspect of
> this is that we benefit from SCTLR_EL2.SPAN being RES1 when
> HCR_EL2.E2H==0.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

This would change slightly when you change patch 12, but it matches
the spec and those changes would be trivial to apply here.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad






> ---
>  arch/arm64/include/asm/kvm_host.h |  2 +-
>  arch/arm64/kvm/config.c           | 82 +++++++++++++++++++++++++++++++
>  arch/arm64/kvm/nested.c           |  4 ++
>  3 files changed, 87 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 9dca94e4361f0..c82b071ade2a5 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -495,7 +495,6 @@ enum vcpu_sysreg {
>         DBGVCR32_EL2,   /* Debug Vector Catch Register */
>
>         /* EL2 registers */
> -       SCTLR_EL2,      /* System Control Register (EL2) */
>         ACTLR_EL2,      /* Auxiliary Control Register (EL2) */
>         CPTR_EL2,       /* Architectural Feature Trap Register (EL2) */
>         HACR_EL2,       /* Hypervisor Auxiliary Control Register */
> @@ -526,6 +525,7 @@ enum vcpu_sysreg {
>
>         /* Anything from this can be RES0/RES1 sanitised */
>         MARKER(__SANITISED_REG_START__),
> +       SCTLR_EL2,      /* System Control Register (EL2) */
>         TCR2_EL2,       /* Extended Translation Control Register (EL2) */
>         SCTLR2_EL2,     /* System Control Register 2 (EL2) */
>         MDCR_EL2,       /* Monitor Debug Configuration Register (EL2) */
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index eebafb90bcf62..562513a4683e2 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -1130,6 +1130,84 @@ static const struct reg_bits_to_feat_map sctlr_el1_feat_map[] = {
>  static const DECLARE_FEAT_MAP(sctlr_el1_desc, SCTLR_EL1,
>                               sctlr_el1_feat_map, FEAT_AA64EL1);
>
> +static const struct reg_bits_to_feat_map sctlr_el2_feat_map[] = {
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_CP15BEN,
> +                       RES0_WHEN_E2H1 | RES1_WHEN_E2H0 | REQUIRES_E2H1,
> +                       FEAT_AA32EL0),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_ITD   |
> +                       SCTLR_EL2_SED,
> +                       RES1_WHEN_E2H1 | RES0_WHEN_E2H0 | REQUIRES_E2H1,
> +                       FEAT_AA32EL0),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_BT0, REQUIRES_E2H1, FEAT_BTI),
> +       NEEDS_FEAT(SCTLR_EL2_BT, FEAT_BTI),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_CMOW, REQUIRES_E2H1, FEAT_CMOW),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_TSCXT,
> +                       RES0_WHEN_E2H0 | RES1_WHEN_E2H1 | REQUIRES_E2H1,
> +                       feat_csv2_2_csv2_1p2),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_EIS   |
> +                       SCTLR_EL2_EOS,
> +                       AS_RES1, FEAT_ExS),
> +       NEEDS_FEAT(SCTLR_EL2_EnFPM, FEAT_FPMR),
> +       NEEDS_FEAT(SCTLR_EL2_IESB, FEAT_IESB),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_EnALS, REQUIRES_E2H1, FEAT_LS64),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_EnAS0, REQUIRES_E2H1, FEAT_LS64_ACCDATA),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_EnASR, REQUIRES_E2H1, FEAT_LS64_V),
> +       NEEDS_FEAT(SCTLR_EL2_nAA, FEAT_LSE2),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_LSMAOE        |
> +                       SCTLR_EL2_nTLSMD,
> +                       AS_RES1 | REQUIRES_E2H1, FEAT_LSMAOC),
> +       NEEDS_FEAT(SCTLR_EL2_EE, FEAT_MixedEnd),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_E0E, REQUIRES_E2H1, feat_mixedendel0),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_MSCEn, REQUIRES_E2H1, FEAT_MOPS),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_ATA0  |
> +                       SCTLR_EL2_TCF0,
> +                       REQUIRES_E2H1, FEAT_MTE2),
> +       NEEDS_FEAT(SCTLR_EL2_ATA        |
> +                  SCTLR_EL2_TCF,
> +                  FEAT_MTE2),
> +       NEEDS_FEAT(SCTLR_EL2_ITFSB, feat_mte_async),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_TCSO0, REQUIRES_E2H1, FEAT_MTE_STORE_ONLY),
> +       NEEDS_FEAT(SCTLR_EL2_TCSO,
> +                  FEAT_MTE_STORE_ONLY),
> +       NEEDS_FEAT(SCTLR_EL2_NMI        |
> +                  SCTLR_EL2_SPINTMASK,
> +                  FEAT_NMI),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_SPAN, AS_RES1 | REQUIRES_E2H1, FEAT_PAN),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_EPAN, REQUIRES_E2H1, FEAT_PAN3),
> +       NEEDS_FEAT(SCTLR_EL2_EnDA       |
> +                  SCTLR_EL2_EnDB       |
> +                  SCTLR_EL2_EnIA       |
> +                  SCTLR_EL2_EnIB,
> +                  feat_pauth),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_EnTP2, REQUIRES_E2H1, FEAT_SME),
> +       NEEDS_FEAT(SCTLR_EL2_EnRCTX, FEAT_SPECRES),
> +       NEEDS_FEAT(SCTLR_EL2_DSSBS, FEAT_SSBS),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_TIDCP, REQUIRES_E2H1, FEAT_TIDCP1),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_TWEDEL        |
> +                       SCTLR_EL2_TWEDEn,
> +                       REQUIRES_E2H1, FEAT_TWED),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_nTWE  |
> +                       SCTLR_EL2_nTWI,
> +                       AS_RES1 | REQUIRES_E2H1, FEAT_AA64EL2),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_UCI   |
> +                       SCTLR_EL2_UCT   |
> +                       SCTLR_EL2_DZE   |
> +                       SCTLR_EL2_SA0,
> +                       REQUIRES_E2H1, FEAT_AA64EL2),
> +       NEEDS_FEAT(SCTLR_EL2_WXN        |
> +                  SCTLR_EL2_I          |
> +                  SCTLR_EL2_SA         |
> +                  SCTLR_EL2_C          |
> +                  SCTLR_EL2_A          |
> +                  SCTLR_EL2_M,
> +                  FEAT_AA64EL2),
> +       FORCE_RES0(SCTLR_EL2_RES0),
> +       FORCE_RES1(SCTLR_EL2_RES1),
> +};
> +
> +static const DECLARE_FEAT_MAP(sctlr_el2_desc, SCTLR_EL2,
> +                             sctlr_el2_feat_map, FEAT_AA64EL2);
> +
>  static const struct reg_bits_to_feat_map mdcr_el2_feat_map[] = {
>         NEEDS_FEAT(MDCR_EL2_EBWE, FEAT_Debugv8p9),
>         NEEDS_FEAT(MDCR_EL2_TDOSA, FEAT_DoubleLock),
> @@ -1249,6 +1327,7 @@ void __init check_feature_map(void)
>         check_reg_desc(&sctlr2_desc);
>         check_reg_desc(&tcr2_el2_desc);
>         check_reg_desc(&sctlr_el1_desc);
> +       check_reg_desc(&sctlr_el2_desc);
>         check_reg_desc(&mdcr_el2_desc);
>         check_reg_desc(&vtcr_el2_desc);
>  }
> @@ -1454,6 +1533,9 @@ struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg)
>         case SCTLR_EL1:
>                 resx = compute_reg_resx_bits(kvm, &sctlr_el1_desc, 0, 0);
>                 break;
> +       case SCTLR_EL2:
> +               resx = compute_reg_resx_bits(kvm, &sctlr_el2_desc, 0, 0);
> +               break;
>         case MDCR_EL2:
>                 resx = compute_reg_resx_bits(kvm, &mdcr_el2_desc, 0, 0);
>                 break;
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 96e899dbd9192..ed710228484f3 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1766,6 +1766,10 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
>         resx = get_reg_fixed_bits(kvm, SCTLR_EL1);
>         set_sysreg_masks(kvm, SCTLR_EL1, resx);
>
> +       /* SCTLR_EL2 */
> +       resx = get_reg_fixed_bits(kvm, SCTLR_EL2);
> +       set_sysreg_masks(kvm, SCTLR_EL2, resx);
> +
>         /* SCTLR2_ELx */
>         resx = get_reg_fixed_bits(kvm, SCTLR2_EL1);
>         set_sysreg_masks(kvm, SCTLR2_EL1, resx);
> --
> 2.47.3
>

