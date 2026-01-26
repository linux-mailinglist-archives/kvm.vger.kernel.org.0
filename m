Return-Path: <kvm+bounces-69169-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kCxBFm64d2nKkQEAu9opvQ
	(envelope-from <kvm+bounces-69169-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 19:54:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A97428C3AE
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 19:54:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A76D330247CF
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 18:54:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5DDA25B1DA;
	Mon, 26 Jan 2026 18:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PRVPZpNn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DB12459ED
	for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 18:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769453671; cv=pass; b=BGDWa4oZtCK/J5met2BSeTjPniPu6OIcaLoowOyVyqNZ1I20Bb7nNhXchyvZprf46oiU8Y+immoeQc+lCmAN4WR6zaUbrY3Ljq8i3GrFBasbW35dClnF3xTc8C0nQqUMl9Kew62k932lz+Z79N5Iptq6XqYsNM+XcMaHiaUS5s8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769453671; c=relaxed/simple;
	bh=CFenQmwnmFtytfi885JzKAJGxm3UO8jNGSMGkg8UF9E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=orv6AtIAmCfGDsy0RwT1Tevde3U/JpapKtx5Er7QaCmO/27WSaxPq0UDAsf7FI1hkqYCiv58UI2X1/qLlPot8sYmqBraEGuys//9iSed1OfCpQmR8osIpUxNffERhYayzpRJcGwUQkrr3XVhh0NNiL5f2qHdLP38msDoLYYGfMs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PRVPZpNn; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-501511aa012so45821cf.0
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 10:54:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769453668; cv=none;
        d=google.com; s=arc-20240605;
        b=asMVJo/EmB+1DcY0yrGfDA4LyQhSNnUZzVVvgEgc/e2mhwQYoK5XaWRwgxIX8ZxiC4
         8lV9d1q/1KzBpoJ334E/a84l2lUgWtDBfKhZ8p1JAtQ7xJaHjLcT4LLB+4st3olMAnV+
         tHcEx1+OgTuQfWL59IAsyLlhlimMPhwyBLO4sZ0Hl1PqDg7TxE8ON8SYN2PvOR08MrCT
         /VV8NZoIV3GV09GQH+hNpvG8JybFeCISGAdzg3zJ1Tcr9ZcCcKROKxwog2mnsoAQtOiY
         6aF+WMDx7XNPGlOgi5uN4IaAjpmvr+i/IKhs9XbDTjr4AHAJOWvxSFoCqLKeKdH6M92H
         lzWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=A20ynRevkaS25P7B8llafdHKibWpVBHY4kqra9wcNrY=;
        fh=kr8ooFTnPCL8f04KdcQ2DIyXZOdfpDuQzYzcYBzzHTM=;
        b=W9d72NBvg1Qkb43yN+wB7bUwtZefrdYRhXuXmzcl2qxQRSkjOlGfjLk71AMBRcdgUZ
         AfYTIIWCBrcE3akeul16dOffSyqnpNxwfeYiW83anZXfAtPFdGcFSiGKPgO1bYDR3Bko
         sO8O7K6k42evEDH8B5bcZcbX/y/jeykcoZx1qIKOsPV41VoDCKtsCrmt6gGsEqZi38pH
         JVhp9+5u7EwMrzNSQYSMQ4dlsZZaR6h3sejKAgFohMPK1zE5atWIWhw6y37wKDUtRurZ
         PRY1J17dcmYCmC9GY4l6MfBtn1N2LTPP86kqAkdmsR+zQTKINAiKG1BLBykod3vBCRO5
         nIcw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769453668; x=1770058468; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=A20ynRevkaS25P7B8llafdHKibWpVBHY4kqra9wcNrY=;
        b=PRVPZpNnDC8R3+2ZnshFkgecp/FbSkG3H34tguni57Cuocl8Jk1D6sFADUhHfQcWwH
         7yK4bmlGpa7f3wepQ75t/5QJEUo5C/g+N1gL3lRVtmp8ctd/n5bgKWq8lzIf2IaS7K3b
         CC+iE95CEV+xShIYUaNLYnpIha2b8BKDMtJ4ZqY7+w05CsBz+duXVRXr2PKky970RmM/
         RUvvtxx+CDc5daBV1v9UPBGDac34OAHq73uYZ8PZLiwArM1cTNTHxclzNvTC2cNXaqQb
         2NC4SR9vX/qVobm+ZAkFkXqMTkVuSi8FXgzzXNcgnbr73IgQj21aXdga1G4MmrPRBx+6
         DQPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769453668; x=1770058468;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A20ynRevkaS25P7B8llafdHKibWpVBHY4kqra9wcNrY=;
        b=Acdrgs63i7Yrda6aYe6yfitq3xs3JBABhG2/HPdWi20B27o/PAJo0uDM3jHXojQIAf
         3UUCOmyKRlWv/jS7Lqv3bJe7o1LMPnfBtyfILNI5rLlW7XZZoPtnQekr9Dl++Tv7CuQE
         7Qqo8bZPu/XWnYBxaM8IhdI+lBuHlBbeCXl06InEkyZkxYPXeRi+UGyr+Mui8WR7fmh+
         +69sf1Jzm4JV9DQoN406m2XCJQxYrGo6GxKhoU/xVZ+/bQGYYBbzdEQTgjNnBDVu6tLn
         7dC8XAn7UEkRXo5QqAI40YmrFeq5bULKomLZNWjIHt6P9eD9AI4J5rhDJAWLfNjVWSGY
         pjnw==
X-Forwarded-Encrypted: i=1; AJvYcCWLOHUaPJ5gdP6JwubuJtFpRMJ4vBoGymoTEDctU8SYO0+kb5JY/FkbDsTiBDaywZOjjus=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHhsALKGgBzddrZyubWplDx0MBQzcoci6ahO2+HZHJcmfobaR8
	vFWXsSdB6If63B2UPBmx20Utu1xuwFj/Mp9kapjxaAI1vqJwNejHSphewijCS5cJ7MkvQLbg95E
	PvFt0pOV0Lk6E0ND1FJVo0aC9ZEneF3aMK5sYCslJn1J+X4MYkPcFrKn1
X-Gm-Gg: AZuq6aIlaJKuGIYa/E5KjgD6b3Nri9axA+sw6H+HRbuulaa/lKj6ZLe79z5dKmvU/jH
	0Ktdep9GwdptRCPAK1EY7yOoFzk0egT0ASthYbH9q22zoV/wLuf2tcgrkdapzQ8ZwR3GyJkOwkz
	U2lspIqJPknWrJQH3bF9eY66jEvURU3654qGrVk8d9qMgyQoMMrN4czumei/LBliQPDwjbdrZKt
	eiBH7kbQgXkw9pZZ9RvkgSRrYnp7wVpHaLmXJVTadz7CRDkVE4vX9qhctV5vhIm5BZwXJYrX57M
	u1MRaSo=
X-Received: by 2002:a05:622a:107:b0:4ff:c0e7:be9c with SMTP id
 d75a77b69052e-5031418f5d0mr13951761cf.0.1769453667744; Mon, 26 Jan 2026
 10:54:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-5-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-5-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 26 Jan 2026 18:54:00 +0000
X-Gm-Features: AZwV_QjKBi-w0NfZ79ozOKdoVZLPRhYxhGBL0j4hIUh_Ifbq0y3wSazQgK06B-4
Message-ID: <CA+EHjTwuX6y4BY2D3T=59SHX-83RiRCsF=HsqqRKH8K1yUGrmg@mail.gmail.com>
Subject: Re: [PATCH 04/20] KVM: arm64: Introduce data structure tracking both
 RES0 and RES1 bits
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
	TAGGED_FROM(0.00)[bounces-69169-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: A97428C3AE
X-Rspamd-Action: no action

Hi Marc,

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> We have so far mostly tracked RES0 bits, but only made a few attempts
> at being just as strict for RES1 bits (probably because they are both
> rarer and harder to handle).
>
> Start scratching the surface by introducing a data structure tracking
> RES0 and RES1 bits at the same time.
>
> Note that contrary to the usual idiom, this structure is mostly passed
> around by value -- the ABI handles it nicely, and the resulting code is
> much nicer.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |  17 ++--
>  arch/arm64/kvm/config.c           | 122 +++++++++++++++-------------
>  arch/arm64/kvm/nested.c           | 129 +++++++++++++++---------------
>  3 files changed, 144 insertions(+), 124 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index b552a1e03848c..a7e4cd8ebf56f 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -626,13 +626,20 @@ enum vcpu_sysreg {
>         NR_SYS_REGS     /* Nothing after this line! */
>  };
>
> +struct resx {
> +       u64     res0;
> +       u64     res1;
> +};
> +
>  struct kvm_sysreg_masks {
> -       struct {
> -               u64     res0;
> -               u64     res1;
> -       } mask[NR_SYS_REGS - __SANITISED_REG_START__];
> +       struct resx mask[NR_SYS_REGS - __SANITISED_REG_START__];
>  };
>
> +#define kvm_set_sysreg_resx(k, sr, resx)               \
> +       do {                                            \
> +               (k)->arch.sysreg_masks->mask[sr - __SANITISED_REG_START__] = resx; \

Is sr better between parentheses (sr)? (checkpatch, but I think it's valid)

> +       } while(0)

checkpatch nit: space after while

> +
>  struct fgt_masks {
>         const char      *str;
>         u64             mask;
> @@ -1607,7 +1614,7 @@ static inline bool kvm_arch_has_irq_bypass(void)
>  }
>
>  void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt);
> -void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *res1);
> +struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg);
>  void check_feature_map(void);
>  void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu);
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 2122599f7cbbd..a907195bd44b6 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -1290,14 +1290,15 @@ static bool idreg_feat_match(struct kvm *kvm, const struct reg_bits_to_feat_map
>         }
>  }
>

