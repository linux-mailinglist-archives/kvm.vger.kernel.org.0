Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2296F323F9B
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 16:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235840AbhBXOOS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 09:14:18 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:34096 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbhBXOHV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 09:07:21 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11OE4iVa095666;
        Wed, 24 Feb 2021 14:05:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=uvFeAWBXTu0gwLlT2ZXkYAyKT7A3jO9ZRxUCFG5wi0o=;
 b=nDg6sACJo7pJ/iWW3cTtdJvkgr89JF1pXEbW8f2Yts4pavNLE2oZc640SICaiM1TM5fh
 OCHlyxGjphp3XFOBl83KhFf8a9iKdMfWWVrW+l0/4bw9kIpb+kNAAo9Eb9es/2d1auUn
 MWyY9AnVo5GmII4bGP1/YR+tXkV0wEq/3gPCoZSSiGFEkazaRZqRr90OomzMCg9hyNTi
 LdOULr0gXlPZWxWls9kE3nmCE2q1DANrs3qf1x2HaumaFOMjxmhWKXVYgxlrOKksmAta
 Xi8pUbXpY/Z4GD//pgoWl2BBayVFTFna8XvOGHVg7fUhKgYFCetY8jRxXmdHr0Pf7q1Y Mg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 36ugq3hvmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 14:05:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ODscsn012587;
        Wed, 24 Feb 2021 14:05:10 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by aserp3020.oracle.com with ESMTP id 36ucb0sbe5-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 14:05:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AAYNVWFhI/Qoc8Kqj9TY93xKzFkAC84jzzIwjL+PepD+smTurKdpYuVtXL/ziWFiAzdqfX0FesZuDcRZj3G4P0esMdHEPakRm20iW0HI+XzHtBCl/2XYphinYkyp32M5KcleH7jh/WQOokNDGubeNWx59C7cNKG3XaddQW+MLvO1wxQdH8ZyAOh2ORB2Y8jHv5gpsOrp3P8av8GcFGEn0Y1M39mEHOuFsDdxGe2eUeFYB+tWIBURV0fB5KPEnsidT+JZBrZ6znn6kU8cYxKks+qX1bxEaTYa1mGzY1xMtBLZ1byVpXMDWR+y/166alyTnMWkbDUMiKLBKVCgskYjOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uvFeAWBXTu0gwLlT2ZXkYAyKT7A3jO9ZRxUCFG5wi0o=;
 b=SkbNjpZS9TUJ5LdK9JFeZ2h2mYj2tzJkMhEg7g04KKdAAnDGdLWR+rfeYVU35KD0bHW2kd4RB/qsERpCSi/uudlegMTTotZv8G2glN6b5TqeaGHO20F8wlEkuIRhUGgKKViBi379ZA7fIwewNQjpwE31wTQU2MzmLhbD1h5oAuQOYTf/UdMbTdsgaFZ8xqPYX1mEsnMnAh0Pysu1RlFKot65fwei7ZBTGheQkPJLBR6GhGXgBofIaOTl1Qetj+ovnXxDPOFJ4HxLtcZzKzdxFom+a3cSt7N0W9ovs7aO9m+vcwZlVM9B1WmMR1/XUjUoGAyeKChMLtn1eACu1YzlIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uvFeAWBXTu0gwLlT2ZXkYAyKT7A3jO9ZRxUCFG5wi0o=;
 b=YKBmOptsszHSVN8fO0Ko1VRkxAhWbJsqz6qFfoWEGZiB0McIrx6ghpybRzTYxgBgSN20UNgOho7did47cqlYj4iHXruMnuDARZfWCCqDjezVEt8Le0DiFMSl4lrN/t73o9B6iwwSSuzb65cmQVZXZDCIplgOn4UtpkBe1VNNjck=
