Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5507E6ED289
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 18:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbjDXQeh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 12:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbjDXQeW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 12:34:22 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723E2EB
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 09:34:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XqrjEAjM2ZmPGNdAMRmhXr04M0pWCxX/8smUtvA8LrQ/MtrWrqsBxWFa2IP3R6sFRcY6ojvUv7x2NHUKoVGLsQgM9CDj4JvM/whu/iSHj9k5DbtWOzTm0Uf3jkUmBp1+zjbSLquAwIlvpnhaVtr+uv5k/NSfZQzaPlkhP6WtF7GWQUjDffjUV0C1RMc4PwUyjcbTQCk0zhWSrxF83jSTmLLu+yKZYqk7D7j6kEr5plUDQQKV9vazgr+nqQbCZ+KFg6KanLOwQpTw9Kl4Vff4Z+3Y854wONlcxyGjvnD0wboHMIazQ0Hgo6XttPXXch8YIID+l3Y0N3vJ0nn/w3GrXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QkAJPHob69UfWgAF1kievQ2sXP28NUdJmOxfPVwIC2Q=;
 b=CUQXYblpRCuyAU6sQL1dUe0g7WIAhTReSQOcbMs657dSQH4krU3JJdFYwchbjDbq+slyyeKAO3WxO/PxJU+zWMmaC+qccy63MESpKSq3C2376n7wiPRVZlH4Gta0Y5E+XajdEVKOCR7qTSUabxB8l0+VvlSXIHUBvopFjzJuq19NVGHRgRQd9XUWqwOnq/G4fzQuHWDMfajstDXIp1JCs8N3Zl0RQvU5C2NbKtBRpsLtwFh6K6x8bPQuYvp0dhY4eDF+GXVmKmnob/qZCR3ZhY3EOlD03EjLF2s0Qj3YMlJ0uow7g1WENLG8Y2XgWgD6QDWF+rqkq5AXUEvkYkOGzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QkAJPHob69UfWgAF1kievQ2sXP28NUdJmOxfPVwIC2Q=;
 b=0OLCfrp6EXvws0bAiVVk7+SmBJkOzsl5pswXv0faFjT5tDeZATbgyjIIgSMrHaYGqeQed4k+5KH/kRH+WcrDVmqALwPKdE7dn+1scpQYCHAOLyfkceqBedAkCDPmo1FPgBq3VPCDkjAJctSJD3Trt6cIhlj03d4Q3Zl9RbpT4JU=
Received: from DM6PR10CA0028.namprd10.prod.outlook.com (2603:10b6:5:60::41) by
 BL0PR12MB5009.namprd12.prod.outlook.com (2603:10b6:208:1c2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 16:34:18 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:60:cafe::a9) by DM6PR10CA0028.outlook.office365.com
 (2603:10b6:5:60::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33 via Frontend
 Transport; Mon, 24 Apr 2023 16:34:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6340.19 via Frontend Transport; Mon, 24 Apr 2023 16:34:18 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 24 Apr
 2023 11:34:16 -0500
From:   Babu Moger <babu.moger@amd.com>
To:     <pbonzini@redhat.com>, <richard.henderson@linaro.org>
CC:     <weijiang.yang@intel.com>, <philmd@linaro.org>,
        <dwmw@amazon.co.uk>, <paul@xen.org>, <joao.m.martins@oracle.com>,
        <qemu-devel@nongnu.org>, <mtosatti@redhat.com>,
        <kvm@vger.kernel.org>, <mst@redhat.com>,
        <marcel.apfelbaum@gmail.com>, <yang.zhong@intel.com>,
        <jing2.liu@intel.com>, <vkuznets@redhat.com>,
        <michael.roth@amd.com>, <wei.huang2@amd.com>,
        <berrange@redhat.com>, <babu.moger@amd.com>
Subject: [PATCH v3 1/7] target/i386: allow versioned CPUs to specify new  cache_info
Date:   Mon, 24 Apr 2023 11:33:55 -0500
Message-ID: <20230424163401.23018-2-babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230424163401.23018-1-babu.moger@amd.com>
References: <20230424163401.23018-1-babu.moger@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT048:EE_|BL0PR12MB5009:EE_
X-MS-Office365-Filtering-Correlation-Id: 3952cf40-85fd-4493-78f3-08db44e1c01b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WYmmTxtgEge1D8Bi9qe+xZe0sKkbCOQyu8peL+m8d5dAdg0+lCwMg2yGDI1t8+j5abh6yUBBGsjjwAXqdEzen8SXThXMdthqvcRr3rlcdrm0r7PgWemfwsKEakT2V4YZ9HsYzcE6oMKBRiazqRJzi4qvb0mNHgX3AwFNdZlMyOKtslLIqAA79wMVPxOgrb3TIhVttkoQsqccrLgrjUgJhnn+k1Yk0t54gHAyP8Za53XrLJerTq4u14sDMhBjtDWEW3TTDAYtqW6k6Un6FA1KG48exbZzkfDxsD/8l2+/XKa3uK7sKcyOXk5GDydt/wofem1hJonfOyQPgx/zepfuKif0VU5rCtTV3RGgNokV4ONnxm2vyZaeTZXRH85TYVSqhUto0nGp6DDiAfCwbKa9pBuuJ/NMtBPsGT61JanP1QQR8i7qFQZLFjFRU5L9EE7uWi6pvhORe/abkpGfcczWGVZkdfNv1DwHDMkTDgu86z8H+5jFq7VBaGoENgmWXm6EYQhCf3fDE8sCHqvMSnYOhUNojo5/7ApTsEY+noX2+JYpzO1MRt4p0rggdEZURkOfeY+VR6+ZJ2Pn3UirN0KKckvT7hEbAGuidLEmiQZOshc6mUc8SH/RZDM5SvsqesgGYkEOuGDSRAbjF7hhDU/g02O9hFB2nJh3eXQ0YifK4wxQV8VUctpAa1s50zircg+SF2LPJl00ZZBC4DbDPpVAE9S2biehJZgJRdPIjkzcnBg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39860400002)(376002)(396003)(451199021)(36840700001)(40470700004)(46966006)(82740400003)(44832011)(7696005)(70586007)(70206006)(2906002)(6666004)(1076003)(8936002)(40480700001)(336012)(83380400001)(426003)(186003)(16526019)(8676002)(2616005)(41300700001)(26005)(36860700001)(5660300002)(40460700003)(316002)(7416002)(47076005)(86362001)(110136005)(54906003)(36756003)(4326008)(81166007)(356005)(82310400005)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 16:34:18.3632
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3952cf40-85fd-4493-78f3-08db44e1c01b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5009
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michael Roth <michael.roth@amd.com>

