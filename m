Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43802F9839
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 04:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731643AbhARD2q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Jan 2021 22:28:46 -0500
Received: from mga04.intel.com ([192.55.52.120]:7978 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731642AbhARD2o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Jan 2021 22:28:44 -0500
IronPort-SDR: z1ol3waqQBLcgU+jzfBky8DkdIsFuvKuCfog3y/4QZlmBZiJ/OrF7qNpai2hsLPsoGKIKv+pFR
 cmRf7V+MOOPg==
X-IronPort-AV: E=McAfee;i="6000,8403,9867"; a="176181385"
X-IronPort-AV: E=Sophos;i="5.79,355,1602572400"; 
   d="scan'208";a="176181385"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2021 19:28:03 -0800
IronPort-SDR: 6wawdg5lsuHy1fFvOC7yIeMD2oNd1dRJRgDqqEaFRPJoNNvGYQb2DEiIoK/ALFSyEyjdedxlBI
 0Vbwoas/IG9Q==
X-IronPort-AV: E=Sophos;i="5.79,355,1602572400"; 
   d="scan'208";a="573150940"
Received: from amrahman-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.142.253])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2021 19:28:00 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v2 08/26] x86/sgx: Expose SGX architectural definitions to the kernel
Date:   Mon, 18 Jan 2021 16:27:49 +1300
Message-Id: <25746564cb0a719a69b6138d8004b987a5e0bc91.1610935432.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1610935432.git.kai.huang@intel.com>
References: <cover.1610935432.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

KVM will use many of the architectural constants and structs to
virtualize SGX.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/{kernel/cpu/sgx/arch.h => include/asm/sgx_arch.h} | 0
 arch/x86/kernel/cpu/sgx/encl.c                             | 2 +-
 arch/x86/kernel/cpu/sgx/sgx.h                              | 2 +-
 tools/testing/selftests/sgx/defines.h                      | 2 +-
 4 files changed, 3 insertions(+), 3 deletions(-)
 rename arch/x86/{kernel/cpu/sgx/arch.h => include/asm/sgx_arch.h} (100%)

diff --git a/arch/x86/kernel/cpu/sgx/arch.h b/arch/x86/include/asm/sgx_arch.h
similarity index 100%
rename from arch/x86/kernel/cpu/sgx/arch.h
rename to arch/x86/include/asm/sgx_arch.h
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index a78b71447771..68941c349cfe 100644
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
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 5fa42d143feb..509f2af33e1d 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -8,7 +8,7 @@
 #include <linux/rwsem.h>
 #include <linux/types.h>
 #include <asm/asm.h>
-#include "arch.h"
+#include <asm/sgx_arch.h>
 
 #undef pr_fmt
 #define pr_fmt(fmt) "sgx: " fmt
diff --git a/tools/testing/selftests/sgx/defines.h b/tools/testing/selftests/sgx/defines.h
index 592c1ccf4576..4dd39a003f40 100644
--- a/tools/testing/selftests/sgx/defines.h
+++ b/tools/testing/selftests/sgx/defines.h
@@ -14,7 +14,7 @@
 #define __aligned(x) __attribute__((__aligned__(x)))
 #define __packed __attribute__((packed))
 
-#include "../../../../arch/x86/kernel/cpu/sgx/arch.h"
+#include "../../../../arch/x86/include/asm/sgx_arch.h"
 #include "../../../../arch/x86/include/asm/enclu.h"
 #include "../../../../arch/x86/include/uapi/asm/sgx.h"
 
-- 
2.29.2

