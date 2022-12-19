Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6E486513E7
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 21:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbiLSU3R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 15:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbiLSU3G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 15:29:06 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400FD6599;
        Mon, 19 Dec 2022 12:29:06 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJKDULi020911;
        Mon, 19 Dec 2022 20:29:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mN1MQpBxIkoLOiTh7BjZLMZU8r9deuhzwxqNYF6vUFo=;
 b=Hqf6w03EJ4H9z2VP5ULbgxIiDw8jhqQnwheitdr4MbTTPCKUbRbymMJs7MZC/RXneC8J
 AXgYLbhehDwwzJ3zBpXzgGhQZPK8TB1J2+8fPbUkhKWmrlwjSSasjoKJKmw2Kf/j8+Zt
 wABB5rfn8QHzdAD7KgeMnB8OgHc1CYhYXYeEc4yjV53F/1sPv0KamwcSTvBb5Ql45G96
 YH0gCMU+mD7rXt4BqHI1CBwKyHCjLaYng7ZFl3+CumyrPda/8PVIc7sMiwm2iMxf7qxi
 9zoZ9tly2n89l7qUapUgdr1yPfc4gijIPi2G2hyOUCuKRjSoJ3LdMxrcDWw3rNZ2AWxo 8Q== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mjxt7rbph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 20:29:05 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJJwuOq032741;
        Mon, 19 Dec 2022 20:29:04 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([9.208.129.118])
        by ppma01dal.us.ibm.com (PPS) with ESMTPS id 3mh6yykgdd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 20:29:04 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
        by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BJKT2YP60883378
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 20:29:02 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B95158058;
        Mon, 19 Dec 2022 20:29:02 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BF3A5805C;
        Mon, 19 Dec 2022 20:29:01 +0000 (GMT)
Received: from [9.60.89.243] (unknown [9.60.89.243])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 19 Dec 2022 20:29:01 +0000 (GMT)
Message-ID: <4bebf8f9-5d19-b86b-b16c-ed3ea384c214@linux.ibm.com>
Date:   Mon, 19 Dec 2022 15:29:00 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v1 14/16] vfio/ccw: handle a guest Format-1 IDAL
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
 <20221121214056.1187700-15-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20221121214056.1187700-15-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RmFY8iYqy8wNVRLMNVOQemz_4nkSm5wN
X-Proofpoint-GUID: RmFY8iYqy8wNVRLMNVOQemz_4nkSm5wN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 impostorscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212190178
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/21/22 4:40 PM, Eric Farman wrote:
> There are two scenarios that need to be addressed here.
> 
> First, an ORB that does NOT have the Format-2 IDAL bit set could
> have both a direct-addressed CCW and an indirect-data-address CCW
> chained together. This means that the IDA CCW will contain a
> Format-1 IDAL, and can be easily converted to a 2K Format-2 IDAL.
> But it also means that the direct-addressed CCW needs to be
> converted to the same 2K Format-2 IDAL for consistency with the
> ORB settings.
> 
> Secondly, a Format-1 IDAL is comprised of 31-bit addresses.
> Thus, we need to cast this IDAL to a pointer of ints while
> populating the list of addresses that are sent to vfio.
> 
> Since the result of both of these is the use of the 2K IDAL
> variants, and the output of vfio-ccw is always a Format-2 IDAL
> (in order to use 64-bit addresses), make sure that the correct
> control bit gets set in the ORB when these scenarios occur.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index 90685cee85db..9527f3d8da77 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -222,6 +222,8 @@ static void convert_ccw0_to_ccw1(struct ccw1 *source, unsigned long len)
>  	}
>  }
>  
> +#define idal_is_2k(_cp) (!_cp->orb.cmd.c64 || _cp->orb.cmd.i2k)
> +
>  /*
>   * Helpers to operate ccwchain.
>   */
> @@ -504,8 +506,9 @@ static unsigned long *get_guest_idal(struct ccw1 *ccw,
>  	struct vfio_device *vdev =
>  		&container_of(cp, struct vfio_ccw_private, cp)->vdev;
>  	unsigned long *idaws;
> +	unsigned int *idaws_f1;

I wonder if we should be using explicit u64/u32 here since we are dealing with hardware-architected data sizes and specifically want to index by 32- or 64-bits.  Honestly, there's probably a number of other spots in vfio-ccw where that might make sense so it would also be OK to look into that as a follow-on.

Otherwise, LGTM

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

>  	int idal_len = idaw_nr * sizeof(*idaws);
> -	int idaw_size = PAGE_SIZE;
> +	int idaw_size = idal_is_2k(cp) ? PAGE_SIZE / 2 : PAGE_SIZE;
>  	int idaw_mask = ~(idaw_size - 1);
>  	int i, ret;
>  
> @@ -527,8 +530,10 @@ static unsigned long *get_guest_idal(struct ccw1 *ccw,
>  			for (i = 1; i < idaw_nr; i++)
>  				idaws[i] = (idaws[i - 1] + idaw_size) & idaw_mask;
>  		} else {
> -			kfree(idaws);
> -			return NULL;
> +			idaws_f1 = (unsigned int *)idaws;
> +			idaws_f1[0] = ccw->cda;
> +			for (i = 1; i < idaw_nr; i++)
> +				idaws_f1[i] = (idaws_f1[i - 1] + idaw_size) & idaw_mask;
>  		}
>  	}
>  
> @@ -593,6 +598,7 @@ static int ccwchain_fetch_ccw(struct ccw1 *ccw,
>  	struct vfio_device *vdev =
>  		&container_of(cp, struct vfio_ccw_private, cp)->vdev;
>  	unsigned long *idaws;
> +	unsigned int *idaws_f1;
>  	int ret;
>  	int idaw_nr;
>  	int i;
> @@ -623,9 +629,12 @@ static int ccwchain_fetch_ccw(struct ccw1 *ccw,
>  	 * Copy guest IDAWs into page_array, in case the memory they
>  	 * occupy is not contiguous.
>  	 */
> +	idaws_f1 = (unsigned int *)idaws;
>  	for (i = 0; i < idaw_nr; i++) {
>  		if (cp->orb.cmd.c64)
>  			pa->pa_iova[i] = idaws[i];
> +		else
> +			pa->pa_iova[i] = idaws_f1[i];
>  	}
>  
>  	if (ccw_does_data_transfer(ccw)) {
> @@ -846,7 +855,11 @@ union orb *cp_get_orb(struct channel_program *cp, struct subchannel *sch)
>  
>  	/*
>  	 * Everything built by vfio-ccw is a Format-2 IDAL.
> +	 * If the input was a Format-1 IDAL, indicate that
> +	 * 2K Format-2 IDAWs were created here.
>  	 */
> +	if (!orb->cmd.c64)
> +		orb->cmd.i2k = 1;
>  	orb->cmd.c64 = 1;
>  
>  	if (orb->cmd.lpm == 0)

