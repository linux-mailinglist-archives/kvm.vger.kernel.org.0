Return-Path: <kvm+bounces-69265-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YAzKIyMEeWk3ugEAu9opvQ
	(envelope-from <kvm+bounces-69265-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 19:29:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 23CE4990CF
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 19:29:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 49B13304702C
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 18:29:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E8CC326D44;
	Tue, 27 Jan 2026 18:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pGloS9+F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B9832695C
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 18:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769538553; cv=pass; b=LNz2J8+zFHxMZ9ydLnPkeeYY/ngOso4kAgM8SmtDLeTqks5cP+lyyZzAfjLiKfF5k1Pq1B2ckQo61dodWUlBo1x4tOsK3jogKM/NnEYlSV0f8NcsmVCFp4GrzTfGrjh5npGc92nJtWN/bg5h+lkt4u9MUkhuprAmg89r0CICrAg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769538553; c=relaxed/simple;
	bh=aWhPoXoCSpppHcH+Z9T+BsTa5z+q/lP1MwTGPt8CmR8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N6RxU4/SDldV6Hf4oBSnopTyAE1VUBDcyx6x4o2INhbDvOvvGavYVaYhTN0/UvMT9TDAIAdug3bbaw3zy85ekDZCXBD9sM9x74ppcvmKvQiMyQUBgKq/nhB2yHclsvpq9/ZlQI7aJN4JLBqro7utR2FIfS91sc//m1tKtDyue2k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pGloS9+F; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-501511aa012so38381cf.0
        for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 10:29:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769538550; cv=none;
        d=google.com; s=arc-20240605;
        b=BGWGMLw01TxfKVMnHXrlrY2stmL2hmWy2UcHNLnYwZd+6Bm7fXCaR/OJR1Hyt+k9Fi
         u993OBYMXBs17spkV5/WdNatbSEsH+Cx0IQ/Zz0pwZUVgHu+pJqXu3Dxhi97zZIBSWde
         jRVuADLFTzTyv59owrfj0HfTIiI8A4cvUahn/GRn7mSau01lVxqDsEHYp46qx7Fsz3SN
         44L305yXCPeIhgDXd4/lpTxzyxXreOnxZkd/IMo6DB481KdVP3dKniE7KKH0oji+Wc0V
         pkkhqwlK7BGDzlsci7OcFlKOh8a/UdVUnnXiWGbpjZsaUG6nmAFEQD+HA4szygVRFShF
         aJVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=wmqFys/juW1EZAgdfKq6MTjLgOXwmpAGq13j/IO6Ug8=;
        fh=VSNYEmZoP1OwGw3XaSaKm0ktT/tbjWfsxNi4wYwtlyw=;
        b=OINe2Wt5CLBIOSTASEDrQJVesyZwqnxSomIxNa/EVUXHJvW28UwZtbcQpn3Knf0+lM
         I6VxvyO68I1tI1HWfKoitLMysSXmWDr/NqB8AWwC9ztmBhQHOWomj7MuOWU3XUNwjMko
         OiJsx7ti4/a0pV0WFWYm0zndVAgw1eOIGfdRZa9SzBMhi5TEut4ObspWPdokkyc4aH9b
         /kyXtPwoFFOB290V/AVm0/lkoDlOUZHvJ+OUsApW38gBqusCdrIAdoSOf6Vm9poJXMIy
         49ffqXNFN58gm+dXMAzzAjK98vrNzvYhf+9d3Bv1Tyt1m2djEVu1erVkuKwWqHsGUfjr
         +phQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769538550; x=1770143350; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wmqFys/juW1EZAgdfKq6MTjLgOXwmpAGq13j/IO6Ug8=;
        b=pGloS9+FsLL8/vN+hyJeR7yW3/HYzdVk4usxK6oR/NlvZ4iQpKSgju2R2IRVzdUCmy
         PF7DLPtpVgRSgn60wvjm79ullwuSkjs+vvLWHf3z6JN7fajo4iGVY3X3gguS16NbRPfc
         2wzgn6RXZfsJPjVoVRaXzBJPfOtHBt64DkjX3EqGNLKfSgNPI0J8XBTQzqr8I6lMheFo
         T7Ss7bsDpExGmyiB+3WI8miLTmIYD6MxMKQWcRXmrXM509a25+ZIwdyKwu/AAenIfQ1a
         uXdN0kwApJlvjKPmXeSjaXwY/k7/kzrADBG4MUGzLkJMXxxjjRw8nIJI/LbDdenZwaWI
         Vk3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769538550; x=1770143350;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wmqFys/juW1EZAgdfKq6MTjLgOXwmpAGq13j/IO6Ug8=;
        b=Uc+eqKgxnwi5guTTvCTjDzQJcOIgqQrJEZEh6d8ZygmsfBQrvIJFHPcamVlRQJ9Seh
         cRD6CEcBZUp5Rkh76OKGB1rjQtKmTUhKPm4OCFt65KRifQ3QV28bjLqrhkHIpyNAh6Gi
         sEgO5SDx09doyI90xeNfTfW94cgeBO3yisIHkMRJ52jHunnc8tBhFLjh59aTFrhE2WN7
         J73d8ZaJAT37eOkePXC2HzYePNoAingWpSnmy4zSZ00g6OKtP6ZeGoZDH/de/PzZ8XCE
         UbcgFL7xU1LBymODke3giagzQfrHtv0WTPhslT+kZ76gHiaThkRhrG6JYjDWyoNve0GL
         hucg==
X-Forwarded-Encrypted: i=1; AJvYcCWC4gZW+NAdEqItyjDEqC7mexX1IXvBVyGB62BZEQZYTuU+aDnh/o4JmwWcgI1huRsxLqI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHHRgFA/7iKWtYjee2puKouvCm7Fi+kNtf2CcO9kHPJ5MYJAv0
	liKLAmtye2JWSVh6BKEgTWr7E8qKAaxD+4RWPIH2Pvp+jCAlfj/zKXCdLVfWG9nMGrtXBKHhcH/
	D11d/fuFwyTKfWhOnnt4CbBT+TNRIj+lj8onqJXmo
X-Gm-Gg: AZuq6aIKW2aiUyvrWd1mzzobezLVPaVw5e8DqzIwDcNrw2EjUAtZJEzEACbW1VqQYgX
	Y/WKzOhHhMmryPio6E7W5lxkVQKsbClf5q22vwmh+UUBUrCM4N5meeZOPlHwSasfUAeRrFAHbQ9
	S86Ja8tCE8YrpezRmzKat+US8F3cBoSwn56PcaytUmvN6Y+6idrO5yX10QyRJMtVnuyS7H8ZNWp
	Y5kf/tMrMHa35AywrJaM15l5k7Co5NM22O2MT4zdJOITNKqzgJgS2wTGCdEBN5GkdWnCxqs4C1a
	tmuqfAc=
X-Received: by 2002:a05:622a:34e:b0:4ff:bfdd:3f46 with SMTP id
 d75a77b69052e-5032f4e0be6mr10385161cf.15.1769538549723; Tue, 27 Jan 2026
 10:29:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-12-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-12-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 27 Jan 2026 18:28:33 +0000
X-Gm-Features: AZwV_QgXZBRUac8lgCEGhS0B6XOh32RhatNEEL4-duPDQxvYx3j74fO0pxo2Iak
Message-ID: <CA+EHjTyWmb9dEaHqi0Uef3y6vvpGSE0r64AENX98HdkpsSL7Rw@mail.gmail.com>
Subject: Re: [PATCH 11/20] KVM: arm64: Add REQUIRES_E2H1 constraint as
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69265-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 23CE4990CF
X-Rspamd-Action: no action

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> A bunch of EL2 configuration are very similar to their EL1 counterpart,
> with the added constraint that HCR_EL2.E2H being 1.
>
> For us, this means HCR_EL2.E2H being RES1, which is something we can
> statically evaluate.
>
> Add a REQUIRES_E2H1 constraint, which allows us to express conditions
> in a much simpler way (without extra code). Existing occurrences are
> converted, before we add a lot more.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/config.c | 38 ++++++++++++++------------------------
>  1 file changed, 14 insertions(+), 24 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 4fac04d3132c0..1990cebc77c66 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -25,6 +25,7 @@ struct reg_bits_to_feat_map {
>  #define        FIXED_VALUE     BIT(2)  /* RAZ/WI or RAO/WI in KVM */
>  #define        MASKS_POINTER   BIT(3)  /* Pointer to fgt_masks struct instead of bits */
>  #define        AS_RES1         BIT(4)  /* RES1 when not supported */
> +#define        REQUIRES_E2H1   BIT(5)  /* Add HCR_EL2.E2H RES1 as a pre-condition */
>
>         unsigned long   flags;
>
> @@ -311,21 +312,6 @@ static bool feat_trbe_mpam(struct kvm *kvm)
>                 (read_sysreg_s(SYS_TRBIDR_EL1) & TRBIDR_EL1_MPAM));
>  }
>
> -static bool feat_asid2_e2h1(struct kvm *kvm)
> -{
> -       return kvm_has_feat(kvm, FEAT_ASID2) && !kvm_has_feat(kvm, FEAT_E2H0);
> -}
> -
> -static bool feat_d128_e2h1(struct kvm *kvm)
> -{
> -       return kvm_has_feat(kvm, FEAT_D128) && !kvm_has_feat(kvm, FEAT_E2H0);
> -}
> -
> -static bool feat_mec_e2h1(struct kvm *kvm)
> -{
> -       return kvm_has_feat(kvm, FEAT_MEC) && !kvm_has_feat(kvm, FEAT_E2H0);
> -}
> -
>  static bool feat_ebep_pmuv3_ss(struct kvm *kvm)
>  {
>         return kvm_has_feat(kvm, FEAT_EBEP) || kvm_has_feat(kvm, FEAT_PMUv3_SS);
> @@ -1045,15 +1031,15 @@ static const DECLARE_FEAT_MAP(sctlr2_desc, SCTLR2_EL1,
>                               sctlr2_feat_map, FEAT_SCTLR2);
>
>  static const struct reg_bits_to_feat_map tcr2_el2_feat_map[] = {
> -       NEEDS_FEAT(TCR2_EL2_FNG1        |
> -                  TCR2_EL2_FNG0        |
> -                  TCR2_EL2_A2,
> -                  feat_asid2_e2h1),
> -       NEEDS_FEAT(TCR2_EL2_DisCH1      |
> -                  TCR2_EL2_DisCH0      |
> -                  TCR2_EL2_D128,
> -                  feat_d128_e2h1),
> -       NEEDS_FEAT(TCR2_EL2_AMEC1, feat_mec_e2h1),
> +       NEEDS_FEAT_FLAG(TCR2_EL2_FNG1   |
> +                       TCR2_EL2_FNG0   |
> +                       TCR2_EL2_A2,
> +                       REQUIRES_E2H1, FEAT_ASID2),
> +       NEEDS_FEAT_FLAG(TCR2_EL2_DisCH1 |
> +                       TCR2_EL2_DisCH0 |
> +                       TCR2_EL2_D128,
> +                       REQUIRES_E2H1, FEAT_D128),
> +       NEEDS_FEAT_FLAG(TCR2_EL2_AMEC1, REQUIRES_E2H1, FEAT_MEC),
>         NEEDS_FEAT(TCR2_EL2_AMEC0, FEAT_MEC),
>         NEEDS_FEAT(TCR2_EL2_HAFT, FEAT_HAFT),
>         NEEDS_FEAT(TCR2_EL2_PTTWI       |
> @@ -1285,6 +1271,7 @@ struct resx compute_resx_bits(struct kvm *kvm,
>                               unsigned long require,
>                               unsigned long exclude)
>  {
> +       bool e2h0 = kvm_has_feat(kvm, FEAT_E2H0);
>         struct resx resx = {};
>
>         for (int i = 0; i < map_size; i++) {
> @@ -1307,6 +1294,9 @@ struct resx compute_resx_bits(struct kvm *kvm,
>                         match = idreg_feat_match(kvm, &map[i]);
>                 }
>
> +               if (map[i].flags & REQUIRES_E2H1)
> +                       match &= !e2h0;
> +

nit: white space in the newline

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad




>                 if (!match) {
>                         if (map[i].flags & AS_RES1)
>                                 resx.res1 |= reg_feat_map_bits(&map[i]);
> --
> 2.47.3
>

