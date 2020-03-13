Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E445B1841C9
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 08:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgCMHyH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 03:54:07 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:8994 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbgCMHyH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Mar 2020 03:54:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1584086046; x=1615622046;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=VFBfR6wZK6/1Knu7u14dxb1J4sXhHSDDm2X0gyo9rcU=;
  b=fxwdOuE9zeR8LZfdSfpKLPf+EsNBAxJFsE7ovFrAxJ/kKRuCA2VMDzfZ
   u15Yl/hJDx6z2IopAbA5Ou8YXmVyUTx/uaS/02OlZhfj42ydhgVDzYGBA
   YvlA9E+g1OuUs/VVOIVYQydnV+YnW/dX+FaRQo95+rP8KiH4l+IAM7G45
   M6jnzKeSjNo/7kjzKignZX+9EItxijK32dvt3nHieNEtcMeubjMwGGX+R
   0yfuO9BVoDF81FIFCDfbg2J2x41Nx7aO89RdRk3hshti9GcGvKrnO1PUE
   7w9kwv5ROTL1ue0hELYD3QvawBOEJQgyvopASqwcjsvcC0SqntMcgl1p6
   g==;
IronPort-SDR: U+NLv6gbB6NL8P6FKCitzycZojYtxcxY+n+I62wiMcmHPRutveoP/JLpHDhM+4DvQlebFSl7TL
 ZVztSu1v3Nw/8l66O5av9BT7suxXYlF3m10ppUBVupHyEZd/Gi5lDcJeITai/jW93+R1UTXtWq
 ixB52KVmfxqtqh1K78+EFaqwXj7Lr+HPwECwx9+6UdrEzFF+xAUNfF64MYesvxxYoULZ8jslP3
 oOszTz/g92bHWdphLm3x3OPLlKEdf2q9uZ9bTncjVFct8fHGkk4Vdl2noU7yr1dcEH4kxMXaxc
 nXE=
X-IronPort-AV: E=Sophos;i="5.70,547,1574092800"; 
   d="scan'208";a="132827596"
Received: from mail-bn8nam11lp2175.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.175])
  by ob1.hgst.iphmx.com with ESMTP; 13 Mar 2020 15:54:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c19AoK8m85PTORRg6ELSZ5jbqkK/RZIzfA9S0jEHuLekuWod++/qWX0y6agosl8wmijUb0/B0TwrVGZ4jzF4H0NSMCJHHLk4GPREKZg0sVezU9wXt0f8taWWEDdHxxrHC3bhy3ChogSlEj1oMrnDBqAUw+p0pO+r3qJpDBErTOjomKOWne5xLqXJ58vc6mwL0LtXWrAqQimf1VsWo5b1miqA3W/UgFWau0JFMQPg3ySpUZiTP9/t4knd8lYjS209tn7EQJNp+7jddaUnZiYMsmgDp7lExWUaKtxkdVz7sSpLkMzRVyR25VRItn1YLVPpGhlxvIxdvo2qc11JMZ4GHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PA1UOWuzfjLenXwC+59ong8v1PWsWD8rFkbbhp15w3k=;
 b=bLN/4C2lpVK/cjK+kW6lh73K5dxfF8uxQixa4vkv4ZBtkRDecZGs5/XFX7mR3oyO2r+8KZYLqxi2mXoeE/oD2BWekHKlN/GRHL/xf6wGTj+21PyVrtCLMAvndSGI0wqC+NjEFyoARgzs9JKNpmUOazI0LvLxHcxqwl2gxy+ydcV6QZk9tILovmvDk/MEfOkix709M/0cBwguvNZocBlgjDrWW7o4idtfKtIuddrmXUORTCjvW/DpLhFrzlp79ERDCwiT4hArWGwpdSLMko+Mc6yEAhUVAcw7EOiCM2YpU8F6HTH4La6KcDXojXbNevtNQyqeowLFMl3JBCkkVdQOLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PA1UOWuzfjLenXwC+59ong8v1PWsWD8rFkbbhp15w3k=;
 b=bjzGO2+3oOWrHm0yBuhbePZpuNX2mX9Gwl7yaGvh3oEZCxVQ5CJY3VfO/sPa188kukdkNTahGzNOTFl1ejBykXUg0bpKMsqBTT4IT8x/3llpHzHSWMISIffPopWEkG8Hu8Acz3xitjuo0OLib61uRh6puknzq17Z20H/9uxtiBs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
 by MN2PR04MB6637.namprd04.prod.outlook.com (2603:10b6:208:1ef::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16; Fri, 13 Mar
 2020 07:54:04 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8%6]) with mapi id 15.20.2814.018; Fri, 13 Mar 2020
 07:54:04 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v11 03/20] RISC-V: Remove N-extension related defines
