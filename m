Return-Path: <kvm+bounces-68725-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CAdhJqzhcGkhawAAu9opvQ
	(envelope-from <kvm+bounces-68725-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 15:24:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D10B58619
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 15:24:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 924CBA28740
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 13:52:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D89849219C;
	Wed, 21 Jan 2026 13:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AW2mIWUc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B2D48C8DF;
	Wed, 21 Jan 2026 13:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769003298; cv=none; b=V5hsaZ68atd6IMUPYhvO2f3wmyaRNb/IVqKv1ILaq40fJ7iGP7ILsxKYCQL7VVNXA/P4wNaCUPzBEMqpweuMV/YZk5dspJoEM0Wb0DTXyzMtGDQ6bjxTcjmWoCAADLafrm0RXwdD34cpmTk4RwKqjHLSZDze5ZOrx9yNvyifOoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769003298; c=relaxed/simple;
	bh=VpCP4rWPoedg5kjG3d2wjsJQWbzX2GfdwhAN9xSoVLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DTLmQVyFBnnUAh3k/NFuGFXIXbrM2mId3BFAmcHNIFbpIjhAcMlon7N4DudnULYJJ5UVDGMX6oIjf8PmRWXleki3iWx3pDSxnXUrbbQ7SeiPCZ6W9aFn97jg2ROuC1msaYqygffPwg2LSgrMh4Y+dlwLxdGO1Hu8NleQgXwhS0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AW2mIWUc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77ED5C116D0;
	Wed, 21 Jan 2026 13:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769003297;
	bh=VpCP4rWPoedg5kjG3d2wjsJQWbzX2GfdwhAN9xSoVLc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AW2mIWUcA6xvVB3CX2ffd0Gv+2enV+Qb302ghmDEvuHFFUb2Nb8p8O2GzIoCVmqjL
	 xxpFpUbCtnCm+OHuGUAubzYXYTq65VDS61Vsk13OHdoUZSYKS3W6ukkPBZJgiTt87X
	 LOQCEY4FubaP3wEGZkIG5IBfNjprOE5zFDrEugixMzsWd35dJ5Y9i5+GxJQorkZzV9
	 u/8sykpDJ2eb4uNfJIuw9mqYMQzT/jdcSe0zLb4Nd6jPdtvFc5kr095gtiQkRfRVIM
	 5aRgBdJa9/Q/2664KNUAJsMODwSapoqHbv+jKPP4B6icJzvIainfOrjq3KZi/3fyC0
	 Gbw2TE7crSvNA==
Date: Wed, 21 Jan 2026 13:48:10 +0000
From: Will Deacon <will@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, broonie@kernel.org,
	oliver.upton@linux.dev, miko.lenczewski@arm.com,
	kevin.brodsky@arm.com, ardb@kernel.org, suzuki.poulose@arm.com,
	lpieralisi@kernel.org, yangyicong@hisilicon.com,
	scott@os.amperecomputing.com, joey.gouly@arm.com,
	yuzenghui@huawei.com, pbonzini@redhat.com, shuah@kernel.org,
	mark.rutland@arm.com, arnd@arndb.de,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v11 RESEND 6/9] arm64: futex: support futex with FEAT_LSUI
Message-ID: <aXDZGhFQDvoSwdc_@willie-the-truck>
References: <20251214112248.901769-1-yeoreum.yun@arm.com>
 <20251214112248.901769-7-yeoreum.yun@arm.com>
 <aW5dzb0ldp8u8Rdm@willie-the-truck>
 <aW6tix/GeqgXpTUN@e129823.arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aW6tix/GeqgXpTUN@e129823.arm.com>
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68725-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[will@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 1D10B58619
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, Jan 19, 2026 at 10:17:47PM +0000, Yeoreum Yun wrote:
> > > +"2:\n"
> > > +	_ASM_EXTABLE_UACCESS_ERR(1b, 2b, %w0)
> > > +	: "+r" (ret), "+Q" (*uaddr), "+r" (*oldval)
> > > +	: "r" (newval)
> > > +	: "memory");
> >
> > Don't you need to update *oldval here if the CAS didn't fault?
> 
> No. if CAS doesn't make fault the oldval update already.

Sorry, it was the "+r" constraint with a pointer dereference that threw
me but you have the "memory" clobber so it looks like this will work.

> > > +
> > > +	for (i = 0; i < FUTEX_MAX_LOOPS; i++) {
> > > +		if (get_user(oval64.raw, uaddr64))
> > > +			return -EFAULT;
> >
> > Since oldval is passed to us as an argument, can we get away with a
> > 32-bit get_user() here?
> 
> It's not a probelm. but is there any sigificant difference?

I think the code would be clearer if you only read what you actually
use.

> > > +		nval64.raw = oval64.raw;
> > > +
> > > +		if (futex_on_lo) {
> > > +			oval64.lo_futex.val = oldval;
> > > +			nval64.lo_futex.val = newval;
> > > +		} else {
> > > +			oval64.hi_futex.val = oldval;
> > > +			nval64.hi_futex.val = newval;
> > > +		}
> > > +
> > > +		orig64.raw = oval64.raw;
> > > +
> > > +		if (__lsui_cmpxchg64(uaddr64, &oval64.raw, nval64.raw))
> > > +			return -EFAULT;
> > > +
> > > +		if (futex_on_lo) {
> > > +			oldval = oval64.lo_futex.val;
> > > +			other = oval64.lo_futex.other;
> > > +			orig_other = orig64.lo_futex.other;
> > > +		} else {
> > > +			oldval = oval64.hi_futex.val;
> > > +			other = oval64.hi_futex.other;
> > > +			orig_other = orig64.hi_futex.other;
> > > +		}
> > > +
> > > +		if (other == orig_other) {
> > > +			ret = 0;
> > > +			break;
> > > +		}
> > > +	}
> > > +
> > > +	if (!ret)
> > > +		*oval = oldval;
> >
> > Shouldn't we set *oval to the value we got back from the CAS?
> 
> Since it's a "success" case, the CAS return and oldval must be the same.
> That's why it doesn't matter to use got back from the CAS.
> Otherwise, it returns error and *oval doesn't matter for
> futex_atomic_cmpxchg_inatomic().

Got it, but then the caller you have is very weird because e.g.
__lsui_futex_atomic_eor() goes and does another get_user() on the next
iteration instead of using the value returned by the CAS.

It would probably be clearer if you restructured your CAS helper to look
more like try_cmpxchg() and then the loop around it would be minimal.
You might need to distinguish the faulting case from the comparison
failure case with e.g. -EFAULT vs -EAGAIN.

Will

