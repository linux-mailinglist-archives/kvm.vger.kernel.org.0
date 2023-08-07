Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B14FE7726DF
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 16:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbjHGOB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 10:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232180AbjHGOBm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 10:01:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D8C1FFC
        for <kvm@vger.kernel.org>; Mon,  7 Aug 2023 06:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691416666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Xp1oqeDRZYna//2YOwNor1PRNcbpDVn9AtA0YOsdbXI=;
        b=efJMtux/+l0DnsqzGoT72ZvpXT3pfjtsHjwizZOOmnwcWbrGhElVqSJIG00rbQvsHTdC+h
        M6O7WTa1gkrR79axyKHz2xeiJosUcXL2so0ZyUKXoo2df72jzPFqj2aKz6HkqXRh0n7b17
        w15NuQzaGJYM8b2HasAR42XrG1yrU50=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-uF6iBe9oNna8EPtI-Fk9Xg-1; Mon, 07 Aug 2023 09:57:45 -0400
X-MC-Unique: uF6iBe9oNna8EPtI-Fk9Xg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 814D938210AE;
        Mon,  7 Aug 2023 13:52:44 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5311F40679C0;
        Mon,  7 Aug 2023 13:52:44 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        oliver.upton@linux.dev, seanjc@google.com
Subject: [GIT PULL] KVM changes for v6.5-rc6
Date:   Mon,  7 Aug 2023 09:52:43 -0400
Message-Id: <20230807135243.3394830-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 5a7591176c47cce363c1eed704241e5d1c42c5a6:

  KVM: selftests: Expand x86's sregs test to cover illegal CR0 values (2023-07-29 11:05:32 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to d5ad9aae13dcced333c1a7816ff0a4fbbb052466:

  selftests/rseq: Fix build with undefined __weak (2023-08-04 18:10:29 -0400)

I won't be around for the next couple weeks, so while submaintainers are
welcome to send me their merge window pull requests, any bug fixes will have
to go through the architecture trees.  At least for x86 things seem to be in
check, though.

Paolo

----------------------------------------------------------------
x86:

* Fix SEV race condition

ARM:

* Fixes for the configuration of SVE/SME traps when hVHE mode is in use

* Allow use of pKVM on systems with FF-A implementations that are v1.0
  compatible

* Request/release percpu IRQs (arch timer, vGIC maintenance) correctly
  when pKVM is in use

* Fix function prototype after __kvm_host_psci_cpu_entry() rename

* Skip to the next instruction when emulating writes to TCR_EL1 on
  AmpereOne systems

Selftests:

* Fix missing include

----------------------------------------------------------------
Arnd Bergmann (1):
      KVM: arm64: fix __kvm_host_psci_cpu_entry() prototype

Fuad Tabba (7):
      KVM: arm64: Factor out code for checking (h)VHE mode into a macro
      KVM: arm64: Use the appropriate feature trap register for SVE at EL2 setup
      KVM: arm64: Disable SME traps for (h)VHE at setup
      KVM: arm64: Helper to write to appropriate feature trap register based on mode
      KVM: arm64: Use the appropriate feature trap register when activating traps
      KVM: arm64: Fix resetting SVE trap values on reset for hVHE
      KVM: arm64: Fix resetting SME trap values on reset for (h)VHE

Mark Brown (1):
      selftests/rseq: Fix build with undefined __weak

Oliver Upton (3):
      KVM: arm64: Allow pKVM on v1.0 compatible FF-A implementations
      KVM: arm64: Rephrase percpu enable/disable tracking in terms of hyp
      KVM: arm64: Skip instruction after emulating write to TCR_EL1

Paolo Bonzini (4):
      KVM: SEV: snapshot the GHCB before accessing it
      KVM: SEV: only access GHCB fields once
      KVM: SEV: remove ghcb variable declarations
      Merge tag 'kvmarm-fixes-6.5-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD

Raghavendra Rao Ananta (1):
      KVM: arm64: Fix hardware enable/disable flows for pKVM

 arch/arm64/include/asm/el2_setup.h      |  44 ++++++++----
 arch/arm64/include/asm/kvm_asm.h        |   2 +-
 arch/arm64/include/asm/kvm_emulate.h    |  21 ++++--
 arch/arm64/kvm/arm.c                    |  61 +++++++---------
 arch/arm64/kvm/hyp/include/hyp/switch.h |   1 +
 arch/arm64/kvm/hyp/nvhe/ffa.c           |  15 +++-
 arch/arm64/kvm/hyp/nvhe/switch.c        |   2 +-
 arch/x86/kvm/svm/sev.c                  | 124 ++++++++++++++++----------------
 arch/x86/kvm/svm/svm.h                  |  26 +++++++
 tools/testing/selftests/rseq/Makefile   |   4 +-
 tools/testing/selftests/rseq/rseq.c     |   2 +
 11 files changed, 182 insertions(+), 120 deletions(-)

