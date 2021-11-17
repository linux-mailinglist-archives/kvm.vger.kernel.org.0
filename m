Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5191C454096
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 07:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbhKQGGI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 01:06:08 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:8303 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbhKQGGI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 01:06:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637128990; x=1668664990;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=DgrArfVV0tvxCuvr6+eRqMyiA24fpY951h3yxIURp5M=;
  b=lG5hfltqKSDLawCuBhXxywRSdznsCEaDD0RzJF2Z9/r0naTTk1dseXgi
   Qc8KlZLXs+WOjzX48npFcEfebZqfmOaMIczS6OVBlGUjxdVDgkrmrXENo
   NboWHa6gao7LWUrZTqFbdRAodQYIM3JdXHAYJa9GilRORoNu1B7SSTfMb
   o8homlptSp2E/lDhbCNUyxXfY/sozJQeACBRAiUJDEY8PuvXp4KIkqxG6
   NV88Q+SL8mzGKm1PEO4I3VqkGgWHb+JdtJptuspB5xpfkisoCOM7FPZ1F
   6YyKGdJ/IFCRUi7rr5Q3pjgc3YvwKinj6yEx9gB/JSIlOiiaGpsT+0mxU
   g==;
X-IronPort-AV: E=Sophos;i="5.87,240,1631548800"; 
   d="scan'208";a="186809932"
Received: from mail-dm6nam08lp2040.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.40])
  by ob1.hgst.iphmx.com with ESMTP; 17 Nov 2021 14:03:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UlEJBEI2YveQlv8vOgCzEX4dyZwMaJTz1YDFoiLF7cXkCtISavj5Xn1LdfdO1r6Tc0LVaGuI5p9r6mLzpunslBYyzuXNN+jxVyom07KgmnZKJk3Qk8cf1JtjNUXsmK/fkvOF3ATtbQtAbd+eGb2rB0zBAihCDTD3qD56lSLL8mBKiEuAD/JotnuWb6WtWs9iN0u/NtILQBLfQ1cNBErlWIC6NecqsRs/639oFufXXTMtfTyTcq2eR+ujIHHQ0PnZ9dXRAG26HCISmqGCHowoJkyglXpbnscRoFZQFDS3t2aiygzpw8y/UxlgegdOJbnnp7+4feejwNIdp8HRIcfHtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/rW2jUfnoSx4YFbNS6ptfich34DRCgs9w+4V4ArfhJo=;
 b=avO3d+9BIC7OElifIm4hnzjhdcNNsrW7DlZ1J4DWOCjKW9k2IwnaRWC64zarqipVsdJ+T3rOvIzms0oygjV6gNCfYPWjhFh83dh6kD6Ff/rhf1TQxXwwKn7gxuxNDT4vUVl5qp/9Y8NZbN6x/f6vSC1PYBIPV+tPrXBOIxnEGwOJNoU2SsjL4PHeVXneaeq2Dj6aTDbF2zWlWG+4Sx3cl00ajQWhFgj7F6dxzTbnTv8pIrrTtSY+T2kpUDHT6VUwlQI/WXidTnEKVVGpyauk9G8vrwIGiLXmr4oXLBGtCo0JXPpvqpjG02FY2IjO4JZMI610rWq/GWpZ5h4MFycl6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/rW2jUfnoSx4YFbNS6ptfich34DRCgs9w+4V4ArfhJo=;
 b=iqPYC1QjaAzu8lvhGQQlT80L5KYamabHLEabU7XyXH/fi3W+ogURGxKKOSZDA8B6wzACDzqvEO1IUXVZgbOr6+j8GvARmDz9XxXnyGPTrDIkI7TTC63S0bVDoaF51POnvtQHwgA39/F5/4MVIulB6C0Mn3pZI347G6k4Ox0K7vs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7891.namprd04.prod.outlook.com (2603:10b6:5:35b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Wed, 17 Nov
 2021 06:03:06 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97%8]) with mapi id 15.20.4713.019; Wed, 17 Nov 2021
 06:03:06 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anup Patel <anup@brainfault.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Anup Patel <anup.patel@wdc.com>
Subject: [PATCH] RISC-V: KVM: Fix incorrect KVM_MAX_VCPUS value
Date:   Wed, 17 Nov 2021 11:32:41 +0530
Message-Id: <20211117060241.611391-1-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0082.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::22)
 To CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (122.179.27.5) by MA1PR01CA0082.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Wed, 17 Nov 2021 06:03:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a8d49c0-1a41-4df5-7466-08d9a98fec32
