Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E4836C4ED
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 13:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235793AbhD0LSZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 07:18:25 -0400
Received: from mail-eopbgr750082.outbound.protection.outlook.com ([40.107.75.82]:21193
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235860AbhD0LSL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 07:18:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YlkbJoJoGq5WT/Twoh2hRZyOXn85qE0UpzENiov8USYixav0Wj9GhZneFIzRnwvF9L0Uf0X2LWDIHJnfkbAfIy5rxHM2bViXS3WT24O+9/XKzJndgoDKuJYkGKaixu8Ky/CLLSHWsNCCCEVENR5embdvMuWYMTHWZcrbsMagbG7WmRH0ZJWIE8FRlceVq0rVH0ljWU6SkiQnrhGiKVfDp5rzUjYoaew4EnyUbDNJRAZYRI0ealoLRh/1mw/xHMUshQVlOmS6jw6HZTjUaQBaDVvTw7nYl2Kq6oCaRV191FubXLkA+nH9sucZdY5N65OP32Df18aYJjKpPSHo94Q9CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2nOEZicBp1Y3rjtNv6M78nq8vWBASOcaGaeP5+7Aj0E=;
 b=I/bn4V6hsn9TwafW8RGF+o1j7fYYDE9LSeEx1g/kI5n4WEbh5LHuMWN44YsjZBHIblNXoOusm965p0UcTMcFU1xCgfcFcsG8fWMrdWqwsgIapHMqozHmzrC+w9fa1vF6OX9+dfogqRgNXfcAazk9qd78HQ6qbNfexpuggsa821nfCyLT+AjKhKv3HfdGjMiyfiuDYQURkTxJmiXNJE+vYyWzTsC0L0d4Uk9RKvS5n2gHnNoS/Qw/tMlb8aPlM148jiQXXuIOgMX0e1nfkhCfw8JvXh0OjtxF2tvBMoRdDQZdSJCz57DraJ2vBqbj+q4naFfHCnvQ9lWbod5No0vrCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2nOEZicBp1Y3rjtNv6M78nq8vWBASOcaGaeP5+7Aj0E=;
 b=0FQRl/XWpQzccfmsFdg43S5cNyFZGRCaCE9dxLdk4TwIN/gbXVIi9oWY4AIvKhop5OjCjfU/mZA8+FzTN3jNb3B2lHqcZuCkSJj2ZW4UyNNNhhtJ68nilBPk26qZFN+3lEePzuNyB4EfaY0r7qwzxdxle1dGFZeb2aRZSEdX57k=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4432.namprd12.prod.outlook.com (2603:10b6:806:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.26; Tue, 27 Apr
 2021 11:16:50 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Tue, 27 Apr 2021
 11:16:50 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH 1/3] x86/sev-es: Rename sev-es.{ch} to sev.{ch}
Date:   Tue, 27 Apr 2021 06:16:34 -0500
Message-Id: <20210427111636.1207-2-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210427111636.1207-1-brijesh.singh@amd.com>
References: <20210427111636.1207-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0201CA0054.namprd02.prod.outlook.com
 (2603:10b6:803:20::16) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0201CA0054.namprd02.prod.outlook.com (2603:10b6:803:20::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend Transport; Tue, 27 Apr 2021 11:16:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2059cdf-03e8-42b8-4883-08d9096df3e7
X-MS-TrafficTypeDiagnostic: SA0PR12MB4432:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4432083BF27C8506BBA7760FE5419@SA0PR12MB4432.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ArJzbGJWQY1a2sLb8ohcWfJ9FehhhMVuF2gcnDTAijGFiprJt5xfEgQzBaOi/xLTPbVakuK1Qaave7pT56Lmv4PUlzbYvJaTQe/7efVo5Vuq2M3hwnMpl0ouB7vUBB60f5bO8vn2zQEwVVJbu7K/EjImPYGf52Q2yvNnCI5OSpl3lFIm0TowT2mGJbLECegShFlt61KXsb6KZR9lThycDGzrFakqHPwmM63dnAyH7nLPG6QlrPx4qIU/2uzy6oVyR3HYT/goYfYZdDT1tLhAgzhQ7itjONQBKw5W6YLYJeRCWysFRvQhnlUBk/sc3LXBFCG9KbJCOVlmde+/u2B5y/DzeR3Spq6bBo8AqeeWPNTYXp7MvFGN8BI/ZabK+wPJLniQvi9vPeoqy8YHQaFGz5u5sIPxd+ohOhmoW+8yinhSn2/TixUEb2W9PfRYqODerZbA5iJejY3UAIvcdXN3aBs0SIrtzM+lj2L6HAAkFZPvq/VGz7y+hQnpiXYSvI2Ma4Nxm1BkDH/sue4+IwR9tLDYqdZrbSCHmw0/rywEf7UjXBmWC2wTaWRbn+WIYSK1a8mhLOwjuh9XINXfOO0siXxkGsrobFhE6obI/muO+FDTzbQON2jD8ce92xjQ0oMbZHsDg31lmrrOvT79IgqhFt7hFu1KUffSpV4Uyg3lucE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(366004)(376002)(39860400002)(66556008)(66476007)(5660300002)(2616005)(956004)(478600001)(316002)(6916009)(66946007)(6666004)(44832011)(52116002)(86362001)(7696005)(1076003)(36756003)(8676002)(26005)(8936002)(16526019)(4326008)(2906002)(6486002)(83380400001)(186003)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?TuDExmeKGFXWd7k+qEU1r78Nb5W0r0IJqsAp/CH7m/63vjJOGxd+HsPqSN8m?=
 =?us-ascii?Q?dLtdTW5P1gzHSxUtvTiiKn4EjXCPHarYi1Q0Se8BjlIOHtSQwDntsDFFHRqd?=
 =?us-ascii?Q?epcYYCFIiwojuiZquDlVsSNwyYlyUgkgHaK4ZYWchr3rW3mqst/HykKHAush?=
 =?us-ascii?Q?mzEkvkfuHOCPgpljybhkfFjF1/levTukjIp0pFotJWlOIeY8gqdG/zDnnBzl?=
 =?us-ascii?Q?hjfu23/fpp4pAPXMxz5DAn8quW52LT2BgFRUNfbNx90aAnp1YDiwgNRD2QYQ?=
 =?us-ascii?Q?v8BXZmrKX9f4zD/231gFdhyfuzuKZY++154V8qD2I3CsGtPtWjAiJpqE/Hs7?=
 =?us-ascii?Q?cGHiVquag5otqf+3SoMI5NKI2ok/v/XB4xSaNS9gD7clg5jmn0liEgcZjiAj?=
 =?us-ascii?Q?Pl2vzUpkCSKQovhqZDxPQ2eBma5arQwDuZQvl94bCZ1u8463DG+hzyrQ93V2?=
 =?us-ascii?Q?qmpClsZxh2TzZ47q5AtD8UWFpede93kzVJiYnEExCikpch1E4p0I6N5yKK1k?=
 =?us-ascii?Q?BrOqsveKIha10beUjxMUpy/PRV5oxUMsp16wnNsWloa2NKIFgZc7EIX5A58W?=
 =?us-ascii?Q?YygySvopb/TxB37xaS3H9fkkTGG/omHyOlnf5jQGaZ1mCV+SlEYxZJBn4jhV?=
 =?us-ascii?Q?3kTzb+tWrY/xugN4IfIva7ASACpCwcVWpInL2rK90YInRhH/bEKKs94LabPI?=
 =?us-ascii?Q?NC0pQoL4IaCvs5ssajAhIC1a5EBL3tSHyJETLEU3zbO0Pc/ncdbuzNV2K5S9?=
 =?us-ascii?Q?WUsrtELN+XSt/WA0b8nQwEhSgokFbQD1cq32rIBaUx3fWhBrKqZczj0CXy6U?=
 =?us-ascii?Q?3QGWR//OM/axmxwaFQ76zrl7ewzjf0Y+8U8u3v4rM+qq4AEq/YHT8QqI8MHi?=
 =?us-ascii?Q?jF/i8Ute4oNAwIX0UT3wvcEJ6gkiRozmeWlez2x6ywqahVQPwxhqjDhd4m8l?=
 =?us-ascii?Q?vWmqQFPOWAFExCe/mD/tKp5tPUnR1kfCiWwRX82ZAAur2KUX6qWV95fy0Pvs?=
 =?us-ascii?Q?avrSvJknAzFSvDlnOwzbsKJXJM0YOrCyi1t3Ze2mILE67x96VU0zbG2F7e9R?=
 =?us-ascii?Q?TX+FMjJJKattH0e9rCEl9eBQEiA/e/Z5H7+Y8ivlWAWkBUtSCOrn7S5uO7sA?=
 =?us-ascii?Q?XEvJ5UBl+fJa7hyjkLMLNJ9M/AQ342E2P0mno9wvQD2tiuE5VoLpOY3RCuQM?=
 =?us-ascii?Q?jDqkBRrRA5eSnLWsX9OmNOxA5qETnfuQO65tgLQthDtiJ08akFFsKAW8Nt4U?=
 =?us-ascii?Q?SWKdHRliXvotdSnihyDv4im+ERnY0L1iNVrlxuXdJ+GnpNFFWNJYiQRHR9Ez?=
 =?us-ascii?Q?y6rPCvN8oOR3OdEyGHXvAR5K?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2059cdf-03e8-42b8-4883-08d9096df3e7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2021 11:16:49.9920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PK/e8WYIcGQnL2cMV44TO/Dm3QfyigKWe0CQdm8JDTHbWk+99mzQo/DqjxUTQvd9PjnmhLLq8f+AxpxNlXJFyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4432
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SEV-SNP builds upon the SEV-ES functionality while adding new hardware
protection. Version 2 of the GHCB specification adds new NAE events that
are SEV-SNP specific. Rename the sev-es.{ch} to sev.{ch} so that we can
consolidate all the SEV-ES and SEV-SNP in a one place.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/boot/compressed/Makefile                 | 6 +++---
 arch/x86/boot/compressed/{sev-es.c => sev.c}      | 4 ++--
 arch/x86/include/asm/{sev-es.h => sev.h}          | 0
 arch/x86/kernel/Makefile                          | 6 +++---
 arch/x86/kernel/head64.c                          | 2 +-
 arch/x86/kernel/nmi.c                             | 2 +-
 arch/x86/kernel/{sev-es-shared.c => sev-shared.c} | 0
 arch/x86/kernel/{sev-es.c => sev.c}               | 4 ++--
 arch/x86/mm/extable.c                             | 2 +-
 arch/x86/platform/efi/efi_64.c                    | 2 +-
 arch/x86/realmode/init.c                          | 2 +-
 11 files changed, 15 insertions(+), 15 deletions(-)
 rename arch/x86/boot/compressed/{sev-es.c => sev.c} (98%)
 rename arch/x86/include/asm/{sev-es.h => sev.h} (100%)
 rename arch/x86/kernel/{sev-es-shared.c => sev-shared.c} (100%)
 rename arch/x86/kernel/{sev-es.c => sev.c} (99%)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 6e5522aebbbd..2a2975236c9e 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -48,10 +48,10 @@ KBUILD_CFLAGS += $(call as-option,-Wa$(comma)-mrelax-relocations=no)
 KBUILD_CFLAGS += -include $(srctree)/include/linux/hidden.h
 KBUILD_CFLAGS += $(CLANG_FLAGS)
 
-# sev-es.c indirectly inludes inat-table.h which is generated during
+# sev.c indirectly inludes inat-table.h which is generated during
 # compilation and stored in $(objtree). Add the directory to the includes so
 # that the compiler finds it even with out-of-tree builds (make O=/some/path).
-CFLAGS_sev-es.o += -I$(objtree)/arch/x86/lib/
+CFLAGS_sev.o += -I$(objtree)/arch/x86/lib/
 
 KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
 GCOV_PROFILE := n
@@ -93,7 +93,7 @@ ifdef CONFIG_X86_64
 	vmlinux-objs-y += $(obj)/idt_64.o $(obj)/idt_handlers_64.o
 	vmlinux-objs-y += $(obj)/mem_encrypt.o
 	vmlinux-objs-y += $(obj)/pgtable_64.o
-	vmlinux-objs-$(CONFIG_AMD_MEM_ENCRYPT) += $(obj)/sev-es.o
+	vmlinux-objs-$(CONFIG_AMD_MEM_ENCRYPT) += $(obj)/sev.o
 endif
 
 vmlinux-objs-$(CONFIG_ACPI) += $(obj)/acpi.o
diff --git a/arch/x86/boot/compressed/sev-es.c b/arch/x86/boot/compressed/sev.c
similarity index 98%
rename from arch/x86/boot/compressed/sev-es.c
rename to arch/x86/boot/compressed/sev.c
index 82041bd380e5..670e998fe930 100644
--- a/arch/x86/boot/compressed/sev-es.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -13,7 +13,7 @@
 #include "misc.h"
 
 #include <asm/pgtable_types.h>
-#include <asm/sev-es.h>
+#include <asm/sev.h>
 #include <asm/trapnr.h>
 #include <asm/trap_pf.h>
 #include <asm/msr-index.h>
@@ -117,7 +117,7 @@ static enum es_result vc_read_mem(struct es_em_ctxt *ctxt,
 #include "../../lib/insn.c"
 
 /* Include code for early handlers */
-#include "../../kernel/sev-es-shared.c"
+#include "../../kernel/sev-shared.c"
 
 static bool early_setup_sev_es(void)
 {
diff --git a/arch/x86/include/asm/sev-es.h b/arch/x86/include/asm/sev.h
similarity index 100%
rename from arch/x86/include/asm/sev-es.h
rename to arch/x86/include/asm/sev.h
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 0704c2a94272..0f66682ac02a 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -20,7 +20,7 @@ CFLAGS_REMOVE_kvmclock.o = -pg
 CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
 CFLAGS_REMOVE_head64.o = -pg
-CFLAGS_REMOVE_sev-es.o = -pg
+CFLAGS_REMOVE_sev.o = -pg
 endif
 
 KASAN_SANITIZE_head$(BITS).o				:= n
@@ -28,7 +28,7 @@ KASAN_SANITIZE_dumpstack.o				:= n
 KASAN_SANITIZE_dumpstack_$(BITS).o			:= n
 KASAN_SANITIZE_stacktrace.o				:= n
 KASAN_SANITIZE_paravirt.o				:= n
-KASAN_SANITIZE_sev-es.o					:= n
+KASAN_SANITIZE_sev.o					:= n
 
 # With some compiler versions the generated code results in boot hangs, caused
 # by several compilation units. To be safe, disable all instrumentation.
@@ -148,7 +148,7 @@ obj-$(CONFIG_UNWINDER_ORC)		+= unwind_orc.o
 obj-$(CONFIG_UNWINDER_FRAME_POINTER)	+= unwind_frame.o
 obj-$(CONFIG_UNWINDER_GUESS)		+= unwind_guess.o
 
-obj-$(CONFIG_AMD_MEM_ENCRYPT)		+= sev-es.o
+obj-$(CONFIG_AMD_MEM_ENCRYPT)		+= sev.o
 ###
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 18be44163a50..de01903c3735 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -39,7 +39,7 @@
 #include <asm/realmode.h>
 #include <asm/extable.h>
 #include <asm/trapnr.h>
-#include <asm/sev-es.h>
+#include <asm/sev.h>
 
 /*
  * Manage page tables very early on.
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index bf250a339655..fea394cabfa9 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -33,7 +33,7 @@
 #include <asm/reboot.h>
 #include <asm/cache.h>
 #include <asm/nospec-branch.h>
-#include <asm/sev-es.h>
+#include <asm/sev.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/nmi.h>
diff --git a/arch/x86/kernel/sev-es-shared.c b/arch/x86/kernel/sev-shared.c
similarity index 100%
rename from arch/x86/kernel/sev-es-shared.c
rename to arch/x86/kernel/sev-shared.c
diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev.c
similarity index 99%
rename from arch/x86/kernel/sev-es.c
rename to arch/x86/kernel/sev.c
index 73873b007838..9578c82832aa 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev.c
@@ -22,7 +22,7 @@
 
 #include <asm/cpu_entry_area.h>
 #include <asm/stacktrace.h>
-#include <asm/sev-es.h>
+#include <asm/sev.h>
 #include <asm/insn-eval.h>
 #include <asm/fpu/internal.h>
 #include <asm/processor.h>
@@ -459,7 +459,7 @@ static enum es_result vc_slow_virt_to_phys(struct ghcb *ghcb, struct es_em_ctxt
 }
 
 /* Include code shared with pre-decompression boot stage */
-#include "sev-es-shared.c"
+#include "sev-shared.c"
 
 void noinstr __sev_es_nmi_complete(void)
 {
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index b93d6cd08a7f..121921b2927c 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -5,7 +5,7 @@
 #include <xen/xen.h>
 
 #include <asm/fpu/internal.h>
-#include <asm/sev-es.h>
+#include <asm/sev.h>
 #include <asm/traps.h>
 #include <asm/kdebug.h>
 
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index df7b5477fc4f..7515e78ef898 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -47,7 +47,7 @@
 #include <asm/realmode.h>
 #include <asm/time.h>
 #include <asm/pgalloc.h>
-#include <asm/sev-es.h>
+#include <asm/sev.h>
 
 /*
  * We allocate runtime services regions top-down, starting from -4G, i.e.
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index 1be71ef5e4c4..2e1c1bec0f9e 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -9,7 +9,7 @@
 #include <asm/realmode.h>
 #include <asm/tlbflush.h>
 #include <asm/crash.h>
-#include <asm/sev-es.h>
+#include <asm/sev.h>
 
 struct real_mode_header *real_mode_header;
 u32 *trampoline_cr4_features;
-- 
2.17.1

