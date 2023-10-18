Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D2B7CEB14
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 00:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbjJRWRv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 18:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjJRWRu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 18:17:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EB0114;
        Wed, 18 Oct 2023 15:17:48 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39IIp6F2018146;
        Wed, 18 Oct 2023 22:16:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=0S7AhvO2r1Sn1Aa/lDwDJew3h+/4QcW63K+NKu+NC5Q=;
 b=EMLlhEJMk+u83ogznJBxB2geY0LgKaFaxYkmXwU0ddAdpPmoUWuO67E/PBYxHTXXJD8s
 /vZbzM5WszGPWi1bP7dGp8xzyTdTyvW4TParkICrBlQPTUx5jeASuj6s0gSbO5TA07XN
 Qnq5LlBV5tDhK3i0M7buQIzlcXB8l/CGmnFcidfcB4S0Xi17p1ye5SJLuXZdn+/luoQq
 8bUHKWAdrogvn3DAn2Ri4QBjZPfSc84ajMAw3viYW17XZeQik+RZkk78a9HjbLeK+O1Z
 eP8i0LLCoMDTtFQKNum1HrlZmQN3sc6t+b4NoEnWHrqIKq02xf7rq4cmYDqYPCIvOw2q jA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqkhu8ru1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 22:16:58 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39IKCSLO015439;
        Wed, 18 Oct 2023 22:16:57 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg1h43dw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 22:16:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bixzI537eDPelgaARUVyBvRdfr6pTsQRVJgiFLuxoBlYK4CWSU4jF1deaHA+ncFgGUFmPVF2hqBqGDZUNTBFUG3p3xkjwDtNcpHFl14Deeuk+SPqqNRCuJZihyXaI0yLVmWb7hpYhcpyTS8zTAdSfbSUTfJQr5MOICgP9M1diFNfsqU8V5nK+wQCX9qRYr2I4rkLpzimoAovdnChH1XL81ax++yjj3k0xhM51iR0lUf+1Dr+mtkUnVdV7FqZGBOhhvqt2yF/gnmyyJwk370zQC4eAelFvdDrjxWbd6YXOpUSIkhgQhYyEW7aNKFwyxJjIcF6nFfZZrMEpy54wAe9zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0S7AhvO2r1Sn1Aa/lDwDJew3h+/4QcW63K+NKu+NC5Q=;
 b=Rn+ucqTUJynw04DR6xNsxhSSpr4w7M+vjpCJAHIAq54FIMxdz74tLH4eIyj6eR+Um8GkVOzVy6MY+m7SC+hmVrqg+h/Fz+N9NaAr38fIBXiX3DD3Uhein2+uqRce6/UQfxfFBoN9+Oq53jHdLabG9rY7K/k0WcP69cGhOdfSR104mkljM6tMbE4qwb8c/RsbUHl0ohTbwNx8+uFsozEQXtQd7cPUOIsUhZcTJkyokvGo+E50iT3OS9IjcYJPTPCDoAk2kpCgRZ+OwNgRx6pAaDVf3W1fbikRM4NVruCM59/JExhVR0IyR1opfZiSuJI+U4lAPzwGJhY9Qh/fbjp68w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0S7AhvO2r1Sn1Aa/lDwDJew3h+/4QcW63K+NKu+NC5Q=;
 b=QDCD5IYoFpHLdPWHaS7rE3z5KX/4d/C0Rv5YUEKjPZY/dwo5DEVS37fq6MUIAA46blOZvh82JFAOYx50bT5rEH3e6oVOKYFvJmbDRbt3npKlSB8FLEht1fHz/A0O71ZzUzTy9f/+KTKMhK8v5r+ComFq+f6IGNZm/TKnKFnSIt0=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by DS7PR10MB7324.namprd10.prod.outlook.com (2603:10b6:8:ec::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34; Wed, 18 Oct
 2023 22:16:54 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8e27:f49:9cc3:b5af]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8e27:f49:9cc3:b5af%7]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 22:16:54 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     x86@kernel.org, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, pv-drivers@vmware.com,
        xen-devel@lists.xenproject.org, linux-hyperv@vger.kernel.org
