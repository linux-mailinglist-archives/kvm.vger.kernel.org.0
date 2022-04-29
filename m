Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E79A551477A
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 12:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358210AbiD2KwT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 06:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358551AbiD2KwC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 06:52:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4790A193D4
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 03:48:35 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23T7jFeF018608;
        Fri, 29 Apr 2022 10:48:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=DaoePaOima39NX7B12rRS+H0JZ9V/TzNRXlIUGTy0mY=;
 b=rO1LhadU+ci7w3voHSmvhaJI9bbxavnioP7puSWNfix+i3SX7+XBBs3erKS1cEtk67qH
 i6qEZoBIYvdme7qiQsMC41pzMvpLZOeQZLTv7UujpxzdiGp5ZTIZBPsJyPQO9nsMpCnE
 VRvhByqtpi3A05K6Bib7Kf7JSXoss08Jgj0ga9sIP23bSKUDc7SDo84+JVaKPIqVTJMv
 0Q9D98GMEyb7gQGEuVknOQDFJgzQTfcnP6Y7rTTz7TCT/PmwaNB30xzkdd5QhezLY5QQ
 Q4MoBQvpWgXCZdxv73CZ3jow8otHHRw8j/ThRT7t4ToNHqUvqUZixWiHssg46/x/YYDw oQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb5k6fsb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 10:48:10 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23TAedCf027716;
        Fri, 29 Apr 2022 10:48:10 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5yq23b7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 10:48:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i7JTIGAR3vodgNphHRTBX4Rx4qHNR0VPJN28gFu4A+2MTD+1aaP7g4ScwkJLhC2ll1fQ61oK2VcE2OhsTaHU/v/3yKZ+1UmLibtfMP7bVWp1R+Kj2awMQjELkCsSENt9cM/yjVuQk9Fmc3PoNC9Ok6jH1VEgRmsaoYi4eENQ8H5/yqZ0QJrVqqcbhGebWgnZciiQVXcAm/Pr0Np5II8SjopKldMYN9QaeB6XI8TbpRxyvNnWhQBXpZ8Ffy0iJRlpxzkII0Nuf72XV0XOV6rqs4JKpZRbYU79QPucuhNA9bxXhDylDA4chJBOrMcWwG8Lv/2qS+AMtCcB0wPdVsGvXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DaoePaOima39NX7B12rRS+H0JZ9V/TzNRXlIUGTy0mY=;
 b=OYAN9jV5UUyuUmzReBJluTs0G1lDU7jpVE/wXTF/sAVsY/zD55P3dlBlPpdQC73JMS4PCtyQoxxxXhHaFxv+wfvoEWNbaDCD+ek+H8eTyqGHv2OCreLkS5oOaqJu1mQyMvgeft/dAMCM/DYefN5mWpK+347uWjsmdkzNHTt2rTgxHvAQnXfNYdbkQEhqbPT3fv+oqgNIuVtMr72Msv2FwVC6fBZCPzaJBgj5nPKCYrqBh8FFh4wZzbg3hVatAQrS0Lq6un0TGkc8mNPRjKYH6+TqGUBJh6nLsMWwjzcZ9A9FIxIU0kMx44WV8Kx5IXoj5zEI5lLmktpKOI4zjCUMbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DaoePaOima39NX7B12rRS+H0JZ9V/TzNRXlIUGTy0mY=;
 b=K0D/DpTVwKeWhNs724+w3Cua9di/p7hhWrasuIlBowunP879JzUGW3n927PNzkkaUYfROM5X1Xg91ihP5d1cECkXXh7CjVBMnhN39mW9eWU7hbV0ISW6mQQvaEbRGcM5AuBaDGS5irg9OQICuiAwscTYR/bp+HFL/b3q4mKl9QE=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BN6PR10MB1841.namprd10.prod.outlook.com (2603:10b6:404:108::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Fri, 29 Apr
 2022 10:48:08 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 10:48:08 +0000
Message-ID: <cd5ca6ae-e2b6-16b5-25e3-774282e56df2@oracle.com>
Date:   Fri, 29 Apr 2022 11:48:00 +0100
Subject: Re: [PATCH RFC 02/19] iommufd: Dirty tracking for io_pagetable
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-3-joao.m.martins@oracle.com>
 <BN9PR11MB5276338CA4ABF4934BF851358CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <BN9PR11MB5276338CA4ABF4934BF851358CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0012.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::22) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e2c0159-255c-4807-edc7-08da29cdbf1e
