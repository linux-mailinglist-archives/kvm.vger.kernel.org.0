Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3077B55DC44
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344282AbiF1LmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 07:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240736AbiF1LmC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 07:42:02 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58A12F3BA
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 04:41:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mQLS5rAEYzOy1BA+rD/EzFmvaY+/XJUwKmbgTm31omfMVZyxDW8kK1kFSjUc5OlMKpaRtU+2xgX+wphLzwSkVwjfpfwEaXk4V2FQIu31YLRnuF2eYnh8uzXPYuh7rFVUhpfzX7KI5Ws+jf0+0U8IAFhMTGP3+OsZFxWt5nQ+QL0GCsmXh2KuVsBM+zQRs6dAUfLkxu3UjjbIQj+H0A/HztLm3Aflct9OJVZGpHfNYUkgeKEOO/ys2F8A3X/2cqN/QpNtpqy+RmPdha4mFOX6/AtTk0j6N+zX463Tlh+ZKP76OV5YAMo0Luv2dhxre9GoQAt2cqHYyoICMcrmabl/+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QnUWoDAB/kyS3l3pYUzDuWJPaQRj2jTQ37y7IB+TjEE=;
 b=mkFvOeEYgKEy+4Ss5bx3Ds5iA/UwNRT5QsIjtlmC6cwfRpcVxo0Y0/fdMEhaBweuoAue08npj42QpqxlQfKkS4qOFuwzQlu7eRvcfzexnVe6cD5mc9OmWXzLhVaoK06O88LSAr30tzXrhADcR/vMSzM1r7iuBv4Q4+ut/Pzq+/Y0Vs9/GjwxsDRYm40ZyqmHdeQuSOmALYxfXZ9/DttTxG/CCD/bqr5qKYK2B0DHzMUagyb3L/npQH67v+ahujH50/NCIcvdbdl90Po+N8IpC1a54SRnuVGgoLa5Ei86sZdd9zy3fCcyIdLs0V519tv/i6A30vUWVY7pa+2u5aanyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QnUWoDAB/kyS3l3pYUzDuWJPaQRj2jTQ37y7IB+TjEE=;
 b=NaL9cTNxnEwM7zK+O8AeHoJSFC0VIfua0akrywqwxBXGgOSUB78OVXo6JWgbMZncKAkG+UMLtEYSGd9viB9N+QxAtBq28cflrrXxC8fAZIh1neWgTjKyIHmjEUHYaIJcNiE6W1JSa0rAh+uy8CMfIqQIhHW6WvKy+lp5mtYL0R8=
Received: from BN6PR16CA0046.namprd16.prod.outlook.com (2603:10b6:405:14::32)
 by MW4PR12MB5603.namprd12.prod.outlook.com (2603:10b6:303:16a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 11:41:56 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:14:cafe::8b) by BN6PR16CA0046.outlook.office365.com
 (2603:10b6:405:14::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.21 via Frontend
 Transport; Tue, 28 Jun 2022 11:41:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5373.15 via Frontend Transport; Tue, 28 Jun 2022 11:41:55 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 28 Jun
 2022 06:41:52 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH v5 7/8] x86: nSVM: Correct indentation for svm_tests.c part-1
