Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3909C2D35F2
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731265AbgLHWJJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:09:09 -0500
Received: from mail-dm6nam10on2068.outbound.protection.outlook.com ([40.107.93.68]:52065
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726421AbgLHWJI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:09:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gvpq1Z7H2wIOk60G9qqjcF5OQmObg6OSJ5SSMeIf/iOeBk6OtbPhyX7L+KnTFPnBJ6Ilu5bcBksuMcX4ADAdRdrWEQSrQGRUIBzncrEngmNp2l36O07E62WMNZhPB++ImwDL9w0af1X/JnqXd94nlpNZvSDYl/ITuRysFZdJKHAoLBxc3g6qspnsBPckEAnvva9Ft2qbEt/DLo0Th41XgyG1iwBW/28JWsdSfytNIVPnh8qz5Zm2A3a0z6YuO4aPP3SBDoWz1L9ti0OxJXwCZltpdQrzxalVavTRfYhSJAW3dwFyQV7xKV7uDFKoSAwdHCFkXeMpO5t/VU/iw3czVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=awtWtr6qcudGngNaB89F/KCqTuyYWVy8YJE2RT9vcM8=;
 b=ZEr4A9HEchMJ0zcANYx/7F8bSKKcdcjANtNt9syzd/1sakH83cncmNwJZalof/Xu6J6ZqEXFTK17ICvn4nFPxY2ues+S+yC3uXkMWFJqy2kpGCC03bOC90gf4qXuCNUNZPqW1m/vu/7KgoMFftoWMWWBQrIP5Orf9c4wg7JVVO6NWXUnCgoaLg0AW6nYhDF6eVEF5VnusYhFJPseANuab0+gnvNK/DHSPllb4NZrff+4zlsFME9iVjZrwuULxK/Uk4F+KKgLxBM42GrCUuk7jSYiv1VJ5UZwocBnDBLS5OjjqSh5hYc5kHEhAuFLdd5JIkWy2LyH+ZQzIEyl62xoPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=awtWtr6qcudGngNaB89F/KCqTuyYWVy8YJE2RT9vcM8=;
 b=lS53bYMk+6XzC5Es77zqK8eXGYz9Wr3zbudafUpEXGM8dndds1rMVuWwRAZ9uD35tlAT8k4qsQ0FPBT5KV/ODnrFEvbBTT5kcjsSCzjMOKnaGA+ykx6gstd6SHdCuC/cNXvj0U1pGpjBAOjon+j/SaX3C/iChXzQ+qUzCnBbUpI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4415.namprd12.prod.outlook.com (2603:10b6:806:70::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.23; Tue, 8 Dec
 2020 22:08:24 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 22:08:24 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v9 14/18] EFI: Introduce the new AMD Memory Encryption GUID.
Date:   Tue,  8 Dec 2020 22:08:14 +0000
Message-Id: <3a2140b46673543a2c29b9450199a2793cc13cee.1607460588.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1607460588.git.ashish.kalra@amd.com>
References: <cover.1607460588.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0701CA0002.namprd07.prod.outlook.com
 (2603:10b6:803:28::12) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0701CA0002.namprd07.prod.outlook.com (2603:10b6:803:28::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 8 Dec 2020 22:08:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f78f6837-c818-4010-12bc-08d89bc5c828
X-MS-TrafficTypeDiagnostic: SA0PR12MB4415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB441594EE321187F461BCC75B8ECD0@SA0PR12MB4415.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c2QV8dIDyO280nKFG2vBb4cOX9SDeDgVaeTTZL0yopO78NjdHkCDbb6Gctb04/bTX7ATXrZne41baQ5tGX+6qAwLnIBB+tcCjqwk/5q7JV/0LJI8OdeMFUZRY8ybCbNOpixM3qp/4mzkUIkzgVnjy6w5XyBTRWjQOyGAXmml7seyerUiXK0J9nFQYzFJZy9lsvrYXaFDjIynyk9zLxwcfroB9fEp3wBhgCNOijc5+HtuUuUyXS0PNvqPMOObKfXpeTG/nqW8M0DnhtFjyqwSq6zZDlrdnOD+5AlFxeKGWnKQQ333IHPTWGIEvqZDKXSgIG4xquXQusRa4kRYkZhGKXhbB8KgJKutcORXIg/zBBDr3v5o70GnDoN+akxQ7Nvk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(366004)(34490700003)(83380400001)(186003)(4326008)(86362001)(6916009)(7416002)(16526019)(6486002)(5660300002)(66556008)(8676002)(8936002)(508600001)(7696005)(52116002)(66946007)(956004)(36756003)(2906002)(6666004)(26005)(66476007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?dFAmL9aUA2HQA+cS10T/w4SGddBZ/ehfk7jdTK9qSGxfiUBWY85lMZFvCixS?=
 =?us-ascii?Q?unF7LcnTv+ekuNNOXKcWcGVe20lHeh2gnBSp58Trnr+57L+NodjEhwI8eoPf?=
 =?us-ascii?Q?gbT5JgxhhFvh5JWaxq2JUEDSpRteu4gXKutxhrUYEyqf41YV43hwBvYpk4xo?=
 =?us-ascii?Q?HkWLvnjrnr47DFgjjjfAFm0j7XHYqfl/CuFWvDaCGbGxmaGldqyEMy09GLyi?=
 =?us-ascii?Q?jgc0wqIH7cxBvs+fNmaCONNlD2nkdgVFOk0kl4iomzCyY1ziYnzek8FU5Qh6?=
 =?us-ascii?Q?9Mndd0v75plqt4J6pd2qv6/XHEtoK/XaNll+xEPfU+OCORAGFIDGtCp1sjSp?=
 =?us-ascii?Q?aP2+1pgX9JCM5qJ2S2n+CYvnpV9sQMdOHnyHsg5HkMEo/zlzTVTarjEd152W?=
 =?us-ascii?Q?YDrmMeepvtimb7HTSCFaQjH4lDo2LSe3cgdMPu7jjd2Sg7/gY72Ctt8HERes?=
 =?us-ascii?Q?GaDnLpOgW/gFSQiK7CW7SIIPi2oNCO0KrI25a7/amfnSZZEQTC4SOrDKgWV9?=
 =?us-ascii?Q?IbldYIpJNtdRBjZ2mp/tOxVxljg65o1nVfrWy+7Vpt75SyTVU5SPHwhcgq2m?=
 =?us-ascii?Q?dabpuZen2XJ8LE6IQnQIEvp0qdn8KNW9aJg91tCAoq/2LWt4AvDCDo14Vrrs?=
 =?us-ascii?Q?YLnkrlL9tinujcqyimWmxoQQQMGhRmc9JE1PldAT8rEG6sxVWuOIak2IZ0ct?=
 =?us-ascii?Q?Kmgr8J5zXIrvNbW7GVCkjcR3zzuDdG7De/IB48KtwewjYcvZ+S/DEubYKQ8r?=
 =?us-ascii?Q?IaTyxub0J75snmq2zthg1hHrRt4XUh7ROaqs266NKprhS37viQkM6CgqXgmK?=
 =?us-ascii?Q?GMb8ACWq+co/imOz7QsosF+3w2n21t4Eqaoye8/FCUdBRTsEJwO+qdLRM46u?=
 =?us-ascii?Q?NFLD6rY+pGJ2+DuAHceR6FW6u32tUts0Z3D9/Ah/fvEZIPjLuUtQSiAUR8jY?=
 =?us-ascii?Q?B8UQ8MfJ6VmklsZrlLIEOhiU3ZVkfZKzieFQo45aqLV9liOQd8fgpgpEZkS5?=
 =?us-ascii?Q?a2tJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 22:08:24.0787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: f78f6837-c818-4010-12bc-08d89bc5c828
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0/XzO9y+zLeCfwQehCwSc0LV0neJPfwaXVpfKWW1Wv0t0UlWjxhEzIIbJQsCfsoVjxOlEc40YPVCb6cSVRUAJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4415
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Introduce a new AMD Memory Encryption GUID which is currently
used for defining a new UEFI enviroment variable which indicates
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
index d7c0e73af2b9..47d5b70ec058 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -362,6 +362,7 @@ void efi_native_runtime_setup(void);
 
 /* OEM GUIDs */
 #define DELLEMC_EFI_RCI2_TABLE_GUID		EFI_GUID(0x2d9f28a2, 0xa886, 0x456a,  0x97, 0xa8, 0xf1, 0x1e, 0xf2, 0x4f, 0xf4, 0x55)
+#define MEM_ENCRYPT_GUID			EFI_GUID(0x0cf29b71, 0x9e51, 0x433a,  0xa3, 0xb7, 0x81, 0xf3, 0xab, 0x16, 0xb8, 0x75)
 
 typedef struct {
 	efi_guid_t guid;
-- 
2.17.1

