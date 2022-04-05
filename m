Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A787F4F54F9
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 07:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378936AbiDFFXZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 01:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449057AbiDFBQZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 21:16:25 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2047.outbound.protection.outlook.com [40.107.101.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E1D4CD43;
        Tue,  5 Apr 2022 16:09:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SvQIiQMkeW3HfEkr5LcrqcBTlQ0ZZ0ixnUm0TDjo4m3dHZ9yJSV3m2aaEZMjaB8H+FLSptJzUefzYyvP48Qb1KePpmcKCXwH1R9/reJEDHrlVuuRyAhsXo9ZizNUtEg4oyyUmdDVc5W0DKpuHLfxf0mCfLlAwYwWJTDBvj8EKgaoIIpjIajtnSGkdT1tuXlwnFJLNOU5xKyH/bRwTRFkE5mhD5IubSOyD+sIDVZXbi78giHsGpm5UrLnnhzHqb2kORNtF8Oe0gzdwZCVGW4VyRywUhBuIH+ZH3rKeXelxHonk3EMlTk/dxLaC7bQXzQdJNnaT7whii0CR8BKo3YCcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SuRMXmbyLXKaP7ohyz8cLcPKFddGQ6x65bALJVKYpY4=;
 b=kNskKoWRB7jrZpDTAVH458hTNMPHsvws/d7f9ePCPHulNZ1QBqHKUksPFnjC03gOu3JIPBEpASatQcH0+BJrNCzwHGjCoP+vPwev8H6i4omFmbVBE/cRqErbsmicRB9BXX32mlkqwqBqkm1b/vzW+CA7Qgd9aLHyXKCLWp+TzbCoM1Z09ievaV6yOJppEOJdJ6SnCtU+UAQMxYMCnIlK9nHT6vhxwIfG2+QMBnBZnCjXTFoLcdEEXdAalasvIy7+VQgQ90FbiM4jhtZpINz7BadW1eP1PIlGId5+SlnqAIMzndb6HlZ9Na+Wtxonq4Ph6idO0qR0/1eVH17x3i2SHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SuRMXmbyLXKaP7ohyz8cLcPKFddGQ6x65bALJVKYpY4=;
 b=tIC947NUNdbZC6hK7W+MVaqp14YNWNB5fnMDrxXu+AxLon6eLcIMABStNpqAO9G/UkKKUXZcPjzWuPiga9dhwJh0sdcWd3J29px4uUtPCTfuO6sSxoQEvKTD5EtuhilXsxsgn5ZaQ197zTrg1z/b+ZoCXPyionJ0A7vamGGYFQg=
Received: from MW4PR04CA0084.namprd04.prod.outlook.com (2603:10b6:303:6b::29)
 by BL1PR12MB5095.namprd12.prod.outlook.com (2603:10b6:208:31b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 23:09:19 +0000
Received: from CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::c5) by MW4PR04CA0084.outlook.office365.com
 (2603:10b6:303:6b::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31 via Frontend
 Transport; Tue, 5 Apr 2022 23:09:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT008.mail.protection.outlook.com (10.13.175.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5144.20 via Frontend Transport; Tue, 5 Apr 2022 23:09:19 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 5 Apr
 2022 18:09:17 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <joro@8bytes.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <peterz@infradead.org>, <hpa@zytor.com>,
        <jon.grimm@amd.com>, <wei.huang2@amd.com>, <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 00/12] Introducing AMD x2APIC Virtualization (x2AVIC) support.
Date:   Tue, 5 Apr 2022 18:08:43 -0500
Message-ID: <20220405230855.15376-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e870e14-3610-4db2-ca05-08da1759504f
X-MS-TrafficTypeDiagnostic: BL1PR12MB5095:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5095F46A5335DD8822383A40F3E49@BL1PR12MB5095.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PmnZkneZjqqqqVzi6HGMW+rrGvhBd+t4EbhT+93Gu0n9+ZRLCFIJNfy0NF832SEH3x5+iHkR5fyp0i2xc02WNnIwbZbOOLzksnypWs8uJhviKfgvyuMqonkPf5C+mKxX+BYRhQ+hBVfk388fVEznocJgSh/2+cxNhw/s6Q6qWxW/yTCLJo/Io+Bvi3meC8/jbdSdt4w/8WLVREz9uCDHVbDpIF0sG1Pa1IKqRAeNlSqn82lsscE5M25YYPnLTJAPk0uEk+uQDG8bq1BKisM/eVzT2GREsumFWV3i0coWVBU4SZNU1GnDAiRojRFq52iBCxeU2nnFnYm7Frkaqc+tLROWNwe6PfYoowl95FCzvsFKZXCi/cO7FIC7lSGle1gmLq6LgilfAsKlLn0OHAW6j9Q2SBkgXHhC54ubyULLMmn7bQcHxJtt9ZaiJaYiS+NXAGy3hcv4c0JzUBrjhgXVrf8fjF3Pq1g1np5OLos25asET5NvqNoNI8ziVcvaqJQs04SARYEeQPRokCMEmgEFv6rvME44Ng91AxBxqlbmD8o1/7YpD3EVLE92KZiCrQxQT2JivrMKEieiH2Hw+2Zvcm8A7jQWI9FJrA5csVyoaRjtdRk6SUZ2dFnOWL1hjD1/0i9pqL+eG8oyLWAFLLhV6aKq8+WU6pPcsmqOUdWgYIw2FGOLd23rJF8O/SZxttkqzWvoMo6HOu7WVC2I5EonieCL/TlbqMmbGK/982s4rNA0UWesonft40BvzaeElZ83bBokQMIbwJkpK1Z53b/EB36nRZWjMUgtmyjmm82sVPY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(36756003)(356005)(36860700001)(8676002)(70586007)(70206006)(47076005)(82310400005)(8936002)(83380400001)(7416002)(5660300002)(44832011)(81166007)(4326008)(86362001)(26005)(6666004)(316002)(2616005)(186003)(16526019)(336012)(110136005)(426003)(54906003)(1076003)(508600001)(2906002)(40460700003)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 23:09:19.0937
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e870e14-3610-4db2-ca05-08da1759504f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5095
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Previously, with AVIC, guest needs to disable x2APIC capability and
can only run in APIC mode to activate hardware-accelerated interrupt
virtualization.  With x2AVIC, guest can run in x2APIC mode.
This feature is indicated by the CPUID Fn8000_000A EDX[14],
and it can be activated by setting bit 31 (enable AVIC) and
bit 30 (x2APIC mode) of VMCB offset 60h.

The mode of interrupt virtualization can dynamically change during runtime.
For example, when AVIC is enabled, the hypervisor currently keeps track of
the AVIC activation and set the VMCB bit 31 accordingly. With x2AVIC,
the guest OS can also switch between APIC and x2APIC modes during runtime.
The kvm_amd driver needs to also keep track and set the VMCB
bit 30 accordingly. 

Besides, for x2AVIC, kvm_amd driver needs to disable interception for the
x2APIC MSR range to allow AVIC hardware to virtualize register accesses.

Testing:
  * This series has been tested booting a Linux VM with x2APIC physical
    and logical modes upto 512 vCPUs.

Regards,
Suravee

Change from RFCv2 (https://lore.kernel.org/all/5876774a-c188-2026-1328-a4292022832b@amd.com/t/)
  * Rebase to v5.17
  * Clean up based on review comments from Maxim (Thank!!)
  * Patch 6/12: Remove the kvm_get_apic_id() introduced in RFCv2, and
    simply do not support updating physical and logical ID when in x2APIC mode.
  * Patch 7/12: Extend the svm_direct_access_msrs to include x2APIC MSR range
    instead of declaring a new data structure. 
  * Patch 8/12: Remove force svm_refresh_apicv_exec_ctrl(), and do not
    update avic_vapic_bar.
  * Patch 12/12: New to this series.

Suravee Suthikulpanit (12):
  x86/cpufeatures: Introduce x2AVIC CPUID bit
  KVM: x86: lapic: Rename [GET/SET]_APIC_DEST_FIELD to
    [GET/SET]_XAPIC_DEST_FIELD
  KVM: SVM: Detect X2APIC virtualization (x2AVIC) support
  KVM: SVM: Update max number of vCPUs supported for x2AVIC mode
  KVM: SVM: Update avic_kick_target_vcpus to support 32-bit APIC ID
  KVM: SVM: Do not support updating APIC ID when in x2APIC mode
  KVM: SVM: Adding support for configuring x2APIC MSRs interception
  KVM: SVM: Update AVIC settings when changing APIC mode
  KVM: SVM: Introduce helper functions to (de)activate AVIC and x2AVIC
  KVM: SVM: Do not throw warning when calling avic_vcpu_load on a
    running vcpu
  KVM: SVM: Do not inhibit APICv when x2APIC is present
  kvm/x86: Remove APICV activate mode inconsistency check

 arch/x86/hyperv/hv_apic.c          |   2 +-
 arch/x86/include/asm/apicdef.h     |   4 +-
 arch/x86/include/asm/cpufeatures.h |   1 +
 arch/x86/include/asm/svm.h         |  16 ++-
 arch/x86/kernel/apic/apic.c        |   2 +-
 arch/x86/kernel/apic/ipi.c         |   2 +-
 arch/x86/kvm/lapic.c               |   2 +-
 arch/x86/kvm/svm/avic.c            | 151 ++++++++++++++++++++++++++---
 arch/x86/kvm/svm/svm.c             |  56 ++++++-----
 arch/x86/kvm/svm/svm.h             |   7 +-
 arch/x86/kvm/x86.c                 |  13 +--
 11 files changed, 202 insertions(+), 54 deletions(-)

-- 
2.25.1

