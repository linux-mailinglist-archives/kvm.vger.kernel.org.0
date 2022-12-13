Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF7FE64BB3F
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 18:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235888AbiLMRmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 12:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234027AbiLMRmk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 12:42:40 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602A5DE
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 09:42:36 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDGEDBx001040;
        Tue, 13 Dec 2022 17:42:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=Fj7EE2o46k+YRG/j+jcnpHfmhZeQwAdGtEpWrCGhh9g=;
 b=yMxum82BdMfJ1IiVv57c3K4SFhZLWjaIj6naG/LDVvNVMYdo19Hr7ouXTjEjaHuiuXNI
 io9yi6adv+Fo0yHY330AHFx/SHh7dEwPOop01Jrdt8xCZZFnID2iII3mXypSSRqsEQLe
 3cnhceYl7u08Ic94GAO0vYFGYGjhOCXO12RTT/3hdYd8YSK3fhLX1kqfbicmbY4dAya5
 w8Gb7foCUjtK7fXCH8d7ahLvQ2Xy4dyVh+jFejyVmctlyOS2vH5NsPUTtEqaTKAAETG8
 aD75tguW02nB0X/wjspH2u8SlGaDIrGUtHteOgdgA+cje9LF9v66VaSYOEkJs53KrRoF Yw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mcgq0e25w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 17:42:32 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BDGaNYI011712;
        Tue, 13 Dec 2022 17:42:31 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mcgj65aet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 17:42:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nb0gf09khSmEbt9M6P6jgKfBkzFNdsjtWw2lAVXhArpfYo/pMb6ohSdLTNZh3fgdWajERTrcF83hc4czmzTo2gTrvn1JP5g5vM7ATpw/ciaoHBjXvHWdCSG2hU4tIyBfCQW1jFsRMNqU9CXkL+Y8jtW5Ck06GAn74waV+vFw+v9xbFBqQe53QqUSmWgM+nFDAHmxZSh7oCjlqXSFYc1KmmONi+SaDzKtnNj2eo0hUCBJ223cJFWM17nszeBrHgqxb+sNfh++of2Fm590awms9/1YHi6l4PlcJ9z/OTFS/XT/ScPxS8Nu9M6R1exgt8F1QmPEBsLlC1LyEHNs+gQh6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fj7EE2o46k+YRG/j+jcnpHfmhZeQwAdGtEpWrCGhh9g=;
 b=M3kdsTXPuSNvBK+MHR1mEUb96hdmtSgbf64nKkImcE7nH/SGsb5DM/saKN1XyR/Fn1bnn7s29bQaTfUXcDbUzVrZYNn+qbdU+120KrlWBfP+RR65fQShfbFnubpJ2CH3xi6RO3Rf38Swpght77+Rs3T5S7nlvmcgowf/pE49/7asmSyYV5b0pbZRS/pZ/lWk0/W/Ge5MEyJcHfOyPEjp5B4SlOWG+r6N8V+kFiu/vLXtD7s0NxggojUwVIfFU4dz1wFpffPukMx59es9F9R+YAFQFpz9zZj6lZ7vo9MKfidzZDxa6EHXwdpYnp6CRi6hx9oRMVoNFEhSq/gr8TuC1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fj7EE2o46k+YRG/j+jcnpHfmhZeQwAdGtEpWrCGhh9g=;
 b=GEUkDdUYnyN85b24PBWQzaRb/NsPdCTrZl9Q8jtmEgoL4mI3M0WI+Kg5DqLsse4cCFzw2JYzt0jbNKhIW8CxZiMPCjUAPU/Lcp7FnATd2ed565vmZlw7FbLFGqLpCKLRJ1J805uQEzqjpyBsP0M1X3Vh00pCWTNF4JN83+0LGDQ=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by CH2PR10MB4309.namprd10.prod.outlook.com (2603:10b6:610:ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 17:42:29 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e%4]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 17:42:29 +0000
