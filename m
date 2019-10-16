Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1E5D96B3
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 18:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406108AbfJPQMd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 12:12:33 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:20562 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405716AbfJPQMc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 12:12:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1571242352; x=1602778352;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LEr1iTG81jUIiKe4A9+2N5c1Jb/z1mZqs/TTurE2cyg=;
  b=cXsdf3W0LPPksTLthOrS+S2fzqkzB/KOQHm9NP/a9xkjvkEi9Ge6COOH
   qWSC20WXbk7wEExy15AxGrR5p/kgaue09AtCmzgBs8WU4uGd7NuCEfIZS
   yuRByt2nR6bmBW8ogS1e8BGPuuI6up6KfhE4vr7eeKaWC+84K1kTxTQfJ
   rFdt4qIjv5q6bV+/qoR07roCBj1W/OWnQyYxKYCde62j6EPmTkNvsocl+
   7kk2MRAzlHGlHI4xuBHpPU24kvnOe3qgrSPw+YZxHn5qL124ZHCM49Pp0
   WQ7f4OPYtBg7ECCWfbnLNIFIC7MNwB88jAH/3JdXDJXGChN8syi+NL5xw
   g==;
IronPort-SDR: eareGs2/DZrJEGGw29DA4ey7a0OngU8cJjtUuBvqJq7xMF20GtJJNrDQtj8c0gQTOFXIvN9cya
 wbzY9Sl+cmKRaWo2rGTtfey6wd9IYxOzslUtllZbziWiMceLnCpdwXUr44TikGpADz1eZFdUso
 hAO21UF1wVf/JF8gLNs2OkNo/gexsLRzBUAJE3s91ncrOz1yO2r3iMGqQR7FSZfSR6mpbRLDAZ
 5lTBz5Z1CHjQ77RaKqspDqndFrmYAROohNKMGNc1vMpZDogJ/NyehmDUbl02oY1fNBMq1ac5eH
 hyI=
X-IronPort-AV: E=Sophos;i="5.67,304,1566835200"; 
   d="scan'208";a="120681260"
