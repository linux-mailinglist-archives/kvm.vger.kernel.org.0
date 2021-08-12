Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8DD3EA12D
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 10:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235551AbhHLJAA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 05:00:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235541AbhHLI77 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 04:59:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A969F6103A;
        Thu, 12 Aug 2021 08:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628758774;
        bh=4DUeuUPXJ9YkgfHJ3idaWRU8OrWSUOhWlkj96EgFH18=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lAhd5jLoeFXGjCWRzXch7wQA0ymZWKH9PdJMX0CMFloTzMB8JcCmRPTVnESvo04Uf
         0A7eaN3VlakFMuAHcmi6tazp9k4YGq5Go6mvmKGRa5NJGWrEYmIDf9qt6GsUB1WKpr
         3C611NqL/+qazEyhzu3BLDQThOIQAElxqPhSqVkayslanV8D580qFPkgRnigRl0ksW
         p5LFgGmOTspWZIAdxeCG2/4yzqJgim+jlACsKe3Vpqn8Y39O3Kd8MKt1EfJ0OkDGw3
         PWScIm+TVsKwtV0K2li/OW3vCQZi9Ik9TLQ0VvamIcdgtuBG7Gn1NUcIo354/f00hH
         VV6d4LDlWOfwQ==
Date:   Thu, 12 Aug 2021 09:59:29 +0100
From:   Will Deacon <will@kernel.org>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Subject: Re: [PATCH v3 07/15] KVM: arm64: Track value of cptr_el2 in struct
 kvm_vcpu_arch
Message-ID: <20210812085929.GE5912@willie-the-truck>
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-8-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719160346.609914-8-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 19, 2021 at 05:03:38PM +0100, Fuad Tabba wrote:
> Track the baseline guest value for cptr_el2 in struct
> kvm_vcpu_arch, similar to the other registers that control traps.
> Use this value when setting cptr_el2 for the guest.
> 
> Currently this value is unchanged (CPTR_EL2_DEFAULT), but future
> patches will set trapping bits based on features supported for
> the guest.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 1 +
>  arch/arm64/kvm/arm.c              | 1 +
>  arch/arm64/kvm/hyp/nvhe/switch.c  | 2 +-
>  3 files changed, 3 insertions(+), 1 deletion(-)

Acked-by: Will Deacon <will@kernel.org>

Will
