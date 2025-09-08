Return-Path: <kvm+bounces-56977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A6CDB48F60
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 15:25:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C751F7AA1E6
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 13:23:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6800330AD06;
	Mon,  8 Sep 2025 13:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vr6NNYXt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CE430ACF6;
	Mon,  8 Sep 2025 13:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757337923; cv=none; b=EYeACXoebL7ssuYfsCKYmSOO3HcL1gx4CuA9B2CY4XIrYwQ2e58fHX9Gkk+ip5Y3EE5IzU4IvSU3UuJkadnLQhJY+DTjdrIaKqvRDEJlZSMjKMUsfjchy9qN83pZlA/jOuj0HKW20pnONrDBQYlbaAvseIzbFUDCaaCxoLytawQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757337923; c=relaxed/simple;
	bh=y0jr9P2vLFUAvWYOjc4mNs3/bRNqNluga8F3APLirjo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dv+ugBCxm2Hhok5ktp0ygbRoWpkGTN6FqXMqZUlk/7be2zVaS1cpjtHLF3XATYjeTdpn2uqUBE9TK9OWPwFUhN8KgrAlI9Lv978mxt5HUCvy1wN58ByAfiwoF58jh8pi6NAQW8gJppzKZr47fQXY8F5cpCeQuCKZri6dYB1zq+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vr6NNYXt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3AFC4CEF1;
	Mon,  8 Sep 2025 13:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757337923;
	bh=y0jr9P2vLFUAvWYOjc4mNs3/bRNqNluga8F3APLirjo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Vr6NNYXtSMvOm43mYkK4BbzmIYBoKPdkU9UCjQZ+0w/ZLzC2wE8Y7EyhLYOY1NSD/
	 bsnAGDTWjq9FeBBjTDzrTUoHpOHXxdci5P+isp6jC7EXbn+AS16PqruQS2sbyXZ/7Y
	 ZErWBNFHKABgCi4qCYJokjrKdWfOKwf68TRpdC9gVeNeRT62lK/8EpY3wlwB93Xf7V
	 8CcG77wwixILtegnkWbsshU7y2zG2PLcfWdllk11gHXPVI26Jmrc4Qe7DgsqMl/b7b
	 +FxdqAmlQWEUKmBRuVMBX2aybmxLORtY3gUqTTQJEG5iWk1Z2+26mFrOE6wdIXRLWL
	 mxKKH6ARecZ7g==
Date: Mon, 8 Sep 2025 14:25:18 +0100
From: Will Deacon <will@kernel.org>
To: Andre Przywara <andre.przywara@arm.com>
Cc: Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvmtool v3 0/6] arm64: Nested virtualization support
Message-ID: <aL7ZPlm3kANwiWb3@willie-the-truck>
References: <20250729095745.3148294-1-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729095745.3148294-1-andre.przywara@arm.com>

Hi Andre,

On Tue, Jul 29, 2025 at 10:57:39AM +0100, Andre Przywara wrote:
> This is v3 of the nested virt support series, adjusting commit messages
> and adding a check that FEAT_E2H0 is really available.

Do you plan to respin this addressing Alexandru's outstanding comments?

Will

