Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425DB4542E3
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 09:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234562AbhKQIua (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 03:50:30 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:55575 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233830AbhKQIu3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 03:50:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637138850; x=1668674850;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=aZh9fFsa2mfcH22mbWSuLyxyWpXwpU8CmFDH04oJKpg=;
  b=V8ki118rpdLbOUvN0OoJxJ1J7ya+X/qlEm3m+AYIOdGlo91pYnivdaLM
   7e1+xeBBqKqtHhxmmhChH+G1Y7zKP7ArXtPnQ9vNK0IRRraUGGRZkVCAQ
   5QKlyydSxCrXqy/k3h2LeJMetHF5ml5HpBXAxsEDb8oIs7qbLNsJ1YwXk
   8Vz/Fw9GdujzMKQdHqMu0QG4wGWDcQVHLcdAw7losX/WzeflFJx9KoGtd
   JDX26KI89b8g9KjjEiKFyB02t08naku1Oz7omIDzPShYxFEbQaXNutveU
   6O8rhScBBx6AzerIYRvAwwvXTpM3HWFwo4c7SyiAiHpKCAcCnnlQiF5/3
   g==;
X-IronPort-AV: E=Sophos;i="5.87,241,1631548800"; 
   d="scan'208";a="185829410"
Received: from mail-dm6nam12lp2173.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.173])
  by ob1.hgst.iphmx.com with ESMTP; 17 Nov 2021 16:47:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PMjQ0ase5Jgb1pnAydeQJKQUAepLqcZolkUGh44qy/u4ZVK8xdonvScZgwiImNPyKlORFDNcwm1wisjzlp5an3c62/KGD3d+EpxAe/UfLNWG5KLclDGEZ5tiG1ziW2GeXzQodtopuDvKQgVlBE1e0YrDo0EC3wxVzCCT6o6K9wtg7SzvR4V6/BnSSKdmy+6+Kdc57BTYKQ5n6LKpdxr3aeOWcwZRYImswB+wnkbrAptONv14xOWTb65b4WxrDFYCcLWsZz0I8/u9/1/1thJuoUA5zQOF2dPIiFkXNf5XNCyYYjTJ+uNEM/T0Gatf8Sx8UK0st7JFw9hY2rGqDUCNxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IBnc32dtzYj7KqKTtv2MuHKCw85e21JaDE8+y5qmHaA=;
 b=KpHFVKM9anmJXd2To85NW+pWl2kgiN37GFY/qVWj1RSaqkerCGm5sL2NlNqTSUO4vAkMikU2zun2h0ByPWx1eASFqTu5DUekBHegkybVQ+Uj9X08y8Oh1KYYPITNgdlARcbp3Rx4BwhP65CGSjcuPxq6gnVLMHNyuWTVsZdIQV5AP2zLJorEajJn2Qn+2CCLkpo1u7EVbE4tEbOwKZ+ahEfoc/nnH8kG7nM/ZvbY4j8DvMmtweNMd5ZE8YdhArb0PB4+hw6ZiAYVxNlROHIgm/R+SYTw98luzp3pfS60lhr+6GLFz4gnsZZoJ7mLc1c4GqpjKwsz9nkEHDFYv5CGaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IBnc32dtzYj7KqKTtv2MuHKCw85e21JaDE8+y5qmHaA=;
 b=aHCaely7Cl+LMiigh5IHvnLo/rv1pyqEg5+GuBCjRK9wdwFbty8rdLfbUw1CAmTU3IiAtSpxZtIMkQ9wyVY9+MKx75Nz3RkmXsDvWbIL3ZUN/cYeNlZmB4wufNkZbXUiqrj3mtFtVzyDqiWmGAeM+qhcljH85UYgLlfC8Ep46F0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7875.namprd04.prod.outlook.com (2603:10b6:303:13c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Wed, 17 Nov
 2021 08:47:29 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97%8]) with mapi id 15.20.4713.019; Wed, 17 Nov 2021
 08:47:28 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v2] RISC-V: Enable KVM in RV64 and RV32 defconfigs as a module
