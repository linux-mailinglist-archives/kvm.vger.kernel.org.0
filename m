Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A064323F8B
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 16:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234783AbhBXOLI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 09:11:08 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41186 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236980AbhBXNbW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 08:31:22 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ODSwGd041976;
        Wed, 24 Feb 2021 13:29:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=47SAsAeWZxzj0pYLTV3E2eXscEeA4Q0xcedm5E5bEwU=;
 b=SadxG/28eZ3wgSl13HmsyTCQ30/cyteJCAMbZnpw6EtlBXMcuFByk0VwKjPQ9HYYgxbW
 SY2awUKP2UvrVWQci5IULRU36i8feu8IsCCNfM9cYNDX9OhwPut8en2I5mszyIMxLB5s
 eZUWF9cDfzqDiTccOXP4QhuzghyRTgcl6e9IjOFLeJ28FUFFes40iGRiOJ/ACZjHgtey
 6Ww2/y8ZQtvkKgOOJ2Rbw7ZRevtLaYEghi5j38+W1A9PQ56kX6VsY9eFvHRb5IAhwoiZ
 DuwPWgKv/BZmuEA+N/lhHKH7WJAxhTkKBzjfr7NMTjw4MouqFrurnennNR7zuk8VcJYN tg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 36ugq3hs4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 13:29:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ODOaJQ081673;
        Wed, 24 Feb 2021 13:29:33 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by aserp3020.oracle.com with ESMTP id 36ucb0r5vk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 13:29:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hqZoL5dPtauk9zeI1g/u9KdCxIVNhU4nAH7IhodtTX74PgQw5h34w2knpOjSfxXYf36wVditCWRd1jiUwlh58BqOBAbz4RgA0AFgTDtEVm27zfRGzwKW+8tFIrFFqqrGfOn1eRKFGsn6dESQinC22+be3TGCWjcMa2D8NXs/c/U6PMSAPwKwlj67W83NcWtWs9OXppeQVStseclw2cjF8n5NhZtUOm29kbNIAxeq2a7XTMqVbprbJ3CtVqzQ4vsVMpTuLC+Md3C7lM/o/rNYg6AGoz4VmggCqhSqg53DchdUmZewy8gWmgNNbEB85SOHUOsreKmxfmVVAGTrrHmYhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=47SAsAeWZxzj0pYLTV3E2eXscEeA4Q0xcedm5E5bEwU=;
 b=kNuhDOuETGoFYttGN11AE+TFBctbEtVQJhirfafTakOrI3W4VDUjYenusPaeVhICCsT/+R3f+USHDDZaGidNf7m2+0n2IQIdGRSAMi6gMb69SOHf6XbAYZhL59bMhHO7YT6wibz6Rgn7HhrSWpWFcjYEA3y7suQZf3lqh6rcR1boNfgNctDyjaZC2e+JDRUflizZruOHjusc5/h3/yaWv699kmtp+w3eK+X3ZKzD19ZxvXSs5cp2HCj/tWoVCnj3q20LN8u58IOynRMksWQ8p7UsmuExY3t5VgCCYI/T+pJlmwiTG/xWOi8OovQ9CRQS4u1j0gMe+NvPo9hgYgpLyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=47SAsAeWZxzj0pYLTV3E2eXscEeA4Q0xcedm5E5bEwU=;
 b=nJ9hEqyZSu7uHnBfnKi/gq75msr3EtjxtgYX6TqtiD0sjVYGIZ7No8iTPmz0C6RWKzLppIX5mdOMhtrera5gU9d13JpYK4FFg4yq/7ICshYwDYTED0QGdHiHiRRR8Bov7KeMgRQ845qfNG9W3WXjcdJ8gV/veIdMsDNhQzb4NoA=
Authentication-Results: 8bytes.org; dkim=none (message not signed)
 header.d=none;8bytes.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3148.namprd10.prod.outlook.com (2603:10b6:5:1a4::21)
 by DM6PR10MB4347.namprd10.prod.outlook.com (2603:10b6:5:211::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.29; Wed, 24 Feb
 2021 13:29:30 +0000
Received: from DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934]) by DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934%5]) with mapi id 15.20.3868.033; Wed, 24 Feb 2021
 13:29:30 +0000
