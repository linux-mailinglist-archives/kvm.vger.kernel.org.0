Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B43967E4BD
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 13:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbjA0MLO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 07:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232151AbjA0MK7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 07:10:59 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2042.outbound.protection.outlook.com [40.107.20.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFF688CC1;
        Fri, 27 Jan 2023 04:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BKUc6k5BydLVdfAhCZDW2BV1A+Pf2tNjyrVVfOkNRBk=;
 b=SAvWSnN98f2hb9mw6rrD+Z8Q8+BgvgYk8FPgwqjl+d0IpFb2GFkQnh0bJraTYGz2Tv00EHHaJeOHV+MnhbCWsR3MXuXUVQuz75S3MmtAWbJJUJU3ML+Xx3lRRxcI8OQkPloDNjggRQt86Y66Xt+0o4br182JegpjmeuOlI/tUCQ=
Received: from DB6PR0202CA0036.eurprd02.prod.outlook.com (2603:10a6:4:a5::22)
 by GV1PR08MB8402.eurprd08.prod.outlook.com (2603:10a6:150:a7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 11:42:21 +0000
Received: from DBAEUR03FT007.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:a5:cafe::52) by DB6PR0202CA0036.outlook.office365.com
 (2603:10a6:4:a5::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.34 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT007.mail.protection.outlook.com (100.127.142.161) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.21 via Frontend Transport; Fri, 27 Jan 2023 11:42:21 +0000
Received: ("Tessian outbound baf1b7a96f25:v132"); Fri, 27 Jan 2023 11:42:21 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 6c64ba3becf4f171
X-CR-MTA-TID: 64aa7808
Received: from b0a773cadefd.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 448B61F0-7F96-44A2-A403-35D6918DEF7C.1;
        Fri, 27 Jan 2023 11:42:14 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id b0a773cadefd.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:42:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MhXKrKTOXLunmpbCtIdiL/niGVW2nmU9SPyzCWwQAFliHuFsRjS+7KX4mxb24cgljXUcdStWgSC2jIuKWLHPfZwZT0gSSIii/rXa0Ca7kSYED7BFFVXLCuLX+gaejOcFuhBqwd7p3HzlkSNmXckq9yzn0sGbn+8pw4EskrmJ+nckKBYpzmiL2TfMcYK+5NrX4aMaCr5Hoig3Aj9ehr2X0hxv9sJBMikHsK3ZxSsC6P6sdfqekyFHCY0CUloDEhYYLlYEqGlMB8H/HxGQrX6MAbKdVsHN/t8LSje/oy5RvaJP+qyhWHZPXLMI/Ffp9DF0exW/ZuZdCoNOHJMlQ1HIBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BKUc6k5BydLVdfAhCZDW2BV1A+Pf2tNjyrVVfOkNRBk=;
 b=mC94RW0PfzLraKBdD/pO2kqjRt6y+f+EgeIm6VugklubWGFTfqPqxZKcBN01d+DXQ3QlDW01uo9vBl0n4IppfuxtfdjYWixru0DQVDz6TxNtWTUPsKuSmh7I2zL1sIQnv5P+8FAR8CW8/aYEIaHE0iw3EcI7i4puKr9ALYI0diYEm5ObOi+TEXtgRYEH7juyCyVvTY5HbvlxJqFkJ7SO/d9WJfHczVka9oEBOugZXI6cfUJ5VHETrKHs8IGuSkPrLJLHLMGJ45c84kaikMULnCtIJBHUTCeG3XtjzmfCDbSg59HY/RXs6rO+CWql8OTtpD5LZVR0zg5LLc1N6jLRTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BKUc6k5BydLVdfAhCZDW2BV1A+Pf2tNjyrVVfOkNRBk=;
 b=SAvWSnN98f2hb9mw6rrD+Z8Q8+BgvgYk8FPgwqjl+d0IpFb2GFkQnh0bJraTYGz2Tv00EHHaJeOHV+MnhbCWsR3MXuXUVQuz75S3MmtAWbJJUJU3ML+Xx3lRRxcI8OQkPloDNjggRQt86Y66Xt+0o4br182JegpjmeuOlI/tUCQ=
Received: from AS9PR0301CA0043.eurprd03.prod.outlook.com
 (2603:10a6:20b:469::35) by DU0PR08MB8422.eurprd08.prod.outlook.com
 (2603:10a6:10:406::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Fri, 27 Jan
 2023 11:42:13 +0000
Received: from AM7EUR03FT029.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:469:cafe::6b) by AS9PR0301CA0043.outlook.office365.com
 (2603:10a6:20b:469::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT029.mail.protection.outlook.com (100.127.140.143) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.22 via Frontend Transport; Fri, 27 Jan 2023 11:42:13 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:42:12 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:07 +0000
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
Subject: [RFC kvm-unit-tests 10/27] arm: realm: Set RIPAS state for RAM
Date:   Fri, 27 Jan 2023 11:40:51 +0000
Message-ID: <20230127114108.10025-11-joey.gouly@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230127114108.10025-1-joey.gouly@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127114108.10025-1-joey.gouly@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic: AM7EUR03FT029:EE_|DU0PR08MB8422:EE_|DBAEUR03FT007:EE_|GV1PR08MB8402:EE_
X-MS-Office365-Filtering-Correlation-Id: e66a33c0-b67d-42df-2796-08db005b8d3e
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: hhtDTy6STJ9a9QEZL8zimAoI431SQb3ajffRVUwOzB2azBv+DpuOUmqM+RiuF3PS1oYf9egQTcmaOmeUGK/TsGedqJvL0rt0jf+mEy3HpHwoFV0OVsgkVsF/gdt6qfgcr5XW8FdU9CqNJpshXKN9VaKmHimY+WLgbM1SEmF1fhE3AYaPzofWgRyO4T+/4/kukYHyhpKkdZ9ImwfWL/+iCxEaYdR5YZPDKxWlZR1PY8etGHY1JEROMdeeSyu/2ESSK0NjuQSKYi3iYJyzcrV52y9gupsTIcD8HlIH0LL00cn7QRyPKzQltircLKMVmm5SAqMlJ1NMfE0H94w5ttFNEINA4h+WFsgi/zzLLgTnExUjyy+lFNR3ge4TMElHf/f1R1ex2zvWH3MSaC8qaWgb0LkFiYyV28a2b7SXnt57cuKHsfwdJrnfRGklWBuxeuheykeHwqa8o+tTXZlImScG6tZZI+7RY3TAsvb8t5qOzPL9WpNqBHPr9r6d3xhRCq67WSpGfXGprxgG7rLCa/sPz471SOvhs9FoUfE5VDW6X4N5fGNz6yW8kkBiaZgZlw35zkn7lx7ry422F+zSrfZBIb8x5rMY/3uXj+0x3r8X5CkNKLQT5/M7NfLY2nbdKXoKshS/fABOxxdWWAczM+BxuqZV8C6fkEu/1+8BThjHjJtP7vQ0k9bOaV0z08XukMzAbdy/lhJ1w3pZvBru4hqey0IC/HSFWasxtAntWH39sX6DKHswIOxYAaa/Z6ftsPCY
X-Forefront-Antispam-Report-Untrusted: CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(376002)(346002)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(7416002)(316002)(426003)(47076005)(82740400003)(336012)(40460700003)(6666004)(40480700001)(478600001)(82310400005)(70586007)(8676002)(186003)(54906003)(26005)(8936002)(1076003)(7696005)(2616005)(2906002)(41300700001)(36756003)(86362001)(5660300002)(81166007)(70206006)(4326008)(110136005)(36860700001)(356005)(44832011)(83380400001)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8422
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DBAEUR03FT007.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 93c97a55-017d-4a7d-2a0c-08db005b888a
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 92SGT4d85VI8NWAZQBDqSeEGYYAhhu74oIl0p36n2maxioajT+etPcFpkRQItbvNpB5plhXAKThMiRjJt6dvDfqSGfeKNz54Rl++2U8AXeb2C+kt+LKYB8oo4qLvj5bt9yqwDvoLZ7eDaI23ucTjqzHULi6zOHjM8GQwcIXtQMJgXkjKg7IUJSHzMIos/shUwvMFwtHn7j3CmXBZmfF+MzogIEtG5tWSUIvBKUiuWVQSoPTaPbLDjhdVQhKRarrtv/vZ5kgNpysr/xl3lXYsFUb2bCzri2Wrxxh2LHN6HafedWoxn6svSng6dYF+35HjzkEJwzoyCXty7wK82e6l85new+9u3oox9pa0lJEUqGxXy2vktMjR7m42zWmxZDGiWm9M7UA+FpkFoGYVkuGMvNSfzrKSSoUDzx80puYpNgLkFffdL3Fgq2maUQ9OueHuZSClIvRlELPA9E6os6cmhNYLck88AUgFvsj92xxmkEw/0TuCPe6qgQ3i45rRtMtSeG5iuoPUIVJ1JebpIHUBfFvablKOmU2YBh/Hg4OFIgYh9ultZiY9FcRXq4kus0kw5DW8Mv7G0wH8D+8aZKRgRWXWJDVShtkksOv009vt9ACdcMJcH9G6/MLa7NhbC4fJyaKRRC37oQ7u1j5Pmr2LbAGj/EF5C5H7Hg5JX2X2XmHpDyCic8ZQWFNeDr1wuwHv0SZgPalEVACrLe9z0ZvHcOi3JX/z5EYUEETilA5BB7s=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(136003)(396003)(39860400002)(451199018)(36840700001)(40470700004)(46966006)(41300700001)(186003)(86362001)(26005)(478600001)(1076003)(4326008)(6666004)(450100002)(70586007)(8676002)(70206006)(8936002)(316002)(7696005)(40460700003)(36756003)(54906003)(44832011)(110136005)(5660300002)(36860700001)(426003)(47076005)(2906002)(40480700001)(82310400005)(2616005)(336012)(83380400001)(82740400003)(81166007)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:42:21.4585
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e66a33c0-b67d-42df-2796-08db005b8d3e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DBAEUR03FT007.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8402
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

A Realm must ensure that the "RAM" region is set to RIPAS_RAM, before any
access is made. This patch makes sure that all memory blocks are marked as
RIPAS_RAM. Also, before we relocate the "FDT" and "initrd", make sure the
target location is marked too. This happens before we parse the memory blocks.

It is OK to do this operation on a given IPA multiple times. So, we don't
exclude the inital image areas from the "target" list.

Also, this operation doesn't require the host to commit physical memory to back
the IPAs yet. It can be done on demand via fault handling.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 lib/arm/setup.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 36d4d826..7b3dc0b8 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -181,6 +181,7 @@ static void mem_init(phys_addr_t freemem_start)
 	while (r && r->end != mem.end)
 		r = mem_region_find(r->end);
 	assert(r);
+	arm_set_memory_protected(r->start, r->end - r->start);
 
 	/* Ensure our selected freemem range is somewhere in our full range */
 	assert(freemem_start >= mem.start && freemem->end <= mem.end);
@@ -252,6 +253,11 @@ void setup(const void *fdt, phys_addr_t freemem_start)
 
 	/* Move the FDT to the base of free memory */
 	fdt_size = fdt_totalsize(fdt);
+	/*
+	 * Before we touch the memory @freemem, make sure it
+	 * is set to protected for Realms.
+	 */
+	arm_set_memory_protected((unsigned long)freemem, fdt_size);
 	ret = fdt_move(fdt, freemem, fdt_size);
 	assert(ret == 0);
 	ret = dt_init(freemem);
@@ -263,6 +269,7 @@ void setup(const void *fdt, phys_addr_t freemem_start)
 	assert(ret == 0 || ret == -FDT_ERR_NOTFOUND);
 	if (ret == 0) {
 		initrd = freemem;
+		arm_set_memory_protected((unsigned long)initrd, initrd_size);
 		memmove(initrd, tmp, initrd_size);
 		freemem += initrd_size;
 	}
-- 
2.17.1

