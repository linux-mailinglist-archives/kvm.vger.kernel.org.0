Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431A029F093
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 16:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728467AbgJ2Pw7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 11:52:59 -0400
Received: from mail-eopbgr40062.outbound.protection.outlook.com ([40.107.4.62]:50403
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728459AbgJ2Pw7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Oct 2020 11:52:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ke6dLF2QgLBSdOv05hjNSZSOpmhELO3Bgg3EEK00Jwc=;
 b=3Jy+dA5hsDXfRnlt7MHRke/pfNcWnqnhWrXmLw23/Yz3XynqF7hkzSVgUcXrEL1k4MGG3S5JBU5D9nIPyLG1XsXjbuutfuT1XiyeMLoTXWrI/GPWpbNyywaNdsmShLH7N2KxgBFfmV+yidG+1s/GmSl8QYLGZdDb0TCmr2MfWys=
Received: from DB7PR05CA0023.eurprd05.prod.outlook.com (2603:10a6:10:36::36)
 by AM9PR08MB6241.eurprd08.prod.outlook.com (2603:10a6:20b:281::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Thu, 29 Oct
 2020 15:52:51 +0000
Received: from DB5EUR03FT003.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:36:cafe::4) by DB7PR05CA0023.outlook.office365.com
 (2603:10a6:10:36::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend
 Transport; Thu, 29 Oct 2020 15:52:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT003.mail.protection.outlook.com (10.152.20.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3520.15 via Frontend Transport; Thu, 29 Oct 2020 15:52:50 +0000
Received: ("Tessian outbound a64c3afb6fc9:v64"); Thu, 29 Oct 2020 15:52:50 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 19902f423d57cee3
X-CR-MTA-TID: 64aa7808
Received: from 87b761ea14f9.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 60A64232-C721-4701-B08E-A39CFD9BAFC3.1;
        Thu, 29 Oct 2020 15:52:43 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 87b761ea14f9.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 29 Oct 2020 15:52:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CGYYK081E983J7U7DZF/79mwbU9keQ64avMHoM3AaoXZgXjaUt7lbYLwgV0omKVEZa5jxqjA/oKyvPSTPeUliRm32h0WL/E7fBmpbgE2l5jYGuYL9mn8+4fmafaKTjkAOo9Edxr4KV/zTaCMdOFHUTtil2vDhVBXbfYEEVqKadrTBUzmcZFicwnxTy1HvdnVTyOFBud75rhYiTRl1XQKx43gtd8RsV168eNHNvFVTtN6bC3Y4fDovfRK9UvdloM/4RzwY+Ua+Q7ZwuafOsfp3VuKgVYuyeYfS4SkRUIa4dQYrsf3EeeZuU4R2UvTDOIjoxLIg5TyJ6D7b71K1A94Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ke6dLF2QgLBSdOv05hjNSZSOpmhELO3Bgg3EEK00Jwc=;
 b=SQnjGnncvGNROXYCC9qeQE50D/ooXORe3nl82Wvp8F/B1FyKky3huKFkrIWpGMEXf110VJRHKcEsVTn2Dm+Q9p2fRxIs5WNt26G61iFNKs01NHL5b3SHJsHfLaHnuwnmEaD9plxjtJJhekucdlDzNmBLbQt4gVkhokRkugeAIwLwlyIg2AkuO2pRA460JVkHaGLVPzZIqfXdx2j1RxGiuzpwo6c/Bm8O1Nd/dM0p3dsQZ+E0ylMwEZ0zjQ/aShOhwEoLKbhSP2nN4vf+P8jAoRvyC2SpMQ/5Snm8S05zlFbNODzqyL/qvC8UC1vfPJ3twXNr7/V2JCD2GIoLFJaVLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ke6dLF2QgLBSdOv05hjNSZSOpmhELO3Bgg3EEK00Jwc=;
 b=3Jy+dA5hsDXfRnlt7MHRke/pfNcWnqnhWrXmLw23/Yz3XynqF7hkzSVgUcXrEL1k4MGG3S5JBU5D9nIPyLG1XsXjbuutfuT1XiyeMLoTXWrI/GPWpbNyywaNdsmShLH7N2KxgBFfmV+yidG+1s/GmSl8QYLGZdDb0TCmr2MfWys=
Authentication-Results-Original: vger.kernel.org; dkim=none (message not
 signed) header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received: from DB8PR08MB5339.eurprd08.prod.outlook.com (2603:10a6:10:114::19)
 by DBBPR08MB4645.eurprd08.prod.outlook.com (2603:10a6:10:dc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25; Thu, 29 Oct
 2020 15:52:42 +0000
Received: from DB8PR08MB5339.eurprd08.prod.outlook.com
 ([fe80::f848:3db5:1e63:69a7]) by DB8PR08MB5339.eurprd08.prod.outlook.com
 ([fe80::f848:3db5:1e63:69a7%9]) with mapi id 15.20.3455.040; Thu, 29 Oct 2020
 15:52:42 +0000
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     mark.rutland@arm.com, jade.alglave@arm.com, luc.maranget@inria.fr,
        andre.przywara@arm.com, nd@arm.com, alexandru.elisei@arm.com,
        drjones@redhat.com
Subject: [kvm-unit-tests PATCH] arm64: Add support for configuring the translation granule
Date:   Thu, 29 Oct 2020 15:52:29 +0000
Message-Id: <20201029155229.7518-1-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.140.106.49]
X-ClientProxiedBy: SN4PR0801CA0001.namprd08.prod.outlook.com
 (2603:10b6:803:29::11) To DB8PR08MB5339.eurprd08.prod.outlook.com
 (2603:10a6:10:114::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from camtx2.cambridge.arm.com (217.140.106.49) by SN4PR0801CA0001.namprd08.prod.outlook.com (2603:10b6:803:29::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Thu, 29 Oct 2020 15:52:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9ee518c2-2ebc-4277-cc07-08d87c22b0bf
X-MS-TrafficTypeDiagnostic: DBBPR08MB4645:|AM9PR08MB6241:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9PR08MB62415A23F2E442F5F2303856F7140@AM9PR08MB6241.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: jMuegNps9kYxb79lolis5liDmPuZYM7JHaKuVNq54XlAIHO9K6DDFifo/4Zw1T8u7vW0v395Lf+x1t9aqK6WSgVgCFQmfGYKmRytLN9PkYW6JMWPii4C/7kmvuvtRlaC5gJ582cwZmf3dS1sNPvcE4tkfNl1DNAjkKTi3BUg4M5uB69coma3BgJPpiZY7ESDa22B+cvBpbqg+hIPDTf7kiSgX7CBR4P6przE2UDCJFjvra+9zn3/kIErWN9dgeQAsskxeFCo9lmV/KYIgnFPEl6+9KT+ZxIV0UJJ6ioxq7W/lOhJd9MCP4PvOHj5FvYf
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR08MB5339.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(396003)(346002)(376002)(2906002)(6666004)(8676002)(16526019)(186003)(26005)(6916009)(36756003)(4326008)(7696005)(52116002)(6486002)(83380400001)(956004)(2616005)(86362001)(5660300002)(30864003)(316002)(66946007)(66556008)(478600001)(66476007)(1076003)(8936002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +vmTGSmlmqYiN2/4ghwM1kl9C4/abUQ3CDuUpax4TupuJheKOQMk8YMOavA8zYQ1fQYUKfy87VYXENT8PtMfHHtpFYXGGhT3c5wgdItRlKmiEfJswARWpSl7BDqaRjRWVzlbRbpLzXoChZmio5MjVr5UFE43f4/K8EaUnIkEXPKeS8l1L8r3c6ZdvStBkeClMPCVjdbOUTxEufVewCgHgdc893BLVU8fV+RbO20bEDK5XcYuYnN14rNDas0mPpA71J/9PaNIAt5cNDOAPn22A5lVG05+M4obF2VCxQEXCkg377fzX1YJbyKe5A4BWshREkkQdwfWVkjk00X2lknYZLfVh5NwUuBTID0x+U8QZdyQley7KG4obgWXHTL3iUFRcMGl7jnkKLVUZ8JB5Suo3BMZU7vdzcirOF0VmsxTvF95p6gzbBS1RkGd4uXFl4SGt8hE67Zu+PrtobgyY3vgWUe14wHloV7yZz4ql9NSSa+75mIJPK6rtq49TyMuJ6dQGcyHx9Er6rq3CKQvtS/hOFdnfIdhphjPZHnU8BmmKh37Z+ltrOqAGy6KtTzHDmPFWNC7g2/aNv3K6Ls4gtcI4SHTZV3NK8Um+NRxH0OkeHYkPdAei55RhMx09z7xqGwCTCbnBM2tmO3Lo2NAWRZxwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB4645
Original-Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT003.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 82701f55-6578-4860-9692-08d87c22ab7d
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: osswuIam2sEt77pHFNDlYjnRqsr3LS7B4adRjfeh3PgKUTaiZOAP5W8CVYOC5c31WFIkGWvvTxeJA/MtxUKtJlu2eYwDMe5DVsE436UabKBTPczQsj7r9KXSEnAR5ltSCx7NQnl4rgdLxulH3ADnHHycGPM+hhubSlfh8aprXHSDarWVa4Rm4r4TF2AI0UL64n5HI9ZsfG4RUI96+YrZF6qtSzTbTwHWVtFdn/j+wpPNcQUZQhsANPU1OaEbe/kGR8N4HQrwLW9/b54kne4aemq6whYcwUA710HhynuGWwX0BCqzDVqrCFOuHpd9eSTy/ZoDX2tYj2svkVudap9FXwz9pUjJJucqXYI5hdQKgforeozdnlxYU3EYBL3n2Np35BvKV14oTmqsEVYOw/xo1Q==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(136003)(39860400002)(46966005)(70206006)(4326008)(8676002)(36756003)(70586007)(6916009)(2616005)(356005)(107886003)(81166007)(478600001)(83380400001)(956004)(7696005)(1076003)(82740400003)(82310400003)(6486002)(47076004)(186003)(316002)(44832011)(336012)(5660300002)(6666004)(26005)(16526019)(86362001)(8936002)(2906002)(30864003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2020 15:52:50.8937
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ee518c2-2ebc-4277-cc07-08d87c22b0bf
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT003.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6241
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make the translation granule configurable for arm64. arm64 supports
page sizes of 4K, 16K and 64K. By default, arm64 is configured with
64K pages. configure has been extended with a new argument:

 --page-shift=(12|14|16)

which allows the user to set the page shift and therefore the page
size for arm64. Using the --page-shift for any other architecture
results an error message.

To allow for smaller page sizes and 42b VA, this change adds support
for 4-level and 3-level page tables. At compile time, we determine how
many levels in the page tables we needed.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 configure                     | 21 +++++++++++
 lib/arm/asm/page.h            |  4 ++
 lib/arm/asm/pgtable-hwdef.h   |  4 ++
 lib/arm/asm/pgtable.h         |  6 +++
 lib/arm/asm/thread_info.h     |  4 +-
 lib/arm64/asm/page.h          | 17 ++++++---
 lib/arm64/asm/pgtable-hwdef.h | 38 +++++++++++++------
 lib/arm64/asm/pgtable.h       | 69 +++++++++++++++++++++++++++++++++--
 lib/arm/mmu.c                 | 26 ++++++++-----
 arm/cstart64.S                | 12 +++++-
 10 files changed, 169 insertions(+), 32 deletions(-)

diff --git a/configure b/configure
index 706aab5..94637ec 100755
--- a/configure
+++ b/configure
@@ -25,6 +25,7 @@ vmm="qemu"
 errata_force=0
 erratatxt="$srcdir/errata.txt"
 host_key_document=
+page_shift=
 
 usage() {
     cat <<-EOF
@@ -105,6 +106,9 @@ while [[ "$1" = -* ]]; do
 	--host-key-document)
 	    host_key_document="$arg"
 	    ;;
+        --page-shift)
+            page_shift="$arg"
+            ;;
 	--help)
 	    usage
 	    ;;
@@ -123,6 +127,22 @@ arch_name=$arch
 [ "$arch" = "aarch64" ] && arch="arm64"
 [ "$arch_name" = "arm64" ] && arch_name="aarch64"
 
+if [ -z "$page_shift" ]; then
+    [ "$arch" = "arm64" ] && page_shift="16"
+    [ "$arch" = "arm" ] && page_shift="12"
+else
+    if [ "$arch" != "arm64" ]; then
+        echo "--page-shift is not supported for $arch"
+        usage
+    fi
+
+    if [ "$page_shift" != "12" ] && [ "$page_shift" != "14" ] &&
+           [ "$page_shift" != "16" ]; then
+        echo "Page shift of $page_shift not supported for arm64"
+        usage
+    fi
+fi
+
 [ -z "$processor" ] && processor="$arch"
 
 if [ "$processor" = "arm64" ]; then
@@ -254,6 +274,7 @@ cat <<EOF >> lib/config.h
 
 #define CONFIG_UART_EARLY_BASE ${arm_uart_early_addr}
 #define CONFIG_ERRATA_FORCE ${errata_force}
+#define CONFIG_PAGE_SHIFT ${page_shift}
 
 EOF
 fi
diff --git a/lib/arm/asm/page.h b/lib/arm/asm/page.h
index 039c9f7..ae0ac2c 100644
--- a/lib/arm/asm/page.h
+++ b/lib/arm/asm/page.h
@@ -29,6 +29,10 @@ typedef struct { pteval_t pgprot; } pgprot_t;
 #define pgd_val(x)		((x).pgd)
 #define pgprot_val(x)		((x).pgprot)
 
+/* For compatibility with arm64 page tables */
+#define pud_t pgd_t
+#define pud_val(x) pgd_val(x)
+
 #define __pte(x)		((pte_t) { (x) } )
 #define __pmd(x)		((pmd_t) { (x) } )
 #define __pgd(x)		((pgd_t) { (x) } )
diff --git a/lib/arm/asm/pgtable-hwdef.h b/lib/arm/asm/pgtable-hwdef.h
index 4107e18..fe1d854 100644
--- a/lib/arm/asm/pgtable-hwdef.h
+++ b/lib/arm/asm/pgtable-hwdef.h
@@ -19,6 +19,10 @@
 #define PTRS_PER_PTE		512
 #define PTRS_PER_PMD		512
 
+/* For compatibility with arm64 page tables */
+#define PUD_SIZE		PGDIR_SIZE
+#define PUD_MASK		PGDIR_MASK
+
 #define PMD_SHIFT		21
 #define PMD_SIZE		(_AC(1,UL) << PMD_SHIFT)
 #define PMD_MASK		(~((1 << PMD_SHIFT) - 1))
diff --git a/lib/arm/asm/pgtable.h b/lib/arm/asm/pgtable.h
index 078dd16..4759d82 100644
--- a/lib/arm/asm/pgtable.h
+++ b/lib/arm/asm/pgtable.h
@@ -53,6 +53,12 @@ static inline pmd_t *pgd_page_vaddr(pgd_t pgd)
 	return pgtable_va(pgd_val(pgd) & PHYS_MASK & (s32)PAGE_MASK);
 }
 
+/* For compatibility with arm64 page tables */
+#define pud_valid(pud)		pgd_valid(pud)
+#define pud_offset(pgd, addr)  ((pud_t *)pgd)
+#define pud_free(pud)
+#define pud_alloc(pgd, addr)   pud_offset(pgd, addr)
+
 #define pmd_index(addr) \
 	(((addr) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
 #define pmd_offset(pgd, addr) \
diff --git a/lib/arm/asm/thread_info.h b/lib/arm/asm/thread_info.h
index 80ab395..eaa7258 100644
--- a/lib/arm/asm/thread_info.h
+++ b/lib/arm/asm/thread_info.h
@@ -14,10 +14,12 @@
 #define THREAD_SHIFT		PAGE_SHIFT
 #define THREAD_SIZE		PAGE_SIZE
 #define THREAD_MASK		PAGE_MASK
+#define THREAD_ALIGNMENT	PAGE_SIZE
 #else
 #define THREAD_SHIFT		MIN_THREAD_SHIFT
 #define THREAD_SIZE		(_AC(1,UL) << THREAD_SHIFT)
 #define THREAD_MASK		(~(THREAD_SIZE-1))
+#define THREAD_ALIGNMENT	THREAD_SIZE
 #endif
 
 #ifndef __ASSEMBLY__
@@ -38,7 +40,7 @@
 
 static inline void *thread_stack_alloc(void)
 {
-	void *sp = memalign(PAGE_SIZE, THREAD_SIZE);
+	void *sp = memalign(THREAD_ALIGNMENT, THREAD_SIZE);
 	return sp + THREAD_START_SP;
 }
 
diff --git a/lib/arm64/asm/page.h b/lib/arm64/asm/page.h
index 46af552..726a0c0 100644
--- a/lib/arm64/asm/page.h
+++ b/lib/arm64/asm/page.h
@@ -10,38 +10,43 @@
  * This work is licensed under the terms of the GNU GPL, version 2.
  */
 
+#include <config.h>
 #include <linux/const.h>
 
-#define PGTABLE_LEVELS		2
 #define VA_BITS			42
 
-#define PAGE_SHIFT		16
+#define PAGE_SHIFT		CONFIG_PAGE_SHIFT
 #define PAGE_SIZE		(_AC(1,UL) << PAGE_SHIFT)
 #define PAGE_MASK		(~(PAGE_SIZE-1))
 
+#define PGTABLE_LEVELS		(((VA_BITS) - 4) / (PAGE_SHIFT - 3))
+
 #ifndef __ASSEMBLY__
 
 #define PAGE_ALIGN(addr)	ALIGN(addr, PAGE_SIZE)
 
 typedef u64 pteval_t;
 typedef u64 pmdval_t;
+typedef u64 pudval_t;
 typedef u64 pgdval_t;
 typedef struct { pteval_t pte; } pte_t;
+typedef struct { pmdval_t pmd; } pmd_t;
+typedef struct { pudval_t pud; } pud_t;
 typedef struct { pgdval_t pgd; } pgd_t;
 typedef struct { pteval_t pgprot; } pgprot_t;
 
 #define pte_val(x)		((x).pte)
+#define pmd_val(x)		((x).pmd)
+#define pud_val(x)		((x).pud)
 #define pgd_val(x)		((x).pgd)
 #define pgprot_val(x)		((x).pgprot)
 
 #define __pte(x)		((pte_t) { (x) } )
+#define __pmd(x)		((pmd_t) { (x) } )
+#define __pud(x)		((pud_t) { (x) } )
 #define __pgd(x)		((pgd_t) { (x) } )
 #define __pgprot(x)		((pgprot_t) { (x) } )
 
-typedef struct { pgd_t pgd; } pmd_t;
-#define pmd_val(x)		(pgd_val((x).pgd))
-#define __pmd(x)		((pmd_t) { __pgd(x) } )
-
 #define __va(x)			((void *)__phys_to_virt((phys_addr_t)(x)))
 #define __pa(x)			__virt_to_phys((unsigned long)(x))
 
diff --git a/lib/arm64/asm/pgtable-hwdef.h b/lib/arm64/asm/pgtable-hwdef.h
index 3352489..f9110e1 100644
--- a/lib/arm64/asm/pgtable-hwdef.h
+++ b/lib/arm64/asm/pgtable-hwdef.h
@@ -9,38 +9,54 @@
  * This work is licensed under the terms of the GNU GPL, version 2.
  */
 
+#include <asm/page.h>
+
 #define UL(x) _AC(x, UL)
 
+#define PGTABLE_LEVEL_SHIFT(n)	((PAGE_SHIFT - 3) * (4 - (n)) + 3)
 #define PTRS_PER_PTE		(1 << (PAGE_SHIFT - 3))
 
+#if PGTABLE_LEVELS > 2
+#define PMD_SHIFT		PGTABLE_LEVEL_SHIFT(2)
+#define PTRS_PER_PMD		PTRS_PER_PTE
+#define PMD_SIZE		(UL(1) << PMD_SHIFT)
+#define PMD_MASK		(~(PMD_SIZE-1))
+#endif
+
+#if PGTABLE_LEVELS > 3
+#define PUD_SHIFT		PGTABLE_LEVEL_SHIFT(1)
+#define PTRS_PER_PUD		PTRS_PER_PTE
+#define PUD_SIZE		(UL(1) << PUD_SHIFT)
+#define PUD_MASK		(~(PUD_SIZE-1))
+#else
+#define PUD_SIZE                PGDIR_SIZE
+#define PUD_MASK                PGDIR_MASK
+#endif
+
+#define PUD_VALID		(_AT(pudval_t, 1) << 0)
+
 /*
  * PGDIR_SHIFT determines the size a top-level page table entry can map
  * (depending on the configuration, this level can be 0, 1 or 2).
  */
-#define PGDIR_SHIFT		((PAGE_SHIFT - 3) * PGTABLE_LEVELS + 3)
+#define PGDIR_SHIFT		PGTABLE_LEVEL_SHIFT(4 - PGTABLE_LEVELS)
 #define PGDIR_SIZE		(_AC(1, UL) << PGDIR_SHIFT)
 #define PGDIR_MASK		(~(PGDIR_SIZE-1))
 #define PTRS_PER_PGD		(1 << (VA_BITS - PGDIR_SHIFT))
 
 #define PGD_VALID		(_AT(pgdval_t, 1) << 0)
 
-/* From include/asm-generic/pgtable-nopmd.h */
-#define PMD_SHIFT		PGDIR_SHIFT
-#define PTRS_PER_PMD		1
-#define PMD_SIZE		(UL(1) << PMD_SHIFT)
-#define PMD_MASK		(~(PMD_SIZE-1))
-
 /*
  * Section address mask and size definitions.
  */
-#define SECTION_SHIFT		PMD_SHIFT
-#define SECTION_SIZE		(_AC(1, UL) << SECTION_SHIFT)
-#define SECTION_MASK		(~(SECTION_SIZE-1))
+#define SECTION_SHIFT          PMD_SHIFT
+#define SECTION_SIZE           (_AC(1, UL) << SECTION_SHIFT)
+#define SECTION_MASK           (~(SECTION_SIZE-1))
 
 /*
  * Hardware page table definitions.
  *
- * Level 1 descriptor (PMD).
+ * Level 0,1,2 descriptor (PGG, PUD and PMD).
  */
 #define PMD_TYPE_MASK		(_AT(pmdval_t, 3) << 0)
 #define PMD_TYPE_FAULT		(_AT(pmdval_t, 0) << 0)
diff --git a/lib/arm64/asm/pgtable.h b/lib/arm64/asm/pgtable.h
index e577d9c..c7632ae 100644
--- a/lib/arm64/asm/pgtable.h
+++ b/lib/arm64/asm/pgtable.h
@@ -30,10 +30,12 @@
 #define pgtable_pa(x)		((unsigned long)(x))
 
 #define pgd_none(pgd)		(!pgd_val(pgd))
+#define pud_none(pud)		(!pud_val(pud))
 #define pmd_none(pmd)		(!pmd_val(pmd))
 #define pte_none(pte)		(!pte_val(pte))
 
 #define pgd_valid(pgd)		(pgd_val(pgd) & PGD_VALID)
+#define pud_valid(pud)		(pud_val(pud) & PUD_VALID)
 #define pmd_valid(pmd)		(pmd_val(pmd) & PMD_SECT_VALID)
 #define pte_valid(pte)		(pte_val(pte) & PTE_VALID)
 
@@ -52,15 +54,76 @@ static inline pgd_t *pgd_alloc(void)
 	return pgd;
 }
 
-#define pmd_offset(pgd, addr)	((pmd_t *)pgd)
-#define pmd_free(pmd)
-#define pmd_alloc(pgd, addr)	pmd_offset(pgd, addr)
+static inline pud_t *pgd_page_vaddr(pgd_t pgd)
+{
+	return pgtable_va(pgd_val(pgd) & PHYS_MASK & (s32)PAGE_MASK);
+}
+
+static inline pmd_t *pud_page_vaddr(pud_t pud)
+{
+	return pgtable_va(pud_val(pud) & PHYS_MASK & (s32)PAGE_MASK);
+}
+
 
 static inline pte_t *pmd_page_vaddr(pmd_t pmd)
 {
 	return pgtable_va(pmd_val(pmd) & PHYS_MASK & (s32)PAGE_MASK);
 }
 
+#if PGTABLE_LEVELS > 2
+#define pmd_index(addr)					\
+	(((addr) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
+#define pmd_offset(pud, addr)				\
+	(pud_page_vaddr(*(pud)) + pmd_index(addr))
+#define pmd_free(pmd) free_page(pmd)
+static inline pmd_t *pmd_alloc_one(void)
+{
+	assert(PTRS_PER_PMD * sizeof(pmd_t) == PAGE_SIZE);
+	pmd_t *pmd = alloc_page();
+	return pmd;
+}
+static inline pmd_t *pmd_alloc(pud_t *pud, unsigned long addr)
+{
+        if (pud_none(*pud)) {
+		pud_t entry;
+		pud_val(entry) = pgtable_pa(pmd_alloc_one()) | PMD_TYPE_TABLE;
+		WRITE_ONCE(*pud, entry);
+	}
+	return pmd_offset(pud, addr);
+}
+#else
+#define pmd_offset(pud, addr)  ((pmd_t *)pud)
+#define pmd_free(pmd)
+#define pmd_alloc(pud, addr)   pmd_offset(pud, addr)
+#endif
+
+#if PGTABLE_LEVELS > 3
+#define pud_index(addr)                                 \
+	(((addr) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
+#define pud_offset(pgd, addr)                           \
+	(pgd_page_vaddr(*(pgd)) + pud_index(addr))
+#define pud_free(pud) free_page(pud)
+static inline pud_t *pud_alloc_one(void)
+{
+	assert(PTRS_PER_PMD * sizeof(pud_t) == PAGE_SIZE);
+	pud_t *pud = alloc_page();
+	return pud;
+}
+static inline pud_t *pud_alloc(pgd_t *pgd, unsigned long addr)
+{
+	if (pgd_none(*pgd)) {
+		pgd_t entry;
+		pgd_val(entry) = pgtable_pa(pud_alloc_one()) | PMD_TYPE_TABLE;
+		WRITE_ONCE(*pgd, entry);
+	}
+	return pud_offset(pgd, addr);
+}
+#else
+#define pud_offset(pgd, addr)  ((pud_t *)pgd)
+#define pud_free(pud)
+#define pud_alloc(pgd, addr)   pud_offset(pgd, addr)
+#endif
+
 #define pte_index(addr) \
 	(((addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
 #define pte_offset(pmd, addr) \
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 540a1e8..6d1c75b 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -81,7 +81,8 @@ void mmu_disable(void)
 static pteval_t *get_pte(pgd_t *pgtable, uintptr_t vaddr)
 {
 	pgd_t *pgd = pgd_offset(pgtable, vaddr);
-	pmd_t *pmd = pmd_alloc(pgd, vaddr);
+	pud_t *pud = pud_alloc(pgd, vaddr);
+	pmd_t *pmd = pmd_alloc(pud, vaddr);
 	pte_t *pte = pte_alloc(pmd, vaddr);
 
 	return &pte_val(*pte);
@@ -133,18 +134,20 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
 			phys_addr_t phys_start, phys_addr_t phys_end,
 			pgprot_t prot)
 {
-	phys_addr_t paddr = phys_start & PGDIR_MASK;
-	uintptr_t vaddr = virt_offset & PGDIR_MASK;
+	phys_addr_t paddr = phys_start & PUD_MASK;
+	uintptr_t vaddr = virt_offset & PUD_MASK;
 	uintptr_t virt_end = phys_end - paddr + vaddr;
 	pgd_t *pgd;
-	pgd_t entry;
+	pud_t *pud;
+	pud_t entry;
 
-	for (; vaddr < virt_end; vaddr += PGDIR_SIZE, paddr += PGDIR_SIZE) {
-		pgd_val(entry) = paddr;
-		pgd_val(entry) |= PMD_TYPE_SECT | PMD_SECT_AF | PMD_SECT_S;
-		pgd_val(entry) |= pgprot_val(prot);
+	for (; vaddr < virt_end; vaddr += PUD_SIZE, paddr += PUD_SIZE) {
+		pud_val(entry) = paddr;
+		pud_val(entry) |= PMD_TYPE_SECT | PMD_SECT_AF | PMD_SECT_S;
+		pud_val(entry) |= pgprot_val(prot);
 		pgd = pgd_offset(pgtable, vaddr);
-		WRITE_ONCE(*pgd, entry);
+		pud = pud_alloc(pgd, vaddr);
+		WRITE_ONCE(*pud, entry);
 		flush_tlb_page(vaddr);
 	}
 }
@@ -207,6 +210,7 @@ unsigned long __phys_to_virt(phys_addr_t addr)
 void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
 {
 	pgd_t *pgd;
+	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
 
@@ -215,7 +219,9 @@ void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
 
 	pgd = pgd_offset(pgtable, vaddr);
 	assert(pgd_valid(*pgd));
-	pmd = pmd_offset(pgd, vaddr);
+	pud = pud_offset(pgd, vaddr);
+	assert(pud_valid(*pud));
+	pmd = pmd_offset(pud, vaddr);
 	assert(pmd_valid(*pmd));
 
 	if (pmd_huge(*pmd)) {
diff --git a/arm/cstart64.S b/arm/cstart64.S
index ffdd49f..530ffb6 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -157,6 +157,16 @@ halt:
  */
 #define MAIR(attr, mt) ((attr) << ((mt) * 8))
 
+#if PAGE_SHIFT == 16
+#define TCR_TG_FLAGS	TCR_TG0_64K | TCR_TG1_64K
+#elif PAGE_SHIFT == 14
+#define TCR_TG_FLAGS	TCR_TG0_16K | TCR_TG1_16K
+#elif PAGE_SHIFT == 12
+#define TCR_TG_FLAGS	TCR_TG0_4K | TCR_TG1_4K
+#else
+#error Unsupported PAGE_SHIFT
+#endif
+
 .globl asm_mmu_enable
 asm_mmu_enable:
 	tlbi	vmalle1			// invalidate I + D TLBs
@@ -164,7 +174,7 @@ asm_mmu_enable:
 
 	/* TCR */
 	ldr	x1, =TCR_TxSZ(VA_BITS) |		\
-		     TCR_TG0_64K | TCR_TG1_64K |	\
+		     TCR_TG_FLAGS  |			\
 		     TCR_IRGN_WBWA | TCR_ORGN_WBWA |	\
 		     TCR_SHARED
 	mrs	x2, id_aa64mmfr0_el1
-- 
2.17.1

