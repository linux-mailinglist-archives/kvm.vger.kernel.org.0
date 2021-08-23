Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBCB3F4E53
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 18:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbhHWQ2b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 12:28:31 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:55114 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229477AbhHWQ2b (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Aug 2021 12:28:31 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17NEhWTs010647;
        Mon, 23 Aug 2021 16:27:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=rHboY0p5JxAeGnXIXxI2CIR9iG9u7SkzQvS9+IidKyM=;
 b=IOOzKXHE+xLT02UJ8OfzjrNUr6wAJ1F4xZYSLYOx/7+J2wDoGbQTGCHjieOGliDue5X7
 Rju2ntwdnDS6bIEY2fETqL0xWVcmFHtx42gBgGxvHChlRk5nm80Xp6SwFxAIOtlSjeNE
 Dqv2NXbzxv+m8Xd3dyevRYffQdQT/jG0KHJZ9BFeypiMbf4QX75Xg19MnyuthUhiD4LO
 C0dDxK3Aptx4knIbPTpbthRIhldiHJjwZbvNOtskTAyLyvzXmieLTG4XyggRza0tiNIF
 bBCi7hF3WOGhLVapdAMwXYn4GzhjXOQl+deiMufKzo/pV80iVRslDon88cSS0ZTPocMP AQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=rHboY0p5JxAeGnXIXxI2CIR9iG9u7SkzQvS9+IidKyM=;
 b=LRptPnXbo/y6vEWcYAbjtTewtZkWyRAEk5x3WI8O9YXhjmq1gIjliGztlwtbYQASO5EV
 eU0JaLt5jrWRmET48h4wsH+/iibhaHp8mLBA016VvvifDu2+ywFcgwhHXZu9gPcepDoh
 iBvHr0SYCdG1O7dV15W8/4paK0Q/TDDL8NQuo96cK2xCkwY/vp/5r1iQdKfMxnkGvFI3
 bsLHRLEYfJRQg12cUqDMaWqk1FxKAhClggG9aa6IGzqETN8KgpZD4sbEt/wc0Km6L/7G
 W1moZ+GtoihVqKdxBarjzKmuuhWCgspxr3XZOFhGJGYjYwWJ5CiQn/6csjMvdTItl4cL mQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3akxre9x55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Aug 2021 16:27:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17NGFG1A157296;
        Mon, 23 Aug 2021 16:27:45 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by aserp3030.oracle.com with ESMTP id 3ajqhcxs2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Aug 2021 16:27:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hJqvFUhtXPWdeMVtX2qL/wZZDzrWjdawaWkV3DMB+8kEJvR3O+zMcqqRZCgkX3BR+V6pZRgmBZ+cyP1X1eAINtC40pnJXYphi0MuQwyWN8BykeoXeUJRNOqPD9JO9SpzNwGZry8eDYxC59M7gA8EltvkrHr8H9yhhP8fldhDDdZk91UWUW0X+UocpGcgBWkgJsgw2sM0sqBgrkcBRwBoL0dIXN93WgB51JiqvM+ldhickjip0qtRLuGxAPTGkxj5LHjJJvq7of076A0t2n4WDY7mlBojNdYAeDo42GiTLUA+QNkQzAKzauIC7S5DNBJAgFrjYpl7REBE+B69ZXiamQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rHboY0p5JxAeGnXIXxI2CIR9iG9u7SkzQvS9+IidKyM=;
 b=THJR61uUiRL6eKhXEUOM5hTmUtgj7vC1YsVMSxnITyKX5D9X6h2Cd9c0w0kRXkblOrYSZEzun16DlMfgDRVCVAvxE9zHeDaYUjhZ16YgzHiuvU6Q/NkdpoQMbDKvzz2YWgH+iUV9pnzrK/mKg0Pcc3Ek9+7I/FGFIDC27SVw6iwIIorBr5vkkutj4dtEcPO24oPTvz6wvvE/PDGeeK2RK6BtNtqHikLuq7hss3u/2JbiNjSAJG5rxjs5FNZctqytRs0+AdsImDRwdl7H9mdxsqnD+WgXPVjsgzrIc7SO4A0mtk+W/JGIONhjjTAhAaAXDcfGR7kXBeop6IrbJFSW+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rHboY0p5JxAeGnXIXxI2CIR9iG9u7SkzQvS9+IidKyM=;
 b=xrlU38zYNBSGtdGOhjzKHWVwQkAmRJdfI9at1OtcWLdLYdTyRWFv7bJVXN4r7yMD5rNZc7KPnNlZa4V6vhoKabZWNTMyo3iDm+N1UkGHywlxwa4jsRRAQIhiQRSDtIiqVZFiDdjdCvJkcs8zZohWte/HYYtz9aH/FrD/doDIz4E=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from MN2PR10MB3533.namprd10.prod.outlook.com (2603:10b6:208:118::32)
 by MN2PR10MB3278.namprd10.prod.outlook.com (2603:10b6:208:12a::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Mon, 23 Aug
 2021 16:27:42 +0000
Received: from MN2PR10MB3533.namprd10.prod.outlook.com
 ([fe80::b4a5:da86:b597:8547]) by MN2PR10MB3533.namprd10.prod.outlook.com
 ([fe80::b4a5:da86:b597:8547%7]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 16:27:42 +0000
Subject: Re: [PATCH v2] vfio/type1: Fix vfio_find_dma_valid return
To:     Steven Sistare <steven.sistare@oracle.com>, kvm@vger.kernel.org
Cc:     alex.williamson@redhat.com
References: <1629491974-27042-1-git-send-email-anthony.yznaga@oracle.com>
 <244084b3-83f3-533b-4211-5c7fa9404074@oracle.com>
From:   Anthony Yznaga <anthony.yznaga@oracle.com>
Message-ID: <193d2a2a-aedd-06e9-8a42-bbcfdf764c76@oracle.com>
Date:   Mon, 23 Aug 2021 09:27:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <244084b3-83f3-533b-4211-5c7fa9404074@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: SJ0PR13CA0221.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::16) To MN2PR10MB3533.namprd10.prod.outlook.com
 (2603:10b6:208:118::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.154.143.73] (137.254.7.176) by SJ0PR13CA0221.namprd13.prod.outlook.com (2603:10b6:a03:2c1::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.10 via Frontend Transport; Mon, 23 Aug 2021 16:27:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a02e09f0-8b8c-4afe-b613-08d96652ee64
X-MS-TrafficTypeDiagnostic: MN2PR10MB3278:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB327887DE1E3144BCEFC32FE7ECC49@MN2PR10MB3278.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:590;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RLzQ/vV2XIBhwnpTfVGWpIwuhABWvU2ThlPST/mm/m6k2gYMChRKfeM1t62el4jf08kIBihLX+3enrXdaLlzAx2hp6TXvXm99RX4SbYtq9XgR/L9ChKAsG+aLmYaSErZt+EHjRmmP60VJ4b6jVyOfcKXlpbOR8ICefZSc6xswVZjrqDxeaJpY3EkDQgTzHSvk5FscVeGsh1VNORMsJWKdt2dBMsETcK7zJL3VLIDRAOYo6GMJMIEVcqB3n5vlWg7y7KGwzkV1V4d/YDvZz9Z9865Cz8JOIA3FKBP8mKi3sVIpulOVqAv551eG77LRh/U2H3R1yLrVfWh7l3izCa0ghrc9I0+nlpnzK6kbbIOpJKASwtV1aHaGnfGeizRtnS9f0hBZYyEp+3KS7FC/o3WsKkvy35ljYSkRQ3L2awBotzu+H9SA9sO6lO6MbCZeB82kc3DWYirDIusBKq6zltC+9tZTi0SfAOldGkR5Wxvjbv8tSdUGvI4En5XkkvvJA0NFrbnTJ2PxV/tjOWir574LnAH2ij+zCduBa0bUchAxwpaG6Jj9tX/+gAjPCCzxUD+6Ztp1WvUPoPwCN+h/ydRdJl2+l9DfJ2S6boAc7Ykr5TLyD2uEBhoGRT4Z55WfFFQ1b0xgjGBxU+1TplfQDJ8NwmH3ErO/jtnncaDybutSdzKZZ1u+o3WcYbMLNsQFTD4EadGbykL/QaXkuq4LALb21c/wgMSuZtSdfza1b8Ygo0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB3533.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(4326008)(66946007)(66556008)(66476007)(8936002)(31696002)(186003)(5660300002)(44832011)(2906002)(16576012)(38100700002)(316002)(508600001)(26005)(6486002)(31686004)(2616005)(53546011)(956004)(86362001)(36756003)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ri9jbGIwYVpRR2UwcmVGNGo1N0wwY0ZFOU9xWGhHS1phcG51THV2cTZNVFdH?=
 =?utf-8?B?eXdaZFBBK2p6T3lVOEhWc0EwZGtyeWUwTFRIMHgwQm1IQ1M3T2Z5QlplNTVw?=
 =?utf-8?B?NHBlVzdaRXVZSkVEY01qR2tZWmwvYWt4Unp3OGFQZXZWbUhPeUlzbE9oRTJZ?=
 =?utf-8?B?dEFhcGNiNVl1UHlzcEh0MkkxSFpGL0dZVnBlTDBxcjMvTk1qK09hZ0szTEtD?=
 =?utf-8?B?d1VtalNJWCt4YkZKM1N0eUR4VERpbmxWMndMbHVZUU9sZ2hDMWdrV1NpSElS?=
 =?utf-8?B?R21LZXhKaEVva3pQV1BNQUhVZEtvcWtScFZLS2djSHhlRWsvU25GODMvbnBT?=
 =?utf-8?B?RkQvTDVzR1RDMXpYV3VacndsZ1RJRHhjZWtScGEwWFBaMEVsZWQvbDA4bW1R?=
 =?utf-8?B?M2srTDcyZHZ4S3d2RFkrbzNVb1lmTnViYWFtR3hKNit0UE9LUWpLZW04ODJ4?=
 =?utf-8?B?SGpPbkFTcHIwNjVGSG5UUEhNS3UvSUdnUXB1bWdtV1R1Vk51S0tydHlOSmI4?=
 =?utf-8?B?dGJYOUIzbjYveHJaS3BWb2d0TFV0OHQ0ZUxzUTJQTTdISTlUYXN3YjZzczJS?=
 =?utf-8?B?MU9NdlZXZ2hVQjZkR0VjZG9JZTRVVGQ1SjJQc08wOFc2UElOVSt3YTYyMlJ1?=
 =?utf-8?B?eFlUM3NxN1BwOS9vYU9qYlpXbnZWUWMydTNUWTdmS0ozMlo2MHJvTmlOOUds?=
 =?utf-8?B?YkIrbVBmRDRjWnhHSjE0emsyZWx4YSs0WDRXVW0wekwySDBBRjFXQThKQ0dt?=
 =?utf-8?B?MlVXMnVabnlpcVhzUCtZNXA0MDRBMWZoSmg5M3FBa3IwOXZveGgvRFNZbUta?=
 =?utf-8?B?Y2t3SFZXZXQ4TUpWcGJTWEFoL3F6R2RvYm8xejRSVDd1K1ZxVktEd3dkQ1do?=
 =?utf-8?B?clpjNEFscjV0NTVRcTl1djJTM2VaSWM4czFsU1ZmdnpvMmV0RytIWHRkWlF3?=
 =?utf-8?B?VzJhZVkzRWdKN1YrQ08xMkkyRlJYMS9IVHdkUVovejk5WDBjL2Y4cVhXdjZ6?=
 =?utf-8?B?T3NKTithVnpXMlJHbHMya2hKYTZtRWNXa21odE1MMFIyZWF1TmlvZVEvQ3F0?=
 =?utf-8?B?LzBWRU80RVpwQXYrcE9pU25CNFRrQzloQW44WEtURkl6UnBnVXVFaVlvWG1M?=
 =?utf-8?B?dHhJdDVBY0FuUHFPSGtoWkxNczFpZkxrRXRXMm5wUEpLZzhYNjRmeWlzbmdH?=
 =?utf-8?B?aTZOTnQxTWZxQ0tUQlM3ZUNqczh6WXdycGU1Mm83SmJuUDhLRVRZSkdaWnNn?=
 =?utf-8?B?RGhFMEJmZmsxOFdDVGJmZFc1L2tydVd3OHNDM0d2Tm5hMVAzeUZCSmY3WFhw?=
 =?utf-8?B?WE5mRDFpTVJOVnA0dnZvOFJDc3ppZ2MzdS83bXZhZjJrTGxxZWdQNFlMNER6?=
 =?utf-8?B?b0tiOTlMemNmRkFhcEVVc2lud01SdGQvc2MxZ0EzM2JaNW9ya3pNNjV2anpj?=
 =?utf-8?B?SUhkTWdhUExpbEdxR3lpaXZhZHZOTE1EZjJjY252ekJ1cHZCRnJvYkNyclAx?=
 =?utf-8?B?YTJ3VWtDQXRZd0JwQmxjTXlEQkwwUTVqVVBCTERIc1dTcE41TkJ6VVpmODda?=
 =?utf-8?B?VDBwdGxnQXo2ZXVBeXNIaWVkMDRLYVQwOWZQUG0wTlVuc3I3dFdKeERmRHA3?=
 =?utf-8?B?TElmWk1YZnR0M1RGMnp6Zm9WZW5yQ21qQnEzTzV2ZThKdTlRWlNXRnV0cHBU?=
 =?utf-8?B?ZitxWCttSXNwVlJYT3BSNWFDK0Yxa1JiTEtBOHpVVmpWdmhjSmd2M002dkti?=
 =?utf-8?Q?LcE3At5EYuTSQY0CiJ12aAjZhNNip8nUoVvqGmY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a02e09f0-8b8c-4afe-b613-08d96652ee64
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB3533.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 16:27:42.4473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mY38g4QueWdhUQfrl1rBhjp6CObLJ/KsGFL7JcoaOT4VYmqUNgaq3EXPBqBi9gBwLtAYjXsuFY4yDNDN2kKrUedR9jWWsT1rsyBlGlbUxks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3278
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108230112
X-Proofpoint-ORIG-GUID: mf0clUpYc6d2CDvpsFnIuO6-eTdFvGwO
X-Proofpoint-GUID: mf0clUpYc6d2CDvpsFnIuO6-eTdFvGwO
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/23/21 7:58 AM, Steven Sistare wrote:
> On 8/20/2021 4:39 PM, Anthony Yznaga wrote:
>> Fix vfio_find_dma_valid to return WAITED on success if it was necessary
>> to wait which mean iommu lock was dropped and reacquired.  This allows
>> vfio_iommu_type1_pin_pages to recheck vaddr_invalid_count and possibly
>> avoid the checking the validity of every vaddr in its list.
>>
>> Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
>> ---
>> v2:
>>   use Alex Williamson's simplified fix
> Hi Anthony, thanks for finding and fixing this.  I suggest you modify the commit 
> message to describe the bug.  Something like:
>
>   vfio_find_dma_valid is defined to return WAITED on success if it was
>   necessary to wait.  However, the loop forgets the WAITED value returned
>   by vfio_wait() and returns 0 in a later iteration.  Fix it.
>
> With that, 
> Reviewed-by: Steve Sistare <steven.sistare@oracle.com>

Thank, Steve.  I'll send out a v3 with the updated commit message.

Anthony

>
> - Steve
>
>>  drivers/vfio/vfio_iommu_type1.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 0b4f7c174c7a..0e9217687f5c 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -612,17 +612,17 @@ static int vfio_wait(struct vfio_iommu *iommu)
>>  static int vfio_find_dma_valid(struct vfio_iommu *iommu, dma_addr_t start,
>>  			       size_t size, struct vfio_dma **dma_p)
>>  {
>> -	int ret;
>> +	int ret = 0;
>>  
>>  	do {
>>  		*dma_p = vfio_find_dma(iommu, start, size);
>>  		if (!*dma_p)
>> -			ret = -EINVAL;
>> +			return -EINVAL;
>>  		else if (!(*dma_p)->vaddr_invalid)
>> -			ret = 0;
>> +			return ret;
>>  		else
>>  			ret = vfio_wait(iommu);
>> -	} while (ret > 0);
>> +	} while (ret == WAITED);
>>  
>>  	return ret;
>>  }
>>

