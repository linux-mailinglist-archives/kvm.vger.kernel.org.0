Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 069D119D136
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 09:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389688AbgDCH1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 03:27:47 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:17454 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389010AbgDCH1r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Apr 2020 03:27:47 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0337K2HT030821;
        Fri, 3 Apr 2020 00:27:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=gj76iXxm8OOFF6yiGeQRXfI+FLtlMRI2bcldDEIJbJM=;
 b=OO6pBT6B/ZiUa2ykXHEthoafgKgEqFpzc04MWGFSiCiN5ErSoXhl6QfvtpLvowB8hZqi
 54lOjaaU//ithHzvaWitwygrTuyLE7B668ZdN9DnIQtzmRJcN00V2BInclHGq03ncy5F
 46LtW3ze+LrkecxcAe+hXhhj3ni89dOurtpcE4UyBunk1dJhA4+89lnPX/sSIIhj0Tpg
 23Vymco9rsxx0KPUAOpi4NXFYNIUnzJ52y1M84chH1sIYaMAuH+8ezeiuMcB/f8B/TkR
 PDZ45wwCqvyst9ryXnYEC20zS0LYGuol8AXOhfNPFQtkn2iUz5ni1TwSKcXNZg2InLzx Ww== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 304855wk7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 03 Apr 2020 00:27:24 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 3 Apr
 2020 00:27:22 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 3 Apr 2020 00:27:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FM7Hn7ag4dNSROY654bhKcoaD8auvqQcK7vWjv5HwppWROJPuUSi10/NNL1efKrqqNEl7kN8G5sSyVH1DEfMkA2h35fxcnoUOmQ0Ln7nrgXte/ElPrH0qEG5Z4C2++o67UGJ6qvlopCiREAiG8qwdjI4oU8swu+J2+T42O3fDS9Am13sQiuduyJnwWmk+jqJU2XyGwaOsPdtntskbIj9Jsm6hhtgqf7VmFXkjz45XF3t2FBhWbeaFCoBsqh9unnD8rpyXYw4zMycqYzrnRBhGXCu7Mn9yd3ApqLyk7W1YXvbbJgepM9ps935Uyuzo7iL/zfnqzi/UvAlKYMqDB20vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gj76iXxm8OOFF6yiGeQRXfI+FLtlMRI2bcldDEIJbJM=;
 b=DBLAGPNYoMFgPg91Kxmf5h+5qS+zt/1zsA56AYxvnKAUzYb6a4L3HxsXbhzKcnhfbji8NP8Uk4CofPTOXv61znKCRw3IyZn6+CLgZXFW+INCscBG/oTvwT8VUureDs3YsAMksHiQOd52osgI3KBirmyjvXAavP4HC8T4eSNMzqopdDJZxQoLZjUlm4QUNPn8HU2qNPKHLtJy0Ljj5PhwvXTSy1uoxFCnOvydf/yjFOvKCfVf+JC6BwG19KhDRRZ/d7eebfel5ANRJxYTDqAsh1PWdyQQD9+cz5tPfZgOtQEBEFLKh/Egoz0XNw8GGBJiJtibzb4stCK4d8VdC0c2pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gj76iXxm8OOFF6yiGeQRXfI+FLtlMRI2bcldDEIJbJM=;
 b=UlpqLUZibDokJxxzayek7jQe7QQyhBQ8OjuZzM6tvJDYknzx/vzZuZaBO3GeW48zTSr+Y664MqdpN0rzUY2oJG6r/VAEq2vp3V7Ri9LQDXFyA2ESnaj4n+DMbagzwgyQLZaCzy7We7byMzb92ArVj2qQsOvyE30xIxaSM/wjs1Q=
