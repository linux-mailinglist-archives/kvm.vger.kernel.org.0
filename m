Return-Path: <kvm+bounces-69167-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4E1VLACtd2kZkAEAu9opvQ
	(envelope-from <kvm+bounces-69167-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 19:05:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FEAA8BE7F
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 19:05:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 379693036D7C
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 18:05:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5073534D4D2;
	Mon, 26 Jan 2026 18:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O4aXRYxk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5136434A790
	for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 18:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769450729; cv=pass; b=AgYxnXB903+DzNkw1GPeTdSyBYLra3yvkjTe9f41o+blhcgt2zzPwnPUxNgPyjsCtUnArZtE7WjNo/5A7LbZCoDDhLknjCt2GOe0FrlPD5gkUWrtna+FUWDLFDWezlGZ+RPkE+2MMxjhysBIAIRfIQVkRs+kfSLFezL9VoWYgS0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769450729; c=relaxed/simple;
	bh=v+f8FvwBFg7dDGHKP/QYFcL4Q1S4zs4FWdHw639SGDY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hk9DYonK2vUtxSyMUJOFb7zMVa1DVI+FQNYqzx2cDnAvsjEUDgocx5lc6t+YolsFKBc1RqM7ZjmHBT8jd0Uu0JY5hEXn/1zmYApJqUE7c8Z6kLJAeS22zrX/4GzViBccg/M+Hanvus4mxQyZvpE9fM1HVfkOHOFvDNNMcgUXQJA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O4aXRYxk; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5014acad6f2so12041cf.1
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 10:05:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769450727; cv=none;
        d=google.com; s=arc-20240605;
        b=f2o0ZvDU2seogYC1CqnpvrNObuO1q4+S/q7BzT96pMWsYZKwNKUJrE5TlcucdyH5y3
         E9VgO5Qo/K3xMvDGSSf6O2Hr/CAmU1VSAjRHQLJzevtLNEemZ0Xf4FZ8kOUEAChh14xO
         oPYKsVLhZ2hU0j6kkM0gkLG8ObMy8q3pHpjirHpn9KYwPjwggDtJIm70SSMQhVEXZJle
         H/Qxuuh164Xj4Nnljwfy4uafL4Oq1ZXRaYgNXG0Yx47qjChbaJqx8KvKYWYrX05bFpa4
         ckRxlV32LH53k6QsCeexxZqNttjqgx524pyWHV/0MHl5Feh115N8IjJkhxs85Z9WAV9f
         bojQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=k9sW7exYhXYo5b3X/iX8Xd4kSUfKtlhUjch+6299QS8=;
        fh=/EROn/9hs24EkwfXw/to2vHJWqNAZ/tbBZCIG6TgKCI=;
        b=eulN0fGWG4vFYHAz9FBzpiTsxKW48jGKgPub/7KhxnGxusXcjrrCjJv1AwUaIjYp0a
         mgMoLFFR69g+FhiroNeLJPvXmy8jnb5A6TTWT9mYg0MHNctlQ9JAV5Ob1opVGoNGw87e
         9Y9vHn7ITjAYzOXoZBZLkPxL5cJlduaQOnpxIHEnRaOqunZjYKfPX/XxZy87cERNm27M
         N9DCyKlIgrYGNZZaW1FKqm0DsJav6pD+WFqKxTnuRbCq7r4735Ii55XAJPrmocFAijo0
         cT8wHFkZp0yaLuz2iv1WLm0o/aJfvD7wmwZCxGvyC4SoQT1naO6XTxqUAzQhDpOe3X+2
         wZiw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769450727; x=1770055527; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=k9sW7exYhXYo5b3X/iX8Xd4kSUfKtlhUjch+6299QS8=;
        b=O4aXRYxkvuVRcFhDhlBshnPjXMTZeQHqXgVNE9AfzObGgzvCFiWg6OTUT8EZQmnXTe
         eP2vN6v2trg/PwWnfDPmhPHPEmq8AfBKO1zLZIfNNxUJJoV4JobgysolGSuSHaIMumDS
         H4utBBnTVrWIZFUfGP8pRJ5pf/jEizFz7Y20smjRi5ICPpc5CmY7A8vIQt6VfH68k2T1
         Q825M392/4DDm6J+uvGLtu0K5ETItkPCVTf2EeXs5KNybhYM1QLc0LyL/I2dH7nH7GZt
         hgCEgdJBX3ugEYm5BnR6qEY6AhTtlv+Amq6DHyOexnWMF9qsePH4Ov9ImoRXBNdT63OW
         Ni+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769450727; x=1770055527;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k9sW7exYhXYo5b3X/iX8Xd4kSUfKtlhUjch+6299QS8=;
        b=sp/qAllnXfFErDsVGw9QtR3WF3xAFd/7PPAhUUKgjxIOK3VjoPHxjWTJHGAudUF/o9
         nojKbhrI8iqI75OhbIff8PWjZ9cP1MDS/viAUxf/k7exXjj1RDnd3RCKSk1Y9kWSQIGK
         UGkIxaFNna3Q7dexPXvnlcZ9mRMcdezNjguDBQPGv/VsWez42Rj//v0giYt7XGr/1aVH
         P/HwkGKPawLGljkthRf7WqoL/ROVXmCaq9Epb1y1Qj/8g5C+4e7NCjg1yIqo6L9zCzhl
         7abFCMVsyLOaXclChHqMgn1SS3WY8Z8P6bU1Ecqb/hK9uSK9A7zL2PJ5gUkVlCwIQ7u/
         Royg==
X-Forwarded-Encrypted: i=1; AJvYcCUYvbNY/J9mnfUU7/I3Rr2GYVzP00X89rMzDcFa3RLN8iAEM0AHAuIcwDX6HSheP3ym6xA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyBbC2VtyUG5xQx/96uVDbSGs5VMRETCfFvRyjAh8m6YAU+v1/
	/com2hRro3vTnMgYzwljO669as+KW6B46Ps0fEDrWaW/cm77ABdZuKo/zsRn0JcSXOjZcyNe9aL
	JgI9AURrRCylD7Q2QSAa2Wws18hkHqRWPYEvWyhbe
X-Gm-Gg: AZuq6aJo8jWLqZ+YGnJ5bRzXMRw9qcl1M5Wt6lz7ohynITVNkU2jOCiE3hkGFCKDBtD
	BhN6PWjE1m9U/eZ7MM3QVtsiNk/gx7Gg+WucqAI52pr/vQDMetzMuZ6Wvy4ZZ7HTY7fuS2Vtkvd
	Nm92mlRHn0fd7iHmgoD+0kLcosLVPCmNVvYNdgkYdPU2yt9JrzJ+5rKoAiRdMzpsN5D/WjBKPOf
	ct4RaQ0EORlnCtRLgFjhP+V9Hn4rm+lE/hW4U6DTW2VWHMn9q2qWKUhDNSMAl8B38YahqXTleFp
	QDNRTUg=
X-Received: by 2002:a05:622a:1214:b0:4fb:e3b0:aae6 with SMTP id
 d75a77b69052e-503142cc142mr12796471cf.1.1769450726757; Mon, 26 Jan 2026
 10:05:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-3-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-3-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 26 Jan 2026 18:04:00 +0000
X-Gm-Features: AZwV_Qgr9raUBYRUZBfOH_mHnPcBMFzt0yhWhO3RKbwtE7BDMNNTotzOUCwDyNg
Message-ID: <CA+EHjTynFzZK5APC3LRzNbTC8RrtcavBE5=aqwg5a8CCp+oBhw@mail.gmail.com>
Subject: Re: [PATCH 02/20] KVM: arm64: Remove duplicate configuration for SCTLR_EL1.{EE,E0E}
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
	TAGGED_FROM(0.00)[bounces-69167-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 1FEAA8BE7F
X-Rspamd-Action: no action

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> We already have specific constraints for SCTLR_EL1.{EE,E0E}, and
> making them depend on FEAT_AA64EL1 is just buggy.

Looking at the spec, I see that they depend on FEAT_MixedEnd and
FEAT_MixedEndEL0, not on FEAT_AA64EL1. They are already in the right
place in config.c.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad






>
> Fixes: 6bd4a274b026e ("KVM: arm64: Convert SCTLR_EL1 to config-driven sanitisation")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/config.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 9c04f895d3769..0bcdb39885734 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -1140,8 +1140,6 @@ static const struct reg_bits_to_feat_map sctlr_el1_feat_map[] = {
>                    SCTLR_EL1_TWEDEn,
>                    FEAT_TWED),
>         NEEDS_FEAT(SCTLR_EL1_UCI        |
> -                  SCTLR_EL1_EE         |
> -                  SCTLR_EL1_E0E        |
>                    SCTLR_EL1_WXN        |
>                    SCTLR_EL1_nTWE       |
>                    SCTLR_EL1_nTWI       |
> --
> 2.47.3
>

