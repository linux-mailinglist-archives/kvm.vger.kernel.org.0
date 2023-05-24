Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2F170FAD9
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 17:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237470AbjEXPyf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 11:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbjEXPyd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 11:54:33 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2085.outbound.protection.outlook.com [40.107.95.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1F6BF;
        Wed, 24 May 2023 08:54:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XhKwbVHK3DXIYsNKHRgMaBmWL8QkNfJTHghICdGUDk4rFr4jKf8IdWei24NeKWk8gxHWPmHl5EMjwv4BUBnVyw1q/c6ZkGs0xE3cZX9cd0wPi9bpkJEs/8HQjJT1/sH4LbgBoGdefdMDIO6F/c6zH68vng35oiMCxljf8IadmDNM6q82fAjaAiDp5nrNondVWsoh68LM+D6sSTSkMGhZc2nLFn/tuDsAbrF04W7QTDc0f6lozdxNf4ADtKl49u4ODOE/Vl+Lk8K+eBghjxZDXG/bQPTXq1+nY9/DWOsBlgkUYIOwkKUphb+cyamFIuEAxzf8HdXTU7AFH2K9FCNgxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uj0bkYXsR10s3r/m8xtxss13IhLieX8HsOzV2Z7O/i0=;
 b=is25l9oGO14Q26VaZ9v3E3431vTfuw84b7xjorlzxRbOEdxrb2jpZaoFCMDMgqs2tJvY+u3RCvm1IZ5hvAb65uynJ4550+AcVl1c1WiGIt3Olk756C9wECH8M/va+DeUFyqrk0eYkVtMRvefffL1xaUP4LAJjpp9JYW8pJ5uFeAsnYRYVnArE4Xpx1Lz7SOrnjF5/6vOxWt5a2cBGXoU7qjcgPwjZ3wMBYHA0J6UMD2jdbvJUMGugKpL0iJPxpqQyu++v0tlFVuZiBhn2fPPj0KkqG0YHaYgEmw28d54J+M03Q7T7mhhiBaUM3P0aN98SkJmigS5+/2FUbiDDNYrYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uj0bkYXsR10s3r/m8xtxss13IhLieX8HsOzV2Z7O/i0=;
 b=Br1zPgThllSS3nyZLXzdIEE/twQsEDmxBRvTpm6f3SC+KYy5XB8LRBtF+UvfdTkwwU45cfzO1ZN74sg3/zQaLte0uw3gkS8L1o3cpHnBdlTdII6HOWFsMy8PYh5QCzG9m6x/ha/OT/QzDgf29XSHttLwsMwdABbxyp+lNX7sRW0=
Received: from BN9PR03CA0893.namprd03.prod.outlook.com (2603:10b6:408:13c::28)
 by DM4PR12MB5889.namprd12.prod.outlook.com (2603:10b6:8:65::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Wed, 24 May
 2023 15:54:26 +0000
Received: from BN8NAM11FT079.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::f2) by BN9PR03CA0893.outlook.office365.com
 (2603:10b6:408:13c::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29 via Frontend
 Transport; Wed, 24 May 2023 15:54:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT079.mail.protection.outlook.com (10.13.177.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6411.30 via Frontend Transport; Wed, 24 May 2023 15:54:26 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 24 May
 2023 10:54:24 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        <bp@alien8.de>, John Allen <john.allen@amd.com>
Subject: [RFC PATCH v2 1/6] KVM: x86: SVM: Emulate reads and writes to shadow stack MSRs
Date:   Wed, 24 May 2023 15:53:34 +0000
Message-ID: <20230524155339.415820-2-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230524155339.415820-1-john.allen@amd.com>
References: <20230524155339.415820-1-john.allen@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT079:EE_|DM4PR12MB5889:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d4d0fbe-5829-44e4-c266-08db5c6f26ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bQkRdOaafGdWAe/xDCQaKjsZokIspN2Bj9uMjTJ1i9+g30qKvIUxU+rcmhq1uxSNSZAw9iLTsZNIvZbbBUzEVvMNShCW9cqsazx1AphIE5peVW5de7fMoWCI+wvhLHDkem4dzURvhXp5uu1+J6wUIyzrnlpd6La+GYnc+DYS/DUaWa3o9a34BBcqL3x59tAr1lqOQx+tXXXlY+l4uX2M83MB8H/gM5NyJ3lS73/kotAIdOP1SRM+1dg0SK9VJVUYXzM3ggLuLRICREUBPW4x+YhgE8UQe6f8QfbAZbBUXeILSWkYxMi0Rt+nOIj3RrmJQUMWd/HHvUpyrqOlC8o0fWX0LGitXC0Ld4IV2P5Yf4diD3V08BI8cIGmV2LBlJq0/0uiRZvVel9ykoJm/6UuXxAVRSjUY5wiSCRRWDBzXL/+jpkqHNfKP3t9ObU//xaRMcka0SHfshwvShx+FpYDptvqiThi9je6G1NwEA2Lj+X45UZETO8GkAY4PHYmPU4KEqkR1uAb3i2F6KZSTNl3jxciiBA0BHv6/7W0Wuz8F+lbhdlYtltaHzE+wUcTh1t7244mgWnTe1fx85LBLdRrC4BrakX1VZyScyEV/GZLw/Nu0woz9uW2GJtO7JqOgb0u2oU8ckBkR+i3BU7TrrMZgAFzbxPxqYEh04h5StTP0x0C4GiaSGtxpf2CD9EpuHgg9d0A5etQsAksO1wKkSrOTjQUiNslVWHHyqj/6Gu2RmjdVYImk1lE/h753EnpzLVlEdSR2q55Pl76RzI55zBu6w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(346002)(396003)(376002)(451199021)(46966006)(36840700001)(40470700004)(2906002)(36860700001)(16526019)(47076005)(186003)(86362001)(2616005)(40480700001)(426003)(83380400001)(336012)(82740400003)(81166007)(356005)(5660300002)(36756003)(8936002)(8676002)(316002)(41300700001)(44832011)(40460700003)(6666004)(7696005)(26005)(1076003)(6916009)(54906003)(478600001)(4326008)(70206006)(70586007)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 15:54:26.4535
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d4d0fbe-5829-44e4-c266-08db5c6f26ca
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT079.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5889
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set up interception of shadow stack MSRs. In the event that shadow stack
is unsupported on the host or the MSRs are otherwise inaccessible, the
interception code will return an error. In certain circumstances such as
host initiated MSR reads or writes, the interception code will get or
set the requested MSR value.

Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/kvm/svm/svm.c | 58 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index eb308c9994f9..822d7a65e92a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2800,6 +2800,31 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (guest_cpuid_is_intel(vcpu))
 			msr_info->data |= (u64)svm->sysenter_esp_hi << 32;
 		break;
+	case MSR_IA32_S_CET:
+		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
+			return 1;
+		msr_info->data = svm->vmcb->save.s_cet;
+		break;
+	case MSR_IA32_U_CET:
+		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
+			return 1;
+		kvm_get_xsave_msr(msr_info);
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
+			return 1;
+		msr_info->data = svm->vmcb->save.isst_addr;
+		break;
+	case MSR_KVM_GUEST_SSP:
+		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
+			return 1;
+		msr_info->data = svm->vmcb->save.ssp;
+		break;
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
+			return 1;
+		kvm_get_xsave_msr(msr_info);
+		break;
 	case MSR_TSC_AUX:
 		msr_info->data = svm->tsc_aux;
 		break;
@@ -3016,6 +3041,39 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		svm->vmcb01.ptr->save.sysenter_esp = (u32)data;
 		svm->sysenter_esp_hi = guest_cpuid_is_intel(vcpu) ? (data >> 32) : 0;
 		break;
+	case MSR_IA32_S_CET:
+		if (!kvm_cet_is_msr_accessible(vcpu, msr))
+			return 1;
+		svm->vmcb->save.s_cet = data;
+		break;
+	case MSR_IA32_U_CET:
+		if (!kvm_cet_is_msr_accessible(vcpu, msr))
+			return 1;
+		kvm_set_xsave_msr(msr);
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		if (!kvm_cet_is_msr_accessible(vcpu, msr))
+			return 1;
+		if (is_noncanonical_address(data, vcpu))
+			return 1;
+		svm->vmcb->save.isst_addr = data;
+		break;
+	case MSR_KVM_GUEST_SSP:
+		if (!kvm_cet_is_msr_accessible(vcpu, msr))
+			return 1;
+		/* SSP MSR values should be a 4-byte aligned canonical addresses */
+		if ((data & GENMASK(1, 0)) || is_noncanonical_address(data, vcpu))
+			return 1;
+		svm->vmcb->save.ssp = data;
+		break;
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		if (!kvm_cet_is_msr_accessible(vcpu, msr))
+			return 1;
+		/* SSP MSR values should be a 4-byte aligned canonical addresses */
+		if ((data & GENMASK(1, 0)) || is_noncanonical_address(data, vcpu))
+			return 1;
+		kvm_set_xsave_msr(msr);
+		break;
 	case MSR_TSC_AUX:
 		/*
 		 * TSC_AUX is usually changed only during boot and never read
-- 
2.39.1

