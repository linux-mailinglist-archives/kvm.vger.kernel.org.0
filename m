Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B29632C676
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355199AbhCDA2y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:28:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36849 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244836AbhCCPL4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 10:11:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614784221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2x8FmaHqNoFWbYN+V4sFpeQTKKF9zJmBr4OukRyZ06M=;
        b=cvewzn/NN4Lt7XPX+FjKmcox5yO/Kq98j3Qdpw4CRgpjmxPNs0kIx7/7YIb+5Tt6lt5BWr
        FrbC/HujwNlwatndRJuI4mxDq3V9D58qfFkI5PmoSH+oFz45qExlH1HoeyMxl8gWs1Mi4J
        7mXFyWDcOAm4Iezz+1hA2z0/3Nlu5MU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-54E5Z947OkWGeCxK13k7dw-1; Wed, 03 Mar 2021 10:10:18 -0500
X-MC-Unique: 54E5Z947OkWGeCxK13k7dw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0AFAC910160;
        Wed,  3 Mar 2021 15:10:08 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA9CD60C13;
        Wed,  3 Mar 2021 15:10:07 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 5.12-rc2
Date:   Wed,  3 Mar 2021 10:10:07 -0500
Message-Id: <20210303151007.383323-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 2df8d3807ce7f75bb975f1aeae8fc6757527c62d:

  KVM: SVM: Fix nested VM-Exit on #GP interception handling (2021-02-25 05:13:05 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 9e46f6c6c959d9bb45445c2e8f04a75324a0dfd0:

  KVM: SVM: Clear the CR4 register on reset (2021-03-02 14:39:11 -0500)

----------------------------------------------------------------
* Doc fixes
* selftests fixes
* Add runstate information to the new Xen support
* Allow compiling out the Xen interface
* 32-bit PAE without EPT bugfix
* NULL pointer dereference bugfix

----------------------------------------------------------------
Aaron Lewis (1):
      selftests: kvm: Mmap the entire vcpu mmap area

Babu Moger (1):
      KVM: SVM: Clear the CR4 register on reset

Chenyi Qiang (1):
      KVM: Documentation: rectify rst markup in kvm_run->flags

David Woodhouse (2):
      KVM: x86/xen: Fix return code when clearing vcpu_info and vcpu_time_info
      KVM: x86/xen: Add support for vCPU runstate information

Dongli Zhang (1):
      KVM: x86: remove misplaced comment on active_mmu_pages

Kai Huang (1):
      KVM: Documentation: Fix index for KVM_CAP_PPC_DAWR1

Paolo Bonzini (3):
      Documentation: kvm: fix messy conversion from .txt to .rst
      KVM: xen: flush deferred static key before checking it
      KVM: x86: allow compiling out the Xen hypercall interface

Sean Christopherson (1):
      KVM: x86/mmu: Set SPTE_AD_WRPROT_ONLY_MASK if and only if PML is enabled

Wanpeng Li (1):
      KVM: x86: hyper-v: Fix Hyper-V context null-ptr-deref

 Documentation/virt/kvm/api.rst                     | 115 ++++----
 arch/x86/include/asm/kvm_host.h                    |   9 +-
 arch/x86/kvm/Kconfig                               |   9 +
 arch/x86/kvm/Makefile                              |   3 +-
 arch/x86/kvm/hyperv.c                              |   2 +-
 arch/x86/kvm/mmu/mmu_internal.h                    |  16 +-
 arch/x86/kvm/svm/svm.c                             |   1 +
 arch/x86/kvm/x86.c                                 |  22 +-
 arch/x86/kvm/xen.c                                 | 290 +++++++++++++++++++++
 arch/x86/kvm/xen.h                                 |  64 ++++-
 include/uapi/linux/kvm.h                           |  13 +
 tools/testing/selftests/kvm/lib/kvm_util.c         |   6 +-
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c | 159 ++++++++++-
 13 files changed, 633 insertions(+), 76 deletions(-)

