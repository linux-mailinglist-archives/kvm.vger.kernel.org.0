Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427AA43B7D8
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 19:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237711AbhJZRGT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 13:06:19 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:17062 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbhJZRGR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 13:06:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1635267833; x=1666803833;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=UtmGwNLtbSxGJVqCYKK7n4C8ex2dBx4gBgISwW9kXsc=;
  b=R5+TvOkmVQ1a+4mgB6YHy59NbFQdon8ZzKlSPoJRuOQnIzzFr7yIEuP+
   UhGDYOx7S+lsOyX4QTBnacLjekfY2PzrZ3HnamyPKm6ikRKOyoc7Alcyi
   ieXZBouFc+x8thvXMZ9bMrs/4erZGc44dBDKv92JX65f03OCfKsKWSLWE
   Nb/rUkYS+2PbFKgXsqP1zoapJVc1lTyjTpxKVKPWX+UPUUICos3gjBZ6F
   IBVpRSScACfFbJW9um2rwf5vsHcFrCF4p40IgSFbEFESrUo5la0nYWE67
   LQhXHmOILPZFbgMhUjFLmDC22w4hOamqev9YbZG89svP/rfDUbIE9TdIw
   w==;
X-IronPort-AV: E=Sophos;i="5.87,184,1631548800"; 
   d="scan'208";a="295633711"
Received: from mail-bn8nam12lp2175.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.175])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2021 01:03:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e3A7pO99nvGotL2h9oIkQuoOSq0mR6NmJGr0ThOygjKbYyA8q8algzkSKHG+phSa1GuKZIkZzm3LYR+AdV/VbS4LfmcWt4/rvt4Wf5nzHxYm9Lus5HWefwabNhw6oBscTXKII9LHEiE6ebvCw/xWm9C8t+KukuSkxIqiRfwvog0HfARS5EjUYUFWS9b/IcNGwxtCuFm6SKbI6wKYq8qJ+TsJrdyOceysvVPlTdy0TjhlUd9Fn1oAFdulZuZLO19ZQfOczXq2zeAzKqlZGV1jGu0JLrM5vi43Aj+uoVvuvybOj00NKC031JG6HkLxuVVWkm6ppA3EChjDcG9pJkxg5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gBbmF0LwI3fUPesiwtJ6p8oEXlLRgJuvrcp8qsnE36M=;
 b=NM51ckWX5NFCVObhjuneevIxGO4wxhY+N6rpLFaEyVGF+OUMoJ30pDuJ51fCUUzh03oDWa6VLzIdi4Ypdh6Xr7bfSyo0pdwBuxt3RgE5czMidqvQUJLZwTcEs7BqSkA6StAYJDmXYhoxzLDm3q4X+U6CLLumLRTHyfoItntCHvhnrgnZbKoKtZra4gpP1jS53PLZgk/tX10RyUcA6T87BU0VzdFqIBW6znkOG3xk5YNBvFQaB4yGwl7BS/wMdkqZbf3i2CRLLdIxgp7Iw74sfsOmDhEsbv7MrHeJ51vVhbhsTqxecRGDvQckNOTf5dthyyxMQ0vDZxjFXDteYf2FTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gBbmF0LwI3fUPesiwtJ6p8oEXlLRgJuvrcp8qsnE36M=;
 b=qY2wFPeuton7B6NaH64KwhH60WrAFMdJvRadFyYwA1iftODjekW9InsLszdIhZiGG6/nRkjMo4/v8x9/D7Mm63UBpEc7hFEJmTD+548c/XxqONmnBOpl5D2Oqfr2QYcvKY1FAPFF6R1KcusHk4YWdPWuUEd7V4XzCmat5vH28Uw=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB8314.namprd04.prod.outlook.com (2603:10b6:303:135::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Tue, 26 Oct
 2021 17:03:03 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97%8]) with mapi id 15.20.4649.014; Tue, 26 Oct 2021
 17:03:03 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH 1/3] RISC-V: Enable KVM in RV64 and RV32 defconfigs as a module
