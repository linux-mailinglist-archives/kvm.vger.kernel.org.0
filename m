Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03BD9395AB6
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 14:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbhEaMk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 08:40:26 -0400
Received: from mail-eopbgr140102.outbound.protection.outlook.com ([40.107.14.102]:64239
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231327AbhEaMkZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 May 2021 08:40:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bVQljaQehbpeDkhteEQvU7HYd8detDJ38jrWuiEWwv+EuBlBCMq52M3Qr27qOJsKfpxs60ziQlyAdXq/B0s2eW70P+iqMJy1qACwsNdKKTnReS/PlLvtocoByal5Y+GlmA2Eoezv9CBpbUhPhURX1FSqXlEfrBro21Z4XvBoawQocG+WgcwfMq8h7vUI95bpkJWOEpjiyqSJcEexXb3ZtLFAa1LiJZyJAKKjGFOG4uYw2B3Xk4yYftRME4QPjRcks6WDrgbcvtyoeNNgi+Qaq8yKaxiyfIl8OjC2RmLEw6xQ1QJ7dZZ6IQMQJ65x/oexdHQ5o9MFvgzqmCHaHzd1BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PYlY68464CnWx9WfEWBTuHKA48EvpaV5xAsKsKvlQC8=;
 b=KlyKvENXwWVlhCfXxHg7VGlRJNb7ju9e1Bm/QycAO5E8z9G4U+frEyGLkGL/BR2CwTa21T7GMWDbMwY42e07Nn6NACI10t8aZStvbVuGBChejF+XkVGczc0g3P6RwJCNv/bUkSKblNHCsdwzKnfqQbcn6nG8UG6dYGSGbMNuyuj13qTpfqNhS83wzUD8z8WuBISecjXZrEmvM8tACzeBkMo3sumRWO35cDcw57o/jKk824SfqmSpomPRI2xQmWKcV4J99qHWIRjRdFg+9RTbuCGSxgtI5qlA5MPGpcc4Xa8/qp81KS32GQuW+hHFeAcYe3tusIXYBlRA6BIW3u7g6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PYlY68464CnWx9WfEWBTuHKA48EvpaV5xAsKsKvlQC8=;
 b=VkLSeXyhQoOjiXGxDXPCmR5CvNhOnsBEpxPUCp13zRg2Act7AP7unglz8V7eAlKjD2fmKV+iGlKoPcmngqxNzvpozGVEmBeiZw5csLxmpWufMxbkCE+Rsi5ka5q+yaNAYo+xGp/HZZOtAYav/EVjQQ5+6slAImXhU95NqOhzRZk=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com (2603:10a6:20b:283::19)
 by AM9PR08MB6098.eurprd08.prod.outlook.com (2603:10a6:20b:2d9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Mon, 31 May
 2021 12:38:43 +0000
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::7d3f:e291:9411:c50f]) by AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::7d3f:e291:9411:c50f%7]) with mapi id 15.20.4173.030; Mon, 31 May 2021
 12:38:43 +0000
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
Subject: [PATCH v8] qapi: introduce 'query-kvm-cpuid' action
Date:   Mon, 31 May 2021 15:38:06 +0300
Message-Id: <20210531123806.23030-1-valeriy.vdovin@virtuozzo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [176.106.247.78]
X-ClientProxiedBy: AM3PR03CA0065.eurprd03.prod.outlook.com
 (2603:10a6:207:5::23) To AM9PR08MB5988.eurprd08.prod.outlook.com
 (2603:10a6:20b:283::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (176.106.247.78) by AM3PR03CA0065.eurprd03.prod.outlook.com (2603:10a6:207:5::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Mon, 31 May 2021 12:38:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8b7cf0c-160b-42f5-b9ff-08d92431069c
X-MS-TrafficTypeDiagnostic: AM9PR08MB6098:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9PR08MB6098583415824B568B752307873F9@AM9PR08MB6098.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NjcTrmlvD8/kynwBCTuIh3PfdvJPbKiGyRjl9hfgakoag4n/3D7JZGwDfTkVTH1ZkA68s2Q93X9c2FmNhPpf4kKJo2jKyCyCFivpEluFzM3ZXmX9ujZz61RCqNURDiJSKzeTVbLhvVrdOZSYIcAsFlOxeS3e0t9LYtOFtvLNhgin9+WqO+rlrK0lFIxMSoU2oCz4/bE8tEq3HKnL9kRYlGaRuiV0jPBxj1AjKAvmLXQ5B7ROpCn5r7Yx093hhH8mkswSz08TZ11zD4DwtKxiaMAZB3xaLETAl2bAw/Bq6UMM8UkVbZFUX5RkjMJEVXo5aRbJo9VebHT6l0DMAawoCBKvNEtzhMqSLmzeZEE/h3riwmsoXu/AczAnAd+nCujD8d+DJXVDFr3gP4YAzhK6SnvT0NOuvkY9dqsGsapW6qusi69beoZUGUV5/IhtyUNTFAnFMNO1f8P9TFBU158Yzd/7xeW23nisI+UQTBz4se88avX6p83K5m8TvNdXXr9kIvrFNZrLMj/9KoOpz80rgE17ACEbHSDROvT4CVQH0+iOhixlW4HiwQ+nyyyKgBjcaOcV5NkE8bvovRFld4YhEFByvBMFE3rQm44fK6QnM1IkXu0b7cDAjXqFYPiY6p1tAkh0HL+cRBuhEXswESG15xcJnBXE4HJls+PeF0ejTc89hQXmMLqtT40be3bOm56x
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB5988.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(396003)(366004)(39830400003)(8676002)(8936002)(16526019)(1076003)(54906003)(66556008)(66476007)(38100700002)(38350700002)(478600001)(6512007)(66946007)(44832011)(6486002)(36756003)(2616005)(956004)(186003)(6916009)(4326008)(26005)(107886003)(5660300002)(316002)(86362001)(52116002)(6666004)(6506007)(83380400001)(7416002)(2906002)(69590400013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Us+T7fKhrBssoFhWo5A/rkf/Px651XL2OcFaVFziiXfm5dvKvJzZGlda7odZ?=
 =?us-ascii?Q?IYGiAcTUFkTr80Y5vVaYlSfhDOIrpVavHl5H3/Y/sPJnS9FvSNr6BNTdvdLS?=
 =?us-ascii?Q?OU1Lekp35BYM6oGgZMT3UzUjw7Uq9f6aOS4MjGa8kvCN0lGXg3etWhC7rVyl?=
 =?us-ascii?Q?ftirKSW+uan46qVe5K0XkSu6XCVrTsWaiHHCXbN8LAUUCeoHIehp/aUlvKQZ?=
 =?us-ascii?Q?PjVn6tJ0ZYsWor3/gtUsD76157ExHBEW7JJe9fvSF+Nw6TgTr86SxX5PfQ9x?=
 =?us-ascii?Q?UmBiVy6sZ8vHhlBiNK0UfXLXBnaaMpNWGBSvRp9HKno7YVtAHrMDjbC/19Mu?=
 =?us-ascii?Q?U8Gp+ffOonl/bw4omDcDjlcJllnBY/wcQyy5vYBhbCj6OODsbvDTUpNLwTba?=
 =?us-ascii?Q?BKB+u2R2kcR8Tcsxawzvp6SYaRGCsfa+XuHWCHsQFRxNd9o77rk6ixrGfhoK?=
 =?us-ascii?Q?1xMfsh5a4OnCeStgKmLMqwyZhkgD6L9aw3JQcbNdkGRQZlb7MdwU5+VldrQR?=
 =?us-ascii?Q?Ina+OxcwUgj9uTmpJV5V8FHdCi1E27Ff+1QRz0o8uujKxKWRwHpVl9B39sSe?=
 =?us-ascii?Q?MOklvB1isrANamD8iMHUG0UspMl/GfqAGD9JZKrOGshe14RoAzlmcNiraRVF?=
 =?us-ascii?Q?/Q+itW9djVsi3g4KziNg2Rgy7/efhal6OvD7h3yQM1IW8nxE3l9A25NYVPzG?=
 =?us-ascii?Q?ELvpIZx/x9rpFQUOCGIjpUi5p+pcRMK6CUUqfxtdzrokZ8OYnEKVtaKeQcr4?=
 =?us-ascii?Q?sFGdqil+0LhPMWkpf6Vf98J1nLzHeAqSDsmAHaPEI8dcIV1/q7UyOd85STTq?=
 =?us-ascii?Q?VEwz5/0wOjhkLy5u24sKErxgjYabUpBcPq66Ptp8s8elKls/odDnSb4y79Wa?=
 =?us-ascii?Q?839J6hYhh0++jE48Y3gqGHt1MiHquYMKJgEpZe00TIL/9oQAK1mrzVvss6Kd?=
 =?us-ascii?Q?fxAoDtojQvlnMZzL4lwhagRgSbN/Kle/pb2nUlH7QGBSH1mbuZTL6VXuUClH?=
 =?us-ascii?Q?lobH9XJY28aAZJ9VoZA/GfDIe5c4WJz1q66zBh0sQtXT2sxwRrJBJET+civ1?=
 =?us-ascii?Q?lcb52x8VpIZU6HFE745815gIioq99t5gQZ/d8MwKm9THMito3SSWunbrSv2O?=
 =?us-ascii?Q?HzYwjA5Orpxs3B8Nn0fVUN7vajrmc3Qa4XNq4sRZqCS8HxVUmfxNDvFqLiQx?=
 =?us-ascii?Q?IuKDLOeAzEAQ1G1rg9eDr4wki8WgDtcNXZPt2A0xpOZrUR7QYdyXkixjqt7z?=
 =?us-ascii?Q?ycSNFK2nRiEXD14nsR0zYoWApb6jXTEBaTDGfM+5Si1Lyv6n6Jee5+CihJd/?=
 =?us-ascii?Q?V1PUokmHwLhbLP69a41P+kCy?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8b7cf0c-160b-42f5-b9ff-08d92431069c
X-MS-Exchange-CrossTenant-AuthSource: AM9PR08MB5988.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2021 12:38:43.3981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nVbJJWuUmRJT9ClWA8Jhf9RZvCKXo3WbywoAwp+MAQaqNWCe8suld5iibg2qrZYSSyApLSSINUBppaQijQGOPC0aeeZEAI50AZU4DGyoVWo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introducing new qapi method 'query-kvm-cpuid'. This method can be used to
get virtualized cpu model info generated by QEMU during VM initialization in
the form of cpuid representation.

Diving into more details about virtual cpu generation: QEMU first parses '-cpu'
command line option. From there it takes the name of the model as the basis for
feature set of the new virtual cpu. After that it uses trailing '-cpu' options,
that state if additional cpu features should be present on the virtual cpu or
excluded from it (tokens '+'/'-' or '=on'/'=off').
After that QEMU checks if the host's cpu can actually support the derived
feature set and applies host limitations to it.
After this initialization procedure, virtual cpu has it's model and
vendor names, and a working feature set and is ready for identification
instructions such as CPUID.

Currently full output for this method is only supported for x86 cpus.

To learn exactly how virtual cpu is presented to the guest machine via CPUID
instruction, new qapi method can be used. By calling 'query-kvm-cpuid'
method, one can get a full listing of all CPUID leafs with subleafs which are
supported by the initialized virtual cpu.

Other than debug, the method is useful in cases when we would like to
utilize QEMU's virtual cpu initialization routines and put the retrieved
values into kernel CPUID overriding mechanics for more precise control
over how various processes perceive its underlying hardware with
container processes as a good example.

Output format:
The output is a plain list of leaf/subleaf agrument combinations, that
return 4 words in registers EAX, EBX, ECX, EDX.

Use example:
qmp_request: {
  "execute": "query-kvm-cpuid"
}

qmp_response: [
  {
    "eax": 1073741825,
    "edx": 77,
    "in_eax": 1073741824,
    "ecx": 1447775574,
    "ebx": 1263359563,
  },
  {
    "eax": 16777339,
    "edx": 0,
    "in_eax": 1073741825,
    "ecx": 0,
    "ebx": 0,
  },
  {
    "eax": 13,
    "edx": 1231384169,
    "in_eax": 0,
    "ecx": 1818588270,
    "ebx": 1970169159,
  },
  {
    "eax": 198354,
    "edx": 126614527,
  ....

Signed-off-by: Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>

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
---
 qapi/machine-target.json   | 43 ++++++++++++++++++++++++++++++++++++++
 target/i386/kvm/kvm.c      | 37 ++++++++++++++++++++++++++++++++
 tests/qtest/qmp-cmd-test.c |  1 +
 3 files changed, 81 insertions(+)

diff --git a/qapi/machine-target.json b/qapi/machine-target.json
index e7811654b7..a83180dd24 100644
--- a/qapi/machine-target.json
+++ b/qapi/machine-target.json
@@ -329,3 +329,46 @@
 ##
 { 'command': 'query-cpu-definitions', 'returns': ['CpuDefinitionInfo'],
   'if': 'defined(TARGET_PPC) || defined(TARGET_ARM) || defined(TARGET_I386) || defined(TARGET_S390X) || defined(TARGET_MIPS)' }
+
+##
+# @CpuidEntry:
+#
+# A single entry of a CPUID response.
+#
+# One entry holds full set of information (leaf) returned to the guest in response
+# to it calling a CPUID instruction with eax, ecx used as the agruments to that
+# instruction. ecx is an optional argument as not all of the leaves support it.
+#
+# @in_eax: CPUID argument in eax
+# @in_ecx: CPUID argument in ecx
+# @eax: eax
+# @ebx: ebx
+# @ecx: ecx
+# @edx: edx
+#
+# Since: 6.1
+##
+{ 'struct': 'CpuidEntry',
+  'data': { 'in_eax' : 'uint32',
+            '*in_ecx' : 'uint32',
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