Received: from mail-by2nam01lp2054.outbound.protection.outlook.com (HELO NAM01-BY2-obe.outbound.protection.outlook.com) ([104.47.34.54])
  by ob1.hgst.iphmx.com with ESMTP; 17 Oct 2019 00:12:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZMVj2x1MjDbGqfcty7ggZDXeahua4mZujt87CZPl+LmuDVG+7g1VwgCGU4MFWOV9+HdiLqaLQ2kfILtOqpY4Nq7N5Q0xKjlsGHhWdpafd28jeSHVOxPX2SiHRR2+UQi2R+R86nASZh/cinFJj1dx2VsK/ojVybkUROdGKCeBiFM4iYEDRpIvL6kwndk9QZsU42JxvZmVXCtr7qBywZn2w0HycEfZEY1qEjrsDEf8hGYNDQMXna5duENl56UVdTgVyT3QRUI+E65zCY7y+iVHtXhgUBproUjQ0c9FzasFn7PWGqIwwPaotzWinRlyCGz9q5smkp1q22nrpjC+0XPIng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RCXRELHZWT9dsTWPHt0dSCJC5e4c86eGIvx5+ueMqsU=;
 b=g5IkiQ/LyFKSa5U32QoU727kQZOsRX+Hc3GgvEWzJnIpM4sLq5X74lVH/xpQ/9aGYDoDoQkgTE+qhV+3m7t/z4LYFpyyKXDR6K6nMpTls8OMcPl5H8ytQbhIh2fvIjDNhnrgxhf9b+inTi5E6Poc16GpXXdd46hMX6uKHdiUkl9rK7MsYUPvQ3D4ICWtj6z1w0qDEKCVz9pyMACqHfLu4FbprVrFEX3xDxXCDTJ4I7gaeOmqqO85X4zrcDeNky1VxxOtLayBU/Gymo8NAMdSPzZtaTVu7t31wK8F2HZY3TnoYlgFpqB6obMFhdW57nVyzwI2oHVAvbYGwi4A/og6rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RCXRELHZWT9dsTWPHt0dSCJC5e4c86eGIvx5+ueMqsU=;
 b=i5hA4CSedBsF0uHGVGI/EABhvSD56eisowkaoM4z3VJPq/8vqBOq4c2HjUjPwRaZiWSFKO73U8YyMwj3VCEIrJ3jF63yefTv8DS+p8qtCTKD3Z1RImXNrEaPRadprqQbDuoVHySBBuacpPrHr7XnAm9HozpMVyKERRJaqapUlYI=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6397.namprd04.prod.outlook.com (52.132.170.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.17; Wed, 16 Oct 2019 16:12:29 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a%7]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 16:12:29 +0000
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
Subject: [PATCH v9 22/22] RISC-V: KVM: Add MAINTAINERS entry
Thread-Topic: [PATCH v9 22/22] RISC-V: KVM: Add MAINTAINERS entry
Thread-Index: AQHVhDyC5+d3sl6SWk+4WxaMPYYu7A==
Date:   Wed, 16 Oct 2019 16:12:29 +0000
Message-ID: <20191016160649.24622-23-anup.patel@wdc.com>
References: <20191016160649.24622-1-anup.patel@wdc.com>
In-Reply-To: <20191016160649.24622-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR01CA0098.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::16) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.27.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bd14f9b3-29a0-48b3-5fd0-08d75253a49a
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: MN2PR04MB6397:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB6397FF8A9257D359596B9D328D920@MN2PR04MB6397.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1303;
x-forefront-prvs: 0192E812EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(376002)(396003)(346002)(366004)(189003)(199004)(81166006)(102836004)(316002)(44832011)(486006)(55236004)(110136005)(305945005)(7736002)(8676002)(11346002)(2616005)(446003)(54906003)(476003)(86362001)(6512007)(6436002)(386003)(6506007)(81156014)(2906002)(6486002)(1076003)(8936002)(186003)(26005)(50226002)(5660300002)(9456002)(36756003)(4744005)(66946007)(64756008)(66446008)(66476007)(71200400001)(71190400001)(66556008)(52116002)(7416002)(99286004)(256004)(25786009)(76176011)(14454004)(4326008)(478600001)(3846002)(6116002)(66066001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6397;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U1ulebGK3UrvlvpSv6mFq+P/HgvQ+xlahvNALEMmBhhshSug1FNRgcz+7grb22Nk/7ODPFzEoQGktIZyfMSVpCl/DO3dajJP71/qLgi56g4wSrEiops9SaAzJYkyfj/LUmiVVKKeUBtNxFT/Dt9x671VbVoJsrPqtO5wQcGgOSkr7yuS2Rpfh4BHXRkzSPWJJJA/KON+duMJyPWJj3/MYRhifjck0Tzgzx+DI5x58NnoU52Q5rs9dYgfGwDzyi9znYR23pTnoVizhO0D5SrI6OAiewEbZqTPfy3cHpZarDA3UusWmPFFOHs3gkvZIyl0+ISdCsP2pFA1G1UT1HCP0ZhjaI0N/9iCB654PJ8J6xVNf7+DDpvd2tLc7LlwRlaOdyEPtD6FJ497eflbyb//tJ4OfAugZVIlbJI7FcKyxSM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd14f9b3-29a0-48b3-5fd0-08d75253a49a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2019 16:12:29.7895
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TwfH0qXMbglhJYmps49fYzVVq/c8yQcN0Os84+Kd7O6Xh3CmsmuUsFjB/t8ZWMSZwVt4uLe5b4hyx1KflJ+ZkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6397
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add myself as maintainer for KVM RISC-V and Atish as designated reviewer.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a69e6db80c79..b73b9488a7c2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8979,6 +8979,16 @@ F:	arch/powerpc/include/asm/kvm*
 F:	arch/powerpc/kvm/
 F:	arch/powerpc/kernel/kvm*
=20
+KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)
+M:	Anup Patel <anup.patel@wdc.com>
+R:	Atish Patra <atish.patra@wdc.com>
+L:	kvm@vger.kernel.org
+T:	git git://github.com/kvm-riscv/linux.git
+S:	Maintained
+F:	arch/riscv/include/uapi/asm/kvm*
+F:	arch/riscv/include/asm/kvm*
+F:	arch/riscv/kvm/
+
 KERNEL VIRTUAL MACHINE for s390 (KVM/s390)
 M:	Christian Borntraeger <borntraeger@de.ibm.com>
 M:	Janosch Frank <frankja@linux.ibm.com>
--=20
2.17.1

