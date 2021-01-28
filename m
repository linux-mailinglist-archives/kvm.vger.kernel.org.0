Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D19307C28
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 18:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbhA1RVq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 12:21:46 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59726 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233052AbhA1RTW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 12:19:22 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10SH9v2L142536;
        Thu, 28 Jan 2021 17:18:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=YIhT6RDIvq6WNr9ty14ITrahbvo6Iw5CivDMt2ItaSw=;
 b=ksP9yEZZoPQh03Sc3bwq1Aczn+sR7z2IbJertR0rX23riYJgrP4+FmeENGNBx+OFNAPc
 BuFqkwbnVbHO+nTj+HehTe0PX/4U1eM+uxZZ7CXepCafP2uUUJAytXxKqAL3S1xRM03j
 gCWFzY3Sux2tjtC8yKIQ4yWcmyix1ts1RaXNo/TWwymmsBnksK9I+kzDEt9hXT7UUf5k
 ZnL/SZ5qxXmXTF9D9STiIU/TfNeX2HC1yaCzfn/qhPhZtkfvSiw9pndZLR0+BPxsHKYS
 mNM+pmMrF6rbHJ5fsjDWFPpJAz2uYuMvTO4LEQDuiS1evHMW4V4+kpDktXr4QA7Pjm+d 5A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 368b7r5acy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 17:18:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10SHAd0u112490;
        Thu, 28 Jan 2021 17:18:34 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by aserp3020.oracle.com with ESMTP id 368wq2018k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 17:18:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IXexaUJPt2Gh8N3eq6cQMQUwfGh5Znod2oPw1vO45yiYS2gx0ldL4sllSmhXXj1LEZxCcDPDM6Z5+aNgs7KHV6+HjbnXMNL4NTyzcJDlQNbgXa6+oxsFOspO2vfWLRYN2HTSmRlhhAkojoK+ZEafJKqKua1eSIhhB/j6w6TZOkw+ltGPB9w5XbOxk0b/U1pCdHQWtLgeaw13/ea1jV8aQpOSFyOWS8yzxvZPo3msldNjpJ+kUndMO5k8Ph74gvQDIfhUVEekoFVnphBV6IIGTw3Wr15qyUkUHJjKu3bn7aNna1cT2yRx6UFvMqiCpGpBz4ypdgm+R+qv9qZQcZMCpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YIhT6RDIvq6WNr9ty14ITrahbvo6Iw5CivDMt2ItaSw=;
 b=e3LNpj10d1o7neTrK2XrzS+XamOze1p0+lkULhuZT/nZefsDmTGXwrejTjZQgnyT+6z+WdKYkcE29u92+/qjLCe5ZCUBOlcSpG0SlxfRTaxYFoJhqsh+Q4SprI43rjwkRD+KZ0qnT383sF7K1dG3S4P6zqpskEU0oZbdomHMRKpYuzV4Whp9XItSHxl8Z6XaVBzUvvVmig1gXm7fCBqeU/fxZIzNgvFW6x3sxG9UVUhTtbKHsMCfcpq8NSDW4jm7zilLACfBXq8qtIg04R0qwjTphTeo/prHNYeqnSr/OdWQXwR14vw6Fpu7g+XWY8ajRgjxVZ/bPTwrEVgHN+7XUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YIhT6RDIvq6WNr9ty14ITrahbvo6Iw5CivDMt2ItaSw=;
 b=okAQsVTne9cKtYIoWhYMviYXZAVYTmI3I4si0hNtTZjWzLG4HHftFRIDpFLIc2J4oJfV3hmVEah8dgUEtQMxYu5Gim1SOtWftpfaS7zkCvvPKEU/K/wquZJfIYttc9FzmW0XGSKQBEUstFJ4FXB/11bncZNrz/thiPIDU4S4QrU=
Received: from BYAPR10MB3240.namprd10.prod.outlook.com (2603:10b6:a03:155::17)
 by BY5PR10MB4241.namprd10.prod.outlook.com (2603:10b6:a03:208::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Thu, 28 Jan
 2021 17:18:32 +0000
Received: from BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::9123:2652:e975:aa26]) by BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::9123:2652:e975:aa26%5]) with mapi id 15.20.3805.017; Thu, 28 Jan 2021
 17:18:32 +0000
Subject: Re: [PATCH V2 9/9] vfio/type1: block on invalid vaddr
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
References: <1611078509-181959-1-git-send-email-steven.sistare@oracle.com>
 <1611078509-181959-10-git-send-email-steven.sistare@oracle.com>
 <20210122155946.3f42dfc9@omen.home.shazbot.org>
 <2df4d9b2-e668-788d-7c2c-8c27199a0818@oracle.com>
 <20210127170325.0967e16c@omen.home.shazbot.org>
 <20210128100709.5e4e7bed@omen.home.shazbot.org>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
