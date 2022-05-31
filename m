Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26635393E1
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 17:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345621AbiEaPXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 11:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345624AbiEaPXH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 11:23:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029A5275FD
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 08:23:05 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24VEkLiH030125;
        Tue, 31 May 2022 15:22:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=yD5IVjp75JfS4FfEEHJN6g9Xjii8/P0EyXlI43UO7O0=;
 b=s3u4KikgjP6PCy9VCFwNIKhnwGKRzJ4si+bLxANibyn1j/M+uBD7drTw7FLU4ewaJ8mr
 Iac27LD8MZNJeFcMHjwmC7VujJg0NlpA+W+op91iozS9ufvD2tTETuohNdhvkxSwJcMM
 xupytJL9OyDFjoa4JPesLdFk9vAizEbK0EJu73toLqC6yCqiAI2t3sKynNq7L1X9LLnO
 8uDxWCS6gmn8Bd92+51K8FGGrVm5Sm2BJpk/Um0qBl4WlK4H/eGqLWVlHrckZlr9qX/U
 cEz700zFPAm4VXtArLftu9QKHag3mYFsFviVgFT1NTpFVMWunUS0He5ZoMiwhPzEIBOp yQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbcahnf5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 May 2022 15:22:22 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24VFM74k036837;
        Tue, 31 May 2022 15:22:21 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gc8hrtkvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 May 2022 15:22:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iItK4JZYlGW9SCrTTLs4VZ25wKZf3AcLDdUiJy85/czE4txzZvZBHKdWCe7adfq6OTQwmQ+DB5STWe38WFwohHBRFaVFTlb5vNboIVNRR/E4PDQfveE4lgizRY+bp8Obvs32fB5tA1woJamvznfO///MiqlT5c4CSiob0/MvMbpPI0zBI7Suk4Hj4XaUzxGLWT3QPsoytpeEkmX8aZgYu77rLIOu+8pVC6lQAQ1rShEMyojU45ENwPG1puM343LkA4uF9Ptat108zWF4Q+4JEYP1rrcXrPqw2HVazQAKAfLtLVnmcyuXA+7efe10dGRVVibBoR4yCmyd0DzrqxwlPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yD5IVjp75JfS4FfEEHJN6g9Xjii8/P0EyXlI43UO7O0=;
 b=QfS65SqYYJg1h8IO94tRlcGTtDDWh6cOC91xyYEO4faW4kBQ9c4PHb2AKqfubHfM/5bSk0aJ+LzTMOUwAF4vfxDlKwJUogyZo3LPwRhHU8KZ0zg54VQ+dTmw8fWzTtxrRqjRg6B/tR8cDXlKvwEHWhUN6dj8VMSxnKYY2KZFZf0kcj9LVWKi46qfuyTe0ES0ytxf8pC+ehpAHHDsR9Ggeh7csIpyHs+s7R0XewxyOPQLzUpvNIABuvHcLfMQroxto+gRaAm6+MWStVK84Q3XB2JXk2W4KXlO18DqxGhHnYlYv2kcEACfr6h88JGQW+hV5JWzLH2Ek1NGnFxlBwVFTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yD5IVjp75JfS4FfEEHJN6g9Xjii8/P0EyXlI43UO7O0=;
 b=mXQE5MrCchTHrWwtQmVH9sjvwuPB5jO72ZcVuy+A4sAJg6VnXHckrIegf0lJC4v5OOsyffoxYhCmY0Sb/QGbcWRsVuVY+gAPLKmiVAk9Qbvp0+JUXPOv/fKQuPwBTDLGcUK4N2rP6h2Qu9KlZp79e/uBQTB6XeamcGxfU69cxMs=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM6PR10MB3513.namprd10.prod.outlook.com (2603:10b6:5:17b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.17; Tue, 31 May
 2022 15:22:19 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::cd04:db71:3df4:581]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::cd04:db71:3df4:581%5]) with mapi id 15.20.5314.012; Tue, 31 May 2022
 15:22:19 +0000
