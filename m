Return-Path: <kvm+bounces-69363-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yPzKM1xMemkp5AEAu9opvQ
	(envelope-from <kvm+bounces-69363-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:50:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B93FA7342
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:50:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8C79A30B99BE
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 17:44:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 511FF36C5BC;
	Wed, 28 Jan 2026 17:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tv1VV59Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5513612F7
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769622260; cv=pass; b=KNk2EGSl3iCahpqL4WsezUvIG8T9CRQ2Ns/Ym4uW1qpRukl+DX1WeH3IPADBkailWb/9HX5tZi8WKRTROaC2VPac4Mlk1dyi09HQrb83M0fs/pl+6S3Hx7KPiJFfN7ewz0p48I17q9FBjHmxPjHrRjEMHXkGCARR+cawz8Tk9zA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769622260; c=relaxed/simple;
	bh=n9qMoCX3G+jYOXH3ah2jgfZmawPnIAGRu4txfYSI8bI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hOYAL27u5nZSsrPZEI9R0ggfQbgryWdiEQNLtuCT67Oqv+J3R/Z30ZZW8rYlvTBr6kTmprDMd40Q9x/j/61ZgP9D+gwTK9mWhS206Jc+mh+ryDCatYPsqUXa2MC6x+AFez9YHTjh/SmZbWc66IRon9ICB6zVswL7sKXyTAeh5CM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tv1VV59Y; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5014b5d8551so5901cf.0
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 09:44:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769622258; cv=none;
        d=google.com; s=arc-20240605;
        b=dQGIoco+psMFgebaQN7IzCRd/csjJyHV2yikueyXWarQvQOUVMIhjE07cjd1lXRagF
         nt0ENKYIBQi/UBHss5ZnfAOSIMlI0T1rbEcHwaZXJdUnqDEjC0vJszxSXTnlCtNx/MDA
         mFnBNmMQr/iRMpxhhwbPYFDsETNxbLTAXJoj/ey9EqNMlkQ5XQiT2mjxRTlSKvc2Fl4/
         k6lOvtMPvXWzmXstsdZ89sVcf7MytKRP51n4pK9rfo755cdVFHLNsBiDbppEcVMxXzUH
         F8prIQoDmDEESScgznFcEGBXR+uLLVCn0aJq7EMYsjbb5f86rN/tRqWParoHmUZw367D
         vHrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bQ28KNx3pxtawA1nFwPKCc2RQpAN4D6gIqSKFp3a8PE=;
        fh=nxZn9ZLLvfJE54wgrYCtO4abNcb7d+YWvaoGIafBYoQ=;
        b=B7V1Wl/nAu82N7DAa5afgtpbq8o3T7B2I/9kIHe7SONa3Rkjs8FwyRZJs4xeiGrodx
         sEgvGqcb7PEFyf1Nm8L4ECn5w2nDfn7eXDJ/Asw2LVcsEXBKms9N/nMjp1V0EcaMVh0g
         0cuOtIi4U2H99JwLAUnlDhp0+0NWlRbO1tka0+rzIBOiVqU+WSdp37+A5EF6yKrzA2zS
         v94+ApjxOypu0O37aR6+jYT99Qv5hxgZFN6Vcrge+MsNHonso1Ehn9AqrI3kOP9FfEny
         GVYOJ6RFupBzEOyV4qGXieDtKNChp5hqABpadB0D/+DlA9AxxGcfZz6xY4JqoomuxswE
         WCJg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769622258; x=1770227058; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bQ28KNx3pxtawA1nFwPKCc2RQpAN4D6gIqSKFp3a8PE=;
        b=tv1VV59YxTvzh9ODNjmtMQ+78kmvBxebpl/GT3CNNbFXzz05LEQGLRanHO3jyIUTs/
         MxtSxwW2/4SBn87aistUjwenM5dMMtjkzL1K/l8CaR0M6RE+ZwA0j8TgQYK0cfmlvi0n
         fKfAI4huXZvJEdsqWgoyy1cHreEmSC1ucX5/lGTwiNfZEskD974LmkDaMMVQ1Y7z+FlJ
         WMvO+IWeCgA7LD0Zq2ksn4r53+ymYHZ/6AB/JUr8yQzzP1TimP6YK31HgY9gdVRTtMUH
         kLdNhjL/XkQ1lorR16MP03t6dvVnjPaUnxSRG2dwJy1voueIWZGEHUm/4GW3QMd1RLsy
         EsDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769622258; x=1770227058;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bQ28KNx3pxtawA1nFwPKCc2RQpAN4D6gIqSKFp3a8PE=;
        b=LOboGMfvh28f0e3BmplieleB7sUNP9xvqmuj8X4JoOw7T9XZ4y6b8wCGGoVsmEXi4n
         UN+PPUv5nTiV7yM8FJuyNSYH5AlEQubUzW0H4KfRMCAedJWNMqhvjOqu6JWijqO1NKod
         8Ki7YkxCf/03LTSZmDYjJV7Se5vX27frxWO1nZ1+kJRdXWs5ngxfZM+3EQKILnCYiUCj
         Ys7VZYpTA+86apmfislj2U8aI0aXkwurUDBo8plp/HhsGi896lIGj9WW3dLsPB1ATD3B
         QloB8V5pAyflBfbCPuF7QDq7FMOFCbpURCcXxBht67ZPYvLNaofqqfr9oTJ4ohSpIEmo
         59iA==
X-Forwarded-Encrypted: i=1; AJvYcCXgo2FGPJCRWFB9X+EqI/RpQfQ0dLgpfmyOQygha3U8bRSk++M8bJPlfZ56QJT3mbT4cRU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVvBf8U/3Z/4/YQSbnXgVqhi4vBhGDItfExtYdFZivmMjixw+s
	3ldzMH7Wou1mQIuHzRsU4mgdaCufkulexSbWxbBA5obN1KwpLrM/sBfO2MovmNHmeAKoTamBC65
	0O5/N6ODXd5+G9dO371vbij3Ht7mOdxt/pDKq2GvJm8Sa41TcTcT4zNlrVJQ=
X-Gm-Gg: AZuq6aKNm5+dEAuEfSWtpsBIxUPnGyH/BxRuTcO+UIuPBiF0Gp5YZ8ySyNQ+TxxdHbE
	KoMqLVCt/gdg20PnawPUuHaKZaVHa6lfDd9/OTAcj1B/E6/RuTwp0gz4FVGNs++nFFgvHIFTL6z
	j0zTv+xTTLQZXbFPn612QupAkvWphjAM9qfdRHczyFq2D8e++2SeGimMuln/oGMILKMH5mfS1P0
	00B/AFtFo0CSK04BV+HezCmLANx4cvM1NW759NZ2p1Ean/awmuuNqWF0vt5AOIAd3nCIGdoe/eb
	H8BAc/g=
X-Received: by 2002:a05:622a:a64d:b0:4ed:a65c:88d0 with SMTP id
 d75a77b69052e-503340e241emr18057281cf.6.1769622257513; Wed, 28 Jan 2026
 09:44:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-13-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-13-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 28 Jan 2026 17:43:40 +0000
X-Gm-Features: AZwV_Qjw_-4jQqLbJsa_gafDcYnoQTp1vBemlKSUmMjvAlynKsInG-LHMbmXpQc
Message-ID: <CA+EHjTzL6bNZ=sZoub3GY=VZ2bJ+4bFr4jkuiMMBCEqXuAkQPA@mail.gmail.com>
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
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	NEURAL_HAM(-0.00)[-1.000];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-69363-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+]
X-Rspamd-Queue-Id: 4B93FA7342
X-Rspamd-Action: no action

