Return-Path: <kvm+bounces-18937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B4E48FD284
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 18:10:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F1C2F1F2A3A8
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 16:10:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCB7B15351A;
	Wed,  5 Jun 2024 16:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ntmflBvK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2F86CDA1;
	Wed,  5 Jun 2024 16:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717603839; cv=none; b=DjYu0qlQQK9n3hlBDpsWDALf3wDSz0JRQuUMEeM0tKSSUvim28gnjALt1IiLglfoV+F9IzgYcRNAG31E1N3Xbhbj/AKFgl7Q9wV1WnoVFevwuxKd+NnWRM7ZDxOBPxVxVEuLRygzWoAlHKUvKFoc+n+0JfcmAXIZnnGh740+yOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717603839; c=relaxed/simple;
	bh=X5RZYapwOzHyVtyD+jrPDIxhEjidh1wFJDBAWgYemWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JNP9B4TvLJIu8WSEmLiHI79QgZfy+sf5X5kVJgbNbom0twmFhMGNtL6rkXxEQUUh4muqmDYYfUYcJ1p/Bm7myM46PDl5TT5z5qoAvj+IK2MzH+N5zXskVAUN4xRj6EzGpPWpwJzEFfcwHQuE6SE1GQ/49wP0oBM0+93LQypDxJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ntmflBvK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E782DC2BD11;
	Wed,  5 Jun 2024 16:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717603838;
	bh=X5RZYapwOzHyVtyD+jrPDIxhEjidh1wFJDBAWgYemWA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ntmflBvKFTXlT0X/B2Z7CDSlMkwUkkYRrKYpVpp4a3Y+OnfsyrEumUDkgVZW7WchY
	 c1piDTJ2Pq+ey2BLEH/IDujkg16zTaD+/W1LsZJMSJkDoqHiiKkbb01B+g9FMg6m9Y
	 KMH6Vd9V8NoZto08wRxT3dBnbbz2tUjwezi9rlGOmkCwiSDz1Mkf7mmJuMCcB/DAm3
	 Ukgj3Fir0MZITOZJ7YVeuyPtBc+sHK0UA8m3YY3soWENouGgmVb5B14vdAoI/eqDB5
	 g5qAesN8LhQaccWFiWamJitHdSVHc1Z4Qg/xqJ/FHLqgqLVKWK2E/r01fH1WrhSeow
	 VHQGpDXdMoVuw==
Date: Wed, 5 Jun 2024 17:10:33 +0100
From: Will Deacon <will@kernel.org>
To: =?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v4 05/13] KVM: arm64: Rename __guest_exit_panic
 __hyp_panic
Message-ID: <20240605161033.GB22199@willie-the-truck>
References: <20240529121251.1993135-1-ptosi@google.com>
 <20240529121251.1993135-6-ptosi@google.com>
 <20240603143424.GF19151@willie-the-truck>
 <42h74rlklrenekak6dzl6mpi2b37peir6o55tnawvvf3kt6idn@53svu2uxcxk5>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <42h74rlklrenekak6dzl6mpi2b37peir6o55tnawvvf3kt6idn@53svu2uxcxk5>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Jun 04, 2024 at 04:51:58PM +0100, Pierre-Clément Tosi wrote:
> On Mon, Jun 03, 2024 at 03:34:24PM +0100, Will Deacon wrote:
> > On Wed, May 29, 2024 at 01:12:11PM +0100, Pierre-Clément Tosi wrote:
> > > Use a name that expresses the fact that the routine might not exit
> > > through the guest but will always (directly or indirectly) end up
> > > executing hyp_panic().
> > > 
> > > Use CPU_LR_OFFSET to clarify that the routine returns to hyp_panic().
> > > 
> > > Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
> > > ---
> > >  arch/arm64/kvm/hyp/entry.S              | 6 +++---
> > >  arch/arm64/kvm/hyp/hyp-entry.S          | 2 +-
> > >  arch/arm64/kvm/hyp/include/hyp/switch.h | 4 ++--
> > >  arch/arm64/kvm/hyp/nvhe/host.S          | 4 ++--
> > >  4 files changed, 8 insertions(+), 8 deletions(-)
> > 
> > Hmm, I'm not sure about this. When is __guest_exit_panic() called outside
> > of guest context?
> 
> AFAICT, it is also called from
> 
> - the early __kvm_hyp_host_vector, installed by cpu_hyp_init_context()

Well, we've just agreed to remove that one :)

> - the flavors of __kvm_hyp_vector, installed by cpu_hyp_init_features()

cpu_hyp_init_features() doesn't actually plumb the vector into VBAR,
though, so I still think that __guest_exit_panic() is only reachable
in guest context.

> which start handling exceptions long before the first guest can even be spawned.

I don't see how :/

Will

