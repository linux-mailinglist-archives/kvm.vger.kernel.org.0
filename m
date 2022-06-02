Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 789E053BAAA
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 16:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235851AbiFBO0n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 10:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234632AbiFBO0n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 10:26:43 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2064.outbound.protection.outlook.com [40.107.94.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006D82A143D;
        Thu,  2 Jun 2022 07:26:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mZKAFBVUd0fRz098Z1gAOABwEU89slknBihBXESicYP3k0Ws9zi+I/kYUDitjCMbHHkKwK6jEg6SwWxx9SY3oDt7D5Tm7fvC5UrlUQ+tMpT/aVpGRgzvLHk8jWGW/dmWRQJevoolAqp1ycrV1YguZVBH5NoCcg27eciqx+FLbjEHGsvzgpe/Bfgic5oRlUE1fANhluoU7pAPKb7UJQ0uC8eiQ+3b2b4MIGoWAu3PNBS0kekSkGkF5wYP6x4iXrSVhj2748GFoWu+0cL1OLrHzDezAEsCwt1pNdu1tb/iy/DBWqKD0mLkJ6KJMtRhXBhwOI3mtnWPgkn3ycQm2cNpzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ys/7Dj628Lj9HoNrSd/5k0WFFmyavqsCBEAOtMVqfk=;
 b=RYAuwy/1mH0yhwpv0dPIGkBvkGIRZFUMfIB66omSvIqmpf5CcVZqQBfsgM1z+EIDANN6il8dDMRhS86pvPx9PlgUFHGuYaGpKlnzpqRCqJZAewwRxXfI5hylSklw+F4VaQKyvYM9vypDFd0qols6KRan688nhpw47dwWiftYZO219tFrgEuDoo9JvYxRihC/grhXGaX/YX3PgyWvoyPDIlXOdjFg6QIgPOnSZ6Zwu2V2jAW9yNEw/eN2yNCfNdAs9lqAsrRdXj1bxGzC25SO/u44RDpT/SGx34AXZwAJfgSpTWgjJ7Bd9rWFooI7XBaB+85LHvvczv4QRIvdpsne2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ys/7Dj628Lj9HoNrSd/5k0WFFmyavqsCBEAOtMVqfk=;
 b=DEXnGLX6t+E0YTy8UBsHVbBxeL95crbK0dyzh29VEkU+mmP8tKBvZlpcioCvsoWNC5tD3LyVz8BaY7O5Y2uJR2pylkxPwO/xGcKsn9GmCkUAx5Pb+DuFObR9qOWi04/PwV+S80vYpv+1ds3wJTJcMeuH/+wMeMUybARGXIJYImU=
Received: from BN6PR19CA0053.namprd19.prod.outlook.com (2603:10b6:404:e3::15)
 by DM6PR12MB3644.namprd12.prod.outlook.com (2603:10b6:5:118::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.18; Thu, 2 Jun
 2022 14:26:37 +0000
Received: from BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:e3:cafe::e3) by BN6PR19CA0053.outlook.office365.com
 (2603:10b6:404:e3::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13 via Frontend
 Transport; Thu, 2 Jun 2022 14:26:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT012.mail.protection.outlook.com (10.13.177.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5314.12 via Frontend Transport; Thu, 2 Jun 2022 14:26:36 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 2 Jun
 2022 09:26:33 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Santosh.Shukla@amd.com>
Subject: [PATCH 0/7] Virtual NMI feature
Date:   Thu, 2 Jun 2022 19:56:13 +0530
Message-ID: <20220602142620.3196-1-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc8ca169-d4c9-4535-a1de-08da44a3e6d9
X-MS-TrafficTypeDiagnostic: DM6PR12MB3644:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3644DADF52EE8B3E5B7AEAB987DE9@DM6PR12MB3644.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QmSsBIPtQylfifTxvuUvKgcs8uTYm7ts2OK6by8RoCpTORSSH4BtDQr1GNHngH+kTALhfqaJufsLkDg1ljPtmFzjIYQvfi4WYk7kzFngCuKfUXhmmt16g4tqVtCxTTd5rAoPWbdj527nGS/YOzZfTrz3owKhgfrhsJTHEPZIEt9ArOdmiUUb98XV9eiT8aM8UdHdecpdc1SWGF2h+hIMC57h3BlXpXrEvXi8fAv9KkwdiYun3jJhhkX4GAu3q3z4Rzgu5rK1acLBNPOl8F+v5eg36PFu2wKm84ZdfERDjVVXulRr2JgaoXsrWDjppoeJ99wb+vdAlyDRZZn+yfV1fLlp//Skyw+fLpB6w9MotfMcSHvcQ2vz7ac8otR4UbYWxfQI+br8ks2lN5Fw5ar/loAq/RcAAl9xBO8Q3pndq7QCT8GPMrQ6RgXhFFj47A8hrtW0DvrWVyMGOjzGv1jL3ai5C5MyE2Rsa2mjCK+u/dJ7XaUMiUC2MvgDLEYNF9qj61gRVETO0c+hlYopBsJsKEn4QqFJVsJ9ByO/iaklNFVYO2vBxtwezgaqbpB3UaeI9BnV3Tzw9wEYcQgVLPcOytxGBtS5E+dO0FOQCEnLCBcunKMzP9dfeRyufg58rBJFikZI+joMiihOANKtxcq8FifXLHfcf0u1Bx99JeITKMfbZSd6m2zBY3rfOV3cI4Nv4ltkDH8jtQnajLHm8s/roXlWqNpsj/NDHtZR9AGLuKPUpBDpTPBXPb4h7PCEhnm/E4NpXfto9TpPF3l2fKsGlYyP6sV6ijpIiKkFb2evVto=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(26005)(40460700003)(16526019)(47076005)(2616005)(83380400001)(1076003)(5660300002)(2906002)(44832011)(36860700001)(508600001)(6666004)(7696005)(966005)(36756003)(186003)(8936002)(356005)(82310400005)(81166007)(426003)(336012)(8676002)(70586007)(70206006)(4326008)(316002)(6916009)(86362001)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 14:26:36.9101
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc8ca169-d4c9-4535-a1de-08da44a3e6d9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3644
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, NMI is delivered to the guest using the Event Injection
mechanism [1]. The Event Injection mechanism does not block the delivery
of subsequent NMIs. So the Hypervisor needs to track the NMI delivery
and its completion(by intercepting IRET) before sending a new NMI.

Virtual NMI (VNMI) allows the hypervisor to inject the NMI into the guest
w/o using Event Injection mechanism meaning not required to track the
guest NMI and intercepting the IRET. To achieve that,
VNMI feature provides virtualized NMI and NMI_MASK capability bits in
VMCB intr_control -
V_NMI(11) - Indicates whether a virtual NMI is pending in the guest.
V_NMI_MASK(12) - Indicates whether virtual NMI is masked in the guest.
V_NMI_ENABLE(26) - Enables the NMI virtualization feature for the guest.

When Hypervisor wants to inject NMI, it will set V_NMI bit, Processor will
clear the V_NMI bit and Set the V_NMI_MASK which means the Guest is
handling NMI, After the guest handled the NMI, The processor will clear
the V_NMI_MASK on the successful completion of IRET instruction
Or if VMEXIT occurs while delivering the virtual NMI.

To enable the VNMI capability, Hypervisor need to program
V_NMI_ENABLE bit 1.

The presence of this feature is indicated via the CPUID function
0x8000000A_EDX[25].

Testing -
* Used qemu's `inject_nmi` for testing.
* tested with and w/o AVIC case.
* tested with kvm-unit-test

Thanks,
Santosh
[1] https://www.amd.com/system/files/TechDocs/40332.pdf - APM Vol2,
ch-15.20 - "Event Injection".

Santosh Shukla (7):
  x86/cpu: Add CPUID feature bit for VNMI
  KVM: SVM: Add VNMI bit definition
  KVM: SVM: Add VNMI support in get/set_nmi_mask
  KVM: SVM: Report NMI not allowed when Guest busy handling VNMI
  KVM: SVM: Add VNMI support in inject_nmi
  KVM: nSVM: implement nested VNMI
  KVM: SVM: Enable VNMI feature

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/svm.h         |  7 +++++
 arch/x86/kvm/svm/nested.c          |  8 +++++
 arch/x86/kvm/svm/svm.c             | 47 ++++++++++++++++++++++++++++--
 arch/x86/kvm/svm/svm.h             |  1 +
 5 files changed, 62 insertions(+), 2 deletions(-)

-- 
2.25.1

