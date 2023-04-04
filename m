Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373356D6AE6
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 19:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbjDDRwC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 13:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbjDDRwA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 13:52:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD5E1FDA
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 10:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680630673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=iZSxHS25wevEedcDipS2H4ThAisXjNv5NMwYYVZhTik=;
        b=Ci4ypxaaUwFuhf0nlmUmjeK4Q7dRUCdD/B+SpewmB7eB+REgZDuRhTawoy7RVr2u5MjOPT
        N1UMUkJ5xh2brtgnU2wInqq+czi3RhFztXXx55Ttb6uPV78Bt95Ozf1dW2QQJHRW2HoewF
        6SvZCm8hufQGYDn6/OQbK8HXgjg9tOw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-7avhQwGWMBeSkS5kZLCfZA-1; Tue, 04 Apr 2023 13:51:11 -0400
X-MC-Unique: 7avhQwGWMBeSkS5kZLCfZA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C66B857FB8;
        Tue,  4 Apr 2023 17:51:07 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F5E440C6EC4;
        Tue,  4 Apr 2023 17:51:07 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 6.4-rc5
Date:   Tue,  4 Apr 2023 13:51:06 -0400
Message-Id: <20230404175106.757011-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 9e347ba03029e10e6405f8c3a7a91a5597943ed9:

  Merge tag 'kvm-riscv-fixes-6.3-1' of https://github.com/kvm-riscv/linux into HEAD (2023-03-27 10:04:07 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to fb5015bc8b733323b58f015b88e4f316010ec856:

  docs: kvm: x86: Fix broken field list (2023-04-04 13:22:05 -0400)

----------------------------------------------------------------
PPC:

* Hide KVM_CAP_IRQFD_RESAMPLE if XIVE is enabled

s390:

* Fix handling of external interrupts in protected guests

x86:

* Resample the pending state of IOAPIC interrupts when unmasking them

* Fix usage of Hyper-V "enlightened TLB" on AMD

* Small fixes to real mode exceptions

* Suppress pending MMIO write exits if emulator detects exception

Documentation:

* Fix rST syntax

----------------------------------------------------------------
Alexey Kardashevskiy (1):
      KVM: PPC: Make KVM_CAP_IRQFD_RESAMPLE platform dependent

Dmytro Maluka (2):
      KVM: irqfd: Make resampler_list an RCU list
      KVM: x86/ioapic: Resample the pending state of an IRQ when unmasking

Jeremi Piotrowski (1):
      KVM: SVM: Flush Hyper-V TLB when required

Nico Boehr (1):
      KVM: s390: pv: fix external interruption loop not always detected

Paolo Bonzini (1):
      Merge tag 'kvm-s390-master-6.3-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD

Sean Christopherson (3):
      KVM: x86: Suppress pending MMIO write exits if emulator detects exception
      KVM: x86: Clear "has_error_code", not "error_code", for RM exception injection
      KVM: nVMX: Do not report error code when synthesizing VM-Exit from Real Mode

Takahiro Itazuri (1):
      docs: kvm: x86: Fix broken field list

 Documentation/virt/kvm/api.rst  |  4 ++--
 arch/arm64/kvm/arm.c            |  1 +
 arch/powerpc/kvm/powerpc.c      |  6 ++++++
 arch/s390/kvm/intercept.c       | 32 ++++++++++++++++++++++++--------
 arch/s390/kvm/kvm-s390.c        |  1 +
 arch/x86/kvm/ioapic.c           | 36 +++++++++++++++++++++++++++++++++---
 arch/x86/kvm/kvm_onhyperv.h     |  5 +++++
 arch/x86/kvm/svm/svm.c          | 37 ++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/svm/svm_onhyperv.h | 15 +++++++++++++++
 arch/x86/kvm/vmx/nested.c       |  7 ++++++-
 arch/x86/kvm/x86.c              | 14 ++++++++++++--
 include/linux/kvm_host.h        | 11 +++++++++++
 include/linux/kvm_irqfd.h       |  2 +-
 virt/kvm/eventfd.c              | 49 +++++++++++++++++++++++++++++++++++++++++--------
 virt/kvm/kvm_main.c             |  1 -
 15 files changed, 192 insertions(+), 29 deletions(-)

