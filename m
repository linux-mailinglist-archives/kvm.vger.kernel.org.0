Return-Path: <kvm+bounces-49-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E0E07DB391
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 07:39:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7096A1C20979
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 06:39:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A287D287;
	Mon, 30 Oct 2023 06:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dNSk7sYp"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F94AD267
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 06:38:45 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2065.outbound.protection.outlook.com [40.107.212.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E60D57;
	Sun, 29 Oct 2023 23:38:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dky7irwTM2ac4p+mMMtmzC6teC9RFTYBad+0DbZDbZ0AaKrxYOgZEZYbPDP1hG9OGvFCbPgvUeDvf8go+wS3Iht0aBvV+9paU1Ek+Q5I0x4b1lKhVZuI4h08wi/V2+rtNSEU4KYqrMkC6UwL/3D0goPtveVp/BN69Tf8/YgcKNMTqmuVlzC3JZfIq6oFz4gRrKo7k0CAI9C5yBpOWKDFS8oi0tDNAnack/YoIlpHOPC0ydShxAXGt2lnhOAj35sK6AxRJwQZws9HG3AwPGsyjh6AcDsiQ7gjbuub5j7ASGeKXgoAqx7WXFrsveINwktk+3R8rEi29l/s6e4iMW51Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SOpPYnPPYgd8ZYlruYWJfqYAnjA4CKjDFWE63jFS0BU=;
 b=mMhrZ5bY5aYL3Hygu07HAc/0yGSKeOrh3fiYMoGC0Be6NnateP8ilFW5KhNn1anf9UEcsG3mfFDzCKwPmNV2aFMMSnpPuQ4Bdsj3eH8PtNOMuqwNStEd5ClNniTEmLzcDv++m6qBh0GYtu0frL/hG3/1cuCs5mUQhgOmiv1nzKIcOiQo75VKHEuMPEulF2TtPQBj3aX7E/pYf8SEamjErt64C8uJGR+tID4o+7IpbZtTTjRj8UMWncUnFbjgMvA8NBk9aYZdvTTILILe3pzhNXuDWlJsG+0wM+/UqQk4iCQ803jtQppoxdE7VZdVd2rstMAT/ULFm+d9tjYJgwsrSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SOpPYnPPYgd8ZYlruYWJfqYAnjA4CKjDFWE63jFS0BU=;
 b=dNSk7sYpUUktu1tGCXdnXXLniumOsyH60q3d1992O/gTwVQ+zbHJXfgUdGAUu3BnOdzJGqfqKq7Jl6pnWyFTxy8BwFs4MvF55KXmiqv686Gcj6+lcFxD8bBcN9ZkpQZ6yBuI8PEYCKmJlBE6DDf7Kct8gfskzWH+wcEzLJYZoYk=
Received: from BL0PR02CA0101.namprd02.prod.outlook.com (2603:10b6:208:51::42)
 by MN0PR12MB6319.namprd12.prod.outlook.com (2603:10b6:208:3c0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.28; Mon, 30 Oct
 2023 06:38:36 +0000
Received: from BL6PEPF0001AB77.namprd02.prod.outlook.com
 (2603:10b6:208:51:cafe::b8) by BL0PR02CA0101.outlook.office365.com
 (2603:10b6:208:51::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.27 via Frontend
 Transport; Mon, 30 Oct 2023 06:38:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB77.mail.protection.outlook.com (10.167.242.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6933.15 via Frontend Transport; Mon, 30 Oct 2023 06:38:36 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Mon, 30 Oct
 2023 01:38:32 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v5 10/14] x86/sev: Change TSC MSR behavior for Secure TSC enabled guests
Date: Mon, 30 Oct 2023 12:06:48 +0530
Message-ID: <20231030063652.68675-11-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231030063652.68675-1-nikunj@amd.com>
References: <20231030063652.68675-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB77:EE_|MN0PR12MB6319:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d676607-123c-4106-8bd3-08dbd912d860
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/tYNyEsoJAMpYa6UD0ZN5sjX2MhZHN9BUtuNqxNT348m3wU5nnmfyPNYwWP6hk0/XFs8uv/lbjqRtyxbInL8mv7aTPyAwUMrlpNVO8ubq8mIXb2cjEGxttI5KPREYfXWwULPAEgG4FKcEOAqg41TYJiJQ3lx7LZMex5c3B1NkJFTJXgaj/mgMmrud26TN5PPWWNjGvY9ezFqKAOtQwE3jLwEJqGKHVIf+E+ocsYCpM9K47wWE64j31zU7uJhVE60m2DmyLrllP6rhJUX+41EOhQCNWMVbMz4oWhw4ey5pxmw2TVo9Od2bLSzGdoRv6v43ZsCIhwO7PaiBidSvFWkEBMPhC0KUk54tvgeK168ktXr1kcXqapTHYp4NFI2ZiDzpC10o3l2xjiutV0LgTyGKme10daZyPyvmjvFYjB6/EXlnuUpXt5+hYsvjkq2LWWzuCwOHSO9CI8xsVpzfk0WiSG25BPgS8MW2FWQw4Ixd458WrQ5NiJ3OyEdFBe8ki9zzDpE3dE690gkLywANInHDrzcnY/g5e0TqjhogMmP1n0R/sBR0gdqk/OaHQQW3p02Ek3ez9W5/3+LLrmEvK1otkFGfzVGYGxiqdk8jvlsNVeGu3QM0ZW+6HZ6JyawKn/HqaX5SbIwKBZ+NuEKKW8AmHRTx/L9O2t8P0yPCJqmDDDvBjimP5ulhqNDuI0uafhzYG2L2q0TlJLJWyUoJPteM9hq7i9DEa6/8qeQDe035o+qwVNDvAs7gObyP40wVLp5iVx2zlC9xMp8I3YQr2qLxA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(39860400002)(136003)(376002)(230922051799003)(1800799009)(186009)(82310400011)(64100799003)(451199024)(40470700004)(46966006)(36840700001)(7696005)(6666004)(478600001)(83380400001)(16526019)(47076005)(26005)(2616005)(1076003)(336012)(426003)(2906002)(5660300002)(7416002)(41300700001)(54906003)(316002)(70206006)(110136005)(4326008)(8676002)(8936002)(70586007)(82740400003)(36860700001)(36756003)(81166007)(356005)(40460700003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2023 06:38:36.5433
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d676607-123c-4106-8bd3-08dbd912d860
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB77.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6319

Secure TSC enabled guests should not write MSR_IA32_TSC(10H) register
as the subsequent TSC value reads are undefined. MSR_IA32_TSC related
accesses should not exit to the hypervisor for such guests.

Accesses to MSR_IA32_TSC needs special handling in the #VC handler for
the guests with Secure TSC enabled. Writes to MSR_IA32_TSC should be
ignored, and reads of MSR_IA32_TSC should return the result of the
RDTSC instruction.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kernel/sev.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 9468809d02c7..47e2be38a6bc 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -1711,6 +1711,30 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	/* Is it a WRMSR? */
 	exit_info_1 = (ctxt->insn.opcode.bytes[1] == 0x30) ? 1 : 0;
 
+	/*
+	 * TSC related accesses should not exit to the hypervisor when a
+	 * guest is executing with SecureTSC enabled, so special handling
+	 * is required for accesses of MSR_IA32_TSC:
+	 *
+	 * Writes: Writing to MSR_IA32_TSC can cause subsequent reads
+	 *         of the TSC to return undefined values, so ignore all
+	 *         writes.
+	 * Reads:  Reads of MSR_IA32_TSC should return the current TSC
+	 *         value, use the value returned by RDTSC.
+	 */
+	if (regs->cx == MSR_IA32_TSC && cc_platform_has(CC_ATTR_GUEST_SECURE_TSC)) {
+		u64 tsc;
+
+		if (exit_info_1)
+			return ES_OK;
+
+		tsc = rdtsc();
+		regs->ax = UINT_MAX & tsc;
+		regs->dx = UINT_MAX & (tsc >> 32);
+
+		return ES_OK;
+	}
+
 	ghcb_set_rcx(ghcb, regs->cx);
 	if (exit_info_1) {
 		ghcb_set_rax(ghcb, regs->ax);
-- 
2.34.1


