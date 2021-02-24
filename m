Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D2C323F9A
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 16:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235820AbhBXOOO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 09:14:14 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:34100 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231840AbhBXOHV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 09:07:21 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11OE4Vwp095615;
        Wed, 24 Feb 2021 14:05:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=4EFv8kvbeqN9dX6NwGyvbIfSq8g5QrDUdhVAur6jsNE=;
 b=c+y2jE4pgUv+N3bgbGUGsjtpJAmBRjPPrbOgmSA/JEGVV4F2cwEWaOsXCqHIjPNPXTvN
 l5vTLgYqJ5IBjtg4kA17eQH5HSVu+DnLe7Xg8891lQ2UBmM8il+bOMiBw6SdY9PWTbUY
 ytVCpsAPZrxduVt8EZgOtWIIgTI3Fn6IeWI6imX0VGnBKswACPHxHIcgWTQthCL+4Jvx
 UObtE/eU8gaGfUisyKDBND2fG8+lYh7lc2qvDL5A3ahdSJeqOAVedivcW0XAbN4ojqfI
 vX28a5kM/F8T0oHj90D0sV+91EZoJr2VqsBSpfA5BE18uF0BKZvA55qKamUc+MNXx/Jv 6A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 36ugq3hvmn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 14:05:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ODscsm012587;
        Wed, 24 Feb 2021 14:05:09 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by aserp3020.oracle.com with ESMTP id 36ucb0sbe5-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 14:05:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lB7CuPbozbuH0Pg4zv3TRYq47dWXUs8yKgbb8N2OdkMyFTdZDeOHUL358sGc8O3xYWtju6sIrGOCiIM2kPbreTtec2qQwX/aMBSWy5xtQtvsi6gEV85PMR6kdVKkVyqMLU1TbVvC7ElbgVm5w4YS2kcXvNss1hbBbDZ53gYSMAMXbY9+H7ae/YkEbWGdnbKmHfJQwwGqOnI0PLGhc12E84A8sKBWecuGsasOwjKl8e6MTo2Zxu1TNvReT/3EecXGnhWzdkda5BOsWBiRkRgYc1avPiu/Syhd2HiK9HTGzjN4qd1XkZUvdtaWJjwmKA/dXnM43gX3P0BScQfduJ6WTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4EFv8kvbeqN9dX6NwGyvbIfSq8g5QrDUdhVAur6jsNE=;
 b=e9QAnr9dW8qxtLkyuGy3jT7zuWnZQB4LWqnAzKhisibr7etMbaajj9eicIdePm/eyb69cJ/ul+l+7OoT7pX3MW4G1Arys5iQEZURBFWdpglNnEMQSmCz1JkcuzWMRBRvpGLbG53k3xEZ/8RsnvcqfBTV11IKk43SKykqow69wVGwEoMIjEa0Pw98Gj5wEORZfgVBCIVoXoLiWxpmoPMc6LFTMvtVyeNqZSbrir5pht8aYI3Ju9WuA/j8Hf9ZrP89XadEXqQkUBwZvblKdXBUkBN/axlrQ+ILC7cwuanUpzFN1icASmD8gLsLinhZw49JF3r54TnxdJOPdHtc18jrsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4EFv8kvbeqN9dX6NwGyvbIfSq8g5QrDUdhVAur6jsNE=;
 b=fvDfp8EwDkMA3tx3JrYzujpquIAWdDBcafDfjOvE4Hj7ngcuxLsYhFwjBLLcNp6JZIq8MxCtbhlL/08At2Zgwc6CuQeBJ8d7KSqWD8rmNDemjoAfwHdGCkNJeVZyEcmYCgCrGN4+PWBQ46W5fHW56VR0t+BoBIHNsa9CMhtc9pQ=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3148.namprd10.prod.outlook.com (2603:10b6:5:1a4::21)
 by DM5PR1001MB2153.namprd10.prod.outlook.com (2603:10b6:4:2c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Wed, 24 Feb
 2021 14:05:07 +0000
Received: from DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934]) by DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934%5]) with mapi id 15.20.3868.033; Wed, 24 Feb 2021
 14:05:07 +0000
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
Subject: [PATCH v4 4/5] KVM: x86: dump_vmcs should show the effective EFER
Date:   Wed, 24 Feb 2021 14:04:55 +0000
Message-Id: <20210224140456.2558033-5-david.edmondson@oracle.com>
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
Received: from disaster-area.hh.sledj.net (2001:8b0:bb71:7140:64::1) by LO2P123CA0070.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.31 via Frontend Transport; Wed, 24 Feb 2021 14:05:05 +0000
Received: from localhost (disaster-area.hh.sledj.net [local])   by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 54cc0463;      Wed, 24 Feb 2021 14:04:56 +0000 (UTC)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bca8fdb9-fa4c-41b5-b971-08d8d8cd30d1
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2153:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2153E4CBE5028DF2714DA2B3889F9@DM5PR1001MB2153.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FZrxy01BwzZ2fZjNGRDmHbxHe0Uq67vSj2mwZmhmUu5icf7DWSXVPIX1i5SQ2RXusqwKkOlooEn7tBd1hpJiJ1B1QlSTrhhpy46T3B7O+LFGwj4WKRjorMP3KoWOtYESzP9dWrFh+Rrzdo7IqhEqYNktfYQKfvNohbFBq65Jb7ddcWiAOm2xoSWhbWAQlDkt1rz8fKeEokKAxlPsuArYxEYl+CXudZYfzkNHHDY8a5y1RzTtQL9mKhG0fejXlqOg6Q/UxB9Q0JdnrEnkxfGre6fa5PLVsfwa/1nPlmkUiWCy4nxOvBMV6FjaubBwgcycZNjpC0W2DRxgLme+dnZEI0QVesMKTPgfrXEMh1dW93pbZWqESBugKiracV66ysNX2TnlbnaqY08tYdY1xDXnv4s4lxtWEA7JR/4I2ln6A3EOhtCDV63JuCMb38ShO2hxLwKZcS2r1XuK07m6R7WyvV+duCDlVW3wqduT5JKgi8SjCqRU06QDcET3Y5AHnS5gkcRyAGU6VWL/NZlGMYNpUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3148.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(396003)(366004)(376002)(83380400001)(316002)(66476007)(44832011)(8936002)(186003)(2906002)(86362001)(7416002)(8676002)(66556008)(52116002)(36756003)(5660300002)(6916009)(54906003)(1076003)(2616005)(4326008)(478600001)(66946007)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?UOzKmhofidDxRLIR9ifCyyyvyIhopyEdRqk+aAlveUauC5QN0DtMrnoe72E3?=
 =?us-ascii?Q?H+NLYyc7X6lppSzmAfOHWWqfax/qs7DAotDicCWbbPCr+aZXlQsUXH0qYIuN?=
 =?us-ascii?Q?AuOILPcA1rj/pwrASWEi+0mPETbqFbrVMlQWvkxBxKJKE3LRh9AeMYZtOYYo?=
 =?us-ascii?Q?Sj/EWrQiIXgUU9OVFnvy8+g/ZIcTllgp0+FAD88hhQweeOTE/2HpUu8mDnwU?=
 =?us-ascii?Q?sF2+qYXR/P1V0Y91vjpadFCV/kl26+h1RuS1FZFzwj3dhejv9WpCuIZIET8f?=
 =?us-ascii?Q?/Bo1xwtw/qSds9F0J/bw65+Uu4vYQFB76Kd60niC4eTq8keg0J8nJhNPxWXm?=
 =?us-ascii?Q?t86dBLgHvg6X8ncW5q/O+bi1Shh4Qg/PhYWH9Spa8cZSS+gMQ6QEK3C0+ytl?=
 =?us-ascii?Q?HpgDgqCMDXvx7HZDIbFMKg3gwnKKl87NDidzb33Dp5XEGzA8qJH2sfYOE70k?=
 =?us-ascii?Q?QG9y6oMDPVb3Op8qxu8dhSOMgWntk13LspSgJ4Y4uzaqIbFdpJIXzqlA86Ic?=
 =?us-ascii?Q?l7rb4c/XatNFkgD+Fj4SzE7l9ciW4ObMkXCGy43M3A476wgPmPsDdqa+qe63?=
 =?us-ascii?Q?mh3Iy9xa9/ELWBjZlKOAi4IJUTPo2UxW5r9A3Tq9CSgz1lcnl7Vu/RPHiU8o?=
 =?us-ascii?Q?qXVG4OF38Q7o5M47LGJJ8nGHfZusuyamN+EBtYzB41ZpXrxVinhsqTNE0pYV?=
 =?us-ascii?Q?22y9hzzQgOu3Ec+LPIJUBTCcNllQI535vdFvxQzieGOwnqWXJK9CghTJOutu?=
 =?us-ascii?Q?K11+VhwQDwxQmRaZwt1MPBGXBls9RP8+5CVVL9ZMf3X19nSpj2G2dZwYwMiU?=
 =?us-ascii?Q?zQfgroQdZAg/e1bMkWB2TsnEEJjPnu41luQtwzxn4EcBpPhMYbX4EHioFlv2?=
 =?us-ascii?Q?OAlzvG+ZEfQE6In5YOBmlY6uXZXb/P4Kz9fwGr+4HqbrTOjNnNIPwxwOy0Te?=
 =?us-ascii?Q?41sXdT5ZKeNP1OCvE/gPnUswMXrhX5pIAPAfJ2aHBSxRXyAhGwCk+jSHYcAQ?=
 =?us-ascii?Q?H2kjyOcnh2kwZXGGngfvhP00hp1qtnYzpMFTKp6bElrQhTn0YIf08G9Z4Nql?=
 =?us-ascii?Q?qgSgr1zyXJHi1eDrSvYJ3g2pBO39dlbOdPaMA6WLZ+lPHmBv1vj/PIJAasPc?=
 =?us-ascii?Q?ZLD5A6q9TM4LzJvxXemcxicTy2nOoa9KmRbdv+Oj52U6FXzn0QkLH8zK7JLs?=
 =?us-ascii?Q?SFoE95niY5AnXARoMo6jnTu2q8N1WsMGGEAMW3yKgvpi5QiPBAv1l2k6LAs4?=
 =?us-ascii?Q?Q2FFCV0tj3BFbM1lm1fBPPt8Xg6gi1jBvqgDj49CuHj38JSgxXwiPmOpJpp8?=
 =?us-ascii?Q?7Lo7Myxo0ef+/v6BzIjenUmFZ4Uwk/mR22P4SqHi7rODYQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bca8fdb9-fa4c-41b5-b971-08d8d8cd30d1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3148.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2021 14:05:07.3820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lLMofpzdzG4LiZsgCXDBMPrBDjYA47VYMV9vX35POCxB1NrnsCLML1PrpeEyu8KFXDK2OIgJ+qCN12l/SWGHX0Pgx+wFDogd2GFeCZfJTo4=
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

