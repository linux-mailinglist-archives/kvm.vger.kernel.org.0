Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 120FE58E728
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 08:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbiHJGNj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 02:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiHJGNh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 02:13:37 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2061d.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8c::61d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E93606BA;
        Tue,  9 Aug 2022 23:13:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DxGK/T5HWL5zgPGs4gsNLEFoYh1RdibB7Fb8ZE+zq9TEp2A7QDLeYh9EJ2CXWIFQgX39hNvtqcfNapRZZvbx0Hq18mx/+kNw9HZJJuzZnUdjH5JVKNwYtcorxKt91e/btKBoW8GJkhMqZ0xUqoHoERYpUpJRh2hNHZK26CuSATSps48B9/zRDzy3js4UL6b4dWblq7uOep8o7dE5PLsYEC7ijOdqG5EbWAsxi9gKzvRDSp0dH55GKLx+U2TpQikTKDslZTe8zx/GOQesiTqw5lYL1T45zJhfTIWWjqq4Wz+QDX56B/PTJ8fge4EOkzkVyffMB56Kql7WNzaVxI+CAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8cuinjq2l4FGfhpt3iGm/+BclBbGZ9YyXMyHBW+EC9g=;
 b=KUwjMwpOibdlUdYi3j/f/9FYOjh52Wf/DPscW9LUCdoOCS9UwLuBzefeZhInTKXoU08TcIenh40S1CmPY5Tu7+VcPBvuCUKmcTiqFnXKRZzprCH7r8fxluL4Lt5/cviMAQh2aXCNNgnkgfSeaYF5+ya4Yti3UEhOYpfDfXOSA5vNJrrLCufxAxT4eVJrpMhshWETPLdvpRYB51rFKVrDu9IEhJCxvCYZnKMcE3xCGI5x6W16gzJq2QZaejf8yrjL5rKJijs/IH66BBRzU6BU92w2jOPlLgxxDxHz5NtdYIEjn+StWbkhoBiVsBjVNthAgICZxUrKcsTQ3mwZG1XAvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8cuinjq2l4FGfhpt3iGm/+BclBbGZ9YyXMyHBW+EC9g=;
 b=hkfwQ9Xdt64Is+Gofno2d3xcnwym7TrXCnBQme/kRXVn8WaQ63JY+OstkaTXTC6qGC9K8H2H/G6GVGOXYndlnfj/fh1YFJLVTfZFpbtRinK7AhLOb3jpPD+aeOlmvpqaInJYyemihzaRzgYf0ufRaj2/2jCmLApSX60df9Axo2M=
Received: from MW4P222CA0012.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::17)
 by PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Wed, 10 Aug
 2022 06:13:33 +0000
Received: from CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::29) by MW4P222CA0012.outlook.office365.com
 (2603:10b6:303:114::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23 via Frontend
 Transport; Wed, 10 Aug 2022 06:13:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT049.mail.protection.outlook.com (10.13.175.50) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5525.11 via Frontend Transport; Wed, 10 Aug 2022 06:13:33 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 10 Aug
 2022 01:13:27 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>,
        <mlevitsk@redhat.com>
Subject: [PATCHv3 1/8] x86/cpu: Add CPUID feature bit for VNMI
Date:   Wed, 10 Aug 2022 11:42:19 +0530
Message-ID: <20220810061226.1286-2-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220810061226.1286-1-santosh.shukla@amd.com>
References: <20220810061226.1286-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb21811d-4428-4c8d-9b38-08da7a977435
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RlQiek6+thtZ4J4C6/ZRUx6amkvzwaSBPhuz+b1CSUF8WnUw1f4u3sodNXTiTSi7iLrzlR3blenex8tdhJpLQeo18PK+3zGT9YAGL+HvhSqTqSYqcaW+RYPHL6TO0tIiK4GLN/27DNd+WGFezeOppy8CLrapibvWbxaSv1ESXJmQkSlK2uB0xLeB5s6Tatc32es2KZe7f97r83yI+eq7xQ67tTXfbUl++yFgJEHAZg6TGBZGEIy/B/JwGtu9DDPyXm7xI8zCpEa6HB2cM5fTqsGi0D4cvH6bgp0DeZ0pIBgehHyCqhslqspduo22iok1KrLe1ggSaAZxjofI88Od/eVR4GCKPItjqjvAvChiZlleTVmQ27Fyn8zJ+yKubhIzEIsoVznUmzrmkCMqr9Y7A/j0twJIMO8+lkeYyGK5NveTmcQf7Bvnc59C8RInkrjYfmLtldzGHVZ/K1yJI9F+RRuTRjN1hd0JRSNCWyUu1hR6Djo6vmiDRPJDqlhXVftphJnVfNenNyi7cqdzMEEJdI3bmmN/wo+6qGQ+oEjQVYQ/i22rR1HNCxnvsP2EujMXOo/aZRkQyIDAxtJkfeAM4wKStKoLdCmb0v/s+hU1TjLccN98KVyXIxWTSJbC1JYNb4Vew+nOEms/uw29wni27TBC0VtFjGftxFyjRuubX2jFRRlbP45yA7ip2i1lMilIc2D4YdGp5oJrn2pr/7vAYsjnh8V600hZWdp9Z0McNIKBvtCddJfyz5JpORqQAHwjxm0ZOwvJkb1eqr/ddUOU60KG54JpbDq1GJq3erTJ0WGtlTA3ufB3wKT1P8TJvS01jt8oCU5tkDDrA4zc2p2tSA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(346002)(376002)(396003)(46966006)(36840700001)(40470700004)(70586007)(2906002)(44832011)(82310400005)(4326008)(8676002)(70206006)(316002)(6916009)(5660300002)(478600001)(40480700001)(54906003)(7696005)(81166007)(86362001)(41300700001)(6666004)(26005)(36860700001)(36756003)(336012)(8936002)(356005)(426003)(47076005)(82740400003)(186003)(16526019)(2616005)(1076003)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 06:13:33.2479
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb21811d-4428-4c8d-9b38-08da7a977435
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5685
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VNMI feature allows the hypervisor to inject NMI into the guest w/o
using Event injection mechanism, The benefit of using VNMI over the
event Injection that does not require tracking the Guest's NMI state and
intercepting the IRET for the NMI completion. VNMI achieves that by
exposing 3 capability bits in VMCB intr_cntrl which helps with
virtualizing NMI injection and NMI_Masking.

The presence of this feature is indicated via the CPUID function
0x8000000A_EDX[25].

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 14ed039dff55..3d984fd9d41b 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -355,6 +355,7 @@
 #define X86_FEATURE_VGIF		(15*32+16) /* Virtual GIF */
 #define X86_FEATURE_X2AVIC		(15*32+18) /* Virtual x2apic */
 #define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* Virtual SPEC_CTRL */
+#define X86_FEATURE_V_NMI		(15*32+25) /* Virtual NMI */
 #define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* "" SVME addr check */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (ECX), word 16 */
-- 
2.25.1

