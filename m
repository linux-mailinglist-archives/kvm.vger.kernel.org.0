Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 099D71987D5
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 01:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729293AbgC3XIM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 19:08:12 -0400
Received: from ozlabs.org ([203.11.71.1]:40959 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728876AbgC3XIM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 19:08:12 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 48rp615krJz9sSL; Tue, 31 Mar 2020 10:08:09 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1585609689; bh=4mB0dTKGIFZrF/S4U8SltnbkLiTAXQnc0Jb+9Xsv14I=;
        h=Date:From:To:Cc:Subject:From;
        b=slqR33x2DFV0+U98bVjroBx0ay9EnhUN05j42E6GQpEnstfd9eJpkPJharNdf6THs
         8zTYkQHLc/uk7j2pUxL/Ub4+dWypK8mdPURVTnCzFhEgnCoeUIjlH+c7YHJ8FKLvGY
         AconRVi7UkL+3bK2QlJ6Mcry3F+trAj0gut0V+4QI5cP57TUB9aB4Isvln7ajCIcc/
         vPEULj9HB+z/dkqdzggG11fkv5Dz3IAv4Z/iF8wL3YShZzfj1uQGaEdhV9dOu201q5
         dBHbW6DQO4xbe6cqmQijd/gSix+mJ/q5kGMzJ3lifeNWb3sEPQyDGT1I0ca9UV8o0/
         Y5sfJZozWaWDQ==
Date:   Tue, 31 Mar 2020 10:08:02 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org
Subject: [GIT PULL] Please pull my kvm-ppc-next-5.7-1 tag
Message-ID: <20200330230802.GB27514@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Please do a pull from my kvm-ppc-next-5.7-1 tag to get a PPC KVM
update for 5.7.

Thanks,
Paul.

The following changes since commit 1c482452d5db0f52e4e8eed95bd7314eec537d78:

  Merge tag 'kvm-s390-next-5.7-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD (2020-03-16 18:19:34 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-next-5.7-1

for you to fetch changes up to 9a5788c615f52f6d7bf0b61986a632d4ec86791d:

  KVM: PPC: Book3S HV: Add a capability for enabling secure guests (2020-03-26 11:09:04 +1100)

----------------------------------------------------------------
KVM PPC update for 5.7

* Add a capability for enabling secure guests under the Protected
  Execution Framework ultravisor

* Various bug fixes and cleanups.

----------------------------------------------------------------
Fabiano Rosas (1):
      KVM: PPC: Book3S HV: Skip kvmppc_uvmem_free if Ultravisor is not supported

Greg Kurz (3):
      KVM: PPC: Book3S PR: Fix kernel crash with PR KVM
      KVM: PPC: Book3S PR: Move kvmppc_mmu_init() into PR KVM
      KVM: PPC: Kill kvmppc_ops::mmu_destroy() and kvmppc_mmu_destroy()

Gustavo Romero (1):
      KVM: PPC: Book3S HV: Treat TM-related invalid form instructions on P9 like the valid ones

Joe Perches (1):
      KVM: PPC: Use fallthrough;

Laurent Dufour (2):
      KVM: PPC: Book3S HV: Check caller of H_SVM_* Hcalls
      KVM: PPC: Book3S HV: H_SVM_INIT_START must call UV_RETURN

Michael Ellerman (1):
      KVM: PPC: Book3S HV: Use RADIX_PTE_INDEX_SIZE in Radix MMU code

Michael Roth (1):
      KVM: PPC: Book3S HV: Fix H_CEDE return code for nested guests

Paul Mackerras (2):
      KVM: PPC: Book3S HV: Use __gfn_to_pfn_memslot in HPT page fault handler
      KVM: PPC: Book3S HV: Add a capability for enabling secure guests

 Documentation/virt/kvm/api.rst              |  17 ++++
 arch/powerpc/include/asm/kvm_asm.h          |   3 +
 arch/powerpc/include/asm/kvm_book3s_uvmem.h |   6 ++
 arch/powerpc/include/asm/kvm_host.h         |   1 +
 arch/powerpc/include/asm/kvm_ppc.h          |   4 +-
 arch/powerpc/kvm/book3s.c                   |   5 --
 arch/powerpc/kvm/book3s.h                   |   1 +
 arch/powerpc/kvm/book3s_32_mmu.c            |   2 +-
 arch/powerpc/kvm/book3s_32_mmu_host.c       |   2 +-
 arch/powerpc/kvm/book3s_64_mmu.c            |   2 +-
 arch/powerpc/kvm/book3s_64_mmu_host.c       |   2 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c         | 119 +++++++++++++---------------
 arch/powerpc/kvm/book3s_64_mmu_radix.c      |   2 +-
 arch/powerpc/kvm/book3s_hv.c                |  55 +++++++++----
 arch/powerpc/kvm/book3s_hv_tm.c             |  28 +++++--
 arch/powerpc/kvm/book3s_hv_tm_builtin.c     |  16 +++-
 arch/powerpc/kvm/book3s_hv_uvmem.c          |  19 ++++-
 arch/powerpc/kvm/book3s_pr.c                |   6 +-
 arch/powerpc/kvm/booke.c                    |  11 +--
 arch/powerpc/kvm/booke.h                    |   2 -
 arch/powerpc/kvm/e500.c                     |   1 -
 arch/powerpc/kvm/e500_mmu.c                 |   4 -
 arch/powerpc/kvm/e500mc.c                   |   1 -
 arch/powerpc/kvm/powerpc.c                  |  17 +++-
 include/uapi/linux/kvm.h                    |   1 +
 25 files changed, 205 insertions(+), 122 deletions(-)
