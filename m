Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3F364D108
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbiLNUUu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:20:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiLNUUS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:20:18 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on20601.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::601])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7E133C08;
        Wed, 14 Dec 2022 12:08:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GphtGA4gOyGS0xHy7Jz9c2jBm211YnRlti0Bjzh6rhVZWFph8cVR0dSnDA+zqwUBu4innzWZYXhzA+3lKDOgREaPdQBCGWm5OU4tPjkvRGtA3R7P6dxmNC12c9IorGa3WSZy5GHqAgUh0iaFrJQr5QVdfvLC5eY2fSyMpjdmPRASCv5VTg4Pbv/9XFhHAYd5/i+WQBqJUwhVgnYK0yyqgU3k8GXWnXglxyiuZYH0OyRnZrV8IXuCSL+ntFu+0/GLHC0o+EWOsnCrd1HjkO/JkRAUM5ZkU68DkfbUUe+v4rS6mGB4d3idsWoS6mJV2ID4gvIRTFkLAdV1NWJOpwbOEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SzMxwYpfyh7XFqtLB97O0RIzVpulsDfAAiXFKloaZjM=;
 b=g9kLDrfaaB+4Ym83OPzEfb0b5PB7y2BjVX+esu98sqvOpd2d2MglXHYc/EhAM19VSJkIyMyHz/kSeZ/ZKZ7dCnnNl/4KB73/U325HEnuYFbpYrhJst9EdWN1KCd8ajEnECQvyCnDXzj7udZPujvWI7DBw7uPG/+uJ724Vjqo2SHPsW8x5NsNt4xJbyUbRDO1kWjglQhVndjZELLR74OSCQ/Kulc1LBquEMy3x0QuqJJ+nNnt9jT1bhdVOqe6XEubE7LLQu7ExikJSJ1ZMeF4KedouRql3qovR/SPMRlyqHd9jT2WNmLbzvbIDh1CZuO3G+sWB9bm/DUbyIUprqRIyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SzMxwYpfyh7XFqtLB97O0RIzVpulsDfAAiXFKloaZjM=;
 b=uthl4Eu3LMMMLNn7XH591fraZvSbUrasyB1sJGFToQAidqp9IldXjkIjnxNMHneb2RLNR33gA6eYDWfXIX8Cmh84nOBsBXlq3vvVNwNZzgGw/1Uz4YR0VmPW2Ve9lf8EneWGpZ/FNXLQFv7vqTsBTqNp80K8/MAub5YTb7T3cW4=
Received: from MW4P220CA0009.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::14)
 by MW4PR12MB7141.namprd12.prod.outlook.com (2603:10b6:303:213::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 20:08:48 +0000
Received: from CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:115:cafe::14) by MW4P220CA0009.outlook.office365.com
 (2603:10b6:303:115::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 20:08:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT028.mail.protection.outlook.com (10.13.175.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.11 via Frontend Transport; Wed, 14 Dec 2022 20:08:48 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 14:08:47 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Nikunj A Dadhania <nikunj@amd.com>
Subject: [PATCH RFC v7 07/64] KVM: SEV: Handle KVM_HC_MAP_GPA_RANGE hypercall
Date:   Wed, 14 Dec 2022 13:39:59 -0600
Message-ID: <20221214194056.161492-8-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214194056.161492-1-michael.roth@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT028:EE_|MW4PR12MB7141:EE_
X-MS-Office365-Filtering-Correlation-Id: 7789cd11-542a-4e61-74c6-08dade0f0342
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JxE58TbV2E+WNdeUgEh6tyiJlKDbEUSBe77xbaJRTZwknrvt96OxXLiReLBAzTtnFOie/h2pSRT1fpt+DFKuqqwjK7c3FnuzyLAs8IafYkYT6A8HNyt0UsYROuBx+9FnyIUPYBd3adqej8/TRNxGjavVOtOwlCADwPu1xwGCsseTeQjJtonZac5WcEiSKasjZQz3OVbcME4bOsqq9t3oO/2God62VYAG63mEtkjGxZmRmZMDbgb6+AG/0UOAmG5DWBWGjWMjhGZmz03bcYHaky+9EDxcKiNgAz7twCplYUME2r/OR2oE3iyfEtfzBL3Kcsd8jvl9zqBw0bWnPXgGPxvuG1VUCkrDag72qQF7bYqYh9mao9LA13Wvcdw+E+X2f9J9tp9EIXl+092AJVaQ4pxo6qrbgduOHvxOPwczsYcCZpwPEeEhsMjFSpAZmm+fObeUEB3XlBNKCPph+Bo9uONDQp2xsmj0MiCEyTdqtJwIHr9OYCugyMH4niK7NAmgEtW1W1vpKWHozbO9WIxzI/McW6/b3qAyJurowjy5F47yLIH8XX0CUupUt6NKy1oPragHITkRahcNC49yna8p2H9ipoPJvDic5LEU4oFl8MUOC0BrgEdIRkOsSZ9Z3nIhDVJsoc5/9JnIIyyOiZEVEHok6N5jS2kn9wBm/XaLks0te3qsTQ40Pw5aBAPBmRIngVkWb6uB70Smx2VUiowybJaQqX40lBAQHilMMQH6Hds=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(346002)(39860400002)(451199015)(36840700001)(40470700004)(46966006)(8936002)(6916009)(5660300002)(70586007)(70206006)(316002)(8676002)(6666004)(7406005)(7416002)(54906003)(41300700001)(36860700001)(26005)(36756003)(86362001)(82310400005)(4326008)(2616005)(336012)(16526019)(426003)(40460700003)(186003)(478600001)(47076005)(1076003)(2906002)(356005)(81166007)(44832011)(82740400003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 20:08:48.5346
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7789cd11-542a-4e61-74c6-08dade0f0342
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7141
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nikunj A Dadhania <nikunj@amd.com>

KVM_HC_MAP_GPA_RANGE hypercall is used by the SEV guest to notify a
change in the page encryption status to the hypervisor.

The hypercall exits to userspace with KVM_EXIT_HYPERCALL exit code,
currently this is used for explicit memory conversion between
shared/private for memfd based private memory.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/x86.c  | 8 ++++++++
 virt/kvm/kvm_main.c | 1 +
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bb6adb216054..732f9cbbadb5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9649,6 +9649,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		break;
 	case KVM_HC_MAP_GPA_RANGE: {
 		u64 gpa = a0, npages = a1, attrs = a2;
+		struct kvm_memory_slot *slot;
 
 		ret = -KVM_ENOSYS;
 		if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_MAP_GPA_RANGE)))
@@ -9660,6 +9661,13 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 			break;
 		}
 
+		slot = kvm_vcpu_gfn_to_memslot(vcpu, gpa_to_gfn(gpa));
+		if (!vcpu->kvm->arch.upm_mode ||
+		    !kvm_slot_can_be_private(slot)) {
+			ret = 0;
+			break;
+		}
+
 		vcpu->run->exit_reason        = KVM_EXIT_HYPERCALL;
 		vcpu->run->hypercall.nr       = KVM_HC_MAP_GPA_RANGE;
 		vcpu->run->hypercall.args[0]  = gpa;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d2daa049e94a..73bf0bdedb59 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2646,6 +2646,7 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
 
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
 
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 {
-- 
2.25.1