Date:   Tue, 26 Oct 2021 22:31:34 +0530
Message-Id: <20211026170136.2147619-2-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211026170136.2147619-1-anup.patel@wdc.com>
References: <20211026170136.2147619-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0018.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::28) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (122.162.126.221) by MA1PR0101CA0018.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:21::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Tue, 26 Oct 2021 17:02:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ab37cda-854a-45f5-c298-08d998a278f5
X-MS-TrafficTypeDiagnostic: CO6PR04MB8314:
X-Microsoft-Antispam-PRVS: <CO6PR04MB831468F8421AD36D20E57D0E8D849@CO6PR04MB8314.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JVmV8C5xxeLgJom24ov8rkHfBaR+MFJoxfV8vmxxje1jmeDGVIvy1t4YJfy3dLEaeuQFv0+UJk6J6/lgjI/XEsM0b0hBPhGGye4quVKa+1fAHPGjhUgGeHB+2OoWFsqhH3DKQg0YDBsru3YjUPuKDjFFdyAV3KlHAgnvylNRXlo9w9oEOCqpc52QxEU1s8mtd2+pKRtyKDIFDaJDuFmZMUDKZnxeFA3RlzKplTrCLi9ItXZ+m8DkrgiKhV+h3P65XnPaLNMaJtoVpl09Mgj8r8NHiV3cTbMPoLnRgP2EvoVm6+O8GjCqVXUIODQSIu71HzkpFPhabMCK0YJQhREuC6FH7swbnuLipyoUhklQn/plff1CGUrA8SVTJW9Nlahx/j312SnaBI70cUviF8edeTQGqOIct3jP6WrQEmPT3JBAitSJymd2pDU6HvKI+epWx6s7BdbeIc7UVx51THwG6d/Shl7r26WErlfDV/hRZc6mv+yxmv6cDCXeOusDIC5L/2djDqgds0nUa/F+5xc5RH+kY/e/7aDIa7nzaZQYEuA4+eP8BmAGkW77m704r1+HnnfZWTr3TchRsnzbKiBHLi7qqPfZY9c0Qv/8t8uX5aEfCj9OmED4M81JzQTuElyJFApmbd3eC43eHrIRcNcHSvW8RRyMdPrpVbfjlFBdP5+rbVeH2vUHcyr5aQECdtoxeQkiqg3emHyNAJHs3VJEcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(4326008)(5660300002)(26005)(44832011)(2906002)(956004)(52116002)(2616005)(8886007)(38350700002)(7696005)(55016002)(83380400001)(186003)(38100700002)(82960400001)(54906003)(110136005)(316002)(8676002)(8936002)(7416002)(36756003)(86362001)(66556008)(508600001)(66476007)(66946007)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HBsiprU+It+ZwPr6DiwOoyy4hJ0mTY0AC5maVHCvbkYtsBLHZoaw7ZGYn02C?=
 =?us-ascii?Q?FPdwBv4iEN4bma1MOKQg/Qe7xonA0GlmtbllmeeqXySr61LlbiTCJfpQ7Yii?=
 =?us-ascii?Q?T4guj2v5si24Tn5b2fcg0kPyoLFIZw+e0Oc6bJiKIWgRG2Lpju8P8qkzkGDX?=
 =?us-ascii?Q?KMyuhzPJbEvVj4uorV2whXakG3QTvNlqtqM1LuaR24DlPdJoIFE+Ok9wAS3C?=
 =?us-ascii?Q?qxpcSH2YAe3VENlNXXhUFSBk08ROAJAFfJbJpRvJo041cu4Urs9IVvmlqsIa?=
 =?us-ascii?Q?Rh2kMrudLixgwEVF9EGX91Ze97Krfx8j38KP3n0W0nKd76mZdR6A97xTRjev?=
 =?us-ascii?Q?hj6U2pejB1c8q+FTCwEci+Otp67m4qwZ2UIfnJrH+cR/XtKH6jcw72pb0e56?=
 =?us-ascii?Q?9vzem2Qtda4CenjIbhKnPMc/HMmWaJ9WEV+cfWmnDCHluECGq+IdLGy1hjJY?=
 =?us-ascii?Q?QhO9FAgmeHhiWEbTz1RBEIX+Bn1p3svfV9d2VnUfAYwBcJZvFyOhqI9ViKXp?=
 =?us-ascii?Q?jERKOpLEL01N333OHbSp1krqRoUH1epp5zIDAH2Ohq4gwDNYbyyhbKo4NRHE?=
 =?us-ascii?Q?sfd5fa9YqNFSi5LyKJWUCNSCwinLQyBOybt/HwH1mHZw1KNSOKD8NGJsJS2z?=
 =?us-ascii?Q?oVTQsBOR5SZs8Lsbb14fVbMNQr+wAnq4MRnTm8Dxcx7N3dcJdxvataccc5Qb?=
 =?us-ascii?Q?r55DdNWW/r/gLWyjpaAY3f9AMKAYviNhe8bpGY/m3gRjMW8gMKFAYfKx7y6Q?=
 =?us-ascii?Q?UphINUi8gSjEpoy8N6P4AfxebOJTzfOVml5dRVLeTCl7rGDsO2fIizWVRGIH?=
 =?us-ascii?Q?A1AkoVCMFgoLY2tE48mbWVWrHLuckYeIG710TEwgSN1w+Pcxg2IUvn8aC4UO?=
 =?us-ascii?Q?SrvG7RL87bpXUtqJEkSYxIEGrmICRpOxhJtNOhZhQydo8uoQB74gEkVcKkTQ?=
 =?us-ascii?Q?+CXSv6owmOIiztkRsGttqwkZYu2toX01LM+GjWSWIAkdMxH/ZU2/1E2acFZq?=
 =?us-ascii?Q?G3EPFQYkBSSRQRHZbtsKxNZGCssGPNQ56t2yaQGKKejYF9GFCtl+7Ha3gmYW?=
 =?us-ascii?Q?nYWdzHIopYrrekIjer7WJY0d59Z5xjU3ffCdPgOd3Blw+OOMGS8w+fqY/SiS?=
 =?us-ascii?Q?nlkM4JUC3QnSiQT3jvZiJAcxU0NPPSUqWjiXJegvKSIPx5SH7awd3nsNnDgG?=
 =?us-ascii?Q?/aqASdsLQEt9UE9pfpZtN//vZtZSpi5JaOutTZf6D3yYRm3KxC9sYHrcZAE8?=
 =?us-ascii?Q?5zjmdnHdToyIx2fXbvLrDGQzv2z0WsNOVHXISSamthgZ00B6D0QqjSGH96k7?=
 =?us-ascii?Q?fx/54K5xfyK8zsnkUKKaCQIQmFr+4WADF3KXua9FIqxu1BSNQLnmuc3ssQRn?=
 =?us-ascii?Q?K3j9578wW/2dAWN3xg43F1Y5qZJS7KiVm4IWTrSrYsHLd2q27KhjilirEzgm?=
 =?us-ascii?Q?8jR4aNi8w8l0VwPKk3FVpwKDlN4GB6LEN2Nky5LRDoVsu3mFABTGfBO/5hoX?=
 =?us-ascii?Q?CLMC25yRX2dx4FCoRcRagCGS3zv3o9WreFxOZPvLRqRjilm6TZmXlEx9Vj9J?=
 =?us-ascii?Q?c+avFCu1m3FSP1RXpRJkrKP2VMScO7mzQBBMNUztZ/SjcTAo6LtpwVa/cOf5?=
 =?us-ascii?Q?0Jv+9w7hNJ1rKImuBEzk6Fk=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ab37cda-854a-45f5-c298-08d998a278f5
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 17:03:03.5223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /CE9QL+NlWktjNIRfZDP3qU8UlDf/SOqdQe08QtUSnWpG7LJLKMeM2rh562Li0DveSSHil4n5oHt+L1Xbw4u0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8314
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's enable KVM RISC-V in RV64 and RV32 defconfigs as module
so that it always built along with the default kernel image.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arch/riscv/configs/defconfig      | 15 +++++++--------
 arch/riscv/configs/rv32_defconfig |  8 ++++----
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/riscv/configs/defconfig b/arch/riscv/configs/defconfig
index 4ebc80315f01..40506dfab5cf 100644
--- a/arch/riscv/configs/defconfig
+++ b/arch/riscv/configs/defconfig
@@ -2,6 +2,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_NO_HZ_IDLE=y
 CONFIG_HIGH_RES_TIMERS=y