Cc:     jgross@suse.com, akaher@vmware.com, amakhalov@vmware.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, pbonzini@redhat.com,
        wanpengli@tencent.com, vkuznets@redhat.com, peterz@infradead.org,
        seanjc@google.com, dwmw2@infradead.org, joe.jin@oracle.com,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH RFC 1/1] x86/paravirt: introduce param to disable pv sched_clock
Date:   Wed, 18 Oct 2023 15:11:23 -0700
Message-Id: <20231018221123.136403-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0189.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::14) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|DS7PR10MB7324:EE_
X-MS-Office365-Filtering-Correlation-Id: 62c8e463-993a-4f82-687d-08dbd027ef2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j/VlSwLWHQUJRWPrSQb1bQIIdNsAc/3mESMXa/yHu84sOPEWdjn0h1yGAeFQLajdF7grAPXZJb9l1SzDNucq6EFGsWtefIZo3/u/hBm1ziKtkPI8NyRwjm6t4yH32mz4MWdgSqIlFnccC+RRr3vT2lzB9uHDbOMfoGVV0/xHfGpg/mBkbTGJXr+X5w225nNBGgDqMuN88FGqLzdoi+y2bWCplCSpoSLOkcqUB7mCxDB2e1NDyc/nlfzEPVM5qOkR/MwpmksXtp35AHfL6VitX+XEhd1vBOBf0/GljmTf5kEm/4ue6BnEN2D4lXhPYX4Bo0y1un38ajgYbi9zVigyF7Pg0q/Nai0cvm+U9arVPROj8YWETryViE9H/Q3ZzysctHI9KGxNPWS4uZcyF4bigWkeNi0JAYUrHfofbduCNeGUAxuMwk/fcLMgGkVQs4Jrn39EasQdtUhuOmbiT+1ljt7iKyCP5yILO59Frb/wDpFXzP0IaRRw9cL/302wPZeR4+A7SQaDtl5vBcM3JfHR3Ud/zJhbB81lSi0OWonlzhYwY5OFS6hPHYHmFLmO5KMNlUVT6VpwqDicD1MLVU55Vw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(396003)(376002)(136003)(39860400002)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(36756003)(66476007)(86362001)(66946007)(38100700002)(2616005)(83380400001)(41300700001)(6512007)(26005)(6506007)(1076003)(6666004)(2906002)(478600001)(966005)(44832011)(7416002)(5660300002)(66556008)(316002)(8676002)(6486002)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mxL2wChVYcC177zpdi5qB+ttYnygWQw2vGxc7XlJUNSJKwSrf0CzuR/AOMAp?=
 =?us-ascii?Q?UtD+SiEU9aNz1BeobZMBS2U+Fj8Vdu2GJ7+yc3fen2moJj0QozhF7htGUt3N?=
 =?us-ascii?Q?M+nlOzyD6ES1lU0TR2lIpMg9DGmRp8DJp+XfkHFdOoLHEvZpnrxIxtrjc3N8?=
 =?us-ascii?Q?cSgm8r88uvdgaS6sWFPJACAnkLkz7P8MHZ2TSkSaK40NwyEhEOuxY+9EyROJ?=
 =?us-ascii?Q?EKBBwO0ZGOhgzNAgUNNyYa6+TKXpoz1Lem22MtT2X393HpuX/z0qZRV4LyYf?=
 =?us-ascii?Q?OqOm9BwUlskbqJPkS7aJpluKzNl92MnrOfDoT7HhIidVk3yQQMVCSKsqcqh9?=
 =?us-ascii?Q?oVivNFuac/DdO1iQNLqin2vD27tO5stiNrSaRAb2BCHeGwfF2LIlbzB5l0hE?=
 =?us-ascii?Q?+yLqESlne0xR1pSMfHqXLW6opiLx6Ir/PuHfujfUa1ua/to09fjmsZGllxZ+?=
 =?us-ascii?Q?/NAQAyKFoOoI8VyEAXcvXjZz3PMfIp1DG7wD+a3i6Tgt2CMv/9/XM1uaHCrq?=
 =?us-ascii?Q?3mU9pyXJW5tFGOAqgrnV9TrtrBsTWiVYVQrRAeZDAe6AH3IUwmydQrmF8Uh9?=
 =?us-ascii?Q?Jsje2V44KpkFN8GTYvkTTBtUlZzfGL+sduL6aNbRRVNflijPrCb3LRLl+iON?=
 =?us-ascii?Q?7369OImAy+JEZlglJT79Am3laJd6adA6S3YWJ3rOP8lbxhkqSP5aIocg2BJT?=
 =?us-ascii?Q?/Dwkep+DT2+vS0SMHD1I4+PYv/9WPlM1Dp2n5HlyPKcVc8r2KLzl9Sv5t165?=
 =?us-ascii?Q?SKN80ZcbtXKjtgF1AN5ZK+A6nQVYpoJomwUbFN+cJ1pEdXSgEAmLI45DWiPh?=
 =?us-ascii?Q?D60myZQDPKfXHrfWbuE+n1LtNokUHLuNxSEKCP0oHqQzupL7c+TFFxy+RDAa?=
 =?us-ascii?Q?m7kNdggytxe4hVvuGDz0hRxDziVmylneRpPxKFWeV6hqgr4kRHrhyo5JJ3io?=
 =?us-ascii?Q?eCYwUhtYR5aNffC1ZzvUli7Maynbufc8Vv560MycipKJXIN+CGVu/Ml+AO3z?=
 =?us-ascii?Q?rnXy9/h+1bFQpnJNa4IQGP61aKYD4PitGnGDsNzyFKMAlxRKHGfgGz8If6ay?=
 =?us-ascii?Q?CtDvR1GCEsVxAHH+fksCus7x3xzV7exOn3qQvbmMNXrXOxFoBKDulDvyczwP?=
 =?us-ascii?Q?QBIAT4xHmS8R4+79uOkyXLCNUF2p1V8jHWszdm3nA3hyBcK3y/t6/itzSpnw?=
 =?us-ascii?Q?0kgni1jT1zFSXbWLeSeVV5GZ8ZyQWp8cenzTINPuDKECLxWO7vbNbPD6Ux5j?=
 =?us-ascii?Q?uFol7aB/aCtDk5uX+HVE9BBeOseAnju0JvCkbi7Z3rOvbTOVPFlnTbP22+Ha?=
 =?us-ascii?Q?xaykVkV5Hjx3iIGzXqDOEsXR3YudD9MVcPjamEZlhZSVixKbD/6uLvil1Au6?=
 =?us-ascii?Q?4TOyJWvoPqdDAKvOfEiFMPY+zrqNlEACw+ik1NlNwgb7peTNZFwHpLGzDQ4J?=
 =?us-ascii?Q?lMG8j4f+RscoWd5D3ysc50mf1uqcu1mJNbU2ns/iTOwChMus1XbVP9leVWGu?=
 =?us-ascii?Q?EB6kFBSI5pSvklv1oyxHXYdLMNmyJu2Y6zRZG0sFy8AfU85ZneeYnGUsvr6c?=
 =?us-ascii?Q?b7Bti6Av9S9a3qyEcJ6bhNpdEprpa6DTbRiqCn0y?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?laHDKK39RvH2ouOnaZEwE7qXGr+KH10B+VzCPEwrmRTl0XV2ABIWgjkmUf0s?=
 =?us-ascii?Q?497NogqiqBIDJkxePdcYExoPtmRJOlro+fk1N5LqCSuF0utXL5MLHCkleaRM?=
 =?us-ascii?Q?ZG0ERD3fryi45tcJ6EesJKj0f8UDLDe8csUs7Q62vBKbxi351PNii9wLOCbc?=
 =?us-ascii?Q?M2vm62IjQYb1fsGT+2tHHERgQV9be0AekWsi431oxTLFhrgNGccjvR7Q/GVx?=
 =?us-ascii?Q?6TV5pwF8PIyh9Xcr56dw7kqy0m8ggkhs+cJq5+Kpi4LsM1/v9cwFDdTqrKnQ?=
 =?us-ascii?Q?jY5b++9V/KCYNX9z11hUszvnbC0GZ6XwOSwx02XYGDoihOSA5mT86BCGUU/v?=
 =?us-ascii?Q?5a6hgvZSjFVFXbZ2VdR6W5byvnHKTgl7NbEHUoshCzlhEL4pquAofwOT8JRX?=
 =?us-ascii?Q?1vDD6qbtjGexhFYQhyN3e9HNDV9Ft0lJ0mIoIJLjFIcUKYBUHL675RmHoQ4r?=
 =?us-ascii?Q?BC1fGjMV04uaausCWP173BXppbPKCNUQl3/TkW3CnVCWQyScTLNEykrcdzY0?=
 =?us-ascii?Q?TnKQpj28WAiBvC9DOhmSxut+wxgbbdqg0V2NEdLIZSoy6IneTFahDp7I/VI1?=
 =?us-ascii?Q?7DtCzK0YQ3y4HN8pz35VFMnYdBwr4YyJ2BhGyOSCiTMQF6En8yX4DHEWtuis?=
 =?us-ascii?Q?qC3zMDbdIsfHb8QORKoAZWygCKL1wGkVqCsxDf3fDWTorzhMYvCKBN/ldIGK?=
 =?us-ascii?Q?NA79exEi3U6jNXQVF1UjGn7dTrqPVllM1f4hIkJUdE7iAbsjdnJeKbqhsBHJ?=
 =?us-ascii?Q?jht1j2zG1ALP6hPyYMXJqvWICizOVLqZ4EtcCplS5OTmmya7hY2+LlfC4oHA?=
 =?us-ascii?Q?y/n5YFtn4OtS568bU4NNqdvqdQLoqBZ+wPOL0K0CI98QROm2MGY8kyfOA4Hv?=
 =?us-ascii?Q?p9J4qdCIgXvAmSoRqkpv006Lv3TzxAUnymecuBw/pQSevjRhaEwWeKtC4ti7?=
 =?us-ascii?Q?2GWuJ/N7gjp8ugcpnT7EFd76nWABhqGY8+qufOOQaoPP9u0DHGDqSTtFGVB8?=
 =?us-ascii?Q?zzHUA2uOkoLD/YocRLaFwPSqSlGxiR2qzBemmDJ/gHhhItQMGHlNKwR10cc4?=
 =?us-ascii?Q?sTVPQA0n0UMj0vPpgIDmHrBK+xfUhK/VKTbDZHSs+jQx76Hbwyw+nsBrJqDo?=
 =?us-ascii?Q?hUtFCgPRbZvVk1rJ0TN7OFR8EEXi7vlHvwxZ7xO9Wy5XP2yfdE0wldkxiIob?=
 =?us-ascii?Q?owZ1yeaeZwtJr2R1s0qp/lGWAMy2N8FyFfaF/E1ezhDKvnghuIlFzWQ4BGE?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62c8e463-993a-4f82-687d-08dbd027ef2c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 22:16:53.9536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VPUQs7wZovusS4MG23uJQt5z0aDrsF2gONM82Y5ICqmgOxcR5TxavE8HyoKGy/lpUIcVXjf5/mHGy1tvcQW/Rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7324
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-18_18,2023-10-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310180183
X-Proofpoint-GUID: I_9Vn3ylX5O_ShZeLzA9mAADAWz4pA27
X-Proofpoint-ORIG-GUID: I_9Vn3ylX5O_ShZeLzA9mAADAWz4pA27
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As mentioned in the linux kernel development document, "sched_clock() is
used for scheduling and timestamping". While there is a default native
implementation, many paravirtualizations have their own implementations.

