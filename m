Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 443974C368F
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 21:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbiBXUJS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 15:09:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234228AbiBXUJQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 15:09:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1326C2782AD
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 12:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645733324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=BZd1WVhqalDgY0pEVukQFKoKp+dFXjstcrXoRQTNR8c=;
        b=HnP6kmhBh0QdzU0T4w5oUujC6ZmALHNk6GE9F9YFdOuPvj89IzdZC1v6sYRLigqVMNGENQ
        w4Mv+99MPT0RamsKolvddRpLp0OaiDrtlkHfs8xf2G6wu5DY+IVFdblppvRabtOfmWRZAs
        Csa5kQ0RGS6n14WgoLqpzBdjuyEPok8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-1QK3e14cOouBo-54HfMhkQ-1; Thu, 24 Feb 2022 15:08:40 -0500
X-MC-Unique: 1QK3e14cOouBo-54HfMhkQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD769FC82;
        Thu, 24 Feb 2022 20:08:39 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5DC8C2270D;
        Thu, 24 Feb 2022 20:08:39 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 5.17-rc6
Date:   Thu, 24 Feb 2022 15:08:33 -0500
Message-Id: <20220224200833.2287352-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 710c476514313c74045c41c0571bb5178fd16e3d:

  KVM: x86/pmu: Use AMD64_RAW_EVENT_MASK for PERF_TYPE_RAW (2022-02-14 07:44:51 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to e910a53fb4f20aa012e46371ffb4c32c8da259b4:

  KVM: x86: nSVM: disallow userspace setting of MSR_AMD64_TSC_RATIO to non default value when tsc scaling disabled (2022-02-24 13:04:47 -0500)

----------------------------------------------------------------
x86 host:

* Expose KVM_CAP_ENABLE_CAP since it is supported

* Disable KVM_HC_CLOCK_PAIRING in TSC catchup mode

* Ensure async page fault token is nonzero

* Fix lockdep false negative

* Fix FPU migration regression from the AMX changes

x86 guest:

* Don't use PV TLB/IPI/yield on uniprocessor guests

PPC:
* reserve capability id (topic branch for ppc/kvm)

----------------------------------------------------------------
Aaron Lewis (1):
      KVM: x86: Add KVM_CAP_ENABLE_CAP to x86

Anton Romanov (1):
      kvm: x86: Disable KVM_HC_CLOCK_PAIRING if tsc is in always catchup mode

Leonardo Bras (3):
      x86/kvm/fpu: Limit guest user_xfeatures to supported bits of XCR0
      x86/kvm/fpu: Remove kvm_vcpu_arch.guest_supported_xcr0
      x86/kvm: Fix compilation warning in non-x86_64 builds

Liang Zhang (1):
      KVM: x86/mmu: make apf token non-zero to fix bug

Maxim Levitsky (1):
      KVM: x86: nSVM: disallow userspace setting of MSR_AMD64_TSC_RATIO to non default value when tsc scaling disabled

Nicholas Piggin (1):
      KVM: PPC: reserve capability 210 for KVM_CAP_PPC_AIL_MODE_3

Paolo Bonzini (1):
      Merge branch 'kvm-ppc-cap-210' into kvm-master

Wanpeng Li (2):
      KVM: Fix lockdep false negative during host resume
      x86/kvm: Don't use pv tlb/ipi/sched_yield if on 1 vCPU

 Documentation/virt/kvm/api.rst  | 16 +++++++++++++++-
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kernel/fpu/xstate.c    |  5 ++++-
 arch/x86/kernel/kvm.c           |  9 ++++++---
 arch/x86/kvm/cpuid.c            |  5 ++++-
 arch/x86/kvm/mmu/mmu.c          | 13 ++++++++++++-
 arch/x86/kvm/svm/svm.c          | 19 +++++++++++++++++--
 arch/x86/kvm/x86.c              | 30 +++++++++++++++++++++++++-----
 include/uapi/linux/kvm.h        |  1 +
 tools/include/uapi/linux/kvm.h  |  1 +
 virt/kvm/kvm_main.c             |  4 +---
 11 files changed, 86 insertions(+), 18 deletions(-)

