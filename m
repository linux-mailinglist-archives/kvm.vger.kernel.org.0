Return-Path: <kvm+bounces-18670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 458468D854C
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 16:42:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 89751B226E4
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 14:42:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35FB712FB16;
	Mon,  3 Jun 2024 14:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cEWRJjaW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8E782D8E;
	Mon,  3 Jun 2024 14:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717425747; cv=none; b=ABSvzNjzaEZ90vBGuX8/0E91B3281dRi0bfsAHpIUkKJ1EfcPfZZekmw5iUsy3o7Jetzh+hL6KjtSeDQ6TljG85wcZyemMTj1tW1EtvA41pV3BU4QqwvPoAsRX/MpkjG9nl2zv1v7a1T7bIuBP3O7Jv4AMZ4KCg5uWkLxTWkNyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717425747; c=relaxed/simple;
	bh=Gmc1MiEWtkSwKvWmVTgOqpoLoXTlM0acsbYghM7VDKo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZReLWAXnhFlALCJrLfGTtFFOpgIsuzYyRpmn2KZdVzI2hQKxsIW6dR7esd8KECu0AJb9kOIy9EIsJCc/8VDtBgMvyIuJyYRNsJoGnr6+uRTfHFuemvJDj06uw/S07rF61PZnKzQ5r4WooH577ctJAswUXO1jMuTyXc6hS/EA0+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cEWRJjaW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48617C2BD10;
	Mon,  3 Jun 2024 14:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717425745;
	bh=Gmc1MiEWtkSwKvWmVTgOqpoLoXTlM0acsbYghM7VDKo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cEWRJjaW7ueRZN2dxIzGRqLjAY5xm7DNLfZOXd5sQGAIDTdkm6PqW+ynUJkp6C5jV
	 6D4Kpa1FfCkibmrOaczQTJp69ZAcO8rKBytLyn7gV8Xi/6J7mh06VqXfktksIQS77T
	 75A66AhYTCGPd4LNJ2KYDYIwmyV+TmxAmrr0v0tppapa5IWwXcFvMWXfRuSGpOJmyL
	 4qMmxZHImycfVbqW9OLJaWvcudxNJUFITrR0aR8NAisdix+A59XjakSL1TBYIJ+JfU
	 /E/24iLpqSt3Nolc9uejmM8b0uzC8i7Tjy3lRg9BeDtY0ihUbpYdY+76AukJRcvRwL
	 6/0ZCaAs0OuEg==
Date: Mon, 3 Jun 2024 15:42:20 +0100
From: Will Deacon <will@kernel.org>
To: =?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v4 08/13] arm64: Introduce esr_comment() &
 esr_is_cfi_brk()
Message-ID: <20240603144220.GI19151@willie-the-truck>
References: <20240529121251.1993135-1-ptosi@google.com>
 <20240529121251.1993135-9-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240529121251.1993135-9-ptosi@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, May 29, 2024 at 01:12:14PM +0100, Pierre-Clément Tosi wrote:
> As it is already used in two places, move esr_comment() to a header for
> re-use, with a clearer name.
> 
> Introduce esr_is_cfi_brk() to detect kCFI BRK syndromes, currently used
> by early_brk64() but soon to be also used by hypervisor code.
> 
> Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
> ---
>  arch/arm64/include/asm/esr.h       | 11 +++++++++++
>  arch/arm64/kernel/debug-monitors.c |  4 +---
>  arch/arm64/kernel/traps.c          |  8 +++-----
>  arch/arm64/kvm/handle_exit.c       |  2 +-
>  4 files changed, 16 insertions(+), 9 deletions(-)

(nit: typo in subject, should be esr_brk_comment()).

With that fixed:

Acked-by: Will Deacon <will@kernel.org>

Will

