Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD7F8736ACD
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 13:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbjFTLT0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 07:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232656AbjFTLTY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 07:19:24 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB828173B;
        Tue, 20 Jun 2023 04:19:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YbVeCgEo27qhGnEVxS9BY+D8R24pRcl6fg4X1T93P/pBbZv2wMiZFI3huqe2Qe+JOryn3d4F6565RGTNwXAz+UECo1QAoT0SRyuuAKbxXUOGOfuCv3dBfprBe2HtzApxtLKIcyzsboOeHa8+QBOYqViN4YeNIrzIsoWceFrFYr1YRleeL2m/KA9z+gcWXejZXW3Yc1fZvkhNwponmbfyD5e2pQyjMqhWNNLb1E6lNQVFQUPWgqanOHnwPBFhtcI4vE9tnR4KvOHZfVWultHGiDcl9FOmWi6SO2novTG92ZH/GZoc7gtmkssClxDAIpd0O891G6JYWP4+KKJ9c996+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xLekbJqg8vsPFgYGze+HqRvkFOmwXOtKLZ9MaaG0JOA=;
 b=QZwfK+4XVrTOgBEE8SuBCJUaYb+GJkVcoGDxA4s+IOVB3NydjgMEnqky4Yk1bpPeVxuuuh8gOrfg22RDu63y9Tnr+k8vL+DxeILBmLnDDOJo3WB4hwYgbz0PwDhTMn8T4YTw7OIsxs/+J+u+TgqOWy4oSC5RWQJqijiT9eNq6hBORNdiEbXTWZW/XPcjNujFEVF3lDjxBMUqL5DQ1BRSq1u3JSDoR2E8FkPsv/1kxrJRCEERdsaiGGta6u2VdFDPEg7MSpL0p4j38nv+0XA0Pj2VvFdNLPn1WR16kSnU9XoqwDlMFFTjjVZvAULuROqPeICT/h9gnqHZzNRFO/3Fhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xLekbJqg8vsPFgYGze+HqRvkFOmwXOtKLZ9MaaG0JOA=;
 b=cMpmYuXrxidUaeWImkPN+T0DxNBhN/TGHV4mZazIPXuVMIAO2h/0FmpG7nfzV7Lj4AhD0Va67ARIkVmZCL/gyTsLm2tv2rQuL4Z0n3U9sVsmLznKXvES12DYXtm1K3OsKQ8xJ4IztRiksGq/zsWMRvjs/qfStk7u+MB4yl1G7bFiV5+DtqMTOgsR/pBN0WgEsRCJ/iPDDeTYa/vY8uKd8/poe74s9dLQP1gosFM1xtzGLTy9W/xKBeYCrfx8kXlMfMEchuDPCGUovPlOKmHfoaBdezsIOAWMuMVs3rHjyAXq9P0yFM9gkPlnFVBj5ylducoFQeCauT5/7MnhaVxk2g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by IA1PR12MB9031.namprd12.prod.outlook.com (2603:10b6:208:3f9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 11:19:10 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4854:668:e67e:b61d]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4854:668:e67e:b61d%3]) with mapi id 15.20.6500.036; Tue, 20 Jun 2023
 11:19:04 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc:     Robin Murphy <robin.murphy@arm.com>, will@kernel.org,
        catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        nicolinc@nvidia.com, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>,
        zhi.wang.linux@gmail.com, Sean Christopherson <seanjc@google.com>,
        Alistair Popple <apopple@nvidia.com>
