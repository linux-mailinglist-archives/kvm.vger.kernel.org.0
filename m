Return-Path: <kvm+bounces-69251-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OIDdLbPbeGmwtgEAu9opvQ
	(envelope-from <kvm+bounces-69251-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 16:37:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 1067C96D7D
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 16:37:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EC55B305FBFE
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 15:24:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7821F35CBA5;
	Tue, 27 Jan 2026 15:21:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE7CC2FFDE1
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 15:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769527277; cv=none; b=t8SQsBqGeqDuqYW3HxMdP4UP05mrSenuS+ZLEA79APjdcMIRehE/LdYXrZLOdzrVzVXABraLGz1gdcZqJtNh0YD6t6mbdOUigIiZ2zw5nDVpCDvYO+E/h6VVgsQYh7PJaVXUO9FlKjaZCVLFJ4AsNPuZ0hUCIEHz5g/uClpkrcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769527277; c=relaxed/simple;
	bh=sOIeIV9dFYKMJ5f9y1HkAduj63Lo1A2RXb4zTr9aLP8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tYb8qoKThbRmbvyTcn2bRI50SKRJ6qoVKD37F/Ke3Edj9XJCS/bSp/PJGwI9GfL/63a4Jgszaon7d6wkAXyCOZM1nXv22ECpj93u8TTkPrr0YgEg9MpQHdIpg26EHrYFugZm9SnewvJaYbpjMOj/vESbov8TKEbKmOJsZ1mgYbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B518B1596;
	Tue, 27 Jan 2026 07:21:08 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C39643F632;
	Tue, 27 Jan 2026 07:21:13 -0800 (PST)
Date: Tue, 27 Jan 2026 15:21:08 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 06/20] KVM: arm64: Inherit RESx bits from FGT register
 descriptors
Message-ID: <20260127152108.GA2685766@e124191.cambridge.arm.com>
References: <20260126121655.1641736-1-maz@kernel.org>
 <20260126121655.1641736-7-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260126121655.1641736-7-maz@kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69251-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 1067C96D7D
X-Rspamd-Action: no action

On Mon, Jan 26, 2026 at 12:16:40PM +0000, Marc Zyngier wrote:
> The FGT registers have their computed RESx bits stashed in specific
> descriptors, which we can easily use when computing the masks used
> for the guest.
> 
> This removes a bit of boilerplate code.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/config.c | 16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index a907195bd44b6..8d152605999ba 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -1344,6 +1344,11 @@ struct resx compute_reg_resx_bits(struct kvm *kvm,
>  	resx = compute_resx_bits(kvm, r->bit_feat_map, r->bit_feat_map_sz,
>  				 require, exclude);
>  
> +	if (r->feat_map.flags & MASKS_POINTER) {
> +		resx.res0 |= r->feat_map.masks->res0;
> +		resx.res1 |= r->feat_map.masks->res1;
> +	}
> +
>  	tmp = compute_resx_bits(kvm, &r->feat_map, 1, require, exclude);
>  
>  	resx.res0 |= tmp.res0;
> @@ -1424,47 +1429,36 @@ struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg)
>  	switch (reg) {
>  	case HFGRTR_EL2:
>  		resx = compute_reg_resx_bits(kvm, &hfgrtr_desc, 0, 0);
> -		resx.res1 |= HFGRTR_EL2_RES1;
>  		break;
>  	case HFGWTR_EL2:
>  		resx = compute_reg_resx_bits(kvm, &hfgwtr_desc, 0, 0);
> -		resx.res1 |= HFGWTR_EL2_RES1;
>  		break;
>  	case HFGITR_EL2:
>  		resx = compute_reg_resx_bits(kvm, &hfgitr_desc, 0, 0);
> -		resx.res1 |= HFGITR_EL2_RES1;
>  		break;
>  	case HDFGRTR_EL2:
>  		resx = compute_reg_resx_bits(kvm, &hdfgrtr_desc, 0, 0);
> -		resx.res1 |= HDFGRTR_EL2_RES1;
>  		break;
>  	case HDFGWTR_EL2:
>  		resx = compute_reg_resx_bits(kvm, &hdfgwtr_desc, 0, 0);
> -		resx.res1 |= HDFGWTR_EL2_RES1;
>  		break;
>  	case HAFGRTR_EL2:
>  		resx = compute_reg_resx_bits(kvm, &hafgrtr_desc, 0, 0);
> -		resx.res1 |= HAFGRTR_EL2_RES1;
>  		break;
>  	case HFGRTR2_EL2:
>  		resx = compute_reg_resx_bits(kvm, &hfgrtr2_desc, 0, 0);
> -		resx.res1 |= HFGRTR2_EL2_RES1;
>  		break;
>  	case HFGWTR2_EL2:
>  		resx = compute_reg_resx_bits(kvm, &hfgwtr2_desc, 0, 0);
> -		resx.res1 |= HFGWTR2_EL2_RES1;
>  		break;
>  	case HFGITR2_EL2:
>  		resx = compute_reg_resx_bits(kvm, &hfgitr2_desc, 0, 0);
> -		resx.res1 |= HFGITR2_EL2_RES1;
>  		break;
>  	case HDFGRTR2_EL2:
>  		resx = compute_reg_resx_bits(kvm, &hdfgrtr2_desc, 0, 0);
> -		resx.res1 |= HDFGRTR2_EL2_RES1;
>  		break;
>  	case HDFGWTR2_EL2:
>  		resx = compute_reg_resx_bits(kvm, &hdfgwtr2_desc, 0, 0);
> -		resx.res1 |= HDFGWTR2_EL2_RES1;
>  		break;
>  	case HCRX_EL2:
>  		resx = compute_reg_resx_bits(kvm, &hcrx_desc, 0, 0);
> -- 
> 2.47.3
> 

