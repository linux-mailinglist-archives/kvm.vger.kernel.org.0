Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51323230216
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 07:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgG1FwV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 01:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbgG1FwV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 01:52:21 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFE6C061794;
        Mon, 27 Jul 2020 22:52:21 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4BG5RR52nlz9sTk; Tue, 28 Jul 2020 15:52:19 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1595915539; bh=YdXzNj3yLITWMwct98Hrs/Ck+OqhvBxNa6tu3onfhmQ=;
        h=Date:From:To:Cc:Subject:From;
        b=DfJJ9n0KUqXuEohxRDafm3ceWLolNWIrUZGi/vBfITeTWk5KptXtRxcQ1bRHsH9HJ
         FkyI63nA8B64Exj2aBXZUFAmkYVektnMKYHV2eYUa26Fj6jHz25TtgDs3uRtbdWgR/
         VnWUiNaZ5MnbuctyQqDS0RPPXOThyQ00kJRsakHp5FXVmZsWlnnXYew4xro8Lz38Js
         hqVT95VHLJaQ3eM9rLIPDgMYJr/AGkL8Idi9HbzF+AbSWa6C/Y2fCv7GPTkNyCAqa+
         mc7bnBO2hZTS0SA06Gc2sk+Dk7SyyRhIuTZh5SwdCwsEmZUpz3XWIYLcfQNxIA/nvP
         tCz1xrxfssLsQ==
Date:   Tue, 28 Jul 2020 15:51:00 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org
Subject: [GIT PULL] Please pull my kvm-ppc-next-5.9-1 tag
Message-ID: <20200728055100.GA2460422@thinks.paulus.ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Please do a pull from my kvm-ppc-next-5.9-1 tag to get a PPC KVM
update for 5.9.  It's another relatively small update this time, the
main thing being a series to improve the startup time for secure VMs
and make memory hotplug work in secure VMs.

Thanks,
Paul.

The following changes since commit b3a9e3b9622ae10064826dccb4f7a52bd88c7407:

  Linux 5.8-rc1 (2020-06-14 12:45:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-next-5.9-1

for you to fetch changes up to 81ab595ddd3c3036806b460526e1fbc5b271ff33:

  KVM: PPC: Book3S HV: Rework secure mem slot dropping (2020-07-28 12:34:52 +1000)

----------------------------------------------------------------
PPC KVM update for 5.9

- Improvements and bug-fixes for secure VM support, giving reduced startup
  time and memory hotplug support.
- Locking fixes in nested KVM code
- Increase number of guests supported by HV KVM to 4094
- Preliminary POWER10 support

----------------------------------------------------------------
Alexey Kardashevskiy (1):
      KVM: PPC: Protect kvm_vcpu_read_guest with srcu locks

Alistair Popple (1):
      KVM: PPC: Book3SHV: Enable support for ISA v3.1 guests

C�dric Le Goater (1):
      KVM: PPC: Book3S HV: Increase KVMPPC_NR_LPIDS on POWER8 and POWER9

Laurent Dufour (3):
      KVM: PPC: Book3S HV: Migrate hot plugged memory
      KVM: PPC: Book3S HV: Move kvmppc_svm_page_out up
      KVM: PPC: Book3S HV: Rework secure mem slot dropping

Ram Pai (4):
      KVM: PPC: Book3S HV: Fix function definition in book3s_hv_uvmem.c
      KVM: PPC: Book3S HV: Disable page merging in H_SVM_INIT_START
      KVM: PPC: Book3S HV: Track the state GFNs associated with secure VMs
      KVM: PPC: Book3S HV: In H_SVM_INIT_DONE, migrate remaining normal-GFNs to secure-GFNs

Tianjia Zhang (1):
      KVM: PPC: Clean up redundant kvm_run parameters in assembly

 Documentation/powerpc/ultravisor.rst        |   3 +
 arch/powerpc/include/asm/kvm_book3s_uvmem.h |  14 +
 arch/powerpc/include/asm/kvm_ppc.h          |   2 +-
 arch/powerpc/include/asm/reg.h              |   4 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c         |   8 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c      |   4 +
 arch/powerpc/kvm/book3s_hv.c                |  26 +-
 arch/powerpc/kvm/book3s_hv_nested.c         |  30 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c          | 698 +++++++++++++++++++++-------
 arch/powerpc/kvm/book3s_interrupts.S        |  56 ++-
 arch/powerpc/kvm/book3s_pr.c                |   9 +-
 arch/powerpc/kvm/book3s_rtas.c              |   2 +
 arch/powerpc/kvm/booke.c                    |   9 +-
 arch/powerpc/kvm/booke_interrupts.S         |   9 +-
 arch/powerpc/kvm/bookehv_interrupts.S       |  10 +-
 arch/powerpc/kvm/powerpc.c                  |   5 +-
 16 files changed, 646 insertions(+), 243 deletions(-)
