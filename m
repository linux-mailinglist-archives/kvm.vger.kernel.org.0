Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88CA3EA295
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 11:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234842AbhHLKAL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 06:00:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234782AbhHLKAK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 06:00:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B160260FC4;
        Thu, 12 Aug 2021 09:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628762386;
        bh=xhJTzirtcBObaMNh3L8mgpZhwBRzbdzx21Im4hyotWo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mGbsEoq/0jOgKOOuYwiObaj/Yo1csUtEQC9KIgPGavdArcPFxAVMaF64mVewbSu2U
         5IvPkIRglcC07FiTaV5o5QV5Y4vOYO32N9OCwyusHfz6Qui+vqAC8mKzbPXTbClvn+
         VC8W2TF9pQ0fYvndiFmJBhpOAsfboDlhkgEn31ixaruKarsaaq4k1CPOWjJHZstUa3
         WD2ij1Cty5+dsTXVpRKWyMwFxBIZDqD25B8nesZQNBFf+VhhTdpvSKQNtJrOpazIPc
         H82NKgpZYnDdqm7jx2xeAin1ZZd3biXCmoSLrzqyHbzm/Q+tgkaxOzdeYT9DI0Xmqa
         OxOYwQOimZN3Q==
Date:   Thu, 12 Aug 2021 10:59:40 +0100
From:   Will Deacon <will@kernel.org>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Subject: Re: [PATCH v3 15/15] KVM: arm64: Restrict protected VM capabilities
Message-ID: <20210812095938.GM5912@willie-the-truck>
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-16-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719160346.609914-16-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 19, 2021 at 05:03:46PM +0100, Fuad Tabba wrote:
> Restrict protected VM capabilities based on the
> fixed-configuration for protected VMs.
> 
> No functional change intended in current KVM-supported modes
> (nVHE, VHE).
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_fixed_config.h | 10 ++++
>  arch/arm64/kvm/arm.c                      | 63 ++++++++++++++++++++++-
>  arch/arm64/kvm/pkvm.c                     | 30 +++++++++++
>  3 files changed, 102 insertions(+), 1 deletion(-)

This patch looks good to me, but I'd be inclined to add this to the user-ABI
series given that it's really all user-facing and, without a functional
kvm_vm_is_protected(), isn't serving much purpose.

Cheers,

Will
