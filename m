Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11C2C173F9B
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 19:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgB1Sa3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 13:30:29 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41135 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725769AbgB1Sa3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Feb 2020 13:30:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582914626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rPZKnbvXl6Mhr7grrs/+4ekdFdBwP31/FLAQ1ju56IY=;
        b=h/Tmda5q3/peW380w8BeJAPbtKHLx8VIFjZ5wgNPPmV248sg5TFt5RyanEjf0uC43dnvQA
        Gbvy1EiEbJXvEzqgoV3XGGJni4uvrdGC2ELJ59feKV6h3ybiK4hD9jIdGNLi0HfBb2igEz
        m+4yVRb7GB74TMpGBQ4vVlbsZngLlfM=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-8RujVEhTPkmh79ocRi3fBQ-1; Fri, 28 Feb 2020 13:30:22 -0500
X-MC-Unique: 8RujVEhTPkmh79ocRi3fBQ-1
Received: by mail-qk1-f197.google.com with SMTP id s18so3629566qkj.6
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2020 10:30:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rPZKnbvXl6Mhr7grrs/+4ekdFdBwP31/FLAQ1ju56IY=;
        b=oo/ewbsn4NlItjZwK0Eg1fCjXkc4uvkF3h95qW0QdPhuQtSC954NhxIkv+jZNv6bb2
         4fZDm61/dqyB9mq+Sn8Q41VSMtuwUNOvbm+u2pdEKZMYkS5XwLCiejA1xJTK2OrUXGCM
         Ad+ITp6pYRuanTCcvzIkW9whjDumyW/4NmXpMkqn7sF+5pEH9jbWkuGtQOYH7eRsh6h9
         UdzvJtiiujVPXb/oLpXThS5pq/JfLvU6FtBs1xm5xAAYAqed8BdCaNHJX2wf0yB8As6O
         rArkgQoTBnSmaIb+fDuoUpwa4rFWYwhRn++x/Hzs6ucwfBUv+xoY08PYKGrfCon4vuc6
         PfVw==
X-Gm-Message-State: APjAAAXi8NgMRL86zwuyPKgACq6Uh/zHX/J8yXu+EPtQkdO++vhJTc2d
        ZBB8DLnHvfQQFDDFHia2inPsZ+Txd5F2qNrP/ZYXGKZz1e+S9zeHcjwZLOXyuLWZTC/Jz8ZxWnh
        UikwNArCGEBsR
X-Received: by 2002:ae9:eb0f:: with SMTP id b15mr5438627qkg.421.1582914622270;
        Fri, 28 Feb 2020 10:30:22 -0800 (PST)
X-Google-Smtp-Source: APXvYqwNyvKB2WECiHOFTVaTrF27wgcONWYIfPI4oSy+jms0mTZ7zXf5CfKiXZf4wy9iHDS6DFfaUQ==
X-Received: by 2002:ae9:eb0f:: with SMTP id b15mr5438596qkg.421.1582914621990;
        Fri, 28 Feb 2020 10:30:21 -0800 (PST)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id k4sm5331572qtj.74.2020.02.28.10.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 10:30:21 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com, jianjay.zhou@huawei.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2] KVM: Remove unnecessary asm/kvm_host.h includes
Date:   Fri, 28 Feb 2020 13:30:20 -0500
Message-Id: <20200228183020.398692-1-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove includes of asm/kvm_host.h from files that already include
linux/kvm_host.h to make it more obvious that there is no ordering issue
between the two headers.  linux/kvm_host.h includes asm/kvm_host.h to
pick up architecture specific settings, and this will never change, i.e.
including asm/kvm_host.h after linux/kvm_host.h may seem problematic,
but in practice is simply redundant.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
v2:
- s/unecessary/unnecessary/
- use Sean's suggested commit message
---
 arch/arm/kvm/coproc.c                | 1 -
 arch/arm64/kvm/fpsimd.c              | 1 -
 arch/arm64/kvm/guest.c               | 1 -
 arch/arm64/kvm/hyp/switch.c          | 1 -
 arch/arm64/kvm/sys_regs.c            | 1 -
 arch/arm64/kvm/sys_regs_generic_v8.c | 1 -
 arch/powerpc/kvm/book3s_64_vio.c     | 1 -
 arch/powerpc/kvm/book3s_64_vio_hv.c  | 1 -
 arch/powerpc/kvm/book3s_hv.c         | 1 -
 arch/powerpc/kvm/mpic.c              | 1 -
 arch/powerpc/kvm/powerpc.c           | 1 -
 arch/powerpc/kvm/timing.h            | 1 -
 arch/s390/kvm/intercept.c            | 1 -
 arch/x86/kvm/mmu/page_track.c        | 1 -
 virt/kvm/arm/psci.c                  | 1 -
 15 files changed, 15 deletions(-)

diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index 07745ee022a1..f0c09049ee99 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -10,7 +10,6 @@
 #include <linux/kvm_host.h>
 #include <linux/uaccess.h>
 #include <asm/kvm_arm.h>
-#include <asm/kvm_host.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_coproc.h>
 #include <asm/kvm_mmu.h>
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 525010504f9d..e329a36b2bee 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -11,7 +11,6 @@
 #include <linux/kvm_host.h>
 #include <asm/fpsimd.h>
 #include <asm/kvm_asm.h>
