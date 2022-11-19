Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECE9630EAF
	for <lists+kvm@lfdr.de>; Sat, 19 Nov 2022 13:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbiKSMa2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Nov 2022 07:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233106AbiKSMaY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Nov 2022 07:30:24 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3F72CC9A
        for <kvm@vger.kernel.org>; Sat, 19 Nov 2022 04:30:23 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AJC5ktV023869;
        Sat, 19 Nov 2022 12:29:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=5f8EqPVVYo6F5qbb4teZCR8BJKUksKlYsenY+52OdCA=;
 b=Y2U1HZyNI2pbOEv7eoBMQAWA0xh/yNN+fasn6Xke0+zLmn9VPKeudIEOo3zIb6q5YbHb
 wfjiLtM9R0oFNBqbX3ZnPHSw4rYCjFScE1SIKgEPsnlPJIcVas5DfPv8B+903j8cdLbJ
 26muJvV18tnbvtQQq3pqwUshep8wW0dpsSFpzCRMB6tzD2xjtL4hF32UJ0Ykb0s9fbMd
 xoflX9MjQHEQVyTChqaVqTqifsVk9mQh0v7fa4EuRA7jzpTQkckuhvFTHyuuV3ffxTZs
 Mc2ay1w0Gt7MFhKgbrzerRPA4+zUMQWC2ANUjXUsVCKmy2o/no40eFHx+PhevSoP8ol9 IA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kxs57gewx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Nov 2022 12:29:20 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AJCADUB031283;
        Sat, 19 Nov 2022 12:29:19 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk1vehk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Nov 2022 12:29:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BNAMjVnblA3xHRsZU8FRmNYCC89SRLZvmlAKsw04NkQmescU4wOLskFyt+JiEdqv2HlQWNDHR6GCzGAHr7SgIP2HHf2OYMTGLO9NBnpsDo8OHrrEcmJu/mVHxaBpuS1VjLeVoTlKp2gBMVY1ymcyFL7ZelQhLqatGXOzXIhAmRG+jgQn+5Kz/Q2H9fhveeW5qPVewIqJPHx106TNlp0oxo77NKVEOudST86W6XpFdDjxlvjGudGJZAPNd4jFjO9jqgVperN13fLPuZ4hA3RLyrrg8CMsRgYc5jHA5bVMogAhj0R3Q/mmpDcOmm/k++j2rxFPdOdjrcPebOELThTS3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5f8EqPVVYo6F5qbb4teZCR8BJKUksKlYsenY+52OdCA=;
 b=OUPNM4mRPCCKQsyaXNqoJv2B448nXnw+oj1nAaYmHelRVtiZvkUOarreDd7rWH6MNXSLQsr04eYiLKGjdwLEidHaB6CrU7dQ8a8Lmw8CLdBUlhWvzXkyg8X7OUt+dMF+glEKWJqiOjXTraj7v6zzLmMgOtZSgfGMm+hLr1vOfbVoRuzxsvGn9dtsRzUygyrwVK9Uhidu12RJsKaFsJoQ0XO+OLRLvjUep2GymtGxuIEK0q0GD2nAGcyKsNdBy1go8OyDkPsWD2MLgklKA3eCWiJwAg19JT+gj7XVP6ll99LkIlVvp/QjXIEW1OfVJ8KvxeyUGnwd6nQKs5Ey7DZuoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5f8EqPVVYo6F5qbb4teZCR8BJKUksKlYsenY+52OdCA=;
 b=Bq1lJL6TskqG7LLo7qu2lMiCtk4i5TF6rNcXK48dreR9bcCqDbwHxZQ6KDtfL2xDeTeKcw3+9ct+giz6OpK2Xi+lNaEujXNTA16LYlmGAZsz/yUKnsy/dSNfNtHoenASoGGndRdoRHUmsLL3NOXZ12Y8Ixz9jyy+4UqqR8WOMYg=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CY8PR10MB6443.namprd10.prod.outlook.com (2603:10b6:930:61::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Sat, 19 Nov
 2022 12:29:17 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::cf3b:2176:14e5:d04d]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::cf3b:2176:14e5:d04d%4]) with mapi id 15.20.5834.009; Sat, 19 Nov 2022
 12:29:17 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        qemu-ppc@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org
