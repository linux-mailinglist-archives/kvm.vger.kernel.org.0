Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0246636EAB
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 01:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiKXAFP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 19:05:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiKXAFO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 19:05:14 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2047.outbound.protection.outlook.com [40.107.92.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7DA91095B0;
        Wed, 23 Nov 2022 16:05:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JYhZNgHZZQXRH6S15PcrdbaVmYHqzFlpuyoJC4rsqbhGlPoRyUqAJIbfLhm30C9w+43WqUj/cnZsDaBJnVPXwIM0XizC4qSDVKaXJWSKJ9bbfeA8BsRbeNn3JpcVulg6gXzcHf5KWvU9HO0baxqnD+1u4ni9vy1QzgXfeahI9yOsIAJFGxkLVsJzil+VCwaEH4e/inFW88x56XkKCQSDFIy26ICXP5Gvo3HcS1e3+pSzu9C4CV2dI9bLHwkCHj+rigIBDsr4LZIwwsKNFl813PMbTDBVLUW7rHjALrUChk0QxRlx48tHO5IWD03QbWw1LGZvZmvobYuMz92jheppGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ls0dPisZ58tZFHFLr1d8pg0l4ciXYIZa0PX1DhS/Bqk=;
 b=eKEwA2jDgolzZlP2VkWQLBgtUNIYBw8/YRILo36DzTeeWIOSBmg5UwmttCrjYViXFdjIJh0E/JPi4MB8JUgc6zNsv8FNxJ7iuyyfRfm+/hqoqW3fYI9frWV5MnzHg6dc+a4nhRtjpaIO7O5tcbN30BkWVCv1GOZSeMkym7GBQfYvluKAjS2BmN6+04fzoO/tJKP21sHiowJ1/4+PZMz7Qvr2olLhXP1pCYIdeNoP5fBZE46JCCcSVeQCBcHv+bPkyTwBBdOWQou2mIHIWKnlf/fdwmwvR4TJBFtLj2X7mu7lb5VU53xo/X8RX+Yl+Bvh2kCE4j5odls8LJ8e5gC95g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ls0dPisZ58tZFHFLr1d8pg0l4ciXYIZa0PX1DhS/Bqk=;
 b=j2opVBiI8HNihMKOoLlIfGvUlfGNe0Epkc+Z6bhsLBCeb4RYjiESYRS9Z6u76c1SbZ+IxuCuLlY0o41TGo4PaEy2LV+XdKA7gFUcZBIyJeZsYTzH7Y4YxG88tyLU+LqnlrAaXEf/1qIIqEVSNuYMvssTS42gNwN0WT74Udz6hu8=
Received: from MW2PR16CA0070.namprd16.prod.outlook.com (2603:10b6:907:1::47)
 by MN2PR12MB4550.namprd12.prod.outlook.com (2603:10b6:208:24e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Thu, 24 Nov
 2022 00:05:09 +0000
Received: from CO1NAM11FT083.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:1:cafe::c6) by MW2PR16CA0070.outlook.office365.com
 (2603:10b6:907:1::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.17 via Frontend
 Transport; Thu, 24 Nov 2022 00:05:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT083.mail.protection.outlook.com (10.13.174.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5857.18 via Frontend Transport; Thu, 24 Nov 2022 00:05:08 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 23 Nov
 2022 18:05:06 -0600
From:   Kim Phillips <kim.phillips@amd.com>
To:     <x86@kernel.org>
CC:     Kim Phillips <kim.phillips@amd.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/2] x86/cpu, kvm: Support AMD Automatic IBRS
Date:   Wed, 23 Nov 2022 18:04:47 -0600
Message-ID: <20221124000449.79014-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT083:EE_|MN2PR12MB4550:EE_
X-MS-Office365-Filtering-Correlation-Id: a0bd5f69-2ecd-4816-ccc1-08dacdaf8c7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aodgq29ArpU/6XpuZ89yeFOlY4Qre7tyMpJl1o86XmkLGzEej1slS+kwZ58NJaGcjcHYgZnXFu9+e9giSL/I2aBRmrRiOO7Mn/pOt4xvcRVJhS34jT+467qWYy6FR4nfbFezCvcPKoIN3rnyoew0t5HHZCWHUCE/5JeLJ3adF0Qq+LmsbumpbSutyqik2Ht2y9oAlqP6BJ0z+w1JUrvuEYFXsUzkEqX60CnlrB3IH/Jz0R9nq5To/OdgHbPVFo+unihtSO4OelUH4l34QBFdPfWVC4chymp0yUVo25YQszq3Wkzdg4ziD4s6xZtt4eOUc9rwGtwZ/wbgUr7e+k8Wict/z9hgSasPSTGj5vEtN6h8ccB30fQH8BPX+BCmceD6thgTpTwHSLNxJrhsihZVD40q8yP8oJOqnNUpOTdExQ2Eetl7aY+QEAMUQuZa75JSkRUXvNzM5lD4Jqie4p5hFthyBPpV+mAbS3+GccXhLZed2PhBiJZUogtfsJkZ7N2jPrC/gb4/9ujCKx/4oBWHTrIBEgUkNOJmUz6SWehvK0MGlAUBjLq2G0uSftFKZkOEqBloit/oslsRurebdNG0ClzXu8BwAgNvx6/EcmyXc/TopmkD9A8I9k/2iV0UOYgQbZlk3G6i8VcZynh+A3ew4ojj0URmSIxDq0eQcSDONMik7/4XiF5U7AJ0qHCrRj4gGxPORi3ksXVAs8IAKFkDJ18+3dOjzQoBENGNPLXwDh8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(376002)(136003)(451199015)(46966006)(36840700001)(40470700004)(41300700001)(7416002)(8936002)(5660300002)(316002)(8676002)(44832011)(70586007)(4326008)(70206006)(54906003)(6916009)(7696005)(36756003)(26005)(478600001)(2906002)(336012)(1076003)(426003)(16526019)(2616005)(186003)(47076005)(82310400005)(86362001)(40480700001)(36860700001)(83380400001)(356005)(81166007)(82740400003)(40460700003)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 00:05:08.4366
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0bd5f69-2ecd-4816-ccc1-08dacdaf8c7b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT083.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4550
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The AMD Zen4 core supports a new feature called Automatic IBRS
(Indirect Branch Restricted Speculation).

Enable Automatic IBRS by default if the CPU feature is present.
It typically provides greater performance over the incumbent
generic retpolines mitigation.

Patch 1 adds support for AutoIBRS and other feature
bits in the CPUID_8000_0021_EAX leaf.

Patch 2 adds support for AMD Automatic IBRS

Co-developed-by: Babu Moger <Babu.Moger@amd.com>
Co-developed-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Cc: Borislav Petkov <bp@suse.de>
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
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: kvm@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org

Kim Phillips (2):
  x86/cpu, kvm: Use CPU capabilities for CPUID[0x80000021].EAX
  x86/cpu, kvm: Support AMD Automatic IBRS

 .../admin-guide/kernel-parameters.txt         |  9 +++--
 arch/x86/include/asm/cpufeatures.h            |  5 +--
 arch/x86/include/asm/msr-index.h              |  2 ++
 arch/x86/kernel/cpu/bugs.c                    | 23 +++++++-----
 arch/x86/kernel/cpu/common.c                  |  8 +++++
 arch/x86/kernel/cpu/scattered.c               |  4 +++
 arch/x86/kvm/cpuid.c                          | 35 +++++++++++--------
 arch/x86/kvm/reverse_cpuid.h                  | 24 +++++++++----
 arch/x86/kvm/svm/svm.c                        |  3 ++
 arch/x86/kvm/x86.c                            |  3 ++
 10 files changed, 82 insertions(+), 34 deletions(-)

-- 
2.34.1

