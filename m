Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039F223563F
	for <lists+kvm@lfdr.de>; Sun,  2 Aug 2020 12:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728211AbgHBKMT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Aug 2020 06:12:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36573 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726376AbgHBKMS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Aug 2020 06:12:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596363137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jSxQ0k8/M2yKLog8LDz8HUyTSs6ZWh+UyZwI9wLnctI=;
        b=UIKrZiraww6gBMT+bgdpJMUEofHscKNRvlmjKuafCLaYNgz7wTHuYKEzJagrTnLU3QfMl3
        5LQxtG1JS4wT/+1cS4XD7ZaURXmKw+gU3654SBUc1S7JR/4e4roynTkBImb3rIeLO5GFWb
        xjv93pcvZlkBl7wNRKh2XGrIXBWIfDI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-x18vteqNN6CxokD561CStA-1; Sun, 02 Aug 2020 06:12:13 -0400
X-MC-Unique: x18vteqNN6CxokD561CStA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F1658015FB;
        Sun,  2 Aug 2020 10:12:12 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1EB6D60CD1;
        Sun,  2 Aug 2020 10:12:12 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] Final KVM changes for Linux 5.8
Date:   Sun,  2 Aug 2020 06:12:11 -0400
Message-Id: <20200802101211.8454-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 3d9fdc252b52023260de1d12399cb3157ed28c07:

  KVM: MIPS: Fix build errors for 32bit kernel (2020-07-10 06:15:38 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 830f01b089b12bbe93bd55f2d62837253012a30e:

  KVM: SVM: Fix disable pause loop exit/pause filtering capability on SVM (2020-07-31 03:20:32 -0400)

----------------------------------------------------------------
Bugfixes and strengthening the validity checks on inputs from new userspace APIs.

----------------------------------------------------------------

Now I know why I shouldn't prepare pull requests on the weekend, it's
hard to concentrate if your son is shouting about his latest Minecraft
builds in your ear.  Fortunately all the patches were ready and I just
had to check the test results...

Marc Zyngier (1):
      KVM: arm64: Prevent vcpu_has_ptrauth from generating OOL functions

Paolo Bonzini (4):
      selftests: kvm: do not set guest mode flag
      KVM: nVMX: check for required but missing VMCS12 in KVM_SET_NESTED_STATE
      KVM: nVMX: check for invalid hdr.vmx.flags
      Merge tag 'kvmarm-fixes-5.8-4' of git://git.kernel.org/.../kvmarm/kvmarm into kvm-master

Wanpeng Li (2):
      KVM: LAPIC: Prevent setting the tscdeadline timer if the lapic is hw disabled
      KVM: SVM: Fix disable pause loop exit/pause filtering capability on SVM

Will Deacon (1):
      KVM: arm64: Don't inherit exec permission across page-table levels

 arch/arm64/include/asm/kvm_host.h                  | 11 ++++--
 arch/arm64/kvm/mmu.c                               | 11 +++---
 arch/x86/kvm/lapic.c                               |  2 +-
 arch/x86/kvm/svm/svm.c                             |  9 +++--
 arch/x86/kvm/vmx/nested.c                          | 16 +++++++--
 arch/x86/kvm/vmx/nested.h                          |  5 +++
 .../kvm/x86_64/vmx_set_nested_state_test.c         | 42 +++++++++++++++++-----
 7 files changed, 72 insertions(+), 24 deletions(-)

