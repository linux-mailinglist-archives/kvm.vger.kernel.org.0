Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D41664D13A
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiLNUco (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:32:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbiLNUcO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:32:14 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19AEF2189D
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 12:20:54 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEHE7dH016641;
        Wed, 14 Dec 2022 20:20:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=kf1KqycKDs3yqFtrZvhVMGoNwz4XrbqDvOd5GVrU56Y=;
 b=Ye7x53XRa8UBtwxCQAOLrZ9NuntxT4IRAjt7qKHEbVU6SZuJPfeoYdCx2UJvD48peXl5
 uEaUIPDEuGm1sUD7gNZkvi4j2lhlaTmrwasgPHVO158SeEpeosWTRnTqpURVhDB/iIvC
 ZE40tlTdmhTVrEISvQrsXrik5duJ1/bVdoRg+hk7kf4NJdk6pSAX6j1vJFZfiPIb1SCn
 WKmsQ1xIsZoLF4TfOMreQivw6cjsII9KF/xkbaA6trOgjgo6Bx58KsCLuhzH2t1g2pe9
 v7kfuHDr5DuNpl7vzKcXwDR5pCk/ZESOdltLPOfNitbYUUit1QUiAhujL4ljuEgtliRp oA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyeu3a3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 20:20:50 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BEJ3mhu031123;
        Wed, 14 Dec 2022 20:20:49 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyepkgjb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 20:20:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bv/cTyh+NK2cM3m7dgfJCTx3j36cK8VZRLDx/2I5EH3BDqWUijGoFgv2pslqvMiUhS29hJ/owUgVuG2O58L8Q7/MSADY6BgFPNELxtNA+JlDOK49OOY6Osv2sqFEzqu5vm3P6Kj0APaMT/sHbVvZI6fnTGzZoOZ64HQbES1KEo4LDtUwGukHdtWnU+PixtIzs58wkSn1ngkSbpgGjP3D6K1Gv+vF7I7JAkIliwbAMCK4keb9wKvF3bEtlIuyGQ+C0zTLikXuVJtz7Oqo8t7c0Pr4iQihhytgkKriMW7F0E7tiUmGsody19FGl53aKriJDbEjiczoVExCo102ojaf0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kf1KqycKDs3yqFtrZvhVMGoNwz4XrbqDvOd5GVrU56Y=;
 b=VE1ucvJO3SIYd1Gjxma9brr7VNgavaB13H7y7nF0XIW+t5j36X6f19gMCQEsjQvI9ahY8YI7YmwU6GGX4ESZs1d70DSDM8vDoq2tZZomF6peTkaqhQrOPCoHNyKQFDVApaObmLITN53RHcur9cVZSAEPhpSqrnzFR3DgHojYYXq2kVQECC306HQvPeQZn6N4VuKnNl+vEjcafW4xQmMvZ8d7Dcr/8/SdozcwFkfLFLUCsyiuFWQEnydm3bvCdE35L+KrKdEFw4AGKETuUgsMP9PdYbLnvfUBuYXLUG63FNyIs9CbCvj7If4Lg0O2CewyOOXN5/fFMq1c8DBCth1ltA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kf1KqycKDs3yqFtrZvhVMGoNwz4XrbqDvOd5GVrU56Y=;
 b=AXbd9pRScXRN34CKP5lZm2Wtv+aaZNdewIQHyLYFELfWD1B9n/paoHgn1IsXJWSWE4mJ004tWfZUQYwT37Pw8uK3eFLZSioPz8EZFADZtom/yg1Orjf87kX1B/EsSN4j2auyL0EgMX6TjqfrVzhZXX3UzSSk1j1a5XUii8ik1ns=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by MW4PR10MB5775.namprd10.prod.outlook.com (2603:10b6:303:18f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 20:20:46 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca%5]) with mapi id 15.20.5924.011; Wed, 14 Dec 2022
 20:20:46 +0000
Message-ID: <e03a0787-4bd3-de21-9439-a91db71bd05a@oracle.com>
Date:   Wed, 14 Dec 2022 15:20:44 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH V3 1/5] vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
Content-Language: en-US
From:   Steven Sistare <steven.sistare@oracle.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <1671045771-59788-1-git-send-email-steven.sistare@oracle.com>
 <1671045771-59788-2-git-send-email-steven.sistare@oracle.com>
 <20221214124015.36c1fd52.alex.williamson@redhat.com>
 <5a06aaea-cd53-01cb-bb4e-08a3a543fa6f@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <5a06aaea-cd53-01cb-bb4e-08a3a543fa6f@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0088.namprd13.prod.outlook.com
 (2603:10b6:806:23::33) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|MW4PR10MB5775:EE_
