Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDD3C7EDC6
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 09:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390078AbfHBHrD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 03:47:03 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:64637 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390068AbfHBHrC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 03:47:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1564732023; x=1596268023;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=71PGVc9pxZZcZppnRkuckXk1U2lv7j4PsK4oBP562io=;
  b=j765pe4S1Uia5hJ8ybBahcIYTpAT4mjSfYZlI7a7cvYIBZ+B65AW3gtk
   rBveVF8cFC2ttEjugVcFXYjJPj1cXw1Q+OYt7MhVKo7TfYl3tsNvMla0g
   0HkbmtP2NfoG6S+5oLHxOyXGTAOnX1b02aqrqkH7C+2Uc16G/vqElb+Vn
   hMZvF7VeRLgjvE2BXshT/odIm5awXLftPjK8c+eeDJR+HxrSMOV7U9zcS
   66uOPL+HH3RPaGuiB//7novL3ohlFSl6kJ9735pEhg6013W5F54uyPsE3
   ej+f4JxZNgJFH2uULSnrnR+D2OdDZiKYvPL0VyQroPzwAg22zgRv9Yftn
   Q==;
IronPort-SDR: m6ct2B0LqJGqPSygCH7XsVjd93OH9nz0IAiBCR2PNTrdu7te2cbkf6+1PLsXIQTrq5jgsYYwqs
 xUmPeUaKtSKaGcu5PeYATs+aurqAog6IJgSwq8Yug430DQrJnHdtSY4A/T3SspsWXFQy3yBhco
 kwmbILlMuJv2JipldiQhwQo/GTuc2KbFmrwRLTwzTJJ8vThQ9XeEqNQf0oEiyQqvGHKlOpOctf
 Lw+hKsQ4saoecULosVuNYTpAkMImTJsYIiSl4RbH1Km7hyxzaPV7Hm855cPpuJhO4YiyujuL27
 NNI=
X-IronPort-AV: E=Sophos;i="5.64,337,1559491200"; 
   d="scan'208";a="116382437"