X-MS-TrafficTypeDiagnostic: BN6PR10MB1841:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB184178B5D73AAA3025F08DE1BBFC9@BN6PR10MB1841.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ELZpZ496pCo3d3lcLlR5iH7wknsZxBxr4TTPVnWHMnUP7Yxx9cbs7P28+nyn1dqGZNeB4TrBpKHik7FPFVKKQFsadHHGHkT7RyjXMBEsEBoWirDHRsjQMxX0NYX35pVOV6voyTiY4GRgkuSwks/nxreAEAgyfCGSotAuFs2QYxyY/kwKAhs6c/ZL/140VWgdIOQOt7o9ivnGwbgwr5+mJ5l+F98fZaXPvQg19U6W4wdtRXs7s+Ix/vYW/yz4Y8mNgvziQwcTsvs2gVPgocTywh6PSPaxgJkpcurO388OggGwIGoDeFbM7fvaNuj43W+Jvgaazkq8a+uPwvz4WZJDPWFis9/uRHHQwRXYswVXXoprvCdofqV5ACsFVvsI+Z5OgWNw5Xm/65UbLtPJEh8qrntMPQiIIdmAZKi97qVhoBcZi9Lp/8Rd0Hu0DVgTuLdNjJsH84Y6/RxMj8K8mjGiTj7eQo+eJP9VitQKv0VGn1hScKfVE8Sgl7GDoefLY20lOnD3JOAm1jhXM7osFpMPnYJ0c1N3RGqgQRQ4jbSfjhNpfmJCj3fNXeuPEDckMtZ7K6qs9ZPNd+QMk2I9I7B4WFg0siKR0d3NJ4RVPttroEcJkclQLQaooqI1bds1+tcJbQLkK1zYy3bnywuqdIEPYsb5EmUZgvlXiWjNjiLeWEewHb8LNrO3fAjqcnL5/KXjDigLYuxOwApVVZ7A+La6Vfwr+trA3AIP/+VJV55HCuQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(508600001)(86362001)(31696002)(2616005)(53546011)(26005)(6506007)(6512007)(38100700002)(6666004)(2906002)(66946007)(7416002)(66476007)(316002)(66556008)(186003)(36756003)(5660300002)(8936002)(54906003)(31686004)(4326008)(6916009)(83380400001)(8676002)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z2NrWDd1NGZoYzFGZkxHRHE4a2VlR05QOGtrN0xXYUNtTjVJZS9uV3ZwQ0kz?=
 =?utf-8?B?Sy9HcVgvOEVHTXlmM21vdmpiY0pOaTBlTTE1bFRtL0JWcmpWVldIZHRMMTI1?=
 =?utf-8?B?dXpmYmpRTFRuZlZaQkNwaVdVa3NYREZiWVE5RnN1azZXeEFCdE5hZEJaR1hD?=
 =?utf-8?B?eU5zdC9LSFVzbFRZcDRPaHhsL1NOamZwRCtmalFqYUZjbHhWMVg4aUh0cGF1?=
 =?utf-8?B?RW1KaW9hSmVMT0x6UGtDZDBOUkxOa0VlWk1veGt6eFlrZTNIaCtUYUozMTJP?=
 =?utf-8?B?ektjMzIxaldLTklOOXF6OEZHZEgvbE1kaWJPSXJrNis0UmZSVk1vbm5SWTZl?=
 =?utf-8?B?R3c4VDdocUNWVkdIVExLUlZmc1RWbER5V1VXOGp2aXYwU3dtZlFNazBhWm5K?=
 =?utf-8?B?WWtZenVtUzFNc1N5NXo5U0tMbU9FVlNRa25oazZQK2RNVm9TTXc3NzROR2E2?=
 =?utf-8?B?cTVBdWVIbVZpeWluYzlycHhBWGdlcmQxKzdpTG9uMWxhcHFTT1Y3U2N4Q3dk?=
 =?utf-8?B?N2E3OHpBbERuYXBNRk5TNEF0OExDbkJZbTkwcE1lYW5CTWxpdVd6eWpLT1VP?=
 =?utf-8?B?dXVESE9oU0V6WXhVSzcwbDczVTVabGZRbEFBS3NTMlBicnRHZCtvRmFWTTdF?=
 =?utf-8?B?eWg2Tm5nTFdpam43dFhvUnl6SXpIeGNqc0pGY0t6NkU0RXhtSmxVUW5rdVpP?=
 =?utf-8?B?bWxRVzBOMmM4d3l4YkZFaVBzZnBXZXZNVWRnSE0rdFlVNVh4OEp6REFLU0cx?=
 =?utf-8?B?UXFSSW9JS1hsRzNNbHVIQ2hiV2hzakVQNDRNOWQxTjVKZG91UWptbElCcUFs?=
 =?utf-8?B?VUpObGtGVm9wQnpTUkZPakNhUzMzMXN0bG83S3dpRWVIdDNjQXF4dm9wOFpH?=
 =?utf-8?B?ZndwTVF2b0EyWjdEMm9XelVCb0VhR3F3bTRhemZud0lSdmRZTHBYdXJLbWNJ?=
 =?utf-8?B?Q3lDN0FoS0V2allpQ2hjbFZlSnBTZDB3LzJ1eWxlZzVCREdrcW5sSjEvek9J?=
 =?utf-8?B?d21PVDkreTgyblRGK3hFdW8vT0RoWG56WTlnelZlZk1hcEs0cjQ0b3VhYWZp?=
 =?utf-8?B?ajdEYzN1VEJ0UFR0UXNJUEJWYkZ0ZEFUR2NmempQUjR1SmIveW0zWGlBaWNS?=
 =?utf-8?B?akxrOFhLVUw0YURoZWp0UHM0N0hJaGVhbEkvZTh3Ui9KVm9jcVQxUkR0K3hR?=
 =?utf-8?B?amhJd0g5ZkRneVZJaStXMW0zK2U2ZUJHeWxhR0RPRHdZcG9KNElrQlEwdXky?=
 =?utf-8?B?MStnUjU5aUQ5MHVCZGZnaXY0RVBJZ1ZRTlFTODk0akhmM1ZnMUxaQjVTeVZS?=
 =?utf-8?B?ZkloYW9XNk1GZWVyQlBJNm1reTlHRkZOUnkzZ0RPYnZvcUtkdTVLRFRZZFc2?=
 =?utf-8?B?Tm5HRWxuVDVrTE9QYjRxOGZFMmRIS3JIY05mWFFLdXlMV1NYSVE2Wlg1bTNC?=
 =?utf-8?B?Z0lZR0xGUjlJMFJkNGxTMTlJMWpkY1g0S2V0MU96YXo2UVZNdkJEakUrMS9O?=
 =?utf-8?B?UlNuYU1DYmVmQ0dUM0gxaVFiY2NRbnV4UnNNMjhURThoMTJvVnpKaVJtdXJv?=
 =?utf-8?B?aGU0aTA1VmRoNFdzNnpUcktKWmw5OWZjY3lsLzlqRGRzYytNQjA0ek84dHpG?=
 =?utf-8?B?cTdvRmR6TDJMd0F6Nm0rNnBGcTY0d25UNnRTamFRU3JRQ1ZrT1RuMnNEMTcv?=
 =?utf-8?B?Q202c0cxMEpZQ2t3ekFpVi9CQ3ppSU5RTDJtbEtIR3FhV0pBdzFTWU94SWF0?=
 =?utf-8?B?SDVDTmtTekd0aGFVM0NVa1owdThRWGpkYkNPNmRqaGoxVkgrcTc1OEVHUkVV?=
 =?utf-8?B?eFhIbXhRQWtxTkxMakZDM1RiYWpCS2ptakltbkREZkJiSFZGelNmN0MwWHFj?=
 =?utf-8?B?T0hjRmNFTnlOZ2FJQVE5ZlorTWszWFF1MlozUHlSQzN0bnhVWnRQTGFsM2Uz?=
 =?utf-8?B?M0lZYkphRjdaQXEyYXNPblVPTTR3VVRwNEw4SEFSZVlLK3hxOWQwSUFIWjYx?=
 =?utf-8?B?NVZnc2xyT2dNNDJEbnA3Z2VUVFNuQU9IdjlBNmpIeTE2R1R5U01XVkwwYmtE?=
 =?utf-8?B?S0pWZzRkTlFPODcydUppVnVzaW5PZUQ5bUt2bnB6UE1PL3VidDNJK0VSU0dh?=
 =?utf-8?B?azZDOHUvL0FMWVFWQVBmb0xvSm05ZE82b3hxMHpzUU85UDduTTFNLzRJTncr?=
 =?utf-8?B?cEpXa3BSbFoyRjdPMEUxRnhFR0xRdjlDTmhsRHBmdWpYazVkc3QwVXhhN1Vr?=
 =?utf-8?B?M1ZHRmRncDQ1cDZUdHdwRUUyVFBlK0V2aC9kL1pBQkVJak52RHc4MmFkSXRB?=
 =?utf-8?B?M2FGRmVKTzZVbHNZcFd2RW5mNTR1MkxnMHplb2k4dmFFYmFOV2s3d1BQQnR6?=
 =?utf-8?Q?LBOY30zY96U0DnYY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e2c0159-255c-4807-edc7-08da29cdbf1e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 10:48:08.0356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2pWJp8KKLBfxghEGvWumAhev+gAcTflCmmNf27ZT7Bl1l2VaLUzso5sbtpnmS2SxG4uFudfDexzAIJu/VXrd47R1g82XYtqWCR6WduOEjIY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1841
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-29_03:2022-04-28,2022-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=865 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204290061
X-Proofpoint-GUID: YXGdTN7KESteqfuk7JSwEVPe6lvkfj6D
X-Proofpoint-ORIG-GUID: YXGdTN7KESteqfuk7JSwEVPe6lvkfj6D
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 09:07, Tian, Kevin wrote:
>> From: Joao Martins <joao.m.martins@oracle.com>
>> Sent: Friday, April 29, 2022 5:09 AM
>>
>> +static int __set_dirty_tracking_range_locked(struct iommu_domain
>> *domain,
> 
> suppose anything using iommu_domain as the first argument should
> be put in the iommu layer. Here it's more reasonable to use iopt
> as the first argument or simply merge with the next function.
> 
OK

>> +					     struct io_pagetable *iopt,
>> +					     bool enable)
>> +{
>> +	const struct iommu_domain_ops *ops = domain->ops;
>> +	struct iommu_iotlb_gather gather;
>> +	struct iopt_area *area;
>> +	int ret = -EOPNOTSUPP;
>> +	unsigned long iova;
>> +	size_t size;
>> +
>> +	iommu_iotlb_gather_init(&gather);
>> +
>> +	for (area = iopt_area_iter_first(iopt, 0, ULONG_MAX); area;
>> +	     area = iopt_area_iter_next(area, 0, ULONG_MAX)) {
> 
> how is this different from leaving iommu driver to walk the page table
> and the poke the modifier bit for all present PTEs? 

It isn't. Moving towards a single op makes this simpler for iommu core API.

> As commented in last
> patch this may allow removing the range op completely.
> 
Yes.

>> +		iova = iopt_area_iova(area);
>> +		size = iopt_area_last_iova(area) - iova;
>> +
>> +		if (ops->set_dirty_tracking_range) {
>> +			ret = ops->set_dirty_tracking_range(domain, iova,
>> +							    size, &gather,
>> +							    enable);
>> +			if (ret < 0)
>> +				break;
>> +		}
>> +	}
>> +
>> +	iommu_iotlb_sync(domain, &gather);
>> +
>> +	return ret;
>> +}
>> +
>> +static int iommu_set_dirty_tracking(struct iommu_domain *domain,
>> +				    struct io_pagetable *iopt, bool enable)
> 
> similarly rename to __iopt_set_dirty_tracking() and use iopt as the
> leading argument.
> 
/me nods
