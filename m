Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421A120B23E
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 15:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbgFZNOS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 09:14:18 -0400
Received: from foss.arm.com ([217.140.110.172]:49186 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725864AbgFZNOS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jun 2020 09:14:18 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E20EDD6E;
        Fri, 26 Jun 2020 06:14:17 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B1FF43F6CF;
        Fri, 26 Jun 2020 06:14:15 -0700 (PDT)
Subject: Re: [PATCH v2 05/17] KVM: arm64: Use TTL hint in when invalidating
 stage-2 translations
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
References: <20200615132719.1932408-1-maz@kernel.org>
 <20200615132719.1932408-6-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <08ad46a7-b676-a889-7e48-63367dcf453b@arm.com>
Date:   Fri, 26 Jun 2020 14:14:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200615132719.1932408-6-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On 6/15/20 2:27 PM, Marc Zyngier wrote:
> Since we often have a precise idea of the level we're dealing with
> when invalidating TLBs, we can provide it to as a hint to our
> invalidation helper.
>
> Reviewed-by: James Morse <james.morse@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_asm.h |  3 ++-
>  arch/arm64/kvm/hyp/tlb.c         |  5 +++--
>  arch/arm64/kvm/mmu.c             | 29 +++++++++++++++--------------
>  3 files changed, 20 insertions(+), 17 deletions(-)
>
> [..]

I checked that we use the correct level hints where appropriate (for example, that
we use the S2_PMD_LEVEL hint in stage2_dissolve_pmd()). From what I could tell, we
use hints only where we know for sure that we are invalidating a PUD or PMD block
mapping, or a PTE entry. FWIW:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex
