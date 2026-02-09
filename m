Return-Path: <kvm+bounces-70639-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6N8cERYuimmVIAAAu9opvQ
	(envelope-from <kvm+bounces-70639-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 19:57:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 01E30113E63
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 19:57:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E4067301AB82
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 18:57:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1FFC3D903F;
	Mon,  9 Feb 2026 18:57:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31DBC3033D2;
	Mon,  9 Feb 2026 18:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770663432; cv=none; b=puS6ztst0pXrguCXV//PcydCuRIJTpZPzbH3bXqZ3vNZi8bmuVGESUCBg3yVPBYm8k5qS5kHyM5MBlcmKa10tydhGG2hdlvNeTNjBldXP+WU5QMtyBgK19yxReHtFy6C+UJQskAeZuGVktVeMos5oYl5XmWk0da/HCcynU9CdIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770663432; c=relaxed/simple;
	bh=Pd6X/zKUpHxyzsOzhkFBQXmftpIR9RT4sACEVCZ1rs0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hbnABhU1FI6ynYL/QzOVqM/zztHZbYvrBzwaAT6ZOsKQcpKqy+HBp7fsHsKNwBsOoGdPXbb7pmoyAq7pCRTuBC8HkR9lqGqngBjIdoH9TuxvarD6bXFOpXlg69x85yHO1CUawZsJMaUHAHWxTEp2VzXJzSeW0ZIjaKaFvEvqyvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0BAC1339;
	Mon,  9 Feb 2026 10:57:05 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B8D043F740;
	Mon,  9 Feb 2026 10:57:08 -0800 (PST)
Date: Mon, 9 Feb 2026 18:57:06 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, will@kernel.org, maz@kernel.org,
	broonie@kernel.org, oliver.upton@linux.dev, miko.lenczewski@arm.com,
	kevin.brodsky@arm.com, ardb@kernel.org, suzuki.poulose@arm.com,
	lpieralisi@kernel.org, scott@os.amperecomputing.com,
	joey.gouly@arm.com, yuzenghui@huawei.com, pbonzini@redhat.com,
	shuah@kernel.org, mark.rutland@arm.com, arnd@arndb.de
Subject: Re: [PATCH v12 2/7] arm64: cpufeature: add FEAT_LSUI
Message-ID: <aYouAv_EjICIN8oA@arm.com>
References: <20260121190622.2218669-1-yeoreum.yun@arm.com>
 <20260121190622.2218669-3-yeoreum.yun@arm.com>
 <aYY2CyHWtplQ-fuS@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYY2CyHWtplQ-fuS@arm.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70639-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[catalin.marinas@arm.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,arm.com:mid]
X-Rspamd-Queue-Id: 01E30113E63
X-Rspamd-Action: no action

On Fri, Feb 06, 2026 at 06:42:19PM +0000, Catalin Marinas wrote:
> On Wed, Jan 21, 2026 at 07:06:17PM +0000, Yeoreum Yun wrote:
> > +#ifdef CONFIG_ARM64_LSUI
> > +static bool has_lsui(const struct arm64_cpu_capabilities *entry, int scope)
> > +{
> > +	if (!has_cpuid_feature(entry, scope))
> > +		return false;
> > +
> > +	/*
> > +	 * A CPU that supports LSUI should also support FEAT_PAN,
> > +	 * so that SW_PAN handling is not required.
> > +	 */
> > +	if (WARN_ON(!__system_matches_cap(ARM64_HAS_PAN)))
> > +		return false;
> > +
> > +	return true;
> > +}
> > +#endif
> 
> I still find this artificial dependency a bit strange. Maybe one doesn't
> want any PAN at all (software or hardware) and won't get LSUI either
> (it's unlikely but possible).
> 
> We have the uaccess_ttbr0_*() calls already for !LSUI, so maybe
> structuring the macros in a way that they also take effect with LSUI.
> For futex, we could add some new functions like uaccess_enable_futex()
> which wouldn't do anything if LSUI is enabled with hw PAN.

Hmm, I forgot that we removed CONFIG_ARM64_PAN for 7.0, so it makes it
harder to disable. Give it a try but if the macros too complicated, we
can live with the additional check in has_lsui().

However, for completeness, we need to check the equivalent of
!system_uses_ttbr0_pan() but probing early, something like:

	if (IS_ENABLED(CONFIG_ARM64_SW_TTBR0_PAN) &&
	    !__system_matches_cap(ARM64_HAS_PAN)) {
		pr_info_once("TTBR0 PAN incompatible with FEAT_LSUI; disabling FEAT_LSUI");
		return false;
	}

-- 
Catalin

