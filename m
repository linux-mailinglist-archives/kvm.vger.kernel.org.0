Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF423AB38E
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 14:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbhFQM3t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 08:29:49 -0400
Received: from mail-vi1eur05on2103.outbound.protection.outlook.com ([40.107.21.103]:36961
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230039AbhFQM3s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 08:29:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZjTNFIj3FbgLQ6naVssWIrivner6rvTxAfdDWNRRDJxzAVTG+AJHonKBM09R8jL61TwqAl3tBg7vyLXeuPEhpHMJy6Ku+6DbnawjJ+GBBCxpQFNJMz4vy7s3/3XEswbvgePkfJip8bY2dWhkSYwHQ+IRiuh+z/lWT2b2hTMZ5x6vO+pR8XszngCy5DxsYR75OuD/4+1xb8JkLEE3KARNHA1gNUVAcy/1SEPj1kffUFDCwOaLhnutQL+2aHX5li9+fA/wzRHYqnXJSf07/z56MuXeomz9HC7sUIDhcx9qOAfDU4ZCduZx/QahotHR1J3/bck7YWRwmw/3Gitj1BYJqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UKlelffWlljZnyf4nBhl6ja7PGEoHz/8r8mworUyw2I=;
 b=b18k8TCkKgtrI2id2iPIqHRZjr98jD7+oy07/4ISk7vnj40kK1XLiq5vGLYWpWqPaogs8qV3xVIxOijv8xiCfDxV5WUrfxfL310VXblJiU2EVmMvs393Ni5lf3O64I0hnN/H8qlddp6wOObUCFU7Hoh0htFtIC26PgNjg+sOFf19/RzABwlHsIUx/NMGVejtm7ZC4NegFd7vxi/+cfxsxyryyPzsvi7kRxP7jbKULAT+kYPUio1R1e+K+hwEvrlY6SU1JfvSPJMXrHoKb/g+Q3p7no5iS81hE/BP29zAuxfHVksrbMTof94KeTrXyF59uL1o3NbTwgdj357iag6fVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UKlelffWlljZnyf4nBhl6ja7PGEoHz/8r8mworUyw2I=;
 b=C1Y18b6C8UCUpbzsQXlIqxBiQ2AKFzJm7qbQ7oSx4vrp4XbdoDsTkyIYhiaEVkpT8s7a5c2ejpK5ij864Qw3Sr0a7c4I3QRYfZDp1KfNbQAcJOoiK3sODNbt0WkpJVSTcXUqfyz0ENWMUxw3IDBxpZ5YeRVKTSjoCKwBJM9orpM=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com (2603:10a6:20b:283::19)
 by AM0PR08MB4226.eurprd08.prod.outlook.com (2603:10a6:208:147::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.23; Thu, 17 Jun
 2021 12:27:38 +0000
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::c6c:281b:77e6:81b6]) by AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::c6c:281b:77e6:81b6%6]) with mapi id 15.20.4242.019; Thu, 17 Jun 2021
 12:27:39 +0000
