Return-Path: <kvm+bounces-5143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1005281CA97
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 14:16:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA45B1F24F1C
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 13:16:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B74D51946A;
	Fri, 22 Dec 2023 13:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gLrxkwIy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63B71863F;
	Fri, 22 Dec 2023 13:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5818AC433C9;
	Fri, 22 Dec 2023 13:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703251004;
	bh=R5+uHT4pcHdrCAdxbZ/IQlSrZrNoql0WdkZRb2O1vpg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=gLrxkwIykFNCsURQZcIHdasZMCeVk5eMwwva7gsmyJp4fLgIKQL9CacXjr8eQiwOx
	 776oA5fVk7P488vvwLj5zW86FLTOoTRwOZbpqX9ug89J1lr5op6RVlUIKBpoX7M+fi
	 yLJtZo69HRxSTef5ao0rWZ92PMLViFdwwUIB4/qORKK8OiM1s9FBYAau2D2kjol7RL
	 4hsoUvZLdCYwEKWzGz+FxiqCKq2NAsojD2kaAvWWSeMTfWmAXFJJwB9CTYTCvrl8xs
	 4nPU4S2hYirn3UJKn9+9KcHd+CHvI9C0xFf9K5g4PpIY3sXLFwzaKMz+b8nGsXms2Y
	 qXc8kYLY0oLEw==
Received: from disco-boy.misterjones.org ([217.182.43.188] helo=www.loen.fr)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rGfOL-006Jft-WD;
	Fri, 22 Dec 2023 13:16:42 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 22 Dec 2023 13:16:41 +0000
From: Marc Zyngier <maz@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini
 <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.7, part #2
In-Reply-To: <784ab26d-8919-4f08-8440-f66432458492@sirena.org.uk>
References: <ZYCaxOtefkuvBc3Z@thinky-boi>
 <784ab26d-8919-4f08-8440-f66432458492@sirena.org.uk>
User-Agent: Roundcube Webmail/1.4.15
Message-ID: <69259c81441a57ceebcffb0e16895db1@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.182.43.188
X-SA-Exim-Rcpt-To: broonie@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On 2023-12-22 13:09, Mark Brown wrote:
> On Mon, Dec 18, 2023 at 11:17:24AM -0800, Oliver Upton wrote:
> 
>> Here's the second batch of fixes for 6.7. Please note that this pull
>> is based on -rc4 instead of my first fixes tag as the KVM selftests
>> breakage was introduced by one of my changes that went through the
>> perf tree.
> 
> Any news on this?  The KVM selftests are still broken in mainline,
> pending-fixes and -next and the release is getting near.
> 
> Oliver, should your tree be in -next?

No, we don't have the KVM/arm64 fixes in -next.

And we have another two weeks to release, so ample amount of
time until Paolo picks up the PR.

         M.
-- 
Jazz is not dead. It just smells funny...

