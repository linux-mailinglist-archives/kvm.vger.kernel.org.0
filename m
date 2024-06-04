Return-Path: <kvm+bounces-18784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 514218FB3E7
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 15:36:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05233282B6F
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 13:36:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E24EB1474BC;
	Tue,  4 Jun 2024 13:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="c5MUdjtS"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32CF3EA9A
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 13:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717508179; cv=none; b=QV9s04Rkpopriv99LIZmwwfxkyaRxlKay+9NS7t4FHedPAA46Ro0HB/q9tHsxn4NSSc/qv8zAV8P2q+TzvUHXABq94BVYjyRDWe8jJR2z6xYgr/wWrot7HfqQWILSJNp5/LJpEnYyDnnRH86vKk3maSJBtyzQxwVNm8pbM6ehrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717508179; c=relaxed/simple;
	bh=6IcyTfeydHmY/psnH6EEWDj1V6WjkeXiXwT9MO193NI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i4Z/ZbWn9qBX9rDGWro7p/tKNCxmPsxqcVQYIyTzAfJBXN+icVl+MmmiMzM08sloAp0sr0Jn747v3SKH/sLKMxF5B748hbI5bO6z9SGOn95qQrMfn98DajUrp1s+57uNzOfgfiwIBMzYPh2wrwWdXgh/BDzU7+Dp7X8G444Euu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=c5MUdjtS; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: thuth@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717508174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VSUx8HBtycvTGXY09hNGvaNW48lkTHHSidcjdBZAQTA=;
	b=c5MUdjtSaSzL5wKb5gCPz/p8gGG3ZAhHmjp+GUfKQDpd5pdZ4tj9/WgMAr0kqKU3O/sFP/
	NBA8AW7g3JY5hnVjZXuTOGt4vF3EgHjI6dd4S8tdD+w7fRoXSCuVqJVR24bTZLUZji7/hi
	Xs9cqC3hGjkj5SkThrbCniW4BS61m4U=
X-Envelope-To: npiggin@gmail.com
X-Envelope-To: lvivier@redhat.com
X-Envelope-To: linuxppc-dev@lists.ozlabs.org
X-Envelope-To: kvm@vger.kernel.org
Date: Tue, 4 Jun 2024 15:36:10 +0200
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>, 
	Laurent Vivier <lvivier@redhat.com>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v9 29/31] powerpc: Remove remnants of
 ppc64 directory and build structure
Message-ID: <20240604-92e3b6502a920717bec7d780@orel>
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-30-npiggin@gmail.com>
 <15d6ae85-a46e-4a99-a3b9-6aa6420e0639@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15d6ae85-a46e-4a99-a3b9-6aa6420e0639@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 04, 2024 at 12:49:51PM GMT, Thomas Huth wrote:
> On 04/05/2024 14.28, Nicholas Piggin wrote:
> > This moves merges ppc64 directories and files into powerpc, and
> > merges the 3 makefiles into one.
> > 
> > The configure --arch=powerpc option is aliased to ppc64 for
> > good measure.
> > 
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> ...
> > diff --git a/powerpc/Makefile b/powerpc/Makefile
> > index 8a007ab54..e4b5312a2 100644
> > --- a/powerpc/Makefile
> > +++ b/powerpc/Makefile
> > @@ -1 +1,111 @@
> > -include $(SRCDIR)/$(TEST_DIR)/Makefile.$(ARCH)
> > +#
> > +# powerpc makefile
> > +#
> > +# Authors: Andrew Jones <drjones@redhat.com>
> 
> I'd maybe drop that e-mail address now since it it not valid anymore.
> Andrew, do want to see your new mail address here?

No need to change to my new email address. We can either keep it as is for
historical records, and as part of faithful code move, or just drop it.

Thanks,
drew

> 
> Apart from that:
> Acked-by: Thomas Huth <thuth@redhat.com>
> 

