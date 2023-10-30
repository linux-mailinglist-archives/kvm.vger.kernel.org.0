Return-Path: <kvm+bounces-45-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E9957DB38B
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 07:38:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4154E2814C8
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 06:38:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68EC1611C;
	Mon, 30 Oct 2023 06:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wmZ50rkK"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCDD53A6
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 06:38:23 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084A2C5;
	Sun, 29 Oct 2023 23:38:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FMpolhSrjre8oBUuhODoswJJ+OvzpawQi6MzQKtTnFwcwWhnXfCfExrdwU7xzB6ui9CjZZtAx9RLuY9GR3ePomddrqeOCAvLMg1V3tr89CnCZsO1e5QOELjx81O6z3SXHGFS5T11MRwTJBC8ppAUzKrYiA9SnjEQsHMPHohIpyWqL1eLkbycUUB2NONsoip4lVpCfj1By3ysiARVEawqAOf3jEhyRytj5QZ9Qe99+1ZgKp41m62/hIaz1eTfZIZ8GaIJhHVrx+9dGh32dIRP/n6csw29qAZAuBea58aSnuk0YxMXeN+HcYmzUoFWrxvv91hvy9Gp+6Cua0vFRVQ/+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CGmhI67DeZTozEPOTZr4zamRvVEdOWwEP881PZjnnQc=;
 b=GfuTvvzlDe6tirU7Hb+E99LQT+4tBlgChkBU4oabZ1DasX4Z3jj7Y6kCHjwdMebrN5Cg5gOLV0mUQ+CYWJMrYlcinHZUwS5p6pO2ExclGq2RM3d6olaGqIVfVF2o/yk1pLU2x07ATxLHwTO4s7gT49/cAXZORPC3Bt157cgodDuvhGUIU6p0dYMzfsz/AqOQgl8ARLFdtmPCT5k2SJeM7JH2W023PR4z8O+KXyZZhvjeWHCJ+ls1KOa/448ZkAjbfeTPTmcsJsS8RphMPFHI60CfKZ6Nrh0YQsQLAAciaSb6XazBythY7P7JHGtsMPcGnSacUY2CZ8EpNgR58C5BFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CGmhI67DeZTozEPOTZr4zamRvVEdOWwEP881PZjnnQc=;
 b=wmZ50rkKJpyfbubfv5u5CttRVr165FrmoyFPobsKoidB6+pvyCf9Pr1PNAjqewMz9HIGK5oSBilNLGewKO9q6Iyfo/L6jsWduk5AOk2EDvQx9fPHI4Udta6fY6R7w8yiq8Q71ZDiSLbqt2r+nm4VLEz+v6Bb0FuorZpHwt+vraA=