Cc:     pbonzini@redhat.com, peter.maydell@linaro.org, mtosatti@redhat.com,
        chenhuacai@kernel.org, philmd@linaro.org, aurelien@aurel32.net,
        jiaxun.yang@flygoat.com, aleksandar.rikalo@syrmia.com,
        danielhb413@gmail.com, clg@kaod.org, david@gibson.dropbear.id.au,
        groug@kaod.org, palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pasic@linux.ibm.com,
        borntraeger@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, iii@linux.ibm.com, thuth@redhat.com,
        joe.jin@oracle.com, likexu@tencent.com
Subject: [PATCH 3/3] target/i386/kvm: get and put AMD pmu registers
Date:   Sat, 19 Nov 2022 04:29:01 -0800
Message-Id: <20221119122901.2469-4-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221119122901.2469-1-dongli.zhang@oracle.com>
References: <20221119122901.2469-1-dongli.zhang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0003.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::16) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|CY8PR10MB6443:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c6a376f-fbd4-4afd-a2ea-08daca29ad09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Ak0FjIZQNn5J+uS5a6sTeftO5oij7EufR+jNpT50Oqe9BelTzqX5R27auEyKjxgZy89B6rqiWUE7ASrM3PrvtYnUi2TGAmFvPeCSKr2NErYOljBDrxk9G+3sqxSjU7+vlMmZo2tswTw/qlRpWsu47a6U4hQQx+/54bRaS66F4Uf/3oFbsViRPwKCgXoleUjHJdIigmkEjBQDzSKc4MgeLtrA0ios1JRbbbeH1JVwGtgEiJVsAgjcRKU76pnAAJxLJhGmB6lkwPWFGBnKJH9//ePB9PHgdqzd58FGz/pXKQQonyYt2RdhVSw18gDjRhYkNzIFRNT2CNYMy+saGrojBFUXQk69hJOx/HAWNJAvhl5ORiFufVKaA7v1ghN1T3vVjJR/526Ueq5sqFx4O0bP8I5G1BFPIJrZ7+QjWjvDl6H5yL+UGzG3FlKipkfVNm+5BqC9ns6rqf7GxRCzZEqHSVl7eif5H/UMJ7YyM1JeeSM4oNvXg4hh2HLpzXuXXxybDkCaRw0lCvZo5Om1/K1PdfHLbHXeaecEGYBFDwiNyZrXpvFZhTEYBOD9IlkISR+SvfQj1xKxluXGtRhMgGa6PvBQhuY5dQUMVtPMgRK2ripsC/Q+9L3NP+kCP2hTDeI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(396003)(39860400002)(136003)(346002)(451199015)(36756003)(38100700002)(2906002)(44832011)(8676002)(7416002)(4326008)(8936002)(83380400001)(86362001)(316002)(1076003)(2616005)(186003)(6486002)(478600001)(66556008)(66946007)(66476007)(5660300002)(41300700001)(6506007)(6512007)(6666004)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c47/RCX8+Dw9SwbKYW+TfqOk4VIp41J2hnfoczdvGkHWxdRUmnYgEs9CynMj?=
 =?us-ascii?Q?zLXgxnQF4jMM5T0hXmALCvSSSug2LuZwaCSzOwWUhU3IJH92lLQ4w7lMOjES?=
 =?us-ascii?Q?lhiqxyShOB70J5baGewlIwjU6Jt0vusbpFzQuTutU6Tm8SMcsFGMa9IaE7fA?=
 =?us-ascii?Q?fM8pUPHA6cbfXXHik2FymlNu+5kjRTXKJ30n0fe2S7rqH3Fsthfw1e+V/Xpy?=
 =?us-ascii?Q?DYhTGEsZzocHv87iwqUZ5Hx2iXkhyq7w2btxpyyNtxVchBPt5aopWeMQw1sH?=
 =?us-ascii?Q?Io4Pdbfob2Pi24IbP3ezXUiKIQ9bir2uSCZHk3DKiO3m9U4shHUSyOGIHw23?=
 =?us-ascii?Q?b8VXBF3iUyxVPUdUtxEKydZ5L6zsKXseLpCN4F9xqX4vgJE2efbt/JwfCNsp?=
 =?us-ascii?Q?RyQUNoqfuAxKg8sh0WXJeLQFj7/n0mRoBpJU1UQ3j7eFVNn/+E5xRiJT+OHb?=
 =?us-ascii?Q?osVReT5M63lLAKJ9BkmWJuoxsfbk07lWuvNWMxK7cWxuLyTXZuq7rCGujKTp?=
 =?us-ascii?Q?ESLyFVhQaeqfPr4FvMLzhc+sqviTTEXmS4kiV2co8BI3JUnnPTtlrFYmG4+T?=
 =?us-ascii?Q?cIiRVXgtqgQJHIyzbbemeIyNqL5I4EuLRdaUG4dFqQds56ZghWRFURRN1kFw?=
 =?us-ascii?Q?WXfsaylm7HOZpoU9NUqkvC4HpI+EzoXOPc6tLfeNQs0KJv7wOgn4i5oAa+4p?=
 =?us-ascii?Q?w9avH70DcfahDovz58IH5KL20K2p7dGF2QzvkPl+jkmkQgcyTKW0gSCjIyR0?=
 =?us-ascii?Q?zj0GS767P1lDDVzfHxI3o6IKoVfaluPAtwFU8w4yU8T6kyQSWOcZ9bse90+7?=
 =?us-ascii?Q?+T7d1E5IPMTN4eeF8iugVFzHzjsOJ1T6s/JODQ8MuI8ndqxgv8zmbpO7Z+kS?=
 =?us-ascii?Q?Lmbz4oBDlFbBxRG619l8qFEaPx3KAUZLNpbu85t4/5DCcU9RhB4cjBZGVNZK?=
 =?us-ascii?Q?9EbOfU1ITAgpoq8o4p+9yvDFYulTLB2O+wZWSfHp6n1MoJJBVBLVdpVbn0Dv?=
 =?us-ascii?Q?XDQ8eszKEjq7nqHfqt/hNHnpoq5kz1VrO3dgTisiez2bSzaWoZG7fPObPlm9?=
 =?us-ascii?Q?14Oa5Ydiw5ZN0GgDuGB/vgTXLb0vJb+HucSo1XKxXP0HF5Nn9ACnlRPb6xU/?=
 =?us-ascii?Q?fTsJyEN9QpqDCO585I8pq9ZeRYUzJ/7E7v9uqRjDKxsm/rrokz71blwRP2hd?=
 =?us-ascii?Q?8tywgbADPzz8nNfb01RzhGZPsBChcDB8kCvardckJGPU87K9WPab/ETVR9nr?=
 =?us-ascii?Q?6qd1cboWcHUoMSZ8Po6784Rd8OjGeZrxj/MLRsMrfODbhGF8kjtEJXXviIUr?=
 =?us-ascii?Q?S5zedwNTbZkQrOQXOLkJk8BKgNspVTQ22AjpNF/ZAgoOI1FzQ2T43itzZG37?=
 =?us-ascii?Q?jCmRirUGJy+lc6j+1d/EfU2uL2II8odRKTAqgOzWk/keWQt7OzHRDKbDrqxQ?=
 =?us-ascii?Q?9KqPjI73Hl+l7bCUzq8IEtAcBIH90HbnMswEQFjUIAAvOikUQh4ut4gsR0Y/?=
 =?us-ascii?Q?NCQa7Yn1FySchbDokZAC/lgB2qLg0jYGP7AZ0/xjJN2qaof8mb9pHZLfL/35?=
 =?us-ascii?Q?RuIOEz4lyy9FnpxKY3l7hBYkfG/5fR56ilXfsd+g?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?k0qBushpXMc4QXWaqnSae1BcWYrkIIpVUjLE99OiH9sY3beXhY5nNe9GuOCR?=
 =?us-ascii?Q?BgcDV608qyE1xsJlbrvOUIsZXEqy4uhn2w1PfhloRl0rEyP18Oo7PIuSHGf/?=
 =?us-ascii?Q?sQY9tnt9RX0I085M4AQ1DbJu0CumwFdETHjSPK3cR1hEeLcgrOzuPuzsiP1L?=
 =?us-ascii?Q?ZDajxyaiOQ9tSxa1wqB1bbu7Drio3VECtyfo3Cx84/SjIraDz8hBgQbl3nG/?=
 =?us-ascii?Q?J/yZWI0Cc6m3SLvnni3q7yHp34dzfvidUjic0w+CTY0DnsAHqBC/w0R/Ei/C?=
 =?us-ascii?Q?/jVX7RBWK22WAsPizUB/vFvAxB1XDUQhd8OdP99+f5D2bF+3kpgwS5KxcHOo?=
 =?us-ascii?Q?mfHSqNI0+4vxRSPWGJQ+nO8DF/8XiOUspduFwZN7VSrgPyjzjdXySYvFPGn+?=
 =?us-ascii?Q?+oH1sBjlNmd0vX7DzN67DI84xrQ1TvE6lveUpXfUPxiRd6/4bZJ9gy75uuUe?=
 =?us-ascii?Q?oid8KIKwwSid6BcU8XMLBe3KZIdyL2idiC/1oAy4Bk+UVS7NUUzTsYW9fTle?=
 =?us-ascii?Q?ovEATWxrvtNATF78ouUAHNcbUO3BKewFsfy7dbjYGHm0UhsHHOwt5e7OJb2Q?=
 =?us-ascii?Q?IEYd0X6p0ZgW5QU9hJT94muGyIPgtrBuuG1Gdmu6dIIJJUn/EztwOCGBh8EU?=
 =?us-ascii?Q?tiZcy1uVVOvIUeGsMXy5a6zR8EezXoXrZC9tKxaP2He53LWjGI9CTJWqZr8x?=
 =?us-ascii?Q?BDd784bpkL2HnM+RX6VJfHVvrBLYOmjauzzup+VbdQaSBRP8KW2h9q2TOBT2?=
 =?us-ascii?Q?qbL3/ToN9RN8ZhcJ1H0hySzehDHGB04RkOrdt227SsUrdTo4T/NDBBMILNvc?=
 =?us-ascii?Q?92YNgQ8TySKteqZV9QClW6W13A5TXawA+GjgyhPod/DJtq5hEgenhNYJh/jg?=
 =?us-ascii?Q?BbyH2hhgSRxfiahfZlo8MmEFaPU14BKVKXlxhmJQH2v09J00Lal7AisKN/C+?=
 =?us-ascii?Q?7KJzZGc0XtlDd6Fu8cSBnS/N+SyzjjDMJiomkxYueffcmAbLPwPzRD4hgEpU?=
 =?us-ascii?Q?HFTqoRC5W2Olx53dnDgPSoOfVAMq6X2pf/0yDWM1NddZwr+42XsA28WL04Ah?=
 =?us-ascii?Q?tu/Z8flwraVSLTRBCmmLA4vqXmLIrY2zv96/CCNwhbJT6sMEosggehq1vc6D?=
 =?us-ascii?Q?u504aM2fhREVrdHJZLf9vz0WHVLeBWotPWeXfVXdtQ2fcvuZgYeVCrWvVrfC?=
 =?us-ascii?Q?tEKQ3/MYoRdztbSceAgm2KEbDXoTVLKSn5ZLl4Fx8b77cZKi8OlgrSAYDW7X?=
 =?us-ascii?Q?r0EMAF64UpFPnrjUcGibscg+CuSTWshesOJKALwUwr49uLQnOXUmhs/8KuVi?=
 =?us-ascii?Q?7V2dPxic9BOyFHghep3lKrSV0PPOojSJnoji8K7udD9ABiwxyRTUBjHFys5z?=
 =?us-ascii?Q?SAgUo2DWSQpOm64d0OsZMo8Zldmj27oxP4CQiV6JVhuIflhitpYVOZzVGMVP?=
 =?us-ascii?Q?KRe7BbHLABfebVwlO1tTRffGPtHEfoy5SPzBaybRjiHYQwLBzZTGrH/Tu+Jj?=
 =?us-ascii?Q?TvUI5AatUFMhvKAgXgVGPQh/1/QQvT2s+z4ZLw6sR7NiUnFDxPdLZXunLiod?=
 =?us-ascii?Q?dxg9eF52PQh7xXPbOt7GPeO/T5OiTuX7zBq1bV1Ee+C8fMkwg1Xi6kM66LYl?=
 =?us-ascii?Q?/A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c6a376f-fbd4-4afd-a2ea-08daca29ad09
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2022 12:29:17.3937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RfaXHfoZt28PZiMn7E4YZxCszwyikJUdKXAmi1d1T8xrvLUg0O58RxUEu7LqcI0KeZoYTC9UD6TZiW+A+9C+Wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6443
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-18_08,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211190092
X-Proofpoint-ORIG-GUID: O3xHhyl0hNM8W-bLzbQePmLVIoIQN6ei
X-Proofpoint-GUID: O3xHhyl0hNM8W-bLzbQePmLVIoIQN6ei
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The QEMU side calls kvm_get_msrs() to save the pmu registers from the KVM
side to QEMU, and calls kvm_put_msrs() to store the pmu registers back to
the KVM side.