-#include <asm/kvm_host.h>
 #include <asm/kvm_mmu.h>
 #include <asm/sysreg.h>
 
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 2bd92301d32f..23ebe51410f0 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -25,7 +25,6 @@
 #include <asm/kvm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_coproc.h>
-#include <asm/kvm_host.h>
 #include <asm/sigcontext.h>
 
 #include "trace.h"
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index dfe8dd172512..f3e0ab961565 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -17,7 +17,6 @@
 #include <asm/kprobes.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
-#include <asm/kvm_host.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 #include <asm/fpsimd.h>
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3e909b117f0c..b95f7b7743c8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -22,7 +22,6 @@
 #include <asm/kvm_arm.h>
 #include <asm/kvm_coproc.h>
 #include <asm/kvm_emulate.h>
-#include <asm/kvm_host.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 #include <asm/perf_event.h>
diff --git a/arch/arm64/kvm/sys_regs_generic_v8.c b/arch/arm64/kvm/sys_regs_generic_v8.c
index 2b4a3e2d1b89..9cb6b4c8355a 100644
--- a/arch/arm64/kvm/sys_regs_generic_v8.c
+++ b/arch/arm64/kvm/sys_regs_generic_v8.c
@@ -12,7 +12,6 @@
 #include <asm/cputype.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
-#include <asm/kvm_host.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_coproc.h>
 #include <asm/sysreg.h>
diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index ee6c103bb7d5..50555ad1db93 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -27,7 +27,6 @@
 #include <asm/hvcall.h>
 #include <asm/synch.h>
 #include <asm/ppc-opcode.h>
-#include <asm/kvm_host.h>
 #include <asm/udbg.h>
 #include <asm/iommu.h>
 #include <asm/tce.h>
diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
index ab6eeb8e753e..6fcaf1fa8e02 100644
--- a/arch/powerpc/kvm/book3s_64_vio_hv.c
+++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
@@ -24,7 +24,6 @@
 #include <asm/hvcall.h>
 #include <asm/synch.h>
 #include <asm/ppc-opcode.h>
-#include <asm/kvm_host.h>
 #include <asm/udbg.h>
 #include <asm/iommu.h>
 #include <asm/tce.h>
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 2cefd071b848..f065d6956342 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -72,7 +72,6 @@
 #include <asm/xics.h>
 #include <asm/xive.h>
 #include <asm/hw_breakpoint.h>
-#include <asm/kvm_host.h>
 #include <asm/kvm_book3s_uvmem.h>
 #include <asm/ultravisor.h>
 
diff --git a/arch/powerpc/kvm/mpic.c b/arch/powerpc/kvm/mpic.c
index fe312c160d97..23e9c2bd9f27 100644
--- a/arch/powerpc/kvm/mpic.c
+++ b/arch/powerpc/kvm/mpic.c
@@ -32,7 +32,6 @@
 #include <linux/uaccess.h>
 #include <asm/mpic.h>
 #include <asm/kvm_para.h>
-#include <asm/kvm_host.h>
 #include <asm/kvm_ppc.h>
 #include <kvm/iodev.h>
 
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 1af96fb5dc6f..c1f23cb4206c 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -32,7 +32,6 @@
 #include <asm/plpar_wrappers.h>
 #endif
 #include <asm/ultravisor.h>
-#include <asm/kvm_host.h>
 
 #include "timing.h"
 #include "irq.h"
diff --git a/arch/powerpc/kvm/timing.h b/arch/powerpc/kvm/timing.h
index ace65f9fed30..feef7885ba82 100644
--- a/arch/powerpc/kvm/timing.h
+++ b/arch/powerpc/kvm/timing.h
@@ -10,7 +10,6 @@
 #define __POWERPC_KVM_EXITTIMING_H__
 
 #include <linux/kvm_host.h>
-#include <asm/kvm_host.h>
 
 #ifdef CONFIG_KVM_EXIT_TIMING
 void kvmppc_init_timing_stats(struct kvm_vcpu *vcpu);
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index a389fa85cca2..3655196f1c03 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -12,7 +12,6 @@
 #include <linux/errno.h>
 #include <linux/pagemap.h>
 
-#include <asm/kvm_host.h>
 #include <asm/asm-offsets.h>
 #include <asm/irq.h>
 #include <asm/sysinfo.h>
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 3521e2d176f2..0713778b8e12 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -14,7 +14,6 @@
 #include <linux/kvm_host.h>
 #include <linux/rculist.h>
 
-#include <asm/kvm_host.h>
 #include <asm/kvm_page_track.h>
 
 #include "mmu.h"
diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
index 17e2bdd4b76f..14a162e295a9 100644
--- a/virt/kvm/arm/psci.c
+++ b/virt/kvm/arm/psci.c
@@ -12,7 +12,6 @@
 
 #include <asm/cputype.h>
 #include <asm/kvm_emulate.h>
-#include <asm/kvm_host.h>
 
 #include <kvm/arm_psci.h>
 #include <kvm/arm_hypercalls.h>
-- 
2.24.1

