Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E33F4D0ECE
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 05:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245619AbiCHEl7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 23:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245660AbiCHEls (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 23:41:48 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2041.outbound.protection.outlook.com [40.107.220.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2B93BA59;
        Mon,  7 Mar 2022 20:40:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pl0U1PjURwddK3g4rwN+EZ+BGyTL9R48/WTZeeuDuWVjQH7lMcBk6ZeuGxp9t7/n7em7ygofeNoMd8nKKKzyRLn+5GijXqBV26oBgRdT59ZPgFm9aIxzSvSavhfV+O/DxYPotv2h9i/8KKUWGX2uesK2b94u2CQtUCZ1WmRqaCOKLmf8jdwkWW2+zlYtA7mr6PXvHCUle5aQ+RotJ744ryH6JlIyQSfXlvLLOqAy2I3Tdsq4qVZ6nt5SJk1sYS8olkAxwazbeO/lx6wANrXSjMBBfhfz1JThoOkR9oRlzDmx0JqUL/DS44Rh/TFapS7oga1VbpIFUnY+hDNaWIPlMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eqhbSOAP91+41B7UDti6ZhBGWVEsYfQPQAiPzO0wzXQ=;
 b=Wua3dptqYdfH9aUxTDN9GkTgaod5Xq8Qxd065ciiFqUqOAGq6b1VYRBdnw8iKHUpOY+Durz1WaYiiYzWklihjxCfYdNfBFsw/pbgob3aQAhIzb1J8yNIc9tAaWQ9j6FHC3w7uROr0C7zCMXE1BUJQZ6ICUM87RTiZg3wBVYQhLLVm6azCs1P3DMq86OM/B1AwZHZS60wzQdIXOvuKlEHzR1qp6sA6YuXXagGbcxg2fr0yb2Tq3PHJx+/d4k2wqNtm4tyrgWGP71Wr1fdZyNJ3Y/T9OfVc1D9kyQCjGuQQIBgq51abkTMKrejqA1JrTNJ5Nlk4Yl9fGQkvTV1jWomrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eqhbSOAP91+41B7UDti6ZhBGWVEsYfQPQAiPzO0wzXQ=;
 b=ol9/rSZSgpzi1frpik3Cc2O5Wg2t0JWaZXmgY+pkwNUssT2iSDf02iMvO6gDu6beE2MNvGfKwHMblrUZcp6k9l++BV7dzPkRgNoj+JhRbB85g6yPAF2yZPvkCAiNCuLdG61JkyD3HphNTkEs3uSK8ky6/h+9gO1xioAu8XcocU4=
Received: from DM5PR20CA0033.namprd20.prod.outlook.com (2603:10b6:3:13d::19)
 by PH7PR12MB5949.namprd12.prod.outlook.com (2603:10b6:510:1d8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Tue, 8 Mar
 2022 04:40:40 +0000
Received: from DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:13d:cafe::ad) by DM5PR20CA0033.outlook.office365.com
 (2603:10b6:3:13d::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.13 via Frontend
 Transport; Tue, 8 Mar 2022 04:40:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT020.mail.protection.outlook.com (10.13.172.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5038.14 via Frontend Transport; Tue, 8 Mar 2022 04:40:38 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Mon, 7 Mar
 2022 22:40:32 -0600
From:   Nikunj A Dadhania <nikunj@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>,
        Bharata B Rao <bharata@amd.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Mingwei Zhang <mizhang@google.com>,
        "David Hildenbrand" <david@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Nikunj A Dadhania <nikunj@amd.com>
Subject: [PATCH RFC v1 7/9] KVM: SEV: Carve out routine for allocation of pages
Date:   Tue, 8 Mar 2022 10:08:55 +0530
Message-ID: <20220308043857.13652-8-nikunj@amd.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220308043857.13652-1-nikunj@amd.com>
References: <20220308043857.13652-1-nikunj@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9584ea4d-e4a0-4e4a-dd48-08da00bdcb68
X-MS-TrafficTypeDiagnostic: PH7PR12MB5949:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB594997308EE80E91C3F9CEE1E2099@PH7PR12MB5949.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rw6rpe7fVhbdlIeEVJqUtjzW9I/zZV0hQ1RZKXlk38pIoIWrqNJNLsnlMkwWWChb9Ew6JWPkW4OA7cDZkVGSogCXBu1TgGQvPPv0mcXJRKexfESdZiFXsH/oYHEUJhqn8zDgV/4PF5C9YOfBPZHfn80J/pTzlzOwTBMJAMQ9EvISUgUqJK045qkdyuP5KjY+Sk3Pk48JSRRMtHa9Y1K7vsNv6YRt1DNTDEYOGefKpafTCR8oJ0xBv4MjWQv+xVaVst26O41b2iBRx41lVETOAZu/rXaIFv9JEnaITaF7uncY5SGE/ri8s/9nuRSNhxnrDK83gsT+d+FsX33floAjjREDTnmkfdOBA+YHc42Do30vqURj4Q4SMSERhmSlGw3BnVYV4YgwRLxW60BRp2BButG3Dv9Y+OJddkbr8fR0AMyUIz7Bqpd0XHQ8pzrxL5X3sTiorGIooquSA1x4ejp2IgaJlNNclJ639XKJkg2G7A2NwkYa7abcr9i++RkVgT5sE9uaC1guy+1mFH0TJ9+fiPHhTnVcuwr2LFdiB+ctH8wv8z2EsJWkelEeUBGGWDOWofffJzhxO4khkN48I3tdpUw6l7/T24FpVHpLHrVRXDd80wsXUNfEBOTiPbWg/qvN05mp+cyMhVXpmraIgSyNbgoP5TIqo5F4UE/+OsYtKg5RatyVd1J9fPvMlb1AkgxEOn8EuFLcJ5wsiUm0Qr+18A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(81166007)(70206006)(336012)(316002)(426003)(82310400004)(4326008)(2616005)(1076003)(8676002)(70586007)(6666004)(7696005)(16526019)(508600001)(356005)(36860700001)(54906003)(6916009)(186003)(40460700003)(36756003)(47076005)(83380400001)(26005)(2906002)(5660300002)(7416002)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 04:40:38.6875
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9584ea4d-e4a0-4e4a-dd48-08da00bdcb68
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5949
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Create a separate routine sev_alloc_pages() for allocating sev pages.
This will be used in the following MMU based pinning.

While at it, validate the number of pages before the RLIMIT check and
use kzalloc instead of kmalloc.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kvm/svm/sev.c | 44 ++++++++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d0514975555d..7e39320fc65d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -397,43 +397,53 @@ static unsigned long get_npages(unsigned long uaddr, unsigned long ulen)
 	return last - first + 1;
 }
 
-static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
-				    unsigned long ulen, unsigned long *n,
-				    int write)
+static void *sev_alloc_pages(struct kvm_sev_info *sev, unsigned long uaddr,
+			     unsigned long ulen, unsigned long *n)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-	struct pinned_region *region;
 	unsigned long npages, size;
-	int npinned;
 	struct page **pages;
-	int ret;
-
-	lockdep_assert_held(&kvm->lock);
 
 	if (ulen == 0 || uaddr + ulen < uaddr)
 		return ERR_PTR(-EINVAL);
 
 	npages = get_npages(uaddr, ulen);
+	if (WARN_ON_ONCE(npages > INT_MAX))
+		return ERR_PTR(-EINVAL);
 
 	if (rlimit_memlock_exceeds(sev->pages_to_lock, npages)) {
 		pr_err("SEV: %lu locked pages exceed the lock limit of %lu.\n",
-			sev->pages_to_lock + npages,
-			(rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT));
+		       sev->pages_to_lock + npages,
+		       (rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT));
 		return ERR_PTR(-ENOMEM);
 	}
 
-	if (WARN_ON_ONCE(npages > INT_MAX))
-		return ERR_PTR(-EINVAL);
-
 	/* Avoid using vmalloc for smaller buffers. */
 	size = npages * sizeof(struct page *);
 	if (size > PAGE_SIZE)
 		pages = __vmalloc(size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	else
-		pages = kmalloc(size, GFP_KERNEL_ACCOUNT);
+		pages = kzalloc(size, GFP_KERNEL_ACCOUNT);
 
-	if (!pages)
-		return ERR_PTR(-ENOMEM);
+	*n = pages ? npages : 0;
+	return pages;
+}
+
+static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
+				    unsigned long ulen, unsigned long *n,
+				    int write)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct pinned_region *region;
+	unsigned long npages;
+	struct page **pages;
+	int npinned;
+	int ret;
+
+	lockdep_assert_held(&kvm->lock);
+
+	pages = sev_alloc_pages(sev, uaddr, ulen, &npages);
+	if (IS_ERR(pages))
+		return pages;
 
 	/* Pin the user virtual address. */
 	npinned = pin_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 0, pages);
-- 
2.32.0

