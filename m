Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB307A1C11
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 15:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbfH2N5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 09:57:37 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:58709 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728437AbfH2N5f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 09:57:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567087055; x=1598623055;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=e4M+SL+oU8yFhAm+/wSZ/np1nCdxQBgxjIv1+l2kF0s=;
  b=MW/1yT11SzgQ8NixwfXIVVlrbHMNYFeKRGzQ2I0CzzJHZwfJdEmF9vqe
   TGKnvN49sxqTFMRMVFhM/WngsVQOhqq6v23YItqfrLMkHD93nKJ/x9iZR
   +zqhSBviwYdKXTpMDGlxfnB38GX+mz2o6PNHwRQyxFzbGoaNlGi1u7LsG
   w2Tdvc5LremQpsnyAlZsI573mUX/U+/EExIqgVVOquhQ2MvTgOxlWM+AF
   3xWyGRVmA4J9c2Yr+k4y9FtsMpFXIftr9AHvKnUExTuV7fRcXTYRfehaX
   plTn5d8LMlefjF4qUU2lzGmZZm3bhfBkPelXHKSVtZFp69MThikC0WAzl
   w==;
IronPort-SDR: mOVstTnPjFvAdqGcn1FvS7kZi/lUWEbd7KvK9IBdlLGd+8S29ExP6R/b9istnmjc6KTfpVBjpH
 1PsU1Dw2GJP2Y8hoL1krzyF73ljzMXbocDDwMvD1v6UUAOfXYeetzIZeiA5MLA/gu0YBNWRk+F
 q5pF2XylCf6vl+IOh4/LX5GTePSVs/ULIeUuO1J+9kz0kwrxyz+Wo7+Lk6Sq8QM1rz5Cxovrwn
 LX7BSOiETej5eO740VtwGTNWuZdNicw4hd9EQnLl25nDn5w/Odp+RnjtzB4cRH7yGE4Iwu8pdU
 hfc=
X-IronPort-AV: E=Sophos;i="5.64,443,1559491200"; 
   d="scan'208";a="223616026"
