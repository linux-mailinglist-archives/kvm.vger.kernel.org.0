Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815464FE063
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 14:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352154AbiDLMk1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 08:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354963AbiDLMiq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 08:38:46 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2040.outbound.protection.outlook.com [40.107.237.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05111706A;
        Tue, 12 Apr 2022 04:59:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OSCWyvIdYXsKnNzzh/tcTC/JNF4kl5nre4/6zQRwPQLvV5c7pDcKfkVep42ZQiwzDgkaEmAfjaqX/SPcPo+GwOVuF+qTMdBg03vEXgZzxP5Sa5Lj9uQhtD7pL+xnRJi9d06O+qLCc4ONIfkALDZeyg0tu86yT2Q6c3YyOGw8upv62vg4CIlau1dbwBKn/D9/DbGt25pWvtNZN8ihfTGEIkZ66JJ5/8LpbXrZFT4ueB9qrw8EGWuN5xMjc7T/XO2LwIR5dOi4VAXb7V3W0d56EZLzdGNLbNUikyrITwC3LvOTjJuwMq7JqlO0um6zBgoKPd37MC3OijMoL2f07LuKbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MUPTPG38z+bliblYCLX9pdEdXUqPiwyTQjUPaVImobQ=;
 b=Tao80sg8GA1LGy+N9we+huJ7CE9slJ2cG8aWmUcJVAOHsZ1rKnx5ZTFd7Hk5kow0pnShaklvwCdE5p45VOwQFiHcJCHfdx238+GRvpt7VDOgbE/VM1QHdo56RauSICzM3H6ddeoj1HCrRc5XhIRLtv/XGjGbUykM13PgXAOFx3SINKuTIdGmctw4vxX8k4cbFcpN0pCyP4HX5LrRODHOXZZVa4P2kitpEri9HQ8JQ5QsI7uRY8uANIzrSyuK4xUtweKC0EVctDhf1qaY6JZWRie4Fg86J6XlvWLxzJoYmtWj/QZfzNm5MyUOcB+iJYjFNlENtB7q3VSKDwoGg9PDBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MUPTPG38z+bliblYCLX9pdEdXUqPiwyTQjUPaVImobQ=;
 b=16CzQ9E7EYkL88+sfMr6FVIrxfQdR521Y65EdomEWBKf5ijL98hPYcoJbZUgCwErw/BP1L3BvLgxUgnndQgC+E8HksaKCKrMM1zV90yzkOWsgK8CkO8kRa0+9BFQWnTo/F3oWeGmGHM4yzan8V4iGTwWq9CRyIWZDUPDNJ25w/U=
Received: from BN9PR03CA0685.namprd03.prod.outlook.com (2603:10b6:408:10e::30)
 by SA0PR12MB4446.namprd12.prod.outlook.com (2603:10b6:806:71::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 11:59:08 +0000
Received: from BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10e:cafe::cd) by BN9PR03CA0685.outlook.office365.com
 (2603:10b6:408:10e::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29 via Frontend
 Transport; Tue, 12 Apr 2022 11:59:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT032.mail.protection.outlook.com (10.13.177.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5144.20 via Frontend Transport; Tue, 12 Apr 2022 11:59:07 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 12 Apr
 2022 06:59:06 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v2 00/12] Introducing AMD x2APIC Virtualization (x2AVIC) support
Date:   Tue, 12 Apr 2022 06:58:10 -0500
Message-ID: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2168c21-0528-4cc9-44eb-08da1c7bd93b
X-MS-TrafficTypeDiagnostic: SA0PR12MB4446:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB4446591A48B43804D4009147F3ED9@SA0PR12MB4446.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IGi9jm8ySrxLeiinctXpKDcP6kWHTs8YHkg6c0yoZVXdLrvwXmEItv+aR4LeJ21HGY6ezJy850viYniF3ZTx3M4NlfrCxOWpxccXpCsNFnVeyc732gPmOrRez786SWZITGaRqGGr09NG2wTOiDFpuikiRwza6K4RQVk32bWdiawoSTHtZbn9gxCpD1nsGUqy1M7hej5sUE4NIhxutZBSkfKOfWYXgbFYOeiHYcT1s4QOuM66oUOKcSHZ3fDQL1mGYRPLLcp0DE1xA8ZF+djQ5mheNS+FavjIVSqXe4AYQKAtSG0Yrs/qarWYdx29rWSIV2FUUASv/UmSDPHDP7z7GylyFh0fieZgcNlT8HrDICT6d34/HMuD+c8prBVW1bttKuvhe9R8UTjWNYPfPvuimUWeIVOWoySuWBpemh5MAR6ESAVRWuOFcdFTlyqXQ+UI2QVm5VLXGVF31wpgp4ROPsD7pChDtucfFtSKjhA9B+sWIRRp3GgGi9d3vj0sH/t2ybfpxtqvK4TDvHVMW1GQR9590SLZmvz0Fj3UMvyVhvXTUVxP1tmWAe9yULthferxo7pA9xLcoXaCy9+YItSbtTlXlkKHz6/XybND6lJS84hj8/OkRv/ihbRtvfAHKX6l75qWgjD25I2Pj1V+oneRVuc7yCIx72BmZPi1FMu5MBvSJy5sW0mYKrKfZnCW9osG/zbmdM8eNexv2zU9eUI4Q8UrJZLSd+Irzta1QaBYzcJZp8V9/MpZIkFuwNnDHfDBii8DoUtw7vKISyjCHeIn0vFUVLzzN64sBdp8K/pMZ5c=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(36860700001)(44832011)(81166007)(2906002)(86362001)(356005)(110136005)(5660300002)(2616005)(336012)(1076003)(508600001)(426003)(16526019)(186003)(40460700003)(26005)(7696005)(6666004)(8676002)(4326008)(70206006)(70586007)(8936002)(47076005)(83380400001)(316002)(36756003)(82310400005)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 11:59:07.6816
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b2168c21-0528-4cc9-44eb-08da1c7bd93b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4446
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

Changes from v1
(https://lore.kernel.org/lkml/20220405230855.15376-1-suravee.suthikulpanit@amd.com/T/)
  * Rebase to v5.18
  * Patch 7/12: remove logic to check for x2AVIC feature.

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
 arch/x86/kvm/svm/avic.c            | 152 ++++++++++++++++++++++++++---
 arch/x86/kvm/svm/svm.c             |  55 ++++++-----
 arch/x86/kvm/svm/svm.h             |   7 +-
 arch/x86/kvm/x86.c                 |  13 +--
 11 files changed, 204 insertions(+), 52 deletions(-)

-- 
2.25.1