X-MS-TrafficTypeDiagnostic: CO6PR04MB7891:
X-Microsoft-Antispam-PRVS: <CO6PR04MB78912FBE6DAE27F822D0BFCC8D9A9@CO6PR04MB7891.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eupSd5HpZ6NpvO/+C5WYkm3SoIAY/gZa2uDHrbMQXVA2LYwf9L/eM/zBSYkH9S01s3yQlBpSQkD30ypcWC93DuVEcinIsWOc140PMpoV9rc4IuMUUvIlOVfO8hkZ1ZIlz+jb0YRKVM1zxaAmPNJ0bacSgtDTh90AVYaLphbAcRS37oJHtiFfeqQQL6+V/nnMrblmvm4+yhWEmfQ9h13dJwErGiEyFPEDjIQjIUqvfxdr0Zu+Xf8iXlnpCHqPfNkyk45UbeqGVw/8Y1zhGaq8H0PWZqv2wA22yBcHJAfzxSWOjgJRL1D0xo1xUkbZzVMbwfyMRMzhUcW1ZVCZaI7aIsa+k3v9I1qZS3dhnYIFG3qzH1xfk+irIRv2WwjvnHWhdY77ZHhD8IbMe/Ck7Ss/aO0wKWitGnIR8GEvHUympYyRaDDv2fONnl5/i4kPxlu4UXaIrLU6g2gHN7lneKyDtfNkjXanx9WlB4jYk65mMVYUxA4G34hGmj/dfRs3ezN/t5zyPVPShs9jKlQew5/RoqbIVVV1PSrJyrn8+8uNdCdu64W6d4WWKjoDiEH3CsX798FBsovAjlKAeuN4P7djFuue8LAE+PpTaTbmzfSH6yPmFcjUC9GBmBTibA0k2iHy0FSN+fd/w8YWvrmHN52uepfaFaJFGFgYgWVB7qD/ELmKDhR+Fl0Jqiddol6kKS9o3swd15we/ra0XkckM5XOLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(54906003)(44832011)(8886007)(83380400001)(508600001)(36756003)(82960400001)(38350700002)(2616005)(956004)(6666004)(316002)(55016002)(38100700002)(5660300002)(1076003)(66946007)(7696005)(6916009)(4326008)(8676002)(52116002)(66556008)(66476007)(4744005)(86362001)(186003)(26005)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A+690d9xDkrzcYC8OQhpkkdy94wJ4lxD12NRNnUvtWftUKTLkCZ7q8crf+xi?=
 =?us-ascii?Q?QF4998uFQ96Sgn7WsHXYoAM3Ok/JaYa4RkAJLIbY85MFp2P1S9C/2dZHuHgY?=
 =?us-ascii?Q?ZZPlLUbf67JhE2ODOBEyVG9saNeDwlEWwhhywDjRpG7iyNYOugh1g989afxw?=
 =?us-ascii?Q?jd8v+SUot4YH2l0Xnl9yqnl+Pl8pQ8PdKqvTiZsSBxgaTgxg3zUZzwbnFSqr?=
 =?us-ascii?Q?rEUY6JE4MB2+uCkOMBQjbIgqJJuWTFIJRiR2r9usCREXJA7fGJUtlpyQtLmo?=
 =?us-ascii?Q?52myXNk01lKLXfUyrvBc0eWMJGdVB1RwI3vKeZMpjX6Q8ntUQUOhoonpYDdP?=
 =?us-ascii?Q?fpGY7MtnLXOvbHhUUMeTUggK6aTXPSH8UV24F1YJu1WOnf5rpQhoQO8o1uO5?=
 =?us-ascii?Q?g4JDC+/JjiItvajKwZnBdwosebh1K73YywXrMcExtYQDxtMsxME56QN6mayF?=
 =?us-ascii?Q?9wMGUSgY2RRwZfphRm6M4uKFljOdnqwbqPrzGFzz2gpB6f68SzaubkP42gZf?=
 =?us-ascii?Q?60sHwDH49MkeBxD59Ji1GkL9Hy6zD68ApLHRnTpXBH9M7QJ8/huMYTH13taY?=
 =?us-ascii?Q?p8YpVkjXnNloC/IDThCLO5Or1SqzCPIl3885dcIG64iq+JKO69QiaiSHPLrH?=
 =?us-ascii?Q?eVbK/YTcG3BR4IT8ItVuppHmgSkdsBG/BHJKqt9mcBY1yvYIuws+c9vmtcDs?=
 =?us-ascii?Q?lwD822fWjQt/YDb5gJ1GrlPPh6SH09q8ykQvwP2gdjwlGgEY/2Kh3tmpHLQV?=
 =?us-ascii?Q?ik+7wGrNkdCw+q0fByeU/1jJBoe125epgc4W9XHRRa2rdoDuGBjT+GsqAvac?=
 =?us-ascii?Q?STIWuSd/fUfvDENLCumOTbVDdE7nJg8CDXko7UJ1CHaL3ws4jVgDeUDWYF7h?=
 =?us-ascii?Q?zIQ0TSzfIeJoXFQM78Kk+BymAsBOA/BJaj5D0ndV+fAIfoodfiZ2T9Tx3C62?=
 =?us-ascii?Q?Y25tVIkbkxScSL/Wl87sRWUzURvtLeEZz4nimdTmEF7E/MLExRGKowPeoHf0?=
 =?us-ascii?Q?bGvQHDlBLeH9YiMWaNrjR0Od5gDATJNuOPsXKddtxxIo+VF4eVWGSGYsufCU?=
 =?us-ascii?Q?Jx2ULuZzcSjhAgXI7361/nvvNWLkACYFXkIhOPlC4DY9d7ETbiFwMB6yE4Wt?=
 =?us-ascii?Q?xM/D3enSCzm0W8clqcryzZfyLZVG7KSL0DMkPWHuz+VMhiomaB8QpEGN/wlp?=
 =?us-ascii?Q?XlnVTqnXuj14c/AcsYMX5Pu0bt1ph0VJT7IgS7NpeRzMyFjz33CeIj8Ggth5?=
 =?us-ascii?Q?nu3ohny9BtyMqczdT7H6u+qMkexBzzq0TKd1HnLOegNaNK7qOCTcME/MHrAd?=
 =?us-ascii?Q?8GmEEwmNK0V7mMPUuA3OmjoFn/TbXd3/eHQRtzqSPIknF4UV3u2gojm/A3+O?=
 =?us-ascii?Q?ORcVtHJOkYE60L+rXaeAdYpeqhMOmUSfGOTiT9aHRHNmfcq7IkMjZJrdX/pN?=
 =?us-ascii?Q?rjqWmV4zvCNWT7IJ1BDFRK1d1AJB/7AjDMtfhjM3pFu8auInGPMYE9owlqVH?=
 =?us-ascii?Q?DPLN7DMJIUExAWt2hBGvXTNtZjAO7SvvQf9uzHvzv777Bb93c/iZkJIzLKr6?=
 =?us-ascii?Q?iIN1fMKy3GYHCRHO/M2XCnnfrOuQLAlkj+w6y2HPbDk+hw5Wl5oPEYvcM0M3?=
 =?us-ascii?Q?OwNybD1S6alUUZehW/iirYw=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a8d49c0-1a41-4df5-7466-08d9a98fec32
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 06:03:06.5718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EFucTe3jeqEq3fb/nNXzqXpwCHVOvWu9c76lXT7e5k9jSDsXoHnb+7fAetdfQCAegMEv3wTKa/7y6TsTC6bcAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7891
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM_MAX_VCPUS value is supposed to be aligned with number of
VMID bits in the hgatp CSR but the current KVM_MAX_VCPUS value
is aligned with number of ASID bits in the satp CSR.

Fixes: 99cdc6c18c2d ("RISC-V: Add initial skeletal KVM support")
Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arch/riscv/include/asm/kvm_host.h | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 25ba21f98504..2639b9ee48f9 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -12,14 +12,12 @@
 #include <linux/types.h>
 #include <linux/kvm.h>
 #include <linux/kvm_types.h>
+#include <asm/csr.h>
 #include <asm/kvm_vcpu_fp.h>
 #include <asm/kvm_vcpu_timer.h>
 
-#ifdef CONFIG_64BIT
-#define KVM_MAX_VCPUS			(1U << 16)
-#else
-#define KVM_MAX_VCPUS			(1U << 9)
-#endif
+#define KVM_MAX_VCPUS			\
+	((HGATP_VMID_MASK >> HGATP_VMID_SHIFT) + 1)
 
 #define KVM_HALT_POLL_NS_DEFAULT	500000
 
-- 
2.25.1

