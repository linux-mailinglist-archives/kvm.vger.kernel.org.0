Return-Path: <kvm+bounces-63168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A4B69C5ADB4
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:57:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D07C54E91E4
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:51:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD25622425B;
	Fri, 14 Nov 2025 00:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Es0uZdzA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC6321254B;
	Fri, 14 Nov 2025 00:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763081510; cv=none; b=Lz4SZHs0jIP4u9K45Xqe9Kt0YtO0qdMmLjH9FB2KMJT7SOaIWMmO4M2r+FqAMJ+H0l7gVMD0/hrXDyMt/2CXLafBiTN40tMfHFVnTWhRMmYVfh2qGs5AnpVUEX5p1d4HzQoQzgEClgu+NCdySE+Lhvp4l20x8KFM5WR6G3nXIA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763081510; c=relaxed/simple;
	bh=QJ86ODYqgqxlHMa+YM3HW/LCfnPhZ3HHo69Oz3Edjoc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T0WZprWp9DqfBPuQWVH0t2Thpo/r1+rmF0xKK8LK7em5VU3nA9BMnrj4cSK5t+qLoBTUw7WVMg4tuA7/FRiZGji2bUweva3jDpCi3X8W/antJF0N70AY9BIrjxeSdLoNLJ36rk4eKSCATIcsAVmTqLDySukdNSiTO/uE6sFTfx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Es0uZdzA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4E8C16AAE;
	Fri, 14 Nov 2025 00:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763081509;
	bh=QJ86ODYqgqxlHMa+YM3HW/LCfnPhZ3HHo69Oz3Edjoc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Es0uZdzAGHkyljWPk2oI0H8KafeujGgbq/SMP3P7P48HsLkTvF0X0Cl3Cg72pMVPq
	 aoseRPEGD0nlx5jWGZNZhf7l4/HtA6NSWm1XX4mo7tDppbog10rALWhr4YY3G4r9eP
	 QR4WWu+p7nOgCUyK4h53oIFRQq/hRQun+2tIjdWDwvgf9/mwEDCfELDxfrnxHCfCQE
	 QeueAcR/3vPMssKw3vTQ2FeiSXT51jS6F3TA1uSAFnYcBeOzA7i32o3W25gQz368pw
	 BXpj80Vm2b4lyLUYr1cExCCjaJdomVLjnbuXF5Wo86RShx1EeHLuNxrSW7XlYuVb2o
	 ePhDD0NQ6btsw==
Date: Thu, 13 Nov 2025 19:51:32 -0500
From: Keith Busch <kbusch@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	chang.seok.bae@intel.com
Subject: Re: [PATCH 00/10] KVM: emulate: enable AVX moves
Message-ID: <aRZ9FHvDXmDJ-K39@kbusch-mbp>
References: <20251114003633.60689-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114003633.60689-1-pbonzini@redhat.com>

On Thu, Nov 13, 2025 at 07:36:23PM -0500, Paolo Bonzini wrote:
> Over a year ago, Keith Busch posted an RFC patch to enable VMOVDQA
> and VMOVDQU instructions in the KVM emulator.  The reason to do so
> is that people are using QEMU to emulate fancy devices whose drivers
> use those instructions with BARs that, on real hardware, would
> presumably support write combining.  These same people obviously
> would appreciate being able to use KVM instead of emulation, hence
> the request.

Thanks so much! We do still use this, so I'm happy to see this moving. I
know it's been some time in the making, but I can appreciate this is
pretty gnarly and the details are important. I will be happy to give
this a run through the emulation devices, though it may be another week
or so before I can give it a spin.

