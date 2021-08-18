Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 687143F0469
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 15:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236704AbhHRNOj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 09:14:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236805AbhHRNOb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 09:14:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2B9D61058;
        Wed, 18 Aug 2021 13:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629292437;
        bh=XrGwHD7gR8ZU9Zj08YSzBcYnSOA2sKeMDeoS+YJBYY8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s9TgU/8ZXWNKvSgj510XMYezkHGqg+JgIrl8djn/mWFR2XMlQhrOMGTK2+oyffdxh
         yEeNAhxAzkxT295o+GZk8d4JDxk+ATfCn3q37I2+jhg6OP0rcD9i0fzsk+m6N9eYjm
         HoFJw2hHCe2VRpvUVbQRBDd5aDR23P9iw52hS+dqbVjvJKITB9/42wzpMCncL31+7D
         yz7689/pdf+eW/6Vx9rTQhCwrs1HTGz8+dfbQ89kFj1IbJPrAAAKWPiP58ExXDXl+M
         dgaU5kdBtpzSnIhLLIQq8nqNwgtf4nkkMhStxiN4KohlQ9p2F33ETs12hSHaeytbty
         Ey9Gtvx9X5sdg==
Date:   Wed, 18 Aug 2021 14:13:51 +0100
From:   Will Deacon <will@kernel.org>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: Re: [PATCH v4 06/15] KVM: arm64: Restore mdcr_el2 from vcpu
Message-ID: <20210818131350.GD14107@willie-the-truck>
References: <20210817081134.2918285-1-tabba@google.com>
 <20210817081134.2918285-7-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210817081134.2918285-7-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 17, 2021 at 09:11:25AM +0100, Fuad Tabba wrote:
> On deactivating traps, restore the value of mdcr_el2 from the
> newly created and preserved host value vcpu context, rather than
> directly reading the hardware register.
> 
> Up until and including this patch the two values are the same,
> i.e., the hardware register and the vcpu one. A future patch will
> be changing the value of mdcr_el2 on activating traps, and this
> ensures that its value will be restored.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h       |  5 ++++-
>  arch/arm64/include/asm/kvm_hyp.h        |  2 +-
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  6 +++++-
>  arch/arm64/kvm/hyp/nvhe/switch.c        | 13 +++++--------
>  arch/arm64/kvm/hyp/vhe/switch.c         | 14 +++++---------
>  arch/arm64/kvm/hyp/vhe/sysreg-sr.c      |  2 +-
>  6 files changed, 21 insertions(+), 21 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
