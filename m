Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4241C31E9F2
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 13:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbhBRMf6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 07:35:58 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54356 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbhBRL7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Feb 2021 06:59:01 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IA16Bs136764;
        Thu, 18 Feb 2021 10:05:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=t+3R5pgJIjLlnnNl4rgE5n5ibxQZ22hAk8W+prOmarE=;
 b=NCbm/ePttfFQcbPUvVgqSrtvFAMlDFnSVk/0hYwzYqd57lhrQJl8hbudPAaav46shVb6
 4qcBHX5O3pYDXjoquW14CVf6Br6TSMG6lYpXhtEASlVO4WvB7Eh66F/QQhxqVKLk3qD1
 rvMeUBfEGHkgKgLIL+oKsOV2/tR6ooS5AfHSaIqvnHeLz9JYhjOe/aq9Vy6Dy6md6O0l
 9z8hzgHhTgHNpDS2blzfXGtNseXqizr9xS8CUCrfrbbx2div59GvnRjz+q+brtAIrz7/
 2l50FGBOMkpGZVjow/3LIv17s69xUF8QdfdZnB+MWaemdcDfGPtGYrF4yFI347fWkn0+ 8w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 36p7dnn9vs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Feb 2021 10:05:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11I9xkJd109819;
        Thu, 18 Feb 2021 10:05:00 GMT
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2058.outbound.protection.outlook.com [104.47.37.58])
        by userp3020.oracle.com with ESMTP id 36prhu179f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Feb 2021 10:04:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F4Q4UH4ogjTYObvTvE3/XCpcsHmdCZvjW2BSk5Oykw/wq2xeMnlXhcIBW6mJe/6UhJb+A+OePbFh05mQRxUinDwUD2wLeJ38ltFSvKz2R8TNkUxUhoVedACdR2scmHM4QUPRGUPj2e7MckHyl5uEbjcrZ67d+74mJ8ZdanMmfAy9rsw71FwLOB3gFShpbAemOzQfIsVXob0w7BaThia2xe3RHSpkV2Wi4b7bZ18Ok7Q6C0YPSmaH54bkGgK867JYLcO6SlcQw0sxGofLCAmtkqGufZFfz8EOVVPRmhU2ORh6+vFAqXNZf/b4dX8LA/gRiUWLfwWsGvR4VWuzXBnwcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t+3R5pgJIjLlnnNl4rgE5n5ibxQZ22hAk8W+prOmarE=;
 b=oImjUEj0QLEo0wCOhhgB0QDPmREXBBb7+nUJRDAxUUPnVIQM62mJhmjExxJox9hHv2Jqd6RdJ/gl7Ilb4gD/N0vMh2JMDPIUCmfugyAnwU3D2T7idfKOeV1FPR1jcmF4n4MtV75nL4JQkzE0C5Ad9jLNvHWyBP6ZrlIW0hLxDagomDGRAyZ8qqlfcaYhtlgFzkKLxkPIo9CSJtM2vdNKLvTaoRW+/jhT6bvh7JJdLtBSXWrTDSFRRrTZPGwZVQY1SCatTY9n/pnFvTbkeTXPxXYsnncaNq2j87PIKDZ2Ty6v7efwSxlB0elhpE72KKV3FAQYobJHfq23orSxAvxEJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t+3R5pgJIjLlnnNl4rgE5n5ibxQZ22hAk8W+prOmarE=;
 b=Hq2LSvRPz+rXeoVu3vu7sybD/9b90+DeRokozSSjDZPvQ9nQGgT0wOM3R8ldCqQSMDrEsVq35ZyMM2wBzgCl962VZatGJvZSuFeU16Uc2oqkEDZH0ODF2aTNJgh3uNN7JgJzPyQLrVqNH/SHL4dAA91RbMlQBstnB21aXp7Bi2w=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3148.namprd10.prod.outlook.com (2603:10b6:5:1a4::21)
 by DM6PR10MB2427.namprd10.prod.outlook.com (2603:10b6:5:a9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.34; Thu, 18 Feb
 2021 10:04:57 +0000
Received: from DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934]) by DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934%5]) with mapi id 15.20.3846.027; Thu, 18 Feb 2021
 10:04:57 +0000
