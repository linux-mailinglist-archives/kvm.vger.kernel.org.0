Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E58B67E45B
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbjA0L6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233817AbjA0L6M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:58:12 -0500
Received: from outbound.mail.protection.outlook.com (mail-db8eur05on2060.outbound.protection.outlook.com [40.107.20.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8949D7FA26;
        Fri, 27 Jan 2023 03:54:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lbtS9Kcg831sCdIhPFu0ucGohn4Enumb1k5jv0h4C88=;
 b=hOss0l1J1oWSbYaWOFSgXQOx7vrcPvdNujep4U0jFOegEz4TqJrioNrDBAAA2id6kG/YGRWiOFfFgyg8WiXWyi/fhM8XzL7cyJix31kKYyEmGeheXV/aXzIf6M17tu90E77HaiCwbjzj8qkcXyYfRHdu0EqFS915Z9JVpz2SfSY=
Received: from DB6PR07CA0106.eurprd07.prod.outlook.com (2603:10a6:6:2c::20) by
 AM8PR08MB5844.eurprd08.prod.outlook.com (2603:10a6:20b:1d1::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.23; Fri, 27 Jan 2023 11:43:22 +0000
Received: from DBAEUR03FT033.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:6:2c:cafe::2a) by DB6PR07CA0106.outlook.office365.com
 (2603:10a6:6:2c::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21 via Frontend
 Transport; Fri, 27 Jan 2023 11:43:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT033.mail.protection.outlook.com (100.127.142.251) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22 via Frontend Transport; Fri, 27 Jan 2023 11:43:22 +0000
Received: ("Tessian outbound 333ca28169fa:v132"); Fri, 27 Jan 2023 11:43:22 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: b85a7ebb9964932e
X-CR-MTA-TID: 64aa7808
Received: from 738540edc373.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id EC0D18AF-BF20-4C69-91A5-A02C540EDDBB.1;
        Fri, 27 Jan 2023 11:43:16 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 738540edc373.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:43:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WsxAjcVEP7krukz7VSRBAELHWftQGMD8Q/7jLK5WXrene0cT2Wk/eh3yJMJImF7kzP7X4fR6x1T+FHtm1b3zGBsSdV3ZpdSidrXW7KzSe5Rf5b0TFphDZcX/gS7mhXdd/DrIZLBaNuTFHIQYjG/NRJdE+uUZw6oST0fGNcfzZDDcf8yO6ECqoX8crHaJ2Eg/DV9dBfi+hM+rgFz5jCCCKeozfHX2A5zeW+nX2FVy+EI94DiqqZKxCd/6TafbT0zagDOHilnnn17cD6CtdzIA8ipSUrK0WwxHMWsIpblhcpfgVecOM45P0irI/ZzwmuAZsM0Z193jkrEdhkaDhOLkIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lbtS9Kcg831sCdIhPFu0ucGohn4Enumb1k5jv0h4C88=;
 b=Uy38XnrJvfjPNOj5Ml9BtCT/4ijl+ndD7GlZimLy3WnRktETCLwP0GjPG798cV14qG7smeW0RPusUSl4FhvFQdrvw/0OCbHuoSa54F2NacLVTJxEeKH3qmo100jCkc1jLr/2uXf1U5H792PxBkC5/X3kUU0smYmWm4xnJvXy9XtQkjtyxEbl7fZaFhFjI+jYfof4iPrTR/4liWMc+1FpCxL6UJTg+cmaDJ+YqxCDiR22S2XGxjYJKTBIqaHx9klRYMV9VEWTF3BkFLLiFSNnzx/52rPOq6mOPw7iDXEA4XxoV4U3cXVjkC8N+XiMPIC0S+IaRqL4AIZMkeiiz4pDew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lbtS9Kcg831sCdIhPFu0ucGohn4Enumb1k5jv0h4C88=;
 b=hOss0l1J1oWSbYaWOFSgXQOx7vrcPvdNujep4U0jFOegEz4TqJrioNrDBAAA2id6kG/YGRWiOFfFgyg8WiXWyi/fhM8XzL7cyJix31kKYyEmGeheXV/aXzIf6M17tu90E77HaiCwbjzj8qkcXyYfRHdu0EqFS915Z9JVpz2SfSY=
Received: from AS8PR04CA0051.eurprd04.prod.outlook.com (2603:10a6:20b:312::26)
 by DB4PR08MB9285.eurprd08.prod.outlook.com (2603:10a6:10:3f2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Fri, 27 Jan
 2023 11:43:12 +0000
Received: from AM7EUR03FT039.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:312:cafe::7c) by AS8PR04CA0051.outlook.office365.com
 (2603:10a6:20b:312::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22 via Frontend
 Transport; Fri, 27 Jan 2023 11:43:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT039.mail.protection.outlook.com (100.127.140.224) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.21 via Frontend Transport; Fri, 27 Jan 2023 11:43:10 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:43:09 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:43:03 +0000
From:   Joey Gouly <joey.gouly@arm.com>
To:     Andrew Jones <andrew.jones@linux.dev>, <kvmarm@lists.linux.dev>,
        <kvm@vger.kernel.org>
CC:     <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Steven Price <steven.price@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "Thomas Huth" <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        <linux-coco@lists.linux.dev>, <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC kvm-unit-tests 20/27] qcbor: Add QCBOR as a submodule
Date:   Fri, 27 Jan 2023 11:41:01 +0000
Message-ID: <20230127114108.10025-21-joey.gouly@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230127114108.10025-1-joey.gouly@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127114108.10025-1-joey.gouly@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic: AM7EUR03FT039:EE_|DB4PR08MB9285:EE_|DBAEUR03FT033:EE_|AM8PR08MB5844:EE_
X-MS-Office365-Filtering-Correlation-Id: 1da3743e-a562-416b-2d3b-08db005bb199
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: d+xeNnQAWapLKWYV05kexHW6PajvIVLCYWIJg/wMqKyfFcWxKH93y3BB0Tyo1+ikcezdFBrQxtM+L/aYr0Jj0OAEIoLJimUIC/FkiFCVm9TKSHhbQl5OxFW8DS5HkZb3prypEYzhCDN9QmC/ZAtHPDQ3RsmC60l1Qk2rWrKHqqSRYNXl5I1H4hch9KrJb8QHXKTkjDdllTIBy1RSV6YZ5NOPEt01zGuVvarAQwVlvNgimW3R72ZC7A69OY5Q+spzRiTUS8IR5JT89T0HdMFsWgVCjRgvJ4ImVObDTckasq9kaB9nD5o8O+yUUEZrJpz/UOrY2d1+LpmvtAhdhYfuQER8WIfzXgimOIm1H0q5HR6qYXMrcJtoxcLmi64AkEfITWKYjWBcU1MJym3QdQ+ah3kIpDDkVhsd0dNwpnMEdHA+lylKGlHleMI38A8K6ifTWXsjxMqnKggsw7EbbmMKSubn+B+A55pEtNG7drwLv0saG+DUmkYoZ9SYvNP855Fb51H/3HIROWQ4ldwLtyZ7bJ3N6fsrSv6A770K/+CZHdbkNl9nHOW+RGFR4RCH1nN35BR2GxpeUHUF8OJqTvVCrlw7DQFtVPE6sI9kRypkk9gITmxdxU34iBFoSN38WUyRzhcahZ8gGiJ9taJhRNkbvcluAfuNH9wMOhBSif4fL+EdzQcMKLq4Sjv+zrWow8ZSJf1hJix7r5GYpaN3SwniqUxTbFlOd+UdRQ2LhYEfIK82TLxBtGgpZ7If3pY9HIcYNAhR0PNJnxuKpwu33hSDCrqC+3NJShC6sjw4nKpav64l5qq85pgdM1rVW8s7/FxhRgW3nnhT0Mrr3eQVZ+hdgA==
X-Forefront-Antispam-Report-Untrusted: CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(376002)(346002)(39860400002)(451199018)(40470700004)(46966006)(36840700001)(47076005)(40460700003)(186003)(26005)(4326008)(70206006)(70586007)(8676002)(82740400003)(8936002)(81166007)(41300700001)(7416002)(4744005)(36860700001)(44832011)(966005)(7696005)(478600001)(2906002)(2616005)(5660300002)(1076003)(40480700001)(426003)(82310400005)(316002)(356005)(110136005)(36756003)(336012)(54906003)(86362001)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB9285
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DBAEUR03FT033.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: f5b60917-3f4c-423e-3678-08db005baa3c
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wxJZX1jtUN35VwHWYjHOD3Yv65O5jXtd7w9So4IdGGxAyngtv2ftBnl1Q7fdp+LoWkR8quKdGCBwz8rgAVBkbuq2WBDYiO5ZxUO97tPMlbbqJdc3D6IVSlYJF+6fR1SQfjmlwBIkLJXEyFWltI17Pclc693G2n+qaKW7tz9rZFHlBl8pffb98lhZ2A60KtjWle0l/bJOh7FlIjLxgkX906nz5H9zLENunvGI+p+40HDCxkvh44UlrFUCmmBD3gG2LopYnsU+Y0GR0GX5y+feHV/dRT7+ryrp/pTJI2q9v+eiWCrrgsF4deAXQ3UqLpkzy11DfAWTww7fOwX3PPFVThnP2HdIKIxxLey3HfvzGAP9iUJMU4DtZ1E+D0AQWwdgGJ5Mr6wuB+YHAoHW8YldhKBujAfVjO6KSxaE8NvqJEQ42VpF2cUIGrpiEsAlW31Lyginacqh/NSGNvWWsAYAmHMxUhy1uoTllzYBqSvVD/L/bo8cvdeV4d1ccN5pH13gQK3KZ9Y5CFYFzNzMylTCOxWM1IQz2RLuFsNZNEfrM2QQE7hlf0PktVBVin8qkiEX7d+aQ+QVvYpX5rgmLZhhqHPOYZL2kCgFYTKRZ4uEGY56xT2b2iUBn/u273pJhrlTimimtFTgEZ0EOViFYD7omdEx0qriWRkxvoV4vOVh7HJJJcYauj9nXYGDk/h2hRsj09yxNz6HPL1BsnS304aeFVMBz6UffWQUM/e9lVgS9L9DoTYb4Toy/vN9xtelSlMEHL8wTj0g0osdLFarZf25HOD/A6PKVu7B4ahFsPe4pnA=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(396003)(136003)(39860400002)(451199018)(46966006)(40470700004)(36840700001)(7696005)(41300700001)(36756003)(450100002)(40460700003)(316002)(70586007)(70206006)(4326008)(966005)(82310400005)(478600001)(426003)(40480700001)(54906003)(86362001)(47076005)(110136005)(2616005)(8676002)(26005)(4744005)(186003)(36860700001)(44832011)(82740400003)(2906002)(8936002)(81166007)(5660300002)(336012)(1076003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:43:22.4530
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1da3743e-a562-416b-2d3b-08db005bb199
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DBAEUR03FT033.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5844
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_NONE,
        T_SPF_HELO_TEMPERROR,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Adds the library QCBOR as submodule. This will be later used
for arm64 realm attestation token parsing. The repository is
available at:

	https://github.com/laurencelundblade/QCBOR tag v1.0

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 .gitmodules | 3 +++
 lib/qcbor   | 1 +
 2 files changed, 4 insertions(+)
 create mode 100644 .gitmodules
 create mode 160000 lib/qcbor

diff --git a/.gitmodules b/.gitmodules
new file mode 100644
index 00000000..29fdbc5d
--- /dev/null
+++ b/.gitmodules
@@ -0,0 +1,3 @@
+[submodule "lib/qcbor"]
+	path = lib/qcbor
+	url = https://github.com/laurencelundblade/QCBOR.git
diff --git a/lib/qcbor b/lib/qcbor
new file mode 160000
index 00000000..56b17bf9
--- /dev/null
+++ b/lib/qcbor
@@ -0,0 +1 @@
+Subproject commit 56b17bf9f74096774944bcac0829adcd887d391e
-- 
2.17.1

