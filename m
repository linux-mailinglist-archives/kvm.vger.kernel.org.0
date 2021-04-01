Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78236351A95
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236138AbhDASCJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:02:09 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:59599 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236548AbhDAR6A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 13:58:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617299881; x=1648835881;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=73/GetQxONBnna3naBTBIVnHoPDXomMO14Fw9GZFHVU=;
  b=NaQs8pAfIq2dATvhwf1M6qKvVaTV/BYeglFATbkr9+h6lAkFe8f0+0V/
   Sf6C5WpmVgtuFaA+iJI5kePKcJnHaWJ6072/yWOlvvzq/3UtbCbtCzFC6
   kQfm+JKXp/rWQtqPPLDmXtRXQ+P40zpfHLZUvb+h2r3Vp8tazyrfzF2Gn
   x7DfErwepjJo0zWnhAnpD6a+izp6Bq6sRU29+5c8j5KFG/CaGeSbtcH7A
   c514r+s9u0HBLymGa1FyuToK2rYx/djF1uxym1tpULo+ivokKGkazPVXw
   jwGHmc558u/af4NWkrxQbptg2PC79zhSFAgRW4ve4KGxYrkLckiJygrCh
   A==;
IronPort-SDR: nu3IYh6FcUDvv5raiwmlEhAoHy3Wa5u0DHPPNZj/t4qZZHXyrGa6RXRiUi0sMlxKxMMwGo3qtZ
 0asZFSjbpRH3tIUve0sCrPM9EsCXTzJ72X+Sa+wKMckSo+qJr9WYxVD4qxyJb6cDSm0GqEv3Vx
 OidGnY7aTaq8IFkcGS6SgWwrExH0u3TPrVo8tq0UcKDMLdKnVAKb0vcab9cc2lu96cO0GFBfq0
 nmLMTr4m3iQxLZ/auKkDLSDurdUAZMvwewuZk21WntThyMBmR/mUg/2vtVWYAyUsFepKcWj+J2
 tEU=
X-IronPort-AV: E=Sophos;i="5.81,296,1610380800"; 
   d="scan'208";a="163447192"
Received: from mail-dm3nam07lp2045.outbound.protection.outlook.com (HELO NAM02-DM3-obe.outbound.protection.outlook.com) ([104.47.56.45])
  by ob1.hgst.iphmx.com with ESMTP; 01 Apr 2021 21:35:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gnMX0jBSgmP+7QL0oW7nDdrVkrattvWc4EmhRgN10tXNTFSSexKfPTDzwiA015Y9JM4DXy2vUOSD9DPxOaOuUv4v4mm5c1J3WctCp8jze4feWodNLzpX6MFk3NjkyFWhtpxeWpinIBm2+FhhrTM6Kcf4uHMrUncXNowQMucmvfrPa+dz3SWSfDb4sj5hHVQFGbXX+WNDS7LWi//Wz0Dlgm4UxiSiKyKYKa/km6sfAvhl0xMDV1R3RP4UHq91HX88IGgnQhGkK5lKfmvTE55MSekX4LMryn0nhBoiCYkzoKaDus9sH+yD2/tYSfnEehKpTdReAKHJLYRelie08XdrKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3SKoMUbW2eLvAheKEAnL7+DHjQ1AoYVvj7LHQZKt4io=;
 b=jOEGiUtOY/3+t4y0Qm9JVhsLi4xHXfWRt1EJdT4A/+DtB4tg0BcANPYiuTXpmvpsGRFcetZypyE28uqSnFxAcfX9+npN3vJEfjw2U/+HQUpbCEB8Cfa+IGlHxJIEr6FlgXYK6Vn8aPXMVK7ORTzgV+BaDfYxyrCeP7p0gnvGDHSbM2ih/wIgIQt9SOi4z4TBzxZqx6n4C2T+vJf6tom6bV2g1O+1LLV6+yLCNKDj7PoMyT30NvHJqyos7HLthLEGo0kz/FMiW6LaPUesUgbLPKOb5yraQ+UldTFQnha1WJ/Fj2Jk9qatrCejkVNHHluIDvfB1NsuNHcfZ0Gh3MjfjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3SKoMUbW2eLvAheKEAnL7+DHjQ1AoYVvj7LHQZKt4io=;
 b=Y22+W2/lnpTaEwKHo4yWwP4bQBu2CjAFPA0xRayKnP/LqG08Sg7K/3zWorhXr+6QvNJYI2hBCPYoXeyPhTZo8oLmcKH35S7BjX135YSn2d40OrtIFPU4ZgbBnUt0yw1uWHdH4T+zMlDeA3TQwyARmUhUdKTt3oJ0pGP3VwwHu0k=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB3865.namprd04.prod.outlook.com (2603:10b6:5:ac::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Thu, 1 Apr
 2021 13:35:17 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868%7]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 13:35:17 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v17 00/17] KVM RISC-V Support
