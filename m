Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F103342D7
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 17:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbhCJQQU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 11:16:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:60808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230488AbhCJQPw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 11:15:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AD9A64EB3;
        Wed, 10 Mar 2021 16:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615392951;
        bh=kNwFxeumYsGSpw2tZpd8uXZkDF3dxJ63TdxKFdGfJmI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EvfmFsnWYLYmym8hKP8K/jALy31EtSLFyMYHdv5FOUFseEB6grWYnIJAsgoEWf926
         th+5IyPCQxysBE6egoC4iUwFRl6W+cie9Vr7CYE48t692crMhBDG4U+wTHWkTTzq3Q
         RMMTtvYfGw4BC9OWa7X9QWcGD1ws9hlpuWV6FsNu3NGfVOBqwa2vS0/Oj+4D5jAe96
         kc9T/xrih93VKyp1NOMcrJj3jZhVI2bBcY7AYtaosEwnyI/2hSYiqFZHYbGpqBIUG3
         yMdCXaUaWTL7jO6dtfI4jwlasM/MgXPEOxkX1p/P1HZrSreMWHiHRKNwsJ0cTR/lDm
         wmveAZ5pdj2dA==
Date:   Wed, 10 Mar 2021 16:15:47 +0000
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, qperret@google.com,
        kernel-team@android.com
Subject: Re: [PATCH 3/4] KVM: arm64: Rename SCTLR_ELx_FLAGS to SCTLR_EL2_FLAGS
Message-ID: <20210310161546.GC29834@willie-the-truck>
References: <20210310152656.3821253-1-maz@kernel.org>
 <20210310152656.3821253-4-maz@kernel.org>
 <20210310154625.GA29738@willie-the-truck>
 <874khjxade.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874khjxade.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 10, 2021 at 04:05:17PM +0000, Marc Zyngier wrote:
> On Wed, 10 Mar 2021 15:46:26 +0000,
> Will Deacon <will@kernel.org> wrote:
> > 
> > On Wed, Mar 10, 2021 at 03:26:55PM +0000, Marc Zyngier wrote:
> > > Only the nVHE EL2 code is using this define, so let's make it
> > > plain that it is EL2 only.
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/include/asm/sysreg.h    | 2 +-
> > >  arch/arm64/kvm/hyp/nvhe/hyp-init.S | 2 +-
> > >  2 files changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> > > index dfd4edbfe360..9d1aef631646 100644
> > > --- a/arch/arm64/include/asm/sysreg.h
> > > +++ b/arch/arm64/include/asm/sysreg.h
> > > @@ -579,7 +579,7 @@
> > >  #define SCTLR_ELx_A	(BIT(1))
> > >  #define SCTLR_ELx_M	(BIT(0))
> > >  
> > > -#define SCTLR_ELx_FLAGS	(SCTLR_ELx_M  | SCTLR_ELx_A | SCTLR_ELx_C | \
> > > +#define SCTLR_EL2_FLAGS	(SCTLR_ELx_M  | SCTLR_ELx_A | SCTLR_ELx_C | \
> > >  			 SCTLR_ELx_SA | SCTLR_ELx_I | SCTLR_ELx_IESB)
> > >  
> > >  /* SCTLR_EL2 specific flags. */
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > > index 4eb584ae13d9..7423f4d961a4 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > > @@ -122,7 +122,7 @@ alternative_else_nop_endif
> > >  	 * as well as the EE bit on BE. Drop the A flag since the compiler
> > >  	 * is allowed to generate unaligned accesses.
> > >  	 */
> > > -	mov_q	x0, (SCTLR_EL2_RES1 | (SCTLR_ELx_FLAGS & ~SCTLR_ELx_A))
> > > +	mov_q	x0, (SCTLR_EL2_RES1 | (SCTLR_EL2_FLAGS & ~SCTLR_ELx_A))
> > 
> > Can we just drop SCTLR_ELx_A from SCTLR_EL2_FLAGS instead of clearing it
> > here?
> 
> Absolutely. That'd actually be an improvement.

In fact, maybe just define INIT_SCTLR_EL2_MMU_ON to mirror what we do for
EL1 (i.e. including the RES1 bits) and then use that here?

Will
