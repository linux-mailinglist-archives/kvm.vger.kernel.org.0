Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7869E14A3FC
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 13:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730070AbgA0MgD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 07:36:03 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:24672 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727326AbgA0MgC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 07:36:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580128564; x=1611664564;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=gcbeOiDW7eCdKAvzIVlCL/Bm1cFXh1JkklTvqIXsccE=;
  b=dd7wDPDLITev7NrrHe3Odxsh3igGZFz3ckSBXBFNMkzDzmUBpkkjyCpD
   3wE9jjpmsFs2CfBSCJP51/Uqaf+b+Xvzf92h8xukSNbJTcScm12r8AFt7
   XCodR92wIPQHhlh+VhUmhfJCyc0fxdFHdKwwabkUxZeWhY+DKLvWs7Ewu
   ddosufi6Jzu3zj3F/V8CDjhJ1q3yXBQ15HtzCbpN/Dq+hPT50f6KRzkeb
   PBdtJULRNR/4VjKSL8Wok9Rj89O9PEpHLIu5gIFFZsjNFcyPeyKkS8AK0
   0SOQvLPthAFP2Lz0qJTAVeAZEQJj6wafuKGTSTKBh49C8xv3GK5/FNes4
   A==;
IronPort-SDR: AyfRh1mTU6InLdc2PodusNIH1+Va3Zw4ky9TwUue4yi+liwWa2ubobFZPxlmm3HM++H6pJB33c
 jJ2rBGG3NfSn6x+DtqbXif3plIV4QyIa37j6/RRhJuiGP9uuIv5BlKaNgQwiK7BTB00KTdxeaZ
 oPDJ2NtY6sI0nH1yzdeQe6TNpt6plRQ0PBTnPR/HWcDpZwuLh+VMoFkGx1enQBV5BmIvy2U08j
 DmfLo4j61fOtOmii5VuT/ugIryjWwJR9D59IlcvK5X0nVHACCYmTXFs2dlShBjBK/66il2WtI0
 +EY=
X-URL-LookUp-ScanningError: 1
X-IronPort-AV: E=Sophos;i="5.70,369,1574092800"; 
   d="scan'208";a="230173171"
Received: from mail-mw2nam12lp2042.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.42])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2020 20:35:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QEQ2kKCi7XD6hchpHcL76awNc9H98USNwMTdaO62XX3ohVBwTtwzZ9wN18HE2sDMZGCWt4Fee9Qv07ijuYGTouYUbcyblofYmz/+WGxxuMUyQGCHbRi6psDz4bB5Ls/1LKLIgtq+AyrJX5naVQBIQxP0k4p9NZ65zjkQxR4HbsPOzVjPiPtiY2TexvjqWmyADbDHlKsFc6ABsDjna70H4bw8HEaMwh25OUCiYUB9HoPru8zPKHx2NFe6lZYTO24oCSlzqQECgJs7h3r7dSx8EO/mxUmWCQcmsypuowFyqefCwOtSkaQqbCrNQxENvZaPeNe1WdIKVOWJI20XG/Jxlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Megk4dQFdebmZlFDpI1W5auqLYNpFy1Dh2zXKAV/HI=;
 b=irsPqkMqJLvStMoNYfexL5zkJzUeLZ7L2YYpOWei5ifsYzpynI5xjTCanEo4fsUJJhNOcVyAty7T9IN8Sd6sZ46Ver7OnPfzVEAf8Ukq1RTxBGQpzWdrxz7WqoCT5tUIwkYzOg2wkVuxWttRb0PZWFkKmDRpZPq2egbpq7tg7vq6M2WrPj9pKWYnPQxPwKwnX+vc1ppH2jpkorqRAQPF/I9BFRlBnmgV59zagRLD/4qNzzwxnL6yEvhUiqaqgss8iBgIUDt+Co5m2crxNZ5WVlXGzFZlLdi4nWuJzwaog+Ox68DO/9r5BKk+a4IuU6J907PcDb/G5w37LGGyCJ5EPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Megk4dQFdebmZlFDpI1W5auqLYNpFy1Dh2zXKAV/HI=;
 b=Apsz8Qy2kf2NBRLxH2Dpy+UOMKMpWUn2e7baSGvqnepKtSI8NOMSCmZcr7x0t9Otkg0eT+tAsOt00S1AY7uADt+CVVIhOlSySkl3wvkjg9jyYuF7qRTZJlXjQzoQSgocROrcYQ0p+hXflgsmNoV1U6Zkj2F59mvrBE1rXaR/Aws=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6735.namprd04.prod.outlook.com (10.186.147.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Mon, 27 Jan 2020 12:35:56 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89%7]) with mapi id 15.20.2665.017; Mon, 27 Jan 2020
 12:35:56 +0000
