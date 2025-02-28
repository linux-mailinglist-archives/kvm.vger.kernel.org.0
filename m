Return-Path: <kvm+bounces-39737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E888DA49D9A
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 16:36:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 979123B3FFF
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 15:36:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C0A918C02E;
	Fri, 28 Feb 2025 15:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G9rhfNhB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384A01EF399;
	Fri, 28 Feb 2025 15:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740756998; cv=none; b=Tj//2uqz8zTLl/zvQP3QntBxzFP1nvmYhSJa9GD/3mMOGFB1gSU514lqw7nPhHKC4BaRaaJ3E0tyhEz2SNUFEe8Kf9eYENdnsxmxtJls/2xqbd13BAtVSOoBfooHWZkYEXyvqnUZ/+4R4pp9jOjEviYvKuRbjnPY2xsBziFnxlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740756998; c=relaxed/simple;
	bh=0BHUkJWFpnghyaPeISj4EtKqPcv1QB62037tl4RLY9w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VjgCcPc3jsDqvbqAGcpjQgIaniMaBVtApCVPUSnGpHbgbMVWyVkViAcADzjlZ72V7WkLPJAL8+xiK9sap4VSAFkhjiLj/RzqeyE6965i9CK8/xhLQlreuCdbX6+tMptvu4SIPjjA+HivgNYj1vMQ0CHomOmDYGtZv6K6KkC2psw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G9rhfNhB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9F2C4CED6;
	Fri, 28 Feb 2025 15:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740756997;
	bh=0BHUkJWFpnghyaPeISj4EtKqPcv1QB62037tl4RLY9w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G9rhfNhBEoddREC0iyUaFQve9fSKzfp6ZmUzRfg3zEWAOevtVzNj3fXcm+IoB+cAZ
	 Asiwz6+6zKi0WN5gby5wjxFghxMV2gbHEcBZyp3p/IHgfe6h/sLGMHsIC7BCO/7v7E
	 4w/SaG89E9xkBgI7PbMwlPrb+zotebyhkDbrCNHjtawJ6Ync5oNSR6q7Qb4ap8G8xz
	 9RxOs2AG8DI26Df4lVznHSqzh3R1/lDiwNn0mKd7MGdyDjgsk2C4wKTHlccQqPGaK0
	 6uLEKux82eplkj2TdH7aH6BZXXrqhhbKB5twaCtDm9wsyQJXXzR9hJDpONqA0jWw6C
	 0/8iDye9MyhsQ==
Date: Fri, 28 Feb 2025 08:36:34 -0700
From: Keith Busch <kbusch@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Lei Yang <leiyang@redhat.com>, Keith Busch <kbusch@meta.com>,
	pbonzini@redhat.com, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, x86@kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCHv3 0/2]
Message-ID: <Z8HYAtCxKD8-tfAP@kbusch-mbp>
References: <20250227230631.303431-1-kbusch@meta.com>
 <CAPpAL=zmMXRLDSqe6cPSHoe51=R5GdY0vLJHHuXLarcFqsUHMQ@mail.gmail.com>
 <Z8HE-Ou-_9dTlGqf@google.com>
 <Z8HJD3m6YyCPrFMR@google.com>
 <Z8HPENTMF5xZikVd@kbusch-mbp>
 <Z8HWab5J5O29xsJj@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8HWab5J5O29xsJj@google.com>

On Fri, Feb 28, 2025 at 07:29:45AM -0800, Sean Christopherson wrote:
> On Fri, Feb 28, 2025, Keith Busch wrote:
> > On Fri, Feb 28, 2025 at 06:32:47AM -0800, Sean Christopherson wrote:
> > > > @@ -35,10 +35,12 @@ static inline int call_once(struct once *once, int (*cb)(struct once *))
> > > >                 return 0;
> > > >  
> > > >          guard(mutex)(&once->lock);
> > > > -        WARN_ON(atomic_read(&once->state) == ONCE_RUNNING);
> > > > -        if (atomic_read(&once->state) != ONCE_NOT_STARTED)
> > > > +        if (WARN_ON(atomic_read(&once->state) == ONCE_RUNNING))
> > > >                  return -EINVAL;
> > > >  
> > > > +        if (atomic_read(&once->state) == ONCE_COMPLETED)
> > > > +                return 0;
> > > > +
> > > >          atomic_set(&once->state, ONCE_RUNNING);
> > > >         r = cb(once);
> > > >         if (r)
> > 
> > Possible suggestion since it seems odd to do an atomic_read twice on the
> > same value.
> 
> Yeah, good call.  At the risk of getting too cute, how about this?

Sure, that also looks good to me.

