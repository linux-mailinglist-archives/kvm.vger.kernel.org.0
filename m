Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED8F34E5E23
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 06:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245427AbiCXFcy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 01:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346265AbiCXFct (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 01:32:49 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2072.outbound.protection.outlook.com [40.107.212.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D8990FCA
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 22:31:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rujn4K5cVgwecLCKyUY5lzMtVZ96OaP6GPyYRFs2+qb3zHDh6uKaS82ZDqzIVAa7efYBD7HR6DKU/MAVcrMuZlDFB13n8QvmB66gRrvnW/OjxC73XYXHXxxf3XvBiOg7/OsCAVQKTMbzwMo/vQgdOukEivJYBJie6hr2Hw+JU2TFz86U/7I71O3TqyVT/O3OX1phpkkM13oRQOzA8Dltu0kaL+GwsDRos8iED/4Wah681RmIVZdJbd+6EM1qykCm/f3XzNPQTAl1ISpRWmqajCbFcfD27FDdO0N/LvWDvwE9nh3JhSWt4VM4Urw1k3kJZG8HZV1uOHKvFcvB3r0FRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v/wCLGMiE34FRnWvL8kNnKzm9R5SEO09F7Y0I+w7rTw=;
 b=KLk0EPn+KL+bVR+ZVmwhbjC6aWPG/Wlfc6pqt5zbvT8tXttaRRUvCv2+PCC21D+4TgxSR0UPwwffxI1zQkr/HDKrGEbAq13Ed4CIU9nP8nWe6AhK4FxZcffL+oDkxMIrhtyX4JpHZ4MORqLMydjPMDx/TvlZH8GgpzvUmaxnI2PsTqTPGPUrkidC2LzeDGGYlZPplVeZ4GVcABMoKHZvYFxTmbkKTe9rCYq9sOiQW0PWxp/aejfkmUYIRfAFiWzASjlpIB8T2vRzed1eCxutI6X2nZVU4VbfJNhpy/RaJT6OemFU1W3p/AMW6SK/3Kt4VzF1BtrGUt5CoZcruAujgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v/wCLGMiE34FRnWvL8kNnKzm9R5SEO09F7Y0I+w7rTw=;
 b=J1tQeYPJ4x3pJahHgW3cDzR9FIi9mEOlIEUE6wUffUYqDDYrGkXPZW38CG6p8gyEU1BfIBZN9cXFXfpGAjylaK9Uqxo0mDLQvprlXTFhJnGiNHIJPWJG3YbTQ6IrkdQwLX/0nfPiz24OCGINaiG8bP61506GKe/6O9zpOFa49js=
Received: from BN9P223CA0016.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::21)
 by DM5PR12MB2566.namprd12.prod.outlook.com (2603:10b6:4:b4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Thu, 24 Mar
 2022 05:31:13 +0000
Received: from BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10b:cafe::6) by BN9P223CA0016.outlook.office365.com
 (2603:10b6:408:10b::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17 via Frontend
 Transport; Thu, 24 Mar 2022 05:31:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT028.mail.protection.outlook.com (10.13.176.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5102.17 via Frontend Transport; Thu, 24 Mar 2022 05:31:13 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 24 Mar
 2022 00:31:11 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH v2 0/4] Move npt test cases and NPT code improvements
Date:   Thu, 24 Mar 2022 05:30:42 +0000
Message-ID: <20220324053046.200556-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9de92106-b47e-484a-106c-08da0d5782bb
X-MS-TrafficTypeDiagnostic: DM5PR12MB2566:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB2566705BEA2546617A955C5CFD199@DM5PR12MB2566.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cf4i7++KnPttt+ex4Km13/uIXi/3jCse2P7stoX5/jyrIk9tdji6r8BumcV4UndK/CHzkOBl4H2OYH0+s0joXui4bvgv9Bazioq+lqV6knj7YHnLZIwps9sAlo/JHjYO2+lCbq6sdA3NTWwn6ppU3NNdhLkLMTC3iSvm5p4WG62Y93+np72QB5MNQprJ4b27H8PqBkbmC1Jlr1XScESiQSsqJkJXoMJ51isq/zbN3kKDaOEUdiZnp8E9CUmC8fws/FIIu01T5tTJPpbgaWxnDmNl99U4u4zAcDWL7zmKSMJXxS+KhgS7zacWzN6EFEl/Z+HhFXYkF3qXbETLUxz8rYUpXNr5fyNS6TPoekIREgyiSQJTPhqwSK3W90/mVKR/IpN7IYZeY3Z5e4j8zLXqzvGSR+ADSvLkpRtXWU04FiGFo2C3X0n1MhzB5yyphvnR5b4q8/y+i36/LvNpNHrKJrA9Z4okaaJeIEqbjjo6Yz4vn2WPjXLdgmvE354bYOJI3GorWPk1POZpQUGEpQjuf1cUi2QfNm2zxSEpkw9snurQWcXPKO31ONITpWt/xNjeNoOmBEG3kGV+IZTaZQ+jE8J7ci7IEE5BvBMt1N91aqLaXxvRVvc5ooQClo9ZE09WDOkSLh4BpxdjvunVDURyfvVOw8aKi92J9C0kFjXH/G6wC0KFbZmQ4HWL5Fa8vSgKrsGkiQKTMFygH9FO3grqqQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(36860700001)(426003)(336012)(356005)(47076005)(86362001)(44832011)(40460700003)(83380400001)(81166007)(316002)(508600001)(110136005)(70586007)(70206006)(36756003)(8676002)(4326008)(16526019)(7696005)(82310400004)(1076003)(26005)(2906002)(8936002)(2616005)(5660300002)(186003)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2022 05:31:13.2178
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9de92106-b47e-484a-106c-08da0d5782bb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2566
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If __setup_vm() is changed to setup_vm(), KUT will build tests with PT_USER_MASK set on all 
PTEs. It is a better idea to move nNPT tests to their own file so that tests don't need to 
fiddle with page tables midway.

The quick approach to do this would be to turn the current main into a small helper, 
without calling __setup_vm() from helper.

Current implementation of nested page table does the page table build up statistically 
with 2048 PTEs and one pml4 entry. With newly implemented routine, nested page table can 
be implemented dynamically based on the RAM size of VM which enables us to have separate 
memory ranges to test various npt test cases.

Based on this implementation, minimal changes were required to be done in below mentioned 
existing APIs:
npt_get_pde(), npt_get_pte(), npt_get_pdpe().

v1 -> v2
Added new patch for building up a nested page table dynamically and did minimal changes 
required to make it adaptable with old test cases.

There are four patches in this patch series
1) Turned current main into helper function minus setup_vm().
2) Moved all nNPT test cases from svm_tests.c to svm_npt.c.
3) Enabled PT_USER_MASK for all nSVM test cases other than nNPT tests.
4) Implemented routine to build up nested page table dynamically.

*** BLURB HERE ***

Manali Shukla (4):
  x86: nSVM: Move common functionality of the main() to helper
    run_svm_tests
  x86: nSVM: Move all nNPT test cases from svm_tests.c to a separate
    file.
  x86: nSVM: Allow nSVM tests run with PT_USER_MASK enabled
  x86: nSVM: Build up the nested page table dynamically

 x86/Makefile.common |   2 +
 x86/Makefile.x86_64 |   2 +
 x86/svm.c           | 169 ++++++++++++-------
 x86/svm.h           |  18 ++-
 x86/svm_npt.c       | 386 ++++++++++++++++++++++++++++++++++++++++++++
 x86/svm_tests.c     | 369 +-----------------------------------------
 6 files changed, 526 insertions(+), 420 deletions(-)
 create mode 100644 x86/svm_npt.c

-- 
2.30.2

