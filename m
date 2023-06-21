Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5BD27378C6
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 03:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjFUBkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 21:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjFUBkJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 21:40:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61961170F
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 18:40:08 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35KLYDDo025936;
        Wed, 21 Jun 2023 01:39:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=iAdDFB8J0UJSnGaqk23VK+eckCBr9BJp9Ww9tZvUYTA=;
 b=am1OE5lX2lJ667ff68i7mKnsYu7Grx3RcuiRz6x9ncpRhSUxMB71Sc7JNCNcnKKw0eiF
 olc4cc4dvkBjpoJij9wftB+IZfTMQe3Nw3ALmPRPEUvOyWwinHCJLpyrGEIqRgmXsdSb
 kbRQVZo2UVlDIwuVJhlOfDI8arzG1MvI1gXjllxZdIWbIFG4NL21dGz6CY5qjMbvBJtg
 Aushh9kLSHuSiCG5iu9B4jYmbMVBt1mHH+3ujfXYAdFg3tlS1Mc0Pd9sJ5DE3fDZ8W6/
 eF1KwNjiZ6WxwQJ+0Gsd20p8WadDqO7JFZ3wt1SspLOYcdGDjo59CMJbUodE61+/oXUC vA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r93rbp7qg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jun 2023 01:39:01 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35L1KBiN005872;
        Wed, 21 Jun 2023 01:38:59 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r93955fq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jun 2023 01:38:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZcOc3m5AMWEYoT6ct1bJxabNu4gGQkOaY5Lr4u8wSF1TnUbBjuOFyEEjy2eMQN30YHpDmGgqOuqq+4XlHhUHKplXvXtZDtgWS5wLDjVY7hWTbpx3Gk2tQWm4nglZG+iC4IsEsdSZVEBSxkLa/S71CnDaLzfb6qbT/ODq+P7n1/drIkUKSS1RjWrRh2Q1I0Hv7MWsFX8CeydqWpE8MjQmpF9BYmJYxpZlz7hFKPg9ayZ9Pi1DHn6Lt39NiT+2h3WJMkzUNaaM81NS43YjXhAoyRDiDeE27BIRHYuZx6y9+bOo3bRzjVK53aNj1ALjCybSERomGroWx3Im9Usm5qc6Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iAdDFB8J0UJSnGaqk23VK+eckCBr9BJp9Ww9tZvUYTA=;
 b=DztO4u2VGU/ba6qKXQYghImD73sMCuB7QlkvY5RAVcYnASyAZUTlLrvdidRQJJS0Pv2F5gaVVJfXe4NoWywL4m/j4bck0/zRcq5OlaB7NTZbB1pBmKzwFZ2m//AunagIGmamRrNZAmy6AYLJ0GmWe4lL/2dGNRGwJhLE7VhRGfvw/jJdg4S53iAgmO+XWmjozZeEzgDZyPgJY6805K1MVWix/WE3ZynxY5d8Hzs3z5iTH5ZgWsAohw+DRrGBsgH3MfWHi2pAGR8jcAFUA74ECp60lQJYsO84UHCdnxX140Yk3FIl4YujQM5Iz3A84zFCqeeFCDUYKoJrEX3SEaNq3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iAdDFB8J0UJSnGaqk23VK+eckCBr9BJp9Ww9tZvUYTA=;
 b=fhs3lD3dILoQLRoig4q0rz1NBKPia9nmoH85wAgQb7gPHrF3nEVV+tSYv+pqnmbtY9baXQLMWwPjz/1zFAW6FK2PsEvOk/xJDlzRDmTExpiFGo1PxGFs8ympTVt5T4SlppRLPREojrIH0qQh/0+UjwVuzcu/tIE6B7aR25aVCfU=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by IA1PR10MB6783.namprd10.prod.outlook.com (2603:10b6:208:429::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Wed, 21 Jun
 2023 01:38:57 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::96aa:8e73:85a9:98b9]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::96aa:8e73:85a9:98b9%4]) with mapi id 15.20.6521.020; Wed, 21 Jun 2023
 01:38:57 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, mtosatti@redhat.com, joe.jin@oracle.com,
        likexu@tencent.com, like.xu.linux@gmail.com,
        zhenyuw@linux.intel.com, groug@kaod.org, lyan@digitalocean.com
