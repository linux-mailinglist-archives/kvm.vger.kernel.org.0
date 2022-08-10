Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C609E58E724
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 08:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiHJGMx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 02:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiHJGMw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 02:12:52 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619435FAE6;
        Tue,  9 Aug 2022 23:12:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Am+WuLMlkpkHPHI349RiloiccSQLracDGdRd5qkk3xybXwp1y1BYNom9uY3t6w0YxTqkSWlHydsTBV85HecQSghnhwprLmB427chqhuk0+WsPYuhDBt5iHvdEWxwKLshJU95Jl2h8uehJnLHM4eJoBOHIg0ukB4fVLvA9e05c7fORXQFtSeXRvhcnPMjbxSwLkPCdXuBiikaPJbeX2DK7C2LoM97SfXG+EQfNOSdvdSuXT+7tL/zITUE05DyVihSINIYSAzrqaoWueWkECkvTg81sRmHYRADjX4+sWOEPGhhSrR0tTbxpBsrFZZH3d66TP9EA8/+51SwzDUsPtq8QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vDfO3WPFkiNKPqZQzuJ9ScPBmlBLXrSu6DjmAz7O8/g=;
 b=nFg0GO5Fpbh/Sqv9VHEFlU2GZk2yzboNdpaBdlcROMoH9/07tYVxpAAAcgY7Pw0Pu2LBOv2kNf+ovU2khKzo6axS/m0kF6sX5I/I619e6ZycU/ek/B8xXyp7gQ2xvnzfSXj68Ii635Q2172NwKIN4nUud8T+d9hlRRO1tnC1GlVdBel4trAhF8hvu/Ebhu2Gcj8gj3amPkNq51RVP7iT8IvPaUTPuE5Z+TBw1rfs9oB5NfvEWJuLUhUocLjEQ/QUjfgb1gSzOL+QuzlsmGI9EmGSjthXKs5jqlhGPr0+S8umHZSm3fMmwKJBgpdpinhz9R/LZtkaIX1U3pZYH3RPlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vDfO3WPFkiNKPqZQzuJ9ScPBmlBLXrSu6DjmAz7O8/g=;
 b=4edWGwtug0kVfW9jROicsne9+gYWFxBzp9vWYOjYU5WyAUXT9pxHAM8UVGix5nUuVcma7giPRh61jBiXra+0/7pH5ee8CJol4UG4GwXrMy6S/0+3FQ00occ/LSZP8dV9Xq1LWM/wNikuIOedman4kYgBTHK7SAQYdD/Mp554Bl4=
