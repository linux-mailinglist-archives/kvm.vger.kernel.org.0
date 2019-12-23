Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7F8C12954C
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2019 12:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfLWLfV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Dec 2019 06:35:21 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:54845 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbfLWLfV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Dec 2019 06:35:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1577100920; x=1608636920;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wuU43oZgM5pi7IW3seFwkRJcfftUaolqELEvKyIjWj8=;
  b=l2Kq1AU8UG1zGRsuPFBM4cgD+Sj4+tJlmyBC97DXgDMZxM1o08MDjQC8
   AyCOxXVYuj+FDjglTuvWpifHQFVIZaoEC7oq2CwpKCxoDWBjM/pRxV2qa
   lZ2CWWW/eOKZ8GyUUJa1dZqWWZRpRAAnTYQM37Q1uVRDnSIcEoXSQwJxm
   rYuMMlWoi/ZLfZm+3WV2A8dj5xGPv5UYDHRjGr0NWFdhexCPp8wNrpyql
   Tj7flCAJCS7QHvIyhJaWqvUJy/hc/dE6IKvKDM602h+/7+VXIzXF8hdZa
   hqVcudrC6hS6C/whKZc2nbv1v7UQJe584+dWq/AI4JLn/z//uXs/ctkjf
   g==;
IronPort-SDR: me8dGJimnf1wfr4rQvBQK08QmPGugfcuYsHPcOBC3tN4bQozXieYzkWBd3+oXYVZEYfDSBhY9J
 /k76Inc7NVE88BKmVK24PMvFGVHJ8aCLzITb/VmEu74IoHJ8Szrd+MV36UYHy0tUbSSqufdocB
 aC1HU+WjzHfGpRzlWzT7Dh69oPmYgFCH7zXhWE/FVH5Tv8CSQdQOvJoZAToRjoK5FhlyhTtEgP
 mIeW34uNEzlW+ESJukBkdRmBudlFRw3vnN/i46aNcoDYwQvleCQzX73XwtSZsfIP/oka1bxQ5O
 ikI=
X-IronPort-AV: E=Sophos;i="5.69,347,1571673600"; 
   d="scan'208";a="125956073"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
  by ob1.hgst.iphmx.com with ESMTP; 23 Dec 2019 19:35:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kFe1kx8mMriJCmXuX1ArOJrfd6lBo1D5Zskv3hA1jLouA8MGibFehpp4SXV74otQ6CYvmHkpMyfQqM3GBKSkmuuRujFHI7VrICbKnXCq8s1rsqam2ZmngnONNvv61pcRycaD79604LSFiOmtrQSbCbQ9EkhzihVF4/nUXNe6oyOizxv/uzuQqvCzm3lJ95GxGyeM0DO7tdHlv2zZSp2yP3v82j6w8XcsQ4Umbh8pTCSypvMQnr6OMYyEBjLHd2OcJguPqDXE+5+s3l/GohVttUkpTM4yXa+EcVqDTknUjx/LmvWX6dWlbecVIMpeqO+MFC2s+/OJRHLDWeayNyXXmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0SQlhDbgkw71L1UeaM2aFp01+V1VKFPbfHDGYfhDMg=;
 b=kufhpdF3XGTBlomt70W7nDe20YaWj+alu7HyrqmNDTdB9ZLgPdjK561FEZqrtPQsosdla1pORZTMmmwwUCA7PL6p904eerx89pfO7MwCNQVTaWGMTVJ0tV7ur/gO23W8mT9yhXjfziuqDDlzlh1ttocq93ONgOvpe+RqMt4ET5OQAeErZw4bmfmSc64aPY73zGEvuzAmyD36zHK1kyoszr95iJzMKSCgIUrqadmXg5Hrvi3yqLAACCTV1/F8ZPDjwBeJqZbj9pSdFJZkVGE5PE02DhN2dCgN0qxZUWytZ7GWrQTqm6dhEE6j1ogwwZvl749LX8TGz4owM0uYD7xu6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0SQlhDbgkw71L1UeaM2aFp01+V1VKFPbfHDGYfhDMg=;
 b=bUBsfa0xgOGnERnQesXf3x6Zhfmh3mhT5vNPFJ+d98mi6LabETY2j9dA7gRA/WZ9UKY1rKcUQqtlYWIVGPpAM5If8b9OaesFw+IFg68drrsYjkihjHGeTLgnx31VUFNQIlEs+lDw8X2CDsVWHmp3ST98kV0iTB3RnpViHNxxie4=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB7072.namprd04.prod.outlook.com (10.186.146.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.15; Mon, 23 Dec 2019 11:35:19 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89%7]) with mapi id 15.20.2559.017; Mon, 23 Dec 2019
 11:35:19 +0000
