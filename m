Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8781E6EAE20
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 17:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbjDUPhh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 11:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjDUPhg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 11:37:36 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA485124;
        Fri, 21 Apr 2023 08:37:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=epunw6JjPghDxoPv/QLAqqf3oWlVydNOPHaGDYKsmwOna53vaVLx83M46yd5rYlFJCYk8a7yXA3qfaBkscZ6jGapPwQNIjz/j+Rq44qTNPTxhMJSbz70N6dByjMWddXacbhLupihCprROG/CJwDY9vT2IwH8+a9a2Psyk77P36kgjKTZg3vDQEKdKjNjR2DJmcmQ+POcM5C0hdW27MIeESmNIgXYCMMSBc2pLTWUlyUGe2rl8s7btW88Zpm+debxTZB4FS0NmOF/ZKdX6bBooYnyMoxbktz1CYC5PNOSbw8zY8orECEyHieyyX+arT+1Xg3LpdJ72aAs613HdHkZJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=prDgoKRe+Ymt/phsKxNzECnbnsDP2IrLEcg0ZELRgMQ=;
 b=JH2QJAPBL7NTHxPe6FG98hS8LGbLEgr2sRSxq1+xLJSmdSmnV/iHnU6CcmDCa5IwWGyL64urhl7nTZQNQ9hQZjhVkmFL1wx0i/yj+OGw8pEvpI/Tam7O4iB7yg/1YFJN9ll60u+oawAO7PhvDe8a5R0NEtZUuBojWedIRFBj6n23t84wHN4zWxvblF5u9gBMr++e7MpUp8tXK+821ZoWkzK7rfyXIDiYtSaJZ1Ku/bBGZ8Fa4yTeVu223NdGjFg4ve8UgdgUGP4gOdeiU5KOB27Nzy0ixPKGsBGHuQ6wQACDueEkQrs0Q7ecVMjsDCfcSS4mbq1jEsHtSGrlbcuu5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=prDgoKRe+Ymt/phsKxNzECnbnsDP2IrLEcg0ZELRgMQ=;
 b=AEeDcuGCVzh2KDotHSCDuJdRlPfzNcO5DYnVDs6XK3CMeA+PNjXEtQ1XPAQqrHRj9gvB7YPhFQdle5JbdjGa8hYBrAwWtBexD1tcG+iEkWqdaeOlyiDlSKfR3daCNpPsdH0NQxJKpKtVTn2UpdTbVq69EEYKvdmNLMNFGCahKPw=
