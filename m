Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE10231FB38
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 15:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhBSOtB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 09:49:01 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:38414 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbhBSOsi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Feb 2021 09:48:38 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JEiRlH128023;
        Fri, 19 Feb 2021 14:46:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=QXIBBWVhpomgz5zwYC4F4Lw1Dcc0kxfwnpvDg2axzxw=;
 b=x99wNTpVV/I2gTizy1wNdZFqrI8fZ+XXCWrTxStKnqP3IoyiRGRu0v42uGgbNGfWMYq1
 noG+UunejcEfs6wtTSBaeDIP9Bo1q2Lror16yP/kHG50OboPd3t3HhL9dKJ0dXMI4NhT
 D/pqx4X1R7lMoIUO7420Hi/uPThfBVrWvY9n7MQrphN5ia7DBkabeUVlMbGK1aO5ZDzp
 9k7ejs1qtCYZNCpJkIeG11BtQfuiLcak6qVVF77OpM1z4vUH52QJdXdX2IY+kHgziRTf
 OrXKwogaC1UICRyBZ+7KaBHxDbY/OZBxT5MwUjqzdk98DdqXPbY7z07ovlistvm4imG9 VA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36p49bhvqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 14:46:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JEkDpW144884;
        Fri, 19 Feb 2021 14:46:51 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by userp3030.oracle.com with ESMTP id 36prq1ycm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 14:46:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mrPyusMrnrUmqPl6UVdH6fiyG9DMWZ1h4gwQ1ehRxQB3yKG3YvToLngPepAmizbnYurm4Js9jXJhc8i3DhcZ+EK4uapecf14AlwTuFfHggYNIQLEp2UYLa7bzIsLx5o2MZwVYahEVsjBeTRKdhzgHF6ReLtKcjxRy4DhmqGnpLQPhMM3+5bQxUeApZQL9hBrYK41rKrwdd9sDw9WJ7mDpidGu3oX/GeRUUqrMMuZ4utTwR3L/OmiEZc2aqmKCjSZ22aivj2x/YMCrZFZF9oKi3KgNk9l965IXRsxk4EqDvXmIW0D/cCC7MDqPZvmht9jyc2fzzPMNsWN+3qPc2d1VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QXIBBWVhpomgz5zwYC4F4Lw1Dcc0kxfwnpvDg2axzxw=;
 b=IyrdvM6ogisW34Q5D8QtJY3Qgye7Y2VzD4PTbb4+Mr0V5cdLqdCsWlfWirZMwY5vR32LIRxdhemj9wvoucHddqbWoUamlenjXoO/mgCJ8Z4l9cQGty19lROpfI8fCGHkfyamj9lVOHQWUadnmy/bLrgtb0b3EwqYUSdjeP4+zUFxx5g4uJeCMgVynQWM2NgUc7pEBhrC+wJ8E0nku2oBnYPs+9+7Sl7UppKrQehJHOnU5FEjVScnNYNNqsDliduTEppNQSro4cskm0DMdsOcrf9qyf9X2b8mPzjZ2s6Vhzb44xzE4ZGM0Kk54XhOtUqj0SencizCAKU6lBteemTXtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QXIBBWVhpomgz5zwYC4F4Lw1Dcc0kxfwnpvDg2axzxw=;
 b=aynB/Wnvdqzx9beGl+mcvseuuKpDtVSLt31rt9lcraoQgtKBdyWoVL0c7Rzh3wbJEfFEeYoDzqOiMjYORzq/VDSRVJB/XOj1exhbqZ/pV7OBBZ2QAiGb2woPFubmtdGGqjZ2nFNRYqsY6F3ByPUx9X+FOi9WlWTjBvUvm8mXWO0=
