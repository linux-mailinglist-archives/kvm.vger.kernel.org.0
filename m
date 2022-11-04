Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F1C61A36A
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 22:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiKDVhK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 17:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKDVhI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 17:37:08 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65AD4B9AC;
        Fri,  4 Nov 2022 14:37:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gXQz4wJcFMhm+XbX6kuGOd6z2nkVX656Wxv6fnZvPU4MPWolaEGtCGtlwfFmZ/TPqLx9u9AQfA5GK+CKiXbrM0eNmMGW4Zz8PPH0j3zJuWstxQON1x5d/mSJCw5ZNLMmRwz4MxDM6JAGyrKN1xbReisbPgDAiKj6+/yuPTmxsZzIGeQi2UZ2nv/bKP2bQIgzf30c+dyN7q/O0cu+3WLvs4pymPw5+xxnLYAzwPKvhwXc53IUhT6nHbYnIoeAu9MqLX42VIGrCVy5ULkWLu2ZQm8PkQ49ehD4WBqcdCPKKvzavjTQ40yNmWy76T2lKujp/Xmjc1U1cm9UxUKrwcB5Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mZYg4i/WJH1ABcoeA3PnvMIttJ4rftZ9HeHG7TVdb68=;
 b=WS64Y1XRCpvwMQkOFvcXsVtRXPWRiKppNEPUhownto5Ie750EKwNeYHsV6HYP7cp6ySHjC0vaIZRC3fkv24vYAsvYIzugregyRJy35mdfp/rZQGYMKUjDLu1RxfIR4tEjqpv3QVxtAiPy5PD2t0ikyCgRZ5pfCCybXM8wyMVSu/rd8mzgIjvjSuNSR9LG1eUDLwI1HibS+ldmWK45BT5wKyiGHIwfierdZda3s44dnA/SwpUC0wVGdH7wh1eWbyr1R/J8y3pSeegIYfGFedQ/Dl2h0ok6XscswKlwoHFcNFosjNGEVlDaE5Z0e1tEjYHvxlMNZO9TZl+83L/XdLF+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mZYg4i/WJH1ABcoeA3PnvMIttJ4rftZ9HeHG7TVdb68=;
 b=07+dUSQsczQpsIWkof19X2EvQNdHke9Kg7ZI7/h2aqWeuauadD75oSigmFbRvc6denr5tYnZ1KnQWsOnV1XFKq/sHh7KuTUabRLMf54dvqdsZx+U3kufqogNxkNZUA42Q7BgC4FDuWQ8wbv/JAyBIhGeoJFMY6xH0Rp5Cy7F7bo=
