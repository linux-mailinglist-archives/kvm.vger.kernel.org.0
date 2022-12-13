Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD4F064BDFD
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 21:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236113AbiLMUh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 15:37:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236894AbiLMUhy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 15:37:54 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C5F10B54
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 12:37:52 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDJwn5Q021965;
        Tue, 13 Dec 2022 20:37:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=PtBVsxuAGvtN8to0RieWmi60QBAaQwpqtZvFjK8f2Ko=;
 b=D579/ytq55RLa2DLknNCTSh/3F9wbSby+7RNgpkzr4HoounO/Zvn5/Hmjav2O+OE6Jbw
 dhvbwwkilz5bvhl/CYQkglCaRz5G123l2c/N28zo4EU9bo8C4g63HiEk3phWYX/b1Rvv
 GTxM4sgmqikrWJq1JzuT8JJp2ZtN0+LlhjhL9Uf5AK76XzHT1YXkzM4Kx32bku1dqY5P
 PfAE4v1N3lyGG1X61tfsAUnKhStsPQh/r2qjiUZH6Ebmny/eZTKCFNuens6wUsikMZhz
 qS4sZcC5SFE3ZvjoE9DpDlBr+4mPlVZxUHsuu7LmxDgmIJYUzcdd9RjGlOCHolP7MvnX 9w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyeu06k0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 20:37:51 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BDJIsmJ029999;
        Tue, 13 Dec 2022 20:37:50 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyemuh2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 20:37:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LPMfupatTPcVaeBQWFLZcKo424jGBI9PyZBZbCo/GyJP30z9gcRyM/IuzdyU6J+FuZ47GxH9GqqwObMs90fNSDwkMoqqE/02DQ96jYjLw3IJjePUNfkdb6XhGiSawyPsAAMBmYSVa3mTP2y9NmwV57sALA4dde54yanhvXpzE00qfGUl3lZMmBynyf5LI06klTXCx0o8XwKGYviDNIAXNiUq6U/lsRUlxvPyG20dQWB8ReBnA/BRWCyTKfFyA5YH2RqV5pIFy/owGvAolVZI5pCXyy/peca47IDluYYozxwt10jAm4RkXreMOcOhA+lMixpcxM0qXE9gcmdsRu7VEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PtBVsxuAGvtN8to0RieWmi60QBAaQwpqtZvFjK8f2Ko=;
 b=bhSs70PI5Lc6I1GmiOfyzElw+9/4w/v53bLMvvsAjD/EPktXsOeZjpayL1DqkdY8UkT8/3L6PizJeL1utbXmb0a5T6W5+t7ijxSsCMkuWUimAzTFPnDG7tBumTK/4OuBWAe5BpBQ10DXT3bs/Vde+Om2t+PphBZexFKsWae0icBidMfoZQnKaqmToJ3DN0AXqSviTZ+q7OzMqMUsRhHdFi6daVQ1Kel3r6O3lRSCZBTUm0jR7et2SPlEFSkhgEUq0NEdgrIPsIAd21vc+LrGXacjPuuAXrGwIrQjEXR1r/XBEpZs8Csmvbkc0t2cWOzH6UILL6S0KwXaDd/J8zLfUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PtBVsxuAGvtN8to0RieWmi60QBAaQwpqtZvFjK8f2Ko=;
 b=hC36ReKquzJS+yBgqIyo/7McXQ4IoOjupAX3dF3lAPdTIsAXi5XUKG+q/aPgFefiGuZesb1xg2a8Ng+X1QZrbu5kuvVo9Mx5spG8Ho43R/wg8TdcKfS0hnZJh+0nDTVKNNRFlLFhSfXjQuCPvVvRTB/uPTartH7EnIapGTcESO8=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by BL3PR10MB6017.namprd10.prod.outlook.com (2603:10b6:208:3b0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 20:37:47 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e%4]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 20:37:47 +0000
