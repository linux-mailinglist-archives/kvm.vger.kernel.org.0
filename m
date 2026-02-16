Return-Path: <kvm+bounces-71132-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AKBiB0Fck2nw3wEAu9opvQ
	(envelope-from <kvm+bounces-71132-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 19:04:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DE36B146DBD
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 19:04:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B0FCA3033D27
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 18:04:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22574285CAD;
	Mon, 16 Feb 2026 18:04:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998133C2D;
	Mon, 16 Feb 2026 18:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771265073; cv=none; b=JWaC8/dAPQVmqOk4dNM9j/xYou5CtEbgdzTpvaBO55ue4whZFydBw1MMFZxcWh7b5vFga8BOBvAN1P/7E57xa8nb3PxjHs7+3ZWvvUhk8e6HA9PoeV3L63FTmx9z4EsrlXG2EbgUJfP3Kk4DIpwtPJTwgp5unjyThSL5NGxbrXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771265073; c=relaxed/simple;
	bh=6kGOM1T4poFGaUAsNvDOGjnG5cLnitKexAm58d+t1Hg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O0JH4F+gBo66a5hXxXkHhIfBXNot3CnX+ZrbsREQ+oNQN+4WTtRJQZlEVWj6gwCUmAKcpkCcA3S98rZDP0Ajqi+RRPM3Tb66v4y0fciKVy1y9on4kGcuinRAS6VO0HScwHQ/1wT8IpQjosT8i4903ToMRCA1AqFIoUzqUMPh3GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FDEC116C6;
	Mon, 16 Feb 2026 18:04:29 +0000 (UTC)
Date: Mon, 16 Feb 2026 18:04:27 +0000
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
Subject: Re: [PATCH v12 6/7] arm64: futex: support futex with FEAT_LSUI
Message-ID: <aZNbXlvCHxDmsmOA@arm.com>
References: <20260121190622.2218669-1-yeoreum.yun@arm.com>
 <20260121190622.2218669-7-yeoreum.yun@arm.com>
 <aYtgmZZhAKAvtfaK@arm.com>
 <aYtoOktjE18YNtB+@e129823.arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYtoOktjE18YNtB+@e129823.arm.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71132-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[22];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[catalin.marinas@arm.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DE36B146DBD
X-Rspamd-Action: no action

On Tue, Feb 10, 2026 at 05:17:46PM +0000, Yeoreum Yun wrote:
> > On Wed, Jan 21, 2026 at 07:06:21PM +0000, Yeoreum Yun wrote:
> > > +
> > > +	if (futex_on_lo) {
> > > +		oval64.lo_futex.val = oldval;
> > > +		ret = get_user(oval64.lo_futex.other, uaddr + 1);
> > > +	} else {
> > > +		oval64.hi_futex.val = oldval;
> > > +		ret = get_user(oval64.hi_futex.other, uaddr - 1);
> > > +	}
> >
> > and here use
> >
> > 	get_user(oval64.raw, uaddr64);
> > 	futex[futex_pos] = oldval;
> 
> But there is another feedback about this
> (though I did first similarly with your suggestion -- use oval64.raw):
>   https://lore.kernel.org/all/aXDZGhFQDvoSwdc_@willie-the-truck/

Do you mean the 64-bit read? You can do a 32-bit uaccess, something
like:

	int other_pos = futex_pos ^ 1;
	get_user(futex[other_pos], (u32 __user *)uaddr64 + other_pos);

-- 
Catalin

