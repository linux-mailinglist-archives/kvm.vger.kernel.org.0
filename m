Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAE7419364
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 13:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234318AbhI0Lob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 07:44:31 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:36469 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234357AbhI0Lnv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 07:43:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1632742934; x=1664278934;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=O7P2oK1uS+Hm5yJhndLo5BTuuAbRlu/cowVR7mLP99A=;
  b=C6W6KgzyRw8KGl4TFpGQBUuF8qUaWvuQ9tMrV+m2RtTV2yFQz+jR8Tha
   bUElvTdH7NjpwelpGxqm4bcqb44ywbEgqJzpto9te+SJftt4udSPUtr0S
   LUsWta2IYtT4FUspFBA5MdDlVMLL6zFIOsyf8JkFLyIOu+LMaMd3M7I2c
   RazXiCH/rVDuMuWlcgR/p0Rtm+r3nJgU2pDHmFEKUEGHoukGwYSfxHcpb
   NF63J+uPK0+aW/q/f8HNbihAdADkuQX7iJZ0SNLrGGFTr32uOTVa+wKwY
   LliI6rXKeWoIyuVsRYCQJ5u8G17gkTW5y8hqYhSSEsnmmqHaTYKHkYYrN
   g==;
X-IronPort-AV: E=Sophos;i="5.85,326,1624291200"; 
   d="scan'208";a="181673125"
