Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C35B767B8EE
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 19:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236125AbjAYSAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 13:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236043AbjAYSAM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 13:00:12 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935FD2DE62;
        Wed, 25 Jan 2023 10:00:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c3zAWqE+d7XeYom63PFeS1ap1psyCCih0tR4TgQTLEep9EP4lF6Gg9l+qVXzZtjRJkG9EFG5nbvUPnYN2jZ4QWqgWlfzI9ObTsJduNRoSpwF7olW1AWqyN85XQ/SnsXFGuZ/QrU+bYDJKEtSl8KDFiOwVRaFHa/9MYYOdTqz7BUE6O2/lT1CSISYaNXG8EKJEIGm9E/5WJkEWDBieXD0K1bLm0ovkN1WgRn6BRL088ZlV23vBHCoitsYtiKu8BvTG0BhQFlaYsJSmLdkErYyIXCylSohzqfVvrJ78FSvv/iYvNHKQvAzSlDsrkLrJALYqisjjh0mwIpqjfPW4BcOqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u/XhCnrerFhVuNV/urO1JtZtpre0YTanYRVZg/FOr/0=;
 b=e4keMGmJta564dlZLOiS7llqAwuGCvt4hlIxJohdlcXSDAo5pMJ7O/k5i4yYliraWJjT/LOHS9RP4ecu1SjwCnivw/P8QwdpLzel136+K0MiMDq+1uWmxzrRzg6+bip8q0NN2TQJkoHfFFOhrO43KLHE2l7DZvTYt+/tOKfwSjWCNHVgC8TAUzofiGjH2vOR/7qArlXOvuRVDooPG1nrc7xgtVID0HToT8xzbBfvOHt9BkKoeoSb2ozRI2qWenkkcc3Igln1zBLJzDQ31Ic+iStx4gS2TRUn48CnAw9oDdp+9fio68K1xts5peC50XH1nS/C/w6HFTYxjpQqNT1bMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u/XhCnrerFhVuNV/urO1JtZtpre0YTanYRVZg/FOr/0=;
 b=irKNr+0h8Tu9avOBvFpwmzjxPI84z8vKV+DTRqR16T6ZNaR6Bn9rjC3kYGrpqSLcwDzCJjidEgLT4bmfhs0xTlzRWYdm6h/h5QYMCsHbWtYKCwx8LLAAadAaSAvtqs0eI5j3ZU2vc6j2xuei/6891x5sNPcAfhS5+FQEE/dlXAA=
