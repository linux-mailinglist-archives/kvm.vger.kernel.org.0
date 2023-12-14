Return-Path: <kvm+bounces-4528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A576D8137B6
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 18:11:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D7C361C20E22
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 17:11:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DE1363DFF;
	Thu, 14 Dec 2023 17:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eQO/oAZc"
X-Original-To: kvm@vger.kernel.org
Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [IPv6:2001:41d0:1004:224b::af])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB9BD4E
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 09:11:26 -0800 (PST)
Date: Thu, 14 Dec 2023 17:11:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1702573885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z7KQyebLnTixJI+7HeEOxa3aIwOhIUy62//tcXLarcA=;
	b=eQO/oAZcgvq6R0r3lvE7/mtXOn8K/LZeYyr5WruA3hOZyK6lKh34CkDmm2beyE4oHY3uEs
	j+sKJRhrezWPn9lH4JrmhgS/8+AmJbgnhEMkW/+pzhR+8mMBAUYCPnvPG+DdJ3VtgYJj4k
	whPLSPId+LYxelegpcceWypPhGccd1Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	James Houghton <jthoughton@google.com>,
	Peter Xu <peterx@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Isaku Yamahata <isaku.yamahata@linux.intel.com>,
	David Matlack <dmatlack@google.com>,
	Yan Zhao <yan.y.zhao@intel.com>, Marc Zyngier <maz@kernel.org>,
	Michael Roth <michael.roth@amd.com>,
	Aaron Lewis <aaronlewis@google.com>
Subject: Re: [ANNOUNCE / RFC] PUCK Future Topics
Message-ID: <ZXs3OASFnic62LL6@linux.dev>
References: <20231214001753.779022-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214001753.779022-1-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Dec 13, 2023 at 04:17:53PM -0800, Sean Christopherson wrote:
> Hi all!  There are a handful of PUCK topics that I want to get scheduled, and
> would like your help/input in confirming attendance to ensure we reach critical
> mass.
> 
> If you are on the Cc, please confirm that you are willing and able to attend
> PUCK on the proposed/tentative date for any topics tagged with your name.  Or
> if you simply don't want to attend, I suppose that's a valid answer too. :-)
> 
> If you are not on the Cc but want to ensure that you can be present for a given
> topic, please speak up asap if you have a conflict.  I will do my best to
> accomodate everyone's schedules, and the more warning I get the easier that will
> be.
> 
> Note, the proposed schedule is largely arbitrary, I am not wedded to any
> particular order.  The only known conflict at this time is the guest_memfd()
> post-copy discussion can't land on Jan 10th.
> 
> Thanks!
> 
> 
> 2024.01.03 - Post-copy for guest_memfd()
>     Needs: David M, Paolo, Peter Xu, James, Oliver, Aaron
> 
> 2024.01.10 - Unified uAPI for protected VMs
>     Needs: Paolo, Isaku, Mike R
> 
> 2024.01.17 - Memtypes for non-coherent MDA
>     Needs: Paolo, Yan, Oliver, Marc, more ARM folks?

Can we move this one? I'm traveling 01.08-01.16 and really don't want
to miss this due to jetlag or travel delays.

-- 
Thanks,
Oliver

