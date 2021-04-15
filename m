Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF78360FA2
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 17:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234018AbhDOP7l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 11:59:41 -0400
Received: from mail-bn7nam10on2085.outbound.protection.outlook.com ([40.107.92.85]:8161
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232769AbhDOP7l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 11:59:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lSMhqhb+nw2tk7EyAm68yFMOgxq3WvwKvd9QKoFQyv6AsK6QOk9YT5+K6h9ZD0GAbXjg5vbR4yu3xUMOoTVClr9Snx8MH1Phk240YcgXamnjG9jiCW1LieZ5v0D1/+lkTgWtuEaLQKzMmMZ67P88dCE/lggrrIuqw937ng57XtE9H3iNlynXF6CNlZbTKx46NlSbQ6vmmXrHX7QroQQ62Rvly5kok+BFXzRLUExrRA5Ij7FWzjFdYKY54tGEiZqDzhWyngFJ+6C3CNME5kZ3oxREXY3+ic4QhU13ek3H9+jNvywQyXk8CLV2oh2G0EGlAS66xobLeL6I2YZfYv+MvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fzHgR4/srdRrnpCFf//he/wMHnI5/X07xubuaqy1vPo=;
 b=NfgLHJ2T6MuMbSe23bwfXaZ/LdwuaC8RuUxzq6IkpQcZ7XjfEGct3C8VsTS0hqD6rEr1GUbQRP1KgM6NAZc89ERh1d+GBmynwK+qXvIbVdEXT6w/JDyE8/H2QiF84wsMJDAFGiksnHg79xSYE3WAtLOt/+xG4VpgsDB2ia/5n+1+YDZe4sGpXTkUIP2ZJ39vmw5t6N7aoH4wEzMsh9snxMHkGFmTbMsjErw9QT3jxl/INw8pXZLa+zAE+Voj8ebc6+jJrHNTaPVmjFQSi0KFKu1k8GX7YJsg9R3WJVrvSr/idHUU4TI8u7AXrST4rlixHhxQUNdJ2BdRWH/EbGBXHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fzHgR4/srdRrnpCFf//he/wMHnI5/X07xubuaqy1vPo=;
 b=C27UeugGWc8rOIbZnDg0GHGNf+Z83G0Lg892ZKRNHEtK1F7QYzaY34r3jPhPXwVB0vgKi9Zda2uvjuyrkcGw263QOR/SOKvbeaXfSr4bMVZO6776cTV3Wz+xzb5lQmkIHLELn5hucQC15sSxwVFnfUocLuBXd91wZfBQryNn984=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2719.namprd12.prod.outlook.com (2603:10b6:805:6c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Thu, 15 Apr
 2021 15:59:15 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4042.018; Thu, 15 Apr 2021
 15:59:15 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v13 11/12] EFI: Introduce the new AMD Memory Encryption GUID.
Date:   Thu, 15 Apr 2021 15:58:42 +0000
Message-Id: <ae8924d0dcac0b397295f53f7bd3ff06f6a9ff12.1618498113.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1618498113.git.ashish.kalra@amd.com>
References: <cover.1618498113.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0148.namprd11.prod.outlook.com
 (2603:10b6:806:131::33) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA0PR11CA0148.namprd11.prod.outlook.com (2603:10b6:806:131::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.17 via Frontend Transport; Thu, 15 Apr 2021 15:59:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f50d6138-f304-4e83-f381-08d900276b29
X-MS-TrafficTypeDiagnostic: SN6PR12MB2719:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB271955C3DE6D1B130492A83B8E4D9@SN6PR12MB2719.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kHkVVc+1LjHrlX9jRhSixpjha9JCtOPV+RpylX5ZduaLLKwpZ69veDWGNReaXXqBx5X+ZM1OoxiQOhpBRKujjMMtvHVkRlhfULIRkvlRhQ6g2DncB2tsLOQ9v/2SZZmfmSv0raMeCtAt/wPDRdWNLhvg4n4KHBWsQMMDoXpFkEL4Gyp72XlzadrgQS0mRI87V4Ln5XY85SibOse/sjx+4ET6nbBy7S8x8EzkW7PxRC7B1Evp4qW/9wsnAGnav8ffm7UB1Arc/3eOH+JIaE4YQ76h5hhr81Tic1QSsXxMlecTwoABez193uAhjCTaZR5k/iy62f+ejc2znQrXiV0xi/oc0uFacC8Uo8U4s6wG+Pef4y6713KgM9anHbfxlAdG/GbekEu5snprFQzKjZd8mscJPpcYwC8byhkHzfS6vTSpZ4u6U4xSdG8aFd5i8RZamkvnPpyqYZ5E5v9mXxXsYNBIKsO6zM+t2qJ/hUf48/ByiA9Zr1H4hun9OTFbk0uZlvoA/vIlAdmpPb8dsVUYk66LZ1bUMXRWSoxpYHP7yvB6PTLGz7TWPAqLSJvCcF6voBEmaxy0r3ryWNtpPLcaBv+/V0GwKSK0uS3TNWQnyP/DWclkIZWE6oL1p1nLMhU8lFLDJRUmcWrEOzxNGbiw2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(346002)(136003)(39860400002)(2616005)(6486002)(956004)(6916009)(16526019)(66476007)(66556008)(8676002)(2906002)(66946007)(83380400001)(478600001)(6666004)(316002)(36756003)(8936002)(5660300002)(52116002)(7416002)(86362001)(26005)(38350700002)(38100700002)(7696005)(4326008)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?OQPJgTgpGqwJpB8vUzAn9G6UMz0CT7iiPzsQhUfumu1r8oXmidxLmHTnLLis?=
 =?us-ascii?Q?qRM4uU2STbr/vR806Mepin+raJqhD+KYGMKWlI3tv6zYBkOBf00PWsl4T1Wr?=
 =?us-ascii?Q?WBmO3+fMM1hFk1Ammm+w6FJLrW+VtLCwgzym0r0yPg/IaAJ5ghEiCMmpVFrS?=
 =?us-ascii?Q?fi0Ce9uLs1nCPhRkH8qgYu6MTaKR13R81PnKkzx/ma4zgHM840dWFcZhBKOs?=
 =?us-ascii?Q?cOS9sMxHxID86mT16pBkEUXqlqqOT+M2YVZKM8SwYidpGPPuY85CtPyliMGD?=
 =?us-ascii?Q?Q/q9dx3VsLgyl1ax8T1ptD/j+wYvSKVNQ3v3sfUtkbi/2X9dnESIHCetqSfL?=
 =?us-ascii?Q?XtqjWSVMhqktHZp06KC8aXn5aqWkQjhX+frJA8fUOI/8zEVPRhYEKOF5lEWf?=
 =?us-ascii?Q?VKOi/PiJKdI8vIW6XGAvZHhwW5E4ElLkuj1NQ45RMfFx/Yv5vpXPj2f+/y6o?=
 =?us-ascii?Q?6eVfVFD1i1v+Yw4d1hfPXhvy1Xk8VvaqAh8Z8s478HmcbCi0475DAU1eyLxo?=
 =?us-ascii?Q?uwfg39SifTX7Bp32VhTbK+GnxCcmnPkldWFLQFOBz8WFmZiqRAn2dGPjEq4C?=
 =?us-ascii?Q?+YDNME23rOeq/T8ahbOT9sqs573eL8yjhGbM7Z9qwJYdoiLBJdq5CCKPI6v9?=
 =?us-ascii?Q?e7YuxVGy5qqRSbXPyGMZ3LbOHBIcMQR1trMeistHBTRI+XRtd33t5ML3Pm1B?=
 =?us-ascii?Q?180V1hJgzw/oWyF484bzs+BMLyDZBpCukkKIqvIEkDOMKc6/xKhF7Xfxl7CK?=
 =?us-ascii?Q?94oFtQEH4fxa8hwYtQzEcV3RxEId5Khzy9Ch199zy2RXP+tw1nbBTlBcvouW?=
 =?us-ascii?Q?bmQjYjR2cwtE3zLFsjy4Y3B48nE9gh31jolw+L+4tz4PEDpAQWIaPDrGL6aP?=
 =?us-ascii?Q?NQFovO+gD0lbDn2yYUUdYqefVQlJ/8EL1JD+TFlnCITHXrXSCcT752I6Soah?=
 =?us-ascii?Q?vXrqmflWacj/+kgODAVRl/wS/2TXYSKA49sJMm+WugoxBBRV+GbnUQhlO+a4?=
 =?us-ascii?Q?b8YuERzApuhGkO0pvpkfcHz/DF/ebcOjCUhjBkb1V6t21+2gLe0TmDsKX7xD?=
 =?us-ascii?Q?A5rqPsZjRhkeNCJ9shTCUCGKQDV7sQeherAu95hcZsYpi12pgYdhyF2zo9YT?=
 =?us-ascii?Q?Xg+9WdDX69GGibdfcXgf8PHMrlxxme7cB5un93/LJ5hjn6ZIzLmYvfkrwL4D?=
 =?us-ascii?Q?tApXJOyShMsNwtwOGzyz5PsGTX1dn03zGdTdHIqVhCK4Suv2O3WJ9TzZa2ID?=
 =?us-ascii?Q?OfwjWwCJqP2tnb7pRpsKR8qJgvLRGNeY4SaP5hqGoLPjUuc677EgRls7EV/r?=
 =?us-ascii?Q?P3wC1bMEumNYiFE/sWd1V5f6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f50d6138-f304-4e83-f381-08d900276b29
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 15:59:15.2581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AoSVWllmSoP5kMHmrnw8Lv/sTbH85KOoPc1wNzhcyDOhtslr+H3n1oUJ3FN5qkASrFZ0y2W56GcfnAWvsFPrHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2719
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
Reviewed-by: Steve Rutherford <srutherford@google.com>
---
 include/linux/efi.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 6b5d36babfcc..6f364ace82cb 100644
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

