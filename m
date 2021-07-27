Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C9B3D6E4F
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 07:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235170AbhG0FzV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 01:55:21 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:3876 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233553AbhG0FzT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 01:55:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627365320; x=1658901320;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=7Y+12pXzD7uCRL22muRgNYcmVMSKLDeCJkyJ55/i4B4=;
  b=PHODlJ1Q5GtkAdykd/3BEVRJNIFq3cqD9hAM74gjupp6ohO+Heo+HTvZ
   bcxQIPCkV4MPkKVUjxEoVWjDeRHp+M5LGatSmIdhnBHL+PCx0n8MGz9uW
   Qyr157mCIUEc7lrdX1gSEGa5UwFpY5vALQpkzK+SG8uNdYl+aqa88OjwQ
   +mICt9Y7GbRO+9xOBxCzzq7khsZ7fpQA3lgi0CLt70i3G/CGfaFQtas7q
   W87d359fpAVXWMgfAJMPb5PHnpuiDMXEfikb6V1iI4ru64Ah4so5WveaJ
   Qtjw9PVfQ1uDvnk9EVf0ygAtz89YNt/etnhuADmpa3zzqxi3ciRU/8NT0
   w==;
X-IronPort-AV: E=Sophos;i="5.84,272,1620662400"; 
   d="scan'208";a="176146048"
