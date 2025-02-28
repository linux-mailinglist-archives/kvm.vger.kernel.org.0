Return-Path: <kvm+bounces-39732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DD93AA49CA3
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 16:01:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50280175574
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 15:00:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26A3827183E;
	Fri, 28 Feb 2025 14:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GpIhGHCQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F5E2702C2;
	Fri, 28 Feb 2025 14:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740754708; cv=none; b=UEEBwZ/5wx5z5vCudAp1fc9n2BnE40yAWJT1yl27q2T8MzRPG464OuH8TcvvhcnxuO3xOtijII7K9B/AT4g3Niy94ONJ/9dg11SdBnpLW9tulHep/i0PcCEEYhQxSr/6GFcWkvEI5Lw0hUMW2JlFP7mMaP6jz30XxVkoEEP6vUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740754708; c=relaxed/simple;
	bh=jbcihSxGb0S6EIN2kwS80l3GlBkI0kHNVj0VG5tKTnk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ug7q3oWaxXbFgzVBL6oWsLNWbhqtDpW2H/sAAfvIHtx7NGdrpa3LaxPTHdAUq+KkIVlznPGA1mL8awJ6BoXYuhRsNA5gzr+TntE+ZXTzKDF/aM1qKwjVGXaIBt9yTLCAujj3ld9SwFrNoBGQtUfvGR3abagX1ZuSfmfHOvLbxr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GpIhGHCQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4FFC4CEE2;
	Fri, 28 Feb 2025 14:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740754707;
	bh=jbcihSxGb0S6EIN2kwS80l3GlBkI0kHNVj0VG5tKTnk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GpIhGHCQZGN/ArwvJEofXCOH3krnfhDPTk4Ol9mruH9lTz3oxj8oCINP94j4yKLap
	 vBWsL2v836T1+/WDgVQXn1VUpO7IZOPwqJzqJK+xYZZwBl+y9Qf7fQX4QJY4UcIp90
	 AUvbI6DuPbGF7tkq3Z96ki5dlVjGlO0S9kCpTpgwn+LqCHOaEYwzUFEljhC3urdjal
	 kKP0vxdGFI7FzzHDP09Pbfzo82lGBgASNMzQv90un3u4N5cPZ5Kdv2crRovjEd2bXT
	 ilwEXzb35Xx8vr/nDNXS9EE7oj5LmRtszI4k6VR1kJuxf5q8AetvlOIvWFn3Ad+X/X
	 5lvDy42l1Mgig==
Date: Fri, 28 Feb 2025 07:58:24 -0700
From: Keith Busch <kbusch@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Lei Yang <leiyang@redhat.com>, Keith Busch <kbusch@meta.com>,
	pbonzini@redhat.com, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, x86@kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCHv3 0/2]
Message-ID: <Z8HPENTMF5xZikVd@kbusch-mbp>
References: <20250227230631.303431-1-kbusch@meta.com>
 <CAPpAL=zmMXRLDSqe6cPSHoe51=R5GdY0vLJHHuXLarcFqsUHMQ@mail.gmail.com>
 <Z8HE-Ou-_9dTlGqf@google.com>
 <Z8HJD3m6YyCPrFMR@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8HJD3m6YyCPrFMR@google.com>

On Fri, Feb 28, 2025 at 06:32:47AM -0800, Sean Christopherson wrote:
> On Fri, Feb 28, 2025, Sean Christopherson wrote:
> > On Fri, Feb 28, 2025, Lei Yang wrote:
> > > Hi Keith
> > > 
> > > V3 introduced a new bug, the following error messages from qemu output
> > > after applying this patch to boot up a guest.
> > 
> > Doh, my bug.  Not yet tested, but this should fix things.  Assuming it does, I'll
> > post a v3 so I can add my SoB.
>          v4
> 
> Confirmed that it worked, but deleting the pre-mutex check for ONCE_COMPLETED.
> Will post v4 later today.
> 
> > diff --git a/include/linux/call_once.h b/include/linux/call_once.h
> > index ddcfd91493ea..b053f4701c94 100644
> > --- a/include/linux/call_once.h
> > +++ b/include/linux/call_once.h
> > @@ -35,10 +35,12 @@ static inline int call_once(struct once *once, int (*cb)(struct once *))
> >                 return 0;
> >  
> >          guard(mutex)(&once->lock);
> > -        WARN_ON(atomic_read(&once->state) == ONCE_RUNNING);
> > -        if (atomic_read(&once->state) != ONCE_NOT_STARTED)
> > +        if (WARN_ON(atomic_read(&once->state) == ONCE_RUNNING))
> >                  return -EINVAL;
> >  
> > +        if (atomic_read(&once->state) == ONCE_COMPLETED)
> > +                return 0;
> > +
> >          atomic_set(&once->state, ONCE_RUNNING);
> >         r = cb(once);
> >         if (r)

Possible suggestion since it seems odd to do an atomic_read twice on the
same value. Maybe make this a switch:

	switch (atomic_read(&once->state) {
	case ONCE_NOT_STARTED:
		atomic_set(&once->state, ONCE_RUNNING);
		break;
	case ONCE_COMPLETED:
		return 0;
	case ONCE_RUNNING:
	default:
		WARN_ON(1);
		return -EINVAL;
	} 

