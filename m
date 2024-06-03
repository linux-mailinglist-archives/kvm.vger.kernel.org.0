Return-Path: <kvm+bounces-18673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 972378D856C
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 16:48:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59A122893C5
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 14:48:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B275F1304AF;
	Mon,  3 Jun 2024 14:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u9O7LWSE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7A683CCF;
	Mon,  3 Jun 2024 14:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717426094; cv=none; b=LGlt3I6DLKWp+8h8lWN3v1GSGxxa5jIPSBO5ttS80PBzpv6uJpOVz2oMhrcsRpO3Cn5a06WL+u9fw5wXwhU9z7Yu5JWVo0nwq3wcrqq7g/8WMClVuaIHHrvpo6Xxv+WdVlW6SEn2iWoI0kbefGWWFEWAkdgYiD557aRjawJF0Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717426094; c=relaxed/simple;
	bh=xwGJmu9SlDByMFEBw2+2znkb1UCEFJsO/NYkF0iLi88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uMaiQO4mzIrcAu6aQFRtHyfgXJTXsSUY3pg1NeNKpx1zk0YOUFYOnTbRbxKSnFO9lxs6uG0a7RhczqQ0GmUCh9pjop8eOgn8c89Nv/Qsx7DF/3OwpghveGVpGriQhC0fwFqJAFREf5n8qwkXRO3L/de/mMWOJsPqA6crHjrf/n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u9O7LWSE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D6AC2BD10;
	Mon,  3 Jun 2024 14:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717426093;
	bh=xwGJmu9SlDByMFEBw2+2znkb1UCEFJsO/NYkF0iLi88=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u9O7LWSEsZVIpSxOytjrDzW8s/QSrtPlgqRsgA55OaQpA46OK5C4zTZ+q6gsyRQsT
	 52NHRVuDbG4ydteWD8zOcFJdF/vm29R9+XVPBDoDE+a8itHby4HeQBrIHAP/AZujS5
	 iIgNqvS8hwEI+O4fSnvU6gSprlfO3Q16VXqTGSzdXFMWTVajiT/+fQRA4JORDapHLH
	 jciky5/A0yft6YY0BiVOmx/WR8DtWNBSnOqmsoHRjFxhGwEft9rLFLZcNQMhaSmQXp
	 x0tTPIL3qNbHSwFp7s1u5b77EkD+iUOcfsUKq9cTX2LkqYIIv9miGkjjZ5Lna2RoNN
	 YGEmjFjm86Cgg==
Date: Mon, 3 Jun 2024 15:48:08 +0100
From: Will Deacon <will@kernel.org>
To: =?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v4 11/13] KVM: arm64: Improve CONFIG_CFI_CLANG error
 message
Message-ID: <20240603144808.GL19151@willie-the-truck>
References: <20240529121251.1993135-1-ptosi@google.com>
 <20240529121251.1993135-12-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240529121251.1993135-12-ptosi@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, May 29, 2024 at 01:12:17PM +0100, Pierre-Clément Tosi wrote:
> For kCFI, the compiler encodes in the immediate of the BRK (which the
> CPU places in ESR_ELx) the indices of the two registers it used to hold
> (resp.) the function pointer and expected type. Therefore, the kCFI
> handler must be able to parse the contents of the register file at the
> point where the exception was triggered.
> 
> To achieve this, introduce a new hypervisor panic path that first stores
> the CPU context in the per-CPU kvm_hyp_ctxt before calling (directly or
> indirectly) hyp_panic() and execute it from all EL2 synchronous
> exception handlers i.e.
> 
> - call it directly in host_el2_sync_vect (__kvm_hyp_host_vector, EL2t&h)
> - call it directly in el2t_sync_invalid (__kvm_hyp_vector, EL2t)
> - set ELR_EL2 to it in el2_sync (__kvm_hyp_vector, EL2h), which ERETs
> 
> Teach hyp_panic() to decode the kCFI ESR and extract the target and type
> from the saved CPU context. In VHE, use that information to panic() with
> a specialized error message. In nVHE, only report it if the host (EL1)
> has access to the saved CPU context i.e. iff CONFIG_NVHE_EL2_DEBUG=y,
> which aligns with the behavior of CONFIG_PROTECTED_NVHE_STACKTRACE.
> 
> Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
> ---
>  arch/arm64/kvm/handle_exit.c            | 30 +++++++++++++++++++++++--
>  arch/arm64/kvm/hyp/entry.S              | 24 +++++++++++++++++++-
>  arch/arm64/kvm/hyp/hyp-entry.S          |  2 +-
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  4 ++--
>  arch/arm64/kvm/hyp/nvhe/host.S          |  2 +-
>  arch/arm64/kvm/hyp/vhe/switch.c         | 26 +++++++++++++++++++--
>  6 files changed, 79 insertions(+), 9 deletions(-)

This quite a lot of work just to print out some opaque type numbers
when CONFIG_NVHE_EL2_DEBUG=y. Is it really worth it? How would I use
this information to debug an otherwise undebuggable kcfi failure at EL2?

Will

