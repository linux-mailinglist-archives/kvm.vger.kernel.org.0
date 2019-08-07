Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAF6184B9E
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2019 14:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388015AbfHGM3u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Aug 2019 08:29:50 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:37898 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387713AbfHGM3s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Aug 2019 08:29:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1565180988; x=1596716988;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LLTJgNCyVAD0HBTVMfvNeuX3bwcXsyRjidmw4ESBC3Y=;
  b=dRp000TUii0hNmLkVyadeL7cxhJVcLqK6RVch/Jt21SDLYQ620lTlGbO
   ynnVbviaJSl6EtqTcy3oZj/eGPeSwPi+qlgLa2J+DlQpC+3t2cvCWenCp
   5A6y7w9f3Y1EAFrcuYff5dbbC/qttKBfhwVRkYLNGx0kW8vQ/y1KrJF4o
   Eyjo1ovnxhJhNnaKshgH0RABgLINKE/BWoIp09WGR9bppyvH/4dJlIijR
   FfAFsrvQEhL0L2uCMgd11oBesCjQhgaC5AOoYOdmkW1B+eCKAgI/Ys+pi
   CQsOgAkndsmcNBB5QKxtM/0Kv8iA1IlgtQ0bAPJLoKDaeN3GHtxEpc8Zj
   A==;
IronPort-SDR: G4jWcRg6tMiuB/OZLuzGyruakZoXf2QfgKAQgImoe5jeeRbXDmoIrSfrkSUHrpm9WCUfQiTXE1
 2Otj+LgVFfGmC0ak18ALXRajsjHdJCojKkM0a9k31u2tpZFIjsAjBr2C/fYPvq9xlMS4lwU4XF
 UEmelpTldisTnQwErZn9lZklSYBPqK+j1AIstOmMe2GT1psKkN+iRY+zkdjLgpAilhc07e8nsE
 AbYEP4k9cfZn7bLBJClj7j6Efi8l9TyIIc2qdgJCQ0YpKeo9i1umrCBujz2AotKucsBD6aVD+M
 8Mk=
X-IronPort-AV: E=Sophos;i="5.64,357,1559491200"; 
   d="scan'208";a="119865608"
