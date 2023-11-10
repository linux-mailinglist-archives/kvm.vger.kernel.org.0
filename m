Return-Path: <kvm+bounces-1492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 460E37E7E04
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 18:08:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EFEE21F20CD4
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 17:08:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11172208A8;
	Fri, 10 Nov 2023 17:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1/zMSz8P"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D718E1DFF8
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 17:08:19 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2076.outbound.protection.outlook.com [40.107.100.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2529E4390E
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 09:08:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TqG8Fy0VGrMgwn70Vc8/UKXX0b7efQBxMf+sMrWZdaKL4oJaE7fE5TVQtuSyuuGUspz3wVKLxv1aqouC9m+2yp7hpIsEK8KI2Uz8Zh20eIKLIfulXOqHq7YUOiewuv9mMolJsNBg5NHSv8JGdTonI1D1MrQVN+A3uqiqyDkKUQAkcbNL1kzM8MY3kHjV/6uVE1sYgwUyPOphiaw8mNksPSB76LACZJ6P3skTqBTtWBT3t59SQyWiGiPDVbYA3mQjdepNiaBBc3M+sGJakQMrQ7CBXyniB3WGQ9N4Hpki0qlp27bzFoIWgqK9k5OTm4L+vFUs0BRkyL1BFMCMd36ang==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qrs+3NcZdT+h52uwmz3T53vLM/StVDHg51KXJx1bms0=;
 b=DAH05n3SNcHjKOaz7Y/U5295CB4XvoTqUlxcwUSyfjEHGxB8OO4jN1FM9SfQ4lzc/LuQWkKr20RDCR367NcWi7vnbqOUwDEY/d/qjcYDwPYS/fPyUQq4rLC1kt90gBPd/kWlarVClWQIGV0gPheLjcGUp1Ae8aQaDv4W0PwhE8X8RT1He5gitfm8wAM7DzggNNKNGqwd8gm9DaZjTH20jHTU19tQDBBaW4QAMMxr7Hw6vIbUYHLnMgDHrw6C5z+ILGqNwCoe2zSsWpCd8NU7xGoJyD+bKGZY1f1E/gsz7b0NvjpEVel5xrhTQkkJlRR6WRfrnRZ4k9trsD6Y5P+t+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qrs+3NcZdT+h52uwmz3T53vLM/StVDHg51KXJx1bms0=;
 b=1/zMSz8Pd9nXCv8hR6M18opJ5jwdaabDocmdthtzpmGFt9FsDp8yapl7KsnHqS2qaWD0JaQCRrHq/CrsyXTEPUj/TW0azmq2c9v4+MR4XAmovexRPhvBn+bZFO9LG0cMWgREZg/87Vrsyv2D10W9yYANiMqFUjF/9zWOfrdk76c=
Received: from DM6PR07CA0104.namprd07.prod.outlook.com (2603:10b6:5:330::30)
 by MW3PR12MB4521.namprd12.prod.outlook.com (2603:10b6:303:53::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.29; Fri, 10 Nov
 2023 17:08:13 +0000
Received: from DS3PEPF000099DE.namprd04.prod.outlook.com
 (2603:10b6:5:330:cafe::d8) by DM6PR07CA0104.outlook.office365.com
 (2603:10b6:5:330::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.21 via Frontend
 Transport; Fri, 10 Nov 2023 17:08:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099DE.mail.protection.outlook.com (10.167.17.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6977.16 via Frontend Transport; Fri, 10 Nov 2023 17:08:13 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Fri, 10 Nov
 2023 11:08:11 -0600
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>, <richard.henderson@linaro.org>,
	<eduardo@habkost.net>
CC: <mst@redhat.com>, <marcel.apfelbaum@gmail.com>, <qemu-devel@nongnu.org>,
	<kvm@vger.kernel.org>, <Michael.Roth@amd.com>, <nikunj.dadhania@amd.com>,
	<babu.moger@amd.com>
Subject: [PATCH] target/i386: Fix CPUID encoding of Fn8000001E_ECX
Date: Fri, 10 Nov 2023 11:08:06 -0600
Message-ID: <20231110170806.70962-1-babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DE:EE_|MW3PR12MB4521:EE_
X-MS-Office365-Filtering-Correlation-Id: 2799adaa-25ab-4b33-608c-08dbe20f9fc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	NV9RN4womyxVIBv5P8/x7Sz6YdXJNuJv2LKLCHO5s3qN1ZidswAuE2/v/tfGXy1lgz6n3ydXzl0aVNeNGBED1UDPRWPV7zaA5UjOXlP2XfLzfohoAuM3g192HvqVB2CphxCEeDQVacqe6FlHqTUZeWHMcjQFfUgo95ddY02csDYyvF19rsLeMfQAWN95+BxqobI2P57XCfb1u64tXokfa/o+CuH5LxBBeWPxldB1f5M5izNJYPDTKpiuBeWSq9muFWNRYYBkdGn+EylQ2QRph153bldjUGZ2p8oKyxLgbwbBYfPhKAcxNaJVYBGQTWl0T2K5ig5TrGFxEvKCgCzb8pL692TOHXq6Y4+jJqDDCZlGGYNzuNw1x6+pcB+jvRNuPtANIHXjWuixYvKCEJmOeG+xX/rLJ9tB1Cgv26MrcXFIvkL1D2C36+Q3/2nX7JsoGRRM5+KvGkkiLckfhWuMBIgS+VNgHas0NBQWkSxVVpVG9wlim6Y2i2oBoj42/rLTi1Iuf/Pdou1EIe7yWKxG4vUZ23DrJjcm21xG0vaVqVBJA9KkoZa+Pa8STlvkY4Sr8nV1POl4ivLFndE+YtcuKgfSNMvY+/ObKV+XCKoq0HGTnPnQNX04c4iGqItiOHdszp2FxpZipuKEUBrMtpKLadWTu6ywPxhiq/cYpr02uY796nNVVD4uT4FnBSlOxp4G/o94IKQcQMKc+qpJOcNlKEMdutRTFg0d5ij826BHqOIPLfMeeySoBie3jHthRpMS
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(136003)(346002)(396003)(39860400002)(230922051799003)(451199024)(64100799003)(82310400011)(1800799009)(186009)(36840700001)(40470700004)(46966006)(426003)(40460700003)(40480700001)(1076003)(2616005)(2906002)(16526019)(26005)(336012)(36860700001)(83380400001)(41300700001)(8936002)(478600001)(5660300002)(8676002)(316002)(7696005)(44832011)(47076005)(4326008)(966005)(70206006)(70586007)(54906003)(81166007)(110136005)(356005)(82740400003)(6666004)(36756003)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2023 17:08:13.5109
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2799adaa-25ab-4b33-608c-08dbe20f9fc4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4521

Observed the following failure while booting the SEV-SNP guest and the
guest fails to boot with the smp parameters:
"-smp 192,sockets=1,dies=12,cores=8,threads=2".

qemu-system-x86_64: sev_snp_launch_update: SNP_LAUNCH_UPDATE ret=-5 fw_error=22 'Invalid parameter'
qemu-system-x86_64: SEV-SNP: CPUID validation failed for function 0x8000001e, index: 0x0.
provided: eax:0x00000000, ebx: 0x00000100, ecx: 0x00000b00, edx: 0x00000000
expected: eax:0x00000000, ebx: 0x00000100, ecx: 0x00000300, edx: 0x00000000
qemu-system-x86_64: SEV-SNP: failed update CPUID page

Reason for the failure is due to overflowing of bits used for "Node per
processor" in CPUID Fn8000001E_ECX. This field's width is 3 bits wide and
can hold maximum value 0x7. With dies=12 (0xB), it overflows and spills
over into the reserved bits. In the case of SEV-SNP, this causes CPUID
enforcement failure and guest fails to boot.

The PPR documentation for CPUID_Fn8000001E_ECX [Node Identifiers]
=================================================================
Bits    Description
31:11   Reserved.

10:8    NodesPerProcessor: Node per processor. Read-only.
        ValidValues:
        Value   Description
        0h      1 node per processor.
        7h-1h   Reserved.

7:0     NodeId: Node ID. Read-only. Reset: Fixed,XXh.
=================================================================

As in the spec, the valid value for "node per processor" is 0 and rest
are reserved.

Looking back at the history of decoding of CPUID_Fn8000001E_ECX, noticed
that there were cases where "node per processor" can be more than 1. It
is valid only for pre-F17h (pre-EPYC) architectures. For EPYC or later
CPUs, the linux kernel does not use this information to build the L3
topology.

Also noted that the CPUID Function 0x8000001E_ECX is available only when
TOPOEXT feature is enabled. This feature is enabled only for EPYC(F17h)
or later processors. So, previous generation of processors do not not
enumerate 0x8000001E_ECX leaf.

There could be some corner cases where the older guests could enable the
TOPOEXT feature by running with -cpu host, in which case legacy guests
might notice the topology change. To address those cases introduced a
new CPU property "legacy-multi-node". It will be true for older machine
types to maintain compatibility. By default, it will be false, so new
decoding will be used going forward.

The documentation is taken from Preliminary Processor Programming
Reference (PPR) for AMD Family 19h Model 11h, Revision B1 Processors 55901
Rev 0.25 - Oct 6, 2022.

Cc: qemu-stable@nongnu.org
Fixes: 31ada106d891 ("Simplify CPUID_8000_001E for AMD")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 hw/i386/pc.c      |  4 +++-
 target/i386/cpu.c | 18 ++++++++++--------
 target/i386/cpu.h |  1 +
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 188bc9d0f8..624d5da146 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -77,7 +77,9 @@
     { "qemu64-" TYPE_X86_CPU, "model-id", "QEMU Virtual CPU version " v, },\
     { "athlon-" TYPE_X86_CPU, "model-id", "QEMU Virtual CPU version " v, },
 
-GlobalProperty pc_compat_8_1[] = {};
+GlobalProperty pc_compat_8_1[] = {
+    { TYPE_X86_CPU, "legacy-multi-node", "on" },
+};
 const size_t pc_compat_8_1_len = G_N_ELEMENTS(pc_compat_8_1);
 
 GlobalProperty pc_compat_8_0[] = {
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 358d9c0a65..baee9394a1 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -398,12 +398,9 @@ static void encode_topo_cpuid8000001e(X86CPU *cpu, X86CPUTopoInfo *topo_info,
      * 31:11 Reserved.
      * 10:8 NodesPerProcessor: Node per processor. Read-only. Reset: XXXb.
      *      ValidValues:
-     *      Value Description
-     *      000b  1 node per processor.
-     *      001b  2 nodes per processor.
-     *      010b Reserved.
-     *      011b 4 nodes per processor.
-     *      111b-100b Reserved.
+     *      Value   Description
+     *      0h      1 node per processor.
+     *      7h-1h   Reserved.
      *  7:0 NodeId: Node ID. Read-only. Reset: XXh.
      *
      * NOTE: Hardware reserves 3 bits for number of nodes per processor.
@@ -412,8 +409,12 @@ static void encode_topo_cpuid8000001e(X86CPU *cpu, X86CPUTopoInfo *topo_info,
      * NodeId is combination of node and socket_id which is already decoded
      * in apic_id. Just use it by shifting.
      */
-    *ecx = ((topo_info->dies_per_pkg - 1) << 8) |
-           ((cpu->apic_id >> apicid_die_offset(topo_info)) & 0xFF);
+    if (cpu->legacy_multi_node) {
+        *ecx = ((topo_info->dies_per_pkg - 1) << 8) |
+               ((cpu->apic_id >> apicid_die_offset(topo_info)) & 0xFF);
+    } else {
+        *ecx = (cpu->apic_id >> apicid_pkg_offset(topo_info)) & 0xFF;
+    }
 
     *edx = 0;
 }
@@ -7894,6 +7895,7 @@ static Property x86_cpu_properties[] = {
      * own cache information (see x86_cpu_load_def()).
      */
     DEFINE_PROP_BOOL("legacy-cache", X86CPU, legacy_cache, true),
+    DEFINE_PROP_BOOL("legacy-multi-node", X86CPU, legacy_multi_node, false),
     DEFINE_PROP_BOOL("xen-vapic", X86CPU, xen_vapic, false),
 
     /*
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index cd2e295bd6..7b855924d6 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1988,6 +1988,7 @@ struct ArchCPU {
      * If true present the old cache topology information
      */
     bool legacy_cache;
+    bool legacy_multi_node;
 
     /* Compatibility bits for old machine types: */
     bool enable_cpuid_0xb;
-- 
2.34.1