Received: from mail-co1nam04lp2054.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.54])
  by ob1.hgst.iphmx.com with ESMTP; 29 Aug 2019 21:57:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EoBPx2Fgm2/MphyxM1nL1OJygz+s2MWI1kkQKdh3N/E++/ZJ5F5/xC7cGB7CXV0xcq6ye6kFPATec5oei4M38u50jrD8iUFixkfMGDRNTLZlQO5F0Ob0nSwYtWtYRo80cfh57VSOtnpItup5MmsediawtsHDV2xmE5XQ3clYYNruk9wCayrAylqIP6bv+pIij70rfkMReVJen/RY2jkGu70x/9jzV9dDielJC3j3m/K3XreuPh47xdPtB6r7BSffrThOpkOmGXxwYFdpxbysGvHH6OhVu4iIWybhApocmTLW+tL/yXjt3ZLYJbA7DK/PaBB9EiCEN+eetAXTU+FsRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yXwGU8uyy0dZxkEwhToY5DeNT/buBxRMpjokd2nYIy4=;
 b=aFpzuUir0iFUS2R+jXUNms53VmWADlphLlpbZPOc1Zf9xlmOi3eilpzM0HQSxdwkz2Rq/0/iAyLB+POnl+D/dXaldEYY/DbtG49DDDW4GShBk4izByZuGYwHaFDLMf1Z2Y1C5QKC4PzikceMs62E7KNnO7n6F3Fal50vTe/sFvnuGjZtfhA2dCUbgNExTqWAA1yS0fl0d96ResXwhF2ReJ1lbjXiZPgJICuUhSGdZaaxK4XpbXJ5OAjq3Dnh29bwXfrCBTytt86IJXoGzCj8F7wlVYYTUgVZ73dNL82nGOc3IPPjatgjFBE/45XF8UjSvQko34VTcys47uKUBhkFyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yXwGU8uyy0dZxkEwhToY5DeNT/buBxRMpjokd2nYIy4=;
 b=H//lckTqVlMSQEKy/b5MHDGdk8/N4CE112A+TRg47Ybv8AbN+YFy0zqqrYxZtSRA6kYPhSv9+7eJ856wz34Ss1jt2ozo/UDvw/9VXREyGl1KQaISyw9w98Zakbvjeu2lnwA5bIMPgUAHyyy2XoRW/RrHrk41yNs2ZoufeHMKXSk=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6255.namprd04.prod.outlook.com (20.178.245.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Thu, 29 Aug 2019 13:57:32 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::e1a5:8de2:c3b1:3fb0]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::e1a5:8de2:c3b1:3fb0%7]) with mapi id 15.20.2220.013; Thu, 29 Aug 2019
 13:57:32 +0000
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
Subject: [PATCH v6 21/21] RISC-V: KVM: Add MAINTAINERS entry
Thread-Topic: [PATCH v6 21/21] RISC-V: KVM: Add MAINTAINERS entry
Thread-Index: AQHVXnG0+RGmJlrT8EGqnnEM4OKw0w==
Date:   Thu, 29 Aug 2019 13:57:32 +0000
Message-ID: <20190829135427.47808-22-anup.patel@wdc.com>
References: <20190829135427.47808-1-anup.patel@wdc.com>
In-Reply-To: <20190829135427.47808-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR0101CA0072.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::34) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [49.207.51.114]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9dec2d5d-8f1d-433a-aec4-08d72c88d66f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB6255;
x-ms-traffictypediagnostic: MN2PR04MB6255:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB62553627FB44D683E2DFEB3B8DA20@MN2PR04MB6255.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(366004)(396003)(346002)(376002)(136003)(199004)(189003)(446003)(55236004)(11346002)(76176011)(386003)(4744005)(2616005)(53936002)(36756003)(25786009)(5660300002)(4326008)(6436002)(316002)(6486002)(99286004)(6506007)(71190400001)(256004)(14444005)(6512007)(486006)(52116002)(2906002)(476003)(1076003)(102836004)(478600001)(81166006)(81156014)(110136005)(8676002)(54906003)(26005)(66446008)(64756008)(66556008)(66476007)(86362001)(7416002)(6116002)(50226002)(7736002)(14454004)(3846002)(66066001)(8936002)(44832011)(71200400001)(66946007)(186003)(305945005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6255;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: d8mXcn6pK2MgVT4izcAcvyIsHWOoBJrb4vY/SMGVhkv8dgnURi0zwRknu72EwT0uyNGJDDL6dEeWvbrOlHdba/3QIZ0m5a5tch1T9t/QyH3BK1gRy/wj+Q94Au74RQ4JcrB+0zI3L7sqH+b3hnz8qm9OpbDeya/8GbgKm5ONGjSMbCDDYI2xnX3fEi5UdeqY5b6QP2AhJmuQfwoQBCzYQOFO1De52Gif+7CP4Ia+m44/+mD3p5XMo4AHIi4ryIwe9jewwg2/GcVORYjSPKQN1aIcQbGAGhYUT/Ov9aPcy5Srho5+5FezOVPeSIbm6uhsOUwWcdF/cVFV3mcjWc8KmHTf6Sq5gOq3mcbex8KYSzOIYk5zSEgbNcCR7h970lfSVzz9haJjAGt8BBbt2CGCtm0VZjzrChCstZxelNa1sK8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dec2d5d-8f1d-433a-aec4-08d72c88d66f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 13:57:32.5130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F21pEVeZocvluRzk2w9MO1QDWR6Iq+9fjlyGd7/WsYPdK2Gk9EfEPe38QjOVnZ7BUC2Qk8JMxlL/fED8bRVQlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6255
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add myself as maintainer for KVM RISC-V as Atish as designated reviewer.

For time being, we use my GitHub repo as KVM RISC-V gitrepo. We will
update this once we have common KVM RISC-V gitrepo under kernel.org.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9cbcf167bdd0..b4952516fc32 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8869,6 +8869,16 @@ F:	arch/powerpc/include/asm/kvm*
 F:	arch/powerpc/kvm/
 F:	arch/powerpc/kernel/kvm*
=20
+KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)
+M:	Anup Patel <anup.patel@wdc.com>
+R:	Atish Patra <atish.patra@wdc.com>
+L:	kvm@vger.kernel.org
+T:	git git://github.com/avpatel/linux.git
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

