Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEA81435F0
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 04:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbgAUDdd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 22:33:33 -0500
Received: from ozlabs.org ([203.11.71.1]:50947 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728826AbgAUDdd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jan 2020 22:33:33 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 481vJW2dw3z9sRG; Tue, 21 Jan 2020 14:33:31 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1579577611; bh=suGKrrg/HU8kzRkaVjlEcVNshSTs5/ByjJdeu2rWCsY=;
        h=Date:From:To:Cc:Subject:From;
        b=Ao6jUWwjePqBeumuL87dDPMvkXJTJ6rHz4AauGtQzeX/uN9NEqSZNo/H3RvHSSsVB
         uo0BTg/ZAYXlzW8FKQ1RS4B+dPww6ue/OdIh+nSDzb7LZwMKVml+IWJZsWfpBnt0G3
         Q/gH5NUahrqmhDP74D1ok8BNQfafzwytuVxJPFrWhLDRdjFtAewBa+d15TTp4BZQvj
         NxMcm/DUYUBswUQiRmmak4JLWq7Mh2ZDGRvbw9qWHPxvXRIRsUbskekVK6iTpEKLhh
         DWw5jUB+fQN9j4b8p7VKsWNtQlXzn01/NV00c5OrpmMRIE7cH3WjHATPaa8P3GZ1Kl
         ERZL3WDSHrh3w==
Date:   Tue, 21 Jan 2020 14:33:26 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org
Subject: [GIT PULL] Please pull my kvm-ppc-next-5.6-1 tag
Message-ID: <20200121033326.GA23311@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Please do a pull from my kvm-ppc-next-5.6-1 tag to get a PPC KVM
update for 5.6.

Thanks,
Paul.

The following changes since commit c79f46a282390e0f5b306007bf7b11a46d529538:

  Linux 5.5-rc5 (2020-01-05 14:23:27 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-next-5.6-1

for you to fetch changes up to 3a43970d55e9fd5475d3c4e5fe398ab831ec6c3a:

  KVM: PPC: Book3S HV: Implement H_SVM_INIT_ABORT hcall (2020-01-17 15:08:31 +1100)

----------------------------------------------------------------
KVM PPC update for 5.6

* Add a hypercall to be used by the ultravisor when secure VM
  initialization fails.

* Minor code cleanups.

----------------------------------------------------------------
Leonardo Bras (2):
      KVM: PPC: Book3S: Replace current->mm by kvm->mm
      KVM: PPC: Book3E: Replace current->mm by kvm->mm

Sukadev Bhattiprolu (2):
      KVM: PPC: Add skip_page_out parameter to uvmem functions
      KVM: PPC: Book3S HV: Implement H_SVM_INIT_ABORT hcall

zhengbin (1):
      KVM: PPC: Remove set but not used variable 'ra', 'rs', 'rt'

 Documentation/powerpc/ultravisor.rst        | 60 +++++++++++++++++++++++++++++
 arch/powerpc/include/asm/hvcall.h           |  1 +
 arch/powerpc/include/asm/kvm_book3s_uvmem.h | 10 ++++-
 arch/powerpc/include/asm/kvm_host.h         |  1 +
 arch/powerpc/kvm/book3s_64_mmu_hv.c         |  4 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c      |  2 +-
 arch/powerpc/kvm/book3s_64_vio.c            | 10 +++--
 arch/powerpc/kvm/book3s_hv.c                | 15 +++++---
 arch/powerpc/kvm/book3s_hv_uvmem.c          | 32 ++++++++++++++-
 arch/powerpc/kvm/booke.c                    |  2 +-
 arch/powerpc/kvm/emulate_loadstore.c        |  5 ---
 11 files changed, 119 insertions(+), 23 deletions(-)
