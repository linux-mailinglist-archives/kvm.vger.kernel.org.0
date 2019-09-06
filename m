Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7348AB7A9
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 14:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391675AbfIFMEV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 08:04:21 -0400
Received: from ozlabs.org ([203.11.71.1]:52493 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390233AbfIFMEV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 08:04:21 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 46Px7626x6z9sDB; Fri,  6 Sep 2019 22:04:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1567771458; bh=gNguo5Hk+rPIdjevIYkvYyq4GsNL9jrRIX6fY98i780=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e1Fp1TL1H4rr0DUCJevHd0jtF3SuxzMD24/s1yV5FMhibPjyA7JL8yTU/q4vkLLHA
         p9UKwk8Quqsc+SlSoc0oYAAEAK+gm0CeW+yHdvLlsfGarKLWl2HoqldnORUJEJ+wP0
         1N/TGJiUybqfm/CjdsWOf4D2ihnWJSIEQunfHc3pQ6QHupeBF9Z8ZYjxRCYH++K042
         XKqfGkxRQgi2pehoCbZlhW+EgX8THO1at8H5l74VdtPY1Cj16XpXJaVfyAx2gRxldU
         qCwdPXbtltiEbU4578rLO0+pOoihSQisVdBn2Hq7rtu7aTaoD8icO80sBtq325Lpht
         sZY5IlJb9qEeg==
Date:   Fri, 6 Sep 2019 22:04:15 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [GIT PULL] Please pull my kvm-ppc-next-5.4-1 tag
Message-ID: <20190906120415.GA1625@blackberry>
References: <20190828232353.GA4485@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190828232353.GA4485@blackberry>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 29, 2019 at 09:23:53AM +1000, Paul Mackerras wrote:
> Paolo or Radim,
> 
> Please do a pull from my kvm-ppc-next-5.4-1 tag to get a PPC KVM
> update for 5.4.  There is not a lot this time, mostly minor fixes and
> some prep for future patch series, plus a series that fixes a race
> condition in the XIVE interrupt controller code where interrupts could
> arrive after free_irq() and cause hangs and crashes in the host.
> 
> The XIVE fix touches both PPC KVM and generic powerpc code, so Michael
> Ellerman put it in his topic/ppc-kvm branch and I have merged that
> branch into my kvm-ppc-next branch.

Ping?

> Thanks,
> Paul.
> 
> The following changes since commit 609488bc979f99f805f34e9a32c1e3b71179d10b:
> 
>   Linux 5.3-rc2 (2019-07-28 12:47:02 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-next-5.4-1
> 
> for you to fetch changes up to ff42df49e75f053a8a6b4c2533100cdcc23afe69:
> 
>   KVM: PPC: Book3S HV: Don't lose pending doorbell request on migration on P9 (2019-08-27 14:08:22 +1000)
> 
> ----------------------------------------------------------------
> PPC KVM update for 5.4
> 
> - Some prep for extending the uses of the rmap array
> - Various minor fixes
> - Commits from the powerpc topic/ppc-kvm branch, which fix a problem
>   with interrupts arriving after free_irq, causing host hangs and crashes.
> 
> ----------------------------------------------------------------
> Cédric Le Goater (1):
>       KVM: PPC: Book3S HV: XIVE: Free escalation interrupts before disabling the VP
> 
> Fabiano Rosas (1):
>       KVM: PPC: Remove leftover comment from emulate_loadstore.c
> 
> Mark Cave-Ayland (1):
>       KVM: PPC: Book3S PR: Fix software breakpoints
> 
> Paul Mackerras (7):
>       KVM: PPC: Book3S HV: Fix race in re-enabling XIVE escalation interrupts
>       KVM: PPC: Book3S HV: Don't push XIVE context when not using XIVE device
>       powerpc/xive: Implement get_irqchip_state method for XIVE to fix shutdown race
>       Merge remote-tracking branch 'remotes/powerpc/topic/ppc-kvm' into kvm-ppc-next
>       KVM: PPC: Book3S: Enable XIVE native capability only if OPAL has required functions
>       KVM: PPC: Book3S HV: Check for MMU ready on piggybacked virtual cores
>       KVM: PPC: Book3S HV: Don't lose pending doorbell request on migration on P9
> 
> Paul Menzel (1):
>       KVM: PPC: Book3S: Mark expected switch fall-through
> 
> Suraj Jitindar Singh (1):
>       KVM: PPC: Book3S HV: Define usage types for rmap array in guest memslot
> 
>  arch/powerpc/include/asm/kvm_host.h     | 22 +++++++--
>  arch/powerpc/include/asm/kvm_ppc.h      |  1 +
>  arch/powerpc/include/asm/xive.h         |  9 ++++
>  arch/powerpc/kvm/book3s.c               |  8 +--
>  arch/powerpc/kvm/book3s_32_mmu.c        |  1 +
>  arch/powerpc/kvm/book3s_hv.c            | 24 ++++++---
>  arch/powerpc/kvm/book3s_hv_rm_mmu.c     |  2 +-
>  arch/powerpc/kvm/book3s_hv_rmhandlers.S | 38 +++++++++-----
>  arch/powerpc/kvm/book3s_xive.c          | 60 +++++++++++++++++++----
>  arch/powerpc/kvm/book3s_xive.h          |  2 +
>  arch/powerpc/kvm/book3s_xive_native.c   | 23 +++++++--
>  arch/powerpc/kvm/emulate.c              |  1 +
>  arch/powerpc/kvm/emulate_loadstore.c    |  6 ---
>  arch/powerpc/kvm/powerpc.c              |  3 +-
>  arch/powerpc/sysdev/xive/common.c       | 87 ++++++++++++++++++++++++---------
>  arch/powerpc/sysdev/xive/native.c       |  7 +++
>  16 files changed, 223 insertions(+), 71 deletions(-)
