Return-Path: <kvm+bounces-31045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC1E19BF97E
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 23:52:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72EC72838E6
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 22:52:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B423220D4ED;
	Wed,  6 Nov 2024 22:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mUDBSZDd"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE46645
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 22:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730933558; cv=none; b=gi4aZealfveCg7LUFq6M+eyF+JDawMS6lsLD2BaVvD8gjDGN7HmYeXHxGA5vJRh2n0T5jLLKii+YC+HyPcmnJaaF1s/nYb5M7OVPV/AvZbAQa6QqHXN43MvaMIyR3OTOJ+A+5yQVFr+S6rE1IMXDIi8MQepGEAeyPdTCcSchWzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730933558; c=relaxed/simple;
	bh=uuz7SbLJh5rwabeWcw7hI2Z0MJrhaRiqCEA6omMvznE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UickOzIOu/rYD2Ay9iZ1jWcYo+iuOqBqlYIV46aNY90CyJhfEyBkIbhFScICL4hSXUYIZ4UAeJoUT3FTkUmzl+Xu6PB6lSE0o6WMoIA5GzMKcyL+qNqdSoYmqGwIrvxmbf7wqLWtzhpr4SV5jZQ8fR10eVgiRW/Z9zDGWA116xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mUDBSZDd; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 6 Nov 2024 14:52:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730933551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zz2TnWgWwHZ3O9SosK4mHLHopQ6lWxVj8xTq52jhUiU=;
	b=mUDBSZDduAnB8CzaCrWI+VBzcxXdKygP8DVR/UZ2Us9rTwQ8EDa+1AEGr3fLS9sel6cLCc
	+83Ie5t1aTbs/d5wFoMAFF3UMHYsFtWWWPOLrgZ0Tv1khnkuJ/mrpFWK1Q8ZXrEPjxWHRv
	1B3xNc7+nFoToah1PBW4sDk7NtXvo/4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Bernhard Kauer <bk@alpico.io>, kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86: Make the debugfs per VM optional
Message-ID: <ZyvzKsKlEYvtzI1X@linux.dev>
References: <20241023083237.184359-1-bk@alpico.io>
 <ZyUMlFSjNTJdQpU6@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyUMlFSjNTJdQpU6@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Nov 01, 2024 at 10:15:00AM -0700, Sean Christopherson wrote:
> On Wed, Oct 23, 2024, Bernhard Kauer wrote:
> > Creating a debugfs directory for each virtual machine is a suprisingly
> > costly operation as one has to synchronize multiple cores. However, short
> > living VMs seldom benefit from it.
> > 
> > Since there are valid use-cases we make this feature optional via a
> > module parameter. Disabling it saves 150us in the hello microbenchmark.
> > 
> > Signed-off-by: Bernhard Kauer <bk@alpico.io>
> > ---
> >  virt/kvm/kvm_main.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index a48861363649..760e39cf86a8 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -94,6 +94,9 @@ unsigned int halt_poll_ns_shrink = 2;
> >  module_param(halt_poll_ns_shrink, uint, 0644);
> >  EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
> >  
> > +bool debugfs_per_vm = true;
> > +module_param(debugfs_per_vm, bool, 0644);
> 
> I'm not opposed to letting userspace say "no debugfs for me", but I don't know
> that a module param is the right way to go.  It's obviously quite easy to
> implement and maintain (in code), but I'm mildly concerned that it'll have limited
> usefulness and/or lead to bad user experiences, e.g. because people turn off debugfs
> for startup latency without entirely realizing what they're sacrificing.

I'd be open to a Kconfig option that disables only KVM debugfs, assuming
there are people out there who want that *and* still need the rest of
debugfs facilities.

Even assuming well-intentioned userspace, a defensive user might want to
hide KVM's debugfs surfaces in case it exposed customer data.

Otherwise !CONFIG_DEBUG_FS would get the job done.

> One potentially terrible idea would be to setup debugfs asynchronously, so that
> the VM is runnable asap, but userspace still gets full debugfs information.  The
> two big wrinkles would be the vCPU debugfs creation and kvm_uevent_notify_change()
> (or at least the STATS_PATH event) would both need to be asynchronous as well.

Sounds like a pile o' bugs waiting to happen in a rather gently tested
part of the KVM, so hopefully we don't need to consider that route :)

-- 
Thanks,
Oliver