nit: all the functions below with multiline parameters are misaligned
wrt the parenthesis (checkpatch, but also visible in editor).

> -static u64 __compute_fixed_bits(struct kvm *kvm,
> +static

nit: why the newline? (and same for the remaining ones below)

Nits aside, this preserves the logic and the resulting code is already
easier to read and understand.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad



> +struct resx __compute_fixed_bits(struct kvm *kvm,
>                                 const struct reg_bits_to_feat_map *map,
>                                 int map_size,
>                                 u64 *fixed_bits,
>                                 unsigned long require,
>                                 unsigned long exclude)
>  {
> -       u64 val = 0;
> +       struct resx resx = {};
>
>         for (int i = 0; i < map_size; i++) {
>                 bool match;
> @@ -1316,13 +1317,14 @@ static u64 __compute_fixed_bits(struct kvm *kvm,
>                         match = idreg_feat_match(kvm, &map[i]);
>
>                 if (!match || (map[i].flags & FIXED_VALUE))
> -                       val |= reg_feat_map_bits(&map[i]);
> +                       resx.res0 |= reg_feat_map_bits(&map[i]);
>         }
>
> -       return val;
> +       return resx;
>  }
>
> -static u64 compute_res0_bits(struct kvm *kvm,
> +static
> +struct resx compute_resx_bits(struct kvm *kvm,
>                              const struct reg_bits_to_feat_map *map,
>                              int map_size,
>                              unsigned long require,
> @@ -1332,34 +1334,43 @@ static u64 compute_res0_bits(struct kvm *kvm,
>                                     require, exclude | FIXED_VALUE);
>  }
>
> -static u64 compute_reg_res0_bits(struct kvm *kvm,
> +static
> +struct resx compute_reg_resx_bits(struct kvm *kvm,
>                                  const struct reg_feat_map_desc *r,
>                                  unsigned long require, unsigned long exclude)
>  {
> -       u64 res0;
> +       struct resx resx, tmp;
>
> -       res0 = compute_res0_bits(kvm, r->bit_feat_map, r->bit_feat_map_sz,
> +       resx = compute_resx_bits(kvm, r->bit_feat_map, r->bit_feat_map_sz,
>                                  require, exclude);
>
> -       res0 |= compute_res0_bits(kvm, &r->feat_map, 1, require, exclude);
> -       res0 |= ~reg_feat_map_bits(&r->feat_map);
> +       tmp = compute_resx_bits(kvm, &r->feat_map, 1, require, exclude);
> +
> +       resx.res0 |= tmp.res0;
> +       resx.res0 |= ~reg_feat_map_bits(&r->feat_map);
> +       resx.res1 |= tmp.res1;
>
> -       return res0;
> +       return resx;
>  }
>
>  static u64 compute_fgu_bits(struct kvm *kvm, const struct reg_feat_map_desc *r)
>  {
> +       struct resx resx;
> +
>         /*
>          * If computing FGUs, we collect the unsupported feature bits as
> -        * RES0 bits, but don't take the actual RES0 bits or register
> +        * RESx bits, but don't take the actual RESx bits or register
>          * existence into account -- we're not computing bits for the
>          * register itself.
>          */
> -       return compute_res0_bits(kvm, r->bit_feat_map, r->bit_feat_map_sz,
> +       resx = compute_resx_bits(kvm, r->bit_feat_map, r->bit_feat_map_sz,
>                                  0, NEVER_FGU);
> +
> +       return resx.res0 | resx.res1;
>  }
>
> -static u64 compute_reg_fixed_bits(struct kvm *kvm,
> +static
> +struct resx compute_reg_fixed_bits(struct kvm *kvm,
>                                   const struct reg_feat_map_desc *r,
>                                   u64 *fixed_bits, unsigned long require,
>                                   unsigned long exclude)
> @@ -1405,91 +1416,94 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt)
>         kvm->arch.fgu[fgt] = val;
>  }
>
> -void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *res1)
> +struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg)
>  {
>         u64 fixed = 0, mask;
> +       struct resx resx;
>
>         switch (reg) {
>         case HFGRTR_EL2:
> -               *res0 = compute_reg_res0_bits(kvm, &hfgrtr_desc, 0, 0);
> -               *res1 = HFGRTR_EL2_RES1;
> +               resx = compute_reg_resx_bits(kvm, &hfgrtr_desc, 0, 0);
> +               resx.res1 |= HFGRTR_EL2_RES1;
>                 break;
>         case HFGWTR_EL2:
> -               *res0 = compute_reg_res0_bits(kvm, &hfgwtr_desc, 0, 0);
> -               *res1 = HFGWTR_EL2_RES1;
> +               resx = compute_reg_resx_bits(kvm, &hfgwtr_desc, 0, 0);
> +               resx.res1 |= HFGWTR_EL2_RES1;
>                 break;
>         case HFGITR_EL2:
> -               *res0 = compute_reg_res0_bits(kvm, &hfgitr_desc, 0, 0);
> -               *res1 = HFGITR_EL2_RES1;
> +               resx = compute_reg_resx_bits(kvm, &hfgitr_desc, 0, 0);
> +               resx.res1 |= HFGITR_EL2_RES1;
>                 break;
>         case HDFGRTR_EL2:
> -               *res0 = compute_reg_res0_bits(kvm, &hdfgrtr_desc, 0, 0);
> -               *res1 = HDFGRTR_EL2_RES1;
> +               resx = compute_reg_resx_bits(kvm, &hdfgrtr_desc, 0, 0);
> +               resx.res1 |= HDFGRTR_EL2_RES1;
>                 break;
>         case HDFGWTR_EL2:
> -               *res0 = compute_reg_res0_bits(kvm, &hdfgwtr_desc, 0, 0);
> -               *res1 = HDFGWTR_EL2_RES1;
> +               resx = compute_reg_resx_bits(kvm, &hdfgwtr_desc, 0, 0);
> +               resx.res1 |= HDFGWTR_EL2_RES1;
>                 break;
>         case HAFGRTR_EL2:
> -               *res0 = compute_reg_res0_bits(kvm, &hafgrtr_desc, 0, 0);
> -               *res1 = HAFGRTR_EL2_RES1;
> +               resx = compute_reg_resx_bits(kvm, &hafgrtr_desc, 0, 0);
> +               resx.res1 |= HAFGRTR_EL2_RES1;
>                 break;
>         case HFGRTR2_EL2:
> -               *res0 = compute_reg_res0_bits(kvm, &hfgrtr2_desc, 0, 0);
> -               *res1 = HFGRTR2_EL2_RES1;
> +               resx = compute_reg_resx_bits(kvm, &hfgrtr2_desc, 0, 0);
> +               resx.res1 |= HFGRTR2_EL2_RES1;
>                 break;
>         case HFGWTR2_EL2:
> -               *res0 = compute_reg_res0_bits(kvm, &hfgwtr2_desc, 0, 0);
> -               *res1 = HFGWTR2_EL2_RES1;
> +               resx = compute_reg_resx_bits(kvm, &hfgwtr2_desc, 0, 0);
> +               resx.res1 |= HFGWTR2_EL2_RES1;
>                 break;
>         case HFGITR2_EL2:
> -               *res0 = compute_reg_res0_bits(kvm, &hfgitr2_desc, 0, 0);
> -               *res1 = HFGITR2_EL2_RES1;
> +               resx = compute_reg_resx_bits(kvm, &hfgitr2_desc, 0, 0);
> +               resx.res1 |= HFGITR2_EL2_RES1;
>                 break;
>         case HDFGRTR2_EL2:
> -               *res0 = compute_reg_res0_bits(kvm, &hdfgrtr2_desc, 0, 0);
> -               *res1 = HDFGRTR2_EL2_RES1;
> +               resx = compute_reg_resx_bits(kvm, &hdfgrtr2_desc, 0, 0);
> +               resx.res1 |= HDFGRTR2_EL2_RES1;
>                 break;
>         case HDFGWTR2_EL2:
> -               *res0 = compute_reg_res0_bits(kvm, &hdfgwtr2_desc, 0, 0);
> -               *res1 = HDFGWTR2_EL2_RES1;
> +               resx = compute_reg_resx_bits(kvm, &hdfgwtr2_desc, 0, 0);
> +               resx.res1 |= HDFGWTR2_EL2_RES1;
>                 break;
>         case HCRX_EL2:
> -               *res0 = compute_reg_res0_bits(kvm, &hcrx_desc, 0, 0);
> -               *res1 = __HCRX_EL2_RES1;
> +               resx = compute_reg_resx_bits(kvm, &hcrx_desc, 0, 0);
> +               resx.res1 |= __HCRX_EL2_RES1;
>                 break;
>         case HCR_EL2:
> -               mask = compute_reg_fixed_bits(kvm, &hcr_desc, &fixed, 0, 0);
> -               *res0 = compute_reg_res0_bits(kvm, &hcr_desc, 0, 0);
> -               *res0 |= (mask & ~fixed);
> -               *res1 = HCR_EL2_RES1 | (mask & fixed);
> +               mask = compute_reg_fixed_bits(kvm, &hcr_desc, &fixed, 0, 0).res0;
> +               resx = compute_reg_resx_bits(kvm, &hcr_desc, 0, 0);
> +               resx.res0 |= (mask & ~fixed);
> +               resx.res1 |= HCR_EL2_RES1 | (mask & fixed);
>                 break;
>         case SCTLR2_EL1:
>         case SCTLR2_EL2:
> -               *res0 = compute_reg_res0_bits(kvm, &sctlr2_desc, 0, 0);
> -               *res1 = SCTLR2_EL1_RES1;
> +               resx = compute_reg_resx_bits(kvm, &sctlr2_desc, 0, 0);
> +               resx.res1 |= SCTLR2_EL1_RES1;
>                 break;
>         case TCR2_EL2:
> -               *res0 = compute_reg_res0_bits(kvm, &tcr2_el2_desc, 0, 0);
> -               *res1 = TCR2_EL2_RES1;
> +               resx = compute_reg_resx_bits(kvm, &tcr2_el2_desc, 0, 0);
> +               resx.res1 |= TCR2_EL2_RES1;
>                 break;
>         case SCTLR_EL1:
> -               *res0 = compute_reg_res0_bits(kvm, &sctlr_el1_desc, 0, 0);
> -               *res1 = SCTLR_EL1_RES1;
> +               resx = compute_reg_resx_bits(kvm, &sctlr_el1_desc, 0, 0);
> +               resx.res1 |= SCTLR_EL1_RES1;
>                 break;
>         case MDCR_EL2:
> -               *res0 = compute_reg_res0_bits(kvm, &mdcr_el2_desc, 0, 0);
> -               *res1 = MDCR_EL2_RES1;
> +               resx = compute_reg_resx_bits(kvm, &mdcr_el2_desc, 0, 0);
> +               resx.res1 |= MDCR_EL2_RES1;
>                 break;
>         case VTCR_EL2:
> -               *res0 = compute_reg_res0_bits(kvm, &vtcr_el2_desc, 0, 0);
> -               *res1 = VTCR_EL2_RES1;
> +               resx = compute_reg_resx_bits(kvm, &vtcr_el2_desc, 0, 0);
> +               resx.res1 |= VTCR_EL2_RES1;
>                 break;
>         default:
>                 WARN_ON_ONCE(1);
> -               *res0 = *res1 = 0;
> +               resx = (typeof(resx)){};
>                 break;
>         }
> +
> +       return resx;
>  }
>
>  static __always_inline struct fgt_masks *__fgt_reg_to_masks(enum vcpu_sysreg reg)
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 486eba72bb027..c5a45bc62153e 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1683,22 +1683,19 @@ u64 kvm_vcpu_apply_reg_masks(const struct kvm_vcpu *vcpu,
>         return v;
>  }
>
> -static __always_inline void set_sysreg_masks(struct kvm *kvm, int sr, u64 res0, u64 res1)
> +static __always_inline void set_sysreg_masks(struct kvm *kvm, int sr, struct resx resx)
>  {
> -       int i = sr - __SANITISED_REG_START__;
> -
>         BUILD_BUG_ON(!__builtin_constant_p(sr));
>         BUILD_BUG_ON(sr < __SANITISED_REG_START__);
>         BUILD_BUG_ON(sr >= NR_SYS_REGS);
>
> -       kvm->arch.sysreg_masks->mask[i].res0 = res0;
> -       kvm->arch.sysreg_masks->mask[i].res1 = res1;
> +       kvm_set_sysreg_resx(kvm, sr, resx);
>  }
>
>  int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
>  {
>         struct kvm *kvm = vcpu->kvm;
> -       u64 res0, res1;
> +       struct resx resx;
>
>         lockdep_assert_held(&kvm->arch.config_lock);
>
> @@ -1711,110 +1708,112 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
>                 return -ENOMEM;
>
>         /* VTTBR_EL2 */
> -       res0 = res1 = 0;
> +       resx = (typeof(resx)){};
>         if (!kvm_has_feat_enum(kvm, ID_AA64MMFR1_EL1, VMIDBits, 16))
> -               res0 |= GENMASK(63, 56);
> +               resx.res0 |= GENMASK(63, 56);
>         if (!kvm_has_feat(kvm, ID_AA64MMFR2_EL1, CnP, IMP))
> -               res0 |= VTTBR_CNP_BIT;
> -       set_sysreg_masks(kvm, VTTBR_EL2, res0, res1);
> +               resx.res0 |= VTTBR_CNP_BIT;
> +       set_sysreg_masks(kvm, VTTBR_EL2, resx);
>
>         /* VTCR_EL2 */
> -       get_reg_fixed_bits(kvm, VTCR_EL2, &res0, &res1);
> -       set_sysreg_masks(kvm, VTCR_EL2, res0, res1);
> +       resx = get_reg_fixed_bits(kvm, VTCR_EL2);
> +       set_sysreg_masks(kvm, VTCR_EL2, resx);
>
>         /* VMPIDR_EL2 */
> -       res0 = GENMASK(63, 40) | GENMASK(30, 24);
> -       res1 = BIT(31);
> -       set_sysreg_masks(kvm, VMPIDR_EL2, res0, res1);
> +       resx.res0 = GENMASK(63, 40) | GENMASK(30, 24);
> +       resx.res1 = BIT(31);
> +       set_sysreg_masks(kvm, VMPIDR_EL2, resx);
>
>         /* HCR_EL2 */
> -       get_reg_fixed_bits(kvm, HCR_EL2, &res0, &res1);
> -       set_sysreg_masks(kvm, HCR_EL2, res0, res1);
> +       resx = get_reg_fixed_bits(kvm, HCR_EL2);
> +       set_sysreg_masks(kvm, HCR_EL2, resx);
>
>         /* HCRX_EL2 */
> -       get_reg_fixed_bits(kvm, HCRX_EL2, &res0, &res1);
> -       set_sysreg_masks(kvm, HCRX_EL2, res0, res1);
> +       resx = get_reg_fixed_bits(kvm, HCRX_EL2);
> +       set_sysreg_masks(kvm, HCRX_EL2, resx);
>
>         /* HFG[RW]TR_EL2 */
> -       get_reg_fixed_bits(kvm, HFGRTR_EL2, &res0, &res1);
> -       set_sysreg_masks(kvm, HFGRTR_EL2, res0, res1);
> -       get_reg_fixed_bits(kvm, HFGWTR_EL2, &res0, &res1);
> -       set_sysreg_masks(kvm, HFGWTR_EL2, res0, res1);
> +       resx = get_reg_fixed_bits(kvm, HFGRTR_EL2);
> +       set_sysreg_masks(kvm, HFGRTR_EL2, resx);
> +       resx = get_reg_fixed_bits(kvm, HFGWTR_EL2);
> +       set_sysreg_masks(kvm, HFGWTR_EL2, resx);
>
>         /* HDFG[RW]TR_EL2 */
> -       get_reg_fixed_bits(kvm, HDFGRTR_EL2, &res0, &res1);
> -       set_sysreg_masks(kvm, HDFGRTR_EL2, res0, res1);
> -       get_reg_fixed_bits(kvm, HDFGWTR_EL2, &res0, &res1);
> -       set_sysreg_masks(kvm, HDFGWTR_EL2, res0, res1);
> +       resx = get_reg_fixed_bits(kvm, HDFGRTR_EL2);
> +       set_sysreg_masks(kvm, HDFGRTR_EL2, resx);
> +       resx = get_reg_fixed_bits(kvm, HDFGWTR_EL2);
> +       set_sysreg_masks(kvm, HDFGWTR_EL2, resx);
>
>         /* HFGITR_EL2 */
> -       get_reg_fixed_bits(kvm, HFGITR_EL2, &res0, &res1);
> -       set_sysreg_masks(kvm, HFGITR_EL2, res0, res1);
> +       resx = get_reg_fixed_bits(kvm, HFGITR_EL2);
> +       set_sysreg_masks(kvm, HFGITR_EL2, resx);
>
>         /* HAFGRTR_EL2 - not a lot to see here */
> -       get_reg_fixed_bits(kvm, HAFGRTR_EL2, &res0, &res1);
> -       set_sysreg_masks(kvm, HAFGRTR_EL2, res0, res1);
> +       resx = get_reg_fixed_bits(kvm, HAFGRTR_EL2);
> +       set_sysreg_masks(kvm, HAFGRTR_EL2, resx);
>
>         /* HFG[RW]TR2_EL2 */
> -       get_reg_fixed_bits(kvm, HFGRTR2_EL2, &res0, &res1);
> -       set_sysreg_masks(kvm, HFGRTR2_EL2, res0, res1);
> -       get_reg_fixed_bits(kvm, HFGWTR2_EL2, &res0, &res1);
> -       set_sysreg_masks(kvm, HFGWTR2_EL2, res0, res1);
> +       resx = get_reg_fixed_bits(kvm, HFGRTR2_EL2);
> +       set_sysreg_masks(kvm, HFGRTR2_EL2, resx);
> +       resx = get_reg_fixed_bits(kvm, HFGWTR2_EL2);
> +       set_sysreg_masks(kvm, HFGWTR2_EL2, resx);
>
>         /* HDFG[RW]TR2_EL2 */
> -       get_reg_fixed_bits(kvm, HDFGRTR2_EL2, &res0, &res1);
> -       set_sysreg_masks(kvm, HDFGRTR2_EL2, res0, res1);
> -       get_reg_fixed_bits(kvm, HDFGWTR2_EL2, &res0, &res1);
> -       set_sysreg_masks(kvm, HDFGWTR2_EL2, res0, res1);
> +       resx = get_reg_fixed_bits(kvm, HDFGRTR2_EL2);
> +       set_sysreg_masks(kvm, HDFGRTR2_EL2, resx);
> +       resx = get_reg_fixed_bits(kvm, HDFGWTR2_EL2);
> +       set_sysreg_masks(kvm, HDFGWTR2_EL2, resx);
>
>         /* HFGITR2_EL2 */
> -       get_reg_fixed_bits(kvm, HFGITR2_EL2, &res0, &res1);
> -       set_sysreg_masks(kvm, HFGITR2_EL2, res0, res1);
> +       resx = get_reg_fixed_bits(kvm, HFGITR2_EL2);
> +       set_sysreg_masks(kvm, HFGITR2_EL2, resx);
>
>         /* TCR2_EL2 */
> -       get_reg_fixed_bits(kvm, TCR2_EL2, &res0, &res1);
> -       set_sysreg_masks(kvm, TCR2_EL2, res0, res1);
> +       resx = get_reg_fixed_bits(kvm, TCR2_EL2);
> +       set_sysreg_masks(kvm, TCR2_EL2, resx);
>
>         /* SCTLR_EL1 */
> -       get_reg_fixed_bits(kvm, SCTLR_EL1, &res0, &res1);
> -       set_sysreg_masks(kvm, SCTLR_EL1, res0, res1);
> +       resx = get_reg_fixed_bits(kvm, SCTLR_EL1);
> +       set_sysreg_masks(kvm, SCTLR_EL1, resx);
>
>         /* SCTLR2_ELx */
> -       get_reg_fixed_bits(kvm, SCTLR2_EL1, &res0, &res1);
> -       set_sysreg_masks(kvm, SCTLR2_EL1, res0, res1);
> -       get_reg_fixed_bits(kvm, SCTLR2_EL2, &res0, &res1);
> -       set_sysreg_masks(kvm, SCTLR2_EL2, res0, res1);
> +       resx = get_reg_fixed_bits(kvm, SCTLR2_EL1);
> +       set_sysreg_masks(kvm, SCTLR2_EL1, resx);
> +       resx = get_reg_fixed_bits(kvm, SCTLR2_EL2);
> +       set_sysreg_masks(kvm, SCTLR2_EL2, resx);
>
>         /* MDCR_EL2 */
> -       get_reg_fixed_bits(kvm, MDCR_EL2, &res0, &res1);
> -       set_sysreg_masks(kvm, MDCR_EL2, res0, res1);
> +       resx = get_reg_fixed_bits(kvm, MDCR_EL2);
> +       set_sysreg_masks(kvm, MDCR_EL2, resx);
>
>         /* CNTHCTL_EL2 */
> -       res0 = GENMASK(63, 20);
> -       res1 = 0;
> +       resx.res0 = GENMASK(63, 20);
> +       resx.res1 = 0;
>         if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, RME, IMP))
> -               res0 |= CNTHCTL_CNTPMASK | CNTHCTL_CNTVMASK;
> +               resx.res0 |= CNTHCTL_CNTPMASK | CNTHCTL_CNTVMASK;
>         if (!kvm_has_feat(kvm, ID_AA64MMFR0_EL1, ECV, CNTPOFF)) {
> -               res0 |= CNTHCTL_ECV;
> +               resx.res0 |= CNTHCTL_ECV;
>                 if (!kvm_has_feat(kvm, ID_AA64MMFR0_EL1, ECV, IMP))
> -                       res0 |= (CNTHCTL_EL1TVT | CNTHCTL_EL1TVCT |
> -                                CNTHCTL_EL1NVPCT | CNTHCTL_EL1NVVCT);
> +                       resx.res0 |= (CNTHCTL_EL1TVT | CNTHCTL_EL1TVCT |
> +                                     CNTHCTL_EL1NVPCT | CNTHCTL_EL1NVVCT);
>         }
>         if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, VH, IMP))
> -               res0 |= GENMASK(11, 8);
> -       set_sysreg_masks(kvm, CNTHCTL_EL2, res0, res1);
> +               resx.res0 |= GENMASK(11, 8);
> +       set_sysreg_masks(kvm, CNTHCTL_EL2, resx);
>
>         /* ICH_HCR_EL2 */
> -       res0 = ICH_HCR_EL2_RES0;
> -       res1 = ICH_HCR_EL2_RES1;
> +       resx.res0 = ICH_HCR_EL2_RES0;
> +       resx.res1 = ICH_HCR_EL2_RES1;
>         if (!(kvm_vgic_global_state.ich_vtr_el2 & ICH_VTR_EL2_TDS))
> -               res0 |= ICH_HCR_EL2_TDIR;
> +               resx.res0 |= ICH_HCR_EL2_TDIR;
>         /* No GICv4 is presented to the guest */
> -       res0 |= ICH_HCR_EL2_DVIM | ICH_HCR_EL2_vSGIEOICount;
> -       set_sysreg_masks(kvm, ICH_HCR_EL2, res0, res1);
> +       resx.res0 |= ICH_HCR_EL2_DVIM | ICH_HCR_EL2_vSGIEOICount;
> +       set_sysreg_masks(kvm, ICH_HCR_EL2, resx);
>
>         /* VNCR_EL2 */
> -       set_sysreg_masks(kvm, VNCR_EL2, VNCR_EL2_RES0, VNCR_EL2_RES1);
> +       resx.res0 = VNCR_EL2_RES0;
> +       resx.res1 = VNCR_EL2_RES1;
> +       set_sysreg_masks(kvm, VNCR_EL2, resx);
>
>  out:
>         for (enum vcpu_sysreg sr = __SANITISED_REG_START__; sr < NR_SYS_REGS; sr++)
> --
> 2.47.3
>