Message-ID: <16a49fb7-e7bd-f794-9e12-9e88fa5d536c@oracle.com>
Date:   Tue, 13 Dec 2022 15:37:45 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH V2 1/5] vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
References: <1670960459-415264-1-git-send-email-steven.sistare@oracle.com>
 <1670960459-415264-2-git-send-email-steven.sistare@oracle.com>
 <20221213132245.10ef6873.alex.williamson@redhat.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221213132245.10ef6873.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0113.namprd04.prod.outlook.com
 (2603:10b6:806:122::28) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|BL3PR10MB6017:EE_
X-MS-Office365-Filtering-Correlation-Id: 6213e3b8-2de5-4076-2059-08dadd49e54f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bOYzrCQb+B5D1fKmjg7V2yTyJlLRndhNhql0BWO+j16SjUaOLN99ejR1l09jKUXEDJIV/k+8q2xiokrZvN9PO3BRggcxWiRcGkhUVudYKuyNR6CEgA2fxRvXOQaU/1iTkcAcC5npvvW8PQ6saHRMFkxVn5oTA9NtN7QNRp1i1rT+kbCiEk3xvALYKAUlC+THaPIyaACI94n8iXqmgF228AKDhn74CSceALmGxOp2uD+uUV/5J4CLM3YQUBKqw96gelNxTsfLTGlmjc16YLAoQwADU0nMu+tvpfmj2o/221Q9pRapnxo3R6Rcsq+1KyTDofsT3PXInAXrFkPEII2ewiu11vN77554eo9EUHImuuItsOUyCgoq3clAXZ1VhvSXwuNTMgJrIg1wynnyf5b/xfCJGwyAATG8UVvUpkfA3SFW50DBBpr7FnoqlZyye4qJ9jJZwVnsTjDKtXXuYdVxK36PCtKIUOUWW/FG7m7rAADBT/7jqnFrnj8BRSZnDq0YruHgUrzOWnq2FiMiJmvnJ3eeiwiJAkSGcxj66uBjQNndDCsTKBSlkDApkAoQtZ3eNZk2l+lq9ydktAZA6Aj5dadrwvyjWupwmFmHEtd365yZ0uOs9oD+ghNftlpwXD1gsf1rem5kmYY0z26pVSTQIA2tbqDWTKsqLEy7Vm250kEDjeTraPWTa+GrV4pmi2QCKzr75wQYD605N2rgZU5vS2bmPGjklojQuN6A6C7MqMI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(366004)(376002)(39860400002)(346002)(451199015)(31686004)(83380400001)(36916002)(31696002)(6486002)(478600001)(2906002)(86362001)(36756003)(186003)(2616005)(41300700001)(8676002)(44832011)(6512007)(26005)(66556008)(53546011)(6506007)(5660300002)(38100700002)(66476007)(4326008)(316002)(8936002)(6916009)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QVNGeEt1bjlPSmczT241eDZGaCs3VlJOZk84ZlFlOFEvUjdCZ3BNNlVOMDBE?=
 =?utf-8?B?L21pNFdMaHVMdWdBUithU2xSeTJadjZ0aC9NWU1VZC9NdktscDJHblBtOFFS?=
 =?utf-8?B?SjRNVUhVSHlyaElaVThpaDRxOStGQUFWbmM5Y1htWUc3U2VUQ1pDY0x2Vk15?=
 =?utf-8?B?V0pFNUIvalJFYzUzYzh2Q3A2OUgzRkhIUndTUDBqaTBpZWM1SnY5U0plYW5r?=
 =?utf-8?B?L3BaRXVzWW4rcHZrL1Z4eDlYN3MwcGUvNWhRbG9xV1VRWVZyaGNTTm9TOWVV?=
 =?utf-8?B?MXNGRGszdkFYMG1pRXdQdHZob0RTbGRHbTFkSDMwKzhxdXdyZmtML3Azd2RL?=
 =?utf-8?B?QWNsMllwS2NObXpuU2hxaFE3QURUU24zRUxYUWRKV1c3WThJWlhlN2svUWlI?=
 =?utf-8?B?ZlBQeWhJbmpwRGdvSmttd0VreVB5aHJXbkNRVzB0eGRhM2ZVUXBFOVUyaHVL?=
 =?utf-8?B?ejdoWktUZUdIR3ZqcW5ZLzJQWTFSb1FVdmJlYmFETnpwejZIN3ExaEc0OFR4?=
 =?utf-8?B?OWw2N2hqbjZCZHFRTGlNbVoyejMxQmxkNDBOdkM3RmZiQnNFQzdFR0JQNHVT?=
 =?utf-8?B?VEtxUDZrcWdNaS9ROG4yMmFOUWYvc0xqbVdWb3FPaFY2M21BRUYxZmptaUor?=
 =?utf-8?B?M09JNzlWcWw0TzVQckVZcGNaSndDUkcySHNwN0Nsb1hRS1JXNFA0dTJzdVlD?=
 =?utf-8?B?YncveW02R1RlZS9Zc3QyeWszR3VQU3JqK1pUc1VCM1AvamhzbGwwdWQ1Yy9p?=
 =?utf-8?B?OFM1Q2hSUU5LeE03T0djZGFJUWc4cGpnVHNTc0dwajZET0JjUldub05WOEV6?=
 =?utf-8?B?bWZad1Z0bXY5bVpVZDFCUU05eUlUMTZiT3N0YlNpOWhjWGdyazhwVzZzblB6?=
 =?utf-8?B?cGZNQ3JiR3g0SjZWVnJqV0p5bEIrOGhQSWp4VkZLUVdmOWszWHZmR3VYa29D?=
 =?utf-8?B?RjZlekU3dWRSQ1BPWWFCYmdVOUVEUkl2RDNuazdtYTBoMTJHVkt4bVZGaFZH?=
 =?utf-8?B?ckV5d203Y0FIUmpjTlJ5dnUzR09paURSeTQvQURLUDNwTWI1QkVqRnhiZDdn?=
 =?utf-8?B?aUZVOFJoSE1WSUJKanVjQXZKenE5cDhKQWJYOCt5ZlYxVU9XOWZNS1Y3aHI2?=
 =?utf-8?B?TmVNR2VxVFJXS2hGcG1WeVZldzdDZGt1bjRXSk9BUUtDN3RBYzFmRDE3QmE1?=
 =?utf-8?B?SSt5eWt4SS9KcDFraXo2ekt6bEdEMW5BWGVyckhzVXN5N0JweHUxRHJSOFZD?=
 =?utf-8?B?SFlHckxEQUJVY0NxTUJKV3NROGR2V0Q1UkVvKzk4dmRDUjNRRTl4Y3k1MnAv?=
 =?utf-8?B?TWViYzJ1VG43S0gvbTMzTWVKZDlidTJTT2tZMmxMcVRiTE91cHYrRmt3aDRV?=
 =?utf-8?B?clNDVG5RTlFXcW1YR2pER3JmL1hCenVJbkI1RkxFVmZlN1NNbXJHVU5UQm9n?=
 =?utf-8?B?TjdYQ0FKcjYzZGFndHliakVFMHVtVWU0dWQwNXdyR094ZStpQTh4THcybXh6?=
 =?utf-8?B?cTVjT3JNb0VUbmd6VGFwSkZJTVNZbXlZT1dXMXZpNjMzOVk0K2JnZWg1cXF4?=
 =?utf-8?B?UnFMcE5TR3F4OWVVM25NTDNNSzF6bkVkVEJEekRhWjFJYjlNUjJ2MWtvREZ4?=
 =?utf-8?B?aWwvNEdWY2grMkVCMnRTWU13cDdlaEpQc2tNU2s2UEdtbXdOdXhDb1Q1cld1?=
 =?utf-8?B?YXk1Q1lIaXlkT0dBS0lHeU1ETDBIT2FHM2JJOGFLV0FiQlVmUTNleG9qNllQ?=
 =?utf-8?B?THFzTm9mMFpQa1RwR2l4Wnd6Vit0NmJNcTk5aXdnVm9ZWEswb1RXOHdSdjAv?=
 =?utf-8?B?NzBBSlcwL0RXWFAvM2ZLY01hanBGUC9UZXNCVmlNUG1uS091RzhpZWNKMkxO?=
 =?utf-8?B?cWR5Vm53NFN2dysrNnRUNXhmQjVnRWxTeFF6VUtLcWhvL2NTOEdxOXJuN0xj?=
 =?utf-8?B?Nm5ZVHVDZUV2VlBGeWVSMlBGN2tGVHhpaktwTE9ET01HUTdTS1YybEJSOUpv?=
 =?utf-8?B?cHpkR2MrSnJyNmZ1VHpZUGwwS2lKSkI3Yy9QTmNIMWFDaURXYWJLS2RRT0gv?=
 =?utf-8?B?bS9IbDA4bzdxNldzTGNSRzFsalY3NERRenlKVWpsVVAxWkRIeGZDNHlYNEVn?=
 =?utf-8?B?QzNROEtoQjVMN3E3UkRsZlJycjhvQjZGQ2ExQlcvT0tSL1p2VUE2clVCb1Ro?=
 =?utf-8?B?VXc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6213e3b8-2de5-4076-2059-08dadd49e54f
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 20:37:47.7115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SZ9JITEz+95i0H7hcxlFUVDy3IIlzGGKuwdZhE4s9MxzXIPMUYhAi9GO4utv0+cCErDoIAqBf9iDAW3gsA7xqI1p6yla3osA5gdgCrkyAzU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6017
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212130179
X-Proofpoint-ORIG-GUID: Rm1CEYMtxa63me-xknbpQXCbOkrbuens
X-Proofpoint-GUID: Rm1CEYMtxa63me-xknbpQXCbOkrbuens
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/13/2022 3:22 PM, Alex Williamson wrote:
> On Tue, 13 Dec 2022 11:40:55 -0800
> Steve Sistare <steven.sistare@oracle.com> wrote:
> 
>> Disable the VFIO_UPDATE_VADDR capability if mediated devices are present.
>> Their kernel threads could be blocked indefinitely by a misbehaving
>> userland while trying to pin/unpin pages while vaddrs are being updated.
>>
>> Do not allow groups to be added to the container while vaddr's are invalid,
>> so we never need to block user threads from pinning, and can delete the
>> vaddr-waiting code in a subsequent patch.
>>
> 
> 
> Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")

