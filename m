Return-Path: <kvm+bounces-52097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CE40B014D8
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 09:38:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4D2967B0639
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 07:37:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16D541F1534;
	Fri, 11 Jul 2025 07:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oi1lj1Ye"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD051EFF96;
	Fri, 11 Jul 2025 07:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752219527; cv=none; b=XdyW57KrrfqoUwHb7eumInfy9sLXWGjIwz6dfKqA+3wdyvdDA4PnTjxd/uSDsyApSIl9c4SaY7sVjnMCcR1zuGBz3zAuVhRcuw0zIyxeM+QFnTrNBz+sTC5w7GzUynNWtA82yeX4VLud14pdMoY/MUt2FAUbPn/nyNlVTH6MOLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752219527; c=relaxed/simple;
	bh=qBfAnNPFlJIvLFh79dRJlYctXmYnodTHUO9RBCiagGg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IY+TFrAzf/YarVaBImfT6s1OfFSkGH/9FBrTnSMTtmL0A8FaqBB5X2iq+c96GPv5g+/3C3juSrn9KnO/iwgs7WpU1L1nXIC09kD2dL8r532H1GaHUjp0sKuBRJYZ9HMkdA7ReDa5xNQM3WbCj0r2CcEznVUsoNQzyOk2358AQX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oi1lj1Ye; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586CEC4CEED;
	Fri, 11 Jul 2025 07:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752219525;
	bh=qBfAnNPFlJIvLFh79dRJlYctXmYnodTHUO9RBCiagGg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Oi1lj1Ye9Z7o1T1LwRuh0e+RHwXKmqPAc4qr087+696O6Zj6YB6UOvtzxC0Zk9RuD
	 b9wNyNfKdZIjrzeede/wPlhZDESnY9L7s0blVMHCWovinGzz+NRXB11J2ybr70uBZc
	 2IlZ+lst1GVXs5DJsu/yk2pY/6D0fTDbSGKrmNYU=
Date: Fri, 11 Jul 2025 09:38:43 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Thomas Huth <thuth@redhat.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-spdx@vger.kernel.org
Subject: Re: [PATCH v2] powerpc: Replace the obsolete address of the FSF
Message-ID: <2025071119-important-convene-ab85@gregkh>
References: <20250711053509.194751-1-thuth@redhat.com>
 <2025071125-talon-clammy-4971@gregkh>
 <9f7242e8-1082-4a5d-bb6e-a80106d1b1f9@redhat.com>
 <2025071152-name-spoon-88e8@gregkh>
 <aHC-Ke2oLri_m7p6@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHC-Ke2oLri_m7p6@infradead.org>

On Fri, Jul 11, 2025 at 12:32:57AM -0700, Christoph Hellwig wrote:
> On Fri, Jul 11, 2025 at 09:30:31AM +0200, Greg Kroah-Hartman wrote:
> > That's a crazy exception, and one that should probably be talked about
> > with the FSF to determine exactly what the SPDX lines should be.
> 
> It is called the libgcc exception and has been around forever for the
> files in libgcc.a that a lot of these low-level kernel helpers were
> copied from as the kernel doesn't link libgcc.

Ah, so it would be something like this exception:
	https://spdx.org/licenses/GCC-exception-2.0.html
but the wording doesn't seem to match.

I'll let the license lawyers figure this out, thanks for the hint!

greg k-h

