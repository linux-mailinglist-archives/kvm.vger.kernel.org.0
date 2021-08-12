Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89FA3EA127
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 10:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235491AbhHLI7k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 04:59:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235158AbhHLI7j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 04:59:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D543A60C3F;
        Thu, 12 Aug 2021 08:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628758755;
        bh=q4t3vjuGK+tg/Wy9fWMngwcMUzb/VrxOSr5Xbkqf90I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VtzrVV2aF9VFqkuM1pzh5cVjlv4J4jrsalzZfW086fCJzEgKaIfEScPtVlsr2DWdy
         8racU7H4uRyOoEzYWpyLZngiBLf2knMRE6R5je/wcMfoZpTMNikwmjhhogsFBrB8Fj
         zBV1zXMUxF1s3YyRrvIdHjDcQVFIeGI6hzCghwDlaB0+Jm/fh8KvNw8Jnb3fs0g1kD
         DMQkp6Xg2Pg+Y4nZIQiqf8kbWOG4nNvqRLTDP6jnKPNebSxtG4PRjrBTDPn3UY0O0M
         y8lA/WZx/bicXZ60X+NZlqbURiMLL0D6FLgP+Ch/nD234s/pKaw5Ym4CHws8W8WVkr
         m1FXGuYEY/4eg==
Date:   Thu, 12 Aug 2021 09:59:09 +0100
From:   Will Deacon <will@kernel.org>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Subject: Re: [PATCH v3 02/15] KVM: arm64: Remove trailing whitespace in
 comment
Message-ID: <20210812085908.GC5912@willie-the-truck>
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-3-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719160346.609914-3-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 19, 2021 at 05:03:33PM +0100, Fuad Tabba wrote:
> Remove trailing whitespace from comment in trap_dbgauthstatus_el1().
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index f6f126eb6ac1..80a6e41cadad 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -318,14 +318,14 @@ static bool trap_dbgauthstatus_el1(struct kvm_vcpu *vcpu,
>  /*
>   * We want to avoid world-switching all the DBG registers all the
>   * time:
> - * 
> + *
>   * - If we've touched any debug register, it is likely that we're
>   *   going to touch more of them. It then makes sense to disable the
>   *   traps and start doing the save/restore dance
>   * - If debug is active (DBG_MDSCR_KDE or DBG_MDSCR_MDE set), it is
>   *   then mandatory to save/restore the registers, as the guest
>   *   depends on them.
> - * 
> + *
>   * For this, we use a DIRTY bit, indicating the guest has modified the
>   * debug registers, used as follow:
>   *

I'd usually be against these sorts of changes but given you're in the
area...

Acked-by: Will Deacon <will@kernel.org>

Will
