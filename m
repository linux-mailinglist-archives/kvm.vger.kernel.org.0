Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7416369682
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 17:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243142AbhDWP74 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 11:59:56 -0400
Received: from mail-co1nam11on2087.outbound.protection.outlook.com ([40.107.220.87]:39777
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231858AbhDWP7x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 11:59:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ej32xX4t606nJ5gJx3fgzJ1+1sTv8yHld3XkSHg0LHpwB7ML63UiWV7qOcIgwap5kNh1PeEIhOMSnoKWxoHnm9GjFkgfLh03Tf4U3mZd+pBOrq8Hvfkvs6Odsn92f7y6lL6HrZxJQhl0Wg4mmqZ0uGJ5Zz5JMqKj2u1Gn2ux9/F2tBxoiz1kT3pNhT6ZTihYhylMW3qhL3XhTAx+dL2eXcrdd7zy6sH9vAJrj8ND5BdaqixN/ZN1tMDyFKXoXBKwnosvUQ6pFQNCVSKcTpip71lTmve0izSCH9EXywT12YpJGaZUDNvgC6Oyg5CdH3GenMj1WwWAR40y5hBSFfiEJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kP40PdU4Z8HHa6wnZVnRT/zhr1u8HNB3yWt0AcQt+JM=;
 b=JJ1sJHLx/aciHgNV17A8a2S8GHyfKVZcTC6VO4p28APlporr2nVGS+0yG7/cq4mkDq5j+1HIwPTNZ28YO1PNZEdc6P9bFc5/B0BfOqWElTPfL9quG2QJhJUh4wXiB7Ea8SAEbHNnrxN+Fl7LG/bmW8qkpq8dqsaok8XdCmTAgxHcHdv3qnVsT6punYmNCWVUGbJrSqu8lpMAiADCUmdmWlG5uMgWVJh+H+4fPoQuzI1SSmxFmHxFNIXi7+AYcEAofUIxrtIVuETBeC1brWCTZ/RcUmJuHBgnhQybmCV1iAS6S+4WXJKYBy6srK8irBCL6uRYXpCqFXgKVbn8zQPK/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kP40PdU4Z8HHa6wnZVnRT/zhr1u8HNB3yWt0AcQt+JM=;
 b=RXa1i0ksoN14HGR7pD4spY6qmhRIDrdBuoTswiQUQKxnIrRkXfjnMZOAiofDz+XGNnajuZ+Iqn0beDPFtNcA1kzQUY8nqAtQDICpINqPO41y79TjuXdpq8R2grH7Wo4c5Ixuh65ui0Nne4VZuhNsrnkRkQNb/l11tCYOaVr97fA=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2717.namprd12.prod.outlook.com (2603:10b6:805:68::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Fri, 23 Apr
 2021 15:59:11 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%7]) with mapi id 15.20.4065.025; Fri, 23 Apr 2021
 15:59:11 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v2 3/4] EFI: Introduce the new AMD Memory Encryption GUID.
