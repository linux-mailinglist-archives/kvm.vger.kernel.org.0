Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F27B67E458
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbjA0L6g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:58:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjA0L6C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:58:02 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2061b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaf::61b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77CE17E6FB;
        Fri, 27 Jan 2023 03:54:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IUevxZg1UcpjeMjHy2JelqYsn9dKIor7hu3sqpFhgSU=;
 b=F64np7L4+bDEloIPHFej39lAO0BGHOjRFa7kho6aZaq8WgygQ3x+UwmYR8wAilzbuKHS6GZbkAAZjS5ivlDvul2yhCIUN/pOstmbgVijrZPrRvGnzuHOlcl/KH8QXGqx3pQN2h5BCSfV2nJiS62zgpL9aklmfwnQD0qIhuwdpS4=
Received: from AM5PR0701CA0055.eurprd07.prod.outlook.com (2603:10a6:203:2::17)
 by PAWPR08MB10183.eurprd08.prod.outlook.com (2603:10a6:102:368::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Fri, 27 Jan
 2023 11:43:26 +0000
Received: from AM7EUR03FT022.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:203:2:cafe::d3) by AM5PR0701CA0055.outlook.office365.com
 (2603:10a6:203:2::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.10 via Frontend
 Transport; Fri, 27 Jan 2023 11:43:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT022.mail.protection.outlook.com (100.127.140.217) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22 via Frontend Transport; Fri, 27 Jan 2023 11:43:26 +0000
Received: ("Tessian outbound 43b0faad5a68:v132"); Fri, 27 Jan 2023 11:43:26 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 328f40782be5ee90
X-CR-MTA-TID: 64aa7808
Received: from a446c2399be5.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 2356810A-096C-4C8B-9DC8-612C047184FD.1;
        Fri, 27 Jan 2023 11:43:19 +0000
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id a446c2399be5.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:43:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MOPePCEXhhynwWV/BAlesTuY2yvHTH57WvYqiQh8DaUfc0UHcObtA+1M/uPshV+ConiYe46kRqgfIQdz8UlUoUtDCuFenuwliSImXQYM3t4v/0IIzGhoArxwycFc+PUzxEWeppL5VApCK9rWn4Ae66GkhqABUyE+tGrypNidoruWBw7YcNO0FVE6Uvuiv8GYF0Q7WvZatDfwZSl024ATlshJkPccyWWot1Cf06kM6C82nFkpePbAGQe7rua50vd0XxGZLe1F3Jeh8bLPhX1YXRjpwnpALIFLgBuAuzlVxgwgypaHDKdYAKy8QUEJNhtXPtNrGvkYurvwzpwCfsyOmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IUevxZg1UcpjeMjHy2JelqYsn9dKIor7hu3sqpFhgSU=;
 b=jQU1ahQlo4Ke6Pb2xZEZdR+BCyictohj9pUSJ/a4AF3eH1Qpv5S3d1RMNeWGu5IMMRwUmHsN5rkbRDBi73zmmY6ltXVb+lw3l/hTSCARDOlPjQ/FVNTqFis1sHz/DrUGctajxfwhQ7UvAipEFZa30oCt9ZubfrBLI3f3Mb17amCJKxbzo2BEzHiFFd8QZEx6wNIoL5lHNtcp/Ps29bSbs++H4cQqWWMwpi/GN+CcFDkzTT7mNgQdMswrjU3xaB7BUPRHYcODt2qi4ephmtPHZh5oWp19osj4pl4LbbJoYObRubhT5rx4Bn9PNllgZUrHahyN4StYhhJUaWY92TnasA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IUevxZg1UcpjeMjHy2JelqYsn9dKIor7hu3sqpFhgSU=;
 b=F64np7L4+bDEloIPHFej39lAO0BGHOjRFa7kho6aZaq8WgygQ3x+UwmYR8wAilzbuKHS6GZbkAAZjS5ivlDvul2yhCIUN/pOstmbgVijrZPrRvGnzuHOlcl/KH8QXGqx3pQN2h5BCSfV2nJiS62zgpL9aklmfwnQD0qIhuwdpS4=
Received: from AM6PR10CA0103.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:8c::44)
 by AS2PR08MB9295.eurprd08.prod.outlook.com (2603:10a6:20b:599::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 11:43:16 +0000
Received: from AM7EUR03FT059.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:8c:cafe::4d) by AM6PR10CA0103.outlook.office365.com
 (2603:10a6:209:8c::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:43:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT059.mail.protection.outlook.com (100.127.140.215) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.22 via Frontend Transport; Fri, 27 Jan 2023 11:43:15 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:43:14 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:43:09 +0000
From:   Joey Gouly <joey.gouly@arm.com>
To:     Andrew Jones <andrew.jones@linux.dev>, <kvmarm@lists.linux.dev>,
        <kvm@vger.kernel.org>
CC:     <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Steven Price <steven.price@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "Thomas Huth" <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        <linux-coco@lists.linux.dev>, <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC kvm-unit-tests 21/27] arm: Add build steps for QCBOR library
Date:   Fri, 27 Jan 2023 11:41:02 +0000
Message-ID: <20230127114108.10025-22-joey.gouly@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230127114108.10025-1-joey.gouly@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127114108.10025-1-joey.gouly@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic: AM7EUR03FT059:EE_|AS2PR08MB9295:EE_|AM7EUR03FT022:EE_|PAWPR08MB10183:EE_
X-MS-Office365-Filtering-Correlation-Id: b8ff3243-6c42-4f00-d0ca-08db005bb414
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 6Pb/yAI+dMoySgWPV1ESXU1C2voGE4GuzhZPXTv6ithvZsU/Gtm10HiNA08QRjRA6wUyqBAFXOCL1LB4L+faNiVe/vtaW6OEkJQ2JAKBgZ2GhqisIHcHYXzQ+mrCZ7aK+VpQj0CU4mvEBO6y91YiCcDq4DbBHyGYX7/RQmOED4lnudve+LTBViSkrDmP1QioCSvmw8ZVHGwXUZ+/HvbzPUr++y6k+2cCXiP/GAvoGqPxaNwOtJ59NQE+fwoqbTuGEMHYF1BOoI8fJyJAFpVP8zmczAccPfJy9/dr7ZnTZFP3iCIDRwgsLtOstauOMy+G2HVmTllEDiKwgRHAnO8uFyVaUwYk8WkoggSqGkdip20c7CTkiLeT+mN7zyqgMNE3cEbqwQetVdwct3cbSF9+dFcIYxfGSL6AM1CBv3Jr5JHNM8j7BIwdIY/Q7pLWrooDAqpE1Nx/qYC4lFMuK/EaThGS4oPske/9kClCF7pcK7EUPPhQdiWOAJeUBPvVlRXeJHc3pwkpg3DALzf2yMo4twx4elkJ+qyToa2zGaPbky/o0i07JPT1u1GyxqHlHNg+mTq2yAy9IHsKPVZ3YaJwq/CYkjPd8TUlxveyD13aWXoU6ngN5H1EE1Xp4eH6k52J2YSP8V8U4H2DWQjT+5xePZzao2hE5wEiXhAQQ3UHwUwkre2/AVUlymtdbAYwfOgxhmEQG41v/7QjudMwMqjuQtk+kc4awzIdwJEw9H3EM6Dfygyvx7QDoUemqqYntlH3
X-Forefront-Antispam-Report-Untrusted: CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(39860400002)(376002)(451199018)(46966006)(40470700004)(36840700001)(2906002)(44832011)(336012)(36860700001)(426003)(5660300002)(8936002)(41300700001)(7416002)(478600001)(2616005)(8676002)(26005)(4326008)(186003)(1076003)(6666004)(356005)(86362001)(40480700001)(81166007)(82740400003)(47076005)(83380400001)(40460700003)(70206006)(70586007)(7696005)(54906003)(316002)(110136005)(36756003)(82310400005)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9295
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM7EUR03FT022.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: ffcf11f7-c067-4ec1-9755-08db005bad9e
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CsW5b+f35YyOz/qvi9SQwM6FjIkI62PVUtVbDim9uaKiWq0GUXFnjeeUT2XZAbZVbjeWdtZJ9JsQmAPzJ3UytuCn78MLrN5EhDLmTZ9P2p/bJ+hpLrfw7pdi29xp7U2m0LKE99BDklUj8R1vHBaYxo+an61qBtpp58ndroRAAqx/vhrkRtkBLLffxGribre+8ou1vyCt6LMXuMkm8C2mnYXmfj2BSy2sLFH27XYlci+BMXM9K0D6cjQJKBhb6RnBBvvMvXoThxXLcEDMDBTT89SsCb1YnV/nuY6xEG0YuPoC/ooCpOwrcQGvV9ca53lXa/vqSm7yuGz9GpclwYANUuU3Z9eBdWhuajp3osd6e40KOpteMiozkmgbdAOyMRVz/vS7GpZ1VGU2mGjVUG2NVpPf3Pg4pTns54/0B2x/V+zbVTOe+qQ5DK4cLLM87mZrNrVE56bncweZ+Z7La7gmt9ipMzk6xykfS0o8vrCHBKRai0hNt5ZUcB/5Zd6Ce3mObjdz8mSdk5dUMXT3ALZfAntObrxdmVT+BC7n5CEsQlYHPeK92kA2Ts9MTr1Tsc56+MKeDP1pXAnq0w8WzKky4+DE570vhbUA6irk2AlBIXmW6ICvlTo8Fdr0VwxV852ONWAzz7DN6ks2w3NoA1mSPDAeHw+76T2fiyH7k3fqsaDQtoapxzDPkiVLX75qcNnEQMX5PydI2HocAha44oz5dZ/9+0mnjuUwcieSQeSmf7A=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(136003)(39860400002)(376002)(451199018)(46966006)(36840700001)(40470700004)(316002)(426003)(47076005)(336012)(110136005)(81166007)(54906003)(82740400003)(41300700001)(40460700003)(36860700001)(44832011)(2906002)(36756003)(8936002)(40480700001)(83380400001)(5660300002)(8676002)(4326008)(70586007)(70206006)(478600001)(6666004)(450100002)(7696005)(82310400005)(1076003)(186003)(86362001)(26005)(2616005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:43:26.5562
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8ff3243-6c42-4f00-d0ca-08db005bb414
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM7EUR03FT022.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB10183
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,SPF_HELO_PASS,SPF_NONE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

The QCBOR library will be used for Realm attestation.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/Makefile.arm64 | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 8448af36..8d450de9 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -9,6 +9,8 @@ ldarch = elf64-littleaarch64
 arch_LDFLAGS = -pie -n
 arch_LDFLAGS += -z notext
 CFLAGS += -mstrict-align
+CFLAGS += -I $(SRCDIR)/lib/qcbor/inc
+CFLAGS += -DQCBOR_DISABLE_FLOAT_HW_USE -DQCBOR_DISABLE_PREFERRED_FLOAT -DUSEFULBUF_DISABLE_ALL_FLOAT
 
 mno_outline_atomics := $(call cc-option, -mno-outline-atomics, "")
 CFLAGS += $(mno_outline_atomics)
@@ -25,6 +27,7 @@ cflatobjs += lib/arm64/processor.o
 cflatobjs += lib/arm64/spinlock.o
 cflatobjs += lib/arm64/gic-v3-its.o lib/arm64/gic-v3-its-cmd.o
 cflatobjs += lib/arm64/rsi.o
+cflatobjs += lib/qcbor/src/qcbor_decode.o lib/qcbor/src/UsefulBuf.o
 
 OBJDIRS += lib/arm64
 
@@ -40,4 +43,5 @@ tests += $(TEST_DIR)/realm-sea.flat
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
 arch_clean: arm_clean
-	$(RM) lib/arm64/.*.d
+	$(RM) lib/arm64/.*.d		\
+	      lib/qcbor/src/.*.d
-- 
2.17.1

