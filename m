Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67614466E10
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 00:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377672AbhLCACm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 19:02:42 -0500
Received: from mail-bn7nam10on2056.outbound.protection.outlook.com ([40.107.92.56]:58718
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1377673AbhLCACm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 19:02:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=npRx+YkK4CmFwKlnqTkZJ7kqEhmwR8r3sX3nX3OUhqu11geAe+deFriFGt8qhvXNT5qZCIfv7IequImaj+c8yZbq4sbsRBNmon9sFSFHpuEv5tKGtF4l1/S7lC06xEP5vdkcQSnxe/OHge2pIGVU0m4tZo1/xQYEe7FqVzogTvU9C+K+kx9A0hWYKKMEuuj/lybSzq3IZEAh1N/kTWjjcRMgUbrq9/3lGNMQAEWwFPhk8nVoBwGnX4Ba+6iCy8NmJzdcmq4Z3shrVbLv69wOHClks7xtepw3Bd/CvF95ZRZNiOmeYa6RA63faAm8L8kQt0KG44xZYakuMft83g1eWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4C+mJ3ZNm6iD2z56ij/EXKqfmYfZfwfriP0H5Bxp4qc=;
 b=no8YJq9tPMR7dMLf5B1mmrvNAzv8SxgnS2OpnzHkkrhe0Mv68cIv0b4Nc0DjqrDoaXWByvp4PCE1RzcpyaoNOpFh13RSDZAX0Tr7L0aXPNKRGv9i4LJrmR7nRoiqJ3XGEEbttu9j52St4QSoymsf+H/oGhdar2v+qK6e/4Dhhq9nBayf3gVHvHpvbwTV5k1CcNDM35rKwb3+T87q/JNqeqHPZ2xMCH6ySbAFNhaC4isCIIxAcQxqQWS2XGM5mE7lfaXxxSPKOFRQtbT4VrbTOgPE9kf/dvdQyVmeGSIl774rKYDdH1G+VE3AqInFKpdyFrRlB78M5myObmdPRuAjVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4C+mJ3ZNm6iD2z56ij/EXKqfmYfZfwfriP0H5Bxp4qc=;
 b=3CVyVZ6TTSAqq9mJ3OMLOp1cWN3JkdkONNfs4/cSd9P+BdTZMRhdm60tsHsEBA1zyipJC/VJvd8GuLXlLEYcTpUQRBt1440cD+n2sAqZ0MobZq4dmGqFJKi/lb6mrHB6IzsJhsswDZM28e7yEwUDnmZVOi0hhvIKTb87E8RmG9A=
Received: from MWHPR17CA0094.namprd17.prod.outlook.com (2603:10b6:300:c2::32)
 by DM5PR1201MB0121.namprd12.prod.outlook.com (2603:10b6:4:56::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Thu, 2 Dec
 2021 23:59:17 +0000
Received: from CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:c2:cafe::8c) by MWHPR17CA0094.outlook.office365.com
 (2603:10b6:300:c2::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend
 Transport; Thu, 2 Dec 2021 23:59:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT015.mail.protection.outlook.com (10.13.175.130) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4755.13 via Frontend Transport; Thu, 2 Dec 2021 23:59:16 +0000
Received: from sos-ubuntu2004-quartz01.amd.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 2 Dec 2021 17:59:13 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <pbonzini@redhat.com>, <joro@8bytes.org>, <seanjc@google.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <peterz@infradead.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
        <jon.grimm@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v2 0/3] svm: avic: Allow AVIC support on system w/ physical APIC ID > 255
Date:   Thu, 2 Dec 2021 17:58:22 -0600
Message-ID: <20211202235825.12562-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca913add-ba4a-46c7-cfea-08d9b5efbfd1
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0121:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0121D4F414E37C2596BB6EF3F3699@DM5PR1201MB0121.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 47UCHqXBE2Nz62bnrKmK+vG6+ILlKOwRubLGulKlbMUWblyP9zJVf4sMdhYy9AmuqoyQ7KBq0sh3ODlEH18ypFYex5vqNJsaHFcQP1r2xk5QlemOLBarqqxsPD5IwRw+9n1PXSiDRA6YQ6IWUnzZURbkxzrdg31kNW+Zp05uznlNIV1krVRdftiSHmH67j+NaJOaOI9SpQkubKP5L0DaRs1ToPb3DnNFRht+eECe0HQc/Rj6Xnlsk3dPsQzBxHJgRsSaQRPDiX3dK2hq6DANw2dcB9gQqrUFiptjzmII873e6/G1XR3+O2jsqzh4qeBRTO6mmLqgXIzlDjzrNBOBHAAu+kJXE6rM5EAMok+UjH61MYlHwZshem5DID+0iglzCkoutLNISYWzfYDpot28sa6FCNmUP5fyLutGkY/uE1ORPIRFRK7BYS/UfwRuRPPe995Om/Uvd4B035xRhxjVS0oJZaNpmsKM7pUhn0g3krzHOE7R5Imbf8bBdRWyiIK6mF5kAmEH5QiG2p++KUIdy0e9ra9a0qBwr8UiOa1CrGPzFUy9rvD29PrszBURgFRjda3+LUwx5s3hXrKVQIZD7r15nLEaLCLezYKYRg7bTvygox5U88KqrUo09LkVWYEId1mHZAgTY69sKNvOZo6Z+19XmmNdQeWCdAf5TfyThho/BT3o3ijhoD9+thnnR+mqqINylA14iK2wlGYSdbdUFZW9vJbPGeNRv5n5TVW8biMe9Pf6UYQMVEq8uQTJRnPRwFaWlNFS2gq8/f9fkchYBfIWpEF2NdG/tSKHzF6sn0L08o68ogPYSsiG/oOAeq3nhRt7eXWGb+ncspA7xOFRtAPpq3++wUevi7HPoK2f9BGRdpNccr6oe3Ur5nuzvt0/
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(1076003)(6666004)(70206006)(70586007)(8676002)(7416002)(508600001)(8936002)(83380400001)(110136005)(81166007)(36860700001)(336012)(16526019)(36756003)(82310400004)(44832011)(47076005)(54906003)(2616005)(2906002)(356005)(86362001)(186003)(26005)(4326008)(316002)(5660300002)(40460700001)(7696005)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 23:59:16.8008
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca913add-ba4a-46c7-cfea-08d9b5efbfd1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0121
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Originally, AMD SVM AVIC supports 8-bit host physical APIC ID.
However, newer AMD systems can have physical APIC ID larger than 255,
and AVIC hardware has been extended to support upto the maximum physical
APIC ID available in the system.

This series introduces a helper function in the APIC subsystem to get
the maximum physical APIC ID allowing the SVM AVIC driver to calculate
the number of bits to program the host physical APIC ID in the AVIC
physical APIC ID table entry.

Regards,
Suravee Suthikulpanit

Changes from V1 (https://lkml.org/lkml/2021/11/10/243) :

 * Refactor AVIC hardware setup code into a helper function to simplify
   logic for enabling AVIC. (patch 1/3)

 * Simplify the logic in avic_init_host_physical_apicid_mask() by 
   by removing the CPUID[0xb,0x1] check for processor level APIC ID
   mask. (patch 3/3)

Suravee Suthikulpanit (3):
  KVM: SVM: Refactor AVIC hardware setup logic into helper function
  x86/apic: Add helper function to get maximum physical APIC ID
  KVM: SVM: Extend host physical APIC ID field to support more than
    8-bit

 arch/x86/include/asm/apic.h |  1 +
 arch/x86/kernel/apic/apic.c |  6 ++++++
 arch/x86/kvm/svm/avic.c     | 38 +++++++++++++++++++++++++++++--------
 arch/x86/kvm/svm/svm.c      |  8 +-------
 arch/x86/kvm/svm/svm.h      |  2 +-
 5 files changed, 39 insertions(+), 16 deletions(-)

-- 
2.25.1

