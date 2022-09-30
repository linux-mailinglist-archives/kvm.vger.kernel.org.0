Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01BF65F0E93
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 17:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbiI3PPL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 11:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbiI3PPJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 11:15:09 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2081.outbound.protection.outlook.com [40.107.101.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0327A5C36D
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 08:15:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dyiNds36iSOtTTLRKZiXhTdhSUUroXL1nDvX/YR9NWiyNOjyUHGGcqrlWU6+tb1hT0npl1QwUcUixh9jLvGmuyLTcjH5PotOi5mFaLaU+SQTyuQ9I0NF8sl/6KIwYfN1lLSqxrrH6KPrQkqx+wWaI97HefzCO8/amb9HH87yiDgMgA3xb51z69RMMVCDYvB2RzNmgtyp1QiNbEcprDSa1+dm9FioYAXkmxguGgUJuJs/cYNQ4qSQyrfOdPPq3oS37JojGRpDB96rMDHRaQCfvqfv3sLifLMcxLMVjxe/mnzAy0MeGY2vZQnYK9jVEqyd9sYQNFhxov1DgBG3fQ/qBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+2ayFyr87PrDNTyBkodhT+gEwPtKngFt2QVuiwrZwyw=;
 b=QdD0makXqIhr1YuJruL3sn7viAS7AxuESn1DmbLKGLxQSU8WgxJSzt4HBkGqFxw17DL1A2JbtgF3BNzom0EI/K1FKKQ8bzmzEhjAUPsCbXnoBR+iVmXlGHVW/y8cjGZofU4OlXiNAUGaq057VHwpBhXqB3MrfCZA5UBbmLzsH9p1Hx45s/wNOlvqAfdGeWpoNHkldfyYa7KcsWGxYF/7N2BdLiEHPwM9VNeUfDwik/kRpE/Q5UkMss4XLjHO+5+KLIqmTcalb0557gc+pwrdfTQqsQAyL27t5b14qHVD2WdHjt4HNSqSjXhjkCy3rDZdrlp8zXIPXfebkKL8vi5Xzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+2ayFyr87PrDNTyBkodhT+gEwPtKngFt2QVuiwrZwyw=;
 b=MsK6zS5Gdu1dKzhKUKXbVV3pimec4gW/kKDMScT/0OQC9FG7ANfz8iUwGfGK47H9zjzEKbUMweMul4dYN0PR1jz5DL17L7Rfe4kkuOQXxXguPXgeOj9f+3QcpI8bkiSXCcJq8iJx3i3/i8EGgD8XDjl1WBzTaP2tGI2dePBh+v8=
Received: from DS7PR03CA0325.namprd03.prod.outlook.com (2603:10b6:8:2b::34) by
 SJ0PR12MB5453.namprd12.prod.outlook.com (2603:10b6:a03:37f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.23; Fri, 30 Sep 2022 15:14:59 +0000
Received: from DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2b:cafe::b4) by DS7PR03CA0325.outlook.office365.com
 (2603:10b6:8:2b::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20 via Frontend
 Transport; Fri, 30 Sep 2022 15:14:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT055.mail.protection.outlook.com (10.13.173.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5676.17 via Frontend Transport; Fri, 30 Sep 2022 15:14:59 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 30 Sep
 2022 10:14:58 -0500
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
CC:     Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Michael Roth <michael.roth@amd.com>
Subject: [PATCH 2/4] qemu-options.hx: Update the reduced-phys-bits documentation
Date:   Fri, 30 Sep 2022 10:14:28 -0500
Message-ID: <13a62ced1808546c1d398e2025cf85f4c94ae123.1664550870.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1664550870.git.thomas.lendacky@amd.com>
References: <cover.1664550870.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT055:EE_|SJ0PR12MB5453:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fe45696-0517-4ae4-5e76-08daa2f68a5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mTtPJMU+ErVL7AthKFsPoBYOkMCmpNXx6mqpteN3DGRWLDLwEfHRm7VvQzt1/BXY7ebrVLYFmmGcdkVqnTsPOxBxdOR32rXza9+cNRiN0eWILg0SoF3fea2LPyRWVw14uvkmKthdqeH2DQHSJJz2fkXQqCC2T/Nix2x5hsOnJJpPWN1faWMpFCvhNK/2/fLBUTwnCQfMHviiTV71Um46C98UOCMXjdPNkGLZBFAQamqazAoVkJyBbeTnUcL0RrZWlJyE9NiVUXwTJ3ysUBln2v8iZ5w08wvdiB0dfumNC3A3EQE7fGbERmy+GaIkAB3MSnyIg77eCFSTs3llEENPX3dxeqBeq+Qdr5kJi2b6xmTvD+bDL319fS8ML9MbNKOiIvyNTpbY82BnIpt32phrgfrsfnFZNw57JeJZ8NTwHKzZt6zm3fmgeEzNnPX0wLgY4LJCx5Kpt0Fsj5/5jQt0nMrNf0HTdup98hXY1DiqnHwJYkDN1cY8mH9j2+Mo6iauUtzw/upImNlO5Usi3pl1F8I0J7KGNWLOsBcFZf43xMAuKGaVaXOG6SDcIaXKKvIW+qSW2tn/06qIlb2TADSKuSovlGCoVd7QAJ3tA2WqyI4bo9Pp1xkJ4X13SXVmX4RrvNWWtWynrwbzDT4lAdFgo77nRhoBEQpokXHBmg2n+OBGqqKmYMe8anh4V0KCh7g6GcvvOxr+TKH7xhNwtyciSZssEle31KLjsN/sy72Jq8EMaEEEf3i6v9H5AY62HtdqSvhlYr7uPMLwyK91ocTQgTi0A+Gx97+AxgmYNqaE5Nt3WislozuZehamufaPQQq6
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(39860400002)(396003)(451199015)(46966006)(36840700001)(40470700004)(36756003)(54906003)(110136005)(86362001)(36860700001)(356005)(2616005)(426003)(47076005)(16526019)(186003)(81166007)(82740400003)(83380400001)(336012)(15650500001)(478600001)(26005)(6666004)(8936002)(70586007)(70206006)(8676002)(4326008)(7696005)(82310400005)(2906002)(5660300002)(41300700001)(40460700003)(316002)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 15:14:59.2347
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fe45696-0517-4ae4-5e76-08daa2f68a5e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5453
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A guest only ever experiences, at most, 1 bit of reduced physical
addressing. Update the documentation to reflect this as well as change
the example value on the reduced-phys-bits option.

Fixes: a9b4942f48 ("target/i386: add Secure Encrypted Virtualization (SEV) object")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 qemu-options.hx | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/qemu-options.hx b/qemu-options.hx
index 913c71e38f..3396085cf0 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -5391,7 +5391,7 @@ SRST
         physical address space. The ``reduced-phys-bits`` is used to
         provide the number of bits we loose in physical address space.
         Similar to C-bit, the value is Host family dependent. On EPYC,
-        the value should be 5.
+        a guest will lose a maximum of 1 bit, so the value should be 1.
 
         The ``sev-device`` provides the device file to use for
         communicating with the SEV firmware running inside AMD Secure
@@ -5426,7 +5426,7 @@ SRST
 
              # |qemu_system_x86| \\
                  ...... \\
-                 -object sev-guest,id=sev0,cbitpos=47,reduced-phys-bits=5 \\
+                 -object sev-guest,id=sev0,cbitpos=47,reduced-phys-bits=1 \\
                  -machine ...,memory-encryption=sev0 \\
                  .....
 
-- 
2.37.3

