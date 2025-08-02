Return-Path: <kvm+bounces-53869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AF97EB18B2F
	for <lists+kvm@lfdr.de>; Sat,  2 Aug 2025 09:57:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB77C1AA280A
	for <lists+kvm@lfdr.de>; Sat,  2 Aug 2025 07:57:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D406D1F5838;
	Sat,  2 Aug 2025 07:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nhSBPGfx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74126F53E;
	Sat,  2 Aug 2025 07:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754121422; cv=none; b=CznclfXHvHuWRNNnsmtbvrN40uhAMFyO4/CEsHnpxROcG5o2Mmz6J3VDAXrqkth3SeDt69grLShktRD6HPw3WS0eMkJQ9v63ssXluu3/596t1wqrrkQuX16q40Qhoi44rJk7usKJSuHEDKAksSaUGqJdnruNhwQS4gsozK5YbXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754121422; c=relaxed/simple;
	bh=2b5GbjigTte0LeO6C5rEvPFavIVvpcqgIf/OWOjQf8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PN8dVkDHLjyTEK4FAMJL66Ln24Su6GqPRHmZyipWKxqtt+GP/4ul0mnkpnCmYrdsTrLYRwngLLd/q6nb06jkBMUNZYyuiXpiwmHlRGo20tzbrcrjRC1++/SwhVVl4OwVMkXcWV/CINnR87lVXNDzWvBNg/HjzCXOoq6LwpSOINI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nhSBPGfx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144DAC4CEEF;
	Sat,  2 Aug 2025 07:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1754121421;
	bh=2b5GbjigTte0LeO6C5rEvPFavIVvpcqgIf/OWOjQf8s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nhSBPGfxGYn3Q9q7/YOAQcElYijIvLBrLa57QIvIX6HFYR7C5eIIuK5LoNEE97mpq
	 TeWk20WicxPaKDx/bXfMfI6Rnc2mkSGGkeZgcA8dGVZEjaiaJ8s6IQmWcRW4yhr0lE
	 bDdgbi0wqsPk3JRS4DBAlkBH/09Czo0P9z5KpqTU=
Date: Sat, 2 Aug 2025 08:56:57 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thomas Huth <thuth@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-spdx@vger.kernel.org
Subject: Re: [PATCH v2] arch/x86/kvm/ioapic: Remove license boilerplate with
 bad FSF address
Message-ID: <2025080228-easily-clanking-0ddd@gregkh>
References: <20250728152843.310260-1-thuth@redhat.com>
 <2025072819-bobcat-ragged-81a7@gregkh>
 <2025072818-revoke-eggnog-459a@gregkh>
 <bfe5477e-7340-468a-af3f-192adc451c2d@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfe5477e-7340-468a-af3f-192adc451c2d@redhat.com>

On Fri, Aug 01, 2025 at 01:26:43PM +0200, Thomas Huth wrote:
> On 28/07/2025 17.50, Greg Kroah-Hartman wrote:
> > On Mon, Jul 28, 2025 at 05:36:47PM +0200, Greg Kroah-Hartman wrote:
> > > On Mon, Jul 28, 2025 at 05:28:43PM +0200, Thomas Huth wrote:
> > > > From: Thomas Huth <thuth@redhat.com>
> > > > 
> > > > The Free Software Foundation does not reside in "59 Temple Place"
> > > > anymore, so we should not mention that address in the source code here.
> > > > But instead of updating the address to their current location, let's
> > > > rather drop the license boilerplate text here and use a proper SPDX
> > > > license identifier instead. The text talks about the "GNU *Lesser*
> > > > General Public License" and "any later version", so LGPL-2.1+ is the
> > > > right choice here.
> > > > 
> > > > Signed-off-by: Thomas Huth <thuth@redhat.com>
> > > > ---
> > > >   v2: Don't use the deprecated LGPL-2.1+ identifier
> > > 
> > > If you look at the LICENSES/preferred/LGPL-2.1 file, it says to use:
> > > 	SPDX-License-Identifier: LGPL-2.1+
> > > 
> > > as the kernel's SPDX level is older than you might think.
> > > 
> > > Also, doesn't the scripts/spdxcheck.pl tool object to the "or-later"
> > > when you run it on the tree with this change in it?
> > 
> > Ugh, sorry, no, it lists both, the tool should have been fine.  I was
> > reading the text of the file, not the headers at the top of it.  My
> > fault.
> 
> By the way, is there a reason why LICENSES/preferred/LGPL-2.1 suggests only
> the old variant:
> 
>   For 'GNU Lesser General Public License (LGPL) version 2.1 or any later
>   version' use:
>     SPDX-License-Identifier: LGPL-2.1+
> 
> ... while LICENSES/preferred/GPL-2.0 suggests both:
> 
>   For 'GNU General Public License (GPL) version 2 or any later version' use:
>     SPDX-License-Identifier: GPL-2.0+
>   or
>     SPDX-License-Identifier: GPL-2.0-or-later
> 
> That looks somewhat inconsistent to me... Should the LGPL files be updated?

If you want to, sure.  Odds are we don't have many LGPL files in the
tree for it to ever be noticed before.

thanks,

greg k-h

