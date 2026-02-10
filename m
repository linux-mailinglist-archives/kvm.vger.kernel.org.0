Return-Path: <kvm+bounces-70769-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gP18KOtgi2nDUAAAu9opvQ
	(envelope-from <kvm+bounces-70769-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 17:46:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 576F311D685
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 17:46:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 325DD305CA1C
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:45:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BB3F32AAD1;
	Tue, 10 Feb 2026 16:45:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 382423203BC;
	Tue, 10 Feb 2026 16:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770741921; cv=none; b=p4jZndZrO9gxwFZzBYkA/4ijBiLvgeAt8dX+rr1cCrCtq64ox0c/yzr0DX7jtUMMA6IqBudVpPReLWr14uTIUMTZHBB019GHjrRyGFX1r0DygRM9FIGc7EwVKqWJkrHjadArHd857RrMfDtC+v/4vGPKtEPEmrcDAH3iE5QMNXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770741921; c=relaxed/simple;
	bh=dMush2K0571ehpAANLKxDb3nHTfySaTETlhFpRasweE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qL+UWxsHk9u1Wi/ALWJLqE3faK5nGcuEN6yWSGjLam/B19zn8+jXYmoLC0vcLmJmOYKA6N3NNPlbw0+eCE+Sb4WYgeVtcHIkcRedi9e/tOU+gyktERoaIPoe8HGknovu8bNe/QLJ9l61XNTm9mAajL+xbn24dvIDKED0bsgij9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3D6A1339;
	Tue, 10 Feb 2026 08:45:13 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6423A3F632;
	Tue, 10 Feb 2026 08:45:16 -0800 (PST)
Date: Tue, 10 Feb 2026 16:45:13 +0000
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
Message-ID: <aYtgmZZhAKAvtfaK@arm.com>
References: <20260121190622.2218669-1-yeoreum.yun@arm.com>
 <20260121190622.2218669-7-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121190622.2218669-7-yeoreum.yun@arm.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70769-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 576F311D685
X-Rspamd-Action: no action

I wonder whether we can shorten this function a bit. Not sure it would
be more readable but it would be shorter.

On Wed, Jan 21, 2026 at 07:06:21PM +0000, Yeoreum Yun wrote:
> +static __always_inline int
> +__lsui_cmpxchg32(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> +{
> +	u64 __user *uaddr64;
> +	bool futex_on_lo;
> +	int ret, i;
> +	u32 other, orig_other;
> +	union {
> +		struct futex_on_lo {
> +			u32 val;
> +			u32 other;
> +		} lo_futex;
> +
> +		struct futex_on_hi {
> +			u32 other;
> +			u32 val;
> +		} hi_futex;
> +
> +		u64 raw;
> +	} oval64, orig64, nval64;

	union {
		u32 futex[2];
		u64 raw;
	}

> +
> +	uaddr64 = (u64 __user *) PTR_ALIGN_DOWN(uaddr, sizeof(u64));
> +	futex_on_lo = IS_ALIGNED((unsigned long)uaddr, sizeof(u64));

	futex_pos = (unsigned long)uaddr & 4 ? 1 : 0;

> +
> +	if (futex_on_lo) {
> +		oval64.lo_futex.val = oldval;
> +		ret = get_user(oval64.lo_futex.other, uaddr + 1);
> +	} else {
> +		oval64.hi_futex.val = oldval;
> +		ret = get_user(oval64.hi_futex.other, uaddr - 1);
> +	}

and here use

	get_user(oval64.raw, uaddr64);
	futex[futex_pos] = oldval;

> +
> +	if (ret)
> +		return -EFAULT;
> +
> +	ret = -EAGAIN;
> +	for (i = 0; i < FUTEX_MAX_LOOPS; i++) {
> +		orig64.raw = nval64.raw = oval64.raw;
> +
> +		if (futex_on_lo)
> +			nval64.lo_futex.val = newval;
> +		else
> +			nval64.hi_futex.val = newval;
> +
> +		if (__lsui_cmpxchg64(uaddr64, &oval64.raw, nval64.raw))
> +			return -EFAULT;
> +
> +		if (futex_on_lo) {
> +			oldval = oval64.lo_futex.val;
> +			other = oval64.lo_futex.other;
> +			orig_other = orig64.lo_futex.other;
> +		} else {
> +			oldval = oval64.hi_futex.val;
> +			other = oval64.hi_futex.other;
> +			orig_other = orig64.hi_futex.other;
> +		}

Something similar here to use futex[futex_pos].

We probably also need to check that the user pointer is 32-bit aligned
and return -EFAULT if not.

-- 
Catalin

