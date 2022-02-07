Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 889B44AB3D2
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 07:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243534AbiBGFxg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 00:53:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232138AbiBGFM2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 00:12:28 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA08AC043181
        for <kvm@vger.kernel.org>; Sun,  6 Feb 2022 21:12:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KWWxfxsa6uHJ0Me5zjjsFJ4nywc1wzKb6RHFN2TckW8HUQTPGc+HYSbohPfeMH5YkXvJ1JOJqnJXrC+FLorME+0dgx/D4eAqrZszjIt5mZ4vH8EeY0H9tTPIPR5EoQZO45/IGziv9BqWEeMgJP66qkfMM0mDWaEHNBTy3yoXyjUWlQ2ik3PpLMh0XUT2uS7JCBhYEnyGeSCMbY8I69sB7q9yOT8Q5YdB23dGD8tnJFB2ejUnoiHiA7GDCQr828N5wqiamrHiiJrLvUzC6iCUaAX4TODOAGfrS2UXTtax9xsTS1LtU84SLbe8rbiqsLRpVE7ZTfBe4PRfxtCw6as8lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iFzdtarAtmoWuVd6O1FKwQ+pYADnQ7vydNv2jX7SPnE=;
 b=dsLRVcBfSd6TMJN93laFjxffzoMudPySNELfrvu9/q2YSxTOrAh1IWismKhZMNB46yjljC/PcbAlP7g3/7CQ9fmpI8zWUqS0I6/9VNyql3E53fyxneIvAR3ZBPKc6un9qzWONxGQQcOfdYK4pVk63eXayNFFQROmETmvYL6uRf34py4iEmLDWr/QcpvCsfwhWB9SxmBZ7ih8kzXrYdVHGzoY6L7qB64EVV91o14Vine3RFr3lxQwQdtvXUwRFi+QZM6yGLd1Lxuu73/8AtIx6rSNXTjCyJXey+XrL+MAi3r1zmqBCCk63ErOhG/JpmlLprcMT9ur+m+5KPizwDZWQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iFzdtarAtmoWuVd6O1FKwQ+pYADnQ7vydNv2jX7SPnE=;
 b=bY8fLudmSEwH3DuzGUzcPUobHY8rR/N8Pyh8ETmFHXPDLZgSftARwMyNjvjgz2eEtku5IXz3n21FrTgkY0ZsIB5PWnW7K93CJFAc6i2yy983ZX6VY4dZZcLOFI2Ux+jNTzhb4VMybRfaDzUoN+KFyv+mZx9m/OsUScVUweox9d8=
Received: from DM5PR07CA0143.namprd07.prod.outlook.com (2603:10b6:3:13e::33)
 by CY4PR12MB1222.namprd12.prod.outlook.com (2603:10b6:903:3b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17; Mon, 7 Feb
 2022 05:12:22 +0000
Received: from DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:13e:cafe::12) by DM5PR07CA0143.outlook.office365.com
 (2603:10b6:3:13e::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Mon, 7 Feb 2022 05:12:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT004.mail.protection.outlook.com (10.13.172.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4951.12 via Frontend Transport; Mon, 7 Feb 2022 05:12:21 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Sun, 6 Feb
 2022 23:12:19 -0600
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>, <aaronlewis@google.com>
Subject: [kvm-unit-tests PATCH 0/3] nSVM: Add testing for routing L2 exceptions
Date:   Mon, 7 Feb 2022 05:11:59 +0000
Message-ID: <20220207051202.577951-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3eecc482-9555-4f4b-5a58-08d9e9f86bd9
X-MS-TrafficTypeDiagnostic: CY4PR12MB1222:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1222F219C1F24C9020519172FD2C9@CY4PR12MB1222.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tmuJPjBLvi0M+RSU674YkJSwlPsE9NspTOaKdMP32kiSvNFAO1yHtaZ0Q//4jWAjALjroAbn7pZZALF32u8SzY8Hv8c/KIowAqfwIHEHkn9XBNveiujRatLVOF3+3VNi7ni9yEhtoctY8to1w9ijZIcR2vC/bzMKEHqfGPRFJL8sTWRRwejS/kBxwmKYcOh6NxNkxnjnmeE81vMxebWc4RxNrbVjaTW4ZZCE8ylAr3sfy0tTOLlT2Q50GRWr8USpQi+xBYKBAVPtODKB8LCI/MawoVpg60dbRWJWqS3J8Zg2sf0tJlOixunkXTwYEpuV7tK84uVvhl7KScuUWjKk5n2NU6a/PeCSrZtLNzD+EcL2BGbynWbRQDTBFhroXSEjxKWEo5ZKmetvhubSQaerHc3hWx+JLVboMnVs8GbgB0z3PkK59SdvlkuR55l+JJv11ZW41wX93xkIkHrRhxCH9mv4y7qvb8QuXpm41NEcb85BdU3KrGF9f+VR9TrZ+GoYjYYlxFtn8+GO/UGhWI6jOg3HzMEPNWc5JSg0KOove10jaWVp9eSrkFHDRJnJwnYsmxd3hZc3WsP5ND2dUVjTbPz5QvLqFz+GMGoqNHVdEPPyjPn+MFGcijIbact7OVyE/udyZKDLhjXZG1wsziJdM+MhELwemmFvT03KE9fQIDX21qbKLQnHlLb5as7oqi9A7M955PkuJBOjKHpDqJK5RfDNAbDgyy+u1UhskSTIeAqlYqp1a/GiIROlV6ZpBURNC+d6/u1ulMANXTEEhwn3xvGedy7m720E7dUya1J/i8s=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(426003)(336012)(70586007)(8676002)(186003)(1076003)(26005)(16526019)(2616005)(82310400004)(5660300002)(83380400001)(6916009)(86362001)(44832011)(966005)(36860700001)(70206006)(4326008)(47076005)(8936002)(54906003)(316002)(36756003)(356005)(6666004)(40460700003)(81166007)(2906002)(7696005)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 05:12:21.9266
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eecc482-9555-4f4b-5a58-08d9e9f86bd9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1222
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

Above tests were added to verify 8 different exceptions
#GP, #UD, #DE, #BP, #NM, #OF, #DB, #AC.

There are 3 patches in this series
1) Added routines to set/clear PT_USER_MASK to make #AC test work for nSVM. 
2) exception_mnemonic patch is taken from the Aaron's vmx series[1]. 
3) Added test infrastructure and exception tests.

[1] https://lore.kernel.org/all/20220125203127.1161838-1-aaronlewis@google.com/
Aaron Lewis (1):
  x86: Make exception_mnemonic() visible to the tests

Manali Shukla (2):
  x86: Add routines to set/clear PT_USER_MASK for all pages
  x86: nSVM: Add an exception test framework and tests

 lib/x86/desc.c  |   2 +-
 lib/x86/desc.h  |   1 +
 lib/x86/vm.c    |  54 ++++++++++++++
 lib/x86/vm.h    |   3 +
 x86/svm_tests.c | 185 ++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 244 insertions(+), 1 deletion(-)

-- 
2.30.2

