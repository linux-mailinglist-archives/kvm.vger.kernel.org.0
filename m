Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12EDB4A6AC9
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 05:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242770AbiBBENd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 23:13:33 -0500
Received: from mail-dm6nam11on2045.outbound.protection.outlook.com ([40.107.223.45]:12769
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232236AbiBBENc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 23:13:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fIT8jpge4CcVgkH+6gacF8oUp9i/Tir+raL4lcZtd5PVig99rdoOUcUEa8wVD2bwz3O744c4tJ54Sosxm+ZYhZ6ZbkQGQCt2xSmAd0qKSce4A7xdcyURvXRtNPyJRgXhvA4R3hfkySWQpXOPV9SmtFj6weftAqqriuJTmTKKhah3Se7po323xDmxiPM8W3MLT+8i6p+LO3W5R+kF+xs8Ai2y35KgXEVNnvmWqGNvpWxwn2JSih27Nx5X8Io8xusnKdk/VFkgWX3LnrkOAmKKKSooA+jz2NQMvXkc7/XHj1hyme27XMAQCUcUZiE4rEZVfC2wGbOS2vsIRbeAYBtCVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vLTDWExBMPxK2LJgLbaSqQ5IzEY//W6KUDcFTmUhao4=;
 b=HLDewysR/KDHJIQEEDh/7zwkl1BApXguw7czYIeWxt0/H5k84NgEEmhkjPszTReuVdDV1EIi/RYMIJs22IMTDbrIGIRuy0m2di/fKhkOB0i72Ga8k4GGNrBS4Wb0mTtraozBq1HZw8be3256a7vMFQGy9g9Q928xaNDGLJCYfYzYOZqjTA4XLluZfrkjOK/QotGHhkqPvZ4lPIi5JEJgaJVrLlrj4k67ue9Gm/rSZNGFph1ZiTH/YTvP4WyZdMEaTktQMqVYYclKQ8NxyFekqmh/GmUgUpVhsO7aIqa8rbU1ltjfFIoNFrXleA3PROzFW091BaWBje0S6KtROyod0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vLTDWExBMPxK2LJgLbaSqQ5IzEY//W6KUDcFTmUhao4=;
 b=GGw3kntdvLT1OmKA9AHoI8g9VlqHPk01Nq/yeJLurDckUPqEXNA7B0YjLms9rcGtXpHVbyvahcF5sHIMznLmafL8Z/V/ryQpGzP/USc6rFmld1YFcgrs0HXx0R2llm3YuQ7s2BZbXWJCT2WSRxa/b/WprA2MRkjKAC/6ahLfCb8=
Received: from DM5PR2001CA0014.namprd20.prod.outlook.com (2603:10b6:4:16::24)
 by BY5PR12MB3780.namprd12.prod.outlook.com (2603:10b6:a03:1a2::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.20; Wed, 2 Feb
 2022 04:13:29 +0000
Received: from DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:16:cafe::2e) by DM5PR2001CA0014.outlook.office365.com
 (2603:10b6:4:16::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Wed, 2 Feb 2022 04:13:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT021.mail.protection.outlook.com (10.13.173.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4951.12 via Frontend Transport; Wed, 2 Feb 2022 04:13:28 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 1 Feb
 2022 22:13:26 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <seanjc@google.com>, <mlevitsk@redhat.com>, <pbonzini@redhat.com>,
        <joro@8bytes.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <peterz@infradead.org>, <hpa@zytor.com>,
        <jon.grimm@amd.com>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>
Subject: [PATCH v4 0/3] svm: avic: Allow AVIC support on system w/ physical APIC ID > 255
Date:   Tue, 1 Feb 2022 22:11:09 -0600
Message-ID: <20220202041112.273017-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c79f930-c1d4-4ea6-d67d-08d9e6025df9
X-MS-TrafficTypeDiagnostic: BY5PR12MB3780:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB3780CB4F949B69BF8173AAFBF3279@BY5PR12MB3780.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uxac/SKXcQmmyBsvnMw/fDvizmvPT0IuHMTyeKdMy1BBryviC9IBbDUe4FmgxMD0gd6ZZNN9k0gAQOJqPT7S9QaLEA3qd/rQ3EhYSsL6DlvSRGn8Mw8cHlFnNn52hiAOe5slYXHHh0GFH2enEiKk0DOkV0VnDt3AOO3NdTJM5FYVa4kBLpIfvh55YbrxqHhwSo7Wh56RbYO/rzz6qO5wKZou4//R/AgyMhjUGP4zbH9yN3JUpbboYqOHEVCd4VcgnLeXkyuLQqXbFgO6Q3rJ05FfJocOaTtMzUW7R4IBItoSHoqbefqsDkwcrV2S+2kwyQmLTLHNkCY5GGDM1mmgKdUIRzHn7WccnK+1BhsJ9DbPSmjO3JMXQFFH8RoPvtZcRgNFfqFhhl3fgUzXhG8B/9ng4punPH/XpeJ+eMbMZlGiYTThTquy6JNBpe291RRWq+pdJ7UCjDe16jhXsDHFDofS/xJmbhXGnuS0zi2ov/pfTdGfKu5GCF/6w14E3u0R3SPPt8VVyW4QM0puA93NRdR1ByXQmJazRqU+9CNiyHNaCKKu5U+FYmQLuEz4Y74hNR0Z4wYYZeGLsHssVvPs8odPSq+siSneUvvmCWXrbnR+C5aP+sYTDUPVyLHp4sHvXqysr7CUY1jcI9iS7Pw7vPwAbDD51DRs46fuoeK6G8w5//aGud6yEzFvpH4Yoeu5wfaJmWtmTcSfK9sVBMWiNWU9tMyy4wjR5/MWsLgcPTMYxgPTdB7zaTnyM8UhBsuG1cghHknjm7KpaxUjo1UTrnivE2dTeH/B7heDpp/VV0Q=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(16526019)(7696005)(2906002)(508600001)(81166007)(36756003)(70586007)(6666004)(336012)(82310400004)(426003)(1076003)(8676002)(26005)(2616005)(70206006)(54906003)(8936002)(356005)(5660300002)(186003)(316002)(4326008)(83380400001)(110136005)(47076005)(7416002)(86362001)(44832011)(40460700003)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 04:13:28.9519
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c79f930-c1d4-4ea6-d67d-08d9e6025df9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3780
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Originally, AMD SVM AVIC supports 8-bit host physical APIC ID.
However, newer AMD systems can have physical APIC ID larger than 255,
and AVIC hardware has been extended to support upto 12-bit host
physical APIC ID.

This series introduces a helper function in the APIC subsystem to get
the maximum physical APIC ID allowing the SVM AVIC driver to calculate
the proper size to program the host physical APIC ID in the AVIC
physical APIC ID table entry.

Regards,
Suravee Suthikulpanit

Changes from V3 (https://lkml.org/lkml/2021/12/13/1062)

 * Rename and modify patch 1/3 to also set vcpu_(un)blocking only
   when AVIC is enabled.

 * PATCH 3/3: Instead of dynamically calculate the host
   physical APIC ID mask value, use the max host physical APIC ID
   to determine whether to use 8-bit or 12-bit mask.

 * PATCH 3/3: change avic_host_physical_id_mask size.

 * PATCH 3/3: change warning condition in avic_vcpu_load()

Suravee Suthikulpanit (3):
  KVM: SVM: Only call vcpu_(un)blocking when AVIC is enabled.
  x86/apic: Add helper function to get maximum physical APIC ID
  KVM: SVM: Add support for 12-bit host physical APIC ID

 arch/x86/include/asm/apic.h |  1 +
 arch/x86/kernel/apic/apic.c |  6 +++++
 arch/x86/kvm/svm/avic.c     | 50 +++++++++++++++++++++++++++++--------
 arch/x86/kvm/svm/svm.c      | 10 ++------
 arch/x86/kvm/svm/svm.h      |  4 +--
 5 files changed, 49 insertions(+), 22 deletions(-)

-- 
2.25.1

