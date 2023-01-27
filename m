Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFDFE67E430
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234196AbjA0Lwh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234068AbjA0LwX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:52:23 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2064.outbound.protection.outlook.com [40.107.22.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 387B97BBE5;
        Fri, 27 Jan 2023 03:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dAthAYOVywOx8lXe0h46x7ZB6wNi2URhTTiXJIcBscU=;
 b=33gJpoAbHMpJgShtK36NvshIaiJwXLMHJRWF/7XkPzEN5LMpvoAg51lA8KbjuVpPTMWBz6IcoUy7kJOABQ7HO0gjf+5X/J06znkx5cJIqi7gQz4PkGQu26VriCeSMlAv/dutdE1XVtHrWBNIOEriEVbnmEYk7ASKKJp/mBxjhgw=
Received: from DB8PR04CA0026.eurprd04.prod.outlook.com (2603:10a6:10:110::36)
 by PR3PR08MB5596.eurprd08.prod.outlook.com (2603:10a6:102:88::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 11:44:04 +0000
Received: from DBAEUR03FT063.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:110:cafe::22) by DB8PR04CA0026.outlook.office365.com
 (2603:10a6:10:110::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22 via Frontend
 Transport; Fri, 27 Jan 2023 11:44:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT063.mail.protection.outlook.com (100.127.142.255) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.17 via Frontend Transport; Fri, 27 Jan 2023 11:44:04 +0000
Received: ("Tessian outbound b1d3ffe56e73:v132"); Fri, 27 Jan 2023 11:44:03 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 79fec1a3b4157ab0
X-CR-MTA-TID: 64aa7808
Received: from 9134af7da11f.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id E8CDC639-88BD-455C-B67E-8AC8E24ADBE9.1;
        Fri, 27 Jan 2023 11:41:29 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 9134af7da11f.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:41:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nmq85NsRTvJ2QTNZU5yQQMc+1XrRAE/uDbfZf4t7WFttH5OiOofMK5XDqtSn0SA/HxnBq4ZZREi8wIrOyABIAaRWNBVK5tSG+uZWfIWfhbCTDFfX/Zg2+DlqetX1BgkaQn50CIbNy5LzXf41wl7lRWHZ5Fyrz59Y+7lrAOgJwp5cxOeZRN1Lxka8MQHh7fZCB8qhEDeMh/qCNMbPow/9WZm5AKL35DkX/eJet3TNNQppLk8pt9dFSt5C84TddfjPPMGXs86T4+wvPqjQM+QDAMx0xAlHYVEfDK7aI1XXBFXc4SsTG9xipNeAh36HOrS31rpKdCkGOvBW+N5hV/Q8tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dAthAYOVywOx8lXe0h46x7ZB6wNi2URhTTiXJIcBscU=;
 b=S3FG+yu+FRUfUQnX2D3d8jTBGn7N2o5tt/lzRllOZSgzb5UspJSj28lKSTJUFkdZC4G/mLUMbjmPWgJyda28pe5T1wzS1xqmsvV4drWFW+AkhxvUX4Z6EV4YrOdkuDJgROXoyOLl9+kg0rOuV5joUmbnZhm7YPeEf8DbGUHvXJ6J6fNoKSMXL5Z8vNqX0aDDxx7ureDgXzYVLt3hKbmN/8yiqT6YnH2HiyQqp0s/YmcYr5MZseyQ6ULeiVwmOEg2/CSV7z1lWkRGmtJwOs/mdVIT/iVOJXL87EKKudIa4ZpCT7K/hTzFU110wvGq0v5/NYyJfN6UzXMpIt4bhg3adQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dAthAYOVywOx8lXe0h46x7ZB6wNi2URhTTiXJIcBscU=;
 b=33gJpoAbHMpJgShtK36NvshIaiJwXLMHJRWF/7XkPzEN5LMpvoAg51lA8KbjuVpPTMWBz6IcoUy7kJOABQ7HO0gjf+5X/J06znkx5cJIqi7gQz4PkGQu26VriCeSMlAv/dutdE1XVtHrWBNIOEriEVbnmEYk7ASKKJp/mBxjhgw=
Received: from AS9PR06CA0224.eurprd06.prod.outlook.com (2603:10a6:20b:45e::21)
 by AS8PR08MB10149.eurprd08.prod.outlook.com (2603:10a6:20b:63f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Fri, 27 Jan
 2023 11:41:27 +0000
Received: from AM7EUR03FT049.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:45e:cafe::17) by AS9PR06CA0224.outlook.office365.com
 (2603:10a6:20b:45e::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:41:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT049.mail.protection.outlook.com (100.127.140.234) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.23 via Frontend Transport; Fri, 27 Jan 2023 11:41:27 +0000
Received: from AZ-NEU-EX02.Emea.Arm.com (10.251.26.5) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:41:22 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX02.Emea.Arm.com
 (10.251.26.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:41:21 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:41:16 +0000
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
Subject: [RFC kvm-unit-tests 01/27] lib/string: include stddef.h for size_t
Date:   Fri, 27 Jan 2023 11:40:42 +0000
Message-ID: <20230127114108.10025-2-joey.gouly@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230127114108.10025-1-joey.gouly@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127114108.10025-1-joey.gouly@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic: AM7EUR03FT049:EE_|AS8PR08MB10149:EE_|DBAEUR03FT063:EE_|PR3PR08MB5596:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e2bc0e4-5f08-488f-b44d-08db005bca8b
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: onWF71zoO6duUEy+orjL4HaxS7SZPO7QtYxVx46ihrlGO+YyVonwfIlTIu00ZAPHMs7YkA3E6vU9GnqqdU27eMrSPYu/x1wCRnudyHy5gM/gZ8W7/GgTP5530FbyNkMiccVtwRyU2fvbqEiy9RK1HPX2oYrwhFWhi005jQEdRWSrf3HGKCulEBesNQpa1HUJ7IX5eWG7Gjnj8oRYS1cVcnMrKM31Iy7uzvnvw0iQ0v9TF90z8j0TzhNxvG1sZy363v1rvCg/wb0CjxzQWQhy4k2/B92exKQP8b+gt6aoXdM7pppTWhPHkg4RFXqpeB//gffmF3kcfMNWSFOuJYgMBYiMBGgj7vWdlZOZCsY102gVLqjuSvqkOhWjhiP8fFBdx9vWelXzjr75mW5MFs7PjZeSed0SY3ZfC1ItTa5Hfgexj5m7uCnVXw6HS0MKqzbYGYyfhQe9bVZH3ljQhwkIGpHflS4rq4KlXj+c+GN2Hltz0Ji1LsUkffHEwQr77tNThmnTwWZ0Q6tWJxJWkgiFx9yv0AKf7hlmfY6pcfUhaAK1HW9Ol18oebkFwl8x9HV1Fob94Zuz8Z6ITPJozmg7vhKbT832BIzIpqfqkq9cDh2mf3LI2Rz69J6BJRO7WzFae424vUO7jvYEwraiwCLr80DtcXANe0WX6ud3b5uvawutaZjZy9kr+NJe00cAjQhlePoGZ2ibeu/4qkgzuzuHutcwKkoXLNePSB4mKNvd6xiRUw7Mk9Micf72EgyKR/T7
X-Forefront-Antispam-Report-Untrusted: CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(39860400002)(136003)(396003)(451199018)(40470700004)(46966006)(36840700001)(82740400003)(36756003)(40460700003)(4744005)(82310400005)(356005)(316002)(5660300002)(26005)(7696005)(186003)(8936002)(47076005)(36860700001)(4326008)(40480700001)(2906002)(7416002)(70206006)(70586007)(6666004)(478600001)(81166007)(426003)(336012)(8676002)(44832011)(41300700001)(1076003)(54906003)(2616005)(110136005)(86362001)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB10149
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DBAEUR03FT063.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: f5b9ad6e-8f74-4b5f-466a-08db005b6cdd
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Szbt/hYZY8svgWwqXFzhQxQ5avkyF0Ux5ueqI0kjXvu/sB5krXdIw3lE7QkcFNjrnfIZMgw2zF3GuQftpIblm8EDW1TGR4+E9daCEgkOLTlKpjgF1gtiXQ0LGKNHmF9uMgmf15J+s3iCc7+QSAmAgq3aYVx7Z2O0LQA5t1SvSv4iP7OLLt/oeXmf7tKiXw3AvsfFLCbzl2qwta8k8yoK/NHF0mCzd2Aol3u5viDryYZW8/+BcDn+/gUj2GctDePm5AEHn37dOipMvSoLDCPW0lcHECe4kURC/MdoP9jlDgRboaglt14gZif0dhU0mvi7IbtVGiNlv5aaxtowCHURdldH11ySc5YR+GZncHqbwee1Jk/i+pu3MWV3fyl4p9XVwiLSiymTGePCc6uQVm445xAtKAZoamHxbDI80eiv4Wm+eRhFPIvA3r2eh1SyXxSZH/e/wNWcjwJb/8VjlCtr8DMRqfpoS6OmOBacpt3XkJZvVgjJuEElDGPUNCe+2ZCiOBy9fIW1jmAHJGH0FUmVbjD8j1FLqmdZaPh4YsumiWkU9wjNtMQRpaMrm1KcmpP3n5MTGBhqCxbuEEzpftFjvHCzi2i1xCEs+uSegXOdd+nTMxmmilTp77UpnEg9c1/9KaDC43UiNrO/XtT3tkuCjZYW5eiHzg78CkWllmk2P6p0ojBYbpHTzcD0hm4gSB38pCCf88PMv79mfX4b0faiQSW7JCaZS2P91zUHfOUIxxw=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(376002)(346002)(39860400002)(451199018)(46966006)(40470700004)(36840700001)(8936002)(44832011)(4744005)(2906002)(41300700001)(5660300002)(70206006)(70586007)(450100002)(4326008)(82310400005)(316002)(8676002)(54906003)(110136005)(186003)(36756003)(36860700001)(26005)(7696005)(1076003)(40460700003)(2616005)(6666004)(478600001)(86362001)(47076005)(336012)(426003)(81166007)(40480700001)(82740400003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:44:04.3234
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e2bc0e4-5f08-488f-b44d-08db005bca8b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DBAEUR03FT063.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5596
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't implicitly rely on this header being included.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 lib/string.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/string.h b/lib/string.h
index b07763ea..758dca8a 100644
--- a/lib/string.h
+++ b/lib/string.h
@@ -7,6 +7,8 @@
 #ifndef _STRING_H_
 #define _STRING_H_
 
+#include <stddef.h>  /* For size_t */
+
 extern size_t strlen(const char *buf);
 extern size_t strnlen(const char *buf, size_t maxlen);
 extern char *strcat(char *dest, const char *src);
-- 
2.17.1

