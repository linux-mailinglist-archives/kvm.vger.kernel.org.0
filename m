Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70F4264D9B8
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 11:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiLOKs4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 05:48:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLOKsz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 05:48:55 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA17C2B1AE;
        Thu, 15 Dec 2022 02:48:53 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFAgPSf017634;
        Thu, 15 Dec 2022 10:48:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : reply-to : in-reply-to : references :
 message-id : content-type : content-transfer-encoding; s=pp1;
 bh=vJHOAPiEpxiliQFj/PeyFATh2PWHiiJrIUoB3dHYbJc=;
 b=ArTFQ2FMLv7ROqunstvEALcrfspFfqRT6A2OV23kpNPEHHsoC1XeXVg39oWIJpvKkaAd
 L1O1jA1rI4yZaDgI0y/bPyEcZMCGAZ/49crju//+gT7gW4r1mjjGSFwur3fKT1Gkgfgy
 cH8OaslFvXHYIUC5XcM4dBYW6YsEvB9kX/HMXONe5CtrLCLyIs+sClh0GEEXzGbkK3WT
 0UOxl/g0avaLI40VXkV9qj+NQKFSuLTe+gdDVuGPwbYCmxgiabc1QnuZb8HX7U4mLpKJ
 RgyyVWGnnjF8d0ir1a2aqJ9F35omOL3zbFNRwRU+X7w1FszK//0Qp4JeqTTnup5TI4gp PQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mg22eg4r5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 10:48:50 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BFAiAZT024379;
        Thu, 15 Dec 2022 10:48:49 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mg22eg4qc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 10:48:49 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFAAmLf005705;
        Thu, 15 Dec 2022 10:48:48 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([9.208.129.118])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3meyfdwaq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 10:48:48 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
        by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BFAmkTg2490892
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 10:48:47 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA0E358052;
        Thu, 15 Dec 2022 10:48:46 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F4E85804C;
        Thu, 15 Dec 2022 10:48:46 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
        by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 15 Dec 2022 10:48:46 +0000 (GMT)
MIME-Version: 1.0
Date:   Thu, 15 Dec 2022 11:48:46 +0100
From:   Harald Freudenberger <freude@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
Subject: Re: [PATCH 2/7] s390/vfio_ap: check TAPQ response code when waiting
 for queue reset
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <20221213154437.15480-3-akrowiak@linux.ibm.com>
References: <20221213154437.15480-1-akrowiak@linux.ibm.com>
 <20221213154437.15480-3-akrowiak@linux.ibm.com>
Message-ID: <0e7badff0648ec2b731ae7703ed5ba91@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lutQ1SXcVJU7XQ_u_BHrWPJJJm4h-3ZI
X-Proofpoint-ORIG-GUID: u9rIOepjXX-ia1WSJn9-GBjj-HUCoeJh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_05,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212150080
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-12-13 16:44, Tony Krowiak wrote:
> The vfio_ap_mdev_reset_queue() function does not check the status
> response code returned form the PQAP(TAPQ) function when verifying the
> queue's status; consequently, there is no way of knowing whether
> verification failed because the wait time was exceeded, or because the
> PQAP(TAPQ) failed.
> 
> This patch adds a function to check the status response code from the
> PQAP(TAPQ) instruction and logs an appropriate message if it fails.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 36 ++++++++++++++++++++++++++-----
>  1 file changed, 31 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c
> b/drivers/s390/crypto/vfio_ap_ops.c
> index 83ff94a38102..a5530a46cf31 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1587,23 +1587,49 @@ static struct vfio_ap_queue
> *vfio_ap_find_queue(int apqn)
>  	return q;
>  }
> 
> +static int apq_status_check(int apqn, struct ap_queue_status *status)
> +{
> +	switch (status->response_code) {
> +	case AP_RESPONSE_NORMAL:
> +	case AP_RESPONSE_RESET_IN_PROGRESS:
> +		if (status->queue_empty && !status->irq_enabled)
> +			return 0;
> +		return -EBUSY;
> +	case AP_RESPONSE_DECONFIGURED:
> +		/*
> +		 * If the AP queue is deconfigured, any subsequent AP command
> +		 * targeting the queue will fail with the same response code. On the
> +		 * other hand, when an AP adapter is deconfigured, the associated
> +		 * queues are reset, so let's return a value indicating the reset
> +		 * for which we're waiting completed successfully.
> +		 */
> +		return 0;
> +	default:
> +		WARN(true,
> +		     "failed to verify reset of queue %02x.%04x: TAPQ rc=%u\n",
> +		     AP_QID_CARD(apqn), AP_QID_QUEUE(apqn),
> +		     status->response_code);
> +		return -EIO;
> +	}
> +}
> +
>  static int apq_reset_check(struct vfio_ap_queue *q)
>  {
> -	int iters = 2;
> +	int iters = 2, ret;
>  	struct ap_queue_status status;
> 
>  	while (iters--) {
>  		msleep(20);
>  		status = ap_tapq(q->apqn, NULL);
> -		if (status.queue_empty && !status.irq_enabled)
> -			return 0;
> +		ret = apq_status_check(q->apqn, &status);
> +		if (ret != -EBUSY)
> +			return ret;
>  	}
>  	WARN_ONCE(iters <= 0,
>  		  "timeout verifying reset of queue %02x.%04x (%u, %u, %u)",
>  		  AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
>  		  status.queue_empty, status.irq_enabled, status.response_code);
> -
> -	return -EBUSY;
> +	return ret;
>  }
> 
>  static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,

Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>

Just one word here: this function is only called once and it is very 
very special
to just check the status after RAPQ/ZAPQ. I would merge this function 
into the
calling code or rename the function to reflect the special condition 
under which
it is called. However - this is not my code and I don't need to maintain 
it, so
maybe simple ignore my words.
