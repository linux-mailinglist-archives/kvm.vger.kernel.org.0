Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128FB323F9D
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 16:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235856AbhBXOOW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 09:14:22 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:59044 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232350AbhBXOHm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 09:07:42 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11OE58LJ018083;
        Wed, 24 Feb 2021 14:05:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=Xpw/yhtG2V6Muoah1BF32QpLvcA/5dBWSpMW/TK0kEI=;
 b=Qy8goXnXpwmkDO/g1ftNVb+TGB7BN7t1Etb00bjnc3LgDJ3oa86DOWn1JhJDfmYh0NMj
 jhWE+jkVImW02b/uhUFdQPJkkobbfC24OxWWjz9dXylnx8uEqoimX4U0w0/6+q7w90MM
 NlSfzG8f0hBNtu8NOq73RhztxbgJnZ3eUDWLOiNjBwtNxm6yQ429Ekj9koPZGcmAh8/+
 R6cwuZtNCWYHbA3/5S9Jnob9o5furr8C38+EcK1mpwzPYppPoCZyE6zwGP7ZGBkm29Ti
 9lWiSIo5J8/Jig5SbwIDDxERvSoAC+s2YJQpQFsk4XOu4sZDinPgEXnOY5gk/Be80Et+ lQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36vr625bwv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 14:05:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ODscsj012587;
        Wed, 24 Feb 2021 14:05:08 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by aserp3020.oracle.com with ESMTP id 36ucb0sbe5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 14:05:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OOzk64z8SrG7SQ1YHK7yLQmvixHuWg2MX5Hgv94QkRkqi1Z5IsIuU0R8vDONujatmhzT+unFj9ugjSs3eomAVnX7RiNpQXaqUI5Dph8RiGFO/GpusOs6AB4pAXqfES+/PLYJCjh0jSGgmKfB/HWsK8r5Ht2M0430+loOqav3nZKnLhf6lAHAXDTukvqlsyeciqTcSkb1ziQs8Dcl+MWe9q/KKqgpeArkMCk2ansAa9n90lMrOPuDWDKC5MZ70hQhzCVc18eLV/UpS7JWWn42QWfSakINoluTQibzJ+8Vv0TxwMwBex62cB7IQYV2d+2hk33Z6+yMYntvUg0mabTDIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xpw/yhtG2V6Muoah1BF32QpLvcA/5dBWSpMW/TK0kEI=;
 b=jqgFH9w5lBfZiGrexmMAOvLSimaF6PS10El8bHw+Tc2F/HotOMYqnYIDKP8njWKA1BN+o+VyFJv5kJw2V/xdZDcg3MjfdKXbbd+EavGE6w7Y5GzciSRNOVohJXxMqJf2r+9egkoge0jcjH9e4C3AmurUDREx4TfJLlEBURbEwxTNfoU7vMDbGqu1NgjtAZ3hL2SI3O+plbaPDUHQgf/8Pt7yvzFFHyb7URKJOp2TuI8ca1URG7CVFE7yNI+j+6OGUoaeL1yROzHvqpDultZENSEHrvtZjrUEvnbSGAJx8HOgU9tee3kvYheCUeIBIUigOxIsJ5MpJpTvRavQO4npoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xpw/yhtG2V6Muoah1BF32QpLvcA/5dBWSpMW/TK0kEI=;
 b=sEnJOI6JltvaFvmr/YKPcIABeHGRSVXb6Jcn9XYYAvIF+5NpmbOXuuD3Iai4jBbzqROqf+U76fxBB8zmXqcXenDB80iTEDgmaceHcilwac69IX/dCL/xtiD4307hn7bw+zyxZjChckey2J5h4L6EtI7sNDJk12xtc9+mRO9SszQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3148.namprd10.prod.outlook.com (2603:10b6:5:1a4::21)
 by DM5PR1001MB2153.namprd10.prod.outlook.com (2603:10b6:4:2c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Wed, 24 Feb
 2021 14:05:05 +0000
Received: from DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934]) by DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934%5]) with mapi id 15.20.3868.033; Wed, 24 Feb 2021
 14:05:05 +0000
