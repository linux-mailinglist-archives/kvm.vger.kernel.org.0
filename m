Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8961B671F93
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 15:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbjARO3N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 09:29:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbjARO2u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 09:28:50 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2114.outbound.protection.outlook.com [40.107.8.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879DC166F4
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 06:15:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JVowyRNRwagpJfaBXJJ7Mz181Z/OqXN5E7+ycgW7jdRdvdN+sNOxuC5355pNEPNBT9/e+Ft4qwZ6VZuD/cQVre0Jo25GZTjAG6QELJagw+w60EUvW4FmMdOYaae84JmKAo4WN9K4hLVk7GHwQHqXZRc2KsHUfJeXmQjQWJKrGrVAijS5+okTOGaz0peUhjmmL+0QK5Fs2/IHCpkrsnfNa49p11PK+7Uu1HfhNPaULURjeSY50aD35xQvj63X9DdzVdnhGc5teP25/+BZfqli+Dt3cXvtrMjZzpsbEvT66vRiSDRSwQTa4WoU92MbHrEABDq0Ctp63wCyDoNgQ8PqXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iurk6kN/cHi+iTitc9lHjcIrXBtaER2BGJEdStnP9D4=;
 b=lofUfYVhUCR66mnyZA82RolqVXPq9BhwQQCUD4hxUboJgeFOTQJ/2nTfjBfHPJjirCcSBOLMJEMqJL+sdQH7rkSB360OT7y1Gy28bbgnrn7iiUeffePZIV/cMPqaExVHdfHAbH79zHpFaxzjXFtWy6f4//PxE7cVtJ6zRBbuNt8wYsXFLgNINMpowD6BI8GmpeETpd9rAdR6KwzyE62KDgb7BlJXyIMGeJL8uQiuRAW5JKY0mP93hW6sp8tDxR/hih6V7bX6SfaMX+Joahuk87gnja3lV4I8HR1biCvfmJTMTFa05pu9Yp4OWkk4MDVuO6KvDKkAzVGvrWuaoo2uog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iurk6kN/cHi+iTitc9lHjcIrXBtaER2BGJEdStnP9D4=;
 b=qbnjE5O5QW6xRjbCi5xUjcmc4Qm/uqVU1BgBhbk0lubSSShvrRsuDrXONcLydImzZzWK1zyandfKSavm63zO2hy5/WNQWslRgKU9JIPyledgp/lIwPc4KB4vhKRGzposaWNNPyP3u9JTstfO1+721tCLuRD1eJhbu+5S0xidXrucOW9Z9YXei14fasO64BBXyKYzlcFdt1U1alkW3QXAFHGIOJ5Ein41+Asujmey/LiFp017Qj/BzC4+MfQ5lns+pNM3dB1HnwZQN1E13CSmGGQrhQRTwytIbi9MM2OuO0i6awEPOr3Onb9flRnO5JbH3h49rUTNZP1C61WOwBXDBA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by PA4PR02MB6509.eurprd02.prod.outlook.com (2603:10a6:102:d7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 18 Jan
 2023 14:15:17 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::e4e:96d4:38b1:6d]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::e4e:96d4:38b1:6d%7]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 14:15:17 +0000
From:   Alexandru Matei <alexandru.matei@uipath.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Alexandru Matei <alexandru.matei@uipath.com>,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: [PATCH] KVM: VMX: Fix crash due to uninitialized current_vmcs
Date:   Wed, 18 Jan 2023 16:13:48 +0200
Message-Id: <20230118141348.828-1-alexandru.matei@uipath.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR03CA0060.eurprd03.prod.outlook.com
 (2603:10a6:803:50::31) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|PA4PR02MB6509:EE_