Date:   Wed, 17 Nov 2021 14:17:05 +0530
Message-Id: <20211117084705.687762-1-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0150.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::20) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (122.179.27.5) by MA1PR01CA0150.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Wed, 17 Nov 2021 08:47:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ff535cc-91a2-410a-b5eb-08d9a9a6e2ab
X-MS-TrafficTypeDiagnostic: CO6PR04MB7875:
X-Microsoft-Antispam-PRVS: <CO6PR04MB78750744E48B7C56B20EF4E28D9A9@CO6PR04MB7875.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yEP/NKUbdkLz0qGJgimaPOYSJr4x1Bqp+1s5AXDnvVQqZ3XL2KIf1osSUg3yih5g410/PkaZ7pgds9xi6JQ9x990uylvAUWwM9jAP0cSiZMN2AJPZ8P/rgsWRkk5J2uULL4BGi6L4WHd5fHTLaCp6sbnAJ9innhhpVpuCpPcvUQJ7TT4xHZ+AbQDeGCqQrz8KDcz6ssda5W0pcdO/RYhWtX5BZ9Stk4Nw7Ef+fK78+cosXcZQsqCaKa1g+UfCja0EzOopGLVfQ0BNooIJcRkgH/p+llblNTuwWN/RFDDTH/4IaOehsWODTBjBWH72xbsUulPGo48pxXrecLtX/tRcGKsBle6HYoR4Y+Qiow1QWYfqeYVKnllzuDc1Mv+9THOk3xaEYGFVnxYLpMNnZjrqkhv20ZEgghXcSqodW6aThFHnG2A8DBlAe4zjnRCHW8CwASxJKa/EKfas4+Efe/0bmoHdazaKqPwhRugM6AgAn9wgN4HmCS4pfJti0jh43f05gKeLW9D4Cf9uAv76mkP32I71Qb25SlH6ojmroMTrhEm6YGHlUGto/MVAfskrJU2eF7z0NRpxdSaN9oHf1ua6Hvd0TYKhVYDtjEN/EIlPtPj0tgiZGeAcz3eaK978Rey3YVNqxsE0M3OTsFNStC8uxDcVJ7aZkD1Ng0LkoccYuCyw7e4z09l6nalB98+a8B02LG65eYooNmo3qHq3+8mhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(7416002)(66476007)(86362001)(6666004)(2906002)(8886007)(36756003)(26005)(4326008)(66946007)(1076003)(82960400001)(110136005)(55016002)(54906003)(508600001)(52116002)(8936002)(316002)(38350700002)(7696005)(44832011)(186003)(5660300002)(2616005)(956004)(8676002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/t2Eze3e5LdRa0Ae7B2X/IREVb2oN7ZF3FyWtmfKasM2qW48hD57YyKJXglk?=
 =?us-ascii?Q?EQKlNy2WoXGDY7JmHNP1hG5BsOO6KsNtXUVM2md6lnn6WIlSqgZmjXnbtEzY?=
 =?us-ascii?Q?sIxvoAhfhWFnFj9GHJf1GmBkcmBQmZXESoZO4cY/tKDSTIdnXVmxX74ybb4+?=
 =?us-ascii?Q?I9U8DLEthFKdCBJbTVZu0nI7/gPMwPe1aqzErq3/6EnZK8V2EKfb8wRvQFJf?=
 =?us-ascii?Q?eNxwDkhjIucAlQaO3K6nqc5QJfgD0jf+uOYdhXaZPuyZKQo7RrzFBzT8JcY0?=
 =?us-ascii?Q?59TRjrIbkmZR74BnCImUgAHDiOCLyljoacZluZPCTE+4hm8j2FhOewR6Trzt?=
 =?us-ascii?Q?5uspIXXigYTOKVL+FQoYqvFeBpC+cP90DLS+YdKWGKgPBvTQL/HPv3LJURiZ?=
 =?us-ascii?Q?Y8E3P1b1i/GH0NEbl6RU2Bo+vKTVjHtNnWtPN33S8vRZ0CoeKVNE9HvOEYr+?=
 =?us-ascii?Q?2OJudin9hvS+i58z+jm9z2A1E1SBnb1JdPU3rKX2tj/E+TB7lqXKtSNDsdtd?=
 =?us-ascii?Q?mrmeySf4yVFTsK5kPWs5BJCy0YaupUbD5hNAURlEiAxs+hn2BhEq1vlwEMA0?=
 =?us-ascii?Q?DsYIikckIHg0OFOw21tQpitWuiVrqI0n/4/HIHuI21RI51z940AiexVl5NvI?=
 =?us-ascii?Q?HxNG/nrNSduFvMSVE/1Wgdy8NVZee+Va8pyBUUiX48QYTlsTwQgc3XLCF2e0?=
 =?us-ascii?Q?svNmcz0MkuQYcyF2prII4VMGH1LhOMjwKymbOg8kcrfvTFsE6TkXhrzZAmpw?=
 =?us-ascii?Q?kHvxQz0IgOiUKtjhkl5TpvktE3/HJWu6VslFajaxtf6QGyf0yM7myXxWcFxd?=
 =?us-ascii?Q?0nDkSzG5RVrPYp3nulM5+keIbGPLEoB9bt40jjVV1F1a6xSQHsIOTkyF+yxU?=
 =?us-ascii?Q?iEgwWEOGROa4Dnh/cMQmAWcri+XXFVCCt8jZ1zU6q9OAYeSadg3KCntgDrA8?=
 =?us-ascii?Q?MCu9bTLl1wJCJlxxkKGEWeXkxkc0RtSJ2Hp+J7vxtWCQXXaxThGl4d1ZKRjA?=
 =?us-ascii?Q?Tu9OUnSKv6N71dk7T2n7lrJa6gN0lzzAcwhvaEA2cR7BjDWp2V1A6EUNaC0a?=
 =?us-ascii?Q?qADMhjS8O4d3LdQ0TAI6t6PQ7it7PPu1ztfaog89WHOUtUaE2uQUR6B35lXh?=
 =?us-ascii?Q?ONoVJwIowUub5I+vFhddInW1J4k0LEf4barHXFoX/lOwlIYTivCYkFyAwVCK?=
 =?us-ascii?Q?0DSyFKpH+0+uoZMMkWGbK2A9TrLKVQ1eWb+0H2gZhW7U0+yV8n9Fk6KVYoin?=
 =?us-ascii?Q?pADECBziQtBwRZSkkRlEcDqqafdH7HOA8XbP1Mws1pY7IXpxC1SWZ87BZZ6Q?=
 =?us-ascii?Q?Xg2fl+np0YaMA+WDc/tZyKiGLB0r1Efj3SNRs4ffve+YTjc2CG4bjZ/xlehk?=
 =?us-ascii?Q?XMCNfgpkKAW0/ephm62jHq5hIM007fyY0sqO3m6Qe0esY2S8r9Nm2otAFw+H?=
 =?us-ascii?Q?1vXw2UawlOsFlAP2JCNJXXdcgZQwOcNzh3Xsl0KjVCxuSe+SZyIOa3fcFm3n?=
 =?us-ascii?Q?0o5vn6wemvwHWsZ/fMHrIaf5UvEnTDDAGQqXtv4pvOfdFDkGvhseyVY7CU5x?=
 =?us-ascii?Q?46BL8IaVWM9IwE6YpCfuIJ7leg60O+yVolxkulnUJHPxwj3tH+uKfhNXEqdR?=
 =?us-ascii?Q?FXvkeH3WSJV1L2cKN2z3Qj0=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ff535cc-91a2-410a-b5eb-08d9a9a6e2ab
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 08:47:28.8318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4fHyOWLt1W4PAfC6zkEdzCislSEBwS7BCosV+Jh4wQRVgDwerUNTV0/wT9jpIN9UI3MBtVykwOHJNnwplb1v/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7875
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's enable KVM RISC-V in RV64 and RV32 defconfigs as module
so that it always built along with the default kernel image.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
Changes since v1:
 - Rebased on Linux-5.16-rc1
 - Removed unwanted stuff from defconfig PATCH1
 - Dropped PATCH2 and PATCH3 since these are already merged via KVM tree
---
 arch/riscv/configs/defconfig      | 2 ++
 arch/riscv/configs/rv32_defconfig | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/riscv/configs/defconfig b/arch/riscv/configs/defconfig
index c252fd5706d2..ef473e2f503b 100644
--- a/arch/riscv/configs/defconfig
+++ b/arch/riscv/configs/defconfig
@@ -19,6 +19,8 @@ CONFIG_SOC_VIRT=y
 CONFIG_SOC_MICROCHIP_POLARFIRE=y
 CONFIG_SMP=y
 CONFIG_HOTPLUG_CPU=y
+CONFIG_VIRTUALIZATION=y
+CONFIG_KVM=m
 CONFIG_JUMP_LABEL=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/riscv/configs/rv32_defconfig b/arch/riscv/configs/rv32_defconfig
index 434ef5b64599..6e9f12ff968a 100644
--- a/arch/riscv/configs/rv32_defconfig
+++ b/arch/riscv/configs/rv32_defconfig
@@ -19,6 +19,8 @@ CONFIG_SOC_VIRT=y
 CONFIG_ARCH_RV32I=y
 CONFIG_SMP=y
 CONFIG_HOTPLUG_CPU=y
+CONFIG_VIRTUALIZATION=y
+CONFIG_KVM=m
 CONFIG_JUMP_LABEL=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
-- 
2.25.1

