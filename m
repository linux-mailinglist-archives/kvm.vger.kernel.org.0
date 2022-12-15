Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2737664D9C6
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 11:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbiLOKv4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 05:51:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiLOKvw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 05:51:52 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A15DBE;
        Thu, 15 Dec 2022 02:51:51 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFAkA6B022392;
        Thu, 15 Dec 2022 10:51:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : reply-to : in-reply-to : references :
 message-id : content-type : content-transfer-encoding; s=pp1;
 bh=/WJkFpYLA65qNga5mPVHx+sBgGM72eHalXyjc4AKLSM=;
 b=aIUqakxRt4s/+DH/B+zsMGiyezkiFN2MDppIOn3b/5QgIzdh6eERKi/iviKujS5rYaBl
 Vf1nZSEj4w5+ZWsw4MLeB7/Q4Y5A4Shl3Dhe4rqpu0tlCjoQ9GelTd1i8h7Lrf3fj3Q6
 84DDXnlJXEuGEnEMa50WrwcMUb3kYjK26sP1i85uazV9kqMoa++DQIysvq5K3j/VY9en
 2Moz6+5yf7HoJmC98BrLWTL1v7M7wzusmCVQo2uvM69Jb/O61OSskesUVgFiHlrPptH3
 jLGywsEk2If+UvZlMUG8uAshBZWrHPWJmh71H870CVrNF0+qR0W7/jGVJOFk7gthVlch Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mg24a0444-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 10:51:44 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BFAlDn3024896;
        Thu, 15 Dec 2022 10:51:44 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mg24a0433-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 10:51:44 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BF8Hl3Y011789;
        Thu, 15 Dec 2022 10:51:43 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([9.208.130.102])
        by ppma01dal.us.ibm.com (PPS) with ESMTPS id 3meyyhw613-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 10:51:43 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
        by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BFApfeM4915954
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 10:51:41 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA07C58065;
        Thu, 15 Dec 2022 10:51:41 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F3B25805A;
        Thu, 15 Dec 2022 10:51:41 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 15 Dec 2022 10:51:41 +0000 (GMT)
MIME-Version: 1.0
Date:   Thu, 15 Dec 2022 11:51:41 +0100
From:   Harald Freudenberger <freude@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
Subject: Re: [PATCH 3/7] s390/vfio_ap: use TAPQ to verify reset in progress
 completes
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <20221213154437.15480-4-akrowiak@linux.ibm.com>
References: <20221213154437.15480-1-akrowiak@linux.ibm.com>
 <20221213154437.15480-4-akrowiak@linux.ibm.com>
Message-ID: <2541e0d3d4fb38af995e8bd91a34986d@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XmT7JLhQ6ffq5hc-cRADki9C7VoYpLxA
X-Proofpoint-ORIG-GUID: bl4qR1ZHy5FpDSG-lRpUFbDpAxnO3Mwr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_05,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 clxscore=1015 spamscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 impostorscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150080
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-12-13 16:44, Tony Krowiak wrote:
> To eliminate the repeated calls to the PQAP(ZAPQ) function to verify 
> that
> a reset in progress completed successfully and ensure that error 
> response
> codes get appropriately logged, let's call the apq_reset_check() 
> function
> when the ZAPQ response code indicates that a reset that is already in
> progress.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c
> b/drivers/s390/crypto/vfio_ap_ops.c
> index a5530a46cf31..5bf2d93ae8af 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -33,7 +33,7 @@
>  static int vfio_ap_mdev_reset_queues(struct ap_queue_table *qtable);
>  static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
>  static const struct vfio_device_ops vfio_ap_matrix_dev_ops;
> -static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q, unsigned
> int retry);
> +static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q);
> 
>  /**
>   * get_update_locks_for_kvm: Acquire the locks required to dynamically 
> update a
> @@ -1632,8 +1632,7 @@ static int apq_reset_check(struct vfio_ap_queue 
> *q)
>  	return ret;
>  }
> 
> -static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
> -				    unsigned int retry)
> +static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
>  {
>  	struct ap_queue_status status;
>  	int ret;
> @@ -1648,12 +1647,15 @@ static int vfio_ap_mdev_reset_queue(struct
> vfio_ap_queue *q,
>  		ret = 0;
>  		break;
>  	case AP_RESPONSE_RESET_IN_PROGRESS:
> -		if (retry--) {
> -			msleep(20);
> -			goto retry_zapq;
> -		}
> -		ret = -EBUSY;
> -		break;
> +		/*
> +		 * There is a reset issued by another process in progress. Let's 
> wait
> +		 * for that to complete. Since we have no idea whether it was a RAPQ 
> or
> +		 * ZAPQ, then if it completes successfully, let's issue the ZAPQ.
> +		 */
> +		ret = apq_reset_check(q);
> +		if (ret)
> +			break;
> +		goto retry_zapq;
>  	case AP_RESPONSE_Q_NOT_AVAIL:
>  	case AP_RESPONSE_DECONFIGURED:
>  	case AP_RESPONSE_CHECKSTOPPED:
> @@ -1688,7 +1690,7 @@ static int vfio_ap_mdev_reset_queues(struct
> ap_queue_table *qtable)
>  	struct vfio_ap_queue *q;
> 
>  	hash_for_each(qtable->queues, loop_cursor, q, mdev_qnode) {
> -		ret = vfio_ap_mdev_reset_queue(q, 1);
> +		ret = vfio_ap_mdev_reset_queue(q);
>  		/*
>  		 * Regardless whether a queue turns out to be busy, or
>  		 * is not operational, we need to continue resetting
> @@ -1931,7 +1933,7 @@ void vfio_ap_mdev_remove_queue(struct ap_device 
> *apdev)
>  		}
>  	}
> 
> -	vfio_ap_mdev_reset_queue(q, 1);
> +	vfio_ap_mdev_reset_queue(q);
>  	dev_set_drvdata(&apdev->device, NULL);
>  	kfree(q);
>  	release_update_locks_for_mdev(matrix_mdev);

Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
