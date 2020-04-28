Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C141BC44C
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 17:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbgD1P6y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 11:58:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728337AbgD1P6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 11:58:53 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E0D720663;
        Tue, 28 Apr 2020 15:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588089533;
        bh=0Bw2WYxz0osMy3g4eF8BHxR9jp93bTXexFG2uSWB8Z0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qQXqibFS7DE1Bc9mclFTDqJuH6c7bf615MUHCHv3NAPVvn22dm8rPlDGvn3QrOcZY
         LmYNgtOIWjP8X08DFvkMQkzEdQvLq7ZTVmQ8onWZbiKS2h+unO1LmjlZEkxdMkAa7f
         ASiYBjhY6YVMhkeIku/IrsxgrHYX7iAW+wYDbf6A=
Date:   Tue, 28 Apr 2020 16:58:48 +0100
From:   Will Deacon <will@kernel.org>
To:     Fuad Tabba <tabba@google.com>
Cc:     maz@kernel.org, catalin.marinas@arm.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, trivial@kernel.org, jeffv@google.com
Subject: Re: [PATCH] KVM: Fix spelling in code comments
Message-ID: <20200428155847.GC12697@willie-the-truck>
References: <20200401140310.29701-1-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200401140310.29701-1-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 01, 2020 at 03:03:10PM +0100, Fuad Tabba wrote:
> Fix spelling and typos (e.g., repeated words) in comments.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/guest.c        | 4 ++--
>  arch/arm64/kvm/reset.c        | 6 +++---
>  arch/arm64/kvm/sys_regs.c     | 6 +++---
>  virt/kvm/arm/arm.c            | 6 +++---
>  virt/kvm/arm/hyp/vgic-v3-sr.c | 2 +-
>  virt/kvm/arm/mmio.c           | 2 +-
>  virt/kvm/arm/mmu.c            | 6 +++---
>  virt/kvm/arm/psci.c           | 6 +++---
>  virt/kvm/arm/vgic/vgic-v3.c   | 2 +-
>  virt/kvm/coalesced_mmio.c     | 2 +-
>  virt/kvm/eventfd.c            | 2 +-
>  virt/kvm/kvm_main.c           | 2 +-
>  12 files changed, 23 insertions(+), 23 deletions(-)

FWIW, these *do* all look like valid typos to me, but I'll leave it at
Marc's discretion as to whether he wants to merge the series, since things
like this can confuse 'git blame' and get in the way of backports.

Will