From:   David Edmondson <david.edmondson@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>, Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Edmondson <david.edmondson@oracle.com>
Subject: [PATCH] KVM: x86: dump_vmcs should not assume GUEST_IA32_EFER is valid
Date:   Thu, 18 Feb 2021 10:04:50 +0000
Message-Id: <20210218100450.2157308-1-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:8b0:bb71:7140:64::1]
X-ClientProxiedBy: LO4P123CA0416.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::7) To DM6PR10MB3148.namprd10.prod.outlook.com
 (2603:10b6:5:1a4::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from disaster-area.hh.sledj.net (2001:8b0:bb71:7140:64::1) by LO4P123CA0416.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:18b::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.35 via Frontend Transport; Thu, 18 Feb 2021 10:04:55 +0000
Received: from localhost (disaster-area.hh.sledj.net [local])   by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 2e495f13;      Thu, 18 Feb 2021 10:04:50 +0000 (UTC)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3337368d-fd3c-49b9-9fdd-08d8d3f4a587
X-MS-TrafficTypeDiagnostic: DM6PR10MB2427:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB24272CC26DBEA10F0B3829F688859@DM6PR10MB2427.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ks1ruvLv2FnU45ksWsSvnliPfxesObCIcVbx1hChU40lhG6kn0W8wM7GmyQP5pEZS/ariquNZq8m4M+AjXBuMhOakivHKIwfHMuVMGHdn8CHsYRzVm8nqwpX8vNvtmP6PlZQDF1Y2eYMArqyijr/Zy+1hzHGYFVda5VEiLG2OPtbqzH9Urzn6oH30And9XIsHSG4Wga3AAuSL5zS1cYk398/1tWGI6dCCsJa6sVTb9DRDxQI0ZBcJ0RWA9PX3tmZqiINbeZ5tJ8OgTFjvZKn9a7XzgkxTJ9Wj5hdxpywFHJKE1nGce7tNat5hLB/GyIU6mzclSq61jxNxUzCm+iBH4gT1gOIvbX9X1K7uJhCM/vQznjq/7y1G+sMvD9HQj4Vwt+4QkOn+epNDNC4PV7jcR6gYpUUVN+CI/ZI0x2Uyj1yKLRvmGQCHl72QI0HKz93cyiX+7PmIxStI/ZrKVIZtZEZ300q0hXJVkfUbUgGQuSxcOpLIUYBjAvwBVAeKLRbbLeLctGGLFN+/HBL3GlWzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3148.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(39860400002)(376002)(136003)(346002)(6916009)(66946007)(36756003)(86362001)(52116002)(4326008)(186003)(478600001)(54906003)(316002)(44832011)(107886003)(66556008)(66476007)(83380400001)(2906002)(2616005)(5660300002)(1076003)(8676002)(8936002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Wl67R7BXgm2Kne1+g0G7HD8rSzbEpc32N+TZTEuqFhsj64DKjurPLgcqhG8u?=
 =?us-ascii?Q?vVesq6XaP9Xcqkxs9uEMYmvB2vxFxRUsadhpOZq2V/vdSa4PKq8rDpfVMZuX?=
 =?us-ascii?Q?jOi6oiD7VG0jpdcH/ZYeE5tMi43nS49Gwp67o+MBiMOqzpvZFNK5eX7RbqZk?=
 =?us-ascii?Q?p8IwHGI0MY0xErmeYGKIhbqcHqF28WtQxri4vdElBxqs18HtqFqVmBmEoYMH?=
 =?us-ascii?Q?f/6gZbRZy+VPQZPe85D15UIpP5Dq5EQmOBSoHbpIR3WCC8C0PnIAKbF7yo0l?=
 =?us-ascii?Q?RSgOLJLgwDoZxLkkeSHxWrFLTSRYxFbPntCUdDDuH24Iuj2pdjhOJvsgZkM+?=
 =?us-ascii?Q?OSQ7PZ+tEEOkWIgAKxqLgsPpVQUpIUbKr5ojD7Kki+5FDNvd260x2VbJLzbG?=
 =?us-ascii?Q?MHbAmRLMihmn4o4Z5hGEwfAyWQEywWprWEtpwjF6Sr6MVbYCmaqVPF0wo85J?=
 =?us-ascii?Q?VvkxjgxPQy32z7Qo8FOT5Qlh1aUClcBDe4mk6CzedRv32qjpBalUgirx4LSw?=
 =?us-ascii?Q?gOg0TgPm99MjaY/+cvrEXvI70+fXjKLkFwTnl1C7GD42jY7OUAL2EKlE6w+X?=
 =?us-ascii?Q?xv6+9r0yb5eHPHzWuyavSCuUeuXOp70rocBUbrrDbe21c665wI7VIYWbhlKG?=
 =?us-ascii?Q?yxy9Rl04x1Qar7aIBWGxXegdmegcW9fRQOp1ZcYt0Sc4vuDhYjIasLB6JI9I?=
 =?us-ascii?Q?gZzuHMl2Y8mkN67zpStdaoBZ72sbWV8uBPVB/DsRHMlBIOxDF63CoQS/+bqB?=
 =?us-ascii?Q?lqvyqGDs+3ZoneYdhLARFGvTyj3GJiHapabaqYdIVfKISoLjJALKkqv/YD+L?=
 =?us-ascii?Q?82QUetV7US0qxi9c8zk65nVEWDyRWmCL9JDHHnX0brnFMTuMCStU1YXk/wkA?=
 =?us-ascii?Q?Iwk1n2F2X1n4yH5fklECB1j5uc8/eyuX8wR2/+UXkhQH8kUnrGdmN0GI06O1?=
 =?us-ascii?Q?rqTwKHRjcwFhDbwVmmLUAiFe0gnxdc/QwBTCyS5yx4/nAAAthtZ1U5/mdkS2?=
 =?us-ascii?Q?CCtZC3MACjIALeq1VZwXJbUAZxyBhn9aCTT1hikojLYDHKkv+S/dTBV9x0DQ?=
 =?us-ascii?Q?yfELP4z114ClNN3Pa6wQ5WTa9VWwc0MISCYMDUyUj+Udz7QlGxr6c6v2z8xw?=
 =?us-ascii?Q?U6/xTp1srZzKQO+yMFyx1WUspYuVNpJRMHcrbOOgPV9AhU83jk5khOKwlePu?=
 =?us-ascii?Q?J3yrbZVLdPLn3tnnQ3BqJJ26iTiJKjl/VEYjPjrNOMit+pPwnceebnij0IkV?=
 =?us-ascii?Q?76jJXcKa3UUX7j1FDgb2OjfG4RojZUubaNQC8IatltL6KPkJEFKDL2VBhzW6?=
 =?us-ascii?Q?X/0Ogxh56M9SKdCVUTdKjOETR4rztKdcBT6/ps7ImdOuEg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3337368d-fd3c-49b9-9fdd-08d8d3f4a587
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3148.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 10:04:57.7973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SBLXitLIIedDA8W0WNTP3LZwDS9WePgOmgy8NA492/wW/hufO5vH1HD0aJXDcglot2f7uWCcc0InugpwxQvYB/Dl1wZZSj0RhRXF3M34jno=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2427
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180087
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=1011 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When dumping the VMCS, retrieve the current guest value of EFER from
the kvm_vcpu structure if neither VM_EXIT_SAVE_IA32_EFER or
VM_ENTRY_LOAD_IA32_EFER is set, which can occur if the processor does
not support the relevant VM-exit/entry controls.

Fixes: 4eb64dce8d0a ("KVM: x86: dump VMCS on invalid entry")
Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 arch/x86/kvm/vmx/vmx.c | 14 +++++++++-----
 arch/x86/kvm/vmx/vmx.h |  2 +-
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index eb69fef57485..74ea4fe6f35e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5754,7 +5754,7 @@ static void vmx_dump_dtsel(char *name, uint32_t limit)
 	       vmcs_readl(limit + GUEST_GDTR_BASE - GUEST_GDTR_LIMIT));
 }
 
