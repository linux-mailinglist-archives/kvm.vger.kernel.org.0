Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D2827399F
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 06:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726577AbgIVETh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 00:19:37 -0400
Received: from ozlabs.org ([203.11.71.1]:45417 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbgIVETh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Sep 2020 00:19:37 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4BwSkb5Dctz9sSC; Tue, 22 Sep 2020 14:19:35 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1600748375; bh=+TyuYYKH3sD47ZT12HOtuNmbIGXXMCkLfW/Ab3VHP3o=;
        h=Date:From:To:Cc:Subject:From;
        b=ds7Nn889CarZevU1lze3hhItrff7UpvSc+e2Mg6s+f7E+6qguTliRTIP5Nmp34zEF
         ehW5vwl5XZyZuz/UrY6g0xkiF6nlDjtFbYqNKwKTsai1NFDOcqUvhi63LJVIqiI6hb
         ZW/kzIPrNUbFIAwwRuBDLBcYG1oUo6KDRqQI+wmF79VSSDTaFDQArM/t8AD7ZpPAxn
         EHd9YNdlXIlMewwMvHlqLWJEL/DV03Kb4MKIDU3TuK8wf2rXK5qim7A75mTocky+Xu
         6/uneDBqqmox7xhf1AomJSbHHuHRyLu3dRrHjHab23UWNFteCmlUe6QptDlJoglQ7l
         DoVPGJBHBaOTg==
Date:   Tue, 22 Sep 2020 14:19:30 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org
Subject: [GIT PULL] Please pull my kvm-ppc-next-5.10-1 tag
Message-ID: <20200922041930.GA531519@thinks.paulus.ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Please do a pull from my kvm-ppc-next-5.10-1 tag to get a PPC KVM
update for 5.10.  This is a small update with just some bug fixes and
no new features.

Thanks,
Paul.

The following changes since commit d012a7190fc1fd72ed48911e77ca97ba4521bccd:

  Linux 5.9-rc2 (2020-08-23 14:08:43 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-next-5.10-1

for you to fetch changes up to cf59eb13e151ef42c37ae31864046c17e481ed8f:

  KVM: PPC: Book3S: Fix symbol undeclared warnings (2020-09-22 11:53:55 +1000)

----------------------------------------------------------------
PPC KVM update for 5.10

- Fix for running nested guests with in-kernel IRQ chip
- Fix race condition causing occasional host hard lockup
- Minor cleanups and bugfixes

----------------------------------------------------------------
Fabiano Rosas (1):
      KVM: PPC: Book3S HV: Do not allocate HPT for a nested guest

Greg Kurz (2):
      KVM: PPC: Book3S HV: XICS: Replace the 'destroy' method by a 'release' method
      KVM: PPC: Don't return -ENOTSUPP to userspace in ioctls

Jing Xiangfeng (1):
      KVM: PPC: Book3S: Remove redundant initialization of variable ret

Paul Mackerras (1):
      KVM: PPC: Book3S HV: Set LPCR[HDICE] before writing HDEC

Qinglang Miao (1):
      KVM: PPC: Book3S HV: XIVE: Convert to DEFINE_SHOW_ATTRIBUTE

Wang Wensheng (1):
      KVM: PPC: Book3S: Fix symbol undeclared warnings

 arch/powerpc/include/asm/kvm_host.h     |  1 +
 arch/powerpc/kvm/book3s.c               |  8 +--
 arch/powerpc/kvm/book3s_64_mmu_radix.c  |  2 +-
 arch/powerpc/kvm/book3s_64_vio.c        |  4 +-
 arch/powerpc/kvm/book3s_64_vio_hv.c     |  2 +-
 arch/powerpc/kvm/book3s_hv.c            | 22 +++++++--
 arch/powerpc/kvm/book3s_hv_interrupts.S |  9 ++--
 arch/powerpc/kvm/book3s_hv_nested.c     |  2 +-
 arch/powerpc/kvm/book3s_hv_rm_xics.c    |  2 +-
 arch/powerpc/kvm/book3s_pr.c            |  2 +-
 arch/powerpc/kvm/book3s_xics.c          | 86 ++++++++++++++++++++++++++-------
 arch/powerpc/kvm/book3s_xive_native.c   | 12 +----
 arch/powerpc/kvm/booke.c                |  6 +--
 13 files changed, 110 insertions(+), 48 deletions(-)
