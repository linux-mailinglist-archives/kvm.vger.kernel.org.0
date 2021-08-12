Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C373EA12B
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 10:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235529AbhHLI7u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 04:59:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235234AbhHLI7u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 04:59:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0776160C3F;
        Thu, 12 Aug 2021 08:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628758765;
        bh=sjxnnAcFFQeU/Bm517XhrtWUqgRGPZPYbSW/yVHWY5s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZQj4RBz6e9t5QGtKRgT4K70zwQlVrLhg48IywHQcySOSt6rJBWxiPe3UmtVIY9fat
         NH6mS5vhBqHsLmQ6tKD5IqSs51Onmw2/6dpdutEG8H/+l2ze6O/epbNnQERnjeGXI9
         x4t/2R52K3AH0iszsA1xjxDa3mPF28Dd9ZskGnTnCP0L7L6kcScsp8DsxeJ8SZ1RsM
         dlnFyiFf6Ya4QsEQXaNIgr/CCPxGaO1DhmeJFqi6dlc5c4/03lj+FSrAPV7mRpCDxe
         aFBNoK42mSG49sj9MSQRNKSjdN1qxzMtyUwVW6UH+i4eS82mClXtG54n8dyYNiAaHz
         7mqlx7Y6mygDg==
Date:   Thu, 12 Aug 2021 09:59:20 +0100
From:   Will Deacon <will@kernel.org>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Subject: Re: [PATCH v3 05/15] KVM: arm64: Refactor sys_regs.h,c for nVHE reuse
Message-ID: <20210812085919.GD5912@willie-the-truck>
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-6-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719160346.609914-6-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 19, 2021 at 05:03:36PM +0100, Fuad Tabba wrote:
> Refactor sys_regs.h and sys_regs.c to make it easier to reuse
> common code. It will be used in nVHE in a later patch.
> 
> Note that the refactored code uses __inline_bsearch for find_reg
> instead of bsearch to avoid copying the bsearch code for nVHE.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/sysreg.h |  3 +++
>  arch/arm64/kvm/sys_regs.c       | 30 +-----------------------------
>  arch/arm64/kvm/sys_regs.h       | 31 +++++++++++++++++++++++++++++++
>  3 files changed, 35 insertions(+), 29 deletions(-)

With the naming change suggested by Drew:

Acked-by: Will Deacon <will@kernel.org.

Will
