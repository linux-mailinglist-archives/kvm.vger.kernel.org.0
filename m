Return-Path: <kvm+bounces-69264-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ECO9LTICeWmOuQEAu9opvQ
	(envelope-from <kvm+bounces-69264-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 19:21:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3068C98F36
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 19:21:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F0D3B3044088
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 18:21:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F749326945;
	Tue, 27 Jan 2026 18:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qWHm0fXn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC6132693C
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 18:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769538087; cv=pass; b=Cp+iJTeyV7NIn40NRtmsqCmbo1x8y12SQHP9GG7NGxLewNO1xIRo9RtkWhgXOZqjtJjiJYHHd8J6X3lQ+DraZnNNchlBpG/czZh00b+DgapytW0H6X4Tlw3Rc6jrAglVOUnEOo39i4XYHeOD/fgcbpYBp/4IGxTuCZY7Urfq9eM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769538087; c=relaxed/simple;
	bh=g/5hkAwC8K8uuKp+mUsVYSQJdxRY3jyLmOOMHdLbhsw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ohYnJsnnOdRzibpEcJ6lEFtexwego48x763D92d1KuAX4fD5nbUWdGmOami5w5kJgYerY+JHTa6BdsTsQaHcCr+dLwCgE4r07gTAd7cJ8lVH1kSYI4UM89rwVYMbl0T3j8ZnGv5eSXKg0dPVjDBjmB5BgXTc6t4XbJeprb72J8k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qWHm0fXn; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-501511aa012so34391cf.0
        for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 10:21:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769538085; cv=none;
        d=google.com; s=arc-20240605;
        b=QDQhZXwLAkoJ/PT9kCGWgJNk0c6oBh7JWFw+C99dm0p/8JB0TSzHQTVvCG+LbnHWPG
         nEQFMgotsIT/HARHqQAk1p4JIuhI4/axSUEhxHBvyBvdIH7Kwnf223Z9RHBUF3gFajna
         9M1ljVAMf41UkLT6EFQ0zlubxExUcgVlbrP6bcEkmP33x0AG4AedSoMBec8T1bKiLIHb
         Tt+bc2aFIJYSJxXcdW/BmttOgHFi7uucAVuXIqjcCbJYG1Bso/ohTmA8gbWyHAS8ExV+
         Fx/TOl72kkAfepi9W9XKg1MMkMI6shlvBAUu7Rwy7LVHu07yH8unkPaXVDvBebveCqrf
         gngA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=v38EWj5h/QCAdjN/pQcmdZuKsr9ZCCkUgpYACTXDljc=;
        fh=8DpXGBMUhHPl0ZMuZrRpNVdILxmFl69pymPOYzWNlaU=;
        b=A4M8ub240+b3H0/CSqJB+jzW5v05xvf2p76zkJM1EmWbXqk/llATuhZTwk7ykI+pT7
         trFZpHGD17ZnrjFBZ81DBAKO8UVn+mG66BnPp1cVdoYqoyCG5e2ocDFEymcYaSNThNGp
         p9KxtY2ICKtFBztag5+wpoahH3uwR3hPn30mGrOvgdcMZBBmoYrMPGMH1uFCbyltGuJc
         DNdSN0jUefImN9F8FVmxl1twZLnsfIPdpgcUil9Qd5TTwvMp/YDnceEvUBLvatH30Lm+
         XNp8V2EMS2rpxCrwKjuIFmaAtpkLN+MKzOHgCE7jM8YBM2ErkhRWBemF8Jg8h6aYe7XB
         w+ug==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769538085; x=1770142885; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=v38EWj5h/QCAdjN/pQcmdZuKsr9ZCCkUgpYACTXDljc=;
        b=qWHm0fXnaGf93z/hcMVLVU2FQRj3OPlx4h25fxa/kxdEvcXJdeeQuB3l3QbAFUyjUD
         tV5pxWfjrxd64Oz5CXH34VrlSTu9EwSRrHtwJMmBUFfmdO+lTBsu2IzfsPF6ojc3+8su
         XTlpDhwULvkTpr5rHqTmz9m14OXlwL2z2AQSesYsIBjsCoFu/ew2YjQn6MwJRKFhb59m
         8wYRxPoJiNY2Gb5QudVVkNF4YjOLCO1Oj8UOgthh1b3AS8/mvC0vDT+brrx+QzVYl354
         Lnu2crL4kR07EwrZfp0SsgENYAJBmfr9pn1x8AJcYITC2E6G8vRZpEEvVtaIwuDIfmKA
         zE3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769538085; x=1770142885;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v38EWj5h/QCAdjN/pQcmdZuKsr9ZCCkUgpYACTXDljc=;
        b=FdPDm2sQZL4+FidM0BeD14yEb2wBK6cbx78L0b3aM6QpmSmR4y3HHj4Xt8mvj2ohFo
         P8D8aqOCzsJ0cTi4kXaT8JgZwywSuW0FLHGTmvBIeAG7IDzOM/YXUdg6Y3lLwb6E2VVr
         8lpNa2pCxdr3y27wL0ITO70TO/P+4v5+1z+bK1dl2gAqYUH+q+ugoSIG4v+KPfvE+MjS
         EqlWuSuOF+/Ew+J+HMxkveZtQGtOBZr0GkLWUIERqN+39dbQ4AhgGJm2NXv3twhT0yR+
         7pDN0HXmhE0MNmhJKZAx3/+s0O6kfCE786UkyqMkfK5E0QKcca7iCGW1wDRMRPsUhV+g
         qTcw==
X-Forwarded-Encrypted: i=1; AJvYcCUHhmy+n409IepKU9Z8reZsrVVR8BOHFLa7b8+YijR//tGySLMoZg2UIDV/L/jmaej0Qc8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzd9nHzJ3bI1RtitrWzgHpiVkBSu1HO+wyjX6UCgr4NXOFMiCNm
	3tTqLSuSa8f4WsByuo2YyIPfaOUz7ZksO8a+1gAgNZ4CZNjuXHyev1ew6b714OtSVQ7MF+glkpm
	fxaLo8Y1itHkI8Lhai3j9mrzeNLQcH+nY9TtNWEMD
X-Gm-Gg: AZuq6aIbTt29R+nHY5bpd3NH0QvZT3vtikN/HrCpUHylLg8b/qxfchBZpWjoBam0run
	u0jXbr5cfamG8nAAOgrQqVXMI+5X/M7gi3QyXcefMCJD09qI21aovgDOn2jWCnSwLU/F9AJTrwk
	0sUDt7jzQX8C/g/PHsO14clyeAc7PZeGY6+tK0NB5C0XXKWxSBZRdnEYmrhDv9z+jhdKYAcCFIx
	GmPKUPPV5+OqkbxzZjYfg/PqjWVmQ6DGJO61dOCs4lOGBP7FGUmCpSKvU56ElWsNUQZQYRg
X-Received: by 2002:ac8:5f11:0:b0:4ed:ff79:e678 with SMTP id
 d75a77b69052e-5032f52b23cmr10650801cf.18.1769538084451; Tue, 27 Jan 2026
 10:21:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-11-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-11-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 27 Jan 2026 18:20:47 +0000
X-Gm-Features: AZwV_QgHSiyi6-Py8aoEMg3B72DbuTR2OJAKTX59HorEV0HuWAtLNErLntzE9YA
Message-ID: <CA+EHjTzjRHXJMDKc8GY=8aQ3KJeLYSQYMH_tA03XMav=0VQ7RQ@mail.gmail.com>
Subject: Re: [PATCH 10/20] KVM: arm64: Simplify FIXED_VALUE handling
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
	TAGGED_FROM(0.00)[bounces-69264-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 3068C98F36
X-Rspamd-Action: no action

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> The FIXED_VALUE qualifier (mostly used for HCR_EL2) is pointlessly
> complicated, as it tries to piggy-back on the previous RES0 handling
> while being done in a different phase, on different data.
>
> Instead, make it an integral part of the RESx computation, and allow
> it to directly set RESx bits. This is much easier to understand.
>
> It also paves the way for some additional changes to that will allow
> the full removal of the FIXED_VALUE handling.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

The new code preserves the logic, and is easier to understand.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  arch/arm64/kvm/config.c | 67 ++++++++++++++---------------------------
>  1 file changed, 22 insertions(+), 45 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 39487182057a3..4fac04d3132c0 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -37,7 +37,7 @@ struct reg_bits_to_feat_map {
>                         s8      lo_lim;
>                 };
>                 bool    (*match)(struct kvm *);
> -               bool    (*fval)(struct kvm *, u64 *);
> +               bool    (*fval)(struct kvm *, struct resx *);
>         };
>  };
>
> @@ -389,14 +389,12 @@ static bool feat_vmid16(struct kvm *kvm)
>         return kvm_has_feat_enum(kvm, ID_AA64MMFR1_EL1, VMIDBits, 16);
>  }
>
> -static bool compute_hcr_e2h(struct kvm *kvm, u64 *bits)
> +static bool compute_hcr_e2h(struct kvm *kvm, struct resx *bits)
>  {
> -       if (bits) {
> -               if (kvm_has_feat(kvm, FEAT_E2H0))
> -                       *bits &= ~HCR_EL2_E2H;
> -               else
> -                       *bits |= HCR_EL2_E2H;
> -       }
> +       if (kvm_has_feat(kvm, FEAT_E2H0))
> +               bits->res0 |= HCR_EL2_E2H;
> +       else
> +               bits->res1 |= HCR_EL2_E2H;
>
>         return true;
>  }
> @@ -1281,12 +1279,11 @@ static bool idreg_feat_match(struct kvm *kvm, const struct reg_bits_to_feat_map
>  }
>
>  static
> -struct resx __compute_fixed_bits(struct kvm *kvm,
> -                               const struct reg_bits_to_feat_map *map,
> -                               int map_size,
> -                               u64 *fixed_bits,
> -                               unsigned long require,
> -                               unsigned long exclude)
> +struct resx compute_resx_bits(struct kvm *kvm,
> +                             const struct reg_bits_to_feat_map *map,
> +                             int map_size,
> +                             unsigned long require,
> +                             unsigned long exclude)
>  {
>         struct resx resx = {};
>
> @@ -1299,14 +1296,18 @@ struct resx __compute_fixed_bits(struct kvm *kvm,
>                 if (map[i].flags & exclude)
>                         continue;
>
> -               if (map[i].flags & CALL_FUNC)
> -                       match = (map[i].flags & FIXED_VALUE) ?
> -                               map[i].fval(kvm, fixed_bits) :
> -                               map[i].match(kvm);
> -               else
> +               switch (map[i].flags & (CALL_FUNC | FIXED_VALUE)) {
> +               case CALL_FUNC | FIXED_VALUE:
> +                       map[i].fval(kvm, &resx);
> +                       continue;
> +               case CALL_FUNC:
> +                       match = map[i].match(kvm);
> +                       break;
> +               default:
>                         match = idreg_feat_match(kvm, &map[i]);
> +               }
>
> -               if (!match || (map[i].flags & FIXED_VALUE)) {
> +               if (!match) {
>                         if (map[i].flags & AS_RES1)
>                                 resx.res1 |= reg_feat_map_bits(&map[i]);
>                         else
> @@ -1317,17 +1318,6 @@ struct resx __compute_fixed_bits(struct kvm *kvm,
>         return resx;
>  }
>
> -static
> -struct resx compute_resx_bits(struct kvm *kvm,
> -                            const struct reg_bits_to_feat_map *map,
> -                            int map_size,
> -                            unsigned long require,
> -                            unsigned long exclude)
> -{
> -       return __compute_fixed_bits(kvm, map, map_size, NULL,
> -                                   require, exclude | FIXED_VALUE);
> -}
> -
>  static
>  struct resx compute_reg_resx_bits(struct kvm *kvm,
>                                  const struct reg_feat_map_desc *r,
> @@ -1368,16 +1358,6 @@ static u64 compute_fgu_bits(struct kvm *kvm, const struct reg_feat_map_desc *r)
>         return resx.res0 | resx.res1;
>  }
>
> -static
> -struct resx compute_reg_fixed_bits(struct kvm *kvm,
> -                                 const struct reg_feat_map_desc *r,
> -                                 u64 *fixed_bits, unsigned long require,
> -                                 unsigned long exclude)
> -{
> -       return __compute_fixed_bits(kvm, r->bit_feat_map, r->bit_feat_map_sz,
> -                                   fixed_bits, require | FIXED_VALUE, exclude);
> -}
> -
>  void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt)
>  {
>         u64 val = 0;
> @@ -1417,7 +1397,6 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt)
>
>  struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg)
>  {
> -       u64 fixed = 0, mask;
>         struct resx resx;
>
>         switch (reg) {
> @@ -1459,10 +1438,8 @@ struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg)
>                 resx.res1 |= __HCRX_EL2_RES1;
>                 break;
>         case HCR_EL2:
> -               mask = compute_reg_fixed_bits(kvm, &hcr_desc, &fixed, 0, 0).res0;
>                 resx = compute_reg_resx_bits(kvm, &hcr_desc, 0, 0);
> -               resx.res0 |= (mask & ~fixed);
> -               resx.res1 |= HCR_EL2_RES1 | (mask & fixed);
> +               resx.res1 |= HCR_EL2_RES1;
>                 break;
>         case SCTLR2_EL1:
>         case SCTLR2_EL2:
> --
> 2.47.3
>

