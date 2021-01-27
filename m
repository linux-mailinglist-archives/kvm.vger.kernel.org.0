Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247313067E6
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 00:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbhA0X3w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 18:29:52 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44226 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbhA0X2I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jan 2021 18:28:08 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10RNFB9r068567;
        Wed, 27 Jan 2021 23:27:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=eI8vf7sGGSsmZ5Eh/fyCGHrzP/yULgGJWh794jdx1BU=;
 b=yk08hSdMHuWJ5I+hbN8x09OZgwdRW2vrLeY3YzBZJIDmkJRiSqSJkzeS3+vgmWPbRKh4
 dNtamgGJsE1iawWfrClZ4Vc8OC424H2SM7Sau7EolAmNecb6TIxySKvmFJ9XZR5Oa5c9
 H5Bf6rAXjfh6xJbVB0QB2gfL1okPgD51KKFCfmQ6JSfEyJQQJ/T1Ttq6pgH1g+I1q0jR
 y4x5WiN7c2S42jvHaAmvsy+CA64NlKxWK8B2M46AjJwSqfkhzguJHw1kvg2kmZV738j5
 GSbhQciyKsV67NOAxAjkiDeEi4TZm5T0UYTDfT4EG3m8HwQZl/KdCimEiBdeFsZLZ2pj nw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 368brkskqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 23:27:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10RNF8qS060974;
        Wed, 27 Jan 2021 23:25:18 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by aserp3030.oracle.com with ESMTP id 368wcpv500-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 23:25:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UUWJ0jnPtu/h0DlOit43LISXQrwFu91Ei8J5NdfjqXzQFqSLsQFyuvibVi9kkBJEGDyv/oN1uBK/BZwoiARsjaXdiDUdEggaHKA5Xda//IkcbVbfGHJNU2uzLjSg9IWGpKeNnxZck6aJFlx/omVZ5g4MGKAW82CDJt7e4fAvaM2GogSyeOGi0x+qBPhLkfuJjKW7sirk/LPvSgmBhwxCDpR9u8ONDrgm+jpq6rVWkUEddsGrhA+BXBMpcaMhU9UurtYQuqGhuW/DxguGho8kKUL87j0x8g/MEFP7N1BZDPUXNk2b2WCTnc1Gybqm8/YBOmyQkp88ZT0w+aV5n5rY+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eI8vf7sGGSsmZ5Eh/fyCGHrzP/yULgGJWh794jdx1BU=;
 b=PCCv3uHEvLzOiUFWqWU/w/0PRLtZutNnSPQ0UCj14BaT7zB+ygHHyJh8lHA1/4PuWkP6vzKaey+7DfqPelgfT7EcuMwFFeQrMXBNz8qUjl6loUXkZV7q+mqoCr0ccBCbdMK9Ul/cU+plNfCdXHyJQs75gBM8Eqv6Q5jDGcaiBQVrB/RQ/MwATwQhwhNzYwttCOLKDnBhwGRf4wxMtMKBzdi+cDNcYQll4beMmf+4wVvDGJeVHuQuwaMo2jHFQKmf53rmHt85l0faGSn60Tig4KVs7h982HC8V7wKD5HBmwAZExWjcf0KzI+uPYgf1l1UuIFc4ieym8SF+A8PPKnSyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eI8vf7sGGSsmZ5Eh/fyCGHrzP/yULgGJWh794jdx1BU=;
 b=Oh1R6ddiZWU3Aa9Tk8K+c+mxl+zpRxfRZ091NuzUEFYKhSdrCVN2qAyP8t5Qtay+pSSeR44g5icGd4f3tLQYrxF10BIJawvozQOt/rTE4x6rLdxOiocw49JyhQ2bT4Lk8j4NlrcAEuGmfD+2vz43fF5RmpR3lD2ZDUdiWySUNIw=
