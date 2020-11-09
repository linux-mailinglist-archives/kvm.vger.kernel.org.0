Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C6E2AB71F
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 12:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729866AbgKILfP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 06:35:15 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:1455 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730026AbgKILfB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 06:35:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1604921701; x=1636457701;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=9jS7rQ0IdYDT/xDPDvbh86ELTS2141i3HcilaybMNPE=;
  b=BGQbUb7w5J/8hFH2sbvtHlbQtKoglmrFGGTF60rAOXwV/YyYD9zc3bZF
   bz2uZ6l3ggtDWT/5bSdN5iA5xkcdqT5aY6ui8e1UoM7iNWnrjSaFqiqqZ
   jnuOdf3mi8Idf66WJZhuKT2zdhSXcRqJDUFs/iNVJdR5VxyJbwN4DQq4H
   0xyiiiq37j0L7gU2NZe+OneWPvqgY0ikvvv8t4p6iCgfqILvKR+Me4hbo
   8a9VsW9E0gHi+hXBgUi+w+S+7+gJS4ForpWvUTWE2SYRfh2/JT6ZV5huB
   /4sLOHN6RbBhgY5o4jawyVCT4DHkCWv6msxRb730/hWOa4xIwmb/UNa6j
   Q==;
IronPort-SDR: bItDQT3Fc4WYls5y+V84Bo9ScnbsIvAOwW6SzdFN+jfTQiDQXTHSxNn7YEadf39ia72Q4iLvt6
 AsC1EUlObnYbzWkYYfgk2bPl5uRdnzBokV+EOfSCvmkXT2wVyQPLwmBDBhs5OyXtUL6lwQ2rYg
 k9JN9v7Vk4DO0yialpmbUR8iI26wcD2e1ho9tkNvo2Q7BW9Vp3M8HEo5KR8ftJ86YFlCUHqpRK
 3AK+Wu4Qm+nveqovaw0D8JksQHELOv9+YP/YzA7Z2WzTpY9lxY57Q4kD2VnMlS3KKbgERWTauy
 GOU=
X-IronPort-AV: E=Sophos;i="5.77,463,1596470400"; 
   d="scan'208";a="152081076"
Received: from mail-bn8nam08lp2047.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.47])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2020 19:34:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kza0VqsgMr28l7+GU/As850VmGOCZKmFEpwW3KCJgtybpC3QiQOYPKEfTKo4wofb4V+rMs65sYKp5HZf2S6fXLMy10Lbn6om5NKfJPnv3B0pkdDqpelFUWBCT/9NI364WDuCb5TFF1KBHOq1lWfObu+U4WUOBFun1Rq2xj7Aq0zRINJTE/nFu/VTytCwUV1adPPRNYwKpDpMqY5pzQUCjOhpz8XgctNg4iNMgy8s5qReWzeQ+mgYNwEXgAL0g/Gi2WSog9QOsMvS3qMTFkmPjSVeaL056q6/gdi/gMgABKhYoAbMywBTSQ8oHAs2PQrLxbKQyP25kZskANNZgsqqRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uxvpnG2onT2Qcoi3wLM1eZbmICMZWC7QO3qCwAm//64=;
 b=J7fQGXGqs0v3dAE+AdLG+uVpROtF7GRlharZEGYCKiYt3M2Wsnnm8X32hlnjGHWqyXoyJ01iMEEVGYnDgeHOHTJOz9kHAIb5FWXROzSmQpLjNRm4s2Xvq8ll2KqzxNM/zGwJHqzqnT9jPFkqRNE3I555zxKfA/3HOKJ2LWRUSly44TNHD4Y75cPBfEfJI4qKnSWIxv9/1DygRr//LScAQscVI0lUA5R/nPjcBnmFLusjxKVDswpZV34+bFaB6Ly0N5OuaoYhBVtJLa/gQ/31eF3oNXjiRXBMzH7g3Dox6s41ZcjW7fF/ubRJ4sDpzxnUdRIQKlZUj0vuxGhtnEqkAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uxvpnG2onT2Qcoi3wLM1eZbmICMZWC7QO3qCwAm//64=;
 b=VI3ewdNIyyBYqwLuqivahJz5Bp6ZVx4do2L/wXUJNbmizLnerFu5NOlK9K60wf3toPZs901Lp+Qi82GkxWpagiKNftxyKprQ0MilNv1PqZcV+RUr3HVJHyIr2BjroKnZIwRr9qbYEPuAueCV+qNP7A0pG+f09Jb2OhwsahuNEns=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB3866.namprd04.prod.outlook.com (2603:10b6:5:ad::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Mon, 9 Nov
 2020 11:34:58 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::d035:e2c6:c11:51dd]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::d035:e2c6:c11:51dd%6]) with mapi id 15.20.3541.025; Mon, 9 Nov 2020
 11:34:58 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v15 17/17] RISC-V: KVM: Add MAINTAINERS entry