Received: from mail-dm6nam08lp2046.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.46])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jul 2021 13:55:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rae+g7rclcHPwyPp8wHUybdBRqW0qBRDkd+PZyjy6u4E/whTO1eq3kTY7wMkIb9udTxVDYZpgYTvK44rXmyCMvm3cu327pCYCgNhjiu1D1xkNeirdocmgVsxIejz7+HIuklygYjtJuoykWtaC3YM9Sa499GzI0JH7EogaOkwyrCxhbYZAwLnRrFdVDawbrMVh66Nbd/BB2B6pdjBh3i4mJUXTd3UaxNY9zHERl2msGkLcTaKo6Xk2lFFIBN1F3fzpiPpkfS1DApZjmSag9hcYRUbDAGnNTO0efm+pX9t18MiJ0ik1YuKo/dnazm2IvvcdxLjg79d6f+m2RmKG1Es8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GM4He3/tCskH7NaizHCXRp0JaamvkktW+6pPHiZUn+E=;
 b=lmD0PVudXZ2CeBRJ3v1Y4rpCvOFj3MyXrhT0Wlj/sSLhHZ4RUQFiKjNNoSfVFh4MEtrnq2S7wtMbC8jlvCdI4a1lrJ46EI+0EbxSG79RITAYXQ61OFkXtLC3IDztDnOqJ3JgKfw4MLUJpzd0uU84qLKk+c10LHlyTYZNnsWm0dvzJlhSlFGWc1XjKsRdI2zIsX1bXVRe/Y8gd+TnN9fxOLnd6m6GjOkxNCC65fd3KBWHgPpudhpGdWVCU6Vf5WkUUufNjxnOvpS8TSZkp+Pcu/RtAUAxr0Y3PXqCFVnDU6ehTzuHb0Nb4/hYW+Xxh6pkUTpGikNhD9JJeG3Q3p/vfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GM4He3/tCskH7NaizHCXRp0JaamvkktW+6pPHiZUn+E=;
 b=FgZvMM+q5YJ5yoR8ktqmpbiL9SnowEPmufyDVRycMNj7qPy+sLkiSEM7NIh36sCTp+XByJ3GKfp34PaA8fcNLcCkmBaX8BowrVG1nwUV2cBr63v6UFGrkHm7+KGVK+OBmh8lDdEuruUiJF2w0OKh89j3iUWfQOW9TEr5pFVOwNE=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7778.namprd04.prod.outlook.com (2603:10b6:303:13e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Tue, 27 Jul
 2021 05:55:17 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::a153:b7f8:c87f:89f8]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::a153:b7f8:c87f:89f8%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 05:55:17 +0000
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
Subject: [PATCH v19 00/17] KVM RISC-V Support
Date:   Tue, 27 Jul 2021 11:24:33 +0530
Message-Id: <20210727055450.2742868-1-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0030.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:22::16) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.171.179.229) by MA1PR0101CA0030.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:22::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Tue, 27 Jul 2021 05:55:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49551d46-e0d0-4b2f-f086-08d950c31c17
X-MS-TrafficTypeDiagnostic: CO6PR04MB7778:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB7778193CCC54C88A4C59D9308DE99@CO6PR04MB7778.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:79;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2VJq7Jsk2Lxd0SwA+3cZFEnysmnGGCWOmc6ij902H0OVe4OEjx+/0AjTWLL7ZHzVwH5MtiQKEDSF+J5l1YgC6KJLLiHkwAUKg8KZeLpke1iaJav0cQVvub/pE6VEEKnhNkhOWLoYgVVQyMNT5LR8lUOGdXG1kQVtkLrwwsxWcOR9xF//kQfsKOMmwU8eJuhVjRTfxkCUI5CKAzf3s79jItACz0Veq+PDXPEHkRXr1Hp9dsDBFzxwhAJPH5gfzgkQgq1NqySf8qGLOIuRdsOhPwyxKzF5+yMPeD7mTZxaHAL7MC0AjYnUXbDsazwTuuF1kxrz287lDHyCESftTvd/5ELWZMB+YL4OZsvVYH/eBe5sDljYZaklQADHha/nXCVC7GP4ff5JvgQBdGLJHJmZhwvztsC/+W+6ES3PbODA6cYc2b1nYTrpJiJMe/s7igp093rUezJyn8d8G6cjkbAEe7q8oS4oWc76B/aIxM4eCAHnNnQfci7w3yFFpa0O0gaCLGAaubZuNkxYsxEJ/cwLao+WYVr1jHZfk38MyCzEHozYHWs3+HUx6jxUsFlsjNtH4FUsiJk7qmAfMd8dhxkZTLLz0SBedMQvZhlXS7ipLuIynsLoCKp3FCOyrtJVFjteagJQ3Yn/9G9NuMM2kU4Lz1xhbxh1BSqNXMRvA/1iQ1pD3Q0MMF3bQsueEWiMmgMTyfbHoS81Zfym6czkLVArzyWJLhYORCIvBmN8GH5NpDzBp/BS8CzrHPYD401mUsqGiCpQt1D7wXXKiDtUtgyIT2/RTPPmDsz4HPrnRW0T6NnTPiTEQgcZWuBPiH79lLchlXLL3DwMWUm1mr6t02weftPSBBzGrifk7VnmoCe0moU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(366004)(346002)(396003)(66556008)(66476007)(956004)(44832011)(5660300002)(52116002)(38350700002)(186003)(316002)(110136005)(38100700002)(2616005)(8936002)(7696005)(4326008)(30864003)(8676002)(2906002)(26005)(86362001)(1076003)(54906003)(66946007)(7416002)(55016002)(966005)(6666004)(8886007)(478600001)(36756003)(83380400001)(42580500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mJ1c5DQTzZf3Hf8fB83C8gv2hTJDhjxqKXnC86BzgyLihLz1nTM9Mr+ysW/w?=
 =?us-ascii?Q?3grlwJoYVYdH94ov+QUiL18BY1w8Uu2Ds/+5t6PIUKQIUQzjNV0rWX8JI4hJ?=
 =?us-ascii?Q?XKobC+9Ni40NP34veeNhg6cEDKh8ha+DbPDkCTrj53IUT/qSH7BgVX1dZE3K?=
 =?us-ascii?Q?YGS2c80GMQBU8B9AlZ4UBOi6wQbxHWdHV0kaLs5cTnuoRaIj21wFZvE91d2r?=
 =?us-ascii?Q?NRpUt/jV/yf0IIJcvdCtvcL46cMyaLQzI5AUe4KWH8JVdV+TRHbDcV+VPGq9?=
 =?us-ascii?Q?WoB7UgmWe5XdxXDgFsJM8dit9oCbWoFJDNPiY+yIxtDsCS7/CWhYD5/8yc92?=
 =?us-ascii?Q?nvj7Q/ewSdoQMSJ3RwoVa8qpHODfWw8goXtoF9yzV3W418+4rhbpx9bbonIp?=
 =?us-ascii?Q?pyluO9ZAfdkGO5fTvTej7+0XDHeVPEJFyG6buTWC2M95URIx62WU3yoZTWdW?=
 =?us-ascii?Q?aZWuG5ss7TQpie+AXQJ3l4HDCELmOtcmy37UvHza9DH5miELao50Leh/DRj9?=
 =?us-ascii?Q?cFDiQJfLDzawKTQhpkMRAKfj3b/P30cI1lZA/lte7AwCNRti+uRjfhiRAdFJ?=
 =?us-ascii?Q?8LL4z9i2bKKT8Gmx4UlXlDP7AgOGO/OhchU0KyIIGQD3lolaihyj9yVkSHF7?=
 =?us-ascii?Q?Bppiq2mXM730wd59mwGJWxWcdn0CJY+ZsJsJpc7wVq4ZGr8hNevbmwv2dVWH?=
 =?us-ascii?Q?jOHcJPheE0W55a+u8ZLtnKZlO4U2aNYl6B7XsPOW3rkbj/oqdLZDOe3rEFwX?=
 =?us-ascii?Q?PEhtffWnO4A9p/ptPwcTxSsW37o1ksr4wh9o8PLR0ygJgfbk0EBEeoaua3h1?=
 =?us-ascii?Q?wkcRz52bfyujjInlMTAnNv+rvPp19BSe7kDucXwRtCiMYgwWatOOMoPZGvlD?=
 =?us-ascii?Q?dydbKr9J7xpg6KJDqSKAAFXhKDtUPiiscmhv8hAv9ovW7KrOV6RIx4Vi9hkN?=
 =?us-ascii?Q?GfCmyh7V78D9/TWy7Qkp+DcZaVp1PKcEWgYFvOX5m/a8cYeZ9/0Vsp2B0x3U?=
 =?us-ascii?Q?eTtgZrKYwBV1R8bvDs3sZUOO2kiuSMa9qbQ+2Odgfi0NSU5LD5zC27n5h4k1?=
 =?us-ascii?Q?n0+41M4iG4RgZIBvr2hp6xpsbDHEPyQsTuiyrsbMUuK735St4MN6yIiY28lB?=
 =?us-ascii?Q?TYTQpNM+bhDZsxk//a4IAlAjjyp6jNl8ciDI4EaqzYiRPnm3aHdue6eFpVeV?=
 =?us-ascii?Q?bN5C1rARAVbNtUjhgQ4ZLx5Nmgwz7Z+JClR8As7SSJuirUkKInwrjM3E7W4K?=
 =?us-ascii?Q?4hmG3QDvtCgN3QS4OV5025TNDIjj9pvK3U774yVaDaQHHLvnbSshntjadJiU?=
 =?us-ascii?Q?eTZn12xExmCUeTAF232ZesiO?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49551d46-e0d0-4b2f-f086-08d950c31c17
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 05:55:17.1792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C1ttLra7IEvVdocY2x6c0bs8aiXHFEw/iqJzZNfoSqKATJ+xcwoOc2eKiVhIEObOEUGGQ2Vwp26atFz8I7L9TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7778
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