Received: from MW4P221CA0015.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::20)
 by DM6PR12MB2794.namprd12.prod.outlook.com (2603:10b6:5:48::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Wed, 10 Aug
 2022 06:12:47 +0000
Received: from CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::e8) by MW4P221CA0015.outlook.office365.com
 (2603:10b6:303:8b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.20 via Frontend
 Transport; Wed, 10 Aug 2022 06:12:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT017.mail.protection.outlook.com (10.13.175.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5525.11 via Frontend Transport; Wed, 10 Aug 2022 06:12:47 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 10 Aug
 2022 01:12:41 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>,
        <mlevitsk@redhat.com>
Subject: [PATCHv3 0/8] Virtual NMI feature 
Date:   Wed, 10 Aug 2022 11:42:18 +0530
Message-ID: <20220810061226.1286-1-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 068eb151-9824-4d84-f6a8-08da7a9758d7
X-MS-TrafficTypeDiagnostic: DM6PR12MB2794:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8whgBMgwM6lEELcKlUiBtYOlPxrBMuEf3JLGIbelFisTna++XDsNbG4+LaZlnGyc+/RijCjPh3KaIIt+EuxBLDDqzDGfF0HDO6zlGMVcOwJKdR7yFPuI3RV5bD6PR4PzMB3OtbW8zQuZSzzLibTlOY64XhQb9d4S6Y8C73rODB6AKU8zRMZyMIZ1B4MoifW3J6NAuOHDyHPwJZAijdg408kTcPCSr6xgcwLwYuanvL/mP4QQ06Gf53NjSTmXz0cJSf7LRAHmSC6drDQOXpPLagzwzd8R+E2FTjUebRemTV4q6MjHbcA6bj16e7SPqHuC5AbevP7W52LUTY4fmL+Zxb20kIaSFjK37ck8qsxoTvv7NrRT64VDfqSZk33KtjeX2tae96pbKgEiRRalsmJC+RVsfnU+mRp3xST4anG7o0K3L9XXvVH357Cbp9/t8NR97Zlav+14+SWHE5+oEyTxPJS0VEqhfuJBh0XgzrpwL0E/IfV1dAXT1AXyWDzX/ZoOdjO166IzFWiBYObWvHd5sIQvC/7ULeI+Tp4vW0HRNx8b1wFBAHnbr4pimNW4DogmNmL+d7LsxoZ1HJBa6UkIblx2qqEVQZYmzFWu8IajMXSK2mpmQpuCXIc9olWwYq96Qox6oClfNDqY9/3yMp0gRMBrJl0PzGdNMWyMBZB6lEnIanx8RTp+/a47iR+65KiskSoQUKStpjvW+xQAg3/xNGRMG7AVKg70JdOSnkEth7IwXkYuICEpgP/EBjCjo4+Htc9GEiCudehNqWHqRiMRZNNN8+z+CuTfNCeXhu4bxz7HDfoKco8PxSqjXThKyZVISL9iBhPtCPIKmMNn1sjdHs+iBNKLTkXtYVfBxCBQj5Rt4uwHcYs9tENdoFp9vJxf/VvFYHxT0YnOsgCXWQbuMqNu79EjEvdC15V6kByOz5M=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(136003)(346002)(376002)(36840700001)(40470700004)(46966006)(82740400003)(6666004)(40460700003)(7696005)(1076003)(186003)(83380400001)(426003)(47076005)(2906002)(16526019)(41300700001)(478600001)(36756003)(966005)(44832011)(8936002)(54906003)(82310400005)(86362001)(81166007)(5660300002)(6916009)(316002)(36860700001)(336012)(4743002)(26005)(40480700001)(2616005)(4326008)(356005)(70206006)(8676002)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 06:12:47.1795
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 068eb151-9824-4d84-f6a8-08da7a9758d7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2794
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change History:
v3 (rebased on eb555cb5b794f):
03 - added clear/set_vnmi_mask API for SMM case
04 - added vnmi_pending check so to detect the pending VNMI scenario
05 - removed WARN_ON
06 - handle one of nested case where L1 using vnmi and L2 doesn't
07 - Emulate the VMEXIT(#INVALID) case for nested case
08 - No change.

v2:
https://lore.kernel.org/lkml/20220709134230.2397-7-santosh.shukla@amd.com/T/#m4bf8a131748688fed00ab0fefdcac209a169e202
01, 02 - added maxim reviwed-by.
03 - Added get_vnmi_vmcb API to return vmcb for l1 and l2.
04 - Moved vnmi check after is_guest_mode() in func svm_nmi_blocked().
05 - Added WARN_ON check for vnmi pending.
06 - Save the V_NMI_PENDING/MASK state in vmcb12 on vmexit.
07 - No change.

v1:
https://lore.kernel.org/all/20220602142620.3196-1-santosh.shukla@amd.com/

Description:
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

If NMI virtualization enabled and NMI_INTERCEPT bit is unset
then HW will exit with #INVALID exit reason.

To enable the VNMI capability, Hypervisor need to program
V_NMI_ENABLE bit 1.

The presence of this feature is indicated via the CPUID function
0x8000000A_EDX[25].

Testing -
* Used qemu's `inject_nmi` for testing.
* tested with and w/o AVIC case.
* tested with kvm-unit-test
* tested with vGIF enable and disable.
* tested nested env:
  - L1+L2 using vnmi
  - L1 using vnmi and L2 not 


Thanks,
Santosh
[1] https://www.amd.com/system/files/TechDocs/40332.pdf - APM Vol2,
ch-15.20 - "Event Injection".

Santosh Shukla (8):
  x86/cpu: Add CPUID feature bit for VNMI
  KVM: SVM: Add VNMI bit definition
  KVM: SVM: Add VNMI support in get/set_nmi_mask
  KVM: SVM: Report NMI not allowed when Guest busy handling VNMI
  KVM: SVM: Add VNMI support in inject_nmi
  KVM: nSVM: implement nested VNMI
  KVM: nSVM: emulate VMEXIT_INVALID case for nested VNMI
  KVM: SVM: Enable VNMI feature

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/svm.h         |  7 +++
 arch/x86/kvm/svm/nested.c          | 32 ++++++++++++++
 arch/x86/kvm/svm/svm.c             | 44 ++++++++++++++++++-
 arch/x86/kvm/svm/svm.h             | 68 ++++++++++++++++++++++++++++++
 5 files changed, 151 insertions(+), 1 deletion(-)

-- 
2.25.1

