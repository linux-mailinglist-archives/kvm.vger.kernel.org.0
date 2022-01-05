Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCDD484D03
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 05:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237320AbiAEEEB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 23:04:01 -0500
Received: from mail-dm6nam10on2047.outbound.protection.outlook.com ([40.107.93.47]:46199
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230284AbiAEED7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 23:03:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EkhAs2e9RFXP2DMJGHW8hMmDR5dZibn7m7iX1zOnxmT0m0x9iUpS1bAn4U1VvJMrIvibz1xe993QWYibi+V8rxMUSJQ6E5zqDCPE/nHQp2RkFAIvo9ewkigztumGfXsPgCS9okqCg55ij9eJgvYh2ezQORg87EUg8TmmWBH7RAp2hVQglFY6ptmzu/fIik2tbSGxkUA5aOphRZme/xf/J1CiPomc5bRsFC5/JcWcC6r3SoRSO3V8ItL0WzGWriCY2AHOHzIx5EzWiutffn0zshaCTfLuWFDATOYyXCGNkzSiW6oxf8USPxu0kroSTPWg3xl11fLBLvyBVZSKVC7jpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b1WVO+dBH5WcDkBE07astWoCVT8cU9czOuwmBXbmIDc=;
 b=HVihtU3P5v1OuviTvUbBpz+AwvoksRiL6B2KA+P5VtCUTNwQjAguhunqPTrNjmyl0nRSqfyIAFO0eckbQjn+dtIrKHXb8kAy8R8aZBY/vfOX+y+iWIg2WvuE0xTcuKs5Ch8KTl4+nysPcMJuqDZjf1nRr0RQ9T+o508Nf+dzGxHEjpFQ+jlXBfBNyyo0OIh0s+UrHPtD041JD70vHnFIW3P2VveD7DfQz6D5oYwYOfFc0hlr24O+HlNqZLi1IfeRLuxDaEdg5hLaWHkUGbyizW7fWXeridfWBv0pZEoGKzxkzczTdMMgwdpHNT6Fu24JCo0Mou7xFhlC3EAhkffwWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b1WVO+dBH5WcDkBE07astWoCVT8cU9czOuwmBXbmIDc=;
 b=J+603SjY1bWpzDjskZtB6dniALjjtFpwSeUJMKzWLVm+0ixLSEAWKqfbOBGAqzBiTv27grH/DIc7mIT5+asYcbFkvDjqGHjLz2jCqo99n3f2JPYj8AQhILNE+L9V0tCH0T3kWyZ9FeLSo3lbxu//DeWz4aOqyKOEQGgRRJz1T/4=
Received: from MW3PR06CA0030.namprd06.prod.outlook.com (2603:10b6:303:2a::35)
 by BL0PR12MB4932.namprd12.prod.outlook.com (2603:10b6:208:1c2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Wed, 5 Jan
 2022 04:03:57 +0000
Received: from CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::64) by MW3PR06CA0030.outlook.office365.com
 (2603:10b6:303:2a::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7 via Frontend
 Transport; Wed, 5 Jan 2022 04:03:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT046.mail.protection.outlook.com (10.13.174.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4867.7 via Frontend Transport; Wed, 5 Jan 2022 04:03:57 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Tue, 4 Jan
 2022 22:03:53 -0600
From:   Nikunj A Dadhania <nikunj@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nikunj@amd.com>,
        <vasant.hegde@amd.com>, <brijesh.singh@amd.com>
Subject: [PATCH v2] KVM: x86: Check for rmaps allocation
Date:   Wed, 5 Jan 2022 09:33:37 +0530
Message-ID: <20220105040337.4234-1-nikunj@amd.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 451b7b97-5eeb-4f6d-d49b-08d9d00065d4
X-MS-TrafficTypeDiagnostic: BL0PR12MB4932:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB4932D88B469D3B928E1C722EE24B9@BL0PR12MB4932.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R98EcbHIGsjpnSAaHawScQ2GeItuhG8ny00JWkwDx09r8Ua2/z93kvNmi0AmNvQflNJHpt20SVtL88B1vFxEZcXLaWuFMclJrl+BLid+EjeZ3lsXTxnf66/C+drZnFDK0rPo5u6Lfl/yH5dUxdGCkKUKxbZc49eY6nDe6ABMhG7s1ySvnAKD3Z2xaWvmhYUxLhsTDt3lx0KxVPs8SZGqlr2UhEVowgrxl6T7DnIPpcPxWeTpoKa5Xgub1d/Z/MmbOBdocK4vkXhSsD0M4wUYNVev6PLtUM34YC2ztxmKl+TlzNPq0ukFNj0ZW+xMMh0Q77et0NjIo//6+B7xyjWhxpPAsahEjgS2xMnfk/Frl3+Q4c0Jr0zirUmR1tPiXLhD3sG4FqlqvRMv2tvv/kUgwlxm5BREsHBU86Ad/b3CdQsC7TicNcusCAvskJ6rsi/q53ZRDW+QpIZa0brV2paegkuJHupn4up7ZGizeWBRdlLybgLTWU5+aXkKEwnEVMvUgzddzeoauwxRu3dkosR1E2aQ+zYtNNbT79WkWLARyzyt3e7faL0r2TIau3un1tkTLSPQokdZ0HiHBTc1j7W1tS/k6SGwE4yjJb2ApHcz1Nv+rUfbVI3mOzzWADD0RVU8oRjdq8ERrAprtxtOtLHrwTRwRsvd+Ht39J5CK9yMCMGFL9O20Zd79a71uqkWubecRyPqRDzfh9V0QIwcNWycUlpvQlrJ5JKmchBFJaKpfMt9VMU34peP/iQtaUvH+n/QpgH2EyhjF8xT1PbvzZnvXTCeBBUVeiSTR7ieDUuj1ONt0GNvieGP8cqYMKlNucNUhs9huNkH3SvxkHL214mGgfRQkDsuzJsydzyUapxDD9Mw7Js5YBDnDVcdYBibV/aI
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(40470700002)(36840700001)(70586007)(82310400004)(70206006)(40460700001)(26005)(2616005)(16526019)(5660300002)(2906002)(81166007)(8676002)(7696005)(1076003)(426003)(36756003)(8936002)(6666004)(508600001)(36860700001)(316002)(6916009)(83380400001)(336012)(4326008)(54906003)(186003)(356005)(47076005)(966005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 04:03:57.5097
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 451b7b97-5eeb-4f6d-d49b-08d9d00065d4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4932
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With TDP MMU being the default now, access to mmu_rmaps_stat debugfs
file causes following oops:

BUG: kernel NULL pointer dereference, address: 0000000000000000
PGD 0 P4D 0
Oops: 0000 [#1] PREEMPT SMP NOPTI
CPU: 7 PID: 3185 Comm: cat Not tainted 5.16.0-rc4+ #204
RIP: 0010:pte_list_count+0x6/0x40
 Call Trace:
  <TASK>
  ? kvm_mmu_rmaps_stat_show+0x15e/0x320
  seq_read_iter+0x126/0x4b0
  ? aa_file_perm+0x124/0x490
  seq_read+0xf5/0x140
  full_proxy_read+0x5c/0x80
  vfs_read+0x9f/0x1a0
  ksys_read+0x67/0xe0
  __x64_sys_read+0x19/0x20
  do_syscall_64+0x3b/0xc0
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7fca6fc13912

Return early when rmaps are not present.

Reported-by: Vasant Hegde <vasant.hegde@amd.com>
Tested-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---

v1: https://lore.kernel.org/kvm/20220104092814.11553-1-nikunj@amd.com/T/#u

Check the rmaps inside kvm_mmu_rmaps_stat_show() as the rmaps can be
allocated dynamically (Peter Xu)

 arch/x86/kvm/debugfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index 543a8c04025c..9240b3b7f8dd 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -95,6 +95,9 @@ static int kvm_mmu_rmaps_stat_show(struct seq_file *m, void *v)
 	unsigned int *log[KVM_NR_PAGE_SIZES], *cur;
 	int i, j, k, l, ret;
 
+	if (!kvm_memslots_have_rmaps(kvm))
+		return 0;
+
 	ret = -ENOMEM;
 	memset(log, 0, sizeof(log));
 	for (i = 0; i < KVM_NR_PAGE_SIZES; i++) {
-- 
2.32.0