Message-ID: <3e81ad22-37e3-1ac2-48ec-18a2715c2fde@oracle.com>
Date:   Thu, 28 Jan 2021 12:18:28 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210128100709.5e4e7bed@omen.home.shazbot.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [24.62.106.7]
X-ClientProxiedBy: CH2PR07CA0042.namprd07.prod.outlook.com
 (2603:10b6:610:5b::16) To BYAPR10MB3240.namprd10.prod.outlook.com
 (2603:10b6:a03:155::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.92] (24.62.106.7) by CH2PR07CA0042.namprd07.prod.outlook.com (2603:10b6:610:5b::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Thu, 28 Jan 2021 17:18:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08c97335-5e04-4ffa-6f57-08d8c3b0bccc
X-MS-TrafficTypeDiagnostic: BY5PR10MB4241:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4241EEF6E7517D03463607D7F9BA9@BY5PR10MB4241.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uO+CZbwKukkzZNHeOzvW0FhOlL5j2jmvnOOwGc6Rx1gR6eK3kdRG+z8DT7Z4gqAhiM6EdQusxU4yKc99maNccp3s4R8gjGL6hnrucC4QWb9fxVBDd+sa2ANv/tanlxv+ynV4VXU2XAuILloIV/m+F88LzPtzccK6Z3N7kgqdSCkov01Lydt4VzfdAhE4F9klMvEIvm79SSs17PCcoxMYhRVg9baUcPdYAkF1TCW4AC0lCc2VSWR9vREtyClOefiAjI5p7WraQm3B4c0WZyZ7L5BEPi99rD315d10z2aQKlJV/ESpgPliK+3aQP+TLygR4fNaJBAm2+ITBxhW8H8EfJfVeFzM/wJS7b5BwQ6bNCKKq5ll/YUILd8OUzqzcFtAnrqL6UPOAft05kLOC+DG7Sl/w+TVKW3lBQ3l3pcw6W6joOLTVzYvY4p3acCdRjUl/Oy6Y52V2IXdLTyrUpZe0ZUcodqmAHGQi5eRhL6D0YnVp6AgjbXl8RA2V7EOp2qovTMV3EQcE5dwcvbeadszfRhl1TIOM1BNrCn2dkzLNrF12zXdY7KTHle0526basyLO1og+C/tcyLiy69K8PUXW3w+jCk/oJ2kbjXb4Z+thPs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3240.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(39860400002)(366004)(136003)(376002)(6486002)(6666004)(186003)(16526019)(2906002)(8936002)(31696002)(86362001)(16576012)(5660300002)(31686004)(478600001)(36916002)(36756003)(6916009)(4326008)(54906003)(44832011)(66556008)(66946007)(66476007)(26005)(956004)(53546011)(2616005)(8676002)(83380400001)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?N2U2bDVSMVBhUk9PV2tkckV4SWt2UzJmdC9vNEJvU2YrWmVaOUF3Q1V6Z2FZ?=
 =?utf-8?B?bThIakVEays5QVlaeXRqbHBTZ2FycDVPTG5qRGVnWk5lck5JM0VvcVpQZ0F1?=
 =?utf-8?B?Nk9OSnlEWm1nZm51dHhyT0J4WlZDWklZQmRYRHZRckp5bUovRDBaNDN6QVhm?=
 =?utf-8?B?aVIrRDFqRUFjUW1QV2krK2xCQ0hYWHh2TmlOY0tUNkp6ejlVRVNHSDdjbml4?=
 =?utf-8?B?M3F1NEFSSEpQZ3ZOWUIxaWdDSzB6Uk1zSkdweFlhMDlTd0dpQ29yWERwZ0RN?=
 =?utf-8?B?VWRDS05QL2VqOHBINEdGc2wxcUFvN1NUY2QzdzdCRXI2NDFCcVB6bXJGNzJQ?=
 =?utf-8?B?c3FZU1BRaEVZV3lXbjk0d3hONXA3QzdsZThLY2JWNlYxakNSVitvcEw2V2ww?=
 =?utf-8?B?U2FVdnNIT2EwSHltREhTVW92U2NFQnA4dFJoaFZzVGkyQTloZy9LNlk5ajNV?=
 =?utf-8?B?VzhlZFdSMEVrcDhRZU1CenlmbTVtN3FZQTU0NWhrVUpsb0wybUJMTTFkemJJ?=
 =?utf-8?B?TjIvL1ZiR2s5SURVSjdjM0dvenl0V2R1NVhiV0pYR0RSWFlGcUJnUFRUcUF1?=
 =?utf-8?B?Y1pody95UmVvaUJXOE9MQzBRT1ZBbm1xOXgrN215RGR2eG8xRG9HK0Y1UE5x?=
 =?utf-8?B?S1cranFNTWtNdHR5cVVhaVdheEt2Q2pYOHlxWStDRW84c3hnOVBNSTBpT00v?=
 =?utf-8?B?ZlV1b0NJUk4yL3JpSUFSWTM4TEJ3NTM5clFxczk0NFlkaDdZcFJBZ3AvUHQr?=
 =?utf-8?B?YUFLbjMxc3I5Um55TnJlMnNsU0FxUHV6S2ltODJFc3hsUFNGMmRpT082enVM?=
 =?utf-8?B?K0VLZklZb2MrM3JDcUFVdnlMU3V4eE5TL1hlUUc2NVNUU1hleFgxMUJaSUp5?=
 =?utf-8?B?djhjQ1JmZ3hJS2lZK1l0NkZLVXFPT2IxTnkvd2cxZktkYjFNOHZjNk81bUpF?=
 =?utf-8?B?OHhFV3dBenFSc2c5NVJJS3h1TmgyYkRsSlo1NTcrVGZtaHlKekY3RnUvZmJu?=
 =?utf-8?B?RG9BV3liWENQRTRCOXlvUFFIaFUySE4wdnRyTy9YYU90eCt2MUN4TXNyRUp0?=
 =?utf-8?B?NjVNb3QvN2thUm9KUDBVaW50V3E5YTlDZDAwMmNtcGVxTzVndUs2MnVvRERu?=
 =?utf-8?B?NUlmcEF5TkhvVU81WFVBZG5CazBlTFhlTjM2aE10NW1HSWJMWG9wajh0VGJG?=
 =?utf-8?B?d0N6N0QzeEVmaUVBUGZZbWJkVHQ3R1hyc2JMd0p0OXpvMzVVa1N3Zzh3R3cv?=
 =?utf-8?B?SkdYNFpZdy81ZmE3MnZyZC9CL3JXa0pYYVQvd0lRTjZrazFzaU5DS3U1RXNK?=
 =?utf-8?B?dytxRXBYQzRRb3JLWkgyK1lET3JmS05SN1RkR3ZmUXQ4TEZ0TkxQNTlPSi9C?=
 =?utf-8?B?RnBoM2loK0RZamFqSUdBYWlhbGhkK3Fwa3RQM0xRZnI1djcwY2tJbk1VQVRY?=
 =?utf-8?Q?M2D4YMOb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08c97335-5e04-4ffa-6f57-08d8c3b0bccc
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3240.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2021 17:18:32.4668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eRKG9G21rgd0SJgPqDG9+Iugrs7KWyO0jyYdQpnnEe3qpXF6/AbO84DfSY8PAxd6UOvHZSHoXXFlZeUxevDXQQOzknNHjNo0ro1UncYUids=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4241
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9878 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101280083
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9878 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101280083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/28/2021 12:07 PM, Alex Williamson wrote:
> On Wed, 27 Jan 2021 17:03:25 -0700
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
>> On Wed, 27 Jan 2021 18:25:13 -0500
>> Steven Sistare <steven.sistare@oracle.com> wrote:
>>
>>> On 1/22/2021 5:59 PM, Alex Williamson wrote:  
>>>> On Tue, 19 Jan 2021 09:48:29 -0800
>>>> Steve Sistare <steven.sistare@oracle.com> wrote:
>>>>     
>>>>> Block translation of host virtual address while an iova range has an
>>>>> invalid vaddr.
>>>>>
>>>>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>>>>> ---
>>>>>  drivers/vfio/vfio_iommu_type1.c | 83 +++++++++++++++++++++++++++++++++++++----
>>>>>  1 file changed, 76 insertions(+), 7 deletions(-)
>>>>>
>>>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>>>> index 0167996..c97573a 100644
>>>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>>>> @@ -31,6 +31,7 @@
>>>>>  #include <linux/rbtree.h>
>>>>>  #include <linux/sched/signal.h>
>>>>>  #include <linux/sched/mm.h>
>>>>> +#include <linux/kthread.h>
>>>>>  #include <linux/slab.h>
>>>>>  #include <linux/uaccess.h>
>>>>>  #include <linux/vfio.h>
>>>>> @@ -75,6 +76,7 @@ struct vfio_iommu {
>>>>>  	bool			dirty_page_tracking;
>>>>>  	bool			pinned_page_dirty_scope;
>>>>>  	bool			controlled;
>>>>> +	wait_queue_head_t	vaddr_wait;
>>>>>  };
>>>>>  
>>>>>  struct vfio_domain {
>>>>> @@ -145,6 +147,8 @@ struct vfio_regions {
>>>>>  #define DIRTY_BITMAP_PAGES_MAX	 ((u64)INT_MAX)
>>>>>  #define DIRTY_BITMAP_SIZE_MAX	 DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
>>>>>  
>>>>> +#define WAITED 1
>>>>> +
>>>>>  static int put_pfn(unsigned long pfn, int prot);
>>>>>  
>>>>>  static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
>>>>> @@ -505,6 +509,52 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
>>>>>  }
>>>>>  
>>>>>  /*
>>>>> + * Wait for vaddr of *dma_p to become valid.  iommu lock is dropped if the task
>>>>> + * waits, but is re-locked on return.  If the task waits, then return an updated
>>>>> + * dma struct in *dma_p.  Return 0 on success with no waiting, 1 on success if    
>>>>
>>>> s/1/WAITED/    
>>>
>>> OK, but the WAITED state will not need to be returned in the new scheme below.
>>>   
>>>>> + * waited, and -errno on error.
>>>>> + */
>>>>> +static int vfio_vaddr_wait(struct vfio_iommu *iommu, struct vfio_dma **dma_p)
>>>>> +{
>>>>> +	struct vfio_dma *dma = *dma_p;
>>>>> +	unsigned long iova = dma->iova;
>>>>> +	size_t size = dma->size;
>>>>> +	int ret = 0;
>>>>> +	DEFINE_WAIT(wait);
>>>>> +
>>>>> +	while (!dma->vaddr_valid) {
>>>>> +		ret = WAITED;
>>>>> +		prepare_to_wait(&iommu->vaddr_wait, &wait, TASK_KILLABLE);
>>>>> +		mutex_unlock(&iommu->lock);
>>>>> +		schedule();
>>>>> +		mutex_lock(&iommu->lock);
>>>>> +		finish_wait(&iommu->vaddr_wait, &wait);
>>>>> +		if (kthread_should_stop() || !iommu->controlled ||
>>>>> +		    fatal_signal_pending(current)) {
>>>>> +			return -EFAULT;
>>>>> +		}
>>>>> +		*dma_p = dma = vfio_find_dma(iommu, iova, size);
>>>>> +		if (!dma)
>>>>> +			return -EINVAL;
>>>>> +	}
>>>>> +	return ret;
>>>>> +}
>>>>> +
>>>>> +/*
>>>>> + * Find dma struct and wait for its vaddr to be valid.  iommu lock is dropped
>>>>> + * if the task waits, but is re-locked on return.  Return result in *dma_p.
>>>>> + * Return 0 on success, 1 on success if waited,  and -errno on error.
>>>>> + */
>>>>> +static int vfio_find_vaddr(struct vfio_iommu *iommu, dma_addr_t start,
>>>>> +			   size_t size, struct vfio_dma **dma_p)    
>>>>
>>>> more of a vfio_find_dma_valid()    
>>>
>>> I will slightly modify and rename this with the new scheme I describe below.
>>>   
>>>>> +{
>>>>> +	*dma_p = vfio_find_dma(iommu, start, size);
>>>>> +	if (!*dma_p)
>>>>> +		return -EINVAL;
>>>>> +	return vfio_vaddr_wait(iommu, dma_p);
>>>>> +}
>>>>> +
>>>>> +/*
>>>>>   * Attempt to pin pages.  We really don't want to track all the pfns and
>>>>>   * the iommu can only map chunks of consecutive pfns anyway, so get the
>>>>>   * first page and all consecutive pages with the same locking.
>>>>> @@ -693,11 +743,11 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>>>>>  		struct vfio_pfn *vpfn;
>>>>>  
>>>>>  		iova = user_pfn[i] << PAGE_SHIFT;
>>>>> -		dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
>>>>> -		if (!dma) {
>>>>> -			ret = -EINVAL;
>>>>> +		ret = vfio_find_vaddr(iommu, iova, PAGE_SIZE, &dma);
>>>>> +		if (ret < 0)
>>>>>  			goto pin_unwind;
>>>>> -		}
>>>>> +		else if (ret == WAITED)
>>>>> +			do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu);    
>>>>
>>>> We're iterating through an array of pfns to provide translations, once
>>>> we've released the lock it's not just the current one that could be
>>>> invalid.  I'm afraid we need to unwind and try again, but I think it's
>>>> actually worse than that because if we've marked pages within a
>>>> vfio_dma's pfn_list as pinned, then during the locking gap it gets
>>>> unmapped, the unmap path will call the unmap notifier chain to release
>>>> the page that the vendor driver doesn't have yet.  Yikes!    
>>>
>>> Yikes indeed.  The fix is easy, though.  I will maintain a count in vfio_iommu of 
>>> vfio_dma objects with invalid vaddr's, modified and tested while holding the lock, 
>>> provide a function to wait for the count to become 0, and call that function at the 
>>> start of vfio_iommu_type1_pin_pages and vfio_iommu_replay.  I will use iommu->vaddr_wait 
>>> for wait and wake.  
>>
>> I prefer the overhead of this, but the resulting behavior seems pretty
>> non-intuitive.  Any invalidated vaddr blocks all vaddr use cases, which
>> almost suggests the unmap _VADDR flag should only be allowed with the
>> _ALL flag, but then the map _VADDR flag can only be per mapping, which
>> would make accounting and recovering from _VADDR + _ALL pretty
>> complicated.  Thanks,
> 
> I wonder if there's a hybrid approach, a counter on the vfio_iommu
> which when non-zero causes pin pages to pre-test vaddr on all required
> vfio_dma objects, waiting and being woken on counter decrement to check
> again.  Thanks,

Sounds good, thanks.

- Steve

>>>>>  		if ((dma->prot & prot) != prot) {
>>>>>  			ret = -EPERM;
>>>>> @@ -1496,6 +1546,22 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
>>>>>  	unsigned long limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
>>>>>  	int ret;
>>>>>  
>>>>> +	/*
>>>>> +	 * Wait for all vaddr to be valid so they can be used in the main loop.
>>>>> +	 * If we do wait, the lock was dropped and re-taken, so start over to
>>>>> +	 * ensure the dma list is consistent.
>>>>> +	 */
>>>>> +again:
>>>>> +	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
>>>>> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
>>>>> +
>>>>> +		ret = vfio_vaddr_wait(iommu, &dma);
>>>>> +		if (ret < 0)
>>>>> +			return ret;
>>>>> +		else if (ret == WAITED)
>>>>> +			goto again;
>>>>> +	}    
>>>>
>>>> This "do nothing until all the vaddrs are valid" approach could work
>>>> above too, but gosh is that a lot of cache unfriendly work for a rare
>>>> invalidation.  Thanks,    
>>>
>>> The new wait function described above is fast in the common case, just a check that
>>> the invalid vaddr count is 0.
>>>
>>> - Steve
>>>   
>>>>> +
>>>>>  	/* Arbitrarily pick the first domain in the list for lookups */
>>>>>  	if (!list_empty(&iommu->domain_list))
>>>>>  		d = list_first_entry(&iommu->domain_list,
>>>>> @@ -2522,6 +2588,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
>>>>>  	iommu->controlled = true;
>>>>>  	mutex_init(&iommu->lock);
>>>>>  	BLOCKING_INIT_NOTIFIER_HEAD(&iommu->notifier);
>>>>> +	init_waitqueue_head(&iommu->vaddr_wait);
>>>>>  
>>>>>  	return iommu;
>>>>>  }
>>>>> @@ -2972,12 +3039,13 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
>>>>>  	struct vfio_dma *dma;
>>>>>  	bool kthread = current->mm == NULL;
>>>>>  	size_t offset;
>>>>> +	int ret;
>>>>>  
>>>>>  	*copied = 0;
>>>>>  
>>>>> -	dma = vfio_find_dma(iommu, user_iova, 1);
>>>>> -	if (!dma)
>>>>> -		return -EINVAL;
>>>>> +	ret = vfio_find_vaddr(iommu, user_iova, 1, &dma);
>>>>> +	if (ret < 0)
>>>>> +		return ret;
>>>>>  
>>>>>  	if ((write && !(dma->prot & IOMMU_WRITE)) ||
>>>>>  			!(dma->prot & IOMMU_READ))
>>>>> @@ -3055,6 +3123,7 @@ static void vfio_iommu_type1_notify(void *iommu_data, unsigned int event,
>>>>>  	mutex_lock(&iommu->lock);
>>>>>  	iommu->controlled = false;
>>>>>  	mutex_unlock(&iommu->lock);
>>>>> +	wake_up_all(&iommu->vaddr_wait);
>>>>>  }
>>>>>  
>>>>>  static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {    
>>>>     
>>>   
>>
> 
