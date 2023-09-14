Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B39679FCDD
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 09:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235938AbjINHLd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 03:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235932AbjINHLb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 03:11:31 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FCB0E50
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 00:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694675486; x=1726211486;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ge7Ux0L98nZAT4BdO1zTFkQrOwTQXrhDDcBB51V5G1k=;
  b=NNUJEt/VyMXCmVoB7L1gFyivhuXdd4zLThw3QLnibd8Mkp4n2UcQ9JJR
   A8ALQMihqzRRMnCXyNMtvPn3+uwtTDX0GsE2wUWFy4RVzssa69vtzetkX
   oXV0ukNrIVKD1//FPPY9Ly55oyxMX3ClfPvS92IB8mN/zW3mlR+gz+Y0K
   fbgm19w/+oE4f6T/Rf954BcqSNL51PjlQCRLXd+/7w4RLJLUG+CFsXY75
   sUE8ML0/TI9omIgsnX5TMe4NqEkV71Bln+6Zcn72UHC2eB9R5Uf/dU6YT
   JtoizoW0JDeA7C4DcxtSsHqsTppe5Zg3N8sv6PVUv6SCazBjlpD1BJ/Gj
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="359135837"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="359135837"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 00:11:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="779526084"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="779526084"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga001.jf.intel.com with ESMTP; 14 Sep 2023 00:11:21 -0700
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
        Zhao Liu <zhao1.liu@intel.com>,
        Yongwei Ma <yongwei.ma@intel.com>
Subject: [PATCH v4 02/21] tests: Rename test-x86-cpuid.c to test-x86-topo.c
Date:   Thu, 14 Sep 2023 15:21:40 +0800
Message-Id: <20230914072159.1177582-3-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
References: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zhao Liu <zhao1.liu@intel.com>

The tests in this file actually test the APIC ID combinations.
Rename to test-x86-topo.c to make its name more in line with its
actual content.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
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
index 00562f924f7a..eaaa041804b2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1721,7 +1721,7 @@ F: include/hw/southbridge/ich9.h
 F: include/hw/southbridge/piix.h
 F: hw/isa/apm.c
 F: include/hw/isa/apm.h
-F: tests/unit/test-x86-cpuid.c
+F: tests/unit/test-x86-topo.c
 F: tests/qtest/test-x86-cpuid-compat.c
 
 PC Chipset
diff --git a/tests/unit/meson.build b/tests/unit/meson.build
index 0299ef6906cc..bb6f8177341d 100644
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

