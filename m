Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68E1681DC0
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 15:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731075AbfHENof (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 09:44:35 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:8092 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729333AbfHENoe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 09:44:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1565012673; x=1596548673;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LLTJgNCyVAD0HBTVMfvNeuX3bwcXsyRjidmw4ESBC3Y=;
  b=DKF1ssULJUnv/WtdF33XKHKIixM5L6x4p5P5ESiSnkAf7ira9L91hnMv
   n3n1g1wFmScrd4Yc3DfCAklCoOFBbZvWpWBavbWigSiMclouG57ksnWJv
   0y1BSjxse3swqe/v8Gfayzfsq70ru4z4m92dRcQ0zKgrbETfrGqjfBnuE
   P+9eItMc1kDJGX3D4iSyqGnYxD7kzxZkSUq+KXqUNrD82lmY3PNtl3cXu
   uamnTWMLOx9nPNafzc+0tzUbDbHlTP6UaYly3hWNWWwpPWkUptWJilQVM
   htNgKm/EtC8xrrXcmNuaEAQNiFi8+iWvqjEGEp4AJzjP9Hf4tb1wwz0V7
   w==;
IronPort-SDR: c1U/RS7g/rIFwyjVspLUf1zkyDVSV6HWzqSEcqzOWxQzDqupvhhemw7FGALYjR/kfLxa4M8geo
 7wGCNZe44vC3VyxCQoWBeCzmLIKWtjpJ4egvSNJo1Y1bsVHQQ4YJeB9RjmujMXaF2ZOPbW+/aK
 SG+lPh+ZWtWjhRbpNhmK5NOOITeXD0tKloyaw758hX8c9FTuQTEuYHGVDArWZlAPslZf0Pm7EL
 /Nf11+cyT7KcwA8/dorqM90Got8YrHFNIo4O8iKa2/YAp2TmO85zC9nTTDGkStRbTlTsDmPHoA
 LPw=
X-IronPort-AV: E=Sophos;i="5.64,350,1559491200"; 
   d="scan'208";a="115996719"
Received: from mail-sn1nam01lp2057.outbound.protection.outlook.com (HELO NAM01-SN1-obe.outbound.protection.outlook.com) ([104.47.32.57])
  by ob1.hgst.iphmx.com with ESMTP; 05 Aug 2019 21:44:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZOh9hGtVMKe2yLtCmMKTIPhHMBLIvHPBZgTEcdYw6isZ3Ds4laIw+xKV8ZC6r5bK8zRoUbMF3u5XgtiVd3iBioAsg0xR8/+1FG56Hl2c3gOlje7SRXnu5MjQOORTUzjT5G3S/lMirsRZTV95P/O3+gAQsdV0WcYzOs3+RZmWinDPLXFcedM1QZ6BMx7lz/KQdwnuWYYUhPCaAmoygp8iYrpb4DWGRgq7OjfkL0d2cmwjeGq5o8XDHajfiwcY5WmBijTwUlHOjhiQzuzYRGCyVrcU5/ztPINwQajtb0ZOM3Fe0R5zDSCZKS+bY0+79PgsyGWGV1u5Idqz7XOzJYFvPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rY2bVuq65cOlebX3boys5tycXEhMoWErW+e7acNWF8k=;
 b=R+pJq0WJotJzCcReT+Tqdk9LNqgx9hBuO+jV11GYUJNSBDZLmqj+pp/53u3yioPALbPkdZHJn3M4PG4Hk2Ic/iY4fY3gP+a0AHVr/+HEJn+Dqy3JS9H2T+6EFu73sYRMnE0tzz/jBkgo837tecjUBlzqUkRplfvZrHeZ+56bqcw3f6o7Lawjo9psFGjxGLFOCgeOtpo56KLwr9l0XqprvO2L0H6Ogy6sFL6Zy+91/p8k74ewYya6z/UM4LlPESv6pYO2k/m1lq4GjRsA2ipkRcGP1dUryfoAiWHFPq7nXdO6uxXDgV8e2inlSibRfUh9Rsc9XROSxyNt53FUhxjvfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rY2bVuq65cOlebX3boys5tycXEhMoWErW+e7acNWF8k=;
 b=ae0YLhp+LWBnqaN2Sp/r+xR2vIQlVtWVVOfZvpT5I63lHrGsf+rspmTNYBBMqZfItQQf6R494fG8jcaDMNrxsLwuTcUtNRcTxC4vxcn9sAnyBrm33j3Oz5x3OqBmZ7nqVZT4zvjZq4TvmlChEIjyXwscKusiNo6rj5RnC4jvyH0=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6446.namprd04.prod.outlook.com (52.132.169.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.13; Mon, 5 Aug 2019 13:44:30 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2136.018; Mon, 5 Aug 2019
 13:44:30 +0000
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
Subject: [PATCH v3 18/19] RISC-V: Enable VIRTIO drivers in RV64 and RV32
 defconfig
Thread-Topic: [PATCH v3 18/19] RISC-V: Enable VIRTIO drivers in RV64 and RV32
 defconfig
Thread-Index: AQHVS5PnXYsEbhOYsUCQ1bxJLhIz+g==
Date:   Mon, 5 Aug 2019 13:44:30 +0000
Message-ID: <20190805134201.2814-19-anup.patel@wdc.com>
References: <20190805134201.2814-1-anup.patel@wdc.com>
In-Reply-To: <20190805134201.2814-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BMXPR01CA0087.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::27) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.20.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: edf96e18-cf5a-4eae-4778-08d719ab0a3f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB6446;
x-ms-traffictypediagnostic: MN2PR04MB6446:
x-microsoft-antispam-prvs: <MN2PR04MB6446AA630D4393EDE2A35E768DDA0@MN2PR04MB6446.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:238;
x-forefront-prvs: 01208B1E18
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(189003)(199004)(102836004)(55236004)(386003)(25786009)(4326008)(6506007)(76176011)(7416002)(53936002)(2906002)(478600001)(3846002)(6116002)(44832011)(2616005)(446003)(476003)(11346002)(86362001)(486006)(1076003)(6436002)(256004)(110136005)(6512007)(316002)(54906003)(14444005)(6486002)(14454004)(66946007)(66476007)(66556008)(36756003)(305945005)(81166006)(5660300002)(71200400001)(71190400001)(68736007)(64756008)(66446008)(81156014)(7736002)(8676002)(8936002)(78486014)(99286004)(66066001)(50226002)(52116002)(186003)(9456002)(26005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6446;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lJJ7x1E51MuM6xBrAgzf7EaurNnyueQ7zyh1iOElME7SOAzmWc0uumJ1JU2ziE9Gd/ExQhCIcbsXtWEJosFuFjXXMYovm2RxXcmf9ESe76jzn5kz9yGD1RJGbnwJhK+GkQHzWin1tUjt7e5im+ilGxGU6W4B9lRIOsKGXbG9ABy4m2zdWLMMD2nvGV0Mayzq+Cby+TSvZChd3roGJA2WmUNnopjTFm2qG0b86OONoIgG1lF4xBm2goKchfKv6H3LnIWkJ50eZZM73R8nsrxSm3XMkp0X20RWpWMoB3xbasz0dn5w903lVVtDNVpzzfwsE4q92JFi1wAP3doax+2r24L5MPmpT5SNzVMr7SXcOMx32fSnxCTbkn4xOUNfAjzt6QxtrSezCsMblJit3MWk1XLfqU2eglQB0zvRkunvme4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edf96e18-cf5a-4eae-4778-08d719ab0a3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2019 13:44:30.1753
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Anup.Patel@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6446
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch enables more VIRTIO drivers (such as console, rpmsg, 9p,
rng, etc.) which are usable on KVM RISC-V Guest and Xvisor RISC-V
Guest.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arch/riscv/configs/defconfig      | 13 +++++++++++++
 arch/riscv/configs/rv32_defconfig | 13 +++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/arch/riscv/configs/defconfig b/arch/riscv/configs/defconfig
index 93205c0bf71d..420a0dbef386 100644
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
@@ -54,11 +57,15 @@ CONFIG_SERIAL_8250_CONSOLE=3Dy
 CONFIG_SERIAL_OF_PLATFORM=3Dy
 CONFIG_SERIAL_EARLYCON_RISCV_SBI=3Dy
 CONFIG_HVC_RISCV_SBI=3Dy
+CONFIG_VIRTIO_CONSOLE=3Dy
+CONFIG_HW_RANDOM=3Dy
+CONFIG_HW_RANDOM_VIRTIO=3Dy
 CONFIG_SPI=3Dy
 CONFIG_SPI_SIFIVE=3Dy
 # CONFIG_PTP_1588_CLOCK is not set
 CONFIG_DRM=3Dy
 CONFIG_DRM_RADEON=3Dy
+CONFIG_DRM_VIRTIO_GPU=3Dy
 CONFIG_FRAMEBUFFER_CONSOLE=3Dy
 CONFIG_USB=3Dy
 CONFIG_USB_XHCI_HCD=3Dy
@@ -71,7 +78,12 @@ CONFIG_USB_STORAGE=3Dy
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
@@ -84,6 +96,7 @@ CONFIG_NFS_V4=3Dy
 CONFIG_NFS_V4_1=3Dy
 CONFIG_NFS_V4_2=3Dy
 CONFIG_ROOT_NFS=3Dy
+CONFIG_9P_FS=3Dy
 CONFIG_CRYPTO_USER_API_HASH=3Dy
 CONFIG_CRYPTO_DEV_VIRTIO=3Dy
 CONFIG_PRINTK_TIME=3Dy
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