Date:   Tue, 28 Jun 2022 11:38:52 +0000
Message-ID: <20220628113853.392569-8-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220628113853.392569-1-manali.shukla@amd.com>
References: <20220628113853.392569-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 141cfadc-8a56-4c86-d15b-08da58fb33f7
X-MS-TrafficTypeDiagnostic: MW4PR12MB5603:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 39M45anaf7gorplOsLzfoJO1faNIl166HVjtsFuvsVQpNwggkWgXrfRT6Zi/Lua95oTFdtinhZo6i8zxSe/1B4GeriRVY/BMHcjzE0qYoVk4WDEJ4Dvy0apuS41DRDFMl5Z5A00IebNo0aFXJpVxzW9Pwv/Ff5THwU638ES3WKWGKDU1dW2tCynN1TE9jelh9V/lDf5dPih7IYj2zUkvAPe9IwFZU8ZschNOoDIHcn1/em74WrSu9h+Nf0nhKkb521MI7LhL8FjK+ms2MAEJVrUy3MsB4oOKzAfPiwriIJ6U7mvlJIJUGNEqav7ko/MURibCNTJCnHhpffJbeiDAhCuY3ONhxXnY2VNCj7BDXMmmAEneQh4sTJnc60VHZbmYyex2xx3IfrtH3xiCD90IU3G+ULPI/Q+wPdmnYB495HNa9ZaB8oCtdFcNx0aGo5haGWR8ndxaAqqUnq6p+wUfa4/8z0zKeFRX9wVMMOiMqIgde4JXfWdwqoXYTthGBdz1ngA9XmVkHJYNbEwvMI/kca2lG1okkyiV0fXBWVcfS2ayMUU3CxwRg93U3N4CSVSiGzaYhnghoHRHOh3qSAhdUfyF/mAkvbH9/SrJwmqECRwZ9a6UTT6As4+4hzpqh+z47OC6m+xAM7euEff/SyeGzNZNDwK/1Ydd8jKxXpOdbWvHWVr80GNVNQ9o93utw5ppdPHor+2Wnyxn6121xlc2jvTAwEWocGcvU33LqD6WnBn4fqWnnkHMVIu0hFgBXHFheKgpA9sdsmxjBLmzwxUODIHXPQTnk0mF0ygWoEeGVJPNMTY6DduCoKcJ915BNV0wjVKQgy5R8VGcBHcCaZSi6aBpJFGLREwGtls8O6cAQ3A=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(136003)(376002)(346002)(40470700004)(46966006)(36840700001)(36860700001)(41300700001)(7696005)(2616005)(2906002)(1076003)(82310400005)(16526019)(186003)(426003)(336012)(47076005)(40480700001)(8676002)(83380400001)(26005)(30864003)(86362001)(4326008)(81166007)(356005)(966005)(82740400003)(36756003)(8936002)(70586007)(70206006)(110136005)(316002)(40460700003)(5660300002)(478600001)(44832011)(36900700001)(579004)(559001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 11:41:55.7636
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 141cfadc-8a56-4c86-d15b-08da58fb33f7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5603
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixed indentation errors in svm_tests.c.

No functional changes intended.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 x86/svm_tests.c | 2174 +++++++++++++++++++++++------------------------
 1 file changed, 1087 insertions(+), 1087 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 1692912..f9e3f36 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -43,492 +43,492 @@ static void null_test(struct svm_test *test)
 
 static bool null_check(struct svm_test *test)
 {
-    return vmcb->control.exit_code == SVM_EXIT_VMMCALL;
+	return vmcb->control.exit_code == SVM_EXIT_VMMCALL;
 }
 
 static void prepare_no_vmrun_int(struct svm_test *test)
 {
-    vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMRUN);
+	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMRUN);
 }
 
 static bool check_no_vmrun_int(struct svm_test *test)
 {
-    return vmcb->control.exit_code == SVM_EXIT_ERR;
+	return vmcb->control.exit_code == SVM_EXIT_ERR;
 }
 
 static void test_vmrun(struct svm_test *test)
 {
-    asm volatile ("vmrun %0" : : "a"(virt_to_phys(vmcb)));
+	asm volatile ("vmrun %0" : : "a"(virt_to_phys(vmcb)));
 }
 
 static bool check_vmrun(struct svm_test *test)
 {
-    return vmcb->control.exit_code == SVM_EXIT_VMRUN;
+	return vmcb->control.exit_code == SVM_EXIT_VMRUN;
 }
 
 static void prepare_rsm_intercept(struct svm_test *test)
 {
-    default_prepare(test);
-    vmcb->control.intercept |= 1 << INTERCEPT_RSM;
-    vmcb->control.intercept_exceptions |= (1ULL << UD_VECTOR);
+	default_prepare(test);
+	vmcb->control.intercept |= 1 << INTERCEPT_RSM;
+	vmcb->control.intercept_exceptions |= (1ULL << UD_VECTOR);
 }
 
 static void test_rsm_intercept(struct svm_test *test)
 {
-    asm volatile ("rsm" : : : "memory");
+	asm volatile ("rsm" : : : "memory");
 }
 
 static bool check_rsm_intercept(struct svm_test *test)
 {
-    return get_test_stage(test) == 2;
+	return get_test_stage(test) == 2;
 }
 
 static bool finished_rsm_intercept(struct svm_test *test)
 {
-    switch (get_test_stage(test)) {
-    case 0:
-        if (vmcb->control.exit_code != SVM_EXIT_RSM) {
-            report_fail("VMEXIT not due to rsm. Exit reason 0x%x",
-                        vmcb->control.exit_code);
-            return true;
-        }
-        vmcb->control.intercept &= ~(1 << INTERCEPT_RSM);
-        inc_test_stage(test);
-        break;
+	switch (get_test_stage(test)) {
+	case 0:
+		if (vmcb->control.exit_code != SVM_EXIT_RSM) {
+			report_fail("VMEXIT not due to rsm. Exit reason 0x%x",
+				    vmcb->control.exit_code);
+			return true;
+		}
+		vmcb->control.intercept &= ~(1 << INTERCEPT_RSM);
+		inc_test_stage(test);
+		break;
 
-    case 1:
-        if (vmcb->control.exit_code != SVM_EXIT_EXCP_BASE + UD_VECTOR) {
-            report_fail("VMEXIT not due to #UD. Exit reason 0x%x",
-                        vmcb->control.exit_code);
-            return true;
-        }
-        vmcb->save.rip += 2;
-        inc_test_stage(test);
-        break;
+	case 1:
+		if (vmcb->control.exit_code != SVM_EXIT_EXCP_BASE + UD_VECTOR) {
+			report_fail("VMEXIT not due to #UD. Exit reason 0x%x",
+				    vmcb->control.exit_code);
+			return true;
+		}
+		vmcb->save.rip += 2;
+		inc_test_stage(test);
+		break;
 
-    default:
-        return true;
-    }
-    return get_test_stage(test) == 2;
+	default:
+		return true;
+	}
+	return get_test_stage(test) == 2;
 }
 
 static void prepare_cr3_intercept(struct svm_test *test)
 {
-    default_prepare(test);
-    vmcb->control.intercept_cr_read |= 1 << 3;
+	default_prepare(test);
+	vmcb->control.intercept_cr_read |= 1 << 3;
 }
 
 static void test_cr3_intercept(struct svm_test *test)
 {
-    asm volatile ("mov %%cr3, %0" : "=r"(test->scratch) : : "memory");
+	asm volatile ("mov %%cr3, %0" : "=r"(test->scratch) : : "memory");
 }
 
 static bool check_cr3_intercept(struct svm_test *test)
 {
-    return vmcb->control.exit_code == SVM_EXIT_READ_CR3;
+	return vmcb->control.exit_code == SVM_EXIT_READ_CR3;
 }
 
 static bool check_cr3_nointercept(struct svm_test *test)
 {
-    return null_check(test) && test->scratch == read_cr3();
+	return null_check(test) && test->scratch == read_cr3();
 }
 
 static void corrupt_cr3_intercept_bypass(void *_test)
 {
-    struct svm_test *test = _test;
-    extern volatile u32 mmio_insn;
+	struct svm_test *test = _test;
+	extern volatile u32 mmio_insn;
 
-    while (!__sync_bool_compare_and_swap(&test->scratch, 1, 2))
-        pause();
-    pause();
-    pause();
-    pause();
-    mmio_insn = 0x90d8200f;  // mov %cr3, %rax; nop
+	while (!__sync_bool_compare_and_swap(&test->scratch, 1, 2))
+		pause();
+	pause();
+	pause();
+	pause();
+	mmio_insn = 0x90d8200f;  // mov %cr3, %rax; nop
 }
 
 static void prepare_cr3_intercept_bypass(struct svm_test *test)
 {
-    default_prepare(test);
-    vmcb->control.intercept_cr_read |= 1 << 3;
-    on_cpu_async(1, corrupt_cr3_intercept_bypass, test);
+	default_prepare(test);
+	vmcb->control.intercept_cr_read |= 1 << 3;
+	on_cpu_async(1, corrupt_cr3_intercept_bypass, test);
 }
 
 static void test_cr3_intercept_bypass(struct svm_test *test)
 {
-    ulong a = 0xa0000;
+	ulong a = 0xa0000;
 
-    test->scratch = 1;
-    while (test->scratch != 2)
-        barrier();
+	test->scratch = 1;
+	while (test->scratch != 2)
+		barrier();
 
-    asm volatile ("mmio_insn: mov %0, (%0); nop"
-                  : "+a"(a) : : "memory");
-    test->scratch = a;
+	asm volatile ("mmio_insn: mov %0, (%0); nop"
+		      : "+a"(a) : : "memory");
+	test->scratch = a;
 }
 
 static void prepare_dr_intercept(struct svm_test *test)
 {
-    default_prepare(test);
-    vmcb->control.intercept_dr_read = 0xff;
-    vmcb->control.intercept_dr_write = 0xff;
+	default_prepare(test);
+	vmcb->control.intercept_dr_read = 0xff;
+	vmcb->control.intercept_dr_write = 0xff;
 }
 
 static void test_dr_intercept(struct svm_test *test)
 {
-    unsigned int i, failcnt = 0;
+	unsigned int i, failcnt = 0;
 
-    /* Loop testing debug register reads */
-    for (i = 0; i < 8; i++) {
+	/* Loop testing debug register reads */
+	for (i = 0; i < 8; i++) {
 
-        switch (i) {
-        case 0:
-            asm volatile ("mov %%dr0, %0" : "=r"(test->scratch) : : "memory");
-            break;
-        case 1:
-            asm volatile ("mov %%dr1, %0" : "=r"(test->scratch) : : "memory");
-            break;
-        case 2:
-            asm volatile ("mov %%dr2, %0" : "=r"(test->scratch) : : "memory");
-            break;
-        case 3:
-            asm volatile ("mov %%dr3, %0" : "=r"(test->scratch) : : "memory");
-            break;
-        case 4:
-            asm volatile ("mov %%dr4, %0" : "=r"(test->scratch) : : "memory");
-            break;
-        case 5:
-            asm volatile ("mov %%dr5, %0" : "=r"(test->scratch) : : "memory");
-            break;
-        case 6:
-            asm volatile ("mov %%dr6, %0" : "=r"(test->scratch) : : "memory");
-            break;
-        case 7:
-            asm volatile ("mov %%dr7, %0" : "=r"(test->scratch) : : "memory");
-            break;
-        }
+		switch (i) {
+		case 0:
+			asm volatile ("mov %%dr0, %0" : "=r"(test->scratch) : : "memory");
+			break;
+		case 1:
+			asm volatile ("mov %%dr1, %0" : "=r"(test->scratch) : : "memory");
+			break;
+		case 2:
+			asm volatile ("mov %%dr2, %0" : "=r"(test->scratch) : : "memory");
+			break;
+		case 3:
+			asm volatile ("mov %%dr3, %0" : "=r"(test->scratch) : : "memory");
+			break;
+		case 4:
+			asm volatile ("mov %%dr4, %0" : "=r"(test->scratch) : : "memory");
+			break;
+		case 5:
+			asm volatile ("mov %%dr5, %0" : "=r"(test->scratch) : : "memory");
+			break;
+		case 6:
+			asm volatile ("mov %%dr6, %0" : "=r"(test->scratch) : : "memory");
+			break;
+		case 7:
+			asm volatile ("mov %%dr7, %0" : "=r"(test->scratch) : : "memory");
+			break;
+		}
 
-        if (test->scratch != i) {
-            report_fail("dr%u read intercept", i);
-            failcnt++;
-        }
-    }
+		if (test->scratch != i) {
+			report_fail("dr%u read intercept", i);
+			failcnt++;
+		}
+	}
 
-    /* Loop testing debug register writes */
-    for (i = 0; i < 8; i++) {
+	/* Loop testing debug register writes */
+	for (i = 0; i < 8; i++) {
 
-        switch (i) {
-        case 0:
-            asm volatile ("mov %0, %%dr0" : : "r"(test->scratch) : "memory");
-            break;
-        case 1:
-            asm volatile ("mov %0, %%dr1" : : "r"(test->scratch) : "memory");
-            break;
-        case 2:
-            asm volatile ("mov %0, %%dr2" : : "r"(test->scratch) : "memory");
-            break;
-        case 3:
-            asm volatile ("mov %0, %%dr3" : : "r"(test->scratch) : "memory");
-            break;
-        case 4:
-            asm volatile ("mov %0, %%dr4" : : "r"(test->scratch) : "memory");
-            break;
-        case 5:
-            asm volatile ("mov %0, %%dr5" : : "r"(test->scratch) : "memory");
-            break;
-        case 6:
-            asm volatile ("mov %0, %%dr6" : : "r"(test->scratch) : "memory");
-            break;
-        case 7:
-            asm volatile ("mov %0, %%dr7" : : "r"(test->scratch) : "memory");
-            break;
-        }
+		switch (i) {
+		case 0:
+			asm volatile ("mov %0, %%dr0" : : "r"(test->scratch) : "memory");
+			break;
+		case 1:
+			asm volatile ("mov %0, %%dr1" : : "r"(test->scratch) : "memory");
+			break;
+		case 2:
+			asm volatile ("mov %0, %%dr2" : : "r"(test->scratch) : "memory");
+			break;
+		case 3:
+			asm volatile ("mov %0, %%dr3" : : "r"(test->scratch) : "memory");
+			break;
+		case 4:
+			asm volatile ("mov %0, %%dr4" : : "r"(test->scratch) : "memory");
+			break;
+		case 5:
+			asm volatile ("mov %0, %%dr5" : : "r"(test->scratch) : "memory");
+			break;
+		case 6:
+			asm volatile ("mov %0, %%dr6" : : "r"(test->scratch) : "memory");
+			break;
+		case 7:
+			asm volatile ("mov %0, %%dr7" : : "r"(test->scratch) : "memory");
+			break;
+		}
 
-        if (test->scratch != i) {
-            report_fail("dr%u write intercept", i);
-            failcnt++;
-        }
-    }
+		if (test->scratch != i) {
+			report_fail("dr%u write intercept", i);
+			failcnt++;
+		}
+	}
 
-    test->scratch = failcnt;
+	test->scratch = failcnt;
 }
 
 static bool dr_intercept_finished(struct svm_test *test)
 {
-    ulong n = (vmcb->control.exit_code - SVM_EXIT_READ_DR0);
+	ulong n = (vmcb->control.exit_code - SVM_EXIT_READ_DR0);
 
-    /* Only expect DR intercepts */
-    if (n > (SVM_EXIT_MAX_DR_INTERCEPT - SVM_EXIT_READ_DR0))
-        return true;
+	/* Only expect DR intercepts */
+	if (n > (SVM_EXIT_MAX_DR_INTERCEPT - SVM_EXIT_READ_DR0))
+		return true;
 
-    /*
-     * Compute debug register number.
-     * Per Appendix C "SVM Intercept Exit Codes" of AMD64 Architecture
-     * Programmer's Manual Volume 2 - System Programming:
-     * http://support.amd.com/TechDocs/24593.pdf
-     * there are 16 VMEXIT codes each for DR read and write.
-     */
-    test->scratch = (n % 16);
+	/*
+	 * Compute debug register number.
+	 * Per Appendix C "SVM Intercept Exit Codes" of AMD64 Architecture
+	 * Programmer's Manual Volume 2 - System Programming:
+	 * http://support.amd.com/TechDocs/24593.pdf
+	 * there are 16 VMEXIT codes each for DR read and write.
+	 */
+	test->scratch = (n % 16);
 
-    /* Jump over MOV instruction */
-    vmcb->save.rip += 3;
+	/* Jump over MOV instruction */
+	vmcb->save.rip += 3;
 
-    return false;
+	return false;
 }
 
 static bool check_dr_intercept(struct svm_test *test)
 {
-    return !test->scratch;
+	return !test->scratch;
 }
 
 static bool next_rip_supported(void)
 {
-    return this_cpu_has(X86_FEATURE_NRIPS);
+	return this_cpu_has(X86_FEATURE_NRIPS);
 }
 
 static void prepare_next_rip(struct svm_test *test)
 {
-    vmcb->control.intercept |= (1ULL << INTERCEPT_RDTSC);
+	vmcb->control.intercept |= (1ULL << INTERCEPT_RDTSC);
 }
 
 
 static void test_next_rip(struct svm_test *test)
 {
-    asm volatile ("rdtsc\n\t"
-                  ".globl exp_next_rip\n\t"
-                  "exp_next_rip:\n\t" ::: "eax", "edx");
+	asm volatile ("rdtsc\n\t"
+		      ".globl exp_next_rip\n\t"
+		      "exp_next_rip:\n\t" ::: "eax", "edx");
 }
 
 static bool check_next_rip(struct svm_test *test)
 {
-    extern char exp_next_rip;
-    unsigned long address = (unsigned long)&exp_next_rip;
+	extern char exp_next_rip;
+	unsigned long address = (unsigned long)&exp_next_rip;
 
-    return address == vmcb->control.next_rip;
+	return address == vmcb->control.next_rip;
 }
 
 extern u8 *msr_bitmap;
 
 static void prepare_msr_intercept(struct svm_test *test)
 {
-    default_prepare(test);
-    vmcb->control.intercept |= (1ULL << INTERCEPT_MSR_PROT);
-    vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR);
-    memset(msr_bitmap, 0xff, MSR_BITMAP_SIZE);
+	default_prepare(test);
+	vmcb->control.intercept |= (1ULL << INTERCEPT_MSR_PROT);
+	vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR);
+	memset(msr_bitmap, 0xff, MSR_BITMAP_SIZE);
 }
 
 static void test_msr_intercept(struct svm_test *test)
 {
-    unsigned long msr_value = 0xef8056791234abcd; /* Arbitrary value */
-    unsigned long msr_index;
-
-    for (msr_index = 0; msr_index <= 0xc0011fff; msr_index++) {
-        if (msr_index == 0xC0010131 /* MSR_SEV_STATUS */) {
-            /*
-             * Per section 15.34.10 "SEV_STATUS MSR" of AMD64 Architecture
-             * Programmer's Manual volume 2 - System Programming:
-             * http://support.amd.com/TechDocs/24593.pdf
-             * SEV_STATUS MSR (C001_0131) is a non-interceptable MSR.
-             */
-            continue;
-        }
+	unsigned long msr_value = 0xef8056791234abcd; /* Arbitrary value */
+	unsigned long msr_index;
+
+	for (msr_index = 0; msr_index <= 0xc0011fff; msr_index++) {
+		if (msr_index == 0xC0010131 /* MSR_SEV_STATUS */) {
+			/*
+			 * Per section 15.34.10 "SEV_STATUS MSR" of AMD64 Architecture
+			 * Programmer's Manual volume 2 - System Programming:
+			 * http://support.amd.com/TechDocs/24593.pdf
+			 * SEV_STATUS MSR (C001_0131) is a non-interceptable MSR.
+			 */
+			continue;
+		}
 
-        /* Skips gaps between supported MSR ranges */
-        if (msr_index == 0x2000)
-            msr_index = 0xc0000000;
-        else if (msr_index == 0xc0002000)
-            msr_index = 0xc0010000;
+		/* Skips gaps between supported MSR ranges */
+		if (msr_index == 0x2000)
+			msr_index = 0xc0000000;
+		else if (msr_index == 0xc0002000)
+			msr_index = 0xc0010000;
 
-        test->scratch = -1;
+		test->scratch = -1;
 
-        rdmsr(msr_index);
+		rdmsr(msr_index);
 
-        /* Check that a read intercept occurred for MSR at msr_index */
-        if (test->scratch != msr_index)
-            report_fail("MSR 0x%lx read intercept", msr_index);
+		/* Check that a read intercept occurred for MSR at msr_index */
+		if (test->scratch != msr_index)
+			report_fail("MSR 0x%lx read intercept", msr_index);
 
-        /*
-         * Poor man approach to generate a value that
-         * seems arbitrary each time around the loop.
-         */
-        msr_value += (msr_value << 1);
+		/*
+		 * Poor man approach to generate a value that
+		 * seems arbitrary each time around the loop.
+		 */
+		msr_value += (msr_value << 1);
 
-        wrmsr(msr_index, msr_value);
+		wrmsr(msr_index, msr_value);
 
-        /* Check that a write intercept occurred for MSR with msr_value */
-        if (test->scratch != msr_value)
-            report_fail("MSR 0x%lx write intercept", msr_index);
-    }
+		/* Check that a write intercept occurred for MSR with msr_value */
+		if (test->scratch != msr_value)
+			report_fail("MSR 0x%lx write intercept", msr_index);
+	}
 
-    test->scratch = -2;
+	test->scratch = -2;
 }
 
 static bool msr_intercept_finished(struct svm_test *test)
 {
-    u32 exit_code = vmcb->control.exit_code;
-    u64 exit_info_1;
-    u8 *opcode;
+	u32 exit_code = vmcb->control.exit_code;
+	u64 exit_info_1;
+	u8 *opcode;
 
-    if (exit_code == SVM_EXIT_MSR) {
-        exit_info_1 = vmcb->control.exit_info_1;
-    } else {
-        /*
-         * If #GP exception occurs instead, check that it was
-         * for RDMSR/WRMSR and set exit_info_1 accordingly.
-         */
+	if (exit_code == SVM_EXIT_MSR) {
+		exit_info_1 = vmcb->control.exit_info_1;
+	} else {
+		/*
+		 * If #GP exception occurs instead, check that it was
+		 * for RDMSR/WRMSR and set exit_info_1 accordingly.
+		 */
 
-        if (exit_code != (SVM_EXIT_EXCP_BASE + GP_VECTOR))
-            return true;
+		if (exit_code != (SVM_EXIT_EXCP_BASE + GP_VECTOR))
+			return true;
 
-        opcode = (u8 *)vmcb->save.rip;
-        if (opcode[0] != 0x0f)
-            return true;
+		opcode = (u8 *)vmcb->save.rip;
+		if (opcode[0] != 0x0f)
+			return true;
 
-        switch (opcode[1]) {
-        case 0x30: /* WRMSR */
-            exit_info_1 = 1;
-            break;
-        case 0x32: /* RDMSR */
-            exit_info_1 = 0;
-            break;
-        default:
-            return true;
-        }
+		switch (opcode[1]) {
+		case 0x30: /* WRMSR */
+			exit_info_1 = 1;
+			break;
+		case 0x32: /* RDMSR */
+			exit_info_1 = 0;
+			break;
+		default:
+			return true;
+		}
 
-        /*
-         * Warn that #GP exception occurred instead.
-         * RCX holds the MSR index.
-         */
-        printf("%s 0x%lx #GP exception\n",
-            exit_info_1 ? "WRMSR" : "RDMSR", get_regs().rcx);
-    }
+		/*
+		 * Warn that #GP exception occured instead.
+		 * RCX holds the MSR index.
+		 */
+		printf("%s 0x%lx #GP exception\n",
+		       exit_info_1 ? "WRMSR" : "RDMSR", get_regs().rcx);
+	}
 
-    /* Jump over RDMSR/WRMSR instruction */
-    vmcb->save.rip += 2;
-
-    /*
-     * Test whether the intercept was for RDMSR/WRMSR.
-     * For RDMSR, test->scratch is set to the MSR index;
-     *      RCX holds the MSR index.
-     * For WRMSR, test->scratch is set to the MSR value;
-     *      RDX holds the upper 32 bits of the MSR value,
-     *      while RAX hold its lower 32 bits.
-     */
-    if (exit_info_1)
-        test->scratch =
-            ((get_regs().rdx << 32) | (vmcb->save.rax & 0xffffffff));
-    else
-        test->scratch = get_regs().rcx;
+	/* Jump over RDMSR/WRMSR instruction */
+	vmcb->save.rip += 2;
+
+	/*
+	 * Test whether the intercept was for RDMSR/WRMSR.
+	 * For RDMSR, test->scratch is set to the MSR index;
+	 *      RCX holds the MSR index.
+	 * For WRMSR, test->scratch is set to the MSR value;
+	 *      RDX holds the upper 32 bits of the MSR value,
+	 *      while RAX hold its lower 32 bits.
+	 */
+	if (exit_info_1)
+		test->scratch =
+			((get_regs().rdx << 32) | (vmcb->save.rax & 0xffffffff));
+	else
+		test->scratch = get_regs().rcx;
 
-    return false;
+	return false;
 }
 
 static bool check_msr_intercept(struct svm_test *test)
 {
-    memset(msr_bitmap, 0, MSR_BITMAP_SIZE);
-    return (test->scratch == -2);
+	memset(msr_bitmap, 0, MSR_BITMAP_SIZE);
+	return (test->scratch == -2);
 }
 
 static void prepare_mode_switch(struct svm_test *test)
 {
-    vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR)
-                                             |  (1ULL << UD_VECTOR)
-                                             |  (1ULL << DF_VECTOR)
-                                             |  (1ULL << PF_VECTOR);
-    test->scratch = 0;
+	vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR)
+		|  (1ULL << UD_VECTOR)
+		|  (1ULL << DF_VECTOR)
+		|  (1ULL << PF_VECTOR);
+	test->scratch = 0;
 }
 
 static void test_mode_switch(struct svm_test *test)
 {
-    asm volatile("	cli\n"
-		 "	ljmp *1f\n" /* jump to 32-bit code segment */
-		 "1:\n"
-		 "	.long 2f\n"
-		 "	.long " xstr(KERNEL_CS32) "\n"
-		 ".code32\n"
-		 "2:\n"
-		 "	movl %%cr0, %%eax\n"
-		 "	btcl  $31, %%eax\n" /* clear PG */
-		 "	movl %%eax, %%cr0\n"
-		 "	movl $0xc0000080, %%ecx\n" /* EFER */
-		 "	rdmsr\n"
-		 "	btcl $8, %%eax\n" /* clear LME */
-		 "	wrmsr\n"
-		 "	movl %%cr4, %%eax\n"
-		 "	btcl $5, %%eax\n" /* clear PAE */
-		 "	movl %%eax, %%cr4\n"
-		 "	movw %[ds16], %%ax\n"
-		 "	movw %%ax, %%ds\n"
-		 "	ljmpl %[cs16], $3f\n" /* jump to 16 bit protected-mode */
-		 ".code16\n"
-		 "3:\n"
-		 "	movl %%cr0, %%eax\n"
-		 "	btcl $0, %%eax\n" /* clear PE  */
-		 "	movl %%eax, %%cr0\n"
-		 "	ljmpl $0, $4f\n"   /* jump to real-mode */
-		 "4:\n"
-		 "	vmmcall\n"
-		 "	movl %%cr0, %%eax\n"
-		 "	btsl $0, %%eax\n" /* set PE  */
-		 "	movl %%eax, %%cr0\n"
-		 "	ljmpl %[cs32], $5f\n" /* back to protected mode */
-		 ".code32\n"
-		 "5:\n"
-		 "	movl %%cr4, %%eax\n"
-		 "	btsl $5, %%eax\n" /* set PAE */
-		 "	movl %%eax, %%cr4\n"
-		 "	movl $0xc0000080, %%ecx\n" /* EFER */
-		 "	rdmsr\n"
-		 "	btsl $8, %%eax\n" /* set LME */
-		 "	wrmsr\n"
-		 "	movl %%cr0, %%eax\n"
-		 "	btsl  $31, %%eax\n" /* set PG */
-		 "	movl %%eax, %%cr0\n"
-		 "	ljmpl %[cs64], $6f\n"    /* back to long mode */
-		 ".code64\n\t"
-		 "6:\n"
-		 "	vmmcall\n"
-		 :: [cs16] "i"(KERNEL_CS16), [ds16] "i"(KERNEL_DS16),
-		    [cs32] "i"(KERNEL_CS32), [cs64] "i"(KERNEL_CS64)
-		 : "rax", "rbx", "rcx", "rdx", "memory");
+	asm volatile("	cli\n"
+		     "	ljmp *1f\n" /* jump to 32-bit code segment */
+		     "1:\n"
+		     "	.long 2f\n"
+		     "	.long " xstr(KERNEL_CS32) "\n"
+		     ".code32\n"
+		     "2:\n"
+		     "	movl %%cr0, %%eax\n"
+		     "	btcl  $31, %%eax\n" /* clear PG */
+		     "	movl %%eax, %%cr0\n"
+		     "	movl $0xc0000080, %%ecx\n" /* EFER */
+		     "	rdmsr\n"
+		     "	btcl $8, %%eax\n" /* clear LME */
+		     "	wrmsr\n"
+		     "	movl %%cr4, %%eax\n"
+		     "	btcl $5, %%eax\n" /* clear PAE */
+		     "	movl %%eax, %%cr4\n"
+		     "	movw %[ds16], %%ax\n"
+		     "	movw %%ax, %%ds\n"
+		     "	ljmpl %[cs16], $3f\n" /* jump to 16 bit protected-mode */
+		     ".code16\n"
+		     "3:\n"
+		     "	movl %%cr0, %%eax\n"
+		     "	btcl $0, %%eax\n" /* clear PE  */
+		     "	movl %%eax, %%cr0\n"
+		     "	ljmpl $0, $4f\n"   /* jump to real-mode */
+		     "4:\n"
+		     "	vmmcall\n"
+		     "	movl %%cr0, %%eax\n"
+		     "	btsl $0, %%eax\n" /* set PE  */
+		     "	movl %%eax, %%cr0\n"
+		     "	ljmpl %[cs32], $5f\n" /* back to protected mode */
+		     ".code32\n"
+		     "5:\n"
+		     "	movl %%cr4, %%eax\n"
+		     "	btsl $5, %%eax\n" /* set PAE */
+		     "	movl %%eax, %%cr4\n"
+		     "	movl $0xc0000080, %%ecx\n" /* EFER */
+		     "	rdmsr\n"
+		     "	btsl $8, %%eax\n" /* set LME */
+		     "	wrmsr\n"
+		     "	movl %%cr0, %%eax\n"
+		     "	btsl  $31, %%eax\n" /* set PG */
+		     "	movl %%eax, %%cr0\n"
+		     "	ljmpl %[cs64], $6f\n"    /* back to long mode */
+		     ".code64\n\t"
+		     "6:\n"
+		     "	vmmcall\n"
+		     :: [cs16] "i"(KERNEL_CS16), [ds16] "i"(KERNEL_DS16),
+		      [cs32] "i"(KERNEL_CS32), [cs64] "i"(KERNEL_CS64)
+		     : "rax", "rbx", "rcx", "rdx", "memory");
 }
 
 static bool mode_switch_finished(struct svm_test *test)
 {
-    u64 cr0, cr4, efer;
+	u64 cr0, cr4, efer;
 
-    cr0  = vmcb->save.cr0;
-    cr4  = vmcb->save.cr4;
-    efer = vmcb->save.efer;
+	cr0  = vmcb->save.cr0;
+	cr4  = vmcb->save.cr4;
+	efer = vmcb->save.efer;
 
-    /* Only expect VMMCALL intercepts */
-    if (vmcb->control.exit_code != SVM_EXIT_VMMCALL)
-	    return true;
+	/* Only expect VMMCALL intercepts */
+	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL)
+		return true;
 
