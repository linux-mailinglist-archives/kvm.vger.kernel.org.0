Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA2A514D60
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 16:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377510AbiD2Ojp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 10:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377638AbiD2OjQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 10:39:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97D52AC68
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 07:35:58 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TEMnh3015535;
        Fri, 29 Apr 2022 14:34:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=RJmmG3BYjPzHehvknRwjAVB65JKr02OLbd+DCEJgyCU=;
 b=bw9U9Xzq43Ob+L2vYRqSQmY32/E0Xycl3ZfMHswk1heRkHlCehbHdb1EihRXGHn9Gx7a
 4fN+QZ0PJFLQ8VEMB648VO5nb+R/60LC2r8mfpln80KIxS1J7u0MlMwnGkBH9gQcVJNV
 /279ypqNv8zu7pf0Bzry1Ge7DrlsCDcsZDpc9Bqk6r0tvHajlnoGdH1c8HSdwxKZW/N+
 amulSOlEzpDRKyYHmmGQCSy+9Ad/9P5X2UKifVmeky1Y62a0yaxFKfJmkAuz0nBkBS8B
 RXRSp++e2eE5ns45LOsZzFovg9c3IpYfBqVuxsF08Td26N8lJ4T47n6nm1ffng0fs652 Gw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb9axvmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 14:34:34 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23TEGHtv008735;
        Fri, 29 Apr 2022 14:34:33 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w831by-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 14:34:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g8GacELLuUX/ryn7RQhsX5tzRYy4QkutO5L5sgMrUH0f0cXGhdF2+QG0C4EmDglcjalFMKJ/xSOCxCrISys2tLbb9FWQ5LeWewynSJOs/COB9BpZt1iuv4ZhW02+pqTzJA7dtIt6TJbr+W9CqkSIX54kxT6IUPMgiIdVfwj8kPw8vm+VlzE6pD9+d1TJ3qohxZdtnlDjSVpswztjZLIw8zXcM7nJLxjYBvmQtPWNAF6eFcWRUborFpIuTVSA917Lbd73w/zw9m++PVIWwaN7dCZGhpoArvmJCowr5Z2ogo9JSzD9nYGXqDZt0pa32k47N6YjUlW7r0ReRtnfw9lZ4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RJmmG3BYjPzHehvknRwjAVB65JKr02OLbd+DCEJgyCU=;
 b=mXaFiONb8F4JL1Y821Z6LwY80BYm6zOdach5RsW+qirahHK0ep6mmJs4FUSLiTaai8O/wSu+JO/xnh6OXI8yeJpoBp5UmRR7WHA02Ct9JesSxB0rlmUGhiobi5yFCR1t/X3Z+A+tpmsQpbz37Sz1VwCCBElm0W3aSGp0WnwtzbNnmwfjmcGNTzw7zWlXCOnkN5JQ9oD9fsE8UWcr28y14BhENPspAuI6T73IRIxdPow9LLiCw2ofwy7ZJC0vEjCDIFbmnQc9JpODBHhvWQBVprfTOxDhmjiTgxR9rhqqE2pvNdzWSxCn16MOA3yaGr6R7/+FcVR/EMsvFYQFR/ARbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RJmmG3BYjPzHehvknRwjAVB65JKr02OLbd+DCEJgyCU=;
 b=rj7AM6x0/2s8EvglFony8su7ui6C40eaQy1/bDMmVPJpcPSpdfR+hdGiEztJ9gPN8Wc1V5wlHbvKt9d1sDGLjGG/dYpSlcPKMi+dAuMP5JppVDJ7O/8dDZrDYlArhxqAct0C8PMlBDaOBVuEpFTsUU/qm5rLWphW71WijNyDE8Y=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CY4PR10MB1735.namprd10.prod.outlook.com (2603:10b6:910:a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 29 Apr
 2022 14:34:30 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 14:34:30 +0000
Message-ID: <8fab5fd6-5311-f282-ef59-3325cee0cdb7@oracle.com>
Date:   Fri, 29 Apr 2022 15:34:23 +0100
Subject: Re: [PATCH RFC 13/19] iommu/arm-smmu-v3: Add feature detection for
 BBML
Content-Language: en-US
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kunkun Jiang <jiangkunkun@huawei.com>,
        iommu@lists.linux-foundation.org
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-14-joao.m.martins@oracle.com>
 <8e897628-61fa-b3fb-b609-44eeda11b45e@arm.com>
 <fdb44064-c4ab-9bd1-f984-e3772b539c13@oracle.com>
 <27dc8d16-5e10-ae13-d91f-bc7826d34af1@arm.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <27dc8d16-5e10-ae13-d91f-bc7826d34af1@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0155.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:188::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3beaf30d-a688-40f8-8003-08da29ed5f0f
X-MS-TrafficTypeDiagnostic: CY4PR10MB1735:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1735C36C21C40EABB3D7F0EABBFC9@CY4PR10MB1735.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QWUNRZMY7dJRAyDqBJRr2uyUpogSNRyJjhJcU1Ry7yQoAdq3x1fg5/W3ATty7Iy9e20PIi7QtQsxqv7z7GkNOXdyzjS6aiViu/mNDa3UW2sKdppStQIvRdcfXqzNg0hLJJeSWfc3GgRguWq9b7re/8+E8WYpjNiS4Qf3KWytWJ7EZq3gBXSEQAYI5fm1c2c1zb9bELBJkPCGjCFuTD2+KAaU2RIwTxcDOFk75AaWthI97JxvemizFQPBpULi8QVDTpFAqNhVLinZiIAkiZxby9s49wecXI/IAoBjwLx4/m95ULgYq42lCylbVSy9O1K/WIrKonHoUTfbKdns0lT9agHrRaA84YrFLVnruby8+G6L2GWANlgVmynTpWozQefntnlp8NPh8M11frEQtryPlHBiQ9/BhFlprt17aWCetaitJH3TKnonKasNRitPRUDj+fifvTDU+yY5wNqS21R418Odf1w67crKUu0n2HldFK+lqaVe6aEGDpgVrQT/J75h1j6BeQEux5mk75WfC7gN2hBjL0zCAD4o+rRbYinDvQ7govS42Wf6ma1t0R6ZHxp7klWex5+lU137Vhx/dpFFuH0pIUtonCOVeVTOWYsZoNk6+KDN/k6evf8wzit1B+XUDdYTPsEenlUyzY41T+T26Zsyn8Htjq7vap+49pwQFN0awGqljH9lsJjQ/uGdEa7KN/YzO1RZ+qdRhr6dBo2aoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(2906002)(6666004)(38100700002)(31696002)(86362001)(5660300002)(6512007)(83380400001)(26005)(53546011)(7416002)(8936002)(508600001)(6506007)(31686004)(316002)(66556008)(186003)(4326008)(66476007)(8676002)(66946007)(2616005)(6916009)(54906003)(36756003)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qk44bTByTDk3blhFZ3NveEJqQVdVcVZZc2pRQ3lkZm5kMUM4cSttNUFPbDAx?=
 =?utf-8?B?TEZuYU13d2hHNWdSTU0reGdPMXpFOVZmVW93aURaWmN6cnh2ZTRFa01LOEVI?=
 =?utf-8?B?bklxUE1lNkVsTHRzb05CRzlFanVPV0VCQWhSS0lpZ1NqaFVaUStkL3JBRUhD?=
 =?utf-8?B?d3R4Ti8zdUY2QStmVHpoK0Zsb2NyVVRxWnRrOVBxS3pzWnlScHIwM05lSmZm?=
 =?utf-8?B?QWd0UTBHS2FCNGpERzgyMEQvM3daUE1Jcnd4cW5LOW51dXMrV29WWms4SHRu?=
 =?utf-8?B?RlVYZGxuNkMvNnBwS3VNdzJJUzBXN0hoK3lTTzVzbTRrVDR2bHNiOFpVVWI1?=
 =?utf-8?B?RDJrUDFvNzJSRFRZQWNFQ1JyYjRPTDFPT2JRT2NQdHRDNFNnQmFGL1BORkht?=
 =?utf-8?B?N1hXaEF1cVVKM3B3UWhnRElqdlVnQ3NrNVFXSC9HWE1iNk9EbDVJdWdzNmtP?=
 =?utf-8?B?QTMyck9wa1hEWUFsN0hqL0ZCcDdZOVNpZVRUYklhZjJEelBtZkZ4Z1J2NHRV?=
 =?utf-8?B?alY4azZrVTJEUit1aUR4QVozb2NlZWUzOGxLcGVYOHFUd0hCZFVQd2xwdlkv?=
 =?utf-8?B?SkN2NEJueGNOa0Z4TU5pSlkrNEl0Y25Md1JlSG9iaHp6QnpveWFrb0xBeWMz?=
 =?utf-8?B?OXUzaXhLaXNsdmtjaEFVQ3FmdWRBaGJSY0E5WUdBL1hpNUNXUVFGMzA1dENx?=
 =?utf-8?B?RG8ybjV5bHN3QU13dUZUdStMMnZUSXdhTFZnQ2VxT0lad3piaktWcVMrUHBB?=
 =?utf-8?B?bkozdEhFbVdaVmZyb28xTHRubHhYSTVkYTZZVFJjd0p3ODJiOXkwV2tEakln?=
 =?utf-8?B?K3RqcjRGSG1UT1dLTWRpb3g3WUJrZ2dETmRBV2ZaRUh6dnNNdVFKQUhMbS92?=
 =?utf-8?B?VEkvRHl3RHNTNGRqT3V2ZkpOQ2NacWZqUkNSaHJIZFMzRjFCT2dvS3grQk5s?=
 =?utf-8?B?bjBmbzUvSGZiNElCcUI3NlVrbGgzZ3RZZENFMFFRbVBlS0YyU3JJcFQ3SDND?=
 =?utf-8?B?RlhRanBFOWlvRE1udkJZdWp4TERYSkEwOVlVM2UwNFo0TkM5Ujd5Y0taL1hQ?=
 =?utf-8?B?eXAwL2dQcWN3bWNTdFVpRkd5WU1ZU3lCNHgwV281dW1xc0l0NEFzS1hMRGNK?=
 =?utf-8?B?VitIcG5LQzVlRER4WFZVWldJeWFkdnh3R2t5a2dOYTlxdDdlbno1enF5b3lQ?=
 =?utf-8?B?QlBENXMrT3ZVdjk1cE1jQzl4YlNnV3F2VFVDb0dwNEMybzhQRjFxVDdsSXYw?=
 =?utf-8?B?bE9mbUF1TzdGbGhJd0FWbEw1NkprOCtSd3NIRDg0Y3hVaENSMTI4ZEU5b1Ev?=
 =?utf-8?B?eU5VRTVuNlNOZ0VZU3NkRDNIeWRsaVFGYnJmOE90aUk0TUI5elRRNTFQMDJ4?=
 =?utf-8?B?TXBYMXd5cFl6eXRyY1haaE1nTGdYcW4rcWJubGtxZmVpVVRxL2ZscFM3WnE0?=
 =?utf-8?B?eDl5SStRWkhVWTNva1BtLytubE1uSzB6RWFQdHNST2hNSFBzeU80YWVDaTJF?=
 =?utf-8?B?enRtT3VRdXhhenRuVkE2NzlTemJBUXI0dm9sSmgrMmdQRHBjUHpENmV6cEdJ?=
 =?utf-8?B?amhaY3pRVUkySmI4TGZkVWJ0STY1Vmd3TG0rYzQvMWpjS2hWS3FUdDVXa1Bw?=
 =?utf-8?B?ZzAybGNHTzJyVDZrVkYyRnZsRHkrS2FCRHdPNUh0REpLVkhvSnNHR2JzelBI?=
 =?utf-8?B?bmd6K2QwMUJ2RTViNHVxLys1VFovUktRRGNEdWsyQ1podXFyV1RiWldudlVu?=
 =?utf-8?B?eHNzaDFRSzltOVFYb0RubUZkVHF0SytDd25hUVI3RnliTjFCN1NMTkVBbFo2?=
 =?utf-8?B?OEx6aVh5OGxUd0ZENjA1bGVka2FVUzlhNGU0NjFVaGdQNzZyVnQ4SzJJcE5B?=
 =?utf-8?B?R3pGbzlOdTlabG5jcTA0alBRaHU3WGlyQzBpM3NmT0RxWHFQVnZtVE1ia05K?=
 =?utf-8?B?QnFKYmRkY0NjVVNBN29tWU4vTXdmZzJsQkQ3TzRNeE81WklvM1UrYi9hWjBX?=
 =?utf-8?B?WisrbUxpWEtnaFRLYU1DYmF2K04reU1jVnhlT2hETTFjZkZXc1k1SHBNTUFj?=
 =?utf-8?B?bmRrQ2U5UUc2QmxlTUxSS1Yrb1B5bFZqU2hyZXNURGdZYWkrTndMVUtmM2Vz?=
 =?utf-8?B?dGRqangwMHhIekVLblhqcXJ5aUJQeVhMKzd3dFFLdnFncW1haDdtOE43L1NT?=
 =?utf-8?B?QzBYNGRCbGI2b2lRWWR6MmZQQlp4ejhuc0F0NGZoODFRQjVWa3ZrdXA0UCto?=
 =?utf-8?B?S3cvSGpNaUs3U2svdjI5Q09hMG5GMUoxd3R3aDJLR3pPMEpteE9yMGQxTHJ5?=
 =?utf-8?B?NDZQcEtKNVcySmZ5LzNuMXZyQ3NoaUo0dXhpUktnZ01ud3Z4YStMa3dVRlFU?=
 =?utf-8?Q?OlLLl1kdxKMO5Xu8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3beaf30d-a688-40f8-8003-08da29ed5f0f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 14:34:30.7685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wPtyzF617AFznJWZjhqBlsnRlWACn3VRL8vUz8kbD6eFON2/UAAMpW/hQ8LrohTCAlDOZ7kcWuNo24VRloQpwiGwHRrVepgadG8qmbN7trs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1735
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-29_05:2022-04-28,2022-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204290080
X-Proofpoint-ORIG-GUID: hvFy4VHRBExNq8VhwPpnq_zwWeMIEQit
X-Proofpoint-GUID: hvFy4VHRBExNq8VhwPpnq_zwWeMIEQit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 13:26, Robin Murphy wrote:
> On 2022-04-29 12:54, Joao Martins wrote:
>> On 4/29/22 12:11, Robin Murphy wrote:
>>> On 2022-04-28 22:09, Joao Martins wrote:
>>>> From: Kunkun Jiang <jiangkunkun@huawei.com>
>>>>
>>>> This detects BBML feature and if SMMU supports it, transfer BBMLx
>>>> quirk to io-pgtable.
>>>>
>>>> BBML1 requires still marking PTE nT prior to performing a
>>>> translation table update, while BBML2 requires neither break-before-make
>>>> nor PTE nT bit being set. For dirty tracking it needs to clear
>>>> the dirty bit so checking BBML2 tells us the prerequisite. See SMMUv3.2
>>>> manual, section "3.21.1.3 When SMMU_IDR3.BBML == 2 (Level 2)" and
>>>> "3.21.1.2 When SMMU_IDR3.BBML == 1 (Level 1)"
>>>
>>> You can drop this, and the dependencies on BBML elsewhere, until you get
>>> round to the future large-page-splitting work, since that's the only
>>> thing this represents. Not much point having the feature flags without
>>> an actual implementation, or any users.
>>>
>> OK.
>>
>> My thinking was that the BBML2 meant *also* that we don't need that break-before-make
>> thingie upon switching translation table entries. It seems that from what you
>> say, BBML2 then just refers to this but only on the context of switching between
>> hugepages/normal pages (?), not in general on all bits of the PTE (which we woud .. upon
>> switching from writeable-dirty to writeable-clean with DBM-set).
> 
> Yes, BBML is purely about swapping between a block (hugepage) entry and 
> a table representing the exact equivalent mapping.
> 
> A break-before-make procedure isn't required when just changing 
> permissions, and AFAICS it doesn't apply to changing the DBM bit either, 
> but as mentioned I think we could probably just not do that anyway.

Interesting, thanks for the clarification.
