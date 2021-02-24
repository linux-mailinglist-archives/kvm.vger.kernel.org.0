Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A0C323FAF
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 16:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234853AbhBXOQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 09:16:34 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:34912 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbhBXOIk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 09:08:40 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11OE4whM096187;
        Wed, 24 Feb 2021 14:05:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=uQYrDyg9OEqr6VqV3M/PSelONwF7ebIT2Lj+DkG0NYY=;
 b=s77RfbA9ogwgZUdmJ1jAkRcY1LJtM75IVTBSKsq0/pTfII6aHbUHhQl8zuE8rCW3FF7E
 9Utq9Q4XuTBUKtKBSAw07id1TlN6XF0ypi8dTK/UBrj5xRflBq42nKYoPuUkea07ikhP
 vEZYPmJPMYu+RPrfrRN/UIM8UMx0pldMSOpNn2MyehYvqH2VdpN2D9+bYpWvBNmmGBgd
 Nxs+OWn/PMUN0jv5/dsWfUVeXRpoCdo2DZOUM6xnP+5BK4rWWMkCuZ+rEoe4pnXiptcR
 mJfcJVVfJNlthepL9S8v9avZO1bnStxy5tyMjDUe6BCfw557Ctw/UXwf+6IOoyw1YzO+ bw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 36ugq3hvmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 14:05:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ODscsi012587;
        Wed, 24 Feb 2021 14:05:07 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by aserp3020.oracle.com with ESMTP id 36ucb0sbe5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 14:05:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lmLT4/5XVE4yjT5CyTNAU7/gn4R1sLLtMJaFGBcqiH179RKkjwe71/H0BggxIp6Vfo7u1MRy46TdLyc3to+H70488UoArHg/4tBWJDpiQmvOjsNKAUKPIl+onxT8k9DbIyGUPdwatR58PkIM6VULUq3iWAPOnRs1Tsv7Ez71argjq8itKM9L2ceKicPPZRqbFoK/zWL4ZoKbSq4vU+7luzqp2Bas8Y2UhZ9UVJF0pzhgnKT+uW8TjPP+fEEQSr3eW0MiiLRvVBNyb6cscmtH7/UrtbCw+18ohTgp+rPbkhC9kddx2qGLLRptC+UdmbSv8rCjdXqPx+VaKcTTk0bY2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQYrDyg9OEqr6VqV3M/PSelONwF7ebIT2Lj+DkG0NYY=;
 b=Y10Wg8U38Im0ptVbHvK1aWHVJof3gR5pQx1YH5aq1N0ppriKLgHhcLuBBsPO1pKpT54RjngAi9nb1xhrNmXzAls3DfLHefZUyE9qKbyWW8zhdq/X8hrf9IWcppB8S7CODBWkJUxdQZxkgjTAuhA+zxvbK0NKG3N7sP8LYWyXI4+xSWdx4RU/I/KlnLoMHrz9gUpNF00Vgf8Uw3YyAn7CvWij7VVGUMxgZm0oRj24+J+zE2MfYI7HX9ePV3rWnIXVaylwLN5p7j+T4y9+LAS4w+5POuCDFW7SOFibP2dlGXkiVEHw/VxM9xyPCb2ddCSn79a4DHxnHuIb7ImFByAf/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQYrDyg9OEqr6VqV3M/PSelONwF7ebIT2Lj+DkG0NYY=;
 b=b9LwmBw3WOcUKHutQml3bMNY0lz2gM3RbzeJ+OIa2NoMMQL6sJA10sf6N6UF4ex6Gwvvfom84ID7tEs33OFCjAH4sDwcqIrBjCtZxvsGxq3+gGmqn7QaR2xUK7ANDFKiKQKAa6kGLYvAOO1XKp2jEOrBN5ANBoWKLLWOzmUhjYY=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3148.namprd10.prod.outlook.com (2603:10b6:5:1a4::21)
 by DM5PR1001MB2153.namprd10.prod.outlook.com (2603:10b6:4:2c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Wed, 24 Feb
 2021 14:05:05 +0000
Received: from DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934]) by DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934%5]) with mapi id 15.20.3868.033; Wed, 24 Feb 2021
 14:05:04 +0000
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
Subject: [PATCH v4 2/5] KVM: x86: dump_vmcs should not conflate EFER and PAT presence in VMCS
Date:   Wed, 24 Feb 2021 14:04:53 +0000
Message-Id: <20210224140456.2558033-3-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210224140456.2558033-1-david.edmondson@oracle.com>
References: <20210224140456.2558033-1-david.edmondson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:8b0:bb71:7140:64::1]
X-ClientProxiedBy: LO2P123CA0070.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::34) To DM6PR10MB3148.namprd10.prod.outlook.com
 (2603:10b6:5:1a4::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from disaster-area.hh.sledj.net (2001:8b0:bb71:7140:64::1) by LO2P123CA0070.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.31 via Frontend Transport; Wed, 24 Feb 2021 14:05:02 +0000
Received: from localhost (disaster-area.hh.sledj.net [local])   by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id fd0bc691;      Wed, 24 Feb 2021 14:04:56 +0000 (UTC)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2782f92b-03c3-44ce-14f4-08d8d8cd2f5e
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2153:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1001MB21531AACAD343CEA4FE44333889F9@DM5PR1001MB2153.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:389;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tJbd52yp7g90w74kay3VpOhKI4of1O5JOuMSNA9TN8SYLlw/0GYci+l0L3TcQS/7B2xt+nD923v8wW6gRlXUkemFMY87/z1qOm8RWO1n9oW2+jIsTOuoRDVelvWJM8SnbXeVmlY23R5FFgnoOlGt/2g1KzgI2p6tBhls99qzwPmSeEnN+yiSG5GXp+qRHjLNFtTUVLEDBep5S8qlHSIzg0kX8TIzh8sozvG76sjpzElowBDz09w+HO6/RGoScw5msGlKJKaPsRUXv9mH3lzvcX6QFlukFH4p3hpUa1gxaHW1XdPCwa2nW0mcsTJwRQJ5keu/6QxPD3bvkQjafexSZHdGfhMxi3bvNXzzER4AU6xDh98ilN+5GIGz5insBtwRGzpi2/dMMD7z826E6/cmG9PHNjr7eYWlyFb+OTXXSa5BRhefjSa3Vu+R9lOYommcZh3dnUkyT6aJPa50aC2VCXIrMLdL8hjUG50Uq7xafGh7S+i97EgV8N2q/98CBEQuM1S9ZdJRIgd5Rp/iPB5M+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3148.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(396003)(366004)(376002)(83380400001)(316002)(66476007)(44832011)(8936002)(186003)(2906002)(86362001)(7416002)(8676002)(66556008)(52116002)(36756003)(5660300002)(6916009)(54906003)(1076003)(2616005)(4326008)(6666004)(478600001)(66946007)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?0TduX1DUD6kcMJg9Yc2LXYVa6KVTIfZs6QDrUPAuhFuKGSCMGHZx7zpk6FYx?=
 =?us-ascii?Q?L6SSoaNgJHT5+SlkuYBAII10rBS32LXLMUhxvpxvaKcwDHqqi7RM1htMYh53?=
 =?us-ascii?Q?jkfgmEEDJtpXGtBs8bLqp1t5Ny2zWfGR/JP81MeIouE36HhHTiPh5WL1wF7S?=
 =?us-ascii?Q?iGXCTKOJMn4ifwL5CT4vTZa9Lai3kA9fferMh+2r3pGxg/5djrCbZdJLj75S?=
 =?us-ascii?Q?5q5c7c7A4mrxNk+kNHfT7xI0qSmH7xlbVs+UYfok5ODb72bksS2UGr1T+TiP?=
 =?us-ascii?Q?AUcVwWAbknf+a1GioK4F26WMOM4VAr/j/H0JiuaE/agYTHX5fz7vgbA9gXZ3?=
 =?us-ascii?Q?gzBtIvppFtDOg69vJ6j20OZSKpKG9+1cfyMI/CK2LG4CuXTgId8MFhFlarxN?=
 =?us-ascii?Q?S3Jl/S7xOYS0CSIaguUeg4SoHq0hsmwjffvOWl2KG0oi8ACH2RFfKmcjbPT2?=
 =?us-ascii?Q?mjfzONobWHDw+gHKOEoADnva6NcV0OmAdmAPbmmhzgt8mRcMv2TzKPTQdxe1?=
 =?us-ascii?Q?TDnQOrbirPcGxAVDJI0g+fDjSm3kiywjxtmdLqMYbHViBW0VfGKiMJp4bBRX?=
 =?us-ascii?Q?ZqGxqShCXUiFVo8/CqKbv9vuZT2yQjS1bmqw3rkIZLdat+/dBRj8LFDjVGnc?=
 =?us-ascii?Q?4wPWkmGINCXAT9R/0D219D1PjOeb6PTlW5SST+uxi+zBLFxgm2skV5Ze/hY+?=
 =?us-ascii?Q?/i+/p50k+POp1ncSXBxQNW8rKV3DfM2bspVBxxxWvB9ciORg3x7ICRmAq0ZP?=
 =?us-ascii?Q?HLcy/apIcqP9D7vdT09+M5jPnWtIkbN9RcfNRcMyBQ+yE50cgt0Ofj3PRSvX?=
 =?us-ascii?Q?gYekhUWdSwroQhQjdbWbcpqrceiNVlKaCxnU6Ua+Dg0ATLQdTQyDTAQRbFx3?=
 =?us-ascii?Q?ZBEsua4VtzTPHOVI8fflM8B7DLB5QC5T9wsfGYpRKbfuQVhqAhcvAIW1l2iu?=
 =?us-ascii?Q?uaVZwTddqGh1p9F66Sb9dqWyBXdtYTAb1hcthRdAL+0vYbFzgKEmezDKBC2I?=
 =?us-ascii?Q?mfD4T5iyhNYB3N2QApK8tjR/luZA8OP8xG6TxZJ77/zXla5mtC+mu8X9GRjh?=
 =?us-ascii?Q?EDvtZkPGSiZ0E8L9sbs0AXpH6uGv70QeYMvI+GSl2Q8ON7vnUKkAdOom8b13?=
 =?us-ascii?Q?jDUosUrDXyokbTHhWZbSOIm6dgFYJ2AdUnZEWafG3Plv2MPNGwtFBxqMClBh?=
 =?us-ascii?Q?gq6eUgdDJRI0HuEEL1pXdCqSvmzvo8RpAKXNJOxh7V7vQZaS0PAqWVPAIH8J?=
 =?us-ascii?Q?E+QkF0R0Y1aGKnxyh+GMJln1xfZizePfJRIw17KiHqxUlkF/PCd5b8zF1ed+?=
 =?us-ascii?Q?zPdD0lu/ruofqMNubE+IujANwUZ6dIDbAkB3xVBwDlNtkA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2782f92b-03c3-44ce-14f4-08d8d8cd2f5e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3148.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2021 14:05:04.8384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gx+sYxSj1d0dQNvLHGHKcLm5LTa9ruF+zyo2cW2jyIQIeySa23JPJx0t/BB7g/AWA87sM4s3VA6zSSK9jd0ZdqjUDpiPILwVDmwmB9mryoA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2153
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240108
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240109
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Show EFER and PAT based on their individual entry/exit controls.

Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 arch/x86/kvm/vmx/vmx.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ea1b3a671d51..90d677d72502 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5860,11 +5860,12 @@ void dump_vmcs(void)
 	vmx_dump_sel("LDTR:", GUEST_LDTR_SELECTOR);
 	vmx_dump_dtsel("IDTR:", GUEST_IDTR_LIMIT);
 	vmx_dump_sel("TR:  ", GUEST_TR_SELECTOR);
-	if ((vmexit_ctl & (VM_EXIT_SAVE_IA32_PAT | VM_EXIT_SAVE_IA32_EFER)) ||
-	    (vmentry_ctl & (VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_IA32_EFER)))
-		pr_err("EFER =     0x%016llx  PAT = 0x%016llx\n",
-		       vmcs_read64(GUEST_IA32_EFER),
-		       vmcs_read64(GUEST_IA32_PAT));
+	if ((vmexit_ctl & VM_EXIT_SAVE_IA32_EFER) ||
+	    (vmentry_ctl & VM_ENTRY_LOAD_IA32_EFER))
+		pr_err("EFER= 0x%016llx\n", vmcs_read64(GUEST_IA32_EFER));
+	if ((vmexit_ctl & VM_EXIT_SAVE_IA32_PAT) ||
+	    (vmentry_ctl & VM_ENTRY_LOAD_IA32_PAT))
+		pr_err("PAT = 0x%016llx\n", vmcs_read64(GUEST_IA32_PAT));
 	pr_err("DebugCtl = 0x%016llx  DebugExceptions = 0x%016lx\n",
 	       vmcs_read64(GUEST_IA32_DEBUGCTL),
 	       vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS));
@@ -5901,10 +5902,10 @@ void dump_vmcs(void)
 	       vmcs_readl(HOST_IA32_SYSENTER_ESP),
 	       vmcs_read32(HOST_IA32_SYSENTER_CS),
 	       vmcs_readl(HOST_IA32_SYSENTER_EIP));
-	if (vmexit_ctl & (VM_EXIT_LOAD_IA32_PAT | VM_EXIT_LOAD_IA32_EFER))
-		pr_err("EFER = 0x%016llx  PAT = 0x%016llx\n",
-		       vmcs_read64(HOST_IA32_EFER),
-		       vmcs_read64(HOST_IA32_PAT));
+	if (vmexit_ctl & VM_EXIT_LOAD_IA32_EFER)
+		pr_err("EFER= 0x%016llx\n", vmcs_read64(HOST_IA32_EFER));
+	if (vmexit_ctl & VM_EXIT_LOAD_IA32_PAT)
+		pr_err("PAT = 0x%016llx\n", vmcs_read64(HOST_IA32_PAT));
 	if (cpu_has_load_perf_global_ctrl() &&
 	    vmexit_ctl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
 		pr_err("PerfGlobCtl = 0x%016llx\n",
-- 
2.30.0