-    /* Jump over VMMCALL instruction */
-    vmcb->save.rip += 3;
+	/* Jump over VMMCALL instruction */
+	vmcb->save.rip += 3;
 
-    /* Do sanity checks */
-    switch (test->scratch) {
-    case 0:
-        /* Test should be in real mode now - check for this */
-        if ((cr0  & 0x80000001) || /* CR0.PG, CR0.PE */
-            (cr4  & 0x00000020) || /* CR4.PAE */
-            (efer & 0x00000500))   /* EFER.LMA, EFER.LME */
-                return true;
-        break;
-    case 2:
-        /* Test should be back in long-mode now - check for this */
-        if (((cr0  & 0x80000001) != 0x80000001) || /* CR0.PG, CR0.PE */
-            ((cr4  & 0x00000020) != 0x00000020) || /* CR4.PAE */
-            ((efer & 0x00000500) != 0x00000500))   /* EFER.LMA, EFER.LME */
-		    return true;
-	break;
-    }
+	/* Do sanity checks */
+	switch (test->scratch) {
+	case 0:
+		/* Test should be in real mode now - check for this */
+		if ((cr0  & 0x80000001) || /* CR0.PG, CR0.PE */
+		    (cr4  & 0x00000020) || /* CR4.PAE */
+		    (efer & 0x00000500))   /* EFER.LMA, EFER.LME */
+			return true;
+		break;
+	case 2:
+		/* Test should be back in long-mode now - check for this */
+		if (((cr0  & 0x80000001) != 0x80000001) || /* CR0.PG, CR0.PE */
+		    ((cr4  & 0x00000020) != 0x00000020) || /* CR4.PAE */
+		    ((efer & 0x00000500) != 0x00000500))   /* EFER.LMA, EFER.LME */
+			return true;
+		break;
+	}
 
-    /* one step forward */
-    test->scratch += 1;
+	/* one step forward */
+	test->scratch += 1;
 
-    return test->scratch == 2;
+	return test->scratch == 2;
 }
 
 static bool check_mode_switch(struct svm_test *test)