However, only the Intel gp/fixed/global pmu registers are involved. There
is not any implementation for AMD pmu registers. The
'has_architectural_pmu_version' and 'num_architectural_pmu_gp_counters' are
calculated at kvm_arch_init_vcpu() via cpuid(0xa). This does not work for
AMD. Before AMD PerfMonV2, the number of gp registers is decided based on
the CPU version.

This patch is to add the support for AMD version=1 pmu, to get and put AMD
pmu registers. Otherwise, there will be a bug:

1. The VM resets (e.g., via QEMU system_reset or VM kdump/kexec) while it
is running "perf top". The pmu registers are not disabled gracefully.

2. Although the x86_cpu_reset() resets many registers to zero, the
kvm_put_msrs() does not puts AMD pmu registers to KVM side. As a result,
some pmu events are still enabled at the KVM side.

3. The KVM pmc_speculative_in_use() always returns true so that the events
will not be reclaimed. The kvm_pmc->perf_event is still active.

4. After the reboot, the VM kernel reports below error:

[    0.092011] Performance Events: Fam17h+ core perfctr, Broken BIOS detected, complain to your hardware vendor.
[    0.092023] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR c0010200 is 530076)

5. In a worse case, the active kvm_pmc->perf_event is still able to
inject unknown NMIs randomly to the VM kernel.