This series can be found in riscv_kvm_v19 branch at:
https//github.com/avpatel/linux.git

Our work-in-progress KVMTOOL RISC-V port can be found in riscv_v8 branch
at: https//github.com/avpatel/kvmtool.git

The QEMU RISC-V hypervisor emulation is done by Alistair and is available
in master branch at: https://git.qemu.org/git/qemu.git

To play around with KVM RISC-V, refer KVM RISC-V wiki at:
https://github.com/kvm-riscv/howto/wiki
https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-QEMU
https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-Spike

Changes since v18:
 - Rebased on Linux-5.14-rc3
 - Moved to new KVM debugfs interface
 - Dropped PATCH17 of v18 series for having KVM RISC-V in drivers/staging

Changes since v17:
 - Rebased on Linux-5.13-rc2
 - Moved to new KVM MMU notifier APIs
 - Removed redundant kvm_arch_vcpu_uninit()
 - Moved KVM RISC-V sources to drivers/staging for compliance with
   Linux RISC-V patch acceptance policy

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

 Documentation/virt/kvm/api.rst          |  193 ++++-
 MAINTAINERS                             |   12 +
 arch/riscv/Kconfig                      |    1 +
 arch/riscv/Makefile                     |    1 +
 arch/riscv/include/asm/csr.h            |   87 ++
 arch/riscv/include/asm/kvm_host.h       |  266 ++++++
 arch/riscv/include/asm/kvm_types.h      |    7 +
 arch/riscv/include/asm/kvm_vcpu_timer.h |   44 +
 arch/riscv/include/uapi/asm/kvm.h       |  128 +++
 arch/riscv/kernel/asm-offsets.c         |  156 ++++
 arch/riscv/kvm/Kconfig                  |   36 +
 arch/riscv/kvm/Makefile                 |   25 +
 arch/riscv/kvm/main.c                   |  118 +++
 arch/riscv/kvm/mmu.c                    |  802 ++++++++++++++++++
 arch/riscv/kvm/tlb.S                    |   74 ++
 arch/riscv/kvm/vcpu.c                   | 1002 +++++++++++++++++++++++
 arch/riscv/kvm/vcpu_exit.c              |  701 ++++++++++++++++
 arch/riscv/kvm/vcpu_sbi.c               |  173 ++++
 arch/riscv/kvm/vcpu_switch.S            |  400 +++++++++
 arch/riscv/kvm/vcpu_timer.c             |  225 +++++
 arch/riscv/kvm/vm.c                     |   96 +++
 arch/riscv/kvm/vmid.c                   |  120 +++
 drivers/clocksource/timer-riscv.c       |    9 +
 include/clocksource/timer-riscv.h       |   16 +
 include/uapi/linux/kvm.h                |    8 +
 25 files changed, 4691 insertions(+), 9 deletions(-)
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