Hi Marc,

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> "Thanks" to VHE, SCTLR_EL2 radically changes shape depending on the
> value of HCR_EL2.E2H, as a lot of the bits that didn't have much
> meaning with E2H=0 start impacting EL0 with E2H=1.
>
> This has a direct impact on the RESx behaviour of these bits, and
> we need a way to express them.
>
> For this purpose, introduce a set of 4 new constaints that, when
> the controlling feature is not present, force the RESx value to
> be either 0 or 1 depending on the value of E2H.
>
> This allows diverging RESx values depending on the value of E2H,
> something that is required by a bunch of SCTLR_EL2 bits.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/config.c | 24 +++++++++++++++++++++---
>  1 file changed, 21 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 1990cebc77c66..7063fffc22799 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -26,6 +26,10 @@ struct reg_bits_to_feat_map {
>  #define        MASKS_POINTER   BIT(3)  /* Pointer to fgt_masks struct instead of bits */
>  #define        AS_RES1         BIT(4)  /* RES1 when not supported */
>  #define        REQUIRES_E2H1   BIT(5)  /* Add HCR_EL2.E2H RES1 as a pre-condition */
> +#define        RES0_WHEN_E2H0  BIT(6)  /* RES0 when E2H=0 and not supported */
> +#define        RES0_WHEN_E2H1  BIT(7)  /* RES0 when E2H=1 and not supported */
> +#define        RES1_WHEN_E2H0  BIT(8)  /* RES1 when E2H=0 and not supported */
> +#define        RES1_WHEN_E2H1  BIT(9)  /* RES1 when E2H=1 and not supported */
>
>         unsigned long   flags;
>
> @@ -1298,10 +1302,24 @@ struct resx compute_resx_bits(struct kvm *kvm,
>                         match &= !e2h0;
>
>                 if (!match) {
> +                       u64 bits = reg_feat_map_bits(&map[i]);
> +
> +                       if (e2h0) {
> +                               if      (map[i].flags & RES1_WHEN_E2H0)
> +                                       resx.res1 |= bits;
> +                               else if (map[i].flags & RES0_WHEN_E2H0)
> +                                       resx.res0 |= bits;
> +                       } else {
> +                               if      (map[i].flags & RES1_WHEN_E2H1)
> +                                       resx.res1 |= bits;
> +                               else if (map[i].flags & RES0_WHEN_E2H1)
> +                                       resx.res0 |= bits;
> +                       }
> +
>                         if (map[i].flags & AS_RES1)
> -                               resx.res1 |= reg_feat_map_bits(&map[i]);
> -                       else
> -                               resx.res0 |= reg_feat_map_bits(&map[i]);
> +                               resx.res1 |= bits;
> +                       else if (!(resx.res1 & bits))
> +                               resx.res0 |= bits;

The logic here feels a bit more complex than necessary, specifically
regarding the interaction between the E2H checks and the fallthrough
to AS_RES1.

Although AS_RES1 and RES0_WHEN_E2H0 are mutually exclusive in
practice, the current structure technically permits a scenario where
both res0 and res1 get set if the flags are mixed (the e2h0 block sets
res0, and the AS_RES1 block falls through and sets res1). This cannot
be ruled out by looking at this function alone.

  It might be cleaner (and safer) to determine the res1 first, and
then apply the masks. Something like:

+                       bool is_res1 = false;
+
+                       if (map[i].flags & AS_RES1)
+                               is_res1 = true;
+                       else if (e2h0)
+                               is_res1 = (map[i].flags & RES1_WHEN_E2H0);
+                       else
+                               is_res1 = (map[i].flags & RES1_WHEN_E2H1);
...

This also brings up a side point: given the visual similarity of these
flags, it is quite easy to make a typo and accidentally combine
incompatible flags (e.g., AS_RES1 | RESx_WHEN_E2Hx, or RES0_WHEN_E2H0
| RES1_WHEN_E2H0), would it be worth adding a check to warn on
obviously invalid combinations?

Or maybe even redefining AS_RES1 to be
(RES1_WHEN_E2H1|RES1_WHEN_E2H0), which is what it is conceptually.
That could simplify this code even further:

+                       if (e2h0)
+                               is_res1 = (map[i].flags & RES1_WHEN_E2H0);
+                       else
+                               is_res1 = (map[i].flags & RES1_WHEN_E2H1);

What do you think?

Cheers,
/fuad




>                 }
>         }
>
> --
> 2.47.3
>