Received: from MW4PR03CA0278.namprd03.prod.outlook.com (2603:10b6:303:b5::13)
 by DM4PR12MB6111.namprd12.prod.outlook.com (2603:10b6:8:ac::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 15:37:31 +0000
Received: from CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::ea) by MW4PR03CA0278.outlook.office365.com
 (2603:10b6:303:b5::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.23 via Frontend
 Transport; Fri, 21 Apr 2023 15:37:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT066.mail.protection.outlook.com (10.13.175.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.27 via Frontend Transport; Fri, 21 Apr 2023 15:37:31 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 21 Apr
 2023 10:37:30 -0500
Date:   Fri, 21 Apr 2023 10:35:14 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Atish Patra <atishp@rivosinc.com>, <linux-kernel@vger.kernel.org>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        <linux-coco@lists.linux.dev>, Dylan Reid <dylan@rivosinc.com>,
        <abrestic@rivosinc.com>, Samuel Ortiz <sameo@rivosinc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Jiri Slaby <jirislaby@kernel.org>,
        <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-riscv@lists.infradead.org>,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Uladzislau Rezki <urezki@gmail.com>
Subject: Re: [RFC 00/48] RISC-V CoVE support
Message-ID: <20230421153514.tpqzvdu7zt7pe7hs@amd.com>
References: <20230419221716.3603068-1-atishp@rivosinc.com>
 <ZEFopfs5Ij/AIkee@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZEFopfs5Ij/AIkee@google.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT066:EE_|DM4PR12MB6111:EE_
X-MS-Office365-Filtering-Correlation-Id: a66fb1eb-af32-4c61-03c0-08db427e5232
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r11ADHa80zMcQTwUxC0vl5FOpEpV0SOh5toa12Ikx5z+8+jJrV50Lne7ziQYaldm0VuasfOqD3hIWVhaFobKdU2QUkYF54X02Ru+CR0BaE+6IOiHIWWeuOIAq1n243J/a2W21cvyuJl8MPJaaskh3XTsWn4t1ZGHiukX38omNCrnCXqE/khFCu9Ef+/WWi0AzUQ/FFcw6YoFg98uN7l/nQ8O8ttzGkepQzQoRvNbA5j+iDQ0/OklIfj3kqcBci3IK/27KgiQlWHTENS+eO4DGaShhPtlCconsYhWGF1cpgHHfsoLbg3tviz+I/oe1/+/buSmuqhMg3AfgA9sSiASe8QblfhGiidHw5mv4nF//t0clGws7hDaW2zkJzfRYA/7kTB5M8EUZpn6+5o1J5Ggvarng+8q0/CNe5PgyuzKfViF77kydqKeRqddkObeB+eIrZixKnaK1e5GEOZr286r+QPQ2pnYqnfVY0TplvAXYzm9sJ4CPKgBUpXLdCNOlbV4Qc6lXLcRlX5M3Fsu4FVCxPjhwQ/AyyBqoRvvVTVO1v7luX0jWtf646wNYFQxGNzo8h917/7feTjzCUI481eWvLaR0o/8utN4t2MjiqGk8BMvvKMFhbA0xHooVBPtGvTDiLYRAxP0j0z+DmJIQD+UQlUt4Bj2kGpSQMZLfUdvDSHjo54NBpLRyG7/oSOifVNoBOjN63uTudYHdm1lShdnfZg6esrKUkxgj8y7G8A2+kg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(39860400002)(136003)(376002)(451199021)(46966006)(40470700004)(36840700001)(4326008)(54906003)(966005)(70206006)(70586007)(6916009)(316002)(36756003)(1076003)(26005)(16526019)(40460700003)(36860700001)(356005)(81166007)(2616005)(47076005)(426003)(336012)(186003)(83380400001)(5660300002)(41300700001)(8676002)(8936002)(478600001)(6666004)(82310400005)(82740400003)(7416002)(7406005)(2906002)(86362001)(40480700001)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 15:37:31.3816
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a66fb1eb-af32-4c61-03c0-08db427e5232
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6111
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 20, 2023 at 09:30:29AM -0700, Sean Christopherson wrote:
> Please, go look at restrictedmem[2] and work on building CoVE support on top of
> that.  If the current proposal doesn't fit CoVE's needs, then we need to know _before_
> all of that code gets merged.

I agree it's preferable to know beforehand to avoid potential
maintainability quagmires bringing additional architectures onboard, and
that it probably makes sense here to get that early input. But as a
general statement, it's not necessarily a *requirement*.

I worry that if we commit to such a policy that by the time restrictedmem
gets close to merge, yet another architecture/use-case will come along that
delays things further for architectures that already have hardware in the
field.

Not saying that's the case here, but just in general I think it's worth
keeping the option open on iterating on a partial solution vs. trying to
address everything on the first shot, depending on how the timing works
out.

Thanks,

Mike

> 
> [1] https://lore.kernel.org/linux-mm/20200522125214.31348-1-kirill.shutemov@linux.intel.com
> [2] https://lkml.kernel.org/r/20221202061347.1070246-1-chao.p.peng%40linux.intel.com
> 
> > arch/riscv/Kbuild                       |    2 +
> > arch/riscv/Kconfig                      |   27 +
> > arch/riscv/cove/Makefile                |    2 +
> > arch/riscv/cove/core.c                  |   40 +
> > arch/riscv/cove/cove_guest_sbi.c        |  109 +++
> > arch/riscv/include/asm/cove.h           |   27 +
> > arch/riscv/include/asm/covg_sbi.h       |   38 +
> > arch/riscv/include/asm/csr.h            |    2 +
> > arch/riscv/include/asm/kvm_cove.h       |  206 +++++
> > arch/riscv/include/asm/kvm_cove_sbi.h   |  101 +++
> > arch/riscv/include/asm/kvm_host.h       |   10 +-
> > arch/riscv/include/asm/kvm_vcpu_sbi.h   |    3 +
> > arch/riscv/include/asm/mem_encrypt.h    |   26 +
> > arch/riscv/include/asm/sbi.h            |  107 +++
> > arch/riscv/include/uapi/asm/kvm.h       |   17 +
> > arch/riscv/kernel/irq.c                 |   12 +
> > arch/riscv/kernel/setup.c               |    2 +
> > arch/riscv/kvm/Makefile                 |    1 +
> > arch/riscv/kvm/aia.c                    |  101 ++-
> > arch/riscv/kvm/aia_device.c             |   41 +-
> > arch/riscv/kvm/aia_imsic.c              |  127 ++-
> > arch/riscv/kvm/cove.c                   | 1005 +++++++++++++++++++++++
> > arch/riscv/kvm/cove_sbi.c               |  490 +++++++++++
> > arch/riscv/kvm/main.c                   |   30 +-
> > arch/riscv/kvm/mmu.c                    |   45 +-
> > arch/riscv/kvm/tlb.c                    |   11 +-
> > arch/riscv/kvm/vcpu.c                   |   69 +-
> > arch/riscv/kvm/vcpu_exit.c              |   34 +-
> > arch/riscv/kvm/vcpu_insn.c              |  115 ++-
> > arch/riscv/kvm/vcpu_sbi.c               |   16 +
> > arch/riscv/kvm/vcpu_sbi_covg.c          |  232 ++++++
> > arch/riscv/kvm/vcpu_timer.c             |   26 +-
> > arch/riscv/kvm/vm.c                     |   34 +-
> > arch/riscv/kvm/vmid.c                   |   17 +-
> > arch/riscv/mm/Makefile                  |    3 +
> > arch/riscv/mm/init.c                    |   17 +-
> > arch/riscv/mm/ioremap.c                 |   45 +
> > arch/riscv/mm/mem_encrypt.c             |   61 ++
> > drivers/tty/hvc/hvc_riscv_sbi.c         |    5 +
> > drivers/tty/serial/earlycon-riscv-sbi.c |   51 +-
> > include/uapi/linux/kvm.h                |    8 +
> > mm/vmalloc.c                            |   16 +
> > 42 files changed, 3222 insertions(+), 109 deletions(-)
> > create mode 100644 arch/riscv/cove/Makefile
> > create mode 100644 arch/riscv/cove/core.c
> > create mode 100644 arch/riscv/cove/cove_guest_sbi.c
> > create mode 100644 arch/riscv/include/asm/cove.h
> > create mode 100644 arch/riscv/include/asm/covg_sbi.h
> > create mode 100644 arch/riscv/include/asm/kvm_cove.h
> > create mode 100644 arch/riscv/include/asm/kvm_cove_sbi.h
> > create mode 100644 arch/riscv/include/asm/mem_encrypt.h
> > create mode 100644 arch/riscv/kvm/cove.c
> > create mode 100644 arch/riscv/kvm/cove_sbi.c
> > create mode 100644 arch/riscv/kvm/vcpu_sbi_covg.c
> > create mode 100644 arch/riscv/mm/ioremap.c
> > create mode 100644 arch/riscv/mm/mem_encrypt.c
> > 
> > --
> > 2.25.1
> > 
> 
