Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 060D512A5B6
	for <lists+kvm@lfdr.de>; Wed, 25 Dec 2019 04:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfLYDAa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 22:00:30 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:11765 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbfLYDA3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Dec 2019 22:00:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1577242829; x=1608778829;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=KBw0mEbx4kCVNoxXwgnRjZbr5zHrpLcqKgIlKhi6NSs=;
  b=gZ5dG9A/n6A5WbZrIZe0njFFwA6DzgjvDRTKz510aqJbn2NtJftJVJOC
   QNshlcRlEky4srS0bLyvIwpHyC6aVD5oBiQqh9+RWmLPHT/XuLYqb2WP4
   TFqUWurRfh8dnqvtFw6svpuZe+111vCMCxjLpfS0dt8FoyjdDu8UiTCb+
   wNqrkkbAH07LrAtw/F/EzbbVrLBKk8mep3iE5G5unxiFKAstFMp6N+za2
   4lAa8mqkRuQCfuMYCIPexucgizzdrX2oyA+pvDQFkXdskSVcR1+XnymKU
   Ehw/Jc7BkSQE77Kd9igaMttVokBChe0QklnKE63+YYhjYBZ1dlTda/BCe
   w==;
IronPort-SDR: OcrM+KmYKKd9+mXuAB8NG2EerpK3Y0TU//BvHLjeAvPz7UJv2khzbgwkow2aVkAFDEbiqE6bvo
 CzB90OB7Z1jAzj54jwiyHW5FXfHb3Ex6bes/YE8Z1a26agO4yISzsTKu72OBy1c6xYJUuYFbjw
 SCj78tcxLJdEd0v0wQLUiSLH6nfilFxyHbwimIL30JeNx5HPYY6/csUcPr26K7hoPSYQqrP6yu
 b4n2QCyET1NridbbUUkN4DzV+Nj82eEv7nHYbgOao5CBjGyezriLaymTo0NNocyfkA+AE9HHq8
 5ck=
X-IronPort-AV: E=Sophos;i="5.69,353,1571673600"; 
   d="scan'208";a="233774499"
Received: from mail-co1nam11lp2174.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.174])
  by ob1.hgst.iphmx.com with ESMTP; 25 Dec 2019 11:00:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Knz4n22MOejfT+bddL61as+jbD9xKAsta3Bsx/JMWXYUbYaxvX02LvbepgzICiot8yX9vR0mcm93y/Hg/4Y3Z260SisicYplmQ20fyzChh4Pj8dZ8h907uL/RfLAyyUfu2/q+VlTMIch0l2iB3j5+Cb2Hmcf2ExS1uS6T8TZh4Z1HSrbxpXvtwYT4KDKjUKEeteztv0i3x9x32iC21TMh3j+g/M2siArOjZ8SuGtdojTeqB6+i9Z6F8iGeqKkvB0NLtWYnWK1OKaes293DthLjur5IE6i/ObL2INxl0jTYtsVpowMSt+RgZDB1ozYR5dXZ3FctOPB7xQisTFOTpK0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9TeJpNow8HDvSkN3SoqXPynMlskZtS2SfL4gs3M1ObM=;
 b=aMS4EKwVi/ATcUygiW2BuVUEAzgHKWrrQBgv/R4Ew28B6qsBH1rmvxprB/9MR5rQifwEYK70QMVRW9GB4rrK+wGqkhyxI7P6+MGrLddsXaQ5YI+J211CUbS5QHUlqHl9U+DJc69DlTh1WZvgJSvSIf/R+mg6/gepzeNQUsHWrESd0GTWPiwJOM85j9g6k0AhDUFX6G3REKQePtIc37iCLLZNb5u7vJMQmOrYKcdIEONaqMpO0CD4AyqjGRMvKH8pxTUQI320GWkidZ9Jfbz2epN6IkRBvsoTglz6gx28GyHPNQwhDLV2wPFfpet9XniWAqFXpxs/wLMTN7e8GAJDog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9TeJpNow8HDvSkN3SoqXPynMlskZtS2SfL4gs3M1ObM=;
 b=YM8LW3L9isatTUUVG3Zr2/yglk7WxBbLJ8BAB1UzNMkehgVIovnD4O3+3SDgw7lDs1p7pojZEzMCNCt5Tvl2kR5SXIaye2vTbTNiCoIe1K0KTy1H56evwgEFdA/eMUkuUTj7I/DjFnnQoyDFp3k7ARMFfemxWTsRUGX1RfNi6X0=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6253.namprd04.prod.outlook.com (20.178.246.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.16; Wed, 25 Dec 2019 03:00:12 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89%7]) with mapi id 15.20.2559.017; Wed, 25 Dec 2019
 03:00:12 +0000
