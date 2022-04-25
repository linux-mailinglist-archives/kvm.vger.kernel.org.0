Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E11B50DF1E
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 13:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234714AbiDYLrs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 07:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234318AbiDYLrq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 07:47:46 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D629020C
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 04:44:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TIl9JRbA5QbxBWR5aBiHaIzHJ1iY+BKuejQKOsJcG57g9cpmhQ9D5ZLr6QDjgNdkCuWOESyGIBSrye5IpBz+4WaVvm7mXgQbjLqWGAXvLCDoEVhAS3JWHsCs+Uh6+ayOx6Q+2VqXZ+XNRAzoivv/Q996DJ1Qe5s1K+gPUk24lSJxqoSXn08a3wSteH34cLT0PO3DnKOWgSEWXRryzWKgMHq3hoN6EnV40lPoIJG1e9e1b4mcGw7YlbrtoIK568sox0lYPflAu/kTwVE6pPri7qtDhwh5FqvZGZibCHkAnW96mzY9to772iEBrRBiB3qApufKbJjLvX0CApbkRbu0Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ADTLG5tG7uJpjS14F/IZYUqvWRDe17IQGeUfoeHinIg=;
 b=DGDLNUzbFhG+BkkTgqSs5Q1DT8hAlfkA5hlS83MlCNpPzjeh4KPvI9Roq04r71DWLulAtNJmr3woiZpd4NCbN9VTr7asEx9tjggBOJR+ClblUQql4FOqBA5+R9vNxdsuBZZeioLW+PeSnYRUsiptu+xfbec/6fnsn7JUWoNECKSQ8t+vvvY6XWkKpAlT1cHxvkcv8uH8xZkQZ4wQAidTfkgrLxXI4FBKyZw7RP/7+44afrm1/hraJIkJ6945kxVxBrkNjDhK/rMbXEMcvqLISG5IXSAXwZ6RSu0JJNQ39f1+1TDdb8LCWRF35GCLNYFHQqDd94hMZjZ0bUew1WlBUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ADTLG5tG7uJpjS14F/IZYUqvWRDe17IQGeUfoeHinIg=;
 b=Qhm+VDhbUhge3vKnuaTKCoMM6eqDmOFbwix0XMQu7sf+sAb8GxAXsqeHF30rvCP2K/XFM/LU3UvaP4I1IA8SQB5iWbZCOjCd6fnk5a7FCgYIiIF0pSzAHPweoZRUS+ta8NrfoXzaB/wuziTPvqyi8nY4TC5YldALYRibLxxjbM0=
Received: from BN0PR03CA0019.namprd03.prod.outlook.com (2603:10b6:408:e6::24)
 by BN8PR12MB3234.namprd12.prod.outlook.com (2603:10b6:408:95::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 25 Apr
 2022 11:44:38 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::30) by BN0PR03CA0019.outlook.office365.com
 (2603:10b6:408:e6::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14 via Frontend
 Transport; Mon, 25 Apr 2022 11:44:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5186.14 via Frontend Transport; Mon, 25 Apr 2022 11:44:38 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 25 Apr
 2022 06:44:36 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests RESEND PATCH v3 0/8] Move npt test cases and NPT code improvements
