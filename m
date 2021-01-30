Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 217C73096E4
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 17:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbhA3QwG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 11:52:06 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37312 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhA3QwG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Jan 2021 11:52:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10UGj1L9163934;
        Sat, 30 Jan 2021 16:51:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=/4PaYMHhQqRylFnVX6/6bxwdw5ozE+icOu1VGrwfHaM=;
 b=DI2UCaFgphmRcUvzo7mNp1qwx+Csl7+VlGQnMvC6g9/sk6yQwPgQKVZknpYT39tNhlWX
 cZiLCh3tfC5voDAUM4mcO/+uJLOXVw3gABHfsI/LbOZ5OnKjKhQxNK126vbSsFu8gV8G
 TY0ZgsEXBtwGkLiK6l+uC4ijP0f/oHjzsolyTXksN40NuoaaJKI6V/ujpWkNuAF6Bgk+
 P6dUNYm3jMrDu2HIsb0l9iCmE2ZbJCkAEFfG2zHgA+JSkXLsktD6qL+5IqsoPFshv901
 WfqZq1jd4cAJkEudjaTCluJBmxXXYDldJuf5Pr2/M0UUcaLcwhIYFnaKP8FbaYpsSmfj Eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36cydkgxsd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 30 Jan 2021 16:51:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10UGikSU151545;
        Sat, 30 Jan 2021 16:51:19 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by aserp3020.oracle.com with ESMTP id 36cy8yyjxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 30 Jan 2021 16:51:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l0iOqus2brm2iX8g1pCCfsfhd9xPCDcYvHrR3v9Yk8KoficiKjanLj3NtfvBv9eElMxtxO7J3GjeWDcdTPt220H5rOujYrwvfUQhjCDR4HrlU9ik0PkI9HmDascMVob8bb1HmKLlm5TISYPWM9IVE8Bj0V1fRWujdxbNyt2I3SPECi8Bm3A05BAC2nUu8hH0SrSuUIsnpJ5Zgb5zaLsaJ/4ycgxloONh4Yv+91ZECnYddgCiq7csqeXrJC6WjiTWKyjpBEyUHYFl1PrSDGCdgbBzrQZIz9UZJ2hm+3cyLh4ASCgX+JSwiT00jPPIqIBqQEI2xdOyEolYPiRkQ8735w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/4PaYMHhQqRylFnVX6/6bxwdw5ozE+icOu1VGrwfHaM=;
 b=Dh0OEAzN5jwOnOuorVr8P0nKN+q6UPjinijrxQsY/C4D15hdq06TR/a08GklGR4ux+RWhjl1/w0PVZmWZc0ihFU4wURtAwxpWwn/hHktjlXIy0A7QHAPqF1LHXpW7/AaVHCnqSIarqntNCYPv5EpUF8YL7M/9uex253QBiOUOvp1Fg+k1m+2qQ69OZslTJ997bHsy1JmXujhAel4/z8Tlqmr1T7mI8+Qny3WDbhrR6AHClO+DHZh6QyygsEaG+q8knh0VvQuadslS7Fy3WmVtslCDommrEyJM6frZ+NBDq1uG/p6W6yz9/AN9x7Kta3Dqx/igQm79B/jfL2QGvhpKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/4PaYMHhQqRylFnVX6/6bxwdw5ozE+icOu1VGrwfHaM=;
 b=metbEbusAo5IjCtseb2wNyzWCkxAi2rPz+S0VHeUYAjlt2MJA0NZA7Joi2GvJ7vyJko6TC/9uXE0LM7qhhffm280k9W0xz9TvDjac7yFvRRg8Or5rb5eU8OuhiPeLdKMEeoOk/3OmicGY4WuoEuent1K0ffqBgf1oB+7gOEnod4=
Received: from BYAPR10MB3240.namprd10.prod.outlook.com (2603:10b6:a03:155::17)
 by BY5PR10MB4340.namprd10.prod.outlook.com (2603:10b6:a03:210::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.23; Sat, 30 Jan
 2021 16:51:16 +0000
Received: from BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::9123:2652:e975:aa26]) by BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::9123:2652:e975:aa26%5]) with mapi id 15.20.3805.022; Sat, 30 Jan 2021
 16:51:15 +0000
Subject: Re: [PATCH V3 5/9] vfio/type1: massage unmap iteration
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
References: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
 <1611939252-7240-6-git-send-email-steven.sistare@oracle.com>
 <20210129145612.0b507334@omen.home.shazbot.org>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
