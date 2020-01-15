Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15BDB13CDE8
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 21:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgAOUPk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 15:15:40 -0500
Received: from mail-dm6nam10on2081.outbound.protection.outlook.com ([40.107.93.81]:37074
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726362AbgAOUPj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 15:15:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NFJsuwmQpi3Yxtwz6xkbuHPKkWSNRYYGNjV5oPRLzr9KSsip69sRGqLVBY5+2PTY8ZuWyADI3tMZ1zu9f8hx0PdSExo9HgCLdVBQdO8Ysd3jYAS6VICQQFwsTqzKvX7UWN6gqbrCDOuTn+Udrwu4jWrXB13H4b2J3k05too2Rs/xRd9unNqTO25mapN4ftIg0zqIFhEy1vVQsc2O2Ptem3Z0wD5LFXPy3bPBiFBjGB4aGPJrUG8JTjSDTgSvXyrbZIFHqi+Nzmxf9K1V5xxYqrFjxAEDZiy6R8G5SPLFDtnQxB9XIvFGa7NxePfTpE0KuQhGTeUjxgWR71HecPTf7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hXLV3KKkyDnoTQGl3RnmhdhFl39LZ6u/2gCnStrvHJI=;
 b=ZaJqWzr+KCA3zozq9UWz8G3uBnh1jb5z6z4JKhYXJ4KiflvmzFo+DbXfKlwEM9eoE0dVYFj3femNwJ0+pZRxglDjZdJ4brC5BXcw4oqOa3bw7jU0M/TColT2+V4tkh/eArOO7Vp0unrQV1EFFq7+iYTDfUDkeWWyz5ltdiHcO8++mCWxwN4yvV+u8wxoIVf1DfwMgQtSpx0dvDIa0pkUHz6Du5WLNL1dLhSJcxOsnTS2lhk0JP4fEYcfK5wBWE7HUuj9hacmyI5V0T32kMiKBlJRvFCEqEGxlQjFd/vkpoWEixiH/+Uip4AO47RNcneiWoJIienhsn3eY4xIUOKeGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hXLV3KKkyDnoTQGl3RnmhdhFl39LZ6u/2gCnStrvHJI=;
 b=ArSL4MDMRYanLxCrkyRI94r5RUXgfNMtDBiAf3KdzLyAY/mJ4A+cP+x8ohKjEOFZevzQ6duJe4V/DZ0elhLfrhkQrOuFa+d+YrS00VoJVEO24ga63a9irKxOU0kw6eqhOH15aF9fFi+NVJD2FqnXrYlQjDSzc5QiAC2SEre2BB8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Babu.Moger@amd.com; 
Received: from CY4PR12MB1574.namprd12.prod.outlook.com (10.172.71.23) by
 CY4PR12MB1702.namprd12.prod.outlook.com (10.175.61.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 15 Jan 2020 20:15:37 +0000
Received: from CY4PR12MB1574.namprd12.prod.outlook.com
 ([fe80::610a:6908:1e18:49fd]) by CY4PR12MB1574.namprd12.prod.outlook.com
 ([fe80::610a:6908:1e18:49fd%7]) with mapi id 15.20.2623.017; Wed, 15 Jan 2020
 20:15:37 +0000
Subject: [kvm-unit-tests PATCH] x86: Add a kvm module parameter check for
 vmware_backdoors test
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org
Date:   Wed, 15 Jan 2020 14:15:35 -0600
Message-ID: <157911933557.8219.11014260858807770513.stgit@naples-babu.amd.com>
User-Agent: StGit/unknown-version
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR04CA0106.namprd04.prod.outlook.com
 (2603:10b6:805:f2::47) To CY4PR12MB1574.namprd12.prod.outlook.com
 (2603:10b6:910:e::23)
MIME-Version: 1.0
Received: from naples-babu.amd.com (165.204.78.2) by SN6PR04CA0106.namprd04.prod.outlook.com (2603:10b6:805:f2::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.11 via Frontend Transport; Wed, 15 Jan 2020 20:15:36 +0000
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 216ea564-0c11-428a-22aa-08d799f7af20
X-MS-TrafficTypeDiagnostic: CY4PR12MB1702:|CY4PR12MB1702:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB17020E45A6A5D0409802B11995370@CY4PR12MB1702.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-Forefront-PRVS: 02830F0362
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(199004)(189003)(16526019)(2906002)(186003)(86362001)(52116002)(7696005)(26005)(55016002)(6916009)(66556008)(478600001)(4744005)(5660300002)(4326008)(103116003)(316002)(956004)(81156014)(8676002)(81166006)(8936002)(66476007)(44832011)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1702;H:CY4PR12MB1574.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dpXZiCsVOuvJVMV3SWoWKcmxZP6IDQl3tL+dwgYf6iVtqeDlG2C+vqqPL1/OuzXVJGDwGbaqRHj0OPehqzEEd+KRam6aEQaiP0kJonJPdQ1zqmGokmBpGZzwo5ID64+2TA4eQt3+L2hO78h729RakzcmDPrLfr93RYYNKmGSM7Ag9+MctePVww3bIPc7GZjJXY/ri9MtrRXUalfMvBNWvzL4y6g0cwYVK4KpAsQ7Dz3l8kUS8WAwKUijrw0Zp5t+9nqOizXOyKmcigvQtaKbmhWwAdB4h6N2VuUL0E4qLndLJwVnsoLkcx6xb/jmRe9gM4NcYAuu2oCF6073gnF08XaZTPvHZnY8y/PY7vUfsf+0cPCncZnwpcw4l0iIdYyv7oyZsS9yTiiVa9oIvH8tv0IBLtjRN4BpSinRjiK4Xv6lb4GJJPRGzxjJ0Bp+wHVM
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 216ea564-0c11-428a-22aa-08d799f7af20
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2020 20:15:37.2164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ie6/4ssyvfYhNxOXOrw3nE/AGCRJLBx7LC1UKM9ug9mrDHLtDsvH8fuUfZbGRmvd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1702
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vmware_backdoors test fails if the kvm module parameter
enable_vmware_backdoor is not set to Y. Add a check before
running the test.

Suggested-by: Huang2, Wei <Wei.Huang2@amd.com>
Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 x86/unittests.cfg |    1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 51e4ba5..aae1523 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -164,6 +164,7 @@ check = /proc/sys/kernel/nmi_watchdog=0
 [vmware_backdoors]
 file = vmware_backdoors.flat
 extra_params = -machine vmport=on -cpu host
+check = /sys/module/kvm/parameters/enable_vmware_backdoor=Y
 arch = x86_64
 
 [port80]

