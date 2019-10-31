Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C81BEAE87
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2019 12:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbfJaLOP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Oct 2019 07:14:15 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:48755 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726722AbfJaLOP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Oct 2019 07:14:15 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 473jPv2Vmzz9sPJ; Thu, 31 Oct 2019 22:14:11 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1572520451; bh=YPLeyvpRHfFhn4xyIHHwVnQ9E5S2/47CprDiBRowXkc=;
        h=Date:From:To:Cc:Subject:From;
        b=nWkaP5yaFuxj4hVYUWCGMFmI9ATh4mIakiiEHPuzlbkxPMUOWMbqCX3lqH/7mvh+m
         9ivIfNAiUByM1yyz1fm9LDNjbblApMYx4xCbpGraiq/QQ4Yr2mjjQerVUtteuGUfjd
         H5bKET4cWLIZ6GJ4twKiLPt0y68rJ2mYyt9xqAHyQxOS/Cz3kXNw8rbj2mc+DtnPm7
         /RrZidpuX7dw766e3mGNpLh6Ngwu8AKONAspg1Kq+RwzKP2xQ/ISHx3RBuul8ukg1d
         4rK4cmR5G5KE2wxXPADBKmKmOCSqM7QTqrCVBe8KXBCRWosOQy/+CStWOkSRYTyXSE
         eWI3dbVBgBD3A==
Date:   Thu, 31 Oct 2019 12:13:49 +0100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org
Subject: [GIT PULL] Please pull my kvm-ppc-next-5.5-1 tag
Message-ID: <20191031111349.GA8045@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo or Radim,

Please do a pull from my kvm-ppc-next-5.5-1 tag to get a PPC KVM
update for v5.5.

Thanks,
Paul.

The following changes since commit 12ade69c1eb9958b13374edf5ef742ea20ccffde:

  KVM: PPC: Book3S HV: XIVE: Ensure VP isn't already in use (2019-10-15 16:09:11 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-next-5.5-1

for you to fetch changes up to 55d7004299eb917767761f01a208d50afad4f535:

  KVM: PPC: Book3S HV: Reject mflags=2 (LPCR[AIL]=2) ADDR_TRANS_MODE mode (2019-10-22 16:29:02 +1100)

----------------------------------------------------------------
KVM PPC update for 5.5

* Add capability to tell userspace whether we can single-step the guest.

* Improve the allocation of XIVE virtual processor IDs, to reduce the
  risk of running out of IDs when running many VMs on POWER9.

* Rewrite interrupt synthesis code to deliver interrupts in virtual
  mode when appropriate.

* Minor cleanups and improvements.

----------------------------------------------------------------
Fabiano Rosas (1):
      KVM: PPC: Report single stepping capability

Greg Kurz (5):
      KVM: PPC: Book3S HV: XIVE: Set kvm->arch.xive when VPs are allocated
      KVM: PPC: Book3S HV: XIVE: Show VP id in debugfs
      KVM: PPC: Book3S HV: XIVE: Compute the VP id in a common helper
      KVM: PPC: Book3S HV: XIVE: Make VP block size configurable
      KVM: PPC: Book3S HV: XIVE: Allow userspace to set the # of VPs

Leonardo Bras (2):
      KVM: PPC: Reduce calls to get current->mm by storing the value locally
      KVM: PPC: E500: Replace current->mm by kvm->mm

Nicholas Piggin (5):
      KVM: PPC: Book3S: Define and use SRR1_MSR_BITS
      KVM: PPC: Book3S: Replace reset_msr mmu op with inject_interrupt arch op
      KVM: PPC: Book3S HV: Reuse kvmppc_inject_interrupt for async guest delivery
      KVM: PPC: Book3S HV: Implement LPCR[AIL]=3 mode for injected interrupts
      KVM: PPC: Book3S HV: Reject mflags=2 (LPCR[AIL]=2) ADDR_TRANS_MODE mode

 Documentation/virt/kvm/api.txt          |   3 +
 Documentation/virt/kvm/devices/xics.txt |  14 +++-
 Documentation/virt/kvm/devices/xive.txt |   8 ++
 arch/powerpc/include/asm/kvm_host.h     |   1 -
 arch/powerpc/include/asm/kvm_ppc.h      |   1 +
 arch/powerpc/include/asm/reg.h          |  12 +++
 arch/powerpc/include/uapi/asm/kvm.h     |   3 +
 arch/powerpc/kvm/book3s.c               |  27 +------
 arch/powerpc/kvm/book3s.h               |   3 +
 arch/powerpc/kvm/book3s_32_mmu.c        |   6 --
 arch/powerpc/kvm/book3s_64_mmu.c        |  15 ----
 arch/powerpc/kvm/book3s_64_mmu_hv.c     |  24 ++----
 arch/powerpc/kvm/book3s_hv.c            |  28 ++-----
 arch/powerpc/kvm/book3s_hv_builtin.c    |  82 ++++++++++++++++----
 arch/powerpc/kvm/book3s_hv_nested.c     |   2 +-
 arch/powerpc/kvm/book3s_pr.c            |  40 +++++++++-
 arch/powerpc/kvm/book3s_xive.c          | 128 +++++++++++++++++++++++++-------
 arch/powerpc/kvm/book3s_xive.h          |   5 ++
 arch/powerpc/kvm/book3s_xive_native.c   |  38 ++++------
 arch/powerpc/kvm/e500_mmu_host.c        |   6 +-
 arch/powerpc/kvm/powerpc.c              |   2 +
 include/uapi/linux/kvm.h                |   1 +
 22 files changed, 288 insertions(+), 161 deletions(-)
