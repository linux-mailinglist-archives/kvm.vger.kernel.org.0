Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65293067DD
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 00:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234593AbhA0X0h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 18:26:37 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49284 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235287AbhA0XYd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jan 2021 18:24:33 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10RNDujX189741;
        Wed, 27 Jan 2021 23:23:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=KM1sgCoPaU+dbc8qGOjds5vZrNcLHTqOVY3Ybipgmow=;
 b=QCvcS3cNEZCuaQEIThRNl5G8tKXENp4LdCCAg+ubf/4dnh/IfLwh3EQNHZmwjb4kv3Wi
 5vXOT82UERb2LXqhcGaDllEiIBBCUFj+Gqd3Ro3fh/DBx8QQ9yWbHEgfQdmKKEK81yZd
 lI8XuLhwKyGcsY8XC758+/MQ7n4g2rD6SosTdDy+jhH+3YvC8BVOdy5YJdtROrGuA1eB
 juQ1oZizGzgy3vnprWXU/cWGvZuGuoFFMIJtbbm/4lz37DDWw1N2dm1TwHabXyM1b6lM
 +YD/vty3OohVsYuF5AEGdyCneT0dLJqzQ4SJrWeVy5g+8WhX/G1DcKJstnt01tmMRtrP cQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 368b7r1p93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 23:23:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10RNFlkk175576;
        Wed, 27 Jan 2021 23:23:43 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by userp3020.oracle.com with ESMTP id 368wjt6sy0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 23:23:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LzNJPMhO59f/Z+/aEVLVe2y5WPekEGLYkQdLgIybirqiiNSaSMQU2fx8uQ9++Fsp7Zfi2xtPrzV7TPosYImoBZnYWwdbVBXiXxeFVytyl2MqEfiw68H+pTfnQv1Ux8/hhBU3qvoDPDhOAEgvHlSUaygGsvzGdddCuVbrEEV7cJ2MF405yy1FJ6+45MP+vetOhTzoeiZkn5sNkCylJnVqWDpw7fslUZUP2Ge2fqGNUIFGvm7RaIgwcS2/vujEZlPpkNI9ClTlZKgtqGOfN6xijzH5hetpL20a+8OcfjQhy3YhVVzIlZCzSIcQ8kkan0Xt5w5OPn/p9Xu+XF2usVc2IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KM1sgCoPaU+dbc8qGOjds5vZrNcLHTqOVY3Ybipgmow=;
 b=KEtq+/GDX/dbubH46Oo7E0bd78NSc0lEsH3S2r76AL342XmOvEZFOYt8DMjCWmZRbSG+TVH/NMKD7nF4VHcqA+2ZQUA508f7g5RDNrlcGRzqaox0+VB/KZqvAozB//Cb3tNgZKrMNpXDRXVSum8x4C13vkUixjfiwy/z+z13Ads3RBkTR7LNHgKHlhVV5Ly8KDsvis+kARmwCZvBLAO/xK0qH9o7TieWw+soXRBfQhLyTZ1ucR3nAE2LkN1AwHERfG03ATEaOnbU5nWhyTuXq5IAivtp9kA189MgplSnXcImvYoaFDE6S62RZ1vruaRCmW1ZuJozs7uU075ovy8bHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KM1sgCoPaU+dbc8qGOjds5vZrNcLHTqOVY3Ybipgmow=;
 b=IqF6MGow2RCh8linY4pcp7llYVdglD9nxnPnFKByoSatDMr+nwou7JaI/Cifr8buUEJrn/uediqHhI4qRN2SjRX7lGs5XXiVB+srRsPxGnmTyKH7ydR02XcXZs2TePPpDvM/VXejOuqkL5RfCwuuMz++shUYvB5xGd5aEkkRxSY=
Received: from BYAPR10MB3240.namprd10.prod.outlook.com (2603:10b6:a03:155::17)
 by BYAPR10MB3655.namprd10.prod.outlook.com (2603:10b6:a03:127::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.16; Wed, 27 Jan
 2021 23:23:40 +0000
Received: from BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::9123:2652:e975:aa26]) by BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::9123:2652:e975:aa26%5]) with mapi id 15.20.3805.017; Wed, 27 Jan 2021
 23:23:40 +0000
Subject: Re: [PATCH V2 6/9] vfio/type1: implement interfaces to update vaddr
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
References: <1611078509-181959-1-git-send-email-steven.sistare@oracle.com>
 <1611078509-181959-7-git-send-email-steven.sistare@oracle.com>
 <20210122144851.4d930db3@omen.home.shazbot.org>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
