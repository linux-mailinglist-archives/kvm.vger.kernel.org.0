Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33C2798E48
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 10:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732729AbfHVIrJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 04:47:09 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:29178 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731500AbfHVIrJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 04:47:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566463629; x=1597999629;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AFobqC0bdIEmM6sFtQmzLt3x6VvFgASxo+AaAyM8jT8=;
  b=kGHW/+ac63DuONWU1x6nQ7iOUffgZXqd5o+gxl7/yeUWE6fREtwonTjU
   jhQq4Qu75hsJdKDqRM34nxeQkcLCJBXcg1cpbUj820flzzbfdo3Lwt/2t
   FmXbvB8vti/UWIips5WZ2EjRaWDprkJr0rStoqk25bAJ2Rczl/NKXzjsv
   xnoWR1idjuYKImBrxalzLSqoTm6fRx1XrUzUfyjZ//vBaQkeSUc/B+ZG0
   C1VIFVgkrbZTyJ/lI3zDMrnEMcEUVoStRmp6Pw2A7GrMNPsfb1GuuggkL
   z4HRsLR9nGjVM3HEGKrZzBpR1U6FaydC8dx3QH9niQRHtNdcuLIhE1daI
   w==;
IronPort-SDR: Q8yyoxUvK7MH5Pi5GY1OJ/NA8TIP7QodlXfIqZM/otfHuuTxWIlifztL8tbUg4cJTmA4LYiWR+
 vq3bSX3zdyaoVRl0A+bEKmhNvbToo9q+cBrwh9I6sR9eG2dTEwEIe/ocfkv9fE65M464kbF0OR
 4zlVrds6xZU0FsFgNOBDH+XGA3TvYklW4J98aycFt36xrf47i+qXYtqwl/MTmOKFdYGlpA0EQU
 QcRYzfKYVz3tKHScVkvSAnzvetEJ6JkfnM5mbal8bW9Knix0jDJj3d/Pbp3zPQZ4zUp/t98ig7
 cb8=
X-IronPort-AV: E=Sophos;i="5.64,416,1559491200"; 
   d="scan'208";a="216835043"
