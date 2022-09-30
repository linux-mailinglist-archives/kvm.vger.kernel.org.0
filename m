Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22E955F0E92
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 17:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbiI3PPC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 11:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbiI3PPA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 11:15:00 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2043.outbound.protection.outlook.com [40.107.92.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221CE3ECDB
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 08:14:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EgzLG5n5+O8vHgLpBUPf63jDwWCq61JVP3gZcHf/VWkX1RjuoQWkEuQAfuM+DO6dWS3QAxko5Y01KiobyzhpJuIJKjSlKucq/87E/YFXh7NifSxS6hjP+O9Sshmi+FcnzCdZh1mlGlfJlhX7jnTJKCfaYOast2W4PE2vC5RBn7LeYMXd3wB/1fPjRjUPAwcOrykrAz9vbj6mHWtOFfo9jCdw7Vb0HBDQg5g9X/laaQ42F+Qiy0tjeqFR/BCG4jpF5zOk30qAQwlfWdjjs1PxUnwU76AMsZXf7FBMzwO7GrfzyxFVqzjMYuUM2xmG3thFwpt71pUsJop/3GsyzEfY3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ob/NQf5+m8reU3ape58u0Hb3iCVgbA1GXB2+QQJ/DJI=;
 b=ebmuXtabKIaW2ckEqKjWbRzLXXZ2b6yR7i1O5nJ8Krr53mXCOKHQDg1V/Bv9iGc1oVItMxOnwFcyLW01AVz0QjpXpNpZJSTvvBrR+htSaCs2iiiaYTG7gRUE4mA4kFhZ7bAo4yA8jvUtUVA390emUBOYbFMN4t+DxttphNxShnDjs5Z9ehtmFQ6irlChAIHRDjEfDHqvVGZYLIVIZNPpXPazp8uZ3DY3K/1ER2q+00bpCXc6ENcxXVnVG0eRu1B4IR245YSG2Sni3WUDAHvACxXgxQ0M3CfTXW6w5Ah3Ow+jbPMst43Dda8DN3BkgDewqV+tvkkw7Ae5YEoDB7gjCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ob/NQf5+m8reU3ape58u0Hb3iCVgbA1GXB2+QQJ/DJI=;
 b=0Z8HnISkUiOyrwsob4ZLAGwKpc2lN2/VZdYYH9TOQeGaCJaAEa6MPWj5Z/Bm7f/xckf3T8akKId5LI/5AXVGGzpy/SwOCtiFLvx0wAHJQgRIF/JE+zTpEe4tJXqd6IpJ8ojCgBfTE+lmCSUoUZ1Cl9QZ+vTh2C2tPvjNegY9ZCM=
Received: from DM6PR13CA0017.namprd13.prod.outlook.com (2603:10b6:5:bc::30) by
 PH8PR12MB6962.namprd12.prod.outlook.com (2603:10b6:510:1bd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Fri, 30 Sep
 2022 15:14:52 +0000
Received: from DM6NAM11FT071.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:bc:cafe::f4) by DM6PR13CA0017.outlook.office365.com
 (2603:10b6:5:bc::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23 via Frontend
 Transport; Fri, 30 Sep 2022 15:14:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT071.mail.protection.outlook.com (10.13.173.48) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5676.17 via Frontend Transport; Fri, 30 Sep 2022 15:14:52 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 30 Sep
 2022 10:14:51 -0500
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
CC:     Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Michael Roth <michael.roth@amd.com>
Subject: [PATCH 1/4] qapi, i386/sev: Change the reduced-phys-bits value from 5 to 1
Date:   Fri, 30 Sep 2022 10:14:27 -0500
Message-ID: <cb96d8e09154533af4b4e6988469bc0b32390b65.1664550870.git.thomas.lendacky@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT071:EE_|PH8PR12MB6962:EE_
X-MS-Office365-Filtering-Correlation-Id: 653afce4-19aa-4afd-9fa2-08daa2f6861b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kv/qhqGNg05tL7Tg+xzc5IEpYXI5oM3d7gcyyhoZYrBKxaktIVf28FXOtczivBctWf8B/FspM+kcix0odpyNLgpC9Q4qV9D7DCCJ7xOSoJ57ZoQyPX/440ZAjtFubdesw8zAYEhV/YGqUBIQ5Rhz7LkS1imqFC6Hb78TmamV8F5mXpLL37NP/6uI+KE3gZuNZqI9N5ldr4zErgKHI68NwviurUPWTMAvyyWvpyPkFUCPEVJQw6sWExFcK/hhyCVOpq7GdjpFYs2Srl0eS43rvQkARBDnxYp/i97K++WWsYoDCsvS09AqNUwbaKbG3kjnnuI3kemF1IRDy81/T4tZ1SV8IXm5An/ruPiX/cQF6hI+Arvd4Z/ugdzU1zAQINlVCAzs6TZnTr15LvTW8qHpt0FrJ8wWT8XBHD38n9GsJWgMs7f3720MKbBj08s3ZtKWifopkErWKSWuPUbr21UeaFddqarbk9NrqzylCPvSsGhQa2LribPQVBOB9BrYwITd2oq57EmA/r7bBK3Ypxo4Zg3AIiGb4UsR5dXfTwROJDfBWQVmJleNZ/WxvLDAAoKm7CxjTeQ8WV9CuBCm065yVI40La/ZUBypKUkA9qwng6l5sLNRHiOWuQcbj194N56DCz6ZDaWyhaVGn42De0un+3rINmCpzbzTnJ4TAuCGf23LI+tSg061E7cBmre3emlqKdMUSdZkyl0VhzdOy94CiySaQbfFGo4uaYaijb7ZlvdbadkSzNaWUE5Vie9kIqYsIWZnq0ySxTEn7enw/aLQbCvaR62jPOCDMWvk4TMn4+vgRJz+OghOBLibUzgZ4erF
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(376002)(136003)(451199015)(36840700001)(40470700004)(46966006)(81166007)(2616005)(356005)(82310400005)(2906002)(110136005)(54906003)(478600001)(316002)(5660300002)(40480700001)(336012)(86362001)(8936002)(26005)(40460700003)(47076005)(7696005)(4744005)(6666004)(83380400001)(186003)(82740400003)(41300700001)(16526019)(36756003)(36860700001)(70586007)(70206006)(8676002)(426003)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 15:14:52.0864
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 653afce4-19aa-4afd-9fa2-08daa2f6861b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT071.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6962
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
addressing. Change the query-sev-capabilities json comment to use 1.

Fixes: 31dd67f684 ("sev/i386: qmp: add query-sev-capabilities command")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 qapi/misc-target.json | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/qapi/misc-target.json b/qapi/misc-target.json
index 4944c0528f..398fd09f25 100644
--- a/qapi/misc-target.json
+++ b/qapi/misc-target.json
@@ -172,7 +172,7 @@
 # -> { "execute": "query-sev-capabilities" }
 # <- { "return": { "pdh": "8CCDD8DDD", "cert-chain": "888CCCDDDEE",
 #                  "cpu0-id": "2lvmGwo+...61iEinw==",
-#                  "cbitpos": 47, "reduced-phys-bits": 5}}
+#                  "cbitpos": 47, "reduced-phys-bits": 1}}
 #
 ##
 { 'command': 'query-sev-capabilities', 'returns': 'SevCapability',
-- 
2.37.3