From:   David Edmondson <david.edmondson@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, David Edmondson <david.edmondson@oracle.com>
Subject: [PATCH v4 1/5] KVM: x86: dump_vmcs should not assume GUEST_IA32_EFER is valid
Date:   Wed, 24 Feb 2021 14:04:52 +0000
Message-Id: <20210224140456.2558033-2-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210224140456.2558033-1-david.edmondson@oracle.com>
References: <20210224140456.2558033-1-david.edmondson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:8b0:bb71:7140:64::1]
X-ClientProxiedBy: LO4P123CA0411.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::20) To DM6PR10MB3148.namprd10.prod.outlook.com
 (2603:10b6:5:1a4::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from disaster-area.hh.sledj.net (2001:8b0:bb71:7140:64::1) by LO4P123CA0411.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:189::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.30 via Frontend Transport; Wed, 24 Feb 2021 14:05:02 +0000
Received: from localhost (disaster-area.hh.sledj.net [local])   by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 944eff70;      Wed, 24 Feb 2021 14:04:56 +0000 (UTC)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e68395ac-0e4a-410b-7075-08d8d8cd2f58
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2153:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2153D596061B0EF9891252E5889F9@DM5PR1001MB2153.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wB4+ej7U034mHS0SHaNRvn8kwigRFLkUoSt+BewLaSlSYbPDShcIu54K7SpBN756L3dy2tNUKKrFEeleOD60Ral5LFQ17WBaAyY4HsEeVIv7fAj1jFelmOsLkyBHjyCvzOR+EMZWQnM1VVmhcVfQrrSujOev3FVvHfirpjvQ4wbHT2yFUdKbHLQJ0x34LfoGj7PYwB6Ow2531bWM9i1TY/QUmZgpQej3Jyce8uFUtdv12w0NtxObamdknRwuFxqyi1bQVoYP58U33xmhHMCLzbpZazzVjHsfvTDqIJO5LkEQ4g1B2eSzg+NbF1SsZHMg7hB0IMpGdhL7LeoLS5OKd42I5AE1gXoImF3jjnXi38J52lqt8c37GuXA94epnwKd3E1lTfVMQu2fXvCSH3RjRd2pm/VIseAkSSJ8SLH9PRbnjNfUorCieKaiyDmcifikU+13TLv1ciZNcql+jqCrFu7xWZ3E8Qa2ycyAORLkpr1B5wM30f9av7459Hg7mxt5leJwYIV79R/i1eN4hUan8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3148.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(396003)(366004)(376002)(83380400001)(316002)(66476007)(44832011)(8936002)(186003)(2906002)(86362001)(7416002)(8676002)(66556008)(52116002)(36756003)(5660300002)(6916009)(54906003)(1076003)(2616005)(4326008)(6666004)(478600001)(66946007)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2Ob9BIjMsmjxaRcKdwQ5+XOuud+YeB+17Wv8mZyJcN2KQqrOH5n+ndrW9mdR?=
 =?us-ascii?Q?Y24Fhyc52uO1+I8HT0StifxhfIwdcOYkhvsl2ClBYhRRfKqj9luKmK4vVfZh?=
 =?us-ascii?Q?KpL5v6B1GmmPrrPdmwKg6SgGjXf52Nakk2SpptehFeQFCt6P1T5vrUtq6lw8?=
 =?us-ascii?Q?pvXKSBjSRxKraxtFYswZDtMAoSj4bR5bqRhT2vYqRJswK/w4QNcGtVveepZR?=
 =?us-ascii?Q?y5pFGN3SWOOa9RNeRfLhA08XYfyPQVorBLqs43bScdFHSkZkMcD8IXIDFc8l?=
 =?us-ascii?Q?sb1ISoaSIejIw+XarawDMANqNOdhu8nINU93FhdXCkSPoOYA165ahHHKaoFw?=
 =?us-ascii?Q?W1FkdX9gyZgkwwHefaIYv2AZqVXq/7HjTb71x2VoucU5+QnaCduvRYcuEERm?=
 =?us-ascii?Q?6f+UN1qCHZbZVIX1ids0W4mkTszqDwbSfaIT7E7j29U6dNDrpR/wbluKu/rv?=
 =?us-ascii?Q?sMWm0e0bPvzzEzHCo07iPiyeyM/i2JEUquT6EnT5M+ZEg/P0T/DwPIZxdc7b?=
 =?us-ascii?Q?15BjLzg7Kla43FJv1TVskB7/ULmOH3OlTHJQr4YKC2S3EhzJJpkui/ZgMSEq?=
 =?us-ascii?Q?fmsx+7Doq/emaUKnSUhTwXR9s2L7qcNOMh9oBwyzsyc8xtA87NpOAsxjpR0a?=
 =?us-ascii?Q?5hBk8T9OVT3pBPz2r9DillSaQnnKX4PlJzN124hiXC/lziMe/27yX2+2aCgc?=
 =?us-ascii?Q?PMDC+dFcmZxqJqepcioFi+W1YfSG3Ns3Jt6gbyFSwJXyftlW93labRZAgeVH?=
 =?us-ascii?Q?f9KaWli8dnE3MdOvSEUPMEnDT3v9H0oAPBZ+hk8UieH1wrQ7OwP4FAYUaeNm?=
 =?us-ascii?Q?4RxFAFvLb6kuLFJRBNS8ePmeHKuTxZXuAX/QiV1gfC/YQkpLAowM+SxwP3JI?=
 =?us-ascii?Q?VHtJk/Oq6Ui8zjRmZQvg6h8qxdx5xXF3OoYfYCEfMVHLNgLmjpkAJpOJwsWs?=
 =?us-ascii?Q?/m25TgjgyQdU3Ork0wmFFf6W3BHprBDzt0NGZiniiVMMjgKinOpqMFlceyBZ?=
 =?us-ascii?Q?nzpfcLTPwq3rx2Zr8+J+bF0ci4pCv2rKcPrMzQ6PKrwPgwQJZazz4oxKqXiz?=
 =?us-ascii?Q?QyvDer1akLX7ErA9DSkVSavB2+e2W1Qu/ov1v3AfOYF+TK4K4S37eoSBcjKI?=
 =?us-ascii?Q?iJiw4eZyqCiclwD4VRNR1ecMWbpljGd+ZOBf7C0FulS5d8e/eKUTG1javXNv?=
 =?us-ascii?Q?H9CSYdGNzE1pnVmKRiuLbvs5bknLMGArS+VBaysjwgjrb29lIlROxV0SioRd?=
 =?us-ascii?Q?4CWQRiCCAAaAeH00yGH2fYYaPqSRFiVFwZSxOrLGszaunFsKR6tGWfk28eyr?=
 =?us-ascii?Q?9WYenOOQYpjTlEvHPEhMhTkZsuCWSNJpPXeILR+dUhIWYA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e68395ac-0e4a-410b-7075-08d8d8cd2f58
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3148.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2021 14:05:04.9784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ijYw2SmaYyLZPEWi++pqIU/zZoyLCGgK4Lt07nAK7IR41Ci/wbfLmGFdaupgBd3Xy0E8qLQBzCM8OkBxY0kOuLMNBOOiQI0rIzdrfTfIDKA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2153
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=966 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240108
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 impostorscore=0 adultscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240109
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the VM entry/exit controls for loading/saving MSR_EFER are either
not available (an older processor or explicitly disabled) or not
used (host and guest values are the same), reading GUEST_IA32_EFER
from the VMCS returns an inaccurate value.

Because of this, in dump_vmcs() don't use GUEST_IA32_EFER to decide
whether to print the PDPTRs - always do so if the fields exist.

Fixes: 4eb64dce8d0a ("KVM: x86: dump VMCS on invalid entry")
Signed-off-by: David Edmondson <david.edmondson@oracle.com>

if valid
---
 arch/x86/kvm/vmx/vmx.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e0a3a9be654b..ea1b3a671d51 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5815,7 +5815,6 @@ void dump_vmcs(void)
 	u32 vmentry_ctl, vmexit_ctl;
 	u32 cpu_based_exec_ctrl, pin_based_exec_ctrl, secondary_exec_control;
 	unsigned long cr4;
-	u64 efer;
 
 	if (!dump_invalid_vmcs) {
 		pr_warn_ratelimited("set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.\n");
@@ -5827,7 +5826,6 @@ void dump_vmcs(void)
 	cpu_based_exec_ctrl = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
 	pin_based_exec_ctrl = vmcs_read32(PIN_BASED_VM_EXEC_CONTROL);
 	cr4 = vmcs_readl(GUEST_CR4);
-	efer = vmcs_read64(GUEST_IA32_EFER);
 	secondary_exec_control = 0;
 	if (cpu_has_secondary_exec_ctrls())
 		secondary_exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
@@ -5839,9 +5837,7 @@ void dump_vmcs(void)
 	pr_err("CR4: actual=0x%016lx, shadow=0x%016lx, gh_mask=%016lx\n",
 	       cr4, vmcs_readl(CR4_READ_SHADOW), vmcs_readl(CR4_GUEST_HOST_MASK));
 	pr_err("CR3 = 0x%016lx\n", vmcs_readl(GUEST_CR3));
-	if ((secondary_exec_control & SECONDARY_EXEC_ENABLE_EPT) &&
-	    (cr4 & X86_CR4_PAE) && !(efer & EFER_LMA))
-	{
+	if (cpu_has_vmx_ept()) {
 		pr_err("PDPTR0 = 0x%016llx  PDPTR1 = 0x%016llx\n",
 		       vmcs_read64(GUEST_PDPTR0), vmcs_read64(GUEST_PDPTR1));
 		pr_err("PDPTR2 = 0x%016llx  PDPTR3 = 0x%016llx\n",
@@ -5867,7 +5863,8 @@ void dump_vmcs(void)
 	if ((vmexit_ctl & (VM_EXIT_SAVE_IA32_PAT | VM_EXIT_SAVE_IA32_EFER)) ||
 	    (vmentry_ctl & (VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_IA32_EFER)))
 		pr_err("EFER =     0x%016llx  PAT = 0x%016llx\n",
-		       efer, vmcs_read64(GUEST_IA32_PAT));
+		       vmcs_read64(GUEST_IA32_EFER),
+		       vmcs_read64(GUEST_IA32_PAT));
 	pr_err("DebugCtl = 0x%016llx  DebugExceptions = 0x%016lx\n",
 	       vmcs_read64(GUEST_IA32_DEBUGCTL),
 	       vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS));
-- 
2.30.0

