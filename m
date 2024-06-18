Return-Path: <kvm+bounces-19885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96D7D90DB5B
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 20:11:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4AF30284B8F
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 18:10:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C6C7156F28;
	Tue, 18 Jun 2024 18:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LlQyohxC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A268C156C6B;
	Tue, 18 Jun 2024 18:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718734253; cv=none; b=FUt60zNxDhr8BQK/GeKTDn3048kgGv/Z9+jhztfFkqK1IM1nowUjFjJ+tljMw3Mu81D0Z+zVWPtpV/0gOy1wib7saIY+HUcM+QYuCIt9vZWCPukbMYJp0yTWeUgZ24BYlDnieapm+20/MXilS/e3Lv2GMarNpEhBlT9JrFtdntA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718734253; c=relaxed/simple;
	bh=dT9cx4s4K2QikyYPXndnE3ihQA4tXeqBMMlxOaR8QqY=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=O+xEA+jrQQsAh+7fbGbbPGj/0nrZlrrgsHLdHPCK+qBpowJNhqPzb05hegCj6Pa//Ak1m3EJW1bvWqY61B4cMLPdKCW/s5u3uKZNnUSKdo0M6Ho1dO/mrh0hbTlq8Vbu0o0pVrTcmfperB0TvRbIF/zUdvd6c1j2CHOsWWGUjdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LlQyohxC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FEE5C4AF1A;
	Tue, 18 Jun 2024 18:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718734253;
	bh=dT9cx4s4K2QikyYPXndnE3ihQA4tXeqBMMlxOaR8QqY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=LlQyohxCPdvTfGt/WAxuy+wi5mpV23i4Lj6BqkLTrGIHFyxuD2rcbhlBZgvyGFjoj
	 XeO0PT0YnDUV3cnN2zgmZt0NIgD0k/nPO9DKKgLcS3XsWSttM0CguqWu50z+TU/Mux
	 50MGraGkZRlNpNU8r8Cn7xolgDIFeKID4nHyGDHjf/JXKcNrXxT6/GxDHGDfylq+GJ
	 4lCv4efOTCLNZdYqgC1r8tcMbFBDCC0skD1QBgf4OzgDEuLTU0IgP/kqi7GIC7IUVH
	 mcQGpdEv9AeBGnrH0/nPU5G4EPSrklGxHWfAMj/uABpd1XfWjiZsguCyEoM20Hfm9U
	 Nx7Ri3SVRVtiw==
Received: from disco-boy.misterjones.org ([217.182.43.188] helo=www.loen.fr)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sJdIA-0054wk-Re;
	Tue, 18 Jun 2024 19:10:50 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 18 Jun 2024 19:10:50 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alexander Potapenko <glider@google.com>, Oliver Upton
 <oliver.upton@linux.dev>, Sudeep Holla <sudeep.holla@arm.com>, Vincent
 Donnefort <vdonnefort@google.com>, James Morse <james.morse@arm.com>, Suzuki
 K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.10, take #2
In-Reply-To: <20240611184839.2382457-1-maz@kernel.org>
References: <20240611184839.2382457-1-maz@kernel.org>
User-Agent: Roundcube Webmail/1.4.15
Message-ID: <6e41454538b8c1e6a3900605af8328b1@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.182.43.188
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, glider@google.com, oliver.upton@linux.dev, sudeep.holla@arm.com, vdonnefort@google.com, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Hi Paolo,

On 2024-06-11 19:48, Marc Zyngier wrote:
> Paolo,
> 
> Here's a smaller set of fixes for 6.10. One vgic fix adressing a UAF,
> and a correctness fix for the pKVM FFA proxy.

Any update on this?

Thanks,

         M.

> 
> Please pull,
> 
>         M.
> 
> The following changes since commit 
> afb91f5f8ad7af172d993a34fde1947892408f53:
> 
>   KVM: arm64: Ensure that SME controls are disabled in protected mode
> (2024-06-04 15:06:33 +0100)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git
> tags/kvmarm-fixes-6.10-2
> 
> for you to fetch changes up to 
> d66e50beb91114f387bd798a371384b2a245e8cc:
> 
>   KVM: arm64: FFA: Release hyp rx buffer (2024-06-11 19:39:22 +0100)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.10, take #2
> 
> - Fix dangling references to a redistributor region if
>   the vgic was prematurely destroyed.
> 
> - Properly mark FFA buffers as released, ensuring that
>   both parties can make forward progress.
> 
> ----------------------------------------------------------------
> Marc Zyngier (1):
>       KVM: arm64: Disassociate vcpus from redistributor region on 
> teardown
> 
> Vincent Donnefort (1):
>       KVM: arm64: FFA: Release hyp rx buffer
> 
>  arch/arm64/kvm/hyp/nvhe/ffa.c      | 12 ++++++++++++
>  arch/arm64/kvm/vgic/vgic-init.c    |  2 +-
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 15 +++++++++++++--
>  arch/arm64/kvm/vgic/vgic.h         |  2 +-
>  4 files changed, 27 insertions(+), 4 deletions(-)

-- 
Jazz is not dead. It just smells funny...

