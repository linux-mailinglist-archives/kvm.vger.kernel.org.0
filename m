Return-Path: <kvm+bounces-69591-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CC4LFLCje2kVHgIAu9opvQ
	(envelope-from <kvm+bounces-69591-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 19:15:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A6DC5B372A
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 19:15:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B417130514B0
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 18:14:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43F5A357737;
	Thu, 29 Jan 2026 18:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t3G8ET0O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0C93570AE
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 18:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769710439; cv=pass; b=GRk8dI/z1Scs3i+dr2QVCcyNdjmEP0Yp0DskB30yYAi+nBTd/oZ8/tbS9ZBU7S8oB5w3ethTx+USNgsp+JwiXtlkmtFbe/uYNVRn8+L4hnDOL7ItIN9Rdj9n4dswy7NmBs9z+fRcMzjcduVMY5tR03IhIIlZeizfM3GyIaKsQBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769710439; c=relaxed/simple;
	bh=yHb3p2o4wgMcF55JscMbe7n4TM3E7DPuyumFVJ/+Qbs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gQABapTu2oD5IgK8cHQ2nK8JJLzgRstaMBI/auUu6ymRXDkzAvNfNltqXJDl//RET8JYBt21kS/tTSXc/wGX99brxp/eh0/W6QWezs4q4XY7+7NO7kWpq0YXfqjPYOlJ/owjwgxsdaNvgoaL/WfpqeXAfVpGH3Xtquptkt9vlAg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t3G8ET0O; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5033b64256dso2521cf.0
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 10:13:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769710436; cv=none;
        d=google.com; s=arc-20240605;
        b=Q2MtjC/AlWEcojzXzW+go3aetdq1g+cIk5F8/Ym8ab1IJ1LRGXR2Sd8ZAPcGCObh9y
         LpxxwiWANNbUT/5uMhA4WIIXgsZ1E6sp1aJsznc3v1IJtKEZiJ5kI/NqSGTwtOZxhteL
         1UIrkLWO3LXmnxbBYMrbBG5sEX9yrMJh/MyoFDrwg9lP1LSDGjWyHaZ6Xu96Ad7F1qlN
         /lOkPzevLWEB2Drx8vzKIECC3ZNyl72vtdS7VzHB6JBoPfeMXlGvZR9Yjji6KcC1XFlZ
         VndIgvJX575zvwsJBr7MNkOBqeZG4A2ab2ZMGXxvEdu3JL2HnVQoigGEpCkF12xZGMqX
         CmtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=55DBf6vGz6h/IMUX0dUx145BpEo7/T5ZyZBZO9eqOec=;
        fh=/a3qkN/L6EcbORXEm5ysWTdMX2liWD4mxojS6y/2GJI=;
        b=P39rL608UPZO7Fdj7O8qi3whrUz2H4I04sVU3+9PURYs+GqxWBtFrfyDkHM6MzbO0t
         PM7fRGXZy2w90iQ46hJHRe0ttbmSNSL4AwnrdUkyX5K/7NiHdceN+GuG4wbemcd312Jb
         qKSFmJEjRRT2toJqG8AwMgvtf0ZpyiqxT5iPt26Hp5imrg5LRNvnGy/fr1s7i6g+PLQ1
         3v6o0RBK8rLCCz+76Av81AyRR4ko2F7aJUGjJVcPuJZ5DIax7wbb5D9OkmUl7ilhDcEz
         j2XTEtoPYO0q+ENAbs/+89xd1uODzsKzzMrrNgM7/NLYKJDCVbBrvyBwv/LvRF3e92Gj
         f6VA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769710436; x=1770315236; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=55DBf6vGz6h/IMUX0dUx145BpEo7/T5ZyZBZO9eqOec=;
        b=t3G8ET0ON5Wo65j6LJmxevqD3mCZI0kPtMl2/4S8ocqAioWSzle+l1oaJahNw4cqla
         u8GfrsSOCA/t+CGOrSPWKQub2FaPvgK4tHj53K0bF3NDHcUOGxamB13hRh8uQQoGpolB
         PDqBKpKsM+jKfjwc5Yr/HLMYNNVQ+DphXWJOTYrd/qILZKHRYNuV4tvBrbZRRpBZot2P
         EUBDr6DtasGh0i3I0MZ4LkNsdtZmdDyqRgVY4ZUoJoQ040u98iEzAgP4H5VbPzVMOqy2
         4IhaZvK0eKrEoqc7va+86lbRV0KS/nvJHNQ56OZ8eWmI40JEH6pl4zsNIodJodi/maa5
         aVWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769710436; x=1770315236;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=55DBf6vGz6h/IMUX0dUx145BpEo7/T5ZyZBZO9eqOec=;
        b=t0cK6WpJSIjMCfMKgIZLdOd5MSzdF4FMsE5oeXwUIg/eGsq+mvZ7bw1tzpTmkbKlCU
         03QI6FjbaACN5HGG3f9IX/y+rOyXk8uajTnireoeqTARObmsNEf3t8GFt4bgK21RZk7L
         16XuDzOZsrIcYpqXv98/F+Dz10yTDJURXUxTLlailBsrlLrzPb2ylTbRn1/L/Ie3brm5
         6KFLpFPIE5Wppq6GUkbcgPkpA/jHecfZZk0VOVxRcbO9UNCckeincvYze3+PvnhtN/Dg
         lWlwvjneoOsetK/z/JdRXF8erzjtscSp3BNTmiu7nTb8AZEatFOvt8q4yCnTx1bvxE1m
         MJSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhrlNJfG5uc8pQM/HE/hpgaLPQGtszhQ3wSSFyXuvYGqbDAq9HXk6NIvVDe5nuFDeeMCk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHQOTVHg0nDfWGHaAzPEJs2diDAR6wL1e3aZHyGtNtC1JMmHh0
	c2GL+m8/g6SEhqP72TiLtYFiEUQ+w3scxRjTPo7I+Eixfx7WztJmCjKeSmlu/tUN0jJYIQ2yg0X
	JXgzuj2jkwVWVcw6NpgRCnT29LC67RP7Q/l7coxwN
X-Gm-Gg: AZuq6aLddikEY6PBTMqGwbnv16tBfBKJNDjY5bpe0CeZ+K21idW892hQ7i2rzfGpSUw
	hsIOS19cyupv5J9IEbfpBtnbGMAgDbUnA6FIbyXE0G1YGRQh3Y0RCALBhrHyhTtbVtlKaV8TYNm
	Bd5WwwdIi46HIF+yCMkdLsvMpd8e5mcFQ1qSrldZmD9olVkhVm2m4Ac/lRU/t0rgr1e8t7kT5Pm
	h9K8MCeQA18hT7RDs9qqMosfB9itRR9CPQ9NrJKyioXiCOABBB+Fvi3HmclsGL4fSrYv+6r
X-Received: by 2002:a05:622a:34c:b0:4f1:a61a:1e8 with SMTP id
 d75a77b69052e-505d29ee0b0mr171561cf.10.1769710435542; Thu, 29 Jan 2026
 10:13:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-14-maz@kernel.org>
 <CA+EHjTw_4WJgiS7vTUprvJOjdNrnW=sjhazCkU9eQW8BUYuZZw@mail.gmail.com>
 <86a4xwbakk.wl-maz@kernel.org> <868qdgb8ct.wl-maz@kernel.org>
In-Reply-To: <868qdgb8ct.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 29 Jan 2026 18:13:18 +0000
X-Gm-Features: AZwV_QgctsLMiyW-LHXWNuYMwH3G1Jg_V-pn8ePMlloILfrF3aUeUb1VzhoKoQ0
Message-ID: <CA+EHjTwxS_xvQqsOJw7PzZBD5Z-oM14z1VwSTC5dCS+79DEpfQ@mail.gmail.com>
Subject: Re: [PATCH 13/20] KVM: arm64: Move RESx into individual register descriptors
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
	TAGGED_FROM(0.00)[bounces-69591-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: A6DC5B372A
X-Rspamd-Action: no action

>
> Actually, this interacts badly with check_feat_map(), which tries to
> find whether we have fully populated the registers, excluding the RESx
> bits. But since we consider E2H to be a reserved but, we end-up with:
>
> [    0.141317] kvm [1]: Undefined HCR_EL2 behaviour, bits 0000000400000000
>
> With my approach, it was possible to distinguish the architecturally
> RESx bits (defined as RES0 or RES1), as they were the only ones with
> the FORCE_RESx attribute.
>
> I can work around it with
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 364bdd1e5be51..398458f4a6b7b 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -1283,7 +1283,7 @@ static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
>         u64 mask = 0;
>
>         for (int i = 0; i < map_size; i++)
> -               if (!(map[i].flags & FORCE_RESx))
> +               if (!(map[i].flags & FORCE_RESx) || !(map[i].bits & resx))
>                         mask |= map[i].bits;
>
>         if (mask != ~resx)
>
> but it becomes a bit awkward...

If it becomes more complicated than the original, then what's the
point. Up to you whether you want to try to pursue this or not. From
my part:

Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad




>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
>

