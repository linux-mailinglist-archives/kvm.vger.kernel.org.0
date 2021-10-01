Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 391AC41F2BD
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 19:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbhJARPF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 13:15:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33517 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231573AbhJARPF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 1 Oct 2021 13:15:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633108400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sVz9m61lZAuKjlDG6AN5kGL/PhCyfwRd/qN/VMo9F+Q=;
        b=LIcogePoPiCpr4VTWFoUYq2Tqg+3xxNw9tXEUlkSe3ktLgql28SR01xl1r9irJrjcW50wJ
        P5A5MUwPMGfF3CgPOaJbH83sY/jaYG8swMBLQTpPuDJaVwR1ezR9cdNTkKeP2vbDprDsHz
        TYm/4JnWqMHnXeMGvAV6HXbBUp9qfms=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-tqiJCmPBMTW4bQ7ddJMOpw-1; Fri, 01 Oct 2021 13:13:17 -0400
X-MC-Unique: tqiJCmPBMTW4bQ7ddJMOpw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68B93100C661;
        Fri,  1 Oct 2021 17:13:16 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 197195F4F0;
        Fri,  1 Oct 2021 17:13:16 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] More KVM fixes Linux 5.15-rc4
Date:   Fri,  1 Oct 2021 13:13:10 -0400
Message-Id: <20211001171310.16659-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 50b078184604fea95adbb144ff653912fb0e48c6:

  Merge tag 'kvmarm-fixes-5.15-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into kvm-master (2021-09-24 06:04:42 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 7b0035eaa7dab9fd33d6658ad6a755024bdce26c:

  KVM: selftests: Ensure all migrations are performed when test is affined (2021-09-30 04:25:57 -0400)

----------------------------------------------------------------
Small x86 fixes.

----------------------------------------------------------------
Oliver Upton (1):
      selftests: KVM: Don't clobber XMM register when read

Sean Christopherson (2):
      KVM: x86: Swap order of CPUID entry "index" vs. "significant flag" checks
      KVM: selftests: Ensure all migrations are performed when test is affined

Zelin Deng (2):
      x86/kvmclock: Move this_cpu_pvti into kvmclock.h
      ptp: Fix ptp_kvm_getcrosststamp issue for x86 ptp_kvm

Zhenzhong Duan (1):
      KVM: VMX: Fix a TSX_CTRL_CPUID_CLEAR field mask issue

 arch/x86/include/asm/kvmclock.h                    | 14 +++++
 arch/x86/kernel/kvmclock.c                         | 13 +---
 arch/x86/kvm/cpuid.c                               |  4 +-
 arch/x86/kvm/vmx/vmx.c                             |  2 +-
 drivers/ptp/ptp_kvm_x86.c                          |  9 +--
 .../selftests/kvm/include/x86_64/processor.h       |  2 +-
 tools/testing/selftests/kvm/rseq_test.c            | 69 ++++++++++++++++++----
 7 files changed, 81 insertions(+), 32 deletions(-)

