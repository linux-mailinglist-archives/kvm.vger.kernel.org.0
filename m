Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6014978B28
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2019 13:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387838AbfG2L6H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 07:58:07 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:18441 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388031AbfG2L6E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 07:58:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1564401483; x=1595937483;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3sVQD24PwdMT+/uCMiIrGy+yEC76O3ceO712hzdkhZM=;
  b=eNcx97fCDcZrkdF4xQcGwiZ3EdXyLFu0GZ0d61+XTXOw5hFnSSw35N61
   /4OSaWE0kBL45Y6G+BSoGAuUM9iJWHZcJ4vewn3RI1tV+KBT0wBcmTwIh
   FDTezgJZeG+Jetm/MDKURzcV1I2Sb6pLv2jO5/oPzn4tXqnUPikzpKzBs
   MtfGjSc4vV1AJ5m1Tag0A7SPJzeETxIoZxmR/0kg5CNU7H+KiwWRCnikz
   VFEhBbYyTr5HrQTpq8vLHKTcb+AVeJhlR0No2aFeBijLhHYIo0RoEcOwa
   Lz6mhShOo4K2N/DGZhjtzJCN8750vXlX12Ihkym/P+GB8gistNyjZEWM5
   w==;
IronPort-SDR: a3ZJ3Ifk9fHCuDwwHh3guDYF9S3/uGewddLc2oQR1e2eJ12T/f0EJhPhpgAAyQtUZY8/spGO+M
 GeZgape7WKBQ8kySv1F85soh+vSwn10LAA0Fy9zgQL2DBdD1Ur9Mf4FPZYqyw2UerFO5s1cS8Y
 Hv/jPTLnjxITdXfm5GDuSyByq9npxdLSIvvL5RRe0TMxAASCniD0lLTkgNKmXvYEmF6Xk/Nq6t
 I1iMCsp3tdE1LERWT2oBbITlFqMIIU7/AaGTToehwbXWLlx/jr19P+06cZZaJMmrcuKGQ9eVeh
 KvE=
X-IronPort-AV: E=Sophos;i="5.64,322,1559491200"; 
   d="scan'208";a="220843445"
