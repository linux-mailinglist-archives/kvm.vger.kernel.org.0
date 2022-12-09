Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 557DC647CF3
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 05:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiLIEin (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 23:38:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiLIEif (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 23:38:35 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2053.outbound.protection.outlook.com [40.107.93.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA123E0B0;
        Thu,  8 Dec 2022 20:38:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QhDZNSc4fuwnmJ5lYEDZ2i3riVDmRUKbZXd89Pj7KfG8Rc+2lJwIZWA/F3y4WN0q2DQBrW0Vk5Ni4XGgbL6cXytfS2ndS132vxyGoTnp9R7mQhF6+8xwPmOxLhz0lupLb+ltcpDl4FR1U6/pO8VJARQokhBrj9y5dbye0k8q6RI8oRvcEm3MQCwbMLW1MfEsLMCiuoiXPZW/3XH1dQnehr/4aCZyRmKGGjFnfsMCorH4Xw9H1QSTcAcBkGvjA//9RBrvAZg4NBHQbA346PWDkKRuHdHMzRWPSyFbyzyXyvpdUzDglCXYCyid4NPWU+NeJtkKTLO+hGzM8LygIcAECw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VdlZe05nU8Crrvr83KOBXIoCYd2qtjNfOi6T50WgvW8=;
 b=E3peOaxGkQHZQC3XTfd0lYaK05EHM/FmEa2enCvy6K5wkr5rwNCMEEjrJoxlWk1s8d9qX4ZhlwZrLv8EBEJevcHdneLLGDuGFjGSHctWNaCWm5cKeX89iftF903oiSOQBvPfmuYVG3y7+DmOVM9YHJhNLeRphglLuY2EyJN7woM9OAqNuAB5fvsms5SVSWdulLKUzmovDGl2VgBkMDTnY2wu3Acx3o2YglWWUcRZbgkYM+U3emOeCDj5DgUYr/AQxQvxSIjJtc9vv72JObl2tyE0NyCccSIa0psjiz8tvODZdbLxoZRWFermi+szvTkiyAOPjEZc7d2onY3xSkv1FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VdlZe05nU8Crrvr83KOBXIoCYd2qtjNfOi6T50WgvW8=;
 b=Jvp5UabHsipA6nQzVIRZoIF7L6VqAzOh0kWJOyxbjvsJ7metTYPQ1nOXETQhG/Kjz1TW32AEplrdx3rrInB0rWJY004jjrY/6PookJOqeWT6QYcOCOZ3heCV4R083+FlHLI1tHgaMLxW5HHP7xC9OQ/3cyKhTsA38vkkj+Nzh6Y=
Received: from MW4PR03CA0184.namprd03.prod.outlook.com (2603:10b6:303:b8::9)
 by PH8PR12MB7230.namprd12.prod.outlook.com (2603:10b6:510:226::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 04:38:33 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b8:cafe::60) by MW4PR03CA0184.outlook.office365.com
 (2603:10b6:303:b8::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Fri, 9 Dec 2022 04:38:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5901.17 via Frontend Transport; Fri, 9 Dec 2022 04:38:32 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 8 Dec
 2022 22:38:19 -0600
From:   Alexey Kardashevskiy <aik@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sean Christopherson" <seanjc@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Huang Rui <ray.huang@amd.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexey Kardashevskiy <aik@amd.com>
Subject: [PATCH kernel v2 0/3] KVM: SEV: Enable AMD SEV-ES DebugSwap
Date:   Fri, 9 Dec 2022 15:38:01 +1100
Message-ID: <20221209043804.942352-1-aik@amd.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT018:EE_|PH8PR12MB7230:EE_
X-MS-Office365-Filtering-Correlation-Id: e52d3211-cbe9-4ef0-3e55-08dad99f3a68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1SjJqiylt5jz37T87DAZCgk5mah8Q5YlaIRXzOY63ITZjFKYjZS3mGD0nYNlZ7ylTKILTU75/EkIyRIWnqDwHfrc1ry4jA/mKuh1INu4Es1JNzdt3AF45jAwuuwBKHER2aGEcsdFShuF5bGuB+bVfsimOwfSXXORQOI+KTksu+lJ3Viadf2C5KkdI0TQzu0O23j7fe0EGmlQiD20nVatAc2TE6/WSzGrGv36AcPc/sNB8D0evSMjVwhl81fjPX23kGKiAw+IEGteABls4j7bFltpqCOj/fE8nC+yF/lRyPstVDYOaIT3ZoRfsxLn0wMneNWbIUYq6UlQImvAIlW3zI432v7htlENFEOxxPpCEhsh39EE+OFtwbI+Y/xTD5Am3TcGm6f3U1sQzmso75Ijor39eVUoV+CCheW6UmGMlBXGZGrFa86E98JCYZUgtXxKaWoA40FbyJwsidbs6SUJJjd4Amw2wfHCf5KAgg+cGOUzkf7T3YOfPHgX/atErI/ufzSdEGXu1VK967EzwrBMH1Wq2TsXIwaVDPT5yw1lv8Drimm3dTs3cLET9kdthsWtQI3AGPciGHxcJgGmiUNrBqj43Xj2lI+Wxjes1XBCdSEMGj4YOAENBj86/+nHf6NFl5uR2ZdTk1r/WKU9//4EyPA5s0luPvzMbU5xngHHOq1zUDGPW2imRYQMsrMoPiMyZzPGIWX6AFtqYrScHdGdcrNd1ScuY7mRO3UFTdaMKB29QCb0oPcOrfsoSvWDjt8JF3wWFAe8ymB+V2oHC5qaQBsnsmFGdz9d0eHRmz09QZacUmSlgmYLkcBS35Z22UTf
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(346002)(376002)(451199015)(40470700004)(46966006)(36840700001)(83380400001)(36860700001)(70586007)(356005)(2906002)(81166007)(40460700003)(5660300002)(4326008)(26005)(47076005)(82310400005)(8936002)(6666004)(8676002)(40480700001)(186003)(1076003)(16526019)(426003)(336012)(82740400003)(2616005)(478600001)(6916009)(70206006)(966005)(316002)(54906003)(41300700001)(7416002)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 04:38:32.7565
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e52d3211-cbe9-4ef0-3e55-08dad99f3a68
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7230
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is to use another AMD SEV-ES hardware assisted register swap,
more detail in 2/3. The patches are fairly independend but required in
this order.

This is based on sha1 0d1409e4ff08 and requires something like this
for X86_FEATURE_NO_NESTED_DATA_BP:
https://lkml.org/lkml/2022/11/29/1229

This patchset is pushed out at
https://github.com/aik/linux/commits/debugswap


Please comment. Thanks.

btw the enormous cc: list came from get_maintainer.pl, keep it like
this or tell the script something to reduce the list?


Alexey Kardashevskiy (3):
  x86/amd: Cache values in percpu variables
  KVM: SEV: Enable data breakpoints in SEV-ES
  x86/sev: Do not handle #VC for DR7 read/write

 arch/x86/include/asm/debugreg.h        |  9 +++-
 arch/x86/include/asm/msr-index.h       |  1 +
 arch/x86/include/asm/svm.h             |  1 +
 arch/x86/kvm/svm/svm.h                 | 16 +++++--
 tools/arch/x86/include/asm/msr-index.h |  1 +
 arch/x86/kernel/cpu/amd.c              | 45 ++++++++++++++------
 arch/x86/kernel/sev.c                  |  6 +++
 arch/x86/kvm/svm/sev.c                 | 29 +++++++++++++
 arch/x86/kvm/svm/svm.c                 |  3 +-
 9 files changed, 90 insertions(+), 21 deletions(-)

-- 
2.38.1

