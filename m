Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3AFD31FB34
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 15:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhBSOst (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 09:48:49 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52406 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbhBSOsh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Feb 2021 09:48:37 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JEiHRq111906;
        Fri, 19 Feb 2021 14:46:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=qSdaWzW5cW8G5XAjhyJLFR1zacYsNYVnJkFu9y6tB2I=;
 b=nlVoSlsWhwtDHZdpxgKxONsmwNRgkIbSi7BMwbuURH6Fxf1c82xvgjRJsNRtf+egJnNT
 2sZZ2ZG17dMski+LvfXb6Ulk2mhPk4nx8y5GyOALR9rOT644FfuHDekeIkkcPePWCJNg
 uG8HTb0v99X8p6InRpuhjs9KByiBVl1aNTy/qXfweZdURJHjLdBzJFg76uVzLc8kHtym
 hZsqtG+Opq1haKEQAwXdJV1EUQ6lgBhHydBPXkagQslKS9jMG3ED5+jG/LyfzX11b/Xk
 Z64AljQ3YZ+yOerAOIX4X+mi+G2ajqUWC3ECw2dpmsfH+fWMweohbh12i2ljM3nVCAbr Dw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36pd9ah87f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 14:46:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JEkKfT112347;
        Fri, 19 Feb 2021 14:46:44 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by aserp3020.oracle.com with ESMTP id 36prp2yfsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 14:46:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JFONimb+hmI3GxtrM57orRREZZfySd3s2ill1hRZ3+lplFGNgGfjE/cgyiZKhr/M8w9Qqo4eLqw8s6eJ3yDqKsZ/8EG4xTkacPOTha2YPckVsbyM8fTeA8yGxmBvpvoeqzWMa5Zt5gz7aUtDoYOJ4ofMGrP8tCxDo/bigWJiYlF2ltoDN0j/5lnn7etYH/6SgecDYJXutvrSMezB+fuEe24Imco5WF+7ekW0oNMPGexXdE/2mA4brGSt9AsX3hY9/0fUGpE6GXD84v2hSUb2fC+Deq8q8E+Uiqd201FmN5CVLVWgC7qk0zKoz7lGO29K+1SI6Qqif5nmJAcLR5VeLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qSdaWzW5cW8G5XAjhyJLFR1zacYsNYVnJkFu9y6tB2I=;
 b=FNUZzcJxvV3xZSgEfpTxXT9NRElOOdEXaTlfBgX4YUIHppJwQ4xtmMYpU45Jk+++KI6aXUUhey/UFrNmf2B4MaDaKRp9OOWgaj9NKMDb9H3r3iDKlw79V3hOjK9OfVi9p+9xIqAWc0I/1BLAIyw22t8qR3rtdUvVYnnSegR+wvESn+6wy7XVjI5iwDsP7+YwW4+FN3UbhRxIXXR3fL2EQCu8LVdsGMAkkK2eCdWstXJnEF7qrzxM7/0oLov3yXzv7IuvbWAWy5sBMYhVJ4yO0t072T6JgDhPi7RTYR4LR0JkdsgG31q5iDWMIy3/4UVm6iSGXblC2kj3UCSz1jeXvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qSdaWzW5cW8G5XAjhyJLFR1zacYsNYVnJkFu9y6tB2I=;
 b=vEQB7x98m57fW4peUP8SYQMxNxnAihq4UfINySnCdW2wxBcCklL0kd9Nnv3s3mOylfIK8MQsRuZaO9+Ufw3srxYBR3zqf7ADFIhkUVoWV6Fj1GqFJTF/1R43Ki7VvLZhKQs5J7T6Xhni9rjYf71YuoB7bKjpM23WzfWTPgHH6Ts=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3148.namprd10.prod.outlook.com (2603:10b6:5:1a4::21)
 by DS7PR10MB5280.namprd10.prod.outlook.com (2603:10b6:5:3a7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Fri, 19 Feb
 2021 14:46:42 +0000
Received: from DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934]) by DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934%5]) with mapi id 15.20.3846.027; Fri, 19 Feb 2021
 14:46:42 +0000