Received: from mail-bn3nam04lp2055.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.55])
  by ob1.hgst.iphmx.com with ESMTP; 29 Jul 2019 19:58:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UjAOfYkMw4vgQ3ISP0fv74UGR3XrV/YEdAOk85zFowbmxg86Zhq3aIo25f+iv5mcxJE3WQDIaQzhzuSTyxLvJ1Yd0wkJrkJbCfXvQ/M0FZlAju/B6SuFqWb90CdEhI4AH9leGwANccvm2y+19g1abEpAiX851+m/eF+nIglNYiEXUmrKPwhrxgzdTpSJixTJPVqswZXQlT+w44KweowiFUUQKjt0j+VMDDhNU2S1LzH0Lm4UPvB8ZBj9rmjFzE8Vo8scxAb50Xhc6pSvv/4EmrtlkytpT0o8rW6UjCNORRjpnYkZ9WLJeenLPPZIYCGzJk6B5tiX763MibiEa0qsoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ot1gvoL1ac5Bhj8HPN2EC5ZSgrmJBFnsvONQ2G1Vovk=;
 b=U7MZaMgHIVK/EC9Xm+LANohxDYJIpavvUmiuK+UPYIE+ttzf0G5Pz9fTXrx+ckG0Ozmm6kDJM3zuPXDB7vclgJbLFGLHMugsqVUPScnHjzzq2sVHYfo++FwzGWe58OTspBVM/r/PJDbDO7VfnqAe99LiOSWa5HGztZLA/kSIp7VqtglzsvS++x0oQkC9SKNr5ojeGdZGSQ55xp8fgI2qdOAUTD3rzOaxOp0fd8NVqtltFlhB0By/tg3PgmJNH3+kM0qquYuLBKt4E2dh+x04mUE2RESQeDxtN4uPYgTWt+4GUpltlAmogGrQ2eqsdGoN5dA9SffdVR9tIZL+/hFA7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ot1gvoL1ac5Bhj8HPN2EC5ZSgrmJBFnsvONQ2G1Vovk=;
 b=K10vqZHjEGsGRpmmGuBokuJ6iYPthe67ws9ffibPbu1QlXn2FKoZyvbbViEjD/G4OBXZs9vuEK6sT/nsLaQuacsbImQOl5HpTdhAPzUL17anC/IqnXEh72mgUk67SSPNVUTuUjQME+9DfOSxTitm0ieno2Umdjxz5FcF/b2HMAg=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6208.namprd04.prod.outlook.com (20.178.248.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.13; Mon, 29 Jul 2019 11:58:00 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 11:58:00 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
CC:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [RFC PATCH 16/16] RISC-V: Enable VIRTIO drivers in RV64 and RV32
 defconfig
Thread-Topic: [RFC PATCH 16/16] RISC-V: Enable VIRTIO drivers in RV64 and RV32
 defconfig
Thread-Index: AQHVRgTePmcBp6xfkUSkbD7A64bxsA==
Date:   Mon, 29 Jul 2019 11:58:00 +0000
Message-ID: <20190729115544.17895-17-anup.patel@wdc.com>
References: <20190729115544.17895-1-anup.patel@wdc.com>
In-Reply-To: <20190729115544.17895-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PN1PR01CA0116.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00::32)
 To MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.23.101]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c2762ee-8f19-48a9-6b8e-08d7141c00fc
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB6208;
x-ms-traffictypediagnostic: MN2PR04MB6208:
x-microsoft-antispam-prvs: <MN2PR04MB62081135C28E95171F286B4C8DDD0@MN2PR04MB6208.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:238;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(366004)(136003)(396003)(376002)(39860400002)(189003)(199004)(6116002)(71190400001)(76176011)(71200400001)(7416002)(11346002)(7736002)(99286004)(446003)(2616005)(2906002)(476003)(256004)(54906003)(78486014)(3846002)(110136005)(316002)(53936002)(25786009)(4326008)(305945005)(486006)(14444005)(44832011)(66066001)(5660300002)(478600001)(68736007)(14454004)(66556008)(66476007)(64756008)(66446008)(6436002)(186003)(6512007)(1076003)(26005)(81166006)(81156014)(8676002)(6486002)(50226002)(8936002)(55236004)(86362001)(9456002)(52116002)(386003)(6506007)(36756003)(102836004)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6208;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /E+4+ypMNd62GMUuhb7yoKN+nCAd7CX/40peCTUuYzMJBdO8FGZjGx8Iswj/SFQr6KWuKEa12ni4tYEbzOlfX9BKkS1l6nQvH4Q5z+IFtPClq3q2mgQ4yFKCcLufVT5oV12RfmLr6XMoWvYagK1h0ThARa4SYdO4bbabkL/Ow91Br0ie1TvmjmHzLFb3m9qaJ74e+j1IqkySRO8HZm+waeTvdianUz7dtT0waewisXECoMeNsS3tym6Pk5t2bQCmzPdTcD6fb6c0pgNfO4iihydGE8Md+3FQeDo7KQM/Jb96cGRQXXUjn4wFKiGBACiv/wjDjJLKfk0YgE6ZBjHw1aL/cxBHJfoxS3OMneb/e2/8mSMd3bBCea1jyoJAOplnzlv9mOrQ8MGltZ0dufoDUpTeVLPhtbWORDyoGt7L+SM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c2762ee-8f19-48a9-6b8e-08d7141c00fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 11:58:00.6845
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Anup.Patel@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6208
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch enables more VIRTIO drivers (such as console, rpmsg, 9p,
rng, etc.) which are usable on KVM RISC-V Guest and Xvisor RISC-V
Guest.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arch/riscv/configs/defconfig      | 23 ++++++++++++++++++-----
 arch/riscv/configs/rv32_defconfig | 13 +++++++++++++
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/configs/defconfig b/arch/riscv/configs/defconfig
index b7b749b18853..420a0dbef386 100644
--- a/arch/riscv/configs/defconfig
+++ b/arch/riscv/configs/defconfig
@@ -29,15 +29,19 @@ CONFIG_IP_PNP_DHCP=3Dy
 CONFIG_IP_PNP_BOOTP=3Dy
 CONFIG_IP_PNP_RARP=3Dy
 CONFIG_NETLINK_DIAG=3Dy
