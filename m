Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2702B41C2B4
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 12:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245510AbhI2KaT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 06:30:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:53000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245324AbhI2KaS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 06:30:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DE04613A5;
        Wed, 29 Sep 2021 10:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632911318;
        bh=38W4+E7XmZj6LdI0NjZ184grtf29Qd/YWJcOFsY7XlU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s3oPKMoutgasFHaIKQPk4Npg6PF2e4bD+Bc2eWht+hP3eyeMfCb7jpgyRR/gaGQ95
         vUfnBx+fRhNFoIXgxRgvwuTxnkZlFa34a9R81ir/MQi5iy5ZDFiPJlOpiQWBQZvP2B
         36EVVBvobQt6g0Xj/wgk5VqUgZ+bFJjXIfIpWe7wJVvVGwHFmYQFZ7Q16JjWO5GS4D
         88fTfgsMuxiJci6e4Vq0Q9s8tzFoHjvxi2zHa3EpzdokMUJ8DhzSLZWSnZD9nKsojL
         BvvAINMsHcfmxvxt0dLpk5zGsl7Z5OMLFcAh8d+P2bY3GOPdoLZQS7/cipIrnIZDTM
         Afla3FdpKjAWg==
Date:   Wed, 29 Sep 2021 11:28:33 +0100
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, ascull@google.com,
        dbrazdil@google.com, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Allow KVM to be disabled from the command
 line
Message-ID: <20210929102832.GD21057@willie-the-truck>
References: <20210903091652.985836-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903091652.985836-1-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 03, 2021 at 10:16:52AM +0100, Marc Zyngier wrote:
> Although KVM can be compiled out of the kernel, it cannot be disabled
> at runtime. Allow this possibility by introducing a new mode that
> will prevent KVM from initialising.
> 
> This is useful in the (limited) circumstances where you don't want
> KVM to be available (what is wrong with you?), or when you want
> to install another hypervisor instead (good luck with that).
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  Documentation/admin-guide/kernel-parameters.txt |  3 +++
>  arch/arm64/include/asm/kvm_host.h               |  1 +
>  arch/arm64/kernel/idreg-override.c              |  1 +
>  arch/arm64/kvm/arm.c                            | 14 +++++++++++++-
>  4 files changed, 18 insertions(+), 1 deletion(-)

Acked-by: Will Deacon <will@kernel.org>

Will
