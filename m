Return-Path: <kvm+bounces-52220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA6E8B0278B
	for <lists+kvm@lfdr.de>; Sat, 12 Jul 2025 01:14:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3800B5A56DA
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 23:14:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2766022259A;
	Fri, 11 Jul 2025 23:14:21 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6926A1F2BAB;
	Fri, 11 Jul 2025 23:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.228.1.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752275660; cv=none; b=jTo8lY3JM6JEiyUh1cplp6QhPG6dU1/9QIcEfpt5y9EZYvVBqq+/OjAF4Jh1S9JS2Khy8FryI4WjTOpinywrnS+ZaspazZ3WGPgi3nvj9nQzNxptGOw8Z8Pn1UT3B2oEGdAEtBg5VOqqzgfOb7shPd3uw4Lc3BXD+spEct4JcZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752275660; c=relaxed/simple;
	bh=bFbJVZY43Jpn39tYWKXR9nU1JbUGappWLcKOMLT4sl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mWZ8UP0C7F7knLR+UEIvMMhyNfxRcIkIeJ5S/8ElBLzX6VhPtyqaJiaIv/vkow51nqeF+CdUeqE2H/CfW4WxXLNKtZOBIeslXr1AjYMws4niLRZUhc+P2FPonojp6fZktk7EqomY2Hmc4kdGYUiPlgzrVR7KXGqc3miD0U+83ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org; spf=pass smtp.mailfrom=kernel.crashing.org; arc=none smtp.client-ip=63.228.1.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.crashing.org
Received: from gate.crashing.org (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 56BND41k624388;
	Fri, 11 Jul 2025 18:13:04 -0500
Received: (from segher@localhost)
	by gate.crashing.org (8.18.1/8.18.1/Submit) id 56BND1e0624384;
	Fri, 11 Jul 2025 18:13:01 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date: Fri, 11 Jul 2025 18:13:01 -0500
From: Segher Boessenkool <segher@kernel.crashing.org>
To: Richard Fontana <rfontana@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@infradead.org>, Thomas Huth <thuth@redhat.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-spdx@vger.kernel.org,
        J Lovejoy <opensource@jilayne.com>
Subject: Re: [PATCH v2] powerpc: Replace the obsolete address of the FSF
Message-ID: <aHGafTZTcdlpw1gN@gate>
References: <20250711053509.194751-1-thuth@redhat.com>
 <2025071125-talon-clammy-4971@gregkh>
 <9f7242e8-1082-4a5d-bb6e-a80106d1b1f9@redhat.com>
 <2025071152-name-spoon-88e8@gregkh>
 <aHC-Ke2oLri_m7p6@infradead.org>
 <2025071119-important-convene-ab85@gregkh>
 <CAC1cPGx0Chmz3s+rd5AJAPNCuoyZX-AGC=hfp9JPAG_-H_J6vw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAC1cPGx0Chmz3s+rd5AJAPNCuoyZX-AGC=hfp9JPAG_-H_J6vw@mail.gmail.com>

On Fri, Jul 11, 2025 at 05:02:18PM -0400, Richard Fontana wrote:
> On Fri, Jul 11, 2025 at 3:38 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, Jul 11, 2025 at 12:32:57AM -0700, Christoph Hellwig wrote:
> > > On Fri, Jul 11, 2025 at 09:30:31AM +0200, Greg Kroah-Hartman wrote:
> > > > That's a crazy exception, and one that should probably be talked about
> > > > with the FSF to determine exactly what the SPDX lines should be.
> > >
> > > It is called the libgcc exception and has been around forever for the
> > > files in libgcc.a that a lot of these low-level kernel helpers were
> > > copied from as the kernel doesn't link libgcc.
> >
> > Ah, so it would be something like this exception:
> >         https://spdx.org/licenses/GCC-exception-2.0.html
> > but the wording doesn't seem to match.
> >
> > I'll let the license lawyers figure this out, thanks for the hint!
> 
> This one
> 
>  * In addition to the permissions in the GNU General Public License, the
>  * Free Software Foundation gives you unlimited permission to link the
>  * compiled version of this file with other programs, and to distribute
>  * those programs without any restriction coming from the use of this
>  * file.  (The General Public License restrictions do apply in other
>  * respects; for example, they cover modification of the file, and
>  * distribution when not linked into another program.)
> 
> is `GCC-exception-2.0`
> 
> while this one:
> 
>  *    As a special exception, if you link this library with files
>  *    compiled with GCC to produce an executable, this does not cause
>  *    the resulting executable to be covered by the GNU General Public License.
>  *    This exception does not however invalidate any other reasons why
>  *    the executable file might be covered by the GNU General Public License.
> 
> does not seem to be in the SPDX exception list. It is very similar to
> `GNU-compiler-exception` except it specifically mentions GCC instead
> of saying "a GNU compiler".

https://spdx.org/licenses/GNU-compiler-exception.html

is exactly this.


Segher