Message-ID: <512bf233-dac7-4266-8e57-7b4dece3bbe6@oracle.com>
Date:   Tue, 13 Dec 2022 12:42:27 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH V1 1/2] vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <1670946416-155307-1-git-send-email-steven.sistare@oracle.com>
 <1670946416-155307-2-git-send-email-steven.sistare@oracle.com>
 <20221213092610.636686fc.alex.williamson@redhat.com>
 <3f3ca4c0-b401-0d18-e911-18189ff9c1d0@oracle.com>
 <20221213103109.67c2e2ca.alex.williamson@redhat.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221213103109.67c2e2ca.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0044.namprd12.prod.outlook.com
 (2603:10b6:802:20::15) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|CH2PR10MB4309:EE_
X-MS-Office365-Filtering-Correlation-Id: fe35cb9d-cef2-40f0-4361-08dadd3167d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4xdyl9c8abjQvvYdI41hZWxC+OkoDT6D7Im1KlHNu+8c9BQGNO34HbdovzIddL8Ufd6GhWRtF7KhPwyEfhUOijQZFmjzcKFmREE53nfXjfLeJbznceR00YO1EYASTHNTB+Uhc/760VQAgCIvTj06s83ryoffUpKytZmX1rNwyDMTWp6qO1UBDOF0RRm7q3ldRbtlxqz0XSfdq/FQydlWo9wOkEapbKxDCs9Ic390yLrGytYQI6rWlfVTZEwL3lPNT2Q6Fedf+9a+XpyHbpnSWIlGSDjCX8njqvSA5xB/OPFQmBYUB4T2C2ohRiE9NaXUckiCQpw23WICXJJSlvkBSAAFPrElzn2L9wic/SCstfhZe/wIaU5qhxtbBgLgaqSJieHrKZ9SOIMtBzwfUGQUbAfg2VNhke6PZDrPEzWO9ldqnZjaoAfvdVgq63sJieg3ttNBljwrfS/zgV1x6Xbz4jBQEc/O4P2L852A0L5l/jOuBqojVXVv8BeL+dwbkIwks2Xr88XX0gk/SWWXztgJ6MDUFWgD0HeVIdnu+aQBxUtdc4N/0jj9KfPYGti6MIK80NFp5GqUrJRfb6rkif5QNcsgJRsPc6QwP7/fBDsYPeAT+5mgMOXJr+enwcP6rzslrmZvPf8uaXqvAs0laCLfCkbSfxRru2PmoZJcCSSG1iyIOYF1vdZ+dJ0wqUgZbTQof7VDdZqudVca4IudmgViEcWuBdPaQYGppWVA4rl0W1g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(136003)(346002)(396003)(376002)(451199015)(2616005)(36756003)(31696002)(86362001)(186003)(44832011)(2906002)(54906003)(83380400001)(6916009)(41300700001)(6512007)(6486002)(53546011)(38100700002)(478600001)(6506007)(36916002)(26005)(66946007)(8936002)(8676002)(4326008)(66556008)(5660300002)(316002)(66476007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OTNwa1hWTW01T2RPNUVXSXQ2VmVYNTdoYkxvMi9SOFFBR0MyUEVKYml5MUtK?=
 =?utf-8?B?U3dJaWpwWnF4bURUZjY2MldObHU1Y01hZ3VlYmZiK2RNa210bGlKYmNiMFNR?=
 =?utf-8?B?WEZ2akUrdjVrYmp3MnloSTFUbHRlbmxRZDFlTVoxQ3FjKzdGbURuVHd4Nyt4?=
 =?utf-8?B?VzhyWlRTb2ROZ1UxQ0wyTC9ZRDJVVGdWeGx0cStxbTlLVHgvdHdvbmNxTVRm?=
 =?utf-8?B?YWVSN1dSdGJrMlhZVW5rUkxLZXpqUkE1dzNxNkNRWEdyUjkvTmdmTThNTzda?=
 =?utf-8?B?b3Q4cmQ1YXhWTGpxbmlmVnp4MG1XZE9DSFNBNTFOVUR3RytLK1F6YTNPUzdW?=
 =?utf-8?B?N2Q5YURWMGYzSXdQRjhMK3dQY1dzVnBlalViRUJKY0JxenNBVmFlS3dVL2J6?=
 =?utf-8?B?ZnVqQWhQSzJFWDdLUjdXcnViTUwxMzArT3ZEU04raG92L3BiSG5qbzViRUxa?=
 =?utf-8?B?RWxQRTRBazk0eTBwbnRkcUNaUVcva0J6emRvVFVNd041OHlJa2xYZGVDdlRm?=
 =?utf-8?B?M2U0c1BSSkhja0hSTTBNVXJ5OVNkZXZ4S3ZYcXpFaEdXTHFrQ3c1c1dtRFhK?=
 =?utf-8?B?MlpIS1d1OEdDQ0ZoY25pRVRaR2RRZXoxaUs5VFV1bVlrZnlPSUdRZmdLN0pH?=
 =?utf-8?B?RW1mMk9rZkxRMVJkb2k2ckFQeXBHNUVhS2VSd1l1RG5MMzBFWDRGeVhLRUgy?=
 =?utf-8?B?TVh4MnBsdkEwUjB3VEtPYXE1eTUxM1EybCtUTUdMN21BQ0xPcmZQQUhob3Fx?=
 =?utf-8?B?K2dpNnpLTXJXZWFxcmVVaUE3bE41cXpraFc2YmxtYVpDUFhXZU1tZW5FeFk0?=
 =?utf-8?B?V0FtclNQdDJ1RTdKTlcxSDgzNjhQQUhkc2V4NmxxeWIvQ1FZcTdkMWd1QWcw?=
 =?utf-8?B?MWJvL1h4ZTJJS3pNQVFzNUY4NGxZNFlPZVRKZkp4TjJuT1hKbUc1S1ZqSzZM?=
 =?utf-8?B?RFROa0xjd3ZpZ1N0aG1RWm5XNGN3bXZjOXozd29jUDNNSDhhdERXemduMU14?=
 =?utf-8?B?cmlubk5aOTRGby9jSC8yendRT3Y5cEdDdWswUVJvZzNUYUx1c1g5aCswRzdp?=
 =?utf-8?B?M2l3QUs4MHpWbUxEY2RzUDZ4eXd4Q0g0c0ZuTTdVNEc4QjhhbGFHeE5JK3Q1?=
 =?utf-8?B?ZmU1Z0dXcjRFREl5T3hFanZsaXVtdXM2a3BaVndndW1iTi9GMTE4ZllNUFdu?=
 =?utf-8?B?Y3lXUysvU3pOem0vYzR1L1RVYThneS9Ea3lrZDQ3TkNWdnRHMnNzQStuWkxL?=
 =?utf-8?B?MXN5dFc2SWFCb0NEUjVTajJFbjk2N015a3hWNVAzWW1Oc2RSMkhVZjNSMFg5?=
 =?utf-8?B?dXlmRDRYemZjd3BNQWR4eUNRZjFObWRUS2VCQXBlQVc4Nnd2cTA5dS9rUWI3?=
 =?utf-8?B?NjdNQUJCelhqTDVob09SWUxKcTBkQVZzTW1xQzRyVFAySTdURG5wNWxsbHdj?=
 =?utf-8?B?c2dNcmFLZlNLeFZMc05IMVBxMkdEQzEwUFlPTW4yTjkrem0wMkttWHVPcXU3?=
 =?utf-8?B?M25oRHk3WmxDMm1VRWZDK0xCMm9LVXpMWk04YXBINWhDdzh4d1orNnpoQkhy?=
 =?utf-8?B?T3o1bTc1VU5Fci9IMVFPbTFHdkJGb3d6NDdZbzg2Q1o0c3BxRVdzUjh0QTRn?=
 =?utf-8?B?bGdhdEg5eC8rRkxCY1VVcHc0NXdPTGoxQ1FSWHV3dlYxRmJsQzdQYm9UWGYv?=
 =?utf-8?B?VDJEejFUbnhJK0Z3bFhJWmpKaDYvZ2I1NWtoOFFHcEtlL2U1d3BYKyt4MkVL?=
 =?utf-8?B?bEwyaVRleVB0Q3pGWmtORjBoZVZ5amxLY1lVa2h3ajlHNjd1UEpOcVFJMTdh?=
 =?utf-8?B?Z2NNajAzRmZlaktDR2lTbW9GWHB0VDR6VjJFaVJ4VkNWcWpnbnVWajAvTnpU?=
 =?utf-8?B?K1puSm5ReEl2Yk0valFOc2xiNGhUS1FhRG5QY3g0allTUjZXWGNVdDZvTDFa?=
 =?utf-8?B?RDhrNkhRQ3ZHZ2gzVll2SWUwV056S1pNT3Vram1WSFgwSHlISllkYTkwdFNv?=
 =?utf-8?B?MmNZUXJYZHUxd0xnTklaRnF5djJScTQ2cFNxNms5VTVNbjNtbUFTTWdpcjR3?=
 =?utf-8?B?T1ExeHUvckNiUk1pdjl2Z0k3b2pxZzVjelUvM1RYUFcrOFArUUR1SVVHRys3?=
 =?utf-8?B?a3MrQTgxYXJ4cTR4dzJmT3RZYm5IYU9oRDVTeFYyODltdkRsS2R1Y2FUWlVm?=
 =?utf-8?B?ZVE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe35cb9d-cef2-40f0-4361-08dadd3167d8
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 17:42:29.2971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2WWYxzbaITgC1r4RiRbqZPWLAEohsqpwrOFoUX38srH3+DuZY5PGRJfBwM5cM5o4/4EX36zSVINXRXPgfavo4tET4Hz4bR7opDtnE46PmNI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4309
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212130156
X-Proofpoint-ORIG-GUID: XTrvo204sbJDLi_e-24Cn3vCa0WVM3lk
X-Proofpoint-GUID: XTrvo204sbJDLi_e-24Cn3vCa0WVM3lk
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/13/2022 12:31 PM, Alex Williamson wrote:
> On Tue, 13 Dec 2022 11:54:33 -0500
> Steven Sistare <steven.sistare@oracle.com> wrote:
> 
>> On 12/13/2022 11:26 AM, Alex Williamson wrote:
>>> On Tue, 13 Dec 2022 07:46:55 -0800
>>> Steve Sistare <steven.sistare@oracle.com> wrote:
>>>   
>>>> Disable the VFIO_UPDATE_VADDR capability if mediated devices are present.
>>>> Their kernel threads could be blocked indefinitely by a misbehaving
>>>> userland while trying to pin/unpin pages while vaddrs are being updated.  
>>>
>>> Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")
>>>   
>>>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>>>> ---
>>>>  drivers/vfio/vfio_iommu_type1.c | 25 ++++++++++++++++++++++++-
>>>>  include/uapi/linux/vfio.h       |  6 +++++-
>>>>  2 files changed, 29 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>>> index 23c24fe..f81e925 100644
>>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>>> @@ -1343,6 +1343,10 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>>>  
>>>>  	mutex_lock(&iommu->lock);
>>>>  
>>>> +	/* Cannot update vaddr if mdev is present. */
>>>> +	if (invalidate_vaddr && !list_empty(&iommu->emulated_iommu_groups))
>>>> +		goto unlock;
>>>> +
>>>>  	pgshift = __ffs(iommu->pgsize_bitmap);
>>>>  	pgsize = (size_t)1 << pgshift;
>>>>  
>>>> @@ -2189,6 +2193,10 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>>>>  
>>>>  	mutex_lock(&iommu->lock);
>>>>  
>>>> +	/* Prevent an mdev from sneaking in while vaddr flags are used. */
>>>> +	if (iommu->vaddr_invalid_count && type == VFIO_EMULATED_IOMMU)
>>>> +		goto out_unlock;  
>>>
>>> Why only mdev devices?  If we restrict that the user cannot attach a
>>> group while there are invalid vaddrs, and the pin/unpin pages and
>>> dma_rw interfaces are restricted to cases where vaddr_invalid_count is
>>> zero, then we can get rid of all the code to handle waiting for vaddrs.
>>> ie. we could still revert:
>>>
>>> 898b9eaeb3fe ("vfio/type1: block on invalid vaddr")
>>> 487ace134053 ("vfio/type1: implement notify callback")
>>> ec5e32940cc9 ("vfio: iommu driver notify callback")
>>>
>>> It appears to me it might be easiest to lead with a clean revert of
>>> these, then follow-up imposing the usage restrictions, and I'd go ahead
>>> and add WARN_ON error paths to the pin/unpin/dma_rw paths to make sure
>>> nobody enters those paths with an elevated invalid count.  Thanks,  
>>
>> Will do.  I think I will put the revert at the end, though, as dead code 
>> clean up.  That patch will be larger, and if it is judged to be too large
>> for stable, it can be omitted from stable.
>>
>> - Steve
>>
>>>> +
>>>>  	/* Check for duplicates */
>>>>  	if (vfio_iommu_find_iommu_group(iommu, iommu_group))
>>>>  		goto out_unlock;
>>>> @@ -2660,6 +2668,20 @@ static int vfio_domains_have_enforce_cache_coherency(struct vfio_iommu *iommu)
>>>>  	return ret;
>>>>  }
>>>>  
>>>> +/*
>>>> + * Disable this feature if mdevs are present.  They cannot safely pin/unpin
>>>> + * while vaddrs are being updated.
>>>> + */
>>>> +static int vfio_iommu_can_update_vaddr(struct vfio_iommu *iommu)
>>>> +{
>>>> +	int ret;
>>>> +
>>>> +	mutex_lock(&iommu->lock);
>>>> +	ret = list_empty(&iommu->emulated_iommu_groups);
>>>> +	mutex_unlock(&iommu->lock);
>>>> +	return ret;
>>>> +}
> 
> I'd also keep this generic to what it's actually doing, ie. simply
> reporting if emulated_iommu_groups are present, so it could be
> something like:
> 
> static bool vfio_iommu_has_emulated(struct vfio_iommu *iommu)

