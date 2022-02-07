Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E994AB3DC
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 07:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233037AbiBGFxc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 00:53:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232152AbiBGFNJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 00:13:09 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2044.outbound.protection.outlook.com [40.107.237.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B41AC043181
        for <kvm@vger.kernel.org>; Sun,  6 Feb 2022 21:13:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UQD/yvwSoO3PtNGIam/uc7+jQZYgsbcltECqhuIz9Xs0B605JugYfKFNhZZFqQLCg1nPLoWSGB/k6xKKzGIywevJRIkBMpEfIRIvda4W/HYKQ/mdKVAVJ2YgNY8m8ZDioWhVfapOT5oGa5ZXbLsYk0NFipuKxtcTZ5nRHuHUUdL1xM+RGFbDMYpKpcg0O6MxVE5euJxPCgzhg5+WqrmbD4Lj6vzEXqyixGFUOnM7uiLCS5BIvXgA4R/uOwV9/FrzTJuXQv8kr6DfuSCc1XCLqT9PE68TE0zAboLfVYeHJYetlIljhb3wOP2J/o8UV9mVS4NmUBSMlT8XV3SjMKq+kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jatOICf8ZCei9qGhUo4lBfxjpVd2LA3wjAo5st6pq5Y=;
 b=eU/hUBj2Q7CVufUFwPQ/UPWPz4kXruzVE57L8YapoZYvF0bTLlBdAjnmsFgCkwQakP/fOdxnfGcld2O5JhZ5c5RTFOGzqpKdcWZo68DVWuaMnPUHlj2kkdZszMksybINLW7Cps667CkQnNUKcCq7F5S7nAC57ue4PvqYRg7P/YTOHl47vBmp7TAJEnzAozvbT+WcBaz6YocyuLxUNI9zW+QOG/kpBGnGKQ7mHjE9V1difVvF9lRc/PgYdJJAzWdwIu0RS5AUGTk1Yj9t9WWJGk/MJ6XzYs6mp26/OuQVGLujH1zHgHEOBceDc9Pxb8VRYbgU9jbBySZmm3ut4dY0AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jatOICf8ZCei9qGhUo4lBfxjpVd2LA3wjAo5st6pq5Y=;
 b=Y61AsV2t4w4+4qUmA4hNYsdRm2JfMmSZj5xTEZtNCFcHYJnLZdrgRWMS1dOX2rcmb/nTw4GuGAw8n8MDGy+M2vDarYRzKZXGUf2lM3CvamAeyxJs1HNqGZ/VL47+3AG1AoYlaSfaRfnZew82yXipJX/p6np87/kYswJTfelOE1k=
Received: from DM6PR17CA0024.namprd17.prod.outlook.com (2603:10b6:5:1b3::37)
 by BN8PR12MB3012.namprd12.prod.outlook.com (2603:10b6:408:64::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Mon, 7 Feb
 2022 05:13:05 +0000
Received: from DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b3:cafe::85) by DM6PR17CA0024.outlook.office365.com
 (2603:10b6:5:1b3::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18 via Frontend
 Transport; Mon, 7 Feb 2022 05:13:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT013.mail.protection.outlook.com (10.13.173.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4951.12 via Frontend Transport; Mon, 7 Feb 2022 05:13:05 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Sun, 6 Feb
 2022 23:13:01 -0600
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>, <aaronlewis@google.com>
Subject: [kvm-unit-tests PATCH 2/3] x86: Make exception_mnemonic() visible to the tests
Date:   Mon, 7 Feb 2022 05:12:01 +0000
Message-ID: <20220207051202.577951-3-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220207051202.577951-1-manali.shukla@amd.com>
References: <20220207051202.577951-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e5da0b2-ec0a-49c4-4963-08d9e9f885b7
X-MS-TrafficTypeDiagnostic: BN8PR12MB3012:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB30120556A465390CF3BD18E5FD2C9@BN8PR12MB3012.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9HBSa7OnvpJpxg3/ZMXmst8kQVsLJotlmmxInM9Uv0GrEz7ep/t2u4+7C21j1mW6+k65u4XXtlpjoamaJHmTvJdwrr8++9JMEo/HWTkRLvinUlX1g8XZKAZCqrSCEQsITuGCOCTSzQRFa6Jqw7EhdSvT94b2jG8IhBzlpXs7FgksV+WuDVqr261bOlDCPm/cPPu7K4uCKv2dJHxVfoWam57keXXVkfsCWMjP+ZKDsUTBQMieZTVrIXRAV0hUdoG9mvMhWD+E9wFBL2udxCB+q5KUAZIrCZIUuaHd3Jr6UxYi5pkjCdokgLgJipVlnIXIBeEmFdXIF+WUjGwMm2WsSzsc1w62kPWgpTdKp4+otMXT/Nw8aRCmgRhojXdOISMN4cBhEdaHY5Gh4GCBSls9+ScKlPtMsigLFFTDD1ZRJI/ZAknmlr1eLlPf3hRGskIc/Qnh/P2UOLQzcNdy1saLMyiK3AUrdHJS1ImuSWF9Y55uuorCRgccvlgu+DYnr1o64srKL8d05KplMy5l7bf7XjRMwgLISH1mK8OMia5BERYOZDZrmBWACOeUD1bQ7FkvPUFJD7Z+2VaJJ3wsAR9ENllnsq3B2mXfs0caS06OyvzrE6mikkAEmes3t+uwjaknxjkttZPORdFU7lK2++M8JH10x8QCrp6ppanjY6W04RsavUHXgmtM2uLVapoWNWxKiK4zApvkie2uYLtdrIh74A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(36756003)(26005)(186003)(316002)(54906003)(336012)(81166007)(6916009)(47076005)(1076003)(2616005)(16526019)(2906002)(7696005)(356005)(426003)(40460700003)(86362001)(44832011)(82310400004)(5660300002)(508600001)(8676002)(36860700001)(8936002)(4326008)(70586007)(83380400001)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 05:13:05.3084
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e5da0b2-ec0a-49c4-4963-08d9e9f885b7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3012
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Aaron Lewis <aaronlewis@google.com>

exception_mnemonic() is a useful function for more than just desc.c.
Make it global, so it can be used in other KUT tests.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 lib/x86/desc.c | 2 +-
 lib/x86/desc.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 16b7256..c2eb16e 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -91,7 +91,7 @@ struct ex_record {
 
 extern struct ex_record exception_table_start, exception_table_end;
 
-static const char* exception_mnemonic(int vector)
+const char* exception_mnemonic(int vector)
 {
 	switch(vector) {
 	case 0: return "#DE";
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 9b81da0..ad6277b 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -224,6 +224,7 @@ void set_intr_alt_stack(int e, void *fn);
 void print_current_tss_info(void);
 handler handle_exception(u8 v, handler fn);
 void unhandled_exception(struct ex_regs *regs, bool cpu);
+const char* exception_mnemonic(int vector);
 
 bool test_for_exception(unsigned int ex, void (*trigger_func)(void *data),
 			void *data);
-- 
2.30.2

