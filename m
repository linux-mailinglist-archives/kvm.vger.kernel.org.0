Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9B3B43B7D6
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 19:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237696AbhJZRGR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 13:06:17 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:17062 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237672AbhJZRGQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 13:06:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1635267832; x=1666803832;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=9ucWaaESS2CsdgeNVZ34STd8kfV1gwN6Hz4NHkKn+zo=;
  b=EKGlYJE3gvKQ15KURULNrxeo4Z4v/4NxqC1PBFiIEAzGRLthkNJeXLAv
   lyNJ0VnqQJyBk8kbkCydx3DKfwSROZctg9DW0pQOHzbfKmvJ1sxCrU9TH
   B4JK+GNmNS9Et9NXXaUyLJGqm0zu9CCsJi4jn77SgoUNSTW66ZHArkQ8z
   7kY/QoBwFQ9Y8C8l0YsfselENQ+883W6bdgj7TLUM0u61Fgd8tss15PeC
   JlPiKXK1g/iHhUf+Vqh6ZKEp3JbvAh9aE3R+UvdjnMLgp1AvdsJWppat5
   pzcR2rPr736ru6v1uexUfodvu1QxSk2s9ENCVzfRvcW0234ru1QXQmPm3
   g==;
X-IronPort-AV: E=Sophos;i="5.87,184,1631548800"; 
   d="scan'208";a="295633709"
