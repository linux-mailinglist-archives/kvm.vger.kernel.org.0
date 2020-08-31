Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD4B257932
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 14:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgHaM0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 08:26:40 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:54712 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726927AbgHaM0Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 08:26:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1598876777; x=1630412777;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=/l6V7IghWq9bV8DqtloXg0w7ww8jZzp9oowLpnw3pKk=;
  b=RW1+bdPJR4MueFuNYfIylTJjA+etzQMzrvZRopmMNUghWOK+fjeB+NwK
   ruzB7zvEVXz84Wel7TweeUVXWgXRkM1AYSQBFRIlqR0l1ky02OdaEV35u
   CmvfXG4oydWH7FhgtwQ2NnzUyDsuzHQisfBzZN23P7OlwNxw5QZaYYK7Z
   dBmtxcfF7Y4rJ/Z9o2tyJ6CJIvRBkRUMXA0fxTZxqihehF0SpWNY5Yfbi
   e70QwFp645yCQMwqFXeaL3/uqoDjBgSRORAG3K0urNQZCup/NTnhXv7An
   BWB8bDGqar6VVM+w+r1JMSAPndjFdquKnAvGH76cjLsr6QFh2jzPJoxlI
   A==;
IronPort-SDR: T/BYtcTyw7UwH6KiYl71Na+BtnCAPp4G+QwwQYR1Ke0PXrLsRGcVoWZtYgutAGeidjpUUE5DFU
 OfbJMjiSlsbGjsenvDOYEHphjyrUWpxnV45WCyx7i9rhpg1FqBUl0S9KyTvdiILD1rtvyuDITW
 81mjUb7wkFr2Q8u6xWwlboCXpfj9W+LRDJeUA6cY7L7xxGoUX7Hm20CXLfKVhCzZ/qKT3dr3Hc
 Ihubj90SwqQJTd17orDG+uKQLK4EOMcA63ZuuJHg6caMKJ+VlWDhXSPqrStkXe2uHzDN0vwZ92
 GuE=
X-IronPort-AV: E=Sophos;i="5.76,375,1592841600"; 
   d="scan'208";a="146216472"
