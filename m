Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13B1E514CCF
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 16:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377277AbiD2Oav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 10:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377294AbiD2Oat (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 10:30:49 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6885DA2054
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 07:27:31 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TEMneP015535;
        Fri, 29 Apr 2022 14:26:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=hxVNWiJy3qO1DRCtxmUHMetlfEny6vPfeX2V5WHmPMs=;
 b=GxR5lH3lnDtTAVV6tGAIsXYrmvZWlVxgyX89c3tZaLXPvZoLUWcYhsQNT0MOSMQdARhp
 mtnrP8i/yGApKKtGjTdOHgC+09fjrYCBSMKMysMUbfYu2qB/SRRgJ7REJ0Mu+yG4cN6V
 XBC9A+x0/Nujlnm/3d5cFJfB8nNDz4q+KZ+ddjlIqNpf+0i2qUfwPpZnSdBp1dB8LTUQ
 D+mwOanDp9qkTQSaIeMmmugtzk1L2LwWhlag8/y6nTBcgW8rVVyI+TKG3wJdgU96qV1z
 J67NOhO2agbkGPTVpLqzHv8ieZpRVstO4P1C6oR3vVCjKWiXpJcTxiP06paB/t/BX9IB hA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb9axv0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 14:26:54 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23TEGGjb008676;
        Fri, 29 Apr 2022 14:26:52 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w82tcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 14:26:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XyhvjBy3BPhwCn3Q2VQW0paOrYedlF8lopH0oWY+PBLnwo5hCmy9kL8/Uz8ANkd+Q4AiN56qTV1RhJ3NeOAZan9rzs7LzkE/t1pq7tCROO8iXr/8npsEhbv8NfyUe/RvFWiCZOoUJ/XMT8KcpkHQc/pdjtIwj1B2IeAgBD4vmD5GgrxswLifEjGscCoIWlqKH6AGDigYovJo7AlLLVBISqiqS6eSY5TiIZKodX//F9amWZPOWau+id8VkygLK/E3nCuMl8dRZqxggLjSRZfHpvZqeBEymyKoWZ9efJfARk9rD9wKJmGLhIPwUrTaO89dqtxoBmLcRMX2xvoDHzF6SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hxVNWiJy3qO1DRCtxmUHMetlfEny6vPfeX2V5WHmPMs=;
 b=hevln6rU5rwGO5i9KmYHatiBo5iB9Az3hMw1SKm4P/p7HDHip+JUsyGKvDRyWjae2XETxakq9k93bcyfnEc+VqWy3KUnQsrdt3mPKIxsYt0/3LJvo6uS2Rxpa7Vwueu8erqy5tJnfWhenNhLtNd+DT064Gxdwnmo0XfguG6aQdYOdIS3Z2OpuhrEZ9b+DToC3GCKJLLA746DNXRS7udHEfxAMutNGm7qKlXwpA1jAK1Qj6J8rK/Glka+B4W7GQsy23NPP7u4X9rlJu73pRWqHYO6QP1S1AgxniEV1iuRP/yllgMj1oh15csGs3lPAsj79/w6YGy8y1cesYJbYzfrQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hxVNWiJy3qO1DRCtxmUHMetlfEny6vPfeX2V5WHmPMs=;
 b=OJDlzXavpmsu6fGQs/pWR3uiRvSjBkxhe23r3dW7pVDuOzBEh2JHVZJ9CrCgoGVTIb5sA1jQPshisEY7Y3POCb9EFv+klbtHYLn3x0hhYuEqHkMmS3wOutukKBwWp4X2WpHMNfHo4GQBxiyD54uwfHXbklv3CHdTFHImVsG4oKY=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM6PR10MB2507.namprd10.prod.outlook.com (2603:10b6:5:b6::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.18; Fri, 29 Apr
 2022 14:26:51 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 14:26:51 +0000
Message-ID: <eee58121-1224-cc56-f5a8-b7b8387b9e61@oracle.com>
Date:   Fri, 29 Apr 2022 15:26:41 +0100
Subject: Re: [PATCH RFC 01/19] iommu: Add iommu_domain ops for dirty tracking
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     iommu@lists.linux-foundation.org, Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-2-joao.m.martins@oracle.com>
 <20220429120820.GQ8364@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20220429120820.GQ8364@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0107.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::23) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ae38cea-b499-488f-9023-08da29ec4cc9
X-MS-TrafficTypeDiagnostic: DM6PR10MB2507:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB2507D657A8D37CB4E3B4798DBBFC9@DM6PR10MB2507.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fuRRVyZe8ThfcU0LXv6Zxmjnd/WV7mQCl4diXzOwVE5gGyYDB3E7BjGyqD86fZXL76t7IiwAzNxUhuz4xW864x2oe6FsGQZBfqXupqu/mqPeseZdC/rNz0gfU1d2EynaJQmjpRLWvyugLlbXWbAjPJaUOZkW1ceQ3MQgOiKjA0oSHbJWmDgQbR6toaDJ2WsfUsUA6em0Us7JApYDLIsrUNV+E5NLBRKkfbNHRnyFvdGNlNd6kIyrSCmaL7DQeJiFokOK7TmdAYlARfAHgg+vrPlCh77/Ch2Y8I8J8oUoGZ3xNLqJfcRCzQ5G+MdRiDAtACbe3y1lavjdIm9ruubTJHQMadT3m1nwi+MHEF4Ab3lqXCpzZTGWGSLX6WOe56Uu9UZNALeIIEZ/cRqiD7+moqVWW0JgCT17Y+ZJN22wLpZIfDIRXtWBXXBIIOCUOAs9PGpgHesYQfFcke4Mg498sJxI7oL9yGNKad+5rz+51KsfY4dRZ/tBzLgqVqoc1q/1lsIbI13eHxLuNjpI5byAVo81QHZPG5L+jtZp5vdC+vkUSGhshHQsTKOCDVKsOwC1MdhxrkEoHwznALzp8+KSnLa/61Yw9KrTc+OTHcN1JlGR3XzvM+Z3iCaFu8R61yJ8x7EXXafSCDvEdmqEqsbgNAltXSiXkHa2tZbVvYFgslO8JK1VX3SuOJM9efN32FXHxWWYAVM86KrPIWXUIvwe3cHJ7zX7cu7XdcB4v4u20GQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31696002)(186003)(8936002)(7416002)(508600001)(2616005)(53546011)(86362001)(2906002)(26005)(6506007)(6512007)(6666004)(38100700002)(83380400001)(5660300002)(316002)(6916009)(4326008)(8676002)(6486002)(31686004)(36756003)(66476007)(66556008)(54906003)(66946007)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1E2dFY2T3dOYlhaRkV1SU85dVhQRG5LWGNsamN6VEJGc0ZGaUQ1blpYeTYw?=
 =?utf-8?B?UXFEUVZXMXByYXozQ3Bia2hidXV1S2kvUkkzREdlM0VGdjQ0c3V1bnBZdkIw?=
 =?utf-8?B?NTJjOFp3bStOWjB1enN4bDdZdllQMnFFUHhxUHhBSjlkdkw3alQ3eWpYZUlx?=
 =?utf-8?B?ZjdSUkhJTE1VQThHR3NqY3YzWkd4UWxYZzg1dDJoNEpaekdzZVcya096cFgw?=
 =?utf-8?B?RXpFUUxZbkV5TG02Zk92UW5LNFlaOFBJbjRrai9CMWl0UzAwYk9wNjZqM2Ro?=
 =?utf-8?B?c0JFcE9aRW1Cak5iZ1lGdnkzeVJDWG15cGQwZ3RhWk9NT21YOG1jT0VFU2RD?=
 =?utf-8?B?cWNyNTREQU9HbWZlSnF3ZEpUU0VqOGVPVzJRVnJpSGVoa05JT0xHU3J4UWRV?=
 =?utf-8?B?MW9URjhaVTUyWUd4ZkZIaGtvTThQaEptQTE1ckJYNnVDK3VxaHRBQ1NFWkFr?=
 =?utf-8?B?U2dibEdaZ1FYWVdaU2FyRDVkL0toOVhHYjdHN04yUUpWQXRROG04K3RCUUxW?=
 =?utf-8?B?M2lCNDJlOWFaek9nWlNJanJSeE00WTdHaHdZQVM1NmR5cG1xckkwTWgyQ0d4?=
 =?utf-8?B?eXE5TUtKYSsyOHNQU3hsS05JT00xZGVRZThDWWNYTkZyOWZuZ3puMG5sOUpI?=
 =?utf-8?B?d1VNUGlPYWlYeXc0TVlzVWx0Wmg5MHFWSnJqU05JdmlHakZJK2NIL2JyYmdh?=
 =?utf-8?B?cHg3aWt2Qk5nOXUwTmRRTUNseUV5Z2tBOTA3bm1jd1V1S1I2dDJnek5jdHg4?=
 =?utf-8?B?Vm9PUS8wUFJvUGVZZktJUEVwdU50MWxMN1lQUDllU0hmZEZSMlRadTA0eEx3?=
 =?utf-8?B?c21nRDVJZy9MVUcydnNucCtaOElzcDRDNjVtSWpkQUF0VEFIb3NvSjRKVEZQ?=
 =?utf-8?B?TmJ1L2cyT3huWUxNbDV4SVFmVDd4S1dGZlpQTGVHMjNiZzJMb2dNZWhUTFdU?=
 =?utf-8?B?a1lXczJMS21UL3UwNkMySGdjWEhCSVUvRW0rbTNLUlloYmV2ZVhXdHAvYVJi?=
 =?utf-8?B?TGlmR2dMS1FDNmRMNG5nOE5wcGNyclArOTc5SEFWeGpyeVdId0dRVnpiTFdU?=
 =?utf-8?B?NUFFY1dHQVlOcVoxOFRzSTh4NGZOcEMycU51d0NpWUFVKy9RTllxQzNnazBJ?=
 =?utf-8?B?NWFmQ2E3bjlhYjVIUnRraU50YzRRYXozZ0lVSUNXRldvM2VQaG1CeCs3MDNY?=
 =?utf-8?B?cGc0UUpkTzJJZ25wOUJqRE1hcmoyb2lWb1RjWFg2MXlIbk9VaDBkU1h0Snpn?=
 =?utf-8?B?S0FjVExld0VmMk1oeTdjVTk3MFFLNklnSFN1aWI5Nml5UGpQQlhremNHUUhZ?=
 =?utf-8?B?MitpaHVZdGk1Uysvdk1ZSHhZQTBRdkMzcnlRZXpYVU41cHh6bDFPaXVYd1pJ?=
 =?utf-8?B?d2VhUFlwN09OTFBUTXd3TlZtUk9BL1VFc1N6czBIb3pSejFuRVJwNkNRS0tk?=
 =?utf-8?B?eGpBcHVDbzNvWmhCU0RzRlUyUDd1MVBqRGI1SVA2TngyR1NWTkJIbjBocHBX?=
 =?utf-8?B?MnR4d2FaVktqd3JVNitGWjZYMUhFVEZmbjVQaWZldWtnRFdpVGlCWUZqSDRT?=
 =?utf-8?B?dDlVSDFFVVlOODNqdFA4RDVXWXJOeC94QjhpMG9oSDU4ZVEwQ1lQb2VWVWM1?=
 =?utf-8?B?THZEMk1rRXc0U0hySitPTkhVV04wZ05hUlo3NTBFRkJROG1YS081VVEwa1RC?=
 =?utf-8?B?QnEwdTFoK05NVkVLTDJhZUs4YzNWdTNzMmNjUmRENU9LekVZMHJuMlhmMG16?=
 =?utf-8?B?NXhYYm9OYUFpT2lUNEhyM3FmT253WGYvcHg3VW5FaE5pbHBXY0pra1kvUHcr?=
 =?utf-8?B?cEVVcFoyK1RzYVNQbUJ0QnlGc2JXSEtQOE9oZGZlTkllMHZXTnFGbGQ2NVls?=
 =?utf-8?B?aWxMME9zcEphR1MwdEtvQ090bExpMzZ2YTZ1Qm94a1NPNnI3RzFJSWw1TS9T?=
 =?utf-8?B?RzVxRDVMQmM5TEFIU3dLNFhKajN4MUNoVGRPbkI2Zy9UcWROZnFVdzhOekUw?=
 =?utf-8?B?cnpZQTY1YXRmd3ZGb0ZHQkFVaTZ2WCs2SFZlT3U0RFVMcGRvOC9INHVoTXo5?=
 =?utf-8?B?aEc5aFRRWms0MGhHek5GV282eFhiNzZNblBhcnJ6eXlVcmdmWFlXcGs4dVlL?=
 =?utf-8?B?WmR4Q1BWWEM5YVJDck8yaUJFVFZhUDNlVGU1MTVRdkwrWWh3VmhTSmdpOW9D?=
 =?utf-8?B?THJwUURTTjZWaHBhUFltemdMWlN2cVJ4Uy91WnhiUEFGWWVqbUNxeGE3RDdH?=
 =?utf-8?B?UURMcjJoRmVCaURuNEc4S2EzV0dXZW42bHNYc3RrclRiV05BemN3TXZvT28x?=
 =?utf-8?B?cCtwek9jR3pxMm9vRkpSUjB3UWhNTXYwRy9JVVRxRWh4cVVya0JoeWFJOHMz?=
 =?utf-8?Q?jImXlUPsth2i9QfM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ae38cea-b499-488f-9023-08da29ec4cc9
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 14:26:50.9128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /BAB1RQm5piD5IWuU5BbVSq6eWmr15xiOtfK+IS2zd7wNYzHjxAMT+PpXBwQBTUzfA2ieSqX3lcnIKVmU01KvAALaCfnHorqQ4c4WG3ZPVc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2507
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-29_05:2022-04-28,2022-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204290080
X-Proofpoint-ORIG-GUID: g_3d3vMhy-dzmSmMdBcRoatnTcbbVJ97
X-Proofpoint-GUID: g_3d3vMhy-dzmSmMdBcRoatnTcbbVJ97
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 13:08, Jason Gunthorpe wrote:
> On Thu, Apr 28, 2022 at 10:09:15PM +0100, Joao Martins wrote:
>> +
>> +unsigned int iommu_dirty_bitmap_record(struct iommu_dirty_bitmap *dirty,
>> +				       unsigned long iova, unsigned long length)
>> +{
> 
> Lets put iommu_dirty_bitmap in its own patch, the VFIO driver side
> will want to use this same data structure.
> 
OK.

>> +	while (nbits > 0) {
>> +		kaddr = kmap(dirty->pages[idx]) + start_offset;
> 
> kmap_local?
> 
/me nods

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
>> +	struct page **pages;
> 
> In many (all?) cases I would expect this to be called from a process
> context, can we just store the __user pointer here, or is the idea
> that with modern kernels poking a u64 to userspace is slower than a
> kmap?
> 
I have both options implemented, I'll need to measure it. Code-wise it would be
a lot simpler to just poke at the userspace addresses (that was my first
prototype of this) but felt that poking at kernel addresses was safer and
avoid assumptions over the context (from the iommu driver). I can bring back
the former alternative if this was the wrong thing to do.

> I'm particularly concerend that this starts to require high
> order allocations with more than 2M of bitmap.. Maybe one direction is
> to GUP 2M chunks at a time and walk the __user pointer.
> 
That's what I am doing here. We GUP 2M of *bitmap* at a time.
Which is about 1 page for the struct page pointers. That is enough
for 64G of IOVA dirties read worst-case scenario (i.e. with base pages).

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
> 
> I would expect all the GUPing logic to be here too?

I had this in the iommufd_dirty_iter logic given that the iommu iteration
logic is in the parent structure that stores iommu_dirty_data.

My thinking with this patch was just to have what the IOMMU driver needs.

Which actually if anything this helper above ought to be in a later patch.