+CONFIG_NET_9P=3Dy
+CONFIG_NET_9P_VIRTIO=3Dy
 CONFIG_PCI=3Dy
 CONFIG_PCIEPORTBUS=3Dy
 CONFIG_PCI_HOST_GENERIC=3Dy
 CONFIG_PCIE_XILINX=3Dy
 CONFIG_DEVTMPFS=3Dy
+CONFIG_DEVTMPFS_MOUNT=3Dy
 CONFIG_BLK_DEV_LOOP=3Dy
 CONFIG_VIRTIO_BLK=3Dy
 CONFIG_BLK_DEV_SD=3Dy
 CONFIG_BLK_DEV_SR=3Dy
+CONFIG_SCSI_VIRTIO=3Dy
 CONFIG_ATA=3Dy
 CONFIG_SATA_AHCI=3Dy
 CONFIG_SATA_AHCI_PLATFORM=3Dy
@@ -53,9 +57,15 @@ CONFIG_SERIAL_8250_CONSOLE=3Dy
 CONFIG_SERIAL_OF_PLATFORM=3Dy
 CONFIG_SERIAL_EARLYCON_RISCV_SBI=3Dy
 CONFIG_HVC_RISCV_SBI=3Dy
+CONFIG_VIRTIO_CONSOLE=3Dy
+CONFIG_HW_RANDOM=3Dy
+CONFIG_HW_RANDOM_VIRTIO=3Dy
+CONFIG_SPI=3Dy
+CONFIG_SPI_SIFIVE=3Dy
 # CONFIG_PTP_1588_CLOCK is not set
 CONFIG_DRM=3Dy
 CONFIG_DRM_RADEON=3Dy
+CONFIG_DRM_VIRTIO_GPU=3Dy
 CONFIG_FRAMEBUFFER_CONSOLE=3Dy
 CONFIG_USB=3Dy
 CONFIG_USB_XHCI_HCD=3Dy
@@ -66,8 +76,14 @@ CONFIG_USB_OHCI_HCD=3Dy
 CONFIG_USB_OHCI_HCD_PLATFORM=3Dy
 CONFIG_USB_STORAGE=3Dy
 CONFIG_USB_UAS=3Dy
+CONFIG_MMC=3Dy
+CONFIG_MMC_SPI=3Dy
+CONFIG_VIRTIO_PCI=3Dy
+CONFIG_VIRTIO_BALLOON=3Dy
+CONFIG_VIRTIO_INPUT=3Dy
 CONFIG_VIRTIO_MMIO=3Dy
-CONFIG_SPI_SIFIVE=3Dy
+CONFIG_RPMSG_CHAR=3Dy
+CONFIG_RPMSG_VIRTIO=3Dy
 CONFIG_EXT4_FS=3Dy
 CONFIG_EXT4_FS_POSIX_ACL=3Dy
 CONFIG_AUTOFS4_FS=3Dy
@@ -80,11 +96,8 @@ CONFIG_NFS_V4=3Dy
 CONFIG_NFS_V4_1=3Dy
 CONFIG_NFS_V4_2=3Dy
 CONFIG_ROOT_NFS=3Dy
+CONFIG_9P_FS=3Dy
 CONFIG_CRYPTO_USER_API_HASH=3Dy
 CONFIG_CRYPTO_DEV_VIRTIO=3Dy
 CONFIG_PRINTK_TIME=3Dy
