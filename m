Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8A7323F8F
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 16:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235213AbhBXOMS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 09:12:18 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:37708 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234883AbhBXNcH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 08:32:07 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ODTLcW160530;
        Wed, 24 Feb 2021 13:29:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=Xpw/yhtG2V6Muoah1BF32QpLvcA/5dBWSpMW/TK0kEI=;
 b=sklgfuWNUDN7lOpUiWYoCJ//Kk4khmFhb78EEKdSEHgZhH95xItW6uTg7cV+9adJcuF9
 EoVACEj+EkKGEiYWIATM1ZpB03XY9aXyD4ER1LJK1KPdgETknexmt6DFrvwTJkqJM8u/
 gf8aaTlppY/70H+uRLRrRBjgx9QsWPK1CfjzFgxc+LMUykij2JtIG2L1C8CVFAet7Jw1
 6aAmg37YwNOE5sh/I1EHZSvSy33b+CohPNePGNOFuAvPvA1Jm5PQWzrXDz+IQj08JpA8
 bPKu71tgEZLcUgjthmDw5FFEMQEenI5N9qISW0IKJ5V2AFpbfMmdIaNKzLi6asRL8qg5 dg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 36vr6258dt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 13:29:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ODQBqj184325;
        Wed, 24 Feb 2021 13:29:29 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by userp3020.oracle.com with ESMTP id 36uc6t4rmp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 13:29:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jnF+fLi51TBoEKapOlVesNwbk6nCyEdjxOUfkD+bWw02N+0ylHmOXrnNCQ4vq62naULIlMrmjDY/5k3Qjyeyt5JrqKat2FMUBYHc5We5vSI31jypB/dLL3ZDLwFJbEqLXL3eLpjhVXr88n9yr2NVgzf7l+/fUKokqdVnZ5SWrC0aPhGHi/Mq9xDdohoQQfSSR8vlK7oV6RAe10TjPfHEqY/VAkaLDLZCo/CV434vi8Cnxv8UZJHFXt9KRRbEZz6yxblF5hb0wr4ybC9GuCaYHjrbfhq5yXEe1ccgLOHmr6I9lFxQt/zyrC//sgt1G1SMTr1Mn9C175I+ev4KtBlfTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xpw/yhtG2V6Muoah1BF32QpLvcA/5dBWSpMW/TK0kEI=;
 b=lFcTWx2IhyfUJqHiNKKo4IiMidJCJOwliLQhBxx4EMbrXnxTjHqMoApVbYSmWLFOFJK9MdL76/lTWjSN3Q38MvBjBLvcYRGwH1uRxXJeYbLFkbVhP9nIsMa9F2zs9qBRJisH72PDCSMTt4DU0dbDaLJ+UKZQ4FAGLH8ivgaCxE476SqLBL6cc7OfOY7iMs12gCtN0EH/NUwJXeeptcJpfj5xrb8tN4Oosh7ilLo5cssCscTIJ2giLnRhcm6iY8/beLmkKzfkUP+bCdz3pMSklwvOXV4GbVO1lbh7O7h4zSAMW2kIN86lplkzNpPYogpihn19KBTvmLIcqqWWhYiU9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xpw/yhtG2V6Muoah1BF32QpLvcA/5dBWSpMW/TK0kEI=;
 b=XpGuBh4sMehdncqAyXB9Wjdr2DqnRgacKPVW9dN3EYpvmM6JqgwvKMmpRKZyBBTFbCkk/YM1/wNmEDsTnE4oVAni04scz1t1pb0JaUuRnf9QuC7ySYCQ5v2vVe0dCE/ZCDTX66+YyIK+Pd/zQAwL7SWGcA0QDrdSu22ZQyHQh/E=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3148.namprd10.prod.outlook.com (2603:10b6:5:1a4::21)
 by DM6PR10MB3146.namprd10.prod.outlook.com (2603:10b6:5:1a6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Wed, 24 Feb
 2021 13:29:27 +0000
Received: from DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934]) by DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934%5]) with mapi id 15.20.3868.033; Wed, 24 Feb 2021
 13:29:27 +0000
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
Subject: [PATCH v3 1/5] KVM: x86: dump_vmcs should not assume GUEST_IA32_EFER is valid
Date:   Wed, 24 Feb 2021 13:29:15 +0000
Message-Id: <20210224132919.2467444-2-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210224132919.2467444-1-david.edmondson@oracle.com>
References: <20210224132919.2467444-1-david.edmondson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:8b0:bb71:7140:64::1]
X-ClientProxiedBy: LO2P265CA0484.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::9) To DM6PR10MB3148.namprd10.prod.outlook.com
 (2603:10b6:5:1a4::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from disaster-area.hh.sledj.net (2001:8b0:bb71:7140:64::1) by LO2P265CA0484.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:13a::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Wed, 24 Feb 2021 13:29:24 +0000
Received: from localhost (disaster-area.hh.sledj.net [local])   by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 9bdc4505;      Wed, 24 Feb 2021 13:29:19 +0000 (UTC)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fcfa492c-10b7-4952-db36-08d8d8c8349a
X-MS-TrafficTypeDiagnostic: DM6PR10MB3146:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB3146C5C3C130B087C8856DFA889F9@DM6PR10MB3146.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 021S6outwtCODseOjVexkfWdLsM/0JosKN/oVAsaqyshcGzlE95i2+e6oqxI2G8TKzsMod/dV+kHG9f3xIoKawWji99Tl5oI/ad8toVcrlrtPU4yvKyYOaNPYce1IDWsr0OFv7WZYI/BQTeWdSOEAZegTC/hBH8JDW4y/6fyU4JvuBb0DaZ48wPRYhYLph1k4ATDlDPYrf3lBt0GoUuBwVSuPtUZHRWU+BkSpAL6k+vqAO52+xkFudUxtQQlC+AcmhmhINk3Wndd4Oy227158eUU8Dw6vvNPg++K+Jsi7MJUIoEjFz0/cb9pnD1J4dNDfEc9eZ4fcOypG78tD9xz62uBCTk6U6YoomeMMuI2t7ytba53QN5g2mN0khBYUq70sJvWv3/pmccKHkCx5jPHWKwi4LcSgLD7N6xVQlo/ViSruFi9zQ097M4i8zCVplCSTNwZWc5wvrBfsUyTW4dvAS9uEjyyHIX3kpXD32VKbmSGUTkyjyapnmaaFo9DFb3ve34YiVlRFGJwX03coySvdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3148.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(39860400002)(396003)(366004)(107886003)(2906002)(44832011)(6916009)(4326008)(6666004)(86362001)(478600001)(8936002)(2616005)(316002)(7416002)(54906003)(36756003)(83380400001)(186003)(66476007)(66946007)(52116002)(1076003)(8676002)(66556008)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?sAZETCU/ZXAAmdPX2XXh1FbES28HjFlqt/fkb7Dx4Sty+54zaLCflGStr+0Y?=
 =?us-ascii?Q?JKDWUAZls3OgGdz7HflqPFckdi+af+zWJwbfaVxUWoyXI3Chrkz8XpGraBIu?=
 =?us-ascii?Q?ZnKkgVIMDcUFrFBzAxrCgkEamJbLhtk9kTErqCsTTy2fa6InSZio/zX6jMVI?=
 =?us-ascii?Q?X57apQbPX1+t8m+MQBY2yxuyRbm1ueU8a4nHLCjN2rMbDmcT27Q5p/g73uz0?=
 =?us-ascii?Q?WYyeXMGqoVt1H5nt6/ptqwpX8CDOrI9v3qEMhTFJEOEw+lA1SbP5IWSC8gjM?=
 =?us-ascii?Q?eZNje2js4wsxP1RLcIZc6W0JVwZ4rHDZ0kjrBrNwMgKMaXQTHktVYBx0iLk7?=
 =?us-ascii?Q?r9vNY9XzWnHqwB4brGBFhuYdPOqjP/x97hNWm8PJuj/oJmVXHolQdS8ejbeY?=
 =?us-ascii?Q?AnbaCc39DiM3HCpQtrcMT+Nq9ydg/BIZMB258EoB4hJU0eMUsAfq0ucsZbtN?=
 =?us-ascii?Q?jiiVx7xcDKb4ibOxjpIxrQlA4IQD04iq0I0BeW0LizJy6V8MkbXxVHKfG4cD?=
 =?us-ascii?Q?AvtS9CCLI/jZm24tfu9IDDzYIzcmWj3c7+yqZI/EUIp2FeoGcaycaO8iF9rz?=
 =?us-ascii?Q?5od8eL8XE4BOacUkK1Dc3K9DDZd0mJ887gOr8KfIEq3j9roAaCHdFejKliI8?=
 =?us-ascii?Q?EH9DKdqW+MktNFqDXhw68NliXodt4gQE87sh0pBdOW/oY06KFnzWE5/F8tlR?=
 =?us-ascii?Q?YnUvBEMa18o8F22qOcBsT8fF03S5a+TRvg7DKRUPrpvFVz8poFfljlE3A0qD?=
 =?us-ascii?Q?8AJWuFHYSsIDj6OP5WFrVYKGNtasuS8JP/saQm02Cfgb2YbU8Xxg/HsHNKaB?=
 =?us-ascii?Q?8ADmqUNt6DYmtMQuf8bituumt+h792Y2QlJLCbvwDbb9mdlITAv27watrjvu?=
 =?us-ascii?Q?WD9O+ekprcSbI9aN6zhkX/g6PHQsBEL2Ym5+4g6ADExf2EnYKUsrC10GQIoK?=
 =?us-ascii?Q?zDfRyHHN203xNFLf9PSp5G6j5YBRxrneXDWQMo3jw8AyfeHbKXYa1YDq2tuj?=
 =?us-ascii?Q?hOrybuSSye5tadtLPPojwzhv4b/9bkacdGGO1kyjO/bvVWNE7Hv2i1Jk3rzL?=
 =?us-ascii?Q?T18TOlrCaGVc9JajD1LFQAP0doh1le5DZsKVHi4AIY8zOz7e+gB6rr9LnfP4?=
 =?us-ascii?Q?uA8TbyU/a3XnwNPYdqGxlugl7RLUnisrv3YguQRdKjjtadLEmSYxfvgDn0Rd?=
 =?us-ascii?Q?Y8lU/7P1S++KAiWXXmHrmaYuFrjnABJ/iDIlyuAAWxgxWcpT8aR4iuBcR6KV?=
 =?us-ascii?Q?WtR/Yddeeaf2baXoMpXktCrgNbD5+saOPsyzwIMhnESVWTECu+OYayLos6Mi?=
 =?us-ascii?Q?VR8WoPKnlyF67C6Hv4QVbOuOWvHlXnLYQkn787oNZ9RqHQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcfa492c-10b7-4952-db36-08d8d8c8349a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3148.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2021 13:29:26.7064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sNnmQJjGR8G5IQlOYBWQq86q5J4+Uzmhnw0LBOZ4POtaEfD7JRZiPVhddkbNPkv/YcAmgeXQmTAj60pXjGxjry/IOUtxz5wO7fd2nxLORs8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3146
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=966 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102240104
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 impostorscore=0 adultscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240105
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