will do in both patches, slipped through the cracks.

>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 31 ++++++++++++++++++++++++++++++-
>>  include/uapi/linux/vfio.h       | 15 +++++++++------
>>  2 files changed, 39 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 23c24fe..80bdb4d 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -859,6 +859,8 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>>  	if (!iommu->v2)
>>  		return -EACCES;
>>  
>> +	WARN_ON(iommu->vaddr_invalid_count);
>> +
> 
> I'd expect this to abort and return -errno rather than simply trigger a
> warning.

I added the three WARN_ON's at your request, but they should never fire because
we exclude mdevs.  I prefer not to bloat the code with additional checking that
never fires, and I would prefer to just delete WARN_ON, but its your call.

>>  	mutex_lock(&iommu->lock);
>>  
>>  	/*
>> @@ -976,6 +978,8 @@ static void vfio_iommu_type1_unpin_pages(void *iommu_data,
>>  
>>  	mutex_lock(&iommu->lock);
>>  
>> +	WARN_ON(iommu->vaddr_invalid_count);
>> +
> 
> This should never happen or else I'd suggest this also make an early
> exit.

I would like to delete the WARN_ON's entirely.

>>  	do_accounting = list_empty(&iommu->domain_list);
>>  	for (i = 0; i < npage; i++) {
>>  		dma_addr_t iova = user_iova + PAGE_SIZE * i;
>> @@ -1343,6 +1347,10 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>  
>>  	mutex_lock(&iommu->lock);
>>  
>> +	/* Cannot update vaddr if mdev is present. */
>> +	if (invalidate_vaddr && !list_empty(&iommu->emulated_iommu_groups))
>> +		goto unlock;
> 
> A different errno here to reflect that the container state is the issue
> might be appropriate here.