X-MS-Office365-Filtering-Correlation-Id: 996d690c-ba60-4d3a-f514-08dade10af22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qipQWS8IjnS0JRIixTRrXYCHgyqIZvyGsA1y+YXydcuN0+nfjVBx5hwTTWamJU71DfXu9PfFw8hDsEiTs7zdnzw8qCdLr/l/zwMPpsGx+Y25g9qNgngPYl+n7AOS76WvFwrk9ob6hbmVxXRX9fcEZugg8yRGn2+p9VpQynEqjzA4emuCPVVVyqVt/ZQKSkkL0JGvtzWCAos/pSgdifPrNZm7OP8Xb0em4RO6sP4XL3iLkCZ5CBsrk7ErkBZNQKXbQFdYQBBbTs9QpBm7C4BanUHl25tk+Ibwb7+UFMAqUIDstS1ROs0ZGIdUEvXRfcWNCNkjFe18KV2IIxGxRimB7EsPTpL25RooUQqbxm7EVXgcdaIujvQkdDhqHhe7tHS7hTjoZ4bIRye0Blc/zwP8DYzXGnBDDISOtLzc+ql6uPgPQx13EQ8sM2cmsaQnjriVomUmVAs5KY5TP1gftO27LF7sx6OMRmGxknRLlM54C41a0Ez5/AbHi1Q85AKnqDPRoMOCwl6Xx2kuQVmbr19GevJZg3Q+UqVFBN3ucpgZCh7ltxE1oyUbq3hrmjXboD9RRkL7wzHOfSrWfLRySb1Ys+USNIEYBwFacG7LGd4mWqsOI0pMLgazamB/D78Kjg9uALzjkLuHrLScpSbJSmI46seUR4JH3fblhxY32NVdwDwnt4/4gbK/FnF0QIa/AvoBF/MnfjDokaY6N0bYQ1gXUasYe9LF2UOI4w21wKEfd1s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(376002)(346002)(366004)(136003)(451199015)(31686004)(36756003)(316002)(54906003)(4326008)(8676002)(86362001)(31696002)(38100700002)(6486002)(478600001)(186003)(66946007)(83380400001)(26005)(53546011)(6512007)(6506007)(44832011)(6916009)(2906002)(2616005)(8936002)(5660300002)(36916002)(66476007)(41300700001)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MXdta1I4Y3lGTmVyQ0FFajQ1VDU5dER6K1plVElJQlB6R0JMOWxFZUFKSGpo?=
 =?utf-8?B?TnVjREc1cStBbW02MFNoem9wdEdTanhtVnRJTjBwRis3bFIzbG1xNTRkTFgx?=
 =?utf-8?B?Z2tpMHE4VkYyUW83U2l3RUI1N0QxWlBIVklSQnN6QlhtMlBDY3IvLzZIL2oy?=
 =?utf-8?B?UkExS3BSTTJ0YVJXQ2lidkZJTmYxR3plRWxxOGEyY2pSTTBQQWtob053MUJT?=
 =?utf-8?B?SFFvbWc0cHNTNWt2QUEyRGlSa3RMQ0RVcDM3dkZRdFIraURtS3pIYXhXNnBn?=
 =?utf-8?B?N1BIR2I5L2pIYlpYTmlFZVduelN1eWE2eTJtNnN1Z2xQV0FpeEEwZE42QXpj?=
 =?utf-8?B?amFHZ2l6NGg5aE40Z1dzQkZ6aDRZWG9yRVNhbk9jNjVSSUxYdWh1dWN2bHE1?=
 =?utf-8?B?UE12SmdLdDY2emdUWDVBZ1FZTnZhMFlIMGtIcVh0ZlhRcWxoQ2JBQmNRUVEw?=
 =?utf-8?B?MXV6OG1RVldpUnhrVUEzSjF6WmMxeXdTNXdBeFVlMzkrWi9GR0RxMUpKdkpL?=
 =?utf-8?B?QlJsRURJWWNheENnOEJ2V0pLb3l2VmJ2Wkk1T3JJTXlXV3YxRndSakZNREpZ?=
 =?utf-8?B?ZzVOUkZIcHdNejZLc01zY1B1aC9mZW5xSEo3ckRkcHVTRmZpdUFWVTg0eHl4?=
 =?utf-8?B?eSs0R29XWkxFNnB3MzdlRE9KU3Bkd0YvamVkL3FlSi9FV0JzRnlrNTZvWmJw?=
 =?utf-8?B?NTYvT1Q1QWFCYnRGdGJHTUpMQlhPNG5XQzlLY3dMNm9YU3FKZFkzQUtkb1Bi?=
 =?utf-8?B?eUxWR1l4dHhRM3pjSzRKNFE0bE4ra1dyV0ZTOVhERnpMakJkRm03bU1EUjha?=
 =?utf-8?B?R1JzTC82a0FBdkdNeWIyU3dqRExkVlhBVGNDSHAzUDFYMm5CMW1QOWdBS1B1?=
 =?utf-8?B?UDhyYy9FeEQ4bTZYdExldis2c1dTRDBWK2VBOWRmZjcxT0FBNTRaZHJHVW1D?=
 =?utf-8?B?V3V4dDBvU1B5ZkUzMGt5UFR3V05MWmZrYkxLejEvSjIwQUlzSzd4QSs3VEpJ?=
 =?utf-8?B?Wmo3VWhhcE90Q0lkdWNZOHdvSlk0V00xekl4aUo4cWw0b0xhTWs5am01NDEy?=
 =?utf-8?B?eWFMdTdXUEpYYnAvS3RlaU0wZzlJVHhhK2EzZytDWDhJWWpidkhYTkU0MkJN?=
 =?utf-8?B?aGlESEhWNm5OM1hXbGcwbjladU11aVNZOE43b0k0S1lrSHBCRE1KakxabTJj?=
 =?utf-8?B?dlZXM0lZK0kwK2FTMTViSFR4MmxUM1dGNXJ1blhVTUExeHRselYzaVRuU0Fq?=
 =?utf-8?B?SUdqdTF3NVgra2x5MWR2MVhkaGVPYW8vTTNTcVBRT3BnaTRhd1NMZUxkVlda?=
 =?utf-8?B?a2N2ZGdOVmp3cEpkdGdQYm94MjdxTHdDVmNpem1qSkcrWEdkNU5vNjRzMUpT?=
 =?utf-8?B?ZnV0VURGamk3ZDFMSWxWNVVLcDVuMUZTUytIaHRsMEszZWxkTFBwbFpLaDFy?=
 =?utf-8?B?T2lyelRaSXpXbTlHWEdnYXBDRE5Fa1BRampNY0RyYkNPUGpDNVZlTFZ6YW5L?=
 =?utf-8?B?bnNjVnord1VWUG85SzNEYjRkOFcrSzN1TjV0ak5mZDFWUXIwQlk2VFU1d1FI?=
 =?utf-8?B?RlhmZDRKRlM3T3ZBYmM4bGYrS1JaaVV0NFB4Z0FiZG1sbFI2YkVkVlB1R2JD?=
 =?utf-8?B?aUEySlEvamZKaUxBU1UzZjhlZWxwakFhbzBZdExrNnNmKzNVZzJ4ZWZFT0hU?=
 =?utf-8?B?Q0tmM29UejA4WTRMdnBuZU1VSzJZbU41SzdHeUxrSk1NdG5kdUMraVROL0Nr?=
 =?utf-8?B?MGZ3TzdZNEd0UWJTeUh3Ly92VzBha25pd1hrbXVGUTc1MFUxTjBnWTlrWlBV?=
 =?utf-8?B?SFI4YjVkdWJ5MzdWOHJNb2JCcEpETlR4R2g3K0hHKzNibk4xZzc4TTZ4ZjJY?=
 =?utf-8?B?SjVXUFdBcXpsMkpLbXJ0VC9aK1hMaWJ2TE1oMnBkSzhCdC9KSlFhbXJVZWtx?=
 =?utf-8?B?MWZDQWszeHQ1UmZqa0l6d0VZeTlaaHJ0aEc4KzhOYnIzRURaQVFkWW1aUFBn?=
 =?utf-8?B?Uy96MXNKME9RWW4vZGJwdFo4VFViMW5vUlY3NmJnYVhmWCtXWFJDL21RaTBU?=
 =?utf-8?B?ZlpTUjV6cUVrYm13TFA0a2JUVitJYnJTaHc2aWh0QTVOK0JibUk4L2MzNE9P?=
 =?utf-8?B?dHJQbzVuNjRVVmZWSFlqT21GRGZmcE8zZGk1RWwxbEVmQWdEN2ZUdVJzZkt3?=
 =?utf-8?B?ZFE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 996d690c-ba60-4d3a-f514-08dade10af22
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 20:20:46.6899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oen5XE7CJ6ByResaYTGXeAlSwZOkqWuDTW0/Yh+XKOTPVNZHIQykeQKtDvltLqpch0kVePlbVqQrPVJgRV+Dkv+F7pimm5yrXP/8rYWaRbg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5775
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_11,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140166
X-Proofpoint-ORIG-GUID: YlqCeEerMZgmB6-ijWAmGTipbmyhwHJD
X-Proofpoint-GUID: YlqCeEerMZgmB6-ijWAmGTipbmyhwHJD
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/2022 3:03 PM, Steven Sistare wrote:
> On 12/14/2022 2:40 PM, Alex Williamson wrote:
>> On Wed, 14 Dec 2022 11:22:47 -0800
>> Steve Sistare <steven.sistare@oracle.com> wrote:
>>
>>> Disable the VFIO_UPDATE_VADDR capability if mediated devices are present.
>>> Their kernel threads could be blocked indefinitely by a misbehaving
>>> userland while trying to pin/unpin pages while vaddrs are being updated.
>>>
>>> Do not allow groups to be added to the container while vaddr's are invalid,
>>> so we never need to block user threads from pinning, and can delete the
>>> vaddr-waiting code in a subsequent patch.
>>>
>>> Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")
>>>
>>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>>> ---
>>>  drivers/vfio/vfio_iommu_type1.c | 41 +++++++++++++++++++++++++++++++++++++++--
>>>  include/uapi/linux/vfio.h       | 15 +++++++++------
>>>  2 files changed, 48 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>> index 23c24fe..b04f485 100644
>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>> @@ -861,6 +861,12 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>>>  
>>>  	mutex_lock(&iommu->lock);
>>>  
>>> +	if (iommu->vaddr_invalid_count) {
>>> +		WARN_ONCE(1, "mdev not allowed with VFIO_UPDATE_VADDR\n");
>>> +		ret = -EIO;
>>> +		goto pin_done;
>>> +	}
>>> +
>>
>> This simplifies to:
>>
>> 	if (WARN_ONCE(iommu->vaddr_invalid_count,
>> 		      "mdev not allowed	with VFIO_UPDATE_VADDR\n")) {
>> 		ret = -EIO;
>> 		goto pin_done;
>> 	}
> 
> Will do, thanks.  It's a new idiom for me.
> 
>> I was sort of figuring this would be a -EPERM or -EBUSY, maybe even
>> -EAGAIN, though perhaps it's academic which errno to return if we
>> should never get here.
> 
> Not EAGAIN.  That implies they should retry, but we don't want them to keep
> retrying until userland (never) remaps the vaddr.
> 
> EPERM is returned for other reasons, particularly in vfio_iommu_type1_dma_rw_chunk,
> where we would like to return something unique for this condition. 
> 
> EBUSY sounds good, here and in the other locations.
>  
>>>  	/*
>>>  	 * Wait for all necessary vaddr's to be valid so they can be used in
>>>  	 * the main loop without dropping the lock, to avoid racing vs unmap.
>>> @@ -1343,6 +1349,12 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>>  
>>>  	mutex_lock(&iommu->lock);
>>>  
>>> +	/* Cannot update vaddr if mdev is present. */
>>> +	if (invalidate_vaddr && !list_empty(&iommu->emulated_iommu_groups)) {
>>> +		ret = -EIO;
>>> +		goto unlock;
>>> +	}
>>> +
>>
>> On the other hand, this errno is reachable by the user, and I'm not
>> sure -EIO is the best choice for a condition that's blocked due to use
>> configuration.
>>>  	pgshift = __ffs(iommu->pgsize_bitmap);
>>>  	pgsize = (size_t)1 << pgshift;
>>>  
>>> @@ -2185,11 +2197,16 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>>>  	struct iommu_domain_geometry *geo;
>>>  	LIST_HEAD(iova_copy);
>>>  	LIST_HEAD(group_resv_regions);
>>> -	int ret = -EINVAL;
>>> +	int ret = -EIO;
>>>  
>>>  	mutex_lock(&iommu->lock);
>>>  
>>> +	/* Attach could require pinning, so disallow while vaddr is invalid. */
>>> +	if (iommu->vaddr_invalid_count)
>>> +		goto out_unlock;
>>> +
>>
>> Also user reachable, so should track if we pick another errno.
>>
>>>  	/* Check for duplicates */
>>> +	ret = -EINVAL;
>>>  	if (vfio_iommu_find_iommu_group(iommu, iommu_group))
>>>  		goto out_unlock;
>>>  
>>> @@ -2660,6 +2677,16 @@ static int vfio_domains_have_enforce_cache_coherency(struct vfio_iommu *iommu)
>>>  	return ret;
>>>  }
>>>  
>>> +static int vfio_iommu_has_emulated(struct vfio_iommu *iommu)
>>> +{
>>> +	int ret;
>>> +
>>> +	mutex_lock(&iommu->lock);
>>> +	ret = !list_empty(&iommu->emulated_iommu_groups);
>>> +	mutex_unlock(&iommu->lock);
>>> +	return ret;
>>> +}
>>
>> Nit, this could return bool.  
> 
> OK.
> 
>> I suppose it doesn't because the below
>> returns int, but it seems we're already in the realm of creating a
>> boolean value there.
>>
>>> +
>>>  static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
>>>  					    unsigned long arg)
>>>  {
>>> @@ -2668,8 +2695,13 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
>>>  	case VFIO_TYPE1v2_IOMMU:
>>>  	case VFIO_TYPE1_NESTING_IOMMU:
>>>  	case VFIO_UNMAP_ALL:
>>> -	case VFIO_UPDATE_VADDR:
>>>  		return 1;
>>> +	case VFIO_UPDATE_VADDR:
>>> +		/*
>>> +		 * Disable this feature if mdevs are present.  They cannot
>>> +		 * safely pin/unpin while vaddrs are being updated.
>>> +		 */
>>> +		return iommu && !vfio_iommu_has_emulated(iommu);
>>>  	case VFIO_DMA_CC_IOMMU:
>>>  		if (!iommu)
>>>  			return 0;
>>> @@ -3080,6 +3112,11 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
>>>  	size_t offset;
>>>  	int ret;
>>>  
>>> +	if (iommu->vaddr_invalid_count) {
>>> +		WARN_ONCE(1, "mdev not allowed with VFIO_UPDATE_VADDR\n");
>>> +		return -EIO;
>>> +	}
>>
>> Same optimization above, but why are we letting the code iterate this
>> multiple times in the _chunk function rather than testing once in the
>> caller?  Thanks,
> 
> An oversight, I'll hoist it.

It's actually a little nicer to leave the test here.  The first call to
here returns failure, and the caller exits the loop.  

Hoisting it requires jumping to an out label that releases the iommu lock.

Which do you prefer?

- Steve
>>> +
>>>  	*copied = 0;
>>>  
>>>  	ret = vfio_find_dma_valid(iommu, user_iova, 1, &dma);
>>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>>> index d7d8e09..4e8d344 100644
>>> --- a/include/uapi/linux/vfio.h
>>> +++ b/include/uapi/linux/vfio.h
>>> @@ -49,7 +49,11 @@
>>>  /* Supports VFIO_DMA_UNMAP_FLAG_ALL */
>>>  #define VFIO_UNMAP_ALL			9
>>>  
>>> -/* Supports the vaddr flag for DMA map and unmap */
>>> +/*
>>> + * Supports the vaddr flag for DMA map and unmap.  Not supported for mediated
>>> + * devices, so this capability is subject to change as groups are added or
>>> + * removed.
>>> + */
>>>  #define VFIO_UPDATE_VADDR		10
>>>  
>>>  /*
>>> @@ -1215,8 +1219,7 @@ struct vfio_iommu_type1_info_dma_avail {
>>>   * Map process virtual addresses to IO virtual addresses using the
>>>   * provided struct vfio_dma_map. Caller sets argsz. READ &/ WRITE required.
>>>   *
>>> - * If flags & VFIO_DMA_MAP_FLAG_VADDR, update the base vaddr for iova, and
>>> - * unblock translation of host virtual addresses in the iova range.  The vaddr
>>> + * If flags & VFIO_DMA_MAP_FLAG_VADDR, update the base vaddr for iova. The vaddr
>>>   * must have previously been invalidated with VFIO_DMA_UNMAP_FLAG_VADDR.  To
>>>   * maintain memory consistency within the user application, the updated vaddr
>>>   * must address the same memory object as originally mapped.  Failure to do so
>>> @@ -1267,9 +1270,9 @@ struct vfio_bitmap {
>>>   * must be 0.  This cannot be combined with the get-dirty-bitmap flag.
>>>   *
>>>   * If flags & VFIO_DMA_UNMAP_FLAG_VADDR, do not unmap, but invalidate host
>>> - * virtual addresses in the iova range.  Tasks that attempt to translate an
>>> - * iova's vaddr will block.  DMA to already-mapped pages continues.  This
>>> - * cannot be combined with the get-dirty-bitmap flag.
>>> + * virtual addresses in the iova range.  DMA to already-mapped pages continues.
>>> + * Groups may not be added to the container while any addresses are invalid.
>>> + * This cannot be combined with the get-dirty-bitmap flag.
>>>   */
>>>  struct vfio_iommu_type1_dma_unmap {
>>>  	__u32	argsz;
>>