Date:   Mon,  9 Nov 2020 17:02:40 +0530
Message-Id: <20201109113240.3733496-18-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201109113240.3733496-1-anup.patel@wdc.com>
References: <20201109113240.3733496-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.171.188.68]
X-ClientProxiedBy: MAXPR01CA0099.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::17) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.171.188.68) by MAXPR01CA0099.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:5d::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 11:34:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fbe7c6be-707d-4234-7f7c-08d884a37cd8
X-MS-TrafficTypeDiagnostic: DM6PR04MB3866:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB3866C2332AF28068211F2A028DEA0@DM6PR04MB3866.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hAnNe71YUnN5H2PiA/Vl0IYcX3Uzp4FEyjIyiRhAa8rKkCvXLwG8AJsQrmYumDt0kViY9Vk4joKl3XRf+/7tUAxFb/tCJb85P++3/GnskQP6coMrZnlC5vDMhqmruWPr6ajTQjfojt3O7IrYqOKd6PejBnDvDXIXZ2fwC7pSN18fwj8OBZX9GZp46I4Y1s19kXjSw+JbdfaLekkgSfcnV9kaNbLCB0uqV/40bbfOjRq4QO2tliyMKPrIu4L8xDBPPpk43CiMAAVNIOM4OHoSOm8SvWPFNuUbklKIxwqq0b4CztlvkJ0M7+P/FqDej0HEFyrNJ8ToWgnYivodKJsBYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(55016002)(7416002)(1076003)(44832011)(16526019)(186003)(316002)(26005)(8676002)(110136005)(54906003)(5660300002)(52116002)(7696005)(956004)(2616005)(478600001)(66476007)(66556008)(4326008)(66946007)(6666004)(2906002)(36756003)(86362001)(8886007)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: zbXLrc4p7+hRJeCckn3d4uSKioJEmBB5ozyH7Iq4+SIrz5P4UQfRF8NfJr4HeHeAMae/4oWZHj0dEbm0Qh+88R33QK8bXGSrkIX21yOKWP4We1YrkNl5izd0eYtPHcV/uzZXsXuOURWK1agRplfK3PrtqnBDGcxvWnr2VX31jv4jDY2PsBtFhL+pWifT+9FIznwMKf7/UXhOofMlMcn5ZNM9K9pIkVUWaXbVi4n+e0s7nnUpsSQC6qxsr08p0C0nUNzgp2wsuAjG8nlYXzgfUZVjuBNtcuzxUQke2Awj1H04vB6Tv8BpMhTTvGf4t61VOCDcL9M4eEX7podJFe+RlmUoDOzfiLuODfHhuda+m+76QZUfTsYMjoW1OPpVzwoOyRJ2Hg80ZKyDvbeDn6olkdOjf4cttpk1/dGpxQqT3RVgpAER+EF6QYpw/+LpRVPVliAGs4Tkxyo4ZKTH/1T5tgEP67hoeyTO6amhlxw10xryq4+NKRh8NfP2SbK4JPNtxjLSRyPblWYjVZJRkDqfmhYAEoP2RQFJSv9GuDFzA00kq1ZjFUxyeEkUK1MOCferTvlnLCorkbq2dtdIWN1Iwq2yld+DVsJALXqvPJ9xQqKZK8KHPdWf6zkkAnqCMUFzvdwZTkDXNnBF6dxWvxPbAw==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbe7c6be-707d-4234-7f7c-08d884a37cd8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 11:34:58.6331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BUyLldD90YfggO7VtfEG4ypw96SmFxBw23UGDy4HtoyJed7mLVCrf3AJzvOXmAOR4pFLCcZWJCLKIXLEPV9/Iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB3866
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
index 3da6d8c154e4..983fcd2d10cf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9640,6 +9640,17 @@ F:	arch/powerpc/include/uapi/asm/kvm*
 F:	arch/powerpc/kernel/kvm*
 F:	arch/powerpc/kvm/
 
+KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)
+M:	Anup Patel <anup.patel@wdc.com>
+R:	Atish Patra <atish.patra@wdc.com>
+L:	kvm@vger.kernel.org
+L:	kvm-riscv@lists.infradead.org
+S:	Maintained
+T:	git git://github.com/kvm-riscv/linux.git
+F:	arch/riscv/include/asm/kvm*
+F:	arch/riscv/include/uapi/asm/kvm*
+F:	arch/riscv/kvm/
+
 KERNEL VIRTUAL MACHINE for s390 (KVM/s390)
 M:	Christian Borntraeger <borntraeger@de.ibm.com>
 M:	Janosch Frank <frankja@linux.ibm.com>
-- 
2.25.1