New EPYC CPUs versions require small changes to their cache_info's.
Because current QEMU x86 CPU definition does not support cache
versions, we would have to declare a new CPU type for each such case.
To avoid this duplication, the patch allows new cache_info pointers
to be specified for a new CPU version.

Co-developed-by: Wei Huang <wei.huang2@amd.com>
Signed-off-by: Wei Huang <wei.huang2@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Babu Moger <babu.moger@amd.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
 target/i386/cpu.c | 36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 6576287e5b..e3d9eaa307 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1598,6 +1598,7 @@ typedef struct X86CPUVersionDefinition {
     const char *alias;
     const char *note;
     PropValue *props;
+    const CPUCaches *const cache_info;
 } X86CPUVersionDefinition;
 
 /* Base definition for a CPU model */
@@ -5192,6 +5193,32 @@ static void x86_cpu_apply_version_props(X86CPU *cpu, X86CPUModel *model)
     assert(vdef->version == version);
 }
 
+/* Apply properties for the CPU model version specified in model */
+static const CPUCaches *x86_cpu_get_version_cache_info(X86CPU *cpu,
+                                                       X86CPUModel *model)
+{
+    const X86CPUVersionDefinition *vdef;
+    X86CPUVersion version = x86_cpu_model_resolve_version(model);
+    const CPUCaches *cache_info = model->cpudef->cache_info;
+
+    if (version == CPU_VERSION_LEGACY) {
+        return cache_info;
+    }
+
+    for (vdef = x86_cpu_def_get_versions(model->cpudef); vdef->version; vdef++) {
+        if (vdef->cache_info) {
+            cache_info = vdef->cache_info;
+        }
+
+        if (vdef->version == version) {
+            break;
+        }
+    }
+
+    assert(vdef->version == version);
+    return cache_info;
+}
+
 /*
  * Load data from X86CPUDefinition into a X86CPU object.
  * Only for builtin_x86_defs models initialized with x86_register_cpudef_types.
@@ -5224,7 +5251,7 @@ static void x86_cpu_load_model(X86CPU *cpu, X86CPUModel *model)
     }
 
     /* legacy-cache defaults to 'off' if CPU model provides cache info */
-    cpu->legacy_cache = !def->cache_info;
+    cpu->legacy_cache = !x86_cpu_get_version_cache_info(cpu, model);
 
     env->features[FEAT_1_ECX] |= CPUID_EXT_HYPERVISOR;
 
@@ -6703,14 +6730,17 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
 
     /* Cache information initialization */
     if (!cpu->legacy_cache) {
-        if (!xcc->model || !xcc->model->cpudef->cache_info) {
+        const CPUCaches *cache_info =
+            x86_cpu_get_version_cache_info(cpu, xcc->model);
+
+        if (!xcc->model || !cache_info) {
             g_autofree char *name = x86_cpu_class_get_model_name(xcc);
             error_setg(errp,
                        "CPU model '%s' doesn't support legacy-cache=off", name);
             return;
         }
         env->cache_info_cpuid2 = env->cache_info_cpuid4 = env->cache_info_amd =
-            *xcc->model->cpudef->cache_info;
+            *cache_info;
     } else {
         /* Build legacy cache information */
         env->cache_info_cpuid2.l1d_cache = &legacy_l1d_cache;
-- 
2.34.1

