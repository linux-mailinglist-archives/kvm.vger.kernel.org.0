Return-Path: <kvm+bounces-11951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FECE87D76C
	for <lists+kvm@lfdr.de>; Sat, 16 Mar 2024 00:50:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFDFB1C2150E
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 23:50:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 980555A4E9;
	Fri, 15 Mar 2024 23:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xAkLQNIl"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1D83D55D
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 23:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710546606; cv=none; b=swSu1laz01yhlwbT48CkApsqcUhmRDiCdEccPAY6gMMdTYdGgcX2BfEf2tFW6L1DmtKjoy7JVvwShrTf3QcJrMxPLdiul4G6eYgrnrczARoWzPycNPle81KIOWfyyI9wZ5fW6tbLS9aOtUkc/zyMDW3TO5kqSJ3C/mpUCfwe0HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710546606; c=relaxed/simple;
	bh=u41JPPyahwkcMdiBsvwuRdbUHkTF+A9NJXDUhpdTfhs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WaOEgQljFUMrrCiIucGhO4KnjlKNeU1llgeAibOzdZtoJs3ZpruYqRJg6qG9WwAK9TiLRQ/3wumctwQ62oKblU73BQWHZaYvQ803dPFlTc2AVyCMeOJBMsBE6SVkIvaQQyvFzF3D1ITs2765vZ0bkbM3r3J7LjNWVw3v0E/LSus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xAkLQNIl; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 15 Mar 2024 23:49:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710546602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lr24rmkLhK7P/svE1+lMLfVjjwDVOU98eR1CGgpk51U=;
	b=xAkLQNIlat+/VAjel51Vop2rV0HdaV0o3QB/f2L+ftfrd81C0PG1D4pNSPN70Tfqz/5mhQ
	IFD7W2M0jvmiHDHz6Rsdm8nHzKS4cK9wxKyX4lwrkcTbwO88bL/VNhrrqBrMG+ZD0UXO+k
	vN0qN9twfG56fQuTNW+4/yPMUlZisTY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM changes for Linux 6.9 merge window
Message-ID: <ZfTepXx_lsriEg5U@linux.dev>
References: <20240315174939.2530483-1-pbonzini@redhat.com>
 <CAHk-=whCvkhc8BbFOUf1ddOsgSGgEjwoKv77=HEY1UiVCydGqw@mail.gmail.com>
 <ZfTadCKIL7Ujxw3f@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfTadCKIL7Ujxw3f@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Fri, Mar 15, 2024 at 04:32:10PM -0700, Oliver Upton wrote:
> On Fri, Mar 15, 2024 at 03:28:29PM -0700, Linus Torvalds wrote:
> > The immediate cause of the failure is commit b80b701d5a67 ("KVM:
> > arm64: Snapshot all non-zero RES0/RES1 sysreg fields for later
> > checking") but I hope it worked at *some* point. I can't see how.
> 
> Looks like commit fdd867fe9b32 ("arm64/sysreg: Add register fields for
> ID_AA64DFR1_EL1") changed the register definition that tripped the
> BUILD_BUG_ON().
> 
> But it'd be *wildly* unfair to blame that, the KVM assertions are added
> out of fear of new register definitions breaking our sysreg emulation.
> 
> > I would guess / assume that commit cfc680bb04c5 ("arm64: sysreg: Add
> > layout for ID_AA64MMFR4_EL1") is also involved, but having recoiled in
> > horror from the awk script, I really can't even begin to guess at what
> > is going on.
> > 
> > Bringing in other people who hopefully can sort this out.
> 
> At this point I'm heavily biased towards just dropping the KVM checks
> for now than attempt a fix-forward. We can work things out better with
> arm64 folks next release.
> 
> So unless anyone screams, I say we revert:
> 
>   99101dda29e3 ("KVM: arm64: Make build-time check of RES0/RES1 bits optional")
>   891766581dea ("KVM: arm64: Add debugfs file for guest's ID registers")

Duh, that second one should actually be:

  b80b701d5a67 ("KVM: arm64: Snapshot all non-zero RES0/RES1 sysreg fields for later checking")

-- 
Thanks,
Oliver

