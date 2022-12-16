Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED3F64F213
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 21:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbiLPUBF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 15:01:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbiLPUBD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 15:01:03 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635EC2B25A;
        Fri, 16 Dec 2022 12:01:00 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BGJiwkN028370;
        Fri, 16 Dec 2022 20:01:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bmsyMLIDcZ/1wcwvXYl9Kzu/xmDrRfRYNyYXb0TopCk=;
 b=ptasNTZzJUvrKNFRPPccvSyKjdg24MzKRTQRU3j+An30wgo7a8r5IwYG7HIKG/eoGX72
 2217kpFgIqON2ZeQke0aVD/mTP38C1JWu33YhtxYfDGUUWChRn+rO3UX5GX2CRSHhPEx
 8yjmv6Nen1XuF1RYwOmvYeqshxnKQzZ245zwh5TQ40zCHOW2iFVFBqJve2Sj2DC7KqE0
 nA/hX1OWtbDsfUMU5TCsi5H/pVrJCt4qYteJPJ0ghD0OnWiDEKMZU7UMuMrbxvTsMZEM
 52ZEoAwQmi8U4ijUzxO5WCCa3vuylp5RVbGc/vDzLLz2vGZZHRWUIhfoA9fRcMXzdK3x NQ== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mgy3wgaey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Dec 2022 20:00:59 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BGJleW3020797;
        Fri, 16 Dec 2022 19:59:53 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([9.208.130.99])
        by ppma02dal.us.ibm.com (PPS) with ESMTPS id 3mf07h0xqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Dec 2022 19:59:53 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
        by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BGJxpNC37159266
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Dec 2022 19:59:52 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4D6C5805F;
        Fri, 16 Dec 2022 19:59:51 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28AEE58058;
        Fri, 16 Dec 2022 19:59:50 +0000 (GMT)
Received: from [9.160.114.181] (unknown [9.160.114.181])
        by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 16 Dec 2022 19:59:50 +0000 (GMT)
Message-ID: <caa39cd9-d488-fea2-6569-88d08b9621b3@linux.ibm.com>
Date:   Fri, 16 Dec 2022 14:59:49 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v1 08/16] vfio/ccw: pass page count to page_array struct
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20221121214056.1187700-1-farman@linux.ibm.com>
 <20221121214056.1187700-9-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20221121214056.1187700-9-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ejqwko0jQXC0qdD_rs6psyWfxRK3X11W
X-Proofpoint-ORIG-GUID: Ejqwko0jQXC0qdD_rs6psyWfxRK3X11W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-16_13,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 clxscore=1015 malwarescore=0 mlxscore=0 phishscore=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212160177
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/21/22 4:40 PM, Eric Farman wrote:
> The allocation of our page_array struct calculates the number
> of 4K pages that would be needed to hold a certain number of
> bytes. But, since the number of pages that will be pinned is
> also calculated by the length of the IDAL, this logic is
> unnecessary. Let's pass that information in directly, and
> avoid the math within the allocator.
> 
> Also, let's make this two allocations instead of one,
> to make it apparent what's happening within here.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index 4b6b5f9dc92d..66e890441163 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -43,7 +43,7 @@ struct ccwchain {
>   * page_array_alloc() - alloc memory for page array
>   * @pa: page_array on which to perform the operation
>   * @iova: target guest physical address
> - * @len: number of bytes that should be pinned from @iova
> + * @len: number of pages that should be pinned from @iova
>   *
>   * Attempt to allocate memory for page array.
>   *
> @@ -63,18 +63,20 @@ static int page_array_alloc(struct page_array *pa, u64 iova, unsigned int len)
>  	if (pa->pa_nr || pa->pa_iova)
>  		return -EINVAL;
>  
> -	pa->pa_nr = ((iova & ~PAGE_MASK) + len + (PAGE_SIZE - 1)) >> PAGE_SHIFT;
> -	if (!pa->pa_nr)
> +	if (!len)

Seems like a weird way to check this.  if (len == 0) ?

Otherwise:
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

>  		return -EINVAL;
>  
> -	pa->pa_iova = kcalloc(pa->pa_nr,
> -			      sizeof(*pa->pa_iova) + sizeof(*pa->pa_page),
> -			      GFP_KERNEL);
> -	if (unlikely(!pa->pa_iova)) {
> -		pa->pa_nr = 0;
> +	pa->pa_nr = len;
> +
> +	pa->pa_iova = kcalloc(len, sizeof(*pa->pa_iova), GFP_KERNEL);
> +	if (!pa->pa_iova)
> +		return -ENOMEM;
> +
> +	pa->pa_page = kcalloc(len, sizeof(*pa->pa_page), GFP_KERNEL);
> +	if (!pa->pa_page) {
> +		kfree(pa->pa_iova);
>  		return -ENOMEM;
>  	}
> -	pa->pa_page = (struct page **)&pa->pa_iova[pa->pa_nr];
>  
>  	pa->pa_iova[0] = iova;
>  	pa->pa_page[0] = NULL;
> @@ -167,6 +169,7 @@ static int page_array_pin(struct page_array *pa, struct vfio_device *vdev)
>  static void page_array_unpin_free(struct page_array *pa, struct vfio_device *vdev)
>  {
>  	page_array_unpin(pa, vdev, pa->pa_nr);
> +	kfree(pa->pa_page);
>  	kfree(pa->pa_iova);
>  }
>  
> @@ -545,7 +548,7 @@ static int ccwchain_fetch_ccw(struct ccw1 *ccw,
>  	 * required for the data transfer, since we only only support
>  	 * 4K IDAWs today.
>  	 */
> -	ret = page_array_alloc(pa, iova, bytes);
> +	ret = page_array_alloc(pa, iova, idaw_nr);
>  	if (ret < 0)
>  		goto out_free_idaws;
>  