-void dump_vmcs(void)
+void dump_vmcs(struct kvm_vcpu *vcpu)
 {
 	u32 vmentry_ctl, vmexit_ctl;
 	u32 cpu_based_exec_ctrl, pin_based_exec_ctrl, secondary_exec_control;
@@ -5771,7 +5771,11 @@ void dump_vmcs(void)
 	cpu_based_exec_ctrl = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
 	pin_based_exec_ctrl = vmcs_read32(PIN_BASED_VM_EXEC_CONTROL);
 	cr4 = vmcs_readl(GUEST_CR4);
-	efer = vmcs_read64(GUEST_IA32_EFER);
+	if ((vmexit_ctl & VM_EXIT_SAVE_IA32_EFER) ||
+	    (vmentry_ctl & VM_ENTRY_LOAD_IA32_EFER))
+		efer = vmcs_read64(GUEST_IA32_EFER);
+	else
+		efer = vcpu->arch.efer;
 	secondary_exec_control = 0;
 	if (cpu_has_secondary_exec_ctrls())
 		secondary_exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
@@ -5955,7 +5959,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	}
 
 	if (exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY) {
-		dump_vmcs();
+		dump_vmcs(vcpu);
 		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		vcpu->run->fail_entry.hardware_entry_failure_reason
 			= exit_reason;
@@ -5964,7 +5968,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	}
 
 	if (unlikely(vmx->fail)) {
-		dump_vmcs();
+		dump_vmcs(vcpu);
 		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		vcpu->run->fail_entry.hardware_entry_failure_reason
 			= vmcs_read32(VM_INSTRUCTION_ERROR);
@@ -6049,7 +6053,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 
 unexpected_vmexit:
 	vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n", exit_reason);
-	dump_vmcs();
+	dump_vmcs(vcpu);
 	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 	vcpu->run->internal.suberror =
 			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 9d3a557949ac..f8a0ce74798e 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -489,6 +489,6 @@ static inline bool vmx_guest_state_valid(struct kvm_vcpu *vcpu)
 	return is_unrestricted_guest(vcpu) || __vmx_guest_state_valid(vcpu);
 }
 
-void dump_vmcs(void);
+void dump_vmcs(struct kvm_vcpu *vcpu);
 
 #endif /* __KVM_X86_VMX_H */
-- 
2.30.0

