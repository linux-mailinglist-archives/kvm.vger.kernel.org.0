Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33F12A8A1D
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 23:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732509AbgKEWut (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 17:50:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:54904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732573AbgKEWur (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 17:50:47 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33C07206CA;
        Thu,  5 Nov 2020 22:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604616646;
        bh=i0KTUnwHXRywNXytlunN2AFWsQbhzt3gRCrTn0gzgpg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OfFoo/WXvxdNy1NAYDKVfo8AJKU+9jfnTaskPF4Ua1vcLBIjqdZAPKlSDmgIbVtCc
         nHCrsd/ea4VC+HOSOzeKvYUCbNXx5gVY/wN4YMuxTJlJma94Tfqwe+jS7Bp3vlVDbb
         QiPOaeNW/rVzB3o0Oddmd1x1WCHc1R6WS0bP5kj8=
Date:   Thu, 5 Nov 2020 22:50:42 +0000
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        Peng Liang <liangpeng10@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 3/3] KVM: arm64: Handle SCXTNUM_ELx traps
Message-ID: <20201105225041.GF8842@willie-the-truck>
References: <20201103171445.271195-1-maz@kernel.org>
 <20201103171445.271195-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103171445.271195-4-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 03, 2020 at 05:14:45PM +0000, Marc Zyngier wrote:
> As the kernel never sets HCR_EL2.EnSCXT, accesses to SCXTNUM_ELx
> will trap to EL2. Let's handle that as gracefully as possible
> by injecting an UNDEF exception into the guest. This is consistent
> with the guest's view of ID_AA64PFR0_EL1.CSV2 being at most 1.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/sysreg.h | 4 ++++
>  arch/arm64/kvm/sys_regs.c       | 4 ++++
>  2 files changed, 8 insertions(+)

Acked-by: Will Deacon <will@kernel.org>

Will