If EFER is not being loaded from the VMCS, show the effective value by
reference to the MSR autoload list or calculation.

Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 arch/x86/kvm/vmx/vmx.c | 20 ++++++++++++++++----
 arch/x86/kvm/vmx/vmx.h |  2 +-
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index faeb3d3bd1b8..b9bb66ad2ac4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5810,11 +5810,13 @@ static void vmx_dump_dtsel(char *name, uint32_t limit)
 	       vmcs_readl(limit + GUEST_GDTR_BASE - GUEST_GDTR_LIMIT));
 }
 
-void dump_vmcs(void)
+void dump_vmcs(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 vmentry_ctl, vmexit_ctl;
 	u32 cpu_based_exec_ctrl, pin_based_exec_ctrl, secondary_exec_control;
 	unsigned long cr4;
+	int efer_slot;
 
 	if (!dump_invalid_vmcs) {
 		pr_warn_ratelimited("set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.\n");
@@ -5860,8 +5862,18 @@ void dump_vmcs(void)
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
@@ -6008,7 +6020,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	}
 
 	if (exit_reason.failed_vmentry) {
-		dump_vmcs();
+		dump_vmcs(vcpu);
 		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		vcpu->run->fail_entry.hardware_entry_failure_reason
 			= exit_reason.full;
@@ -6017,7 +6029,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	}
 
 	if (unlikely(vmx->fail)) {
-		dump_vmcs();
+		dump_vmcs(vcpu);
 		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		vcpu->run->fail_entry.hardware_entry_failure_reason
 			= vmcs_read32(VM_INSTRUCTION_ERROR);
@@ -6103,7 +6115,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
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

