Return-Path: <kvm+bounces-69567-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6KAdHQiOe2k1GAIAu9opvQ
	(envelope-from <kvm+bounces-69567-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 17:42:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id F0722B25B1
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 17:42:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7EF4E3007955
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 16:42:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39CB33431EF;
	Thu, 29 Jan 2026 16:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BjJNXrk6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADC533D6D4
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 16:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769704960; cv=pass; b=RlJ/v426eWDjYbXW437dku4dQeI2zq7ek1Kv7JCGpF/LX6RrYQUr2dALEJbSDFVNTLFFB3mSBF6XYREawpUgIqwo0oZ2ccLKHZUAfgb41Ta1gsnKkSgmOjaMG7hd5cUrTH0cNjYFAdHURejTMKNJ87bvd2WE3AYRIesDqhNIaN0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769704960; c=relaxed/simple;
	bh=MwG6UqR6avV7JdKFskgLX/UuuUNq7QZrPqAsH3rPeMw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W3LSxuFSc+CJQMi1X2/kJVI0yhCFN1DZ0rgHiqc44Yzs4J24hpzWAeMYPmuHQ29wzjJ460fKY+FzT9pkwwmEVl21uMuotQwSl5yhafJFBc5AMHe9Gf6jYdD1s5bZSIb+roZC0xN0BPlKo+ET1hiFRbLCHu3RsM8nOnTw7bloaTQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BjJNXrk6; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5033b64256dso445581cf.0
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 08:42:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769704954; cv=none;
        d=google.com; s=arc-20240605;
        b=bHWkLKD4zarvj0hYSQgzo0iTG2A8cZiNXwNZQaznu6g1WxqZ9upa6/khGyqh/jSHmI
         FfHLzUOQkNF4hFZTORLad04XqKBmo75Lwyy9iZYt0JEZDRHO/Dk33ucxd/FMyX2k6gRf
         RsZI48VjkEJ3VFIX2Sq4M/cUdUT5Ig1eGU9cX1H+YmMZ5Na9wtKs73Zf0K/9sdqIBBN6
         WjFGq15Eu/i5rHRZXvT1SnGLxkVXIkt+5bnniLoLXC4T5Q9mRrYf1JB8HPR1AaxD5ePD
         WRNBNlvp5VPTdhO7S6aD7jjId/tsPk30O4aU9P33sEdWdss7+6jVbtlnVyCYlGIbWhyZ
         ROfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=mie6pCcIIw47fH1gJHDTDQWilzzUt5ppA4ofEa1Bgr0=;
        fh=KH25DObIa3BhhQOCOqxYvPZyTPoFQ6Sjy74SjlKaYp0=;
        b=LUoZzaeMFMoGL6tprK+IvLTqPw+axnGIJibaZWtjdnCFTvXSV2XT10QxpQsYH5ySvE
         M+xMBCuM2DkD6OniSJTjBS5RvaTHIKeLluF2F1pVdhdKfP/0gA3AMaY7XABfHteQv6Ax
         CaCEPIBOg1OiMcKhtApRSnxt8loGWvea9ox3P0PRY5X3fns6iTQIiBwBeqojKGqM4c2F
         GyvjzO8zziV97RRHCqIZoNJ4VChdhY6gJlRy0M2Aq7CWWyX/ZLrrSwfR7jovft+JcQWp
         mFyjUPaS14+ddZs+PHlLxxVa9MbbvG2b8ie0kQO2/8Q9kzTbe2zmi4YgwzkIEq9dXZHK
         9XZw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769704954; x=1770309754; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mie6pCcIIw47fH1gJHDTDQWilzzUt5ppA4ofEa1Bgr0=;
        b=BjJNXrk6kwsWDZUQQYUOngLngAf2lq/tDD0YHpObDHhurub6QOF0yDME0i7QT35Eb8
         n1QCgOGdGHRg9QnJKN/s1WMCp0ccCueXp78s2X5EVhpMkdssByv28FfTfRRsUFlrEH6/
         iFDLmqVH3NC7YOmSyms/mTNB/OhTDCf4djmBmPVQehtA+I+BH4meykUt7lB8fZsxtdrb
         M5XBOgEx8LGhISmA7GJ3eisKWJjI4ega0c0TZ/mblg9Xw3cMnrzUojYBHDSczTPPrMt0
         AmmNNZKfEts2I/RXu8Cf02TLBisvE42cHf6TuHg8P4aSJAxxxkRlC69NdlM2gtWaIOti
         Wbsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769704954; x=1770309754;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mie6pCcIIw47fH1gJHDTDQWilzzUt5ppA4ofEa1Bgr0=;
        b=VotZmfaZ//1QCUqakngrRJyvsF+n2UDwJPZiZsmbC8TWgiCHVw9TMsVObSfpfj2DLr
         DwCa7w4FzrZ3fIUqeB/oKNUdHI3EQBN+mVfsN0uhKNCUR1qJAcIlrWFmmPwTdrwiidr9
         Hhw54qz2D9PLwXj3F9VCxT6zHNOrhZcyFPg0PbDOU/H172Cu/H8Zwfp5EtKubPFDSmWg
         yauVhPc3HKb5YdTDHcAxKcDifvr4FvSdyOcN11HeC7F3qW8+WPvlVnOa7RefEI4bS9ED
         ls76VOL5DkJe931RpfrcNVzeUH/IdM64f86vJV4xw25JZOs44UeVbli5pFK+/MnUiDZA
         eoSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWXhNWiT0hzmk2fTHUxj/zyZt1QiJBuIbOn7Wf2PJuBXgC+Bmu4nEMrNkVMzyzWzI27k/0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxlt6ncXVEOr6vtZBbwx/eO+X5Wap3A65LyUCw6kck794R3Btb5
	ie3ujLG2nbKw/hj7vShw6LjLY83IywnbV/wTPbESXmfg4YT5tZQD4k6SgVLX92Aw+BaVNjxvR/K
	7SrLw4hYobC88WUeX19yq4WtAmdSAwY9CQi0CuHPE
X-Gm-Gg: AZuq6aIAf5n5kn6j5F2OwdsOfyEWK7IQb7KbPymPTEaxZc+sPeJTYoYDIfG3ZBa00oj
	g3FpGUkAnNDp840gOwZmS52QFKFOwCTuW7EaESRCf08zO0ZEwpY7Hhq5kAq6sws3SKWX20HFqJv
	TCe9VdTGiP6pDNhTQ8JQBBXnwFHOGpC0qasJA6vMi/+5m384yWvtFRIychynMkat1u5FO3uRHeA
	z9+U/LxbP+bUgCW6vnfY6/w7b5fPNwc8YzCxj9C1mwTunySSmfI0aPjhw8wPNwx1e8IydUv
X-Received: by 2002:ac8:58c9:0:b0:4ff:cb72:7c03 with SMTP id
 d75a77b69052e-50428e79945mr12313541cf.3.1769704953904; Thu, 29 Jan 2026
 08:42:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-15-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-15-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 29 Jan 2026 16:41:57 +0000
X-Gm-Features: AZwV_QgUsDZZ79om87g5fzEjBCiqAJNzGck6Go33ZwAHIlJhkXiSMYJ8ttr0Cec
Message-ID: <CA+EHjTzf4TLO+UOkbsqzEuzaaPQgHFjWLpRRrn0jZDndcSGMDA@mail.gmail.com>
Subject: Re: [PATCH 14/20] KVM: arm64: Simplify handling of HCR_EL2.E2H RESx
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69567-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: F0722B25B1
X-Rspamd-Action: no action

Hi Marc,

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> Now that we can link the RESx behaviour with the value of HCR_EL2.E2H,
> we can trivially express the tautological constraint that makes E2H
> a reserved value at all times.
>
> Fun, isn't it?
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/config.c | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index d5871758f1fcc..187d047a9cf4a 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -394,16 +394,6 @@ static bool feat_vmid16(struct kvm *kvm)
>         return kvm_has_feat_enum(kvm, ID_AA64MMFR1_EL1, VMIDBits, 16);
>  }
>
> -static bool compute_hcr_e2h(struct kvm *kvm, struct resx *bits)
> -{
> -       if (kvm_has_feat(kvm, FEAT_E2H0))
> -               bits->res0 |= HCR_EL2_E2H;
> -       else
> -               bits->res1 |= HCR_EL2_E2H;
> -
> -       return true;
> -}
> -
>  static const struct reg_bits_to_feat_map hfgrtr_feat_map[] = {
>         NEEDS_FEAT(HFGRTR_EL2_nAMAIR2_EL1       |
>                    HFGRTR_EL2_nMAIR2_EL1,
> @@ -1023,7 +1013,8 @@ static const struct reg_bits_to_feat_map hcr_feat_map[] = {
>         NEEDS_FEAT(HCR_EL2_TWEDEL       |
>                    HCR_EL2_TWEDEn,
>                    FEAT_TWED),
> -       NEEDS_FEAT_FIXED(HCR_EL2_E2H, compute_hcr_e2h),
> +       NEEDS_FEAT_FLAG(HCR_EL2_E2H, RES0_WHEN_E2H0 | RES1_WHEN_E2H1,
> +                       enforce_resx),

If you were to take my suggestion for the previous patch, I think that
you could express this as follows:

    FORCE_RESx | RES0_WHEN_E2H0 | RES1_WHEN_E2H1

Or if you use the modified patch 12:

    FORCE_RESx | RES1_WHEN_E2H1

Either way:
Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>         FORCE_RES0(HCR_EL2_RES0),
>         FORCE_RES1(HCR_EL2_RES1),
>  };


> --
> 2.47.3
>