@@ -540,132 +540,132 @@ extern u8 *io_bitmap;
 
 static void prepare_ioio(struct svm_test *test)
 {
-    vmcb->control.intercept |= (1ULL << INTERCEPT_IOIO_PROT);
-    test->scratch = 0;
-    memset(io_bitmap, 0, 8192);
-    io_bitmap[8192] = 0xFF;
+	vmcb->control.intercept |= (1ULL << INTERCEPT_IOIO_PROT);
+	test->scratch = 0;
+	memset(io_bitmap, 0, 8192);
+	io_bitmap[8192] = 0xFF;
 }
 
 static void test_ioio(struct svm_test *test)
 {
-    // stage 0, test IO pass
-    inb(0x5000);
-    outb(0x0, 0x5000);
-    if (get_test_stage(test) != 0)
-        goto fail;
-
-    // test IO width, in/out
-    io_bitmap[0] = 0xFF;
-    inc_test_stage(test);
-    inb(0x0);
-    if (get_test_stage(test) != 2)
-        goto fail;
-
-    outw(0x0, 0x0);
-    if (get_test_stage(test) != 3)
-        goto fail;
-
-    inl(0x0);
-    if (get_test_stage(test) != 4)
-        goto fail;
-
-    // test low/high IO port
-    io_bitmap[0x5000 / 8] = (1 << (0x5000 % 8));
-    inb(0x5000);
-    if (get_test_stage(test) != 5)
-        goto fail;
-
-    io_bitmap[0x9000 / 8] = (1 << (0x9000 % 8));
-    inw(0x9000);
-    if (get_test_stage(test) != 6)
-        goto fail;
-
-    // test partial pass
-    io_bitmap[0x5000 / 8] = (1 << (0x5000 % 8));
-    inl(0x4FFF);
-    if (get_test_stage(test) != 7)
-        goto fail;
-
-    // test across pages
-    inc_test_stage(test);
-    inl(0x7FFF);
-    if (get_test_stage(test) != 8)
-        goto fail;
-
-    inc_test_stage(test);
-    io_bitmap[0x8000 / 8] = 1 << (0x8000 % 8);
-    inl(0x7FFF);
-    if (get_test_stage(test) != 10)
-        goto fail;
-
-    io_bitmap[0] = 0;
-    inl(0xFFFF);
-    if (get_test_stage(test) != 11)
-        goto fail;
-
-    io_bitmap[0] = 0xFF;
-    io_bitmap[8192] = 0;
-    inl(0xFFFF);
-    inc_test_stage(test);
-    if (get_test_stage(test) != 12)
-        goto fail;
+	// stage 0, test IO pass
+	inb(0x5000);
+	outb(0x0, 0x5000);
+	if (get_test_stage(test) != 0)
+		goto fail;
 
-    return;
+	// test IO width, in/out
+	io_bitmap[0] = 0xFF;
+	inc_test_stage(test);
+	inb(0x0);
+	if (get_test_stage(test) != 2)
+		goto fail;
+
+	outw(0x0, 0x0);
+	if (get_test_stage(test) != 3)
+		goto fail;
+
+	inl(0x0);
+	if (get_test_stage(test) != 4)
+		goto fail;
+
+	// test low/high IO port
+	io_bitmap[0x5000 / 8] = (1 << (0x5000 % 8));
+	inb(0x5000);
+	if (get_test_stage(test) != 5)
+		goto fail;
+
+	io_bitmap[0x9000 / 8] = (1 << (0x9000 % 8));
+	inw(0x9000);
+	if (get_test_stage(test) != 6)
+		goto fail;
+
+	// test partial pass
+	io_bitmap[0x5000 / 8] = (1 << (0x5000 % 8));
+	inl(0x4FFF);
+	if (get_test_stage(test) != 7)
+		goto fail;
+
+	// test across pages
+	inc_test_stage(test);
+	inl(0x7FFF);
+	if (get_test_stage(test) != 8)
+		goto fail;
+
+	inc_test_stage(test);
+	io_bitmap[0x8000 / 8] = 1 << (0x8000 % 8);
+	inl(0x7FFF);
+	if (get_test_stage(test) != 10)
+		goto fail;
+
+	io_bitmap[0] = 0;
+	inl(0xFFFF);
+	if (get_test_stage(test) != 11)
+		goto fail;
+
+	io_bitmap[0] = 0xFF;
+	io_bitmap[8192] = 0;
+	inl(0xFFFF);
+	inc_test_stage(test);
+	if (get_test_stage(test) != 12)
+		goto fail;
+
+	return;
 
 fail:
-    report_fail("stage %d", get_test_stage(test));
-    test->scratch = -1;
+	report_fail("stage %d", get_test_stage(test));
+	test->scratch = -1;
 }
 
 static bool ioio_finished(struct svm_test *test)
 {
-    unsigned port, size;
+	unsigned port, size;
 
-    /* Only expect IOIO intercepts */
-    if (vmcb->control.exit_code == SVM_EXIT_VMMCALL)
-        return true;
+	/* Only expect IOIO intercepts */
+	if (vmcb->control.exit_code == SVM_EXIT_VMMCALL)
+		return true;
 
-    if (vmcb->control.exit_code != SVM_EXIT_IOIO)
-        return true;
+	if (vmcb->control.exit_code != SVM_EXIT_IOIO)
+		return true;
 
-    /* one step forward */
-    test->scratch += 1;
+	/* one step forward */
+	test->scratch += 1;
 
-    port = vmcb->control.exit_info_1 >> 16;
-    size = (vmcb->control.exit_info_1 >> SVM_IOIO_SIZE_SHIFT) & 7;
+	port = vmcb->control.exit_info_1 >> 16;
+	size = (vmcb->control.exit_info_1 >> SVM_IOIO_SIZE_SHIFT) & 7;
 
-    while (size--) {
-        io_bitmap[port / 8] &= ~(1 << (port & 7));
-        port++;
-    }
+	while (size--) {
+		io_bitmap[port / 8] &= ~(1 << (port & 7));
+		port++;
+	}
 
-    return false;
+	return false;
 }
 
 static bool check_ioio(struct svm_test *test)
 {
-    memset(io_bitmap, 0, 8193);
-    return test->scratch != -1;
+	memset(io_bitmap, 0, 8193);
+	return test->scratch != -1;
 }
 
 static void prepare_asid_zero(struct svm_test *test)
 {
-    vmcb->control.asid = 0;
+	vmcb->control.asid = 0;
 }
 
 static void test_asid_zero(struct svm_test *test)
 {
-    asm volatile ("vmmcall\n\t");
+	asm volatile ("vmmcall\n\t");
 }
 
 static bool check_asid_zero(struct svm_test *test)
 {
-    return vmcb->control.exit_code == SVM_EXIT_ERR;
+	return vmcb->control.exit_code == SVM_EXIT_ERR;
 }
 
 static void sel_cr0_bug_prepare(struct svm_test *test)
 {
-    vmcb->control.intercept |= (1ULL << INTERCEPT_SELECTIVE_CR0);
+	vmcb->control.intercept |= (1ULL << INTERCEPT_SELECTIVE_CR0);
 }
 
 static bool sel_cr0_bug_finished(struct svm_test *test)
@@ -675,25 +675,25 @@ static bool sel_cr0_bug_finished(struct svm_test *test)
 
 static void sel_cr0_bug_test(struct svm_test *test)
 {
-    unsigned long cr0;
+	unsigned long cr0;
 
-    /* read cr0, clear CD, and write back */
-    cr0  = read_cr0();
-    cr0 |= (1UL << 30);
-    write_cr0(cr0);
+	/* read cr0, clear CD, and write back */
+	cr0  = read_cr0();
+	cr0 |= (1UL << 30);
+	write_cr0(cr0);
 
-    /*
-     * If we are here the test failed, not sure what to do now because we
-     * are not in guest-mode anymore so we can't trigger an intercept.
-     * Trigger a tripple-fault for now.
-     */
-    report_fail("sel_cr0 test. Can not recover from this - exiting");
-    exit(report_summary());
+	/*
+	 * If we are here the test failed, not sure what to do now because we
+	 * are not in guest-mode anymore so we can't trigger an intercept.
+	 * Trigger a tripple-fault for now.
+	 */
+	report_fail("sel_cr0 test. Can not recover from this - exiting");
+	exit(report_summary());
 }
 
 static bool sel_cr0_bug_check(struct svm_test *test)
 {
-    return vmcb->control.exit_code == SVM_EXIT_CR0_SEL_WRITE;
+	return vmcb->control.exit_code == SVM_EXIT_CR0_SEL_WRITE;
 }
 
 #define TSC_ADJUST_VALUE    (1ll << 32)
@@ -702,43 +702,43 @@ static bool ok;
 
 static bool tsc_adjust_supported(void)
 {
-    return this_cpu_has(X86_FEATURE_TSC_ADJUST);
+	return this_cpu_has(X86_FEATURE_TSC_ADJUST);
 }
 
 static void tsc_adjust_prepare(struct svm_test *test)
 {
-    default_prepare(test);
-    vmcb->control.tsc_offset = TSC_OFFSET_VALUE;
+	default_prepare(test);
+	vmcb->control.tsc_offset = TSC_OFFSET_VALUE;
 
-    wrmsr(MSR_IA32_TSC_ADJUST, -TSC_ADJUST_VALUE);
-    int64_t adjust = rdmsr(MSR_IA32_TSC_ADJUST);
-    ok = adjust == -TSC_ADJUST_VALUE;
+	wrmsr(MSR_IA32_TSC_ADJUST, -TSC_ADJUST_VALUE);
+	int64_t adjust = rdmsr(MSR_IA32_TSC_ADJUST);
+	ok = adjust == -TSC_ADJUST_VALUE;
 }
 
 static void tsc_adjust_test(struct svm_test *test)
 {
-    int64_t adjust = rdmsr(MSR_IA32_TSC_ADJUST);
-    ok &= adjust == -TSC_ADJUST_VALUE;
+	int64_t adjust = rdmsr(MSR_IA32_TSC_ADJUST);
+	ok &= adjust == -TSC_ADJUST_VALUE;
 
-    uint64_t l1_tsc = rdtsc() - TSC_OFFSET_VALUE;
-    wrmsr(MSR_IA32_TSC, l1_tsc - TSC_ADJUST_VALUE);
+	uint64_t l1_tsc = rdtsc() - TSC_OFFSET_VALUE;
+	wrmsr(MSR_IA32_TSC, l1_tsc - TSC_ADJUST_VALUE);
 
-    adjust = rdmsr(MSR_IA32_TSC_ADJUST);
-    ok &= adjust <= -2 * TSC_ADJUST_VALUE;
+	adjust = rdmsr(MSR_IA32_TSC_ADJUST);
+	ok &= adjust <= -2 * TSC_ADJUST_VALUE;
 
-    uint64_t l1_tsc_end = rdtsc() - TSC_OFFSET_VALUE;
-    ok &= (l1_tsc_end + TSC_ADJUST_VALUE - l1_tsc) < TSC_ADJUST_VALUE;
+	uint64_t l1_tsc_end = rdtsc() - TSC_OFFSET_VALUE;
+	ok &= (l1_tsc_end + TSC_ADJUST_VALUE - l1_tsc) < TSC_ADJUST_VALUE;
 
-    uint64_t l1_tsc_msr = rdmsr(MSR_IA32_TSC) - TSC_OFFSET_VALUE;
-    ok &= (l1_tsc_msr + TSC_ADJUST_VALUE - l1_tsc) < TSC_ADJUST_VALUE;
+	uint64_t l1_tsc_msr = rdmsr(MSR_IA32_TSC) - TSC_OFFSET_VALUE;
+	ok &= (l1_tsc_msr + TSC_ADJUST_VALUE - l1_tsc) < TSC_ADJUST_VALUE;
 }
 
 static bool tsc_adjust_check(struct svm_test *test)
 {
-    int64_t adjust = rdmsr(MSR_IA32_TSC_ADJUST);
+	int64_t adjust = rdmsr(MSR_IA32_TSC_ADJUST);
 
-    wrmsr(MSR_IA32_TSC_ADJUST, 0);
-    return ok && adjust <= -2 * TSC_ADJUST_VALUE;
+	wrmsr(MSR_IA32_TSC_ADJUST, 0);
+	return ok && adjust <= -2 * TSC_ADJUST_VALUE;
 }
 
 