Received: from wdc.com (49.207.48.168) by MA1PR01CA0095.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:1::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.22 via Frontend Transport; Mon, 27 Jan 2020 12:35:52 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Will Deacon <will.deacon@arm.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [kvmtool RFC PATCH v2 0/8] KVMTOOL RISC-V support
Thread-Topic: [kvmtool RFC PATCH v2 0/8] KVMTOOL RISC-V support
Thread-Index: AQHV1Q5R3q09YKq3FUyZASEs+F+zNw==
Date:   Mon, 27 Jan 2020 12:35:55 +0000
Message-ID: <20200127123527.106825-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0095.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::11) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [49.207.48.168]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0f9a9876-5445-4557-be1d-08d7a3257443
x-ms-traffictypediagnostic: MN2PR04MB6735:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB6735C2CBFBCDE0E605DB47378D0B0@MN2PR04MB6735.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02951C14DC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(396003)(366004)(346002)(376002)(189003)(199004)(2616005)(956004)(44832011)(86362001)(186003)(16526019)(4326008)(54906003)(2906002)(5660300002)(55016002)(26005)(316002)(6916009)(55236004)(71200400001)(8886007)(8936002)(8676002)(1006002)(81166006)(81156014)(36756003)(52116002)(7696005)(1076003)(66946007)(478600001)(64756008)(66556008)(66446008)(966005)(66476007)(42580500001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6735;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fWGCcR0ZVkBH0MX5W4Gh4b+V0FOurjnOs+VAPclOpmlppDeAq8nz7SDyct0MHHyyUvkGCWrxLKXU0+fDwH6CbsARkE/R/FWrzFxc/T4SVD6r2ztR44qNDYPi9fTEdLcHkvubUjDV0LTeGLdhjRHuW2UF8rmvRkFnlsVtfRQtZZQDIjD/4Ud8jEDvfhJBp5I+RcLmamI6KpfjjZmAfDtWmqHmaKRjMxrZUhb/Uye+5if82LY0ZtVKFHp7AAxiH7Q+D0BcASc8+69QN2bz9EvtQuOwHZx3HUAZzc8ffSDz+l/bqMQSN2Xk1guNmHQJtwJDYfFFROraV5jAsO25gijnWP4vj0pgfTDxI+mmT5WsoLJEu3V1lUoX7xiskRv7E9Wg35INxM7v3NP7ZkMOhq9dDeSk93+j5CrLJVIy98tepQvaJ6+xBxScCrEHf8wulkNExOTNG/+OSJDdF0phjyAMfzFfxnPOkSZzKU44sh20qqMQBlGhOxCAtkm+0YLr1q7ocm4c68d/QEJQJiXxN1jGzyu5iapWMl/YQN7RwZkpb/I=
x-ms-exchange-antispam-messagedata: nhxXgBOucnNsAPFnDERVjllqmc5MjfzUrGQhT6GKnoK1Wl4144IC2tTkg4XcCc/aS+laOTiYi1yvPIDqQ4SoRZrM00oYCJxfcdtx77CLMjWuQJdN2YxvK6k7VVqvl9c617Fa+VPq7XotnRVnBpfiOw==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f9a9876-5445-4557-be1d-08d7a3257443
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2020 12:35:55.8107
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NqXXTObDL3gjfchxPTy7auWtyDOiEKPFBqoYvznNH+LiMGSf65EY8Ua+2zoPvAzmg2Q82Ncebe1A6Nr6aavYfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6735
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

Changes since v1:
 - Use linux/sizes.h in kvm/kvm-arch.h
 - Added comment in kvm/kvm-arch.h about why PCI config space is 256M
 - Remove forward declaration of "struct kvm" from kvm/kvm-cpu-arch.h
 - Fixed placement of DTB and INITRD in guest RAM
 - Use __riscv_xlen instead of sizeof(unsigned long) in __kvm_reg_id()

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
 riscv/include/kvm/kvm-arch.h        |  85 +++++
 riscv/include/kvm/kvm-config-arch.h |  15 +
 riscv/include/kvm/kvm-cpu-arch.h    |  51 +++
 riscv/include/kvm/sbi.h             |  48 +++
 riscv/ioport.c                      |  11 +
 riscv/irq.c                         |  13 +
 riscv/kvm-cpu.c                     | 404 ++++++++++++++++++++
 riscv/kvm.c                         | 174 +++++++++
 riscv/pci.c                         | 109 ++++++
 riscv/plic.c                        | 558 ++++++++++++++++++++++++++++
 util/update_headers.sh              |   2 +-
 21 files changed, 1874 insertions(+), 9 deletions(-)
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