-CONFIG_SPI=3Dy
-CONFIG_MMC_SPI=3Dy
-CONFIG_MMC=3Dy
-CONFIG_DEVTMPFS_MOUNT=3Dy
 # CONFIG_RCU_TRACE is not set
diff --git a/arch/riscv/configs/rv32_defconfig b/arch/riscv/configs/rv32_de=
fconfig
index d5449ef805a3..b28267404d55 100644
--- a/arch/riscv/configs/rv32_defconfig
+++ b/arch/riscv/configs/rv32_defconfig
@@ -29,6 +29,8 @@ CONFIG_IP_PNP_DHCP=3Dy
 CONFIG_IP_PNP_BOOTP=3Dy
 CONFIG_IP_PNP_RARP=3Dy
 CONFIG_NETLINK_DIAG=3Dy
+CONFIG_NET_9P=3Dy
+CONFIG_NET_9P_VIRTIO=3Dy
 CONFIG_PCI=3Dy
 CONFIG_PCIEPORTBUS=3Dy
 CONFIG_PCI_HOST_GENERIC=3Dy
@@ -38,6 +40,7 @@ CONFIG_BLK_DEV_LOOP=3Dy
 CONFIG_VIRTIO_BLK=3Dy
 CONFIG_BLK_DEV_SD=3Dy
 CONFIG_BLK_DEV_SR=3Dy
+CONFIG_SCSI_VIRTIO=3Dy
 CONFIG_ATA=3Dy
 CONFIG_SATA_AHCI=3Dy
 CONFIG_SATA_AHCI_PLATFORM=3Dy
@@ -53,9 +56,13 @@ CONFIG_SERIAL_8250_CONSOLE=3Dy
 CONFIG_SERIAL_OF_PLATFORM=3Dy
 CONFIG_SERIAL_EARLYCON_RISCV_SBI=3Dy
 CONFIG_HVC_RISCV_SBI=3Dy
+CONFIG_VIRTIO_CONSOLE=3Dy
+CONFIG_HW_RANDOM=3Dy
+CONFIG_HW_RANDOM_VIRTIO=3Dy
 # CONFIG_PTP_1588_CLOCK is not set
 CONFIG_DRM=3Dy
 CONFIG_DRM_RADEON=3Dy
+CONFIG_DRM_VIRTIO_GPU=3Dy
 CONFIG_FRAMEBUFFER_CONSOLE=3Dy
 CONFIG_USB=3Dy
 CONFIG_USB_XHCI_HCD=3Dy
@@ -66,7 +73,12 @@ CONFIG_USB_OHCI_HCD=3Dy
 CONFIG_USB_OHCI_HCD_PLATFORM=3Dy
 CONFIG_USB_STORAGE=3Dy
 CONFIG_USB_UAS=3Dy
+CONFIG_VIRTIO_PCI=3Dy
+CONFIG_VIRTIO_BALLOON=3Dy
+CONFIG_VIRTIO_INPUT=3Dy
 CONFIG_VIRTIO_MMIO=3Dy
+CONFIG_RPMSG_CHAR=3Dy
+CONFIG_RPMSG_VIRTIO=3Dy
 CONFIG_SIFIVE_PLIC=3Dy
 CONFIG_EXT4_FS=3Dy
 CONFIG_EXT4_FS_POSIX_ACL=3Dy
@@ -80,6 +92,7 @@ CONFIG_NFS_V4=3Dy
 CONFIG_NFS_V4_1=3Dy
 CONFIG_NFS_V4_2=3Dy
 CONFIG_ROOT_NFS=3Dy
+CONFIG_9P_FS=3Dy
 CONFIG_CRYPTO_USER_API_HASH=3Dy
 CONFIG_CRYPTO_DEV_VIRTIO=3Dy
 CONFIG_PRINTK_TIME=3Dy
--=20
2.17.1

