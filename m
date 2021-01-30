Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBEC3096EB
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 17:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhA3QwX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 11:52:23 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60276 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhA3QwV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Jan 2021 11:52:21 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10UGkSEZ037576;
        Sat, 30 Jan 2021 16:51:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=gbxMa3MC+j19B2TmAnfhai3SO3A352mwVY8CA6KAhJQ=;
 b=J8MPj5tbRD5Kx8sLkD4EycT0JvMRXOGeaKPbQHnC+0UrbgRshdhriZiQBab+C1ZIV3F2
 RIOtrOwCSl6qxc1jLAgbTybcIc39vwC7bodWZ6sUFJYF3BOhgh0sq03VY+Xuc/r1U+kn
 p9Vog9xXOLjRFH1FVrohd/FMRi+4/QOmeqvM5aCB/j13sjXOgW8NWJjodL+huYMW9zNh
 RFPVHl+hScGtwHT7xp+sEBY2QVnrnXni0fcTgnZWkrewhF9HJMW0zkM+CR46OhOX8fNg
 MtJc186s0tB5mjr+4nMvWZ0oa/7VSn42YDp0ervfdiXS25Gq1lBadIm8/Og1F+32Xm/c ag== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 36cvyah4ty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 30 Jan 2021 16:51:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10UGjxHH192263;
        Sat, 30 Jan 2021 16:51:34 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by userp3020.oracle.com with ESMTP id 36cxsgsx58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 30 Jan 2021 16:51:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JCGgOh9gbfSyXN0CxTw+Mirsp4mcqASqpA/BG++arpZnsn1FFLie80nV62Fi6+esC3PVpty3iO5kSXOwKOVvwpEppl0BI4QGdt2Ab6HMvZ0u1i8dLZ+EcIQcirrY7Lhv7eLS7rgBI6O6ta5PRvuZsl/zIYPUGAv8AdZ8A9xzSehBcw+MeGsNUsLTlOfjhGUcv4ZQmT3eswP56Gr4O2tu7ccWNZLolYP6ItAjmRYPsqYw5/6QZ7hXBNcnSZn2Gt9E1liyPAsgbara9j7JFbR6d8609JbXwkYJBNm0IzkLRxvrIR+1E/I2bdZOXPFfTPoP5vzwcEtmZ6cQvbRvXinToA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gbxMa3MC+j19B2TmAnfhai3SO3A352mwVY8CA6KAhJQ=;
 b=H9G9ehjjrOG41A/qZyFfX+lHXvm3ym1ZH/3Dbp+xq3S/K9/CwmJIp1Pz6iY3FjubcVFuN2VCwg/EsuT0C61Y01CvrUYH4qry64ZsO3Hfl/dw63kJsf9lj+mHDjPqD6jDopAQYR7yjClQuwwgcljUwFwkVXWUJw9JV46zHnQY5fgbiiWuaSm/opqT10CmQU1taLkAvtZZS+KU+8GiFzQmBpBNDQDU9IFvQxuTzM3NnoqHrdeKEYNJnJGX6omat0W2Clim2eZ4Z7kzfkB5m7SlA8qmhzJlSSarXC0zklzdq9Q1UkJwxTNEtHukZ5097gp6K3HF3AW9hhIlUUtasg3VPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gbxMa3MC+j19B2TmAnfhai3SO3A352mwVY8CA6KAhJQ=;
 b=S/23UkqrXOKH0U99Ur3TWVlZX5Za4Jy49RpNCpsFh6cGwORQxWxc4rWxq2SfN4mdPw4/mht3mqjUxEK0sEqVan+C7U5K7O8NBZ6h9Eg/4U3MhrvrQ5Lkyg21lPE9e8LyhyBM6dQ46kHG/uQTUoEYIImuMD+iCjyVp2PolETYBzM=
Received: from BYAPR10MB3240.namprd10.prod.outlook.com (2603:10b6:a03:155::17)
 by BY5PR10MB4340.namprd10.prod.outlook.com (2603:10b6:a03:210::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.23; Sat, 30 Jan
 2021 16:51:32 +0000
Received: from BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::9123:2652:e975:aa26]) by BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::9123:2652:e975:aa26%5]) with mapi id 15.20.3805.022; Sat, 30 Jan 2021
 16:51:32 +0000
