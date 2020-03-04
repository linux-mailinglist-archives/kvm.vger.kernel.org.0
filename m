Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82890178C3C
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 09:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbgCDIGu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 03:06:50 -0500
Received: from mga06.intel.com ([134.134.136.31]:29965 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725271AbgCDIGu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 03:06:50 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 00:06:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,513,1574150400"; 
   d="scan'208";a="233948346"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.160])
  by orsmga008.jf.intel.com with ESMTP; 04 Mar 2020 00:06:47 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [kvm-unit-tests PATCH] x86: Move definition of some exception vectors into processor.h
Date:   Wed,  4 Mar 2020 15:49:32 +0800
Message-Id: <20200304074932.77095-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Both processor.h and desc.h hold some definitions of exception vector.
put them together in processor.h

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 lib/x86/desc.h      | 5 -----
 lib/x86/processor.h | 3 +++
 x86/debug.c         | 1 +
 x86/idt_test.c      | 1 +
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 00b93285f5c6..0fe5cbf35577 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -91,11 +91,6 @@ typedef struct  __attribute__((packed)) {
     "1111:"
 #endif
 
-#define DB_VECTOR   1
-#define BP_VECTOR   3
-#define UD_VECTOR   6
-#define GP_VECTOR   13
-
 /*
  * selector     32-bit                        64-bit
  * 0x00         NULL descriptor               NULL descriptor
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 103e52b19d82..67ba416b73ff 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -15,6 +15,9 @@
 #  define S "4"
 #endif
 
+#define DB_VECTOR 1
+#define BP_VECTOR 3
+#define UD_VECTOR 6
 #define DF_VECTOR 8
 #define TS_VECTOR 10
 #define NP_VECTOR 11
diff --git a/x86/debug.c b/x86/debug.c
index c5db4c6ecf5a..972762a72ce8 100644
--- a/x86/debug.c
+++ b/x86/debug.c
@@ -10,6 +10,7 @@
  */
 
 #include "libcflat.h"
+#include "processor.h"
 #include "desc.h"
 
 static volatile unsigned long bp_addr;
diff --git a/x86/idt_test.c b/x86/idt_test.c
index aa2973301ee0..964f119060ee 100644
--- a/x86/idt_test.c
+++ b/x86/idt_test.c
@@ -1,4 +1,5 @@
 #include "libcflat.h"
+#include "processor.h"
 #include "desc.h"
 
 static int test_ud2(bool *rflags_rf)
-- 
2.20.1

