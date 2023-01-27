Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3EFB67E3EA
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbjA0Loz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:44:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233569AbjA0Lok (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:44:40 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2062f.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe1a::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E9E7B421;
        Fri, 27 Jan 2023 03:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SFNQAxSU7XAJtJhJFGLeQLPoIFHCEXEJJzjwvGAuSAo=;
 b=3KMDKRZwFWb9ItNkbUaQhuGI41XuKkUT4DSbqUMi614rMCTgaTLpG/16qVo9FhAqVB9PWiaMkS2IoI3SkgRMlPVdVQyqiO8MunblxaDgPqKL9scwX6fQPp7N7L9/6bCc/S6T+wHQ3oQyocuLb/a4NW8YzXEALI3bDvXdcWflQPM=
Received: from DUZPR01CA0142.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bd::22) by GV1PR08MB8452.eurprd08.prod.outlook.com
 (2603:10a6:150:84::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 11:41:55 +0000
Received: from DBAEUR03FT031.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:4bd:cafe::f4) by DUZPR01CA0142.outlook.office365.com
 (2603:10a6:10:4bd::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.34 via Frontend
 Transport; Fri, 27 Jan 2023 11:41:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT031.mail.protection.outlook.com (100.127.142.173) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.23 via Frontend Transport; Fri, 27 Jan 2023 11:41:55 +0000
Received: ("Tessian outbound 333ca28169fa:v132"); Fri, 27 Jan 2023 11:41:55 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: ec865946f5b87296
X-CR-MTA-TID: 64aa7808
Received: from 496d2b36e9b2.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id A7413008-086D-4EFF-988E-873B3B9F265B.1;
        Fri, 27 Jan 2023 11:41:48 +0000
Received: from EUR02-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 496d2b36e9b2.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:41:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HSlpimX2uVn1xq7nvWgwXNkUfk8Z0aXIQxhaU1ANcUn7wlerGMBPMyF2X3CqezsF28ZL6VSfSrNHRE5ARI/kkiXC8VwnI25epJJF5q9x9CVngpocvZ4BZwmoe/5J5eOrFpSNKwslUA+8zsn8Fn55mC2xGk5k9Y5UaOl3qMV/DonvcrgNBNmLMLzCD3MJB9TNl139rSi+G0gnL424Ca6LynKD6SzkNxlpd/getnLpVJeud7ec+K0sZQFjaxB2sBMCuPqI6s3g1SAZN5+9eKZ8Og0XUt9MLMioLfhLpAmdd0vgrBktGRfBWsoy8mwdNAJ5elpalpzS224ZsZ42rOxteA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SFNQAxSU7XAJtJhJFGLeQLPoIFHCEXEJJzjwvGAuSAo=;
 b=RecQWZn5VyHaYQmJZGmcLEepxfJwIG2T5K3oSZp7H1AqTiMTff83yq5s1IFiL+OdCMXPPx+6dWLfqDsb3R1Et97IIltGrANk/bSNilE59fUZ99rSWfIbZfTBFHb+0BIiAdWtHRqoD4bWfMK1t598K9KAu+AWf/rda0SAD/fpRofIdwRT/Nf/7t0SN9fvtAsL0WwTGr1UgCL4jFIi7U3jz/JDIvwxVZIpHnmd9D/W6HLHlay+CIOmIVvidw7GcWwoI7p4RIl4uEXjv+Teyw2wMxAhIjFhwb0My70lncuUKyq2cJfdNbTV/DHK5roRNWGthbCCHVbI2UTcdXwmz0UZcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SFNQAxSU7XAJtJhJFGLeQLPoIFHCEXEJJzjwvGAuSAo=;
 b=3KMDKRZwFWb9ItNkbUaQhuGI41XuKkUT4DSbqUMi614rMCTgaTLpG/16qVo9FhAqVB9PWiaMkS2IoI3SkgRMlPVdVQyqiO8MunblxaDgPqKL9scwX6fQPp7N7L9/6bCc/S6T+wHQ3oQyocuLb/a4NW8YzXEALI3bDvXdcWflQPM=
Received: from DB6PR0801CA0043.eurprd08.prod.outlook.com (2603:10a6:4:2b::11)
 by GV1PR08MB7682.eurprd08.prod.outlook.com (2603:10a6:150:61::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 11:41:45 +0000
Received: from DBAEUR03FT030.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:2b:cafe::4b) by DB6PR0801CA0043.outlook.office365.com
 (2603:10a6:4:2b::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22 via Frontend
 Transport; Fri, 27 Jan 2023 11:41:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 DBAEUR03FT030.mail.protection.outlook.com (100.127.142.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.23 via Frontend Transport; Fri, 27 Jan 2023 11:41:44 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX04.Arm.com
 (10.251.24.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:41:44 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:41:38 +0000
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
Subject: [RFC kvm-unit-tests 05/27] arm: Introduce NS_SHARED PTE attribute
Date:   Fri, 27 Jan 2023 11:40:46 +0000
Message-ID: <20230127114108.10025-6-joey.gouly@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230127114108.10025-1-joey.gouly@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127114108.10025-1-joey.gouly@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic: DBAEUR03FT030:EE_|GV1PR08MB7682:EE_|DBAEUR03FT031:EE_|GV1PR08MB8452:EE_
X-MS-Office365-Filtering-Correlation-Id: a4e2754a-ec96-4b97-f229-08db005b7db1
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: nXh9nliPOvPbK7iNWdfQJGaAOWXzyeT5xP272oeXMQ9wIlN/pix2FVmcYcMy9nDWaq/OkvqSyBVXc55g49cWYD6Xhr6cWFfHF/0uEYL10iFdgj/qkC4BIaFMA5oxfivwOz7d1bBlhIVTG+DqbusvWuj4fBifty806bpuD44d3lpGQSJrd56jZBN9uHdu5qx4ytc7vEiSNGrZ+18JdL0P40iRHq/uq83+sWygUotByfqK/9KBTqt3NKkc9WSI/YZgxd3o9pSAfH7l8t3u1uqMdE/FN29YZ+drzkyUWoMnlikkWs9OSPzMfR3VjUQsWGFYumhKrotfZK90x7fhs7d5uR+8ShN+DXYs1NPQj/PpaK3tdyrGAl62T8lcmin4kEwCgbnnlXe1RKZkZ/pF4pTkO9Z1xh3hZipZr52rZX4KVOW3ZIZ8KSDirXNhp49vvtT7RV6iNZQ3OzQsu6u5wpoLprBbBCa83pJe+ZBP0PYOgMNxIzUvoiC+LsGQukDOaleWpueHjB8abYeLGp51GmmegorsCaGpPclUby0k7KvWFF/0BbWZ6RqiNFCIkc/vXY0o1jwlhi3MAzJ+TgPyww8n/19y2KTpCf0SRrY6huTOiUULMpIyNFY1MPdg6KqRa400jPYr7BDKsBGLskLI/Qb06DyXIlb/SM8mbHg2ZWh56hA8xZO/eWpLIDPrkRGjNk/zuJeG/gkwDza51yvzMo2cta4NtgWSqJul9F9rpskEs4KEyjcLgv3dKTnqPX0wHp1R
X-Forefront-Antispam-Report-Untrusted: CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(396003)(39860400002)(451199018)(40470700004)(46966006)(36840700001)(356005)(2906002)(44832011)(5660300002)(7416002)(81166007)(8936002)(41300700001)(6666004)(86362001)(478600001)(40460700003)(83380400001)(110136005)(36860700001)(54906003)(82740400003)(316002)(82310400005)(47076005)(426003)(336012)(40480700001)(36756003)(2616005)(7696005)(8676002)(70586007)(4326008)(70206006)(1076003)(186003)(26005)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB7682
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DBAEUR03FT031.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 13603eb6-22e3-412e-8705-08db005b776a
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5JR6tMbSyb8ho6MztJk614jf6sgNrGS2nBQ5uMO8s5UsFLsHLocIecDnIEEI1yhKS5/KyrlOe9C7jnhvbLYXF7wZLX/QsVdxzBKj3pnPcY1x1dZ7NIieLTBxt3oKEoV3icJWPWLpD01kzCrUR6Y2QvdGs82vx0qUVCdj3CA+q1ng+mQXerzdQ/AiSU4Wp9UxqlPZp/rZodDUkYrm7vXPp/eGi+1bW0nqZ7rqTNqsRHCljLHXLTXmTm77+IS1NfbBU2KVnQGJhCpenDcbd136331+YVYgVAoua5IbS2nAnd7Y0JUJDy2ZDS/ofjW/9ltetC7oYsWM5BFlpmAP6zG23WTDy0MjivcSzg2SU5QSyDNaemqh9WX3KWrTRtz54qQI+9o3S2bd0E9UK8hRyy2B1msexRNxt51xiYyiv0hs9wbeUGkDc9lX0iq1tQpoQssItJVxbdeqEo38my0Xl7nKHbOeBTxJl4XvJtjWbkuoX7KCA3eby/Q2XlAbmLbsR0fWro8iLISpH1/w5vKBq/E7mdVn9dgihOc+RzzCgTpKVw6YO32G+mUXq9ao/etp0LWp1t6YPpWuXaVi8DugemQqX5zZhyO53GHrCjAPkyS6bNfKHpCdM8VHLKDSsPwsj3uYWkYbULFhZS04iC9nLZx0Ga/PsZhZe6Fg9SraHGKDWgTGrcQrs09H+GNBqdblQ7JSL/tiA2WykW73hPhgi98aTDDju8FChQqzOx+sbMDyXS8=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(376002)(136003)(396003)(451199018)(36840700001)(46966006)(40470700004)(2906002)(186003)(8676002)(5660300002)(4326008)(70586007)(450100002)(70206006)(40460700003)(82740400003)(40480700001)(8936002)(86362001)(81166007)(41300700001)(336012)(426003)(82310400005)(36756003)(83380400001)(2616005)(54906003)(110136005)(316002)(36860700001)(44832011)(47076005)(6666004)(478600001)(7696005)(26005)(1076003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:41:55.3270
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a4e2754a-ec96-4b97-f229-08db005b7db1
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DBAEUR03FT031.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8452
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_NONE,SPF_NONE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a new attribute to indicate the mapping is "Shared" with the
host. This will be used by the Realms to share pages with the Host.
For normal VMs, this is always 0.

For realms, this is dynamic, depending on the IPA width. The top bit of the
IPA is "treated" as the "NS_SHARED" attribute, making the VM access the
unprotected alias of the IPA.

By default, apply the NS_SHARED attribute for all I/O.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 lib/arm/mmu.c           | 5 ++++-
 lib/arm64/asm/pgtable.h | 6 ++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index acaf5614..6f1f42f5 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -22,6 +22,8 @@
 
 pgd_t *mmu_idmap;
 
+/* Used by Realms, depends on IPA size */
+unsigned long prot_ns_shared = 0;
 unsigned long phys_mask_shift = 48;
 
 /* CPU 0 starts with disabled MMU */
@@ -194,7 +196,8 @@ void __iomem *__ioremap(phys_addr_t phys_addr, size_t size)
 {
 	phys_addr_t paddr_aligned = phys_addr & PAGE_MASK;
 	phys_addr_t paddr_end = PAGE_ALIGN(phys_addr + size);
-	pgprot_t prot = __pgprot(PTE_UNCACHED | PTE_USER | PTE_UXN | PTE_PXN);
+	pgprot_t prot = __pgprot(PTE_UNCACHED | PTE_USER | PTE_UXN |
+				 PTE_PXN | PTE_NS_SHARED);
 	pgd_t *pgtable;
 
 	assert(sizeof(long) == 8 || !(phys_addr >> 32));
diff --git a/lib/arm64/asm/pgtable.h b/lib/arm64/asm/pgtable.h
index 22ce64f0..5b9f40b0 100644
--- a/lib/arm64/asm/pgtable.h
+++ b/lib/arm64/asm/pgtable.h
@@ -22,6 +22,12 @@
 #include <linux/compiler.h>
 
 extern unsigned long prot_ns_shared;
+/*
+ * The Non-secure shared bit for Realms is actually part of the output
+ * address, however it is modeled as a PTE attribute.
+*/
+#define PTE_NS_SHARED		(prot_ns_shared)
+
 /*
  * Highest possible physical address supported.
  */
-- 
2.17.1

