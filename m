Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65AF564F2EA
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 22:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbiLPVF4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 16:05:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbiLPVFy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 16:05:54 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58C011457;
        Fri, 16 Dec 2022 13:05:53 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BGKjb2Y006918;
        Fri, 16 Dec 2022 21:05:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Oo8mBuBZgFRfBoIG2R9zZw/e4eRe4rB5Bfcu13vegAk=;
 b=EoR0U5m/6iVjxgitSzVErDG1iZChS9mnYHzx+KIvAuIPJCtQnXAdRRxW4yVbT5dnPCg0
 3gS+bSvcUGqQvzXeA31XQsvlJUHa0TW5oJITKyB5rx3EABCcayxxEUgbkzPAAUKKZo8d
 etO8PC6w8GLjNs0jRJ5LCICHJgJB1ZpE1k9qUEC3H6osFvXEsecrktfgffmTkNOwvL93
 WuUL291rkEaNDKtRNQEPfJbFA/0jg5u1PFd58hHPzJiXJgvUVnQa4bCBpheb/o1QLlik
 bjcPVMV5TqG07+PGxpoNnrN6tiJcWgeVbodxOywOqnfVzFEehO+zQKvflnRk4dIpOQWT FA== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mh00brgjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Dec 2022 21:05:53 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BGL1FBZ030949;
        Fri, 16 Dec 2022 21:05:52 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([9.208.129.118])
        by ppma04wdc.us.ibm.com (PPS) with ESMTPS id 3meyqkvgud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Dec 2022 21:05:52 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
        by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BGL5ogd66191686
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Dec 2022 21:05:50 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 963EA5805A;
        Fri, 16 Dec 2022 21:05:50 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2471F5805F;
        Fri, 16 Dec 2022 21:05:49 +0000 (GMT)
Received: from [9.160.114.181] (unknown [9.160.114.181])
        by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 16 Dec 2022 21:05:48 +0000 (GMT)
Message-ID: <56ab58a3-345b-3ac8-13c4-125e9b83fec1@linux.ibm.com>
Date:   Fri, 16 Dec 2022 16:05:48 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v1 09/16] vfio/ccw: populate page_array struct inline
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
 <20221121214056.1187700-10-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20221121214056.1187700-10-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hBClydWd-bn4w9InIx30Sb4Vq4ar3BKw
X-Proofpoint-ORIG-GUID: hBClydWd-bn4w9InIx30Sb4Vq4ar3BKw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-16_14,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212160187
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/21/22 4:40 PM, Eric Farman wrote:
> There are two possible ways the list of addresses that get passed
> to vfio are calculated. One is from a guest IDAL, which would be
> an array of (probably) non-contiguous addresses. The other is
> built from contiguous pages that follow the starting address
> provided by ccw->cda.
> 
> page_array_alloc() attempts to simplify things by pre-populating
> this array from the starting address, but that's not needed for
> a CCW with an IDAL anyway so doesn't need to be in the allocator.
> Move it to the caller in the non-IDAL case, since it will be
> overwritten when reading the guest IDAL.
> 
> Remove the initialization of the pa_page output pointers,
> since it won't be explicitly needed for either case.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 22 +++++-----------------
>  1 file changed, 5 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index 66e890441163..a30f26962750 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -42,7 +42,6 @@ struct ccwchain {
>  /*
>   * page_array_alloc() - alloc memory for page array
>   * @pa: page_array on which to perform the operation
> - * @iova: target guest physical address
>   * @len: number of pages that should be pinned from @iova
>   *
>   * Attempt to allocate memory for page array.
> @@ -56,10 +55,8 @@ struct ccwchain {
>   *   -EINVAL if pa->pa_nr is not initially zero, or pa->pa_iova is not NULL
>   *   -ENOMEM if alloc failed
>   */
> -static int page_array_alloc(struct page_array *pa, u64 iova, unsigned int len)
> +static int page_array_alloc(struct page_array *pa, unsigned int len)
>  {
> -	int i;
> -
>  	if (pa->pa_nr || pa->pa_iova)
>  		return -EINVAL;
>  
> @@ -78,13 +75,6 @@ static int page_array_alloc(struct page_array *pa, u64 iova, unsigned int len)
>  		return -ENOMEM;
>  	}
>  
> -	pa->pa_iova[0] = iova;
> -	pa->pa_page[0] = NULL;
> -	for (i = 1; i < pa->pa_nr; i++) {
> -		pa->pa_iova[i] = pa->pa_iova[i - 1] + PAGE_SIZE;
> -		pa->pa_page[i] = NULL;
> -	}
> -
>  	return 0;
>  }
>  
> @@ -548,7 +538,7 @@ static int ccwchain_fetch_ccw(struct ccw1 *ccw,
>  	 * required for the data transfer, since we only only support
>  	 * 4K IDAWs today.
>  	 */
> -	ret = page_array_alloc(pa, iova, idaw_nr);
> +	ret = page_array_alloc(pa, idaw_nr);
>  	if (ret < 0)
>  		goto out_free_idaws;
>  
> @@ -565,11 +555,9 @@ static int ccwchain_fetch_ccw(struct ccw1 *ccw,
>  		for (i = 0; i < idaw_nr; i++)
>  			pa->pa_iova[i] = idaws[i];
>  	} else {
> -		/*
> -		 * No action is required here; the iova addresses in page_array
> -		 * were initialized sequentially in page_array_alloc() beginning
> -		 * with the contents of ccw->cda.
> -		 */
> +		pa->pa_iova[0] = iova;
> +		for (i = 1; i < pa->pa_nr; i++)
> +			pa->pa_iova[i] = pa->pa_iova[i - 1] + PAGE_SIZE;
>  	}
>  
>  	if (ccw_does_data_transfer(ccw)) {