Message-ID: <7dc220a7-6854-bcc0-f224-a17260450ac6@oracle.com>
Date:   Sat, 30 Jan 2021 11:51:10 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210129145612.0b507334@omen.home.shazbot.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [24.62.106.7]
X-ClientProxiedBy: BYAPR07CA0040.namprd07.prod.outlook.com
 (2603:10b6:a03:60::17) To BYAPR10MB3240.namprd10.prod.outlook.com
 (2603:10b6:a03:155::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.92] (24.62.106.7) by BYAPR07CA0040.namprd07.prod.outlook.com (2603:10b6:a03:60::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Sat, 30 Jan 2021 16:51:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9da962e-5f84-40b9-e066-08d8c53f4229
X-MS-TrafficTypeDiagnostic: BY5PR10MB4340:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB43409BA0A74049DFB3800B33F9B89@BY5PR10MB4340.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +tDTiOC+n2TmXFHtQu8b43xTPdYVcjg6+rLHepL/pQ9mj5elb+SwEwi2emZM2EtF5O5U6SXcGMzB6aQWSWElDkET8DJyrKGCwyjyYk+UmI1+YcO4ssDp7cVF/1li/PLfl1yUR8BUHhlh1Mvu3iYsfdv052sLYVppjqohdDlAS6Guu88rbSjnl+lGxRa+curWvcfR9iGhlpxod0+TpmiZIqXKKqB4//gUv3cgZ7ajfaFbzu4vq/lv/n6ln51rtGAAKQbLxpwx2vtXcRNa8+M3JhFmChjumIBGUEAqhlKbuZP0yH2/JmTwPdekBxryUfjeUOvjvEzGCtFGrCo1fmSGm9uNm8usgHrAd06xsH3kxEAFMciP1L61buT+tmCmTfsXqkIMighm+b/UUpgu4mBcfxhAzCc3bJEL407CJxcAiIaKHIJcUmAmDiVPiFo7ZkTpyjSDPwb5CMHmkp+jRkYpE+gmPPgd72ZXS9Ec3skrFNd8m6vWV9s70m6Q3M+icZZBn0ajF1KelznAUMGsEDsW+oy+WH8VPZUbWE0Ix+ilghxx5EYkrHXRZQmI4i8WCesDZi//h1iUuiOUmkHCBdVN9d8WgfB2aoxj/VJ/EYrwzQg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3240.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(366004)(346002)(136003)(54906003)(8676002)(2616005)(31696002)(44832011)(8936002)(16576012)(316002)(2906002)(956004)(86362001)(4326008)(6916009)(6666004)(83380400001)(36756003)(6486002)(36916002)(31686004)(66946007)(186003)(26005)(5660300002)(66556008)(66476007)(53546011)(16526019)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cTF0cnBDTTRIN3lkOG5ucjBpUlRMTDltTzFrRG5za3NXaU1IL0xHMnNiTDJ3?=
 =?utf-8?B?OVdUVnJXYVJ0WnBLcFJqWXdmdW5IUm9RVU9IbUNQWThQa3V4b05QSmpjT0tj?=
 =?utf-8?B?b29CTi84ZWpOY2MyVWNJN01WNmRaeHhPVk9mSk5RZWNnYnE2WVkvbnZzd2FI?=
 =?utf-8?B?WmFId3dZVStjdmVjVlp6c29CREY5Zks0eDE0dnZxSGtGT3FpUjdHY01yb09j?=
 =?utf-8?B?MlhYZ1I1cDhuSmVVcXhpQUpWVGIzakhwTE5nckdUMHhwOWRwSElsNnBCWFZo?=
 =?utf-8?B?eXdpemlhbUh1VTRkOVkrWDdNUjk3VnNkYWJPUkpFNlRaL2dIOHkyLzcvZWI5?=
 =?utf-8?B?eWtVRTQzcjJVK2xOalQrZU5WVDNMQVJEWFBTcys1Qlc3d0JYTG1PbGJNSkRP?=
 =?utf-8?B?ZXU1bE9ORlhhU1p4Z0xZMlU1K3J1aFJNSWtoNGlTNE1kOEd6T0tzYm1yUEJP?=
 =?utf-8?B?d0tobUF6V2wxRE8rYVlJbCtxM0ZQY256YVpxU3VWV3FxSDRoQ2Evc3lkdFZw?=
 =?utf-8?B?QWREWUVCSlhaZVR3N1BoYU5jMnRVNVl2THB2WTNpVmgwNkRNRUNmRi9BL0Vo?=
 =?utf-8?B?TG1WU3ZWWW1Hd2E5NGFYVERmWE9NdUsvNnBranBmMzVaV3R2eWtOdFlOYy9M?=
 =?utf-8?B?LzR0ei9LSkEvQWdRRUtMMW4vcThvOHk4UW5xZTZiMGVXQUV3aUc3bHdGYXdl?=
 =?utf-8?B?RGJacmVhekpRQmpkVWxRd0JCWHdIUDlCc2Q4N1RmTWNmVG9RQVJMM3RiaTVl?=
 =?utf-8?B?TUN5dWREM0I1T1owNjFscGlrVnhvVFVEZ0gwWTVSTjJEZVJDa3hBT0Y2M3lF?=
 =?utf-8?B?SS9iejYrRkp3NGFER3R0RWk3V3VlUTBFYWZFbG1ic1NRbXVlQkkwN1g5OE1o?=
 =?utf-8?B?end0VDdGTUNxalI3T2lneGE5MGliSkJHMmZkZVpkZ3cwLzNWTHFpbXRQZ0sw?=
 =?utf-8?B?UFZwQmR1bmFJV0VlSkt6bURNZGsvQnJDL1BwYVZ1SUN5NFR3UDlVeWlQRkhK?=
 =?utf-8?B?OVVwdUZVK3pTOEJpd05Pa25NUjBUd2pDZFdFcTFEOW1jSHROTDFzaSt4TTI4?=
 =?utf-8?B?RHdOMndrYytTQ2dEdW95TkJCdS9Zd25xaXM3NFRxTGh4NWhxRmorSXRMcU9B?=
 =?utf-8?B?eStGQzZCaU1hUGV4blJDNExiQ1lMcjBiVTFnMmg4STN2MDNvQmJWQlcrd2xq?=
 =?utf-8?B?WDdOUTVjT1NxTlFrUGRIT2lYN05pM1RQcTV5N2JRbnFOeDBIZ1I0U29OVlU5?=
 =?utf-8?B?eGlSWS9tUlR6QVpjL1JqWTZlNW13RjdwdnpkdVJhQys5RUFlcExrMjk0TDJZ?=
 =?utf-8?B?bzZpTEVwQU80SXVSTXQyOHNvVmwyWlQ1SGNiZWc0S2U5c0k3bzQzdHUrSjBI?=
 =?utf-8?B?aEUvOGt5djhsMzVweGpLTW5WVjRGR1l2aEdsWnYxZDNwVlNZTHhVTEVGUFFv?=
 =?utf-8?Q?MvCi5jsi?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9da962e-5f84-40b9-e066-08d8c53f4229
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3240.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2021 16:51:15.7836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WDQaPH2pXrrT2pFbuWbHY44MQcrmLVEXWUv21MDPKOqIfpwDHTU6/koM6ITROu1bqGCwc8tkErb/FtkK4+mTNCvlEZz+m55gJNnldRtaJuA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4340
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9880 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 suspectscore=0 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101300091
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9880 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101300091
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/29/2021 4:56 PM, Alex Williamson wrote:
> On Fri, 29 Jan 2021 08:54:08 -0800
> Steve Sistare <steven.sistare@oracle.com> wrote:
> 
>> Modify the iteration in vfio_dma_do_unmap so it does not depend on deletion
>> of each dma entry.  Add a variant of vfio_find_dma that returns the entry
>> with the lowest iova in the search range to initialize the iteration.  No
>> externally visible change, but this behavior is needed in the subsequent
>> update-vaddr patch.
>>
>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 35 ++++++++++++++++++++++++++++++++++-
>>  1 file changed, 34 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 407f0f7..5823607 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -173,6 +173,31 @@ static struct vfio_dma *vfio_find_dma(struct vfio_iommu *iommu,
>>  	return NULL;
>>  }
>>  
>> +static struct rb_node *vfio_find_dma_first(struct vfio_iommu *iommu,
>> +					    dma_addr_t start, size_t size)
> 
> Nit, we return an rb_node rather than a vfio_dma now, but the naming is
> still pretty similar to vfio_find_dma().  Can I change it to
> vfio_find_dma_first_node() (yes, getting wordy)?  Thanks,

Sure - steve

>> +{
>> +	struct rb_node *res = NULL;
>> +	struct rb_node *node = iommu->dma_list.rb_node;
>> +	struct vfio_dma *dma_res = NULL;
>> +
>> +	while (node) {
>> +		struct vfio_dma *dma = rb_entry(node, struct vfio_dma, node);
>> +
>> +		if (start < dma->iova + dma->size) {
>> +			res = node;
>> +			dma_res = dma;
>> +			if (start >= dma->iova)
>> +				break;
>> +			node = node->rb_left;
>> +		} else {
>> +			node = node->rb_right;
>> +		}
>> +	}
>> +	if (res && size && dma_res->iova >= start + size)
>> +		res = NULL;
>> +	return res;
>> +}
>> +
>>  static void vfio_link_dma(struct vfio_iommu *iommu, struct vfio_dma *new)
>>  {
>>  	struct rb_node **link = &iommu->dma_list.rb_node, *parent = NULL;
>> @@ -1078,6 +1103,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>  	dma_addr_t iova = unmap->iova;
>>  	unsigned long size = unmap->size;
>>  	bool unmap_all = !!(unmap->flags & VFIO_DMA_UNMAP_FLAG_ALL);
>> +	struct rb_node *n;
>>  
>>  	mutex_lock(&iommu->lock);
>>  
>> @@ -1148,7 +1174,13 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>  	}
>>  
>>  	ret = 0;
>> -	while ((dma = vfio_find_dma(iommu, iova, size))) {
>> +	n = vfio_find_dma_first(iommu, iova, size);
>> +
>> +	while (n) {
>> +		dma = rb_entry(n, struct vfio_dma, node);
>> +		if (dma->iova >= iova + size)
>> +			break;
>> +
>>  		if (!iommu->v2 && iova > dma->iova)
>>  			break;
>>  		/*
>> @@ -1193,6 +1225,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>  		}
>>  
>>  		unmapped += dma->size;
>> +		n = rb_next(n);
>>  		vfio_remove_dma(iommu, dma);
>>  	}
>>  
> 
