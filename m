Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C61F21EB266
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 01:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbgFAXyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 19:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgFAXyD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 19:54:03 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C998CC05BD43;
        Mon,  1 Jun 2020 16:54:02 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1003)
        id 49bX7s1DFzzB3tX; Tue,  2 Jun 2020 09:54:01 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1591055641; bh=BMCP+EQlTqcCkd9Maz03VQlqG+YysRAL2juaQXqp2n8=;
        h=Date:From:To:Subject:From;
        b=j+besacjEVeqcDAx0+D3PFTaPPFvoyQJvdLsWD0W6QnvKBoZKlhLjeZb08iuCSvnM
         ggnOf/sP20MQDlwQC6bt6u7nQu9iBLpXchDum8A/jl086FRofiRFjvRmdnvHDBSuk5
         don0i5mQbwWCS5P0qxfKF7Dtc7f/mh/DsHgS1/ob4owIAem9ccRsVDbgQk9Bk7p4ou
         ru+arUQx7GfDTU575EE/rTuo2lsARUmxEnzKk1wB0kLfMo9kgkSbgtcKZjzsdqqKhY
         OKQe/Mn9gk0ImmPsCk4adOAW1PibkSaCTqv5W5Be9BXtnrfux9zlD9fPRBn+XDQbSF
         oOtwBvDkZgd8Q==
Date:   Tue, 2 Jun 2020 09:53:57 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: [GIT PULL] Please pull my kvm-ppc-next-5.8-1 tag
Message-ID: <20200601235357.GB428673@thinks.paulus.ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Please do a pull from my kvm-ppc-next-5.8-1 tag to get a PPC KVM
update for 5.8.  It's a relatively small update this time.  Michael
Ellerman also has some commits in his tree that touch
arch/powerpc/kvm, but I have not merged them here because there are no
merge conflicts, and so they can go to Linus via Michael's tree.

Thanks,
Paul.

The following changes since commit 9d5272f5e36155bcead69417fd12e98624e7faef:

  Merge tag 'noinstr-x86-kvm-2020-05-16' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip into HEAD (2020-05-20 03:40:09 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-next-5.8-1

for you to fetch changes up to 11362b1befeadaae4d159a8cddcdaf6b8afe08f9:

  KVM: PPC: Book3S HV: Close race with page faults around memslot flushes (2020-05-28 10:56:42 +1000)

----------------------------------------------------------------
PPC KVM update for 5.8

- Updates and bug fixes for secure guest support
- Other minor bug fixes and cleanups.

----------------------------------------------------------------
Chen Zhou (1):
      KVM: PPC: Book3S HV: Remove redundant NULL check

Laurent Dufour (2):
      KVM: PPC: Book3S HV: Read ibm,secure-memory nodes
      KVM: PPC: Book3S HV: Relax check on H_SVM_INIT_ABORT

Paul Mackerras (2):
      KVM: PPC: Book3S HV: Remove user-triggerable WARN_ON
      KVM: PPC: Book3S HV: Close race with page faults around memslot flushes

Qian Cai (2):
      KVM: PPC: Book3S HV: Ignore kmemleak false positives
      KVM: PPC: Book3S: Fix some RCU-list locks

Tianjia Zhang (2):
      KVM: PPC: Remove redundant kvm_run from vcpu_arch
      KVM: PPC: Clean up redundant 'kvm_run' parameters

 arch/powerpc/include/asm/kvm_book3s.h    | 16 +++----
 arch/powerpc/include/asm/kvm_host.h      |  1 -
 arch/powerpc/include/asm/kvm_ppc.h       | 27 ++++++------
 arch/powerpc/kvm/book3s.c                |  4 +-
 arch/powerpc/kvm/book3s.h                |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c      | 12 ++---
 arch/powerpc/kvm/book3s_64_mmu_radix.c   | 36 +++++++++++----
 arch/powerpc/kvm/book3s_64_vio.c         | 18 ++++++--
 arch/powerpc/kvm/book3s_emulate.c        | 10 ++---
 arch/powerpc/kvm/book3s_hv.c             | 75 +++++++++++++++++---------------
 arch/powerpc/kvm/book3s_hv_nested.c      | 15 +++----
 arch/powerpc/kvm/book3s_hv_uvmem.c       | 14 ++++++
 arch/powerpc/kvm/book3s_paired_singles.c | 72 +++++++++++++++---------------
 arch/powerpc/kvm/book3s_pr.c             | 30 ++++++-------
 arch/powerpc/kvm/booke.c                 | 36 +++++++--------
 arch/powerpc/kvm/booke.h                 |  8 +---
 arch/powerpc/kvm/booke_emulate.c         |  2 +-
 arch/powerpc/kvm/e500_emulate.c          | 15 +++----
 arch/powerpc/kvm/emulate.c               | 10 ++---
 arch/powerpc/kvm/emulate_loadstore.c     | 32 +++++++-------
 arch/powerpc/kvm/powerpc.c               | 72 +++++++++++++++---------------
 arch/powerpc/kvm/trace_hv.h              |  6 +--
 22 files changed, 276 insertions(+), 237 deletions(-)