Date:   Fri, 23 Apr 2021 15:59:01 +0000
Message-Id: <f9d22080293f24bd92684915fcee71a4974593a3.1619193043.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1619193043.git.ashish.kalra@amd.com>
References: <cover.1619193043.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0039.namprd05.prod.outlook.com
 (2603:10b6:803:41::16) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0501CA0039.namprd05.prod.outlook.com (2603:10b6:803:41::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.15 via Frontend Transport; Fri, 23 Apr 2021 15:59:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9919eb28-9018-482f-62d6-08d90670bc3b
X-MS-TrafficTypeDiagnostic: SN6PR12MB2717:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB271784571ED419117A77E28C8E459@SN6PR12MB2717.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6oTDrPrNveAO8JzZIKc8xPr5m3IktJ167Od+PPJJC5NeJhArRsH17vKrOQ0ekqgK81p8i61pBxgNlRjHn+zKVHKtZINucXNJftu6RvX6cSWW317mE9h6WtzaxXW0hSM1kPih4PtRmma1bx2EX5bJ0+VsrPXSZ0ohMMD7roeFU+M0Ed/4ziKWmvfGEsHsmVBwo/Oy4nkGh+NN+RivgbHqmh78UnUZZlxj7H2+h7FnqIn3OLeJRKVLM2mTs/vqJTwqh5ZJoxved46ISL7SaBK44vgT0ibHMvPUj/dKz/XAHjQCEz0puOeF4UX3mIfrQ9YY8pHIwQQs59zTPjTo3XFhrS6cYbs6PkrhOueE3Xs8WrvkTeK2ar9kvwK9P9gGAi7d7a61PQ74Is8LVrtl5I2kyi9K8pgtdjEhX5yWISUSlaIGcuu8UzPVdmbYHRh2dmV/keyaOxfkB9jFPIcI1EY0psSBMV3o6vIl6EkQzzpv5nv8Y7Oyr4vJ7wvOEvnKv/2qjRXXWeWNG8uvq8XoM/+3k356vpwymAE0K1pXkwBg8FZqXkpCY2+MPS72ciNnuvgXODQRPpI8L9PolBFOXRIzcj47VKYTzWjBRYlcat4EliycRZVewtknAYc6ou+yImC/Ng0e7f4dZjHZEw6ODyO/0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(83380400001)(66946007)(186003)(956004)(6486002)(38100700002)(5660300002)(316002)(6666004)(2906002)(66556008)(66476007)(16526019)(26005)(36756003)(2616005)(8676002)(478600001)(7416002)(86362001)(38350700002)(6916009)(7696005)(4326008)(8936002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?gY5US5g8gkOLNPKN91a1iIovq7bJ2dliu/Hf5D1qQEOsz4npIt2Az5wXdkmi?=
 =?us-ascii?Q?ytDk871YMqH3iIX/Wxagva6cANKdBCVLdafXkrK+kLvnBttWU7thz+c1+CA2?=
 =?us-ascii?Q?nqMs3F9M1kcpoXSZOGKpbxPitmPhme7hFyC0cO4RCbY8WvqJAif/8UyRW2c3?=
 =?us-ascii?Q?4rx9sQiclGwpnDpHAui5dLzMc2XPReY9C4tFeWV9LpONDXaHZ/IVEJ+bWWhO?=
 =?us-ascii?Q?vfg3PWFndTSLg2SDDP2nY8isR3K/ySfL2HP3ExWMeDPARaJoBEygdTvSHAm6?=
 =?us-ascii?Q?f5uZEuKLzwRe2AAWBVtR7o0Ss8TdZsEFsbBzAcl0Rb9QOF4wKGaHLxBZ4wsW?=
 =?us-ascii?Q?X8mI2spjedKVIH20eCozlMoBn4a/7vG1LdBIt3nSr0RUaPxZL6jRZuz1ch7X?=
 =?us-ascii?Q?MXgLaC5YFFH62GyatZNTW+Kb7yYQ1tIL2vt0LtnHOvjKGZepNkd2A7vm9QOv?=
 =?us-ascii?Q?xK8pll3FirSg7MGknAAjzrWmivCfasGGpiNl8msNrmqes7dHjE95f/kWNWFa?=
 =?us-ascii?Q?GfuXg+EcMS3OsplOddmDkuiMbZvwqyMqOkeldIWV//S9vX38kz1C47LQiMdU?=
 =?us-ascii?Q?VANqG4va2SkKUvHBb72RMF3aRfvb2b49/6f2RZKctN7XruRDuNh3a/RAfSeU?=
 =?us-ascii?Q?soBnD7SbmogQCoWCY43iEYA1TYMv6NBhGQlhke6Zykt/C5eo44P8yNTAvRRb?=
 =?us-ascii?Q?aP32N6o0N5enV2LS0atzsWIIU1y7/B3KPuctfhVsxuKAkRFa0GhvQDU9yTZz?=
 =?us-ascii?Q?ot/gis/xfEngCPA0EKqT1JjXaml4xJnHAbGPWom5z71UICD/tHNPPyQa0Lyp?=
 =?us-ascii?Q?HXX5TGwptyyPQwmrwDomhVJ7qPL0GPA1F5HNx47jdA3hlF/imTW8+ni4v4nL?=
 =?us-ascii?Q?vlifEwEIpBNDSsNYEsn+q/vR0jmB7JrFJ/Bw8NcLvzItlTHk5b+laxNCWY9g?=
 =?us-ascii?Q?orU+O8hf4gwGI3I+6MrlbfzxjBQ66XRR67ZVIUSrAb3rBre7lEXUfoq9URIj?=
 =?us-ascii?Q?uqMf8x7gnQkwctHFLQ16+Ck6qrrF+lTtEvi1U/bGoiVtnZBZ0/oC+SnC4uOy?=
 =?us-ascii?Q?ngcge/qROGelZASnJr5CFz69WEYaZ42X4zE7O2fNToLUl3Vk8pd3CpdPn5xD?=
 =?us-ascii?Q?ltCRFm/dHujO9wX91qh4UBFBHyCBnRnn0xcOvK7lE7oAlNCbknrvYVXm7F3h?=
 =?us-ascii?Q?GvyMnIg+XoC81lu4NbKIwA8+Wzwdsda2CnY2k0eKAN0vZgvXaKw13rH4S3/8?=
 =?us-ascii?Q?8pieWS9hW78Bvz+oFV7uY7vxW+AHU8JtEou7b/YBgHl6rJ3fJhYHeo2BH9qx?=
 =?us-ascii?Q?2VYyjMMQDD895ZIG6SgJYGiV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9919eb28-9018-482f-62d6-08d90670bc3b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 15:59:11.5367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qBRCBB4Iaswo/GCA8h1L4zvEU+n4LzEa9Xyl9RyaVi5AT0hGu5ACA04ERdxIY61pV6YqhECA7MT22jhs4OvBmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2717
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Introduce a new AMD Memory Encryption GUID which is currently
used for defining a new UEFI environment variable which indicates
UEFI/OVMF support for the SEV live migration feature. This variable
is setup when UEFI/OVMF detects host/hypervisor support for SEV
live migration and later this variable is read by the kernel using
EFI runtime services to verify if OVMF supports the live migration
feature.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 include/linux/efi.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 8710f5710c1d..e95c144d1d02 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -360,6 +360,7 @@ void efi_native_runtime_setup(void);
 
 /* OEM GUIDs */
 #define DELLEMC_EFI_RCI2_TABLE_GUID		EFI_GUID(0x2d9f28a2, 0xa886, 0x456a,  0x97, 0xa8, 0xf1, 0x1e, 0xf2, 0x4f, 0xf4, 0x55)
+#define MEM_ENCRYPT_GUID			EFI_GUID(0x0cf29b71, 0x9e51, 0x433a,  0xa3, 0xb7, 0x81, 0xf3, 0xab, 0x16, 0xb8, 0x75)
 
 typedef struct {
 	efi_guid_t guid;
-- 
2.17.1

