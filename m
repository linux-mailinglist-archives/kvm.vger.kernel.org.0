Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D25877D4AE8
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 10:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233892AbjJXIwV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 04:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232752AbjJXIwU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 04:52:20 -0400
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53394AC
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 01:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698137539; x=1729673539;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=05opl6eHOEUc53Rp+2mgfwcFNpjlhzO/jsMIMmFWdfA=;
  b=Rrzyp+U+0F/d/nhos0sI9GY98H248sjCJKOnXus8qzl5I6JWA0FdtP8Z
   5h556lUk6AtQtdvWXZjyhXG0fhSGQp8eZvOA50fr9kaPAmvFWG+W2Fr1s
   O3vnofZsXuUgL2ZubE00OZDvcHpHPeIIFuJqa4+OAAkJpbTcYHHbGiZcY
   t5eL5I/OX/JmzuG/M4mBZ+FZAuTCRhf2lzEenxu0V/d34TDc8Ea3UpWWO
   NM/ClLU1sxWswJP6AEAfqgEDIt0/VMvFPnPqnv7nQ73C0JY4tvAw/sRQc
   8au7GxLC/foGBznEHb95p5F6ZROnSFgCQblEUsjmHKg2/8d3nbSPr1CIB
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="5638301"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="5638301"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 01:52:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="793417959"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="793417959"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga001.jf.intel.com with ESMTP; 24 Oct 2023 01:52:14 -0700
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
        Babu Moger <babu.moger@amd.com>,
        Yongwei Ma <yongwei.ma@intel.com>,
        Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v5 02/20] tests: Rename test-x86-cpuid.c to test-x86-topo.c
Date:   Tue, 24 Oct 2023 17:03:05 +0800
Message-Id: <20231024090323.1859210-3-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231024090323.1859210-1-zhao1.liu@linux.intel.com>
References: <20231024090323.1859210-1-zhao1.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zhao Liu <zhao1.liu@intel.com>

The tests in this file actually test the APIC ID combinations.
Rename to test-x86-topo.c to make its name more in line with its
actual content.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Tested-by: Babu Moger <babu.moger@amd.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
Changes since v3:
 * Modify the description in commit message to emphasize this file tests
   APIC ID combinations. (Babu)

Changes since v1:
 * Rename test-x86-apicid.c to test-x86-topo.c. (Yanan)
---
 MAINTAINERS                                      | 2 +-
 tests/unit/meson.build                           | 4 ++--
 tests/unit/{test-x86-cpuid.c => test-x86-topo.c} | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)
 rename tests/unit/{test-x86-cpuid.c => test-x86-topo.c} (99%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7f9912baa094..60a69822c262 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1748,7 +1748,7 @@ F: include/hw/southbridge/ich9.h
 F: include/hw/southbridge/piix.h
 F: hw/isa/apm.c
 F: include/hw/isa/apm.h
-F: tests/unit/test-x86-cpuid.c
+F: tests/unit/test-x86-topo.c
 F: tests/qtest/test-x86-cpuid-compat.c
 
 PC Chipset
diff --git a/tests/unit/meson.build b/tests/unit/meson.build
index f33ae64b8dc6..0dbe32ba9b83 100644
--- a/tests/unit/meson.build
+++ b/tests/unit/meson.build
@@ -21,8 +21,8 @@ tests = {
   'test-opts-visitor': [testqapi],
   'test-visitor-serialization': [testqapi],
   'test-bitmap': [],
-  # all code tested by test-x86-cpuid is inside topology.h
-  'test-x86-cpuid': [],
+  # all code tested by test-x86-topo is inside topology.h
+  'test-x86-topo': [],
   'test-cutils': [],
   'test-div128': [],
   'test-shift128': [],
diff --git a/tests/unit/test-x86-cpuid.c b/tests/unit/test-x86-topo.c
similarity index 99%
rename from tests/unit/test-x86-cpuid.c
rename to tests/unit/test-x86-topo.c
index bfabc0403a1a..2b104f86d7c2 100644
--- a/tests/unit/test-x86-cpuid.c
+++ b/tests/unit/test-x86-topo.c
@@ -1,5 +1,5 @@
 /*
- *  Test code for x86 CPUID and Topology functions
+ *  Test code for x86 APIC ID and Topology functions
  *
  *  Copyright (c) 2012 Red Hat Inc.
  *
-- 
2.34.1