Message-ID: <ac7c05de-02b6-199e-2138-6e623f9b4f4e@oracle.com>
Date:   Wed, 27 Jan 2021 18:23:37 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210122144851.4d930db3@omen.home.shazbot.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [24.62.106.7]
X-ClientProxiedBy: BYAPR05CA0093.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::34) To BYAPR10MB3240.namprd10.prod.outlook.com
 (2603:10b6:a03:155::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.92] (24.62.106.7) by BYAPR05CA0093.namprd05.prod.outlook.com (2603:10b6:a03:e0::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.8 via Frontend Transport; Wed, 27 Jan 2021 23:23:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7527c5c1-9753-47ec-1708-08d8c31a9462
X-MS-TrafficTypeDiagnostic: BYAPR10MB3655:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3655CE7C3935955E89F432E3F9BB9@BYAPR10MB3655.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xQhTe1r8RlhQtHFFHOTw4rsAI3Y2LUbJNLqPO/ap/HJ0wmxl1iThsEb48+1cPNrx6MKidBy5YSTIRVUSl4+MzTVspCdxZSXxpxxpZTsdLVVrikMjtm0EjCDbh7XTcHBfgYITrcWTlEm/mJunobDOFFA8rMhL5+z7wa+hJs3fwkh/GVfvUL2Plsls9b4IAHB4d3gzxCwBBFvnaZk22dllWg4Fv8nqGMs69+24pqEwsqz7JmlnpwFqCPLO/5sp0TbTFEHdqwfyLOqkvaly/jxOvZ0jWBBtiWKY2WBVx9KMvWKrO7O1QcBy+0cMFuHXBiEGw3LzwzOSiP6SU+EWwblbAiwMpUGyPS3vHmJEU7C0+XA0cdajxPsU3/AuPNwhQ53r/8QMHvG3U3W97UOk544dSbHXndtDo+NrwGkd18BCmuGG2M4rac5FplHkv8eVeWSWbRHuyH2gjc/i5XoGCP8eMuQAhjmkYOsCNuhab5F7D9Q9AAQsjADi8BscV3slr1Cnlz4H/EKViD7Islodb/9G2J6Qxn7t3r6Ii1DGxid8/UVUy+0T6jzW3z8AJwo0rlfarkMr1eL0SyYp1UIRvqlaPuwdZbWxii/g5LMTSTzl7cM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3240.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(136003)(396003)(366004)(346002)(186003)(36916002)(54906003)(478600001)(16526019)(31696002)(26005)(44832011)(4326008)(31686004)(8676002)(956004)(6486002)(86362001)(83380400001)(66476007)(66556008)(316002)(6916009)(53546011)(66946007)(16576012)(2906002)(8936002)(2616005)(5660300002)(36756003)(15650500001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MURHVmljRG5QQTNUNTcxNnd2Tm4yZDlTQ3dvbE0wQWxROXZjejM0Z0ZkSmMv?=
 =?utf-8?B?Zzdxa1I2OWRtT3R3WmgwRGhrbUtaeXN3OEY3bXlxY3IvUkdRd25SalFPZm5s?=
 =?utf-8?B?MzUreHRya0ZPWnNMRUNVMkpCdjhVLzg5R2ppYmk5Tjc0dkdjUjRKbVY2YWpL?=
 =?utf-8?B?NzEvTkhJbWVJRW92dzNVR0RaMVc3MEcxb01iZ2pQR1BOTXhFeUI3OTNYZXow?=
 =?utf-8?B?RUw0dDk3WURQaE9lWmRuY0hPVXB0dHMyQVZPWWNjMVVYdDAxSmxvMGpLNUhx?=
 =?utf-8?B?OGkzSEhvdld1T1dPSUlGMUYrWHZPTFF0NWVqeWoyUXVjZFVhYlJDRWxVbldB?=
 =?utf-8?B?d1BTVDg0YjNaZjVhWHRZZWRJUThSK0FyTlV2UVllcUpLajdCZTF5ajQwc2VG?=
 =?utf-8?B?VklQeDYwcHBMQTFPWHNNcDFuV3J1eVUwVVdKUCs0TWUxazR2L1Fmdy9OTlZO?=
 =?utf-8?B?b2hOa1NTUkJPWGx6aERHNS8xQUphSFhnMVh3UXNjcDRpOHFGY2xLNFd3cjNs?=
 =?utf-8?B?SFlsZy9qeGxJQ2MrMEFvR2N1QjdxVE5PT1c2V1NNU1c2OUJ0VEhGMEJzR0xx?=
 =?utf-8?B?dU5sTHZrekw2NGQzZlhuUlQxN1NGSmQ1VForTStMRXVvSTN0dWtKZ1NVczBG?=
 =?utf-8?B?ZFZpS1BuYklqTmttcVpOVjNrb3haOTMwazFMM2V5Q3hMNjF5QnhZTWdDRWw0?=
 =?utf-8?B?bkpRRi9peXRyL2NwWU8rWXlvb2hqanROSmZWNGs1M2taV2hkTjE1V2xTUndC?=
 =?utf-8?B?SFIyeW9aVjZEUDZPVlZ5QVBMeTlwS1pLNjhCVzBhMnRad1FUZjNDRHk0aEdI?=
 =?utf-8?B?N29rT1FRS3d5YUg3cmlYZzZvSWFTTHd3WGRUOWpVUzJmNHdabzVieHZlK2I0?=
 =?utf-8?B?aU1ock9YTjRqYTc4eklYcVBLNnNkZjVEZDZ1Z0VkNnI3RzVIMGx6MDA0eU1x?=
 =?utf-8?B?OG1hb0o2VnpSOHZsUU9EdXlNWk93YUlFZTRORldKQ2tJU1dhQkFDUlU3Ym0x?=
 =?utf-8?B?N2o2TVhxWXpUS2RqK0JjQ0tNZ0RxeksybjFWSHNDank3YzdBR21pVXVySlJY?=
 =?utf-8?B?TS84K0pLeW9sQStZRDdNdUgxL05KLzkxcGQxVGlRSnhLbUI1bXhpOVhSRURZ?=
 =?utf-8?B?UGNPZzJ2a1Rpczl6NWk4cnNQdldmT2RQM29GQ3lUeEVxNGN5WEcyeXNkaXNP?=
 =?utf-8?B?UEVma2RWVUpuczd1clBsZ3VqWTlXYzdrOFBYblhtRXVoSWpNanFZLzBRUjVv?=
 =?utf-8?B?WXZGRElHZDNYU0Jpcnhrc2FLOTh2dzg3a0lNeExKSU5wTXhFaVpiVWorbXZP?=
 =?utf-8?B?MnRwRWFnbXAxa0hwS2o3dGl6OWcvbHlQaUJDVklmZDZkWGRpQTRRbVhjOEkw?=
 =?utf-8?B?Tm8yYkxmM0tzT0svRS9VTjBUTG9XNkM3Zmhkemc4OEZwdDJhMmxjSlVuUzRS?=
 =?utf-8?Q?ZPG90ZAO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7527c5c1-9753-47ec-1708-08d8c31a9462
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3240.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 23:23:40.0506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I11wfQIWbq/kv1RlWd2nSO38fE35lcILnLCR61NbJAVLQbEg3ckvCZqTOKNsCikMuihNfY/1Gtmod8UZzfy/d2oOlJnPMX6Bcwl3pttA9mo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3655
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101270116
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270116
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/22/2021 4:48 PM, Alex Williamson wrote:
> On Tue, 19 Jan 2021 09:48:26 -0800
> Steve Sistare <steven.sistare@oracle.com> wrote:
> 
>> Implement VFIO_DMA_UNMAP_FLAG_VADDR, VFIO_DMA_MAP_FLAG_VADDR, and
>> VFIO_UPDATE_VADDR.  This is a partial implementation.  Blocking is
>> added in the next patch.
>>
>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 54 ++++++++++++++++++++++++++++++++++++++---
>>  1 file changed, 51 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index ef83018..c307f62 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -92,6 +92,7 @@ struct vfio_dma {
>>  	int			prot;		/* IOMMU_READ/WRITE */
>>  	bool			iommu_mapped;
>>  	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
>> +	bool			vaddr_valid;
>>  	struct task_struct	*task;
>>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>>  	unsigned long		*bitmap;
>> @@ -1101,6 +1102,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>  	dma_addr_t iova = unmap->iova;
>>  	unsigned long size = unmap->size;
>>  	bool unmap_all = !!(unmap->flags & VFIO_DMA_UNMAP_FLAG_ALL);
>> +	bool invalidate = !!(unmap->flags & VFIO_DMA_UNMAP_FLAG_VADDR);
>>  
>>  	mutex_lock(&iommu->lock);
>>  
>> @@ -1181,6 +1183,18 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>  		if (dma->task->mm != current->mm)
>>  			break;
>>  
>> +		if (invalidate) {
>> +			if (!dma->vaddr_valid)
>> +				goto unwind;
>> +			dma->vaddr_valid = false;
>> +			unmapped += dma->size;
>> +			size -= dma->iova + dma->size - iova;
>> +			iova = dma->iova + dma->size;
>> +			if (iova == 0)
>> +				break;
>> +			continue;
>> +		}
> 
> Clearly this is where the change to find-first semantics should have
> been introduced, the previous patch didn't require it.  Would it really
> be that unsightly to do:
> 
> while (1) {
> 	if (unlikely(invalidate))
> 		dma = vfio_find_dma_first(...
> 	else
> 		dma = vfio_find_dma(...
> 
> 	if (!dma)
> 		break;
> 
> Find-first followed by a tree walk might be more efficient, but of
> course requires a full loop redesign.

OK, I'll bite.  How about:

n = vfio_find_dma_first(iommu, iova, size);
while (n) {
        dma = rb_entry(n, struct vfio_dma, node);
        ...
        n = rb_next(n);
        vfio_remove_dma(iommu, dma);
}

plus similar changes in unwind.  This costs logN + N, eg O(N). 

For unmap-all, I could do find-any in constant time instead of logN and suppress the rb_next, 
but the code would be messier and the overall cost would still be O(N), so it does not seem worth it.

>> +
>>  		if (!RB_EMPTY_ROOT(&dma->pfn_list)) {
>>  			struct vfio_iommu_type1_dma_unmap nb_unmap;
>>  
>> @@ -1218,6 +1232,20 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>  		unmapped += dma->size;
>>  		vfio_remove_dma(iommu, dma);
>>  	}
>> +	goto unlock;
>> +
>> +unwind:
>> +	iova = unmap->iova;
>> +	size = unmap_all ? SIZE_MAX : unmap->size;
>> +	dma_last = dma;
>> +	while ((dma = vfio_find_dma_first(iommu, iova, size)) &&
>> +	       dma != dma_last) {
>> +		dma->vaddr_valid = true;
>> +		size -= dma->iova + dma->size - iova;
>> +		iova = dma->iova + dma->size;
>> +	}
>> +	ret = -EINVAL;
>> +	unmapped = 0;
>>  
>>  unlock:
>>  	mutex_unlock(&iommu->lock);
>> @@ -1319,6 +1347,7 @@ static bool vfio_iommu_iova_dma_valid(struct vfio_iommu *iommu,
>>  static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>  			   struct vfio_iommu_type1_dma_map *map)
>>  {
>> +	bool update = map->flags & VFIO_DMA_MAP_FLAG_VADDR;
> 
> Please pick a slightly more specific variable name, update_vaddr maybe.
> Perhaps even clear_vaddr rather than invalidate above for consistency.

OK.

>>  	dma_addr_t iova = map->iova;
>>  	unsigned long vaddr = map->vaddr;
>>  	size_t size = map->size;
>> @@ -1336,13 +1365,16 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>  	if (map->flags & VFIO_DMA_MAP_FLAG_READ)
>>  		prot |= IOMMU_READ;
>>  
>> +	if ((prot && update) || (!prot && !update))
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
>> @@ -1353,7 +1385,19 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>  		goto out_unlock;
>>  	}
>>  
>> -	if (vfio_find_dma(iommu, iova, size)) {
>> +	dma = vfio_find_dma(iommu, iova, size);
>> +	if (update) {
>> +		if (!dma) {
>> +			ret = -ENOENT;
>> +		} else if (dma->vaddr_valid || dma->iova != iova ||
>> +			   dma->size != size) {
>> +			ret = -EINVAL;
>> +		} else {
>> +			dma->vaddr = vaddr;
>> +			dma->vaddr_valid = true;
>> +		}
>> +		goto out_unlock;
>> +	} else if (dma) {
>>  		ret = -EEXIST;
>>  		goto out_unlock;
>>  	}
>> @@ -1377,6 +1421,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>  	iommu->dma_avail--;
>>  	dma->iova = iova;
>>  	dma->vaddr = vaddr;
>> +	dma->vaddr_valid = true;
>>  	dma->prot = prot;
>>  
>>  	/*
>> @@ -2545,6 +2590,7 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
>>  	case VFIO_TYPE1v2_IOMMU:
>>  	case VFIO_TYPE1_NESTING_IOMMU:
>>  	case VFIO_UNMAP_ALL:
>> +	case VFIO_UPDATE_VADDR:
>>  		return 1;
>>  	case VFIO_DMA_CC_IOMMU:
>>  		if (!iommu)
>> @@ -2699,7 +2745,8 @@ static int vfio_iommu_type1_map_dma(struct vfio_iommu *iommu,
>>  {
>>  	struct vfio_iommu_type1_dma_map map;
>>  	unsigned long minsz;
>> -	uint32_t mask = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE;
>> +	uint32_t mask = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE |
>> +			VFIO_DMA_MAP_FLAG_VADDR;
>>  
>>  	minsz = offsetofend(struct vfio_iommu_type1_dma_map, size);
>>  
>> @@ -2718,6 +2765,7 @@ static int vfio_iommu_type1_unmap_dma(struct vfio_iommu *iommu,
>>  	struct vfio_iommu_type1_dma_unmap unmap;
>>  	struct vfio_bitmap bitmap = { 0 };
>>  	uint32_t mask = VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP |
>> +			VFIO_DMA_UNMAP_FLAG_VADDR |
>>  			VFIO_DMA_UNMAP_FLAG_ALL;
> 
> dirty + vaddr would need a separate test per my previous patch comment.
> Thanks,

Yes.

- Steve
