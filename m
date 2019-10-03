Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08F6BC97D1
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 07:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728781AbfJCFI5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 01:08:57 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:16284 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfJCFI4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 01:08:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1570079352; x=1601615352;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=e4IeyBIoCbMLkmvC4pIlXMoWK9e6hQZ7UT/EejEs+y4=;
  b=LVqu0gQwO3Fg+uDHtXcqbcVXJFDvC1h1AI6NOztexJmckgr7qFn8BFvu
   7AfIzrJPMainKVMGOQ24+FejBOvPEXcevgvWbQivTh8bcVwQDXaZw1Dp2
   Y9GvEpO5xfkfet4B/43CWvLqs4n2YW3WNEaRppNaI8I6Eh27yTieXiTXf
   8NJNM9K1BlxMysisv3AEvDWiZBaJRuIXjcwBiZDQp90sscE4+DSNmnC73
   oax7ExWvRMqQWwAK1YPOrW47HdfTSF4uGA1XRArxzWfuEYNaCVMqCKAs5
   SxskLCPs/8BNLvKPU43x20ArfP0H33MnU5XUvhputGFCK9loHeuu4U6Zp
   Q==;
IronPort-SDR: 4tlD4bsmYFAIQDjrP7WdWT/aiT2Y3SvvifAWDOe51bibDY/YvB7tL//LFA4xqEKDyLWc2Umk9G
 V6GvOaz+n3DFJR9fnNngjvG+wbbHCJpDULfJzVC1EZ/Iy86hVD1md/k1gPNzuNVPwydTAK1FqH
 3m95RTidSsHLCsrlRejDa0p6i3Q3DDmoMYzYQ2vgbrnRYG/xBoJDs8f9LgLWCOLYknKu8Y72Nf
 c5PMYmWgd03mILleiRAk8wfF5TTxK+eN4ybzDhGDkGotBTDwFe+uKZuBk1y2gsSqIMDB+0zAck
 NdY=
X-IronPort-AV: E=Sophos;i="5.67,251,1566835200"; 
   d="scan'208";a="220620976"
