Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05A68A8CB3
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387682AbfIDQQU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 12:16:20 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:1357 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732724AbfIDQQT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 12:16:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567613778; x=1599149778;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=i0dBuMtm4qYdmPHDPdzjlUG780xav8sFb1mfXlmWgr8=;
  b=FUDKTFx38UgliSsRDF8EvuBevzh/DpD5Y3oPBC6cTuIpY1Qhs4jXGpTO
   q4dSECqwB0PUrOIcUhjV7IxeOBYgOvHsCgXl6d65Iq6Y/tx+NPItFogML
   Imo/iLigQnbwNGYg+E43UFVPPTT9VI8ZglEWi5D+Qq63/9LbjptV/6Vua
   jwCj6SJj9pr/KHXpFh2rz+UgttHZPq/tjdfQcy7Ipr6dqD0M+ArU3M6Mf
   BAy8dw9/ElN2tdMn2Oy1HLCM3m0yxwRgUqI2xGcQPWHIviEytll2vktsW
   228G0Qd1tcFXhIlPCDHRuXY9AO0QzCuezCwnQMAvubYvOwvyBr5Z2F45J
   g==;
IronPort-SDR: 3wfHu7/y9YsErmAI2BBD12gfGZixHfxgYe0qcpMOB2ofdvSlhjY3rULJE70xt9yrjXZyM5qfq6
 8UFPBS/zUbEiyHRGWG4bYlD3+WB3OxmlV9mr9Jo4D+2pR6Mn+NxZYtwqvpRrrTAhZluONWAP/q
 UUuziFs42UWcPeJiMHCjVMjjcIQOXLTYTHwlzdv0BS0ch59mINUinxPj6QLSlo80wwaJZABD86
 ndluVV54pQvNpcZ0O6CbFXrz0WZw2jh7tLQ4ni9SxUC90C6XD6rsZs/en2NLjNq5aIqx+Z1qv5
 Kzo=
X-IronPort-AV: E=Sophos;i="5.64,467,1559491200"; 
   d="scan'208";a="121994088"
Received: from mail-dm3nam05lp2051.outbound.protection.outlook.com (HELO NAM05-DM3-obe.outbound.protection.outlook.com) ([104.47.49.51])
  by ob1.hgst.iphmx.com with ESMTP; 05 Sep 2019 00:16:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eXDwen0SX4wjQof89S1y+e/bqW1lipt2pVmBfnjM9fwUKMwDUcpF32wZoKcLqcMMTBokyb43tQYRWGGKTP7wOujxW5yb2mI+6Px4Pd7Vaw2UjczNbk5LsQ9cAx/4CLov982eVtEEeN37fqZkbJGqa2VW8Y/AEDIjBFhRCqO8aPs//SpIvT6tIVxbWU2s2/o/5cpIY7h0m4kffCVHGarXZa76vyAAQJJGKQEChTodVdD3SCFjTxLODLg/T1pzYteJnL26P0HG19N0Nah5YYUIqdgShLjHXZFw8oeqEruZy2Hx5xd4Kd0EXd1VChYWSdvVfY2awYU7uvqohQo1c/625g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6V1q6hJtlrVrDqgWao5UQv7SJqACoYta45fGWJ5PcbU=;
 b=g1h1NPdi3gVYO7NevllJzmyn3S5W2zkubLQNZbSu8kwAk/Ww90adyQSDbDO2W7gAK254CecElHRy6VP3VK/h0ZBYjlqM+fe7ZD2t4GUmXR2HB1zpEo65Z3XrpfNlGXpAkLdrZvEb2mdBKusEiIuJM073vo0EGJsRwbBenZ8k0/e7atbyejCfhyLws6PRthNBBfY2JFQZtbO2jcC4RpO7DfToobqBjs9txD4Vdg/M597xLSeyTZbXuu9+b1IdykrS+kUL3ETrdP6RLGW0yCEQAItGBWVEj166Aa7ZHzTOxxUYMnZiKXnR6pvFuUSnL/0odhVlCeGouXjNTCcQI4fpOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6V1q6hJtlrVrDqgWao5UQv7SJqACoYta45fGWJ5PcbU=;
 b=jxiItgvM64x8b6kpw4PUQHjVo6MMc019oHENk7tXFni6MeYDQDBrXMpgoMqY1/IY461jLlwY+65oEx3OlxLVICAeERN9KeowsqdTFoLLev4iwgeWGu6SaeeEdwaZCZxBbIqGxRwVI3V7srS9mlYESTkBFyEiBY4OJVyca57kp2c=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5504.namprd04.prod.outlook.com (20.178.247.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 4 Sep 2019 16:16:16 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::e1a5:8de2:c3b1:3fb0]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::e1a5:8de2:c3b1:3fb0%7]) with mapi id 15.20.2220.022; Wed, 4 Sep 2019
 16:16:16 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