Received: from mail-dm3nam03lp2056.outbound.protection.outlook.com (HELO NAM03-DM3-obe.outbound.protection.outlook.com) ([104.47.41.56])
  by ob1.hgst.iphmx.com with ESMTP; 07 Aug 2019 20:29:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b/RibwNEhTY2ti5PrKK5M6JiC/GsOAaPKJutVOeoA7eXY1aMmHhjtzq90ZZIqZDFpX5+xYW4Kv1ke0UlhKSLcDbMPRVGcxAhN6UE7EImZjaMtqjKPz2KVfwzbnjsr6jogw76efKvr3PiZ65xJqpiRw4h/yYFcpKG1NNbjDB8mwo+8X4c9oajVeMlXiN8vazL8k51Jwgjk7VvW9jWXXpefA+FYqniJT9s29NqxHbVhjn/sWUG0jQ8q4/0fDFMFAn4lrmf3Q7/FqmhTdEgBKIIsPmQUCAEMaNxz4VqWFtin8j7rMtvALySSxiZz34BOLb5iHHmCkJsi288YFZ9X4AZNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rY2bVuq65cOlebX3boys5tycXEhMoWErW+e7acNWF8k=;
 b=luGQh9sBL16YvaKs3VI8RQld7a5/WkcXiOJC5qu1j1g7NaAiBI9bndhCrrUyl4Y2TOOMi5GvD1D3dmaqca62yie1tQcWBgkkfNtO0XJBpMxGcVN0nuoMfkfsZj6zXIEwVbN0L4qa8OEyeCt98ttYrgAvmAk4d55HEGqEJzwv/Mkl6uwyZFHhmG9ZnqeDcsDFoQ2xfcvewC2RYkKHAK7KCjU4Do1ngguB0AEJhOfUYr4dXTfrDmWVV8EygcI8lnbYwaaydu8pxV3uJ8B+ZtZMgXgbmtqM1nnZKe9/VGczsF8Hfp68xKlo3v9Tyzz+H4m01ocTK8f890uWo9PW9o0MSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rY2bVuq65cOlebX3boys5tycXEhMoWErW+e7acNWF8k=;
 b=bcYc40EmRDnDf+lmXodrsWc5h4TLDIkPpNGc7dUNPzoNQjbtDqKDSWn+s7oCgGAtSD3aC8ETw4+KUYWRtHxnVhN6/M/927GzO1VPweu/ReCdszc5KdDxz39ka6i33qEXiB+Z/oJ37Uk+e9/CtpwuGID6b9xU9QwHQxI+zCSj3uE=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5821.namprd04.prod.outlook.com (20.179.22.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Wed, 7 Aug 2019 12:29:46 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2157.015; Wed, 7 Aug 2019
 12:29:46 +0000
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
Subject: [PATCH v4 19/20] RISC-V: Enable VIRTIO drivers in RV64 and RV32
 defconfig
Thread-Topic: [PATCH v4 19/20] RISC-V: Enable VIRTIO drivers in RV64 and RV32
 defconfig
Thread-Index: AQHVTRvLa7uY6eE0xkKO9JocK2GkAg==
Date:   Wed, 7 Aug 2019 12:29:45 +0000
Message-ID: <20190807122726.81544-20-anup.patel@wdc.com>
References: <20190807122726.81544-1-anup.patel@wdc.com>
In-Reply-To: <20190807122726.81544-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PN1PR01CA0097.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00::13)
 To MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [49.207.52.255]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 234c26ab-88e5-4fcf-f32b-08d71b32ee54
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB5821;
x-ms-traffictypediagnostic: MN2PR04MB5821:
x-microsoft-antispam-prvs: <MN2PR04MB5821E80444FA9CD3BAA017918DD40@MN2PR04MB5821.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:238;
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(366004)(39860400002)(396003)(136003)(376002)(199004)(189003)(110136005)(1076003)(71190400001)(6486002)(71200400001)(50226002)(186003)(53936002)(2906002)(25786009)(66066001)(8676002)(36756003)(54906003)(81156014)(7736002)(81166006)(6436002)(316002)(6512007)(8936002)(26005)(4326008)(305945005)(66446008)(6506007)(64756008)(66556008)(66476007)(66946007)(11346002)(68736007)(478600001)(2616005)(86362001)(476003)(55236004)(102836004)(486006)(446003)(76176011)(14454004)(14444005)(52116002)(3846002)(6116002)(256004)(5660300002)(7416002)(44832011)(386003)(99286004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5821;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uo0Gch82XoBejRv2h57TrqVALvDwDx1bOYFq6j/T9ZTjjbJq67J0qQNUzNAhTR5wvt6cm3S2beCucMNMSFhUX+L+PRiRTfY6ma8n+V8JiP0k+7uFwSHBPluXqTlHIsoJQjPuOMuYP30DwSybkaA+48EPsgEx8dlyFku7rrOaSHASoF6OCcsF8pDwSvwrSAErWLPVspnXNItjsZC7mgxYCRW1wC5DVc9kLElPKzlUNzISwFWB+UcTkQmu4Gx+CdnWFWicwoL8SxmVYpCNzgZmAnLHPkEQ+4taj/Mhs1UPdHDOuKu6yiq0fc7nWjKa1aKQRZbutNEcr8dJ5N+Dckiusk6wwCKsaCX7AsZ8RdyD21SHHBQKAY/CftUJrHxrmrn+eLYZ+IqOPSy0mOiHEtiddfRPpA4Ipa825c/Di/LFIzc=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 234c26ab-88e5-4fcf-f32b-08d71b32ee54
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2019 12:29:46.0332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jknTPpuu0lxufwmm+6R6nZhvwFH8IuUY+MspzMMJVPPVzh/QkmEHOv2S3ydKOKXKaDrHFAepZM55G+kNmygSpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5821
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

