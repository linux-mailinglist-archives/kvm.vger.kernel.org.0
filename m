Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB2CB4112FE
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 12:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236058AbhITKkL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 06:40:11 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:29748 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235917AbhITKkG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 06:40:06 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KA9Yoo019643;
        Mon, 20 Sep 2021 10:37:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=vkRPZ+VoJSi1c4vsO7PDtPst60HFkVEdoBfrAZpPA+U=;
 b=GQBi2jgaD4uPmtx5mCWZLLBbmFUPv6Sv9hG2Qwfti9sp3RngPDGVp8Ot1A6awv3vEXHm
 Dh+YmxczwKkvF2QBW3sv53zk0hPE2BSvaQ73/mYzDUX2ZRCVjNdhFeoWirId/oDon6sN
 T5v7TjTGx4zEuyVmJRqkgWcnmPo0ZDkfZf5/wPGqxMpZXCVYh5suycdkVNAmtL44FXLp
 z+JbcI4bRUBw0imefems2ogu/AaqwokB3EhShu14xcocowAirmNbWvBwUyiBa6f1bdRz
 67j/RfkYgzXuNyFaaJcwEx1i4x/UXAdimQy2ZaaiqIlauCZDAofbsCcEav55WeF5wAVv LQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=vkRPZ+VoJSi1c4vsO7PDtPst60HFkVEdoBfrAZpPA+U=;
 b=LbBidCnyqnAtCSm0leTPYRBVHbfV3kR6sps/GaWQmXEnhMohSw/9yzR6Svwfll2EeKFP
 Ojij5zemnruRXnOz/6/167GTjiDPN9p5NCYXR9H/gwavnoHwsXVlWMAJbf1OIdYYz9R6
 yw6StgJucesdEWN1KzSe5ff3a5QVeQICBSaZeer/ydNjasSOTw11D2311yFZRNy9/GSw
 dTJhESWIfgNs9dDrRT69vOQpwYOWh1/Cvno6+VJMOEBPO/GkUleVCzh3O6nji+q42MXg
 242A9ByU+jpZq0MIykACsP1SrOH+mA1ixcokyHYp11nz9AFa4/6tP1h3fIq17uKsKUzC gg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b66j2huxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:37:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18KAVTOo106020;
        Mon, 20 Sep 2021 10:37:47 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3030.oracle.com with ESMTP id 3b557vbvc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:37:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YMbTz7stPlKosmXIaLhrn8+DPryYFznQ2Xd60mKKyMLO4rrJ2rwiyNJsUcO5E18KLyMAC7Sa6p4+B1H7CYeKWuCztDhurLw6+vWu0S7I3Q1e3YkhP0+xrhuDytwFLMDdcoi9eklcUEpU4U86oX6CidM0MOd0FPgHAWiz10t0H38VeKxUu1Gm2tlwyS5qfW9BLLDGPhqFwF3gQREI4W/C7+g6Xosd/kUO7WUMTCU6SNQJx2jwp5nfAI0UE2Ll4v7xWEVeYR3YSl4yx+dqYrwYmyJ/XfWiGpra8dDh1XH3SieFr0FKSf7eC4Cnshz3eC9+pwXceO87WqJg2u6cFufSdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=vkRPZ+VoJSi1c4vsO7PDtPst60HFkVEdoBfrAZpPA+U=;
 b=QLk5lNRDXmTznxdFyaOOq0OWEaZHf/TwRSP8HteIjUVKfP2f35lRyFZ5ItpxO2UJd0cTQlaCnqv0uGSwhR8DoBbmO0SxgjTKRH12EaBdGsWpbE1EwqvdyBp6nfRfWtrsRE11MHxy/QxWLlb2gRZWTB9oeHPfzEvRe9qdUa17mWxFGH22F1gK+XJ4R/vTcpZMIUhS5/ZjFWwoaLM9KT+gLh9HP6awLaWWXXR2ZKn/Gcz2NdxGqSvyWalNV95fu2P5a3H2Zf8E4q8sVeaHrnaGVYTJ0YacLqQa96QPHiflJY0shxxGBpoSVKVTD2mX2GBINp6R7IEHM3va1lVoa+ZQ2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkRPZ+VoJSi1c4vsO7PDtPst60HFkVEdoBfrAZpPA+U=;
 b=JDfIZ6RZGHgca8wfSxVHfz3TQa4PhfF4bPnlLhP620qZkqQ7fk4JPrW4ufyPcu8xwrVgAjXIx8ex0fJ7DGETyzGvwCfXOFf01Mgbb0N2fTx5jyqHXyBKmMAcGtDVs5B5KU+I6Pkra/GLkuIbIh14pjdDwYLT13NJBjB+X0XvtYs=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3148.namprd10.prod.outlook.com (2603:10b6:5:1a4::21)
 by DM6PR10MB3308.namprd10.prod.outlook.com (2603:10b6:5:1ab::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Mon, 20 Sep
 2021 10:37:45 +0000
Received: from DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::6124:acae:c33e:1708]) by DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::6124:acae:c33e:1708%6]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 10:37:45 +0000
From:   David Edmondson <david.edmondson@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        David Matlack <dmatlack@google.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: [PATCH v6 1/4] KVM: x86: Clarify the kvm_run.emulation_failure structure layout
Date:   Mon, 20 Sep 2021 11:37:34 +0100
Message-Id: <20210920103737.2696756-2-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920103737.2696756-1-david.edmondson@oracle.com>
References: <20210920103737.2696756-1-david.edmondson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0036.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::24) To DM6PR10MB3148.namprd10.prod.outlook.com
 (2603:10b6:5:1a4::21)
