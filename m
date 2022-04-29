Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B604514F71
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 17:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378419AbiD2PcN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 11:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378279AbiD2PcE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 11:32:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65ABDDA6C9
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 08:28:18 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TDlHNm025790;
        Fri, 29 Apr 2022 15:27:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=f82mPqQ1LQV9OESCi720Hj3TWO+GNGqyiQPs50soKUo=;
 b=H4R5tA1fztBXr0lY30hDcoBqsnpYCFa9tylGxY6iU7W7E4bfsTxxoiAfOfAAAECG0m9K
 rTGrrR8JP6ScdgBzpQ43MnSj3RA0o2CTGBDOkBv7+f22YGA1W7xXYC2AALmXSVtlUsTV
 Xw0pgoC6GJ/MnmEChHAQl9ghH4Lu5FU0Lsa1qz16PE1b+tywsuOEpJyzkotpVwyhlJ3k
 T/pSn0yQOMgxc8gkhfBnqSbMQo++F2VY4qZ8pprv/fsM7ln7lg6wk66DtAj7pC0Vz/Jv
 2tYOh01EOmJ+wyV+k5ztC0mJY09ZrSD8tdGiJU6J361XoWK/nw2LlAZxhJOkIssziZai nw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb1my73q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 15:27:31 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23TFAlYJ000917;
        Fri, 29 Apr 2022 15:27:30 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5yqa01f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 15:27:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HdBIX+vvITtJ5JWmrYOqh3b3Zqb3W5LPvbCAIseRdXIIezgaHg6TNq5aNs1SWwh7Br/b8T4NhScSS7oGKSX0kgnUUZMAAD6hebhM4RmLbACVrRAdlJVgK0pEOdmxpzR+l8/JkqziT2lC2stBk+7g/lIY+YJtkw/ZLNguAsF4KO+mCEBHQgZM5f1Zj2KocmO16a7Gmf+h5msUw0mg5hPomdIOdoH29ZWsPTqw/h8L4bfOi6Wj7IE8730GnFo4raf8Xs8LDA2jXxGZsWFEqYNThD1B1VHX0IzrlFMoAoMWFQfGjSvkTe0r3NcKy0jrmKWl7c1rhGYpfhvi/zQTXOiZvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f82mPqQ1LQV9OESCi720Hj3TWO+GNGqyiQPs50soKUo=;
 b=F2oscbzGh7c47wA34BFO8OXdxJkdKf3EY3eQTEDRJ4IMDu4GbAK28ydEP54sZyI8Erb9tOmT+3ZuVbJPY2xqP91xJ0298SQx7Stz7Up8PDgWk7X9iZHeY46t7lkKHIs4tCxJl61Z2brM1372AIx1pyYS75gMvHVwOHvzWJFFBB7jPVuZxdkfRum2zsKo1ka869Cb5FVkgUaVGT1vjNEqn84omzT8LvPgOfV+XTBNQKBmbUfnlJSif+YXO3SUKlpgZRgUGLyLIQbS/XvZXjw1x5h+xFPvJ0LxzQ0oE5KCBhbEc5niOEHmN5ovWZan+Kakoh8vUwO+3p2EiCyte0OwnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f82mPqQ1LQV9OESCi720Hj3TWO+GNGqyiQPs50soKUo=;
 b=iQbp5qxbwHrVnN9+DK9w+lDejctxT1+Z8cQ2MJL3xo5pP7upYtPTi0LEut26fhz4sOAfj6SFfdcGHWPDrdi8ggyHdTs1bMLpj+WGSKyTfnxctbqx1cewZVtwya1WpR/hUVtKHFiAxOW75TF0OV+klfRltqYy6OY6o3boc7KU5iQ=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CY4PR10MB1861.namprd10.prod.outlook.com (2603:10b6:903:122::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 29 Apr
 2022 15:27:27 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 15:27:27 +0000
Message-ID: <87fcdf87-0151-2a88-6ac5-bff002243f34@oracle.com>
Date:   Fri, 29 Apr 2022 16:27:20 +0100
Subject: Re: [PATCH RFC 01/19] iommu: Add iommu_domain ops for dirty tracking
Content-Language: en-US
To:     Baolu Lu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-2-joao.m.martins@oracle.com>
 <2d369e58-8ac0-f263-7b94-fe73917782e1@linux.intel.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <2d369e58-8ac0-f263-7b94-fe73917782e1@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0076.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da1044ca-244d-41f1-3590-08da29f4c44d
X-MS-TrafficTypeDiagnostic: CY4PR10MB1861:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1861B5AE698BBC838243E899BBFC9@CY4PR10MB1861.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H1A+a5+vMhknBqIntT2bH5PA+7bXK8iT4cZZSSa3pV8ce8qyD743GvgMsHlKMa+NnNOd0Jpcqb7EUFbqeVo4vYEsQUZgl2ZWYf62vXCi3V7SDLUZ7oPMtO6ADUOg9EtgQTysnHUgmjZFY9WDI3xmOdOws1GLvnC2iQne2Sn6GYT278lje6MmRs9gbl1PY+tYgXY3nkHvTZ5yFsYowYji3Pm2y8/rHVNJvg6UvEacoW9ke5ulxPn15ZMg57XGXLJNHloImGtH02acNkwO76bTaAsUNoJxq4t/U2aFCxT/nIwTdGCLhMzL1ciWl/RZR1NOvCOKr92E475FY3xw1k4nBBnL0BljJ/VW+GM3sNh1pw89htiyh0+h1tw8oEzFrayhPWMwn6Q4t6ADS4SLB/Pr4RWVNUPBsCjoJAjOtz07dxchUuq6DudMQptRaAXX5IzecUO1t7Klx3Kur+K9BtYqgP9/4vumrtuCTP6LCKV7itVy97zEGV6j0oeZc6TRppN7GYEpC+UWuIaILGnX1EErEDDmd0z3lYnvcQle1CnRWR73yoNicOwCkt736MciPP4kJoKYyJR42niQWKziU9gEfK8MFfcTFYdCAtRaV/xFFQWIXRfNIIE3HH3xxXm5DgyCHqV0oo8lhQArQorAnOkrALlWVPLi8EVSyV3/WShT114UeZDvrUxoh84KYa2+mXXCLMxUPR0W9wsHMIMqNER4onJAMjwBofaTZXyo94Kgm1dVAAVQFFxqPB1LrsXi0ICxLS2Xyuy9cUt8TUBPWjJDRYPNZYP6Ew1YzyoztJPiChZAhcLp/KosVr4VFp70Phy2ZTop68eAgfeQKUj/PUPqnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(38100700002)(31686004)(8936002)(7416002)(508600001)(66946007)(8676002)(4326008)(66476007)(316002)(54906003)(6916009)(2906002)(6666004)(2616005)(26005)(6512007)(6506007)(53546011)(30864003)(966005)(186003)(6486002)(83380400001)(31696002)(5660300002)(66556008)(86362001)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZDFRZ1NLOE1qbzlsTFVZQ1pPTWlESlhtcGFmbjBCd3l0Nkk0VGVSUkI0T0Np?=
 =?utf-8?B?V2J4MnhBazNFYUpsK3BwK3Bka2QzdGVmVllkMzQ1UzBNbm1SQWFHTkR1Vmhp?=
 =?utf-8?B?TDBBTzFxY0xQZ0h0Sm9reW9TWkc2SWlHQXZTdkMweTV5aC9VLzVFaTNzTHlO?=
 =?utf-8?B?Ynl1SEpTWldHdmtlSVk4eGt1VzFqUFFwY2lDWmpTSjRldWxoM3NtSittdkY3?=
 =?utf-8?B?bXBjdDdBalB2Y0p3T3hkaGgyMGh5UGI5U0pjeFhMVWFFeTlJSVVRbFJHZ1JY?=
 =?utf-8?B?b0dRYzZFeHBNNml6RkVFcXU5NmNibjRJOWI3ZXZVRStIeEhvbGtCSWpndjdi?=
 =?utf-8?B?YjRMSXAyR1dTRUJzOHFwQWxMQlpXTWcrQ0phVEtYMWJSeFdqL0ozMktIRUZT?=
 =?utf-8?B?M2FEOWQ3ZW9OUENiWmF4VnliTVA4YjZzendpUFl5dGdzQTIvTWt3aE1SMjYv?=
 =?utf-8?B?UzNVd0ZqT3AwK245TkI3eURpN2k2TWhHcHhlZ3IrL2tvTVpmRThjM0ozUHNC?=
 =?utf-8?B?M1RHTjZGWXVKZ1hEVUJSQTJqbWxVSllCMjdmdWpzMmxUeC9tL1RscTRSYzgx?=
 =?utf-8?B?NGxtbHE2N1lDd0RrQmVMYnlrYjZVUGxjdGk4WG1UL2c1NFpaOXQrUU9lMGZn?=
 =?utf-8?B?MW5sZzZxWHQzRWd4dEhOTUoxYmp1NGR5NTRaZDBaNDZOMnpvb3FQM25yTm1O?=
 =?utf-8?B?VFp5RVFHamo1bXhCZGxCRzJpSFFBV3gvbWVKZ1pVbkNSMkd6Mm9ma21abCtn?=
 =?utf-8?B?ZzJobzg1eFpmYWE0dStxanhtdEx5THB6d2pPYjZ1WU9SbEt4WVU0bWlnUmlS?=
 =?utf-8?B?WDdCeUV2S3N1QkZUa0EzMXFacEkrbW9EQm0wc1VBZGdOa2xoQ3lhSk9LWUUy?=
 =?utf-8?B?ZExKUHd0eTRmVnc4eXQ5NEVIZ3ZRajVEUXJKODZ5WkR3UW96dy9nQzU2SnlW?=
 =?utf-8?B?SXpxVFh3MWR1ZWRwNXZxTVBpb0Y5NDRhejFpSFdNWVF5WlVtTXQ3ZUN3YnpH?=
 =?utf-8?B?V3RXcnRBMkYxc0VJSGRoUm8wQlduQk41bXBqb0o5Q0s5TWw2VVNVdkczV0hz?=
 =?utf-8?B?a3ZnQmdVWUJGVTZTZlV0M3BDSXNTTUtybHJWaXNRWWtDUUNhZkp0MFJSR0hQ?=
 =?utf-8?B?TG9wQlhHODVZTHIvMEhVVzEwejdTZG15V0NiRWZwdmhCQ00xYzNBK1FZMmxX?=
 =?utf-8?B?Tzh5bmxTdVZQemlLOW8vYXd3VzBWblJuWVJzSFk2eEVmSGIyZWM3VnhuSERi?=
 =?utf-8?B?eDZHVjc5WHBBbGwxTFhXd1NYR0N4aitPajNmWFRDczZkbVFiZkRvbjRROXJB?=
 =?utf-8?B?Rm9Sbi9Fa0lUMTVnUXpjbm11bWpXRUwzZTZHMEVmYWdiSTRBTmJkZXAyWWlt?=
 =?utf-8?B?OGtXeEVHUnk5OUl6a3FCd1VMWkhZdGNsMFQ4anJMekxXc2xLU09oajRBQVUv?=
 =?utf-8?B?cWdzMDM0YmcyMUk1RjJDcERYT1F0WTVVeXBGY1VzLy9EWmg1K3A4V1pYMFds?=
 =?utf-8?B?T2RhT2o2bEdUSldZdnBUT205VHNCV1NISDlTTUNsYWpCb0ljNGZ5VEdheHRQ?=
 =?utf-8?B?VUw0SHB0Ui9KaGRyQkpleU8wMDZiNitGYytjRjk2VUhxYnJVU1JaSXlRU09i?=
 =?utf-8?B?WDFteFhidXBWU0N4K3AzV0xxZmcyODZ6cVJ4N01HcWFZS0VkcDdPaHU2YjZX?=
 =?utf-8?B?ZHJ4NUJBQ0M2WmRTcXZEOXA3b2VmSlFMV3VJV01uQ2pqeVEwTlBSalhHRklJ?=
 =?utf-8?B?QnkyaUZjVkVMTDIwaFgrc1BEdThGT3JzRzNEaEJ3dFVLVUtvaHBpRW92amVR?=
 =?utf-8?B?d3BObHhUbk5MQ3BaR1FTMDNmTWFMd29odzd2T2wxZFlLdDVXb1JUMmc4N2JG?=
 =?utf-8?B?TUtwcHVJRWdEUnl5ZU5WTmlXTjQvVldTUjlLUG0vRFVPRnZ0QkhQQ2p2Mmhy?=
 =?utf-8?B?RVZ1cFQvWmhuMU9HT3p1ZjdkQmQxaXNmLzlNK2lvUmxUajJ0d2s2VFpNMjR3?=
 =?utf-8?B?RUxjL2U4S1pEaVdLV0ZRUGhsUEEwWHY1aG5xNllTVEZWY2UvcDFNdEUxTlFv?=
 =?utf-8?B?bUNmaG1ZUDRUQ0dlTzFuNUI3TEtUWS9TTi9LUENyYmR1aXdpVjJmQTVaVU9q?=
 =?utf-8?B?aVZsM3pXVE1GOWs3QngwaDlPM1ZoTDlkWHNHa2JYbWl1WGFUbkNSVjdvU2E5?=
 =?utf-8?B?QWRpWjVzN0N1RnlibWphc084MVhDZ0I0STA5dEt2RTRrOWk5Mlo2WjRRNlVR?=
 =?utf-8?B?OXNYN1UzSFNnZ0dEc3haNXVITm9XN2tpMGR4NHVsK0hVY0tpcGllZzcxZkZ2?=
 =?utf-8?B?TmxwVmZicW5VbjE4TDlHblN5SEgvTUNDRW5vQ1JxZWZ6clErQmJVRmJYZDgr?=
 =?utf-8?Q?e2QiZwAuQ2B+yizc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da1044ca-244d-41f1-3590-08da29f4c44d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 15:27:27.0530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k4EUjerpaHa1o86lJaI0eX5vN8OFB5mCIx1r2f5WAfK7OeYMVAY2ErH1b6qkBxNJSA0xAMhnKIbb0oyv7RIk5ZbDuRQAfQlftLfKTnnI+hY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1861
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-29_05:2022-04-28,2022-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204290083
X-Proofpoint-GUID: 2a5K2-cp5ZYhkrXWUyvhkveBAacG4dg5
X-Proofpoint-ORIG-GUID: 2a5K2-cp5ZYhkrXWUyvhkveBAacG4dg5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 14:40, Baolu Lu wrote:
> Hi Joao,
> 
> Thanks for doing this.
> 
> On 2022/4/29 05:09, Joao Martins wrote:
>> Add to iommu domain operations a set of callbacks to
>> perform dirty tracking, particulary to start and stop
>> tracking and finally to test and clear the dirty data.
>>
>> Drivers are expected to dynamically change its hw protection
>> domain bits to toggle the tracking and flush some form of
>> control state structure that stands in the IOVA translation
>> path.
>>
>> For reading and clearing dirty data, in all IOMMUs a transition
>> from any of the PTE access bits (Access, Dirty) implies flushing
>> the IOTLB to invalidate any stale data in the IOTLB as to whether
>> or not the IOMMU should update the said PTEs. The iommu core APIs
>> introduce a new structure for storing the dirties, albeit vendor
>> IOMMUs implementing .read_and_clear_dirty() just use
>> iommu_dirty_bitmap_record() to set the memory storing dirties.
>> The underlying tracking/iteration of user bitmap memory is instead
>> done by iommufd which takes care of initializing the dirty bitmap
>> *prior* to passing to the IOMMU domain op.
>>
>> So far for currently/to-be-supported IOMMUs with dirty tracking
>> support this particularly because the tracking is part of
>> first stage tables and part of address translation. Below
>> it is mentioned how hardware deal with the hardware protection
>> domain control bits, to justify the added iommu core APIs.
>> vendor IOMMU implementation will also explain in more detail on
>> the dirty bit usage/clearing in the IOPTEs.
>>
>> * x86 AMD:
>>
>> The same thing for AMD particularly the Device Table
>> respectivally, followed by flushing the Device IOTLB. On AMD[1],
>> section "2.2.1 Updating Shared Tables", e.g.
>>
>>> Each table can also have its contents cached by the IOMMU or
>> peripheral IOTLBs. Therefore, after
>> updating a table entry that can be cached, system software must
>> send the IOMMU an appropriate
>> invalidate command. Information in the peripheral IOTLBs must
>> also be invalidated.
>>
>> There's no mention of particular bits that are cached or
>> not but fetching a dev entry is part of address translation
>> as also depicted, so invalidate the device table to make
>> sure the next translations fetch a DTE entry with the HD bits set.
>>
>> * x86 Intel (rev3.0+):
>>
>> Likewise[2] set the SSADE bit in the scalable-entry second stage table
>> to enable Access/Dirty bits in the second stage page table. See manual,
>> particularly on "6.2.3.1 Scalable-Mode PASID-Table Entry Programming
>> Considerations"
>>
>>> When modifying root-entries, scalable-mode root-entries,
>> context-entries, or scalable-mode context
>> entries:
>>> Software must serially invalidate the context-cache,
>> PASID-cache (if applicable), and the IOTLB.  The serialization is
>> required since hardware may utilize information from the
>> context-caches (e.g., Domain-ID) to tag new entries inserted to
>> the PASID-cache and IOTLB for processing in-flight requests.
>> Section 6.5 describe the invalidation operations.
>>
>> And also the whole chapter "" Table "Table 23.  Guidance to
>> Software for Invalidations" in "6.5.3.3 Guidance to Software for
>> Invalidations" explicitly mentions
>>
>>> SSADE transition from 0 to 1 in a scalable-mode PASID-table
>> entry with PGTT value of Second-stage or Nested
>>
>> * ARM SMMUV3.2:
>>
>> SMMUv3.2 needs to toggle the dirty bit descriptor
>> over the CD (or S2CD) for toggling and flush/invalidate
>> the IOMMU dev IOTLB.
>>
>> Reference[0]: SMMU spec, "5.4.1 CD notes",
>>
>>> The following CD fields are permitted to be cached as part of a
>> translation or TLB entry, and alteration requires
>> invalidation of any TLB entry that might have cached these
>> fields, in addition to CD structure cache invalidation:
>>
>> ...
>> HA, HD
>> ...
>>
>> Although, The ARM SMMUv3 case is a tad different that its x86
>> counterparts. Rather than changing *only* the IOMMU domain device entry to
>> enable dirty tracking (and having a dedicated bit for dirtyness in IOPTE)
>> ARM instead uses a dirty-bit modifier which is separately enabled, and
>> changes the *existing* meaning of access bits (for ro/rw), to the point
>> that marking access bit read-only but with dirty-bit-modifier enabled
>> doesn't trigger an perm io page fault.
>>
>> In pratice this means that changing iommu context isn't enough
>> and in fact mostly useless IIUC (and can be always enabled). Dirtying
>> is only really enabled when the DBM pte bit is enabled (with the
>> CD.HD bit as a prereq).
>>
>> To capture this h/w construct an iommu core API is added which enables
>> dirty tracking on an IOVA range rather than a device/context entry.
>> iommufd picks one or the other, and IOMMUFD core will favour
>> device-context op followed by IOVA-range alternative.
> 
> Instead of specification words, I'd like to read more about why the
> callbacks are needed and how should they be implemented and consumed.
> 
OK. I can extend the commit message towards that.

This was roughly my paranoid mind trying to capture all three so dumping
some of the pointers I read (and in the other commits ttoo) is for future
consultation as well.

>>
>> [0] https://developer.arm.com/documentation/ihi0070/latest
>> [1] https://www.amd.com/system/files/TechDocs/48882_IOMMU.pdf
>> [2] https://cdrdv2.intel.com/v1/dl/getContent/671081
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>   drivers/iommu/iommu.c      | 28 ++++++++++++++++++++
>>   include/linux/io-pgtable.h |  6 +++++
>>   include/linux/iommu.h      | 52 ++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 86 insertions(+)
>>
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index 0c42ece25854..d18b9ddbcce4 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -15,6 +15,7 @@
>>   #include <linux/init.h>
>>   #include <linux/export.h>
>>   #include <linux/slab.h>
>> +#include <linux/highmem.h>
>>   #include <linux/errno.h>
>>   #include <linux/iommu.h>
>>   #include <linux/idr.h>
>> @@ -3167,3 +3168,30 @@ bool iommu_group_dma_owner_claimed(struct iommu_group *group)
>>   	return user;
>>   }
>>   EXPORT_SYMBOL_GPL(iommu_group_dma_owner_claimed);
>> +
>> +unsigned int iommu_dirty_bitmap_record(struct iommu_dirty_bitmap *dirty,
>> +				       unsigned long iova, unsigned long length)
>> +{
>> +	unsigned long nbits, offset, start_offset, idx, size, *kaddr;
>> +
>> +	nbits = max(1UL, length >> dirty->pgshift);
>> +	offset = (iova - dirty->iova) >> dirty->pgshift;
>> +	idx = offset / (PAGE_SIZE * BITS_PER_BYTE);
>> +	offset = offset % (PAGE_SIZE * BITS_PER_BYTE);
>> +	start_offset = dirty->start_offset;
>> +
>> +	while (nbits > 0) {
>> +		kaddr = kmap(dirty->pages[idx]) + start_offset;
>> +		size = min(PAGE_SIZE * BITS_PER_BYTE - offset, nbits);
>> +		bitmap_set(kaddr, offset, size);
>> +		kunmap(dirty->pages[idx]);
>> +		start_offset = offset = 0;
>> +		nbits -= size;
>> +		idx++;
>> +	}
>> +
>> +	if (dirty->gather)
>> +		iommu_iotlb_gather_add_range(dirty->gather, iova, length);
>> +
>> +	return nbits;
>> +}
>> diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
>> index 86af6f0a00a2..82b39925c21f 100644
>> --- a/include/linux/io-pgtable.h
>> +++ b/include/linux/io-pgtable.h
>> @@ -165,6 +165,12 @@ struct io_pgtable_ops {
>>   			      struct iommu_iotlb_gather *gather);
>>   	phys_addr_t (*iova_to_phys)(struct io_pgtable_ops *ops,
>>   				    unsigned long iova);
>> +	int (*set_dirty_tracking)(struct io_pgtable_ops *ops,
>> +				  unsigned long iova, size_t size,
>> +				  bool enabled);
>> +	int (*read_and_clear_dirty)(struct io_pgtable_ops *ops,
>> +				    unsigned long iova, size_t size,
>> +				    struct iommu_dirty_bitmap *dirty);
>>   };
>>   
>>   /**
>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>> index 6ef2df258673..ca076365d77b 100644
>> --- a/include/linux/iommu.h
>> +++ b/include/linux/iommu.h
>> @@ -189,6 +189,25 @@ struct iommu_iotlb_gather {
>>   	bool			queued;
>>   };
>>   
>> +/**
>> + * struct iommu_dirty_bitmap - Dirty IOVA bitmap state
>> + *
>> + * @iova: IOVA representing the start of the bitmap, the first bit of the bitmap
>> + * @pgshift: Page granularity of the bitmap
>> + * @gather: Range information for a pending IOTLB flush
>> + * @start_offset: Offset of the first user page
>> + * @pages: User pages representing the bitmap region
>> + * @npages: Number of user pages pinned
>> + */
>> +struct iommu_dirty_bitmap {
>> +	unsigned long iova;
>> +	unsigned long pgshift;
>> +	struct iommu_iotlb_gather *gather;
>> +	unsigned long start_offset;
>> +	unsigned long npages;
> 
> I haven't found where "npages" is used in this patch. It's better to add
> it when it's really used? Sorry if I missed anything.
> 
Yeap, you're right. This was an oversight when I was moving code around.

But I might introduce all the code that uses/manipulates this structure.

>> +	struct page **pages;
>> +};
>> +
>>   /**
>>    * struct iommu_ops - iommu ops and capabilities
>>    * @capable: check capability
>> @@ -275,6 +294,13 @@ struct iommu_ops {
>>    * @enable_nesting: Enable nesting
>>    * @set_pgtable_quirks: Set io page table quirks (IO_PGTABLE_QUIRK_*)
>>    * @free: Release the domain after use.
>> + * @set_dirty_tracking: Enable or Disable dirty tracking on the iommu domain
>> + * @set_dirty_tracking_range: Enable or Disable dirty tracking on a range of
>> + *                            an iommu domain
>> + * @read_and_clear_dirty: Walk IOMMU page tables for dirtied PTEs marshalled
>> + *                        into a bitmap, with a bit represented as a page.
>> + *                        Reads the dirty PTE bits and clears it from IO
>> + *                        pagetables.
>>    */
>>   struct iommu_domain_ops {
>>   	int (*attach_dev)(struct iommu_domain *domain, struct device *dev);
>> @@ -305,6 +331,15 @@ struct iommu_domain_ops {
>>   				  unsigned long quirks);
>>   
>>   	void (*free)(struct iommu_domain *domain);
>> +
>> +	int (*set_dirty_tracking)(struct iommu_domain *domain, bool enabled);
>> +	int (*set_dirty_tracking_range)(struct iommu_domain *domain,
>> +					unsigned long iova, size_t size,
>> +					struct iommu_iotlb_gather *iotlb_gather,
>> +					bool enabled);
> 
> It seems that we are adding two callbacks for the same purpose. How
> should the IOMMU drivers select to support? Any functional different
> between these two? How should the caller select to use?
> 

x86 wouldn't need to care about the second one as it's all on a per-domain
basis. See last two patches as to how I sketched Intel IOMMU support.

Albeit the second callback is going to be removed, based on this morning discussion.

But originally it was to cover how SMMUv3.2 enables dirty tracking only really
gets enabled on a PTE basis rather than on the iommu domain. But this
is deferred now to be up to the iommu driver (when it needs to) ... to walk
its pagetables and set DBM (or maybe from the beginning, currently in debate).

>> +	int (*read_and_clear_dirty)(struct iommu_domain *domain,
>> +				    unsigned long iova, size_t size,
>> +				    struct iommu_dirty_bitmap *dirty);
>>   };
>>   
>>   /**
>> @@ -494,6 +529,23 @@ void iommu_set_dma_strict(void);
>>   extern int report_iommu_fault(struct iommu_domain *domain, struct device *dev,
>>   			      unsigned long iova, int flags);
>>   
>> +unsigned int iommu_dirty_bitmap_record(struct iommu_dirty_bitmap *dirty,
>> +				       unsigned long iova, unsigned long length);
>> +
>> +static inline void iommu_dirty_bitmap_init(struct iommu_dirty_bitmap *dirty,
>> +					   unsigned long base,
>> +					   unsigned long pgshift,
>> +					   struct iommu_iotlb_gather *gather)
>> +{
>> +	memset(dirty, 0, sizeof(*dirty));
>> +	dirty->iova = base;
>> +	dirty->pgshift = pgshift;
>> +	dirty->gather = gather;
>> +
>> +	if (gather)
>> +		iommu_iotlb_gather_init(dirty->gather);
>> +}
>> +
>>   static inline void iommu_flush_iotlb_all(struct iommu_domain *domain)
>>   {
>>   	if (domain->ops->flush_iotlb_all)
> 
> Best regards,
> baolu

Thanks!