Received: from mail-mw2nam10lp2109.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.109])
  by ob1.hgst.iphmx.com with ESMTP; 31 Aug 2020 20:26:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JTJXEKu0+7UyziP0Mz1Ib8oQvjOM+a/vIywjOYz8mlBdN69Vk6ZhQFYu2eYSBfBNzD0XWe4kYXeMyeWyvcDA+In9bgdIbh61dYrq8W3nuNjf+8usqWNDH8MgIWqMXEwUQswoLQfyc25+MtI4U/c9l917VCVgrp1nFBRs2EqUCQG8U1MOM24dj7C5Qoaj3eSypsPoj65mgWdtugOYQhfij2M8j43AxitU4sCX7krSULhbpasc1xNfsiI//SQenBA9YjPs1LsRnioL4xeRusq2zysAaXtbg2FIj2rXVnmD75DFqV+A5rVw272mnxJCKOE2YkjQbtkSo5CC4gU8KYK+KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4cvoeOZthn19X0Ny1hOZClSG0+XGKoTvF5rCPHacwqc=;
 b=g4WOGdXWK/nuaRzlRZCh7Sx8Br7cndC9R+rAOtgIsmfqyGXkAnIYrsh270bsqMcNYsKAMl8LJ+WQDntsV0cXgzB5toeoOi9opSukdNiki1ajeu9OqIcYqUpaKp1lTfO2IPScvz5q/q69J2SB781e8fhLoy18B51T0a3ShIilql4KauOyRjwwt8pWfF9yrBN1BdB5eVdYZTfNI6EX69WgyIiG8Ew/L8CU3oidQMbt1HNhhj5SrevitRbVrN2ddcKMKCpE6JFpQJqCOPNvv6NqPDejSOybr1cZ1KwSYf6ZUOFtDnCzysMXIUs6/Hr0ueus09MK474St8uMXwhCW8an4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4cvoeOZthn19X0Ny1hOZClSG0+XGKoTvF5rCPHacwqc=;
 b=DZkOHfBCT1O2k9Q/tGptJ89lrdHcjbItvu9J6QrEOFE85DEItnTzBXvxwSZcAphbT6a33ZKEYKwlOkGji9f1UW71xxLlqsEipgHoLATbxnjOfIN6j9EDq7LmEoridXZDbz65ClBiDNuJnrVsgvzbV0lqT2uNZ3yj1fKUx7mAk70=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB5386.namprd04.prod.outlook.com (2603:10b6:5:106::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.24; Mon, 31 Aug
 2020 12:26:13 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::607a:44ed:1477:83e]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::607a:44ed:1477:83e%7]) with mapi id 15.20.3326.025; Mon, 31 Aug 2020
 12:26:13 +0000
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
Subject: [PATCH v14 00/18] KVM RISC-V Support
Date:   Mon, 31 Aug 2020 17:55:20 +0530
Message-Id: <20200831122538.335889-1-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BM1PR0101CA0038.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:1a::24) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BM1PR0101CA0038.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:1a::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Mon, 31 Aug 2020 12:26:08 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [103.15.57.192]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 58df00fc-5e4e-474d-e0f4-08d84da90c8a
X-MS-TrafficTypeDiagnostic: DM6PR04MB5386:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB5386C2211F5E38AA4A860AB18D510@DM6PR04MB5386.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:79;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5bSVl7Y/7vEKaVuVHzDElOCWLcwKq6D7IH4fMfFL/g8gen+QxJNyv6VOBXPE8iUBLDV+zNMmamJzmhN9c868dn2eMS+UzV6Of5aLwiY7HfJvJCq+Uug8RA3le5d/8+d1At/IF85rFA2KUkZjxjO1brj+mz3Si/WSXb4pGDnF6cjjeHvLkNKpEM64lN4LLIWr3k4a+Um278agk1yYp1zc14iMl+JGbqvjDUwgs7DCFobLcHEY0oEE1D5Ok6UxtnPC23ERPGyXR9nnwtyIN1JOvqLUSM7q5hZKcFBPsfqHOvjPH4H8zgiTh4kLg6UtkL9YdlDHXa3e78MbonMCrcUmGh8DRsRDnXdvgjQvrRh3v8C5ifS0JKm7bh74yhjESN9Ml10nvq4f+oFiCjiOH7toiMcAG9KYx2lL8HAEbeYwjZyhtKjhUXzUau8twWyiL32h+t+GlAp/g4gTJMrrUf5wdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(30864003)(6486002)(478600001)(966005)(110136005)(54906003)(66556008)(83380400001)(66476007)(5660300002)(6666004)(16576012)(316002)(186003)(66946007)(26005)(2906002)(44832011)(8936002)(4326008)(36756003)(956004)(2616005)(52116002)(1076003)(8676002)(86362001)(7416002)(42580500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: pEnVRgDbbzR6FHZoGv6F/ah1cq+9EVfcXtQfjXbyBS8Y3/uD7c7ZDVe3kdiBLaAI+krIx+8QxO1PJkTzmCQ577GPrIthwKo5v2o3+e+07Os2CVm7UnBcMqfhO7oIsDqwpnzzw6DMQbupy+n5GkcvWqPsoKhwEqrBFvkWep8LXDHyew6jfsLElSd5ljfMxRbz5ZZgtErxtBs7F4+4B1WXxg8C22ww6qz485dLZjGTE82ta6H2+dwkfMNrTHjik9t3nCdSIDD+MgeV1aWKb2gzHaVhZcvp2zNt3cVALY0nIfOxQN0VXeEv8vhbsViAi6kI7PLAUoJtV0pr/2Oy6C27cBBiUxsBZfVVxsYFGe9Ax7REzmxuV8SsXJ7U8n8FQ3vmudVJKX12rnsAWoJIk0fRx/XCoQuHnnohayt00ahLGDnFpm5iEuTPsiGSXqBrbkvu7B9L3wLTk7ECGGrERZ+bulfA+jI0cHYDwlF18+IxLIk3n3fy7L1F4nnfc0Uwv1HPkD0mVy1G+Bc8ybekoK4O1fIQJTOCwPF95TZfKQVDnrPAnl+ZhmHPkYpjk339mCu9VPQweOK3Kf/lu8FWPPSbUfSmk+WIrUYFCxd08yGEiOLmJ7eYWcBflExZAC/oB6rnEsvvkrA+RfOcdtGdY1bSCw==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58df00fc-5e4e-474d-e0f4-08d84da90c8a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2020 12:26:13.2612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZrI68Vx7dl5TBqg/ZxeJsA8Akp/wRBqJVKNnm+NIoSUftnuNlZMbbLDtYotcx+ifA8xYiMCtOB+3/UUFmu7qqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5386
Sender: kvm-owner@vger.kernel.org
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

This series can be found in riscv_kvm_v14 branch at:
https//github.com/avpatel/linux.git

Our work-in-progress KVMTOOL RISC-V port can be found in riscv_v4 branch
at: https//github.com/avpatel/kvmtool.git

The QEMU RISC-V hypervisor emulation is done by Alistair and is available
in mainline/anup/riscv-hyp-ext-v0.6.1 branch at:
https://github.com/kvm-riscv/qemu.git

To play around with KVM RISC-V, refer KVM RISC-V wiki at:
https://github.com/kvm-riscv/howto/wiki
https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-QEMU
https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-Spike

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

Anup Patel (14):
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
  RISC-V: Enable KVM for RV64 and RV32

Atish Patra (4):
  RISC-V: KVM: Add timer functionality
  RISC-V: KVM: FP lazy save/restore
  RISC-V: KVM: Implement ONE REG interface for FP registers
  RISC-V: KVM: Add SBI v0.1 support

 Documentation/virt/kvm/api.rst          |  193 ++++-
 MAINTAINERS                             |   11 +
 arch/riscv/Kconfig                      |    2 +
 arch/riscv/Makefile                     |    2 +
 arch/riscv/configs/defconfig            |    3 +
 arch/riscv/configs/rv32_defconfig       |    3 +
 arch/riscv/include/asm/csr.h            |   89 ++
 arch/riscv/include/asm/kvm_host.h       |  278 +++++++
 arch/riscv/include/asm/kvm_types.h      |    7 +
 arch/riscv/include/asm/kvm_vcpu_timer.h |   44 +
 arch/riscv/include/asm/pgtable-bits.h   |    1 +
 arch/riscv/include/uapi/asm/kvm.h       |  128 +++
 arch/riscv/kernel/asm-offsets.c         |  156 ++++
 arch/riscv/kvm/Kconfig                  |   36 +
 arch/riscv/kvm/Makefile                 |   15 +
 arch/riscv/kvm/main.c                   |  118 +++
 arch/riscv/kvm/mmu.c                    |  857 +++++++++++++++++++
 arch/riscv/kvm/tlb.S                    |   74 ++
 arch/riscv/kvm/vcpu.c                   | 1012 +++++++++++++++++++++++
 arch/riscv/kvm/vcpu_exit.c              |  701 ++++++++++++++++
 arch/riscv/kvm/vcpu_sbi.c               |  173 ++++
 arch/riscv/kvm/vcpu_switch.S            |  400 +++++++++
 arch/riscv/kvm/vcpu_timer.c             |  225 +++++
 arch/riscv/kvm/vm.c                     |   81 ++
 arch/riscv/kvm/vmid.c                   |  120 +++
 drivers/clocksource/timer-riscv.c       |    8 +
 include/clocksource/timer-riscv.h       |   16 +
 include/uapi/linux/kvm.h                |    8 +
 28 files changed, 4752 insertions(+), 9 deletions(-)
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

