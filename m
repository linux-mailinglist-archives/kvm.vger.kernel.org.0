Return-Path: <kvm+bounces-69170-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mIb4Ghq+d2l8kgEAu9opvQ
	(envelope-from <kvm+bounces-69170-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 20:18:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C66BB8C7A7
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 20:18:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D48023045AA6
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 19:17:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 747CF27F75C;
	Mon, 26 Jan 2026 19:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="THzgoWwd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0287926ED3A
	for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 19:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769455023; cv=pass; b=pK39gg6s3GM5PQpD8dVcLapySiycu+Cr0UoifkkdVmivU/v5xma8Y4OzYZEvp6313NT8kkbNTBg5Aq32vu8k+I90dEGU0Thl3EBYuSSPP/of0QBo9kXUOZEJ7hn4cgvfVbQqj9SLQpVENWBRwjyq/nwPE7h88nnZ34aufthOKT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769455023; c=relaxed/simple;
	bh=shASez4WWN24nr1jfpbfUJWlDIHBrF006qMDmGLDxkw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JpHiiQHKDmKKFXKWdxHehxhqehitNVNXeY58kaoX+SAGVKoTvjRetW1Fw65MldWxV5iDu0nr4eWYbD3AIaiQ//mwyHnR9W8qz0hVlMV1no2NbL36kKoFrJukoh9XgTf5yG9xvd5XMl2cvhGyVZemJS9i5fC4kGq5L6EJlgw7Y7k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=THzgoWwd; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5014acad6f2so48501cf.1
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 11:17:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769455021; cv=none;
        d=google.com; s=arc-20240605;
        b=R2u6RQvZovVDimQc9hkZ7CL8sM5uR7KFVLRcGQK41ueUc65Hc5+QpKSm/KnKacwD9f
         hDUpC2mVgUyNCIiJWoF21iDHE+Tyv/0LIcxG1p1mhM+5VZqAbcw8h+2HIJhy4Hm28Ujz
         67Z+Fh3QnHwYLJMm3Yfpop50EhjFPh3ghLS8n+mHNptuSWNPuON9/xGdHBPwDWUbkNsp
         Krma3v3gB+Smq/fh8cKK9DedkHsrStAyKHy5uuYBXAGsfylAxc79bjv0yalmD7xgi1g+
         6lGP2a4LufKiFVbiwoOw6ubvWNiWdADnXQt3l7gv6kiB8d63HW9yB2vi4xxovn8o/qWL
         96lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Q78Gf8ey3PlNHaQFSeNbIKQ639y8O+joeYk6mwpkVco=;
        fh=sQQzq2zvrCBt1MMZNaN77qQyu8TDQWOj/DewDw07hcM=;
        b=JAAoOcWPGkY94LkpErxtuS/8I11ucvBWkgBc+FBK3UCgqrTdDMmGjCJ4xiboT46M/q
         TzrGbU0uWyP3I9+sJLv83xqktIy0Tl1IGfMdpnJ1WqZR1WOZqu8fkNBpdQ3DPvSIUvP3
         VFDpkNWejgIHhrWYZrrci6i49VZbX52LJQzhycGi0jrsZppKNOoh8ekRo2Q/kf5g7Khd
         w5TyVzN3eEWw8JR1Ktwd7FlevFdv9Epwb/+bZjEVWIqqcthsIs7YDFlCfIrDcW9bqOt2
         IdkazubN6tvg0NR/KTS+o79tb2/EHTfJzDNWa9oN7Z514YIxmOfkWhx/dth5gFVpbb1K
         OsdA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769455021; x=1770059821; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q78Gf8ey3PlNHaQFSeNbIKQ639y8O+joeYk6mwpkVco=;
        b=THzgoWwd0rXP4Jejc3C1lfdsx5M+vMG27bvTkmysR6CEVA5PBCcfgjsXKZQJvP2nfc
         uwoTLyaYbdNdU27LjohEYX6O0RLmnm9nB215/YYSakI2+wqPboIDpAfh7AGJDJzjl/M/
         m0WtELOA7gpVdkojX2JTsWLhoIQGN1g9xtxhTiEG0wfTEZBlQBTR+B6WPx4nUP70j3IY
         ZMpyigAnH7dqyM45cnpivGSZqxv+yQkLxOJneiORstkGgJq8skXRQ/2g+iA1LLSJpg4b
         YAPqOUKFfJMI1yVVSbi+AQoKAmZUJkTrRnd2wRSNHAan6IrlL6QcRm/BMr6cWy/6fISv
         tDBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769455021; x=1770059821;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q78Gf8ey3PlNHaQFSeNbIKQ639y8O+joeYk6mwpkVco=;
        b=vON2SirXTC0/MZ2wGLY74hORZ55EhqwzSWSNMXXKBBCvyRe9KKoS3oVOmcv4l5vN9O
         QIsCTohZLVlifrGvRBJWmRVXEJ35tMropPRzaUOsBPPqqJpTrq3Wpbgi1mq1MIdGgaMo
         1KRtt6cYE+TvN3asYsgUbDV1X0xg3fqzRaI2zntauMO1w80f44cpe8NNg4yEhRb9lNsM
         PwQkYVdvCRUK/88daFtnccw+QqvNfB6QqW9Q5Mo5V28vzw65ot2oQrU/xK8kvgOB2w5H
         4lBynC9uizp6yPqLq+lXmFJbn+0YlWmWpghBx9QP591VTvcQWrxsycEmNUlr1HvKYQMx
         zX8g==
X-Forwarded-Encrypted: i=1; AJvYcCXpFbkDvWrJPRabdrXpqdXfYSwZTq9f0NllMTIbWqKP3ix0UOI6CjW214gsoa+Gpljr05g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1yPuYpPXkvwDg4qgxFO/I5SymbaFqIq2EbjzsX8CHf3deJUd9
	qL3epvzDxZEYsgCy3KyTz/0HYM0GB7I9hgwZewqWVCsUqeWI0S/JlPSX3fxQUMcyFm5ve48lAvh
	M51P1SaGWfbQjXcuGkIc9vILD/Z+CEImKXq9O1qoQ
X-Gm-Gg: AZuq6aIbVpMcoiqVOBtxPsVINuDxY3t840B/nWYHjqj0n1Qcb45Y/nKeVy5S/u3/XqK
	BcoGCW9So74b6NcHHea006GtX/USZES4n6Wpu0LggzbFthc1BhVFYS6wDuVoH+Akwj3E89WhCqD
	Z+rlysqHbdsW7doBVSz4kvn93Vqca06YhWIuMYxBCiJm5jIDqjZ5QJfI1tkXWMwtvxo3gGti4KI
	mbKf/bxsQuc2df5go9gEz3gEcq6ea4lpM6ntzdtFTjzio3V4ze/WmkDd3aA57ChDvXXAoad
X-Received: by 2002:a05:622a:1651:b0:4f0:2e33:81aa with SMTP id
 d75a77b69052e-50314395914mr14193861cf.11.1769455020509; Mon, 26 Jan 2026
 11:17:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-6-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-6-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 26 Jan 2026 19:15:00 +0000
X-Gm-Features: AZwV_Qjj96yrEnieCy5TgVtfTcOY3xBDAy9jwhHwQBFe31riTdky8XYLoS7UhzA
Message-ID: <CA+EHjTzmr+479uxdQgnM6Ai5jcx1=L2-ufQPD67fvqsCL1gZ8A@mail.gmail.com>
Subject: Re: [PATCH 05/20] KVM: arm64: Extend unified RESx handling to runtime sanitisation
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
	TAGGED_FROM(0.00)[bounces-69170-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: C66BB8C7A7
X-Rspamd-Action: no action

Hi Marc,

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> Add a new helper to retrieve the RESx values for a given system
> register, and use it for the runtime sanitisation.
>
> This results in slightly better code generation for a fairly hot
> path in the hypervisor.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h | 13 +++++++++++++
>  arch/arm64/kvm/emulate-nested.c   | 10 +---------
>  arch/arm64/kvm/nested.c           | 13 ++++---------
>  3 files changed, 18 insertions(+), 18 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index a7e4cd8ebf56f..9dca94e4361f0 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -635,6 +635,19 @@ struct kvm_sysreg_masks {
>         struct resx mask[NR_SYS_REGS - __SANITISED_REG_START__];
>  };
>
> +#define kvm_get_sysreg_resx(k, sr)                                     \
> +       ({                                                              \
> +               struct kvm_sysreg_masks *__masks;                       \
> +               struct resx __resx = {};                                \
> +                                                                       \
> +               __masks = (k)->arch.sysreg_masks;                       \
> +               if (likely(__masks &&                                   \
> +                          sr >= __SANITISED_REG_START__ &&             \
> +                          sr < NR_SYS_REGS))                           \
> +                       __resx = __masks->mask[sr - __SANITISED_REG_START__]; \
> +               __resx;                                                 \
> +       })
> +

This now covers all registers that need to be sanitized, not just
VNCR-backed ones now.

nit: wouldn't it be better to capture sr in a local variable rather
than reuse it? It is an enum, but it would make checkpatch feel
slightly better :)

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad





>  #define kvm_set_sysreg_resx(k, sr, resx)               \
>         do {                                            \
>                 (k)->arch.sysreg_masks->mask[sr - __SANITISED_REG_START__] = resx; \
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 774cfbf5b43ba..43334cd2db9e5 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2427,15 +2427,7 @@ static enum trap_behaviour compute_trap_behaviour(struct kvm_vcpu *vcpu,
>
>  static u64 kvm_get_sysreg_res0(struct kvm *kvm, enum vcpu_sysreg sr)
>  {
> -       struct kvm_sysreg_masks *masks;
> -
> -       /* Only handle the VNCR-backed regs for now */
> -       if (sr < __VNCR_START__)
> -               return 0;
> -
> -       masks = kvm->arch.sysreg_masks;
> -
> -       return masks->mask[sr - __SANITISED_REG_START__].res0;
> +       return kvm_get_sysreg_resx(kvm, sr).res0;
>  }
>
>  static bool check_fgt_bit(struct kvm_vcpu *vcpu, enum vcpu_sysreg sr,
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index c5a45bc62153e..75a23f1c56d13 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1669,16 +1669,11 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
>  u64 kvm_vcpu_apply_reg_masks(const struct kvm_vcpu *vcpu,
>                              enum vcpu_sysreg sr, u64 v)
>  {
> -       struct kvm_sysreg_masks *masks;
> -
> -       masks = vcpu->kvm->arch.sysreg_masks;
> -
> -       if (masks) {
> -               sr -= __SANITISED_REG_START__;
> +       struct resx resx;
>
> -               v &= ~masks->mask[sr].res0;
> -               v |= masks->mask[sr].res1;
> -       }
> +       resx = kvm_get_sysreg_resx(vcpu->kvm, sr);
> +       v &= ~resx.res0;
> +       v |= resx.res1;
>
>         return v;
>  }
> --
> 2.47.3
>

