Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E832351B37
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234629AbhDASGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:06:53 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:55859 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235005AbhDASBa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 14:01:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617300091; x=1648836091;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=lt/QKwJXcapmTqSI3EiGaC1bAYetQ+QNn0vvxI4oqIw=;
  b=hOC1QGQk2o7DOl8Q1Dv6QzVBDZtO3cF09xvgQoQqxCRPZuYXMnnhNRzK
   E5pFkTjXrZVBQHg8TqM+AApGz5YDovXEMQDizNYEPk7MqsDeDlKtwRJSo
   9FRj+oBg0go+IEjnrso/aifjF9Bwdiqk0YcfOAl13Tbhu8qZQtsr92eqb
   RkUw6lfxdckpBAJUG0HeVQPmKkLsHKaB8Bp1BDZJHvkhqXllGo+6rXdIY
   EXdx+mpqI9Ef8zpLXWfsKkWKxkdWNGKI8lsN78Y4/b7uh9ii297HDhYyS
   xijXcn+iid3g0F8VGAmR9+LhR/1Akhd4L/C9ZdMBc6T3z6lDvLKp+amOy
   g==;
IronPort-SDR: CaevHoNgyVTILvEs8uUmlqPKP+daE+VNMN4+IwbpbnTN1vnP+5cWoG/gbLSqaFmsoC0fZfZfmz
 8rZ9H8uij5aGbSEUa8u+2N1jNHnmHYfWnDDDh3E7gsfaA+TeiYZu7XZ63RKZWONiD8V89LsUj2
 euWV5ZzE8JDc8NH/wtcFhl7UDh9BGZMkxZzuqdWmOYypDyFgaeRp+FIqIjUQ1/HsCNo1DoQwPi
 daNf2h2Gy/35SlLNmWnfw4xZDtZjNQjxtsfIWPmcBGajqWinR4DWzwsVaZXQ00vquW0inT6mmR
 izY=
X-IronPort-AV: E=Sophos;i="5.81,296,1610380800"; 
   d="scan'208";a="163561419"
Received: from mail-bn8nam11lp2174.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.174])
  by ob1.hgst.iphmx.com with ESMTP; 01 Apr 2021 21:41:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VvxljKXgwRa4upl6RYZNPP6CmDYnZluKiLonzdknJbBO6H2AbY/rUOvInveoQjm+yIxAR9IzLNsoM/5OyvKHQ2UbYLHSzN4MZyZt5ZgditMwnWudLzBAsBoqS+OaBtlt39qwJL8G3T6+rymjwL4LGquspePlllK3u7XaT/uz2+926cVVHFq1yGa4aWxAEhc3Y+qv2xVDKlqZoXkNHxqwcT5abPwq1cS14mScIg4090JhDATsZUgYXIma6Ka2l1L2Q33rzl5f9uiCQeBcWd9Owe6FGFk/I/2C6SC4ALo/5fN3iKYt69jJzfTNXE3WCslCquQep3XyQ8coc+RJ3dUxwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JVONtn7CY6bJufBTlSVyRiQgxQc9dDvTi0cfyuI8f+o=;
 b=Yx3L4ASrU+9I+CuOkZXwbG0RGfH7+u+ctzhgSaaDKe5Eu8y89ZoO/iYpyHtQVJqhrTak2h8/pv9HKFxvymVD4PHfgAYcsES/t5M7k1GpvCwbE1k/cDzrWdgi3KQ2rVDvMcI4fj8Z74XsuIZ46xekLV7kmJcmeafbciTCBrLDZdtwGmU1DHv2uTG83ezGDBvOmWchNuoKJgVBTYYe5OCay2qgsZnG7tf5fHB27bnQIgiiKSxSiCqF1ruyQD0EV3FFXgFyH3IxEua0qk+2yvW9wps+qunPWdS1mN5vAyLGMinjPaWzzw3CI+Lhdja2M3+Gho9+p/nO7qjQf4ulOS7wFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JVONtn7CY6bJufBTlSVyRiQgxQc9dDvTi0cfyuI8f+o=;
 b=y4N4OHk7ojSS/lRf+lCd3/ngxttZyuD5qR4GXd1R7uRlN8AxwyrXOJajZ/jNhqqIU2byCFj8D5m4/3CaY+codZJYPrfVTyADL6B+ctM+2EaSNYM2BwlRsZaxHl2DkkkilHHaT5l4w/V/94qZs7GTxcQMM07humIJehT0bJn5+vw=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM5PR04MB0218.namprd04.prod.outlook.com (2603:10b6:3:77::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.27; Thu, 1 Apr 2021 13:41:40 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868%7]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 13:41:40 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v7 0/8] KVMTOOL RISC-V Support