Received: from mail-dm6nam10lp2103.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.103])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2021 19:42:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q18+uZw+XTSK6dLQ35mwXDX260Vh+9Bi0+Ug6E4X8J8ywWp/msIBjRouga/CmxYtkuUQq5J04gPZF788OFUaxuWlm3Y2+TGesOdlc8RIr7TLMuU6htbH3Pdux0/1bWyOU40EWYB/0Q6wgz1MYvIUN7V6IvVV+zKaFmBlW7MEVkBtcEhRF8XVvXqCJV0h+cN1wrllOJsT13NMeOdMqgNtSWACpbcp1170EweRra55OG4n6PfHdaoCzv6PKy7y4pZp7ExjEr7XJAKmY1QjXkpX9oJO/l9N1AHgt7qi0lWA1Wi543rVtO2WlX5lmDpejHgnC5QgP3FS01rISmuL6732vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=dVM3GuZKnKY6Qr70ezyO+Dml4X6awswagqTzl0mZX9E=;
 b=eRdPjhH61Zm6zN7plsUTRemCJH616BzosgBmPWHq+yFyi5rhGeyntLt9BgmmWqF9Uxs+Jscg/rOfK5+X4bO7MK9jvQGCJyMUhn0nbv9ZJjhnccodpEe6UHv+txpvxvNXUcOSMtSsGaiZdTGrQpXiAFyep4HOeeGBLKHBS1/+/Rbp2qfdzsBv/kbnAlrgPtbyS2CnXZQ8ZEFjrzD3MEbDqMB95dpUOhcUcJ0fM2eEiIpkblyX3t58xAvp0h346Y4QJdx4bZuVcRxc4vQHKs8PDdyHs9GQWQ++ISo/FDC5jJjsnmpibSkUGdwalrSCQS0bLHfeXwp4hQF9KC9DmKZzmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dVM3GuZKnKY6Qr70ezyO+Dml4X6awswagqTzl0mZX9E=;
 b=l8JspvcwZl2DPHZ73M44MiPyCQojHpFPZEBdcLUTQiENmYpGmYnVi3kY5chQfkX7j3clRGrEOnkYAziE0/4dJhxDysUO4P/Rdpd2oaqcs9zdIkmFFzSglovypXcnH/qeBlT7Jneon2SsnodE6bfuWJmuT4ocIc+LYCv6vzb2Ap8=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO1PR04MB8236.namprd04.prod.outlook.com (2603:10b6:303:163::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Mon, 27 Sep
 2021 11:42:00 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b%6]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 11:42:00 +0000
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
Subject: [PATCH v20 17/17] RISC-V: KVM: Add MAINTAINERS entry
Date:   Mon, 27 Sep 2021 17:10:16 +0530
Message-Id: <20210927114016.1089328-18-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210927114016.1089328-1-anup.patel@wdc.com>
References: <20210927114016.1089328-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0051.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::13) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (122.179.75.205) by MAXPR0101CA0051.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Mon, 27 Sep 2021 11:41:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6fe8c9b7-0e90-4f81-9b0d-08d981abd0fc
X-MS-TrafficTypeDiagnostic: CO1PR04MB8236:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR04MB8236F288C7EBAB5B46C00BAC8DA79@CO1PR04MB8236.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XLXqgR84lqvRa3/MMBYTjfOd+CBVeHEv9ViS/+ab/rIz5yBw2W5dNttDIcFNaQweglKCam2z5mzCSw++Z0qfEOKRL2FEE5sb4hy1HCr+t8aEBtVf8qyU3sR3YQZFAnjIPA+ZlhE4ykDF89PTMlEvzgnCLviciKt4kKE454Zu4LJKm1DuXMDeAdmpafOkk9YP3PBfTR9n8wpyfne6uViMttLo0VFvxpzH9vPOJXq8dp/eV+XpPMSmaBN+GDsPuZrMwgaiXp6wNsIFnnMHMVkmaYEK54Rz5mbYl+Vx2N0vOJGdxKvApVUx6gWsRLkIRCB8S7JaeIM4nNKcDfcPkBgThMqjN8cpxq85hWCZrKBSL6u1oG8AP+BCnLl1wHRR7648EjOWmV2jT7DKuLDtHqkRhcTiM07B2HVhJAt+J8uhEsrcZ/63MYKMlYRPx9fj2zNiEzVPMP0EPMipugNDErRbfvs5R2yPwyd9+8jfWLg6CFyOqzo7GIBfTUj3zwxyV62ty9Sz9g02o5TS7euwUmxyJNPBp/PlsW49rWm0TU/rqSqEOIKBUoqgNjChFpxlmxO/6T+qrlIcvqIaoVXOe9z8yXDb0RCyXewV+rQA2Wmoo1+vygcg9PmcCWh1OiIJ/HFGDTPl1BNAtCwPQ+dx1/aZ6Uba8hpepNz2LlFq7gIUQ8IsAhhCO7wiPJBXjyklz5+H
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(66946007)(44832011)(38100700002)(54906003)(110136005)(186003)(55016002)(38350700002)(8936002)(508600001)(7696005)(6666004)(1076003)(36756003)(66476007)(66556008)(4326008)(2616005)(5660300002)(86362001)(2906002)(8676002)(8886007)(52116002)(7416002)(26005)(956004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?50GxG9KYOg+Jz4vvBV3aSggqmhYcSR1pjzgDO7ADP5iLDT7eX+Mz3w5WisD7?=
 =?us-ascii?Q?u5XDpC+7O+sekPUKQcVK/ZYP19/TXrQBHhaOtnSFqgF3/IYQwO6eQU223mDg?=
 =?us-ascii?Q?XPN+PBAqRls7VBjwhIdxZ3CxbwycMmoHk04uU+Hk6NWZT3XhAjDpYjD9EE0c?=
 =?us-ascii?Q?/y5zsTUP4ZV9VtItPNdlLlLKADMDRnziMhR1hdXP/cv4TvcVM79xCM9hj0aH?=
 =?us-ascii?Q?vw5ybbYIo6VdWUX1pnKwNun6agFto9H5VDNxJk+Xl6b5h0iKN3dgZINQuQlA?=
 =?us-ascii?Q?vVu8yPUxDGTDLX1VRXSTE+5MKWBcvGMhSkKc2KD6jTB2HPWUfnqybkF+9Gzw?=
 =?us-ascii?Q?hZ4QnA4tJoiTJ4Vuv9Z2zsek1dMMItFAFB/schmERlGex7o0hoSweNgcfChm?=
 =?us-ascii?Q?6KUxWVrYAurjtdQ1RKwJWH9H/Q78LXQuBiMg4HZHi4CPPxU6hCT+I1WEwX6W?=
 =?us-ascii?Q?oPYNuwVyq1gy0g+7z2csTSHSgm4cyPfxZCt+DVeOxOwwrTwqiATT38RnT+fA?=
 =?us-ascii?Q?qsRCb8PbwPh3g811d6IFlQxmkG1LPVPzi1onEDb2HAfbO7VCqyvE/2jxlygH?=
 =?us-ascii?Q?zrMI0GqqBTP5bbXv+EU3qNHiFAvQpu79cvLKMZbk63zZt3GKcQ7ub8tcIYf5?=
 =?us-ascii?Q?vb/0Rbs2+QQmEIlMYadE1L+6laBEW9p7Fed3ACCv90bf6zOde6KhEmwjmP16?=
 =?us-ascii?Q?5QbGPiNlYIdQYYixhoVEyNzKjgUenHOOawfbfXtpoQkyBORKOrY2wYVP470P?=
 =?us-ascii?Q?7JVcbXP+fWMb+0FYLoHCvI4o7M41xI9cc0VFVH1FsAzT+66M+w8d+A01qKmW?=
 =?us-ascii?Q?mRmMgt7/lv2AxMCja7akM6+meukPBIrcMX3zpEAXG/xjufSKVSgTuo79jPDj?=
 =?us-ascii?Q?VcEIW6W9WXgVL3P4rbSZfrrJBsCIMWw4tvzBzoWP2wLnv5jIqlDHLuDo3t78?=
 =?us-ascii?Q?YvWBR2bd+HEgv7Tq+4shf2mev2kh1rHCvl/cctr/q8Gb2U1OB2QW/ZIoGeUa?=
 =?us-ascii?Q?f73y7btGnpIranttaA5K0LSe8qsv+HBOXYuHpDAnQ+4wl3RRETqeifSwSR8s?=
 =?us-ascii?Q?VR2XCK3w3ln+ZIkdX05qX4E4M4OIk2iM9TrPY0WnqYu70Pu2I75fbt2rK8jd?=
 =?us-ascii?Q?BawIls85Fxvd8T71XL8UFYy+jf58vwKRS8DYiifBhFqDoudjkW6m+IYAR4Ao?=
 =?us-ascii?Q?4T3V8m0hucctZnZoyTnwxA6QBk+0a59dOkpnyX909stFCpC240mVjFYzci7K?=
 =?us-ascii?Q?kAJOxqOtWF3cVxiV6ILgZtZJcz2Y/O+yVhArvdExEcCRqdkk8JmBzY/oHTUU?=
 =?us-ascii?Q?+qUjF8NYaShqfqNKtOaGA42j?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fe8c9b7-0e90-4f81-9b0d-08d981abd0fc
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 11:41:59.8876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zhNfn4bqla4vyNngSuzkig2H7Fk10KWGDOClL7Q6u40CmS4W4FmsN+rN4A+2E0KQparZEWRUrKliRf0Tq1WOdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR04MB8236
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
 MAINTAINERS | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5b33791bb8e9..65afc028f4d3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10269,6 +10269,18 @@ F:	arch/powerpc/include/uapi/asm/kvm*
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
+F:	arch/riscv/include/asm/kvm*
+F:	arch/riscv/include/uapi/asm/kvm*
+F:	arch/riscv/kvm/
+
 KERNEL VIRTUAL MACHINE for s390 (KVM/s390)
 M:	Christian Borntraeger <borntraeger@de.ibm.com>
 M:	Janosch Frank <frankja@linux.ibm.com>
-- 
2.25.1