[...] Uhhuh. NMI received for unknown reason 30 on CPU 0.

The patch is to fix the issue by resetting AMD pmu registers during the
reset.

Cc: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 target/i386/cpu.h     |  5 +++
 target/i386/kvm/kvm.c | 83 +++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 86 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index d4bc19577a..4cf0b98817 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -468,6 +468,11 @@ typedef enum X86Seg {
 #define MSR_CORE_PERF_GLOBAL_CTRL       0x38f
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL   0x390
 
+#define MSR_K7_EVNTSEL0                 0xc0010000
+#define MSR_K7_PERFCTR0                 0xc0010004
+#define MSR_F15H_PERF_CTL0              0xc0010200
+#define MSR_F15H_PERF_CTR0              0xc0010201
+
 #define MSR_MC0_CTL                     0x400
 #define MSR_MC0_STATUS                  0x401
 #define MSR_MC0_ADDR                    0x402
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 0b1226ff7f..023fcbce48 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2005,6 +2005,32 @@ int kvm_arch_init_vcpu(CPUState *cs)
         }
     }
 
+    if (IS_AMD_CPU(env)) {
+        int64_t family;
+
+        family = (env->cpuid_version >> 8) & 0xf;
+        if (family == 0xf) {
+            family += (env->cpuid_version >> 20) & 0xff;
+        }
+
+        /*
+         * If KVM_CAP_PMU_CAPABILITY is not supported, there is no way to
+         * disable the AMD pmu virtualization.
+         *
+         * If KVM_CAP_PMU_CAPABILITY is supported, "!has_pmu_cap" indicates
+         * the KVM side has already disabled the pmu virtualization.
+         */
+        if (family >= 6 && (!has_pmu_cap || cpu->enable_pmu)) {
+            has_architectural_pmu_version = 1;
+
+            if (env->features[FEAT_8000_0001_ECX] & CPUID_EXT3_PERFCORE) {
+                num_architectural_pmu_gp_counters = 6;
+            } else {
+                num_architectural_pmu_gp_counters = 4;
+            }
+        }
+    }
+
     cpu_x86_cpuid(env, 0x80000000, 0, &limit, &unused, &unused, &unused);
 
     for (i = 0x80000000; i <= limit; i++) {
@@ -3326,7 +3352,7 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
             kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, env->poll_control_msr);
         }
 