Subject: [RFC PATCH 2/2] arm64: Notify on pte permission upgrades
Date:   Tue, 20 Jun 2023 21:18:26 +1000
Message-Id: <9b5ac4150137c0c91646ff94ee2080b5a98aa50a.1687259597.git-series.apopple@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.063f3dc2100ae7cbe3a6527689589646ea787216.1687259597.git-series.apopple@nvidia.com>
References: <cover.063f3dc2100ae7cbe3a6527689589646ea787216.1687259597.git-series.apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY4P282CA0017.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:a0::27) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|IA1PR12MB9031:EE_
X-MS-Office365-Filtering-Correlation-Id: 80327d3d-1c4d-495c-fd24-08db718027e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u9ua1lrJFTLZCBPaZfDc7KptIpcnxm+RQkxGPZVkjHSWgtjUS13obZ3aWd86uXl1BZiir+GVYpYm0tBqSYngVoMd49qiae09PP/1vOPjVrywhdsHT4DMpTfGfTAJIB1eiWWtdP8mY7wfmGIy278D+XSykkcDBSerwVZO4klPZeQklYVx0B2yAy8hGjjqAifYjTXu2SbOo8YfGUh9Z61/ArnTpPE/BF19Ov1OknNwf+UpSn2hZXCgCU/GeCJ6FUWPJkaJra8KeQI0dh2haSGPu9Lh8r/4EbjQO9qYSHOd7vbu2DVkFArgVD6b52nJyx2ppzvRlbtb0s+RXUlOZGtELeGma2JzTkNJcheY2iirWR7QTTGoXCKhIfRjmTjtDT53tMHLoXUp8yr1hNHeFGuXJsKAlqPnkreqsLqdvTXbscz95+Cc4wYO2UdJBDr2rJQcl22veqlcm/uUUmlFdApQYIz1jdR/8iZ+cA1VYnpTNvpcFl1s3yCUlPYFlvHqo4Bw5PHe/zOjAgLY9y/UMbp+aj+eFTBTkdy18KseOpKNwzk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(39860400002)(396003)(366004)(346002)(451199021)(8676002)(8936002)(66946007)(186003)(66556008)(66476007)(5660300002)(54906003)(4326008)(26005)(6666004)(6486002)(316002)(478600001)(41300700001)(36756003)(6506007)(6512007)(38100700002)(107886003)(7416002)(86362001)(2906002)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4uVgNtCIVFsxiZqNjlazJHsr6p/IcEPuFWo9wBKO48CY4HDW1DZ5HeQ/NduN?=
 =?us-ascii?Q?BAaC/xoEOMDIlVpK8oQKEwIOgC/PUg5JrkgfAyvkSeBnYBnWHiZGS/S3gEGi?=
 =?us-ascii?Q?qzSct6FUOMtw5v3cvdHC7xRlvKz+DlTvnP8tO39gJpN9WejZvxBIFkQn4gAS?=
 =?us-ascii?Q?ePdsCF04bOIuOb9UGzl+nEf857//v1ZC63GyFaj9xU0pSoiynHdc6k2P1Izn?=
 =?us-ascii?Q?rvSn10dwPOIi+eeI+GBcIHrulupTAndELr+rMJMPCmdGPxqZdQJ7+sPmqQNC?=
 =?us-ascii?Q?hXdkZDj3OIO90NeuVbs6ZZXyPdjIA0lQPr3SmBiOSdHme2y1TxUB022aT44z?=
 =?us-ascii?Q?PGHqCXnrZbRrUE5gVr/0nvtc3pWe5TVGcygMIxuiEZxSPXdRI/rPyvqSbSjs?=
 =?us-ascii?Q?f9Q4NVR4jgSweT95aGn2tgxqsvc8s0c3oNdBe5mAA9Ht/isn+BwS9xmsrhZr?=
 =?us-ascii?Q?YNNX9uK8QbvZQ619G6InWbftz52KPtdIOCZDlCRsnXGV1R0BDoAJPKgxTn6Z?=
 =?us-ascii?Q?kLibWJzHj8wQkKjFXz0VVQv0nEcyk7c3YzkrVtvd5kri7ynrt2dSPxi4XTly?=
 =?us-ascii?Q?SgAQVvDacrtA/pR+1SlluRJDh4pmCzhql8aJrGW7fJmK1FVYlxvEZFGGHYSA?=
 =?us-ascii?Q?bOr7OekCAlzaQtIh8/bmd2qLdce80LnxfvLmxdeNlFZzk6nHntzCxdmvRACk?=
 =?us-ascii?Q?deFBlXOiGtv4buFIpVZYUNH6rKPMeUD/u0wWGkuGYvNKlMrd8oRR4D7e83eC?=
 =?us-ascii?Q?0EqrdlxbjPWF6pYiTx5+Zmn6BDcRY3LUxi4/5q3ZIiF77WU9ZgCMRF/naMbV?=
 =?us-ascii?Q?XukSesfpSBgqb6JLNLA6e4RMlGinv8ShwszAIfMtzG88wdnSItXJ0NZJLKRl?=
 =?us-ascii?Q?FiwRjhfUfb5TdauUV/f9i2Do6dyiBoOsuWis/ud0sbPCny8LkU3w3fMz2RLx?=
 =?us-ascii?Q?IRCsVKnrAtzWVFt66PBSIwTYYckuVPH6V0oP7ukqfLmKN8tUmFi86eaeGFXn?=
 =?us-ascii?Q?fwp6y1aB9+XP27em/oR05qyGzp4V1MfAZjCZXIjfod2S65i+Z0mv3KWp4TSU?=
 =?us-ascii?Q?93UIpb9hSSNB3wtOF0qFj43Q+CnI973fY0NT4B+gpE7zQ5a018lRgl1mLNXh?=
 =?us-ascii?Q?3A0wbjQGwikz/WP8H5GdLIxfSpZiWwH/4Ugh5ZF5UVe/R/jjLi8O0i2ttM6z?=
 =?us-ascii?Q?iVRiwfal0cXLpJVNUDXVXpnONL5S5OusYx3Tay1VAJfMKC4r+cXTCN1uTaRy?=
 =?us-ascii?Q?dMY4qyZ3CGQL+dt+CdKxNmD7MXfDxgWbHhcArmLpj0Cu1+OSKxdvPegK42oV?=
 =?us-ascii?Q?Ngd7jwHVa2qy7U8k6r5GT1V6xa/I0pgn0FBxyhS29YPmc4Csh3pUbPv0Of4O?=
 =?us-ascii?Q?l9L47i837l9QrAqYQ80rO0+ovHH64VLdtwGtUs8UElplGNrwUYveRhcK2LiY?=
 =?us-ascii?Q?HiCDBgBuCmyCTkJd9bUTe5ks/dM/lHM/olCM69bI0mu4OSaD+TaAJZrufEog?=
 =?us-ascii?Q?74v0Z/FTid0XZcrUuzPCLMS/bRWG0TeUx6ZlpNshSJVmmLge6LnM9KDYHRCV?=
 =?us-ascii?Q?gS9b9lXKzVBAqLDQz6QlKszhbV7EBRTOAWHaE6mT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80327d3d-1c4d-495c-fd24-08db718027e3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 11:19:04.4010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vKq9PjOINo6Hph8jJQPmCzucd6BvW+TTezX26F34mOk1xFb//EVE+0TcFYHTEhPC4x9cR9RV3WDeYvu+wn5K3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9031
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ARM64 requires TLB invalidates when upgrading pte permission from
read-only to read-write. However mmu_notifiers assume upgrades do not
need notifications and none are sent. This causes problems when a
secondary TLB such as implemented by an ARM SMMU doesn't support
broadcast TLB maintenance (BTM) and caches a read-only PTE.

