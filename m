Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C85E11E08A
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 10:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfLMJ0g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 04:26:36 -0500
Received: from foss.arm.com ([217.140.110.172]:51746 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725937AbfLMJ0f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 04:26:35 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 64CA41FB;
        Fri, 13 Dec 2019 01:26:35 -0800 (PST)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EE99F3F52E;
        Fri, 13 Dec 2019 01:26:34 -0800 (PST)
Date:   Fri, 13 Dec 2019 10:26:33 +0100
From:   Christoffer Dall <christoffer.dall@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 3/3] KVM: arm/arm64: Drop spurious message when faulting
 on a non-existent mapping
Message-ID: <20191213092633.GD28840@e113682-lin.lund.arm.com>
References: <20191211165651.7889-1-maz@kernel.org>
 <20191211165651.7889-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211165651.7889-4-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 11, 2019 at 04:56:50PM +0000, Marc Zyngier wrote:
> Should userspace unmap memory whilst the guest is running, we exit
> with a -EFAULT, but also having spat a useless message on the console.
> 
> Get rid of it.

Acked-by: Christoffer Dall <christoffer.dall@arm.com>

> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  virt/kvm/arm/mmu.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index f73393f5ddb7..fbfdffb8fe8e 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1696,7 +1696,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	down_read(&current->mm->mmap_sem);
>  	vma = find_vma_intersection(current->mm, hva, hva + 1);
>  	if (unlikely(!vma)) {
> -		kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
>  		up_read(&current->mm->mmap_sem);
>  		return -EFAULT;
>  	}
> -- 
> 2.20.1
> 
