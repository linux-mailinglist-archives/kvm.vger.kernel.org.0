Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EABA72F78C2
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731868AbhAOMWX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:22:23 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:36814 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731857AbhAOMWU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 07:22:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610713340; x=1642249340;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=wDhD0EFwIBITnSoPCysuFLCzTcJlqo/KLgCMeMDGKao=;
  b=fMGOPgwdPtCpDNrdnZ8LjAz55hRDn4ijhYm2TBrVHBDlOqv2HsUtMqZR
   nhvlaR8KLRtgp9LDcQBlDYTBIWRbN7R983xusK6wjxS1IDCAfkynwKaHs
   Ycb3J1KOA8yR0LJl6sb+8RUAN7qwWkH4QyaVjQzkf+efBhVmEkTBdG7+/
   R7DHViQmzELKYHHXp4dWez0ghUXILTDZifzGjnLPyvAr8d2FoMN/Kep1R
   BixwKAj+DR4oUa+t53CbF1HnPv5xzMJkl1cKLSK/+M6L651zMBoAIWENS
   D0q9UY+mkD3wAlkc5/cysVIbo0lP8E0e/pdSO350mz1zlBVU12ZkjxIpS
   w==;
IronPort-SDR: owV0S+07T3N8hd3igRHgjwOnWE5ORrVKbhlVVXShEYUD2yTF2iLk89/HwWXeJPu/JG6SJR19l6
 kG21gjGaF+dFkqaXYcADS8cRE7fNAkB8wrN6f1HZfQ/LRPvSufM3em6pjozq1GXUXJsKGENs7H
 arfDfjy2M/tZDMK5aIe9Dw03YkF8JHeIIOIcmz2M5JNzP/oGeUdEnCIkepFsrIrSVWXVlhyUl+
 Vu0/9bZpKVV2ysAtzewTlnucRgjEuRFeZcxusAwNbfRLRll5qLnpBvGjCq/qW5xX0FiUKLdavW
 YlM=
X-IronPort-AV: E=Sophos;i="5.79,349,1602518400"; 
   d="scan'208";a="157507161"
