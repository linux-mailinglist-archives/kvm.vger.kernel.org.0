Return-Path: <kvm+bounces-69252-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +FNNNE7ceGnbtgEAu9opvQ
	(envelope-from <kvm+bounces-69252-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 16:39:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F57696E6F
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 16:39:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 717D030D13BC
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 15:28:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CE0236164B;
	Tue, 27 Jan 2026 15:26:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15B4B3612F1
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 15:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769527575; cv=none; b=G9KIBc7Ayd3MFMXLXWPU1SFmxtz8BIl0trhVqulnPmSKgI+mFmc4ltn55j6eir2RXIUlxIivo0O/0wF94xibGN6epmlqFviuIKwE7GUqqtJvFImQddtf+hbKWwXumTr5iRhmddKAWXt8rd5fpG2TKKT3/Q2SstWRBC1+Ta2SbAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769527575; c=relaxed/simple;
	bh=HDt1CqFtRIaJlbdx1oIOlAqFWYxY9F112Nin7VHjd6k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Am0U5CvegITr1z0Qw2plGRsD/POv2IK+J3TcFlSzjzhIfSlEfidYxPoshAD25eGPABsNBsDnKcSHkVfLUKhN+YvwKxaTz5N/Dg1L2nwajqh9lmlG0shW9akUXM6kI7kB2j4+kueoqGqjTBMs3q9C89uC9k11OEIrIAuH9edtp1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 121791596;
	Tue, 27 Jan 2026 07:26:07 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 213823F632;
	Tue, 27 Jan 2026 07:26:12 -0800 (PST)
Date: Tue, 27 Jan 2026 15:26:09 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 07/20] KVM: arm64: Allow RES1 bits to be inferred from
 configuration
Message-ID: <20260127152609.GB2685766@e124191.cambridge.arm.com>
References: <20260126121655.1641736-1-maz@kernel.org>
 <20260126121655.1641736-8-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260126121655.1641736-8-maz@kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69252-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joey.gouly@arm.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	R_DKIM_NA(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[e124191.cambridge.arm.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,arm.com:email]
X-Rspamd-Queue-Id: 4F57696E6F
X-Rspamd-Action: no action

On Mon, Jan 26, 2026 at 12:16:41PM +0000, Marc Zyngier wrote:
> So far, when a bit field is tied to an unsupported feature, we set
> it as RES0. This is almost forrect, but there are a few exceptions

forrect is almost correct too!

> where the bits become RES1.
> 
> Add a AS_RES1 qualifier that instruct the RESx computing code to
> simply do that.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey

> ---
>  arch/arm64/kvm/config.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 8d152605999ba..6a4674fabf865 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -24,6 +24,7 @@ struct reg_bits_to_feat_map {
>  #define	CALL_FUNC	BIT(1)	/* Needs to evaluate tons of crap */
>  #define	FIXED_VALUE	BIT(2)	/* RAZ/WI or RAO/WI in KVM */
>  #define	MASKS_POINTER	BIT(3)	/* Pointer to fgt_masks struct instead of bits */
> +#define	AS_RES1		BIT(4)	/* RES1 when not supported */
>  
>  	unsigned long	flags;
>  
> @@ -1316,8 +1317,12 @@ struct resx __compute_fixed_bits(struct kvm *kvm,
>  		else
>  			match = idreg_feat_match(kvm, &map[i]);
>  
> -		if (!match || (map[i].flags & FIXED_VALUE))
> -			resx.res0 |= reg_feat_map_bits(&map[i]);
> +		if (!match || (map[i].flags & FIXED_VALUE)) {
> +			if (map[i].flags & AS_RES1)
> + 				resx.res1 |= reg_feat_map_bits(&map[i]);
> +			else
> +				resx.res0 |= reg_feat_map_bits(&map[i]);
> +		}
>  	}
>  
>  	return resx;
> -- 
> 2.47.3
> 