Received: from mail-bn8nam12lp2175.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.175])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2021 01:03:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=agEbAJVtlsYKiJ/+0Xj8DEwDbUttgrm+iWIiiGY4zdkzH8cFQOKW/GsudR5QYpUhenIF8ipvBo/Qai4+aNFqL6f9aNbHVI8aFLOAKceEG7tEsVRKGLAlhp5AUKGx9z1PYGAWfZ2qk+NH2UqypYj3wFztqwVD2gCiPlX71CEykb2RPj1l+IOaFVKQX9wOHxb+btdnZSO6XCUZ5Qf/TK8zDhefM3i2uQ96NmAZ3vg2upAvCzh4jc5Wv0+KPgbZO7dOmQy2VJlWhE73KuLZHYsMi4+xsprYIR+PdD0KMUJ1LYkCPvklLvUHh5PPNv4XROqCgz7IDUtJZVD6eFUYHPyKRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MQfcLXej1QKeheX2IshEZ0/P5+ML7Vd669XAu9BsiuY=;
 b=Buaa7EUaD4KXgzpP0W8FaUJFinEbbS5BXj8iqP+o1qnktLay9XvDpNzjKENHP8xSe75JXNAFumFzc81TYgS1tpS/0WnhbNeWtXz/utfdGJGu3LfqoC4bshUr9luWd4C1/Kkzlosm3SH56Jl3KH0bo2C+h0nlxUGtp2KaKSZ7gp3Ks+hDotG/RkMlf1c1SMY5nFUc7vOpzx4VGI0gIFs5+a7AQN+b7R80l0peL7eC3xNopQWMJ8oDPWtYZGwSoJb+7+bFtvYoDacvCl0YJOhaKISgYZ1vWojKtDNeGLWld3CLtqWvCVCBba7b1d5IdFcg06SH8mMnJ+kthluurZWZFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MQfcLXej1QKeheX2IshEZ0/P5+ML7Vd669XAu9BsiuY=;
 b=XAECyDUDAXi36O0w3Y2tgde9ru2GWXk6ofJXuRKIsJnmjKBkCQQ8fhJeyU+xQ8oNBRDMPrYACHe97IZa1kiN8zDNJt/5+luWgw9YAv5GyC/1/ONTbK5AjHvta6AHrc2GRk6P4x6jh69yfnvLs4naoANiULkAnPMzhwzSfDs63Xw=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB8314.namprd04.prod.outlook.com (2603:10b6:303:135::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Tue, 26 Oct
 2021 17:02:59 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97%8]) with mapi id 15.20.4649.014; Tue, 26 Oct 2021
 17:02:59 +0000
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
Subject: [PATCH 0/3] RISC-V: KVM: Few assorted changes
Date:   Tue, 26 Oct 2021 22:31:33 +0530
Message-Id: <20211026170136.2147619-1-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0018.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::28) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (122.162.126.221) by MA1PR0101CA0018.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:21::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Tue, 26 Oct 2021 17:02:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a0c20d0-1f3a-4d02-f976-08d998a27685
X-MS-TrafficTypeDiagnostic: CO6PR04MB8314:
X-Microsoft-Antispam-PRVS: <CO6PR04MB8314EFFC2F3AB5019E5DB4C18D849@CO6PR04MB8314.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 06dOmV1e0EdELHTyRzijvsWYwMkLVTFbIFei1u3Z4Kso9VwfE/m4Hwe1KfOLMU+olJ1qTt73FEi9R4dagr8ZHlVX3I33PX+2inzISsdvXb2MIuEEjMABaZkS6Cp/XKPXIDI4iVo/Xb1vG2adcjR0XoVeGnle7cO0wvLFWD6gY1cj9kJ+F4xwPQdMq84FeOv0XrKnB9mx/gFaSaWIja7APB70gpcVAUbo+k5PdksZf5mkwFT6Zmry4U6uyR2mC1q6Oo73kgzEPPjYmN8a/0O/wqPzPQiXpR2ckzcWts4W2FDmFegAb4BOfh5dcCWFs5s1gBXklcoUT+XmUQFjAVAlxG/xhYSMCI5kqW+8VC1fgSwU/ZqBa8T9Zcf6sR7cTSG70EE0iIPQGwlnsfmkB589iyinJCiTvWfKdkuxYACR56Hf+u2GLCV4w8nkwMdi1C9Q984z2NyM8DnY3xs1mCRrqbzvA9At3E0zlRtxk4Xj8uA/ZusUhYc+MyxV65P2kU3FuKtrBKmYrxOCpIymkypnLCCjswl7vPYRgPcS1gP9nVXLLS5PilhuqdX08c55cAGgrxyboC9jKgCH2fUFtYAmx3iO7LwPaIKyUbu5ZTJdLIX780K/jc0IDUmOx5Id1/7xAVNFSi730BsVSMICl0wVM+vJS0r/owvWNLs+zVt1JuhaA6uxb8EGlmG6s/64Dvyx6sPwnDmNvLcsLSJ2tPjuZ3VB0gU0QotJmliFH/nSz+GjOxzPvVtdDIf3fSAj2QSUIGiem4kiUP1deU6zIVsM5jPNf+Xethyx3FKY5nvJRk8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(4326008)(5660300002)(26005)(44832011)(2906002)(956004)(966005)(52116002)(2616005)(8886007)(38350700002)(7696005)(55016002)(83380400001)(186003)(4744005)(38100700002)(82960400001)(54906003)(110136005)(316002)(8676002)(8936002)(7416002)(36756003)(86362001)(66556008)(508600001)(66476007)(66946007)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bQAtJvZuuYecxMLr1DELn7bK6x1I2myf5O419kFv0xfib7BzlRzSl5CqcEDN?=
 =?us-ascii?Q?z44JvNNu/LQOztJIKTAh3wQW2mImDr39E2LhV925FirxoJ1/HM8kR74pX2y/?=
 =?us-ascii?Q?oIAce5us0s6Zbvrt5DBnxwU5ETDuSxNWKmJURWm0FcU8G/3N/9Ji0NAS82oU?=
 =?us-ascii?Q?i5RhXcoaCX6yi783CvkBXKu/4r4uXoytkPgx0WzUUktlusQ9VxcxYPUo3R0A?=
 =?us-ascii?Q?Zr1qp8W8yj/cGjP04h0lhWFXAErI+JMrircFamz07yQuK/wv6+znQ7QYhjLf?=
 =?us-ascii?Q?u+ZKM3ru1ugOHyXyYK/AyayoFmyGa0neEAc6Xf8zdYFpbPgYSM/p9l6aIs5A?=
 =?us-ascii?Q?j5F5CZ3NPQjlwZ548XnHG0HB7r2SCM4YHb8iuyWbvs8uUGVEPmWYzPV7AIYO?=
 =?us-ascii?Q?WuQcQFwcHOJSI10qjRLf3JgTFaH8cvVyfc2VWXLkYBlUikRGzPO1pEln+Ezu?=
 =?us-ascii?Q?1rrzaLUy54ES8biQexbOpHOwXSY+dtViymNG5FE7UmbLi4BHGQkth1w4fQsD?=
 =?us-ascii?Q?aNV1r97AAchiuiSOmQnKWbQWJ6DeaL97nRa7xXrT+h8tkwsIDzDxCHbKbIWJ?=
 =?us-ascii?Q?u54tqfqJwFphytiVrRRzQgBcfflLDrQ8XfZ04+ORHpUD5jrfMSUdu3/7reKi?=
 =?us-ascii?Q?KGc5ceG6bntMRZ+7+ihgbsos6oVYXPYOTJxsjyBMS+a9ANo4jdHCnlwZIoBX?=
 =?us-ascii?Q?hplFRudTWyPM9VriSIpvjoSAOZc7RzSwlPtixrqRkWJjkZLTN4lR9z37/1H3?=
 =?us-ascii?Q?uTqunHRDSLMOPbaDiNwM7UCOkxqr303dxVH2oLyxIVzGy65vLxBR6Fiw6XYm?=
 =?us-ascii?Q?0hN9r3tTcQXdg+Q9H7KQejJF/dl/raeUibI2Mglk7rgvcsLEj2mwE27BSO5T?=
 =?us-ascii?Q?ThJ+7ZhQJUKyAULZgH9dqPyP0b7FV/riZ3iGh6i898hIG9oW3ZuluOzaOP4E?=
 =?us-ascii?Q?KkqD93C96zBi/cT5qQzrRIeOprTX7yHPL+KLrKqkSyl8ei271W1qLWIlPOMn?=
 =?us-ascii?Q?tTCm7WQuZ+dkMFkf38pELpb3LD3R6rk1vCng9ag+3vPnET+rfbVMErU+TvaJ?=
 =?us-ascii?Q?WDKgV4ucYZjBZ3ZsOhXuvGDAW2zHjknF9yn21I2KHgRALLkehWvJqaJvVRIr?=
 =?us-ascii?Q?Tb/n8JEfi9TY8Z2KCOTm04BcUbX2EY1o8bfIj/deePUv3yULYIyklrxv6SA4?=
 =?us-ascii?Q?ToLmnYlh5gvpXbL0Bs1SpxqhaR4+6O8qcUSXSkZXmqyVgMCjT6OwCqddPnma?=
 =?us-ascii?Q?2YT3W3xQfm92/Buct1gRjRiDrHuO11VeJSdZJtLO0jSb6pYVBLA3Tl4eThce?=
 =?us-ascii?Q?WJitkkk5MgV9KhFG8cqDYp20EFl+CtNoz2+K7awk+JJ9EbVKY7GjAOQNWMmU?=
 =?us-ascii?Q?5k/HO46eMebCVl+o/7EZXFkXtlkZ+HPnvKfHyfWmLAzxmsuUD/2eZKoAa0Y/?=
 =?us-ascii?Q?BVdSF7ce8NYnygw1whASH9j+3iqqt+ixe9KE8oyUHZtQKEibXiDXXpJ5o/cT?=
 =?us-ascii?Q?RAMSxegiKznZaZ4Gko9Ci/hdMzC8CNBpG5UQfjt+64lrAnH3KW9s1v6wJ97L?=
 =?us-ascii?Q?M1CxtWbdlzzkYgF42puqu3dwQoqad7JhcABJcqVOR4eTA6+7tAFffBdPNdPs?=
 =?us-ascii?Q?gS0aWXMFiqXrPO5+DPyjQ7s=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a0c20d0-1f3a-4d02-f976-08d998a27685
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 17:02:59.4343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0gh24R0bMZG0LLZOgZ1kXJKI31cyAFKL6V7c04XVwUfqkuzL/QFKhziQRa1FB4OYkfHpUr2NFeCcCT0bnMemEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8314
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I had a few assorted KVM RISC-V changes which I wanted to sent after
KVM RISC-V was merged hence this series.

These patches can also be found in riscv_kvm_assorted_v1 branch at:
https://github.com/avpatel/linux.git

Anup Patel (3):
  RISC-V: Enable KVM in RV64 and RV32 defconfigs as a module
  RISC-V: KVM: Factor-out FP virtualization into separate sources
  RISC-V: KVM: Fix GPA passed to __kvm_riscv_hfence_gvma_xyz() functions

 arch/riscv/configs/defconfig         |  15 ++-
 arch/riscv/configs/rv32_defconfig    |   8 +-
 arch/riscv/include/asm/kvm_host.h    |  10 +-
 arch/riscv/include/asm/kvm_vcpu_fp.h |  59 +++++++++
 arch/riscv/kvm/Makefile              |   1 +
 arch/riscv/kvm/tlb.S                 |   4 +-
 arch/riscv/kvm/vcpu.c                | 172 ---------------------------
 arch/riscv/kvm/vcpu_fp.c             | 167 ++++++++++++++++++++++++++
 8 files changed, 244 insertions(+), 192 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_fp.h
 create mode 100644 arch/riscv/kvm/vcpu_fp.c

-- 
2.25.1

