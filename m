Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F16466E16
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 00:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377717AbhLCACu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 19:02:50 -0500
Received: from mail-dm6nam10on2066.outbound.protection.outlook.com ([40.107.93.66]:62688
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1377696AbhLCACq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 19:02:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h8duSyxvdp2msB6HmDtDoMvUr5pRF6SkkdTA+k6caxz5haX7aLW6/Vfplt94l19g9N2Ax376khGhXNZJc+ASzmkMeD3y/Y3H3TQK0IsncXAvSJG/Ho/0kne+EneG1TneQfzHoWh0IKpU1O5T8MwNsZMZqGP0UQdLDsI5LmRiaNZnbEHcpx8NFFBK9PIJFQxgCivSwq64ZrYbBfMK0wHo0nSM6X9LFjHaO1CxkiWiSU7+oNjePa4/zo2tn0uDtbLNUV/gTLdSWR9a0z/NgD4pwm6kjuFQaz0QkzFQD99zO8iuHbOaNuN/TYMWZMiFuy7I0/YBlRo4aK/C7PG7s0pQiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RYrcdxL/0Nmp4KpM+BbFq2Viz+0j2qsvxaFq4m+huW4=;
 b=YjteR9akQKfhDjbfsaHQylfLikTKEV4ZFSsN6h9u9043AcBcTjhlaBUuhl6LUktekHx3MVxhS7wVcZPuLzkxN75j6yLJ/b5ZfdcBqd1Yt1wSxVy6mDJ5vyyno0JFySRaf3jA+vpIiwl15Qj7/VYYUK4zcJJvSx3AxKVuOnyXr4FAeO2b+2kjqwrzfsyQV6tTFEdT1Z79+pg/LdE6itslQpiq3PjbcK1E20AnKRBtUUBPgu+ldRyYF6hQIqotDFmeUNFE0fAuyG0QZI4UN7I/Z27YgPbegkq4mCRJ+XJ4Jkl2lsxxKDoRIxrTB0JXniRA4ARxMcpl2XRM+4gf/nuXtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RYrcdxL/0Nmp4KpM+BbFq2Viz+0j2qsvxaFq4m+huW4=;
 b=Fpbh806Scq3z2XxxySFWISlrcKk8Iar4WsCR1LDqV8OWpOTr+HzdJ4Z+TScFqWmDb5EpsMFljdCkXIUuSbRDHO+PPna13f4+8ZJ6zeN8jNK/fY+0x6UISBubHZm0GCEVGSAf40X92d8kHVey/DgbAlWV6RbL1T5ZuwgKaI7bdVA=
Received: from MWHPR17CA0086.namprd17.prod.outlook.com (2603:10b6:300:c2::24)
 by BN8PR12MB2897.namprd12.prod.outlook.com (2603:10b6:408:99::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Thu, 2 Dec
 2021 23:59:18 +0000
Received: from CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:c2:cafe::b4) by MWHPR17CA0086.outlook.office365.com
 (2603:10b6:300:c2::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24 via Frontend
 Transport; Thu, 2 Dec 2021 23:59:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT015.mail.protection.outlook.com (10.13.175.130) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4755.13 via Frontend Transport; Thu, 2 Dec 2021 23:59:18 +0000
Received: from sos-ubuntu2004-quartz01.amd.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 2 Dec 2021 17:59:15 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <pbonzini@redhat.com>, <joro@8bytes.org>, <seanjc@google.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <peterz@infradead.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
        <jon.grimm@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v2 2/3] x86/apic: Add helper function to get maximum physical APIC ID
Date:   Thu, 2 Dec 2021 17:58:24 -0600
Message-ID: <20211202235825.12562-3-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211202235825.12562-1-suravee.suthikulpanit@amd.com>
References: <20211202235825.12562-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20121b59-ff1e-4c27-bcb9-08d9b5efc0bd
X-MS-TrafficTypeDiagnostic: BN8PR12MB2897:
X-Microsoft-Antispam-PRVS: <BN8PR12MB2897A38CFFAC5836A5E44C71F3699@BN8PR12MB2897.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i2ae/Kmb+gXcTamGnOchYMx4de3p3nbU2puQqNZizFK9/7o5MysmlWOy21xBATzyqxi7cSlFKKyGbd43r9+7DoV8hR+Pnh5isg/piDPYs9XHVHmlIjznlgRqPkKB1llxQfS1HzFSda4rt9c9SNS9A1H1+sFr5TkcIaL4SpCdUfAjSkHEkoWSdkI037HBz1LCktDMtLRLeFBZwfVOXPWsF2Kn6RaBhRIRfJ39W1H0qgipfO0leIx3E92ugAstkp2MZzOqggIMbh01wEpIXimxS9mfDFjkYWYHXOZ94/IYCjvxXn6MXXQ16BqgAFpg1wq+7xBixhvJsg+WMSUnEMyTnDTysoiZP9F18QyrWFNFKr3BZVyp5qxACRB1yVconPMIJcn3ycX5i+1WGanfSmcudklQu5adfFUemrTV46OoIUyjnZyyja9GlKmeyExf6ZWMeJ4bBqUxlfOWrgOKuy3EDfISN0IkrNkR2fja7KLhdGwSRn0JlbgXgyFvYZcBv+ZthWD5zF9USJeuaiXCTwOjDNKTrQDf4pLXEAftZ0TU/UYpPCkLhImtTGTi6cvGEFMplZSsm25XEgYZvE/CBC4ZxvZNdqO/BbK34xhH5XM1qM/4CTmkwu+DFmytt/MkmqbYnT69fmkAzacbaOR6+uPao77Oq07LX4fh+nyeQ5mvvOaxbzJMFXB6B1MUCLPnZlP9eUeg/h35L1H+xU1h8dj0Q/jtVnZYqfcXBqzyn2qBCsGuPv2LSLIkckj9lbCKC4Xa5oaNxy0KM5lpQ0SIKLy3vRx/gepL+wm06WSuJVK/wcM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(70586007)(36756003)(426003)(316002)(6666004)(70206006)(2616005)(47076005)(86362001)(7696005)(82310400004)(336012)(7416002)(1076003)(508600001)(36860700001)(8936002)(4326008)(40460700001)(2906002)(110136005)(81166007)(356005)(44832011)(54906003)(16526019)(8676002)(26005)(186003)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 23:59:18.3465
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 20121b59-ff1e-4c27-bcb9-08d9b5efc0bd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2897
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Export the max_physical_apicid via a helper function since this information
is required by AMD SVM AVIC support.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/apic.h | 1 +
 arch/x86/kernel/apic/apic.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 48067af94678..77d9cb2a7e28 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -435,6 +435,7 @@ static inline void apic_set_eoi_write(void (*eoi_write)(u32 reg, u32 v)) {}
 #endif /* CONFIG_X86_LOCAL_APIC */
 
 extern void apic_ack_irq(struct irq_data *data);
+extern u32 apic_get_max_phys_apicid(void);
 
 static inline void ack_APIC_irq(void)
 {
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b70344bf6600..47653d8c05f2 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2361,6 +2361,12 @@ bool apic_id_is_primary_thread(unsigned int apicid)
 }
 #endif
 
+u32 apic_get_max_phys_apicid(void)
+{
+	return max_physical_apicid;
+}
+EXPORT_SYMBOL_GPL(apic_get_max_phys_apicid);
+
 /*
  * Should use this API to allocate logical CPU IDs to keep nr_logical_cpuids
  * and cpuid_to_apicid[] synchronized.
-- 
2.25.1