Message-ID: <d1cd15eb-d6f4-500e-957b-181d793e34ff@oracle.com>
Date:   Tue, 31 May 2022 16:22:18 +0100
Subject: Re: [PATCH RFC 09/19] iommu/amd: Access/Dirty bit support in IOPTEs
Content-Language: en-US
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        iommu@lists.linux-foundation.org
Cc:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
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
        Kevin Tian <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-10-joao.m.martins@oracle.com>
 <efd6a8ac-413c-f39e-e566-bb317ed77ac4@amd.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <efd6a8ac-413c-f39e-e566-bb317ed77ac4@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4P190CA0018.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::28) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ba8a30f-2880-4fe9-e194-08da431959d5
X-MS-TrafficTypeDiagnostic: DM6PR10MB3513:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3513605CF8F510D65FF5F3FBBBDC9@DM6PR10MB3513.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ONF80bj1nczZfxeLM1W0qtR6MA57Ag6W/JdBZKHuOD2eTAhyAT2KHfgcaHRGDIS4dWsraRiYcD9CBBXjwM+8xc+oJTYeJKlvBX4ujpLwOoNi/82NA1eSfsSoGEEVhAfqgDdjXJg3EF9Z2ElmPrrsL1EUt4jTO+LGWt0Gl1HE1ddJ2AadIddHziSTm0QNtXCv2xoJMqCIEmu94QIAgy0Hd48N/SPwcbxXo0jny5t7a0xPq7kWP0wbYVrsYgMihQCk8JhpB0CXjDe29cLt7K2rRx9FcrOiIQjj4SMMz6UNtD1KfNxfQZ/5+HLTXCaeABAzZxL9zou9xednHHhQoyiBwEpTUy45RQgfvWQjjtZxiNochk5FJQSMBU9okmCbTWGxwc/rQqL44VMYTvMVxeRvsQ17hXQjVJ4HiwubuvwUV4806fUuhyafqk370n9tuGainrqf9gZSyFqHIzXtQe8yqNZuMye7zxlnG8usPmlP8jgyavkSvisRBEahp6r15oMXvOmre2c6GJsnHX8ogP+Ka/ZyBBapl+cvnwwLMip1++Omj4Odk1XQKQSNF1JwIyXoIHxNSr5arLgOk9VzoxX7PGf8D0sk+917aC+xsQQb5izWGXjC9z5ZrdS+u2kSQkRESNEGOWYzFQQ4w9yigsZ2q3qjLNvZKV2xa/5Q0Gueswxf3shwPp9sjx7nMT9W49SNPJ3BuHWyKE9AhDx7QdoMcyl+tSx8oFJcoT/AR4J54sY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(6486002)(86362001)(2616005)(26005)(6512007)(2906002)(38100700002)(186003)(83380400001)(31696002)(6506007)(66946007)(53546011)(5660300002)(8676002)(4326008)(508600001)(7416002)(66476007)(316002)(66556008)(31686004)(36756003)(54906003)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aHNody90bGlPRys1aSszM3JpSEpqTnVoaXdiUEh0NTkxUExGeWtaOEtPRGtB?=
 =?utf-8?B?UExZQWN5dzNhRS9KdnlxNE92QlJvNytYa2hrOVJKUmk5VkhqRUhMeTdXQnhZ?=
 =?utf-8?B?RDAwYy9sSXh1RVdIbmpIQWRsMVQwRUtjMFpyZS9VUmx6b05TUU1wWXdzcUIw?=
 =?utf-8?B?V3Q5aHg2Mzl1cE9jMjNlU0NvOEo5em4vOGhWdUNJZ2ZkVjJXL09NVW95MUl2?=
 =?utf-8?B?L3RMYjFmaHlIK1JOM3FPMFpiV3ZFczNYNkVqT2JtZUhrbUJhYUZsNDFJWjBK?=
 =?utf-8?B?MWgrOWRSSUhMRGt2WVYyeFhRRlVQQmdVeDE3VUc4eUxjRE93ckN3MDJtc0Fj?=
 =?utf-8?B?Z3AvMXlzOVFyN3JjODNTMGFvbEFFK242S2NOYmxQUmFIZ242SElwYzVLcjdZ?=
 =?utf-8?B?L1hndjJNWk50UU5HTzR0TW9LaHZvTEtWWXAvY3VtcW5lNFJQL0M5a0t3Y204?=
 =?utf-8?B?Q0pWRy9ibUlPT2tYVHJYbjRIc0hseTl6ZmpmS2tCc0l0MHhUQWpuTEs1Y3BW?=
 =?utf-8?B?MmF1T3J5RUZreVFDTmtnWkh2YlJmdVMrV21zV1Y4SVJBc005ek9JUGQ1UGs0?=
 =?utf-8?B?dFN3TThyZDZYdFNKRS91RGs5dHVyWks5QWlBOEo0cGN3Zm5HMzJZRm4zVkJW?=
 =?utf-8?B?bks2UkVDZGpMRCtCbnJKNE5qd2ZaN1BkRC95WC90Vm56RkIwQnhRWGNFOXJ3?=
 =?utf-8?B?NGEvS0tYOEUxMCtGRnd5Y0x5RmNOanpRRW1waDJLNlhXU3lkRzVqSmdKTGhQ?=
 =?utf-8?B?SUN4YUJ5clhZcGFmSkNzWS9CS2lvZHVpREpoNXpQYndBMThRMU9adVVjTmRs?=
 =?utf-8?B?RUdnTytJNXdQdTRCOGxTcU0vVTJWeDhmWnhxVlQ3dk9DTkpxV094SjdJNU5w?=
 =?utf-8?B?REJGbkYzS1Z6amttZENzc3RISmIrdXgxMkFnbFFYeVZFcUNkeTlWY3VSTXF4?=
 =?utf-8?B?VThRakdGR1FKTnZYTi81cUNDTDhtQVNiMFErVGdEbFNzYytuWkNwVm5jcS9p?=
 =?utf-8?B?RmlkeWZUeUl3ZlppSTZtd2Y3VEFRWFhDb0pCYnBJZE1aT3hZTXBxaTFZODVR?=
 =?utf-8?B?RVp5SlVYTzMxbVlxN3RYSTVvbkZ6NWJuZENiazVzdm5nMVptS1Z2bFhnTTdr?=
 =?utf-8?B?b2dsSW54SzhiNkJsK3lrbVg0ak1pSlNSam52QVRaUWk2U1AzdEQzMlBwOUx2?=
 =?utf-8?B?TGo5cWo3Y1RyOXhjT2RtTi9HZXFUWTRjRkRkUGIzYU1MVXYzcmFYSGRDT0dD?=
 =?utf-8?B?MmtING1heEovanltOFF5a3JGdmRTc3VPVHQ1ZXAvVTAvc3l3MUVaSUQvOVph?=
 =?utf-8?B?eGMwbDJnN25xRTBhRHRvdVdadkhIcDcxVzFzRzAzT1dobG9KMi85aXIrc3FL?=
 =?utf-8?B?M3JxVXluRjQ2TXo4bUFLZFVlM2tHVmhJRjQ3SVBjcjRHeXZCSnhEeHUwamNT?=
 =?utf-8?B?Y0JUN2h3OXhqN1FNbHJ1ejV4WVllOTFGL3FiajBBdEU0NWhLZEppWldObit2?=
 =?utf-8?B?b1hGbkNiZ3BDeXBWdmFPTWlpWWdiNVFkOXB4YVpmOXF6cWFKUHlMcngrUFFx?=
 =?utf-8?B?MG81MGVzbUxIam9DSkZXN0FIejVDQnFXckFyZjBOUndQMWVYNjNUc0JlNzMz?=
 =?utf-8?B?RStCRWEralRnakI3SFEvZnZaNWc0b2wveDdZVkhrajRPc05CY09xMlRWbHNB?=
 =?utf-8?B?RU01c2t2aHM5Sk1EQ2ZGL25sclRONG50MEtIV1BsMUlqMWtUOEF5UkEvQTM2?=
 =?utf-8?B?NCtQRXU4K2dJV2IzNHZjSThJK3B4d0hCcjNHRzkwc2dhZ1c4c2pHclZjYWFC?=
 =?utf-8?B?WldqY0VLTFJmRWR0NWpwZ0RNTW82WE1MTkZJS3VkMFRHMDBwcDZuVVNjUlY5?=
 =?utf-8?B?VVFPMkM5dlRJSzdocHV4OGloWGhhS2xhL3cyVFZzWVdoQjlUTlYveDUzYU9i?=
 =?utf-8?B?UmdRaHZsa0hSWUxsQ1hZekVWUlRsRFdDMGkxUWtRUE5BWE5la3ZQc0hxcnlq?=
 =?utf-8?B?T213UFZ0SlFFdUVpRkVHVGNzNjQ1bGw5dUo2b0d0UU91OEN6SjVBT21YT1dQ?=
 =?utf-8?B?M0Z3YUFkbER5clpDUjR6MkE2Z2VGMVZ3cXg4bHg0c3hqNHNUMU9venV0N083?=
 =?utf-8?B?LzRqUC9pY0R6a3ZLTkd1Z09DM2lrY2dNd1Njbk5GY2VDcnlhaS82eWpmNEFP?=
 =?utf-8?B?U3YzdnVoa2NJMXlUeTJHOTIwakd2bDR2ck1jbE1tclZEekIvVGN0eFY1elpu?=
 =?utf-8?B?ZlBxa3N2S3h2WkhyVUxHRDVITm5HL1VDRUVGYjljT2g5Q1NTdjZadVZmZUUw?=
 =?utf-8?B?YkhLTG9TcVRpUWxPNGs2b3I3OFM5Z21pN0psUXZaV2I1WmZsY2MxV08zcXZW?=
 =?utf-8?Q?KXAboxLPPHHjuqGU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ba8a30f-2880-4fe9-e194-08da431959d5
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2022 15:22:18.9122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rUM7xhigtYRrjcI0VW8Iv56Aq9bB/QCuC5BPittrumu/4dtACfAEFP75iBMVtTMbqAoKzzQDYTZL+vXpt4gOC7i6tKkutof7aryNL9p1WF8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3513
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-05-31_07:2022-05-30,2022-05-31 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205310076
X-Proofpoint-ORIG-GUID: N7A3jRXIUe3vWrsSGogFqrMjsZJ02wvD
X-Proofpoint-GUID: N7A3jRXIUe3vWrsSGogFqrMjsZJ02wvD
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/31/22 12:34, Suravee Suthikulpanit wrote:
> Joao,
> 
> On 4/29/22 4:09 AM, Joao Martins wrote:
>> .....
>> +static int amd_iommu_set_dirty_tracking(struct iommu_domain *domain,
>> +					bool enable)
>> +{
>> +	struct protection_domain *pdomain = to_pdomain(domain);
>> +	struct iommu_dev_data *dev_data;
>> +	bool dom_flush = false;
>> +
>> +	if (!amd_iommu_had_support)
>> +		return -EOPNOTSUPP;
>> +
>> +	list_for_each_entry(dev_data, &pdomain->dev_list, list) {
> 
> Since we iterate through device list for the domain, we would need to
> call spin_lock_irqsave(&pdomain->lock, flags) here.
> 
Ugh, yes. Will fix.

>> +		struct amd_iommu *iommu;
>> +		u64 pte_root;
>> +
>> +		iommu = amd_iommu_rlookup_table[dev_data->devid];
>> +		pte_root = amd_iommu_dev_table[dev_data->devid].data[0];
>> +
>> +		/* No change? */
>> +		if (!(enable ^ !!(pte_root & DTE_FLAG_HAD)))
>> +			continue;
>> +
>> +		pte_root = (enable ?
>> +			pte_root | DTE_FLAG_HAD : pte_root & ~DTE_FLAG_HAD);
>> +
>> +		/* Flush device DTE */
>> +		amd_iommu_dev_table[dev_data->devid].data[0] = pte_root;
>> +		device_flush_dte(dev_data);
>> +		dom_flush = true;
>> +	}
>> +
>> +	/* Flush IOTLB to mark IOPTE dirty on the next translation(s) */
>> +	if (dom_flush) {
>> +		unsigned long flags;
>> +
>> +		spin_lock_irqsave(&pdomain->lock, flags);
>> +		amd_iommu_domain_flush_tlb_pde(pdomain);
>> +		amd_iommu_domain_flush_complete(pdomain);
>> +		spin_unlock_irqrestore(&pdomain->lock, flags);
>> +	}
> 
> And call spin_unlock_irqrestore(&pdomain->lock, flags); here.

ack

Additionally, something that I am thinking for v2 was going to have
@had bool field in iommu_dev_data. That would align better with the
rest of amd iommu code rather than me introducing this pattern of
using hardware location of PTE roots. Let me know if you disagree.

>> +
>> +	return 0;
>> +}
>> +
>> +static bool amd_iommu_get_dirty_tracking(struct iommu_domain *domain)
>> +{
>> +	struct protection_domain *pdomain = to_pdomain(domain);
>> +	struct iommu_dev_data *dev_data;
>> +	u64 dte;
>> +
> 
> Also call spin_lock_irqsave(&pdomain->lock, flags) here
> 
ack
>> +	list_for_each_entry(dev_data, &pdomain->dev_list, list) {
>> +		dte = amd_iommu_dev_table[dev_data->devid].data[0];
>> +		if (!(dte & DTE_FLAG_HAD))
>> +			return false;
>> +	}
>> +
> 
> And call spin_unlock_irqsave(&pdomain->lock, flags) here
> 
ack

Same comment as I was saying above, and replace the @dte checking
to just instead check this new variable.

>> +	return true;
>> +}
>> +
>> +static int amd_iommu_read_and_clear_dirty(struct iommu_domain *domain,
>> +					  unsigned long iova, size_t size,
>> +					  struct iommu_dirty_bitmap *dirty)
>> +{
>> +	struct protection_domain *pdomain = to_pdomain(domain);
>> +	struct io_pgtable_ops *ops = &pdomain->iop.iop.ops;
>> +
>> +	if (!amd_iommu_get_dirty_tracking(domain))
>> +		return -EOPNOTSUPP;
>> +
>> +	if (!ops || !ops->read_and_clear_dirty)
>> +		return -ENODEV;
> 
> We move this check before the amd_iommu_get_dirty_tracking().
> 

Yeap, better fail earlier.

> Best Regards,
> Suravee
> 
>> +
>> +	return ops->read_and_clear_dirty(ops, iova, size, dirty);
>> +}
>> +
>> +
>>   static void amd_iommu_get_resv_regions(struct device *dev,
>>   				       struct list_head *head)
>>   {
>> @@ -2293,6 +2368,8 @@ const struct iommu_ops amd_iommu_ops = {
>>   		.flush_iotlb_all = amd_iommu_flush_iotlb_all,
>>   		.iotlb_sync	= amd_iommu_iotlb_sync,
>>   		.free		= amd_iommu_domain_free,
>> +		.set_dirty_tracking = amd_iommu_set_dirty_tracking,
>> +		.read_and_clear_dirty = amd_iommu_read_and_clear_dirty,
>>   	}
>>   };
>>   