Authentication-Results: zytor.com; dkim=none (message not signed)
 header.d=none;zytor.com; dmarc=none action=none header.from=oracle.com;
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
Subject: [PATCH v4 5/5] KVM: x86: dump_vmcs should include the autoload/autostore MSR lists
Date:   Wed, 24 Feb 2021 14:04:56 +0000
Message-Id: <20210224140456.2558033-6-david.edmondson@oracle.com>
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
Received: from disaster-area.hh.sledj.net (2001:8b0:bb71:7140:64::1) by LO4P123CA0411.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:189::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.30 via Frontend Transport; Wed, 24 Feb 2021 14:05:05 +0000
Received: from localhost (disaster-area.hh.sledj.net [local])   by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 4dda7ddb;      Wed, 24 Feb 2021 14:04:57 +0000 (UTC)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1254655-00cc-4c95-e595-08d8d8cd3103
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2153:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1001MB215312C137148C74780B3BFB889F9@DM5PR1001MB2153.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bKqK9tgthmwX3h0/dSjJMEfwmpcj9pJQA6TwY7jjrv0KAXKpICg/dqK8YDj9PMLH01+pGr+HU0GTStG8hzrsc95HkLt50i97O4pr0Xo8R9Kf3BF+EOFXEhGDGAb4oYtQRk+3SbAzLG0zXjgCR3NGpCW7r/3kzG+MVlXPsIrHlffUO65FN5FkF6E0K7aqiV+3bhk3ikkrvOVVwI6Cc4u1pGa3WJ6pQHLrZhfyEDw+Ib8yxvNDvRTLGfRT0GiiQmwDZBsA6EUWOttzDA4g5JU2hVBfyWMjnlOIAweBWOyGP8VwLeXwKGUsE+hdAbLhLcj86I718R3+5yRrMW53Wow1triAThspBBF9jsz4ZWtX60NTmmIh/tE1EKe1r2yQYQoawPlBMmFjmW8kVoW/kzPrbq7jBHJc5onqJp1ILwkgmibH6casjd02tX1E65PA83zQ4YxUaGHvYL75tqYH/6nBV2+HFTTrlE4XYzHZpzK0GOOydl4q2qipJdrF3XJGijlji8er5ZB12gI64+ADePYmoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3148.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(396003)(366004)(376002)(83380400001)(316002)(66476007)(44832011)(8936002)(186003)(2906002)(86362001)(7416002)(8676002)(66556008)(52116002)(36756003)(5660300002)(6916009)(54906003)(1076003)(2616005)(4326008)(478600001)(66946007)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vEkkc6SRxA1mTn1zd+SAlgepokDtcKbba+yzzuBuWxsB5CbBu9oeEsFV6WCK?=
 =?us-ascii?Q?WzIQ5hJ0CARdhALV6b4Q7wM2RXO4EHCcF2sfHUDwfoSF/QSMnuTanbUOHWXB?=
 =?us-ascii?Q?RxoVXJPWRgn4VI5UF1GUtIZUQm4F+Q0bfQClcrrD65GvJLOw0C5GHtfkj2VY?=
 =?us-ascii?Q?jesEC9ZnC936HrFyeK1yAeWyKagttUOMynYit22de6tfioDykPKJy7v6wjpZ?=
 =?us-ascii?Q?UAUE6zMLfGN5QzjMlYNWqC+DZTaHkE5GEYGB+3MJjBarq82cUoaGgyfnIABC?=
 =?us-ascii?Q?GprmrPOzO1Lh6x0n5L99XWcJCf+zsV9uW+OSafpwJeHov4OW1fI3R43OTUmX?=
 =?us-ascii?Q?oIeyab8jeVJyfO+BwxypGdTczl5rNVZNr0+/sdDDcBLTivRehLrOjdXfwf5J?=
 =?us-ascii?Q?du0L87pPQuTogcJAa9psWyLUwVfiWqv8CMifL931QY5cq2fehX9UjWLjftqH?=
 =?us-ascii?Q?/ensJp2l9KgneoWLk0qtxVLVxgRQ/3hEcvy0QpHmuQqGDqxwR0ISB3J1GNBo?=
 =?us-ascii?Q?kE6FZagoQsXsXiWCgTseIIs57vBSLtzc595EJKxSiaNZepfJhcYXrmG2m7Vt?=
 =?us-ascii?Q?K9JxHe2OBVU1LTuTr1VRD/VGbLps8VjMfIwkpuZUU7sofTt39RQwsJKuHpVu?=
 =?us-ascii?Q?raIq7eF3mIBeeYaGOxXXYxbDWUy/NdIGW1ZYkskS7EknRtxXRoy34W4O7SKN?=
 =?us-ascii?Q?pPq1+tq84alcjtcU+dMFo1Q35KS6cHVrp3LiZnnJB7FafXv4AMk2UZjgLpmW?=
 =?us-ascii?Q?+fmF6BYa54QKCQd5QGn7b1Jqyq5+KprrN5D7bdI8nQUP3g4t9Z2c3P97qOxb?=
 =?us-ascii?Q?faUbdPoKaIrYYUTWG9TKpEmX5gHqqH9LrOqvKAclUVVgvsdqJvhc16zDeGDM?=
 =?us-ascii?Q?0zYydLNF/IRCFopUsb1ki994IDbiNmDYgI+pSNwODubSsKNPYLONiiJUOT1R?=
 =?us-ascii?Q?r1Cxuh8JZqjPXm0sNn5uqpxZm1z+WRnCDY/NaLL//jaNzCKysQFmIsjGnJiP?=
 =?us-ascii?Q?E/ZzAZJ5HIm4D+9V1CY3YnCUzWy+jjGey/NlmXMNR1ALlMUDiiaEQVDz4xVy?=
 =?us-ascii?Q?+UnUTPPoWCEy6EnE+77XbxUPNqKKdedhW8QP+/Jq55LlCi9dZ1kzGlEOQ/mt?=
 =?us-ascii?Q?PwxWQvKS8JPaAPZQH1mpateE3HWK9Yf1bokRSA2GdXKRMo4aYY6f2SsO5/3F?=
 =?us-ascii?Q?41MFv92cVvQDy8DGNVBEiSKXGX40vT72zd8gGsKE5hE5ZTIeOZ2urvLroIWD?=
 =?us-ascii?Q?MWdXP54bYW4RS7oSsHodsqAB260Sn6FvAsI7aiOX9H91rU6F03oIgnSZujCx?=
 =?us-ascii?Q?CWrQhXkJyeORhSPvAbkQpfRnu+oa8CcBuKlf3lyzhP48oQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1254655-00cc-4c95-e595-08d8d8cd3103
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3148.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2021 14:05:07.7218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /FQS24TtsUswtqeqUTOvHh9FRwjwFbfrfp3ADyi/ak2bOcXsRhYOyuUUsbMgtg8lIa1/dRDplwL+o8s8Ez+zsfLuxDGK4a4CBaHYwp4o29c=
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

