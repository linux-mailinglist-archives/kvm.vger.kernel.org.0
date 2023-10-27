Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D4D7D9165
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 10:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235085AbjJ0I0H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 04:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345539AbjJ0I0C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 04:26:02 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422891AD;
        Fri, 27 Oct 2023 01:25:59 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39R85X43005432;
        Fri, 27 Oct 2023 08:25:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : reply-to : in-reply-to : references :
 message-id : content-type : content-transfer-encoding; s=pp1;
 bh=Ydc/j18p3b7EHQ/VYDnN7DJ8GH9rECYSsKAj2yxuRrQ=;
 b=k66R5I553ezE4knFNEcqmh3oSuHjdXdaM3AV1isaoW7CI+h3BK+kPzpAIfH53POJxwH3
 NjcTuA+WbcO9n0ceR/qnTYltbHI5Ts25YeyqeIaq3e+Z7blpiqyyyiqkoYfGzFy1aMfX
 8AavoLfekBiyM+NqyJ2rbkNdYEVA4JERyQkOhGAhi/T2zM9DEE1DUG2023j6bIQSlSxH
 5ywAWepNFTaIib4UFh3nSdErfzUmVicq7ojh3T2wkp1WWVWx94Ox2p2QiTkCIAzIzn/u
 4rrTLBJ/ynUuviRDTUW132NDGcM+8wgKQuRvXwUkhur3kWf0mzapg3JJuD0NXldo97+F Lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u09cyrnmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Oct 2023 08:25:58 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39R85VFS005360;
        Fri, 27 Oct 2023 08:25:57 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u09cyrnkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Oct 2023 08:25:57 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39R7phEO021554;
        Fri, 27 Oct 2023 08:25:57 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tywqrbrbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Oct 2023 08:25:57 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
        by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39R8PtYd8651374
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Oct 2023 08:25:56 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B090058055;
        Fri, 27 Oct 2023 08:25:55 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C16225803F;
        Fri, 27 Oct 2023 08:25:54 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 27 Oct 2023 08:25:54 +0000 (GMT)
MIME-Version: 1.0
Date:   Fri, 27 Oct 2023 10:25:54 +0200
From:   Harald Freudenberger <freude@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, pasic@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, mjrosato@linux.ibm.com
Subject: Re: [PATCH v3 2/3] s390/vfio-ap: set status response code to 06 on
 gisc registration failure
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <20231026183250.254432-3-akrowiak@linux.ibm.com>
References: <20231026183250.254432-1-akrowiak@linux.ibm.com>
 <20231026183250.254432-3-akrowiak@linux.ibm.com>
Message-ID: <b1ef49cb13547f9c51e47534d3f18e2a@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WK9z_048pRAA6Uu47XJJisIS8aaRAfUM
X-Proofpoint-ORIG-GUID: CkPyB9-wDSfB82hIVAlCbVBQIlDjRrQf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-27_06,2023-10-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1011
 lowpriorityscore=0 adultscore=0 spamscore=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2310270071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-10-26 20:32, Tony Krowiak wrote:
> From: Anthony Krowiak <akrowiak@linux.ibm.com>
> 
> The interception handler for the PQAP(AQIC) command calls the
> kvm_s390_gisc_register function to register the guest ISC with the 
> channel
> subsystem. If that call fails, the status response code 08 - indicating
> Invalid ZONE/GISA designation - is returned to the guest. This response
> code does not make sense because the non-zero return code from the
> kvm_s390_gisc_register function can be due one of two things: Either 
> the
> ISC passed as a parameter by the guest to the PQAP(AQIC) command is 
> greater
> than the maximum ISC value allowed, or the guest is not using a GISA.
> 
> Since this scenario is very unlikely to happen and there is no status
> response code to indicate an invalid ISC value, let's set the
> response code to 06 indicating 'Invalid address of AP-queue 
> notification
> byte'. While this is not entirely accurate, it is better than 
> indicating
> that the ZONE/GISA designation is invalid which is something the guest
> can do nothing about since those values are set by the hypervisor.
> 
> Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
> Suggested-by: Halil Pasic <pasic@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c
> b/drivers/s390/crypto/vfio_ap_ops.c
> index 9cb28978c186..25d7ce2094f8 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -393,8 +393,8 @@ static int ensure_nib_shared(unsigned long addr,
> struct gmap *gmap)
>   * Register the guest ISC to GIB interface and retrieve the
>   * host ISC to issue the host side PQAP/AQIC
>   *
> - * Response.status may be set to AP_RESPONSE_INVALID_ADDRESS in case 
> the
> - * vfio_pin_pages failed.
> + * status.response_code may be set to AP_RESPONSE_INVALID_ADDRESS in 
> case the
> + * vfio_pin_pages or kvm_s390_gisc_register failed.
>   *
>   * Otherwise return the ap_queue_status returned by the ap_aqic(),
>   * all retry handling will be done by the guest.
> @@ -458,7 +458,7 @@ static struct ap_queue_status
> vfio_ap_irq_enable(struct vfio_ap_queue *q,
>  				 __func__, nisc, isc, q->apqn);
> 
>  		vfio_unpin_pages(&q->matrix_mdev->vdev, nib, 1);
> -		status.response_code = AP_RESPONSE_INVALID_GISA;
> +		status.response_code = AP_RESPONSE_INVALID_ADDRESS;
>  		return status;
>  	}

Interesting ... The INVALID_GISA is handled in the default arm of the 
switch
in ap_queue.c but the INVALID_ADDRESS is handled as irq enablement 
failed.
So this change fits more to the current AP bus code. Thanks

Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
