Return-Path: <kvm+bounces-69168-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CMetFE20d2nKkQEAu9opvQ
	(envelope-from <kvm+bounces-69168-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 19:37:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 52B8B8C251
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 19:37:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 461DC3028B23
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 18:36:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D18A226D02;
	Mon, 26 Jan 2026 18:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HSoXX6Z1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279EF2417D9
	for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 18:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769452610; cv=pass; b=rfLgCwuyZm6yeQ1oxkjlqEwGKFL/5ffuhYjW04d0425esyX96WW940hAv/oRbMrQrt2rDzx+xZcxtgeWlE+SfThBNEph+JzPn/MspGZ7L9Oc2rOXDK10RgaVi5tGcbCBKB6Np0DN/nDXBjnQclH6McJ7xId3x4z9QJ8QSbSR95o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769452610; c=relaxed/simple;
	bh=vX1fhktiscd2cjtz1zbJNk4NfMz5KeG+nW9kp+MQDZw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PmY/VIDjVbiHivAVfe1U8Xsl+N0cdAgL1bi9A3sCNCbzfDBQKole6QG2yXPbQYbkmdi8AA6EL0DXxl1y6TQFGQmNXlLeEcaPPjSvFszm3ubPscMJMoFDp5jij3tUftL7I24mp7MjE1mDEeP4GzhNOYBO10UnVU829Y5h0B6zmYM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HSoXX6Z1; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5014b5d8551so42701cf.0
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 10:36:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769452608; cv=none;
        d=google.com; s=arc-20240605;
        b=CDWTBWgJGBNjLieN5SnbFQIr9CDKWMptQ8StTGiPUx0f9TxN2BL2guIWLVlw5AtZ0Q
         1/Byt2AztGtc66cMKu/y9cyyx+nUOKGDvi6AqP8UQ1E4JH11GOaYvQai0KDLoBL2w8To
         kIO8vT+nLeeJ5xUfVN+/1HBgcBX8AR9fKWAeM0lnVlRuvGFfcBVEeEMvQVaGnYh9/uiR
         ro5jzhwzlI20q/asUyC2Nked3tJFpmnsXjs4NOmK/lqQlLTrjHxCg7cmpD6Acczw5Tei
         sJe3AIq0WLUFvfCdzCzmZmjO2nXGDe2MdRudhuVi3s9x6G8U0qdy+uEkkPwK38/1yX6s
         nEkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Nr6ZY9QUfU1ONCnN3zu+tZf3955xHGY/dQF3/cqaDvg=;
        fh=dE3MeFF6cn5sF65ufX5ctAiXmQW6vUBjEH+BbWsypwg=;
        b=hQmm/fEbNOJRMiriACx/eVhRi8JwozPmh4czdbuMyyJoob3Fe7MCoSG3kWpAhE9wnu
         rIRPxHNC8x92mTnbikDNxmZ5fhImlbtfduCG6pqma5dY4pMqlOg9EEI+Q2XfluUzAcg5
         ruu9FBCA5OP4lmBF50ciY9CfP7+2KSmMYsrUroprNGd+M/sYjT8SsSdlQF0L3W5QrRGm
         odbQzTyGhhSG/tKqJjLsYk31vMZ6ZigQL02iBxxb6MkUhoDxQ2/fzhiBMMKOA3zi0uVy
         mYwxqFEhPHAf/pXb03yxOWqhukpm2V+++8O7XEqu5rrvL43YFbc8oaJ8Gm/pJHBHIChJ
         +t8w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769452608; x=1770057408; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Nr6ZY9QUfU1ONCnN3zu+tZf3955xHGY/dQF3/cqaDvg=;
        b=HSoXX6Z1E3zlT+Zpl1VsKFt1O459kdGw8MHguBRT0VKhPgokR4fAGP+9Nn0Rh0xbbc
         UlyjqSYYvF2kvvMS+/g4wDJ7BRa0uTLUh6FiqOMo0919R4C5pOxZVlC1s8gg6HSWNnft
         1sCKdpJqOtHejFSWoO52E4JVjoRaHe7StaUWGyfLGO4yKPUHcvLVCEBjnemXunVQ9Hkz
         vRi7/k7U2MP98Nrr4UglixJQjvFUJhoSfhRySlN7OGM4EYHZPpFqkZDWVyHSCaUPn96h
         SX31PTWpb8uENQ2bJmEGE7B4Z34vfrJFKQZaFrc5s0zPnRRInxDIwOJ6PmCrNpwNlzxr
         cAvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769452608; x=1770057408;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nr6ZY9QUfU1ONCnN3zu+tZf3955xHGY/dQF3/cqaDvg=;
        b=mnrXmtRsoqnUGr7+mowZYpUa9hf3asXYRfjG9Zht8igA/RJnZ+tfL0oqvOu0cCDgN/
         4n0BO8ofO2hXz4Fxv+eCPGr11iUb4xFR6XB2V6aUM3Ur6tLdaxvCZQU5qV3dr9WgoHpR
         SwqnK8wZ9f9i49+VCAmvjeChDQSkjRRCr78PVNn3HaheDvyMpiCpmErzdW3feuRPcvYv
         AXMVu4nwCh64k0m4Lcz4LUSRPjZXzPjYMaUefenM1BeBh0+AxMmqt+TvSVV9V5pdRjDc
         T82CCn7ob2UQDzW7QWPXvb7PiFYf4PurBRlHjT77z0aHY7XcjjbVPV6l5+/UkBbjKeSY
         8Hdw==
X-Forwarded-Encrypted: i=1; AJvYcCWWTJPjDqExg7oosbuqktt4jzZBK1GCSDs/FuM/4z2lS80dHOJNo5QD8StH6I7JMjznzlc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6vrAVegU3L2WyRYkaKvz00FONPKnv0cfZ0e1JKfX7NGHN42X5
	XXbAQClVpS32vLwY268ca4m7w39GWDyrw/aYxgKntyxWkxZ1JNlk0a23e9JDABbPvY6J/orLsTi
	yVh9eeOcMAoLsE55y1q7Bp9Lvp9KttCIIEf7G1OGC
X-Gm-Gg: AZuq6aJihhjSjdlTAHumJ/GCdRzI0yCl4DTkOHgyPqup1bRJ/v8MZsQiB87bzupTOFT
	dijrMVUrkgphKufSvFrafDx4PSw+tYk5ml3bHHVbuMYhTfw5vv1qPba0oMsVIDBoh1oFShd3zsY
	dQuev6tO+psB8tKXcWHYayIuXH7k8e0lOtCAfvK3A+yyZy7BB1rhiqDif7YvxkRSRHoS1kwIy4N
	eUVKeKu5FzPCG8Qrv0T0kimuRGPfTbzrw4eKUBG5d3JTVwIBBTYIBl2eDwJN5yslUmVf02i
X-Received: by 2002:a05:622a:14c7:b0:4f3:5474:3cb9 with SMTP id
 d75a77b69052e-503143735c5mr1861661cf.14.1769452607562; Mon, 26 Jan 2026
 10:36:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-4-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-4-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 26 Jan 2026 18:35:00 +0000
X-Gm-Features: AZwV_QgxoPZSd-obyO74bD1D2orgbXY4GVKiKLrcaTbXWiYTi356mxofCsFsPUg
Message-ID: <CA+EHjTx3C60LaoMtCRH5eYNBmNGPEX+0XHtPgTk7OWjc8MTByQ@mail.gmail.com>
Subject: Re: [PATCH 03/20] KVM: arm64: Introduce standalone FGU computing primitive
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
	TAGGED_FROM(0.00)[bounces-69168-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 52B8B8C251
X-Rspamd-Action: no action

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> Computing the FGU bits is made oddly complicated, as we use the RES0
> helper instead of using a specific abstraction.
>
> Introduce such an abstraction, which is going to make things significantly
> simpler in the future.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

The old way was mixing "bits that don't exist" with "bits we need to
trap". Here the distinction is clear.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad





> ---
>  arch/arm64/kvm/config.c | 57 ++++++++++++++++++-----------------------
>  1 file changed, 25 insertions(+), 32 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 0bcdb39885734..2122599f7cbbd 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -1335,26 +1335,30 @@ static u64 compute_res0_bits(struct kvm *kvm,
>  static u64 compute_reg_res0_bits(struct kvm *kvm,
>                                  const struct reg_feat_map_desc *r,
>                                  unsigned long require, unsigned long exclude)
> -
>  {
>         u64 res0;
>
>         res0 = compute_res0_bits(kvm, r->bit_feat_map, r->bit_feat_map_sz,
>                                  require, exclude);
>
> -       /*
> -        * If computing FGUs, don't take RES0 or register existence
> -        * into account -- we're not computing bits for the register
> -        * itself.
> -        */
> -       if (!(exclude & NEVER_FGU)) {
> -               res0 |= compute_res0_bits(kvm, &r->feat_map, 1, require, exclude);
> -               res0 |= ~reg_feat_map_bits(&r->feat_map);
> -       }
> +       res0 |= compute_res0_bits(kvm, &r->feat_map, 1, require, exclude);
> +       res0 |= ~reg_feat_map_bits(&r->feat_map);
>
>         return res0;
>  }
>
> +static u64 compute_fgu_bits(struct kvm *kvm, const struct reg_feat_map_desc *r)
> +{
> +       /*
> +        * If computing FGUs, we collect the unsupported feature bits as
> +        * RES0 bits, but don't take the actual RES0 bits or register
> +        * existence into account -- we're not computing bits for the
> +        * register itself.
> +        */
> +       return compute_res0_bits(kvm, r->bit_feat_map, r->bit_feat_map_sz,
> +                                0, NEVER_FGU);
> +}
> +
>  static u64 compute_reg_fixed_bits(struct kvm *kvm,
>                                   const struct reg_feat_map_desc *r,
>                                   u64 *fixed_bits, unsigned long require,
> @@ -1370,40 +1374,29 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt)
>
>         switch (fgt) {
>         case HFGRTR_GROUP:
> -               val |= compute_reg_res0_bits(kvm, &hfgrtr_desc,
> -                                            0, NEVER_FGU);
> -               val |= compute_reg_res0_bits(kvm, &hfgwtr_desc,
> -                                            0, NEVER_FGU);
> +               val |= compute_fgu_bits(kvm, &hfgrtr_desc);
> +               val |= compute_fgu_bits(kvm, &hfgwtr_desc);
>                 break;
>         case HFGITR_GROUP:
> -               val |= compute_reg_res0_bits(kvm, &hfgitr_desc,
> -                                            0, NEVER_FGU);
> +               val |= compute_fgu_bits(kvm, &hfgitr_desc);
>                 break;
>         case HDFGRTR_GROUP:
> -               val |= compute_reg_res0_bits(kvm, &hdfgrtr_desc,
> -                                            0, NEVER_FGU);
> -               val |= compute_reg_res0_bits(kvm, &hdfgwtr_desc,
> -                                            0, NEVER_FGU);
> +               val |= compute_fgu_bits(kvm, &hdfgrtr_desc);
> +               val |= compute_fgu_bits(kvm, &hdfgwtr_desc);
>                 break;
>         case HAFGRTR_GROUP:
> -               val |= compute_reg_res0_bits(kvm, &hafgrtr_desc,
> -                                            0, NEVER_FGU);
> +               val |= compute_fgu_bits(kvm, &hafgrtr_desc);
>                 break;
>         case HFGRTR2_GROUP:
> -               val |= compute_reg_res0_bits(kvm, &hfgrtr2_desc,
> -                                            0, NEVER_FGU);
> -               val |= compute_reg_res0_bits(kvm, &hfgwtr2_desc,
> -                                            0, NEVER_FGU);
> +               val |= compute_fgu_bits(kvm, &hfgrtr2_desc);
> +               val |= compute_fgu_bits(kvm, &hfgwtr2_desc);
>                 break;
>         case HFGITR2_GROUP:
> -               val |= compute_reg_res0_bits(kvm, &hfgitr2_desc,
> -                                            0, NEVER_FGU);
> +               val |= compute_fgu_bits(kvm, &hfgitr2_desc);
>                 break;
>         case HDFGRTR2_GROUP:
> -               val |= compute_reg_res0_bits(kvm, &hdfgrtr2_desc,
> -                                            0, NEVER_FGU);
> -               val |= compute_reg_res0_bits(kvm, &hdfgwtr2_desc,
> -                                            0, NEVER_FGU);
> +               val |= compute_fgu_bits(kvm, &hdfgrtr2_desc);
> +               val |= compute_fgu_bits(kvm, &hdfgwtr2_desc);
>                 break;
>         default:
>                 BUG();
> --
> 2.47.3
>