Date:   Thu,  1 Apr 2021 19:10:48 +0530
Message-Id: <20210401134056.384038-1-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.179.112.210]
X-ClientProxiedBy: MAXPR0101CA0019.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::29) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.179.112.210) by MAXPR0101CA0019.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Thu, 1 Apr 2021 13:41:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05d75563-e549-4db8-82ef-08d8f513e142
X-MS-TrafficTypeDiagnostic: DM5PR04MB0218:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR04MB021841C2EA105114E705EC448D7B9@DM5PR04MB0218.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0gsPDX3/XDyPrD5SZZvZ/7ggDeD7m7KPwfli7dGNjRnkumvzcGych+H/UKilrA6vb1rPTU0uMtFid1kbyFQnrHVyQ0j4bVy+H9S4gO1WRH/XO5kSalYjpAi30Nx3N81cNiyBBr39ZyMY9tcMjzUPDs283hZRsuDPdp/Rtdziycfz8L4qPBWkpfTZ7r/voRberLNpLrHbgo0ounhQJCl9jU2cjyhmFi2CCR9993LBMSvwoZc6IgmwTytY0k81pf/2xcTtB/IAcDR62CMLF4GEn9xrLRBRi8PoDM9BXUnnXrS2PewodRtveICvTWLnL1CH5v3nfOW1bJTQ1chS0bHPyugcr7z+oB9klg3mRY5BXb64tZCwkrM8CTbUje5h46Wi1opebTcv34QWMMyiofsDPjgg0s9kx0gpjORuN2DjF44eq6rdwS/23DjHofXGzE8fkrPydLY0DRUCjKHp6/sUlTNh6/cqaJlqx7GH6KNxNwGOdmo5MLgML4Eaw+mNhlCfzy7M/QphFN5HIlN3jPP6VGbL2Sd+6bFtlzGaKZv5LskswMCNeIpayFBQH97+6yrXFTYVwIWeGndxsYMciL1XyFCp91GSMqG7fS4Cywh9DyDUIZPZaV3NPIvOoxa6WcV42tHCAb0tA3GyxBA/yib4+K47T3665ie3tmcWI84fAo+fo9Q5yYls3K6Dyz5mVjQqyhHYi2IGqypcBKB6S2ODeWZ2C59VDl9pOTcNKWqJLgqx0NFuIcsOID8D5tay1PfeQeSEj3+Kwo7XlQKrPT+R9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(396003)(136003)(346002)(38100700001)(966005)(8676002)(6666004)(316002)(36756003)(8886007)(86362001)(66946007)(2906002)(186003)(16526019)(44832011)(1076003)(54906003)(2616005)(956004)(83380400001)(478600001)(66556008)(66476007)(7696005)(26005)(8936002)(5660300002)(4326008)(52116002)(55016002)(6916009)(42580500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QdT74QQK110ZEyNAJlksJXOpUWtPYaK2ZXLboTChKueDUa1B1/BqNiDOTvWh?=
 =?us-ascii?Q?jrueDXzxNi14/3f4cJl3kdWbrhrYWewLFsxyt9/AOT7+l41JCw1qte0dyjP/?=
 =?us-ascii?Q?hIrIjauYU0abY1r/QgVFvTni/nomgHB9yKFR0Z0hReR1d8TjRpUcttEdEC2t?=
 =?us-ascii?Q?2lDzd4z2+iVVqXrNjQg6ucFUGGP0ciW4uEgJ5Hp4B/7eUcJVSFoIsn24w5JP?=
 =?us-ascii?Q?zZkk9f+VWanx3HnMuHQHjuCseqMG3FkDBseddmLDAvVI6IEfxpVBdN3b01Qv?=
 =?us-ascii?Q?rT3oe/SDFDEN9PztR+3BR+Lupm/izyJP0h8pMD54pITPeKM90eR526Fn+6+j?=
 =?us-ascii?Q?1GoaYozK3POabek55OBe6ogr8ASC5Ti3j4FgGoKHv2JHwftwN5ZSkhLNU11e?=
 =?us-ascii?Q?s/tV3jq3eFdcnEj4FXfQrdNB8+MOyH5OklR2jPcboPt+zg0RkjYcjX55PDN9?=
 =?us-ascii?Q?ifX7fKi2C4wEGAkg/xu5vXyt2/+tieGcCwumfMCJibmgshNfgyLMYAPA7snN?=
 =?us-ascii?Q?1i+LnqJxEW9HSxFnmJ1q9laX53F7Og8bw8HjG3r4NQArteDkE7RlOIYkzssm?=
 =?us-ascii?Q?DUmzsaGFJ/Zcqth4XCmV19aIFNNtRKozp5uFBMm44t1o2wJypFdhT0vBTp2N?=
 =?us-ascii?Q?CIZoQPR7AaGMWwmAkiQC5sEoXApVXINpW5e9KDVDtrTT6ECbl045J5AKe6za?=
 =?us-ascii?Q?6+Ikybd+nnuQr+ZoBJx2JamoDip9rsIucIwEdMOCCIQL+6M8YrBPzv0ejG0C?=
 =?us-ascii?Q?5JLbjkYaWXWB6z1BvQiwv/9L0aljUZytkZ4Fbvs2bYGMdgVOuCHm2E8e8/TX?=
 =?us-ascii?Q?8FcvoYCTTOoWGMSvjMXdgpBzws/c8DRt4Orx8sgGfbDGphLd1H6JYomwsYWO?=
 =?us-ascii?Q?J1XiWh4jt1nlaSFMwCEdUpFGALV9ZBWvVvQnphna59TrXty+jKwaYmUQdpTG?=
 =?us-ascii?Q?zWkfsuyII3+fsUdLRAYeQ8pJM6odSG9aEJHhov4DHFdUQ8gwnp536fl4WGME?=
 =?us-ascii?Q?rD1YI3gvx/fd7yhNq7LMDQbEtl62gEjN+mxSrOgPpoAq5ekezzQXu58jwwpM?=
 =?us-ascii?Q?2rAe/vAEY0vsmt5ij2CmMF5Ndem7nCu1Hk2UscbageH4BCDq7f259c8zywLi?=
 =?us-ascii?Q?6nka8E4OqAtiID6SCfOfWW/3/QALmJHgtnlfjecp3aKscIun9TsWwTWw8LD3?=
 =?us-ascii?Q?3sRfID3sW/0mKb9eoArORn+KM0vjCXLmxOlBn2t8RVvwCSGmO5kFB0PMa84j?=
 =?us-ascii?Q?wzmKL/VmGG29d/2l+De1QEaDLdVX2YTJFbOjzPnPOzGfuACr/4tEqtpYNL7t?=
 =?us-ascii?Q?BgeXMxe6bCSkPJcQxrxyvtAk?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05d75563-e549-4db8-82ef-08d8f513e142
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 13:41:40.7010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3cSgdaRM7DogpeXOyTcyB7c1MVe+K6807vra0w/ZJvP4YLQMdQd3J54AYsqwaa52tbjGbfrdQhgRxeNOIt2Zsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0218
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds RISC-V support for KVMTOOL and it is based on
the v10 of KVM RISC-V series. The KVM RISC-V patches are not yet
merged in Linux kernel but it will be good to get early review
for KVMTOOL RISC-V support.

The KVMTOOL RISC-V patches can be found in riscv_master branch at:
https//github.com/kvm-riscv/kvmtool.git

The KVM RISC-V patches can be found in riscv_kvm_master branch at:
https//github.com/kvm-riscv/linux.git

The QEMU RISC-V hypervisor emulation is done by Alistair and is
available in master branch at: https://git.qemu.org/git/qemu.git

Changes since v6:
 - Rebased on recent commit 117d64953228afa90b52f6e1b4873770643ffdc9
 - Sync-up headers with latest KVM RISC-V v17 series which is based
   on Linux-5.12-rc5

Changes since v5:
 - Sync-up headers with latest KVM RISC-V v16 series which is based
   on Linux-5.11-rc3

Changes since v4:
 - Rebased on recent commit 90b2d3adadf218dfc6bdfdfcefe269843360223c
 - Sync-up headers with latest KVM RISC-V v15 series which is based
   on Linux-5.10-rc3

Changes since v3:
 - Rebased on recent commit 351d931f496aeb2e97b8daa44c943d8b59351d07
 - Improved kvm_cpu__show_registers() implementation

Changes since v2:
 - Support compiling KVMTOOL for both RV32 and RV64 systems using
   a multilib toolchain
 - Fix kvm_cpu__arch_init() for RV32 system

Changes since v1:
 - Use linux/sizes.h in kvm/kvm-arch.h
 - Added comment in kvm/kvm-arch.h about why PCI config space is 256M
 - Remove forward declaration of "struct kvm" from kvm/kvm-cpu-arch.h
 - Fixed placement of DTB and INITRD in guest RAM
 - Use __riscv_xlen instead of sizeof(unsigned long) in __kvm_reg_id()

Anup Patel (8):
  update_headers: Sync-up ABI headers with Linux-5.12-rc5
  riscv: Initial skeletal support
  riscv: Implement Guest/VM arch functions
  riscv: Implement Guest/VM VCPU arch functions
  riscv: Add PLIC device emulation
  riscv: Generate FDT at runtime for Guest/VM
  riscv: Handle SBI calls forwarded to user space
  riscv: Generate PCI host DT node

 INSTALL                             |   7 +-
 Makefile                            |  24 +-
 arm/aarch64/include/asm/kvm.h       |  45 ++-
 include/linux/kvm.h                 | 269 ++++++++++++-
 powerpc/include/asm/kvm.h           |  10 +
 riscv/fdt.c                         | 195 ++++++++++
 riscv/include/asm/kvm.h             | 128 +++++++
 riscv/include/kvm/barrier.h         |  14 +
 riscv/include/kvm/fdt-arch.h        |   8 +
 riscv/include/kvm/kvm-arch.h        |  85 +++++
 riscv/include/kvm/kvm-config-arch.h |  15 +
 riscv/include/kvm/kvm-cpu-arch.h    |  51 +++
 riscv/include/kvm/sbi.h             |  48 +++
 riscv/ioport.c                      |   7 +
 riscv/irq.c                         |  13 +
 riscv/kvm-cpu.c                     | 490 ++++++++++++++++++++++++
 riscv/kvm.c                         | 174 +++++++++
 riscv/pci.c                         | 109 ++++++
 riscv/plic.c                        | 563 ++++++++++++++++++++++++++++
 util/update_headers.sh              |   2 +-
 x86/include/asm/kvm.h               |  44 ++-
 21 files changed, 2283 insertions(+), 18 deletions(-)
 create mode 100644 riscv/fdt.c
 create mode 100644 riscv/include/asm/kvm.h
 create mode 100644 riscv/include/kvm/barrier.h
 create mode 100644 riscv/include/kvm/fdt-arch.h
 create mode 100644 riscv/include/kvm/kvm-arch.h
 create mode 100644 riscv/include/kvm/kvm-config-arch.h
 create mode 100644 riscv/include/kvm/kvm-cpu-arch.h
 create mode 100644 riscv/include/kvm/sbi.h
 create mode 100644 riscv/ioport.c
 create mode 100644 riscv/irq.c
 create mode 100644 riscv/kvm-cpu.c
 create mode 100644 riscv/kvm.c
 create mode 100644 riscv/pci.c
 create mode 100644 riscv/plic.c

-- 
2.25.1

