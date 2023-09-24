Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0537AC74D
	for <lists+kvm@lfdr.de>; Sun, 24 Sep 2023 11:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjIXJ14 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Sep 2023 05:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjIXJ1z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Sep 2023 05:27:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E7AF1
        for <kvm@vger.kernel.org>; Sun, 24 Sep 2023 02:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695547622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zHKWyHfacqVewjndjBS85PHaoQHVa8lSR8E5aIAAdmQ=;
        b=T0c2VVGDpchjyBYBB3WQIfsIhMt1ZNteXHa6vE1VzNu1cq0q0p6JiDDsYXgYaUtvWzWD8N
        +qCwoY58ffEZ9E7XAlp8yfenjAw8lzmRyaCeSikWeIyblEEssZUSMjO+QlIi6/zo+Q0hfb
        QXi8x899SLQBdsGvsYSxztUXL7th4VM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-680-dWYrLDX-NRu4iiNPZAxlbQ-1; Sun, 24 Sep 2023 05:27:01 -0400
X-MC-Unique: dWYrLDX-NRu4iiNPZAxlbQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B6B55380673E;
        Sun, 24 Sep 2023 09:27:00 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96A27711291;
        Sun, 24 Sep 2023 09:27:00 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 6.6-rc3
Date:   Sun, 24 Sep 2023 05:27:00 -0400
Message-Id: <20230924092700.1192123-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit ce9ecca0238b140b88f43859b211c9fdfd8e5b70:

  Linux 6.6-rc2 (2023-09-17 14:40:24 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 5804c19b80bf625c6a9925317f845e497434d6d3:

  Merge tag 'kvm-riscv-fixes-6.6-1' of https://github.com/kvm-riscv/linux into HEAD (2023-09-23 05:35:55 -0400)

----------------------------------------------------------------
ARM:

* Fix an UV boot crash

* Skip spurious ENDBR generation on _THIS_IP_

* Fix ENDBR use in putuser() asm methods

* Fix corner case boot crashes on 5-level paging

* and fix a false positive WARNING on LTO kernels"

RISC-V:

* Fix KVM_GET_REG_LIST API for ISA_EXT registers

* Fix reading ISA_EXT register of a missing extension

* Fix ISA_EXT register handling in get-reg-list test

* Fix filtering of AIA registers in get-reg-list test

x86:

* Fixes for TSC_AUX virtualization

* Stop zapping page tables asynchronously, since we don't
  zap them as often as before

----------------------------------------------------------------
Anup Patel (4):
      RISC-V: KVM: Fix KVM_GET_REG_LIST API for ISA_EXT registers
      RISC-V: KVM: Fix riscv_vcpu_get_isa_ext_single() for missing extensions
      KVM: riscv: selftests: Fix ISA_EXT register handling in get-reg-list
      KVM: riscv: selftests: Selectively filter-out AIA registers

Jean-Philippe Brucker (1):
      KVM: arm64: nvhe: Ignore SVE hint in SMCCC function ID

Marc Zyngier (1):
      KVM: arm64: Properly return allocated EL2 VA from hyp_alloc_private_va_range()

Paolo Bonzini (4):
      Merge tag 'kvmarm-fixes-6.6-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      KVM: x86/mmu: Do not filter address spaces in for_each_tdp_mmu_root_yield_safe()
      KVM: SVM: INTERCEPT_RDTSCP is never intercepted anyway
      Merge tag 'kvm-riscv-fixes-6.6-1' of https://github.com/kvm-riscv/linux into HEAD

Sean Christopherson (3):
      KVM: selftests: Assert that vasprintf() is successful
      KVM: x86/mmu: Open code leaf invalidation from mmu_notifier
      KVM: x86/mmu: Stop zapping invalidated TDP MMU roots asynchronously

Tom Lendacky (2):
      KVM: SVM: Fix TSC_AUX virtualization setup
      KVM: SVM: Do not use user return MSR support for virtualized TSC_AUX

 arch/arm64/include/asm/kvm_hyp.h                 |   2 +-
 arch/arm64/kvm/hyp/include/nvhe/ffa.h            |   2 +-
 arch/arm64/kvm/hyp/nvhe/ffa.c                    |   3 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S               |   1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c               |   8 +-
 arch/arm64/kvm/hyp/nvhe/psci-relay.c             |   3 +-
 arch/arm64/kvm/mmu.c                             |   3 +
 arch/riscv/kvm/vcpu_onereg.c                     |   7 +-
 arch/x86/include/asm/kvm_host.h                  |   3 +-
 arch/x86/kvm/mmu/mmu.c                           |  21 +---
 arch/x86/kvm/mmu/mmu_internal.h                  |  15 ++-
 arch/x86/kvm/mmu/tdp_mmu.c                       | 152 ++++++++++-------------
 arch/x86/kvm/mmu/tdp_mmu.h                       |   5 +-
 arch/x86/kvm/svm/sev.c                           |  34 +++--
 arch/x86/kvm/svm/svm.c                           |  43 +++++--
 arch/x86/kvm/svm/svm.h                           |   1 +
 arch/x86/kvm/x86.c                               |   5 +-
 include/linux/arm-smccc.h                        |   2 +
 tools/testing/selftests/kvm/lib/test_util.c      |   2 +-
 tools/testing/selftests/kvm/riscv/get-reg-list.c |  60 ++++++---
 20 files changed, 210 insertions(+), 162 deletions(-)

