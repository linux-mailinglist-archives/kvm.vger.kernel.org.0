Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B41751984E
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 09:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345531AbiEDHfi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 03:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345479AbiEDHfc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 03:35:32 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2045.outbound.protection.outlook.com [40.107.243.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EDFF167CF;
        Wed,  4 May 2022 00:31:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Al5lswkaM1ioc7SAOTQTJFeaubPNSU6xgAF04uBdc+xoNln12eqQZ+MKd7FIpTpW5IUCwv2fvFU0j8e/7kKg6uizhmP6uajWlJdf/UA2atjRRY0yPwOjVpzLoFWr2EPugkNiZ9mkSwywUQuKVPxjmajbtHznzta6w+Ed8RCuY5hR20HoMCNELeHJIqdcYAC2WNvtLmG8KD5Ts0QGYZfZchfMwgjhPp++LGySYa8/THeowiCJYDWNHph4tGMRWcO4tCChRMtCk4F/a8Tt1GJcDG0uJIHcwZJqrXXPi0/AZrvJ92td9hAk6Wy4HN967Op4ZU+ubR1ItV/0YnC3HOzv/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LVw3Kw/l6ZaeJGRkLmevcFKwNXvx8XknQ9mOAv3S6L4=;
 b=Dm7KaucNoX6htSGh/2jIMyNCQEsuC1s72iqMnm1bBeM3r9HSBxMrrKcNtA09M5SmeniUnL1UQZrCW6wTH9fVV+ssAM7ZdHmpsiqp+9k48xRyVU8ATKVcgDJbML4uEYbS4M/Ej9ymi5+WgLB8fpX9vAC5146drueqNj3/Jm24bvLJJi7B6aaAEMM6i6CwvlyLoopoPUkaH9J1QJyu2PrTxXgMY28op7WTxC4mT3Eb90jdcD/T59dvG2ibOtTZSLcAz1QzvgyDpfdj7gtlsk45JEB1rPZ56bGjujolzNlUji0J7hFiFwX0Abp6QdmvRBKhWPdjAagzSKXqbw/3mw5H9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LVw3Kw/l6ZaeJGRkLmevcFKwNXvx8XknQ9mOAv3S6L4=;
 b=d+O36Qn7BRZJpnLYG0wfREOGPntuD4cv3OesAcq7DiKaVE3hOEyXdUUoMvKYd/MnXNKgz6ceDnLkdxCZdXhT+vvh0NqxJhRNdxVtmQLrKYVON1V1leA/8ZB9H1+GsgQX13d7iA8rnfM1YBmV9B1qns+YUiyMhQlbr90fF/HfAbI=
Received: from BN9PR03CA0118.namprd03.prod.outlook.com (2603:10b6:408:fd::33)
 by DM6PR12MB4827.namprd12.prod.outlook.com (2603:10b6:5:1d6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Wed, 4 May
 2022 07:31:49 +0000
Received: from BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fd:cafe::ee) by BN9PR03CA0118.outlook.office365.com
 (2603:10b6:408:fd::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.23 via Frontend
 Transport; Wed, 4 May 2022 07:31:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT022.mail.protection.outlook.com (10.13.176.112) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Wed, 4 May 2022 07:31:48 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 4 May
 2022 02:31:47 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v3 00/14] Introducing AMD x2AVIC and hybrid-AVIC modes
Date:   Wed, 4 May 2022 02:31:14 -0500
Message-ID: <20220504073128.12031-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07fd20b2-6b78-41d4-8659-08da2da0265b
X-MS-TrafficTypeDiagnostic: DM6PR12MB4827:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB482747F32FF1F43AF0223954F3C39@DM6PR12MB4827.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Iy+dyTO7AN1ytoi7AIBOx/+mEbwF2AFGQFP8R6EjZH6Wpt1cJzRNupZkgSK1TQc91Enm7RGZ7ixqxkXhLrdnMBbKuLiwFq4E9o2iHYsk4WzyUlSKQYeWI94PVjMngN/TeMrkjoIz5eba9+1nh896RllMfOvVRlekdfvGK9lF8actpeTr6cKmXds75dH/oy+Wh87UGD2mda4MgFmojBqhpVTQYEL8r+TCgTvi++Oan+E+SIibXyzv4CseejkXqu9lqOOCkhYUQbuiNHeu4LING3CEBR4/PmkIqTDjiYCVKVlCMuns1vI4USmX3ZzM4RFPrTa/y3OIhpI8R0BQsBwfpdcUP16mQDChN2c+2EVL3qXwwiUT+4PA5zayYjRUjUlGIalX7KM9BsIXBJOSedHz83Iq4hGddFbUHjfULr6geallJAdAoz9d6YOgBcpY3C7McI9tPL1MAA3qNAeHzPu+mXwkxjM9/uo+NuSWQvjCNPkqkoB9Tyf18JwrHiXKrNkLcu0697YKwUnOSWW3DbVHxLb63pw8dTPgDe65mbKvQNW7ObqCuFqVmw9J3hqCWMKXNHGWV+KTDqupLJFfqpVX1UixIqKRNZxVTYV/4g+nBuA34TEeU+HA+imbsOw5oyUXMFoGtIQy8Em0ah3R8ZQ7BPKQbolA7vD6FADYCcUim/IBW6B+/na+WrQqSZ5qiZsARUHa3oV5umcMW8eA+kktURS+f+gRgt8csxA5bq1cC2BdUhi3JaPxWjmljzu/zS1G3sVqiAwL/6LWAbZcJbOxGQzS61qAK7LMV7OyDv/rc1g=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(47076005)(426003)(16526019)(336012)(1076003)(186003)(26005)(6666004)(7696005)(2616005)(356005)(81166007)(40460700003)(86362001)(83380400001)(82310400005)(36860700001)(44832011)(110136005)(5660300002)(54906003)(508600001)(316002)(70586007)(8676002)(4326008)(70206006)(8936002)(36756003)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:31:48.7271
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07fd20b2-6b78-41d4-8659-08da2da0265b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4827
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introducing support for AMD x2APIC virtualization. This feature is
indicated by the CPUID Fn8000_000A EDX[14], and it can be activated
by setting bit 31 (enable AVIC) and bit 30 (x2APIC mode) of VMCB
offset 60h.

With x2AVIC support, the guest local APIC can be fully virtualized in
both xAPIC and x2APIC modes, and the mode can be changed during runtime.
For example, when AVIC is enabled, the hypervisor set VMCB bit 31
to activate AVIC for each vCPU. Then, it keeps track of each vCPU's
APIC mode, and updates VMCB bit 30 to enable/disable x2APIC
virtualization mode accordingly.

Besides setting bit VMCB bit 30 and 31, for x2AVIC, kvm_amd driver needs
to disable interception for the x2APIC MSR range to allow AVIC hardware
to virtualize register accesses.

This series also introduce a partial APIC virtualization (hybrid-AVIC)
mode, where APIC register accesses are trapped (i.e. not virtualized
by hardware), but leverage AVIC doorbell for interrupt injection.
This eliminates need to disable x2APIC in the guest on system without
x2AVIC support. (Note: suggested by Maxim)

Regards,
Suravee

Testing for v3:
  * Tested booting a Linux VM with x2APIC physical and logical modes upto 512 vCPUs.
  * Test enable AVIC in L0 with xAPIC and x2AVIC modes in L1 and launch L2 guest
  * Test partial AVIC mode by launching a VM with x2APIC mode

Changes from v2
(https://lore.kernel.org/all/20220412115822.14351-1-suravee.suthikulpanit@amd.com/)
  * Rebase to kvm/queue
  * Patch  3: Moving force_avic option declaration to avic.c
  * Patch  7: Change to only setup x2APIC msrs supported by x2AVIC in svm_direct_access_msrs.
  * Patch  8: Add back avic_refresh_apicv_exec_ctrl() in avic_set_virtual_apic_mode()
  * Patch  9: Update avic_set_x2apic_msr_interception() logic
  * Patch 11: Introduce hybrid-AVIC mode (NEW)
  * Patch 12: Modify warning to check for vcpu with xAPIC or x2APIC mode only.
  * Patch 13: Add support for avic_kick_target_vcpus_fast() (NEW)
  * Patch 14: Add doorbell tracepoint (NEW)

Suravee Suthikulpanit (14):
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
  KVM: SVM: Introduce hybrid-AVIC mode
  kvm/x86: Warning APICv inconsistency only when vcpu APIC mode is valid
  KVM: SVM: Use target APIC ID to complete x2AVIC IRQs when possible
  KVM: SVM: Add AVIC doorbell tracepoint

 arch/x86/hyperv/hv_apic.c          |   2 +-
 arch/x86/include/asm/apicdef.h     |   4 +-
 arch/x86/include/asm/cpufeatures.h |   1 +
 arch/x86/include/asm/svm.h         |  21 +++-
 arch/x86/kernel/apic/apic.c        |   2 +-
 arch/x86/kernel/apic/ipi.c         |   2 +-
 arch/x86/kvm/lapic.c               |   2 +-
 arch/x86/kvm/svm/avic.c            | 181 ++++++++++++++++++++++++++---
 arch/x86/kvm/svm/svm.c             |  56 ++++-----
 arch/x86/kvm/svm/svm.h             |   6 +-
 arch/x86/kvm/trace.h               |  18 +++
 arch/x86/kvm/x86.c                 |   8 +-
 12 files changed, 251 insertions(+), 52 deletions(-)

-- 
2.25.1

