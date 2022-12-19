Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9067651325
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 20:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232681AbiLST1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 14:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232775AbiLST13 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 14:27:29 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C3313D42;
        Mon, 19 Dec 2022 11:27:18 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJJD1V8012893;
        Mon, 19 Dec 2022 19:27:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=d87c6z5IyM+eqEyv+CACUUNtmAfVdkOOAsd1hHiJuow=;
 b=tK2VU0inFhvoanUOrHJM/f5rQdyagLn9FH1QOEm0bhe0QA4rGhS1ZnXMrhvqmZXKCYB7
 9wVPqkNKucvSFvMlJGkVccnMM5K2NY9FVTAIk6NHx5zxpmb+Oy0LvKLTPR5tF8xB/CJH
 5FVmWQSlEVBw0pKd9dKm+33c/ndAFJ+NdU968Gd7w7vGTTL4vq0hNVT619XmLN1tXR91
 5lmlq2GhFGsdqsnbKRT7glj63Sz+avQO0PnjTUADVmPq9FeL2CKkFzPprXfgj0Ul7ZDo
 HUt+v9DDaB7U1vtqxxN2d2p7T0KMZ3tpCL2viNnZiC3mjsafdE6paJ32rOFhyCRqSgjo Tg== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mjwww8a5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 19:27:17 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJHb3rY027516;
        Mon, 19 Dec 2022 19:27:17 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([9.208.129.114])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3mh6yuk559-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 19:27:17 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
        by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BJJRFuO47186326
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 19:27:15 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63BA158059;
        Mon, 19 Dec 2022 19:27:15 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2952158058;
        Mon, 19 Dec 2022 19:27:14 +0000 (GMT)
Received: from [9.60.89.243] (unknown [9.60.89.243])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 19 Dec 2022 19:27:14 +0000 (GMT)
Message-ID: <7512483a-ac05-3125-fa1b-3934d9436ef2@linux.ibm.com>
Date:   Mon, 19 Dec 2022 14:27:13 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v1 11/16] vfio/ccw: discard second fmt-1 IDAW
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
 <20221121214056.1187700-12-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20221121214056.1187700-12-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XPyK3fPKmFHlmqTNCaZikIRy3v9MGAfg
X-Proofpoint-GUID: XPyK3fPKmFHlmqTNCaZikIRy3v9MGAfg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=0 impostorscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212190169
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/21/22 4:40 PM, Eric Farman wrote:
> The intention is to read the first IDAW to determine the starting
> location of an I/O operation, knowing that the second and any/all
> subsequent IDAWs will be aligned per architecture. But, this read
> receives 64-bits of data, which is the size of a format-2 IDAW.
> 
> In the event that Format-1 IDAWs are presented, discard the lower
> 32 bits as they contain the second IDAW in such a list.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index 34a133d962d1..53246f4f95f7 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -516,11 +516,15 @@ static int ccw_count_idaws(struct ccw1 *ccw,
>  		bytes = ccw->count;
>  
>  	if (ccw_is_idal(ccw)) {
> -		/* Read first IDAW to see if it's 4K-aligned or not. */
> -		/* All subsequent IDAws will be 4K-aligned. */
> +		/* Read first IDAW to check its starting address. */
> +		/* All subsequent IDAWs will be 2K- or 4K-aligned. */
>  		ret = vfio_dma_rw(vdev, ccw->cda, &iova, sizeof(iova), false);
>  		if (ret)
>  			return ret;
> +
> +		/* Format-1 IDAWs only occupy the first int */
> +		if (!cp->orb.cmd.c64)
> +			iova = iova >> 32;

Rather than read 8B and discarding 4B, can't we check this format value first and only read 4B for format-1?

>  	} else {
>  		iova = ccw->cda;
>  	}

