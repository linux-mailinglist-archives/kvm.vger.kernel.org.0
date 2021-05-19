Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2EB388597
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 05:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353290AbhESDjm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 23:39:42 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:8529 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353297AbhESDjP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 23:39:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621395475; x=1652931475;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=fLCyzy/BhaQ3dhs6zdtElm9lnLeMsgx2cA8gJo/GNNY=;
  b=muUBaGtUGpzusyPZ19OEgIRwLYzEZHFvtjIspyv3Om67qK2Lnt00bNWR
   LxJAgbN9CmPJEkgXzkhldCDzxvjQvhdPS5PBn7LZ6eNnXivbXRXF/v1T1
   U2uhJX+ao4b/7hurA+SwXLMdVbkqzZBQ829wEzWCL3whRgYRcdLgKNdy1
   JrAACkUrsHCGMd06M+OzAy9OhgUieDL2oMgRZMotodQXkQ6Z4tMeoyrqT
   jC5e9YXSZrryEat87FcFNCAg+/BDf4TOKM2L+YcBiK94FcxgP1Brrae96
   YJOXVruvgaT1VrMcI2JLGJg80Zmd9aJzlGKioeCAMlqmWBWyNZixhHlHL
   A==;
IronPort-SDR: /XWT0jodwqdL6x9o0UTr7T9h4fhY2hWpWcnjgm/GI+Eu6c0M0QdHb4I3tKZdsCqbd3n5t8PLCx
 98rPtsOXF2Zmjxp+EQS9Q7CNPtuU5FBt8RLjVyYGM9ISGqj/UIeMl7CvQhY9YrDScZHqkVf1oC
 0wGkxKLBPw3QZn1eiWMCkjv+fHXdGWcILVHI4/fnY0YTPsb5adw0Jv7bGqsIVglZ5EPUE6aABY
 k7/W+AFBmfwzRzwG0LLn3LC8hhieejY4WiLyzP1/Tr371lxLvr5Ve4FAUxJFhClqwtFQ97xnKZ
 Esk=
X-IronPort-AV: E=Sophos;i="5.82,311,1613404800"; 
   d="scan'208";a="173270056"
Received: from mail-dm6nam10lp2108.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.108])
  by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 11:37:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nsaAkzdJNhhgLjAikT/m8oB8rvtQqD66bvT7vLhoyfNdSo4meVOUVEcw7XKAXmSrh6Bh/nhb0BgI56rGYcMOQZGjmAPfaalkxxl5KFdKYO+7geQAjSK2HmDEw9NHTblty8sowE6By3hB9rHUrvFOdI8N0Gz4+Ax1iYGNd96DTuxXn8ci2s4PEDuXGzmuBavRrm8gFHxa4FdlSqBG7G+8GcNeMrnFEKCPKRjzYA+axp1ItVpcSH1AjjSdS1A/NF5eMqAbDP8d8KYqBPnqu+MKVM/Z+hH7AMtlqW0g3WqneNH0dnefPghYowXq3txuSdcpJoND7ai9GPh6Jj3YFVK5jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sfhzEBWkNqn/MKknPu6wV/JX0/k2a28Mxv8yOonECH4=;
 b=Yr65hBNXNImsLcId4N5fKkDVGO3akQ3AhDNoydmLk+H1DcRTJuuN/ydzcDn411bO3LoPWGia5aG6jUmWlU9mIw9DpObYfYAmCQLIcd3WWxLj81dUfikX/JrrKukpK9+BVvIUqCoP4DnOxDqCq5OMImnhLN03o1AE7JEwMQPkkJaYIHXloVBm28emah6x6uoTQAsbxzu3tySCCyQuvx9XtWDD2Rdmxtc+3+F2tdyw3ymTKcwn9b2Xn35KxsrUSIJSXZ0Dqv/3s5XmHctTOq7wjPpoZG9k6j/m40fZQ6GBoJOnSnEQPKmok+c30IIxfPlm+IHiM92aCYLvun2+08ajnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sfhzEBWkNqn/MKknPu6wV/JX0/k2a28Mxv8yOonECH4=;
 b=lCJ0HhnF8SVkHAWyVup6sevKrKZn9/SccDEAGKyJ6YRFcpbxoGF6E3dTlslgFHNR9MMGE0CAfwumpzxcr7kXyUTMm5uB6pWk/MEAPEEjHDq/Kdy1W3l0b+arBgi66y9uDVzq0HG6YRljssuUYAMA5KWNYZerHPZRquPO7g+2880=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7745.namprd04.prod.outlook.com (2603:10b6:5:35a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Wed, 19 May
 2021 03:37:47 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::88a0:bf18:b01d:1a50]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::88a0:bf18:b01d:1a50%4]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 03:37:47 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v18 18/18] RISC-V: KVM: Add MAINTAINERS entry
