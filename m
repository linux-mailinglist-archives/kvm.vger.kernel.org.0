Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12B0630EAD
	for <lists+kvm@lfdr.de>; Sat, 19 Nov 2022 13:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbiKSMa3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Nov 2022 07:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233122AbiKSMaY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Nov 2022 07:30:24 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9FD2CDC2
        for <kvm@vger.kernel.org>; Sat, 19 Nov 2022 04:30:23 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AJC5ktU023869;
        Sat, 19 Nov 2022 12:29:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=6pheb86MaVGWRtjTs02g7r6tWkNjgZ8somyUJZmhfGk=;
 b=XM9rjmc4XwlAYaHS47HJa1tpC1Sj3+3AT+YocGC53gDf8a+vz1dYdprgj0qHNUDzpFon
 jVYw1fAR/tRdYGg2FZWjeL2p9NZeYOL7NV5hCCdBPV0qlfI3ab0WU0JPqgwBVJVL/7gx
 0A2yz0BUMA6YsLRg6LsLYOZ9B+Izrwlvmfi23FtgyYgTIDpijV1g0juYQVbid26FhGCr
 y75dBkTMzRdFoFCzadmwJKzDvFwX92b2YvnxtrrXlM1N2KDlI5yXDPge8wbgt4S3+kP3
 hKUSCSXwXBCfzHxb8TLm8kdfzIWfe/u/s3fYhXGxWx5qWWDpRiYLs9hh2uT+7O4UspZf 8w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kxs57geww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Nov 2022 12:29:18 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AJ9j6Pw035352;
        Sat, 19 Nov 2022 12:29:17 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk1cc54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Nov 2022 12:29:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n8i+pxB1tB8JezBNvBEyzBCtNipmGVX0Sy0kLPH0XZKsOzB465+oZ26jbGs/eDqcJK2U+IzUTqKNroFLhle3T2SlRuAvkXZ9c+Nv4CXioMnnZz9ZIM+R47/vzppov2vdIOtZ7Z37cPKPsLPlJpshbAiKO6bGMYFQEqiy6zm0jvdeEDq1jZHRH2kbqr88qIhhEy7PvK58JeyBZ+oWIqo23lZ157CxYK1AY28SC3FZpiucm0bMUopVN7RllX+AbLHiEF5bO/v1jsWcb66cjYWRuMPxdEuVObH5szM0UJzzDWFayYn4ceFUOFtoiqy6d0E9YiDRyc+Wy5KYNotrakIeAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6pheb86MaVGWRtjTs02g7r6tWkNjgZ8somyUJZmhfGk=;
 b=LMd8h4hTYp3tjyPz/vrnJGQLY9r7k3dg5Hj2uClVY2AmPCOkOfUCBH6ZA6gvmpyZ3k08ouZxALVCBbSMtutU7HnB5cKlfTYxVO+Pq4YzklzSs5nadH9brbZQUZJ9iEHBx2vcIrsgKnzVJJBuFYHccT+s7olvdGQYXy8kq0kRCssE9/XFVRF5Mm4a1YwN9taowRq4d4SrfUqKVX0F5e8EVByqcpvNLnwFtB3jQSyMGec1ngR21dt2gHIPrqPy6mUGQW0b9NAevDFisHaKjZXX0FDOw62B/v4Yi8dI/AxS+MdbQUdx/TF30iNRa4iREhn2Y6fDVHOXqO2BgtsFrZxxkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6pheb86MaVGWRtjTs02g7r6tWkNjgZ8somyUJZmhfGk=;
 b=DhDJMxqLQ0zNXvEuZAGA8E50FCZwou3XB+chOzBvwFjteisUW1rGB1Ao7giPzb4rsxkyJLe1cRdNw3XPJrt0faIg/EfPEuZcSQk/GXMfQs1JMiLhre2svTPmppbD7M18RfgHSyiXsMpXNC7lOX2NwtSWv87Oa1Yc/YKivuMOqjM=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CY8PR10MB6443.namprd10.prod.outlook.com (2603:10b6:930:61::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Sat, 19 Nov
 2022 12:29:15 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::cf3b:2176:14e5:d04d]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::cf3b:2176:14e5:d04d%4]) with mapi id 15.20.5834.009; Sat, 19 Nov 2022
 12:29:15 +0000
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
Subject: [PATCH 2/3] i386: kvm: disable KVM_CAP_PMU_CAPABILITY if "pmu" is disabled
Date:   Sat, 19 Nov 2022 04:29:00 -0800
Message-Id: <20221119122901.2469-3-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221119122901.2469-1-dongli.zhang@oracle.com>
References: <20221119122901.2469-1-dongli.zhang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0343.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::18) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|CY8PR10MB6443:EE_
X-MS-Office365-Filtering-Correlation-Id: 45d63191-9a00-4b94-0296-08daca29ac01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SeHvgPm8T13QOURDGmRoZJuTw0mK56GOYUHssB6Te2k1D1S1n4R0+z2RfSvS5iema6JXqJI6E7tus4VXDNow68lZDV1LI3fPt9qBKGtfe5gY6rppFoDJ+H+zwzaYFZv4IJsOs6eyawgGiUQhV5iNBhGIRl/RLFUxtiCY5pTwz0iZT1RKwtdRZSH1vD5QuYWMjBxXmE5FO9y6pM6VvROQn6XGYE6WmaBs/9LnfRyzEVR3hnDUt8y8mTGu8qNM4f+dtJZ4U6y3XZx9j6MrdpoeWftsvgOJe8FClg7QzhjSkLKhsyZtuq6R3Jn2z7ACoSZNCy10afaSe/l8E7CM1InJAIlB9NP8Vhny12Ijsky+FB6EveEPpFsgEYAlcWn60bmOq9FLT3AJSHOJDDnSOskoXJWNgo4EtqIAtQk7efr9zupGOZ3bYBGGbP+ofLwJ1Q76aup0zUXsQ6cWkOGft+9JZmHmsXE8a5seuDRULi8wbU7s7EeXnSL0yBPVuHM8/1ltaYLmddNGNqwmUoUaL+kMiUjZovEIPDkqmfhgQK0WO+rbpvUjmYZwORhVe/IAohr0rioTXncBRcI64kmZRW9WGXoeEApHmqjh07LAOy+Zw9znna7Ow6rrRwBBjE8qKa20KAYo/K8WCVp+ol97soN/Sg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(396003)(39860400002)(136003)(346002)(451199015)(36756003)(38100700002)(2906002)(44832011)(8676002)(7416002)(4326008)(8936002)(83380400001)(86362001)(316002)(1076003)(2616005)(186003)(6486002)(478600001)(66556008)(66946007)(66476007)(5660300002)(41300700001)(6506007)(6512007)(6666004)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ktwx5OJGyHqllBy/80HE8TOVWpW6g1cLSWmFVqCmNyaG3BV/gFAekAnZMHfO?=
 =?us-ascii?Q?W0yXYBNhrwxRgC6L87iQlpTzDL/fYmcpZo74a7b2Ey7YCQh/z+XpKWXADwuY?=
 =?us-ascii?Q?xb93Gip3svFLcoZqtYbxnGO9kj7at0LzExU/ZjtbyF6CpavJD6G90duHWLS9?=
 =?us-ascii?Q?kvzfNiuV68rHG5NSjtlMV79JPvhmp2ja2v1eLCXixV8WnTlXWCBeqwVykAnD?=
 =?us-ascii?Q?+9VcKd1Erb/sE4RKpuBE3/C/Ku/CeopD8Jzvewgm13JNAJ8au9jehlfTmy66?=
 =?us-ascii?Q?gvF3hKAOcMGS0uTnRUaEWCZ/xTBjpca0gitibpzm39HtoCAXUdY2fU/AGhYZ?=
 =?us-ascii?Q?sbss6VKZOdFZeZQwUB5a8hqqCBWD306KAcErRG1v3hERS4Fi6nXX5ZfMaH3l?=
 =?us-ascii?Q?dwifKsQ60+1PB3mpJuCqCSvWwFVHfSJffzzaLt+SQjQzTYdwpnVo4Hf3Gy5f?=
 =?us-ascii?Q?zNJWoxJpq5KHBtq3kO8YSuETk+YmZBa8kQdvmoN9eLQKC+E+ayPOOC+FveH1?=
 =?us-ascii?Q?DV6OdB2/uFPB4PUIFHNxF+ML9wF8Chw5mH+x8jNHNxDAEXNu5HCCk7zgfawS?=
 =?us-ascii?Q?aSYdc1fBEcwOXrBEQN2gatRCr3XiqGf5PHd56lFhwbX6SI8jazbWFkzQBP0Y?=
 =?us-ascii?Q?t4Fwn8CsMYwY0Fd1t6iPVWEdCMkiWE0cR3LYRO/KLVfn8ymSYXBhA1E9SZUo?=
 =?us-ascii?Q?Edu2btZgYsKr8CgUDZVz5a0wTFXSQcNJi1dSsZhcif19/tXwoO7E9lZr56ve?=
 =?us-ascii?Q?ePpDYOMhp0C1Jawg09cdNQeG8gbXeg+eV35Rm7ft5c9ZZH7cNJnA11GzjNtK?=
 =?us-ascii?Q?m58V8OJ3+iXh5itv1JopyGrfw77CkHuqOaq5vofCP/vmc29uegWolRMCDitn?=
 =?us-ascii?Q?ksfpVGMNDSV77A0jgsG8JU5vxMiG0TZYkZvAr+hhWNjHJ5/ZCRzgxOfi+tJZ?=
 =?us-ascii?Q?yl8bj4PxcyYiBle7vsRkF2F2VqW+ueJh/YRAspm5xK3QTjv6W2SbPJHXl1PU?=
 =?us-ascii?Q?/G/EZ800CvVlL9qJcYY2IQ+DeVpMPpnQs5i+RfRE1ea6PekOCFSjDmiNJU0N?=
 =?us-ascii?Q?bzXl+IJCjgudy7fobD1sdgckZJAruElT4lU/PB2PQK1/SCyiW+qmPFMvHbk1?=
 =?us-ascii?Q?JKFaTzWrPXquvI/rbjtfx1WTa+gyyGMFiv3fvf+KtP8lCKdSYec3bjcDw1Qa?=
 =?us-ascii?Q?UnuVvZbyEbjtcV+8JGGmJJ1vk6uQ88144gj0lZPGkCRnu1lFVj+OIytXnL10?=
 =?us-ascii?Q?oq81z6b6HYwhEr6ECFWmHUU9b0ubPoS44ePsfY1UhZBbqit2JyWj++nERNsL?=
 =?us-ascii?Q?6vkkFcCjqIL654aTRRLoskUzLO2R8fdXiJR4t5yX2goyFbJBTIzOMiQJCHeu?=
 =?us-ascii?Q?04FTpBII2cPF8bJCFSdYzdw1uJ3/oAbXkdinnxgJWdMhLmw3+UZCi8ne1pXp?=
 =?us-ascii?Q?gvAZB+dS7Ma0SDLaX375F8qbZFiAug7At6qBiqiC8tjw0C5y1RbeAORksEVZ?=
 =?us-ascii?Q?rNdMC6J9cVFKvC4LT+sF47wdmXTVlllZO42WTL7Wnzf3WiK3aemrB73BXJnC?=
 =?us-ascii?Q?kCa5/QLP6PZK4pxqDW1FDWQBLUAXb+c5l6AQWvwC?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?Z24+vN2cCvmV8Jv/eJL4x+AMy3NKmHde84cV/7mQqMxXiPjlwrJYT/y1YIb7?=
 =?us-ascii?Q?ioyGB85uTGxHdZSOg1lCqQ25pDBj08S6RbWA/1l7DzwfpGhOYoKp9w58NIMe?=
 =?us-ascii?Q?Rr6GSE0+bOCIWrAKFLheF3sff+J3QWtSnjFVB5Eb95u8j8xwiyM7aVhEjFbO?=
 =?us-ascii?Q?GJS1Bbtxu+ygOKerwFLBvOd315YISFLanW9FUQ00vzRThaN4Ds1jv2UPNDAP?=
 =?us-ascii?Q?5CSQRk6SCkUYLpBcCDNcDsPoZiUu8eCBQlKlbq20xRZLBbOB4ODxdwp9TVX6?=
 =?us-ascii?Q?gorV6zaPbx8FG/OuSf+L6ZSr7fSlDO5vYme+P0KcjfKYHWcZf9+MP5C4Yk5K?=
 =?us-ascii?Q?qK0WXYlqMicQ/P1LpTExF5VAvwi2DPaw4qTHZDYC/zET2KkPk2HTQ7fd18AZ?=
 =?us-ascii?Q?E5FEg/5EFKYRhI8LFmkXZ3G1YrbxGfqyPB8E8vjLGxVUvTx/pp/CvoyY4PsW?=
 =?us-ascii?Q?H8ampcVR9qIU4DMiHhLlyjVIwrRV4TLi4UcYXYdo6JCPTqEjwUo13RJuuHxK?=
 =?us-ascii?Q?mNZvCVFIhhgFzw5Pzwji9zFkPt88gHMJNFYM8NF10FqTyI0opTO/8YwA3s4g?=
 =?us-ascii?Q?D72idzk+GgwrKnY9tEya6PPQ4eKNOpaQoZYrAVGyHJ3nraQLpb1NFNfAEX1n?=
 =?us-ascii?Q?sJCgXdxCY68B8Ap9S0DC/MqUIBqtuIBjNullHAu36aB+V1lJGXxyE1IEBYY9?=
 =?us-ascii?Q?hH/fB4UvvtlKJHWDyXOlc/fwC/Sra+C821a8T/dhooi9XQLoqnR3Np8DAkIs?=
 =?us-ascii?Q?714U9NCCfWH2UaQIRv0CzumyFHdHR/CXKbygOQfSdRe0e2rU7UtD+M+BSd/1?=
 =?us-ascii?Q?egTg4dsz+CxGtqqcJE9vh0zXnLyl8esxxJAmZX42Ko2mnGubM6gmw48OHaUj?=
 =?us-ascii?Q?ZMcmC4mnNLsxEvxSauLLWlsRGxp08EGtnK6lf4kfJwGo/Dxh2KNTBpyO+j/7?=
 =?us-ascii?Q?8Ozt4eYNIEMNGuuLTeijOZhzkxHgNdquyRqcTNZ+MdgOnuzfCu+9s4sEh61J?=
 =?us-ascii?Q?2h4SsaAsbcXak87oE9zowsMFacVO7GqC5/rpbhL2d7eZJQ97h6aGEakUa1R0?=
 =?us-ascii?Q?0XCQ66bjGRPZlvsxRA7DmdtzQzWQqpWhjv+VtuoGqShIirArbk5LbgZQkZpS?=
 =?us-ascii?Q?xQ9k6FNj/H7SlaOmjycfOd/YhStRyBHxxKhSfIw9JI0oaY1MBFWFYb9kDawF?=
 =?us-ascii?Q?bU4gOzOX9eUj2eBA3bAw4HvQ0YonpfzMqSex8jfYC/dX1ybydOvrYGZZ42Fm?=
 =?us-ascii?Q?x1TBw3OjfZuD8Qxsml97bj66fusY18jRJjniI2XphKiBV9BepcqXKaYtjv+m?=
 =?us-ascii?Q?KiezcJNRn5z8FJHGyssSRq3bTewaHL/Zv4KrXUbwznMyIvgtE+jGWOzGYT0w?=
 =?us-ascii?Q?hbzf7Kd5nvDYWyE5hYfALstQYN5JTUvcG/uAEcTzNoW0GB9+VPOz16VycNQr?=
 =?us-ascii?Q?MlBiVdbhHlnF7wpmJ6d23Ge9RU/8lERFDVMneKKm86l7pqegKCUxgwfua3Jn?=
 =?us-ascii?Q?910Lb1/hgPzNXiJbhItWT7cJ8+LzXdmxMU25gguKJbNRET6QOF45hbt4hOG+?=
 =?us-ascii?Q?haA+6Q1rvgPnnYydtEBFus9+IPsGbygmrEP0vl23Lq14ZCXy1C5B+EgwUfTH?=
 =?us-ascii?Q?0Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45d63191-9a00-4b94-0296-08daca29ac01
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2022 12:29:15.6282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6V/hsYFd+AURwnu6u5eqwAofRzspWuDgd+s0DGRWH9B0IixpecUvowc97f85RJfA/Ee7mQJ08IUFJ8R92TTVPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6443
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-18_08,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211190092
X-Proofpoint-ORIG-GUID: zABPYiSP8cs7IRP2--OSUoT9Z-T7q7Ow
X-Proofpoint-GUID: zABPYiSP8cs7IRP2--OSUoT9Z-T7q7Ow
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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