Authentication-Results: alien8.de; dkim=none (message not signed)
 header.d=none;alien8.de; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3148.namprd10.prod.outlook.com (2603:10b6:5:1a4::21)
 by DM6PR10MB3466.namprd10.prod.outlook.com (2603:10b6:5:17e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.31; Fri, 19 Feb
 2021 14:46:49 +0000
Received: from DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934]) by DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934%5]) with mapi id 15.20.3846.027; Fri, 19 Feb 2021
 14:46:49 +0000
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
Subject: [PATCH v2 3/3] KVM: x86: dump_vmcs should include the autoload/autostore MSR lists
Date:   Fri, 19 Feb 2021 14:46:32 +0000
Message-Id: <20210219144632.2288189-4-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210219144632.2288189-1-david.edmondson@oracle.com>
References: <20210219144632.2288189-1-david.edmondson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:8b0:bb71:7140:64::1]
X-ClientProxiedBy: LO4P123CA0291.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::8) To DM6PR10MB3148.namprd10.prod.outlook.com
 (2603:10b6:5:1a4::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from disaster-area.hh.sledj.net (2001:8b0:bb71:7140:64::1) by LO4P123CA0291.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:196::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.35 via Frontend Transport; Fri, 19 Feb 2021 14:46:40 +0000
Received: from localhost (disaster-area.hh.sledj.net [local])   by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 0c6e3e79;      Fri, 19 Feb 2021 14:46:32 +0000 (UTC)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2e4ac86-7f58-490c-ba69-08d8d4e52c2d
X-MS-TrafficTypeDiagnostic: DM6PR10MB3466:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB3466171F7B89E7499D69775F88849@DM6PR10MB3466.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XBcIb/hWE0mLSKq3vm+8ZFtEDFkrtHE2Blqvk8Bz+N/GiyEw5NWxCsovla+iT7ITEWm5NJmELD8FqM26LJKIZVFFNCtiPQ2xlqJnOwsSiT7JRwpDbGIiR53OBA06vcc9K/qf17qVNl9sEsjigg6HeobvFPBwxJqrDEISkkvT54CxmzR090BMC6erKZnkX+kiE0yDihzQcU0unGiG873N1NG8O6z8LlqQoc4BD2eJ5L4EMLd/mCZZTkmnjfSGvvd5G23KBCwB7I5AhxikKp5Q5+a9ggabiJFjMSspwaetazq7xGTa5drsnXZn/CDNOpYQW+SWJ9X//leKE29BgqztT62uSWJGXHPCqMCxexaLqqHaMmwiiapS++MLOHw0MUdU83mPYhV96FmTD/xkdSMp3eZt/vw4j0+v3j0fH7ElCviTUoQ7sY402Gkf8b1aw/knHXr4lgPpD4LqG5pBR/JMJtLIO9dcB4mSGqT4/QbQIkQyJtZBlESBT2cTROcKTP4JHHYjjGuxhpCwRFGXfsxMFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3148.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(366004)(39860400002)(136003)(346002)(36756003)(316002)(478600001)(8936002)(4326008)(52116002)(7416002)(186003)(54906003)(44832011)(107886003)(8676002)(83380400001)(66946007)(2616005)(5660300002)(2906002)(66476007)(6916009)(1076003)(86362001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?TLgH29Vlfm70jjhgNDtPpY1fgcUjvRw4pATTLKe6/AXnEXgdAyoqKX1jNZDc?=
 =?us-ascii?Q?KjMpZuToQRo1k5Ila5i4TtEZEyZJ1ncG20b4ZQU2iSCqHLXZO0SN5mPqUUwR?=
 =?us-ascii?Q?v8p3bfXvFbP9xhnxb63gqPOlpQR+zoM0kmueVHncvNvZp+3Vhf4SLS6Q0wgz?=
 =?us-ascii?Q?Y6g1noUoBYnMmNDqr0ncBdI73gb7B70aQcAbK/Y7sRsOc7dLaBoCaOx48uoM?=
 =?us-ascii?Q?XaPffeLURREu3nzY0V3VG9EfrM8xUc4yVtImtvNITq5P3zrPAaoPW/80NUid?=
 =?us-ascii?Q?CpsRv35JGlH3j1IpgOFDU5qevbPxnc1IdnzCwBKjLLj65wEGMkSFd1j2+OEm?=
 =?us-ascii?Q?xWOAiSkLBqxGiis2jdIokHMKHcq1pwld2ueE4bLjC1XF78NmUeZsAZtgE7fc?=
 =?us-ascii?Q?7HSWv45XuhcumF7M3vl5tBs+qW8/vjngbuFeogeApWuYviJxktSVsroOPlmt?=
 =?us-ascii?Q?NPR1n4aix5J/OdVUnvGgiKSHMOt0ngxI6JSWv5Gx/4YgK5J6BEa6xHv72OlH?=
 =?us-ascii?Q?jJsNyiW/YZOeYNIDuCM9fWnos+TWnleI+UjslNQgcXzewIdZekc0zv+SV29P?=
 =?us-ascii?Q?9tXjGVQkxk+IyIXRN0WH09pPtQsb2qFG9l1lKA3X5+tFAJC8bnJZhajIRfoY?=
 =?us-ascii?Q?dCZ2dCnhRdwUu/6t2jhPJ146fe0B3V3ByNAMhCRcBQCoVHiWwe0LwglM39Mp?=
 =?us-ascii?Q?jWkX4Ot4NQg0xqxDtUBGZCJF0u/NpYiIw7STpLM06ZLIuQtwZh+FQ8lofVCL?=
 =?us-ascii?Q?9HX+33pzFX7I15HBwTJX7R3w6i0DM+/qvZpqxVVkKEZ3AxLf50lxmDPvEVsv?=
 =?us-ascii?Q?Gm8I1KW+XdKg21FRp6S0S8zfyMPDdDFn4kPZURmARQdOUHAUYcpvEphpN+qA?=
 =?us-ascii?Q?ItREULuaNdYw+K7VHQOvbyBd3UaChf+FuoRV99WpmBYTmxqohtb5LfgEZ5w+?=
 =?us-ascii?Q?MNLPoJGs1igPpmOO3gBoDTDrqDvScyMlwi86Nuy3NvPjZmeo6MgubO1q2z+Q?=
 =?us-ascii?Q?qiqJ9rrorgp3kDM5J+KqHB1NjUD9ktTImifSbG0stQejqnTiGA64GnfkBXgN?=
 =?us-ascii?Q?KICyqx3z9JdWq0YP7pzBWqyJNY/LDZBshqePpRyj9lPkZlq1K5EXn/JtK8N3?=
 =?us-ascii?Q?eC2gVX5OFZWBsVho68J9MsTqjlnhN3mGcl95fX5MdgyOXdSuKOQxIY8lxgbf?=
 =?us-ascii?Q?qPuQggCfWZinhAzD+oaFCFw1XSzaR5ZdQgSp+psRvkfhzoncwNO5MJOVRR1J?=
 =?us-ascii?Q?B6fr0MEiBD/wHVcScDO2CPHcIHvkYmYB7mpqbEfzsgdZuAeetVTYth/PGokh?=
 =?us-ascii?Q?EwpCSPhRwE940X1u9mWmIk2ATeFmBXL3no67OHnS6FLvXg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2e4ac86-7f58-490c-ba69-08d8d4e52c2d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3148.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2021 14:46:45.0095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c3XgJmh/ebwjG3VOkrJk4k4f3dAZLmDel5vYY5UG1DsNKpfdyCZq2SOVW0FGjJccamupniFEc4GYN6p1Hu3BRXrscN+00x/TNNVEUtE8TNg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3466
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9899 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102190119
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9899 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102190119
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
index 25090e3683ca..5dbaab73e576 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5754,8 +5754,19 @@ static void vmx_dump_dtsel(char *name, uint32_t limit)
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
@@ -5826,6 +5837,10 @@ void dump_vmcs(void)
 	if (secondary_exec_control & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY)
 		pr_err("InterruptStatus = %04x\n",
 		       vmcs_read16(GUEST_INTR_STATUS));
+	if (vmcs_read32(VM_ENTRY_MSR_LOAD_COUNT) > 0)
+		vmx_dump_msrs("guest autoload", &vmx->msr_autoload.guest);
+	if (vmcs_read32(VM_EXIT_MSR_STORE_COUNT) > 0)
+		vmx_dump_msrs("guest autostore", &vmx->msr_autostore.guest);
 
 	pr_err("*** Host State ***\n");
 	pr_err("RIP = 0x%016lx  RSP = 0x%016lx\n",
@@ -5855,6 +5870,8 @@ void dump_vmcs(void)
 	    vmexit_ctl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
 		pr_err("PerfGlobCtl = 0x%016llx\n",
 		       vmcs_read64(HOST_IA32_PERF_GLOBAL_CTRL));
+	if (vmcs_read32(VM_EXIT_MSR_LOAD_COUNT) > 0)
+		vmx_dump_msrs("host autoload", &vmx->msr_autoload.host);
 
 	pr_err("*** Control State ***\n");
 	pr_err("PinBased=%08x CPUBased=%08x SecondaryExec=%08x\n",
@@ -5954,7 +5971,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	}
 
 	if (exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY) {
-		dump_vmcs();
+		dump_vmcs(vcpu);
 		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		vcpu->run->fail_entry.hardware_entry_failure_reason
 			= exit_reason;
@@ -5963,7 +5980,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	}
 
 	if (unlikely(vmx->fail)) {
-		dump_vmcs();
+		dump_vmcs(vcpu);
 		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		vcpu->run->fail_entry.hardware_entry_failure_reason
 			= vmcs_read32(VM_INSTRUCTION_ERROR);
@@ -6048,7 +6065,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 
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

