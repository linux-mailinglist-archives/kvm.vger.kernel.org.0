Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1E479FCDF
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 09:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235904AbjINHL7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 03:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232122AbjINHL6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 03:11:58 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE04CCD
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 00:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694675514; x=1726211514;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o0xqXS2pqWHAmiFScEJ8wU0LIvknrc6zkMnLQpxHdcY=;
  b=Y2Rr4kfgfnYz3C3et8jMvqAFXjfzdfoRUdZ/BE65esp2AdJUnF44ApNb
   SCm2LOfVk2nKIAMsNZGXGgtzu5pcTq/8GKKoU84l0lffFUU+JhT5jBRAk
   fWqqjr05LUuyYaqVyDBzQn+kj2EuUQpJg+Gg4+xa8/qSLPdmyUuoUjkTT
   P3t+8zE6WRDxh+CuBzJFCVbT1kkasVGx0SVxgHS6tQmneOEux/vJ78Wxv
   /q0bhu1m/Gk6HKZljUL2mrAieTLhpYya3NrnNHfTYHhTTM2t7IDYRHkF8
   3we1hC8zgY7V/xqTINb4kjifrLomQbf9K3fqX1jMsbcplbOUax6uDqIi1
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="359135927"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="359135927"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 00:11:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="779526212"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="779526212"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga001.jf.intel.com with ESMTP; 14 Sep 2023 00:11:29 -0700
From:   Zhao Liu <zhao1.liu@linux.intel.com>
To:     Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Zhenyu Wang <zhenyu.z.wang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Babu Moger <babu.moger@amd.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v4 04/21] hw/cpu: Update the comments of nr_cores and nr_dies
Date:   Thu, 14 Sep 2023 15:21:42 +0800
Message-Id: <20230914072159.1177582-5-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
References: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zhao Liu <zhao1.liu@intel.com>

In the nr_threads' comment, specify it represents the
number of threads in the "core" to avoid confusion.

Also add comment for nr_dies in CPUX86State.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since v3:
 * The new patch split out of CPUSTATE.nr_cores' fix. (Xiaoyao)
---
 include/hw/core/cpu.h | 2 +-
 target/i386/cpu.h     | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 92a4234439a3..df908b23c692 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -277,7 +277,7 @@ struct qemu_work_item;
  *   See TranslationBlock::TCG CF_CLUSTER_MASK.
  * @tcg_cflags: Pre-computed cflags for this cpu.
  * @nr_cores: Number of cores within this CPU package.
- * @nr_threads: Number of threads within this CPU.
+ * @nr_threads: Number of threads within this CPU core.
  * @running: #true if CPU is currently running (lockless).
  * @has_waiter: #true if a CPU is currently waiting for the cpu_exec_end;
  * valid under cpu_list_lock.
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index fbb05eace57e..70eb3bc23eb8 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1881,6 +1881,7 @@ typedef struct CPUArchState {
 
     TPRAccess tpr_access_type;
 
+    /* Number of dies within this CPU package. */
     unsigned nr_dies;
 } CPUX86State;
 
-- 
2.34.1