Date:   Mon, 25 Apr 2022 11:44:09 +0000
Message-ID: <20220425114417.151540-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02f82e65-a74a-4ee7-8120-08da26b0fa86
X-MS-TrafficTypeDiagnostic: BN8PR12MB3234:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3234E3CFDAA62C5FA0447733FDF89@BN8PR12MB3234.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0brFVNlJuY1nfPDjbOSsr6iPwmgh4/Dtz/gi8y88xEZD9p9mLTXI3LDe4rH5Z/I2zG0L7yC+vU/tbP8jdoslPRiLSh9Rox/RsV4mXm8GeaUbZmSUCLsNFmFHXQUggLgkUgr8JTqgh55Lt/o8oYsG9A/UGfVS+kHQx0qTGsu6YJ4swKQRW788I5ntsVdzV01VsZsP6RYy63Xb/zhNh3ppLl1APhwG3Fp5lfRPa2VvOfolod83xATcjYcf4QaThTDdCwkejZnhesJfXh1hyDhdQCLhGb+U73cH2FJ7rqBemEcyfnlXiTqZf7vMUNwTZ6CMZkRq4SGQCkMmsnDeBCzvgeeJMZjD3I6jGrAcFs98J8678MNGevM5dPLKZ5tkfRLXK1qEn0u00tf68CoQsGTMRk17qmMBAPphZdAxKh1OuluSU/iyN84S8SQt/t/24zObAYaWBTWttDqdGOAR5hZX7QmpC8NUFs9K8AUf87kY2gfAuQRXfx4ulOfrfMDD8eSVuL/WqrUWGt8N1YH+FBqYNQH0lH8SQpnhYnUEBCZCgWdNF/z64YTGnByXuI4WgCL6S1wGbL2Mr3wt6aBv0ICQHng4tMK+qeGK+FFvJfftrK83IPepYkJ0lLMkXUo76dlynTCD2I9rRhK9HqHuceFGQPH2PaGGRMpHK7QXGc1lj2mYsBYYRHro55aqwe/KdGHW7ZmA1PX9M/IYYC2HrWUrww==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(36756003)(508600001)(70206006)(2906002)(70586007)(356005)(4326008)(44832011)(8936002)(6666004)(7696005)(110136005)(5660300002)(82310400005)(26005)(316002)(86362001)(81166007)(2616005)(1076003)(16526019)(47076005)(36860700001)(40460700003)(8676002)(83380400001)(186003)(336012)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 11:44:38.4940
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02f82e65-a74a-4ee7-8120-08da26b0fa86
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3234
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If __setup_vm() is changed to setup_vm(), KUT will build tests with 
PT_USER_MASK set on all PTEs. It is a better idea to move nNPT tests 
to their own file so that tests don't need to fiddle with page tables midway.

The quick approach to do this would be to turn the current main into a 
small helper, without calling __setup_vm() from helper.

setup_mmu_range() function in vm.c was modified to allocate new user 
pages to implement nested page table.

Current implementation of nested page table does the page table build 
up statistically with 2048 PTEs and one pml4 entry. With newly 
implemented routine, nested page table can be implemented dynamically 
based on the RAM size of VM which enables us to have separate memory 
ranges to test various npt test cases.

Based on this implementation, minimal changes were required to be done 
in below mentioned existing APIs:
npt_get_pde(), npt_get_pte(), npt_get_pdpe().

v1 -> v2
Added new patch for building up a nested page table dynamically and 
did minimal changes required to make it adaptable with old test cases.

v2 -> v3
Added new patch to change setup_mmu_range to use it in implementation 
of nested page table.
Added new patches to correct indentation errors in svm.c, svm_npt.c and 
svm_tests.c.
Used scripts/Lindent from linux source code to fix indentation errors.

Last patch from this series was bounced back due to maximum characters for
patch was crossed, so resending the whole series again by spliting the patch in
multiples.

Manali Shukla (8):
  x86: nSVM: Move common functionality of the main() to helper
    run_svm_tests
  x86: nSVM: Move all nNPT test cases from svm_tests.c to a separate
    file.
  x86: nSVM: Allow nSVM tests run with PT_USER_MASK enabled
  x86: Improve set_mmu_range() to implement npt
  x86: nSVM: Build up the nested page table dynamically
  x86: nSVM: Correct indentation for svm.c
  x86: nSVM: Correct indentation for svm_tests.c part-1
  x86: nSVM: Correct indentation for svm_tests.c part-2

 lib/x86/vm.c        |   37 +-
 lib/x86/vm.h        |    3 +
 x86/Makefile.common |    2 +
 x86/Makefile.x86_64 |    2 +
 x86/svm.c           |  272 ++--
 x86/svm.h           |    5 +-
 x86/svm_npt.c       |  391 +++++
 x86/svm_tests.c     | 3535 ++++++++++++++++++++-----------------------
 x86/unittests.cfg   |    6 +
 9 files changed, 2157 insertions(+), 2096 deletions(-)
 create mode 100644 x86/svm_npt.c

-- 
2.30.2