About KVM, it uses kvm_sched_clock_read() and there is no way to only
disable KVM's sched_clock. The "no-kvmclock" may disable all
paravirtualized kvmclock features.

 94 static inline void kvm_sched_clock_init(bool stable)
 95 {
 96         if (!stable)
 97                 clear_sched_clock_stable();
 98         kvm_sched_clock_offset = kvm_clock_read();
 99         paravirt_set_sched_clock(kvm_sched_clock_read);
100
101         pr_info("kvm-clock: using sched offset of %llu cycles",
102                 kvm_sched_clock_offset);
103
104         BUILD_BUG_ON(sizeof(kvm_sched_clock_offset) >
105                 sizeof(((struct pvclock_vcpu_time_info *)NULL)->system_time));
106 }

There is known issue that kvmclock may drift during vCPU hotplug [1].
Although a temporary fix is available [2], we may need a way to disable pv
sched_clock. Nowadays, the TSC is more stable and has less performance
overhead than kvmclock.

This is to propose to introduce a global param to disable pv sched_clock
for all paravirtualizations.

Please suggest and comment if other options are better:

1. Global param (this RFC patch).

2. The kvmclock specific param (e.g., "no-vmw-sched-clock" in vmware).

Indeed I like the 2nd method.

3. Enforce native sched_clock only when TSC is invariant (hyper-v method).

