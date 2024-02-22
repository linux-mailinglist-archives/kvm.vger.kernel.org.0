Return-Path: <kvm+bounces-9430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A8148602C3
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 20:37:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 31A87B28AAD
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 18:59:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE1531DFD9;
	Thu, 22 Feb 2024 18:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ANCs/h1r"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BD614B81D
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 18:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708628329; cv=none; b=PWqkh0Car6bJxjO62uC1N6if0spGRAPxMlh2/rmW9Epdr56c24LfEFFmYUIoJEqXbAn64Z+QdCSTJPm225zBv99qfI/hGWFcVnqq79rG/kQnDs4PAZx6YMHNIYWUTq5jHYlSmW3wvfc1W4HbgQwNVqbIvVcrpExRDw/AqsPY6zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708628329; c=relaxed/simple;
	bh=RAT48h2u3y3O5tYBBYYlc57OcpbSHfgGw0mrClbLdzc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nYIcoa2mz5tYScJp+g/7qrsNR/uR2HIaX3YlrKzGci0/eLL3CZyRFsJL7Zv6VzgXqSWDbmCSCtcH4pBBLh+LFTtjfxgu4aiazadVp/A1Nk7ZjqaCvv5ylWDBq8VocP9rJTWK/yvXAcgdwC+ZsqxxOnqEGXKvD6nr7qnX3+IQ99U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ANCs/h1r; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 22 Feb 2024 18:58:39 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708628324;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fXtbm9eYcFP/Qnaj9qL/VFl6ikfpqHd5JRVGugnAsRs=;
	b=ANCs/h1ri9pxP0KeNYrihg5GVv0VHUel8sBuQbI3aM2899NJMo3u2CIKJfyhr9Kxo7aXo3
	vdcLrXi7PBTvjOsZvDoH2eyLIsmTY65/YPJCmtDO/0pM7hEw3FSaSS9yNrmDwUWo0BhGc/
	07/w1+p57kfkPkl2Iqrj2cy6HX4VySQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Joey Gouly <joey.gouly@arm.com>,
	Christoffer Dall <cdall@cs.columbia.edu>, KVM <kvm@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the kvm-arm tree
Message-ID: <ZdeZX34HpANzWKXj@linux.dev>
References: <20240222220349.1889c728@canb.auug.org.au>
 <20240222111129.GA946362@e124191.cambridge.arm.com>
 <20240222224041.782761fd@canb.auug.org.au>
 <b9d9a871-ba64-4c13-a186-0c60adc8d245@redhat.com>
 <87frxka7ud.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87frxka7ud.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 22, 2024 at 02:31:38PM +0000, Marc Zyngier wrote:
> On Thu, 22 Feb 2024 13:11:59 +0000,
> Paolo Bonzini <pbonzini@redhat.com> wrote:
> > 
> > On 2/22/24 12:40, Stephen Rothwell wrote:
> > >> This fails because https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/commit/?id=fdd867fe9b32
> > >> added new fields to that register (ID_AA64DFR1_EL1)
> > >> 
> > >> and commit b80b701d5a6 ("KVM: arm64: Snapshot all non-zero RES0/RES1 sysreg fields for later checking")
> > >> took a snapshot of the fields, so the RES0 (reserved 0) bits don't match anymore.
> > >> 
> > >> Not sure how to resolve it in the git branches though.
> > > 
> > > Thanks.  I will apply this patch to the merge of the kvm-arm tree from
> > > tomorrow (and at the end of today's tree).
> > 
> > Marc, Oliver, can you get a topic branch from Catalin and friends for
> > this sysreg patch, and apply the fixup directly to the kvm-arm branch
> > in the merge commit?
> > 
> > Not _necessary_, as I can always ask Linus to do the fixup, but
> > generally he prefers to have this sorted out by the maintainers if it
> > is detected by linux-next.
> 
> I think that's not the correct thing to do at this time. I should have
> timed the introduction of these checks a bit later, after the merge
> window.
> 
> But more to the point, the proposed patch is also not the best thing
> to merge, because it hides that there is a discrepancy between what
> the architecture describes, and what KVM knows. I really want to know
> about it, or it will be yet another bug that we wont detect easily.
> Specially for ID_AA64DFR*_EL1 which are a bloody mine-field.
> 
> So I'd rather we make the check optional, and we'll play catch up for
> a bit longer. Something like the patch below.
> 
> Oliver, do you mind queuing this ASAP (also pushed out to my dev
> branch)?
> 
> Thanks,
> 
> 	M.
> 
> From 85d861a6ca055c7681c826c580e7c90d74c26ac5 Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Thu, 22 Feb 2024 14:12:09 +0000
> Subject: [PATCH] KVM: arm64: Make build-time check of RES0/RES1 bits optional
> 
> In order to ease the transition towards a state of absolute
> paranoia where all RES0/RES1 bits gets checked against what
> KVM know of them, make the checks optional and garded by a
> config symbol (CONFIG_KVM_ARM64_RES_BITS_PARANOIA) default to n.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Applied as commit 99101dda29e3 ("KVM: arm64: Make build-time check of
RES0/RES1 bits optional") on the kvmarm/next branch.

-- 
Thanks,
Oliver

