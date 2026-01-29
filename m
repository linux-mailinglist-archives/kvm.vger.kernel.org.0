Return-Path: <kvm+bounces-69581-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8AHWMjWbe2nOGAIAu9opvQ
	(envelope-from <kvm+bounces-69581-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 18:39:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 34839B3038
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 18:39:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 857223052637
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 17:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2E99353ED7;
	Thu, 29 Jan 2026 17:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XgDfcssl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63514350D4F
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 17:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769708093; cv=pass; b=FDBYWMCcoc0/cilAdMnC69hTUCeUaGOBYDISe/7QoDlVAci8RQWgxpvcp7g87h07dbCXOWn6ZLTQ/XyumbnRa/9mIU+XwSBrJAbcN06yp9LzGAqDJjNlgaDB79M6weOub3vpTZ7VRoBklu9Wg338pdYZCyXs6olCWCbpWOMlT2A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769708093; c=relaxed/simple;
	bh=UaPo9BsXw41+UwtF89c2dJMBz8qHAJ6NArRn59ehYok=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dyHD+JmLg0QRSEbFNG7ww+q2Tev76wTkju7KFT+XBPaP1ScC0rXyB9425KPQMD0xwxySQq3h7pcjAWkqttRwMBDnAxd/e0OGlKIHbAAA6d5XZ3uGV7njxKI+yn84uS/GLoaK/VvoaCNPlePiihJIYHelqHUSfGXgMMLuEGE9qPA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XgDfcssl; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-50299648ae9so591151cf.1
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 09:34:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769708091; cv=none;
        d=google.com; s=arc-20240605;
        b=ZDUtQrUeqaSVzVAUUPqE/u+8BUX6qjErBvtg42sPsv5bgA3R7ALeH6oO06ZBx/iA8N
         tF2kVEIBf+jW17XoCWCpz2f19JUqnn63PDv8FLYU+2YrxYOHiBFhzRsUVMLDK2sw2zP4
         EdsuBBFvol5lb5fVFt5/zAzlXiRC4R4lj+t4y1cYzsGUXolNAR+fiR2DHtng0xpK3egS
         GcGE8025ndl8KmFMMiNx9TMFs4mlRZZwBI++7CL3NFWxTy8qJhzfF8l1a+PhkIH3dXO0
         cTICEznyIp3uAO8C3ZI5nK7J3xl7rlkMxNV0sB7KY5NMcdn73tcrkP6b2Wh7MrW1wKX4
         ch5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=OCjRmeNlyKGhmHNcoMiPz9wOGxIE7UrMLqkSTeQIzDw=;
        fh=/fEK2aW0mXMU1TL934aC3vyk017M2XDMYs2ug3nKmg8=;
        b=V2bomK1hASu2y+CoqAvTU4ENTABZAyIM/eLxp23vfbz5L9rbFu1UqKUCGg6A0fJ9dF
         KaoN8jPupp/StJCWsHAMQ7TuIEDHDK+F3FK7tPp3P696H7WS5w41d/XY0NZXylygCVa+
         +1kq4e6hncy08EUj6ZyyQ83MmJVk0EJ8nZvdmkCDQNZ3BXVUh/KprZHZLPTEonD3bbJz
         665OlamTXSb9sstpulYlofRLyHJAsKrRNVpTaw45m6vOz5g1h6FRY2EdhlFCmLpbOmih
         UBcA4CmMoNEXmTilDHlHmi4P50aS4GsWyJNmrXHZo30xTgfyJpLuID+Tc7g1Vwt5e6SE
         f+sg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769708091; x=1770312891; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OCjRmeNlyKGhmHNcoMiPz9wOGxIE7UrMLqkSTeQIzDw=;
        b=XgDfcsslWRxI4y/mlEUqaUtdGdWfZ56YmlJLbTlFCKl3XopI0cm9ShSoYfaeKFgYWA
         tZjah32vWAWvXD2m6npQD5oYKCoW/87RqWvenkSvSXdvbjQ0868w0Omc1SAwGWEHRVAl
         7dYSICCiNhHnCN0rtl2ahPvESEA7AAkS2v0cI0NOfpTjbXVKOeKDiQm/58HFfKUUJxUy
         mpvmzWvONntu3ukmG6C6gBCXPnXOfU95Nwyj+JR+hgsz+9n6hmQ+3Y3Id4U53/dZWMCC
         VdozLNZMOL4bqortEgY9JyiMgoeqHRHyZCkR87NnhiBgrBq7umXqmlkr/HLQSzi2jSx8
         r3UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769708091; x=1770312891;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OCjRmeNlyKGhmHNcoMiPz9wOGxIE7UrMLqkSTeQIzDw=;
        b=Mw2zEURjz5UYBsLsZs07LDB7sedvRCM7sC8T/fb60Bg3n8qlXCWy4P+cnX647f1R/E
         3JBgTLW5B74Ho+UazbMK9swcvvv+gxFpSwnJ5KzhGmy0G3n5E11Bpr6mnP/7l2t/Haws
         KM0Kud/K8H27SQIkmCC5oMgHuVtYkwUg1YRflfOt5fdkk+51SN4gQTYzjqA8FaRj7J0C
         KrP/uT/ZmktIKEhV1PpDSFmlUa1A9NIGqH6yD3JfdcSr/9esqEuNCccHgauiR2TfiSvh
         NnwLP/nSpodp2SThb6rEJoZquBsaUJ7s1KW2NrBES/LD2uw/ec8qN4zimsdA/bh9pAXa
         h6CA==
X-Forwarded-Encrypted: i=1; AJvYcCV+Dr8Q5kB3q/vszLEkKNZQyvNxclzeYYjfIisHJ5ZXhQ9Q9GErdRTBJHAbTdbQ3batXrA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTjxtCJraED3sc4ctAPdEHIYjZn0ec9ovHYF32PVWE4gW6sIjQ
	BS/aKXZo9xb2m2MX7chtBeGEZP8Rk18MMi2v1rHttkiJhkkRgFUziZxTi3fZ6+nvamFLNVkIdP8
	KhbrJZW7DNdws1GjYBdywz6uQQZ6zwVgf9rC0v5qI
X-Gm-Gg: AZuq6aJLP/FkPx7hUNMT8XVbL6luMuhXQqG97eZ1f/uTsoWVnQwL2w5Xr1KnNmhja1+
	kNkeycgM5yo7/N3Jiy3yHBnmIIKdheHAfw/8vGb6oCoxPVHKqIsj8AkZfYam6l4Hga9Jt+ZiGzS
	EbAmCkKyQXfW8XBQtVTX9NQ6QPPIHdo+6gN1ztvz+TDd44k4W4WF7Bl9Sltvs/ra17YbPghzA8h
	rdWIIRodE+X5+ZSPskna9gCo6VAKOx5c1Fyo3YPk4OQTE9a7tGzAYl5zlSIb5+GLCX8Pqzu
X-Received: by 2002:ac8:5dc7:0:b0:4ed:ff77:1a85 with SMTP id
 d75a77b69052e-504310c6a76mr11415131cf.17.1769708090725; Thu, 29 Jan 2026
 09:34:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-17-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-17-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 29 Jan 2026 17:34:13 +0000
X-Gm-Features: AZwV_QiTE6QZNIoj8DOQzS5LJpafanXH_brsaCuAk8_cVjfPbm_tEiXo0cJUCrM
Message-ID: <CA+EHjTxS-TVNzFdENTa3F3V1Z5+grxx7x5MO1YJGrZJEY+kUaQ@mail.gmail.com>
Subject: Re: [PATCH 16/20] KVM: arm64: Simplify handling of full register
 invalid constraint
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
	TAGGED_FROM(0.00)[bounces-69581-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 34839B3038
X-Rspamd-Action: no action

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> Now that we embed the RESx bits in the register description, it becomes
> easier to deal with registers that are simply not valid, as their
> existence is not satisfied by the configuration (SCTLR2_ELx without
> FEAT_SCTLR2, for example). Such registers essentially become RES0 for
> any bit that wasn't already advertised as RESx.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  arch/arm64/kvm/config.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 28e534f2850ea..0c037742215ac 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -1332,7 +1332,7 @@ struct resx compute_reg_resx_bits(struct kvm *kvm,
>                                  const struct reg_feat_map_desc *r,
>                                  unsigned long require, unsigned long exclude)
>  {
> -       struct resx resx, tmp;
> +       struct resx resx;
>
>         resx = compute_resx_bits(kvm, r->bit_feat_map, r->bit_feat_map_sz,
>                                  require, exclude);
> @@ -1342,11 +1342,14 @@ struct resx compute_reg_resx_bits(struct kvm *kvm,
>                 resx.res1 |= r->feat_map.masks->res1;
>         }
>
> -       tmp = compute_resx_bits(kvm, &r->feat_map, 1, require, exclude);
> -
> -       resx.res0 |= tmp.res0;
> -       resx.res0 |= ~reg_feat_map_bits(&r->feat_map);
> -       resx.res1 |= tmp.res1;
> +       /*
> +        * If the register itself was not valid, all the non-RESx bits are
> +        * now considered RES0 (this matches the behaviour of registers such
> +        * as SCTLR2 and TCR2). Weed out any potential (though unlikely)
> +        * overlap with RES1 bits coming from the previous computation.
> +        */
> +       resx.res0 |= compute_resx_bits(kvm, &r->feat_map, 1, require, exclude).res0;
> +       resx.res1 &= ~resx.res0;
>
>         return resx;
>  }
> --
> 2.47.3
>