Date:   Wed, 19 May 2021 09:05:53 +0530
Message-Id: <20210519033553.1110536-19-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210519033553.1110536-1-anup.patel@wdc.com>
References: <20210519033553.1110536-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.179.32.148]
X-ClientProxiedBy: MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::19) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.179.32.148) by MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend Transport; Wed, 19 May 2021 03:37:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac5e25ee-15fb-41bd-eb74-08d91a7777f5
X-MS-TrafficTypeDiagnostic: CO6PR04MB7745:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB7745C1F619ADC5877DABFDBC8D2B9@CO6PR04MB7745.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AjIphE6qYEIT6HxeQT7jwJGJxlEYa7YrLGDio1Z80iA05we0HwTw01pf5UX1B45rBp+c+h9snzYMosHbTczdA2XWrfRqUf60bcZ3qjUtcMVTa30ZXSWToKtkQkttbJYX5dcmWQPFjoJ6wfx2uY62TaBS5Dof86c6onuJ2BFTRcKSLvBQwGd4slzarwKA585vN6Fp1+PxBYabaKZUQoUud77xDy2FcPMMYH8WxP5QEmkQlw60oAeL9WU5HTTtsX7k/1h1yTAh2K0aX7jBJCxCw6vj1q2Q+aCR5ZTGaq83yrLlvUZ6IPivhOGgCb3O/bMp6zR3sAgAOdcwJtAcRofpehw7FYT8HM2sesdIKMmZ4phT+fnCWz7fH4I4+jj6e2v9Ay7o0QzLBbolTCzDsLShvl7PfPho+qGW1uyRs93rHoNmw90diewMvjTMq1gW6wUjqz1eZ2asYRq1yCmNwTbmbSdCf0CbRlGwtdOQXqXbO3RlpX7G81VGP9xGGo7zRfXCAYOR9THuSz/j3DlTS4ovMxR6cCn22VuC6B9wJQcfDi4nillHTZ8MVr8r2gnmfk8h0+6wumQsLbkEgHyORjKoLDCNoQXwV9VOMc7XEYBjvM2tALfJZTNKVNzih5ABne1IyW8zRr6F77epFTwAN7/DsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(7416002)(1076003)(66946007)(478600001)(2906002)(186003)(956004)(2616005)(26005)(16526019)(36756003)(8676002)(44832011)(6666004)(55016002)(7696005)(52116002)(8886007)(86362001)(38350700002)(66476007)(4326008)(54906003)(5660300002)(110136005)(66556008)(316002)(38100700002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6Nh8DLHGcX/QhGffNOjC+vpxg7gkTXsYCCQqsJ9yn2Z0DBjF1kqm7WpSmZW5?=
 =?us-ascii?Q?bXKnBXY4SkMdqK6ApTH228M27XqRrCkBWYlfomp+tcGVjn7b/kkpOZb1Avrr?=
 =?us-ascii?Q?yghdGLWimrPK9OMAxZQT/q983EaGANgzuAr3UG1cQ+sidg7EHul/MsNQFBqo?=
 =?us-ascii?Q?Rn4ZlfuRZgEvmq39GUobDF+1mr0t10P6gzVYkIPmSFp0iJ67hq+WOfsc57if?=
 =?us-ascii?Q?vByvVUTin6499lIh8vunPvDGNV33JVDEwI45rDob60k55lCzzUtEpn6kFgKj?=
 =?us-ascii?Q?sFMfxWai79fV6n8Nb9bI5y6boGcvbjdF4hbH6QpECAMCrhKhLR8rLR/y2ngW?=
 =?us-ascii?Q?Beun+xYp6S4JaVZ1FJV8aEeDr10z5YawsA05hh+bc3OEVBQoc/pSPuelxR3g?=
 =?us-ascii?Q?LSGNITXVirQPFBKkzfYbtJPl/IzFpqSzuK7/+sJW7Grkhh6tKvxZ/mPmlooV?=
 =?us-ascii?Q?H5y05q1CkVClJdH8VugCwAjhqU3AMP1kKmQLPNG2p2e4T5MY5KdHg6/0I3H2?=
 =?us-ascii?Q?NeFQNle7OtoSMaxWNKIppynHxF+FLayWpA9a46ls0FKpJskmR5qQTrTRbB5V?=
 =?us-ascii?Q?wBG3ka7MP+mUh4MO/E06sTnDssHmIOVT0kDaOa4IMnH5Etow0I49kOu1AM+5?=
 =?us-ascii?Q?SD+H1uOQPpR8+9qzdRWKRgPYm+TqSaWSBJxgoF7FM15VN03dWg91Vy/i7We0?=
 =?us-ascii?Q?8CIuJzATNL4n4+kArwTL/K24nwzvTA+u6T8Q1W96iP3EJRT4NDmNAhUJGjOd?=
 =?us-ascii?Q?oyxzEnoLEPjVwneB47PACEg0AF7zgPGmw3wuqrpC2ICSeFj8RT9MkiCm6YHg?=
 =?us-ascii?Q?/ATTA4JRA52SWPDsiWGnc8xsMjLKeaNezREsWe59gzE1RonEEKFddGyPLeNB?=
 =?us-ascii?Q?n4vE4XPzhqlNVT3lZZmRGoyEVFvAunC4UoAkOtsOicPg3rq9XdEmBkdwoqGx?=
 =?us-ascii?Q?AkYrL7dV3UfQKv3W/Y110rc3p1x8BHy5GXL0JyQCWlSYTBeiDv1dn1XhqjKV?=
 =?us-ascii?Q?4HSlz2YTDsIGbhvZJXNowbomFtxOqFFm/YGBqAAtXV5PlKFiS9g6csjSpK3f?=
 =?us-ascii?Q?Tfoj6ngx3A4etN3pppaY0HNjFhPU4jR5vgkxM1xibWWIGqInbX72Ze2SUhJl?=
 =?us-ascii?Q?SeemJOTrkzDzMuEkh9+lHzRocpkGeMqqcZ0fQd2XCilUPwVUq/a3ROa4ZNJS?=
 =?us-ascii?Q?xqBaoOvOyNTMN18Yj4An1dPruRGzi81+wpYtWPe0Eq6SAkxcIcDkt8ROK75F?=
 =?us-ascii?Q?gQtvuCiwv+ftkxMdSgWA/rQGLIN9XFugOR6hpE8BZ7xwDoYykBkqprk7cM4t?=
 =?us-ascii?Q?7neAlGI5laCVLPzdQLV6T6rC?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac5e25ee-15fb-41bd-eb74-08d91a7777f5
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2021 03:37:46.9733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7qFPDMtde+a97607662/7qV7NE/baU+WXi0DpsvxJUvnWWtlldySoRNp4JkTP4K7KAohjV4DlBDaEY4IJ1YbkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7745
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
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 008fcad7ac00..8a54857a383c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10009,6 +10009,17 @@ F:	arch/powerpc/include/uapi/asm/kvm*
 F:	arch/powerpc/kernel/kvm*
 F:	arch/powerpc/kvm/
 
+KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)
+M:	Anup Patel <anup.patel@wdc.com>
+R:	Atish Patra <atish.patra@wdc.com>
+L:	kvm@vger.kernel.org
+L:	kvm-riscv@lists.infradead.org
+L:	linux-riscv@lists.infradead.org
+S:	Maintained
+T:	git git://github.com/kvm-riscv/linux.git
+F:	arch/riscv/include/uapi/asm/kvm*
+F:	drivers/staging/riscv/kvm/
+
 KERNEL VIRTUAL MACHINE for s390 (KVM/s390)
 M:	Christian Borntraeger <borntraeger@de.ibm.com>
 M:	Janosch Frank <frankja@linux.ibm.com>
-- 
2.25.1

