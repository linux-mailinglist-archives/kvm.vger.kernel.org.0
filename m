Return-Path: <kvm+bounces-52237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDADFB02D7C
	for <lists+kvm@lfdr.de>; Sun, 13 Jul 2025 00:48:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F32ABA458EA
	for <lists+kvm@lfdr.de>; Sat, 12 Jul 2025 22:48:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8289B22F39B;
	Sat, 12 Jul 2025 22:48:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91C064A1D;
	Sat, 12 Jul 2025 22:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.133.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752360508; cv=none; b=qVEPi0Io/eujCWFU5t6Xh5N9qGI6qr4C/53Pjsmfvqng8u7pbx01F9wTrkt3/xV9fDJBdsREzvTHEs8uy4eCiao0rEguUoAM1VKTC0gBHr2jksEpOlBmDmLebXS3U5CZGTTRl+rT2iVX20fAxRNc9sOJOI+o2ynqm0VYYL7yFlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752360508; c=relaxed/simple;
	bh=JbxKo7AIDufaUdxUBchbEMXE4FdUl7BQ7nHVx+21JhQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=SHnZ+TWgzJ66qOUQLgosNtP2EZVZMsFG83/YRCRZVNv1N8ahDjMoy/G6/A0xm2wgW331WfnfELpNhT1duvV+moW81donElavmyj9Qoa5iqXmIbm+UMlbUlrMC3D8F9HP+rVcdy/wHvgZJ+joOfVReT03qx3zUm00x7yZt1wP1SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk; spf=none smtp.mailfrom=orcam.me.uk; arc=none smtp.client-ip=78.133.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=orcam.me.uk
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 4FCC992009C; Sun, 13 Jul 2025 00:48:16 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 4196692009B;
	Sat, 12 Jul 2025 23:48:16 +0100 (BST)
Date: Sat, 12 Jul 2025 23:48:16 +0100 (BST)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Richard Fontana <rfontana@redhat.com>
cc: Segher Boessenkool <segher@kernel.crashing.org>, 
    Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
    Christoph Hellwig <hch@infradead.org>, Thomas Huth <thuth@redhat.com>, 
    Madhavan Srinivasan <maddy@linux.ibm.com>, 
    Michael Ellerman <mpe@ellerman.id.au>, 
    Thomas Gleixner <tglx@linutronix.de>, Nicholas Piggin <npiggin@gmail.com>, 
    Christophe Leroy <christophe.leroy@csgroup.eu>, 
    linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
    kvm@vger.kernel.org, linux-spdx@vger.kernel.org, 
    J Lovejoy <opensource@jilayne.com>
Subject: Re: [PATCH v2] powerpc: Replace the obsolete address of the FSF
In-Reply-To: <CAC1cPGzLK8w2e=vz3rgPwWBkqs_2estcbPJgXD-RRx4GjdcB+A@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.2507122332310.45111@angie.orcam.me.uk>
References: <20250711053509.194751-1-thuth@redhat.com> <2025071125-talon-clammy-4971@gregkh> <9f7242e8-1082-4a5d-bb6e-a80106d1b1f9@redhat.com> <2025071152-name-spoon-88e8@gregkh> <aHC-Ke2oLri_m7p6@infradead.org> <2025071119-important-convene-ab85@gregkh>
 <CAC1cPGx0Chmz3s+rd5AJAPNCuoyZX-AGC=hfp9JPAG_-H_J6vw@mail.gmail.com> <aHGafTZTcdlpw1gN@gate> <CAC1cPGzLK8w2e=vz3rgPwWBkqs_2estcbPJgXD-RRx4GjdcB+A@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Fri, 11 Jul 2025, Richard Fontana wrote:

> > > while this one:
> > >
> > >  *    As a special exception, if you link this library with files
> > >  *    compiled with GCC to produce an executable, this does not cause
> > >  *    the resulting executable to be covered by the GNU General Public License.
> > >  *    This exception does not however invalidate any other reasons why
> > >  *    the executable file might be covered by the GNU General Public License.
> > >
> > > does not seem to be in the SPDX exception list. It is very similar to
> > > `GNU-compiler-exception` except it specifically mentions GCC instead
> > > of saying "a GNU compiler".
> >
> > https://spdx.org/licenses/GNU-compiler-exception.html
> >
> > is exactly this.
> 
> No, because `GNU-compiler-exception` as defined here
> https://github.com/spdx/license-list-XML/blob/main/src/exceptions/GNU-compiler-exception.xml
> assumes use of the term "GCC" rather than "a GNU compiler".

 I don't know what the legal status of the statement referred is, however 
the original exception as published[1] by FSF says:

'"GCC" means a version of the GNU Compiler Collection, with or without 
modifications, governed by version 3 (or a specified later version) of the 
GNU General Public License (GPL) with the option of using any subsequent 
versions published by the FSF.'

which I think makes it clear that "GCC" is a collection of "GNU compilers" 
and therefore the two terms are synonymous to each other for the purpose 
of said exception (in the old days "GCC" stood for "GNU C Compiler", but 
the old meaning makes no sense anymore now that we have compilers for Ada, 
Fortran and many other languages included in GCC).

 NB up to date versions of CRT code refer to the exception as published 
rather than pasting an old version of its text:

'Under Section 7 of GPL version 3, you are granted additional
permissions described in the GCC Runtime Library Exception, version
3.1, as published by the Free Software Foundation.'

References:

[1] "GCC Runtime Library Exception", version 3.1, 
    <https://www.gnu.org/licenses/gcc-exception-3.1.html>

 FWIW,

  Maciej