From:   David Edmondson <david.edmondson@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: [PATCH v3 5/5] KVM: x86: dump_vmcs should include the autoload/autostore MSR lists
Date:   Wed, 24 Feb 2021 13:29:19 +0000
Message-Id: <20210224132919.2467444-6-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210224132919.2467444-1-david.edmondson@oracle.com>
References: <20210224132919.2467444-1-david.edmondson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:8b0:bb71:7140:64::1]
X-ClientProxiedBy: LO2P265CA0155.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::23) To DM6PR10MB3148.namprd10.prod.outlook.com
 (2603:10b6:5:1a4::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from disaster-area.hh.sledj.net (2001:8b0:bb71:7140:64::1) by LO2P265CA0155.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:9::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Wed, 24 Feb 2021 13:29:28 +0000
Received: from localhost (disaster-area.hh.sledj.net [local])   by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id e46fa011;      Wed, 24 Feb 2021 13:29:20 +0000 (UTC)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f44e696d-456e-4e1b-2c7f-08d8d8c8374a
X-MS-TrafficTypeDiagnostic: DM6PR10MB4347:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB4347519451C00AD6E59274C7889F9@DM6PR10MB4347.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mu0PE8waTqdijqLmdRQm1s/7rUBwGe8qOR/on4BUbRXjM4nEXkxcTUgLW3KdSlp8f5TgKTeONK77zBg6K8RUI8SQJDDb3/APLf1KFe1UPICUOLsEYm+lySZMI7eiz6Dv0qq5bRdHWreJMySUpDeoWHO6TGL4JC9SRKD3O3gFTv+4sMJNST0I6GaK+YMvw9Ag/xy1VDmo8o251Vj9mm/fzpyC4A9aRrNtuGrNlW5zchNAgG+ht5lTsL3GrhOu8X/Enm6RmUMXeoKZ+mJOL3yzzD2IT48KQA70XtFUJ9uBfgDL6AzRAhzenAwTtJaEXlrR14cXGiLZ6cyrsP3OdkIxpcEW49mko5e2UXPUfebpRM2phHwij3MntzsHhr/yNsq/cu9k3HD2KNPF5ROnB5PXRJr2/4X3/L8L3tBNtNxuvRtpGRdWqTQ+tDZM9OuhazAHFqcjuOMJztrwaJIgH8CR7VEWuGjfJbxpMPTCqoAla6RlXGrD8hl0TS3Q5Jy723jXhniPRXKrn/2hJZBb/TXI1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3148.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(366004)(39860400002)(136003)(2616005)(186003)(1076003)(5660300002)(316002)(478600001)(4326008)(8676002)(66476007)(66556008)(52116002)(66946007)(83380400001)(86362001)(2906002)(6916009)(36756003)(54906003)(8936002)(44832011)(107886003)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2whT0qPJi7QYOuamrew/gvuzfBPVr+LXmZKocSHBQn1zN0p8rASBZmTInJ03?=
 =?us-ascii?Q?1dTCWhrPuqVnsFP7AS0UVXtXDgRNhB2g9m0AD/Pw7GR3Q1LEx7JMPZEVH3LW?=
 =?us-ascii?Q?OvRik9Rin+0+pS0XTzV+g3cJZ8zxh+KZVjaBLNbZhT2h0TFNvMZ24aZbC38D?=
 =?us-ascii?Q?yJB0kSUum//1Q+Dg9Cl1WiwbTNoTYLOAaNYnY31j7KSJypUnk9QC2Wsdu4/r?=
 =?us-ascii?Q?ywPW3lT2mN3Odk3UvE08POvnPfaNQrStn+HUVd/RTKFNTrIWY+lWy2BruV0K?=
 =?us-ascii?Q?CsJ4fL4uZ6SpK5x6QTTapldh23Mpj/OU+cDUSgnqRpmlCWXOvza0XdKjLkPl?=
 =?us-ascii?Q?tDAhgGwoVtd67n5cbW6pAexYy0M1XozGOFacIfo+W3M+KQZD6Nw6+YjaPLYT?=
 =?us-ascii?Q?THPgDRj6AOfz76XrQm3N7P7H/De76wNccwQcqd2aVdxhis0W7F2WWDScuPIS?=
 =?us-ascii?Q?ai7tq7QWOF4fFkmc0H94eDrCFW4StOGsG2dPyLO5ILHnnHYKf6kfYlp6Uudq?=
 =?us-ascii?Q?iKyM4rjqyQ2WVKkAQiA2uLmB6N2qpuZVQEcA8LLfmkJZr7d/ajXgEupgIFCu?=
 =?us-ascii?Q?27EMt246dAkt9f9+LQn9gH9a2tCAxz/AKiRaLoWVUx2oK74GqI4QWVLcj2rE?=
 =?us-ascii?Q?5IYL+NNhmsfZ0KsVdgGxjSVutzsfpf6L7TABqDAJ7SbGy+F6qAGOiBOjD6qe?=
 =?us-ascii?Q?D3TRQiD3ig+VRdnjQ6ndEFutQVouCeYKsjSSf9IAiHfHiaMgmWPSi751jUUc?=
 =?us-ascii?Q?tci79qP9tlCG3mxcLi4GaAYrO2DgZukrj8fWkbmHxw4KFGzunuHzPXhXUXMi?=
 =?us-ascii?Q?VFc6n8ijsvxxIfCihHxjjoS8UjWKRk5FQYCHACBzGhSoruGI9lAf5+e8+mJZ?=
 =?us-ascii?Q?pXUdDafoiHWDHatMa2gsmOG/joef277ki06ryLXiiHZJOMmkSVjIwZ/WgrjP?=
 =?us-ascii?Q?UuDsC5i5H3GiiVz4SEzkjOjNsR441gpayHh9aEIL3gyA6wLTLXOI1PbPSIoq?=
 =?us-ascii?Q?OnUE4/Xv4ilxpLR3Be3DG5O4m6n0Cg9bLLc4UoLUpXWeLhXo6BdqHyf4bDLI?=
 =?us-ascii?Q?FUORZGIc23XUQCoK7oaUB5JE+WrhoTcbYQMtXFLrOOYBi+BIPyePEyqseW2C?=
 =?us-ascii?Q?M00yuj8/nYtz3EdXtBdsCxXQyzG0rAwAnXjgCZMv9PpecMzSutN2tUnws1TT?=
 =?us-ascii?Q?8rUhyMx+z/g4aL+JiAGcvHrtNoo1DCsqUvIqbMjnqo1tVynk6LXzgUojLqPm?=
 =?us-ascii?Q?bYbyxXgRp9UDHq1DXQHAf6D+Ty5inV/hyNoMf1bKYKeR1U93B4u8+qOvM/bg?=
 =?us-ascii?Q?gcltnSmCKRfbnaqj4VNG51nZpikH4nSPq9AdzMZj3cvSQw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f44e696d-456e-4e1b-2c7f-08d8d8c8374a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3148.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2021 13:29:30.7710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wJ4GeBvyDrnATWHIAiCcO+6JRTFLzJby1YJM6kQ2OAJrB4VyRs/+b+xMwLvyrdLUgBkLNCBAJi4cDsmm6xiYiYMN2yl+oy7wBcbJLPSH2XA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4347
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240104
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When dumping the current VMCS state, include the MSRs that are being
automatically loaded/stored during VM entry/exit.

Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 arch/x86/kvm/vmx/vmx.c | 25 +++++++++++++++++++++----
 arch/x86/kvm/vmx/vmx.h |  2 +-
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ed04827a3593..de42b8c14a38 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5810,8 +5810,19 @@ static void vmx_dump_dtsel(char *name, uint32_t limit)
 	       vmcs_readl(limit + GUEST_GDTR_BASE - GUEST_GDTR_LIMIT));
 }
 
