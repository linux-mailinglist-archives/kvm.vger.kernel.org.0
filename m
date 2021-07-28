Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B2C3D8E53
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 14:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235263AbhG1MyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 08:54:21 -0400
Received: from mail-vi1eur05on2135.outbound.protection.outlook.com ([40.107.21.135]:60448
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234966AbhG1MyU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 08:54:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jnskj604I7CcD7byCEJhhCxBx/62CpA5+YX2af0fSYhr/AR6wiofwl24FkiG5kG0ssscd4TOcnoUFQi2Xg+0XFw0IjMVM+3ZSDpAQ9JANhSlphY3rOlF5Opt9wbWbae8wPmhKIwKUjSSusEmlQf/7IaZN1mB/pp5xqHKa8r2kbgfSXE5MDym0MaFpwwxzzj8RSTeEpsJTdwO/15FLTaRrn5/ROd6Cg/HpYqSkcv8JS6n6b6NGpXEJb0u4ZNfu3+2bQieswDLBZlmNzRV4Sl51GPZsYERhw43QXb/RUsy+O5x9ehvVkEMQ/3zKdb2fEy1tCtelbZYFiwFEXqilYiMeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rmgkTiZx1wd4IFkQL3/08fdtdPU47jQTzXn1O7Lhad8=;
 b=Cj7IXhTwlF9zg3ueunsbHEAZFFyXPBDayhHO8Rwizai7k5ipro/umvMuvhLo63KVB1gYpAgsbzlyQjvNIeqf/3QhyK2lW5OlnXE22ILJdw5mOV0N/LKfxCczrMUaT8gxZRtSBBdwVEhhZxOKEteoi+JyK0gFV+GJ08AqaE/56iR/jxcVMruMNG0NaUg+QcDeBdQQnH93Ws/mm+qk1wQ4BmJwcuC6SG2d++s01OazLYMm2XVc54fdRNPgbZ+aQ6daqE47oqEdwU3Xt/32fHkhbIv/c+nU3gpurs37gw3JsCJUHec30GFBrk3ty7wg77ft9RXZygw4BcGqZc+0/ZtL3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rmgkTiZx1wd4IFkQL3/08fdtdPU47jQTzXn1O7Lhad8=;
 b=bSa56zeqTl4OnvHbMGtxcoYn7t/SY0TQE1k3hrpJKnuMscc5P1O4qbbCAtBAoqPT4czkcPW/E+klNRhPohp6Z0BVjX0/OxaNLJgvBSC2fWk30BqCN/hac+lvx+bIFvFIDB19KtXE9lJX6iNLBdMwx8HDtKMgMPXp0eSOEQBp2TI=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com (2603:10a6:20b:283::19)
 by AM0PR08MB3379.eurprd08.prod.outlook.com (2603:10a6:208:dd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Wed, 28 Jul
 2021 12:54:16 +0000
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::2d48:8cfb:a44e:f543]) by AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::2d48:8cfb:a44e:f543%9]) with mapi id 15.20.4373.020; Wed, 28 Jul 2021
 12:54:16 +0000
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
Subject: [PATCH v12] qapi: introduce 'query-x86-cpuid' QMP command.
Date:   Wed, 28 Jul 2021 15:54:02 +0300
Message-Id: <20210728125402.2496-1-valeriy.vdovin@virtuozzo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM6PR02CA0005.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::18) To AM9PR08MB5988.eurprd08.prod.outlook.com
 (2603:10a6:20b:283::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (176.106.247.78) by AM6PR02CA0005.eurprd02.prod.outlook.com (2603:10a6:20b:6e::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 12:54:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fec28a52-4b4a-4d32-0b66-08d951c6cede
X-MS-TrafficTypeDiagnostic: AM0PR08MB3379:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB33799516DA3DB5FFEF00BF8287EA9@AM0PR08MB3379.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kRJwqNU6LoTK1vykALvht9F77hSlWdEiWlNA5GcAbU+ssvbXi2RCB21NIFQ7Ke38KIX8s1X+sCve5rpFdcVT+UhzYap1bxhwQOOAg8lbBvz9MZIv2TaRL+df13Dm7nOLH03gnwipzEKSJYzJ9t1hnKKxugOvk3+4u5TEsRvFGqTuu3WWuKddzlk/pzAeDN029fA1szf52XmWmIb3RtlE7Lfr42NtSsCHU1Up9/75vH+slH0DhLkZPifSrd21aybYZ1Ax91oOrZ6PJnU/Kc930fJdIzTD5hwEB0IFtcmpHAyhXu5CeaumDdvzoep+aKkoxZIsUCKhuN8RSEqY5IHvm4q+fPK5Lq21Mb+UKeZvPlzD4KT/7OOWXWSAbLZPbtu4Ev2Hl5OB+0ZweKxEfiIIN/GlqPpNXyfy6hhdmo08IjMhxd8G08PZQ8L57nN0rOB4PCFH/LVM/wZg3Af7Y4GLfMjhy+4BWFbeO0J0yKKs/cm8+0rXvOhnfFC4ZuLqIR1GrjarDn2L1r4I0gGQCPCHvI+3gXqGRLDIYWCucv9Yw6VK3GVcFDWmZVsbgdNQ+gRl7f5eOUD9F79sw1qXTxY1MEXVgFJDl+5xHDVS2oYOuK9PHifUqmZbK11uPMzI0jtdqaDS8/JlUNULLvQcZfNSYGAhXPAaZkiEWJYfhM5vSIxtiFxwwj3DJ6NdqWsELwh8H5i3jYYQJ3ZQuiOnkGK7gfjrZoZZhIE3TKbjIMwbQOLoYMZXaMDdRn1Iwk8pyNj8QvUVq+2lo2a0l9WR8X2XpA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB5988.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(39840400004)(366004)(2616005)(956004)(5660300002)(36756003)(54906003)(316002)(26005)(8676002)(4326008)(66476007)(8936002)(6916009)(7416002)(38100700002)(38350700002)(44832011)(66946007)(52116002)(83380400001)(66556008)(186003)(478600001)(6666004)(86362001)(1076003)(6506007)(966005)(6512007)(107886003)(2906002)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Fe8hcvQnGEMCdT3OXEpDXUJTaW1GhoF4fQ1Es4S8K4gZdAagk22OhRekYZzh?=
 =?us-ascii?Q?OIA/GJFwv28yBK7gWpdwtMclzQr0qtFB4Dj3UtCZMe8gYCBTXINqYA9w6lrG?=
 =?us-ascii?Q?rQhI/XAmPIIMz1laiiIwobgpQEbuSgBTNUGLJkG9vLxcw2L8W2Yf5QgqY/mt?=
 =?us-ascii?Q?RfABXJbOYHZTfFaXzeM03afwVro8woRVv8vBIeKl6fVwreJ+y06xLtEXQ2AC?=
 =?us-ascii?Q?GVmPSLDlC32Fa3LqcmDQ5iwAVE/VFQdeGAzvDJBEn090svjY78gbGf7jqdjF?=
 =?us-ascii?Q?fpSmUeWbdnQUBF9co1T4tAiOK7GEOZbdkLIvKgOnH/bEeuDxspSjlvwnDoK4?=
 =?us-ascii?Q?EB3XTDG1ncwh0aEFlIJ1q9ZLjZy3E+qvj5uGJ4uKnSpTvTTOKyYeuVoiB3ou?=
 =?us-ascii?Q?4OiVZc2hN0R7UAU7dnI3rVJ3fYmhzaeqIAYNk+wljZ5toTLcOX9lc0Mr+x9v?=
 =?us-ascii?Q?Ph68JqIWdF63aCJk4Bs+u1wrdrLv7EAWu3IUf3UNR4K5oLr3QKpI5ZtKkePp?=
 =?us-ascii?Q?ecRR4amMVDTxLQHul2JX5s207ZpjOxIjimWoKLUNb4gNcS6N/QV2ADQ4C+cs?=
 =?us-ascii?Q?bS3jCnjJWC986xJivX1PPq4rqlgl5Mt3t7mWTvEHgVBkHxpLwMY08hnU5GyM?=
 =?us-ascii?Q?OPchVJbjjHhcukjIyjJuRphLhggT+IiGb3QnmVUyKa7vEUGz15VfokS5Kqn8?=
 =?us-ascii?Q?3YUTCy7rPnQe5MOcbKl5ATgmurfpBJmIWRL+3tmTI0E4qCGHFqUpkxzb5nRj?=
 =?us-ascii?Q?ncpxsVEuJ/xrPjG/1psc/QJuhTM57Im2U1IsZry6Nt/+MoV2s69nkjlh76x0?=
 =?us-ascii?Q?b+1tnvJBXdKI9Vh8jQrvBA2rN/7KKtTNRcev6UgD/e+TdjG4POCDZRO2PPkO?=
 =?us-ascii?Q?SUlVCQbt8s8tsv9tM2ueDFEV08765S8Nt54Om52+HTnmVBQzfyTRX/yZ9/fl?=
 =?us-ascii?Q?BVxg110otCBaNzQSJDmSVOuhzLkaMdyWXdXLLZ+kCNwOQOb6l9JoNhSGAqA5?=
 =?us-ascii?Q?ke/rwImd5h7z47gIRfSRw61c/vmwz7AARbFtfd5TBKS2eGEEMdB2CJuTpBf3?=
 =?us-ascii?Q?YRHjKwFlWqS3hY07C7GP3Ksr0IiQ9RpMhnBzWIqGJKaC0M0IPosyKdu8N6qW?=
 =?us-ascii?Q?9k0W/MfsmdMHNK25Xb1+k94nH2I3h9My37r6g52K2tNLBdWtFOQ60hpebHPt?=
 =?us-ascii?Q?PP5xazu5VRO1E1endtCG0WUSmVnfuGv+R0R2Hnd2Hr9Brr84zTLjPbj5sQqp?=
 =?us-ascii?Q?oXgoRms4zpHXHxEFv5MHpYRKIgTq3oQYe9W2fiBoBLk4wvNNU1a91obM1p/M?=
 =?us-ascii?Q?k7hsIeiqABPzgRNsO9qCDIjs?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fec28a52-4b4a-4d32-0b66-08d951c6cede
X-MS-Exchange-CrossTenant-AuthSource: AM9PR08MB5988.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 12:54:16.7211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fuoa9hUK8iI/0ktaUDLd9DsNQZVKnqn4El7nWO33upnFsev+VKK67IbmMTClweUmUeqnohl6g3oWzAlXp3tSuI8zyP04pQ4+vYHP8vZjEHw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB3379
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introducing new QMP command 'query-x86-cpuid'. This command can be used to
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
instruction, new QMP command can be used. By calling 'query-x86-cpuid'
command, one can get a full listing of all CPUID leaves with subleaves which are
supported by the initialized virtual CPU.

Other than debug, the command is useful in cases when we would like to
utilize QEMU's virtual CPU initialization routines and put the retrieved
values into kernel CPUID overriding mechanics for more precise control
over how various processes perceive its underlying hardware with
container processes as a good example.

The command is specific to x86. It is currenly only implemented for KVM acceleator.

Output format:
The output is a plain list of leaf/subleaf argument combinations, that
return 4 words in registers EAX, EBX, ECX, EDX.

Use example:
qmp_request: {
  "execute": "query-x86-cpuid"
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
This patch is next version (v12) of a patch with a changed subject
Previous subject: [PATCH v11] qapi: introduce 'query-kvm-cpuid' QMP command
https://patchew.org/QEMU/20210617122723.8670-1-valeriy.vdovin@virtuozzo.com/
Supersedes: 20210617122723.8670-1-valeriy.vdovin@virtuozzo.com

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
v12:
    - Changed title from query-kvm-cpuid to query-x86-cpuid
    - Removed CONFIG_KVM ifdefs
    - Added detailed error messages for some stub/unimplemented cases.

 qapi/machine-target.json   | 44 ++++++++++++++++++++++++++++++++
 softmmu/cpus.c             |  2 +-
 target/i386/kvm/kvm-stub.c | 10 ++++++++
 target/i386/kvm/kvm.c      | 51 ++++++++++++++++++++++++++++++++++++++
 tests/qtest/qmp-cmd-test.c |  1 +
 5 files changed, 107 insertions(+), 1 deletion(-)

diff --git a/qapi/machine-target.json b/qapi/machine-target.json
index e7811654b7..db906c9240 100644
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
+  'if': 'defined(TARGET_I386)' }
+
+##
+# @query-x86-cpuid:
+#
+# Returns raw data from the emulated CPUID table for the first VCPU.
+# The emulated CPUID table defines the response to the CPUID
+# instruction when executed by the guest operating system.
+#
+# Returns: a list of CpuidEntry
+#
+# Since: 6.1
+##
+{ 'command': 'query-x86-cpuid',
+  'returns': ['CpuidEntry'],
+  'if': 'defined(TARGET_I386)' }
diff --git a/softmmu/cpus.c b/softmmu/cpus.c
index a7ee431187..74fa6b9af4 100644
--- a/softmmu/cpus.c
+++ b/softmmu/cpus.c
@@ -128,7 +128,7 @@ void hw_error(const char *fmt, ...)
 /*
  * The chosen accelerator is supposed to register this.
  */
-static const AccelOpsClass *cpus_accel;
+const AccelOpsClass *cpus_accel;
 
 void cpu_synchronize_all_states(void)
 {
diff --git a/target/i386/kvm/kvm-stub.c b/target/i386/kvm/kvm-stub.c
index 92f49121b8..27305fc458 100644
--- a/target/i386/kvm/kvm-stub.c
+++ b/target/i386/kvm/kvm-stub.c
@@ -12,6 +12,7 @@
 #include "qemu/osdep.h"
 #include "cpu.h"
 #include "kvm_i386.h"
+#include "qapi/error.h"
 
 #ifndef __OPTIMIZE__
 bool kvm_has_smm(void)
@@ -39,3 +40,12 @@ bool kvm_hv_vpindex_settable(void)
 {
     return false;
 }
+
+typedef struct CpuidEntryList CpuidEntryList;
+CpuidEntryList *qmp_query_x86_cpuid(Error **errp);
+
+CpuidEntryList *qmp_query_x86_cpuid(Error **errp)
+{
+    error_setg(errp, "Not implemented in --disable-kvm configuration");
+    return NULL;
+}
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 7fe9f52710..114ed76493 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -20,10 +20,12 @@
 
 #include <linux/kvm.h>
 #include "standard-headers/asm-x86/kvm_para.h"
+#include "qapi/qapi-commands-machine-target.h"
 
 #include "cpu.h"
 #include "sysemu/sysemu.h"
 #include "sysemu/hw_accel.h"
+#include "sysemu/accel-ops.h"
 #include "sysemu/kvm_int.h"
 #include "sysemu/runstate.h"
 #include "kvm_i386.h"
@@ -1464,6 +1466,51 @@ static Error *invtsc_mig_blocker;
 
 #define KVM_MAX_CPUID_ENTRIES  100
 
+struct kvm_cpuid2 *cpuid_data_cached;
+extern const AccelOpsClass *cpus_accel;
+
+static inline int is_kvm_accel(AccelOpsClass *class)
+{
+    ObjectClass *parent_class;
+
+    parent_class = &class->parent_class;
+    return strcmp(object_class_get_name(parent_class),
+        "kvm-accel-ops") == 0;
+}
+
+CpuidEntryList *qmp_query_x86_cpuid(Error **errp)
+{
+    int i;
+    struct kvm_cpuid_entry2 *kvm_entry;
+    CpuidEntryList *head = NULL, **tail = &head;
+    CpuidEntry *entry;
+
+    if (!cpuid_data_cached) {
+         if (cpus_accel && !is_kvm_accel((AccelOpsClass *)cpus_accel))
+             error_setg(errp, "Not implemented for non-kvm accel");
+         else
+             error_setg(errp, "VCPU was not initialized yet");
+         return NULL;
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
@@ -1833,6 +1880,10 @@ int kvm_arch_init_vcpu(CPUState *cs)
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
index c98b78d033..bd883f7f52 100644
--- a/tests/qtest/qmp-cmd-test.c
+++ b/tests/qtest/qmp-cmd-test.c
@@ -46,6 +46,7 @@ static int query_error_class(const char *cmd)
         { "query-balloon", ERROR_CLASS_DEVICE_NOT_ACTIVE },
         { "query-hotpluggable-cpus", ERROR_CLASS_GENERIC_ERROR },
         { "query-vm-generation-id", ERROR_CLASS_GENERIC_ERROR },
+        { "query-x86-cpuid", ERROR_CLASS_GENERIC_ERROR },
         { NULL, -1 }
     };
     int i;
-- 
2.17.1

