Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0760441933A
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 13:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbhI0Lm0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 07:42:26 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:64516 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233970AbhI0LmZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 07:42:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1632742847; x=1664278847;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=EIXO8/dzU9QZapHRN5fHiDnRsFcIoY+27I2Gk6oC0eY=;
  b=Uaip/MnGgpgBMCXoPyLFs10YiHPyV9NM470umMum+qnkMtspedJQnVqt
   OyZJ0cNhrzawLD2skMzQVLruq5R84gZ3d5OY44htewHDSexiXCcwf9y7n
   4QzD5J2QogFIIChiEJLaZHFMM/Pzcb636BmHD1UJXnB7Jx99sFubkXCjA
   ceV2JOiQZO3BqWg3N4uyH5c6fVDMLqGpGE5/YV2RnOZzSrWxhxIXbzRNe
   PNAn5S7QXR5lJkkdyTtQZG5DrwbRFqTLGc+lqiZPRh12KUkAwkzy1lD36
   VM7AO6M6wsUX7PUGkwzYY5zxd69YCFcWi408GKIoFU/PC7jkuu0tEyKjE
   g==;
X-IronPort-AV: E=Sophos;i="5.85,326,1624291200"; 
   d="scan'208";a="181070301"
Received: from mail-mw2nam12lp2047.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.47])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2021 19:40:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m7OCoew8Uw/DG8pJHStktALoY3CTKmX2lev72Ku8uzWs8TGqeXqjMBiTQcfxMMA8w9DhZjmfEEVtvB2SGCb27oQaRUNHTbGevDwSsGyuoQkAKKeHImf0DmZGpnaq5o2JjfmbwAS7AOZzXFkBAzwQL/Vxu3rA3JTDfgGCGbL8c1a08acQAUKtiaWi96ZXlCFWBmcq3W4dzX4cY5n3aT9O7AX6LPTlfCSHhhmZVulLkBmloWj2hidtNk7bXUC8dIAWQCVBxEzUvk/XHVi1Wmf+rPs8SzmJAwpC9g8pMmFYeTcod2P9Wb1ilWI3xMUZ47w+WY50kEtUiT+FFIPPXwROxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=GeD0kYQGM28CqXvQ6W0CDu0P5NKVDL/0QThaxDTEjvE=;
 b=YGDPI6dvXiKdQFWCqnRDlmhJoUVEc6VRl10o01IO6IrR0Sz7d6iSk7+ARSkYLkz7U6U3raqGfc6uzekQgnzI9CxO+5gzALeZ4+z6H9x/xkQVAICBVwSrPATj5Lpcod3woyhuPoM+f2kuhEA+bVfLa5PTML8uL2r21yitRyzyf6gJEAV4+VnLepfHLnXLhB8ZY+N8lOBcp2K0Qs+3E1I05wC5msGs90DrK5LfEw21SfjfMeHG3GrWIw/JFAyde5IhN71LWqs1Z27jwOqDWzkDkiOjYqWKHXuRzoHlxRW7CIvUaOLiQ+9FCYFKOhOB7tf/FMoVNo0NZDGLG3KEDau2xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GeD0kYQGM28CqXvQ6W0CDu0P5NKVDL/0QThaxDTEjvE=;
 b=uuNYS0KnY/8BXkZc20Z9nGxK/3xaAOWYIhYX+WHwGhZEk/KPgpb7QabYdFm/dDfUrk60tLvjNJtLf61lcEJ4fXIyFSahuU2M7Z9WcTrzJ1uoPbQzaeoRB58lHPf+LznB5YK3lu6MFVk+ibiwD0XicswV+qSRrrsa/C3x+vtYCx8=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB8345.namprd04.prod.outlook.com (2603:10b6:303:134::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Mon, 27 Sep
 2021 11:40:46 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b%6]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 11:40:45 +0000
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
Subject: [PATCH v20 00/17] KVM RISC-V Support
Date:   Mon, 27 Sep 2021 17:09:59 +0530
Message-Id: <20210927114016.1089328-1-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0051.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::13) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (122.179.75.205) by MAXPR0101CA0051.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Mon, 27 Sep 2021 11:40:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 331bb111-eebe-411e-b749-08d981aba4d9
X-MS-TrafficTypeDiagnostic: CO6PR04MB8345:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB83456782F38FF6AF7F3C2D678DA79@CO6PR04MB8345.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:79;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fx65++79SILbrUK8M/xP6P09VhiBdD6zFZwcouQWb8RGCJYjQSfhObDExtkqERS8gZjdOf+AQdTgjhkS+FRwnr4fXbBC9jRiOUUblbZVZavjC0/XDonO3Xgxkvp1Mh5no+l9WOXX4x8++On5DvLEnwfnv38vunso9ChGrbMUXlTG19mNAc5oS9Llsq1okZbGFBi/oB+g25SKuWJZdra+06hrc8hw6YReOGRl6Z4VD2L08ZKffYam3uv3xwob/snyBmlj3FGs3Oz3p420fUbhz+EKAE5Y0fUhlXEIDJJCT1w1VXOjIW7Kl+oiFbDM1BVV5H9hDo6MwFQV1LIpIX/MDLrrjSxjhpZM2CdF+ByUL+xMJH+XuO8Uq0eC095pWj9TOludwq5vpl2UPb7m6N1CCZKeHKaH2nRl5n1PqhSYcvh6EwlLdg1UKqoPntmv4M4bKJFEM+HMtt8mlmshwJhitsy8tz7omQtiohQRKjcWFuczM7cy2kMs5Bkuj+97+L6FnPonOQqTtPG++l2jTcZbxpdmJDSwZnwtpwOglVoofV16/r281N3zDRPwrfwaRyM0CF9WwMNkINxePOhzurTI+gFbYcoFUrko/1ZIgzOEEAs5en+fc5RLfNtPoBxiwVaDqfDd5rl5zXDoOB7OW2C8ErhgyjNSA3i2IqyqzyeRyIMmTz9OgFShgMAx76Dkz8ycaly87d2m0WHrWYdsPJxSO32T9ptBGRnZqpT1PU0eYbTahdi5XJ8UZZDMUEN5icWuXmN7yrQIVSySw9mOBRU0gBQISrcuPC42tCZxxSdWMce4MzCfEs7pbh9aHSxCR5ccol8tChcMreaGSFaomiLatwUmq7pYaVoaDhmm2nAw5Pc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(316002)(508600001)(1076003)(2906002)(8676002)(5660300002)(83380400001)(6666004)(966005)(7696005)(8936002)(38100700002)(52116002)(110136005)(38350700002)(186003)(66946007)(8886007)(54906003)(36756003)(66556008)(7416002)(86362001)(66476007)(956004)(2616005)(30864003)(55016002)(44832011)(4326008)(42580500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ksn/KHgnSrNvpuM0tv/EPqB47Clu+9e8eTuhzp9l774DY31hPR95h9NofgJF?=
 =?us-ascii?Q?qeHh9PMvoxo34P8i/mmGmxOA/N5QrR3LsaP73uue452zq7KrSpwe0s4rYXcq?=
 =?us-ascii?Q?ONNdLUbTwapnhp9PdwYaAkPiEWbtV9N9qwfC0lTbNUZ5poeY3Oz3GkUslqXJ?=
 =?us-ascii?Q?9gjfJO4hk2+iXn+bZo6dGYwRtKkHqzo121KqEAMFq8wlUYS5I0uGEqmntJNs?=
 =?us-ascii?Q?iXPLRqlUWE127tBP9G3Lw7spY6qdBDEmG3dXXWPinKjl/bO5W+2/5fISyQJr?=
 =?us-ascii?Q?kbZH7ahqaxHVrztCMtwHCfZMwSK1LYK3lUcTYOBxtMkuOVNF95hWKBZNXK2L?=
 =?us-ascii?Q?FGnbzhFsWamRIQquOSoZKYkRde5wTK975PrNatJg/P+Fjdx+d9Vc6YO/77ux?=
 =?us-ascii?Q?MV4pBQSkevX+yNIe55IeoyYGHMupU7NxdIQZheaoK4WOVfgXu7Jg5SwdRe+X?=
 =?us-ascii?Q?ZKYKgQSbecnTTLzWTud8BnIYZw3tHHb4LwtG5QrjjrAiKEChCyxQmSBME06J?=
 =?us-ascii?Q?RWpLf89xc8ZZftwiT90J/KKbK0uDpwGQ8Y2N3e43groo/3HT5TEqjaDxKKt+?=
 =?us-ascii?Q?0gww9nk0buZrs9+bFbErd8FcQBx+XWb7Xg9fepdMY3t+UTQqyxcRdsigX0E9?=
 =?us-ascii?Q?741zORJ5stbwRBz7XYHiAvLSRwTXJsZWCqO/hUt0BuuDGPSLxzeLHg82OGkb?=
 =?us-ascii?Q?O4VLU9V89TsAEvaCPGeJJkdZLfSCD7BZifaZswWGD48Tk+rycani2QhKzyvp?=
 =?us-ascii?Q?jy4mr8D1YBs2akl8FPAt0BTh95fLu9TMppTqDbeVwkSo7u420TYg3cZejsew?=
 =?us-ascii?Q?JGdD2tR2Lo88EzehHHxIFlt3FVE5qRJL6MzrT3IH28Ekq/J/iRUWviPddnEm?=
 =?us-ascii?Q?PzIPtFVAmH4j0KILwW0St2jLpESe81kPlL3Gzoy8FZ2cVuPVhQCz9mQvXKDY?=
 =?us-ascii?Q?WIN8EL6ZHvjnDUh2GTP5wl7LPaeRZNGMvaacRtaQA83lCfS5dk93mBWzZX6/?=
 =?us-ascii?Q?hW/CW9yZcvvWP23Lcaw3EqaRzAfZ8hMdWGBuw64waQnqGVh+DKQWJ0xyMBr8?=
 =?us-ascii?Q?Yjo3ytHVmT9vNQ+foJtcTFenwwaufZRZRafktuyyvFUOmPHgtbZtUsgtMAJl?=
 =?us-ascii?Q?sGog1eEzXNHAoiZP+sRh+kYXOWU+kvQqBfNJM+yo53+SwdDWQrTOZLExv0uu?=
 =?us-ascii?Q?blGRGKhRSOGgYDj+aGD2y4fdhNS+cusIVEawGpZl/wiUAjxyBHKQKcyKKEzq?=
 =?us-ascii?Q?cA29uVqgMXwvVv600HKlcmJA/1/2FcCBgZcOYh5OA3IyEGYDmsDWnpbNr6pN?=
 =?us-ascii?Q?54EAhI3BfFpEv+Q461SOm4zX?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 331bb111-eebe-411e-b749-08d981aba4d9
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 11:40:45.7038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TbMXBEB2/R11OqD/6RVPa41hIUkSXk2hAoG9sWijdmcIcHagbqCVrSYd7dTE+KBsyS+KY5HaADEuTXHZSc77Tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8345
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds initial KVM RISC-V support. Currently, we are able to boot
Linux on RV64/RV32 Guest with multiple VCPUs.

Key aspects of KVM RISC-V added by this series are:
1. No RISC-V specific KVM IOCTL
2. Loadable KVM RISC-V module supported
3. Minimal possible KVM world-switch which touches only GPRs and few CSRs
4. Both RV64 and RV32 host supported
5. Full Guest/VM switch is done via vcpu_get/vcpu_put infrastructure
6. KVM ONE_REG interface for VCPU register access from user-space
7. PLIC emulation is done in user-space
8. Timer and IPI emuation is done in-kernel
9. Both Sv39x4 and Sv48x4 supported for RV64 host
10. MMU notifiers supported
11. Generic dirtylog supported
12. FP lazy save/restore supported
13. SBI v0.1 emulation for KVM Guest available
14. Forward unhandled SBI calls to KVM userspace
15. Hugepage support for Guest/VM
16. IOEVENTFD support for Vhost

Here's a brief TODO list which we will work upon after this series:
1. KVM unit test support
2. KVM selftest support
3. SBI v0.3 emulation in-kernel
4. In-kernel PMU virtualization 
5. In-kernel AIA irqchip support
6. Nested virtualizaiton
7. ..... and more .....

This series can be found in riscv_kvm_v20 branch at:
https//github.com/avpatel/linux.git

Our work-in-progress KVMTOOL RISC-V port can be found in riscv_v9 branch
at: https//github.com/avpatel/kvmtool.git

The QEMU RISC-V hypervisor emulation is done by Alistair and is available
in master branch at: https://git.qemu.org/git/qemu.git

To play around with KVM RISC-V, refer KVM RISC-V wiki at:
https://github.com/kvm-riscv/howto/wiki
https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-QEMU
https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-Spike

Changes since v19:
 - Rebased on Linux-5.15-rc3
 - Converted kvm_err() to kvm_debug() in kvm_set_spte_gfn() function
   added by PATCH11

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

 Documentation/virt/kvm/api.rst          | 193 ++++-
 MAINTAINERS                             |  12 +
 arch/riscv/Kconfig                      |   1 +
 arch/riscv/Makefile                     |   1 +
 arch/riscv/include/asm/csr.h            |  87 +++
 arch/riscv/include/asm/kvm_host.h       | 266 +++++++
 arch/riscv/include/asm/kvm_types.h      |   7 +
 arch/riscv/include/asm/kvm_vcpu_timer.h |  44 ++
 arch/riscv/include/uapi/asm/kvm.h       | 128 +++
 arch/riscv/kernel/asm-offsets.c         | 156 ++++
 arch/riscv/kvm/Kconfig                  |  36 +
 arch/riscv/kvm/Makefile                 |  25 +
 arch/riscv/kvm/main.c                   | 118 +++
 arch/riscv/kvm/mmu.c                    | 802 +++++++++++++++++++
 arch/riscv/kvm/tlb.S                    |  74 ++
 arch/riscv/kvm/vcpu.c                   | 997 ++++++++++++++++++++++++
 arch/riscv/kvm/vcpu_exit.c              | 701 +++++++++++++++++
 arch/riscv/kvm/vcpu_sbi.c               | 185 +++++
 arch/riscv/kvm/vcpu_switch.S            | 400 ++++++++++
 arch/riscv/kvm/vcpu_timer.c             | 225 ++++++
 arch/riscv/kvm/vm.c                     |  97 +++
 arch/riscv/kvm/vmid.c                   | 120 +++
 drivers/clocksource/timer-riscv.c       |   9 +
 include/clocksource/timer-riscv.h       |  16 +
 include/uapi/linux/kvm.h                |   8 +
 25 files changed, 4699 insertions(+), 9 deletions(-)
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

