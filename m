Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D8767E3F3
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbjA0LqW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233084AbjA0Lpn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:45:43 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2072.outbound.protection.outlook.com [40.107.21.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C865D7CCB1;
        Fri, 27 Jan 2023 03:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MDAYQ8+UYEE6DLe0LNm6SQFVNecp3wXZDOjg6HprJE8=;
 b=i1etITeCghsbXAO2U6Vn9SY59NVE65obHNuTWo7VkrhWeRmQisYZ4VVSQKqd46CthXkffI/dDh+VnsUkw5TZQdKK6oKCheSYhZxi999PbC4/n4xH2LBf4iodvFU3LNliv0n2Kj2eKiSQdxMQKOn31GPmkorqOPt5KcSMRpfZqIM=
Received: from DBBPR09CA0029.eurprd09.prod.outlook.com (2603:10a6:10:d4::17)
 by DB8PR08MB5338.eurprd08.prod.outlook.com (2603:10a6:10:111::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 11:43:15 +0000
Received: from DBAEUR03FT032.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:d4:cafe::5c) by DBBPR09CA0029.outlook.office365.com
 (2603:10a6:10:d4::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:43:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT032.mail.protection.outlook.com (100.127.142.185) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.23 via Frontend Transport; Fri, 27 Jan 2023 11:43:15 +0000
Received: ("Tessian outbound 333ca28169fa:v132"); Fri, 27 Jan 2023 11:43:15 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: c833f2fdfedaec41
X-CR-MTA-TID: 64aa7808
Received: from c1aeac7245cb.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 6A05F7D2-29A8-4ED7-A2D2-C0C273B25438.1;
        Fri, 27 Jan 2023 11:43:08 +0000
Received: from EUR03-AM7-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id c1aeac7245cb.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:43:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FsxZLAdpJdQMUmuoFs8yklMQPqG1n9s0ICb1KtE2qUQyie9AlRtvgwInA+HD16o0j/zUTg1+QuufanbBR6iggU2/JYLGabjLaRPOSiNpkVT5TNodjwV/jomAjp2DR9n+JFADd1NBfDRSSN6n6EiAZh9EgDe7ZqpXPnIuFQ7ICX7kk/xzTJTOT9pxQeuJyb+nV4I++uWieD6qUv5FgtGYRlMbmzS2S37FTCooPvVuqZZq5WPVSMAFfa04R0xd4/QZvfl7ix11bv7kcZ/+BXUCQGrhVkLQrXIaoYpLfcO9UEi4r+u555jxsG21Zdy/SWdx2+RPeFrFpRsBlBasH/Uv0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MDAYQ8+UYEE6DLe0LNm6SQFVNecp3wXZDOjg6HprJE8=;
 b=fovWUULQeWcSA6KSPIyNUqDdEGE+uave4IjYo9pq7m9I3CmZuKDQ7yl50f7W3hi/uX5LINJxP9tjSb3zmPJUfO78ua+jhVMBSblpzSVOaRcUkn7p2uH6sSo+cNS6TWAxcdEgn+aoP/I9mj+iIdvUasklSCRbMzlA5X+WO+cqW9mrci+6Z5dnM1lzxgoGzAD9aUcQ2N9HOMD6zSvW6ObccTxisuRSKf8Mu7X4dE7fV22WO4pfxgeqzethMiRyqpWuHgIHDL1b1syISrrcGBt1fae7/FKRngWwjp35qbCdoWTcjSZDvfErGMSqscEEj8Np9toQLMHr9iXeJLoVcxICTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MDAYQ8+UYEE6DLe0LNm6SQFVNecp3wXZDOjg6HprJE8=;
 b=i1etITeCghsbXAO2U6Vn9SY59NVE65obHNuTWo7VkrhWeRmQisYZ4VVSQKqd46CthXkffI/dDh+VnsUkw5TZQdKK6oKCheSYhZxi999PbC4/n4xH2LBf4iodvFU3LNliv0n2Kj2eKiSQdxMQKOn31GPmkorqOPt5KcSMRpfZqIM=
Received: from DB7PR05CA0003.eurprd05.prod.outlook.com (2603:10a6:10:36::16)
 by VI1PR08MB5408.eurprd08.prod.outlook.com (2603:10a6:803:130::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 11:43:04 +0000
Received: from DBAEUR03FT056.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:36:cafe::b6) by DB7PR05CA0003.outlook.office365.com
 (2603:10a6:10:36::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22 via Frontend
 Transport; Fri, 27 Jan 2023 11:43:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 DBAEUR03FT056.mail.protection.outlook.com (100.127.142.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.23 via Frontend Transport; Fri, 27 Jan 2023 11:43:04 +0000
Received: from AZ-NEU-EX02.Emea.Arm.com (10.251.26.5) by AZ-NEU-EX04.Arm.com
 (10.251.24.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:43:03 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX02.Emea.Arm.com
 (10.251.26.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:43:03 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:57 +0000
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
Subject: [RFC kvm-unit-tests 19/27] arm: realm: Enable memory encryption
Date:   Fri, 27 Jan 2023 11:41:00 +0000
Message-ID: <20230127114108.10025-20-joey.gouly@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230127114108.10025-1-joey.gouly@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127114108.10025-1-joey.gouly@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic: DBAEUR03FT056:EE_|VI1PR08MB5408:EE_|DBAEUR03FT032:EE_|DB8PR08MB5338:EE_
X-MS-Office365-Filtering-Correlation-Id: 20965eea-6bcc-44df-79b5-08db005bad56
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 7rnr+3R6a1LCsyy2J/XdmpbnBnEKzsyEnWDDcuWElPJszZCIG11NceBbqP1j0pFQOFzQnPEkeJX5HZ+pad8GP35fRYCGX7+R1KLhX10QyopUyJOpuQzCUAaDsHL37LqfxHVtXVnM/mbQnt1onL0yJFAPYOFEx6ZqumwSAGSNnB64bs/MbaAoPftfcAJq4uTKG16yxb3q509Dcc9II7Z2LV9TVM3t2PlxGak0a5YvABof9T90kraWMKPua2h77hSwK6KUR/hG03J2Fncu3rGm30/ruj5tnOof3AHLbAdYqb4QrQQn2z+3XQegxAfwJynA8IESZzZPKfmievvEtZg/NQbsRkyURYmyTHu/VNFxhX/dqy5tBsJtVttFfjy0pj5lQ5kvBHZW5VeR8njhpqBSX4TroxXOkioZOfdzoliRolIw7dybC3quMaMn/zc+JgyfsOyOgdXRFf5oUQrkKPedLWEBwRPyZ/3+J5CJzlZ4IYB7FOIZcAIFROps9lxvDExfj+Wuu/hGLN+2i9Z9WtmcX/diVeDRG0xTsCa6Sr3kEKJfUGHr6uwmMNVJ8uX8CWtz2UpzzH5i7eaplWgaVEJV/dn22ucMf3s8ez+flVOae6LSI2dUxX/vNfhTBGh4/Q1zMHpbqUC8lbkSjXeNuvVTJL4TTHRV8b1m5IqkoHq9ZTQE/aPOZDnHbQyCY0mg5Ym+TadMcqkFagzmFsjCtSa1kX+U+fc8Oew+u5YLziBS3xzj3S2eNKhCKtQH2UgnUp9Y
X-Forefront-Antispam-Report-Untrusted: CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(136003)(396003)(346002)(451199018)(46966006)(40470700004)(36840700001)(82310400005)(36756003)(2906002)(6666004)(7416002)(41300700001)(8936002)(70206006)(70586007)(44832011)(5660300002)(8676002)(40480700001)(4326008)(316002)(36860700001)(40460700003)(86362001)(110136005)(7696005)(54906003)(478600001)(356005)(1076003)(81166007)(186003)(26005)(82740400003)(83380400001)(2616005)(426003)(336012)(47076005)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5408
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DBAEUR03FT032.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 5c348f23-71da-4fc9-a759-08db005ba6cb
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iYc/76WXSVwf5b4iSxD1glybNnymH/T6owZISoInFI7mSs/uEaws11lEGzjfLESlmi5nkDGT1CgwYIzt4UNZgyHcV5C0PNFWz0jtQuAd+bmYb2GEl195Wb8xvNJUMlnwIsv21jN+o8eKRpIkbUQOLFZeookAkJ+9b658PdjlN+xAruCCTdS7e4vXjF1uKGq3x2ClBKabKcYENryqfHRf+72rpDFHk2eBA5KWYBXo/HZHvg3jWJocKnkYhqcx+psKCWbv61IYpT4mYbyiB8QotgkTtEsrxVX+PIGm5GHjPYuQjlz+bqDviTy19frKKFMvNzP0QuNLES9stYBapJ7Wn1ZaZyC8E4p7c/iVd3OrHAfCqAUP/9gvgivoTaMourH+q5lFTDOFdO7B7+hNc89pE1SDWY1TpdUNF3OiZw+HlQwyZBPkio8slT3fYncOkAbKNieQC7NAlg/Yw1RMXPtXlO5Q0TFYGF4Jh17RqQ6PfIB5b5GROFZ7bvuTh/xZoX7PWk5QMbvetwZaw7+1k0uzVuHntRBtyFAzM6av1SUw7bO5gE2QcWWFJz2HrXaDWj9La64scGaHU+8GghddNW/S/JQBkY97QmlZY11bt41QkV+h+jM/GbM65kZcU/yuB9ljZluQqVedUxqLDh6NeeaRJhhjdDxunbFxpmgyVifSv0fo0HW35Hf2FOwlKVDSnNu4pWCpG/WdK8Tjx9Y43lHWdUTseUL0zaALcBUGkuiPozk=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(396003)(376002)(346002)(451199018)(36840700001)(40470700004)(46966006)(70586007)(4326008)(316002)(82310400005)(450100002)(70206006)(8936002)(54906003)(36756003)(5660300002)(8676002)(82740400003)(36860700001)(86362001)(81166007)(41300700001)(186003)(1076003)(26005)(6666004)(110136005)(336012)(426003)(47076005)(44832011)(40460700003)(40480700001)(2906002)(2616005)(478600001)(7696005)(83380400001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:43:15.2894
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 20965eea-6bcc-44df-79b5-08db005bad56
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DBAEUR03FT032.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5338
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

Enable memory encryption support for Realms.

When a page is "decrypted", we set the RIPAS to EMPTY, hinting to the hypervisor
that it could reclaim the page backing the IPA. Also the pagetable is updated
with the PTE_NS_SHARED attrbiute, whic in effect turns the "ipa" to the
unprotected alias.

Similarly for "encryption" we mark the IPA back to RIPAS_RAM and clear the
PTE_NS_SHARED attribute.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 lib/arm/mmu.c      | 65 ++++++++++++++++++++++++++++++++++++++++++++--
 lib/arm64/asm/io.h |  6 +++++
 2 files changed, 69 insertions(+), 2 deletions(-)

diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 2b5a7141..d4fbe56a 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -22,6 +22,7 @@
 #include <linux/compiler.h>
 
 pgd_t *mmu_idmap;
+unsigned long idmap_end;
 
 /* Used by Realms, depends on IPA size */
 unsigned long prot_ns_shared = 0;
@@ -30,6 +31,11 @@ unsigned long phys_mask_shift = 48;
 /* CPU 0 starts with disabled MMU */
 static cpumask_t mmu_enabled_cpumask;
 
+static bool is_idmap_address(phys_addr_t pa)
+{
+	return pa < idmap_end;
+}
+
 bool mmu_enabled(void)
 {
 	/*
@@ -92,12 +98,17 @@ static pteval_t *get_pte(pgd_t *pgtable, uintptr_t vaddr)
 	return &pte_val(*pte);
 }
 
+static void set_pte(uintptr_t vaddr, pteval_t *p_pte, pteval_t pte)
+{
+	WRITE_ONCE(*p_pte, pte);
+	flush_tlb_page(vaddr);
+}
+
 static pteval_t *install_pte(pgd_t *pgtable, uintptr_t vaddr, pteval_t pte)
 {
 	pteval_t *p_pte = get_pte(pgtable, vaddr);
 
-	WRITE_ONCE(*p_pte, pte);
-	flush_tlb_page(vaddr);
+	set_pte(vaddr, p_pte, pte);
 	return p_pte;
 }
 
@@ -122,6 +133,39 @@ phys_addr_t virt_to_pte_phys(pgd_t *pgtable, void *mem)
 		+ ((ulong)mem & (PAGE_SIZE - 1));
 }
 
+/*
+ * __idmap_set_range_prot - Apply permissions to the given idmap range.
+ */
+static void __idmap_set_range_prot(unsigned long virt_offset, size_t size, pgprot_t prot)
+{
+	pteval_t *ptep;
+	pteval_t default_prot = PTE_TYPE_PAGE | PTE_AF | PTE_SHARED;
+
+	while (size > 0) {
+		pteval_t pte = virt_offset | default_prot | pgprot_val(prot);
+
+		if (!is_idmap_address(virt_offset))
+			break;
+		/* Break before make : Clear the PTE entry first */
+		ptep = install_pte(mmu_idmap, (uintptr_t)virt_offset, 0);
+		/* Now apply the changes */
+		set_pte((uintptr_t)virt_offset, ptep, pte);
+
+		size -= PAGE_SIZE;
+		virt_offset += PAGE_SIZE;
+	}
+}
+
+static void idmap_set_range_shared(unsigned long virt_offset, size_t size)
+{
+	return __idmap_set_range_prot(virt_offset, size, __pgprot(PTE_WBWA | PTE_USER | PTE_NS_SHARED));
+}
+
+static void idmap_set_range_protected(unsigned long virt_offset, size_t size)
+{
+	__idmap_set_range_prot(virt_offset, size, __pgprot(PTE_WBWA | PTE_USER));
+}
+
 void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
 			phys_addr_t phys_start, phys_addr_t phys_end,
 			pgprot_t prot)
@@ -190,6 +234,7 @@ void *setup_mmu(phys_addr_t phys_end, void *unused)
 	}
 
 	mmu_enable(mmu_idmap);
+	idmap_end = phys_end;
 	return mmu_idmap;
 }
 
@@ -278,3 +323,19 @@ void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
 		flush_tlb_page(vaddr);
 	}
 }
+
+void set_memory_encrypted(unsigned long va, size_t size)
+{
+	if (is_realm()) {
+		arm_set_memory_protected(__virt_to_phys(va), size);
+		idmap_set_range_protected(va, size);
+	}
+}
+
+void set_memory_decrypted(unsigned long va, size_t size)
+{
+	if (is_realm()) {
+		arm_set_memory_shared(__virt_to_phys(va), size);
+		idmap_set_range_shared(va, size);
+	}
+}
diff --git a/lib/arm64/asm/io.h b/lib/arm64/asm/io.h
index be19f471..3f71254d 100644
--- a/lib/arm64/asm/io.h
+++ b/lib/arm64/asm/io.h
@@ -89,6 +89,12 @@ static inline void *phys_to_virt(phys_addr_t x)
 	return (void *)__phys_to_virt(x);
 }
 
+extern void set_memory_decrypted(unsigned long va, size_t size);
+#define set_memory_decrypted		set_memory_decrypted
+
+extern void set_memory_encrypted(unsigned long va, size_t size);
+#define set_memory_encrypted	set_memory_encrypted
+
 #include <asm-generic/io.h>
 
 #endif /* _ASMARM64_IO_H_ */
-- 
2.17.1

