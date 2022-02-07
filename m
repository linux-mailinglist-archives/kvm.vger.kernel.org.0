Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5EBA4AB409
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 07:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240923AbiBGFvM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 00:51:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbiBGFNu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 00:13:50 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2087.outbound.protection.outlook.com [40.107.236.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180BAC043181
        for <kvm@vger.kernel.org>; Sun,  6 Feb 2022 21:13:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mvTSirEcCU5dLF/i2wiK9+Dh8m7bmCvWhDoJTbgbIMyoFaVOKlnqpn4zV9IBrXqL/ArhM+y5+AGessDvejRVeI0pVuNd+xAOOisITM87TohfQ043XX3zcjr+WnVq1QH+xEyynXAdyOozOTLQahpfWWG7oRRYmkdK/z2Kv+wGp+H5AI+w50DvLTblIkXcDyVqN/Slbl5Q1mWcdcirACOGEIoT2OQ9zacd3Ng6OIODdRKKzRRHW/x4UCIVwNkgmm7D84NqeTzsutQTLiajBlcghDGpW49fX42pkIPiVHiDwqlX/pIVldk6Rmi6ajr3NUXpcEMHb1cxZevvT5dp9aGs4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P6pUBvDwVu4Ulfbf8J6ZRAI8e0FcdEL/g4vwaN78in8=;
 b=mGpekMVXhArbUdeqHMrg2ONWPWVI+Un8x4L6RQSngYunJxtBluI4r/4HV5Ez8MJkPvRWdLWLWQSQqpytHWul6gdyi+OZsDAXL39/qxnQeMpnx3BRkJr39pwRiq+4DSB9qbVAFPOcwUquIKm6UPgE1qEyUTEYqJjZriMUW+QOitHaXy9x3s77TNxTXv3EAdRQq/gDQBbKajNtM5XBP13M0BxPSt/7ROh/4KPPWrjdxdH2ieYKhU1MowVm0IuQj2YDLH73lgJbXFdSpihk7eTnDZG03NWO7GKfGvIyoMTbyk277nOPVAz1IZ2Wt4PPFfTqbip55XoyPgYy5rAMqvXNPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P6pUBvDwVu4Ulfbf8J6ZRAI8e0FcdEL/g4vwaN78in8=;
 b=ajVw6x0QgkcDjPLTj0d3wn1ynVCwxzU1wZZuch3H5Dj2hVEo4gAtUn8lr7+qku7/8uqSNVsy0i026GK7AYfojt0NTWy7gDsaaJj+aP/YeX4a1wuCJQtQcWJuHFkjjKr76JHUQKEXb3PsXtXENJT2BOJeQdhEjTu5q5z0b5X2rKM=
Received: from DM5PR19CA0042.namprd19.prod.outlook.com (2603:10b6:3:9a::28) by
 BY5PR12MB3698.namprd12.prod.outlook.com (2603:10b6:a03:194::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Mon, 7 Feb
 2022 05:13:45 +0000
Received: from DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:9a:cafe::2f) by DM5PR19CA0042.outlook.office365.com
 (2603:10b6:3:9a::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18 via Frontend
 Transport; Mon, 7 Feb 2022 05:13:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT026.mail.protection.outlook.com (10.13.172.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4951.12 via Frontend Transport; Mon, 7 Feb 2022 05:13:44 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Sun, 6 Feb
 2022 23:13:42 -0600
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>, <aaronlewis@google.com>
Subject: [kvm-unit-tests PATCH 3/3] x86: nSVM: Add an exception test framework and tests
Date:   Mon, 7 Feb 2022 05:12:02 +0000
Message-ID: <20220207051202.577951-4-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220207051202.577951-1-manali.shukla@amd.com>
References: <20220207051202.577951-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37bf3da9-b8a8-4436-29f2-08d9e9f89d38
X-MS-TrafficTypeDiagnostic: BY5PR12MB3698:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB36984D9BED36D1CC4BC8AEF6FD2C9@BY5PR12MB3698.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:183;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +N1nIxvi/WsNKPNzcqCvXRgSSsb9TDvJVHT/zPcFbzILrApvhmEGvDXnbuUAuPGh6JB85aPer6oZhZGs1VQczdhnj7YSYxBy8f2drW+7I7OnCNjICAcjB6P/Al/NZVyyDiWnGW9/0Z95UtbRusnAR+rQHZtTHPLPs8zHlddeGgKiZLgTUOD+EVXU6d/WXxCwKFZTK3uLYtgvN6YOaLIzS1jXGxpO8r/cp21DWYl5/3JQxEd2Nb3QIEMVEb/uldNVtCKr9X84Zc1u1pZBXMNgsltJGxdqgB5+EzSyDIqz+8YEoHQg1BdWFKGQoBpIkdksijb7o4hWmKe8qItBYfeGKrz8gDtNu+EoKFETVqy1nwpSz3FgbRnN5v4xjSzRwmWj7fA0s2fP51iHOvv63g9NgJxsUyLrZtsaTb8l5pupbB76CHE/2mpv20QPumEdXICCSv7hIi2smlTLvYZWb583vqTtEgovDwYucoxONrTjb6hjBAIUewfXgIPdUJZqBxbIV/8Or3Wr/PVehEgtrYxm6m82+O3/2SeXlX05cWljQgdmKE4fv8voSvFFcjwI00BYBdB2r+Tqs/GhJ1HhxFK/k3KyY6Q+C/fnGDr6kIp3be0r98JnPbjr5MnoH0Pc3Y3GOYV0RKh+WLH8O96EFGEspVJjNfUUj3t9ly4F/iyaFQ0fYjyR73Q5l+K/PitbzEU7iB4jp5Sg8OChGTR7M460PA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(70586007)(70206006)(356005)(47076005)(44832011)(2906002)(86362001)(82310400004)(8936002)(4326008)(8676002)(6666004)(7696005)(81166007)(5660300002)(36860700001)(316002)(6916009)(508600001)(83380400001)(36756003)(336012)(1076003)(186003)(426003)(2616005)(16526019)(54906003)(40460700003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 05:13:44.7407
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 37bf3da9-b8a8-4436-29f2-08d9e9f89d38
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3698
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set up a test framework that verifies an exception occurring
in L2 is forwarded to the right place (L1 or L2)
It adds an exception test array and exception callbacks to that array.

Tests two conditions for each exception
1) Exception generated in L2, is handled by L2 when L2 exception handler
   is registered.
2) Exception generated in L2, is handled by L1 when intercept exception
   bit map is set in L1.

Add testing for below exceptions:
(#GP, #UD, #DE, #BP, #NM, #OF, #DB, #AC)
1. #GP is generated in c by non-canonical access in L2.
2. #UD is generated by calling "ud2" instruction in L2.
3. #DE is generated using instrumented code which generates
   divide by zero condition
4. #BP is generated by calling "int3" instruction in L2.
5. #NM is generated by calling floating point instruction "fnop"
   in L2 when TS bit is set.
6. #OF is generated using instrumented code and "into" instruction
   is called in that code in L2.
7. #DB is generated by setting TF bit before entering to L2.
8. #AC is genrated by writing 8 bytes to 4 byte aligned address in L2
   user mode when AM bit is set in CR0 register and AC bit is set in
   RFLAGS

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 x86/svm_tests.c | 185 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 185 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 0707786..66bfb51 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -10,6 +10,7 @@
 #include "isr.h"
 #include "apic.h"
 #include "delay.h"
+#include "x86/usermode.h"
 
 #define SVM_EXIT_MAX_DR_INTERCEPT 0x3f
 
@@ -3074,6 +3075,189 @@ static void svm_nm_test(void)
         "fnop with CR0.TS and CR0.EM unset no #NM excpetion");
 }
 
+static void svm_l2_gp_test(struct svm_test *test)
+{
+    *(volatile u64 *)NONCANONICAL = 0;
+}
+
+static void svm_l2_ud_test(struct svm_test *test)
+{
+    asm volatile ("ud2");
+}
+
+static void svm_l2_de_test(struct svm_test *test)
+{
+        asm volatile (
+                "xor %%eax, %%eax\n\t"
+                "xor %%ebx, %%ebx\n\t"
+                "xor %%edx, %%edx\n\t"
+                "idiv %%ebx\n\t"
+                ::: "eax", "ebx", "edx");
+}
+
+static void svm_l2_bp_test(struct svm_test *svm)
+{
+    asm volatile ("int3");
+}
+
+static void svm_l2_nm_test(struct svm_test *svm)
+{
+    write_cr0(read_cr0() | X86_CR0_TS);
+    asm volatile("fnop");
+}
+
+static void svm_l2_of_test(struct svm_test *svm)
+{
+    struct far_pointer32 fp = {
+        .offset = (uintptr_t)&&into,
+        .selector = KERNEL_CS32,
+    };
+    uintptr_t rsp;
+
+    asm volatile ("mov %%rsp, %0" : "=r"(rsp));
+
+    if (fp.offset != (uintptr_t)&&into) {
+        printf("Codee address too high.\n");
+        return;
+    }
+
+    if ((u32)rsp != rsp) {
+        printf("Stack address too high.\n");
+    }
+
+    asm goto("lcall *%0" : : "m" (fp) : "rax" : into);
+    return;
+into:
+    asm volatile (".code32;"
+            "movl $0x7fffffff, %eax;"
+            "addl %eax, %eax;"
+            "into;"
+            "lret;"
+            ".code64");
+    __builtin_unreachable();
+}
+
+static void svm_l2_db_test(struct svm_test *test)
+{
+    write_rflags(read_rflags() | X86_EFLAGS_TF);
+}
+
+static uint64_t usermode_callback(void)
+{
+   /*
+    * Trigger an #AC by writing 8 bytes to a 4-byte aligned address.
+    * Disclaimer: It is assumed that the stack pointer is aligned
+    * on a 16-byte boundary as x86_64 stacks should be.
+    */
+    asm volatile("movq $0, -0x4(%rsp)");
+
+    return 0;
+}
+
+static void svm_l2_ac_test(struct svm_test *test)
+{
+    bool hit_ac = false;
+
+    write_cr0(read_cr0() | X86_CR0_AM);
+    write_rflags(read_rflags() | X86_EFLAGS_AC);
+ 
+    run_in_user(usermode_callback, AC_VECTOR, 0, 0, 0, 0, &hit_ac);
+
+    report(hit_ac, "Usermode #AC handled in L2");
+    vmmcall();
+}
+
+static void svm_ac_init(void)
+{
+    set_user_mask_all(phys_to_virt(read_cr3()), PAGE_LEVEL);
+}
+
+static void svm_ac_uninit(void)
+{
+    clear_user_mask_all(phys_to_virt(read_cr3()), PAGE_LEVEL);
+}
+
+struct svm_exception_test {
+    u8 vector;
+    void (*guest_code)(struct svm_test*);
+    void (*init_test)(void);
+    void (*uninit_test)(void);
+};
+
+struct svm_exception_test svm_exception_tests[] = {
+    { GP_VECTOR, svm_l2_gp_test },
+    { UD_VECTOR, svm_l2_ud_test },
+    { DE_VECTOR, svm_l2_de_test },
+    { BP_VECTOR, svm_l2_bp_test },
+    { NM_VECTOR, svm_l2_nm_test },
+    { OF_VECTOR, svm_l2_of_test },
+    { DB_VECTOR, svm_l2_db_test },
+    { AC_VECTOR, svm_l2_ac_test, svm_ac_init, svm_ac_uninit },
+};
+
+static u8 svm_exception_test_vector;
+
+static void svm_exception_handler(struct ex_regs *regs)
+{
+    report(regs->vector == svm_exception_test_vector,
+            "Handling %s in L2's exception handler",
+            exception_mnemonic(svm_exception_test_vector));
+    vmmcall();
+}
+
+static void handle_exception_in_l2(u8 vector)
+{
+    handler old_handler = handle_exception(vector, svm_exception_handler);
+    svm_exception_test_vector = vector;
+
+    report(svm_vmrun() == SVM_EXIT_VMMCALL,
+           "%s handled by L2", exception_mnemonic(vector));
+
+    handle_exception(vector, old_handler);
+}
+
+static void handle_exception_in_l1(u32 vector)
+{
+    u32 old_ie = vmcb->control.intercept_exceptions;
+
+    vmcb->control.intercept_exceptions |= (1ULL << vector);
+
+    report(svm_vmrun() == (SVM_EXIT_EXCP_BASE + vector),
+           "%s handled by L1",  exception_mnemonic(vector));
+
+    vmcb->control.intercept_exceptions = old_ie;
+}
+
+static void svm_exception_test(void)
+{
+    struct svm_exception_test *t;
+    int i;
+
+    for (i = 0; i < ARRAY_SIZE(svm_exception_tests); i++) {
+        t = &svm_exception_tests[i];
+        test_set_guest(t->guest_code);
+        if (t->init_test)
+            t->init_test();
+
+        handle_exception_in_l2(t->vector);
+
+        if (t->uninit_test)
+            t->uninit_test();
+
+        vmcb_ident(vmcb);
+
+        if (t->init_test)
+            t->init_test();
+
+        handle_exception_in_l1(t->vector);
+
+        if (t->uninit_test)
+            t->uninit_test();
+
+        vmcb_ident(vmcb);
+    }
+}
+
 struct svm_test svm_tests[] = {
     { "null", default_supported, default_prepare,
       default_prepare_gif_clear, null_test,
@@ -3196,5 +3380,6 @@ struct svm_test svm_tests[] = {
     TEST(svm_nm_test),
     TEST(svm_int3_test),
     TEST(svm_into_test),
+    TEST(svm_exception_test),
     { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
-- 
2.30.2