Received: from DS7PR03CA0270.namprd03.prod.outlook.com (2603:10b6:5:3b3::35)
 by DM4PR12MB7600.namprd12.prod.outlook.com (2603:10b6:8:108::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.20; Fri, 4 Nov
 2022 21:37:03 +0000
Received: from DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b3:cafe::ea) by DS7PR03CA0270.outlook.office365.com
 (2603:10b6:5:3b3::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22 via Frontend
 Transport; Fri, 4 Nov 2022 21:37:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT015.mail.protection.outlook.com (10.13.172.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5791.20 via Frontend Transport; Fri, 4 Nov 2022 21:37:03 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 4 Nov
 2022 16:37:02 -0500
From:   Kim Phillips <kim.phillips@amd.com>
To:     <x86@kernel.org>
CC:     Kim Phillips <kim.phillips@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] x86/speculation: Support Automatic IBRS
Date:   Fri, 4 Nov 2022 16:36:48 -0500
Message-ID: <20221104213651.141057-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT015:EE_|DM4PR12MB7600:EE_
X-MS-Office365-Filtering-Correlation-Id: cf8102a6-ed9c-4afb-c2fb-08dabeacb6e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T4i4Seu+szmCsvMTYtPm1SyWxigqFa3db7MYsvgMe61isur0QNOwg2Hs6U6rXrShq8lnhRJc1lqKCYxUNSjb6iFiZ2J/mK8nMupzBPuDsMDd2GJs5910/JZO8anWvCKUwDpNd8rj6sGWsC4a20i48jqW7hIMnWrKtL9TpVhiPXJACnMBCx8sMI3LHyJTfSqBY8an5OM1yrWW6oesKJRIlqb/Or3KrdtxG8BgiLKPlJzC343vuv/KjxdTEEd2mGneTEt/nO/NknSzyRBuhHxueKSPWbnkmgVVCG3tZ+B7lbwY61jKZXiL8wofxWIyhuC0Mdm/POLAL5LOetRBeLOndDuFWEf8L3Kp258bfdkGBnwZKp3yvBXN6zE82d5WIoy032c720MHSICW3HDP8kLNJyj1Mghy91+XEtZ7Ufk5+s/8jjlD45kl8Gw54rUsWZRl45q/3XEsOqpEhmFTzmhSAIMq03ovmVXSUfilwhOhjIyWZ1/+CCcQE9qpryZDOv2+eGl0/dSsUp/iTjjUuTG9fkLifNJu1yMKMgG7hRP98s5XlQRs/jV7rVuLv5BuC9gtWT6VQdyyIv1pTUPeeVXpXrMwVfDwhL5UidcOlkvplR1YKDVLj1zxhP0UNw7NshDdXBPcVkYV2KgzqRd460wA4nNlPh4egMtZaMHkE3ZPcJikDVPHjH3eL+Kd3llOQNU8TiKXcyrMU6eXpK+NfOhhddau4aHv7yEIuc1vD6iRWrvX4UzEe6+p7g5LRYBc9HsG7Yu/3+tyfJOpCkGVgMDMzzes46bRXA35LGpUVOudqJg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(376002)(39860400002)(136003)(451199015)(46966006)(36840700001)(40470700004)(26005)(82740400003)(83380400001)(47076005)(70586007)(7416002)(36756003)(16526019)(1076003)(40480700001)(186003)(2616005)(2906002)(44832011)(336012)(8676002)(41300700001)(4326008)(36860700001)(70206006)(8936002)(5660300002)(426003)(86362001)(40460700003)(7696005)(478600001)(82310400005)(6916009)(54906003)(316002)(81166007)(6666004)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 21:37:03.7532
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cf8102a6-ed9c-4afb-c2fb-08dabeacb6e2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7600
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The AMD Zen4 core supports a new feature called Automatic IBRS.
(Indirect Branch Restricted Speculation).

Enable Automatic IBRS by default if the CPU feature is present.
It typically provides greater performance over the incumbent
generic retpolines mitigation.

Patch 1 adds support for the CPUID_8000_0021_EAX leaf
that has the bit that identifies X86_FEATURE_AUTOIBRS.

Patch 2 adds support for Auto IBRS.

Patch 3 makes the Auto IBRS feature available for VM guests.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Juergen Gross <jgross@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Babu Moger <Babu.Moger@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: kvm@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org

Kim Phillips (3):
  x86/cpufeatures: Add support for cpuid leaf 80000021/EAX
    (FeatureExt2Eax)
  x86/speculation: Support Automatic IBRS
  x86/speculation: Support Automatic IBRS under virtualization

 .../admin-guide/kernel-parameters.txt         |  1 +
 arch/x86/include/asm/cpufeature.h             |  7 ++--
 arch/x86/include/asm/cpufeatures.h            |  5 ++-
 arch/x86/include/asm/disabled-features.h      |  3 +-
 arch/x86/include/asm/msr-index.h              |  2 ++
 arch/x86/include/asm/nospec-branch.h          |  1 +
 arch/x86/include/asm/required-features.h      |  3 +-
 arch/x86/kernel/cpu/bugs.c                    | 34 +++++++++++++++++--
 arch/x86/kernel/cpu/common.c                  |  3 ++
 arch/x86/kvm/cpuid.c                          |  5 ++-
 arch/x86/kvm/reverse_cpuid.h                  |  1 +
 arch/x86/kvm/svm/svm.c                        |  3 ++
 arch/x86/kvm/x86.c                            |  3 ++
 13 files changed, 62 insertions(+), 9 deletions(-)

-- 
2.34.1