Received: from BYAPR10MB3240.namprd10.prod.outlook.com (2603:10b6:a03:155::17)
 by BYAPR10MB3655.namprd10.prod.outlook.com (2603:10b6:a03:127::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.16; Wed, 27 Jan
 2021 23:25:16 +0000
Received: from BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::9123:2652:e975:aa26]) by BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::9123:2652:e975:aa26%5]) with mapi id 15.20.3805.017; Wed, 27 Jan 2021
 23:25:16 +0000
Subject: Re: [PATCH V2 9/9] vfio/type1: block on invalid vaddr
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
References: <1611078509-181959-1-git-send-email-steven.sistare@oracle.com>
 <1611078509-181959-10-git-send-email-steven.sistare@oracle.com>
 <20210122155946.3f42dfc9@omen.home.shazbot.org>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
Message-ID: <2df4d9b2-e668-788d-7c2c-8c27199a0818@oracle.com>
Date:   Wed, 27 Jan 2021 18:25:13 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210122155946.3f42dfc9@omen.home.shazbot.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [24.62.106.7]
X-ClientProxiedBy: CY4PR08CA0040.namprd08.prod.outlook.com
 (2603:10b6:903:151::26) To BYAPR10MB3240.namprd10.prod.outlook.com
 (2603:10b6:a03:155::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.92] (24.62.106.7) by CY4PR08CA0040.namprd08.prod.outlook.com (2603:10b6:903:151::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 23:25:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f8012eb-237a-4436-ff43-08d8c31acdf6
X-MS-TrafficTypeDiagnostic: BYAPR10MB3655:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB36559C292D136D06C83F23DDF9BB9@BYAPR10MB3655.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +KVoY3xz0mVZtcsdSsRhlVfdYZqiMvMJ5dJBHe7ZKX5Qrr6e6GzrZMuILMgE15ioHCDfnnT+YY7cJd8z/oRhnZSNmPR9+auLUlyxyJ0H2ShhDFBk26YC/JwyiMKKu+mfQAOs3+B8VV6wOmUy9lfRwN/0E0/LgVXDNQQUWewgaBY+rVjYl3QP4AInaAbOna0LZBKI3LWwWgz8GDJMNl40JFE6f61ipNWtmABCNbZrIo6VfkHSdz2sqQhWIw2GmuM2t4rvlPJzMy9vQg+LvcaXWuAweCs0ctgWMGNkhmyFe/tPU1rCkfr3yRkwPWvEkAXi9vk3OapzkbjMLJf4y/yyj/JM6sIU23i/wZLbVdziqWRiWTpl6vMPegNswQsF5WmftmUYMuPgc3QM8dneXV0iBJou8E74KxpoeYKY8dkG/XzSpqYoYxzd0kM8HXTan/Ag/t6uwduonj1ZqlZ/pWJoYPhwIbrLijkYlEQPKPQ16BdRJ+CiO/9wTriLqlETIqYfsTBpqIXlSa32Xlm76vR5qmBrSVsYa5eayh2uC0Y5H+nnwz3Gsf0uNKAU2gmBCJrXyvpNM4hRsCDqDpkaKJSNTsQvFMVkao4t0QQ9B5FKnT0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3240.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(136003)(396003)(366004)(346002)(186003)(36916002)(54906003)(478600001)(16526019)(31696002)(26005)(44832011)(4326008)(31686004)(8676002)(956004)(6486002)(86362001)(83380400001)(66476007)(66556008)(316002)(6916009)(53546011)(66946007)(16576012)(2906002)(8936002)(2616005)(5660300002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZHdpU2R4WCs2c1lHQlQ5ejNJMld3SGdXTTBPYXVWK05NWWJ4eWlieFRYd3F2?=
 =?utf-8?B?cG4xRGVhOXczK1JDdDNuNXo0RVNvaFEwNmlPT2Z6dHNZQWIvZzdLdXVnSXhV?=
 =?utf-8?B?M25sdWtNNGZwSXZQMWo0MWFBVnVxQW5pMjNRVzgrL3hrbXJFd1BWRUJWT3Uy?=
 =?utf-8?B?M3I1Zkxndk12YkgyanU0OUJERExVTHdFMTBWZmFUMktValEyS012OG9pMjN3?=
 =?utf-8?B?czN2c3dXRlc4K01ZMWExd2p0NHF5TVZCL3UzQnBBS01laURvSGZoMnRZbi9v?=
 =?utf-8?B?MEhkNFlrZEtFUUpTaUZnMVMvcUpMVVp1RkJQV3V2clgwdmVheXFvckZSTitM?=
 =?utf-8?B?dTl6MXdETm9xL3F6TzdCTlY0SmtlWFdjL0FKdU5hanJaaHpPNjg5NHZVV2xh?=
 =?utf-8?B?dHY2c3IzSVBZcnZ3Z3dwSTZWSTVpUnZTbGc2SGU2SW1CYXZIbU8rMzdMa2ZP?=
 =?utf-8?B?blN2MDV4MWtMUXgvZFpSZG1PeGtNT2RiYy9WY1h4SzJGK3BhbkJxWXkxT0Ew?=
 =?utf-8?B?WmdMbU9oa0M4dlZFbFlydndoUnVNU0ppeDFGNHd0QmFidGdnZWJFeWJnOWZP?=
 =?utf-8?B?U3d0QWIrSXZJbVFvbWV6SzdXeDU2OVYzL0tWMnZBanc2L0ZVb2daOWpyNnkv?=
 =?utf-8?B?QW5TQWRnQzNLSEwyMUt5V1JmdGdaMy9JS1FiVklvYStMYTB1TExVRXA5dWpN?=
 =?utf-8?B?a3poalY2R2VLd254SUN5c0o2K1huek1HRWFmWkx6YXNKNVlqNVNjck9SdXRs?=
 =?utf-8?B?NllqMEQzaVJpU3FabGtHY1hpU2ZCTHFCSWRjZGVIMDhxbjlzbkQ3RU9nVzJk?=
 =?utf-8?B?aytsbC93elZvUmVzLzduMmZOUjYwWFpKYUV4d05pY0crR3NaMnQ4ODMwTXBD?=
 =?utf-8?B?SC9aZTF1a0VPK2d1cHN4R0pPNHE4am9yT0owSFdaQ1pzQjFHdHdyVk9HcGt3?=
 =?utf-8?B?a251K1doYmhReGk3ajE3RW42TzZYUUEybkp2MUVwZThhajIxOGNiM0xHVTRC?=
 =?utf-8?B?SWJIU0xCbTkwZ240YlV1YXozUkJuRTNFc0twQ01DdHBJWnZ6YWVRUjB2V2pW?=
 =?utf-8?B?clcrSzhrVkhDUEJVUi8xWDc4WnpGRXNKVFlDMzVsYlhsUUJlS0tkU1BiekJv?=
 =?utf-8?B?MDF2eVlBWkdPMFd6cS9UQnUydDI4RmpsVUxFZ1BWRE1zNCtkNjA2VWQ2YnQ1?=
 =?utf-8?B?bTdCV001NU9MK01ldVg4YVRuUmowbFplWkVMbGZXS2ZOZ0IwZmZ5MTVsbXRa?=
 =?utf-8?B?TGRBYndnMGU3TFFCZThMajVjSVhBZUQ3bytUM294RUowTmdIMHV2Lzg3L1Ns?=
 =?utf-8?B?WlEzeG40ZGpSYlhYUFROTWpTMWhLUFk3YXNJUWhmcGV6Sllna2wrK2RjOXM2?=
 =?utf-8?B?TmxQdUQ2dXh4UEtIenlmN0huOFBBUXJIWTZNeVBPTTk2SThNWEQ5ZzdEKzZo?=
 =?utf-8?Q?c44ilHyk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f8012eb-237a-4436-ff43-08d8c31acdf6
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3240.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 23:25:16.6796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eXVp8PFphQieUn+ssI0Vovp9T/EXO+U66G9ljwDUPwCZ4iI5SRyW18+TnhYNF6dCfqMMuMTqrFWNY/haN+/0BpxfCVmIu+9kh2ONBORg/BY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3655
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270116
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101270116
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/22/2021 5:59 PM, Alex Williamson wrote:
> On Tue, 19 Jan 2021 09:48:29 -0800
> Steve Sistare <steven.sistare@oracle.com> wrote:
> 
>> Block translation of host virtual address while an iova range has an
>> invalid vaddr.
>>
>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 83 +++++++++++++++++++++++++++++++++++++----
>>  1 file changed, 76 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 0167996..c97573a 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -31,6 +31,7 @@
>>  #include <linux/rbtree.h>
>>  #include <linux/sched/signal.h>
>>  #include <linux/sched/mm.h>
>> +#include <linux/kthread.h>
>>  #include <linux/slab.h>
>>  #include <linux/uaccess.h>
>>  #include <linux/vfio.h>
>> @@ -75,6 +76,7 @@ struct vfio_iommu {
>>  	bool			dirty_page_tracking;
>>  	bool			pinned_page_dirty_scope;
>>  	bool			controlled;
>> +	wait_queue_head_t	vaddr_wait;
>>  };
>>  
>>  struct vfio_domain {
>> @@ -145,6 +147,8 @@ struct vfio_regions {
>>  #define DIRTY_BITMAP_PAGES_MAX	 ((u64)INT_MAX)
>>  #define DIRTY_BITMAP_SIZE_MAX	 DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
>>  
>> +#define WAITED 1
>> +
>>  static int put_pfn(unsigned long pfn, int prot);
>>  
>>  static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
>> @@ -505,6 +509,52 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
>>  }
>>  
>>  /*
>> + * Wait for vaddr of *dma_p to become valid.  iommu lock is dropped if the task
>> + * waits, but is re-locked on return.  If the task waits, then return an updated
>> + * dma struct in *dma_p.  Return 0 on success with no waiting, 1 on success if
> 
> s/1/WAITED/

OK, but the WAITED state will not need to be returned in the new scheme below.

>> + * waited, and -errno on error.
>> + */
>> +static int vfio_vaddr_wait(struct vfio_iommu *iommu, struct vfio_dma **dma_p)
>> +{
>> +	struct vfio_dma *dma = *dma_p;
>> +	unsigned long iova = dma->iova;
>> +	size_t size = dma->size;
>> +	int ret = 0;
>> +	DEFINE_WAIT(wait);
>> +
>> +	while (!dma->vaddr_valid) {
>> +		ret = WAITED;
>> +		prepare_to_wait(&iommu->vaddr_wait, &wait, TASK_KILLABLE);
>> +		mutex_unlock(&iommu->lock);
>> +		schedule();
>> +		mutex_lock(&iommu->lock);
>> +		finish_wait(&iommu->vaddr_wait, &wait);
>> +		if (kthread_should_stop() || !iommu->controlled ||
>> +		    fatal_signal_pending(current)) {
>> +			return -EFAULT;
>> +		}
>> +		*dma_p = dma = vfio_find_dma(iommu, iova, size);
>> +		if (!dma)
>> +			return -EINVAL;
>> +	}
>> +	return ret;
>> +}
>> +
>> +/*
>> + * Find dma struct and wait for its vaddr to be valid.  iommu lock is dropped
>> + * if the task waits, but is re-locked on return.  Return result in *dma_p.
>> + * Return 0 on success, 1 on success if waited,  and -errno on error.
>> + */
>> +static int vfio_find_vaddr(struct vfio_iommu *iommu, dma_addr_t start,
>> +			   size_t size, struct vfio_dma **dma_p)
> 
> more of a vfio_find_dma_valid()

I will slightly modify and rename this with the new scheme I describe below.

>> +{
>> +	*dma_p = vfio_find_dma(iommu, start, size);
>> +	if (!*dma_p)
>> +		return -EINVAL;
>> +	return vfio_vaddr_wait(iommu, dma_p);
>> +}
>> +
>> +/*
>>   * Attempt to pin pages.  We really don't want to track all the pfns and
>>   * the iommu can only map chunks of consecutive pfns anyway, so get the
>>   * first page and all consecutive pages with the same locking.
>> @@ -693,11 +743,11 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>>  		struct vfio_pfn *vpfn;
>>  
>>  		iova = user_pfn[i] << PAGE_SHIFT;
>> -		dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
>> -		if (!dma) {
>> -			ret = -EINVAL;
>> +		ret = vfio_find_vaddr(iommu, iova, PAGE_SIZE, &dma);
>> +		if (ret < 0)
>>  			goto pin_unwind;
>> -		}
>> +		else if (ret == WAITED)
>> +			do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu);
> 
> We're iterating through an array of pfns to provide translations, once
> we've released the lock it's not just the current one that could be
> invalid.  I'm afraid we need to unwind and try again, but I think it's
> actually worse than that because if we've marked pages within a
> vfio_dma's pfn_list as pinned, then during the locking gap it gets
> unmapped, the unmap path will call the unmap notifier chain to release
> the page that the vendor driver doesn't have yet.  Yikes!

Yikes indeed.  The fix is easy, though.  I will maintain a count in vfio_iommu of 
vfio_dma objects with invalid vaddr's, modified and tested while holding the lock, 
provide a function to wait for the count to become 0, and call that function at the 
start of vfio_iommu_type1_pin_pages and vfio_iommu_replay.  I will use iommu->vaddr_wait 
for wait and wake.

>>  		if ((dma->prot & prot) != prot) {
>>  			ret = -EPERM;
>> @@ -1496,6 +1546,22 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
>>  	unsigned long limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
>>  	int ret;
>>  
>> +	/*
>> +	 * Wait for all vaddr to be valid so they can be used in the main loop.
>> +	 * If we do wait, the lock was dropped and re-taken, so start over to
>> +	 * ensure the dma list is consistent.
>> +	 */
>> +again:
>> +	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
>> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
>> +
>> +		ret = vfio_vaddr_wait(iommu, &dma);
>> +		if (ret < 0)
>> +			return ret;
>> +		else if (ret == WAITED)
>> +			goto again;
>> +	}
> 
> This "do nothing until all the vaddrs are valid" approach could work
> above too, but gosh is that a lot of cache unfriendly work for a rare
> invalidation.  Thanks,

The new wait function described above is fast in the common case, just a check that
the invalid vaddr count is 0.

- Steve

>> +
>>  	/* Arbitrarily pick the first domain in the list for lookups */
>>  	if (!list_empty(&iommu->domain_list))
>>  		d = list_first_entry(&iommu->domain_list,
>> @@ -2522,6 +2588,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
>>  	iommu->controlled = true;
>>  	mutex_init(&iommu->lock);
>>  	BLOCKING_INIT_NOTIFIER_HEAD(&iommu->notifier);
>> +	init_waitqueue_head(&iommu->vaddr_wait);
>>  
>>  	return iommu;
>>  }
>> @@ -2972,12 +3039,13 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
>>  	struct vfio_dma *dma;
>>  	bool kthread = current->mm == NULL;
>>  	size_t offset;
>> +	int ret;
>>  
>>  	*copied = 0;
>>  
>> -	dma = vfio_find_dma(iommu, user_iova, 1);
>> -	if (!dma)
>> -		return -EINVAL;
>> +	ret = vfio_find_vaddr(iommu, user_iova, 1, &dma);
>> +	if (ret < 0)
>> +		return ret;
>>  
>>  	if ((write && !(dma->prot & IOMMU_WRITE)) ||
>>  			!(dma->prot & IOMMU_READ))
>> @@ -3055,6 +3123,7 @@ static void vfio_iommu_type1_notify(void *iommu_data, unsigned int event,
>>  	mutex_lock(&iommu->lock);
>>  	iommu->controlled = false;
>>  	mutex_unlock(&iommu->lock);
>> +	wake_up_all(&iommu->vaddr_wait);
>>  }
>>  
>>  static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
> 
