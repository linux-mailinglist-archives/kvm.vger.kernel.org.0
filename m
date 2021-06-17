Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38663ABBEA
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 20:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbhFQSiP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 14:38:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59622 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231289AbhFQSiP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Jun 2021 14:38:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623954966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=N/27r8jjnxPGdpC0ykYj/q5IIkngOTZIKQLUhzWLbTA=;
        b=EXDv/ROb9DubvUe7CcVY2zjCCs4o4hukIvwsl6J8N/XaY3N45fhuAioLN/d507H3CgYGG4
        +HGazNf6DiF3AS3jsvh47Vkc8260bbV7fUykaT3f/j9zus1oX7Fcmwi+wBFOo9bs+2UfZK
        6gAVVzlfov65xzgkahKPKEuoZE3hJoU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-SvJ4QTmCPgenZh_8kcQZAw-1; Thu, 17 Jun 2021 14:36:05 -0400
X-MC-Unique: SvJ4QTmCPgenZh_8kcQZAw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44EAB818703;
        Thu, 17 Jun 2021 18:36:04 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E7EBAF6EA;
        Thu, 17 Jun 2021 18:36:03 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 5.13-rc7
Date:   Thu, 17 Jun 2021 14:36:03 -0400
Message-Id: <20210617183603.844718-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 4422829e8053068e0225e4d0ef42dc41ea7c9ef5:

  kvm: fix previous commit for 32-bit builds (2021-06-09 01:49:13 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to d8ac05ea13d789d5491a5920d70a05659015441d:

  KVM: selftests: Fix kvm_check_cap() assertion (2021-06-17 13:06:57 -0400)

----------------------------------------------------------------
Miscellaneous bugfixes.  The main interesting one is a NULL pointer dereference
reported by syzkaller ("KVM: x86: Immediately reset the MMU context when the SMM
flag is cleared").

----------------------------------------------------------------
Alper Gun (1):
      KVM: SVM: Call SEV Guest Decommission if ASID binding fails

ChenXiaoSong (1):
      KVM: SVM: fix doc warnings

Fuad Tabba (1):
      KVM: selftests: Fix kvm_check_cap() assertion

Gustavo A. R. Silva (1):
      KVM: x86: Fix fall-through warnings for Clang

Jim Mattson (1):
      kvm: LAPIC: Restore guard to prevent illegal APIC register access

Sean Christopherson (2):
      KVM: x86: Immediately reset the MMU context when the SMM flag is cleared
      KVM: x86/mmu: Calculate and check "full" mmu_role for nested MMU

Wanpeng Li (1):
      KVM: X86: Fix x86_emulator slab cache leak

Yanan Wang (1):
      KVM: selftests: Fix compiling errors when initializing the static structure

 arch/x86/kvm/cpuid.c                        |  1 +
 arch/x86/kvm/lapic.c                        |  3 +++
 arch/x86/kvm/mmu/mmu.c                      | 26 +++++++++++++++++++-
 arch/x86/kvm/svm/avic.c                     |  6 ++---
 arch/x86/kvm/svm/sev.c                      | 20 +++++++++++----
 arch/x86/kvm/vmx/vmx.c                      |  1 +
 arch/x86/kvm/x86.c                          |  6 ++++-
 tools/testing/selftests/kvm/lib/kvm_util.c  |  2 +-
 tools/testing/selftests/kvm/lib/test_util.c | 38 ++++++++++++++---------------
 9 files changed, 73 insertions(+), 30 deletions(-)