Will do.

>> +
>>  	pgshift = __ffs(iommu->pgsize_bitmap);
>>  	pgsize = (size_t)1 << pgshift;
>>  
>> @@ -2189,6 +2197,10 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>>  
>>  	mutex_lock(&iommu->lock);
>>  
>> +	/* Attach could require pinning, so disallow while vaddr is invalid. */
>> +	if (iommu->vaddr_invalid_count)
>> +		goto out_unlock;
>> +
>>  	/* Check for duplicates */
>>  	if (vfio_iommu_find_iommu_group(iommu, iommu_group))
>>  		goto out_unlock;
>> @@ -2660,6 +2672,16 @@ static int vfio_domains_have_enforce_cache_coherency(struct vfio_iommu *iommu)
>>  	return ret;
>>  }
>>  
>> +static int vfio_iommu_has_emulated(struct vfio_iommu *iommu)
>> +{
>> +	int ret;
>> +
>> +	mutex_lock(&iommu->lock);
>> +	ret = !list_empty(&iommu->emulated_iommu_groups);
>> +	mutex_unlock(&iommu->lock);
>> +	return ret;
>> +}
>> +
>>  static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
>>  					    unsigned long arg)
>>  {
>> @@ -2668,8 +2690,13 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
>>  	case VFIO_TYPE1v2_IOMMU:
>>  	case VFIO_TYPE1_NESTING_IOMMU:
>>  	case VFIO_UNMAP_ALL:
>> -	case VFIO_UPDATE_VADDR:
>>  		return 1;
>> +	case VFIO_UPDATE_VADDR:
>> +		/*
>> +		 * Disable this feature if mdevs are present.  They cannot
>> +		 * safely pin/unpin while vaddrs are being updated.
>> +		 */
>> +		return iommu && !vfio_iommu_has_emulated(iommu);
>>  	case VFIO_DMA_CC_IOMMU:
>>  		if (!iommu)
>>  			return 0;
>> @@ -3080,6 +3107,8 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
>>  	size_t offset;
>>  	int ret;
>>  
>> +	WARN_ON(iommu->vaddr_invalid_count);
>> +
> 
> Same as pinning, this should trigger -errno.  Thanks,

Another one that should never happen.  

- Steve

>>  	*copied = 0;
>>  
>>  	ret = vfio_find_dma_valid(iommu, user_iova, 1, &dma);
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index d7d8e09..4e8d344 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -49,7 +49,11 @@
>>  /* Supports VFIO_DMA_UNMAP_FLAG_ALL */
>>  #define VFIO_UNMAP_ALL			9
>>  
>> -/* Supports the vaddr flag for DMA map and unmap */
>> +/*
>> + * Supports the vaddr flag for DMA map and unmap.  Not supported for mediated
>> + * devices, so this capability is subject to change as groups are added or
>> + * removed.
>> + */
>>  #define VFIO_UPDATE_VADDR		10
>>  
>>  /*
>> @@ -1215,8 +1219,7 @@ struct vfio_iommu_type1_info_dma_avail {
>>   * Map process virtual addresses to IO virtual addresses using the
>>   * provided struct vfio_dma_map. Caller sets argsz. READ &/ WRITE required.
>>   *
>> - * If flags & VFIO_DMA_MAP_FLAG_VADDR, update the base vaddr for iova, and
>> - * unblock translation of host virtual addresses in the iova range.  The vaddr
>> + * If flags & VFIO_DMA_MAP_FLAG_VADDR, update the base vaddr for iova. The vaddr
>>   * must have previously been invalidated with VFIO_DMA_UNMAP_FLAG_VADDR.  To
>>   * maintain memory consistency within the user application, the updated vaddr
>>   * must address the same memory object as originally mapped.  Failure to do so
>> @@ -1267,9 +1270,9 @@ struct vfio_bitmap {
>>   * must be 0.  This cannot be combined with the get-dirty-bitmap flag.
>>   *
>>   * If flags & VFIO_DMA_UNMAP_FLAG_VADDR, do not unmap, but invalidate host
>> - * virtual addresses in the iova range.  Tasks that attempt to translate an
>> - * iova's vaddr will block.  DMA to already-mapped pages continues.  This
>> - * cannot be combined with the get-dirty-bitmap flag.
>> + * virtual addresses in the iova range.  DMA to already-mapped pages continues.
>> + * Groups may not be added to the container while any addresses are invalid.
>> + * This cannot be combined with the get-dirty-bitmap flag.
>>   */
>>  struct vfio_iommu_type1_dma_unmap {
>>  	__u32	argsz;
> 
