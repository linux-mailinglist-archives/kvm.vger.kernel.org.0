Return-Path: <kvm+bounces-33530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 733A89EDA86
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 23:59:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 372AE167B93
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 22:59:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C12C31F0E59;
	Wed, 11 Dec 2024 22:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WaW+15dg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12CD1BC085;
	Wed, 11 Dec 2024 22:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733957978; cv=none; b=BjtrPMFBHtu/khAFP9a6OC52EvxmDdI0/HDXZPbWNa0pOEgMpCwD4u6qWB/Xdqyco3aPFtp1DVaY9mNuO9zJw6XIrJ5hIJRbjdSh5Us0LxNoXBzwQ8JAuGpKtsrMeIGLdzWIlBUh0qZm4b3O1R6pMnJpjbSsp27Az4vBXk70KSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733957978; c=relaxed/simple;
	bh=ba8OhYJWZ7/RdSdR8zo6eTaxvZtkyE7pWbYivefWwDo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k6Lj7y3ivRb1p+jom7HfSLubWS4Nzgp80mDWPJ255dgyKmJU5+PUAqjyBdst2H41eqNUI5bBHZd7HOPFOx46BoV0LHklq8KAJOSEz0XUXlCU6okAl1/Z2P5yKyBYxG1+w462NUxf/y2ZAsAXpxCBP89rwOiX8yNJoWYh7H3Banc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WaW+15dg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544C4C4CED2;
	Wed, 11 Dec 2024 22:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733957977;
	bh=ba8OhYJWZ7/RdSdR8zo6eTaxvZtkyE7pWbYivefWwDo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WaW+15dgE5AhR7mM92AiA6N5aJE7lkhwrwK16HZxjs4UoJDius5M1h9sMsfQmFYRJ
	 k4G+vsfFOATgIp4A9IWmEDFXj2uAEANp3yfKGYKxdInMn8EgftnquPb91kaVHKroiW
	 ro09RxLYMw8dcZu/Ii/Ny2j9diSMfFbubvjCkbampS7gmb5oXyIHzZ3HezADhQxLsJ
	 kLtQmKUCKChmXo1gLDb5N9G6fk88uyjFB1OdDva8/FHvdXnzTcnimD5ILgDGNoI//6
	 Mvq/J5aBVmgX0czKCB9R0vqUxmSaexbQItgIfnNj3BUQUqlWpcYI61Sjqn3U+6acYH
	 upCxWWuLsTdGg==
Date: Wed, 11 Dec 2024 22:59:32 +0000
From: Will Deacon <will@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: julien.thierry.kdev@gmail.com, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, apatel@ventanamicro.com,
	andre.przywara@arm.com, suzuki.poulose@arm.com,
	s.abdollahi22@imperial.ac.uk
Subject: Re: [PATCH RESEND kvmtool 0/4] arm: Payload memory layout change
Message-ID: <20241211225931.GC17836@willie-the-truck>
References: <20241128151246.10858-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241128151246.10858-1-alexandru.elisei@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Nov 28, 2024 at 03:12:42PM +0000, Alexandru Elisei wrote:
> (resending because I accidently only sent the cover letter, sorry for that)
> 
> The first 3 patches are fixes to kvm__arch_load_kernel_image(). I've CC'ed
> the riscv maintainer because it looks to me like riscv is similarly
> affected.
> 
> Patch #4 ("arm64: Increase the payload memory region size to 512MB") might
> be controversial. Follows a bug report I received from Abdollahi Sina in
> private. Details in the commit message, but the gist of the patch is that
> the memory region where kernel + initrd + DTB are copied to are changed
> from 256MB to 512MB.  As a result, the DTB and initrd are moved from below
> ram_start + 256MB to ram_start + 512MB to accomodate a larger initrd.  If
> users rely on finding the DTB and initrd at the current addresses, then I'm
> not sure the patch is justified - after all, if someone really wants to use
> such a large initrd instead of a disk image with virtio, then replacing
> SZ_256M with SZ_512M locally doesn't look like a big ask.
> 
> On the other hand, if there are no users that rely on the current payload
> layout, increasing the memory region size to 512MB to allow for more
> unusual use cases, while still maintaining compatibility with older
> kernels, doesn't seem unreasonable to me.
> 
> Please comment, I don't feel strongly either way - I'll happy drop the last
> patch if there are objections.

Well, I won't reject an imperial.ac.uk patch on a hunch, so let's go for
the whole lot and see if anybody complains!

I'll fix the indentation issue spotted by Drew when applying (thanks!).

Will