-        if (has_architectural_pmu_version > 0) {
+        if (has_architectural_pmu_version > 0 && IS_INTEL_CPU(env)) {
             if (has_architectural_pmu_version > 1) {
                 /* Stop the counter.  */
                 kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
@@ -3357,6 +3383,26 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
                                   env->msr_global_ctrl);
             }
         }
+
+        if (has_architectural_pmu_version > 0 && IS_AMD_CPU(env)) {
+            uint32_t sel_base = MSR_K7_EVNTSEL0;
+            uint32_t ctr_base = MSR_K7_PERFCTR0;
+            uint32_t step = 1;
+
+            if (num_architectural_pmu_gp_counters == 6) {
+                sel_base = MSR_F15H_PERF_CTL0;
+                ctr_base = MSR_F15H_PERF_CTR0;
+                step = 2;
+            }
+
+            for (i = 0; i < num_architectural_pmu_gp_counters; i++) {
+                kvm_msr_entry_add(cpu, ctr_base + i * step,
+                                  env->msr_gp_counters[i]);
+                kvm_msr_entry_add(cpu, sel_base + i * step,
+                                  env->msr_gp_evtsel[i]);
+            }
+        }
+
         /*
          * Hyper-V partition-wide MSRs: to avoid clearing them on cpu hot-add,
          * only sync them to KVM on the first cpu
@@ -3817,7 +3863,7 @@ static int kvm_get_msrs(X86CPU *cpu)
     if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_POLL_CONTROL)) {
         kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, 1);
     }
-    if (has_architectural_pmu_version > 0) {
+    if (has_architectural_pmu_version > 0 && IS_INTEL_CPU(env)) {
         if (has_architectural_pmu_version > 1) {
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
@@ -3833,6 +3879,25 @@ static int kvm_get_msrs(X86CPU *cpu)
         }
     }
 
+    if (has_architectural_pmu_version > 0 && IS_AMD_CPU(env)) {
+        uint32_t sel_base = MSR_K7_EVNTSEL0;
+        uint32_t ctr_base = MSR_K7_PERFCTR0;
+        uint32_t step = 1;
+
+        if (num_architectural_pmu_gp_counters == 6) {
+            sel_base = MSR_F15H_PERF_CTL0;
+            ctr_base = MSR_F15H_PERF_CTR0;
+            step = 2;
+        }
+
+        for (i = 0; i < num_architectural_pmu_gp_counters; i++) {
+            kvm_msr_entry_add(cpu, ctr_base + i * step,
+                              env->msr_gp_counters[i]);
+            kvm_msr_entry_add(cpu, sel_base + i * step,
+                              env->msr_gp_evtsel[i]);
+        }
+    }
+
     if (env->mcg_cap) {
         kvm_msr_entry_add(cpu, MSR_MCG_STATUS, 0);
         kvm_msr_entry_add(cpu, MSR_MCG_CTL, 0);
@@ -4118,6 +4183,20 @@ static int kvm_get_msrs(X86CPU *cpu)
         case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL0 + MAX_GP_COUNTERS - 1:
             env->msr_gp_evtsel[index - MSR_P6_EVNTSEL0] = msrs[i].data;
             break;
+        case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL0 + 3:
+            env->msr_gp_evtsel[index - MSR_K7_EVNTSEL0] = msrs[i].data;
+            break;
+        case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR0 + 3:
+            env->msr_gp_counters[index - MSR_K7_PERFCTR0] = msrs[i].data;
+            break;
+        case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTL0 + 0xb:
+            index = index - MSR_F15H_PERF_CTL0;
+            if (index & 0x1) {
+                env->msr_gp_counters[index] = msrs[i].data;
+            } else {
+                env->msr_gp_evtsel[index] = msrs[i].data;
+            }
+            break;
         case HV_X64_MSR_HYPERCALL:
             env->msr_hv_hypercall = msrs[i].data;
             break;
-- 
2.34.1