CC:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [PATCH v7 20/21] RISC-V: Enable VIRTIO drivers in RV64 and RV32
 defconfig
Thread-Topic: [PATCH v7 20/21] RISC-V: Enable VIRTIO drivers in RV64 and RV32
 defconfig
Thread-Index: AQHVYzwT/TmE4RVItEaEX+vtCf8idA==
Date:   Wed, 4 Sep 2019 16:16:16 +0000
Message-ID: <20190904161245.111924-22-anup.patel@wdc.com>
References: <20190904161245.111924-1-anup.patel@wdc.com>
In-Reply-To: <20190904161245.111924-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0084.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::24)
 To MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [49.207.53.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 338a4857-dd19-4f28-1299-08d731533661
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB5504;
x-ms-traffictypediagnostic: MN2PR04MB5504:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB5504F3CC4C57DBFCD3E09B408DB80@MN2PR04MB5504.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:238;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(136003)(396003)(346002)(366004)(39860400002)(199004)(189003)(66556008)(66446008)(7416002)(7736002)(8676002)(478600001)(25786009)(386003)(66946007)(99286004)(256004)(14444005)(50226002)(14454004)(66476007)(64756008)(6506007)(6512007)(102836004)(6436002)(8936002)(54906003)(6116002)(3846002)(486006)(26005)(55236004)(86362001)(1076003)(53936002)(476003)(316002)(71200400001)(71190400001)(81156014)(76176011)(52116002)(305945005)(5660300002)(6486002)(36756003)(186003)(11346002)(2616005)(66066001)(44832011)(4326008)(2906002)(446003)(81166006)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5504;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: oQTc7cANtd0XH0H6ysANcC+aXYP/fJV24wJMlOyWmd1x1anNmaO0nigy81otTOZRdwLEmkJEVs7duqicnxLPX5jC82wbxihLsXsNka0RTED6aXROlOxqcuPio7NlEbMBgRJ8ql9E9BZlfPb0Q+1H0U2RamJ1fI2KIMWBixNBZ969BkRSjhRqgp7sWfKwaO7iNY9N4M3nmyi9pGWCWjLvLyz9Sv3K7isL3mPLStijIhP+VW/1XHRXvbBvZK+y3OnGQ+Il49O2g3TNe1KdcEONQoHugbFXgy6Mfzw1bQoN5su0atkh8BS3xV1ubNyTVY+FLGsP0qjntLx2iWN/UEsSb90kUNcUuZ5B3dxB44PbpcziebHfEILc1niHbhAjemzOmJ9V7NOThSeFzYFRSnKjdIQg4at31yxOwpFTiz3WecE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 338a4857-dd19-4f28-1299-08d731533661
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 16:16:16.2221
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HkooxODKxAIWkrYNjyEeyUqsNU8/48F6aUzhqo+9t2CApFgaKP9WahbzgPoTlQ9ofX423wwLAB47GCSt4ARq0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5504
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
Reviewed-by: Alexander Graf <graf@amazon.com>
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