-void dump_vmcs(void)
+static void vmx_dump_msrs(char *name, struct vmx_msrs *m)
 {
+	unsigned int i;
+	struct vmx_msr_entry *e;
+
+	pr_err("MSR %s:\n", name);
+	for (i = 0, e = m->val; i < m->nr; ++i, ++e)
+		pr_err("  %2d: msr=0x%08x value=0x%016llx\n", i, e->index, e->value);
+}
+
+void dump_vmcs(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 vmentry_ctl, vmexit_ctl;
 	u32 cpu_based_exec_ctrl, pin_based_exec_ctrl, secondary_exec_control;
 	unsigned long cr4;
@@ -5890,6 +5901,10 @@ void dump_vmcs(void)
 	if (secondary_exec_control & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY)
 		pr_err("InterruptStatus = %04x\n",
 		       vmcs_read16(GUEST_INTR_STATUS));
+	if (vmcs_read32(VM_ENTRY_MSR_LOAD_COUNT) > 0)
+		vmx_dump_msrs("guest autoload", &vmx->msr_autoload.guest);
+	if (vmcs_read32(VM_EXIT_MSR_STORE_COUNT) > 0)
+		vmx_dump_msrs("guest autostore", &vmx->msr_autostore.guest);
 
 	pr_err("*** Host State ***\n");
 	pr_err("RIP = 0x%016lx  RSP = 0x%016lx\n",
@@ -5919,6 +5934,8 @@ void dump_vmcs(void)
 	    vmexit_ctl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
 		pr_err("PerfGlobCtl = 0x%016llx\n",
 		       vmcs_read64(HOST_IA32_PERF_GLOBAL_CTRL));
+	if (vmcs_read32(VM_EXIT_MSR_LOAD_COUNT) > 0)
+		vmx_dump_msrs("host autoload", &vmx->msr_autoload.host);
 
 	pr_err("*** Control State ***\n");
 	pr_err("PinBased=%08x CPUBased=%08x SecondaryExec=%08x\n",
@@ -6019,7 +6036,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	}
 
 	if (exit_reason.failed_vmentry) {
-		dump_vmcs();
+		dump_vmcs(vcpu);
 		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		vcpu->run->fail_entry.hardware_entry_failure_reason
 			= exit_reason.full;
@@ -6028,7 +6045,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	}
 
 	if (unlikely(vmx->fail)) {
-		dump_vmcs();
+		dump_vmcs(vcpu);
 		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		vcpu->run->fail_entry.hardware_entry_failure_reason
 			= vmcs_read32(VM_INSTRUCTION_ERROR);
@@ -6114,7 +6131,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 unexpected_vmexit:
 	vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
 		    exit_reason.full);
-	dump_vmcs();
+	dump_vmcs(vcpu);
 	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 	vcpu->run->internal.suberror =
 			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 12c53d05a902..4d4a24e00012 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -541,6 +541,6 @@ static inline bool vmx_guest_state_valid(struct kvm_vcpu *vcpu)
 	return is_unrestricted_guest(vcpu) || __vmx_guest_state_valid(vcpu);
 }
 
-void dump_vmcs(void);
+void dump_vmcs(struct kvm_vcpu *vcpu);
 
 #endif /* __KVM_X86_VMX_H */
-- 
2.30.0