@@ -749,203 +749,203 @@ static u64 guest_tsc_delay_value;
 
 static void svm_tsc_scale_guest(struct svm_test *test)
 {
-    u64 start_tsc = rdtsc();
+	u64 start_tsc = rdtsc();
 
-    while (rdtsc() - start_tsc < guest_tsc_delay_value)
-        cpu_relax();
+	while (rdtsc() - start_tsc < guest_tsc_delay_value)
+		cpu_relax();
 }
 
 static void svm_tsc_scale_run_testcase(u64 duration,
-        double tsc_scale, u64 tsc_offset)
+				       double tsc_scale, u64 tsc_offset)
 {
-    u64 start_tsc, actual_duration;
+	u64 start_tsc, actual_duration;
 
-    guest_tsc_delay_value = (duration << TSC_SHIFT) * tsc_scale;
+	guest_tsc_delay_value = (duration << TSC_SHIFT) * tsc_scale;
 
-    test_set_guest(svm_tsc_scale_guest);
-    vmcb->control.tsc_offset = tsc_offset;
-    wrmsr(MSR_AMD64_TSC_RATIO, (u64)(tsc_scale * (1ULL << 32)));
+	test_set_guest(svm_tsc_scale_guest);
+	vmcb->control.tsc_offset = tsc_offset;
+	wrmsr(MSR_AMD64_TSC_RATIO, (u64)(tsc_scale * (1ULL << 32)));
 
-    start_tsc = rdtsc();
+	start_tsc = rdtsc();
 
-    if (svm_vmrun() != SVM_EXIT_VMMCALL)
-        report_fail("unexpected vm exit code 0x%x", vmcb->control.exit_code);
+	if (svm_vmrun() != SVM_EXIT_VMMCALL)
+		report_fail("unexpected vm exit code 0x%x", vmcb->control.exit_code);
 
-    actual_duration = (rdtsc() - start_tsc) >> TSC_SHIFT;
+	actual_duration = (rdtsc() - start_tsc) >> TSC_SHIFT;
 
-    report(duration == actual_duration, "tsc delay (expected: %lu, actual: %lu)",
-            duration, actual_duration);
+	report(duration == actual_duration, "tsc delay (expected: %lu, actual: %lu)",
+	       duration, actual_duration);
 }
 
 static void svm_tsc_scale_test(void)
 {
-    int i;
+	int i;
 
-    if (!tsc_scale_supported()) {
-        report_skip("TSC scale not supported in the guest");
-        return;
-    }
+	if (!tsc_scale_supported()) {
+		report_skip("TSC scale not supported in the guest");
+		return;
+	}
 
-    report(rdmsr(MSR_AMD64_TSC_RATIO) == TSC_RATIO_DEFAULT,
-           "initial TSC scale ratio");
+	report(rdmsr(MSR_AMD64_TSC_RATIO) == TSC_RATIO_DEFAULT,
+	       "initial TSC scale ratio");
 
-    for (i = 0 ; i < TSC_SCALE_ITERATIONS; i++) {
+	for (i = 0 ; i < TSC_SCALE_ITERATIONS; i++) {
 
-        double tsc_scale = (double)(rdrand() % 100 + 1) / 10;
-        int duration = rdrand() % 50 + 1;
-        u64 tsc_offset = rdrand();
+		double tsc_scale = (double)(rdrand() % 100 + 1) / 10;
+		int duration = rdrand() % 50 + 1;
+		u64 tsc_offset = rdrand();
 
-        report_info("duration=%d, tsc_scale=%d, tsc_offset=%ld",
-                    duration, (int)(tsc_scale * 100), tsc_offset);
+		report_info("duration=%d, tsc_scale=%d, tsc_offset=%ld",
+			    duration, (int)(tsc_scale * 100), tsc_offset);
 
-        svm_tsc_scale_run_testcase(duration, tsc_scale, tsc_offset);
-    }
+		svm_tsc_scale_run_testcase(duration, tsc_scale, tsc_offset);
+	}
 
-    svm_tsc_scale_run_testcase(50, 255, rdrand());
-    svm_tsc_scale_run_testcase(50, 0.0001, rdrand());
+	svm_tsc_scale_run_testcase(50, 255, rdrand());
+	svm_tsc_scale_run_testcase(50, 0.0001, rdrand());
 }
 
 static void latency_prepare(struct svm_test *test)
 {
-    default_prepare(test);
-    runs = LATENCY_RUNS;
-    latvmrun_min = latvmexit_min = -1ULL;
-    latvmrun_max = latvmexit_max = 0;
-    vmrun_sum = vmexit_sum = 0;
-    tsc_start = rdtsc();
+	default_prepare(test);
+	runs = LATENCY_RUNS;
+	latvmrun_min = latvmexit_min = -1ULL;
+	latvmrun_max = latvmexit_max = 0;
+	vmrun_sum = vmexit_sum = 0;
+	tsc_start = rdtsc();
 }
 
 static void latency_test(struct svm_test *test)
 {
-    u64 cycles;
+	u64 cycles;
 
 start:
-    tsc_end = rdtsc();
+	tsc_end = rdtsc();
 
-    cycles = tsc_end - tsc_start;
+	cycles = tsc_end - tsc_start;
 
-    if (cycles > latvmrun_max)
-        latvmrun_max = cycles;
+	if (cycles > latvmrun_max)
+		latvmrun_max = cycles;
 
-    if (cycles < latvmrun_min)
-        latvmrun_min = cycles;
+	if (cycles < latvmrun_min)
+		latvmrun_min = cycles;
 
-    vmrun_sum += cycles;
+	vmrun_sum += cycles;
 
-    tsc_start = rdtsc();
+	tsc_start = rdtsc();
 
-    asm volatile ("vmmcall" : : : "memory");
-    goto start;
+	asm volatile ("vmmcall" : : : "memory");
+	goto start;
 }
 
 static bool latency_finished(struct svm_test *test)
 {
-    u64 cycles;
+	u64 cycles;
 
-    tsc_end = rdtsc();
+	tsc_end = rdtsc();
 
-    cycles = tsc_end - tsc_start;
+	cycles = tsc_end - tsc_start;
 
-    if (cycles > latvmexit_max)
-        latvmexit_max = cycles;
+	if (cycles > latvmexit_max)
+		latvmexit_max = cycles;
 
-    if (cycles < latvmexit_min)
-        latvmexit_min = cycles;
+	if (cycles < latvmexit_min)
+		latvmexit_min = cycles;
 
-    vmexit_sum += cycles;
+	vmexit_sum += cycles;
 
-    vmcb->save.rip += 3;
+	vmcb->save.rip += 3;
 
-    runs -= 1;
+	runs -= 1;
 
-    tsc_end = rdtsc();
+	tsc_end = rdtsc();
 
-    return runs == 0;
+	return runs == 0;
 }
 
 static bool latency_finished_clean(struct svm_test *test)
 {
-    vmcb->control.clean = VMCB_CLEAN_ALL;
-    return latency_finished(test);
+	vmcb->control.clean = VMCB_CLEAN_ALL;
+	return latency_finished(test);
 }
 
 static bool latency_check(struct svm_test *test)
 {
-    printf("    Latency VMRUN : max: %ld min: %ld avg: %ld\n", latvmrun_max,
-            latvmrun_min, vmrun_sum / LATENCY_RUNS);
-    printf("    Latency VMEXIT: max: %ld min: %ld avg: %ld\n", latvmexit_max,
-            latvmexit_min, vmexit_sum / LATENCY_RUNS);
-    return true;
+	printf("    Latency VMRUN : max: %ld min: %ld avg: %ld\n", latvmrun_max,
+	       latvmrun_min, vmrun_sum / LATENCY_RUNS);
+	printf("    Latency VMEXIT: max: %ld min: %ld avg: %ld\n", latvmexit_max,
+	       latvmexit_min, vmexit_sum / LATENCY_RUNS);
+	return true;
 }
 
 static void lat_svm_insn_prepare(struct svm_test *test)
 {
-    default_prepare(test);
-    runs = LATENCY_RUNS;
-    latvmload_min = latvmsave_min = latstgi_min = latclgi_min = -1ULL;
-    latvmload_max = latvmsave_max = latstgi_max = latclgi_max = 0;
-    vmload_sum = vmsave_sum = stgi_sum = clgi_sum;
+	default_prepare(test);
+	runs = LATENCY_RUNS;
+	latvmload_min = latvmsave_min = latstgi_min = latclgi_min = -1ULL;
+	latvmload_max = latvmsave_max = latstgi_max = latclgi_max = 0;
+	vmload_sum = vmsave_sum = stgi_sum = clgi_sum;
 }
 
 static bool lat_svm_insn_finished(struct svm_test *test)
 {
-    u64 vmcb_phys = virt_to_phys(vmcb);
-    u64 cycles;
-
-    for ( ; runs != 0; runs--) {
-        tsc_start = rdtsc();
-        asm volatile("vmload %0\n\t" : : "a"(vmcb_phys) : "memory");
-        cycles = rdtsc() - tsc_start;
-        if (cycles > latvmload_max)
-            latvmload_max = cycles;
-        if (cycles < latvmload_min)
-            latvmload_min = cycles;
-        vmload_sum += cycles;
-
-        tsc_start = rdtsc();
-        asm volatile("vmsave %0\n\t" : : "a"(vmcb_phys) : "memory");
-        cycles = rdtsc() - tsc_start;
-        if (cycles > latvmsave_max)
-            latvmsave_max = cycles;
-        if (cycles < latvmsave_min)
-            latvmsave_min = cycles;
-        vmsave_sum += cycles;
-
-        tsc_start = rdtsc();
-        asm volatile("stgi\n\t");
-        cycles = rdtsc() - tsc_start;
-        if (cycles > latstgi_max)
-            latstgi_max = cycles;
-        if (cycles < latstgi_min)
-            latstgi_min = cycles;
-        stgi_sum += cycles;
-
-        tsc_start = rdtsc();
-        asm volatile("clgi\n\t");
-        cycles = rdtsc() - tsc_start;
-        if (cycles > latclgi_max)
-            latclgi_max = cycles;
-        if (cycles < latclgi_min)
-            latclgi_min = cycles;
-        clgi_sum += cycles;
-    }
+	u64 vmcb_phys = virt_to_phys(vmcb);
+	u64 cycles;
+
+	for ( ; runs != 0; runs--) {
+		tsc_start = rdtsc();
+		asm volatile("vmload %0\n\t" : : "a"(vmcb_phys) : "memory");
+		cycles = rdtsc() - tsc_start;
+		if (cycles > latvmload_max)
+			latvmload_max = cycles;
+		if (cycles < latvmload_min)
+			latvmload_min = cycles;
+		vmload_sum += cycles;
+
+		tsc_start = rdtsc();
+		asm volatile("vmsave %0\n\t" : : "a"(vmcb_phys) : "memory");
+		cycles = rdtsc() - tsc_start;
+		if (cycles > latvmsave_max)
+			latvmsave_max = cycles;
+		if (cycles < latvmsave_min)
+			latvmsave_min = cycles;
+		vmsave_sum += cycles;
+
+		tsc_start = rdtsc();
+		asm volatile("stgi\n\t");
+		cycles = rdtsc() - tsc_start;
+		if (cycles > latstgi_max)
+			latstgi_max = cycles;
+		if (cycles < latstgi_min)
+			latstgi_min = cycles;
+		stgi_sum += cycles;
+
+		tsc_start = rdtsc();
+		asm volatile("clgi\n\t");
+		cycles = rdtsc() - tsc_start;
+		if (cycles > latclgi_max)
+			latclgi_max = cycles;
+		if (cycles < latclgi_min)
+			latclgi_min = cycles;
+		clgi_sum += cycles;
+	}
 
-    tsc_end = rdtsc();
+	tsc_end = rdtsc();
 
-    return true;
+	return true;
 }
 
 static bool lat_svm_insn_check(struct svm_test *test)
 {
-    printf("    Latency VMLOAD: max: %ld min: %ld avg: %ld\n", latvmload_max,
-            latvmload_min, vmload_sum / LATENCY_RUNS);
-    printf("    Latency VMSAVE: max: %ld min: %ld avg: %ld\n", latvmsave_max,
-            latvmsave_min, vmsave_sum / LATENCY_RUNS);
-    printf("    Latency STGI:   max: %ld min: %ld avg: %ld\n", latstgi_max,
-            latstgi_min, stgi_sum / LATENCY_RUNS);
-    printf("    Latency CLGI:   max: %ld min: %ld avg: %ld\n", latclgi_max,
-            latclgi_min, clgi_sum / LATENCY_RUNS);
-    return true;
+	printf("    Latency VMLOAD: max: %ld min: %ld avg: %ld\n", latvmload_max,
+	       latvmload_min, vmload_sum / LATENCY_RUNS);
+	printf("    Latency VMSAVE: max: %ld min: %ld avg: %ld\n", latvmsave_max,
+	       latvmsave_min, vmsave_sum / LATENCY_RUNS);
+	printf("    Latency STGI:   max: %ld min: %ld avg: %ld\n", latstgi_max,
+	       latstgi_min, stgi_sum / LATENCY_RUNS);
+	printf("    Latency CLGI:   max: %ld min: %ld avg: %ld\n", latclgi_max,
+	       latclgi_min, clgi_sum / LATENCY_RUNS);
+	return true;
 }
 
 bool pending_event_ipi_fired;
@@ -953,182 +953,182 @@ bool pending_event_guest_run;
 
 static void pending_event_ipi_isr(isr_regs_t *regs)
 {
-    pending_event_ipi_fired = true;
-    eoi();
+	pending_event_ipi_fired = true;
+	eoi();
 }
 
 static void pending_event_prepare(struct svm_test *test)
 {
-    int ipi_vector = 0xf1;
+	int ipi_vector = 0xf1;
 
-    default_prepare(test);
+	default_prepare(test);
 
-    pending_event_ipi_fired = false;
+	pending_event_ipi_fired = false;
 
-    handle_irq(ipi_vector, pending_event_ipi_isr);
+	handle_irq(ipi_vector, pending_event_ipi_isr);
 
-    pending_event_guest_run = false;
+	pending_event_guest_run = false;
 
-    vmcb->control.intercept |= (1ULL << INTERCEPT_INTR);
-    vmcb->control.int_ctl |= V_INTR_MASKING_MASK;
+	vmcb->control.intercept |= (1ULL << INTERCEPT_INTR);
+	vmcb->control.int_ctl |= V_INTR_MASKING_MASK;
 
-    apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL |
-                  APIC_DM_FIXED | ipi_vector, 0);
+	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL |
+		       APIC_DM_FIXED | ipi_vector, 0);
 
