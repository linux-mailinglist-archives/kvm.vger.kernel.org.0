Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B66C3A41B6
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2019 04:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbfHaC03 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Aug 2019 22:26:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41158 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728271AbfHaC03 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Aug 2019 22:26:29 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DC7DA59455;
        Sat, 31 Aug 2019 02:26:28 +0000 (UTC)
Received: from flask (unknown [10.43.2.55])
        by smtp.corp.redhat.com (Postfix) with SMTP id F4220600CC;
        Sat, 31 Aug 2019 02:26:26 +0000 (UTC)
Received: by flask (sSMTP sendmail emulation); Sat, 31 Aug 2019 04:26:26 +0200
Date:   Sat, 31 Aug 2019 04:26:26 +0200
From:   Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 5.3-rc7
Message-ID: <20190831022626.GA453351@flask>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Sat, 31 Aug 2019 02:26:28 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit a55aa89aab90fae7c815b0551b07be37db359d76:

  Linux 5.3-rc6 (2019-08-25 12:01:23 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm tags/for-linus

for you to fetch changes up to 75ee23b30dc712d80d2421a9a547e7ab6e379b44:

  KVM: x86: Don't update RIP or do single-step on faulting emulation (2019-08-27 20:59:04 +0200)

----------------------------------------------------------------
KVM fixes for 5.3-rc7

PPC:
- Fix bug which could leave locks locked in the host on return to a
  guest.

x86:
- Prevent infinitely looping emulation of a failing syscall while single
  stepping.
- Do not crash the host when nesting is disabled.

----------------------------------------------------------------
Alexey Kardashevskiy (1):
      KVM: PPC: Book3S: Fix incorrect guest-to-user-translation error handling

Radim Krčmář (1):
      Merge tag 'kvm-ppc-fixes-5.3-1' of git://git.kernel.org/.../paulus/powerpc

Sean Christopherson (1):
      KVM: x86: Don't update RIP or do single-step on faulting emulation

Vitaly Kuznetsov (1):
      KVM: x86: hyper-v: don't crash on KVM_GET_SUPPORTED_HV_CPUID when kvm_intel.nested is disabled

 arch/powerpc/kvm/book3s_64_vio.c    | 6 ++++--
 arch/powerpc/kvm/book3s_64_vio_hv.c | 6 ++++--
 arch/x86/kvm/hyperv.c               | 5 ++++-
 arch/x86/kvm/svm.c                  | 8 +-------
 arch/x86/kvm/vmx/vmx.c              | 1 +
 arch/x86/kvm/x86.c                  | 9 +++++----
 6 files changed, 19 insertions(+), 16 deletions(-)
