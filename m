Return-Path: <kvm+bounces-39399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A4B13A46C3B
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 21:23:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 289F8188D1BA
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:23:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 000EE1527B4;
	Wed, 26 Feb 2025 20:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jY3iXqKo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06AC82755F8;
	Wed, 26 Feb 2025 20:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740601380; cv=none; b=CMYbl+cthitIp5D8G0EAqA+9C4t40/7pV5rintKXAEvkL5L4w7uhbQ/k5G2ZlHUwBxsA7m79m59R6/Mz/JNl2E+aQJ7WA3/w7yUb3Ih6fDuBnl0/u1EwzN9B/71FmI5tltLDi4uWbFSmWbiOLFNLdznXK2kpsEVQrjKFm3DTGgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740601380; c=relaxed/simple;
	bh=TJBTQ+3f/r8E//HQ2y4XUQ3h4sUT5Gyxz3ST2XBzFAk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DWVbp86OHWcx/cHmQdCaHVHaopBWRY96gRE13azoXWFm6RdtGYAtVCG+zmU2aSm+UIfHs8skdqyI/lEIHH5NXY5HFaoyA3zTtD6QL7Zu0rEkygQLusNzx60ZgoombCHssPz/v6FBC1mHoQ2F8n0MzdBC6falLAv10Tbiq+NpZD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jY3iXqKo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D35C4CED6;
	Wed, 26 Feb 2025 20:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740601379;
	bh=TJBTQ+3f/r8E//HQ2y4XUQ3h4sUT5Gyxz3ST2XBzFAk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jY3iXqKoHXG1erk4nCM4AlZYQBWahwN4LlG6pmgUcxhy5i83b0au1NWga1rL9ILNi
	 L4Is105br50nk+k+3rFi42AhkIHNwwPGHtrkSBZoRF2fid1T5E67eyoo7HBkVvK9/b
	 xIZVCWn8VOInaeq+osazYnsqkoR0/ovkWWngtE4JyBJb4xbZ6ONvopxuvB/BMcGDrV
	 05BkN2Wl5LvbwnuiDKvcdccjYjf3Cycfhu0Dd1/EP3YjvOnQEjVwGwjHsHV79yHBER
	 WzoehbMHPySvTOcSCcAZcroryAWs1ilcoXEIG7aCPDcljgtb5XFH7ARIwfY22lPbxq
	 likBPFT3gm4/w==
Date: Wed, 26 Feb 2025 13:22:56 -0700
From: Keith Busch <kbusch@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Keith Busch <kbusch@meta.com>, pbonzini@redhat.com, kvm@vger.kernel.org,
	x86@kernel.org, virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] kvm: retry nx_huge_page_recovery_thread creation
Message-ID: <Z794IJ_oalhkw7RQ@kbusch-mbp>
References: <20250226024304.1807955-1-kbusch@meta.com>
 <Z7919lMgDtbcl1CX@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7919lMgDtbcl1CX@google.com>

On Wed, Feb 26, 2025 at 12:13:42PM -0800, Sean Christopherson wrote:
> I much prefer my (misguided in the original context[*]) approach of marking the
> call_once() COMPLETED if and only if it succeeds.

I have a new appreciation for this approach given our recent
discoveries. I was mistaken in assuming there were no retryable errors
here.

Thanks for the suggestion, I'll merge your propsal with the kvm side and
give it a test.
 
> diff --git a/include/linux/call_once.h b/include/linux/call_once.h
> index 6261aa0b3fb0..9d47ed50139b 100644
> --- a/include/linux/call_once.h
> +++ b/include/linux/call_once.h
> @@ -26,20 +26,28 @@ do {									\
>  	__once_init((once), #once, &__key);				\
>  } while (0)
>  
> -static inline void call_once(struct once *once, void (*cb)(struct once *))
> +static inline int call_once(struct once *once, int (*cb)(struct once *))
>  {
> +        int r;
> +
>          /* Pairs with atomic_set_release() below.  */
>          if (atomic_read_acquire(&once->state) == ONCE_COMPLETED)
> -                return;
> +                return 0;
>  
>          guard(mutex)(&once->lock);
>          WARN_ON(atomic_read(&once->state) == ONCE_RUNNING);
>          if (atomic_read(&once->state) != ONCE_NOT_STARTED)
> -                return;
> +                return -EINVAL;
>  
>          atomic_set(&once->state, ONCE_RUNNING);
> -        cb(once);
> +        r = cb(once);
> +        if (r) {
> +                atomic_set(&once->state, ONCE_NOT_STARTED);
> +                return r;
> +        }
> +
>          atomic_set_release(&once->state, ONCE_COMPLETED);
> +        return 0;
>  }
>  
>  #endif /* _LINUX_CALL_ONCE_H */