Date:   Fri, 13 Mar 2020 13:21:14 +0530
Message-Id: <20200313075131.69837-4-anup.patel@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200313075131.69837-1-anup.patel@wdc.com>
References: <20200313075131.69837-1-anup.patel@wdc.com>
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::19) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (1.39.129.91) by MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14 via Frontend Transport; Fri, 13 Mar 2020 07:53:54 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [1.39.129.91]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a5a23e3a-9e1a-479f-15ac-08d7c723b300
X-MS-TrafficTypeDiagnostic: MN2PR04MB6637:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR04MB6637A4245FE2DB37183ACA6F8DFA0@MN2PR04MB6637.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:331;
X-Forefront-PRVS: 034119E4F6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(199004)(6666004)(1006002)(4326008)(8886007)(8676002)(81156014)(478600001)(7696005)(5660300002)(8936002)(36756003)(81166006)(52116002)(1076003)(44832011)(66476007)(26005)(4744005)(316002)(66946007)(956004)(55016002)(186003)(2616005)(16526019)(54906003)(2906002)(7416002)(66556008)(86362001)(110136005)(36456003)(42976004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6637;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jcm6sSM6Y3oXtMIGwi9Cu41/EF01TF4q1shsNiwqcG93kdzlH+lzvyHbNQ8U2R2TKulNm/NXkwKqcRZNClIYCGnJPf4jiBoVLkKJe64MlkGABZLglNBBNoTl0mpMsE7V3ipMpdrxcoLaGHoT/3uKQvkvMBj9IAx9xV+UYofkl4+uj+OmR5OkgnnYMEpQVlx17GdkqYliG1dgSOVvnM8ci47Ra7GOM63kxQWoZaLVNha2/Hsnazu56Ml0qBOpv+8ZuaDTmboGSv303fA7pLSnf7ctOu4Bna9RT4aSxcZmOAFA8yYT523yF/GOt9b+b71K9BrdMF41GBJPLPc3rrzRgUBXmq2bna1L8hU6QS1hrR2azzQR/3ffkP2K5yDojPQ9CzFXlXJStbkBbGXmo8SzbqTsYq1U2Hz79psHFvrT2I/CQnCid+DWwIqi0JwJzsQVKBtXketfYS4GjhgnuNDuJI3PoMO15sc3c0vv/+ZyWOyZM/hXABGMGaLjF2aZDUZ7b1LkvwA5tkDoCZaZwKIsrQ==
X-MS-Exchange-AntiSpam-MessageData: B/jZTfEvuTcG/Of1b/jlmvdEgSfqBl28F+tDrq+a0jnpEnq6xd6Lmbk1+q0UqDsHFv7QLOS1WtKd6TeAsUZnPHlqph62pVYylYYHfx6EngkEltBU981kwrTvjJBmuBW1+g3p+fqq5WHmAnoVVTLNtw==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5a23e3a-9e1a-479f-15ac-08d7c723b300
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2020 07:54:04.1891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bya1LNE00Z2m7yCYYaQpYhbXE9dz/Du4rvXUiSAdCrkniru2rHP7/d4ctcNB7e6ycRsSwLfwO3/CZPjCLn72GA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6637
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The RISC-V N-extension is still in draft state hence remove
N-extension related defines from asm/csr.h.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arch/riscv/include/asm/csr.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index 8e18d2c64399..cec462e198ce 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -51,13 +51,10 @@
 #define CAUSE_IRQ_FLAG		(_AC(1, UL) << (__riscv_xlen - 1))
 
 /* Interrupt causes (minus the high bit) */
-#define IRQ_U_SOFT		0
 #define IRQ_S_SOFT		1
 #define IRQ_M_SOFT		3
-#define IRQ_U_TIMER		4
 #define IRQ_S_TIMER		5
 #define IRQ_M_TIMER		7
-#define IRQ_U_EXT		8
 #define IRQ_S_EXT		9
 #define IRQ_M_EXT		11
 
-- 
2.17.1

