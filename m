Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1F63B91F7
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 15:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236662AbhGANE0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 09:04:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236580AbhGANEZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 09:04:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDAD56140B;
        Thu,  1 Jul 2021 13:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625144515;
        bh=iHSHG/c7nR83GudWbkb74eh2Q3S1tPDocmMIvzxBwxI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r1fhICH1688wSS5RIgsm/HH8jTIkrAb09EbweFoFHMMOdYK0c1cl2TrqRJMzxJf0A
         34gPvJmmuP40y0tyr80fVb/PVALcQvo14bkIgBkYMFY1BpGBeAwG8ug18OwYmweRB2
         d3kzdYN51EoXMX6dMwKFdnlTiNuO5PvNMTLZYhzqu3j9RsjPZe7DcA1tpv23Utw73V
         o+WUPlFHGaJnsQG9m6kwhxeWBEJbJ/uI1VO+dWt0nRoVkAR1SVm31K+Od3ZsC+JUGZ
         R66XWaCnIdzq82WXf32VT4O3RpYngK1td+OS4I6TijYKgDAnkrxLdUdh7ejBmR490S
         0rqcZdipkInQg==
Date:   Thu, 1 Jul 2021 14:01:49 +0100
From:   Will Deacon <will@kernel.org>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Subject: Re: [PATCH v2 03/13] KVM: arm64: Fix names of config register fields
Message-ID: <20210701130149.GC9757@willie-the-truck>
References: <20210615133950.693489-1-tabba@google.com>
 <20210615133950.693489-4-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615133950.693489-4-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 15, 2021 at 02:39:40PM +0100, Fuad Tabba wrote:
> Change the names of hcr_el2 register fields to match the Arm
> Architecture Reference Manual. Easier for cross-referencing and
> for grepping.
> 
> Also, change the name of CPTR_EL2_RES1 to CPTR_NVHE_EL2_RES1,
> because res1 bits are different for VHE.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_arm.h | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 25d8a61888e4..bee1ba6773fb 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -31,9 +31,9 @@
>  #define HCR_TVM		(UL(1) << 26)
>  #define HCR_TTLB	(UL(1) << 25)
>  #define HCR_TPU		(UL(1) << 24)
> -#define HCR_TPC		(UL(1) << 23)
> +#define HCR_TPCP	(UL(1) << 23)

This one is a bit weird: the field is called TPCP if the CPU supports
FEAT_DPB but is called TPC otherwise! So I don't think renaming it like
this really makes anything better. Perhaps add a comment:

  #define HCR_TPC	(UL(1) << 23)	/* TPCP if FEAT_DPB */

?

Rest of the patch looks good:

Acked-by: Will Deacon <will@kernel.org>

Will
