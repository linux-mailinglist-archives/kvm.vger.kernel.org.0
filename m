Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE5ED7EDFB
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 09:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390463AbfHBHsz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 03:48:55 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:39514 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388689AbfHBHsw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 03:48:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1564732156; x=1596268156;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3sVQD24PwdMT+/uCMiIrGy+yEC76O3ceO712hzdkhZM=;
  b=eZfJhmWCes3LX5xRf93AzrITf+dlDl1Nt0OGLC4K+/VAG6Ahcqw69AAP
   Gg3yf5zXxsjl85wo9GbRCRZwELrIK1hVT113k4RipuQibyv0Pv3A0/qvr
   GwdH36r8317AYwrPPRQR3k1PIlXmRYYqh4frgKb+hef96PSoL8oGoQiKR
   Y46TSzec8KiG4/LiP25dUztKQRqxCiS03johXPwhnoWOk5BRESPpMX9Lg
   uuG7pJaR7yq0LIupkXBHT/+Llca1bSQyH0+TfUUnh8r/xs1k9drdbOSQa
   3XEiOCfiJ5PFxt8DveJaO0v86PoPKodszQzwETcDFkCnr4aE7QmtvLe0v
   w==;
IronPort-SDR: 70PsoMnoUO1aRTxdHFVw35TdCrkoOjDl54bV4n2SkAHY5EQL97raDZfQ0ZaFXZD17SwpX/isLa
 1lIS4SQOIg6kkk4AITNvAUeSxAAm0Q4Plzq9gDcnGUt1QBDshBsODxcvnTnXWx6wKJSRUDy8r4
 rrzHwW5jRQJ4qeC1U1hbnWkOtfAvZKc+AnI8xrZFEb6AL5pDxZk5NJdEuk1Vu9oyvFvzpmuBWZ
 GVHLDY0nKA+u5aUkFVDZx9QcrAXXMS0ZrEFQL2+LhXTeuM5HpUb48k6t7hJMcmOCEfXlyC9xbi
 4l4=
X-IronPort-AV: E=Sophos;i="5.64,337,1559491200"; 
   d="scan'208";a="215006751"
Received: from mail-co1nam04lp2057.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.57])
  by ob1.hgst.iphmx.com with ESMTP; 02 Aug 2019 15:49:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cuHSj6CNP1d1UrV8qPIW3so7FAQ15a0A12hcd4qeEGcalB5ggANCDZjAS7KqgiwHrDRr1stleB6nxwIPELza8URB2+rarmae1qFvR+5lUQMvbDs4Tgcca6KnkcPBJPimE+woqOg9pYaZlj4Pn/Tu4TaQUyYsOe2dnhA63S/85ZcDhy4/jnX9z1/ZRTMT2VyT2kW8lKenVqC4dvx+q7piPKPDkOK9BzmY/P+rSTeBKLHGXWkQxNBhlhRICeKfmzZyhWe4WgUG7kuKhCxGSYjno3U6OwCVnrYtXEtvSD/+borVD2cyio+9+7yl7/C1PguvfUmnXIOH4QW8pWzE34uVqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ot1gvoL1ac5Bhj8HPN2EC5ZSgrmJBFnsvONQ2G1Vovk=;
 b=NZbC9aX3KPK4CzUEflo0R2QWGbBcOqNyVIlepepIepHDxiAlsAy0N5cZ8CBYZBcyg4nx0GtLx+DnrX0A/39tVavNh/Vbs2I0IbPmeuyHT445wyDqG2eaVcqVzieHutaXMvgBm1yoIbHHKmQdfNVoDWCWU+8tWeLIkmCoQYpFxOACBwdcKDhMrk1DlzCMr1/C2ek35S5/UwsFTveKygVb9i9Lg2S8D/TeGXUeXHapNLFlJKoFs4qbkouQ1sHE8EUwJOy1HpOZZzLotSpV9bOMXcmHd3neYxawC30yzl1P4h4TfZ/7endhZc7jHEam5lzGL/V9VWYoRA2IyC5RDVFEWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ot1gvoL1ac5Bhj8HPN2EC5ZSgrmJBFnsvONQ2G1Vovk=;
 b=OCuE0Vggrqj1El4W5L/uPAO7S24oH7TB3dic748s8upF3U8ZEaAytmX/f6YR8BUjfuw09JUnIKQSuEKL6OT25P84SPnPOL8teoMcHN0izOOHJ4hWKtNcT8XbRcUopd6FYrnY6VRyyUoqaB9NZ5tyx+ws4ArU2iPG7xNi8OktaM4=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6208.namprd04.prod.outlook.com (20.178.248.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.16; Fri, 2 Aug 2019 07:48:49 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2136.010; Fri, 2 Aug 2019
 07:48:49 +0000
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
Subject: [RFC PATCH v2 18/19] RISC-V: Enable VIRTIO drivers in RV64 and RV32
 defconfig
Thread-Topic: [RFC PATCH v2 18/19] RISC-V: Enable VIRTIO drivers in RV64 and
 RV32 defconfig
Thread-Index: AQHVSQa4U9A3Oes97U6GsDcP3hBRMw==
Date:   Fri, 2 Aug 2019 07:48:49 +0000
Message-ID: <20190802074620.115029-19-anup.patel@wdc.com>
References: <20190802074620.115029-1-anup.patel@wdc.com>
In-Reply-To: <20190802074620.115029-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PN1PR01CA0111.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00::27)
 To MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.20.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c445b94b-8f05-4cbb-9618-08d7171ddae8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB6208;
x-ms-traffictypediagnostic: MN2PR04MB6208:
x-microsoft-antispam-prvs: <MN2PR04MB6208F0E0862993BCB72B9F3C8DD90@MN2PR04MB6208.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:238;
x-forefront-prvs: 011787B9DD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(136003)(39860400002)(396003)(376002)(346002)(199004)(189003)(99286004)(7736002)(305945005)(9456002)(50226002)(2906002)(8936002)(14444005)(256004)(3846002)(14454004)(86362001)(5660300002)(6116002)(478600001)(53936002)(316002)(66446008)(64756008)(66476007)(66946007)(66556008)(6512007)(68736007)(81166006)(81156014)(102836004)(55236004)(76176011)(71190400001)(386003)(25786009)(6506007)(54906003)(71200400001)(110136005)(78486014)(476003)(8676002)(446003)(44832011)(66066001)(6436002)(52116002)(2616005)(1076003)(186003)(7416002)(486006)(36756003)(6486002)(4326008)(26005)(11346002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6208;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cypk29NwHkGu4QwgI6wIuU3tcUL2UUlIstPB/LmreB4PpFWx/psqajHKoss1ktiafXs+8gonb4SLYdphtTxMvg3tVy35sc4QsydSaWIGSw8OdKkjo3LkRtE6d9WUPeBFkqPomIppZmGdMUy1ZgPnfe0BY4i7YwYCkz0SshzwPk4ECM8E8pOikz40LFVKlrCOfgyseXxU9xgWf/3aEDo4tDaxKOv3S6gbRkm/gwa/cVbeqh36BpXOq7c0OlcWpRCeC1hJb4DViOM4Q85JcmJr3JJiLKVTSYg8cXQQxb1VOHSXWb1LxxxC/bCGjNu/Jl5xHVRkWthI4fT8BU5d9h37eu8AowfsjveOjzGwt4UVvj4kjeWC9i/1KT+PfMytsDkwNEUIsgQn40ud9YZSzIqkw7umZYZh8p24sVceBQW/bFI=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c445b94b-8f05-4cbb-9618-08d7171ddae8
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2019 07:48:49.2579
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