+CONFIG_BPF_SYSCALL=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_CGROUPS=y
@@ -13,12 +14,14 @@ CONFIG_USER_NS=y
 CONFIG_CHECKPOINT_RESTORE=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
-CONFIG_BPF_SYSCALL=y
+# CONFIG_SYSFS_SYSCALL is not set
+CONFIG_SOC_MICROCHIP_POLARFIRE=y
 CONFIG_SOC_SIFIVE=y
 CONFIG_SOC_VIRT=y
-CONFIG_SOC_MICROCHIP_POLARFIRE=y
 CONFIG_SMP=y
 CONFIG_HOTPLUG_CPU=y
+CONFIG_VIRTUALIZATION=y
+CONFIG_KVM=m
 CONFIG_JUMP_LABEL=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
@@ -68,14 +71,12 @@ CONFIG_HW_RANDOM=y
 CONFIG_HW_RANDOM_VIRTIO=y
 CONFIG_SPI=y
 CONFIG_SPI_SIFIVE=y
+# CONFIG_PTP_1588_CLOCK is not set
 CONFIG_GPIOLIB=y
 CONFIG_GPIO_SIFIVE=y
-# CONFIG_PTP_1588_CLOCK is not set
-CONFIG_POWER_RESET=y
 CONFIG_DRM=y
 CONFIG_DRM_RADEON=y
 CONFIG_DRM_VIRTIO_GPU=y
-CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_USB=y
 CONFIG_USB_XHCI_HCD=y
 CONFIG_USB_XHCI_PLATFORM=y
@@ -85,10 +86,10 @@ CONFIG_USB_OHCI_HCD=y
 CONFIG_USB_OHCI_HCD_PLATFORM=y
 CONFIG_USB_STORAGE=y
 CONFIG_USB_UAS=y
+CONFIG_MMC=y
 CONFIG_MMC_SDHCI=y
 CONFIG_MMC_SDHCI_PLTFM=y
 CONFIG_MMC_SDHCI_CADENCE=y
-CONFIG_MMC=y
 CONFIG_MMC_SPI=y
 CONFIG_RTC_CLASS=y
 CONFIG_VIRTIO_PCI=y
@@ -139,5 +140,3 @@ CONFIG_RCU_EQS_DEBUG=y
 # CONFIG_FTRACE is not set
 # CONFIG_RUNTIME_TESTING_MENU is not set
 CONFIG_MEMTEST=y
-# CONFIG_SYSFS_SYSCALL is not set
-CONFIG_EFI=y
diff --git a/arch/riscv/configs/rv32_defconfig b/arch/riscv/configs/rv32_defconfig
index 434ef5b64599..44022e048efd 100644
--- a/arch/riscv/configs/rv32_defconfig
+++ b/arch/riscv/configs/rv32_defconfig
@@ -2,6 +2,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_NO_HZ_IDLE=y
 CONFIG_HIGH_RES_TIMERS=y
+CONFIG_BPF_SYSCALL=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_CGROUPS=y
@@ -13,12 +14,14 @@ CONFIG_USER_NS=y
 CONFIG_CHECKPOINT_RESTORE=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
-CONFIG_BPF_SYSCALL=y
+# CONFIG_SYSFS_SYSCALL is not set
 CONFIG_SOC_SIFIVE=y
 CONFIG_SOC_VIRT=y
 CONFIG_ARCH_RV32I=y
 CONFIG_SMP=y
 CONFIG_HOTPLUG_CPU=y
+CONFIG_VIRTUALIZATION=y
+CONFIG_KVM=m
 CONFIG_JUMP_LABEL=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
@@ -67,11 +70,9 @@ CONFIG_HW_RANDOM_VIRTIO=y
 CONFIG_SPI=y
 CONFIG_SPI_SIFIVE=y
 # CONFIG_PTP_1588_CLOCK is not set
-CONFIG_POWER_RESET=y
 CONFIG_DRM=y
 CONFIG_DRM_RADEON=y
 CONFIG_DRM_VIRTIO_GPU=y
-CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_USB=y
 CONFIG_USB_XHCI_HCD=y
 CONFIG_USB_XHCI_PLATFORM=y
@@ -130,4 +131,3 @@ CONFIG_RCU_EQS_DEBUG=y
 # CONFIG_FTRACE is not set
 # CONFIG_RUNTIME_TESTING_MENU is not set
 CONFIG_MEMTEST=y
-# CONFIG_SYSFS_SYSCALL is not set
-- 
2.25.1

