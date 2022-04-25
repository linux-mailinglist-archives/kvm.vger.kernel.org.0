Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30D9350D6C0
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 03:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240261AbiDYCB2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Apr 2022 22:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234324AbiDYCB1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Apr 2022 22:01:27 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2056.outbound.protection.outlook.com [40.107.244.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976A851317
        for <kvm@vger.kernel.org>; Sun, 24 Apr 2022 18:58:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l0iyFSAi5xHXos9Ab8HHsDl1T+ATYLdnIyeHBnNsMl1D0ZjA84Mcd5oBz1DgTnkEgVz8UZKENXDxp2OuWNCnLcYQuL/OrujZDcBfJHxriHOA50Z99u9u5VXOIboOi7Q4O90VvoBHlfukR4Gq+gBRz4hX8VhTJk9tRgWivzCCJPF5DC8wo4WwvAkBDDSISYamHLMjn7pP1FSKSBzWlz8I8SlZgmLRWIxcnO+HA8BduglHyexlwEUnup4r+55kQJrC4PDVcYEbVi73GpWvJD2B9K0frt9Feeg2pWC3DPHzRt5hzUQ/lu9ild4P2rUHUVMI9Gc9LMcFHE8r75mCaIUzgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZXKN1FNHp7dz5qZ9JcC1uchjE8yJx7VMjI7ClajhHyM=;
 b=ZJ/WvVVEfmM5D+3Rh7Dk3sC7/PxSBva0bIsOE3svuL2SWeCJ25T78tGDGfQ0vIXGDmhOSLgPu15U3stsusXNIQk8Ajk3S6lcVYI8rbi2H5Ac0ctYsOO/DKiv7uYCDjr7fpujRr2shkQTroHrHYbC7chgjDOiCK6BlZQ5nqUybZUutuAFNUcb+uIl/6sbjXRTdsfU1Ew3QUlqyyjMz1EJ0znIMluQL9o/Bx9/yfjcj301zQn5oGfkF+I5DgAzm7JLq7AYaoMEmWs8mq4yl8B3cb7SigZO7SYaAipvvgAo7Q9PsKREKjEIKCq3SjFUqOk7gYdBZuu+97Kh52fyz6ko1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZXKN1FNHp7dz5qZ9JcC1uchjE8yJx7VMjI7ClajhHyM=;
 b=4WLC6+vsdwElUgHknNiWg+t/qB8uIAda1opRb9bZhZiI0II0GDW+or2LLODqNkgibUUfUnAenCla/A0hUyR42aHo8kvgI8f95+ZGk01GCytJK23cCHgjmBCN+uL6LoPrjSQHM20NEPSHUbYPNUFUzoa7N8S3gEI4iwFRxEDWBl4=
Received: from BN0PR03CA0005.namprd03.prod.outlook.com (2603:10b6:408:e6::10)
 by CY4PR1201MB0007.namprd12.prod.outlook.com (2603:10b6:903:d4::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Mon, 25 Apr
 2022 01:58:21 +0000
Received: from BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::92) by BN0PR03CA0005.outlook.office365.com
 (2603:10b6:408:e6::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13 via Frontend
 Transport; Mon, 25 Apr 2022 01:58:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT044.mail.protection.outlook.com (10.13.177.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5186.14 via Frontend Transport; Mon, 25 Apr 2022 01:58:21 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sun, 24 Apr
 2022 20:58:19 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH v3 0/6] Move npt test cases and NPT code improvements
Date:   Mon, 25 Apr 2022 01:58:00 +0000
Message-ID: <20220425015806.105063-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b7ea2f5-23b2-4eee-c4cc-08da265f135c
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0007:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB00078A52BF0D6D4551C83E88FDF89@CY4PR1201MB0007.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FBIbh7u43qe5n273VFOrqQzyDLO3xGu+I2tcjrBNG6mAF/i2ITJkclw4XtwqlbjgCP+6EbzhyB7cuBrLlKYGrWFS6JMkFy5DnEsOaPCuxANUUfdoyYYIHPy5wjpv7JwOi+Or3YfcQjFdRV91b61mrDNg+5YEIVjnOTFmikVo9AkzWMzin2BfVf/KeXLjb3z3/96io7Nt1IsjMKFwxAvk3JEaVMD6j6rrnTNty6w3WjGD5gNbMAbpy+xvqlT8pV8G2tUX1+MR0diUI/hzD106O+dj2pVX9TeIaEQukPRDbNQu9zropgmhz/kelZv0k8nybFTrwM2NASE3KBc1l+V6IBs+pTfDWzETwwmae//obSCA1+tG4yv7uJXzMNg7tcSU0l6fDOBzQHvWuvE6SAuwJKChIsrqOXqfO11Ydxc8EDZB2SEFPZavY0cMlPIIwyhkUq73cRgamm3v02P6VF+dgb6Bz3ca6LVDYV982dUq7K+wq2XePPgOGmRpxthcHAeP2E/md36LAIXSjIajvmLLiFPvLOaBdjzjP/Ml+AVKUIk/nc3mUj95KVcLZ2+635c8vr1PYvkF9006tic2bp71+bqYlBscjeJKqC8lLFGs4H6iJSQsOozG1ThvleHzh6PVu2n/n6GfyGyjL2DtpHE50ivh8LvxRv423Ai0ISTYeGJ7cUAGoPXqigg0kBNdR5EuISQC02LE6rBfA+mWfLyJJQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(1076003)(70586007)(186003)(16526019)(426003)(336012)(47076005)(36756003)(8676002)(2616005)(4326008)(70206006)(44832011)(36860700001)(5660300002)(8936002)(82310400005)(26005)(40460700003)(316002)(81166007)(83380400001)(86362001)(110136005)(508600001)(7696005)(6666004)(356005)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 01:58:21.4160
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b7ea2f5-23b2-4eee-c4cc-08da265f135c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0007
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If __setup_vm() is changed to setup_vm(), KUT will build tests with PT_USER_MASK 
set on all PTEs. It is a better idea to move nNPT tests to their own file so 
that tests don't need to fiddle with page tables midway.

The quick approach to do this would be to turn the current main into a small 
helper, without calling __setup_vm() from helper.

setup_mmu_range() function in vm.c was modified to allocate new user pages to
implement nested page table.

Current implementation of nested page table does the page table build up 
statistically with 2048 PTEs and one pml4 entry. With newly implemented 
routine, nested page table can be implemented dynamically based on the RAM
size of VM which enables us to have separate memory ranges to test various npt 
test cases.

Based on this implementation, minimal changes were required to be done in
below mentioned existing APIs:
npt_get_pde(), npt_get_pte(), npt_get_pdpe().

v1 -> v2
Added new patch for building up a nested page table dynamically and did minimal
changes required to make it adaptable with old test cases.

v2 -> v3
Added new patch to change setup_mmu_range to use it in implementation of nested
page table.
Added new patch to correct identation errors in svm.c, svm_npt.c and svm_tests.c

Manali Shukla (6):
  x86: nSVM: Move common functionality of the main() to helper
    run_svm_tests
  x86: nSVM: Move all nNPT test cases from svm_tests.c to a separate
    file.
  x86: nSVM: Allow nSVM tests run with PT_USER_MASK enabled
  x86: Improve set_mmu_range() to implement npt
  x86: nSVM: Build up the nested page table dynamically
  x86: nSVM: Corrected indentation for all nSVM files

 lib/x86/vm.c        |   37 +-
 lib/x86/vm.h        |    3 +
 x86/Makefile.common |    2 +
 x86/Makefile.x86_64 |    2 +
 x86/svm.c           |  182 +--
 x86/svm.h           |    5 +-
 x86/svm_npt.c       |  387 +++++
 x86/svm_tests.c     | 3304 +++++++++++++++++++------------------------
 x86/unittests.cfg   |    6 +
 9 files changed, 1979 insertions(+), 1949 deletions(-)
 create mode 100644 x86/svm_npt.c

-- 
2.30.2

