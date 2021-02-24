Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1740323F8C
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 16:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234890AbhBXOLs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 09:11:48 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:37706 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234889AbhBXNcH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 08:32:07 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ODSnE4148234;
        Wed, 24 Feb 2021 13:29:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=BmHbFWpCy4zpjT/Wed1GBPgQ2G0Bgz5qE1pyrzTcNQI=;
 b=w3RrEryIt9qftyXq0sItn9PinBBmnok/bEd4twg/Lbq8gCPTzl7XPNCFUfcy3UfHJcfe
 5omidyFntxpL2e15KBYSQ4VWu3PMC0j3RjQiEhsbHJZN67+cW8owtvuVKLByQJb5R5S+
 vgcTXLstq63JmAVgKDo9j1rwSGotOBGNq77GD10LRUDlWuAHWzh8+CMBLMVcDENSejwW
 uTfl2b2eke3pblrXXDB7bOLJZrjaUE+upgfa4EZlNHXQLOHL/o2CQxnbjh4eBWSHAsdH
 ubcC/HIrQ4fnXCjuZMyWO3v1aKowLhbpGYe5FsltQw2xLuEhkE+VqJhuDiMLc0AK3RNd Bg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 36vr6258dy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 13:29:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ODQBqm184325;
        Wed, 24 Feb 2021 13:29:31 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by userp3020.oracle.com with ESMTP id 36uc6t4rmp-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 13:29:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FBVaT0YArSZRWBQ4KfnKfK/UxlhpzDXKsfDS38egJkZjiCWfc9GLzeYCcn0sok1T8vmaQcFuy5cBJDVMWzAMKaFMQ4o60XyjpsoSnoUdJOKFI4pbHmH+XflrRVPCwIwRZksZu7FJr9rtQ7mMRs4yFfGLjsr4Y4RZ5A4GlJLFwWpdARLWd+jtxAHF24US4UVOSvGhTLQtekTfh/WVbrykFm7PT3S2XEdpQvFQksxJwUlyoNqdQK1qx1kOZQqqJJUQfZaGJX7lvT0nQ9nbChyc1+S0XiEN0h/ISY6Emx6jNEOTWo2l9wVVSM2kMCuhvl3QXUHFABP+ABgMWz4vK1HugA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BmHbFWpCy4zpjT/Wed1GBPgQ2G0Bgz5qE1pyrzTcNQI=;
 b=PeKi7/iEw+3/AZfwnG4u33b97q1Efbqjp0rQI2IynjwmHYEyQIyCXFD12VnZVzxX5851LgjdeFkTVS/gpvcAtfgjYNYIHQv4ylAvcTECJxhWI0kGRrSiJruHBkr5E9+pVS3iIVcOxNMWvV86zW3FyNdwpE9vhlqCd6LTf6NtMDPHuP0EjoCfRL0mwx0C13tTxOdGtbrxx7uulgHbeodKrWLqHilXGMlqTIV2ZZiQzz/GSGjvhlumNWTMUtsdqFZ+sq9Mf7dVeQkGzMOFbnMfJ1JTSOMVJWVvCfDEQMYLwmMp4sL2we9MtXSNUJcsB5X8Eh/vGA/UFHeILLGNcPthkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BmHbFWpCy4zpjT/Wed1GBPgQ2G0Bgz5qE1pyrzTcNQI=;
 b=KieW5Jwrbihuuvf1ab4r2AzSqDfAh5e3IV3oVNBspsNeA3Eec6dan3ZkEO6Yw5TtKpitYfyhxqzo1VZPmbtlYuIr4GKXFUuW7LM85QrlYraeBol4D2uwDf5ezZzdwPFIvOZR8+dsbDlzPC3o+4M+zmMjcCsPmu36SZl9ZOLgkPQ=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3148.namprd10.prod.outlook.com (2603:10b6:5:1a4::21)
 by DM6PR10MB3146.namprd10.prod.outlook.com (2603:10b6:5:1a6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Wed, 24 Feb
 2021 13:29:30 +0000
Received: from DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934]) by DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934%5]) with mapi id 15.20.3868.033; Wed, 24 Feb 2021
 13:29:29 +0000
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
Subject: [PATCH v3 4/5] KVM: x86: dump_vmcs should show the effective EFER
Date:   Wed, 24 Feb 2021 13:29:18 +0000
Message-Id: <20210224132919.2467444-5-david.edmondson@oracle.com>
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
Received: from disaster-area.hh.sledj.net (2001:8b0:bb71:7140:64::1) by LO2P265CA0484.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:13a::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Wed, 24 Feb 2021 13:29:27 +0000
Received: from localhost (disaster-area.hh.sledj.net [local])   by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id a092ea89;      Wed, 24 Feb 2021 13:29:19 +0000 (UTC)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e0b2eb8-aaf1-440b-28ae-08d8d8c8368c
X-MS-TrafficTypeDiagnostic: DM6PR10MB3146:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB3146A81C0D55EA789E6268B8889F9@DM6PR10MB3146.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KHfS4KUZ3Yk0LmCfcIX4Qf9/6XhtzqAwgxr76cU6lQmPv4uwjQaPoInbx+6eNlCjB6n7LMHIkrsLoOkxCNfeQrHWulRC2PByb1NPXQuOdtuNBFs1YSeShnmiIouyTKDkGJFJ8Vjmj9FIdVASjasbizZVllyHP6x85JQ4pE1fsudV8O5qGgwkcqoASVNS7bYRezFCF1MEYSDsWE5H3M3JKKvKuRQ/9oQC2RVw0ubzp3mDHGEtPan2jajNnGStRX9rcfzpEBEiLfd/yWKFY4ub+rS6ky27pIfvFRQf//E0ZX8kB4199hrtNGsDFZVQSbC5Jk3S2nsA00S4PJgdlAq38AzFS0ST+8C4JZ/qvyvFknOz65DbJQ2ONxnR70LjpEV38qeOEx3JTM3v8rz4hHxIAZ539BP+Kc9qQe4LYyJQ5kfStYlmS08pwLYLr0W3/XNhIN6e5igRJBRN2SgEFafj8PWwmM3GqbRlv5vbHZ1qFWHYxrG1jSTVsRn3kYZMjKMKsWHrhfiUfqZ9w80OfWNSBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3148.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(39860400002)(396003)(366004)(107886003)(2906002)(44832011)(6916009)(4326008)(86362001)(478600001)(8936002)(2616005)(316002)(7416002)(54906003)(36756003)(83380400001)(186003)(66476007)(66946007)(52116002)(1076003)(8676002)(66556008)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?bJCBhmJpiCna5ruVH4N3b5/CVi2ZTFsk5bdwuKhdvdu4auzRGo82oCUTJjau?=
 =?us-ascii?Q?uCvETVce0vTnIKNpuD37ia8XE6Avaw9B2WC7bNgCERFlZ3jh9VFcFhzBiqBV?=
 =?us-ascii?Q?4ldpLvje9/mLhmgax4FtfmHo4Xe3dvgYUtMoF+PNJ9iWMX8viHzEpsIqGLiw?=
 =?us-ascii?Q?oSXdcA+GCky4CMmg8Jel9c4FWsmBAgtUdNzWZE9RHP7YCpo72S1TcEmRnkbg?=
 =?us-ascii?Q?nGyN00935G8xMyEkzzLc1Mbef/1zfdAjtItg4XLyhnDpDYw+Xcfm4TNCOmo3?=
 =?us-ascii?Q?3DdlxtQwEllYJezbcynN+s4gim4WJLFE3octw1RMEmJbMjkWfmVOVeaLHzXd?=
 =?us-ascii?Q?Po8y3G1LpjKdPIoDrokJEC3jMvef0zppHatEm1kts3DEAg8G0DZS/CB6KPZB?=
 =?us-ascii?Q?9gnvwq4xfZFGjk/4M40ofAn2W35qpq/mvbEuSipJMDEIZjM/RLWti29kpxw8?=
 =?us-ascii?Q?bVmX17AWsyza5A9iBLwtK/G3yUgILvdSAN711UUgOZ7MaXK1wSNkccWhV+Pz?=
 =?us-ascii?Q?fN8oRQN6XbL0KPQchEs24bWm93Qj2XSM9vFuS3L+0GVnaWZSt0XS6Jo53M4w?=
 =?us-ascii?Q?SR7j1BNd8h8SjmL2VOAw+n+9nFHfmddncRnVT+KD4DjwRWFvyup/70+FHgCi?=
 =?us-ascii?Q?3PI3pNs4EiE2AU9gMLp04+BTpPKgmBSOY0DzwL+j4i4bU5JUpDm89bygs/Tg?=
 =?us-ascii?Q?gX32yGOiH1ST2UKYEv4XNvXHxytX4eGjq0z+7iKDICjuGmmst9l9PPoXlmVw?=
 =?us-ascii?Q?I2OMZCllKwsISZj/hIPpTHyeVF/kM8nxcyMwN1wEQblnGtzB0pWDa3G9aKDT?=
 =?us-ascii?Q?/ni6BHy2jJ4XovE15w05Y5iTvZ+7EBhMrRYM2qz9nPv2ro5t+Bbebqu8wTRk?=
 =?us-ascii?Q?nz7oaxJ8ETHpxsQcMkjESVtVmfvrpRYFDi7U7XYadXA7wJk3UZLbnxqZ9Rlj?=
 =?us-ascii?Q?Su53oL3ZykGAFUl0GJJBLmKgs8PUlrtgFdAD1IQjgmHzrUu2N65/FkQ/IcJH?=
 =?us-ascii?Q?5azqgtS3uLaols+R06oesBI13pxEjl5Kfnd5d9LGEj/GiRMA98iq82qdp1ee?=
 =?us-ascii?Q?7PF74yQITfjd+cXGMUgXa/K001k+2x2w5HY6zs9bcxMYGKsTyRWygmxH3CRF?=
 =?us-ascii?Q?rqMvOa4Qcrhmn6Aj+FyoEAsMW90xwNFMLPGbP25AWFwxnQTeZhLlehhTxOjS?=
 =?us-ascii?Q?TOnLBPJ8DPV/WZxFE9VJfpHtu8qXtal3Nyf1MS96xEaJlzurmmRSRkw6iyGV?=
 =?us-ascii?Q?4WagkjvgtUAUL4UhkqmHq47AlCNQ0xRqaX5OOSzAgdZEvsY2HqcDKKz3d9A2?=
 =?us-ascii?Q?68smd/3eUtMMdG98org6dSv8R5S6ZUn489ANlrn17inO3A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e0b2eb8-aaf1-440b-28ae-08d8d8c8368c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3148.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2021 13:29:29.6207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nmD1bzbL3qh1+vMDozNHt0S6LEUmJNfLd6rVt5YT4m1feg+d/UmBAIlBPX68IzTUpZxVVb+U8yUaDHSkBgFreAB0aVVQ90ulPpeTtgtb9r0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3146
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
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