-    set_test_stage(test, 0);
+	set_test_stage(test, 0);
 }
 
 static void pending_event_test(struct svm_test *test)
 {
-    pending_event_guest_run = true;
+	pending_event_guest_run = true;
 }
 
 static bool pending_event_finished(struct svm_test *test)
 {
-    switch (get_test_stage(test)) {
-    case 0:
-        if (vmcb->control.exit_code != SVM_EXIT_INTR) {
-            report_fail("VMEXIT not due to pending interrupt. Exit reason 0x%x",
-                        vmcb->control.exit_code);
-            return true;
-        }
+	switch (get_test_stage(test)) {
+	case 0:
+		if (vmcb->control.exit_code != SVM_EXIT_INTR) {
+			report_fail("VMEXIT not due to pending interrupt. Exit reason 0x%x",
+				    vmcb->control.exit_code);
+			return true;
+		}
 
-        vmcb->control.intercept &= ~(1ULL << INTERCEPT_INTR);
-        vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
+		vmcb->control.intercept &= ~(1ULL << INTERCEPT_INTR);
+		vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
 
-        if (pending_event_guest_run) {
-            report_fail("Guest ran before host received IPI\n");
-            return true;
-        }
+		if (pending_event_guest_run) {
+			report_fail("Guest ran before host received IPI\n");
+			return true;
+		}
 
-        irq_enable();
-        asm volatile ("nop");
-        irq_disable();
+		irq_enable();
+		asm volatile ("nop");
+		irq_disable();
 
-        if (!pending_event_ipi_fired) {
-            report_fail("Pending interrupt not dispatched after IRQ enabled\n");
-            return true;
-        }
-        break;
+		if (!pending_event_ipi_fired) {
+			report_fail("Pending interrupt not dispatched after IRQ enabled\n");
+			return true;
+		}
+		break;
 
-    case 1:
-        if (!pending_event_guest_run) {
-            report_fail("Guest did not resume when no interrupt\n");
-            return true;
-        }
-        break;
-    }
+	case 1:
+		if (!pending_event_guest_run) {
+			report_fail("Guest did not resume when no interrupt\n");
+			return true;
+		}
+		break;
+	}
 
-    inc_test_stage(test);
+	inc_test_stage(test);
 
-    return get_test_stage(test) == 2;
+	return get_test_stage(test) == 2;
 }
 
 static bool pending_event_check(struct svm_test *test)
 {
-    return get_test_stage(test) == 2;
+	return get_test_stage(test) == 2;
 }
 
 static void pending_event_cli_prepare(struct svm_test *test)
 {
-    default_prepare(test);
+	default_prepare(test);
 
-    pending_event_ipi_fired = false;
+	pending_event_ipi_fired = false;
 
-    handle_irq(0xf1, pending_event_ipi_isr);
+	handle_irq(0xf1, pending_event_ipi_isr);
 
-    apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL |
-              APIC_DM_FIXED | 0xf1, 0);
+	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL |
+		       APIC_DM_FIXED | 0xf1, 0);
 
-    set_test_stage(test, 0);
+	set_test_stage(test, 0);
 }
 
 static void pending_event_cli_prepare_gif_clear(struct svm_test *test)
 {
-    asm("cli");
+	asm("cli");
 }
 
 static void pending_event_cli_test(struct svm_test *test)
 {
-    if (pending_event_ipi_fired == true) {
-        set_test_stage(test, -1);
-        report_fail("Interrupt preceeded guest");
-        vmmcall();
-    }
+	if (pending_event_ipi_fired == true) {
+		set_test_stage(test, -1);
+		report_fail("Interrupt preceeded guest");
+		vmmcall();
+	}
 
-    /* VINTR_MASKING is zero.  This should cause the IPI to fire.  */
-    irq_enable();
-    asm volatile ("nop");
-    irq_disable();
+	/* VINTR_MASKING is zero.  This should cause the IPI to fire.  */
+	irq_enable();
+	asm volatile ("nop");
+	irq_disable();
 
-    if (pending_event_ipi_fired != true) {
-        set_test_stage(test, -1);
-        report_fail("Interrupt not triggered by guest");
-    }
+	if (pending_event_ipi_fired != true) {
+		set_test_stage(test, -1);
+		report_fail("Interrupt not triggered by guest");
+	}
 
-    vmmcall();
+	vmmcall();
 
-    /*
-     * Now VINTR_MASKING=1, but no interrupt is pending so
-     * the VINTR interception should be clear in VMCB02.  Check
-     * that L0 did not leave a stale VINTR in the VMCB.
-     */
-    irq_enable();
-    asm volatile ("nop");
-    irq_disable();
+	/*
+	 * Now VINTR_MASKING=1, but no interrupt is pending so
+	 * the VINTR interception should be clear in VMCB02.  Check
+	 * that L0 did not leave a stale VINTR in the VMCB.
+	 */
+	irq_enable();
+	asm volatile ("nop");
+	irq_disable();
 }
 
 static bool pending_event_cli_finished(struct svm_test *test)
 {
-    if ( vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-        report_fail("VM_EXIT return to host is not EXIT_VMMCALL exit reason 0x%x",
-                    vmcb->control.exit_code);
-        return true;
-    }
+	if ( vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+		report_fail("VM_EXIT return to host is not EXIT_VMMCALL exit reason 0x%x",
+			    vmcb->control.exit_code);
+		return true;
+	}
 
-    switch (get_test_stage(test)) {
-    case 0:
-        vmcb->save.rip += 3;
+	switch (get_test_stage(test)) {
+	case 0:
+		vmcb->save.rip += 3;
 
-        pending_event_ipi_fired = false;
+		pending_event_ipi_fired = false;
 
-        vmcb->control.int_ctl |= V_INTR_MASKING_MASK;
+		vmcb->control.int_ctl |= V_INTR_MASKING_MASK;
 
-	/* Now entering again with VINTR_MASKING=1.  */
-        apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL |
-              APIC_DM_FIXED | 0xf1, 0);
+		/* Now entering again with VINTR_MASKING=1.  */
+		apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL |
+			       APIC_DM_FIXED | 0xf1, 0);
 
-        break;
+		break;
 
-    case 1:
-        if (pending_event_ipi_fired == true) {
-            report_fail("Interrupt triggered by guest");
-            return true;
-        }
+	case 1:
+		if (pending_event_ipi_fired == true) {
+			report_fail("Interrupt triggered by guest");
+			return true;
+		}
 
-        irq_enable();
-        asm volatile ("nop");
-        irq_disable();
+		irq_enable();
+		asm volatile ("nop");
+		irq_disable();
 
-        if (pending_event_ipi_fired != true) {
-            report_fail("Interrupt not triggered by host");
-            return true;
-        }
+		if (pending_event_ipi_fired != true) {
+			report_fail("Interrupt not triggered by host");
+			return true;
+		}
 
-        break;
+		break;
 
-    default:
-        return true;
-    }
+	default:
+		return true;
+	}
 
-    inc_test_stage(test);
+	inc_test_stage(test);
 
-    return get_test_stage(test) == 2;
+	return get_test_stage(test) == 2;
 }
 
 static bool pending_event_cli_check(struct svm_test *test)
 {
-    return get_test_stage(test) == 2;
+	return get_test_stage(test) == 2;
 }
 
 #define TIMER_VECTOR    222
@@ -1137,529 +1137,529 @@ static volatile bool timer_fired;
 
 static void timer_isr(isr_regs_t *regs)
 {
-    timer_fired = true;
-    apic_write(APIC_EOI, 0);
+	timer_fired = true;
+	apic_write(APIC_EOI, 0);
 }
 
 static void interrupt_prepare(struct svm_test *test)
 {
-    default_prepare(test);
-    handle_irq(TIMER_VECTOR, timer_isr);
-    timer_fired = false;
-    set_test_stage(test, 0);
+	default_prepare(test);
+	handle_irq(TIMER_VECTOR, timer_isr);
+	timer_fired = false;
+	set_test_stage(test, 0);
 }
 
 static void interrupt_test(struct svm_test *test)
 {
-    long long start, loops;
+	long long start, loops;
 
-    apic_write(APIC_LVTT, TIMER_VECTOR);
-    irq_enable();
-    apic_write(APIC_TMICT, 1); //Timer Initial Count Register 0x380 one-shot
-    for (loops = 0; loops < 10000000 && !timer_fired; loops++)
-        asm volatile ("nop");
+	apic_write(APIC_LVTT, TIMER_VECTOR);
+	irq_enable();
+	apic_write(APIC_TMICT, 1); //Timer Initial Count Register 0x380 one-shot
+	for (loops = 0; loops < 10000000 && !timer_fired; loops++)
+		asm volatile ("nop");
 
-    report(timer_fired, "direct interrupt while running guest");
+	report(timer_fired, "direct interrupt while running guest");
 
-    if (!timer_fired) {
-        set_test_stage(test, -1);
-        vmmcall();
-    }
+	if (!timer_fired) {
+		set_test_stage(test, -1);
+		vmmcall();
+	}
 
-    apic_write(APIC_TMICT, 0);
-    irq_disable();
-    vmmcall();
+	apic_write(APIC_TMICT, 0);
+	irq_disable();
+	vmmcall();
 
-    timer_fired = false;
-    apic_write(APIC_TMICT, 1);
-    for (loops = 0; loops < 10000000 && !timer_fired; loops++)
-        asm volatile ("nop");
+	timer_fired = false;
+	apic_write(APIC_TMICT, 1);
+	for (loops = 0; loops < 10000000 && !timer_fired; loops++)
+		asm volatile ("nop");
 
-    report(timer_fired, "intercepted interrupt while running guest");
+	report(timer_fired, "intercepted interrupt while running guest");
 
-    if (!timer_fired) {
-        set_test_stage(test, -1);
-        vmmcall();
-    }
+	if (!timer_fired) {
+		set_test_stage(test, -1);
+		vmmcall();
+	}
 
-    irq_enable();
-    apic_write(APIC_TMICT, 0);
-    irq_disable();
+	irq_enable();
+	apic_write(APIC_TMICT, 0);
+	irq_disable();
 
-    timer_fired = false;
-    start = rdtsc();
-    apic_write(APIC_TMICT, 1000000);
-    safe_halt();
+	timer_fired = false;
+	start = rdtsc();
+	apic_write(APIC_TMICT, 1000000);
+	safe_halt();
 
-    report(rdtsc() - start > 10000 && timer_fired,
-          "direct interrupt + hlt");
+	report(rdtsc() - start > 10000 && timer_fired,
+	       "direct interrupt + hlt");
 
-    if (!timer_fired) {
-        set_test_stage(test, -1);
-        vmmcall();
-    }
+	if (!timer_fired) {
+		set_test_stage(test, -1);
+		vmmcall();
+	}
 
-    apic_write(APIC_TMICT, 0);
-    irq_disable();
-    vmmcall();
+	apic_write(APIC_TMICT, 0);
+	irq_disable();
+	vmmcall();
 
-    timer_fired = false;
-    start = rdtsc();
-    apic_write(APIC_TMICT, 1000000);
-    asm volatile ("hlt");
+	timer_fired = false;
+	start = rdtsc();
+	apic_write(APIC_TMICT, 1000000);
+	asm volatile ("hlt");
 
-    report(rdtsc() - start > 10000 && timer_fired,
-           "intercepted interrupt + hlt");
+	report(rdtsc() - start > 10000 && timer_fired,
+	       "intercepted interrupt + hlt");
 
-    if (!timer_fired) {
-        set_test_stage(test, -1);
-        vmmcall();
-    }
+	if (!timer_fired) {
+		set_test_stage(test, -1);
+		vmmcall();
+	}
 
-    apic_write(APIC_TMICT, 0);
-    irq_disable();
+	apic_write(APIC_TMICT, 0);
+	irq_disable();
 }
 
 static bool interrupt_finished(struct svm_test *test)
 {
-    switch (get_test_stage(test)) {
-    case 0:
-    case 2:
-        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-            report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
-                        vmcb->control.exit_code);
-            return true;
-        }
-        vmcb->save.rip += 3;
+	switch (get_test_stage(test)) {
+	case 0:
+	case 2:
+		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+				    vmcb->control.exit_code);
+			return true;
+		}
+		vmcb->save.rip += 3;
 
-        vmcb->control.intercept |= (1ULL << INTERCEPT_INTR);
-        vmcb->control.int_ctl |= V_INTR_MASKING_MASK;
-        break;
+		vmcb->control.intercept |= (1ULL << INTERCEPT_INTR);
+		vmcb->control.int_ctl |= V_INTR_MASKING_MASK;
+		break;
 
-    case 1:
-    case 3:
-        if (vmcb->control.exit_code != SVM_EXIT_INTR) {
-            report_fail("VMEXIT not due to intr intercept. Exit reason 0x%x",
-                        vmcb->control.exit_code);
-            return true;
-        }
+	case 1:
+	case 3:
+		if (vmcb->control.exit_code != SVM_EXIT_INTR) {
+			report_fail("VMEXIT not due to intr intercept. Exit reason 0x%x",
+				    vmcb->control.exit_code);
+			return true;
+		}
 
-        irq_enable();
-        asm volatile ("nop");
-        irq_disable();
+		irq_enable();
+		asm volatile ("nop");
+		irq_disable();
 
-        vmcb->control.intercept &= ~(1ULL << INTERCEPT_INTR);
-        vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
-        break;
+		vmcb->control.intercept &= ~(1ULL << INTERCEPT_INTR);
+		vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
+		break;
 
-    case 4:
-        break;
+	case 4:
+		break;
 
-    default:
-        return true;
-    }
+	default:
+		return true;
+	}
 
-    inc_test_stage(test);
+	inc_test_stage(test);
 
