Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB94158E694
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 07:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbiHJFIB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 01:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbiHJFH5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 01:07:57 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060.outbound.protection.outlook.com [40.107.93.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E89182FBC
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 22:07:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=drnHzegzCYTf2+kqWw12iOmnHDCGTc0P/ERp0ODfVJ+HttYFnCGX1dNTk1OaPL0/wFm1pn5TsfI+yhSs33yOqzoiYk0bt5oAbDFROohvNl6sjLajmTPCjwaoQFSWSygnrOb3o/pm4M+c2w6/2x0s3luFbKqmIznX0gFbIteYZQSqLJ70ckbqZEBz6nnXWWpqVneUvx+PAdC25jqgD8qgLSK6yPlg4btLNs3bk30IJkm9JHlw8oJEMURou65/D3C1+sNnwPmhlyQY7XIRfK0xv03hXvv4b0K4kUR4vxU6YBcPTVCkRh8uo1NKulwZeCbruzwvMaOC59gcaHHMuTmQeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A3o4Od+GGInd+nZLwUrKiUdFqkrpG8YV8vRxAnk/uwM=;
 b=evLvQL//N1FfdDTMlcERiI1CPOVzk3NN8ceS6Sf6u8mOpjVwwYh1uW2jH/tRlgn1EPPTH7JF/lho4SkH025qD9wq2tZUIx/ZI85o3zUpZg9bnY/YJpI2gJiHsXZ0sr20ItxwpyugadBuJ964WxnNSPztZNzEW5bjRoCZ3t6jNaQ/WZMcTFXlISldhVxOFtSQ718S7z2tiVaHeTbJySdZJsNEU6jQBVF8lJsoHuatF8wtp/AZoT57zFcJONyZjN1H7a/JqwExU2qMWrmKthZoNmsVq7c5ALrp8YDW8dZaDSu+QaH/Mesr6MdrJgME23euFAeUCUaUHllVEbFQosV1IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A3o4Od+GGInd+nZLwUrKiUdFqkrpG8YV8vRxAnk/uwM=;
 b=pfoq05YjNJT6K7tNwCqCdoDie9FSL81NJne4DZj2/GHjqQxO+221qau0HrpfYgWW2dRcTlB5hjaLxHyrl2GF19rDxiWooNyn6tbWkAJkavehgXEbChn7gD2K+q2A2btvweqmsMhtiUaVrBVNn5lCdrhxyKEAzESF0MRKYfjuLW8=
Received: from BN0PR04CA0141.namprd04.prod.outlook.com (2603:10b6:408:ed::26)
 by DM6PR12MB4140.namprd12.prod.outlook.com (2603:10b6:5:221::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Wed, 10 Aug
 2022 05:07:54 +0000
Received: from BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ed:cafe::60) by BN0PR04CA0141.outlook.office365.com
 (2603:10b6:408:ed::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16 via Frontend
 Transport; Wed, 10 Aug 2022 05:07:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT063.mail.protection.outlook.com (10.13.177.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5525.11 via Frontend Transport; Wed, 10 Aug 2022 05:07:54 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 10 Aug
 2022 00:07:52 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <aaronlewis@google.com>
Subject: [kvm-unit-tests PATCH v2 0/4] x86: nSVM: Add testing for routing L2 exceptions
Date:   Wed, 10 Aug 2022 05:07:34 +0000
Message-ID: <20220810050738.7442-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5d1cc0b-65ba-4190-fd48-08da7a8e4878
X-MS-TrafficTypeDiagnostic: DM6PR12MB4140:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y1JqaH5MAlmGfz3+M0XbHi6vI4DQ7uUyDnH8IGZ/u78rxTtMntw5iGGVqkwDpa3GLpBKia2sv7HosOB6+wcK2Eb9LCAX27R93OH/Nred/Bwk45YjzCf/oyfR+wr9PL4dzbhD91tSNT6rkUVAsqI9jxCsizaVmBlV/NQ6AH/rflhCrjd+rxqBkz/lHu6DixAhZ0GbUSl5aDKfwkSwB56IbSJS7a8KXMNZrYaS6vvm10NKX/XuICxAHfw2iYAB/WsBru7quDwinzIZbOwlGieD2Ojq+MFcqFWzLSpmvKvEJ/vTZWLDtasF3JWTfRBYlLh30ZomNOUcSDs6KW6gd+ofude8HOyBuGjT5ciQChNyA5ern05bGZeVsWvMjYEIDCIiTSdvYvTj98913+xr2EHyLp/VarLe7WQMPx1XAHY2BB419N9VYNcZcMvvd+0W/4JXOHeF1rB5qpvFl5u8H6Thnw7q8V+FRpSSB6azXwSIQuw3RxJEe1VstzZgZO1C1DNF4kM82YDbJGeiicinnVUHw3NkQdIFFftO0NPpabsXi8yUIqXeq7z+PxGRFCvaDDQppItpFuLf6tGi03Ff8KwHNd4FKbPCv6/fFADRxojyvMBBzvOBk6Ih8UEyzaTtRDymRLQpSMaASnBOnhqF78vg1LUzQJmCsy9+r0OxCtRaXaStBQcmKG04bwIwpueTwXbPgWj08QcV6C1kRImZ/prXSvb3mZX/8yFkM0mJfPC/i99s/gEEqCu7ELU6Lo5SeIrJd5oaYH5CZfP/ta/jPOrdIPj8JxWfnL0srn0fQ/JmzQ3C9RoUydWq8OEODcqPXRH802qH0HhKUdsYTcQ1yWiy00aRNNp3bi9Rnr7rQO9sb3PLBk88G7eUYn9FAtYFaO3dWlw3ONVyYkfNcofVXju3CA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(39860400002)(376002)(346002)(36840700001)(46966006)(40470700004)(6666004)(478600001)(966005)(36756003)(81166007)(82740400003)(356005)(16526019)(426003)(83380400001)(186003)(2616005)(1076003)(336012)(47076005)(26005)(41300700001)(54906003)(110136005)(86362001)(40480700001)(82310400005)(7696005)(70586007)(5660300002)(8676002)(4326008)(70206006)(40460700003)(316002)(44832011)(36860700001)(8936002)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 05:07:54.5398
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f5d1cc0b-65ba-4190-fd48-08da7a8e4878
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4140
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Series is inspired by vmx exception test framework series[1].

Set up a test framework that verifies an exception occurring in L2 is
forwarded to the right place (L1 or L2).

Tests two conditions for each exception.
1) Exception generated in L2, is handled by L2 when L2 exception handler
   is registered.
2) Exception generated in L2, is handled by L1 when intercept exception
   bit map is set in L1.

Above tests were added to verify 8 different exceptions.
#GP, #UD, #DE, #DB, #AC, #OF, #BP, #NM.

There are 4 patches in this series
1) Added test infrastructure and exception tests.
2) Move #BP test to exception test framework.
3) Move #OF test to exception test framework.
4) Move part of #NM test to exception test framework because
   #NM has a test case which checks the condition for which #NM should not
   be generated, all the test cases under #NM test except this test case have been
   moved to exception test framework because of the exception test framework
   design.

v1->v2
1) Rebased to latest kvm-unit-tests. 
2) Move 3 different exception test cases #BP, #OF and #NM exception to
   exception test framework.

[1] https://lore.kernel.org/all/20220125203127.1161838-1-aaronlewis@google.com/
[2] https://lore.kernel.org/kvm/a090c16f-c307-9548-9739-ceb71687514f@amd.com/

Manali Shukla (4):
  x86: nSVM: Add an exception test framework and tests
  x86: nSVM: Move #BP test to exception test framework
  x86: nSVM: Move #OF test to exception test framework
  x86: nSVM: Move part of #NM test to exception test framework

 x86/svm_tests.c | 197 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 142 insertions(+), 55 deletions(-)

-- 
2.34.1

