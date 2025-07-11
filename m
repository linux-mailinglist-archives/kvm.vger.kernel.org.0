Return-Path: <kvm+bounces-52222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 67DECB02798
	for <lists+kvm@lfdr.de>; Sat, 12 Jul 2025 01:20:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 797831CA783D
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 23:20:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B96D223339;
	Fri, 11 Jul 2025 23:20:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86E3EB665;
	Fri, 11 Jul 2025 23:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.228.1.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752276019; cv=none; b=kJyDyTQQbCtyRqOegYQ2qRxFaUAO8jY7v3gwFPENdXug3Ka5IDWJI56aVjW08w1pmLRV9hmROuN3SN6n483oRpSRmuJxgO/GBtJrhFxsOpiv+zqiYqE02Hg42qf2s74m0LWxTFRkxRG+WQVAQ6ejcOVUBwUBvC3p9au7jvZS2d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752276019; c=relaxed/simple;
	bh=pNsFVG/FLnwtKUkOiwlrea6wLLnXFQVnlBGzsZkNWpA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G1/UDjbXOqMYoA7j2yH02ROC7lawquNrrXwsmRzV4RiTyV78dPn0GQuLICBOVLZa/ZslL3GNR2f97UV1ULHfftKE+yYWHukK8qeOieo9SHT1siEX81TI8xrgCxy/ZW3mLI4OtuqrVT8yXqOZCl+8nq82KJqYXfV3koSMs+c/IaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org; spf=pass smtp.mailfrom=kernel.crashing.org; arc=none smtp.client-ip=63.228.1.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.crashing.org
Received: from gate.crashing.org (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 56BNJptK624605;
	Fri, 11 Jul 2025 18:19:51 -0500
Received: (from segher@localhost)
	by gate.crashing.org (8.18.1/8.18.1/Submit) id 56BNJjtJ624601;
	Fri, 11 Jul 2025 18:19:45 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date: Fri, 11 Jul 2025 18:19:45 -0500
From: Segher Boessenkool <segher@kernel.crashing.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Huth <thuth@redhat.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-spdx@vger.kernel.org
Subject: Re: [PATCH v2] powerpc: Replace the obsolete address of the FSF
Message-ID: <aHGcEdTmhlsfx7Tz@gate>
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

Almost.  It is called the "GCC Runtime Library Exception", and it is
about a lot more than libgcc, although that of course is one of the most
important things it covers :-)

Not linking to libgcc is a foolish thing btw.  The main reason for it
originally is to not have long divisions in the kernel (for x86
anyway!), but not using libgcc is neither sufficient nor necessary for
that goal.


Segher