Received: from mail-bn3nam04lp2056.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.56])
  by ob1.hgst.iphmx.com with ESMTP; 22 Aug 2019 16:47:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QXUvRikjqurxI5jdAvYo5/YnpDqPnUx/mPrx6SGyNrsmINuKr4YqXdxffNxVbyKF1nZwGPtWTs2LIPnqnUXF7ZECze0BAQLwOnraOH9vUjFlfscGkh1BhXuTsy+tP8SMhGvZovuwN15nm2L/1r/9cbABRWSM2CpEpXEUeyxz07WuKK0cUHFS+o/YYxIcwcqeoSN8tidJ55vphdIca43mHZcX2tTfPsT96/RLZ3XIHVZQmcctJ1WvcEEMi3vPsf+O97iSoy3ZtuvSh2JwUoDgSO/+3UrjHaYZO/iMBbuhQg/z9NeGAuNofxo7SBJZ9e9aeSNxOgYvXw5HT1alXZ5I0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=muv0KS9WyjBoEujLq99rslGg5z/MF0Jskl0AnruBOPc=;
 b=VXyCyqw2d31C34K/OkdSfCtB+bm12iVANiTQ2ugZIiG7S7tikGGGidgzTHaPqdqvibS12RXLHFALFH6PJE506tPGG+O7ySgEh4Qw4rtjSUBRkl83WS4NVDB2qpbiArSD9/yasodopEGK2puPFY3QJ63UVJD43U0iagz1J7dIISZePi5Vdj9dXu7IbXc8PQIUrJrAAdtS8c+c/4ysPzt8GIEUmsS3H+LiwGvNNDU1BjDrLtBZy8HtLAsVeRqBtAXXAA+vKfQLQyEDg228rE2N0LjYfAfBoSuSY++I2KvBnCzs9uD0LhjmjpQ1tCbvKCcoxoQd8FRBDwNZ84BFVLXMwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=muv0KS9WyjBoEujLq99rslGg5z/MF0Jskl0AnruBOPc=;
 b=yjpDBRMXV7s5SGpVORY8wmQkKSc1IQqr5ias/RaYWwUPcGio44h5avHhMsPX1id5KbXRwZ8pCTzRTrSHAC+cVS6+Xa/KmFXQEnfDVmSciil6MrN3jVbNgdn+Yn7cVeoV6rSfTOGrRRg2fHyO34YGv1yCqZSRAq2MpOSpHD9pzp0=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6048.namprd04.prod.outlook.com (20.178.249.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.19; Thu, 22 Aug 2019 08:47:06 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2178.018; Thu, 22 Aug 2019
 08:47:06 +0000
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
Subject: [PATCH v5 19/20] RISC-V: Enable VIRTIO drivers in RV64 and RV32
 defconfig
Thread-Topic: [PATCH v5 19/20] RISC-V: Enable VIRTIO drivers in RV64 and RV32
 defconfig
Thread-Index: AQHVWMYtqJBIY1dIZU2MUdQGr5Tm+w==
Date:   Thu, 22 Aug 2019 08:47:06 +0000
Message-ID: <20190822084131.114764-20-anup.patel@wdc.com>
References: <20190822084131.114764-1-anup.patel@wdc.com>
In-Reply-To: <20190822084131.114764-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0118.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::34) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [199.255.44.175]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 09aca62d-4021-41fd-569f-08d726dd4f66
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR04MB6048;
x-ms-traffictypediagnostic: MN2PR04MB6048:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB60484037C40C286ACEF5BA798DA50@MN2PR04MB6048.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:238;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(346002)(366004)(396003)(376002)(136003)(199004)(189003)(6116002)(6486002)(3846002)(54906003)(316002)(76176011)(52116002)(2616005)(50226002)(446003)(5660300002)(1076003)(8936002)(8676002)(81156014)(81166006)(11346002)(478600001)(14454004)(53936002)(110136005)(86362001)(4326008)(186003)(26005)(66066001)(66476007)(25786009)(102836004)(7736002)(36756003)(6512007)(305945005)(386003)(6506007)(99286004)(71190400001)(71200400001)(7416002)(486006)(476003)(6436002)(66946007)(44832011)(256004)(66556008)(64756008)(14444005)(2906002)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6048;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KqKwezpCM49YRBpPiav69tE3ImDAO9KSN7F36pKPRaO89ctOPlHlia1dZJjA61uVdgh+tX+EcomcfmQVQsfHu6WZKOtF2QlEkUbf/vXB8/7Yv4Wz5TVdPHj6S28NVVLtke8YmuKEStpm5U+TP+N5UAuskA/1hiZ20RR4SZQIHuaMmpkYBcE9iizLp4g6Xj5lA1NQOmLXPUTfVCPPm/Ohh2FrsIZN1HPIqtsTGqmS8uXj0B/bXJ5KliI/7dayI9gCf5VGIj98SRZksElgP3NxcHRW1eSRqP22N1dXuWryIKdpB8ZQ/knYjDzV7EV/W052gdV9+wmjVAoeiYel0sDr/8ZKxqmG58DghGYwEmYrPgPuVi99GJfFpKWUEA/zpXU/esahG3LB05kvdcQEzGgahxD1tRL8AetOvL9USc2Eb/Y=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09aca62d-4021-41fd-569f-08d726dd4f66
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 08:47:06.6164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: afYCIiXPjt26+BHkmyjDqsX8NxnDDSfQ8xrr9Pgz6sBD+N/fmvtGTXLU6s17kpnVFpv+v7tgDtkngETiAkaN4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6048
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch enables more VIRTIO drivers (such as console, rpmsg, 9p,
rng, etc.) which are usable on KVM RISC-V Guest and Xvisor RISC-V
Guest.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/riscv/configs/defconfig      | 11 +++++++++++
 arch/riscv/configs/rv32_defconfig | 11 +++++++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/riscv/configs/defconfig b/arch/riscv/configs/defconfig
index 3efff552a261..420a0dbef386 100644
--- a/arch/riscv/configs/defconfig
+++ b/arch/riscv/configs/defconfig
@@ -29,6 +29,8 @@ CONFIG_IP_PNP_DHCP=3Dy
 CONFIG_IP_PNP_BOOTP=3Dy
 CONFIG_IP_PNP_RARP=3Dy
 CONFIG_NETLINK_DIAG=3Dy
+CONFIG_NET_9P=3Dy
+CONFIG_NET_9P_VIRTIO=3Dy
 CONFIG_PCI=3Dy
 CONFIG_PCIEPORTBUS=3Dy
 CONFIG_PCI_HOST_GENERIC=3Dy
@@ -39,6 +41,7 @@ CONFIG_BLK_DEV_LOOP=3Dy
 CONFIG_VIRTIO_BLK=3Dy
 CONFIG_BLK_DEV_SD=3Dy
 CONFIG_BLK_DEV_SR=3Dy
+CONFIG_SCSI_VIRTIO=3Dy
 CONFIG_ATA=3Dy
 CONFIG_SATA_AHCI=3Dy
 CONFIG_SATA_AHCI_PLATFORM=3Dy
