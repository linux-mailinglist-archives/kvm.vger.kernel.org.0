Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A74483F22
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 10:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiADJ2e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 04:28:34 -0500
Received: from mail-dm3nam07on2051.outbound.protection.outlook.com ([40.107.95.51]:46126
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229684AbiADJ2e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 04:28:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U/anuSCDTA4q83UpZnoW1tFYA8U1TEzr6Ur1le31A4u+uVkbr1AZIO+f8SpXU/uvTcy4TngRKvBksYrjk96GwLgf48dOHSHI4nCMqc8LLY+ilq9+pBSqcYXtOJBOI8hI4DfBBYXgoe7y8S/z9zxkdWvpfaN6LsdIhfwhv+7UcaS27FB+yo054w55BJliVDNFoIZ4Fu4DhALlnAjaQDSjX/3IQwR2sogiQ8ikxav1Srab5DSiYr/gQZjmwMDBXjPY4w6UCeFxtz+nLCj9QYSL2npDZ/puXIH99DvFi52W7YXPmd6hRnzlpBtTwZAfJP99ugiVkkQyPi2gG5UwrkplQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rWw0GjXqh6V5gh/kxU8vG4qrRVXTfzvxKEtZq1po51A=;
 b=gisd5y7I7DUcsvX8/YJJAMVq/G5t0RU/dXJl10OyOZY3/ZjlYAOhAF14IqAwCAMDSgnjGBm7VGQ0C70xubE3qFAuSKHkD6aZMIw7IWbIAtYyjTlyanF363FJBYFySJv9b+dkOjRPVBjnICA1Ph41niIuoo1PgeM5oJOT31COCOXT3oOvkntPKPBhMUxzOlJ4tAOYCZuUrXKDR64fNkpJ1KBUqOSA2JnBeXnkIJDi7CcSR/wO1FHy1gVmKSv2mZi2GMdqnzlM/yjpwbfAUQoPh+z9WpG24MrNf4dsnLeWAbi9N7m0oXbUQri/yVoGhrcDeddcZZdwBqZEjJl1zsLMOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rWw0GjXqh6V5gh/kxU8vG4qrRVXTfzvxKEtZq1po51A=;
 b=UB39tYGlEoBeF5LyqwstTSn8o+sKvorAxR/bgD3OflaB/ME4FSY98EH/d75bcMmgtGfyNA3QCUiYTBmwbGEMaCfXPBOa+vAP89RzW/RCIzjoQWlw7BbNqgukVZxzJvKajWHmwc19a53iLwZbJU4j82TTm7Eoz5h/d1ItzOEw8VU=
Received: from DM5PR1101CA0015.namprd11.prod.outlook.com (2603:10b6:4:4c::25)
 by BY5PR12MB3956.namprd12.prod.outlook.com (2603:10b6:a03:1ab::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Tue, 4 Jan
 2022 09:28:30 +0000
Received: from DM6NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4c:cafe::e6) by DM5PR1101CA0015.outlook.office365.com
 (2603:10b6:4:4c::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14 via Frontend
 Transport; Tue, 4 Jan 2022 09:28:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT032.mail.protection.outlook.com (10.13.173.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4844.14 via Frontend Transport; Tue, 4 Jan 2022 09:28:30 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Tue, 4 Jan
 2022 03:28:27 -0600
From:   Nikunj A Dadhania <nikunj@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nikunj@amd.com>,
        <vasant.hegde@amd.com>, <brijesh.singh@amd.com>
Subject: [PATCH] KVM: x86: Do not create mmu_rmaps_stat for TDP MMU
Date:   Tue, 4 Jan 2022 14:58:14 +0530
Message-ID: <20220104092814.11553-1-nikunj@amd.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74875b74-1c84-4788-832b-08d9cf649240
X-MS-TrafficTypeDiagnostic: BY5PR12MB3956:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB3956B39E57E20400097AD9F5E24A9@BY5PR12MB3956.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:669;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 58BXgeaH2TKmvxmJKwT0maavoGefcS8KY0YGF4N6agamTKMORTgZoTDRst1/n7IAAGv5z9mAvJcIuOwXpQSCJoAw2Tjp+TAgQJQzmM9+ozRiHiF2AJItvgPAx3imu40XuOgce/M9dAkid2EGz+x1l4zs2dxLcmvcqOtBwDfBM8//8Y6lEZzYCDIi6qqW4EDLFjpfUeCIJtrI/YlabdUs0PDSoQQqwZ/c9rgzsGSv0abxHApHqkFiqdXGR55BHQZegzqmGRs2WnysktUQIsgAIERrRsS/o3dvr3YoGR7fj7AXlcmWeAmOVbRNSGCdRbv2lsyotqEwEpQYWpZtHIhwTgHLdFyfoYyqixdeSyBn0amqCNx5plX6Ej64ZRnhlaPdSYKtzWSfat9UpOmPxlvPf5Y4aB44a1yUjRdiQDHmKZyApgKkNARF4m5IrhsuMQu+rJlEdMbbnEnAH76cOhKzZ3jPI6Czv0JN3v2SnUrlWj/pa/GkRspr1WTDw3Ss00WsDbcjaY8CGCBoT6UsiI94ESAf6bk5yv9Lbr8bSg9ghThU7oaMcdEb3329vJZJxWbc+RWeqf/aZ8GNRyvcOA3cIlhj8+KfGojkjkKcqVNEtZSwcUgMWchESPo+Ft7YvFcFYlfYj4S3WImdGT5KeZucTT2sD0JGTHvdzM0Vyewd+D2UnC1YZv8nLjavjjspK3cQSkC9Wr4RK8Yp00AAYaJ6haaxwAEXy75pY0anDFzIFCneUouY/i/a7knjbc7iHMcSWIQrSQ7I6KEdVhBsfvXqyjAYelwRa2ciRmK2uV7ke5U=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700002)(6666004)(426003)(508600001)(83380400001)(316002)(8936002)(70206006)(7696005)(186003)(356005)(16526019)(5660300002)(26005)(336012)(40460700001)(8676002)(82310400004)(81166007)(6916009)(54906003)(2616005)(36756003)(1076003)(2906002)(36860700001)(70586007)(47076005)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 09:28:30.6235
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74875b74-1c84-4788-832b-08d9cf649240
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3956
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

Create mmu_rmaps_stat debugfs file only when rmaps are created.

Reported-by: Vasant Hegde <vasant.hegde@amd.com>
Tested-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kvm/debugfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index 543a8c04025c..78bb09a3a7b7 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -180,7 +180,8 @@ static const struct file_operations mmu_rmaps_stat_fops = {
 
 int kvm_arch_create_vm_debugfs(struct kvm *kvm)
 {
-	debugfs_create_file("mmu_rmaps_stat", 0644, kvm->debugfs_dentry, kvm,
-			    &mmu_rmaps_stat_fops);
+	if (kvm_memslots_have_rmaps(kvm))
+		debugfs_create_file("mmu_rmaps_stat", 0644, kvm->debugfs_dentry, kvm,
+				    &mmu_rmaps_stat_fops);
 	return 0;
 }
-- 
2.32.0