We disable KVM_CAP_PMU_CAPABILITY if the 'pmu' is disabled in the vcpu
properties.

Cc: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 target/i386/kvm/kvm.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 8fec0bc5b5..0b1226ff7f 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -137,6 +137,8 @@ static int has_triple_fault_event;
 
 static bool has_msr_mcg_ext_ctl;
 
+static int has_pmu_cap;
+
 static struct kvm_cpuid2 *cpuid_cache;
 static struct kvm_cpuid2 *hv_cpuid_cache;
 static struct kvm_msr_list *kvm_feature_msrs;
@@ -1725,6 +1727,19 @@ static void kvm_init_nested_state(CPUX86State *env)
 
 void kvm_arch_pre_create_vcpu(CPUState *cs)
 {
+    X86CPU *cpu = X86_CPU(cs);
+    int ret;
+
+    if (has_pmu_cap && !cpu->enable_pmu) {
+        ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
+                                KVM_PMU_CAP_DISABLE);
+        if (ret < 0) {
+            error_report("kvm: Failed to disable pmu cap: %s",
+                         strerror(-ret));
+        }
+
+        has_pmu_cap = 0;
+    }
 }
 
 int kvm_arch_init_vcpu(CPUState *cs)
@@ -2517,6 +2532,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
+    has_pmu_cap = kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY);
+
     ret = kvm_get_supported_msrs(s);
     if (ret < 0) {
         return ret;
-- 
2.34.1