Received: from mail-by2nam05lp2051.outbound.protection.outlook.com (HELO NAM05-BY2-obe.outbound.protection.outlook.com) ([104.47.50.51])
  by ob1.hgst.iphmx.com with ESMTP; 03 Oct 2019 13:09:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j7yLgKv6ZNBygPrwWV7Pfr3306SfWS39Eq5zvfnGposN4zxQMnzplqYP0Sl4cs7FZ8QxNLF9RcxUe7HOxT9pkFNV7vNYrtBckppEHl8W9HIVn2iq3JGq8+Uci6apADA0OW145DS/GSzerqPExE9iU1hi/PgkBowIHzDzBMQIu1Q2VS0NFTeVMCBgaCTVcKfrmOTbOac9/sI0dYjmYHow6Xu4EdpatGuOkYt++PTi16vIdu7iHwKO/Qx61Aj4ARyNWNuODeSnj8/hx7nEBFvh1rfaxRoDDZarmj9V2bpD9zM04EgtxDLUKRg4ERxYjF1nddd4Jx+GPv928eQexYFIUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eyJioRD2MCDWcOnHG5aafsm4TsMtXV13r+iC9EJ4k0s=;
 b=HA0MQT2KKf4+7KVzVhHMc+O55yiZfJnsFD6IdMwBJCssBXNRXCMv+Ywy45xstq4WIGAbhx1kBVLcMDwyoLrmslWY0VKNKjopYEysXP0oZ1iqE38FvCrB/+zBaXc3L0+d9BsRQzwO8kFl4Zcolch8nLvAXtvM1X8ByYOUFTavnFVD3EIdyYABT4T3XaoWJ0cAWGUX7lNJectQQR32VUYnSRqwUiew+vDyb42orpTW98RQ3Sj58mZUcy/pu6ILJ+5IVCm1y9G+2O0RHtfXPEbHSsvMxHRSzUC2Skx0xTqAfSWVw7C6X16PeEm9z7nCtfVt+N2/FdwkEu65uB1k0sfddQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eyJioRD2MCDWcOnHG5aafsm4TsMtXV13r+iC9EJ4k0s=;
 b=ZVsrMi0x0byPiwe0ezRmyel0UF1z1Ac3M4M9pek1sHa+4pqjLtQ1fP92L1DOzm+nNS0m+Pgc/fDBEtTw8HtJA8HT9s4iBekOyEDqPhH5jYy14J/1OcxWFlBdpH1VUnJHgO+AM5vRaxe8WzTxUyV09K9Ts/bMVn1YgAnYjcQ38NI=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6272.namprd04.prod.outlook.com (20.178.248.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.17; Thu, 3 Oct 2019 05:08:49 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a%7]) with mapi id 15.20.2305.023; Thu, 3 Oct 2019
 05:08:49 +0000
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
Subject: [PATCH v8 19/19] RISC-V: KVM: Add MAINTAINERS entry
Thread-Topic: [PATCH v8 19/19] RISC-V: KVM: Add MAINTAINERS entry
Thread-Index: AQHVeaikWtIEjYUkWUCF0M+05pNo4g==
Date:   Thu, 3 Oct 2019 05:08:49 +0000
Message-ID: <20191003050558.9031-20-anup.patel@wdc.com>
References: <20191003050558.9031-1-anup.patel@wdc.com>
In-Reply-To: <20191003050558.9031-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BMXPR01CA0030.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:c::16) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [111.235.74.37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 898c908d-4b2f-44b8-e093-08d747bfc678
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: MN2PR04MB6272:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB62723F00DE83F0452D8FC8C48D9F0@MN2PR04MB6272.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1303;
x-forefront-prvs: 01792087B6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(189003)(199004)(6512007)(6486002)(81166006)(81156014)(8936002)(6116002)(3846002)(8676002)(50226002)(2906002)(110136005)(66066001)(6436002)(316002)(66476007)(66556008)(7416002)(66446008)(36756003)(1076003)(5660300002)(54906003)(4744005)(7736002)(305945005)(76176011)(25786009)(52116002)(256004)(71190400001)(86362001)(99286004)(71200400001)(2616005)(446003)(14454004)(476003)(102836004)(186003)(26005)(11346002)(44832011)(6506007)(486006)(478600001)(4326008)(66946007)(386003)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6272;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lHMapwfuiL/3qCE0E+2DdpqR3s0pJhIuJW/gX3ZU2zKiYROh/Ei9ubZX8q4c3uNffNCXUcf7r4VTGXy7Hdb/1ahTbcwV6bW9lFgbR/zmQVaylTLPuFc7jlJWYVfOe2o/izux1mUEDV+v0Irtlqglwm0y+Ov14YNUV+50YjcpKYso3UGJIjDEXw5IUuIOJpHeLKm5VJwcymmC6g3JY+FPD5vl398bTogfJeELdMNgLiRmCrYheIyWavNds7xHL0btftons95lFyC+LgunTyW0UNZCVy7MqanrKTpisPUxEdUKje24pNK2P/l2KTB9yS9kK8Vd1fMX3ZWDAsJTIYjqiPS9hH2SRLSddfydlZDRiSCb9CKcl4nVQHDGa9w24h9VU2cTDC4B8tEBuRPjdJzJpS1HybOd1YjEcfu7w/JlPeE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 898c908d-4b2f-44b8-e093-08d747bfc678
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2019 05:08:49.6027
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Iz9D3tn/CVFBPzlqU3vMOwTAynoCvpiHEOFsptDPoeuwR4Pb3ak2We3T2AHqbCNku+4ksOCfGexBcqVBHtCNvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6272
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
index 296de2b51c83..67f6cb317866 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8980,6 +8980,16 @@ F:	arch/powerpc/include/asm/kvm*
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