If EFER is not being loaded from the VMCS, show the effective value by
reference to the MSR autoload list or calculation.

Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 arch/x86/kvm/vmx/vmx.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index faeb3d3bd1b8..ed04827a3593 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5815,6 +5815,7 @@ void dump_vmcs(void)
 	u32 vmentry_ctl, vmexit_ctl;
 	u32 cpu_based_exec_ctrl, pin_based_exec_ctrl, secondary_exec_control;
 	unsigned long cr4;
+	int efer_slot;
 
 	if (!dump_invalid_vmcs) {
 		pr_warn_ratelimited("set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.\n");
@@ -5860,8 +5861,18 @@ void dump_vmcs(void)
 	vmx_dump_sel("LDTR:", GUEST_LDTR_SELECTOR);
 	vmx_dump_dtsel("IDTR:", GUEST_IDTR_LIMIT);
 	vmx_dump_sel("TR:  ", GUEST_TR_SELECTOR);
+	efer_slot = vmx_find_loadstore_msr_slot(&vmx->msr_autoload.guest, MSR_EFER);
 	if (vmentry_ctl & VM_ENTRY_LOAD_IA32_EFER)
 		pr_err("EFER= 0x%016llx\n", vmcs_read64(GUEST_IA32_EFER));
+	else if (efer_slot >= 0)
+		pr_err("EFER= 0x%016llx (autoload)\n",
+		       vmx->msr_autoload.guest.val[efer_slot].value);
+	else if (vmentry_ctl & VM_ENTRY_IA32E_MODE)
+		pr_err("EFER= 0x%016llx (effective)\n",
+		       vcpu->arch.efer | (EFER_LMA | EFER_LME));
+	else
+		pr_err("EFER= 0x%016llx (effective)\n",
+		       vcpu->arch.efer & ~(EFER_LMA | EFER_LME));
 	if (vmentry_ctl & VM_ENTRY_LOAD_IA32_PAT)
 		pr_err("PAT = 0x%016llx\n", vmcs_read64(GUEST_IA32_PAT));
 	pr_err("DebugCtl = 0x%016llx  DebugExceptions = 0x%016lx\n",
-- 
2.30.0