Date:   Thu,  1 Apr 2021 19:04:18 +0530
Message-Id: <20210401133435.383959-1-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.179.112.210]
X-ClientProxiedBy: MA1PR01CA0104.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::20) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.179.112.210) by MA1PR01CA0104.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Thu, 1 Apr 2021 13:35:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6a41bcf-24ac-46f8-a477-08d8f512fcd4
X-MS-TrafficTypeDiagnostic: DM6PR04MB3865:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB3865269520B5442895B077108D7B9@DM6PR04MB3865.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:79;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y8KUloPqvd76dcFuZKBZoPw9H8ICb5mZp8zTDMPwN7M57SE+02D3kdB6o+KAPFv0Bi0A2/+aInMTL2FQK0eYRWdjy93VZlB241cd36Ly3I8noANSWa73UMig6boWGAibC1px5cRust4bsVxZNBsgPRgI1+OfA8nh1r+cWmjS6fL9eXv8VsBglF9bp+kpoHFSARtybyQqyOj0miroofUrX26JS2gOtm0a4FuyqyzPrDlkkQgOoKnP3gIQ3my1BNr80ndkScG+1AcO3NM/pq4fsfKrn+6A0VZLQTcQ6VmK7m/sdq2NJ5vRsvZT3xJAm+Vz/0RyhQaF6WM2NCQI8peze4xNgc/z/VULL7JmwF0a1/ZcOrVh0lIhzHo4cSZeLGfSbvPkFuQBc4pk9rluBD4/Ix87htrs+Es/gFUF5ylBLTD1K0fCVOv8pfYMs/x9X9HlKJ+Mqa8D1WgMTGE2xpBqO2PnELguXlIF0aM/VAkBv4CdISVd8mxhgL7FJQDZgzNEyZcITTwmWUZ1+Wx6VZa0liyYl+bnI0yE4OOdSwl3CvT7RVJ50KGCYsbigGMjs08njSc0TVNtB1HnmApvV71cocwCumCR3MdSKfVeJ6/Xy/pgALmWoqPTupZfEUAj5CFKXASL37D6mqaDit/Jik9YfL79TW1aagV0n1j4FmbJ3crYGGuJ3CoYAffZDQCT83ep5xNoIyW9iO3eyAPf3i1TbctjaS/Gzjk9bwg7ED2HZLqlaKKuJ80OpDxg0YvCLsuPs4eUhCLrMddJmvf+aZCYeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(366004)(39860400002)(6666004)(36756003)(55016002)(26005)(2906002)(30864003)(83380400001)(966005)(66556008)(66476007)(5660300002)(66946007)(7416002)(186003)(16526019)(7696005)(956004)(2616005)(8886007)(38100700001)(8936002)(52116002)(44832011)(54906003)(110136005)(8676002)(316002)(86362001)(4326008)(1076003)(478600001)(42580500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?CjochSdHlIpFtoqpFPCuQpY4wHKzW6I4TrAz9EYaXXcdfEltT5pNbdBcPZIp?=
 =?us-ascii?Q?4JtOpeTGGPJa9lDSzmykNwbJAJohR8STx9xTrR7nBW9OuLd4h9eF5+tWmz5v?=
 =?us-ascii?Q?pOHEmTLLMXJ4ZFHoI4VlyER1VWbt1eH+hgdXxYNlwv+L/S8uJoNKaRMeRdXr?=
 =?us-ascii?Q?UUlbUGFuUMzHkkI8c+PJMy/hEEpdJpoEby2HmdabPESApABnCjoN0mtnnNlg?=
 =?us-ascii?Q?9chxLkxerXu88c0gMG4BTZNN+WvHYfCN3D92SwksRD7JrDSS0DPI6CVW+KTH?=
 =?us-ascii?Q?vNBFQHqIgDPJKiP6NKHGcyCP4FYeHCfNxtym5q8cHA7eYmpjukbUchIFpN+V?=
 =?us-ascii?Q?+R0uRr+kSlCMVFgR4odK7CDVj9PHZXf3QoOueTpqfG7DUoaNyY6phIAwwryI?=
 =?us-ascii?Q?ppZPPf8126HigqCJHYWxSS1pm6nHU4tsM1YSBOMQELfg0f1QukCGxIW54DjI?=
 =?us-ascii?Q?mBhNAAv/KJVlwN+Lg53a1f0vTafHX03FEpK6GT8i2utD7j/Hei3Kmim2X0lG?=
 =?us-ascii?Q?LDnKK2HiaMhq5L89ouQgG/qobrkuw+EwgaM+gvNrXHEtFiRjyIdiPx/Leys/?=
 =?us-ascii?Q?n7a+f1hNzGXdxN23svy77m+e5A2HoP8gA8IokCwiz0b55pAfQP1Xg2zDTjZ+?=
 =?us-ascii?Q?B9coI4CmdF6EkYMeuG6QE9TPfKB10YiUZGpQxa5vOczkf+FEqrTjWmR0k2gG?=
 =?us-ascii?Q?udxT5SERFJGJKBTm+Su4YHP4YFZfHfnr2qJe7CC8Pn/tS7tFi+4+RzrDbL4z?=
 =?us-ascii?Q?bUMXKEuh3CA/2OScWXCi6MBYtiokVpVHkzPhKIYIsEHuTQpI3IvEitUdFmX4?=
 =?us-ascii?Q?NlmrMAprpVUlizu5cMfIk/O3eJT4BjYT549t0Sp8PeMiGc82cGxD6AnvuVZw?=
 =?us-ascii?Q?QLJ1sNr762IXDC6hr79I5zmtNFXp7hP2Q3xliec3kLS6IzB2LkyNk1eiCbWT?=
 =?us-ascii?Q?7dusvP+K/tDT6mY8jq1PiTx1cNv4f1UYWfs1/seHK8+BWq0kgX1shL77MXNC?=
 =?us-ascii?Q?5tNs0sae+6I98t8+5vtp3m4r0tfbFt/0lcvmj30MVVvFMUR/YTZBHA++Txkl?=
 =?us-ascii?Q?goWqoAjgbxKs6ALEMHKgHFNKo1YHRNJiFMoTEnyBaOUR2o2ZDNyGCP3RbSoL?=
 =?us-ascii?Q?vZKUIQr7cKAC+2ON0KhBn4xnGlHk1TP0fYN+Se3gq0DsgHA+hZRui7b42Tm9?=
 =?us-ascii?Q?rD7wM1Ycak972lUzwVNTHQmumkl81s9mhT2lV/2I/t4apKVXfHjqm0rjpgfw?=
 =?us-ascii?Q?xo26v6ljpi6Iw3XiHmhTgWgNHA32GVxY2pA3x/4eU52n2xHavNqknXMR/FQZ?=
 =?us-ascii?Q?SWXdiJnCIjfxj6/DLiHyKPwF?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6a41bcf-24ac-46f8-a477-08d8f512fcd4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 13:35:17.5873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XdMrA52+3+nnhc1911yPSlcmgit75E4F6Lz78qEFlxHWpJJkwLAsnHxLka8yvanJSzNAE4pk8s47Zlw+WEVH3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB3865
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds initial KVM RISC-V support. Currently, we are able to boot
Linux on RV64/RV32 Guest with multiple VCPUs.

Key aspects of KVM RISC-V added by this series are:
1. No RISC-V specific KVM IOCTL
2. Minimal possible KVM world-switch which touches only GPRs and few CSRs
3. Both RV64 and RV32 host supported
4. Full Guest/VM switch is done via vcpu_get/vcpu_put infrastructure
5. KVM ONE_REG interface for VCPU register access from user-space
6. PLIC emulation is done in user-space
7. Timer and IPI emuation is done in-kernel
8. Both Sv39x4 and Sv48x4 supported for RV64 host
9. MMU notifiers supported
10. Generic dirtylog supported
11. FP lazy save/restore supported
12. SBI v0.1 emulation for KVM Guest available
13. Forward unhandled SBI calls to KVM userspace
14. Hugepage support for Guest/VM
15. IOEVENTFD support for Vhost

Here's a brief TODO list which we will work upon after this series:
1. SBI v0.2 emulation in-kernel
2. SBI v0.2 hart state management emulation in-kernel
3. In-kernel PLIC emulation
4. ..... and more .....

This series can be found in riscv_kvm_v17 branch at:
https//github.com/avpatel/linux.git

Our work-in-progress KVMTOOL RISC-V port can be found in riscv_v7 branch
at: https//github.com/avpatel/kvmtool.git

The QEMU RISC-V hypervisor emulation is done by Alistair and is available
in master branch at: https://git.qemu.org/git/qemu.git

To play around with KVM RISC-V, refer KVM RISC-V wiki at:
https://github.com/kvm-riscv/howto/wiki
https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-QEMU
https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-Spike

Changes since v16:
 - Rebased on Linux-5.12-rc5
 - Remove redundant kvm_arch_create_memslot(), kvm_arch_vcpu_setup(),
   kvm_arch_vcpu_init(), kvm_arch_has_vcpu_debugfs(), and
   kvm_arch_create_vcpu_debugfs() from PATCH5
 - Make stage2_wp_memory_region() and stage2_ioremap() as static
   in PATCH13

Changes since v15:
 - Rebased on Linux-5.11-rc3
 - Fixed kvm_stage2_map() to use gfn_to_pfn_prot() for determing
   writeability of a host pfn.
 - Use "__u64" in-place of "u64" and "__u32" in-place of "u32" for
   uapi/asm/kvm.h

Changes since v14:
 - Rebased on Linux-5.10-rc3
 - Fixed Stage2 (G-stage) PDG allocation to ensure it is 16KB aligned

Changes since v13:
 - Rebased on Linux-5.9-rc3
 - Fixed kvm_riscv_vcpu_set_reg_csr() for SIP updation in PATCH5
 - Fixed instruction length computation in PATCH7
 - Added ioeventfd support in PATCH7
 - Ensure HSTATUS.SPVP is set to correct value before using HLV/HSV
   intructions in PATCH7
 - Fixed stage2_map_page() to set PTE 'A' and 'D' bits correctly
   in PATCH10
 - Added stage2 dirty page logging in PATCH10
 - Allow KVM user-space to SET/GET SCOUNTER CSR in PATCH5
 - Save/restore SCOUNTEREN in PATCH6
 - Reduced quite a few instructions for __kvm_riscv_switch_to() by
   using CSR swap instruction in PATCH6
 - Detect and use Sv48x4 when available in PATCH10

Changes since v12:
 - Rebased patches on Linux-5.8-rc4
 - By default enable all counters in HCOUNTEREN
 - RISC-V H-Extension v0.6.1 spec support

Changes since v11:
 - Rebased patches on Linux-5.7-rc3
 - Fixed typo in typecast of stage2_map_size define
 - Introduced struct kvm_cpu_trap to represent trap details and
   use it as function parameter wherever applicable
 - Pass memslot to kvm_riscv_stage2_map() for supporing dirty page
   logging in future
 - RISC-V H-Extension v0.6 spec support
 - Send-out first three patches as separate series so that it can
   be taken by Palmer for Linux RISC-V

Changes since v10:
 - Rebased patches on Linux-5.6-rc5
 - Reduce RISCV_ISA_EXT_MAX from 256 to 64
 - Separate PATCH for removing N-extension related defines
 - Added comments as requested by Palmer
 - Fixed HIDELEG CSR programming

Changes since v9:
 - Rebased patches on Linux-5.5-rc3
 - Squash PATCH19 and PATCH20 into PATCH5
 - Squash PATCH18 into PATCH11
 - Squash PATCH17 into PATCH16
 - Added ONE_REG interface for VCPU timer in PATCH13
 - Use HTIMEDELTA for VCPU timer in PATCH13
 - Updated KVM RISC-V mailing list in MAINTAINERS entry
 - Update KVM kconfig option to depend on RISCV_SBI and MMU
 - Check for SBI v0.2 and SBI v0.2 RFENCE extension at boot-time
 - Use SBI v0.2 RFENCE extension in VMID implementation
 - Use SBI v0.2 RFENCE extension in Stage2 MMU implementation
 - Use SBI v0.2 RFENCE extension in SBI implementation
 - Moved to RISC-V Hypervisor v0.5 draft spec
 - Updated Documentation/virt/kvm/api.txt for timer ONE_REG interface

Changes since v8:
 - Rebased series on Linux-5.4-rc3 and Atish's SBI v0.2 patches
 - Use HRTIMER_MODE_REL instead of HRTIMER_MODE_ABS in timer emulation
 - Fixed kvm_riscv_stage2_map() to handle hugepages
 - Added patch to forward unhandled SBI calls to user-space
 - Added patch for iterative/recursive stage2 page table programming
 - Added patch to remove per-CPU vsip_shadow variable
 - Added patch to fix race-condition in kvm_riscv_vcpu_sync_interrupts()

Changes since v7:
 - Rebased series on Linux-5.4-rc1 and Atish's SBI v0.2 patches
 - Removed PATCH1, PATCH3, and PATCH20 because these already merged
 - Use kernel doc style comments for ISA bitmap functions
 - Don't parse X, Y, and Z extension in riscv_fill_hwcap() because it will
   be added in-future
 - Mark KVM RISC-V kconfig option as EXPERIMENTAL
 - Typo fix in commit description of PATCH6 of v7 series
 - Use separate structs for CORE and CSR registers of ONE_REG interface
 - Explicitly include asm/sbi.h in kvm/vcpu_sbi.c
 - Removed implicit switch-case fall-through in kvm_riscv_vcpu_exit()
 - No need to set VSSTATUS.MXR bit in kvm_riscv_vcpu_unpriv_read()
 - Removed register for instruction length in kvm_riscv_vcpu_unpriv_read()
 - Added defines for checking/decoding instruction length
 - Added separate patch to forward unhandled SBI calls to userspace tool

Changes since v6:
 - Rebased patches on Linux-5.3-rc7
 - Added "return_handled" in struct kvm_mmio_decode to ensure that
   kvm_riscv_vcpu_mmio_return() updates SEPC only once
 - Removed trap_stval parameter from kvm_riscv_vcpu_unpriv_read()
 - Updated git repo URL in MAINTAINERS entry

Changes since v5:
 - Renamed KVM_REG_RISCV_CONFIG_TIMEBASE register to
   KVM_REG_RISCV_CONFIG_TBFREQ register in ONE_REG interface
 - Update SPEC in kvm_riscv_vcpu_mmio_return() for MMIO exits
 - Use switch case instead of illegal instruction opcode table for simplicity
 - Improve comments in stage2_remote_tlb_flush() for a potential remote TLB
  flush optimization
 - Handle all unsupported SBI calls in default case of
   kvm_riscv_vcpu_sbi_ecall() function
 - Fixed kvm_riscv_vcpu_sync_interrupts() for software interrupts
 - Improved unprivilege reads to handle traps due to Guest stage1 page table
 - Added separate patch to document RISC-V specific things in
   Documentation/virt/kvm/api.txt

Changes since v4:
 - Rebased patches on Linux-5.3-rc5
 - Added Paolo's Acked-by and Reviewed-by
 - Updated mailing list in MAINTAINERS entry

Changes since v3:
 - Moved patch for ISA bitmap from KVM prep series to this series
 - Make vsip_shadow as run-time percpu variable instead of compile-time
 - Flush Guest TLBs on all Host CPUs whenever we run-out of VMIDs

Changes since v2:
 - Removed references of KVM_REQ_IRQ_PENDING from all patches
 - Use kvm->srcu within in-kernel KVM run loop
 - Added percpu vsip_shadow to track last value programmed in VSIP CSR
 - Added comments about irqs_pending and irqs_pending_mask
 - Used kvm_arch_vcpu_runnable() in-place-of kvm_riscv_vcpu_has_interrupt()
   in system_opcode_insn()
 - Removed unwanted smp_wmb() in kvm_riscv_stage2_vmid_update()
 - Use kvm_flush_remote_tlbs() in kvm_riscv_stage2_vmid_update()
 - Use READ_ONCE() in kvm_riscv_stage2_update_hgatp() for vmid

Changes since v1:
 - Fixed compile errors in building KVM RISC-V as module
 - Removed unused kvm_riscv_halt_guest() and kvm_riscv_resume_guest()
 - Set KVM_CAP_SYNC_MMU capability only after MMU notifiers are implemented
 - Made vmid_version as unsigned long instead of atomic
 - Renamed KVM_REQ_UPDATE_PGTBL to KVM_REQ_UPDATE_HGATP
 - Renamed kvm_riscv_stage2_update_pgtbl() to kvm_riscv_stage2_update_hgatp()
 - Configure HIDELEG and HEDELEG in kvm_arch_hardware_enable()
 - Updated ONE_REG interface for CSR access to user-space
 - Removed irqs_pending_lock and use atomic bitops instead
 - Added separate patch for FP ONE_REG interface
 - Added separate patch for updating MAINTAINERS file

Anup Patel (13):
  RISC-V: Add hypervisor extension related CSR defines
  RISC-V: Add initial skeletal KVM support
  RISC-V: KVM: Implement VCPU create, init and destroy functions
  RISC-V: KVM: Implement VCPU interrupts and requests handling
  RISC-V: KVM: Implement KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls
  RISC-V: KVM: Implement VCPU world-switch
  RISC-V: KVM: Handle MMIO exits for VCPU
  RISC-V: KVM: Handle WFI exits for VCPU
  RISC-V: KVM: Implement VMID allocator
  RISC-V: KVM: Implement stage2 page table programming
  RISC-V: KVM: Implement MMU notifiers
  RISC-V: KVM: Document RISC-V specific parts of KVM API
  RISC-V: KVM: Add MAINTAINERS entry

Atish Patra (4):
  RISC-V: KVM: Add timer functionality
  RISC-V: KVM: FP lazy save/restore
  RISC-V: KVM: Implement ONE REG interface for FP registers
  RISC-V: KVM: Add SBI v0.1 support

 Documentation/virt/kvm/api.rst          | 193 ++++-
 MAINTAINERS                             |  11 +
 arch/riscv/Kconfig                      |   1 +
 arch/riscv/Makefile                     |   2 +
 arch/riscv/include/asm/csr.h            |  89 +++
 arch/riscv/include/asm/kvm_host.h       | 277 +++++++
 arch/riscv/include/asm/kvm_types.h      |   7 +
 arch/riscv/include/asm/kvm_vcpu_timer.h |  44 ++
 arch/riscv/include/asm/pgtable-bits.h   |   1 +
 arch/riscv/include/uapi/asm/kvm.h       | 128 +++
 arch/riscv/kernel/asm-offsets.c         | 156 ++++
 arch/riscv/kvm/Kconfig                  |  36 +
 arch/riscv/kvm/Makefile                 |  15 +
 arch/riscv/kvm/main.c                   | 118 +++
 arch/riscv/kvm/mmu.c                    | 854 ++++++++++++++++++++
 arch/riscv/kvm/tlb.S                    |  74 ++
 arch/riscv/kvm/vcpu.c                   | 997 ++++++++++++++++++++++++
 arch/riscv/kvm/vcpu_exit.c              | 701 +++++++++++++++++
 arch/riscv/kvm/vcpu_sbi.c               | 173 ++++
 arch/riscv/kvm/vcpu_switch.S            | 400 ++++++++++
 arch/riscv/kvm/vcpu_timer.c             | 225 ++++++
 arch/riscv/kvm/vm.c                     |  81 ++
 arch/riscv/kvm/vmid.c                   | 120 +++
 drivers/clocksource/timer-riscv.c       |   8 +
 include/clocksource/timer-riscv.h       |  16 +
 include/uapi/linux/kvm.h                |   8 +
 26 files changed, 4726 insertions(+), 9 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_host.h
 create mode 100644 arch/riscv/include/asm/kvm_types.h
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_timer.h
 create mode 100644 arch/riscv/include/uapi/asm/kvm.h
 create mode 100644 arch/riscv/kvm/Kconfig
 create mode 100644 arch/riscv/kvm/Makefile
 create mode 100644 arch/riscv/kvm/main.c
 create mode 100644 arch/riscv/kvm/mmu.c
 create mode 100644 arch/riscv/kvm/tlb.S
 create mode 100644 arch/riscv/kvm/vcpu.c
 create mode 100644 arch/riscv/kvm/vcpu_exit.c
 create mode 100644 arch/riscv/kvm/vcpu_sbi.c
 create mode 100644 arch/riscv/kvm/vcpu_switch.S
 create mode 100644 arch/riscv/kvm/vcpu_timer.c
 create mode 100644 arch/riscv/kvm/vm.c
 create mode 100644 arch/riscv/kvm/vmid.c
 create mode 100644 include/clocksource/timer-riscv.h

-- 
2.25.1

