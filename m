Return-Path: <kvm+bounces-70766-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6LDYLoxZi2ljUAAAu9opvQ
	(envelope-from <kvm+bounces-70766-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 17:15:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 31BCE11CFD6
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 17:15:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E317E301739F
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:15:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8195C389454;
	Tue, 10 Feb 2026 16:15:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1083385EDA;
	Tue, 10 Feb 2026 16:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770740103; cv=none; b=l4dPWSQoz74UxmrwuuMWa+oZpX9ATkj3ElUrjEOKT/9GAzznLGIxXtsN5q24/h+4WWmqEJ93TFKwBANoJKzNO8sRURIgcmVqWOCBIKpmYUfzsZbzl5X07+bkMM7HqvEoTcQZiFgyp76SbDOuThFgu/YhHGfNARTMrODiOFUrQ+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770740103; c=relaxed/simple;
	bh=9vtbxyiMLrYNdwBoK7qoue5mhebGylj6qkZTJg0n2wo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KsL1Yc5RbDcK+idFtIj02MEsicWF/g8nEROpQC/Xm/LKUR0CYsEOsCh2RqzoEFcCkg41d2xXVW1N4tCJIUmfyA3gUuzGMpjIS0q3H4NwvWldo/DGjXI5Z2xfCgtqFO0K4NbovD6qqoHjvOK9vjyL+5VV0rDGfQfLFBUfIyz4PbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9AB9B339;
	Tue, 10 Feb 2026 08:14:53 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C179F3F632;
	Tue, 10 Feb 2026 08:14:56 -0800 (PST)
Date: Tue, 10 Feb 2026 16:14:54 +0000
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
Message-ID: <aYtZfpWjRJ1r23nw@arm.com>
References: <20260121190622.2218669-1-yeoreum.yun@arm.com>
 <20260121190622.2218669-3-yeoreum.yun@arm.com>
 <aYY2CyHWtplQ-fuS@arm.com>
 <aYouAv_EjICIN8oA@arm.com>
 <aYsAaaQgBaLbDSsW@e129823.arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYsAaaQgBaLbDSsW@e129823.arm.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70766-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 31BCE11CFD6
X-Rspamd-Action: no action

Hi Levi,

On Tue, Feb 10, 2026 at 09:54:49AM +0000, Yeoreum Yun wrote:
> > On Fri, Feb 06, 2026 at 06:42:19PM +0000, Catalin Marinas wrote:
> > > On Wed, Jan 21, 2026 at 07:06:17PM +0000, Yeoreum Yun wrote:
> > > > +#ifdef CONFIG_ARM64_LSUI
> > > > +static bool has_lsui(const struct arm64_cpu_capabilities *entry, int scope)
> > > > +{
> > > > +	if (!has_cpuid_feature(entry, scope))
> > > > +		return false;
> > > > +
> > > > +	/*
> > > > +	 * A CPU that supports LSUI should also support FEAT_PAN,
> > > > +	 * so that SW_PAN handling is not required.
> > > > +	 */
> > > > +	if (WARN_ON(!__system_matches_cap(ARM64_HAS_PAN)))
> > > > +		return false;
> > > > +
> > > > +	return true;
> > > > +}
> > > > +#endif
> > >
> > > I still find this artificial dependency a bit strange. Maybe one doesn't
> > > want any PAN at all (software or hardware) and won't get LSUI either
> > > (it's unlikely but possible).
> > > We have the uaccess_ttbr0_*() calls already for !LSUI, so maybe
> > > structuring the macros in a way that they also take effect with LSUI.
> > > For futex, we could add some new functions like uaccess_enable_futex()
> > > which wouldn't do anything if LSUI is enabled with hw PAN.
> >
> > Hmm, I forgot that we removed CONFIG_ARM64_PAN for 7.0, so it makes it
> > harder to disable. Give it a try but if the macros too complicated, we
> > can live with the additional check in has_lsui().
> >
> > However, for completeness, we need to check the equivalent of
> > !system_uses_ttbr0_pan() but probing early, something like:
> >
> > 	if (IS_ENABLED(CONFIG_ARM64_SW_TTBR0_PAN) &&
> > 	    !__system_matches_cap(ARM64_HAS_PAN)) {
> > 		pr_info_once("TTBR0 PAN incompatible with FEAT_LSUI; disabling FEAT_LSUI");
> > 		return false;
> > 	}
> 
> TBH, I'm not sure whether it's a artifical dependency or not.
> AFAIK, FEAT_PAN is mandatory from Armv8.1 and the FEAT_LSUI seems to
> implements based on the present of "FEAT_PAN".
> 
> So, for a hardware which doesn't have FEAT_PAN but has FEAT_LSUI
> sounds like "wrong" hardware and I'm not sure whether it's right
> to enable FEAT_LSUI in this case.

In principle we shouldn't have such hardware but, as Will pointed out,
we might have such combination due to other reasons like virtualisation,
id reg override.

It's not that FEAT_LSUI requires FEAT_PAN but rather that the way you
implemented it, the FEAT_LSUI futex code is incompatible with SW_PAN
because you no longer call uaccess_enable_privileged(). So I suggested a
small tweak above to make this more obvious. I would also remove the
WARN_ON, or at least make it WARN_ON_ONCE() if you still want the stack
dump.

However...

> SW_PAN case is the same problem. Since If system uses SW_PAN,
> that means this hardware doesn't have a "FEAT_PAN"
> So this question seems to ultimately boil down to whether
> it is appropriate to allow the use of FEAT_LSUI
> even when FEAT_PAN is not supported.
> 
> That's why I think the purpose of "has_lsui()" is not for artifical
> dependency but to disable for unlike case which have !FEAT_PAN and FEAT_LSUI
> and IMHO it's enough to check only check with "ARM64_HAS_PAN" instead of
> making a new function like uaccess_enable_futex().

Why not keep uaccess_enable_privileged() in
arch_futex_atomic_op_inuser() and cmpxchg for all cases and make it a
no-op if FEAT_LSUI is implemented together with FEAT_PAN? A quick grep
shows a recent addition in __lse_swap_desc() (and the llsc equivalent)
but this one can also use CAST with FEAT_LSUI.

BTW, with the removal of uaccess_enable_privileged(), we now get MTE tag
checks for the futex operations. I think that's good as it matches the
other uaccess ops, though it's a slight ABI change. If we want to
preserve the old behaviour, we definitely need
uaccess_enable_privileged() that only does mte_enable_tco().

-- 
Catalin