-    return get_test_stage(test) == 5;
+	return get_test_stage(test) == 5;
 }
 
 static bool interrupt_check(struct svm_test *test)
 {
-    return get_test_stage(test) == 5;
+	return get_test_stage(test) == 5;
 }
 
 static volatile bool nmi_fired;
 
 static void nmi_handler(struct ex_regs *regs)
 {
-    nmi_fired = true;
+	nmi_fired = true;
 }
 
 static void nmi_prepare(struct svm_test *test)
 {
-    default_prepare(test);
-    nmi_fired = false;
-    handle_exception(NMI_VECTOR, nmi_handler);
-    set_test_stage(test, 0);
+	default_prepare(test);
+	nmi_fired = false;
+	handle_exception(NMI_VECTOR, nmi_handler);
+	set_test_stage(test, 0);
 }
 
 static void nmi_test(struct svm_test *test)
 {
-    apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, 0);
+	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, 0);
 
-    report(nmi_fired, "direct NMI while running guest");
+	report(nmi_fired, "direct NMI while running guest");
 
-    if (!nmi_fired)
-        set_test_stage(test, -1);
+	if (!nmi_fired)
+		set_test_stage(test, -1);
 
-    vmmcall();
+	vmmcall();
 
-    nmi_fired = false;
+	nmi_fired = false;
 
-    apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, 0);
+	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, 0);
 
-    if (!nmi_fired) {
-        report(nmi_fired, "intercepted pending NMI not dispatched");
-        set_test_stage(test, -1);
-    }
+	if (!nmi_fired) {
+		report(nmi_fired, "intercepted pending NMI not dispatched");
+		set_test_stage(test, -1);
+	}
 
 }
 
 static bool nmi_finished(struct svm_test *test)
 {
-    switch (get_test_stage(test)) {
-    case 0:
-        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-            report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
-                        vmcb->control.exit_code);
-            return true;
-        }
-        vmcb->save.rip += 3;
+	switch (get_test_stage(test)) {
+	case 0:
+		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+				    vmcb->control.exit_code);
+			return true;
+		}
+		vmcb->save.rip += 3;
 
-        vmcb->control.intercept |= (1ULL << INTERCEPT_NMI);
-        break;
+		vmcb->control.intercept |= (1ULL << INTERCEPT_NMI);
+		break;
 
-    case 1:
-        if (vmcb->control.exit_code != SVM_EXIT_NMI) {
-            report_fail("VMEXIT not due to NMI intercept. Exit reason 0x%x",
-                        vmcb->control.exit_code);
-            return true;
-        }
+	case 1:
+		if (vmcb->control.exit_code != SVM_EXIT_NMI) {
+			report_fail("VMEXIT not due to NMI intercept. Exit reason 0x%x",
+				    vmcb->control.exit_code);
+			return true;
+		}
 
-        report_pass("NMI intercept while running guest");
-        break;
+		report_pass("NMI intercept while running guest");
+		break;
 
-    case 2:
-        break;
+	case 2:
+		break;
 
-    default:
-        return true;
-    }
+	default:
+		return true;
+	}
 
-    inc_test_stage(test);
+	inc_test_stage(test);
 
-    return get_test_stage(test) == 3;
+	return get_test_stage(test) == 3;
 }
 
 static bool nmi_check(struct svm_test *test)
 {
-    return get_test_stage(test) == 3;
+	return get_test_stage(test) == 3;
 }
 
 #define NMI_DELAY 100000000ULL
 
 static void nmi_message_thread(void *_test)
 {
-    struct svm_test *test = _test;
+	struct svm_test *test = _test;
 
-    while (get_test_stage(test) != 1)
-        pause();
+	while (get_test_stage(test) != 1)
+		pause();
 
-    delay(NMI_DELAY);
+	delay(NMI_DELAY);
 
-    apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, id_map[0]);
+	apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, id_map[0]);
 
-    while (get_test_stage(test) != 2)
-        pause();
+	while (get_test_stage(test) != 2)
+		pause();
 
-    delay(NMI_DELAY);
+	delay(NMI_DELAY);
 
-    apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, id_map[0]);
+	apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, id_map[0]);
 }
 
 static void nmi_hlt_test(struct svm_test *test)
 {
-    long long start;
+	long long start;
 
-    on_cpu_async(1, nmi_message_thread, test);
+	on_cpu_async(1, nmi_message_thread, test);
 
-    start = rdtsc();
+	start = rdtsc();
 
-    set_test_stage(test, 1);
+	set_test_stage(test, 1);
 
-    asm volatile ("hlt");
+	asm volatile ("hlt");
 
-    report((rdtsc() - start > NMI_DELAY) && nmi_fired,
-          "direct NMI + hlt");
+	report((rdtsc() - start > NMI_DELAY) && nmi_fired,
+	       "direct NMI + hlt");
 
-    if (!nmi_fired)
-        set_test_stage(test, -1);
+	if (!nmi_fired)
+		set_test_stage(test, -1);
 
-    nmi_fired = false;
+	nmi_fired = false;
 
-    vmmcall();
+	vmmcall();
 
-    start = rdtsc();
+	start = rdtsc();
 
-    set_test_stage(test, 2);
+	set_test_stage(test, 2);
 
-    asm volatile ("hlt");
+	asm volatile ("hlt");
 
-    report((rdtsc() - start > NMI_DELAY) && nmi_fired,
-           "intercepted NMI + hlt");
+	report((rdtsc() - start > NMI_DELAY) && nmi_fired,
+	       "intercepted NMI + hlt");
 
-    if (!nmi_fired) {
-        report(nmi_fired, "intercepted pending NMI not dispatched");
-        set_test_stage(test, -1);
-        vmmcall();
-    }
+	if (!nmi_fired) {
+		report(nmi_fired, "intercepted pending NMI not dispatched");
+		set_test_stage(test, -1);
+		vmmcall();
+	}
 
-    set_test_stage(test, 3);
+	set_test_stage(test, 3);
 }
 
 static bool nmi_hlt_finished(struct svm_test *test)
 {
-    switch (get_test_stage(test)) {
-    case 1:
-        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-            report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
-                        vmcb->control.exit_code);
-            return true;
-        }
-        vmcb->save.rip += 3;
+	switch (get_test_stage(test)) {
+	case 1:
+		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+				    vmcb->control.exit_code);
+			return true;
+		}
+		vmcb->save.rip += 3;
 
-        vmcb->control.intercept |= (1ULL << INTERCEPT_NMI);
-        break;
+		vmcb->control.intercept |= (1ULL << INTERCEPT_NMI);
+		break;
 
-    case 2:
-        if (vmcb->control.exit_code != SVM_EXIT_NMI) {
-            report_fail("VMEXIT not due to NMI intercept. Exit reason 0x%x",
-                        vmcb->control.exit_code);
-            return true;
-        }
+	case 2:
+		if (vmcb->control.exit_code != SVM_EXIT_NMI) {
+			report_fail("VMEXIT not due to NMI intercept. Exit reason 0x%x",
+				    vmcb->control.exit_code);
+			return true;
+		}
 
-        report_pass("NMI intercept while running guest");
-        break;
+		report_pass("NMI intercept while running guest");
+		break;
 
-    case 3:
-        break;
+	case 3:
+		break;
 
-    default:
-        return true;
-    }
+	default:
+		return true;
+	}
 
-    return get_test_stage(test) == 3;
+	return get_test_stage(test) == 3;
 }
 
 static bool nmi_hlt_check(struct svm_test *test)
 {
-    return get_test_stage(test) == 3;
+	return get_test_stage(test) == 3;
 }
 
 static volatile int count_exc = 0;
 
 static void my_isr(struct ex_regs *r)
 {
-        count_exc++;
+	count_exc++;
 }
 
 static void exc_inject_prepare(struct svm_test *test)
 {
-    default_prepare(test);
-    handle_exception(DE_VECTOR, my_isr);
-    handle_exception(NMI_VECTOR, my_isr);
+	default_prepare(test);
+	handle_exception(DE_VECTOR, my_isr);
+	handle_exception(NMI_VECTOR, my_isr);
 }
 
 
 static void exc_inject_test(struct svm_test *test)
 {
-    asm volatile ("vmmcall\n\tvmmcall\n\t");
+	asm volatile ("vmmcall\n\tvmmcall\n\t");
 }
 
 static bool exc_inject_finished(struct svm_test *test)
 {
-    switch (get_test_stage(test)) {
-    case 0:
-        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-            report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
-                        vmcb->control.exit_code);
-            return true;
-        }
-        vmcb->save.rip += 3;
-        vmcb->control.event_inj = NMI_VECTOR | SVM_EVTINJ_TYPE_EXEPT | SVM_EVTINJ_VALID;
-        break;
+	switch (get_test_stage(test)) {
+	case 0:
+		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+				    vmcb->control.exit_code);
+			return true;
+		}
+		vmcb->save.rip += 3;
+		vmcb->control.event_inj = NMI_VECTOR | SVM_EVTINJ_TYPE_EXEPT | SVM_EVTINJ_VALID;
+		break;
 
-    case 1:
-        if (vmcb->control.exit_code != SVM_EXIT_ERR) {
-            report_fail("VMEXIT not due to error. Exit reason 0x%x",
-                        vmcb->control.exit_code);
-            return true;
-        }
-        report(count_exc == 0, "exception with vector 2 not injected");
-        vmcb->control.event_inj = DE_VECTOR | SVM_EVTINJ_TYPE_EXEPT | SVM_EVTINJ_VALID;
-        break;
+	case 1:
+		if (vmcb->control.exit_code != SVM_EXIT_ERR) {
+			report_fail("VMEXIT not due to error. Exit reason 0x%x",
+				    vmcb->control.exit_code);
+			return true;
+		}
+		report(count_exc == 0, "exception with vector 2 not injected");
+		vmcb->control.event_inj = DE_VECTOR | SVM_EVTINJ_TYPE_EXEPT | SVM_EVTINJ_VALID;
+		break;
 
-    case 2:
-        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-            report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
-                        vmcb->control.exit_code);
-            return true;
-        }
-        vmcb->save.rip += 3;
-        report(count_exc == 1, "divide overflow exception injected");
-        report(!(vmcb->control.event_inj & SVM_EVTINJ_VALID), "eventinj.VALID cleared");
-        break;
+	case 2:
+		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+				    vmcb->control.exit_code);
+			return true;
+		}
+		vmcb->save.rip += 3;
+		report(count_exc == 1, "divide overflow exception injected");
+		report(!(vmcb->control.event_inj & SVM_EVTINJ_VALID), "eventinj.VALID cleared");
+		break;
 
-    default:
-        return true;
-    }
+	default:
+		return true;
+	}
 
-    inc_test_stage(test);
+	inc_test_stage(test);
 
-    return get_test_stage(test) == 3;
+	return get_test_stage(test) == 3;
 }
 
 static bool exc_inject_check(struct svm_test *test)
 {
-    return count_exc == 1 && get_test_stage(test) == 3;
+	return count_exc == 1 && get_test_stage(test) == 3;
 }
 
 static volatile bool virq_fired;
 
 static void virq_isr(isr_regs_t *regs)
 {
-    virq_fired = true;
+	virq_fired = true;
 }
 
 static void virq_inject_prepare(struct svm_test *test)
 {
-    handle_irq(0xf1, virq_isr);
-    default_prepare(test);
-    vmcb->control.int_ctl = V_INTR_MASKING_MASK | V_IRQ_MASK |
-                            (0x0f << V_INTR_PRIO_SHIFT); // Set to the highest priority
-    vmcb->control.int_vector = 0xf1;
-    virq_fired = false;
-    set_test_stage(test, 0);
+	handle_irq(0xf1, virq_isr);
+	default_prepare(test);
+	vmcb->control.int_ctl = V_INTR_MASKING_MASK | V_IRQ_MASK |
+		(0x0f << V_INTR_PRIO_SHIFT); // Set to the highest priority
+	vmcb->control.int_vector = 0xf1;
+	virq_fired = false;
+	set_test_stage(test, 0);
 }
 
 static void virq_inject_test(struct svm_test *test)
 {
-    if (virq_fired) {
-        report_fail("virtual interrupt fired before L2 sti");
-        set_test_stage(test, -1);
-        vmmcall();
-    }
+	if (virq_fired) {
+		report_fail("virtual interrupt fired before L2 sti");
+		set_test_stage(test, -1);
+		vmmcall();
+	}
 
-    irq_enable();
-    asm volatile ("nop");
-    irq_disable();
+	irq_enable();
+	asm volatile ("nop");
+	irq_disable();
 
-    if (!virq_fired) {
-        report_fail("virtual interrupt not fired after L2 sti");
-        set_test_stage(test, -1);
-    }
+	if (!virq_fired) {
+		report_fail("virtual interrupt not fired after L2 sti");
+		set_test_stage(test, -1);
+	}
 
-    vmmcall();
+	vmmcall();
 
-    if (virq_fired) {
-        report_fail("virtual interrupt fired before L2 sti after VINTR intercept");
-        set_test_stage(test, -1);
-        vmmcall();
-    }
+	if (virq_fired) {
+		report_fail("virtual interrupt fired before L2 sti after VINTR intercept");
+		set_test_stage(test, -1);
+		vmmcall();
+	}
 
-    irq_enable();
-    asm volatile ("nop");
-    irq_disable();
+	irq_enable();
+	asm volatile ("nop");
+	irq_disable();
 
-    if (!virq_fired) {
-        report_fail("virtual interrupt not fired after return from VINTR intercept");
-        set_test_stage(test, -1);
-    }
+	if (!virq_fired) {
+		report_fail("virtual interrupt not fired after return from VINTR intercept");
+		set_test_stage(test, -1);
+	}
 
-    vmmcall();
+	vmmcall();
 
-    irq_enable();
-    asm volatile ("nop");
-    irq_disable();
+	irq_enable();
+	asm volatile ("nop");
+	irq_disable();
 
-    if (virq_fired) {
-        report_fail("virtual interrupt fired when V_IRQ_PRIO less than V_TPR");
-        set_test_stage(test, -1);
-    }
+	if (virq_fired) {
+		report_fail("virtual interrupt fired when V_IRQ_PRIO less than V_TPR");
+		set_test_stage(test, -1);
+	}
 
-    vmmcall();
-    vmmcall();
+	vmmcall();
+	vmmcall();
 }
 
 static bool virq_inject_finished(struct svm_test *test)
 {
-    vmcb->save.rip += 3;
+	vmcb->save.rip += 3;
 
-    switch (get_test_stage(test)) {
-    case 0:
-        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-            report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
-                        vmcb->control.exit_code);
-            return true;
-        }
-        if (vmcb->control.int_ctl & V_IRQ_MASK) {
-            report_fail("V_IRQ not cleared on VMEXIT after firing");
-            return true;
-        }
-        virq_fired = false;
-        vmcb->control.intercept |= (1ULL << INTERCEPT_VINTR);
-        vmcb->control.int_ctl = V_INTR_MASKING_MASK | V_IRQ_MASK |
-                            (0x0f << V_INTR_PRIO_SHIFT);
-        break;
+	switch (get_test_stage(test)) {
+	case 0:
+		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+				    vmcb->control.exit_code);
+			return true;
+		}
+		if (vmcb->control.int_ctl & V_IRQ_MASK) {
+			report_fail("V_IRQ not cleared on VMEXIT after firing");
+			return true;
+		}
+		virq_fired = false;
+		vmcb->control.intercept |= (1ULL << INTERCEPT_VINTR);
+		vmcb->control.int_ctl = V_INTR_MASKING_MASK | V_IRQ_MASK |
+			(0x0f << V_INTR_PRIO_SHIFT);
+		break;
 
