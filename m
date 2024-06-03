Return-Path: <kvm+bounces-18667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BE6AA8D8526
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 16:34:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 579E3B26B55
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 14:34:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2968612F37C;
	Mon,  3 Jun 2024 14:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KuaiWfS+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5354312BF34;
	Mon,  3 Jun 2024 14:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717425269; cv=none; b=XBb+7tNoRPLCBX9G0n93X1FjIQBDmz0ELN14SjipJhUKCMMbtbd2l9+xvnY14LH2lw78yCDFeGzH0/1Pa1jyB41P2OmvIhk9Kl97+BH/Z8fAzjBylzL8vgTkSM94onSiY20r0P2vV0NNnr2mpv/RfrWgX+49clWdtD63SMaimyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717425269; c=relaxed/simple;
	bh=xROsdANeWEUIRIQab77AFtYi7nZRvmAmeUTwKdOP+2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ULSLk6zr8N3bZba1muXxpqqlotwLZlnK5X4rtVlQN6ShZjrlJCBk7xGK8B0NPu+NoO0D6KjGQljBlXhL71rYzatG8voVPjI1NLVV4fiWWIoAASHg4DdJHCJLq7LtFEC0u08t+xYH9v6zsEHpIxm9LzaWeZG/1Y6V/Nq5rTEa+Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KuaiWfS+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D88C2BD10;
	Mon,  3 Jun 2024 14:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717425268;
	bh=xROsdANeWEUIRIQab77AFtYi7nZRvmAmeUTwKdOP+2M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KuaiWfS+FwobmBNFzZv9zT4FJavn4uV4WC5JQUfOuFWxYdMclFDqyfVR+EfbIBZOc
	 9GE07jwCTtXoyO4xDomXkGkOtXnWt7Q1SFBbzpywPHNBN38tQZxN1CpbJe12DZ8Slt
	 BTN7Dl7mfxvgPMdNBn9uFqeBix4D/zCnm+49z0z094liS2YbVNIPpAfvgDe81sAh7F
	 QbC7sa5KYQEc8wRQujThd8kdS+2ZB9GG4fQ7YZZxdyNBuq/gGhuDtqzaw0pxNJ4B2L
	 2BqM2kOJzYsICSkH9Cz0iBhJJqSz/SmXlGGe4oOsu1hs5se1YE0n90+NRoyvmAZkBV
	 DppJ3Dqr7hW5g==
Date: Mon, 3 Jun 2024 15:34:24 +0100
From: Will Deacon <will@kernel.org>
To: =?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v4 05/13] KVM: arm64: Rename __guest_exit_panic
 __hyp_panic
Message-ID: <20240603143424.GF19151@willie-the-truck>
References: <20240529121251.1993135-1-ptosi@google.com>
 <20240529121251.1993135-6-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240529121251.1993135-6-ptosi@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, May 29, 2024 at 01:12:11PM +0100, Pierre-Clément Tosi wrote:
> Use a name that expresses the fact that the routine might not exit
> through the guest but will always (directly or indirectly) end up
> executing hyp_panic().
> 
> Use CPU_LR_OFFSET to clarify that the routine returns to hyp_panic().
> 
> Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
> ---
>  arch/arm64/kvm/hyp/entry.S              | 6 +++---
>  arch/arm64/kvm/hyp/hyp-entry.S          | 2 +-
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 4 ++--
>  arch/arm64/kvm/hyp/nvhe/host.S          | 4 ++--
>  4 files changed, 8 insertions(+), 8 deletions(-)

Hmm, I'm not sure about this. When is __guest_exit_panic() called outside
of guest context?

Will

