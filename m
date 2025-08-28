Return-Path: <kvm+bounces-56031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 72D2FB39428
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 08:49:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 96FC01C22C61
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 06:49:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A9CB2797A1;
	Thu, 28 Aug 2025 06:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="U2w5ixTg";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="IiydNowM"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FADC1F3B96;
	Thu, 28 Aug 2025 06:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756363726; cv=none; b=JoGNKF2kAqitWc1S+ZWD/GRnyNmiTacQYhPbYQdRK0XJdyCUERx73DQh2XRTw64H6AR0OG475YxI91DwesU/9Ab/rFpkLr25zT02BFIQb807ZiMQoC3HYWg8/Ulg/8WgFjZizHNYGXdGzcAe10Q/3qGQ34tPqjca3uiE1PfmBYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756363726; c=relaxed/simple;
	bh=w7FnD7146wVnQD9QJzGzTqFOBi/FQOVNfgQNXpdhqmc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TzFXtBWBmV78sZ9Dpm5o9iWsgpLPkWbI+heK8iL1QRQd6tAe/4rhievxTqKevYpRXlBSpvvIo/sgk3JSqNlyaUPPLvcyAK4qtxo+/2fZsrY78LPHgZo/Bj0b0ATyDjiT9XjjvhjG3iSLhZQ4cCTDrQx6aGNCtB2knEiJusDKow8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=U2w5ixTg; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=IiydNowM; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Date: Thu, 28 Aug 2025 08:48:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1756363722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6/jHY0vfu4GMSQ8pouxgtZETq0PwRLZOeTYTRkcKuB0=;
	b=U2w5ixTg7bIPxbAzJ084ukICiP7yEKF+Tt2FJeI5+TCcPe3TqHfZQjuZnULDEiWjRSenRE
	H1XCw28Mduw8PAR6kAo6oNQbP5adKlu+oCBfSLtYYBecxGSngeYkOmNFClhefDsZE/ODoF
	Z+QOSjjcEY0zPOW2HgR1JNJaHCUto1pg+XO5COAm/Tv2W1oC1IaQaYjRjHWfL3VwEQHHx9
	YOjrrNox1sk8/PHAE8n3fzN5nti0iYelHZzByWzRSDfSiK2GqN0NTayJ9BBALcCJeTWWl9
	AaiL3sj1t351lGePY0f7kOX7l/l3ePOVDjeXMAjmIMZC24o9RVuI/2dAqPqfaQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1756363722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6/jHY0vfu4GMSQ8pouxgtZETq0PwRLZOeTYTRkcKuB0=;
	b=IiydNowMllNcmVg+GducwRs8uvTqXawWAkw6baeC35bajJy9/8O+o4dQM0flAtlwR3zkVo
	RRIzGuFh/yrKqgBQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] vhost_task: Fix a bug where KVM wakes an exited
 task
Message-ID: <20250828064841.oOab1Z9K@linutronix.de>
References: <20250827194107.4142164-1-seanjc@google.com>
 <20250827201059.EmmdDFB_@linutronix.de>
 <aK-f45qszH2VEzV7@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aK-f45qszH2VEzV7@google.com>

On 2025-08-27 17:16:35 [-0700], Sean Christopherson wrote:
> Nice!  This fixes things too.  Either solution works for me.  Or maybe do both?
> Attempting to wake a task that vhost_task knows has exited (is exiting?) is a
> bit gross, but even with that hardening, guarding against UAF is very nice to
> have too.

I don't mind either way.
If this is requested I can submit a proper patch.

> Tested-by: Sean Christopherson <seanjc@google.com>

Sebastian

