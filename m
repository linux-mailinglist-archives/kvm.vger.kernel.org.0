Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2960B33F2A4
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 15:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbhCQOab (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 10:30:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:53752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231536AbhCQOaX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 10:30:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C3B864E13;
        Wed, 17 Mar 2021 14:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615991422;
        bh=UlkZsQXs/INZ7pDMa7O0/XSCqYnvaCwSyP15Y4oHfBQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hFx9pj3srcAi0u0CpljilC3snQR+d5s9R7a0k0W8ptjPW0eN4SEjapr+wS33FekVi
         XOzbYuLA/9gGsmJuv0LpFlDQHH89VheWLZb08wc3igTJit0iPaAdI+S7J9XJO0wOg8
         C83NhCElONH+N6hDeMGDyUG6GiI1PGjSOgDNEtoA9Ym7DsI3m5dgTdr7bzTQZhj0Ba
         OhuIV6ZREfoRWGJqEDevzYSLcrG0GbW8R22p1UV+HMmWJdMzr/vo2xP1Q7HFgwMpQ8
         EMX4rA5txr3B/Gg7lhydc6fuGBCia7u7m3tdS1llYXdnxDDl3FPvwh1LA8Ocm6Aehe
         12Xc8fVU1bm6w==
Date:   Wed, 17 Mar 2021 14:30:17 +0000
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, dave.martin@arm.com, daniel.kiss@arm.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        broonie@kernel.org, kernel-team@android.com
Subject: Re: [PATCH 01/10] KVM: arm64: Provide KVM's own save/restore SVE
 primitives
Message-ID: <20210317143016.GB5393@willie-the-truck>
References: <20210316101312.102925-1-maz@kernel.org>
 <20210316101312.102925-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316101312.102925-2-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 10:13:03AM +0000, Marc Zyngier wrote:
> as we are about to change the way KVM deals with SVE, provide
> KVM with its own save/restore SVE primitives.
> 
> No functional change intended.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/fpsimdmacros.h   |  2 ++
>  arch/arm64/include/asm/kvm_hyp.h        |  2 ++
>  arch/arm64/kvm/hyp/fpsimd.S             | 10 ++++++++++
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 10 +++++-----
>  4 files changed, 19 insertions(+), 5 deletions(-)

With the typo spotted by Quentin fixed:

Acked-by: Will Deacon <will@kernel.org>

Will