-    case 1:
-        if (vmcb->control.exit_code != SVM_EXIT_VINTR) {
-            report_fail("VMEXIT not due to vintr. Exit reason 0x%x",
-                        vmcb->control.exit_code);
-            return true;
-        }
-        if (virq_fired) {
-            report_fail("V_IRQ fired before SVM_EXIT_VINTR");
-            return true;
-        }
-        vmcb->control.intercept &= ~(1ULL << INTERCEPT_VINTR);
-        break;
+	case 1:
+		if (vmcb->control.exit_code != SVM_EXIT_VINTR) {
+			report_fail("VMEXIT not due to vintr. Exit reason 0x%x",
+				    vmcb->control.exit_code);
+			return true;
+		}
+		if (virq_fired) {
+			report_fail("V_IRQ fired before SVM_EXIT_VINTR");
+			return true;
+		}
+		vmcb->control.intercept &= ~(1ULL << INTERCEPT_VINTR);
+		break;
 
-    case 2:
-        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-            report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
-                        vmcb->control.exit_code);
-            return true;
-        }
-        virq_fired = false;
-        // Set irq to lower priority
-        vmcb->control.int_ctl = V_INTR_MASKING_MASK | V_IRQ_MASK |
-                            (0x08 << V_INTR_PRIO_SHIFT);
-        // Raise guest TPR
-        vmcb->control.int_ctl |= 0x0a & V_TPR_MASK;
-        break;
+	case 2:
+		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+				    vmcb->control.exit_code);
+			return true;
+		}
+		virq_fired = false;
+		// Set irq to lower priority
+		vmcb->control.int_ctl = V_INTR_MASKING_MASK | V_IRQ_MASK |
+			(0x08 << V_INTR_PRIO_SHIFT);
+		// Raise guest TPR
+		vmcb->control.int_ctl |= 0x0a & V_TPR_MASK;
+		break;
 
-    case 3:
-        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-            report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
-                        vmcb->control.exit_code);
-            return true;
-        }
-        vmcb->control.intercept |= (1ULL << INTERCEPT_VINTR);
-        break;
+	case 3:
+		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+				    vmcb->control.exit_code);
+			return true;
+		}
+		vmcb->control.intercept |= (1ULL << INTERCEPT_VINTR);
+		break;
 
-    case 4:
-        // INTERCEPT_VINTR should be ignored because V_INTR_PRIO < V_TPR
-        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-            report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
-                        vmcb->control.exit_code);
-            return true;
-        }
-        break;
+	case 4:
+		// INTERCEPT_VINTR should be ignored because V_INTR_PRIO < V_TPR
+		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+				    vmcb->control.exit_code);
+			return true;
+		}
+		break;
 
-    default:
-        return true;
-    }
+	default:
+		return true;
+	}
 
-    inc_test_stage(test);
+	inc_test_stage(test);
 
-    return get_test_stage(test) == 5;
+	return get_test_stage(test) == 5;
 }
 
 static bool virq_inject_check(struct svm_test *test)
 {
-    return get_test_stage(test) == 5;
+	return get_test_stage(test) == 5;
 }
 
 /*
@@ -1688,157 +1688,157 @@ extern const char insb_instruction_label[];
 
 static void reg_corruption_isr(isr_regs_t *regs)
 {
-    isr_cnt++;
-    apic_write(APIC_EOI, 0);
+	isr_cnt++;
+	apic_write(APIC_EOI, 0);
 }
 
 static void reg_corruption_prepare(struct svm_test *test)
 {
-    default_prepare(test);
-    set_test_stage(test, 0);
+	default_prepare(test);
+	set_test_stage(test, 0);
 
-    vmcb->control.int_ctl = V_INTR_MASKING_MASK;
-    vmcb->control.intercept |= (1ULL << INTERCEPT_INTR);
+	vmcb->control.int_ctl = V_INTR_MASKING_MASK;
+	vmcb->control.intercept |= (1ULL << INTERCEPT_INTR);
 
-    handle_irq(TIMER_VECTOR, reg_corruption_isr);
+	handle_irq(TIMER_VECTOR, reg_corruption_isr);
 
-    /* set local APIC to inject external interrupts */
-    apic_write(APIC_TMICT, 0);
-    apic_write(APIC_TDCR, 0);
-    apic_write(APIC_LVTT, TIMER_VECTOR | APIC_LVT_TIMER_PERIODIC);
-    apic_write(APIC_TMICT, 1000);
+	/* set local APIC to inject external interrupts */
+	apic_write(APIC_TMICT, 0);
+	apic_write(APIC_TDCR, 0);
+	apic_write(APIC_LVTT, TIMER_VECTOR | APIC_LVT_TIMER_PERIODIC);
+	apic_write(APIC_TMICT, 1000);
 }
 
 static void reg_corruption_test(struct svm_test *test)
 {
-    /* this is endless loop, which is interrupted by the timer interrupt */
-    asm volatile (
-            "1:\n\t"
-            "movw $0x4d0, %%dx\n\t" // IO port
-            "lea %[io_port_var], %%rdi\n\t"
-            "movb $0xAA, %[io_port_var]\n\t"
-            "insb_instruction_label:\n\t"
-            "insb\n\t"
-            "jmp 1b\n\t"
-
-            : [io_port_var] "=m" (io_port_var)
-            : /* no inputs*/
-            : "rdx", "rdi"
-    );
+	/* this is endless loop, which is interrupted by the timer interrupt */
+	asm volatile (
+		      "1:\n\t"
+		      "movw $0x4d0, %%dx\n\t" // IO port
+		      "lea %[io_port_var], %%rdi\n\t"
+		      "movb $0xAA, %[io_port_var]\n\t"
+		      "insb_instruction_label:\n\t"
+		      "insb\n\t"
+		      "jmp 1b\n\t"
+
+		      : [io_port_var] "=m" (io_port_var)
+		      : /* no inputs*/
+		      : "rdx", "rdi"
+		      );
 }
 
 static bool reg_corruption_finished(struct svm_test *test)
 {
-    if (isr_cnt == 10000) {
-        report_pass("No RIP corruption detected after %d timer interrupts",
-                    isr_cnt);
-        set_test_stage(test, 1);
-        goto cleanup;
-    }
+	if (isr_cnt == 10000) {
+		report_pass("No RIP corruption detected after %d timer interrupts",
+			    isr_cnt);
+		set_test_stage(test, 1);
+		goto cleanup;
+	}
 
-    if (vmcb->control.exit_code == SVM_EXIT_INTR) {
+	if (vmcb->control.exit_code == SVM_EXIT_INTR) {
 
-        void* guest_rip = (void*)vmcb->save.rip;
+		void* guest_rip = (void*)vmcb->save.rip;
 
-        irq_enable();
-        asm volatile ("nop");
-        irq_disable();
+		irq_enable();
+		asm volatile ("nop");
+		irq_disable();
 
-        if (guest_rip == insb_instruction_label && io_port_var != 0xAA) {
-            report_fail("RIP corruption detected after %d timer interrupts",
-                        isr_cnt);
-            goto cleanup;
-        }
+		if (guest_rip == insb_instruction_label && io_port_var != 0xAA) {
+			report_fail("RIP corruption detected after %d timer interrupts",
+				    isr_cnt);
+			goto cleanup;
+		}
 
-    }
-    return false;
+	}
+	return false;
 cleanup:
-    apic_write(APIC_LVTT, APIC_LVT_TIMER_MASK);
-    apic_write(APIC_TMICT, 0);
-    return true;
+	apic_write(APIC_LVTT, APIC_LVT_TIMER_MASK);
+	apic_write(APIC_TMICT, 0);
+	return true;
 
 }
 
 static bool reg_corruption_check(struct svm_test *test)
 {
-    return get_test_stage(test) == 1;
+	return get_test_stage(test) == 1;
 }
 
 static void get_tss_entry(void *data)
 {
-    *((gdt_entry_t **)data) = get_tss_descr();
+	*((gdt_entry_t **)data) = get_tss_descr();
 }
 
 static int orig_cpu_count;
 
 static void init_startup_prepare(struct svm_test *test)
 {
-    gdt_entry_t *tss_entry;
-    int i;
+	gdt_entry_t *tss_entry;
+	int i;
 
-    on_cpu(1, get_tss_entry, &tss_entry);
+	on_cpu(1, get_tss_entry, &tss_entry);
 
-    orig_cpu_count = cpu_online_count;
+	orig_cpu_count = cpu_online_count;
 
-    apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT,
-                   id_map[1]);
+	apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT,
+		       id_map[1]);
 
-    delay(100000000ULL);
+	delay(100000000ULL);
 
-    --cpu_online_count;
+	--cpu_online_count;
 
-    tss_entry->type &= ~DESC_BUSY;
+	tss_entry->type &= ~DESC_BUSY;
 
-    apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_STARTUP, id_map[1]);
+	apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_STARTUP, id_map[1]);
 
-    for (i = 0; i < 5 && cpu_online_count < orig_cpu_count; i++)
-       delay(100000000ULL);
+	for (i = 0; i < 5 && cpu_online_count < orig_cpu_count; i++)
+		delay(100000000ULL);
 }
 
 static bool init_startup_finished(struct svm_test *test)
 {
-    return true;
+	return true;
 }
 
 static bool init_startup_check(struct svm_test *test)
 {
-    return cpu_online_count == orig_cpu_count;
+	return cpu_online_count == orig_cpu_count;
 }
 
 static volatile bool init_intercept;
 
 static void init_intercept_prepare(struct svm_test *test)
 {
-    init_intercept = false;
-    vmcb->control.intercept |= (1ULL << INTERCEPT_INIT);
+	init_intercept = false;
+	vmcb->control.intercept |= (1ULL << INTERCEPT_INIT);
 }
 
 static void init_intercept_test(struct svm_test *test)
 {
-    apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT, 0);
+	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT, 0);
 }
 
 static bool init_intercept_finished(struct svm_test *test)
 {
-    vmcb->save.rip += 3;
+	vmcb->save.rip += 3;
 
-    if (vmcb->control.exit_code != SVM_EXIT_INIT) {
-        report_fail("VMEXIT not due to init intercept. Exit reason 0x%x",
-                    vmcb->control.exit_code);
+	if (vmcb->control.exit_code != SVM_EXIT_INIT) {
+		report_fail("VMEXIT not due to init intercept. Exit reason 0x%x",
+			    vmcb->control.exit_code);
 
-        return true;
-        }
+		return true;
+	}
 
-    init_intercept = true;
+	init_intercept = true;
 
-    report_pass("INIT to vcpu intercepted");
+	report_pass("INIT to vcpu intercepted");
 
-    return true;
+	return true;
 }
 
 static bool init_intercept_check(struct svm_test *test)
 {
-    return init_intercept;
+	return init_intercept;
 }
 
 /*
-- 
2.30.2