Received: from wdc.com (106.51.20.238) by MA1PR01CA0077.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::17) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Mon, 23 Dec 2019 11:35:12 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
CC:     Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [PATCH v10 01/19] RISC-V: Export riscv_cpuid_to_hartid_mask() API
Thread-Topic: [PATCH v10 01/19] RISC-V: Export riscv_cpuid_to_hartid_mask()
 API
Thread-Index: AQHVuYUNsIc/I9RtAkGhAPMN++8CLw==
Date:   Mon, 23 Dec 2019 11:35:19 +0000
Message-ID: <20191223113443.68969-2-anup.patel@wdc.com>
References: <20191223113443.68969-1-anup.patel@wdc.com>
In-Reply-To: <20191223113443.68969-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0077.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::17)
 To MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.20.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 642ecd67-0b53-4d7b-5228-08d7879c3007
x-ms-traffictypediagnostic: MN2PR04MB7072:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB70721C26597B86E620593A768D2E0@MN2PR04MB7072.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 0260457E99
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(199004)(189003)(8886007)(4744005)(478600001)(52116002)(316002)(16526019)(2906002)(8936002)(1076003)(7696005)(36756003)(66946007)(66476007)(86362001)(66446008)(26005)(64756008)(66556008)(4326008)(5660300002)(8676002)(186003)(7416002)(81156014)(2616005)(956004)(71200400001)(55016002)(44832011)(55236004)(81166006)(1006002)(54906003)(110136005)(32040200004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB7072;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZfXvDjXqL3w+D+CSuozi+bAvtBFwFox+LXunTOMH//OMnVnPOy5cXH6S8Y58N+OzoBdvUnJb3gZV0QIuSu+9tayKihygjOnQhTzgILJd+AstyCSnDg3ZatJZz8GEDj03ACNuZqwdraEZVdvTp5tZIx+T5rj+x66RC1sZgx29uhkxcixG0uPV+cxtB9PuJtjNnoN19Bp/khiX54Xrf8GUTYSARRE1vqkz+mk5DUb5eHKXsMUDBI221v1GJyOW/WUszAbrvIIuwqShFyDS9PQ09kqQ3lGrmg+OdNGLdOuYQDmStaVclsmwPqKyC6HqVLaKf3aNG+lUk+t8KXkyjukJCeUX5cvFyRdP/tvupKChT+m/1UYHsKmIUGuCUZ88i7S0QliVXKqU19lXNAYyvrLxzz7+KyeG7WCDDlk8amhx21DOAOOaJxqlmSj+EGvmKyF+PR6QCBNmLL3ljdUl2uznCO8U/uuiMxfUV80TMtPXlOMZJoEUOPMF1kp2XhhYAOZq
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 642ecd67-0b53-4d7b-5228-08d7879c3007
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2019 11:35:19.1366
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wQQJszAzQ+/avRCNOFa5gezE6xOMwLzkTa5Oj3kAsJ78W5m9ETz6eyKAirLZL3D55X4ASMVoJI/mbiLBso92kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7072
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The riscv_cpuid_to_hartid_mask() API should be exported to allow
building KVM RISC-V as loadable module.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arch/riscv/kernel/smp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/riscv/kernel/smp.c b/arch/riscv/kernel/smp.c
index eb878abcaaf8..6fc7828d41e4 100644
--- a/arch/riscv/kernel/smp.c
+++ b/arch/riscv/kernel/smp.c
@@ -10,6 +10,7 @@
=20
 #include <linux/cpu.h>
 #include <linux/interrupt.h>
+#include <linux/module.h>
 #include <linux/profile.h>
 #include <linux/smp.h>
 #include <linux/sched.h>
@@ -63,6 +64,7 @@ void riscv_cpuid_to_hartid_mask(const struct cpumask *in,=
 struct cpumask *out)
 	for_each_cpu(cpu, in)
 		cpumask_set_cpu(cpuid_to_hartid_map(cpu), out);
 }
+EXPORT_SYMBOL_GPL(riscv_cpuid_to_hartid_mask);
=20
 bool arch_match_cpu_phys_id(int cpu, u64 phys_id)
 {
--=20
2.17.1

