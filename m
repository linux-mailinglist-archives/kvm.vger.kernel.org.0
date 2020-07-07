Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B034216D3A
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 14:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgGGM4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 08:56:49 -0400
Received: from foss.arm.com ([217.140.110.172]:47592 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbgGGM4t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 08:56:49 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 17A1FC0A;
        Tue,  7 Jul 2020 05:56:49 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E67833F71E;
        Tue,  7 Jul 2020 05:56:46 -0700 (PDT)
Subject: Re: [PATCH v3 07/17] KVM: arm64: hyp: Use ctxt_sys_reg/__vcpu_sys_reg
 instead of raw sys_regs access
To:     Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
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
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
References: <20200706125425.1671020-1-maz@kernel.org>
 <20200706125425.1671020-8-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <1f97200e-7a0a-aae6-637b-db84481abfb9@arm.com>
Date:   Tue, 7 Jul 2020 13:57:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200706125425.1671020-8-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 7/6/20 1:54 PM, Marc Zyngier wrote:
> Switch the hypervisor code to using ctxt_sys_reg/__vcpu_sys_reg instead
> of raw sys_regs accesses. No intended functionnal change.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h          |   2 +-
>  arch/arm64/kvm/hyp/include/hyp/debug-sr.h  |   4 +-
>  arch/arm64/kvm/hyp/include/hyp/switch.h    |   7 +-
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 110 ++++++++++-----------
>  arch/arm64/kvm/hyp/nvhe/switch.c           |   4 +-
>  5 files changed, 62 insertions(+), 65 deletions(-)

Looks fine to me, checked that the correct function is used (either
__vcpu_sys_reg, or ctxt_sys_reg), and that the registers names match. Also did a
compile test to make extra sure I didn't miss anything:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex
