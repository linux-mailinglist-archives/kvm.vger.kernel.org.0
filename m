Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D794322D8
	for <lists+kvm@lfdr.de>; Sun,  2 Jun 2019 11:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbfFBJup (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Jun 2019 05:50:45 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:34269 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbfFBJuo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Jun 2019 05:50:44 -0400
Received: by mail-ed1-f65.google.com with SMTP id c26so12007856edt.1;
        Sun, 02 Jun 2019 02:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u3baPT6NnNJAMlA9vKWsPZmTx286jlZiMcP5rx6KNI4=;
        b=aren1K6ad7kY70mRxgM7GGAHeiPHynWdd1Hu+YRCGCestJ6ZOp6Vn8iZyArxITse+L
         xY44QEBj0ajHgEpyDFjLe6N9GONA38Csy7tzDua5ZPtMu9JNPH+kNugWNr4nY6qDr+Y7
         NQ4JQJA7bewfz6YUBROYeiCzLIcJxzFoWeQR2Q06/lGA5onTbdLgLsXCll1aaZ3r0B6s
         wdjbYnIiTpx7FIDCSCINAzxnjhHrBvPikI90HHtZCbtb5x96lihU7dP4WE/GN/b7g8Fk
         bvGxIKfQt4QvK/JRFug3ln0Hyr2/pCRbVcx0Gjks6Qt2if8fQV9yDzfC+J1+BqFHYmu9
         dbYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=u3baPT6NnNJAMlA9vKWsPZmTx286jlZiMcP5rx6KNI4=;
        b=GHJK2+YzeG1atSe7JJQnvujHqmMH/vD402czuzF7l2L8LklgMdiVOuahzOKIwT13zV
         ZHkqgU8TIzs90dDAvtc/iiHD6LthnRpJ7rCApojGhpbOXn3u6HRnrEt3WAI8B8mI0vwg
         BkZPgYFCuNBgx8dHdBx2rGuUasWDOmOCucQIztRfJ5PftSV0uCrWNaePG1ZZ1HgjcHra
         NQs2I62++yYAxXN4iLqpqKdwgCEGDV+vIug9BqSAUrUPveuPAAPzU3BRJFv6ZuBfTSLA
         wjfgnOyXYHOtr/M3GSEivfTm0qMb6N/SbuuLDrXsvpLYGHKBnQMjpfpw+Ye9odphusmX
         oZPA==
X-Gm-Message-State: APjAAAXwt4u7isFeetnfsl/tr7nHjOl8862ymbqzliHwDK8rI9P2N44r
        TlcI5a6YXnXu3SYW3EHMKmlFAyAi
X-Google-Smtp-Source: APXvYqzB38n/Q4yzegdZMIIdoiBAEiswBxAFcY7WwOI4NRkOpe3Fo2xXsO5AZxyV5pHcFKQxMIYOMA==
X-Received: by 2002:a50:ec87:: with SMTP id e7mr21698848edr.126.1559469042892;
        Sun, 02 Jun 2019 02:50:42 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id o19sm850450eja.84.2019.06.02.02.50.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 02:50:41 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for 5.2-rc3
Date:   Sun,  2 Jun 2019 11:50:39 +0200
Message-Id: <1559469039-42045-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit cd6c84d8f0cdc911df435bb075ba22ce3c605b07:

  Linux 5.2-rc2 (2019-05-26 16:49:19 -0700)

are available in the git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to f8d221d2e0e1572d0d60174c118e3554d1aa79fa:

  Merge tag 'kvm-s390-master-5.2-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into kvm-master (2019-06-01 00:49:02 +0200)

----------------------------------------------------------------

Fixes for PPC and s390.

----------------------------------------------------------------
Christian Borntraeger (1):
      kvm: fix compile on s390 part 2

Cédric Le Goater (7):
      KVM: PPC: Book3S HV: XIVE: Clear file mapping when device is released
      KVM: PPC: Book3S HV: XIVE: Do not test the EQ flag validity when resetting
      KVM: PPC: Book3S HV: XIVE: Fix the enforced limit on the vCPU identifier
      KVM: PPC: Book3S HV: XIVE: Introduce a new mutex for the XIVE device
      KVM: PPC: Book3S HV: XIVE: Do not clear IRQ data of passthrough interrupts
      KVM: PPC: Book3S HV: XIVE: Take the srcu read lock when accessing memslots
      KVM: PPC: Book3S HV: XIVE: Fix page offset when clearing ESB pages

Paolo Bonzini (2):
      Merge tag 'kvm-ppc-fixes-5.2-1' of git://git.kernel.org/.../paulus/powerpc into kvm-master
      Merge tag 'kvm-s390-master-5.2-2' of git://git.kernel.org/.../kvms390/linux into kvm-master

Paul Mackerras (5):
      KVM: PPC: Book3S HV: Avoid touching arch.mmu_ready in XIVE release functions
      KVM: PPC: Book3S HV: Use new mutex to synchronize MMU setup
      KVM: PPC: Book3S: Use new mutex to synchronize access to rtas token list
      KVM: PPC: Book3S HV: Don't take kvm->lock around kvm_for_each_vcpu
      KVM: PPC: Book3S HV: Fix lockdep warning when entering guest on POWER9

Suraj Jitindar Singh (1):
      KVM: PPC: Book3S HV: Restore SPRG3 in kvmhv_p9_guest_entry()

Thomas Huth (1):
      KVM: s390: Do not report unusabled IDs via KVM_CAP_MAX_VCPU_ID

 arch/mips/kvm/mips.c                  |   3 +
 arch/powerpc/include/asm/kvm_host.h   |   2 +
 arch/powerpc/kvm/book3s.c             |   1 +
 arch/powerpc/kvm/book3s_64_mmu_hv.c   |  36 ++++++------
 arch/powerpc/kvm/book3s_hv.c          |  48 ++++++++++------
 arch/powerpc/kvm/book3s_rtas.c        |  14 ++---
 arch/powerpc/kvm/book3s_xive.c        |  55 +++++++++----------
 arch/powerpc/kvm/book3s_xive.h        |   1 +
 arch/powerpc/kvm/book3s_xive_native.c | 100 +++++++++++++++++++---------------
 arch/powerpc/kvm/powerpc.c            |   3 +
 arch/s390/kvm/kvm-s390.c              |   1 +
 arch/x86/kvm/x86.c                    |   3 +
 virt/kvm/arm/arm.c                    |   3 +
 virt/kvm/kvm_main.c                   |   4 +-
 14 files changed, 157 insertions(+), 117 deletions(-)
