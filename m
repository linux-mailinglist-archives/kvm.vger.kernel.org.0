Return-Path: <kvm+bounces-69259-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SGnPOA/9eGmOuQEAu9opvQ
	(envelope-from <kvm+bounces-69259-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 18:59:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FEEA98B46
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 18:59:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 347EC3003809
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 17:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B1EA324B1B;
	Tue, 27 Jan 2026 17:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lEa3NGxY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24EFD31E0F0
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 17:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769536758; cv=pass; b=Gue5FkcjoCtmZmJ6NgmUBTcbT4U4wJuPhxgkh71Wnq3eadwBqOSTyYD/QMZ+OnYSmBihxk5FIZdPd33JL/ZHfsyeI5sUrsSQa9mhyb5HsXe+TqYz2rnTknOa76xO86RJDbg4ltlkOE3ffGLT0mKz5TxQS1RL5Fp892WrziBDW/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769536758; c=relaxed/simple;
	bh=+hId3SRsn0ruZaW1Cfmoewhzbba8HuhwYa226fcimVY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A4bFR/lnEzEFrky8XLssaOYzMIQCx8EXX/qP72Px6Ucj7ADFFy9uQdKBtpR+ecu3FKHBSKELxaRod6sCMHf2I7RI3hqKTCfGe0Q8DagZ6uZFf/+sXo5EzhkohJ+/bb+PLHrvW7OfZZcvAmyKIQo+g6VEdtebCKfYIGsXMKQgzsw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lEa3NGxY; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-50299648ae9so7041cf.1
        for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 09:59:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769536756; cv=none;
        d=google.com; s=arc-20240605;
        b=dWp1qHeZtq0JesQpoj087Jk3uCYbmt5oq7JXDxytn9jlTYgp9qUp5yVdZYj7IXxFbn
         Ngd5ItEDkHfq0K2uWlP76ORGE4Bq+GqmCKo0JM+0to+ShXntX/dTH7zWayxNiLG3UPmn
         68gEQMKdObsq8+5GhWDl35aZqZsYll/wOy7hz13CKv+vc+SiM44dwAN9WXadLMfYEL+r
         ZdSk8/JAscIizCvWezkHnaN9t7oQR0kXicGPw6UfgXBAI7b2SfGEmapEUJpSa1ZIlIS7
         7ND0pRMCIvp6IwgFRX0pOLDcCP2YcFEZQcYfpnIAFFeKl9Ky5Tya6I13Ks6cSQfGSeRy
         Z6lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=WXQLAHVKOq8T4zWobG4KuuypQi16GgCGUfWQ2Xeqgb4=;
        fh=3E1wXChJLMrmNaDLFgCR0+nPky9h7l74crIDY0Sa7Dg=;
        b=PmX+5gzdbnJmJXW0b2b9KcipXGTPZL5tB1kxQ1K0hKYBNeoKTwstyS/tBSMwgM014y
         OFU3Wkzu35uOGXFNDrnzDxpqlld1pBC7BOpKwfoF7ZDDnrLnw7UvZYvA4VcjIh/2iMa1
         Ti1tE8bUR68JJ5CLkxtF7fzpAbgK+cpxvKC5XcqsY7g1CRXs33R9tkbIcwiGh9Pwj8OW
         37zUrCf2RHDAliKSKd+gdJc+nRbg4umTGQDRL8EAziP2WIGQvdUOHMjE8dTgxriGTwjQ
         NFB6Lj59rNqMhjfQ4p6dcjmGFGkL0WXewoYp80dVercCWX3s4zy6T326mr8hvY8ZSEgD
         YBXw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769536756; x=1770141556; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WXQLAHVKOq8T4zWobG4KuuypQi16GgCGUfWQ2Xeqgb4=;
        b=lEa3NGxYfmvujLuikTlvZ2EcaFL/jDr3wMPYAAsOZMLTLPIlZO93OZfb61oMPGfzLR
         HaZzEkvHhY8cpOF/ibBmuyfwjNhk+JJsm04+uiXFmpNYvUXjreC1VC8oD5NKANTf1a2V
         CpGDxVMi8LbZvwLzavYxEMIEJZZy/0L7N1Djvo/S2AhP70FSYwdgYvnQGNLZlm6XLJRW
         6LxaYV5TYdQ1htpLy5aTx2HqvmabvQ5Ggv3vzng3hDsR6vOZ3U8ywt8hsNBxaSMFJE90
         /MMPOaDAy6F94NbplaEWn/wMvEiahOZTmX5s7rLFMBocQpUasT7Yd/9T6D3F2gVwtIeD
         TRDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769536756; x=1770141556;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WXQLAHVKOq8T4zWobG4KuuypQi16GgCGUfWQ2Xeqgb4=;
        b=Rio2lfIgiXtcZ0wzPWnLEAX9JWRQpx1phKUkgmI80UKUd+bQM7EdvHENsv9enhCMV2
         WHaWdJKb7oX+CaspK4hz3dLH21juf1KdxmHJmnRpXM2rkG88g8XF1K/68H59JFgmPZTa
         RhdJtqk9y5PP19IIvtt7aj+5IuA35bLk6TLVodVqRdnH2vPPM35ksC9o+9XogOofsoVD
         8eAzZD4pp+brP36h4HBLKGXSwmRjCdFXYP5Wwdfqs4KrEn9QPgLf//OE9cn3/3DUPDxQ
         Faw4kohqGl+/i76Dv+J7TjR/OpxJEwtK70G3PMcAH/Aw+Lm73SrYjA6OcvwiQmk8t4WE
         PlLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXVSu8vZc3SK/WHHIIH/DX46QyfOuHjLYqCnrQE+hZfjrcrwX9qgtmTcNps7E8qNw3/aFU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkRXADquoB1ztjGJnDlLhQv7HnoZmLD7dGHB24gC9Myc2GFK8M
	G04yZVfz58z+g0VklSWXm4U3zhTkTCqiDyOQ+24V8KlR32ydUjGBdKGpkl3im8B9Q3Yh3DiyC0p
	bswJDLbciK0Bmp9hQPIKkWzKEFTzqOnRSeRejh3iL
X-Gm-Gg: AZuq6aK17OPDEXkkZuJfWwsK2rraGofVvbzwuO4Ok/lvSIn1DIub0eVANLu6ODpUakQ
	wVkrf38h5U/cHg77ARAjg3BRbXnr+DIyyYSBaoNaWCrsJrpy9oD54ec4hfQkaWT2QoBudDB7Fd9
	oNXBBjeWJFFsYrTgk2PZ7cjD7P/a9vYt7gyB7W8CRaICVMJwQ1fpOPB64BBzoJrBL/+UuCqAsaE
	7aNlEcNrkXGR6yge/26P94GfYmmY3s2Fh5OP5Fnchfdmjg4B5/LnUBMOHxtFtRcsQAXgz14
X-Received: by 2002:ac8:7d89:0:b0:501:3b94:bcae with SMTP id
 d75a77b69052e-5032f479773mr10069921cf.8.1769536755734; Tue, 27 Jan 2026
 09:59:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-7-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-7-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 27 Jan 2026 17:58:38 +0000
X-Gm-Features: AZwV_QhS3T7BGI_KLXpUw2zt_uf_weVG0r6EiuX_Phs-QUEKVVf5BCeOHp72BZA
Message-ID: <CA+EHjTzU=rNQd7YU9O+ombTsZgTHgFThe6BGP20ii2xC2V473Q@mail.gmail.com>
Subject: Re: [PATCH 06/20] KVM: arm64: Inherit RESx bits from FGT register descriptors
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69259-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 1FEEA98B46
X-Rspamd-Action: no action

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> The FGT registers have their computed RESx bits stashed in specific
> descriptors, which we can easily use when computing the masks used
> for the guest.
>
> This removes a bit of boilerplate code.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  arch/arm64/kvm/config.c | 16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index a907195bd44b6..8d152605999ba 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -1344,6 +1344,11 @@ struct resx compute_reg_resx_bits(struct kvm *kvm,
>         resx = compute_resx_bits(kvm, r->bit_feat_map, r->bit_feat_map_sz,
>                                  require, exclude);
>
> +       if (r->feat_map.flags & MASKS_POINTER) {
> +               resx.res0 |= r->feat_map.masks->res0;
> +               resx.res1 |= r->feat_map.masks->res1;
> +       }
> +
>         tmp = compute_resx_bits(kvm, &r->feat_map, 1, require, exclude);
>
>         resx.res0 |= tmp.res0;
> @@ -1424,47 +1429,36 @@ struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg)
>         switch (reg) {
>         case HFGRTR_EL2:
>                 resx = compute_reg_resx_bits(kvm, &hfgrtr_desc, 0, 0);
> -               resx.res1 |= HFGRTR_EL2_RES1;
>                 break;
>         case HFGWTR_EL2:
>                 resx = compute_reg_resx_bits(kvm, &hfgwtr_desc, 0, 0);
> -               resx.res1 |= HFGWTR_EL2_RES1;
>                 break;
>         case HFGITR_EL2:
>                 resx = compute_reg_resx_bits(kvm, &hfgitr_desc, 0, 0);
> -               resx.res1 |= HFGITR_EL2_RES1;
>                 break;
>         case HDFGRTR_EL2:
>                 resx = compute_reg_resx_bits(kvm, &hdfgrtr_desc, 0, 0);
> -               resx.res1 |= HDFGRTR_EL2_RES1;
>                 break;
>         case HDFGWTR_EL2:
>                 resx = compute_reg_resx_bits(kvm, &hdfgwtr_desc, 0, 0);
> -               resx.res1 |= HDFGWTR_EL2_RES1;
>                 break;
>         case HAFGRTR_EL2:
>                 resx = compute_reg_resx_bits(kvm, &hafgrtr_desc, 0, 0);
> -               resx.res1 |= HAFGRTR_EL2_RES1;
>                 break;
>         case HFGRTR2_EL2:
>                 resx = compute_reg_resx_bits(kvm, &hfgrtr2_desc, 0, 0);
> -               resx.res1 |= HFGRTR2_EL2_RES1;
>                 break;
>         case HFGWTR2_EL2:
>                 resx = compute_reg_resx_bits(kvm, &hfgwtr2_desc, 0, 0);
> -               resx.res1 |= HFGWTR2_EL2_RES1;
>                 break;
>         case HFGITR2_EL2:
>                 resx = compute_reg_resx_bits(kvm, &hfgitr2_desc, 0, 0);
> -               resx.res1 |= HFGITR2_EL2_RES1;
>                 break;
>         case HDFGRTR2_EL2:
>                 resx = compute_reg_resx_bits(kvm, &hdfgrtr2_desc, 0, 0);
> -               resx.res1 |= HDFGRTR2_EL2_RES1;
>                 break;
>         case HDFGWTR2_EL2:
>                 resx = compute_reg_resx_bits(kvm, &hdfgwtr2_desc, 0, 0);
> -               resx.res1 |= HDFGWTR2_EL2_RES1;
>                 break;
>         case HCRX_EL2:
>                 resx = compute_reg_resx_bits(kvm, &hcrx_desc, 0, 0);
> --
> 2.47.3
>