X-MS-Office365-Filtering-Correlation-Id: af286d30-24c1-40ef-02e7-08daf95e6c73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YKy95+HHaSqqseoU6Qn+DnXAcjZR3byL0HKCULZv38+yf6cT3Rz5IV8kKUuodeCY73WGpY6Pb4e1VSa3m9G1WzNxD83NBuNUS7h2sFSugVtY84PAUvRSknG8dtoB8Y2nTQxzJ0rshvvwzzp/10kR0TFgsfhDPfq0I7RvT4KEI9+Mo9qSm8Z0jTm+pEWzMNBAoJfKduZqwY1Nzf59UhwvmQ2UHUcZx5zXlQjRGnpc8oj8IW1LV4NNA8o99KhdnibS28EYc+75TALN3JfLHQE3MjsYqlD3Mn0nNonih1XyrYnc62L0Vj9ByqDiGAM2TO366NxEdkPtbpi/o458C8mcu1orF1UfV+mF8EI9h72XVDND73oXTOETt+a8Nea/zhCEK3TyqpfbOSAUmn7d3FNBZag6G1TgRMzXELW/up89b6gOKTo+P/adwmJacALavCIEN5oUWbtz7TCZatZgzubnyRLYdPFnfXx6eyXeWfRvaMzxhmxzHFNwqkG88As3OJaT4gLvc8Cy29hKpHwuzeEvju3nCqo2lnERXqng70Fo/pqIHVahzaW7p7SrQ7foANnG6IIPRuprB0oqN0q4ilMuEMhLcLT8jjKstfdZ/q5wBR2EZ2hwlHmBafPSv6du1NB1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39860400002)(366004)(376002)(136003)(451199015)(83380400001)(110136005)(6512007)(6486002)(54906003)(36756003)(478600001)(186003)(38100700002)(2616005)(1076003)(86362001)(107886003)(8936002)(44832011)(6506007)(26005)(6666004)(2906002)(66946007)(66476007)(8676002)(4326008)(66556008)(316002)(5660300002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0m4Gjov4vh8AbSJVG/guBtbkEliR3Bpp4v5C200FNvC2N+1dtSvspgYFwxKE?=
 =?us-ascii?Q?J3rg90AuVlTWxcK63NOmoQHvDcT6R4+HjEmyfHYJdigAGByK8ZKhHLm/F4/x?=
 =?us-ascii?Q?rqEB0Fl3Ns+Kl+w5Oq+VUJ+v3IOkG4L0KDr0gd0QqnsVqbbv5vsMqW/UFcWU?=
 =?us-ascii?Q?T86IZQDQ7ojH25S6vNH/fa+Op+zxqJexhbj1oOVPPuqdjjdqVbOr2rsofPTp?=
 =?us-ascii?Q?H44xgw2setXOhWfSL1meehmNGNrVEgnxCkmnnRcxUmfZtog+QPqjhUh7Epyw?=
 =?us-ascii?Q?He6BKX3sJo6rQ75vCpmYNcT6JsfkR2PQwCXt4sFEdpnkU7YjPSrP0lRO3vuH?=
 =?us-ascii?Q?jTHBuVkSaS1N0CYFbhyfEFJLMb88Ndy68MHw/pU1XFk2oLfzDLDbwPiFX0Z6?=
 =?us-ascii?Q?B0sImENqjgvK4mUEvpmMBjXUnQAR0XklT3C0cWt8QeYpwP8lL2S9TYSxAD93?=
 =?us-ascii?Q?MfhEH/WS+p0KJLas4wMV3gBV9N5ssul5NrP3Ydk8/bq4da28LssLH9sroA6D?=
 =?us-ascii?Q?o9CKHgqsaOVr11ezcNjhIEPGEW9xjJRbJYbTVuyX6AGdF6zUa2G9fRFis9Xj?=
 =?us-ascii?Q?N5VAeah4SbB7wsJbTctDUcsL7KZdvMB+IGOAS8NrQB9ffCRpDG5isKgfwJ1V?=
 =?us-ascii?Q?HLy3M4Z+swL71GXjgFwLlKQ6zX3kJjiV6EvrGu9IcN7ZrGFvt2a1DaSpKXdt?=
 =?us-ascii?Q?JqMSkyGlqkfsmeUIuICu8t82lbTfYUUKi1fO+Y0WlEftXss4VYD2f+ECombf?=
 =?us-ascii?Q?dwZm83187fHBfBb67VfjImIZ1cV+wG18eTrtFLROhxFEIng1Es3Ac94ReUmN?=
 =?us-ascii?Q?YCmTLcXTcGJtcLccSeWTis2vt/IrgIag0PXk1pqBGfLY3fEN5OBtKSOUdvAq?=
 =?us-ascii?Q?diVJKHS7YGGu2r/sOpG2spY/nm6fpQ6b80t3fL2ZqBuj46DZDzke4A1MXA43?=
 =?us-ascii?Q?/Zk2O02bHl6WRCsmqEO/EAcdhi4sbwfI/P3W0kK8lVy4f3X6jpj9noYkF8gy?=
 =?us-ascii?Q?uReQZGnwQr+r4pijCNiVOEqf24ola4mRWD3tWV90yMFZrXqgeqSqjJ1nOjVM?=
 =?us-ascii?Q?4mmfy+QH64MMyo9DFEwcN39h1Zlopt+S5dRugP8vs3G+CVPkSQF7S8kp+lKY?=
 =?us-ascii?Q?LYwkli5UpNo9ZNC5CGQSpv5YC+w9xB9nsFaT8zOTsZlEevjK1U5whBUOFu5h?=
 =?us-ascii?Q?f0jAipEHiXa6yKYz/zDA6BiXWUQHt9P8x2X4eaBlCyFtDY4PvqyoTwn0ksZa?=
 =?us-ascii?Q?CCbq3b/3cKLPhNQn4IuCsSkK3Z91fHL7OfGz4HaxLWfrXFWJ3WeeTrt+Ab/r?=
 =?us-ascii?Q?a4KKJgbbyKAeaofIgYLE3GB3xXDidhojqn5Wzny9JOHZTxXwH6Zi+Msq1fSv?=
 =?us-ascii?Q?FpQ3+9g0vgrz0LsTUvmAo2scHnHtA4TkCtatWWgxoIEyqNHoo7O4WjQ1bS0H?=
 =?us-ascii?Q?x3uSbP3o9zgkqXkDltQZ9HHhFaff6BFPgDm1HOMv1V4fzaauZ9Dhq8uXDj05?=
 =?us-ascii?Q?kVTYlpgJT809S7k5KsN1gS6j+CTS/cAIpgoSA/K2XRE1xajlMp4uYDMPQHEJ?=
 =?us-ascii?Q?JdIOhnhlzeR1zwI6YVJ1caYQMgcFsMAIfA+3Ke1sRBAHV5LS6tSV30RljKbv?=
 =?us-ascii?Q?1g=3D=3D?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af286d30-24c1-40ef-02e7-08daf95e6c73
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 14:15:17.1190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bb41x0sPEGRuw3cFpvx62oKZbvrMnJ+D90BzDpGe5SxDDdjnWzEorlblvAjRdxMnSr7XZGBBChJoe0YUz+j4Wq7SEwDnydJQbkA4+1TbkP0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR02MB6509
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM enables 'Enlightened VMCS' and 'Enlightened MSR Bitmap' when running as
a nested hypervisor on top of Hyper-V. When MSR bitmap is updated,
evmcs_touch_msr_bitmap function uses current_vmcs per-cpu variable to mark
that the msr bitmap was changed.

vmx_vcpu_create() modifies the msr bitmap via vmx_disable_intercept_for_msr
-> vmx_msr_bitmap_l01_changed which in the end calls this function. The
function checks for current_vmcs if it is null but the check is
insufficient because current_vmcs is not initialized. Because of this, the
code might incorrectly write to the structure pointed by current_vmcs value
left by another task. Preemption is not disabled so the current task can
also be preempted and moved to another CPU while current_vmcs is accessed
multiple times from evmcs_touch_msr_bitmap() which leads to crash.

To fix this problem, this patch moves vmx_disable_intercept_for_msr calls
before init_vmcs call in __vmx_vcpu_reset(), as ->vcpu_reset() is invoked
after the vCPU is properly loaded via ->vcpu_load() and current_vmcs is
initialized.

BUG: kernel NULL pointer dereference, address: 0000000000000338
PGD 4e1775067 P4D 0
Oops: 0002 [#1] PREEMPT SMP NOPTI
...
RIP: 0010:vmx_msr_bitmap_l01_changed+0x39/0x50 [kvm_intel]
...
Call Trace:
 vmx_disable_intercept_for_msr+0x36/0x260 [kvm_intel]
 vmx_vcpu_create+0xe6/0x540 [kvm_intel]
 ? __vmalloc_node+0x4a/0x70
 kvm_arch_vcpu_create+0x1d1/0x2e0 [kvm]
 kvm_vm_ioctl_create_vcpu+0x178/0x430 [kvm]
 ? __handle_mm_fault+0x3cb/0x750
 kvm_vm_ioctl+0x53f/0x790 [kvm]
 ? syscall_exit_work+0x11a/0x150
 ? syscall_exit_to_user_mode+0x12/0x30
 ? do_syscall_64+0x69/0x90
 ? handle_mm_fault+0xc5/0x2a0
 __x64_sys_ioctl+0x8a/0xc0
 do_syscall_64+0x5c/0x90
 ? exc_page_fault+0x62/0x150
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Signed-off-by: Alexandru Matei <alexandru.matei@uipath.com>
---
 arch/x86/kvm/vmx/vmx.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fe5615fd8295..168138dfb0b4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4735,6 +4735,22 @@ static void __vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_TSC, MSR_TYPE_R);
+#ifdef CONFIG_X86_64
+	vmx_disable_intercept_for_msr(vcpu, MSR_FS_BASE, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(vcpu, MSR_GS_BASE, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(vcpu, MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
+#endif
+	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
+	if (kvm_cstate_in_guest(vcpu->kvm)) {
+		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C1_RES, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
+	}
+
 	init_vmcs(vmx);
 
 	if (nested)
@@ -7363,22 +7379,6 @@ static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 	bitmap_fill(vmx->shadow_msr_intercept.read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
 	bitmap_fill(vmx->shadow_msr_intercept.write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
 
-	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_TSC, MSR_TYPE_R);
-#ifdef CONFIG_X86_64
-	vmx_disable_intercept_for_msr(vcpu, MSR_FS_BASE, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(vcpu, MSR_GS_BASE, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(vcpu, MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
-#endif
-	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
-	if (kvm_cstate_in_guest(vcpu->kvm)) {
-		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C1_RES, MSR_TYPE_R);
-		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
-		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
-		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
-	}
-
 	vmx->loaded_vmcs = &vmx->vmcs01;
 
 	if (cpu_need_virtualize_apic_accesses(vcpu)) {
-- 
2.25.1