Received: from wdc.com (106.51.19.73) by MAXPR01CA0084.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:49::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.11 via Frontend Transport; Wed, 25 Dec 2019 03:00:09 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Will Deacon <will.deacon@arm.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [kvmtool RFC PATCH 0/8] KVMTOOL RISC-V support
Thread-Topic: [kvmtool RFC PATCH 0/8] KVMTOOL RISC-V support
Thread-Index: AQHVus9sz0WLDG5sW0+/jwPhZ2/GWg==
Date:   Wed, 25 Dec 2019 03:00:12 +0000
Message-ID: <20191225025945.108466-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR01CA0084.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:49::26) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.19.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2a916f88-5dac-4040-6cff-08d788e68efc
x-ms-traffictypediagnostic: MN2PR04MB6253:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB6253366248AF05D08896CB608D280@MN2PR04MB6253.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02622CEF0A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(136003)(346002)(396003)(376002)(39860400002)(189003)(199004)(81166006)(86362001)(16526019)(8676002)(81156014)(71200400001)(55016002)(44832011)(478600001)(36756003)(186003)(55236004)(6666004)(1006002)(6916009)(8886007)(26005)(956004)(2616005)(54906003)(4326008)(66476007)(64756008)(66446008)(966005)(1076003)(5660300002)(8936002)(316002)(2906002)(52116002)(66946007)(66556008)(7696005)(32040200004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6253;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: visCGmd91EMPJS/4rIqEzukqGqqBjyGP5R8HtnZjRl08mNVXD7oDTKp8fzkuG4Lly7Xl7e7H9iv+12i0o/JREu3Cce0TRBblnOzdzlzhQUc7Ik0+2VbipmlE2/FZr9WhqzssAZ0enDRERrt9dzQvUnVKN9Ebec5Vc5vcAL8HQ8yZxlwOUrxF9e8StgqnKi9sbepAZ+/fdQP3ek0g2hjjKeVkrNxRTWS75R2+TiBaURPDdtKyuqe27c4Mh7FzcYzAVzy46VK4TBolRsbjD9igzDbcM+OEw0NZlbIAN8kS6zxVvFN3LXjMDj2HS6nR2Rb4qp2KczuD3p10I3S4cDbJqD+f7mCfP1Y04GaPYfmlnnIXMI1Djg4r26d03eNjAsiyVAee7BvglspSA+LaXzaZi6CyobP67tpc1+CcSQShRiMv4XyQwFzCbgMzfPtH0SzY9lIWVES+Qi/14xOA/KUwuFX9nJjgPurlxHvoYCXXmYWdakWGSk2GL4TO27qkBXjVlRhpijjYfWyVHfss1L0Wz8weyzm05wAvBwBwTgfPeAQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a916f88-5dac-4040-6cff-08d788e68efc
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Dec 2019 03:00:12.0876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7T0TrptCA8PgveYbEOhUKzMqB6qY9flUsMaFFIHGLs1W2dyHZ3scLj3D6ZQrcDbVQ1qPGwDxQzUsdJT+qc9beA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6253
Sender: kvm-owner@vger.kernel.org
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
available in mainline/alistair/riscv-hyp-ext-v0.5.1 branch at:
https://github.com/kvm-riscv/qemu.git

Anup Patel (8):
  update_headers: Sync-up ABI headers with Linux-5.5-rc3
  riscv: Initial skeletal support
  riscv: Implement Guest/VM arch functions
  riscv: Implement Guest/VM VCPU arch functions
  riscv: Add PLIC device emulation
  riscv: Generate FDT at runtime for Guest/VM
  riscv: Handle SBI calls forwarded to user space
  riscv: Generate PCI host DT node

 INSTALL                             |   7 +-
 Makefile                            |  18 +-
 arm/aarch32/include/asm/kvm.h       |   7 +-
 arm/aarch64/include/asm/kvm.h       |   9 +-
 include/linux/kvm.h                 |  25 ++
 powerpc/include/asm/kvm.h           |   3 +
 riscv/fdt.c                         | 195 ++++++++++
 riscv/include/asm/kvm.h             | 127 +++++++
 riscv/include/kvm/barrier.h         |  14 +
 riscv/include/kvm/fdt-arch.h        |   8 +
 riscv/include/kvm/kvm-arch.h        |  79 ++++
 riscv/include/kvm/kvm-config-arch.h |  15 +
 riscv/include/kvm/kvm-cpu-arch.h    |  53 +++
 riscv/include/kvm/sbi.h             |  48 +++
 riscv/ioport.c                      |  11 +
 riscv/irq.c                         |  13 +
 riscv/kvm-cpu.c                     | 404 ++++++++++++++++++++
 riscv/kvm.c                         | 175 +++++++++
 riscv/pci.c                         | 109 ++++++
 riscv/plic.c                        | 558 ++++++++++++++++++++++++++++
 util/update_headers.sh              |   2 +-
 21 files changed, 1871 insertions(+), 9 deletions(-)
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

--=20
2.17.1