Subject: Re: [PATCH V3 6/9] vfio/type1: implement interfaces to update vaddr
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
References: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
 <1611939252-7240-7-git-send-email-steven.sistare@oracle.com>
 <20210129145650.4a95b45d@omen.home.shazbot.org>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
Message-ID: <7e311a78-b02b-f17f-8b2f-58d38937942d@oracle.com>
Date:   Sat, 30 Jan 2021 11:51:28 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210129145650.4a95b45d@omen.home.shazbot.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [24.62.106.7]
X-ClientProxiedBy: BYAPR07CA0061.namprd07.prod.outlook.com
 (2603:10b6:a03:60::38) To BYAPR10MB3240.namprd10.prod.outlook.com
 (2603:10b6:a03:155::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.92] (24.62.106.7) by BYAPR07CA0061.namprd07.prod.outlook.com (2603:10b6:a03:60::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Sat, 30 Jan 2021 16:51:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 590304c7-9052-4264-2609-08d8c53f4c4d
X-MS-TrafficTypeDiagnostic: BY5PR10MB4340:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB43407CB5B3664D40FE43D60AF9B89@BY5PR10MB4340.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sScLVOIWa2s23wQqpdQM0AvrOVzrwbPb70u85V1OqNEX/SYmAJreR+7b8qXXXuJQaoZ3Z33wNFZtn0ehApFKZDTflo7VsFDf6tFeGnO8XX+7sMW7MWyMxZwnTIZj3UZFefsz24jrHWw3K4RYfrPb9OK3jZrKWoBweOvmurvHWRBpLi1HkMF333V3r3Yt//tfpnvCOrtdIXxHdosDLJyCocNeS88XNV2qcO5aVk4zMLzgRYAR5NXnwkr8A7z7ePWg8pIK5Hr7N9nT7iR+zlOLYdmo6DX5vaS14rHayQ55treLGwea2OJqYK4A/drgrv6X64csSveO1atsfRIWorcmfUmH345qUjaDqNdoKynPws7uTXb9AN5KHqRwWIUZ9+qHJ3KAKXdUs1dD1Ke45qCOQ2MWVTS7yumagmsdbCWgmqXW32mXW8Ii3P7aAirOb7L/N1ps79o0icL06V2MOPhfRA24lw+lojGhR/X5EfPf04f+4Bwh9RHvWAJHbzKVZSJlSFW8CSVS+mge9S8jMqyyxtO13p3mdxhQPaPzICYJYkxObm1UFFJxn0ST4vam5ylinWYhwVEsy7cG9isRDCzX3sPZicd/SAFyviFbFey0KTz4gGUrlcNRtFl8Fdntm2goQ+AZ+Ox2kcRyipQAqS771w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3240.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(366004)(346002)(136003)(54906003)(8676002)(2616005)(31696002)(44832011)(8936002)(16576012)(316002)(2906002)(15650500001)(956004)(86362001)(4326008)(6916009)(6666004)(83380400001)(36756003)(6486002)(36916002)(31686004)(66946007)(186003)(26005)(5660300002)(66556008)(66476007)(53546011)(16526019)(478600001)(76704002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Wld4QnBJajEzRXIrcUtrN2ZsOTEvNEd2TGw1Rk5IZ3J1NGZuR2FiWENUMGZD?=
 =?utf-8?B?VzlzMU9SYUg0Q0tDTFdpOXpXRWhOcGdYNVpiSm05eUJza2hHbDhKRE5hSGNV?=
 =?utf-8?B?T2VXL3NkNHpjbThabk5zTUR1bHdVRCtLYzQ2UGdzK2JDNVpjRFVVSkQxdVow?=
 =?utf-8?B?WlIrOFFSdXdFZ2o3ZDEzN2tuVVZNV05pTmxQb2t1VkZORzdVcW8vWjk1Zzlr?=
 =?utf-8?B?UDlmUjVmTmZWQ0VqSkprdFBLeElHcS9PMU1Edmo4dlVsaWorNzh1NEN3cEZv?=
 =?utf-8?B?VmFlYmliY0NKYVE3bjFKdlRObVo3VEJlQ2ZsOVBnN3NtT2hqQWZXMFRpVnp1?=
 =?utf-8?B?UkxiaVoyQVpQTVF0T29ZVks2ZWpObjRJRHAyTVhOdGprK3NFenZYQTgrcExK?=
 =?utf-8?B?ZmI0K0o5SzdnSENGMlF4bndWZGYxV0d0bFQyS2dXWUF0QTkzQ2JuMGY0SU5X?=
 =?utf-8?B?eHpoZXZQbzd2enBrM1JrdGt3enpnRWFMbzNmRys4aXA3TFhEYW9ReDRDTCtB?=
 =?utf-8?B?c1M1RXA4MmhYaThHZlJKUWZ0MTZQQTNieWNKZ0dYWno2b2Z5d1FhaCtTaW81?=
 =?utf-8?B?TzhSSS9hdk9SamkzSlZKT3YwRW14a0VyTVR0SSttR0FtVDFnS0lVMmhLenhF?=
 =?utf-8?B?SitnbWp3elkrZmd6WXBYamNxbjhzelNueXBrbWVJWXhxM3Y2TE5CeHBVK0I4?=
 =?utf-8?B?UnBBY0VHaWMwaTdtRmJvb2dmWUtyTEZ0bjF4SUlOT0xsbkErbU9oYUM4M0cw?=
 =?utf-8?B?c2dhQ1J1R3N3eEpjbmo0aUtwbnd0VFRDR1BOWFJxeHJ6ckxzY1hxcysxbFd3?=
 =?utf-8?B?V3hRMS9TNFZsN2dEdEJpWlA1aGh1UG91NXJBN2R0b3RaVFZocnQxd2hBLzhG?=
 =?utf-8?B?UkcySnVrN01aYUNEc2dNWXp2V2VaZnVTRHdxQUpkK0gvOUJrVnpoYmh0Rm9L?=
 =?utf-8?B?NS9KTDZXK0FiR1l0NlhRUmhvdG9BRHIvcENkaDYzVGxSQjVOVjV6azBIeEVR?=
 =?utf-8?B?S1pqdTZIZVliUnhIakRqVGlkck5wUXJYMGRYNkFhdi9GSE9sanNDajhpNjFC?=
 =?utf-8?B?bFYxcnZKQXVEN2xiS1JUZFIxL2d5cC8va2RGdHgxU2N4MVlMbGYzMm9IVmoz?=
 =?utf-8?B?WkI2MExwQ1pNcXNNT1VnM2RxYlpIVnpUMFJ5MXJ2N0FJanlUOGhtaEJ2WHRI?=
 =?utf-8?B?R2RJU2NZV0tBOTRSNktyVC9uYkFzbzVhUUw3WEJ0ZXl1NlEvUnVtbEYybENh?=
 =?utf-8?B?OGhldUxuOXMvMzJsb0tqb2JoR1JseWRmT2Q0VFR2VnFlbXUvQVZycEcvb3Ni?=
 =?utf-8?B?dy9XRzRKVlBWZzFNemNQUEdQd2JTOHB1Uk93bVFHTCtyNWp5QWR3WUYvdzJO?=
 =?utf-8?B?QTdBRjRGSXpOSlVjSUM1VzlJMjhzd3RaeTNaQ09EdnRnVlRBamxlOFFranJo?=
 =?utf-8?Q?cmf8hyde?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 590304c7-9052-4264-2609-08d8c53f4c4d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3240.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2021 16:51:32.7500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BJsa1QDn9Gb/sAWoWQ3u6fhePafNmYf3TUDrKkPa+LzcDs8GNEGbaf3x9ICLq23CL1PYd4sdbvqq1FQ2bwm81TIF705znmhjNzFxZOD+fKg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4340
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9880 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101300091
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9880 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101300091
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/29/2021 4:56 PM, Alex Williamson wrote:
> On Fri, 29 Jan 2021 08:54:09 -0800
> Steve Sistare <steven.sistare@oracle.com> wrote:
> 
>> Implement VFIO_DMA_UNMAP_FLAG_VADDR, VFIO_DMA_MAP_FLAG_VADDR, and
>> VFIO_UPDATE_VADDR.  This is a partial implementation.  Blocking is
>> added in a subsequent patch.
>>
>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 62 +++++++++++++++++++++++++++++++++++++----
>>  1 file changed, 56 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 5823607..cbe3c65 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -74,6 +74,7 @@ struct vfio_iommu {
>>  	bool			nesting;
>>  	bool			dirty_page_tracking;
>>  	bool			pinned_page_dirty_scope;
>> +	int			vaddr_invalid_count;
> 
> Nit, I'll move this up in the struct for alignment/hole purposes.  

OK.
I noticed the hole, but I also noticed that the booleans were not declared in
the hole, so I thought perhaps you cared about maintaining binary compatibility.

> Also
> I think this should be an unsigned, we never use the negative value for
> sanity checking and our number of vfio_dma entries is governed by an
> unsigned int.

Agreed.

>>  };
>>  
>>  struct vfio_domain {
>> @@ -92,6 +93,7 @@ struct vfio_dma {
>>  	int			prot;		/* IOMMU_READ/WRITE */
>>  	bool			iommu_mapped;
>>  	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
>> +	bool			vaddr_invalid;
>>  	struct task_struct	*task;
>>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>>  	unsigned long		*bitmap;
>> @@ -973,6 +975,8 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>>  	vfio_unlink_dma(iommu, dma);
>>  	put_task_struct(dma->task);
>>  	vfio_dma_bitmap_free(dma);
>> +	if (dma->vaddr_invalid)
>> +		--iommu->vaddr_invalid_count;
> 
> I'm not a fan of the -- on the left, nor the mixing with ++ on the
> right.  Can I move the -- to the right?

Yes please, same here!  I saw a lot of --prefix usage in the kernel so I made a guess 
that it was a preferred style.

>>  	kfree(dma);
>>  	iommu->dma_avail++;
>>  }
>> @@ -1103,7 +1107,8 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>  	dma_addr_t iova = unmap->iova;
>>  	unsigned long size = unmap->size;
>>  	bool unmap_all = !!(unmap->flags & VFIO_DMA_UNMAP_FLAG_ALL);
>> -	struct rb_node *n;
>> +	bool invalidate_vaddr = !!(unmap->flags & VFIO_DMA_UNMAP_FLAG_VADDR);
> 
> Nit, !! is not necessary and inconsistent with the MAP side below, will
> remove here and for previous unmap_all use.

Yes please.  I was not sure if the community was OK with variables declared bool
taking values other than 0 or 1.  And I missed the !! in map.

>> +	struct rb_node *n, *first_n, *last_n;
>>  
>>  	mutex_lock(&iommu->lock);
>>  
>> @@ -1174,7 +1179,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>  	}
>>  
>>  	ret = 0;
>> -	n = vfio_find_dma_first(iommu, iova, size);
>> +	n = first_n = vfio_find_dma_first(iommu, iova, size);
>>  
>>  	while (n) {
>>  		dma = rb_entry(n, struct vfio_dma, node);
>> @@ -1190,6 +1195,16 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>  		if (dma->task->mm != current->mm)
>>  			break;
>>  
>> +		if (invalidate_vaddr) {
>> +			if (dma->vaddr_invalid)
>> +				goto unwind;
> 
> The unwind actually fits pretty well inline here and avoids the leap
> frogging gotos below.  last_n can also be scoped within the unwind more
> easily here.

Sure, that keeps all the vaddr code in one place.

>> +			dma->vaddr_invalid = true;
>> +			iommu->vaddr_invalid_count++;
>> +			unmapped += dma->size;
>> +			n = rb_next(n);
>> +			continue;
>> +		}
>> +
>>  		if (!RB_EMPTY_ROOT(&dma->pfn_list)) {
>>  			struct vfio_iommu_type1_dma_unmap nb_unmap;
>>  
>> @@ -1228,6 +1243,18 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>  		n = rb_next(n);
>>  		vfio_remove_dma(iommu, dma);
>>  	}
>> +	goto unlock;
>> +
>> +unwind:
>> +	last_n = n;
>> +
>> +	for (n = first_n; n != last_n; n = rb_next(n)) {
>> +		dma = rb_entry(n, struct vfio_dma, node);
>> +		dma->vaddr_invalid = false;
>> +		--iommu->vaddr_invalid_count;
>> +	}
>> +	ret = -EINVAL;
>> +	unmapped = 0;
>>  
>>  unlock:
>>  	mutex_unlock(&iommu->lock);
>> @@ -1329,6 +1356,7 @@ static bool vfio_iommu_iova_dma_valid(struct vfio_iommu *iommu,
>>  static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>  			   struct vfio_iommu_type1_dma_map *map)
>>  {
>> +	bool set_vaddr = map->flags & VFIO_DMA_MAP_FLAG_VADDR;
>>  	dma_addr_t iova = map->iova;
>>  	unsigned long vaddr = map->vaddr;
>>  	size_t size = map->size;
>> @@ -1346,13 +1374,16 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>  	if (map->flags & VFIO_DMA_MAP_FLAG_READ)
>>  		prot |= IOMMU_READ;
>>  
>> +	if ((prot && set_vaddr) || (!prot && !set_vaddr))
>> +		return -EINVAL;
>> +
>>  	mutex_lock(&iommu->lock);
>>  
>>  	pgsize = (size_t)1 << __ffs(iommu->pgsize_bitmap);
>>  
>>  	WARN_ON((pgsize - 1) & PAGE_MASK);
>>  
>> -	if (!prot || !size || (size | iova | vaddr) & (pgsize - 1)) {
>> +	if (!size || (size | iova | vaddr) & (pgsize - 1)) {
>>  		ret = -EINVAL;
>>  		goto out_unlock;
>>  	}
>> @@ -1363,7 +1394,20 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>  		goto out_unlock;
>>  	}
>>  
>> -	if (vfio_find_dma(iommu, iova, size)) {
>> +	dma = vfio_find_dma(iommu, iova, size);
>> +	if (set_vaddr) {
>> +		if (!dma) {
>> +			ret = -ENOENT;
>> +		} else if (!dma->vaddr_invalid || dma->iova != iova ||
>> +			   dma->size != size) {
>> +			ret = -EINVAL;
>> +		} else {
>> +			dma->vaddr = vaddr;
>> +			dma->vaddr_invalid = false;
>> +			--iommu->vaddr_invalid_count;
>> +		}
>> +		goto out_unlock;
>> +	} else if (dma) {
>>  		ret = -EEXIST;
>>  		goto out_unlock;
>>  	}
>> @@ -1387,6 +1431,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>  	iommu->dma_avail--;
>>  	dma->iova = iova;
>>  	dma->vaddr = vaddr;
>> +	dma->vaddr_invalid = false;
>>  	dma->prot = prot;
>>  
>>  	/*
>> @@ -2483,6 +2528,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
>>  	INIT_LIST_HEAD(&iommu->iova_list);
>>  	iommu->dma_list = RB_ROOT;
>>  	iommu->dma_avail = dma_entry_limit;
>> +	iommu->vaddr_invalid_count = 0;
> 
> Nit, we can drop this.

OK.

- Steve

>>  	mutex_init(&iommu->lock);
>>  	BLOCKING_INIT_NOTIFIER_HEAD(&iommu->notifier);
>>  
>> @@ -2555,6 +2601,7 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
>>  	case VFIO_TYPE1v2_IOMMU:
>>  	case VFIO_TYPE1_NESTING_IOMMU:
>>  	case VFIO_UNMAP_ALL:
>> +	case VFIO_UPDATE_VADDR:
>>  		return 1;
>>  	case VFIO_DMA_CC_IOMMU:
>>  		if (!iommu)
>> @@ -2709,7 +2756,8 @@ static int vfio_iommu_type1_map_dma(struct vfio_iommu *iommu,
>>  {
>>  	struct vfio_iommu_type1_dma_map map;
>>  	unsigned long minsz;
>> -	uint32_t mask = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE;
>> +	uint32_t mask = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE |
>> +			VFIO_DMA_MAP_FLAG_VADDR;
>>  
>>  	minsz = offsetofend(struct vfio_iommu_type1_dma_map, size);
>>  
>> @@ -2728,6 +2776,7 @@ static int vfio_iommu_type1_unmap_dma(struct vfio_iommu *iommu,
>>  	struct vfio_iommu_type1_dma_unmap unmap;
>>  	struct vfio_bitmap bitmap = { 0 };
>>  	uint32_t mask = VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP |
>> +			VFIO_DMA_UNMAP_FLAG_VADDR |
>>  			VFIO_DMA_UNMAP_FLAG_ALL;
>>  	unsigned long minsz;
>>  	int ret;
>> @@ -2741,7 +2790,8 @@ static int vfio_iommu_type1_unmap_dma(struct vfio_iommu *iommu,
>>  		return -EINVAL;
>>  
>>  	if ((unmap.flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
>> -	    (unmap.flags & VFIO_DMA_UNMAP_FLAG_ALL))
>> +	    (unmap.flags & (VFIO_DMA_UNMAP_FLAG_ALL |
>> +			    VFIO_DMA_UNMAP_FLAG_VADDR)))
>>  		return -EINVAL;
>>  
>>  	if (unmap.flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) {
> 
