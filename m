Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785542F789F
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbhAOMU0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:20:26 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:38938 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbhAOMUZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 07:20:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610713223; x=1642249223;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=HjHYj/CfkWaO17JqLvpm9Iqvbr2hzJ+ymedApuQUNNc=;
  b=hVHA9HbkGPrMRoy65FOjqJe1wXPxE2eAV8q0f8CJsx0SF0YktFViR9GF
   36dOsZjt8z+txFWKdxkvPYGL8oiiO9oAFpMr4BIOm4nrFKFCEH/KQgToa
   TtiN0qUfw8gJJj0FK6UJ6KHVnum6ANACxobUPfySovEHx/+U5pR70turs
   vYoLB2uzG27mVNO+UL5UqHOTbpJxIWSiWCSTAI7fo2DF8I0k0Yf6UuIF1
   S8uoQsDPew95RAO1Fylpd7cCrhTxMWKZVddaf9ODxZQhRu/qP9qnOvkm0
   u8G/LzD9cXtd6b1fs3uyK5WHlltnnkp0S8OzOQQfRXEd0qVxXJ+VSoyGQ
   Q==;
IronPort-SDR: /XyA3GEDkMTOt5D+KzVKwuPg+om8Amcc28PrUVJsbMrLxW5/bZrNeq9VJ1i4v58srICFC8YyFN
 yn8ugU6x+3y0inFKDDu77loaJIYB+ZBRzW5pv9QdYi0/rKJ42WRsmweIPPH8lfdKE27FZ3n13W
 Qx5hXf8q+wclh0VaouLIvQnzMrL+AGn8/biNokRZMDy8kqUIfWk5xSCQfOeiEksuu0h+H9Y+s5
 5DrPDQnguw2mLCVnm411GKFbLKMZHHvpdO/E4r9w6Pvr2Wg6r2rGEkd1OFksn90VqlrrV5axni
 QPs=
X-IronPort-AV: E=Sophos;i="5.79,349,1602518400"; 
   d="scan'208";a="157514079"
