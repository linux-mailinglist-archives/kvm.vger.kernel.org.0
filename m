Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569911BF357
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 10:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgD3Iqj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 04:46:39 -0400
Received: from mail-co1nam11on2054.outbound.protection.outlook.com ([40.107.220.54]:38369
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726871AbgD3Iqi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 04:46:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UFh/rjaUknIpy4DSETGUzzBylo0Ong9jf5eRnuv9ogF844Okfs13X4APPo4Pl9trMurhbFY6Fx4MJw739p+E/dtOcgoYB6L1fjMoAog2oqmmPwzwJd3T4rJ+U+pLXriVECZzpZ5iRxuzzSP/BBs+o0JOWOLwHgIYJTMnBEQh0xMN2H186+HjAG6grmHX7PfM84KoibaS2zO2PDs8u1m6NSR7Z5cr4AMX/siyqfT/pxX23uIJUY7IItf63IC8f34fRwaCVFQCA7fzlBBnresmP5Ri5v4s7BG6/mXCLA67kBJ1DSq4iZThleGIFjYgJOHD/Sy4VQbuFi4vpd7lk6WLvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3D/kK5cQCLuGeO7hC945SONJQJPxE71P6AsK3LWgYTk=;
 b=oWNu+5zIIG1ofDbEyAsopPnx9h5ubCLMZRRKuO6AMTKH3e3OElFlnoID2CFJVj0RmpDrDNFCf++0qBIcEcCWkYj32qlA5GXpSoG3LoawX55RvGk+iZqB0bczNsDlwHe7sjP3C6JM6ttFdX0Jq/v72eWYXDRIv8xd9j72apEZ/iTN8kF8KWj/PGqQz0WMopJFj7pPxycXVmJn35PFiy1KsVvriQMaVUGyPr2kKxHI/gKLty6B6bUPLuCurZRDNkKNacTcXzqF1POn5bWlq1BwjBBPfiGby7CRr8VI/3AYtsHlI4SBtvjsGBsBFVPppQn2US8DLep94AzdvAegQIMyAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3D/kK5cQCLuGeO7hC945SONJQJPxE71P6AsK3LWgYTk=;
 b=StkOBco2JpN1RvR50gilkdXwwiN+jLyQJmCRLtTFka97Ir2ZuCxjg3i3MajBzRi5nELdwPo+itChvNvAccalH07LxJe05fX+KF5w16Kon30ITKjzE9CDF5kK3umP9Oc5I0KRQRnfNC9Emj5NFicFITIW8g8I+BiDl+hnOH6xLBM=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1465.namprd12.prod.outlook.com (2603:10b6:4:7::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.22; Thu, 30 Apr 2020 08:46:36 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 08:46:36 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v7 15/18] EFI: Introduce the new AMD Memory Encryption GUID.
Date:   Thu, 30 Apr 2020 08:46:26 +0000
Message-Id: <f9cb729a2df1ffc06eaf78e9015d23cc1682973b.1588234824.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588234824.git.ashish.kalra@amd.com>
References: <cover.1588234824.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN6PR16CA0065.namprd16.prod.outlook.com
 (2603:10b6:805:ca::42) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN6PR16CA0065.namprd16.prod.outlook.com (2603:10b6:805:ca::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 08:46:35 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b2aa1ecf-633c-4fab-6589-08d7ece2fdd0
X-MS-TrafficTypeDiagnostic: DM5PR12MB1465:|DM5PR12MB1465:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB14655095104B0F997D4D8D6A8EAA0@DM5PR12MB1465.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(366004)(376002)(136003)(346002)(7416002)(66946007)(26005)(36756003)(86362001)(66556008)(66476007)(5660300002)(478600001)(186003)(8936002)(2906002)(8676002)(16526019)(6916009)(7696005)(956004)(2616005)(52116002)(316002)(4326008)(6666004)(6486002)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0UQM1RbbLv3IQ+ShWeoVLWWvuw7E5OS1iF2Ic8EJe2f4G+Tf5g01nzsVgRRUy2TOLkQ2gvC4dLS5v3ePLIQkfmgiaL4dvPz1iFIoeVrMGTeAk3xvF9y8MzVc7vfaKv8b1VAYeOuSk7KJdgvWjcjcEUTUFzZB4nLFTxEaE/sq6hscDTVSmd1ykYx6rS26VChnWzjv5hjNJLwY8oXGnvo0odr0r5uC2iNxabXgbE0u4gwedvhZ+yxCg4O3t6U5niBX633U7AxODBYL6CFHHcybH/c1bd90Dt4RCweNabqo69/CSmjdA21r4TvdGJGvThe/6fSyamOBZSE1SspEm8bhb9q1zkvOdbeDORNxvtOurynFR2ytI5wDJvIR4VFvRe8Q0YPrB2JTr8WeithFt58Tjlekb95qC0wtHn28HFQ79mLaobmZ91OY9PDKylGvdiwtqE5yTDnIOqJQwkqPX4gFuEDCX2b6J8wKfzXgFKBAShP2irY3gRAn3xIpuTtXKU5X
X-MS-Exchange-AntiSpam-MessageData: yHJw1RXYMpTvqC1OtEaDSwbKxLp7RJLLN2CiMAmO7IA5mDOT6O94er7mFu/HPAm0FYsBiXBTSswPjfQYaNhdhAM/S+j/IazLUWfSYneMBW/cQzMgSE3gGyI9VN/YsIQROqE1kJzux/yDb79+pBl8PJ+RDqVB2ZXVMfl1jDceCbw+PJR0AS52PtNYBLYXnUSULqAAL4MstZtEIz5Xhl41BRmepYJBKySQGXs6mgLbB7FPIxtIreMRmwsKbooM9Fu84hILAo05Pznul2WlQbbxyvgoqmNcrDB9mC9PcSFJguWeTy1ixAsMVIXIZFnAx9qJTnP5jbv+5EfU1kwtqZl1K/l9Od1DLShTj0x0hyNZq6hjGDQe4xCC2v6b+9oxSHWJVQITsAI4WUfw60sukzxSiuKKqdZ00KhrXNvPx1i7JYcYi58bvPkf4EvJegcg7YeTWUrNlfXV6Rh2uUMLV+ThF+wqOWDMNRsKFrRWKCvxNaHEhKHmWf7Z8YCm9nxTpokNN8+5BNeSWLw6HHXcFY3QK+DF/jTs9h3wGZOVGMKta3UBnirVObCgUFgRiGSSSXAg4PurE75ZkB9k2KWnzYH0UJ8P8NIKEkgUry/JvqLpeJo52bF5Ar9hJI4HhmUc6Oy7gVD7M3/dJEz7Uu5YA3JA4gje2lQX4YXbY357OorWNGPtO/+/wEgwuZ+coMw9u+HVnRKe4fYbL1eaMsGRE9oAiIydGSlCWBEk9oqN6inUj1SsFmuALXrtiXLVemlHs3/zjROSmqjktffcJsTGIR62qWuiNMxPs5HeRAZbPz6FlJk=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2aa1ecf-633c-4fab-6589-08d7ece2fdd0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 08:46:36.3440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bjLlf8O41nco/qRdO7emg9xu5a7uxAvhf62FqktfiQlxYXWkExlV2KOTAsJL6F00fuQx8sjR44iuvxet5v1W6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1465
Sender: kvm-owner@vger.kernel.org
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
index 251f1f783cdf..2efb42ccf3a8 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -358,6 +358,7 @@ void efi_native_runtime_setup(void);
 
 /* OEM GUIDs */
 #define DELLEMC_EFI_RCI2_TABLE_GUID		EFI_GUID(0x2d9f28a2, 0xa886, 0x456a,  0x97, 0xa8, 0xf1, 0x1e, 0xf2, 0x4f, 0xf4, 0x55)
+#define MEM_ENCRYPT_GUID			EFI_GUID(0x0cf29b71, 0x9e51, 0x433a,  0xa3, 0xb7, 0x81, 0xf3, 0xab, 0x16, 0xb8, 0x75)
 
 typedef struct {
 	efi_guid_t guid;
-- 
2.17.1