@@ -54,6 +57,7 @@ CONFIG_SERIAL_8250_CONSOLE=3Dy
 CONFIG_SERIAL_OF_PLATFORM=3Dy
 CONFIG_SERIAL_EARLYCON_RISCV_SBI=3Dy
 CONFIG_HVC_RISCV_SBI=3Dy
+CONFIG_VIRTIO_CONSOLE=3Dy
 CONFIG_HW_RANDOM=3Dy
 CONFIG_HW_RANDOM_VIRTIO=3Dy
 CONFIG_SPI=3Dy
@@ -61,6 +65,7 @@ CONFIG_SPI_SIFIVE=3Dy
 # CONFIG_PTP_1588_CLOCK is not set
 CONFIG_DRM=3Dy
 CONFIG_DRM_RADEON=3Dy
+CONFIG_DRM_VIRTIO_GPU=3Dy
 CONFIG_FRAMEBUFFER_CONSOLE=3Dy
 CONFIG_USB=3Dy
 CONFIG_USB_XHCI_HCD=3Dy
@@ -73,7 +78,12 @@ CONFIG_USB_STORAGE=3Dy
 CONFIG_USB_UAS=3Dy
 CONFIG_MMC=3Dy
 CONFIG_MMC_SPI=3Dy
+CONFIG_VIRTIO_PCI=3Dy
+CONFIG_VIRTIO_BALLOON=3Dy
+CONFIG_VIRTIO_INPUT=3Dy
 CONFIG_VIRTIO_MMIO=3Dy
+CONFIG_RPMSG_CHAR=3Dy
+CONFIG_RPMSG_VIRTIO=3Dy
 CONFIG_EXT4_FS=3Dy
 CONFIG_EXT4_FS_POSIX_ACL=3Dy
 CONFIG_AUTOFS4_FS=3Dy
@@ -86,6 +96,7 @@ CONFIG_NFS_V4=3Dy
 CONFIG_NFS_V4_1=3Dy
 CONFIG_NFS_V4_2=3Dy
 CONFIG_ROOT_NFS=3Dy
+CONFIG_9P_FS=3Dy
 CONFIG_CRYPTO_USER_API_HASH=3Dy
 CONFIG_CRYPTO_DEV_VIRTIO=3Dy
 CONFIG_PRINTK_TIME=3Dy
diff --git a/arch/riscv/configs/rv32_defconfig b/arch/riscv/configs/rv32_de=
fconfig
index 7da93e494445..87ee6e62b64b 100644
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
@@ -39,6 +41,7 @@ CONFIG_BLK_DEV_LOOP=3Dy
 CONFIG_VIRTIO_BLK=3Dy
 CONFIG_BLK_DEV_SD=3Dy
 CONFIG_BLK_DEV_SR=3Dy
+CONFIG_SCSI_VIRTIO=3Dy
 CONFIG_ATA=3Dy
 CONFIG_SATA_AHCI=3Dy
 CONFIG_SATA_AHCI_PLATFORM=3Dy
@@ -54,11 +57,13 @@ CONFIG_SERIAL_8250_CONSOLE=3Dy
 CONFIG_SERIAL_OF_PLATFORM=3Dy
 CONFIG_SERIAL_EARLYCON_RISCV_SBI=3Dy
 CONFIG_HVC_RISCV_SBI=3Dy
+CONFIG_VIRTIO_CONSOLE=3Dy
 CONFIG_HW_RANDOM=3Dy
 CONFIG_HW_RANDOM_VIRTIO=3Dy
 # CONFIG_PTP_1588_CLOCK is not set
 CONFIG_DRM=3Dy
 CONFIG_DRM_RADEON=3Dy
+CONFIG_DRM_VIRTIO_GPU=3Dy
 CONFIG_FRAMEBUFFER_CONSOLE=3Dy
 CONFIG_USB=3Dy
 CONFIG_USB_XHCI_HCD=3Dy
@@ -69,7 +74,12 @@ CONFIG_USB_OHCI_HCD=3Dy
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
@@ -83,6 +93,7 @@ CONFIG_NFS_V4=3Dy
 CONFIG_NFS_V4_1=3Dy
 CONFIG_NFS_V4_2=3Dy
 CONFIG_ROOT_NFS=3Dy
+CONFIG_9P_FS=3Dy
 CONFIG_CRYPTO_USER_API_HASH=3Dy
 CONFIG_CRYPTO_DEV_VIRTIO=3Dy
 CONFIG_PRINTK_TIME=3Dy
--=20
2.17.1