Received: from MN2PR18MB2686.namprd18.prod.outlook.com (2603:10b6:208:ad::30)
 by MN2PR18MB3103.namprd18.prod.outlook.com (2603:10b6:208:169::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.19; Fri, 3 Apr
 2020 07:27:21 +0000
Received: from MN2PR18MB2686.namprd18.prod.outlook.com
 ([fe80::f9b3:90dc:bbf:4ebc]) by MN2PR18MB2686.namprd18.prod.outlook.com
 ([fe80::f9b3:90dc:bbf:4ebc%3]) with mapi id 15.20.2878.018; Fri, 3 Apr 2020
 07:27:21 +0000
From:   George Cherian <gcherian@marvell.com>
To:     "maz@kernel.org" <maz@kernel.org>
CC:     "Dave.Martin@arm.com" <Dave.Martin@arm.com>,
        "alexandru.elisei@arm.com" <alexandru.elisei@arm.com>,
        "andre.przywara@arm.com" <andre.przywara@arm.com>,
        "christoffer.dall@arm.com" <christoffer.dall@arm.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "jintack@cs.columbia.edu" <jintack@cs.columbia.edu>,
        "julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        Anil Kumar Reddy H <areddy3@marvell.com>,
        Ganapatrao Kulkarni <gkulkarni@marvell.com>,
        George Cherian <gcherian@marvell.com>
Subject: Re: [PATCH v2 00/94] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
Thread-Topic: Re: [PATCH v2 00/94] KVM: arm64: ARMv8.3/8.4 Nested
 Virtualization support
Thread-Index: AdYJhvrCKEKaxySRQua1lfr4U9NN2g==
Date:   Fri, 3 Apr 2020 07:27:21 +0000
Message-ID: <MN2PR18MB26869A6CA4E67558324F655CC5C70@MN2PR18MB2686.namprd18.prod.outlook.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [49.207.55.211]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 941a9fea-da64-41fb-d89d-08d7d7a072af
x-ms-traffictypediagnostic: MN2PR18MB3103:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB310388849AFE980FAA17FA0BC5C70@MN2PR18MB3103.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0362BF9FDB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR18MB2686.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(346002)(136003)(376002)(39860400002)(396003)(966005)(53546011)(6506007)(52536014)(55236004)(66946007)(54906003)(478600001)(6916009)(86362001)(2906002)(7696005)(7416002)(66476007)(66556008)(64756008)(66446008)(316002)(76116006)(107886003)(55016002)(26005)(81166006)(5660300002)(4326008)(9686003)(71200400001)(186003)(8936002)(33656002)(8676002)(81156014)(30864003);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cd9r+X9ykwQ8LIbtnvA8VgURN/J/gZNLPTt3cSaL1QNTJWTm80DGwLelE+4GaO6P187fp8XV1hDWErKSnVCPKTui/iQPa1NQ1xs+mxtafJt8if9M7oxld+y+KqoaP363xE6JWF/HqKmHEJv1Z5WMLuDf3+874taQzdX9cftyHCSeYkztntPS/wnSrm5OUF9NJXBTWMhgkjLvDKK8FY1fxmNZQmAsnS0cAannXjdqev5zfBFY64o9wyWl40sgbz2zilbHXBesx6OtDUiXUMRjlZkyPL/6J+n1h25VNqEhX0vrKL+PboOgeeeVZFwrIEgwiPJJ88HuODiOCv/GqSci7yvRlKoFssB4/O4XoYzY892RgayTL9OIT0fcQsmqyadxKRu0X3XyNWd4WzAPq9WtxLoDw6vtqwldFrXhV1DrCQaoLjXgJ1Y3Y72aihxzBH4NIf01PFSLyyVvJiPawOK3IOfyOirOTYdfvTkiPz6HgarBkyJQfz/ZpaT4Duo2mSpkzKHG9cuBYzel0tR0coQ+wg==
x-ms-exchange-antispam-messagedata: BVbZwjT8Kk7omJGca4LwnlwfYIyh1zXjAzrViAIJpVJ5bJmV0wNiXnZCao3y6NSPKbitIDIYxqWXEhE59NJCSf1Dzg/a/eM1nGCXFumv039XZU+Fx+i93HKsBMv7YGiLozfXWGTPN0wwadkLDSKtWw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 941a9fea-da64-41fb-d89d-08d7d7a072af
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2020 07:27:21.3261
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iEUR1DMiO2KmMX5yWIzPqGR2RbYaN0X0ytORD7zGD8KMAGexETLHvzJc6Np5UIIS2pMAOaGtZuwHUuCAqzmS3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3103
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-03_05:2020-04-02,2020-04-03 signatures=0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2/11/20 9:48 AM, Marc Zyngier wrote:
> This is a major rework of the NV series that I posted over 6 months
> ago[1], and a lot has changed since then:
>
> - Early ARMv8.4-NV support
> - ARMv8.4-TTL support in host and guest
> - ARMv8.5-GTG support in host and guest
> - Lots of comments addressed after the review
> - Rebased on v5.6-rc1
> - Way too many patches
>
> In my defence, the whole of the NV code is still smaller that the
> 32bit KVM/arm code I'm about to remove, so I feel less bad inflicting
> this on everyone! ;-)
>
> >From a functionality perspective, you can expect a L2 guest to work,
> but don't even think of L3, as we only partially emulate the
> ARMv8.{3,4}-NV extensions themselves. Same thing for vgic, debug, PMU,
> as well as anything that would require a Stage-1 PTW. What we want to
> achieve is that with NV disabled, there is no performance overhead and
> no regression.
>
> The series is roughly divided in 5 parts: exception handling, memory
> virtualization, interrupts and timers for ARMv8.3, followed by the
> ARMv8.4 support. There are of course some dependencies, but you'll
> hopefully get the gist of it.
>
> For the most courageous of you, I've put out a branch[2]. Of course,
> you'll need some userspace. Andre maintains a hacked version of
> kvmtool[3] that takes a --nested option, allowing the guest to be
> started at EL2. You can run the whole stack in the Foundation
> model. Don't be in a hurry ;-).
>
The full series was tested on both Foundation model as well as Marvell Thun=
derX3
Emulation Platform.
Basic boot testing done for Guest Hypervisor and Guest Guest.