Received: from mail-cys01nam02lp2054.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.54])
  by ob1.hgst.iphmx.com with ESMTP; 02 Aug 2019 15:47:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JAbCVWsV7O3pK9DmjZ8yfIJJkC+aPe+3BZVi65xyVX5P8WZ3IvQQ+iZOlp7zvcCpIpcVh5p0nJeQnqllK+3LPkSBIF4kPhMvYKNH00+lblYGyZ17T5W7ehRlHEPMrB1o1kMkg8o+XfWMdUbN20iRexw/hk4rTZpL4ftiYdEb4yFLzjJxlQX8VUaI5puYhw/jiLk3jf7uCUugXS/I9fUi+wYtwCetqnJq61+mQTjje1i93ztsxxpp6Chs5xfZCi+79gGQJGNluWCvy98wgthDWi7aveQCoIUqZXgUPOco2rvR/S1A2B/REaxBQjbir2dpu41lf0rksBcq+pi0CY4a2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fyOTVUpilWpgvsgWDa70MrkgbiTndFWkKtVgmRK4xrg=;
 b=cIemoJAQU35MIFHxESVrwN0TOD5vNXBgcpB62WeJ7eonigW62Bc4BK914gDvehuh0H6mNXWjWmXPiZRXfzQ9F5F6xlG26eZanioml0OUmQr6TyGRmmjBr/5KAJbkTzv40a9FVvQ1uJSHpXaTe/v3iDwjVx8iaNotQ4K9KKJmHjksUOPDRWUwhp/ohv/nqwBSRldwgBgZ5QkvT8R8gFT9OZFDikBYmNPAgEic4CFpZE8o0gEtCPewVJWNTbwiJce8/nikRIZkGi7v4TRBLQkgh5ow4ne9LyraOzNGWOBtuLlRpxYV6KfYjH5wbWHqnbPTqSAsLo+P4WjQfZg5Mq6Hiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fyOTVUpilWpgvsgWDa70MrkgbiTndFWkKtVgmRK4xrg=;
 b=edqYqp3OhXMsqO3/Z2R0Gn5OBDVJBXcq6hL5AEJNTRGJI2H5Bum36rrHVF+N/OArFY6mSb5LfzVbppD9K1tBQ6lbng/+Rif5aQjO4V/nBIrklPcBJTQ6xuPpNoSbmtzS0j4SvBcK7hVQPeYSjQwWH/j1FfWBAmU0GhhSL7keP4M=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5566.namprd04.prod.outlook.com (20.178.248.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Fri, 2 Aug 2019 07:47:00 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2136.010; Fri, 2 Aug 2019
 07:47:00 +0000
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
Subject: [RFC PATCH v2 01/19] KVM: RISC-V: Add KVM_REG_RISCV for ONE_REG
 interface
Thread-Topic: [RFC PATCH v2 01/19] KVM: RISC-V: Add KVM_REG_RISCV for ONE_REG
 interface
Thread-Index: AQHVSQZ3sewhuHmGq0a1Tbk3FgkuXw==
Date:   Fri, 2 Aug 2019 07:47:00 +0000
Message-ID: <20190802074620.115029-2-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: f2cbf4be-825d-4c78-3238-08d7171d99fd
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR04MB5566;
x-ms-traffictypediagnostic: MN2PR04MB5566:
x-microsoft-antispam-prvs: <MN2PR04MB5566610FB3ADC245F4AB82408DD90@MN2PR04MB5566.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:147;
x-forefront-prvs: 011787B9DD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(39850400004)(136003)(366004)(396003)(189003)(199004)(36756003)(14454004)(7736002)(54906003)(6116002)(102836004)(110136005)(71190400001)(446003)(4326008)(3846002)(5660300002)(52116002)(66066001)(2906002)(25786009)(6486002)(6506007)(386003)(55236004)(76176011)(316002)(53936002)(6436002)(4744005)(305945005)(9456002)(81156014)(64756008)(66476007)(78486014)(86362001)(66556008)(66946007)(8936002)(11346002)(476003)(68736007)(81166006)(2616005)(478600001)(486006)(26005)(1076003)(99286004)(50226002)(256004)(71200400001)(66446008)(186003)(6512007)(44832011)(8676002)(7416002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5566;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gRIZEMq0d6V1tgq9AweNNqTB0/02MznKdR/+KTeIYZ7YWqCWj6UlxcCPxrBVSI6aGbyTQn9KEf3bk09rktpTXxCdxyNxQpxPGm5CFOg0NMtXIiFm8sJkiVTnqHq7xPV8M+XLH0mMctIX6UxfhBe/qLXSvfVA9aLaDMiSkipAiXvRiEC39KETQcyP4k0AoBuWDE9nPGhurUn5e4HC3rvhg/vLlli+mbEbXhquAS/yzgoDu6wborJKczvtmFpAo+N05sHuYl+A7KwBv7cIrHsUjb71XCuQRh7WdN2PcFTX8/yR2bdWbTG3kyPOVGHHl/gCjfLDJux77kxqO28xmt75UjNl9Js/Me51weVeBM34NNCeC+g+gVgYe0QHOhqQgElLXJHRX5l65/WUCK5sDGGzXz7HhE35Ry5tqC7Ex2rD1n8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2cbf4be-825d-4c78-3238-08d7171d99fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2019 07:47:00.5220
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Anup.Patel@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5566
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We will be using ONE_REG interface accessing VCPU registers from
user-space hence we add KVM_REG_RISCV for RISC-V VCPU registers.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 include/uapi/linux/kvm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5e3f12d5359e..fcaea3c2fc7e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1142,6 +1142,7 @@ struct kvm_dirty_tlb {
 #define KVM_REG_S390		0x5000000000000000ULL
 #define KVM_REG_ARM64		0x6000000000000000ULL
 #define KVM_REG_MIPS		0x7000000000000000ULL
+#define KVM_REG_RISCV		0x8000000000000000ULL
=20
 #define KVM_REG_SIZE_SHIFT	52
 #define KVM_REG_SIZE_MASK	0x00f0000000000000ULL
--=20
2.17.1