Received: from mail-bl2nam02lp2059.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.59])
  by ob1.hgst.iphmx.com with ESMTP; 15 Jan 2021 20:19:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k+56vsZudHwVg6XEIvDOnq4Hxvvo8121wFgBUbGdTpE5Jn3kIhCB6aMaK1t2ndDznjd99DmBbUvQZqffJ0MJpYRYQ3EWK/6Zq5yfcKGDtz8rTPZNr3yJPpldfWFWKDTSSNK3G5VzYZFBMo0VqxFeu+s9NB1ztixXdGUfO7rR24KydBZZOJLeK2fbhF/UFGXUvi2lNuakwMaGRDltV38m3qjRbtBxlz2sMp+N/uwr74kBJuglE4TyQgw4SRT6jlJycdrYi/roY+pf8ntVA6Ky/TNnJloXeK92yiFgz6ddmo6PLugI2XnB5wLbVtyCu+/ckQfOQ5zV2ts+Kd72D2K9cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WIxsMC+QcX1LOJwShuzcQ7uhebKVAfzVAKr7gO2Y6no=;
 b=KLZbENrJBrIjsqDjV7n3kXjB0WawFfbZgdn/y/rlRamS56qAMizm1VgjiGoePjo+Zygq5XHDO67rwd7MQ4kXVwU2wsQ+CmHaRml1meTyixE1FzdSqlEcw24EtJqoFk5GR581rviQkiMi/UUZUtWZcChZgiJDnpsqWsY/hO/pxxfkK460Kb9PBxUXVpKFDrsef4DlMxi5MqV9OwK8JG7EM2wg1VOJwN0FeDIQMs5F24WNnkmioIMnZ/V6/+Pab5PzJNg/khDySrxANYYmaHl7SN+0ClHdFH55UM1O5zOOehSAN//Z7mIzo892y79gWWmt2SgydszATiZvN0IMXsJNdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WIxsMC+QcX1LOJwShuzcQ7uhebKVAfzVAKr7gO2Y6no=;
 b=gz7IbC04bdrfbTKRp39gRoyIZQzpyY2kR+1Fj6WEtDC2qGG4CpVC6cA4EdQm3X2x5JJoCEhvVx05a10yAWzgpxKiHaW/8djgYmH6WtbAGASyyhV36jHgz4qNSeP6N4+16bX3PqZ5laJx0zTkPuLF0QWFinywm2NaXdK1YLy4EBc=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM5PR04MB3769.namprd04.prod.outlook.com (2603:10b6:3:fc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Fri, 15 Jan
 2021 12:19:14 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97%5]) with mapi id 15.20.3742.012; Fri, 15 Jan 2021
 12:19:14 +0000
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
Subject: [PATCH v16 00/17] KVM RISC-V Support
Date:   Fri, 15 Jan 2021 17:48:29 +0530
Message-Id: <20210115121846.114528-1-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.167.152.18]
X-ClientProxiedBy: MAXPR0101CA0024.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::34) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.167.152.18) by MAXPR0101CA0024.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Fri, 15 Jan 2021 12:19:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5515c33b-2d33-48af-2cc8-08d8b94fc5cb
X-MS-TrafficTypeDiagnostic: DM5PR04MB3769:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR04MB376961C27076E771238CF9AF8DA70@DM5PR04MB3769.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:79;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /5YPMhCE4/2CKXqB2VTDRvwMht2mh1DiUVPW8TtFozzUugA6H6ufFwexwwJ/xiyxHpE9+3y2OBttW2I+fiDFWAPE/Aqu7X3shXXCF6ZQ2Tg9OMjizQuiGHtzAuHnlilIymdrFi2Jd3dIIHozIqVAYAUv332zmLqen9zaE63O+VJPwBi7SvSGFOSKRivHcfppBSF1zxwdn9MIvjFkBhse0PbxZmuHXyF8AsTVwsHezf05EsRP9TeRk++xjkGybG8QHRZaQqMryOkow0fN3DvwI071DogIqYEo78cAd8PXgOMmE+wX7yprvWsFsnNku3eE5L26Rc8fJsFam5VUJI5QzFuj9PP0gVuPoirIY4Rgw0muJIgDb8sYtB0hPTR0WLLdWo4rU7K+N5xIiy1cSxnasVS/qA0jeWBOeah0BaNU1embj1V2w+uydasnk6CN+rv1zKg3p99AFhA4NMXYGURDXSSoZTAaNvcs1mz+k8dj0NiRUsu2Vn4pYFAm6l7ukxFAlnspbzFEQJ6+pFuD8znaLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(366004)(376002)(396003)(66476007)(6666004)(55016002)(7696005)(54906003)(66946007)(110136005)(956004)(5660300002)(2616005)(186003)(52116002)(44832011)(478600001)(66556008)(8936002)(26005)(86362001)(2906002)(83380400001)(966005)(7416002)(30864003)(16526019)(8676002)(316002)(4326008)(36756003)(8886007)(1076003)(42580500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?aHDKcv9JeDh/0OjKEGm7JDLCIdZHg8Iv/DbdRTumGiamYZQHGVx9TFdxaWaT?=
 =?us-ascii?Q?yaD2oUq8r0DTk1wGmuGT5ENJlQGHXEyKlwcRf/tZK+JyH9xKQmh1xLSlWsaP?=
 =?us-ascii?Q?k1FORXcG8M5ITHcFf9+ImaXPmh5GCflGrb0xSVEcw+WP9NpRAruf8u5lUd+v?=
 =?us-ascii?Q?GGiBZri6yGV9Euxw6i3Eh7r0f8G3MWC8GMlVChC/dS9T08pyK/MsSJTWoVIm?=
 =?us-ascii?Q?zD4yhCQaGs65802RjMEGPnCaxPHN6KXXiCjvTNA3Hgxyv1T7qcLXD7vPM7jH?=
 =?us-ascii?Q?dwlp+CON1c/32P/Utem3xWekSeEElHLCF9/y6M1efirmCRsoRPH7OqQMoOXt?=
 =?us-ascii?Q?bOSVW9n9BVtYPco6uJbRq9p557x0w3FpHw0hPuGnDgjq18PqsldDWfC7U5s6?=
 =?us-ascii?Q?3J18oTBSg73K/jkBIwPRO1if0t2bBreVgqYrhA6BX2ZOo4R/6EANVl7U9DQO?=
 =?us-ascii?Q?qgubp3/vEmdVsMAmPDz450wSWrTnL3+7nRGXcgdjRLcVD/vg5bYNPLUM2olh?=
 =?us-ascii?Q?ZMMjEqX/dMj7kIQOzw5AaNNMoUNP7mU1kCgDyZ9YuWD95Ipl4FRLObilqS0u?=
 =?us-ascii?Q?Bu62qZy4y96GWzxju08ynbYhNbMkswoOa335mRn0RUvJS83OB3Psr1WhQJoF?=
 =?us-ascii?Q?gytHXMHJnnDDl5V7qtJZbr78QmZvjbZbGz/ojTkCLGl2VZec8b6pGLMjlZ7x?=
 =?us-ascii?Q?JiApyKbKu64bid1S5+09zfzKK1j7Nu4yZyZQFdUy+QiZeVMu7//wVUpUiZz0?=
 =?us-ascii?Q?klG/yHOMxoxFuJ/B6i0OGiawu4BwjfOuzouMZl4ZvWldayhZZoc+yDLvZEtB?=
 =?us-ascii?Q?vmaG2Gaw5g220sz3jBIcMti0DMZmmT+E4g+Eq9Bh4wV6TRzoiDOydrZEA3pC?=
 =?us-ascii?Q?5EiWiknywkwJSntMPo2HInvI4YaqOSCzLTDZsfSilAf83Dv2IwmNXHB9fh21?=
 =?us-ascii?Q?ByQUt2pwNf0Wky25FwliMlk2evFJNaKWbvE89TZhM3wytBHmgCkJHanl1fMK?=
 =?us-ascii?Q?w6vJ?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5515c33b-2d33-48af-2cc8-08d8b94fc5cb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 12:19:14.7205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TrtqYvltyH+AVakmOzWBYG4RQ1/PDEo/cwqfI9/TtO6Syg0tgzbZreLhAqj8y33TMXfaRtG67oVtRecLC6aleg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB3769
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

This series can be found in riscv_kvm_v16 branch at:
https//github.com/avpatel/linux.git

Our work-in-progress KVMTOOL RISC-V port can be found in riscv_v6 branch
at: https//github.com/avpatel/kvmtool.git

The QEMU RISC-V hypervisor emulation is done by Alistair and is available
in master branch at: https://git.qemu.org/git/qemu.git

To play around with KVM RISC-V, refer KVM RISC-V wiki at:
https://github.com/kvm-riscv/howto/wiki
https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-QEMU
https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-Spike

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
 MAINTAINERS                             |   11 +
 arch/riscv/Kconfig                      |    1 +
 arch/riscv/Makefile                     |    2 +
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
 arch/riscv/kvm/mmu.c                    |  860 +++++++++++++++++++
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
 26 files changed, 4748 insertions(+), 9 deletions(-)
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