Tested-by:  George Cherian <george.cherian@marvell.com>

> [1] https://lore.kernel.org/r/20190621093843.220980-1-marc.zyngier@arm.co=
m
> [2] git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git k=
vm-arm64/nv-5.6-rc1
> [3] git://linux-arm.org/kvmtool.git nv/nv-wip-5.2-rc5
>
> Andre Przywara (3):
>   KVM: arm64: nv: Save/Restore vEL2 sysregs
>   KVM: arm64: nv: Handle traps for timer _EL02 and _EL2 sysregs
>     accessors
>   KVM: arm64: nv: vgic: Allow userland to set VGIC maintenance IRQ
>
> Christoffer Dall (17):
>   KVM: arm64: nv: Introduce nested virtualization VCPU feature
>   KVM: arm64: nv: Reset VCPU to EL2 registers if VCPU nested virt is set
>   KVM: arm64: nv: Allow userspace to set PSR_MODE_EL2x
>   KVM: arm64: nv: Add nested virt VCPU primitives for vEL2 VCPU state
>   KVM: arm64: nv: Handle trapped ERET from virtual EL2
>   KVM: arm64: nv: Emulate PSTATE.M for a guest hypervisor
>   KVM: arm64: nv: Trap EL1 VM register accesses in virtual EL2
>   KVM: arm64: nv: Only toggle cache for virtual EL2 when SCTLR_EL2
>     changes
>   KVM: arm/arm64: nv: Factor out stage 2 page table data from struct kvm
>   KVM: arm64: nv: Implement nested Stage-2 page table walk logic
>   KVM: arm64: nv: Handle shadow stage 2 page faults
>   KVM: arm64: nv: Unmap/flush shadow stage 2 page tables
>   KVM: arm64: nv: arch_timer: Support hyp timer emulation
>   KVM: arm64: nv: vgic-v3: Take cpu_if pointer directly instead of vcpu
>   KVM: arm64: nv: vgic: Emulate the HW bit in software
>   KVM: arm64: nv: Add nested GICv3 tracepoints
>   KVM: arm64: nv: Sync nested timer state with ARMv8.4
>
> Jintack Lim (19):
>   arm64: Add ARM64_HAS_NESTED_VIRT cpufeature
>   KVM: arm64: nv: Add EL2 system registers to vcpu context
>   KVM: arm64: nv: Support virtual EL2 exceptions
>   KVM: arm64: nv: Inject HVC exceptions to the virtual EL2
>   KVM: arm64: nv: Trap SPSR_EL1, ELR_EL1 and VBAR_EL1 from virtual EL2
>   KVM: arm64: nv: Trap CPACR_EL1 access in virtual EL2
>   KVM: arm64: nv: Handle PSCI call via smc from the guest
>   KVM: arm64: nv: Respect virtual HCR_EL2.TWX setting
>   KVM: arm64: nv: Respect virtual CPTR_EL2.{TFP,FPEN} settings
>   KVM: arm64: nv: Respect the virtual HCR_EL2.NV bit setting
>   KVM: arm64: nv: Respect virtual HCR_EL2.TVM and TRVM settings
>   KVM: arm64: nv: Respect the virtual HCR_EL2.NV1 bit setting
>   KVM: arm64: nv: Emulate EL12 register accesses from the virtual EL2
>   KVM: arm64: nv: Configure HCR_EL2 for nested virtualization
>   KVM: arm64: nv: Introduce sys_reg_desc.forward_trap
>   KVM: arm64: nv: Set a handler for the system instruction traps
>   KVM: arm64: nv: Trap and emulate AT instructions from virtual EL2
>   KVM: arm64: nv: Trap and emulate TLBI instructions from virtual EL2
>   KVM: arm64: nv: Nested GICv3 Support
>
> Marc Zyngier (55):
>   KVM: arm64: Move __load_guest_stage2 to kvm_mmu.h
>   KVM: arm64: nv: Reset VMPIDR_EL2 and VPIDR_EL2 to sane values
>   KVM: arm64: nv: Add EL2->EL1 translation helpers
>   KVM: arm64: nv: Refactor vcpu_{read,write}_sys_reg
>   KVM: arm64: nv: Handle virtual EL2 registers in
>     vcpu_read/write_sys_reg()
>   KVM: arm64: nv: Handle SPSR_EL2 specially
>   KVM: arm64: nv: Handle HCR_EL2.E2H specially
>   KVM: arm64: nv: Forward debug traps to the nested guest
>   KVM: arm64: nv: Filter out unsupported features from ID regs
>   KVM: arm64: nv: Hide RAS from nested guests
>   KVM: arm64: nv: Use ARMv8.5-GTG to advertise supported Stage-2 page
>     sizes
>   KVM: arm64: Check advertised Stage-2 page size capability
>   KVM: arm64: nv: Support multiple nested Stage-2 mmu structures
>   KVM: arm64: nv: Move last_vcpu_ran to be per s2 mmu
>   KVM: arm64: nv: Fold guest's HCR_EL2 configuration into the host's
>   KVM: arm64: nv: Propagate CNTVOFF_EL2 to the virtual EL1 timer
>   KVM: arm64: nv: Load timer before the GIC
>   KVM: arm64: nv: Implement maintenance interrupt forwarding
>   arm64: KVM: nv: Add handling of EL2-specific timer registers
>   arm64: KVM: nv: Honor SCTLR_EL2.SPAN on entering vEL2
>   arm64: KVM: nv: Handle SCTLR_EL2 RES0/RES1 bits
>   arm64: KVM: nv: Restrict S2 RD/WR permissions to match the guest's
>   arm64: KVM: nv: Allow userspace to request KVM_ARM_VCPU_NESTED_VIRT
>   arm64: Detect the ARMv8.4 TTL feature
>   arm64: KVM: nv: Add handling of ARMv8.4-TTL TLB invalidation
>   arm64: KVM: nv: Invalidate TLBs based on shadow S2 TTL-like
>     information
>   arm64: KVM: nv: Tag shadow S2 entries with nested level
>   arm64: Add SW reserved PTE/PMD bits
>   arm64: Add level-hinted TLB invalidation helper
>   arm64: KVM: Add a level hint to __kvm_tlb_flush_vmid_ipa
>   arm64: KVM: Use TTL hint in when invalidating stage-2 translations
>   arm64: KVM: nv: Add include containing the VNCR_EL2 offsets
>   KVM: arm64: Introduce accessor for ctxt->sys_reg
>   KVM: arm64: sysreg: Use ctxt_sys_reg() instead of raw sys_regs access
>   KVM: arm64: sve: Use __vcpu_sys_reg() instead of raw sys_regs access
>   KVM: arm64: pauth: Use ctxt_sys_reg() instead of raw sys_regs access
>   KVM: arm64: debug: Use ctxt_sys_reg() instead of raw sys_regs access
>   KVM: arm64: Add missing reset handlers for PMU emulation
>   KVM: arm64: nv: Move sysreg reset check to boot time
>   KVM: arm64: Map VNCR-capable registers to a separate page
>   KVM: arm64: nv: Move nested vgic state into the sysreg file
>   KVM: arm64: Use accessors for timer ctl/cval/offset
>   KVM: arm64: Add VNCR-capable timer accessors for arm64
>   KVM: arm64: Make struct kvm_regs userspace-only
>   KVM: arm64: VNCR-ize ELR_EL1
>   KVM: arm64: VNCR-ize SP_EL1
>   KVM: arm64: Disintegrate SPSR array
>   KVM: arm64: aarch32: Use __vcpu_sys_reg() instead of raw sys_regs
>     access
>   KVM: arm64: VNCR-ize SPSR_EL1
>   KVM: arm64: Add ARMv8.4 Enhanced Nested Virt cpufeature
>   KVM: arm64: nv: Synchronize PSTATE early on exit
>   KVM: arm64: nv: Allocate VNCR page when required
>   KVM: arm64: nv: Enable ARMv8.4-NV support
>   KVM: arm64: nv: Fast-track 'InHost' exception returns
>   KVM: arm64: nv: Fast-track EL1 TLBIs for VHE guests
>
>  .../admin-guide/kernel-parameters.txt         |    4 +
>  .../virt/kvm/devices/arm-vgic-v3.txt          |    8 +
>  arch/arm/include/asm/kvm_asm.h                |    6 +-
>  arch/arm/include/asm/kvm_emulate.h            |    3 +
>  arch/arm/include/asm/kvm_host.h               |   32 +-
>  arch/arm/include/asm/kvm_hyp.h                |   12 +-
>  arch/arm/include/asm/kvm_mmu.h                |   90 +-
>  arch/arm/include/asm/kvm_nested.h             |   11 +
>  arch/arm/include/asm/stage2_pgtable.h         |    9 +
>  arch/arm/include/uapi/asm/kvm.h               |    1 +
>  arch/arm/kvm/hyp/switch.c                     |   11 +-
>  arch/arm/kvm/hyp/tlb.c                        |   18 +-
>  arch/arm64/include/asm/cpucaps.h              |    5 +-
>  arch/arm64/include/asm/esr.h                  |    6 +
>  arch/arm64/include/asm/kvm_arm.h              |   28 +-
>  arch/arm64/include/asm/kvm_asm.h              |   10 +-
>  arch/arm64/include/asm/kvm_coproc.h           |    2 +-
>  arch/arm64/include/asm/kvm_emulate.h          |  181 +-
>  arch/arm64/include/asm/kvm_host.h             |  212 ++-
>  arch/arm64/include/asm/kvm_hyp.h              |   32 +-
>  arch/arm64/include/asm/kvm_mmu.h              |   62 +-
>  arch/arm64/include/asm/kvm_nested.h           |   94 +
>  arch/arm64/include/asm/pgtable-hwdef.h        |    2 +
>  arch/arm64/include/asm/stage2_pgtable.h       |    9 +
>  arch/arm64/include/asm/sysreg.h               |  126 +-
>  arch/arm64/include/asm/tlbflush.h             |   30 +
>  arch/arm64/include/asm/vncr_mapping.h         |   73 +
>  arch/arm64/include/uapi/asm/kvm.h             |    2 +
>  arch/arm64/kernel/asm-offsets.c               |    3 +-
>  arch/arm64/kernel/cpufeature.c                |   55 +
>  arch/arm64/kvm/Makefile                       |    5 +
>  arch/arm64/kvm/emulate-nested.c               |  205 +++
>  arch/arm64/kvm/fpsimd.c                       |    6 +-
>  arch/arm64/kvm/guest.c                        |   85 +-
>  arch/arm64/kvm/handle_exit.c                  |   98 +-
>  arch/arm64/kvm/hyp/Makefile                   |    1 +
>  arch/arm64/kvm/hyp/at.c                       |  231 +++
>  arch/arm64/kvm/hyp/debug-sr.c                 |   18 +-
>  arch/arm64/kvm/hyp/entry.S                    |    3 +-
>  arch/arm64/kvm/hyp/switch.c                   |  241 ++-
>  arch/arm64/kvm/hyp/sysreg-sr.c                |  338 +++-
>  arch/arm64/kvm/hyp/tlb.c                      |  134 +-
>  arch/arm64/kvm/inject_fault.c                 |   12 -
>  arch/arm64/kvm/nested.c                       |  899 ++++++++++
>  arch/arm64/kvm/regmap.c                       |   37 +-
>  arch/arm64/kvm/reset.c                        |   72 +-
>  arch/arm64/kvm/sys_regs.c                     | 1523 +++++++++++++++--
>  arch/arm64/kvm/sys_regs.h                     |    6 +
>  arch/arm64/kvm/trace.h                        |   56 +
>  include/kvm/arm_arch_timer.h                  |    9 +-
>  include/kvm/arm_vgic.h                        |   21 +-
>  virt/kvm/arm/arch_timer.c                     |  271 ++-
>  virt/kvm/arm/arch_timer_nested.c              |   95 +
>  virt/kvm/arm/arm.c                            |   72 +-
>  virt/kvm/arm/hyp/vgic-v3-sr.c                 |   35 +-
>  virt/kvm/arm/mmio.c                           |   14 +-
>  virt/kvm/arm/mmu.c                            |  458 +++--
>  virt/kvm/arm/trace.h                          |    6 +-
>  virt/kvm/arm/vgic/vgic-init.c                 |   30 +
>  virt/kvm/arm/vgic/vgic-kvm-device.c           |   22 +
>  virt/kvm/arm/vgic/vgic-nested-trace.h         |  137 ++
>  virt/kvm/arm/vgic/vgic-v2.c                   |   10 +-
>  virt/kvm/arm/vgic/vgic-v3-nested.c            |  240 +++
>  virt/kvm/arm/vgic/vgic-v3.c                   |   51 +-
>  virt/kvm/arm/vgic/vgic.c                      |   74 +-
>  virt/kvm/arm/vgic/vgic.h                      |   10 +
>  66 files changed, 5925 insertions(+), 737 deletions(-)
>  create mode 100644 arch/arm/include/asm/kvm_nested.h
>  create mode 100644 arch/arm64/include/asm/kvm_nested.h
>  create mode 100644 arch/arm64/include/asm/vncr_mapping.h
>  create mode 100644 arch/arm64/kvm/emulate-nested.c
>  create mode 100644 arch/arm64/kvm/hyp/at.c
>  create mode 100644 arch/arm64/kvm/nested.c
>  create mode 100644 virt/kvm/arm/arch_timer_nested.c
>  create mode 100644 virt/kvm/arm/vgic/vgic-nested-trace.h
>  create mode 100644 virt/kvm/arm/vgic/vgic-v3-nested.c
>

-George