Subject: [PATCH RESEND v2 1/2] target/i386/kvm: introduce 'pmu-cap-disabled' to set KVM_PMU_CAP_DISABLE
Date:   Tue, 20 Jun 2023 18:38:20 -0700
Message-Id: <20230621013821.6874-2-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230621013821.6874-1-dongli.zhang@oracle.com>
References: <20230621013821.6874-1-dongli.zhang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA1P222CA0030.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:22c::6) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|IA1PR10MB6783:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e9a0d65-f17b-4d35-a7bb-08db71f847a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V89G9nB0c937q01oeiqr0K0N8i80lAjxGtQVs7Wc7De0eJdFQ8489rM6rcJD0pKdZcp+D3MHwkyx8EwSzM1T2Uw/wXtgXOXNJdWCejVcQEO+e5pyRDuHNHT94MTSGCtgzSMWUmFYiLgYnbsquffJf3sFrjbdiNxdt6DD9uCUOV36BMIs3pvJvlCceyuloSwtLJMn1oey1BjMtMHTyYE2H/xID84l7AwPVu/qjlNJ0nK06nSB94A75B2SMJMzogrIm+wz16Rez9Befb9ikUkj9CkQSp3oIbXBBoimKitYFZ63lX6uYUxOt98p4jCo6VQG5j+w2dKjntfiIuJncq5/XM3EVD7sv0xcLxUfoYAuJj4B5iv94akn7kKMjrPe4t+Hn8/DIOvO5VYAldAMDhtYhdHD/SNoIp1SPt+/gQo3TxpZR6ysHAOf3WXBixHG06xzCREzS+zAEImpYS2rmTxe13qFP/+ydYRXK3bBidFdEgjCjBPYuwV509syd0cY5qPZnW12ZPfpUhnqYbP47Xw+yGzVV/jAMophK2YOX37oZXh+f9HcLrY5tN4jmwT3TdEk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(376002)(346002)(366004)(396003)(451199021)(2906002)(41300700001)(5660300002)(44832011)(8676002)(36756003)(8936002)(86362001)(478600001)(26005)(6506007)(1076003)(6512007)(186003)(6666004)(6486002)(66946007)(66476007)(66556008)(83380400001)(4326008)(316002)(38100700002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8VBn98GGCg5X/eOM5cspfcyUYkw+5Ei71Ry/BOXqBNP6dhGHseHG2MeFBoYN?=
 =?us-ascii?Q?qQ8aBbDstUcX/dlnAlbESyYdh1VGCATE49f9qU9THz9Z+0gC8f7m3KwE5Bhr?=
 =?us-ascii?Q?E8dz1qHziaTpYVqm19rYXwCmNQCYdfATa5JIPY+Y2u9Bo7rQkC6snDz2+taE?=
 =?us-ascii?Q?Yl+ls9IjmrJMRYRS+HV+kFMfvGLkhjd5SI3BecaoPknMKZL25OQhySXv2yUc?=
 =?us-ascii?Q?8H22bER+5d5dO4/Bu5GA2rJK6/k16XGxqfM9P+SOaXUgO/0i9idl59q+qc+E?=
 =?us-ascii?Q?R8W5HuaHL0LOdB5sIS9oz9HA8wZHuEXQARGGAxtP83m5ObnV/3/tTxBaGxPL?=
 =?us-ascii?Q?ar3jxjrWnyWh8HYir56qk1XXRcyS8Q8uoXwi9X+U7vse2pzFVC1fiJVLuP8P?=
 =?us-ascii?Q?Q8SU0FdtDDnvvNiZkw0HQqB8x0pM6UBOxRG1NIlxfe+HdCmezBOfhd9iPA/D?=
 =?us-ascii?Q?Yhep2RBqz7VJoJFhtJzBafPXdRrVXZB26L8OQOXDYJYhbvKm023ydQRsa/Dd?=
 =?us-ascii?Q?0UVQxVANh8+pjnJ+uSr2FmNhv3I/Fq+xyHb7+VXG9Om5VD20v4LUE7U9Y0V5?=
 =?us-ascii?Q?Lcgp/jrLlXVf0aSUX+eD33Ov+yLvqgkd3/39BI63ofE27chCzZPa2lZWhfD5?=
 =?us-ascii?Q?NZmHRAQmDr4WS9OPh5s0CMY1nGdvKQ2n3xHRFGQG90yKlGo5lmccVssc+1nR?=
 =?us-ascii?Q?p+xTP7l8OOW/3SooptQ9ZGnrbtfNKx4vy2nRifhfBctAQP/8Y8UU17gzSM5Y?=
 =?us-ascii?Q?dvpANnmaNrk8hbliSUn2j3DXf3zBccgbp08gAhfvGye1CYIfaGHnFF+F4Kkl?=
 =?us-ascii?Q?bO9lmvqtVV7C4M2/svsraOf9zsxbXPtEcw8e8rp5Si5ycrk614UgZF6St9UD?=
 =?us-ascii?Q?8kUZXVr+mLPcy1eNI7QAWwYji+DmqORMnBNbBbouNDazkNj9xtay22MQLpAl?=
 =?us-ascii?Q?E0fc3YIWTWxdlr7LzP7502QHTPgRCMycIZJXRSQxonBwUg4YaF9Y3Ep5uXhD?=
 =?us-ascii?Q?dcqjZBBmwx9ADhtu2p2jtXF20vVUdvc+iGuIZlG6CoQxyIkRJDtHDqTWjqns?=
 =?us-ascii?Q?3Ue5gM5+skWpEhFTFdvrJlDmIoTf/TvMKmb8MtICEGBiC8eiXt/V8j/YIVjr?=
 =?us-ascii?Q?KF7JtCHEHHtm+WrWP7TzvJqWGcO7ZaE1eB0xFZCj8X0uCtcC9Iiu1pbdw7Sf?=
 =?us-ascii?Q?x6MLpIkyjU8Yc673HDg33Orhu6oqCp4gWSGLMLME0UBZBSgn0Lyik1MgOK+f?=
 =?us-ascii?Q?4OhKqqcXR4PwY6YSinnbsg+StmMqVKiDdDdoUOK9UXAdTf9HyXC2ZwsWhhfE?=
 =?us-ascii?Q?cXEcV4wgGgQ+VSfWycYkoUMnPJL3FzvIQBD7B37Y7DE+nDu7C2Qknp7DvVnL?=
 =?us-ascii?Q?jO/M0f83eVQXcKa9X2ABeEL71MyjTRLdEsUBe24fH90iSrGWR3U9biHdcPTO?=
 =?us-ascii?Q?nCwcp9zs1Xs/+B52DWaIndNYOAaWrQV9G9PScYnH9YO5YTo7EQsNmEpux27J?=
 =?us-ascii?Q?2G3w062hmfL9p3NVOgKeQSESh/tfpqw9789NBuYrktZPQYb9UhP1d6wWXF5m?=
 =?us-ascii?Q?janNDodlvnSETxOEqY+i/3UxldYpmIztuPv8fuzB?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?T6paRdZQK7ECIqxP8A4Sec4XBY9TEk3ffz01ntf2lPEdiOAl4D64/02AUPQg?=
 =?us-ascii?Q?f+T77rbGTMs4RftO6UOwXFc0K4vSnK9Vb+JSxMbJIv99lKmWSE9STVAI/tOl?=
 =?us-ascii?Q?xndsHjJhpI6mjKWEpeFGBpQJow7zV6hStumRYdoSIUYqSbI48gK/oumJC1EY?=
 =?us-ascii?Q?AwgSQFxiLIXq8u8BSFAXkCcDfmGX91hwo5lzdEoiXWFVN4/SmipRE7+L892V?=
 =?us-ascii?Q?2V4JOeUxxDbXjEH7Uk6Ah71ZGkzGZQDdZpk0/Vuu9TCBpm7osrWYfQDaOo2g?=
 =?us-ascii?Q?uShNqO+/6kTwbFiizgHRfhBuNZEU9lmFNsCSV71UI3TgMoSzC20iuvA+hNDb?=
 =?us-ascii?Q?FAqQ6gkZhk+pUODUuepxNSZVXdLafEjkiKLuhZ5rCw55ZqoiaOTPKSaszUVa?=
 =?us-ascii?Q?ujcwQoBCE6DfE39WIL9Zd8owhGV89+2kM8yrUyHGYRBkDeKojNvAJRH7J0kN?=
 =?us-ascii?Q?yEg373+UZh8I1LT35Qo4/AOxzYkdikz3KQLcxODqBcz6XK5ZVlzQ4jktwQB3?=
 =?us-ascii?Q?NkMA3ia/Z8JC07UwJ8ne4Y6LvEgraWgYyuUufjXONp8EIz4I9QEoj8IhOb5R?=
 =?us-ascii?Q?53+pc9qkjeG1GocXvgNSS/0dGb8g13G5a6mA0j/HK6R/kLhZd/E8hFO+Hkx6?=
 =?us-ascii?Q?ifmamaVAsYkERxkx4QE2epH3pPCyYYohUXiwMRcULxp4FCYvkdQAWn29FUH4?=
 =?us-ascii?Q?8Fp6n/rWl+u7nJGoIHn2RII7sVpamh9o2DcTOIOsQdp3DTk23si1h86L8oqI?=
 =?us-ascii?Q?Z6f67FstxbJU/SoqhFFuvAjDLXiXs9NufyZczS7AsJ+jdTjtyfqCEVItE5n2?=
 =?us-ascii?Q?9EP62gwNVySDmwV+cwXpoyt2ou1HuxLKMX7INvnKyGjzZeH2OGXrCxZt8Z0u?=
 =?us-ascii?Q?St5E1/e6k/ibhQG5WlD0MiJxDrmxjrGKif4Wgf2gtt1DvRV2CqVn4AmOpKiq?=
 =?us-ascii?Q?4L6rCNhGZIA+lOeqcpd4ykvwKNCUZylcPoNOs1JE6FM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e9a0d65-f17b-4d35-a7bb-08db71f847a5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 01:38:57.2975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dkT1GhHszlUYSaJrHGSzUm00DYoHayJpQm7gRoDvfKBuBSqK5I34WOe+C9hC/Jh0I+j8NQi9VS5g//C4/bXuFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6783
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-21_01,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306210012
X-Proofpoint-ORIG-GUID: 5G8uJScsKhy3f6MUOVB7LYIvXVb_jGAD
X-Proofpoint-GUID: 5G8uJScsKhy3f6MUOVB7LYIvXVb_jGAD
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The "perf stat" at the VM side still works even we set "-cpu host,-pmu" in
the QEMU command line. That is, neither "-cpu host,-pmu" nor "-cpu EPYC"
could disable the pmu virtualization in an AMD environment.

We still see below at VM kernel side ...

[    0.510611] Performance Events: Fam17h+ core perfctr, AMD PMU driver.

... although we expect something like below.

[    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
[    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled

This is because the AMD pmu (v1) does not rely on cpuid to decide if the
pmu virtualization is supported.

We introduce a new property 'pmu-cap-disabled' for KVM accel to set
KVM_PMU_CAP_DISABLE if KVM_CAP_PMU_CAPABILITY is supported. Only x86 host
is supported because currently KVM uses KVM_CAP_PMU_CAPABILITY only for
x86.

Cc: Joe Jin <joe.jin@oracle.com>
Cc: Like Xu <likexu@tencent.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
Changed since v1:
- In version 1 we did not introduce the new property. We ioctl
  KVM_PMU_CAP_DISABLE only before the creation of the 1st vcpu. We had
  introduced a helpfer function to do this job before creating the 1st
  KVM vcpu in v1.

 accel/kvm/kvm-all.c      |  1 +
 include/sysemu/kvm_int.h |  1 +
 qemu-options.hx          |  7 ++++++
 target/i386/kvm/kvm.c    | 46 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 55 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 7679f397ae..238098e991 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3763,6 +3763,7 @@ static void kvm_accel_instance_init(Object *obj)
     s->xen_version = 0;
     s->xen_gnttab_max_frames = 64;
     s->xen_evtchn_max_pirq = 256;
+    s->pmu_cap_disabled = false;
 }
 
 /**
diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index 511b42bde5..cbbe08ec54 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -123,6 +123,7 @@ struct KVMState
     uint32_t xen_caps;
     uint16_t xen_gnttab_max_frames;
     uint16_t xen_evtchn_max_pirq;
+    bool pmu_cap_disabled;
 };
 
 void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
diff --git a/qemu-options.hx b/qemu-options.hx
index b57489d7ca..1976c0ca3e 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -187,6 +187,7 @@ DEF("accel", HAS_ARG, QEMU_OPTION_accel,
     "                tb-size=n (TCG translation block cache size)\n"
     "                dirty-ring-size=n (KVM dirty ring GFN count, default 0)\n"
     "                notify-vmexit=run|internal-error|disable,notify-window=n (enable notify VM exit and set notify window, x86 only)\n"
+    "                pmu-cap-disabled=true|false (disable KVM_CAP_PMU_CAPABILITY, x86 only, default false)\n"
     "                thread=single|multi (enable multi-threaded TCG)\n", QEMU_ARCH_ALL)
 SRST
 ``-accel name[,prop=value[,...]]``
@@ -254,6 +255,12 @@ SRST
         open up for a specified of time (i.e. notify-window).
         Default: notify-vmexit=run,notify-window=0.
 
+    ``pmu-cap-disabled=true|false``
+        When the KVM accelerator is used, it controls whether to disable the
+        KVM_CAP_PMU_CAPABILITY via KVM_PMU_CAP_DISABLE. When disabled, the
+        PMU virtualization is disabled at the KVM module side. This is for
+        x86 host only.
+
 ERST
 
 DEF("smp", HAS_ARG, QEMU_OPTION_smp,
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index de531842f6..bf4136fa1b 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -129,6 +129,7 @@ static bool has_msr_ucode_rev;
 static bool has_msr_vmx_procbased_ctls2;
 static bool has_msr_perf_capabs;
 static bool has_msr_pkrs;
+static bool has_pmu_cap;
 
 static uint32_t has_architectural_pmu_version;
 static uint32_t num_architectural_pmu_gp_counters;
@@ -2767,6 +2768,23 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
+    has_pmu_cap = kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY);
+
+    if (s->pmu_cap_disabled) {
+        if (has_pmu_cap) {
+            ret = kvm_vm_enable_cap(s, KVM_CAP_PMU_CAPABILITY, 0,
+                                    KVM_PMU_CAP_DISABLE);
+            if (ret < 0) {
+                s->pmu_cap_disabled = false;
+                error_report("kvm: Failed to disable pmu cap: %s",
+                             strerror(-ret));
+            }
+        } else {
+            s->pmu_cap_disabled = false;
+            error_report("kvm: KVM_CAP_PMU_CAPABILITY is not supported");
+        }
+    }
+
     return 0;
 }
 
@@ -5951,6 +5969,28 @@ static void kvm_arch_set_xen_evtchn_max_pirq(Object *obj, Visitor *v,
     s->xen_evtchn_max_pirq = value;
 }
 
+static void kvm_set_pmu_cap_disabled(Object *obj, Visitor *v,
+                                     const char *name, void *opaque,
+                                     Error **errp)
+{
+    KVMState *s = KVM_STATE(obj);
+    bool pmu_cap_disabled;
+    Error *error = NULL;
+
+    if (s->fd != -1) {
+        error_setg(errp, "Cannot set properties after the accelerator has been initialized");
+        return;
+    }
+
+    visit_type_bool(v, name, &pmu_cap_disabled, &error);
+    if (error) {
+        error_propagate(errp, error);
+        return;
+    }
+
+    s->pmu_cap_disabled = pmu_cap_disabled;
+}
+
 void kvm_arch_accel_class_init(ObjectClass *oc)
 {
     object_class_property_add_enum(oc, "notify-vmexit", "NotifyVMexitOption",
@@ -5990,6 +6030,12 @@ void kvm_arch_accel_class_init(ObjectClass *oc)
                               NULL, NULL);
     object_class_property_set_description(oc, "xen-evtchn-max-pirq",
                                           "Maximum number of Xen PIRQs");
+
+    object_class_property_add(oc, "pmu-cap-disabled", "bool",
+                              NULL, kvm_set_pmu_cap_disabled,
+                              NULL, NULL);
+    object_class_property_set_description(oc, "pmu-cap-disabled",
+                                          "Disable KVM_CAP_PMU_CAPABILITY");
 }
 
 void kvm_set_max_apic_id(uint32_t max_apic_id)
-- 
2.34.1