Received: from mail-co1nam11lp2172.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.172])
  by ob1.hgst.iphmx.com with ESMTP; 15 Jan 2021 20:20:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jTpd1FMMXGf11sqCuXiVqhKAvCx9ftqw/RHngUIBaoMHmC/IBRqwUcAJLjPzegwORDnK4SCcFHju/MATck6sXL9qFUe7C/OSvdrLb3HjVBOi50mfyGXGf3mq1FAK5W8SFTtTiDVzX/IncT2R3S3F/5AHaavg5xgeeQMhnPwT7kJk12zwkJScPRGzN9kDTi/DLHInZh18yzTGjVrXIpYsue71+jVDRLjRXrF6HdJSC+9VzNhyWYdxfnMptTujq3kIjW7QRTnJ9PzOXMHWoDCQVudW/EILkqVLB4Jcjot9Lx/PRkwzL/KUCMx3f6P1GWHaiEqz+rxMff8XdCk0Bu2Zuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rEXVk2pLVEuQxZ9IxQ9Sdn+Q1fvb8QR2bD/xxf4dsIU=;
 b=NlQZYCXrTbpdLkXfN7tT2eNEoHuh2YpDP8zmFKCKEmMJLI7lvOaWNFjF4Ldl/N9MGjXpjVZuvhFqle84m99mKFGHzc+nXTmKZdG/OavPRZ3UQAwtfbfQKgl3JAcq9cJlbSkaUZ2JVWl1qJEV0/HvgMhz2bAFcuSYAhE9Buxus2pZ7wwjzFShgeX6WQyUXbKGv4datz2IxjKsVS+/AysCapQycwE3HHPXJnOFv0xRhw6gnd7OUkMzAUqA7O4LOU9G9pRpIlCqsZHNIV3uNIb+L45AiGfpx0dCgYuszdNFFwijsKqgU1VhsUR5Dhowu2lgFGTFrORdMMUywZmU4axVOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rEXVk2pLVEuQxZ9IxQ9Sdn+Q1fvb8QR2bD/xxf4dsIU=;
 b=DgZcj/0LiLY5fxp3SnYkSlUcPLJY0MpZUE6DcC+fNw2M/o2C6ghDHywQ/1JOPyAhvdOMJ4RSPFAWNoleZi+/h7fY0jzj8JN0QwMCbIa3S9nwFmmYE1GXPKnTqX9EM5vtRehgpQwp6qemEllv2CFAMYyseMVuxBEA1OTNsyDXDRI=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB4330.namprd04.prod.outlook.com (2603:10b6:5:a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 15 Jan
 2021 12:20:44 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97%5]) with mapi id 15.20.3742.012; Fri, 15 Jan 2021
 12:20:44 +0000
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
Subject: [PATCH v16 17/17] RISC-V: KVM: Add MAINTAINERS entry
Date:   Fri, 15 Jan 2021 17:48:46 +0530
Message-Id: <20210115121846.114528-18-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210115121846.114528-1-anup.patel@wdc.com>
References: <20210115121846.114528-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.167.152.18]
X-ClientProxiedBy: MAXPR0101CA0024.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::34) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.167.152.18) by MAXPR0101CA0024.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Fri, 15 Jan 2021 12:20:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9346f790-4cc5-4abc-1ad5-08d8b94ffb2c
X-MS-TrafficTypeDiagnostic: DM6PR04MB4330:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB433005781EA46949311E35A98DA70@DM6PR04MB4330.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ESRHHgkXg8UxKkJ4Oreu1MYtPgqBuaYZWOFpc3INN+otUXwGmvVOIGe6BL39sZSXwAlpiUmyiWbpObeLq37ZLyiL4hgXczTLHVFq086CPldKS8NU6F7fiTxnS+ySf9Qf2WbfjybO9WmY3IeLVFz/IaFLXvMbwY5vojxySWdO+LyTVQ3xF/k9eQB4M64ko2g76a0eR6HZvpbr7kot6/CpH72iQlNf7PjLCAruhm3SqqOnUSH8WH5oHS5yyeTwqzR04Lih7u5lOKfKmeHR4PHcA65EFA3XycUQ5n5jX2wqWJSl74dZmubzHPH+UZGoKXFPCiZ2vBKhnxQdtLL0h0y+uIrsNfaAqmuz1oHdeu2KqXgP9+olZrg7yEXwbLvy50QKhK+nOIVnFNMZxDTCxzIYdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(7416002)(66946007)(316002)(1076003)(66476007)(8936002)(110136005)(186003)(66556008)(86362001)(16526019)(36756003)(44832011)(6666004)(7696005)(4326008)(26005)(52116002)(8676002)(2616005)(478600001)(2906002)(54906003)(956004)(8886007)(55016002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?mpdWkvscHF/sc0MHfd3m2TeQXqOlFQA8YofUStVHvv++aciSDy+q8FhWv3Sf?=
 =?us-ascii?Q?SJ/6JUNZK8/j39mPRYsEeKzaki8hWdAu+12KjaC258SFMeOnGCyf+w3frbaN?=
 =?us-ascii?Q?tIhMxp/MWeW9PvukPcN1hr8bh319dAg3fhbpm/iekbnrTN6+CIKtirexymm8?=
 =?us-ascii?Q?feBOE4kwqHP+MxpVOy2v0angbddFJSVWSJw3GxhBeGfsglC2yWQQnfb1MoKo?=
 =?us-ascii?Q?JwGyW9kG/B9Hxw2lRP5KiJk2RoRV6Dg462aCfT/izIFC7ave7vgiULsOfCNh?=
 =?us-ascii?Q?iARKBIAHlv5tHFnT3Vhde/tIrZxbnYoTqehGLN9Ul0BEM88Wt4StXmhdcgZU?=
 =?us-ascii?Q?gUskdUv95E9BpLQTP7xRd2DlC0cMZY+mkC80guglk+qNO6K3WXz4LXPxjVll?=
 =?us-ascii?Q?gD84DBdIa6eC7Y3IwNuwNbaMmV9XBE1G+bBqWG90a+jMwgaDhLZwwObl7lgo?=
 =?us-ascii?Q?LFNAZH09spd+yY03pzmfNnEOHmbV5wFxUE/S68QQGkYaRhkPk4khaSXTZUKJ?=
 =?us-ascii?Q?DvTW0xtLjzi8sdbBfYP+XOZHeDbQa/0nzzYVGNaAh+4nyEe3rzA6Xo66pEgl?=
 =?us-ascii?Q?MMNV2fOwf3xHKFL3N8wV+tC+Oxeu/q2ortB37vLATEBo0sKUMp/Q5TYD31WX?=
 =?us-ascii?Q?vgGcUJvLqSfshuz1gwjQEErwONdhE8C0i7WIl3nzyXtV7wo4T4yED/nf8HCy?=
 =?us-ascii?Q?Xn3/YFFC/oAjJf79KfhHThXGS5+ez57Q1KfCQIbzqSNLxjIQE7OQn6WsgU6h?=
 =?us-ascii?Q?C6h4oQJ3Kf4cPxBGiJGsIFAokjQcYpE4MG4NCNx4xCS6I+FGdJ2Fy/NsgAYM?=
 =?us-ascii?Q?lwK6L+0SkHVJB1Do5bG2U0lmEYLvjmS+G+3Lh3fIKS3C92gJQkeEuYuDrrVR?=
 =?us-ascii?Q?ALTPHli80tKTOjjWf/F7CtWgngApQsEwlVi4dsWvjVfA4rlXnlaEkL3+vg8V?=
 =?us-ascii?Q?V6IB8hjQPFVzo6gPfktPMTyn/CMXWrxzys2amRESHdo5+cC5VctcVRcoKQ6O?=
 =?us-ascii?Q?z1VS?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9346f790-4cc5-4abc-1ad5-08d8b94ffb2c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 12:20:44.6118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qb1WKlbByasZhUY+9OyiwBBWjIeYEvftGg5mnlqnHffioEYNNMwvFqawsHUc624NHCG2CPW7jQZA1yM5Dc14eA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4330
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
index cc1e6a5ee6e6..a21739347495 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9753,6 +9753,17 @@ F:	arch/powerpc/include/uapi/asm/kvm*
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

