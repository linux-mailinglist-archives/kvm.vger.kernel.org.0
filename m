Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D507214D4DE
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 01:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgA3AyU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 19:54:20 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:44895 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726618AbgA3AyU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 19:54:20 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 487MLf4YKhz9sPJ; Thu, 30 Jan 2020 11:54:18 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1580345658; bh=vSwTx+l4dx4nZFxfAd0KlQypvSZiAM/yuxNdihNDKN0=;
        h=Date:From:To:Cc:Subject:From;
        b=UZAkl/nrVwHCXZU2lhHJgb+Shq8vfk0Jw+IKLxpfYVtB7yHlqdygRIOK6PZhAvRHt
         tYhp7IZ693zXEzODNrG8WROm81pAhLFHwc40WQqCey+MbGqMfl+o33Qyza6vYxRP9C
         1njU1hoKP1A0y+47yidwixv2ZjPxVPJltk34GUynJ4L7glpenkuivbQonSu+T5kywO
         z3cNsL0eTJPMOCrLEltaXM53soLoHav0bLEAPUbDOZah4qm8rlUptyxe/t3lriMZPe
         9UjHkbuDehJxVc4/PR46bwBPKN9HbPcRHWjYeUDRUAPDvKgkYHTMqbnk9hkizKyrLI
         s1nsWMOi+jssQ==
Date:   Thu, 30 Jan 2020 11:54:16 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org
Subject: [GIT PULL] Please pull my kvm-ppc-next-5.6-2 tag
Message-ID: <20200130005416.GA25802@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

I have a second KVM PPC update for you.  I have added two more commits
which are both one-line fixes.  One is a compile warning fix and the
other fixes a locking error where we could incorrectly leave a mutex
locked when an error occurs.

Thanks,
Paul.

The following changes since commit 3a43970d55e9fd5475d3c4e5fe398ab831ec6c3a:

  KVM: PPC: Book3S HV: Implement H_SVM_INIT_ABORT hcall (2020-01-17 15:08:31 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-next-5.6-2

for you to fetch changes up to fd24a8624eb29d3b6b7df68096ce0321b19b03c6:

  KVM: PPC: Book3S PR: Fix -Werror=return-type build failure (2020-01-29 16:47:45 +1100)

----------------------------------------------------------------
Second KVM PPC update for 5.6

* Fix compile warning on 32-bit machines
* Fix locking error in secure VM support

----------------------------------------------------------------
Bharata B Rao (1):
      KVM: PPC: Book3S HV: Release lock on page-out failure path

David Michael (1):
      KVM: PPC: Book3S PR: Fix -Werror=return-type build failure

 arch/powerpc/kvm/book3s_hv_uvmem.c | 2 +-
 arch/powerpc/kvm/book3s_pr.c       | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)
