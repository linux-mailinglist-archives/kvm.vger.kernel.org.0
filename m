Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 629D95EB619
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 02:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbiI0AHz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 20:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiI0AHx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 20:07:53 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2081.outbound.protection.outlook.com [40.107.92.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949689CCD6
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 17:07:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KBhaXstGLwT4kTcBMakwzmpAnr1hc1Ueh+djehzXboovemkz3sqTbCMdGcCpgcBFDycd8+z33il2N8Uw7aK69qkV7LrckwmCiWSlNyyVpSMZUb70x6CqtYBnxGeFvLAVhv6ez8C73lPDIy/diFBiRN37DQSlFlCEDj/nQBoQKY7xcglB/0c9ezgbDX+nhEzhYKk4NcIt3ZyBWge0w1qURAdWaTtO1k/3xvzWZ5Inn874r1zxH4EZXZKoOUx3W3kHIoPlpmSjxGv1Sv/IDpjvcm0EpAAOhGC3Puzlexpj6hd05aEFAfl87ianHAq6Tzd9gPTiTnfr7fu6aBfpqavbKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zc7P9vagI2XEBpUEpeR6xi6T0j7/juD4+kiPqW7++CQ=;
 b=e1qP92LzaRo6MB7VpLcbNCTJ117xF/tzz4QTKmvfSdESiORa5Z/Bpd30DzzLw3SAjnucXTWpVFVnbkK5jkg6tTaYGg/LQfv3HmqJ6ViFgwgWLsc8y7ejUYP8UU851tRD2lRVaDB75ReX1r+fqi8qGvZLnczTG8WAvPg9DSNBPXuuYP7H2XkyXjCJgWLLxBaYq63zut9WmXAcHzxdtQW5Qvawe8AHlhGZZtWTvXkgSpiIa6WsttXqAUVEDN0SsBlkrFC66vRh1HpnngFunDXxNCqBD8HI/TYMO09w+uNb4WtJbDNQmWOf+N/riDdV0HXGl+FDc2JcBGtWTG6lyDatSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=windriver.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zc7P9vagI2XEBpUEpeR6xi6T0j7/juD4+kiPqW7++CQ=;
 b=yaVXVWBLBsqgfGvoGquXrb4M9qPG9aEuMcsSK+KGA0T6Ys0lJhpftwi6yd7urv+X8Y42vLZVA2I66BhlxSjgvnKv7fDfLag0+JzAp2C1W4dfiIG+aRGhEAfod7ApBGPApW+1Ucu1QgcTmwPbGncKtV6bPKvH4KWOqAwHkBXdcjw=
Received: from DM6PR07CA0107.namprd07.prod.outlook.com (2603:10b6:5:330::21)
 by DM6PR12MB4563.namprd12.prod.outlook.com (2603:10b6:5:28e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Tue, 27 Sep
 2022 00:07:49 +0000
Received: from DM6NAM11FT069.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:330:cafe::e1) by DM6PR07CA0107.outlook.office365.com
 (2603:10b6:5:330::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25 via Frontend
 Transport; Tue, 27 Sep 2022 00:07:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT069.mail.protection.outlook.com (10.13.173.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5654.14 via Frontend Transport; Tue, 27 Sep 2022 00:07:44 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 26 Sep 2022 19:07:42 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <ovidiu.panait@windriver.com>
CC:     <kvm@vger.kernel.org>, <liam.merwick@oracle.com>,
        <mizhang@google.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
        <thomas.lendacky@amd.com>, <michael.roth@amd.com>,
        <pgonda@google.com>, <marcorr@google.com>, <alpergun@google.com>,
        <jarkko@kernel.org>, <jroedel@suse.de>, <bp@alien8.de>,
        <rientjes@google.com>
Subject: [PATCH 5.4 1/1] KVM: SEV: add cache flush to solve SEV cache incoherency issues
Date:   Tue, 27 Sep 2022 00:07:29 +0000
Message-ID: <20220927000729.498292-1-Ashish.Kalra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220926145247.3688090-1-ovidiu.panait@windriver.com>
References: <20220926145247.3688090-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT069:EE_|DM6PR12MB4563:EE_
X-MS-Office365-Filtering-Correlation-Id: 41c4f4d6-5372-406f-3ad4-08daa01c4d35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SpmspRP4W25efkAnOKwiOvIRKHflQxhwwklQX81jIZxltGMu2Y0O66XifprpVjs+mKeR0HVx3/55AmcY6a3CLu5ZUg/ktk4pizJJKEYXs02QL8MtXge1zPlx/I7/pAAt074TWbKI0pc5r3FizsZwjLBqjEeNNELHB1BIT6ULrfi2hl5uFwK1iCkty3M5KYw6zR0mU6EyrtJrkuGbjmVJMUx/z2EIQ4FrnPa/SlyZQYN4mwN2+85QEoAum/dbfijd4vN/YK6QOGuei4/4NGzOp0ME1N7FCeS+3Nwudyng4lQWEzUu0z3dgFfOTpEIQY+ZIA1fI+8qd2zyN3jQo8XUvSdlQdAwTHkR9Lc/vYYA4XxCWm/vqZdSFYTBz4SSfejrHWRIxTNcAFxy06i9UdvUANQxDc9T23Yax8ajRJfo3LMsv1aazpNAxHxIwr4qn5MbUwsT6gTS2w0FKbs1Gi/64/4mAlrelkYMHATNQuFRIPH+SjtQlcEEJ+5uNv5yLWJ/jhFkwjivpUPlTbXNRIMB/hcb+MRliJ9LCm3v9FnzoLr9cSCBq9fDxMxFCfykBxIVjvEQPW8JWfaS+DXYd628yAFSCmnD1CRTXFQvlUQZ2jNZKijG6EFX3ZmqqPuS2lwbn1d9w3tlLD+RzUW9n2mzRIeNhCFPGzYBkEJgjmpmD5VoZ1TuoD7dqD51DB5zkx93HdnrHSVQaVxmb4zTUO1WgTtRrL/9bJto5/6Vc8rpBuAL9VTTo2mF744G22BQAxLX5MeYNjQXvRiLkWXqBiMpZ5xyJuHh2fx9JQcYrNHL9NjgKxUImZkCmDy0ETEAkzK1
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(346002)(396003)(451199015)(46966006)(36840700001)(40470700004)(478600001)(6666004)(41300700001)(7696005)(83380400001)(426003)(47076005)(40460700003)(186003)(1076003)(336012)(16526019)(5660300002)(2906002)(2616005)(7416002)(40480700001)(82310400005)(26005)(6916009)(54906003)(8936002)(70586007)(4326008)(8676002)(70206006)(316002)(82740400003)(81166007)(86362001)(356005)(36860700001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 00:07:44.0271
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 41c4f4d6-5372-406f-3ad4-08daa01c4d35
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT069.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4563
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With this patch applied, we are observing soft lockup and RCU stall issues on SNP guests with
128 vCPUs assigned and >=10GB guest memory allocations.

From the call stack dumps, it looks like migrate_pages() gets invoked for hugepages and triggers the
MMU notifiers for invalidate_range_start() and correspondingly kvm_mmu_notifier_invalidate_range_start() 
invokes sev_guest_memory_reclaimed() which internally does wbinvd_on_all_cpus(). This can potentially 
cause long delays especially on large physical CPU count systems (the one we are testing on has 500 CPUs)
and thus delay guest re-entry and cause soft-lockups and RCU stalls on the guest.

Here are the kstack dumps of vCPU thread(s) invoking the invalidate_range_start() MMU notifiers: 

#1: 
[  913.377780] CPU: 79 PID: 6538 Comm: qemu-system-x86 Not tainted 5.19.0-rc5-next-20220706-sev-es-snp+ #380
[  913.377783] Hardware name: AMD Corporation QUARTZ/QUARTZ, BIOS RQZ1002C 09/15/2022
[  913.377785] Call Trace:
[  913.377788]  <TASK>
[  913.304300]  sev_guest_memory_reclaimed.cold+0x18/0x22
[  913.304303]  kvm_arch_guest_memory_reclaimed+0x12/0x20
[  913.304309]  kvm_mmu_notifier_invalidate_range_start+0x2af/0x2e0
[  913.304312]  ? kvm_mmu_notifier_invalidate_range_end+0x101/0x1c0
[  913.304314]  __mmu_notifier_invalidate_range_start+0x83/0x190
[  913.304320]  try_to_migrate_one+0xba9/0xd80
[  913.304326]  rmap_walk_anon+0x166/0x360
[  913.304329]  rmap_walk+0x28/0x40
[  913.304331]  try_to_migrate+0x92/0xd0
[  913.304334]  ? try_to_unmap_one+0xe60/0xe60
[  913.304336]  ? anon_vma_ctor+0x50/0x50
[  913.304339]  ? page_get_anon_vma+0x80/0x80
[  913.304341]  ? invalid_mkclean_vma+0x20/0x20
[  913.304343]  migrate_pages+0x1276/0x1720
[  913.304346]  ? do_pages_stat+0x310/0x310
[  913.304348]  migrate_misplaced_page+0x5d0/0x820
[  913.304351]  do_huge_pmd_numa_page+0x1f7/0x4b0
[  913.304354]  __handle_mm_fault+0x66a/0x1040
[  913.304358]  handle_mm_fault+0xe4/0x2d0
[  913.304361]  __get_user_pages+0x1ea/0x710
[  913.304363]  get_user_pages_unlocked+0xd0/0x340
[  913.304365]  hva_to_pfn+0xf7/0x440
[  913.304367]  __gfn_to_pfn_memslot+0x7f/0xc0
[  913.304369]  kvm_faultin_pfn+0x95/0x280
[  913.304373]  direct_page_fault+0x201/0x800
[  913.304375]  kvm_tdp_page_fault+0x72/0x80
[  913.304377]  kvm_mmu_page_fault+0x136/0x710
[  913.304379]  ? kvm_complete_insn_gp+0x37/0x40
[  913.304382]  ? svm_complete_emulated_msr+0x52/0x60
[  913.304384]  ? kvm_emulate_wrmsr+0x6c/0x160
[  913.304387]  ? sev_handle_vmgexit+0x115a/0x1600
[  913.304390]  npf_interception+0x50/0xd0
[  913.304391]  svm_invoke_exit_handler+0xf5/0x130 
[  913.304394]  svm_handle_exit+0x11c/0x230
[  913.304396]  vcpu_enter_guest+0x832/0x12e0
[  913.304396]  ? kvm_apic_local_deliver+0x6a/0x70
[  913.304401]  ? kvm_inject_apic_timer_irqs+0x2c/0x70
[  913.304403]  kvm_arch_vcpu_ioctl_run+0x105/0x680

#2: 
[  913.378680] CPU: 79 PID: 6538 Comm: qemu-system-x86 Not tainted 5.19.0-rc5-next-20220706-sev-es-snp+ #380
[  913.378683] Hardware name: AMD Corporation QUARTZ/QUARTZ, BIOS RQZ1002C 09/15/2022
[  913.378685] Call Trace:
[  913.378687]  <TASK>
[  913.378699]  sev_guest_memory_reclaimed.cold+0x18/0x22
[  913.378702]  kvm_arch_guest_memory_reclaimed+0x12/0x20
[  913.378707]  kvm_mmu_notifier_invalidate_range_start+0x2af/0x2e0
[  913.378711]  __mmu_notifier_invalidate_range_start+0x83/0x190
[  913.378715]  change_protection+0x11ec/0x1420
[  913.378720]  ? kvm_release_pfn_clean+0x2f/0x40
[  913.378722]  change_prot_numa+0x66/0xb0
[  913.378724]  task_numa_work+0x22c/0x3b0
[  913.378729]  task_work_run+0x72/0xb0
[  913.378732]  xfer_to_guest_mode_handle_work+0xfc/0x100
[  913.378738]  kvm_arch_vcpu_ioctl_run+0x422/0x680

Additionally, it causes other vCPU threads handling #NPF to block as the above code path(s) are holding
mm->mmap_lock, following are the kstack dumps of the blocked vCPU threads:

[  316.969254] task:qemu-system-x86 state:D stack:    0 pid: 6939 ppid:  6908 flags:0x00000000
[  316.969256] Call Trace:
[  316.969257]  <TASK>
[  316.969258]  __schedule+0x350/0x900
[  316.969262]  schedule+0x52/0xb0
[  316.969265]  rwsem_down_read_slowpath+0x271/0x4b0
[  316.969267]  down_read+0x47/0xa0
[  316.969269]  get_user_pages_unlocked+0x6b/0x340
[  316.969273]  hva_to_pfn+0xf7/0x440
[  316.969277]  __gfn_to_pfn_memslot+0x7f/0xc0
[  316.969279]  kvm_faultin_pfn+0x95/0x280
[  316.969283]  ? kvm_apic_send_ipi+0x9c/0x100
[  316.969287]  direct_page_fault+0x201/0x800
[  316.969290]  kvm_tdp_page_fault+0x72/0x80
[  316.969293]  kvm_mmu_page_fault+0x136/0x710
[  316.969296]  ? xas_load+0x35/0x40
[  316.969299]  ? xas_find+0x187/0x1c0
[  316.969301]  ? xa_find_after+0xf1/0x110
[  316.969304]  ? kvm_pmu_trigger_event+0x5e/0x1e0
[  316.969307]  ? sysvec_call_function+0x52/0x90
[  316.969310]  npf_interception+0x50/0xd0

The invocation of migrate_pages() as in the following code path
does not seem right: 
    
    do_huge_pmd_numa_page
      migrate_misplaced_page
        migrate_pages
    
as all the guest memory for SEV/SNP VMs will be pinned/locked, so why is the page migration code path getting invoked at all ?

Thanks,
Ashish