Received: from DM6PR12CA0018.namprd12.prod.outlook.com (2603:10b6:5:1c0::31)
 by DS0PR12MB7608.namprd12.prod.outlook.com (2603:10b6:8:13b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 25 Jan
 2023 18:00:07 +0000
Received: from DM6NAM11FT069.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1c0:cafe::f2) by DM6PR12CA0018.outlook.office365.com
 (2603:10b6:5:1c0::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Wed, 25 Jan 2023 18:00:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT069.mail.protection.outlook.com (10.13.173.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Wed, 25 Jan 2023 18:00:07 +0000
Received: from beas.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 25 Jan
 2023 12:00:03 -0600
From:   Wyes Karny <wyes.karny@amd.com>
To:     Jonathan Corbet <corbet@lwn.net>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bp@alien8.de>,
        Wyes Karny <wyes.karny@amd.com>,
        Carlos Bilbao <carlos.bilbao@amd.com>
Subject: [RESEND] [PATCH] Documentation: KVM: Update AMD memory encryption link
Date:   Wed, 25 Jan 2023 17:59:48 +0000
Message-ID: <20230125175948.21100-1-wyes.karny@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230103143931.120939-1-wyes.karny@amd.com>
References: <20230103143931.120939-1-wyes.karny@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT069:EE_|DS0PR12MB7608:EE_
X-MS-Office365-Filtering-Correlation-Id: c0e4e951-3a82-4058-2535-08dafefdfe7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NFLcyp7sk1h8UR1qAdyl1AkqVxaDd5eLu1EpFAV2PCMckBrG61L9QScE97Y6V9iMze100mRORSDssLSLvZ2TuXTkONPXPzQL5oLT3roC+PBcce2/+MweNGq+E4fB/SzWyHQcfPmekCxiyiPgCsscda18XUOhKH1fZYc/9+SZNqq5VvTzGUrvwEYpvEBZ9UcndxOeqTNsXa8Sm7ixy2u9HyG5/16G1DILtYRRKSdc0tlPoiL2JpK9zwtq9A4jVUPjM+NEfEp20OvgHBGA3T410rcj5wFQiJAAEzsayWSyFRyFBTwtc1mpW2nk8YgFc5WVV1H05n9tr9KQTCXaDi+wMvw8nlSi6DbvcSYcD8pMMtKJMwoduc3cdxOkzxI/ZNhWKspio9iiq+dCMlQubKmpGksyD8V9NxzFYsClrgymswNPBth88ymUxkLs5rYk3DHDNyxtk9gLjB1LoATTGPnCozRq3Wjo7bc/w5vp84MkEtpumgHExPfIQ4U3BaImfQmvR+Rzq/5wWLtqKZsheGLShevM97jrcweBKqIc5U3moTBJUPdaQMAi/25PDmOJmCM1Ck3+DXxaHK4ed/fsTYCNfKcv9Hsb+MJJOx1oe+LqOUyxedXCoHxqdT2DbZUPvlm13iJQa5GwCP/OES34UgcMHgcmHm1mHAZrN8WeBApvmsznKDv+/7pETBhsDublc71uKQBuRMS89dFi31Wne3GxCgIXKXgbVIf1Wfy4cFSmvp6n1t993hW1VbGIinwiTKdPPzFz6l/GECAZayVCZVOgTj2CGNEs2SQ907A6sVVPDVSiRLs/MFQnXcOGCyZ/99P+
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(396003)(346002)(136003)(451199018)(46966006)(36840700001)(40470700004)(110136005)(82740400003)(81166007)(356005)(40460700003)(36756003)(82310400005)(86362001)(966005)(478600001)(336012)(40480700001)(8676002)(54906003)(316002)(4326008)(70206006)(70586007)(426003)(2616005)(7696005)(1076003)(15650500001)(2906002)(47076005)(36860700001)(6666004)(41300700001)(186003)(16526019)(26005)(44832011)(5660300002)(83380400001)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 18:00:07.5426
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c0e4e951-3a82-4058-2535-08dafefdfe7e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT069.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7608
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update AMD memory encryption white-paper document link.
Previous link is not available. Update new available link.

Signed-off-by: Wyes Karny <wyes.karny@amd.com>
Reviewed-by: Carlos Bilbao <carlos.bilbao@amd.com>
---
 Documentation/virt/kvm/x86/amd-memory-encryption.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 935aaeb97fe6..487b6328b3e7 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -440,7 +440,7 @@ References
 
 See [white-paper]_, [api-spec]_, [amd-apm]_ and [kvm-forum]_ for more info.
 
-.. [white-paper] http://amd-dev.wpengine.netdna-cdn.com/wordpress/media/2013/12/AMD_Memory_Encryption_Whitepaper_v7-Public.pdf
+.. [white-paper] https://developer.amd.com/wordpress/media/2013/12/AMD_Memory_Encryption_Whitepaper_v7-Public.pdf
 .. [api-spec] https://support.amd.com/TechDocs/55766_SEV-KM_API_Specification.pdf
 .. [amd-apm] https://support.amd.com/TechDocs/24593.pdf (section 15.34)
 .. [kvm-forum]  https://www.linux-kvm.org/images/7/74/02x08A-Thomas_Lendacky-AMDs_Virtualizatoin_Memory_Encryption_Technology.pdf
-- 
2.34.1

