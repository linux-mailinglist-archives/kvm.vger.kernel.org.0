Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16CBB67E444
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234149AbjA0Lzd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:55:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234322AbjA0LzC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:55:02 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on0621.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe02::621])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647C378ACB;
        Fri, 27 Jan 2023 03:52:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kO8hkE7cAfjRQTMEdbSYVkx4yeMpZCun0pWnYUIRFJg=;
 b=nLKdm8NMlONskRd10en+rfB3Pp9M+pjmgWdV1jrvf5lpFU16578qxxCECTBR0DmYZvRN0wrfKYo89N1JObK751g9EGxQrT+jGpUN1J1morxpK3AeqlnIjm+E0IOp0EfEPA5eU/L9DRIg/1Zo7vuW8IxzrG7+aulOMVluKEmtU34=
Received: from AM6P193CA0092.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:88::33)
 by AS8PR08MB9645.eurprd08.prod.outlook.com (2603:10a6:20b:61a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 11:44:01 +0000
Received: from AM7EUR03FT028.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:88:cafe::e3) by AM6P193CA0092.outlook.office365.com
 (2603:10a6:209:88::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:44:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT028.mail.protection.outlook.com (100.127.140.192) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22 via Frontend Transport; Fri, 27 Jan 2023 11:44:01 +0000
Received: ("Tessian outbound 43b0faad5a68:v132"); Fri, 27 Jan 2023 11:44:00 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 403469eb871d398a
X-CR-MTA-TID: 64aa7808
Received: from 218f26c7afe3.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id B97B7030-A044-480A-8423-9229F3B28E64.1;
        Fri, 27 Jan 2023 11:43:54 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 218f26c7afe3.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:43:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L4SFUav4NYB9p52IOn/oOn7CKvWhIaSlYlgvY8f2IwoMTaaP7dCFcTG8ktBcZbAmanqDc7zLlutfnO+uHc8edTE2OzHrlxkCm/3Ahokjks8ZLpb+Ge2unWyqjwGVRWjOeBhrbvr5884rTKuwPIfJ85pN+g7h9sgaWSuCQQSVGHna5Er0Fd0lfq8DcOlx8q9GWhetO4p7Klo3kny1r5ACi+ffYu0sGssYhwu3e667q5LhZLtzUoOL8Ze8sSpY0E4clIluZMhzO/QqnIMOEQKxuK8zJ+18SM1qKgvgSMnfVCTv2d92MfW2gGeAvD2bltT/a/5r2XtmLxj8WcfspbikkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kO8hkE7cAfjRQTMEdbSYVkx4yeMpZCun0pWnYUIRFJg=;
 b=ime8B6GnJrjUTrsj8PBUy1ojJyVRjw3clnLiNKYn+IM2yb7aiRh6uRWLFgv8UTvLwLZSOJRBoO+RPSNBVso4OsSckxxu1fI2k+gT4C2F03ha7d+xtE25OCRmYBo5q7QIYXzlWw/ThBer2s57zh2RulvXpxXIWt9q703IhsrIt+cyuCF/+T86pRqK9i4a+w2jkrLmWvOimmGBx1mkEEL9pKgauvv+YJW3FvKLNjCIafo6muSNUlqsja215W4SnNJB1pVgGAd/HSqkL6bajurregPlnCI9FAPHQ8tULEeoTst0y2N0FlZnIZ67ZDBYDKS2TzY8QG5UGSe9hZrF/no5DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kO8hkE7cAfjRQTMEdbSYVkx4yeMpZCun0pWnYUIRFJg=;
 b=nLKdm8NMlONskRd10en+rfB3Pp9M+pjmgWdV1jrvf5lpFU16578qxxCECTBR0DmYZvRN0wrfKYo89N1JObK751g9EGxQrT+jGpUN1J1morxpK3AeqlnIjm+E0IOp0EfEPA5eU/L9DRIg/1Zo7vuW8IxzrG7+aulOMVluKEmtU34=
Received: from AS8PR04CA0010.eurprd04.prod.outlook.com (2603:10a6:20b:310::15)
 by PAXPR08MB6640.eurprd08.prod.outlook.com (2603:10a6:102:dd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 11:43:50 +0000
Received: from AM7EUR03FT036.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:310:cafe::1d) by AS8PR04CA0010.outlook.office365.com
 (2603:10a6:20b:310::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:43:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT036.mail.protection.outlook.com (100.127.140.93) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.21 via Frontend Transport; Fri, 27 Jan 2023 11:43:50 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:43:48 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:43:43 +0000
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
Subject: [RFC kvm-unit-tests 27/27] NOT-FOR-MERGING: add run-realm-tests
Date:   Fri, 27 Jan 2023 11:41:08 +0000
Message-ID: <20230127114108.10025-28-joey.gouly@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230127114108.10025-1-joey.gouly@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127114108.10025-1-joey.gouly@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic: AM7EUR03FT036:EE_|PAXPR08MB6640:EE_|AM7EUR03FT028:EE_|AS8PR08MB9645:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f09c37f-d124-4a56-72f2-08db005bc8b2
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: BRJQ17pHYeh6le9LoVuzDMU9zzZO1bzgkGCoP+3Qfew9Oen/RG8qxWTBBmxPP6hZ8xk4IR7mFeJypZ50CE+ffhsj1zUlUsqgLf6G3hZ4Sc8MOnOIMF+LsNsGMIGpe0sKyoDxZUUwLo6k92WvoxmbbGX+Iz3r/1BIfky4t9DMQzNsuP4wlxsvxgDCvmGhpIoHMoC/LHq1yeCyA4QojIgPJxJdt9noHEqTwktzmxfkv2BFVOYxfh/PBpGY0/nL0aKgoksywhWwJiNNiMdDn8wlFAdQ+2FskurOWpCRUKq1y3C+9ujzMu1MPwMgdTEfdc9JdN0JdUO1Va4w39oF7pvunZyTqTvb8m2jib9vw+MONIzuGeN2RbCV99eXICJjtDRh0KqJLieIwSU/TfYCCsmfSfzAkDH6wWpQJURkTESqNlOcKs4JLbiILEkOqP4d4JysReyMAPcqi9r/r+Vcc20B4BaLRbIaq6FFY0EGwVTsZJLaCv2LKWmRR75V4YoWOr9nhEMLOUl2KjX+yj1S+QUCs0AIxVAwjVsOHjO95+m6FdNjX6VgtSauy+fADOJmztNMRB3m15HoIQIkWiVyjXnCDXYdNH3cQTVovG0U+S7xThYEOVmp5nMnE7jneKbhc+WLFDIomrl9uA/aUTKoiG2cqc1/5wCeB5ndV0vSaALNI1csM2iWTIkea/qBqgW8aMWc4LiGFqXPi8Ig11/xzNO4D4LTZjMjEG9zZck4UqtqQIGIb5FgEAlf0eIm4/qQQ8OS
X-Forefront-Antispam-Report-Untrusted: CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(376002)(346002)(451199018)(36840700001)(46966006)(40470700004)(36756003)(82310400005)(81166007)(316002)(2616005)(478600001)(186003)(26005)(1076003)(54906003)(6666004)(40460700003)(356005)(70206006)(4326008)(70586007)(336012)(7696005)(86362001)(110136005)(82740400003)(8676002)(40480700001)(426003)(44832011)(7416002)(2906002)(36860700001)(47076005)(5660300002)(41300700001)(8936002)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6640
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM7EUR03FT028.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 689b1c3e-1a76-4b7e-4fef-08db005bc263
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xc6Azx8JI2BcznU9+WhqXjGLziTYeQPSduihf7ah6zRHNPhbQfLDBjvoy6CDODMElN3LTXToDVO6Ia/l56ReCpL5P/idP7vkgzZbu7XcpHJnJpvN2tU6zml7sTKdvSB1zxUTqK/y5UWjSurfQ67rG4nW4HUq461leryou3E0qaFhcQDuJDVos+3NkZQba5iBsYnZygD3Yktx3Y+1i4laCmYRmrajuyEb+MRT8yN24DDZ/C8jHi2TL+8e4OQfscA2UYIeKt8IhPkrLYkFsd+9OAL87lY/e3Zjvv7Gg6lV5Xqc1P/S5024+0PFoEmHMGkGU59iCDWK23qQudHrZ7l8e5so+fE4jdolN+7JbXuv6NWyreU2xEzKGSQIWWz6o0AQULgEyS9WzFOtBLLkLYeGniIYzL7VdtzKI9+AKDs9jjTIT/w0iR6lcNQOZENdSXHfaQlzJ8RY1k+NzDlzaFaUJymTzMsIm++71824fanI2Zt0nsQWRR0t4CXGVRl1Jiem8cXVzBFLhN+LkOa/JyfdS+gkvOAp0baHKatJXbrXbA9AgTRNALAtgK2p80mw6Z4+Dcv/6xjLcwm3jU+D1ZDQezY+oLCV/lt8qVPP7YAmVsr7KUCnbMboepFXi6Y+zJdXa9hjhpTx183VRzZvAs6OBeH8aNqcQtLyZ/DqtdvWvOb9lIMFiwZfhiPT8flK3QwHPAjKhsixgXTCrbCwfs/BRrs1HrkdYcq6WYMqn4tDkeU=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(376002)(39860400002)(451199018)(46966006)(40470700004)(36840700001)(8936002)(82310400005)(4326008)(1076003)(2616005)(82740400003)(81166007)(44832011)(36756003)(5660300002)(186003)(2906002)(7696005)(26005)(478600001)(86362001)(316002)(54906003)(110136005)(40460700003)(40480700001)(6666004)(70586007)(41300700001)(70206006)(8676002)(450100002)(336012)(426003)(47076005)(36860700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:44:01.1437
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f09c37f-d124-4a56-72f2-08db005bc8b2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM7EUR03FT028.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9645
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,SPF_HELO_PASS,SPF_NONE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

Until we add support for KVMTOOL to run the tests using the
scripts, provide a temporary script to run all the Realm tests.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/run-realm-tests | 56 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)
 create mode 100755 arm/run-realm-tests

diff --git a/arm/run-realm-tests b/arm/run-realm-tests
new file mode 100755
index 00000000..39f431d5
--- /dev/null
+++ b/arm/run-realm-tests
@@ -0,0 +1,56 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0-only
+# Copyright (C) 2023, Arm Ltd
+# All rights reserved
+#
+
+TASKSET=${TASKSET:-taskset}
+LKVM=${LKVM:-lkvm}
+ARGS="--realm --irqchip=gicv3 --console=serial --network mode=none --nodefaults"
+
+TESTDIR="."
+while getopts "d:" option; do
+	case "${option}" in
+		d) TESTDIR=${OPTARG};;
+		?)
+			exit 1
+			;;
+	esac
+done
+if [[ ! -d ${TESTDIR} ]]; then
+	echo "Invalid directory: ${TESTDIR}"
+	exit 1
+fi
+
+function run_tests {
+	DIR="$1"
+
+	$LKVM run $ARGS -c 2 -m 16 -k $DIR/selftest.flat -p "setup smp=2 mem=16"
+	$LKVM run $ARGS -c 1 -m 16 -k $DIR/selftest.flat -p "vectors-kernel"
+	$LKVM run $ARGS -c 1 -m 16 -k $DIR/selftest.flat -p "vectors-user"
+	$LKVM run $ARGS -c 4 -m 32 -k $DIR/selftest.flat -p "smp"
+
+	$LKVM run $ARGS -c 1 -m 32 -k $DIR/realm-ns-memory.flat
+
+	$LKVM run $ARGS -c 4 -m 32 -k $DIR/psci.flat
+
+	$LKVM run $ARGS -c 4 -m 32 -k $DIR/gic.flat -p "ipi"
+	$LKVM run $ARGS -c 4 -m 32 -k $DIR/gic.flat -p "active"
+
+	$LKVM run $ARGS -c 1 -m 16 -k $DIR/timer.flat
+
+	$LKVM run $ARGS -c 1 -m 16 -k $DIR/realm-rsi.flat -p "version"
+	$LKVM run $ARGS -c 1 -m 16 -k $DIR/realm-rsi.flat -p "host_call hvc"
+	$LKVM run $ARGS -c 1 -m 16 -k $DIR/realm-sea.flat
+
+	$LKVM run $ARGS -c 1 -m 24 -k $DIR/realm-attest.flat -p "attest"
+	$LKVM run $ARGS -c 2 -m 24 -k $DIR/realm-attest.flat -p "attest_smp"
+	$LKVM run $ARGS -c 1 -m 24 -k $DIR/realm-attest.flat -p "extend"
+	$LKVM run $ARGS -c 2 -m 24 -k $DIR/realm-attest.flat -p "extend_smp"
+	$LKVM run $ARGS -c 1 -m 24 -k $DIR/realm-attest.flat -p "extend_and_attest"
+	$LKVM run $ARGS -c 1 -m 24 -k $DIR/realm-attest.flat -p "measurement"
+
+	$TASKSET -c 0 $LKVM run $ARGS -c 4 -m 32 -k $DIR/realm-fpu.flat
+}
+
+run_tests "${TESTDIR}"
-- 
2.17.1

