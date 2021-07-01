Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5653D3B9231
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 15:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236710AbhGANZW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 09:25:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236567AbhGANZU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 09:25:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BA2961413;
        Thu,  1 Jul 2021 13:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625145770;
        bh=M+yZhv6g5otK9MkfzDlcaPl/c3UMH4E1t9qb2YpBQQE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mAFaojGOxwSR3+mK09AWgCOlfbEIM4pXDdsJ3gUPTuNNOAMnTtzGkjtUM72UC2w5s
         saxDVUj7iTr8VkMZbBFi/LKeA/qxhDmERgPapUWo5cw6QcxiBBRlpnDy667inwDABQ
         CNwctMGRK4dvJP0WRUNu/zyn0GEKMdJ8SBnPfFw8FDcVj2ITWELMp2KXTl1O82e4Sx
         T4bsCjbmJTW8Zlu9JI0wuRdx3JLiSgV0ZtDZp9pBRai1nFV4FlatrDHjP/bZ2rRVKr
         lLHTwPEdgHGS+cz/zRplGTYHiBZD3e7IeJOmMOFw6fiUMd+TWtBmGh71/uRI4pWdtk
         cvNYb02DcOCAQ==
Date:   Thu, 1 Jul 2021 14:22:44 +0100
From:   Will Deacon <will@kernel.org>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Subject: Re: [PATCH v2 06/13] KVM: arm64: Add feature register flag
 definitions
Message-ID: <20210701132244.GF9757@willie-the-truck>
References: <20210615133950.693489-1-tabba@google.com>
 <20210615133950.693489-7-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615133950.693489-7-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 15, 2021 at 02:39:43PM +0100, Fuad Tabba wrote:
> Add feature register flag definitions to clarify which features
> might be supported.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/sysreg.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 65d15700a168..42bcc5102d10 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -789,6 +789,10 @@
>  #define ID_AA64PFR0_FP_SUPPORTED	0x0
>  #define ID_AA64PFR0_ASIMD_NI		0xf
>  #define ID_AA64PFR0_ASIMD_SUPPORTED	0x0
> +#define ID_AA64PFR0_EL3_64BIT_ONLY	0x1
> +#define ID_AA64PFR0_EL3_32BIT_64BIT	0x2
> +#define ID_AA64PFR0_EL2_64BIT_ONLY	0x1
> +#define ID_AA64PFR0_EL2_32BIT_64BIT	0x2
>  #define ID_AA64PFR0_EL1_64BIT_ONLY	0x1
>  #define ID_AA64PFR0_EL1_32BIT_64BIT	0x2
>  #define ID_AA64PFR0_EL0_64BIT_ONLY	0x1

Maybe just consolidate all of these into two definitions:

  #define ID_AA64PFR0_ELx_64BIT_ONLY   0x1
  #define ID_AA64PFR0_ELx_32BIT_64BIT  0x2

?

Will
