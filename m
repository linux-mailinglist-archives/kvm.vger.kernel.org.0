Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4ED03EA255
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 11:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235588AbhHLJqt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 05:46:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236317AbhHLJqs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 05:46:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0472C60FBF;
        Thu, 12 Aug 2021 09:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628761583;
        bh=qhI1ZjlthPN+UipICNKadmY33LTUi/D0cRWvLI4yveM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FMU+AoXpqHItFGbLzQm/dSToRdT76j6LefDOwqSk3jr4I6dSjXvnx8pSbjcxFm9SW
         Ou7Bq22+d01ZKfXnZbkqFI79xAHFqdwPKcjVeC9mKxNT99PBjb7dkTdODEkSivRe/P
         amk5LNKM50WTSx2SDqdGmHx6nVg8+IU5qJCLpYMUYzAcCn+B8MFrvklaLZmJNFpudU
         yBcpicGZigcM5k0T0bh0rqXeCE318Lx01ZU4kOhBDiS73FABB+JI2CRX7Op3qtACJK
         u+cMB1uIEwlQgDAC2PDLljK4LBFkTMztlOlQWOSymw+fUeXbg0oO4Dxyhm4IZO+ruz
         tr53B7+TDzelg==
Date:   Thu, 12 Aug 2021 10:46:18 +0100
From:   Will Deacon <will@kernel.org>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Subject: Re: [PATCH v3 12/15] KVM: arm64: Move sanitized copies of CPU
 features
Message-ID: <20210812094617.GI5912@willie-the-truck>
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-13-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719160346.609914-13-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 19, 2021 at 05:03:43PM +0100, Fuad Tabba wrote:
> Move the sanitized copies of the CPU feature registers to the
> recently created sys_regs.c. This consolidates all copies in a
> more relevant file.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 6 ------
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c    | 2 ++
>  2 files changed, 2 insertions(+), 6 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
