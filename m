Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5E841DAAA
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 15:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351390AbhI3NJW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 09:09:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351283AbhI3NJE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 09:09:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33017619E4;
        Thu, 30 Sep 2021 13:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633007241;
        bh=3CTzqJ6seyTwaKCCqSo//2u7V4K/VoTn43hSmcSetgo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fn2yZ7NAX4ReoLZviOkyuwHmxIbenGbEKp+bVAs2ukXUbj8LJQgmwXwXxQb8HKzOc
         1OkWfih3hsTOdTG/4sAnyE9mWRl4AeyGDPwxgy0578k6MKysQAALscZwv4fSGhfPHS
         c/Lvg7ihSf9+JtP3ZUzA7qfavw//JA1yTnuVLxZ0fmAfEVAgbYfBH+PBd8V9MGhQZR
         rCIqROiGQqZBSZ2b3aEwH70mmGzwW0/fowbaEKWDHcM0+5iSoSQcn6n0OGFeD3pyin
         4hcZW3PzcjaWBtInV+pxcIdZi0vsJECrJGsIh1NU2aclBylZnGNwoXkSTd0062qtEn
         yt0qJ+7qXT8Cg==
Date:   Thu, 30 Sep 2021 14:07:15 +0100
From:   Will Deacon <will@kernel.org>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: Re: [PATCH v6 02/12] KVM: arm64: Don't include switch.h into
 nvhe/kvm-main.c
Message-ID: <20210930130715.GB23809@willie-the-truck>
References: <20210922124704.600087-1-tabba@google.com>
 <20210922124704.600087-3-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922124704.600087-3-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 22, 2021 at 01:46:54PM +0100, Fuad Tabba wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> hyp-main.c includes switch.h while it only requires adjust-pc.h.
> Fix it to remove an unnecessary dependency.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 2da6aa8da868..8ca1104f4774 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -4,7 +4,7 @@
>   * Author: Andrew Scull <ascull@google.com>
>   */
>  
> -#include <hyp/switch.h>
> +#include <hyp/adjust_pc.h>
>  
>  #include <asm/pgtable-types.h>
>  #include <asm/kvm_asm.h>

Acked-by: Will Deacon <will@kernel.org>

Will
