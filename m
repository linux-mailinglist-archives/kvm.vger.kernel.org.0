Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3D552C027
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 19:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240101AbiERQ11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 12:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240192AbiERQ1P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 12:27:15 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2078.outbound.protection.outlook.com [40.107.243.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B34864703;
        Wed, 18 May 2022 09:27:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A7KTSDw3eTt8bJkGLAa01QhKhdDqFk8Ygt9PnoO15/zAhHSvR4JL897xTC83y4ADgKGyeri5dXhVl/x3jFs9sW+hm4k0FoLNH+W4AtUyPeIMI4CTia/BoPOVbfMHnNE73+EpHcz2ZlEKbiGSC+4wSjRR5ohuHAoMeMMqGXmOlJklwy0QBRN5k/kJyaiCt2+u8v0WJ2MmzuA+heOCIHoqbyi9tmiWnZFMwogHqXxfQwYK0RhTNQ9bGVfLN4NSmCcEeykvYO5XxUJ+RXjlBsEagcQ7okAbFCx2F3J8Fr1zIHhb8afYEFLjrLVtPjrYiAqaeBiu2zzqme/Cx89c57IzQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jkKidbn/xLybtnDttA0unSxRP9Yb1t1gl7PuVqFuHBk=;
 b=JWzLU/boNKWe/JjUe4JqEjQrzjCtHtPactt0vbR4aCd+VtkTum4fDt4InlSEDWJu7/3n+xFkg82ZlDiTyotJ7xdozFw47cpbw9HlR1FADJ0Pf2aNd/vA1E7/uGP81sJi+ktVc/siKR8C+bWBqqK8p8j108AqyFB741bjKSdSApsQCD57+ez86yid6xcwVToY3PigyNi7Xfu06Omi6Hl03N9KMlJasDsWsbXGcVq8YIB89Pv4vVwXIJOfN2Y6IZnERFwfIkCOpVkMp7iW6VML8+e0zuY8ZfPNSZSy4GRXk6zXXLL5p5o8i4keEdveTxS0jq0m2sl9jhW7URMfYYgEGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jkKidbn/xLybtnDttA0unSxRP9Yb1t1gl7PuVqFuHBk=;
 b=1f+iYfh7NU9kBOwTYo/UWSM8W/VYNyHUuDSiqfctMf9SQ1SgBzYk8oMTlTbTUhIWxmUPo5dn0cfDlvKG9yWrGYbtcQ3kBjUZq4jmH/pxTpx4z0dq1KBFr6bDbbyiZRhr5xGSwZT7IvaxrgTIWbtyj5f3rFehnUlDSpsrQPUveWg=
Received: from BN0PR04CA0168.namprd04.prod.outlook.com (2603:10b6:408:eb::23)
 by DS7PR12MB5909.namprd12.prod.outlook.com (2603:10b6:8:7a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Wed, 18 May
 2022 16:27:08 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::2d) by BN0PR04CA0168.outlook.office365.com
 (2603:10b6:408:eb::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13 via Frontend
 Transport; Wed, 18 May 2022 16:27:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Wed, 18 May 2022 16:27:07 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 18 May
 2022 11:27:06 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 00/17] Introducing AMD x2AVIC and hybrid-AVIC modes
Date:   Wed, 18 May 2022 11:26:35 -0500
Message-ID: <20220518162652.100493-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03d16149-101b-40d7-c6a0-08da38eb408b
X-MS-TrafficTypeDiagnostic: DS7PR12MB5909:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB590977721D0D15AA230941B1F3D19@DS7PR12MB5909.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hO4yEbhGtiNY2O/sn3BQJLmMTp6eY5PeZvtGd3kTFalWsQxPhBqMPBOu9jrFQxd2oL98Eak5Yhs2LO8DofIUHa4qa2KcfCZQbl8siHBcJVHxooacN73wazcpOVbkLiTl4AXAI+q5/fdpI/80nuomRHBQFESXIN9T/HvL5QPqFrdwraVN3wCnhmafgKUA9KaB2YdLw+4/X4I6uKQFi3KHyGXlO8CbLsqKlRmdIVJ6IcIeVct1HAE3YqupHsg6EHm3wT3n/eD0jNP2EsKm3FnGjIVnKxtLpTWLRDBUO/5X0tSTCOu2qj7xjm5Rt0qoG5l5RuC3Rxtc8SB9/Ev7n29pGoesooJ1BEX17d9ULCcbSe2/Bhx1sP5OXjkvHyHvj3dVfkTJeHBzsO18Rnb3Mv4XL92gOzku9kpLBJlL3s4ot7n1S5JsdOE0icC+Frjq7KEvvjCxVFG3j12w8452gPDJh74KBN7N1us8Hi2UP8dxGa3kuuUslNElO6lsAxmzKihbVCLwuxkqB8TWZ97USB962OAYO22S4tG09eUVDOKaCF2hK5sPxutWmFTdd5McG62gUOSOM0pmkcGuaJenSBVkgTMAmks9gaEshUHso6Md6/SqxwVsn25V7bwUuIh8qLKYQ3R7KomuzP5ndxAUW30fhHy/DnOy4w8UTMqqraDw1idhLRXZLhboqSjcQ1FwPD/cEpkL0oud5tcesQvOH7ri3NRf9np2KFUw/b3ZQhq4kYFxiK1/tLuwnfo0lTDO8EVYfLI7jD3o0nI33xghmG9AvXbsx403bQ7Px4Ol3mUiM0g=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(36860700001)(8936002)(54906003)(70206006)(70586007)(2616005)(40460700003)(508600001)(110136005)(186003)(5660300002)(426003)(336012)(86362001)(47076005)(6666004)(316002)(2906002)(1076003)(36756003)(16526019)(44832011)(81166007)(82310400005)(26005)(356005)(7696005)(8676002)(4326008)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 16:27:07.7093
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 03d16149-101b-40d7-c6a0-08da38eb408b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5909
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

Testing for v5:
  * Test partial AVIC mode by launching a VM with x2APIC mode
  * Tested booting a Linux VM with x2APIC physical and logical modes upto 512 vCPUs.
  * Test the following nested SVM test use cases:

             L0     |    L1   |   L2
       ----------------------------------
               AVIC |    APIC |    APIC
               AVIC |    APIC |  x2APIC
        hybrid-AVIC |  x2APIC |    APIC
        hybrid-AVIC |  x2APIC |  x2APIC
             x2AVIC |    APIC |    APIC
             x2AVIC |    APIC |  x2APIC
             x2AVIC |  x2APIC |    APIC
             x2AVIC |  x2APIC |  x2APIC

Changes from v4:
(https://lore.kernel.org/lkml/20220508023930.12881-5-suravee.suthikulpanit@amd.com/T/)
  * Patch  3: Move enum_avic_modes definition to svm.h
  * Patch 10: Rename avic_set_x2apic_msr_interception to
              svm_set_x2apic_msr_interception and move it to svm.c
              to simplify the struct svm_direct_access_msrs declaration.
  * Patch 16: New from Maxim 
  * Patch 17: New from Maxim 

Best Regards,
Suravee

Maxim Levitsky (2):
  KVM: x86: nSVM: always intercept x2apic msrs
  KVM: x86: nSVM: optimize svm_set_x2apic_msr_interception

Suravee Suthikulpanit (15):
  x86/cpufeatures: Introduce x2AVIC CPUID bit
  KVM: x86: lapic: Rename [GET/SET]_APIC_DEST_FIELD to
    [GET/SET]_XAPIC_DEST_FIELD
  KVM: SVM: Detect X2APIC virtualization (x2AVIC) support
  KVM: SVM: Update max number of vCPUs supported for x2AVIC mode
  KVM: SVM: Update avic_kick_target_vcpus to support 32-bit APIC ID
  KVM: SVM: Do not support updating APIC ID when in x2APIC mode
  KVM: SVM: Adding support for configuring x2APIC MSRs interception
  KVM: x86: Deactivate APICv on vCPU with APIC disabled
  KVM: SVM: Refresh AVIC configuration when changing APIC mode
  KVM: SVM: Introduce helper functions to (de)activate AVIC and x2AVIC
  KVM: SVM: Do not throw warning when calling avic_vcpu_load on a
    running vcpu
  KVM: SVM: Introduce hybrid-AVIC mode
  KVM: x86: Warning APICv inconsistency only when vcpu APIC mode is
    valid
  KVM: SVM: Use target APIC ID to complete x2AVIC IRQs when possible
  KVM: SVM: Add AVIC doorbell tracepoint

 arch/x86/hyperv/hv_apic.c          |   2 +-
 arch/x86/include/asm/apicdef.h     |   4 +-
 arch/x86/include/asm/cpufeatures.h |   1 +
 arch/x86/include/asm/kvm_host.h    |   1 -
 arch/x86/include/asm/svm.h         |  16 ++-
 arch/x86/kernel/apic/apic.c        |   2 +-
 arch/x86/kernel/apic/ipi.c         |   2 +-
 arch/x86/kvm/lapic.c               |   6 +-
 arch/x86/kvm/svm/avic.c            | 178 ++++++++++++++++++++++++++---
 arch/x86/kvm/svm/nested.c          |   5 +
 arch/x86/kvm/svm/svm.c             |  75 ++++++++----
 arch/x86/kvm/svm/svm.h             |  25 +++-
 arch/x86/kvm/trace.h               |  18 +++
 arch/x86/kvm/x86.c                 |   8 +-
 14 files changed, 291 insertions(+), 52 deletions(-)

-- 
2.25.1

