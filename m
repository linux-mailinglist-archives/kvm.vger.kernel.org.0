Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33CD764D9D6
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 11:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiLOK46 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 05:56:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiLOK4t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 05:56:49 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03154BD1;
        Thu, 15 Dec 2022 02:56:49 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFAnJt4029581;
        Thu, 15 Dec 2022 10:56:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : reply-to : in-reply-to : references :
 message-id : content-type : content-transfer-encoding; s=pp1;
 bh=7ZEo+pYgTuXyDz3TLH/RV2hhT7CIBEQx3Y5iWUHBhz8=;
 b=TPmcUsxHa3VXJW+DordRuu9aRMeHujJsXIclSLwxKQd2pYnmS5VfUVhslJDQgc+nX1d8
 axQlEP3zuH6CTeTcvkkvVYeJx51ho4Hk7XeP/nZ0jCMHXH8OdLTSZxOSzd/AObihR/Ct
 qp1lg4Hg9wR0rlimMB9KuJtSxU5W+U0IWCcYNPFHrgxEiVJQ+y6txU6VHBSeq/e8ILFf
 dNvWfLPlxxDQnttfpfFOQA2tCL7rAWWOwR69EHuif+FjeVy+j/pnWcY/w7nSJP/mZv69
 ofTY81kwqUO0JhNUcPsHBghRklCoQoE02PoVjQyYl4hRV2umHnjVbo4T4R9oC9WVJNCX VA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mg25u05xy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 10:56:46 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BFAnxtU030841;
        Thu, 15 Dec 2022 10:56:46 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mg25u05xc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 10:56:46 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BF8KLen006703;
        Thu, 15 Dec 2022 10:56:44 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([9.208.129.119])
        by ppma03wdc.us.ibm.com (PPS) with ESMTPS id 3mf08ete04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 10:56:44 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
        by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BFAug0g34341178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 10:56:42 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8285658059;
        Thu, 15 Dec 2022 10:56:42 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F17AD58043;
        Thu, 15 Dec 2022 10:56:41 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 15 Dec 2022 10:56:41 +0000 (GMT)
MIME-Version: 1.0
Date:   Thu, 15 Dec 2022 11:56:41 +0100
From:   Harald Freudenberger <freude@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
Subject: Re: [PATCH 5/7] s390/vfio_ap: fix handling of error response codes
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <20221213154437.15480-6-akrowiak@linux.ibm.com>
References: <20221213154437.15480-1-akrowiak@linux.ibm.com>
 <20221213154437.15480-6-akrowiak@linux.ibm.com>
Message-ID: <14c13db623907f41fae355c225db08b9@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 659lW8quFXR06BZJxkXcLO8PXf_oJrzQ
X-Proofpoint-ORIG-GUID: OYSUfh3uRhFM0lXL9bTFhF4lTMRatDe7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_05,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 mlxscore=0 phishscore=0
 clxscore=1015 spamscore=0 malwarescore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212150082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-12-13 16:44, Tony Krowiak wrote:
> Some response codes returned from the queue reset function are not 
> being
> handled correctly; this patch fixes them:
> 
> 1. Response code 3, AP queue deconfigured: Deconfiguring an AP adapter
>    resets all of its queues, so this is handled by indicating the reset
>    verification completed successfully.
> 
> 2. For all response codes other than 0 (normal reset completion), 2
>    (queue reset in progress) and 3 (AP deconfigured), the -EIO error 
> will
>    be returned from the vfio_ap_mdev_reset_queue() function. In all 
> cases,
>    all fields of the status word other than the response code will be
>    set to zero, so it makes no sense to check status bits.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c
> b/drivers/s390/crypto/vfio_ap_ops.c
> index c0cf5050be59..dbf681715a6d 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1659,17 +1659,15 @@ static int vfio_ap_mdev_reset_queue(struct
> vfio_ap_queue *q)
>  		if (ret)
>  			break;
>  		goto retry_zapq;
> -	case AP_RESPONSE_Q_NOT_AVAIL:
>  	case AP_RESPONSE_DECONFIGURED:
> -	case AP_RESPONSE_CHECKSTOPPED:
> -		WARN_ONCE(status.irq_enabled,
> -			  "PQAP/ZAPQ for %02x.%04x failed with rc=%u while IRQ enabled",
> -			  AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
> -			  status.response_code);
> -		ret = -EBUSY;
> -		goto free_resources;
> +		/*
> +		 * When an AP adapter is deconfigured, the associated
> +		 * queues are reset, so let's return a value indicating the reset
> +		 * completed successfully.
> +		 */
> +		ret = 0;
> +		break;
>  	default:
> -		/* things are really broken, give up */
>  		WARN(true,
>  		     "PQAP/ZAPQ for %02x.%04x failed with invalid rc=%u\n",
>  		     AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
> @@ -1677,7 +1675,6 @@ static int vfio_ap_mdev_reset_queue(struct
> vfio_ap_queue *q)
>  		return -EIO;
>  	}
> 
> -free_resources:
>  	vfio_ap_free_aqic_resources(q);
> 
>  	return ret;

Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
