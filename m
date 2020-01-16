Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDD313F9C5
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 20:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729538AbgAPTru (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 14:47:50 -0500
Received: from mail-eopbgr760081.outbound.protection.outlook.com ([40.107.76.81]:20804
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729485AbgAPTru (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 14:47:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VkaC7PD3r8IRDgD4DdTThxOEhrUvHApymGMixLNsUkMxzlbJkf4FSJ1eigbg4i+RiQsUYf21bAetyZRcDphYsTYTRuZN/x5X3vZJ7oAWIsdlwwDSYdxUCSJlZr4A6oV6e2BYmT/KxaUrlm5+TYJ8Pr3j4DbbrMFsLDd+0zU7Lmxf/nRJSDfjjh9bdBuOTU68KC1vq0kPBeLYZbhIRDcdiZNclVI/xqRJ5Kfa/rcBZerB3ymzZrK84uWxPiQ9Zxs1tCE8UQqwsSO7Uk2CuEW2PzQqL2syXzJlbu06+5+ikm7KL5mUyzXztI0Lxqvhe18Lm8zjS2EP9Rgxdlc5c/NfVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ofDM2olXIfCyrBbqaAPvqsScVB5fJMiXCWaadGsq018=;
 b=IgETSF0AXMDx+oY9CS50ypYI85QEu/AtkBNswHEHeRKoA94iKE+3G7W7HbmYbmZTiqTjYFXUgkNCWFU47hEFlOnPmK4L/qPh9xsMM3MiVsML4svudzOs4X6llO/V+u2Ir82kSslDx+svGHRuUS13/wCaaYEuVVquugMWr/lMWbXUkUyhl3papvIfOF2rPIa4yeGjw5EbfK2YoFtQDCYGq1vvf5XCszY6VIbiwRu32hLx5XwmgsnAUDXJFdKW61b50ODU4EWtaaE3VS4MX47jsiuaJqcM+GUjRHwHi5quQByPJphplRd8R5ULRdC6BYnOtOakMwiFQpcHxIhJWxQRzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ofDM2olXIfCyrBbqaAPvqsScVB5fJMiXCWaadGsq018=;
 b=icdPi1ZKTwIGLBV0HeDrQ7yzFYrZSDfSeF9L5yNvMztGwRQFzS3ejr+sVPpGiUYfG9YL8FnaBwYNCFz/ZdkCpLbcE14dbeV3yYmw1GiI5tqGIW5g/UvlYOgQ/Fx/s7rXwHI8lCtYroSgkOXnAG7EuqmUYPapZc7VhAz4k5BCTDM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Babu.Moger@amd.com; 
Received: from CY4PR12MB1574.namprd12.prod.outlook.com (10.172.71.23) by
 CY4PR12MB1799.namprd12.prod.outlook.com (10.175.60.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Thu, 16 Jan 2020 19:47:47 +0000
Received: from CY4PR12MB1574.namprd12.prod.outlook.com
 ([fe80::610a:6908:1e18:49fd]) by CY4PR12MB1574.namprd12.prod.outlook.com
 ([fe80::610a:6908:1e18:49fd%7]) with mapi id 15.20.2644.015; Thu, 16 Jan 2020
 19:47:47 +0000
Subject: [kvm-unit-tests PATCH v2] x86: Add a kvm module parameter check for
 vmware_backdoors test
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org
Date:   Thu, 16 Jan 2020 13:47:46 -0600
Message-ID: <157920400074.15031.16850091609715260458.stgit@naples-babu.amd.com>
User-Agent: StGit/unknown-version
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0072.namprd12.prod.outlook.com
 (2603:10b6:802:20::43) To CY4PR12MB1574.namprd12.prod.outlook.com
 (2603:10b6:910:e::23)
MIME-Version: 1.0
Received: from naples-babu.amd.com (165.204.78.2) by SN1PR12CA0072.namprd12.prod.outlook.com (2603:10b6:802:20::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.9 via Frontend Transport; Thu, 16 Jan 2020 19:47:46 +0000
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a0cbe64c-9472-4cba-d3e5-08d79abcf637
X-MS-TrafficTypeDiagnostic: CY4PR12MB1799:|CY4PR12MB1799:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB17993C2D898840B29ADA00B395360@CY4PR12MB1799.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-Forefront-PRVS: 02843AA9E0
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(189003)(199004)(956004)(81166006)(6916009)(316002)(26005)(52116002)(103116003)(81156014)(7696005)(8676002)(2906002)(186003)(66556008)(86362001)(4326008)(8936002)(66476007)(478600001)(16526019)(44832011)(5660300002)(4744005)(66946007)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1799;H:CY4PR12MB1574.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7S6WSiAtg82tegA/A1gQilNxG/YbDZWmWn1yr/6rPXlWUyYq6GxdwKYpSfEFDD5tivxvjU9Bu9lFgY2yZVoH0nC5fh6fYGTBuy2onLzLrGTdmZyfwCVmVA8N7HPbVVgAfuJK45/W08OREszNbCkm2D8dvu/hLKDmNA7HBnb2Q6zvKq2ZOCr3t7t1bKp1yskNSn6awCKwHjR5uBwCu58rMFrgFuadarR7rkwG9O0OUZtpY82RsADgmLjpbvKhFrBIrrtXb7jM4LwvLvFK5MYtpejTaMmgvT4LaJ9F2HB32IpcTzIDrsp0cAb0J2n+mMA1CcaulzEz3UypTFiRGtsPnUvOURYL4uZ1WCicaaKwIOJmkLWDXjH8NKaT9+u2M7yRzMBwdh57vZhhTxXezEDaoY41x0PV2sCegnf/iJ9iJRi3MghYAuCKjyOUvawrwW+1
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0cbe64c-9472-4cba-d3e5-08d79abcf637
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2020 19:47:47.3596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Fw7y35/sbnIqmkaVF6Kc3Iyz6BYIemqZwrRJc1/VBgD1VsAbu9p+eNR2+GcoWya
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1799
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vmware_backdoors test fails if the kvm module parameter
enable_vmware_backdoor is not set to Y. Add a check before
running the test.

Suggested-by: Wei Huang <Wei.Huang2@amd.com>
Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Liran Alon <liran.alon@oracle.com>
---
v2: Fixed Wei's name.
    Added reviwed by Liran Alon.

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

