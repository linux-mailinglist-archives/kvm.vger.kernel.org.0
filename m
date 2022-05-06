Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE5CB51DE3B
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 19:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444142AbiEFRUi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 13:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352563AbiEFRUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 13:20:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3E0514F465
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 10:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651857413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1g+2xBYEm0OXHS/CQXNuLjQdFiP+UTDj3yuwqdtdFQE=;
        b=SsOqwwzHLuBUEFrT1+fOiPuef5F5ZQ1Y/YLxkgTdnRgSjUPIBrCWvFFOSVNEde4/C7GoPB
        QziL3BbxXccEuYPDW1XRu7W+ttgeG9CNvOC7W3gcTv/wH1E2yyBNitXBAoSS5lWZ2gxjbc
        OHCPJqbwvR1dM4+6sm3ZImcfxP8kEAk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-jPBn9JSVOte3qHUnX52gUA-1; Fri, 06 May 2022 13:16:50 -0400
X-MC-Unique: jPBn9JSVOte3qHUnX52gUA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF22D2999B55;
        Fri,  6 May 2022 17:16:49 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B34D014C2A1E;
        Fri,  6 May 2022 17:16:49 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 5.18-rc6
Date:   Fri,  6 May 2022 13:16:49 -0400
Message-Id: <20220506171649.1426392-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit f751d8eac17692905cdd6935f72d523d8adf3b65:

  KVM: x86: work around QEMU issue with synthetic CPUID leaves (2022-04-29 15:24:58 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 053d2290c0307e3642e75e0185ddadf084dc36c1:

  KVM: VMX: Exit to userspace if vCPU has injected exception and invalid state (2022-05-06 13:08:06 -0400)

----------------------------------------------------------------
x86:

* Account for family 17h event renumberings in AMD PMU emulation

* Remove CPUID leaf 0xA on AMD processors

* Fix lockdep issue with locking all vCPUs

* Fix loss of A/D bits in SPTEs

* Fix syzkaller issue with invalid guest state

----------------------------------------------------------------
Kyle Huey (1):
      KVM: x86/svm: Account for family 17h event renumberings in amd_pmc_perf_hw_id

Paolo Bonzini (2):
      Merge branch 'kvm-tdp-mmu-atomicity-fix' into HEAD
      Merge branch 'kvm-amd-pmu-fixes' into HEAD

Peter Gonda (1):
      KVM: SEV: Mark nested locking of vcpu->lock

Sandipan Das (1):
      kvm: x86/cpuid: Only provide CPUID leaf 0xA if host has architectural PMU

Sean Christopherson (4):
      KVM: x86/mmu: Don't treat fully writable SPTEs as volatile (modulo A/D)
      KVM: x86/mmu: Move shadow-present check out of spte_has_volatile_bits()
      KVM: x86/mmu: Use atomic XCHG to write TDP MMU SPTEs with volatile bits
      KVM: VMX: Exit to userspace if vCPU has injected exception and invalid state

 arch/x86/kvm/cpuid.c        |  5 +++
 arch/x86/kvm/mmu/mmu.c      | 34 +++----------------
 arch/x86/kvm/mmu/spte.c     | 28 ++++++++++++++++
 arch/x86/kvm/mmu/spte.h     |  4 ++-
 arch/x86/kvm/mmu/tdp_iter.h | 34 +++++++++++++++++--
 arch/x86/kvm/mmu/tdp_mmu.c  | 82 +++++++++++++++++++++++++++++----------------
 arch/x86/kvm/svm/pmu.c      | 28 ++++++++++++++--
 arch/x86/kvm/svm/sev.c      | 42 ++++++++++++++++++++---
 arch/x86/kvm/vmx/vmx.c      |  2 +-
 9 files changed, 190 insertions(+), 69 deletions(-)