From:   David Edmondson <david.edmondson@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: [PATCH v2 1/3] KVM: x86: dump_vmcs should not assume GUEST_IA32_EFER is valid
Date:   Fri, 19 Feb 2021 14:46:30 +0000
Message-Id: <20210219144632.2288189-2-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210219144632.2288189-1-david.edmondson@oracle.com>
References: <20210219144632.2288189-1-david.edmondson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:8b0:bb71:7140:64::1]
X-ClientProxiedBy: LO4P123CA0428.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::19) To DM6PR10MB3148.namprd10.prod.outlook.com
 (2603:10b6:5:1a4::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from disaster-area.hh.sledj.net (2001:8b0:bb71:7140:64::1) by LO4P123CA0428.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:18b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.38 via Frontend Transport; Fri, 19 Feb 2021 14:46:38 +0000
Received: from localhost (disaster-area.hh.sledj.net [local])   by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id e8c9f414;      Fri, 19 Feb 2021 14:46:32 +0000 (UTC)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96188673-0a66-41be-454a-08d8d4e52a82
X-MS-TrafficTypeDiagnostic: DS7PR10MB5280:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DS7PR10MB52809B6159B48B198952782288849@DS7PR10MB5280.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: De37E6NRFGkJ+jqCMb8+uULTi7B5FOoinV9MU0y0C+iQw0kWYjDVHWs6DqfB/jtqMVrKmjkBGvbOiEJGeser48I9aOjow3l+J/88q1LX22lAZUKQok2DyPr1BMyAIvoaKxH6xtGGWlIa1aIpUqRIRrj+5b7lRCr22PiugXFT9wucl+22pgcwvnHyPAHz8tNdMl/d4MRv8m843myEFQZNiD+tSGzXRHtKT/9CKdyJ564x3cyAfirnqmqJ+E7njosjOmKCMuocUq/ss1w5+k+zMMgi1/ySOzLq1DC298IlPirn5buhNAgZOQv6rqT+xrD/Kxv5Xn3FO5J9qFovJuwgaMWjBKSlZ0AtHvizarjBX6NoWh13dkvx491RaKiu01Mn+2ttKqy8cr3DdyFmVKqCzGXDr25WZZ2+nLdifXFcWkrW7hmoxSM6BV+6EFvAGWIJL6psJwryFalAJu0K2OQDiwP0YZZhJcGrArwSN+JwpKpA08Lk6f6kgu/uqA2igEf62gIkagNGmrmnKvel5xgsuA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3148.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(136003)(376002)(346002)(86362001)(44832011)(54906003)(316002)(6916009)(2906002)(66556008)(7416002)(8676002)(186003)(8936002)(36756003)(2616005)(52116002)(66946007)(107886003)(1076003)(478600001)(66476007)(5660300002)(4326008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IWdMuuZkXJO2bvA9CZzaNc55ajy8vY91uDz9rjCuH3nyYLb7zI2H9HkveHFd?=
 =?us-ascii?Q?nSPk/cTzc91rhwRR53R+3dfq3EZPoV3ErIl3myv5MSEe+3ybceLYEmuXAR9J?=
 =?us-ascii?Q?uB0vRHtHOGqweSESRPifOe1DViY2rfNdYmxT16Ueix74RLDMzLjICRiEtZVz?=
 =?us-ascii?Q?pORzeY3t3nBLNZuH2bwCMRrwDcavjt6XqPE8+HVE/tjQNpybDDwTXLfxl1mN?=
 =?us-ascii?Q?bjJGKgCMkiAwtSH4D0J+BAiUgIuUPfM9OEkW3qxDWEAvK8YT8unSKa3L5p3d?=
 =?us-ascii?Q?SbFALQZ/YjdxYL7lLf+LNJO58Kq9amWO0zccPFDCL3pndbONYZTYVMxQC24z?=
 =?us-ascii?Q?8VINZB+iOE7Pu40zMQRDGUZnyuDIFfinAwjeVji1qxdXgLMJCRFkZgpIdq0N?=
 =?us-ascii?Q?CBCceouWeIEgzW8482e0IwMU985NhLpR1AqLbduytzC9AeEqTRjHqralpncU?=
 =?us-ascii?Q?v/F8Afnyigc4VaK55MQ13IOYem2rs5OwF49r6kOoNLcNKHYONpgFhD2AxUtu?=
 =?us-ascii?Q?/duFTQEZzOTcESdsAOjqcsNNsRwTqkjHX1ZIFsWIdhldhMCWc2EtS+/Znc9X?=
 =?us-ascii?Q?zB3SdKDcQFk6BeaeadPs+cpRZmdudF3uMI46jIkBM/3K1Pkfy6SKP7XPj3CV?=
 =?us-ascii?Q?vKcnyVJnC1KrQQY0mN+CsKEVcWXfdckqSnqCj8x+wUykNNYMDVp0F2cqkBdG?=
 =?us-ascii?Q?hpPtroykz/0A4HXsqCT/7f7/vifKDxTXYOjvrY2QJ82+KUrPqRlUHRS7oDD6?=
 =?us-ascii?Q?Jd8v+uBTUcHaedKTiZ9FKX/UBZOINnNkgJm4BNd/QC9CkaKhAz3kaNY2IXKU?=
 =?us-ascii?Q?SME/hM/y9vVmpvQE/yf6fPrcPbvjWL2nylq5tMpBkLzlA6CRZgbdh32PyXpd?=
 =?us-ascii?Q?J6FzMt98aC5rXUaB8+Pq/vOrPVLARG81dOazfSTWVRIsLHljOy6uK9m78y0Q?=
 =?us-ascii?Q?QioZb9I1WUk3gv9muBAgnVvtTw2VwpwzCRleGAWz+/IjoEpmuc+P+OyYFRFj?=
 =?us-ascii?Q?r9Un8GMx/hzdVjLAonQLQxn2LVSsACpqWBjCEhyR0Cn4+yA3GISGStfuQ0Iw?=
 =?us-ascii?Q?X8479m82PSmaJIIOOpquMBWRq8yxuhj1Mc1L+YshGg2yQvgwPagvW3K4944Z?=
 =?us-ascii?Q?z6Nb6L69tFLNlbKTXVBjkDYiDubyxUC+8liOR3GoptnNl81CUMLXczyc1ML3?=
 =?us-ascii?Q?xenlvw6nwqHlZzhVZ0I+XWnWczFg61816GKgdazjXVJiX4Op1niQkNJPH/hg?=
 =?us-ascii?Q?D/TVsqlUyQrvVn3/Yu8YBdDAfvofzY2wZ7/9BxCdF6PH45wOjvhmozZCmRo5?=
 =?us-ascii?Q?EpTU7Je5wn2mN9saSdxiY+Ib5ewHAEn4MPmibS4MqwJNUw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96188673-0a66-41be-454a-08d8d4e52a82
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3148.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2021 14:46:42.0562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q3JCiOl+SZicH5ahM7SxzI5C8+XFSJguP/vS/0EwFMo7PB61CI1o8PAztJPMTtV9XjpTIrE0D+BKu6ByssKkI2lp0unEq/0HtgEi9SK7on0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5280
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9899 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102190119
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9899 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102190119
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the VM entry/exit controls for loading/saving MSR_EFER are either
not available (an older processor or explicitly disabled) or not
used (host and guest values are the same), reading GUEST_IA32_EFER
from the VMCS returns an inaccurate value.

Because of this, in dump_vmcs() don't use GUEST_IA32_EFER to decide
whether to print the PDPTRs - do so if the EPT is in use and CR4.PAE
is set.

Fixes: 4eb64dce8d0a ("KVM: x86: dump VMCS on invalid entry")
Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 arch/x86/kvm/vmx/vmx.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index eb69fef57485..818051c9fa10 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5759,7 +5759,6 @@ void dump_vmcs(void)
 	u32 vmentry_ctl, vmexit_ctl;
 	u32 cpu_based_exec_ctrl, pin_based_exec_ctrl, secondary_exec_control;
 	unsigned long cr4;
-	u64 efer;
 
 	if (!dump_invalid_vmcs) {
 		pr_warn_ratelimited("set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.\n");
@@ -5771,7 +5770,6 @@ void dump_vmcs(void)
 	cpu_based_exec_ctrl = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
 	pin_based_exec_ctrl = vmcs_read32(PIN_BASED_VM_EXEC_CONTROL);
 	cr4 = vmcs_readl(GUEST_CR4);
-	efer = vmcs_read64(GUEST_IA32_EFER);
 	secondary_exec_control = 0;
 	if (cpu_has_secondary_exec_ctrls())
 		secondary_exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
@@ -5784,8 +5782,7 @@ void dump_vmcs(void)
 	       cr4, vmcs_readl(CR4_READ_SHADOW), vmcs_readl(CR4_GUEST_HOST_MASK));
 	pr_err("CR3 = 0x%016lx\n", vmcs_readl(GUEST_CR3));
 	if ((secondary_exec_control & SECONDARY_EXEC_ENABLE_EPT) &&
-	    (cr4 & X86_CR4_PAE) && !(efer & EFER_LMA))
-	{
+	    (cr4 & X86_CR4_PAE)) {
 		pr_err("PDPTR0 = 0x%016llx  PDPTR1 = 0x%016llx\n",
 		       vmcs_read64(GUEST_PDPTR0), vmcs_read64(GUEST_PDPTR1));
 		pr_err("PDPTR2 = 0x%016llx  PDPTR3 = 0x%016llx\n",
@@ -5811,7 +5808,8 @@ void dump_vmcs(void)
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

