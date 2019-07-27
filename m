Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E44F776E7
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2019 07:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbfG0FwV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Jul 2019 01:52:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:40958 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726427AbfG0FwT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Jul 2019 01:52:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 22:52:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,313,1559545200"; 
   d="scan'208";a="254568592"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 26 Jul 2019 22:52:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC PATCH 05/21] x86/sgx: Expose SGX architectural definitions to the kernel
Date:   Fri, 26 Jul 2019 22:51:58 -0700
Message-Id: <20190727055214.9282-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190727055214.9282-1-sean.j.christopherson@intel.com>
References: <20190727055214.9282-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM will use many of the architectural constants and structs to
virtualize SGX.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/{kernel/cpu/sgx/arch.h => include/asm/sgx_arch.h} | 0
 arch/x86/kernel/cpu/sgx/driver/driver.h                    | 2 +-
 arch/x86/kernel/cpu/sgx/encl.c                             | 2 +-
 arch/x86/kernel/cpu/sgx/encls.h                            | 2 +-
 arch/x86/kernel/cpu/sgx/main.c                             | 2 +-
 arch/x86/kernel/cpu/sgx/sgx.h                              | 3 +--
 tools/testing/selftests/x86/sgx/defines.h                  | 2 +-
 7 files changed, 6 insertions(+), 7 deletions(-)
 rename arch/x86/{kernel/cpu/sgx/arch.h => include/asm/sgx_arch.h} (100%)

diff --git a/arch/x86/kernel/cpu/sgx/arch.h b/arch/x86/include/asm/sgx_arch.h
similarity index 100%
rename from arch/x86/kernel/cpu/sgx/arch.h
rename to arch/x86/include/asm/sgx_arch.h
diff --git a/arch/x86/kernel/cpu/sgx/driver/driver.h b/arch/x86/kernel/cpu/sgx/driver/driver.h
index 6ce18c766a5a..4dc133f3c186 100644
--- a/arch/x86/kernel/cpu/sgx/driver/driver.h
+++ b/arch/x86/kernel/cpu/sgx/driver/driver.h
@@ -10,7 +10,7 @@
 #include <linux/sched.h>
 #include <linux/workqueue.h>
 #include <uapi/asm/sgx.h>
-#include "../arch.h"
+#include <asm/sgx_arch.h>
 #include "../encl.h"
 #include "../encls.h"
 #include "../sgx.h"
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 836c55d4352d..8549fd95f02d 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -7,7 +7,7 @@
 #include <linux/shmem_fs.h>
 #include <linux/suspend.h>
 #include <linux/sched/mm.h>
-#include "arch.h"
+#include <asm/sgx_arch.h>
 #include "encl.h"
 #include "encls.h"
 #include "sgx.h"
diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
index aea3b9d09936..1b49c7419767 100644
--- a/arch/x86/kernel/cpu/sgx/encls.h
+++ b/arch/x86/kernel/cpu/sgx/encls.h
@@ -8,7 +8,7 @@
 #include <linux/rwsem.h>
 #include <linux/types.h>
 #include <asm/asm.h>
-#include "arch.h"
+#include <asm/sgx_arch.h>
 
 /**
  * ENCLS_FAULT_FLAG - flag signifying an ENCLS return code is a trapnr
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index ead827371139..532dd90e09e1 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -10,8 +10,8 @@
 #include <linux/ratelimit.h>
 #include <linux/sched/signal.h>
 #include <linux/slab.h>
+#include <asm/sgx_arch.h>
 #include "driver/driver.h"
-#include "arch.h"
 #include "encls.h"
 #include "sgx.h"
 #include "virt.h"
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 16cdb935aaa7..748b1633d770 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -8,10 +8,9 @@
 #include <linux/rwsem.h>
 #include <linux/types.h>
 #include <asm/asm.h>
+#include <asm/sgx_arch.h>
 #include <uapi/asm/sgx_errno.h>
 
-#include "arch.h"
-
 struct sgx_epc_page {
 	unsigned long desc;
 	struct sgx_encl_page *owner;
diff --git a/tools/testing/selftests/x86/sgx/defines.h b/tools/testing/selftests/x86/sgx/defines.h
index 3ff73a9d9b93..ebc4c6cf57c4 100644
--- a/tools/testing/selftests/x86/sgx/defines.h
+++ b/tools/testing/selftests/x86/sgx/defines.h
@@ -33,7 +33,7 @@ typedef uint64_t u64;
 	(((~0ULL) - (1ULL << (l)) + 1) & \
 	 (~0ULL >> (BITS_PER_LONG_LONG - 1 - (h))))
 
-#include "../../../../../arch/x86/kernel/cpu/sgx/arch.h"
+#include "../../../../../arch/x86/include/asm/sgx_arch.h"
 #include "../../../../../arch/x86/include/uapi/asm/sgx.h"
 
 #endif /* TYPES_H */
-- 
2.22.0