OK.

> OTOH, I'm not sure it actually makes sense to dynamically change
> reported value, the IOMMU backend supports vaddr update, but there are
> usage restrictions and there's no way that this test can't be racy w/
> other user actions.  

Yes, but VFIO_DMA_CC_IOMMU has the same issue and the same comment,
"this capability is subject to change as groups are added or removed."

> Does it have specific utility in userspace to test
> for this immediately before a live-update, or would QEMU enable support
> for the feature based only on some initial condition?  Thanks,

We always check immediately before live update.  We also check at startup
if only-cpr-capable is specified.  Now the latter check will be done later
in startup, after groups are added.

- Steve

>>>> +
>>>>  static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
>>>>  					    unsigned long arg)
>>>>  {
>>>> @@ -2668,8 +2690,9 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
>>>>  	case VFIO_TYPE1v2_IOMMU:
>>>>  	case VFIO_TYPE1_NESTING_IOMMU:
>>>>  	case VFIO_UNMAP_ALL:
>>>> -	case VFIO_UPDATE_VADDR:
>>>>  		return 1;
>>>> +	case VFIO_UPDATE_VADDR:
>>>> +		return iommu && vfio_iommu_can_update_vaddr(iommu);
>>>>  	case VFIO_DMA_CC_IOMMU:
>>>>  		if (!iommu)
>>>>  			return 0;
>>>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>>>> index d7d8e09..6d36b84 100644
>>>> --- a/include/uapi/linux/vfio.h
>>>> +++ b/include/uapi/linux/vfio.h
>>>> @@ -49,7 +49,11 @@
>>>>  /* Supports VFIO_DMA_UNMAP_FLAG_ALL */
>>>>  #define VFIO_UNMAP_ALL			9
>>>>  
>>>> -/* Supports the vaddr flag for DMA map and unmap */
>>>> +/*
>>>> + * Supports the vaddr flag for DMA map and unmap.  Not supported for mediated
>>>> + * devices, so this capability is subject to change as groups are added or
>>>> + * removed.
>>>> + */
>>>>  #define VFIO_UPDATE_VADDR		10
>>>>  
>>>>  /*  
>>>   
>>
> 