Received: from MN2PR20CA0044.namprd20.prod.outlook.com (2603:10b6:208:235::13)
 by PH7PR12MB5596.namprd12.prod.outlook.com (2603:10b6:510:136::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.27; Mon, 30 Oct
 2023 06:38:19 +0000
Received: from BL6PEPF0001AB73.namprd02.prod.outlook.com
 (2603:10b6:208:235:cafe::e2) by MN2PR20CA0044.outlook.office365.com
 (2603:10b6:208:235::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.28 via Frontend
 Transport; Mon, 30 Oct 2023 06:38:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB73.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6933.22 via Frontend Transport; Mon, 30 Oct 2023 06:38:19 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Mon, 30 Oct
 2023 01:38:14 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v5 06/14] x86/sev: Cache the secrets page address
Date: Mon, 30 Oct 2023 12:06:44 +0530
Message-ID: <20231030063652.68675-7-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB73:EE_|PH7PR12MB5596:EE_
X-MS-Office365-Filtering-Correlation-Id: 74ed083c-0df2-4b6d-2ffa-08dbd912ce1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	IO0JT0VJjoyTfLNrmWwx00rG9BpDlOvvBwaoXFYgLxWzjIGsBFh9G658EoPKjTc9bIRxHA0M6Q+T/QnyGUD9UP5Was6/y3pJBd9YDqa4+NZoPX1zMskazSv1vQ87HpLyTXoiTJNgkxtmPvexgLnpu3qB5nQ+eLdTeEzkgLuS9v8qYPUt5spo8eO24SQu6Ccc6d4bieC8uLZcWQJ9EO8LC8RIc4oDDdm0aKxkQ5UJ/q4BbNasXW553ZuJXFUiMeDV4piL1w4W9SbKwT8j6/0Utl6uITIvaFML2CeMaGG2ozpcZ1rYpe6GTQQdxCvHT4L7ULsOicPf5DX09sTaPazdKaNnIrb/zovrwsheurBdtJ40NyeRyJSLyNKu+SjdexucUzQQh0LiMligNow3moQ16mKRnGLZ8iysK7a9cnTsCuJll3gCHBzzeeZbCy/d1AJ4Uc0hVOpzx3w6F4CQD75Ya1GzJ3l7RRj4GBZhahIsdyEWn5NmAPCQLyJziVnTnBEChUD2RGH9fmbQDkdKTa2MwAq72j3bHkYnq9JiwkCg6FLDlu4oHxwQbwEG6rZMQqI+pZrGZPa3rpeFEQK8fbzjjgIJ6FDcn3Bz6SCuVdJ1+GP5v53a1gdr+I8FFovrBfwTABKwdWxNgkZI51WXh1484Pb4mi/bin36wf6EBIM98YBJTkBGSGFTlAOqnnUjhRRf9MWWR1mxG2JU9MYdWFM4tQ7g+5dJgjE5aINi1gcmaS18iaoOVZGl+cp6om/cVOsPx8+YAPNWia6x0LJAjlUmyQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(396003)(346002)(136003)(230922051799003)(82310400011)(451199024)(186009)(64100799003)(1800799009)(40470700004)(36840700001)(46966006)(40460700003)(110136005)(54906003)(70586007)(70206006)(4326008)(8936002)(8676002)(316002)(7416002)(5660300002)(41300700001)(2906002)(83380400001)(426003)(336012)(356005)(81166007)(47076005)(82740400003)(26005)(16526019)(2616005)(1076003)(36860700001)(478600001)(40480700001)(6666004)(7696005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2023 06:38:19.3246
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74ed083c-0df2-4b6d-2ffa-08dbd912ce1d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB73.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5596

Save the secrets page address during snp_init() from the CC blob. Use
secrets_pa instead of calling get_secrets_page() that remaps the CC
blob for getting the secrets page every time.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kernel/sev.c | 52 +++++++++++++------------------------------
 1 file changed, 16 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index f8caf0a73052..fd3b822fa9e7 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -72,6 +72,9 @@ static struct ghcb *boot_ghcb __section(".data");
 /* Bitmap of SEV features supported by the hypervisor */
 static u64 sev_hv_features __ro_after_init;
 
+/* Secrets page physical address from the CC blob */
+static u64 secrets_pa __ro_after_init;
+
 /* #VC handler runtime per-CPU data */
 struct sev_es_runtime_data {
 	struct ghcb ghcb_page;
@@ -598,45 +601,16 @@ void noinstr __sev_es_nmi_complete(void)
 	__sev_put_ghcb(&state);
 }
 
-static u64 __init get_secrets_page(void)
-{
-	u64 pa_data = boot_params.cc_blob_address;
-	struct cc_blob_sev_info info;
-	void *map;
-
-	/*
-	 * The CC blob contains the address of the secrets page, check if the
-	 * blob is present.
-	 */
-	if (!pa_data)
-		return 0;
-
-	map = early_memremap(pa_data, sizeof(info));
-	if (!map) {
-		pr_err("Unable to locate SNP secrets page: failed to map the Confidential Computing blob.\n");
-		return 0;
-	}
-	memcpy(&info, map, sizeof(info));
-	early_memunmap(map, sizeof(info));
-
-	/* smoke-test the secrets page passed */
-	if (!info.secrets_phys || info.secrets_len != PAGE_SIZE)
-		return 0;
-
-	return info.secrets_phys;
-}
-
 static u64 __init get_snp_jump_table_addr(void)
 {
 	struct snp_secrets_page_layout *layout;
 	void __iomem *mem;
-	u64 pa, addr;
+	u64 addr;
 
-	pa = get_secrets_page();
-	if (!pa)
+	if (!secrets_pa)
 		return 0;
 
-	mem = ioremap_encrypted(pa, PAGE_SIZE);
+	mem = ioremap_encrypted(secrets_pa, PAGE_SIZE);
 	if (!mem) {
 		pr_err("Unable to locate AP jump table address: failed to map the SNP secrets page.\n");
 		return 0;
@@ -2083,6 +2057,12 @@ static __init struct cc_blob_sev_info *find_cc_blob(struct boot_params *bp)
 	return cc_info;
 }
 
+static void __init set_secrets_pa(const struct cc_blob_sev_info *cc_info)
+{
+	if (cc_info && cc_info->secrets_phys && cc_info->secrets_len == PAGE_SIZE)
+		secrets_pa = cc_info->secrets_phys;
+}
+
 bool __init snp_init(struct boot_params *bp)
 {
 	struct cc_blob_sev_info *cc_info;
@@ -2094,6 +2074,8 @@ bool __init snp_init(struct boot_params *bp)
 	if (!cc_info)
 		return false;
 
+	set_secrets_pa(cc_info);
+
 	setup_cpuid_table(cc_info);
 
 	/*
@@ -2246,16 +2228,14 @@ static struct platform_device sev_guest_device = {
 static int __init snp_init_platform_device(void)
 {
 	struct sev_guest_platform_data data;
-	u64 gpa;
 
 	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
 		return -ENODEV;
 
-	gpa = get_secrets_page();
-	if (!gpa)
+	if (!secrets_pa)
 		return -ENODEV;
 
-	data.secrets_gpa = gpa;
+	data.secrets_gpa = secrets_pa;
 	if (platform_device_add_data(&sev_guest_device, &data, sizeof(data)))
 		return -ENODEV;
 
-- 
2.34.1


