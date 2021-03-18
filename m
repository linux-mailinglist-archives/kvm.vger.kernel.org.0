Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1EB3406FE
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 14:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhCRNes (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 09:34:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231398AbhCRNea (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Mar 2021 09:34:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A72864E27;
        Thu, 18 Mar 2021 13:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616074470;
        bh=d+aUNfWPxN/xxjxc8yYGr+7tZ50qw5UZwCakX/qmEk0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AMKitB5VW/7PXIefSVUCNlKk3uz9eZlkxq3nB8HKwt24c/rwDd6rUUQU+6lNyau9X
         NMgBtb3f7NZsoJO9zV63kPQdB7x2LVb+96uwHd40xQhQh7zAEJ8wAJIZRoIIQ1+sbE
         96R8JHHuIp5xr4pxwJtqHMJrF4WjB1kLDC/uIq6vxxjb4Avc04NiEF2VLR0wqix0i3
         EZKOs6l3XRfLLGuYcsafB3MFGzwm9qwRQBk236hbyE4SlgfqhnPPXCfj0ni8oR8PdP
         Tf6aOHl7UnVgKSahhp0sBFHtFXgDLFXSziVTZIQuRfESWZqRaJUc6xvn+aP4G8Sc3w
         t+WQ6ajjAzMQQ==
Date:   Thu, 18 Mar 2021 13:34:25 +0000
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, dave.martin@arm.com, daniel.kiss@arm.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        broonie@kernel.org, ascull@google.com, qperret@google.com,
        kernel-team@android.com
Subject: Re: [PATCH v2 06/11] KVM: arm64: Rework SVE host-save/guest-restore
Message-ID: <20210318133424.GC7055@willie-the-truck>
References: <20210318122532.505263-1-maz@kernel.org>
 <20210318122532.505263-7-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318122532.505263-7-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 18, 2021 at 12:25:27PM +0000, Marc Zyngier wrote:
> In order to keep the code readable, move the host-save/guest-restore
> sequences in their own functions, with the following changes:
> - the hypervisor ZCR is now set from C code
> - ZCR_EL2 is always used as the EL2 accessor
> 
> This results in some minor assembler macro rework.
> No functional change intended.
> 
> Acked-by: Will Deacon <will@kernel.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/fpsimdmacros.h   |  8 +++--
>  arch/arm64/include/asm/kvm_hyp.h        |  2 +-
>  arch/arm64/kvm/hyp/fpsimd.S             |  2 +-
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 40 +++++++++++++++----------
>  4 files changed, 32 insertions(+), 20 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