As no notification is sent and the SMMU does not snoop TLB invalidates
it will continue to return read-only entries to a device even though
the CPU page table contains a writable entry. This leads to a
continually faulting device and no way of handling the fault.

The ARM SMMU driver already registers for mmu notifier events to keep
any secondary TLB synchronised. Therefore sending a notifier on
permission upgrade fixes the problem.

Rather than adding notifier calls to generic architecture independent
code where it may cause performance regressions on architectures that
don't require it add it to the architecture specific
ptep_set_access_flags() where the CPU TLB is invalidated.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 arch/arm64/mm/fault.c       |  7 ++++++-
 arch/arm64/mm/hugetlbpage.c |  9 +++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index c601007..c28f257 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -25,6 +25,7 @@
 #include <linux/perf_event.h>
 #include <linux/preempt.h>
 #include <linux/hugetlb.h>
+#include <linux/mmu_notifier.h>
 
 #include <asm/acpi.h>
 #include <asm/bug.h>
@@ -239,8 +240,12 @@ int ptep_set_access_flags(struct vm_area_struct *vma,
 	} while (pteval != old_pteval);
 
 	/* Invalidate a stale read-only entry */
-	if (dirty)
+	if (dirty) {
 		flush_tlb_page(vma, address);
+		mmu_notifier_invalidate_secondary_tlbs(vma->vm_mm,
+					address & PAGE_MASK,
+					(address & PAGE_MASK) + PAGE_SIZE);
+	}
 	return 1;
 }
 
diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index 21716c9..b689406 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -14,6 +14,7 @@
 #include <linux/pagemap.h>
 #include <linux/err.h>
 #include <linux/sysctl.h>
+#include <linux/mmu_notifier.h>
 #include <asm/mman.h>
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
@@ -480,6 +481,14 @@ int huge_ptep_set_access_flags(struct vm_area_struct *vma,
 
 	orig_pte = get_clear_contig_flush(mm, addr, ptep, pgsize, ncontig);
 
+	/*
+	 * Make sure any cached read-only entries are removed from
+	 * secondary TLBs.
+	 */
+	if (dirty)
+		mmu_notifier_invalidate_secondary_tlbs(mm, addr,
+						addr + (pgsize + ncontig));
+
 	/* Make sure we don't lose the dirty or young state */
 	if (pte_dirty(orig_pte))
 		pte = pte_mkdirty(pte);
-- 
git-series 0.9.1