From:   Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
To:     qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Denis Lunev <den@openvz.org>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
Subject: [PATCH v11] qapi: introduce 'query-kvm-cpuid' QMP command.
Date:   Thu, 17 Jun 2021 15:27:23 +0300
Message-Id: <20210617122723.8670-1-valeriy.vdovin@virtuozzo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [176.106.247.78]
X-ClientProxiedBy: AM6PR08CA0016.eurprd08.prod.outlook.com
 (2603:10a6:20b:b2::28) To AM9PR08MB5988.eurprd08.prod.outlook.com
 (2603:10a6:20b:283::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (176.106.247.78) by AM6PR08CA0016.eurprd08.prod.outlook.com (2603:10a6:20b:b2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Thu, 17 Jun 2021 12:27:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 083abd7f-00f8-434a-0d96-08d9318b4b82
X-MS-TrafficTypeDiagnostic: AM0PR08MB4226:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB4226116EB102E221CA29A6EF870E9@AM0PR08MB4226.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: izs7GDfy9QMifKx0/e9j03ZAqSGn0zxkbwx8YyxtrhB99oz0Km+ngIcatQuqCDn2v8+c3vkZS/uhRsRfI9qAU2qpkwVS8XnB4U2WTOVjEjCgTQ4Yys0FOpf+5myDArdWJ1HdldLwvwctSdUiir4l427CX58kk8IKO7Qbpe8IS4a4hPhiQ0lVNU7E5lhk5NxY/9vPII56txDo+m4cbtvqrBwHxiYm5f/27jnZKn4c9MuQhXQtGOOZxbuO8OV+a0uz7yg+XtWFSQ89/PUSfv7DrHckoRkBWToIfI9BPkUD78poMmDIeFenlBSIUnYW0T03UYld+wDy8u2V3FnOV/cj831T0vkk/eGE33x1jUpJDBE0CSorUeWjvQ/fbZzafl0A0d122zWl77B2ybdfzb08ci7yFl/cwxe5wrbnKn6bdOGX8Li6TUJv3DoMrN8uKGKl3v5cHmjS7JNezG70SCx0nP/bCD/qPIfOaZKhfSHViR4TTJoY7QEw50oFtAmWzcKx9DYbOsyIETbtFF5mjXuUr7Li4K4Alb4+fQ8KtmAXldTuAXKrC2E8wmHk2NNl3EUxFG6oIPZaunF6w14MhrnGp0mqPgKABZD9Y3+XvAXuyaqwKLkDZQ6oaHYqkrFni0dFumb8StBxWifMuYHGrCW3+Q76a2CIlNAnyKfwzUBD7hKL5Gru3Zj5wOsmgV2M+2Ht
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB5988.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39840400004)(376002)(396003)(346002)(7416002)(6666004)(26005)(38350700002)(38100700002)(86362001)(8936002)(8676002)(2906002)(6916009)(54906003)(1076003)(956004)(44832011)(52116002)(2616005)(107886003)(16526019)(186003)(316002)(36756003)(6512007)(478600001)(6506007)(66476007)(66556008)(83380400001)(66946007)(5660300002)(6486002)(4326008)(69590400013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?idIGxboxy6JESjBSmfuMnqbRw8tseo9mS2iZhec/be9FEQefXa8SVHObfFLM?=
 =?us-ascii?Q?KhdqYz+Kowr7Mz20ZGX3IFINTRQjpKSZqcHqfpl5DbS8l8wbVaA2ZWVBCJwx?=
 =?us-ascii?Q?B86uKuPOL35H2Dxtx8EhLo0DMhvEwuEX1whgLh3T4OCtq9BmJ9atxWz4Mb3B?=
 =?us-ascii?Q?BYzhkmQmi6k2Mx4YDbEcl8+IqJ5+gooQTtYEVMFUgsjnOXTbiZPCWSoazI0z?=
 =?us-ascii?Q?K4sGeM+eQ2W8JhZtmddgenPKEuq1frrLHBQN60ssSqlUr9krz6xC1OVz/Hkq?=
 =?us-ascii?Q?jc+V6RlyF7Ja8r1VAAHrw8UICO0JKwsBVbeGc7TStS4neUca2ieE9LMdL8ha?=
 =?us-ascii?Q?C+ZhGHUD+CTLVNPwX0x32y3YZLgbs27onOud8kYC/T1SiZyC+g9FXs0f/+4O?=
 =?us-ascii?Q?srw9j2LeJbN6Eh/nfnZl7Crh+CDXAhsAu8NEnLj95FL/GfmtAsivLdC8iFN6?=
 =?us-ascii?Q?1PqVGbsPUZD47ajgv5YEYqO8huqbLs/OB4h/43diCW05wfR2t88DxredGGhX?=
 =?us-ascii?Q?KM91srGhtIw8dVJgJieKaM3qqLSO+whlSGvmzPzyxnmtjZDmpDEhCWYdgfwb?=
 =?us-ascii?Q?vp9/2agA6JfIVQtggG8UyfdjHQKe1XO5c8braHD4XySBd4z0Q4G4Zu9BX1Xf?=
 =?us-ascii?Q?q8/Tjo+MKZJIDGP3P0xYXGJVyrahD8QVeVgH5ApbfyeYGUEGgf1v9WXRN/ny?=
 =?us-ascii?Q?ZeJZ/r97VFNqT4u3bngjorvR90UNilOUrJxxntJxWE1WRKgJyf+QqrblqrgV?=
 =?us-ascii?Q?pnThyya2znVX2yv213bVcthNYnIcPYYSJSaStlVFJDwZsnAFPyV+6kMfuCuk?=
 =?us-ascii?Q?FqkBjSI9IH6cSSLFtP6BHQsK8yckKTKvOrA2APqm2qdJpEA+HbkNkaN80elj?=
 =?us-ascii?Q?2ESJuEMBi9sVEx/rNJIyg5cyH5KylZrARNXnLBOSZ1xJAoc0cuwaeAT+DAX8?=
 =?us-ascii?Q?SEuhhR5km77ZVQzeNnKXHgoASvxDOdCptgRJs+hK9pjTBFlQb+USI/W90ZD5?=
 =?us-ascii?Q?VJddq55TuNKsHaHX8XOzXMnnP1DWsTUIK/aYxlS9LzaTanXrTb8xrjWVwZq2?=
 =?us-ascii?Q?qXLr2UGOmWoIP+JRxvpM7lkGLEnxvn91aYuJccC/PwAyEyHta3k3EDNdw4AF?=
 =?us-ascii?Q?Lv1LyZuhDX/pK+l2kD2gYHQZ37pBhjZsamMa+WVzkZQBvVRV8T5l/csmyivJ?=
 =?us-ascii?Q?rkAUyLrRkXgzzuoyAskuAuKWeG6HMlOqOaaFCy7WswWYc+OwXYwc/QV5Jpmv?=
 =?us-ascii?Q?pGhmpk17sk/2C+Pk+8t+KUNw1TXZ9WZYSDiJtPXNIWHAhVsAjuw22PWRQWVD?=
 =?us-ascii?Q?eivbCm1vUk0DRtHybBmPRIUC?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 083abd7f-00f8-434a-0d96-08d9318b4b82
X-MS-Exchange-CrossTenant-AuthSource: AM9PR08MB5988.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 12:27:38.8815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4pajt8cmKWSG5yI71YU3dY+lXxBtxQnJyuVkvGdljhfBb18p5aIm7FnKtdyK802OoTquQzd/CxyW9yPdhkmUbEqVO2DDcIvACED4OmJpLV0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB4226
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introducing new QMP command 'query-kvm-cpuid'. This command can be used to
get virtualized cpu model info generated by QEMU during VM initialization in
the form of cpuid representation.

Diving into more details about virtual CPU generation: QEMU first parses '-cpu'
command line option. From there it takes the name of the model as the basis for
feature set of the new virtual CPU. After that it uses trailing '-cpu' options,
that state if additional cpu features should be present on the virtual CPU or
excluded from it (tokens '+'/'-' or '=on'/'=off').
After that QEMU checks if the host's cpu can actually support the derived
feature set and applies host limitations to it.
After this initialization procedure, virtual CPU has it's model and
vendor names, and a working feature set and is ready for identification
instructions such as CPUID.

To learn exactly how virtual CPU is presented to the guest machine via CPUID
instruction, new QMP command can be used. By calling 'query-kvm-cpuid'
command, one can get a full listing of all CPUID leafs with subleafs which are
supported by the initialized virtual CPU.

Other than debug, the command is useful in cases when we would like to
utilize QEMU's virtual CPU initialization routines and put the retrieved
values into kernel CPUID overriding mechanics for more precise control
over how various processes perceive its underlying hardware with
container processes as a good example.

The command is KVM-specific, as the data exposed by it is used AS IS to provide
arguments to initialize VCPU in a linux kernel KVM module. As such it is limited
in compilation by CONFIG_KVM definition flag, so that it doesn't break builds
configured with --disable-kvm parameter.

Output format:
The output is a plain list of leaf/subleaf argument combinations, that
return 4 words in registers EAX, EBX, ECX, EDX.

Use example:
qmp_request: {
  "execute": "query-kvm-cpuid"
}

qmp_response: {
  "return": [
    {
      "eax": 1073741825,
      "edx": 77,
      "in-eax": 1073741824,
      "ecx": 1447775574,
      "ebx": 1263359563
    },
    {
      "eax": 16777339,
      "edx": 0,
      "in-eax": 1073741825,
      "ecx": 0,
      "ebx": 0
    },
    {
      "eax": 13,
      "edx": 1231384169,
      "in-eax": 0,
      "ecx": 1818588270,
      "ebx": 1970169159
    },
    {
      "eax": 198354,
      "edx": 126614527,
      "in-eax": 1,
      "ecx": 2176328193,
      "ebx": 2048
    },
    ....
    {
      "eax": 12328,
      "edx": 0,
      "in-eax": 2147483656,
      "ecx": 0,
      "ebx": 0
    }
  ]
}

Signed-off-by: Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
---
v2: - Removed leaf/subleaf iterators.
    - Modified cpu_x86_cpuid to return false in cases when count is
      greater than supported subleaves.
v3: - Fixed structure name coding style.
    - Added more comments
    - Ensured buildability for non-x86 targets.
v4: - Fixed cpu_x86_cpuid return value logic and handling of 0xA leaf.
    - Fixed comments.
    - Removed target check in qmp_query_cpu_model_cpuid.
v5: - Added error handling code in qmp_query_cpu_model_cpuid
v6: - Fixed error handling code. Added method to query_error_class
v7: - Changed implementation in favor of cached cpuid_data for
      KVM_SET_CPUID2
v8: - Renamed qmp method to query-kvm-cpuid and some fields in response.
    - Modified documentation to qmp method
    - Removed helper struct declaration
v9: - Renamed 'in_eax' / 'in_ecx' fields to 'in-eax' / 'in-ecx'
    - Pasted more complete response to commit message.
v10:
    - Subject changed
    - Fixes in commit message
    - Small fixes in QMP command docs
v11:
    - Added explanation about CONFIG_KVM to the commit message.

 qapi/machine-target.json   | 44 ++++++++++++++++++++++++++++++++++++++
 target/i386/kvm/kvm.c      | 37 ++++++++++++++++++++++++++++++++
 tests/qtest/qmp-cmd-test.c |  1 +
 3 files changed, 82 insertions(+)

diff --git a/qapi/machine-target.json b/qapi/machine-target.json
index e7811654b7..e9ac7a334e 100644
--- a/qapi/machine-target.json
+++ b/qapi/machine-target.json
@@ -329,3 +329,47 @@
 ##
 { 'command': 'query-cpu-definitions', 'returns': ['CpuDefinitionInfo'],
   'if': 'defined(TARGET_PPC) || defined(TARGET_ARM) || defined(TARGET_I386) || defined(TARGET_S390X) || defined(TARGET_MIPS)' }
+
+##
+# @CpuidEntry:
+#
+# A single entry of a CPUID response.
+#
+# One entry holds full set of information (leaf) returned to the guest
+# in response to it calling a CPUID instruction with eax, ecx used as
+# the agruments to that instruction. ecx is an optional argument as
+# not all of the leaves support it.
+#
+# @in-eax: CPUID argument in eax
+# @in-ecx: CPUID argument in ecx
+# @eax: CPUID result in eax
+# @ebx: CPUID result in ebx
+# @ecx: CPUID result in ecx
+# @edx: CPUID result in edx
+#
+# Since: 6.1
+##
+{ 'struct': 'CpuidEntry',
+  'data': { 'in-eax' : 'uint32',
+            '*in-ecx' : 'uint32',
+            'eax' : 'uint32',
+            'ebx' : 'uint32',
+            'ecx' : 'uint32',
+            'edx' : 'uint32'
+          },
+  'if': 'defined(TARGET_I386) && defined(CONFIG_KVM)' }
+
+##
+# @query-kvm-cpuid:
+#
+# Returns raw data from the KVM CPUID table for the first VCPU.
+# The KVM CPUID table defines the response to the CPUID
+# instruction when executed by the guest operating system.
+#
+# Returns: a list of CpuidEntry
+#
+# Since: 6.1
+##
+{ 'command': 'query-kvm-cpuid',
+  'returns': ['CpuidEntry'],
+  'if': 'defined(TARGET_I386) && defined(CONFIG_KVM)' }
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 7fe9f52710..a59d6efa41 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -20,6 +20,7 @@
 
 #include <linux/kvm.h>
 #include "standard-headers/asm-x86/kvm_para.h"
+#include "qapi/qapi-commands-machine-target.h"
 
 #include "cpu.h"
 #include "sysemu/sysemu.h"
@@ -1464,6 +1465,38 @@ static Error *invtsc_mig_blocker;
 
 #define KVM_MAX_CPUID_ENTRIES  100
 
+struct kvm_cpuid2 *cpuid_data_cached;
+
+CpuidEntryList *qmp_query_kvm_cpuid(Error **errp)
+{
+    int i;
+    struct kvm_cpuid_entry2 *kvm_entry;
+    CpuidEntryList *head = NULL, **tail = &head;
+    CpuidEntry *entry;
+
+    if (!cpuid_data_cached) {
+        error_setg(errp, "VCPU was not initialized yet");
+        return NULL;
+    }
+
+    for (i = 0; i < cpuid_data_cached->nent; ++i) {
+        kvm_entry = &cpuid_data_cached->entries[i];
+        entry = g_malloc0(sizeof(*entry));
+        entry->in_eax = kvm_entry->function;
+        if (kvm_entry->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX) {
+            entry->in_ecx = kvm_entry->index;
+            entry->has_in_ecx = true;
+        }
+        entry->eax = kvm_entry->eax;
+        entry->ebx = kvm_entry->ebx;
+        entry->ecx = kvm_entry->ecx;
+        entry->edx = kvm_entry->edx;
+        QAPI_LIST_APPEND(tail, entry);
+    }
+
+    return head;
+}
+
 int kvm_arch_init_vcpu(CPUState *cs)
 {
     struct {
@@ -1833,6 +1866,10 @@ int kvm_arch_init_vcpu(CPUState *cs)
     if (r) {
         goto fail;
     }
+    if (!cpuid_data_cached) {
+        cpuid_data_cached = g_malloc0(sizeof(cpuid_data));
+        memcpy(cpuid_data_cached, &cpuid_data, sizeof(cpuid_data));
+    }
 
     if (has_xsave) {
         env->xsave_buf = qemu_memalign(4096, sizeof(struct kvm_xsave));
diff --git a/tests/qtest/qmp-cmd-test.c b/tests/qtest/qmp-cmd-test.c
index c98b78d033..48add3ada1 100644
--- a/tests/qtest/qmp-cmd-test.c
+++ b/tests/qtest/qmp-cmd-test.c
@@ -46,6 +46,7 @@ static int query_error_class(const char *cmd)
         { "query-balloon", ERROR_CLASS_DEVICE_NOT_ACTIVE },
         { "query-hotpluggable-cpus", ERROR_CLASS_GENERIC_ERROR },
         { "query-vm-generation-id", ERROR_CLASS_GENERIC_ERROR },
+        { "query-kvm-cpuid", ERROR_CLASS_GENERIC_ERROR },
         { NULL, -1 }
     };
     int i;
-- 
2.17.1

