Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1CA5E7CA1
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 16:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbiIWONY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 10:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbiIWONT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 10:13:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2179F1A2
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 07:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663942398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3/tXnfx2ItcntdX91SAbA2MDsexn7TrLVcjXsKnHLr8=;
        b=KAw4qEGg+6s2TPsYzuHM7tbuwFMeotho8go7inWfYS4o/w35N+kWVvwne1W0gx26RZdUCU
        OmSpdBC9tBrFP9pBKzcAB9TjSAjH6XbqrHZvE1kLK7LkO1b9C1sMb1CgwIJsCbZ1928CR7
        Syy1gH8Pl9LYgFi8kVWF+1dNhB2PxAw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-WaWDUrP3OWaat30aMeE9dw-1; Fri, 23 Sep 2022 10:13:12 -0400
X-MC-Unique: WaWDUrP3OWaat30aMeE9dw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E685101E14D;
        Fri, 23 Sep 2022 14:13:12 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 427CA40C2066;
        Fri, 23 Sep 2022 14:13:12 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 5.0-rc7
Date:   Fri, 23 Sep 2022 10:13:12 -0400
Message-Id: <20220923141312.96688-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

As everyone back came back from conferences, here are the pending patches
for Linux 6.0.

The following changes since commit 521a547ced6477c54b4b0cc206000406c221b4d6:

  Linux 6.0-rc6 (2022-09-18 13:44:14 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 69604fe76e58c9d195e48b41d019b07fc27ce9d7:

  Merge tag 'kvm-s390-master-6.0-2' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD (2022-09-23 10:06:08 -0400)

----------------------------------------------------------------
ARM:

* Fix for kmemleak with pKVM

s390:

* Fixes for VFIO with zPCI

* smatch fix

x86:

* Ensure XSAVE-capable hosts always allow  FP and SSE state to be saved
  and restored via KVM_{GET,SET}_XSAVE

* Fix broken max_mmu_rmap_size stat

* Fix compile error with old glibc that doesn't have gettid()

----------------------------------------------------------------
Dr. David Alan Gilbert (1):
      KVM: x86: Always enable legacy FP/SSE in allowed user XFEATURES

Janis Schoetterl-Glausch (1):
      KVM: s390: Pass initialized arg even if unused

Jinrong Liang (1):
      selftests: kvm: Fix a compile error in selftests/kvm/rseq_test.c

Matthew Rosato (3):
      KVM: s390: pci: fix plain integer as NULL pointer warnings
      KVM: s390: pci: fix GAIT physical vs virtual pointers usage
      KVM: s390: pci: register pci hooks without interpretation

Miaohe Lin (1):
      KVM: x86/mmu: add missing update to max_mmu_rmap_size

Paolo Bonzini (2):
      Merge tag 'kvmarm-fixes-6.0-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-s390-master-6.0-2' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD

Sean Christopherson (2):
      KVM: x86: Reinstate kvm_vcpu_arch.guest_supported_xcr0
      KVM: x86: Inject #UD on emulated XSETBV if XSAVES isn't enabled

Zenghui Yu (1):
      KVM: arm64: Use kmemleak_free_part_phys() to unregister hyp_mem_base

 arch/arm64/kvm/arm.c                    |  2 +-
 arch/s390/kvm/gaccess.c                 | 16 +++++++++++++---
 arch/s390/kvm/interrupt.c               |  2 +-
 arch/s390/kvm/kvm-s390.c                |  4 ++--
 arch/s390/kvm/pci.c                     | 20 ++++++++++++++------
 arch/s390/kvm/pci.h                     |  6 +++---
 arch/x86/include/asm/kvm_host.h         |  1 +
 arch/x86/kvm/cpuid.c                    | 11 ++++++++---
 arch/x86/kvm/emulate.c                  |  3 +++
 arch/x86/kvm/mmu/mmu.c                  |  2 ++
 arch/x86/kvm/x86.c                      | 10 +++-------
 tools/testing/selftests/kvm/rseq_test.c |  2 +-
 12 files changed, 52 insertions(+), 27 deletions(-)

