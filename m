Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0803323F90
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 16:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235411AbhBXONQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 09:13:16 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37080 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232672AbhBXNcH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 08:32:07 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ODTH84051807;
        Wed, 24 Feb 2021 13:29:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=uQYrDyg9OEqr6VqV3M/PSelONwF7ebIT2Lj+DkG0NYY=;
 b=U+RFkjuv4EyqeJ40qNEXXM7qCbdOBhv+E7cO3sWOmqDYjK3cIoZmkO1XkxpvQ9zHlhE9
 4JVEDnbzL1LsxiIUeXmCuPkhCKJm8+0TjphW2cSljTlW/p86vJBxr63fCZ8sfYFmqHcF
 vt0wY0bxayRelYnbw6KPIKD3xODsg+1n8JQceNXqNOodeNadOe25K9aY+yCoBeQvMDyt
 ziqcFNmKCiczjjJKtAJ6s2iodYmE7JartZ+NcCxJFQJ8n8YAFwg+5135GHSbcdPXUZM+
 W4ge4OdLe+/ee311oG28Ny8bxxYA2R0qnS+nSoX+CIt3kwyxy+P79n6uwuojw9pIQjev kA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36tsur2xad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 13:29:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ODQBqk184325;
        Wed, 24 Feb 2021 13:29:30 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by userp3020.oracle.com with ESMTP id 36uc6t4rmp-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 13:29:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dfo880b+NwJkEycxE4zMLgNbcS5eAUiCBjz0eqhnI3fs3JYA6onUgs//BtZIojLrYhEMVAeh0luoBSj89Mli7q6VIcp7xYW0BOAYtwDMU2x0cleCCyv/RJObiU/TIWZ32qLo3OOGQfeUbTKojMQgCMwXHL11CdllcfZHspgh4gbSaBkRlPjjkUL1Ssa++wIcwwNaehCML+hWiaYn/PpLmNUHVm3VU2BF4t/Z0Z1M6nNyrJ12YoKdGDOZfEUaaqAd5MRCE0f450+PhZMWGP/RU9LVzMcc1erDYLHFtylM6iTiZkBKgs9p8igxvtYn+27yk95Kd2n2He/xM58D/gX2LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQYrDyg9OEqr6VqV3M/PSelONwF7ebIT2Lj+DkG0NYY=;
 b=NJP5Zw3feN6Qa+bz1T3fqnYsJQN8QOib39nR27aDHh1esvuEk9F7lW3SKVQZJn7hh9cYVHLK45qGSB+96z0LXwPSKZg+ckze+Koe8CAxV4jOe5j6ZbZxmX1TJZOGdVr8GPPRgVgCRsWr96DOhmkye2mbxa5FhedWHyuQd1p3pK9wfGFAVNGh6jgSXg0E/0ift/2L5Yr3fKe7ENelwVxvpA06OCpNT/Xos3MMco0M5OSFZkgEEBthySy7mko3GexB0/wX61QuOkp/jP+snmP3PjUyCabVL54X/uJCDTM3+v52thlVrfr/tx8uPw2tjRoCqQpiAQuAtgPL26mc++DQ9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQYrDyg9OEqr6VqV3M/PSelONwF7ebIT2Lj+DkG0NYY=;
 b=ZzjrGOLyBU2DM3jrSHh+12C4f0rICWiL3M5VmZYpY0QvivyMLA8yxoldjZPo8grwwkOd1ZQRkD39M9EfUlVFlzl0BPKCLUPR3XKX1eTtOaW3v5ssxN9vSkaDOXyIje5XTPngPCW2pbDlqZqJgkpc6CXPYrXk7mWzpXdGoIfb03M=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3148.namprd10.prod.outlook.com (2603:10b6:5:1a4::21)
 by DM6PR10MB3146.namprd10.prod.outlook.com (2603:10b6:5:1a6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Wed, 24 Feb
 2021 13:29:28 +0000
Received: from DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934]) by DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934%5]) with mapi id 15.20.3868.033; Wed, 24 Feb 2021
 13:29:28 +0000
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
Subject: [PATCH v3 2/5] KVM: x86: dump_vmcs should not conflate EFER and PAT presence in VMCS
Date:   Wed, 24 Feb 2021 13:29:16 +0000
Message-Id: <20210224132919.2467444-3-david.edmondson@oracle.com>
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
Received: from disaster-area.hh.sledj.net (2001:8b0:bb71:7140:64::1) by LO2P265CA0155.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:9::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Wed, 24 Feb 2021 13:29:26 +0000
Received: from localhost (disaster-area.hh.sledj.net [local])   by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 8e0038a5;      Wed, 24 Feb 2021 13:29:19 +0000 (UTC)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf7945ae-3ef3-4646-5e70-08d8d8c835fa
X-MS-TrafficTypeDiagnostic: DM6PR10MB3146:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB3146A02465C93ECBE4391F55889F9@DM6PR10MB3146.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:389;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: htsLsOxjp3QWVU9k2unGxq1Kf5W0cC/sDscQUlUfA+MRK85llgfkp+05P87vRXKQ1a+6vJJcR7vGZy72haUkf9XpYKc2MpI1SMo9u7Y3s+29QLa79KjitFHuaJKKHGMxHzW0WklzsNf0NPEn7tmWKYCxFP+qRPauCGrzW2X3akmpPpUgtmvh1a5KinemtN6dhvhJqtAYC5z7I6yEDh+nQWAOQQrMPdRXlpvqcTm5TLI2CvioeinQV4sR+wdC6+3ZEm3/US+WIio5JB/+jMeyUzEds6sfZP3YHA8x8X3qmDAZRszHBHDE6gtJCj5dkNYEuQQMFUzUXdnxXgeqz9opAcHYlKBgjgaacOFMzNOHojUdoXtyJ4JuuZNUbiaIfS4JkEWGmfB0zUSAP0W7ysvMCUSFvBaXSjx0RiNfm8B8XQZ7JB+GJ3zZ3CMzvElBZ7W/TR4ErM9TaJnbVHMYtw94+b7oCF/n1zREotpo0lE1PMW1ScYSPVYsfR1nNHqo5yOd1d+rxAq54vfYtx1Cb7jk7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3148.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(39860400002)(396003)(366004)(107886003)(2906002)(44832011)(6916009)(4326008)(6666004)(86362001)(478600001)(8936002)(2616005)(316002)(7416002)(54906003)(36756003)(83380400001)(186003)(66476007)(66946007)(52116002)(1076003)(8676002)(66556008)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xiuDF/6yQNG6VHp9DpOAoiQW6+2GQ+vCRETtXkvKZJOwKsZiP1sL/yLLMZ3h?=
 =?us-ascii?Q?tJ3vsNx+vUcrUiKkEeDOH6VxyFm7JRPTHTO38dpIh4KV/hnhmGmsd4Qyb34u?=
 =?us-ascii?Q?a1QhIoMVlKaWmDtVpXnXn25cspfhoyFZ4o8ERjNx+pDA64t7wlMJylR/Ha2A?=
 =?us-ascii?Q?6q2JUiSEgeUOO7HiUhcyJ+xRwEEaVGWtag1mCmKLIPGIqtxgWQZPCq4WaDkm?=
 =?us-ascii?Q?A8rOzV3QQ8/Ir3I420ug84K7EAzPZUcFbqHaOrE8juCiJe00oLlwDdgZ/lmk?=
 =?us-ascii?Q?Amf5vEB9rgXrWQ1w5nLtjFgoIWnynsUSwnqlKp2zXLP3Pp8iJ1tpnkbe6fO7?=
 =?us-ascii?Q?fRb0Z4J2TAV4JnS5cTwE02dgKfOXkQtIw2N1vRZ7XHPYOnkb6TLzE+ApA9oY?=
 =?us-ascii?Q?qm3Ag6PDkitdYou4rMzfW2q9lyMppveh9ieKhp0s2qW5TQitkQUeyEnQbkRy?=
 =?us-ascii?Q?nOvpqLfAqPhQQjlK2xMI0AQo+BkLKdcNYgdGkJAsOk7v1lPylwETXSqpqtdf?=
 =?us-ascii?Q?+8G6oTxy7JrFpkCKRKUVLrRZNnhbX1anWDDbsDdY3VL6HLChX3Gr8t091vpL?=
 =?us-ascii?Q?WhJRSoIlrtn9cAiv1qpBVLiRPS9OeZ+1tiQCKxSLOCf9bfYnJEb57/MlKCCa?=
 =?us-ascii?Q?R5riUDGSXG9Al+Zr3xIyNLBSdu1I0ZJvcYlX2tTMOjnTCqyrhPLneekDhOXs?=
 =?us-ascii?Q?m0di2YYVriqlYXnY9vhjxQyzcs7hmSglyUhlV/yp++YvkHCRdVjlZZVacPUq?=
 =?us-ascii?Q?MM1D0grxp3hTx1daUrcCH6FgmJ4I4Vsn0KpFJjVPgS3VRpqAr3efyHKkDhce?=
 =?us-ascii?Q?5GwCzuzN/L4iILH2BhXQl8ZV6kNyL0U/QRsPdn6A+f/wLarPqFPr9Xf8yS/v?=
 =?us-ascii?Q?sGx37oQvf2CH28x0IHMYm2m51QXaH54LTGGbwzDP6As4M7vjGuUppj1hPkci?=
 =?us-ascii?Q?JR+kLgQieN+DuZS26dlu+eM50XlH7tSy2bjSwrdRqJykOejoowdeReq7G+6W?=
 =?us-ascii?Q?DjLXnnWCfTJo/GoZOHjTC6qecvJuV+mItYLGdZhReKSrbAOLDZ0VL7IDBD12?=
 =?us-ascii?Q?ls0hZ1vCIVF6qiybJtMO3cAAxFJPOOet7LlKEcJSaq4sGr7qn/63eS+71dmp?=
 =?us-ascii?Q?PcNKh861lckT9YIKUJ0Cu91oDDZ5BdXRPMTZ2RKDK97ffzKj3YXHmfWPRptC?=
 =?us-ascii?Q?a108VuyvNFwIRc3GFpPUkslaFr16w0UrZ4BOc2aaafycDNcj0/4flp5LqDeQ?=
 =?us-ascii?Q?jO49xY69TJrimar5lJQyC/nIpk5FDvs0FFgP8+tJHuryTUhtkpAvKj+ORnL7?=
 =?us-ascii?Q?KDIYX1s/IW10YqpljPzyqacwsFX8aC1z5eXMLLeeYRNe7Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf7945ae-3ef3-4646-5e70-08d8d8c835fa
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3148.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2021 13:29:28.5053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: brb3UzAABoZwYTi1WdghjiEmGsmH1Se0IA4PKi3pinQfGPY2kUmBuMVRdp5IwWL8LsuSAmyMYoOEBPlyDnNd3GgNr3Oax0vQS2PNAwW+OAQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3146
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102240104
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102240105
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