When dumping the current VMCS state, include the MSRs that are being
automatically loaded/stored during VM entry/exit.

Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 arch/x86/kvm/vmx/vmx.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b9bb66ad2ac4..de42b8c14a38 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5810,6 +5810,16 @@ static void vmx_dump_dtsel(char *name, uint32_t limit)
 	       vmcs_readl(limit + GUEST_GDTR_BASE - GUEST_GDTR_LIMIT));
 }
 
+static void vmx_dump_msrs(char *name, struct vmx_msrs *m)
+{
+	unsigned int i;
+	struct vmx_msr_entry *e;
+
+	pr_err("MSR %s:\n", name);
+	for (i = 0, e = m->val; i < m->nr; ++i, ++e)
+		pr_err("  %2d: msr=0x%08x value=0x%016llx\n", i, e->index, e->value);
+}
+
 void dump_vmcs(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -5891,6 +5901,10 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	if (secondary_exec_control & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY)
 		pr_err("InterruptStatus = %04x\n",
 		       vmcs_read16(GUEST_INTR_STATUS));
+	if (vmcs_read32(VM_ENTRY_MSR_LOAD_COUNT) > 0)
+		vmx_dump_msrs("guest autoload", &vmx->msr_autoload.guest);
+	if (vmcs_read32(VM_EXIT_MSR_STORE_COUNT) > 0)
+		vmx_dump_msrs("guest autostore", &vmx->msr_autostore.guest);
 
 	pr_err("*** Host State ***\n");
 	pr_err("RIP = 0x%016lx  RSP = 0x%016lx\n",
@@ -5920,6 +5934,8 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	    vmexit_ctl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
 		pr_err("PerfGlobCtl = 0x%016llx\n",
 		       vmcs_read64(HOST_IA32_PERF_GLOBAL_CTRL));
+	if (vmcs_read32(VM_EXIT_MSR_LOAD_COUNT) > 0)
+		vmx_dump_msrs("host autoload", &vmx->msr_autoload.host);
 
 	pr_err("*** Control State ***\n");
 	pr_err("PinBased=%08x CPUBased=%08x SecondaryExec=%08x\n",
-- 
2.30.0

