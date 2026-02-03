Return-Path: <kvm+bounces-69983-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CJd4M7vCgWmgJgMAu9opvQ
	(envelope-from <kvm+bounces-69983-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 10:41:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FE80D6F31
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 10:41:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 01FAC302D9C3
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 09:40:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88CA018C33;
	Tue,  3 Feb 2026 09:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h4EPK9H8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447E8310774
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 09:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770111628; cv=pass; b=CYOvFCx3xXAt5RZOf9S81uaDuH0+9bpBRlmjznIJXwJP363X+cGl4rIekM4MFY+0chENYeQ4CXNNgGiGmHagG/zIEmhXzjIhe73+XAJs/XVRwDNaxwMcJwzPW7Uu3++590N0mtWJvy+NLwsvqVJzOnrfhuWCyU6TT/YHAEX6VeY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770111628; c=relaxed/simple;
	bh=F7oytjxQ/ZM2+D72Ivu9+6l4pfn1cS7+cfPa4Xr1Y/E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DNtzxBuvT7xjNuXT4su3ecvYOtWWppOddQ5VTkeLA00qv51pTstISw7EvV3r8/Muaon4f0p3zMQOhUQolCF1CxrY0uxb5UqZyGr88DJE8ETrewxsqCH7E5Ns5nHbF4nBg6HsC48Z9w7ESsWPNU2WzI0Vz/O8cCkojr1Z7hckNvc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h4EPK9H8; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-505d3baf1a7so346121cf.1
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 01:40:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770111626; cv=none;
        d=google.com; s=arc-20240605;
        b=LBlvM3Z5WoYienhwAWFGtboPOp4y70sUmpvlZGHSr8QJc2/GAWmzkU65ABFmt2eGne
         LvP0tvvRJtuyv7a6I/eHMapjX4Fki8qURGgrkySuMH5nat9YM1jqdRRDX0rdwUDfzHKH
         kiUKWqc6ZEDcTbtHB8ZwIvBfxemXIEAB8qHqDizCetco02iWg7N/IK3ANIKugrg3Aiq4
         GKG1l1R68u5K/oBwyjoEslzGABOz/x1uzAzOyP79CeBxw4gNv9RnfPsi2FXmpv6AuK5W
         oTc/GpRKCSRAoPN37Q2Fyatskoi096SB8n0akAX/btAlllv0GtKy0Bh6f50zJy+gzLpp
         Nf8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=/iLRVFcvI8PBqaXa13EXF14ab440i5Z61zkbAzzGqTg=;
        fh=Ybupwz3tHhSmSe9uJbaEgKAwogClMKikCYXcMqplQFo=;
        b=YEf5jGyl6Nee6IMQjV3wFSCtSeXxnXVdPfC0Mfm1PL/9Jg1i2WHgEZyEVXAtRTyPnN
         GYQPbOQ7T4V002OmC1U3p4lht7gSJp9gjGSWSjbwgS9A+3uJFM2h/n0hQ/EXAn4AzkiP
         mAuaSwN6xNKEqGXYR9YW1YFniWN6Nhg/djgFe03mfgZggJ3QiS8wPmcFa/xInrlrol0U
         4VCBZ2QInMyylLvpD/iBfqPquLBNTcdHWXbVZD+AW5XsML/bEXBmokF6uR6jKpkKCjRz
         vmusVZpMhTj/L9ML7y2V1rind096JcWBlaVreA07Cv599Y5Ow67vCiOCSqIG18PIuxWW
         nECg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770111626; x=1770716426; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/iLRVFcvI8PBqaXa13EXF14ab440i5Z61zkbAzzGqTg=;
        b=h4EPK9H8UId8l1oNIt+WjRHB4FGx9sreOihNaXIy+3OnlYVpm9m5BfS5KsrpbmutX5
         onGEC9WSoYNejBi03Q56ev7YnoyzlCmD8cObC8REOrILzZziB56/5qfXXxkZ32GV9cju
         i6vvzbVYY/s+LJbzcXYby/iMc01bNFWRe7iJwkaj6lh0Nk/DIVSchD2UQ0NiYgf6oG0/
         Jpv77rgyqmJ4lEZ7+Y6IW0TLzcAoHYAsBB18qBGAoNnxjCL1ctf7nEtw5s5uJaE7/THx
         H8A5W5Clv1k8ZuGeq9g9jb2NJw64cCXZlswrIUv7UhdFDCSQ7SVaNRHv3Aop8EitsXNS
         zTBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770111626; x=1770716426;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/iLRVFcvI8PBqaXa13EXF14ab440i5Z61zkbAzzGqTg=;
        b=F1CnFeU22heTX9joGSRr41Dejddsw7Ye5lI25nKg9BEhRG4siVh24VEtr4P5kRBeVA
         AwFZY+saK/RTr7XkmVLuLt0thVod40uM458Bb7SBxNUdRXL1dJvQNm6OtfUd0nHo7jVZ
         x2rhL+9l2ipKQkME8dAs83Zv5zIT/PGlwbcz6LkNTA4l+PC9nVkN4PomZtbDqrNEyKXj
         RZ56TZXfHWePOT77+Uh0Zo90fZobA2YVjMNIOCqinXnKUU/oXyuUn2RIBtFpXAtPpB53
         ZKq+ruz5Nh9QxcQzlrS6YWyh8VesCoACvhtjx6gxQja23PSlME3zgxYo66UXlCYhJPKQ
         BHvw==
X-Forwarded-Encrypted: i=1; AJvYcCWzu1oN3iy71Wp/cgM9ZfgXoVTaKrk15FMkF4dvORyzwBosgm42zltGr/VKGmlESRcvf/o=@vger.kernel.org
X-Gm-Message-State: AOJu0YycB/XG/E2kzaC1EnjvMUfduNoWM1dItodbPL+kFQnGCJEFFXsR
	p+yPCCa+vZe21XIxAcIUbn/z3utADfyFN03nIif78NM9CjsHy2HOZ9Sv4wIkVJb6jj2gGvRfrKS
	g4w7G+28y/Rck/fPTLIdm4fjRGTq1nM12rgyNKRY6
X-Gm-Gg: AZuq6aLp/aVZ2o0oyFN7bQXORCHoERUlWc3k7A2AzigPViY9X3shfngRK6+BEutA1AO
	vS0Vfq58TmE3sCZ8VK02tkDdMJZqVwhOJwo4LKfpDG9/vmtn+xSGcEUH7udO1i5398TDK5vreTv
	bxRU8rgyrUltb87YY+AJJfg1pPgry8W7RS9p1eNYkQAPGb3A3f6a0foQKhe9h8vCZ17mNTBQKZ/
	XBqRUPeJOtx7kpluolkGdaMWubcsifXSGTX0LbRa24UkV2Dw5V89004K43R3ILu0JuYISmW8wb5
	fNd5pbPo25QNRRspwP4S8Dixp5nhzV4yS+x6
X-Received: by 2002:a05:622a:e:b0:501:4539:c81 with SMTP id
 d75a77b69052e-5060f009ad3mr4642661cf.2.1770111625864; Tue, 03 Feb 2026
 01:40:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260202184329.2724080-1-maz@kernel.org> <20260202184329.2724080-13-maz@kernel.org>
In-Reply-To: <20260202184329.2724080-13-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 3 Feb 2026 09:39:49 +0000
X-Gm-Features: AZwV_QgvgYBl296K0duqDRaBXXRaqyX8U8f5zkdPWeOZQX-Dkj3fpYJk1QlQ7I8
Message-ID: <CA+EHjTwvXhzMP7WYQycs5CdPD1u-Ycj32-L1kC2Qvw4nmyempg@mail.gmail.com>
Subject: Re: [PATCH v2 12/20] KVM: arm64: Add RES1_WHEN_E2Hx constraints as
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69983-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 6FE80D6F31
X-Rspamd-Action: no action

Hi Marc,

On Mon, 2 Feb 2026 at 18:43, Marc Zyngier <maz@kernel.org> wrote:
>
> "Thanks" to VHE, SCTLR_EL2 radically changes shape depending on the
> value of HCR_EL2.E2H, as a lot of the bits that didn't have much
> meaning with E2H=0 start impacting EL0 with E2H=1.
>
> This has a direct impact on the RESx behaviour of these bits, and
> we need a way to express them.
>
> For this purpose, introduce two new constaints that, when the

nit: constants

> controlling feature is not present, force the field to RES1 depending
> on the value of E2H. Note that RES0 is still implicit,

nit: , -> .
>
> This allows diverging RESx values depending on the value of E2H,
> something that is required by a bunch of SCTLR_EL2 bits.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  arch/arm64/kvm/config.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 7d133954ae01b..7e8e42c1cee4a 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -26,6 +26,8 @@ struct reg_bits_to_feat_map {
>  #define        MASKS_POINTER   BIT(3)  /* Pointer to fgt_masks struct instead of bits */
>  #define        AS_RES1         BIT(4)  /* RES1 when not supported */
>  #define        REQUIRES_E2H1   BIT(5)  /* Add HCR_EL2.E2H RES1 as a pre-condition */
> +#define        RES1_WHEN_E2H0  BIT(6)  /* RES1 when E2H=0 and not supported */
> +#define        RES1_WHEN_E2H1  BIT(7)  /* RES1 when E2H=1 and not supported */
>
>         unsigned long   flags;
>
> @@ -1297,10 +1299,14 @@ static struct resx compute_resx_bits(struct kvm *kvm,
>                         match &= !e2h0;
>
>                 if (!match) {
> -                       if (map[i].flags & AS_RES1)
> -                               resx.res1 |= reg_feat_map_bits(&map[i]);
> +                       u64 bits = reg_feat_map_bits(&map[i]);
> +
> +                       if ((map[i].flags & AS_RES1)                    ||
> +                           (e2h0 && (map[i].flags & RES1_WHEN_E2H0))   ||
> +                           (!e2h0 && (map[i].flags & RES1_WHEN_E2H1)))
> +                               resx.res1 |= bits;
>                         else
> -                               resx.res0 |= reg_feat_map_bits(&map[i]);
> +                               resx.res0 |= bits;
>                 }
>         }
>
> --
> 2.47.3
>