4. Remove and cleanup pv sched_clock, and always use pv_sched_clock() for
all (suggested by Peter Zijlstra in [3]). Some paravirtualizations may
want to keep the pv sched_clock.

To introduce a param may be easier to backport to old kernel version.

References:
[1] https://lore.kernel.org/all/20230926230649.67852-1-dongli.zhang@oracle.com/
[2] https://lore.kernel.org/all/20231018195638.1898375-1-seanjc@google.com/
[3] https://lore.kernel.org/all/20231002211651.GA3774@noisy.programming.kicks-ass.net/

Thank you very much for the suggestion!

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 arch/x86/include/asm/paravirt.h |  2 +-
 arch/x86/kernel/kvmclock.c      | 12 +++++++-----
 arch/x86/kernel/paravirt.c      | 18 +++++++++++++++++-
 3 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 6c8ff12140ae..f36edf608b6b 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -24,7 +24,7 @@ u64 dummy_sched_clock(void);
 DECLARE_STATIC_CALL(pv_steal_clock, dummy_steal_clock);
 DECLARE_STATIC_CALL(pv_sched_clock, dummy_sched_clock);
 
-void paravirt_set_sched_clock(u64 (*func)(void));
+int paravirt_set_sched_clock(u64 (*func)(void));
 
 static __always_inline u64 paravirt_sched_clock(void)
 {
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index fb8f52149be9..0b8bf5677d44 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -93,13 +93,15 @@ static noinstr u64 kvm_sched_clock_read(void)
 
 static inline void kvm_sched_clock_init(bool stable)
 {
-	if (!stable)
-		clear_sched_clock_stable();
 	kvm_sched_clock_offset = kvm_clock_read();
-	paravirt_set_sched_clock(kvm_sched_clock_read);
 
-	pr_info("kvm-clock: using sched offset of %llu cycles",
-		kvm_sched_clock_offset);
+	if (!paravirt_set_sched_clock(kvm_sched_clock_read)) {
+		if (!stable)
+			clear_sched_clock_stable();
+
+		pr_info("kvm-clock: using sched offset of %llu cycles",
+			kvm_sched_clock_offset);
+	}
 
 	BUILD_BUG_ON(sizeof(kvm_sched_clock_offset) >
 		sizeof(((struct pvclock_vcpu_time_info *)NULL)->system_time));
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 97f1436c1a20..2cfef94317b0 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -118,9 +118,25 @@ static u64 native_steal_clock(int cpu)
 DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
 DEFINE_STATIC_CALL(pv_sched_clock, native_sched_clock);
 
-void paravirt_set_sched_clock(u64 (*func)(void))
+static bool no_pv_sched_clock;
+
+static int __init parse_no_pv_sched_clock(char *arg)
+{
+	no_pv_sched_clock = true;
+	return 0;
+}
+early_param("no_pv_sched_clock", parse_no_pv_sched_clock);
+
+int paravirt_set_sched_clock(u64 (*func)(void))
 {
+	if (no_pv_sched_clock) {
+		pr_info("sched_clock: not configurable\n");
+		return -EPERM;
+	}
+
 	static_call_update(pv_sched_clock, func);
+
+	return 0;
 }
 
 /* These are in entry.S */
-- 
2.34.1

