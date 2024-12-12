Return-Path: <kvm+bounces-33572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F75C9EE347
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 10:41:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFB272829D8
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 09:41:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B62920E71D;
	Thu, 12 Dec 2024 09:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="olGgcMgg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE9320E315;
	Thu, 12 Dec 2024 09:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733996494; cv=none; b=MIVlC99gyGzLbgSlWRaZ0R9xjJajsB9biomZk84AL7ACIrcFM+ui70PWU/jI1o6EZm+CHje134nJKpd5z/Su27GPy/GtsU2RZyMn/O8jlPP974koEiiC1MxcaVSfVchZ4787qgZZzrzUFC7ynxCrEXdnXG+mfc5LqfzwLp1SdS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733996494; c=relaxed/simple;
	bh=8T9YqQIGe01+p2hPomlifpNUHNh46GGlOzTjpfIdD7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DxzQs34j1hO0zhrKyb5ZK6nCn4cuQekVQQL/jWw/upzncWF9yZ2CovrqvPJ8ESKzA4nfN0KPBHBRiSgWP+wvFsywS23nlA8W9QxAPCAHNyfO7sa8/DZGc8tx2XFm7ZZEKfAlZ4LSLHjdTmpUZ4+tlpuGnCZdKtnmSJKDaJPfcPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=olGgcMgg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53F0C4CECE;
	Thu, 12 Dec 2024 09:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733996494;
	bh=8T9YqQIGe01+p2hPomlifpNUHNh46GGlOzTjpfIdD7o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=olGgcMggf0fE1LeSI76/UaPOD4ftsCZOroqJTEOGj9ippWzQmUy3icmHWXgt+n1hr
	 NrEveF/eWzKta86ruTjo/akhkLAWp6ktgL5enw2HyOdSlQkXOlR+oZlUQr3Cu2AL8G
	 k7819e9L+NedCTEbNku6Arlz0zh4rk/U2SnKV8VwxJBmH0xGtej74hu87oCbwcFxpv
	 ausS4U8ybsPMwi4Ts9fxSO8/y3fkbu6u3OYJLiTsYHgrfpmCfRyPPl3jZKGGPlfnw5
	 rgk5KsfvSXDEvRFKq6f1ceW7RUs41R4Ydi0GL8tlfiosLOMJi3EFfc5GPUt9uUTfxP
	 YFr+SF2N/1thg==
Date: Thu, 12 Dec 2024 09:41:28 +0000
From: Will Deacon <will@kernel.org>
To: julien.thierry.kdev@gmail.com, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Cc: catalin.marinas@arm.com, kernel-team@android.com, maz@kernel.org,
	oliver.upton@linux.dev, apatel@ventanamicro.com,
	andre.przywara@arm.com, suzuki.poulose@arm.com,
	s.abdollahi22@imperial.ac.uk
Subject: Re: [PATCH RESEND kvmtool 0/4] arm: Payload memory layout change
Message-ID: <20241212094127.GA18819@willie-the-truck>
References: <20241128151246.10858-1-alexandru.elisei@arm.com>
 <173395873873.2737640.3783988676491071650.b4-ty@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173395873873.2737640.3783988676491071650.b4-ty@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Dec 11, 2024 at 11:44:14PM +0000, Will Deacon wrote:
> On Thu, 28 Nov 2024 15:12:42 +0000, Alexandru Elisei wrote:
> > (resending because I accidently only sent the cover letter, sorry for that)
> > 
> > The first 3 patches are fixes to kvm__arch_load_kernel_image(). I've CC'ed
> > the riscv maintainer because it looks to me like riscv is similarly
> > affected.
> > 
> > Patch #4 ("arm64: Increase the payload memory region size to 512MB") might
> > be controversial. Follows a bug report I received from Abdollahi Sina in
> > private. Details in the commit message, but the gist of the patch is that
> > the memory region where kernel + initrd + DTB are copied to are changed
> > from 256MB to 512MB.  As a result, the DTB and initrd are moved from below
> > ram_start + 256MB to ram_start + 512MB to accomodate a larger initrd.  If
> > users rely on finding the DTB and initrd at the current addresses, then I'm
> > not sure the patch is justified - after all, if someone really wants to use
> > such a large initrd instead of a disk image with virtio, then replacing
> > SZ_256M with SZ_512M locally doesn't look like a big ask.
> > 
> > [...]
> 
> Applied to arm64 (sina), thanks!
> 
> [1/4] arm: Fix off-by-one errors when computing payload memory layout
>       https://git.kernel.org/arm64/c/167aa1e
> [2/4] arm: Check return value for host_to_guest_flat()
>       https://git.kernel.org/arm64/c/ca57fb6
> [3/4] arm64: Use the kernel header image_size when loading into memory
>       https://git.kernel.org/arm64/c/32345de
> [4/4] arm64: Increase the payload memory region size to 512MB
>       https://git.kernel.org/arm64/c/9b26a8e

Sorry, these links are all broken as I generated the thankyou note
against a testing branch. Rest assured that the changes are pushed to
the kvmtool.git:

https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git/

Will