MIME-Version: 1.0
Received: from disaster-area.hh.sledj.net (2001:8b0:bb71:7140:64::1) by LO2P265CA0036.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:61::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16 via Frontend Transport; Mon, 20 Sep 2021 10:37:43 +0000
Received: from localhost (disaster-area.hh.sledj.net [local])   by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id eb7d8700;      Mon, 20 Sep 2021 10:37:38 +0000 (UTC)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5d3e4e4-cfa3-4365-f528-08d97c22ae9d
X-MS-TrafficTypeDiagnostic: DM6PR10MB3308:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB33089D2B43186D48775CA91988A09@DM6PR10MB3308.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nv0ZN813c6igNWhpw0FDCAXYw1LBuJZrqLAJj97gaOweLZEX+JPR7fKPaZ4P+2X4DYhp7f05vGJJxFvYNjmc/f5XENkWXQet8XzJp62iCiN/27I2iaOxR/wVW15Fr1OYpuUOiCWqgNQkt/plOCUkjR+jPJJU31gOSmQdUNlJsXIxGzOcNMvFglhJc/+FlNFQ5ykFTticHs5cHiIfeylFKNAVNj+FbHcEIrs2tHpcVPr7rFoetgLZikDp1u4t1MhmFQhxbkRWiYCCLjgaT3+R7ZDguDYEDJqm2QgUB5df8Or649TZB4p+8B2miFb1YiEi5p6R9GHayIkT6u7jkf+yjflR5+vLKA2M4bL+FCmOkrdUl8j169hDWvWSLzT0w3ipqd40UHAFvDTLBED8krv7vd9jrZjmv/GDLt94+RgYG7Li1/jESQOXleqtOiV/Sf85v8HYSVOGZWIWNsf1KWfe7pNhJe2bll96ae0iwegsbZK5wx2c2UIo30AtEWT+oa4HuH3M/nATqH6ofCsbr+KSNFMAY0yMybIOIe9FN2LvMpUYcaiQukOSKzBtn6f4KvRSYBXqQHUGE9/45svwr6sv85J6BPK9YHlGUPWaXeJrv070vPEzu+JfI3dSsF9ZlBfwaBKODv8bLIXGXX4JeASm8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3148.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(39860400002)(346002)(376002)(44832011)(36756003)(4744005)(107886003)(1076003)(8936002)(7416002)(8676002)(83380400001)(186003)(4326008)(52116002)(5660300002)(6916009)(66476007)(6666004)(66556008)(2906002)(2616005)(316002)(38100700002)(54906003)(86362001)(478600001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tva6jbtarSat3Evn5ihXmjSUaZO9fp1RGsBrnoOv0yX2nLmz9ZmQuT6zP06m?=
 =?us-ascii?Q?CowKqmKF+l4oet1B+qW0iteT4LWCofW6ST1Ojezlu6OPleIPnxpuYgfReYON?=
 =?us-ascii?Q?MbaJgz30nct1XngLmCcv4/eST7YteZGdjPpWfCMAT7eKyUOeYpNsW3+EpY6i?=
 =?us-ascii?Q?QLbfXfahkOBFyvjd1/t4mq6jytGH7XFB8h41fy1hGY/FUnKZ8xsXP2raNHNv?=
 =?us-ascii?Q?L+bQy5q27Eci7LITBar2j8ZITaC8teFDVUDYD7F0AmOi+9A3UV4fCLvhR77t?=
 =?us-ascii?Q?D/mg4aM0X479BQrvGWIjUPSm73lhbVPPCz4xha5+cToS8R8bEQ5vWtVd3cYI?=
 =?us-ascii?Q?jXbtP9379JodwL7Dg2Y4vnkkl3RYIPtWHy7R78FozVCVaviuZhCttVIPF8ZA?=
 =?us-ascii?Q?+VAxbAgU7o68NtlJVE+IMB0bKFZql4oBo0lvmD8AarNMlTgHI05oXxvttHg0?=
 =?us-ascii?Q?Jp0C8+GKy/E9GVpIbOSmOZ8h/Jcb5xX3PTsAdAzqR+NzDnIEEglqEm1GSXxN?=
 =?us-ascii?Q?3cHUDQ3wvBCYcW24NoyZHWIVnPAcIyTaIocuq0g6TIRMRd8e3Y8LJ3ljeptU?=
 =?us-ascii?Q?L+tVAK6M0q3XHxjEItFRXTP5YKxVEROAQ/3WiyXXFZT/MOEPjjlHnSOEl/xj?=
 =?us-ascii?Q?8vyXIbgOk1so/i1277kTGoWra9wKIUzlrE25lU27v1p1vgn9IBanNd8GHvky?=
 =?us-ascii?Q?WtKPQhZGYI+yv2EebJ9mDB0MaV1X9g5DzGvvTFWpis3eARNaf7lnnKaI7ZJ/?=
 =?us-ascii?Q?mNnBUj0nVxwkKUVXy0yBrlvhbt/+cZvr/QAgslmaaYjPYN7YSvz6mVfhrnot?=
 =?us-ascii?Q?Uvm/iLItT1tj4wGmdqnIOeG45z0r6QLfJmvAls0VL1QndrRjgUtNJ5mS6chs?=
 =?us-ascii?Q?ZSHGUKc5Yv49tYIeFKMu1o/59dSx1hYUL2o+SJw9UEdvwt4VKlmmwwsDA6cI?=
 =?us-ascii?Q?iAL7wCnuT32sUboz4CNmgBvZtDKAm4aIJten3/0/K5eUFCH0+yVqedJ8b3/b?=
 =?us-ascii?Q?vXQtuylcJ0Saaz5jC6izR+su2S+ImFiMYj74aUUfFhv3U8vCndmbE13D9Xve?=
 =?us-ascii?Q?FF9dorUGCCkpe1ruRvqCeSEaxPKUAcu1CxYvo4FIA1T8wLIIyQMsjxxpfA3n?=
 =?us-ascii?Q?BOliS9YMJSVM2v2rSunEYYZbnJrUyxKmfz1+GWgjDbmwPAs/RzGCjgn0HPGK?=
 =?us-ascii?Q?38uaU/4jdrBgAs38ZVT51lKBDIJ362i7rrZ0HTCH3nxppodedFbT+P37X19O?=
 =?us-ascii?Q?bgCoISeMNkIi28iUdzcldN189T75RXJ1A2HUdBqmV13zHGd+gJAKkmmgx34J?=
 =?us-ascii?Q?QWFUZ7eJ35oF/K5YriJLI/r0tDdtcY/kxexzKoASPS2JaQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5d3e4e4-cfa3-4365-f528-08d97c22ae9d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3148.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2021 10:37:45.1594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r2ZOTKtonmGbopFPtTqXyLDcKnVabA60NhXDHImiH6tCLPNuHkcshrp1z3Lkh/MLcBp3CBGmOeShQiW+5j0WzR1RXsZQWy+LUIbR9FowLUs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3308
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10112 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109200064
X-Proofpoint-GUID: 6M_vuqAIzk5wv0EaPZ9JDKpI8lco8zS9
X-Proofpoint-ORIG-GUID: 6M_vuqAIzk5wv0EaPZ9JDKpI8lco8zS9
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Until more flags for kvm_run.emulation_failure flags are defined, it
is undetermined whether new payload elements corresponding to those
flags will be additive or alternative. As a hint to userspace that an
alternative is possible, wrap the current payload elements in a union.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 include/uapi/linux/kvm.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a067410ebea5..8618fe973215 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -402,8 +402,12 @@ struct kvm_run {
 			__u32 suberror;
 			__u32 ndata;
 			__u64 flags;
-			__u8  insn_size;
-			__u8  insn_bytes[15];
+			union {
+				struct {
+					__u8  insn_size;
+					__u8  insn_bytes[15];
+				};
+			};
 		} emulation_failure;
 		/* KVM_EXIT_OSI */
 		struct {
-- 
2.33.0

