Return-Path: <kvm+bounces-30186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C98039B7D05
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 15:36:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 19441B20B80
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 14:36:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 265F61A255A;
	Thu, 31 Oct 2024 14:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="QkxjHHWw";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="P2Pk2/hy"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2BD1A0BFA;
	Thu, 31 Oct 2024 14:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730385383; cv=none; b=R8wj6y/ZXul6TFDYhY5Sj7dKQeUI0EFAs1YT+xpVnm82EFavedMma5oO5jnNwq5meNPodfxmhyS3Wkrq+7171WpeWrN/KwRLmRu81IVJ+OH1eTpZoLU3dRh+Tg/81AFJWzSYa3H423cPYLkG55jvy72feL3gBwHcqHa11JesSAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730385383; c=relaxed/simple;
	bh=MlUBwT++RbBkyEa3T3TimRZQSnvqIO7eCYZnB8HFFJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FhzUjhRJzY9GmK63tHon7+Mq7KB5j+zqh6a8b9QkI99Ajsl+dn/bGB6pF1RtsyNwJW1EVqRNq/4yUCEKv0bJn1AGa1un3nXcDg0iFVZ7o1O+14oN6UGJe7iNww+Z3buIBRwf31Uob3ZmKY4sN+Fmb3NzU0dTg4cdkuo4T1fDOLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=QkxjHHWw; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=P2Pk2/hy; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Date: Thu, 31 Oct 2024 15:36:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1730385377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zFWtjZRQTdWduLAor0O9LykkVJ5XjmX1JLbKlMKlkpk=;
	b=QkxjHHWwmKJ1qdobe4I2Y+atw8qx+ISgFF1tjNZwtDSp0ORfysW1Jcz5dp7zR6Js79bRy0
	i226xrqs413mzDeBgw1jRomNbeGJzDtZ7nBO8IhD3ecS8/pVOatosqp4tnkxCAtEL79Rzw
	AOwBVAxC7aT6UbutjROR9VsFXnKPNja80g5Bbudr1qkS/7EXziQvg4/kUep7ghULm/MhJq
	CPy4J2UlWVH4QqRN7yanD/6ZWYAmHUF0rieqmdbhcgHGxoEUG6WmEKhoEtF+ZlJZVuiams
	KVYeGXjlzGMc6rW3IS9kkkUjYwTDunfgJIxnWdO+pv5552kLTu4iVR2YXuJ/EQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1730385377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zFWtjZRQTdWduLAor0O9LykkVJ5XjmX1JLbKlMKlkpk=;
	b=P2Pk2/hy3uejlXJUrAHf0UJ4GdC6Jir4eJmEy04sEuesJqD6RKJD3sEgNSp8aqGq+J/BLQ
	+Y3OU1IHoExp3wDQ==
From: Nam Cao <namcao@linutronix.de>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>,
	Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
	intel-gfx@lists.freedesktop.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
	Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	John Stultz <jstultz@google.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>, kvm@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 00/19] hrtimers: Consolidate hrtimer initialization -
 Part 1
Message-ID: <20241031143609.bX-WHDeK@linutronix.de>
References: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>

I just learned the hard way that git-send-email doesn't work for a .mbox
file including multiple emails. Sorry for the noises, please ignore this
one. I will resend it shortly.

On Thu, Oct 31, 2024 at 03:19:21PM +0100, Nam Cao wrote:
> This is a follow up to version 1, which can be found here:
> 
>     https://lore.kernel.org/lkml/cover.1729864615.git.namcao@linutronix.de/
> 
> hrtimers must be initialized with a hrtimer_init() variant, and after that
> the timer's callback function must be setup separately.
> 
> This seperate initialization is error prone and awkward to use. The
> seperate initialization is also problematic for a clean Rust abstraction.
> 
> A combined setup function like timer_setup() is less error prone and
> simpler to use.
> 
> This first part of the conversion provides:
> 
>   - a set of hrtimer_setup*() variants, which take the function pointer as
>     argument.
> 
>   - hrtimer_update_function() which allows to change the callback function
>     after initialization with the proper safety checks in place.
> 
>   - conversion of the hrtimer_init*_on_stack() variants
> 
>   - some minor cleanups
> 
> The remaining users will be converted in follow up series.
> 
> Most conversions were done with Coccinelle. See sematic patch below.
> 
> Changes versus v1:
>   - Open code kvm_xen_init_vcpu() (Sean)
>   - Drop the can/bcm patch (Oliver)
>   - Folded the removal of hrtimer_init_sleeper() (tglx)
>   - Update change logs and cover letter
> 
> The series applies on top of:
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
> 
> and is also available from git:
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/tglx/devel.git hrtimer-setup-part1-v2
> 
> Best regards,
> 
> Nam

