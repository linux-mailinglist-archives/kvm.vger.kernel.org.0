Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639AE53AE26
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 22:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiFAUmx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 16:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiFAUml (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 16:42:41 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19419205D6;
        Wed,  1 Jun 2022 13:24:32 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251IlkkC003358;
        Wed, 1 Jun 2022 18:55:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : reply-to : subject : to : cc : references : from :
 in-reply-to : content-type : content-transfer-encoding; s=pp1;
 bh=XVzw2mc3iz5xfz497XqXBFZCHB9CzJ9ZhmWL6Mw3CVY=;
 b=EqiBpEWWu9GGylszK9QleINctTXoLKf26H0RI7357ln6YJLAIkJlOoor5JauGb7tiLAn
 pSPSErvIIz68OPVr48gEC1erQYfd33FQSpTIlEb+Y21Z0E4LYBXaaKVebe6F1Os89Ljk
 FV3ko/PsVjcsSkFRlYnwsI8Cl5GAHb9ynKUj9ugdIG3IQJYhh4JKxLL/ueR2stOiwTyR
 j1fdBzjFhAez+KNy7X+SxYqVHoIfhnUXrKQY27RLPk/is+OpF9h7Pe1z+GrzoNfr+QR4
 rijBFbEZKPF4/hbY4ll45pYZHscC1U3QI4kMJEmtSDOCWBpvP8KXDuBvlNDR0Y6ttkea Yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gedq0r5g7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 18:55:16 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 251IrWIa019785;
        Wed, 1 Jun 2022 18:55:15 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gedq0r5fw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 18:55:15 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 251IojXG009833;
        Wed, 1 Jun 2022 18:55:15 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04wdc.us.ibm.com with ESMTP id 3gbc7fwgsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 18:55:15 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 251ItE6564356636
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Jun 2022 18:55:14 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CB9FAE064;
        Wed,  1 Jun 2022 18:55:14 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89BF7AE063;
        Wed,  1 Jun 2022 18:55:13 +0000 (GMT)
Received: from [9.65.239.109] (unknown [9.65.239.109])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  1 Jun 2022 18:55:13 +0000 (GMT)
Message-ID: <74c3707f-8e80-d924-00f5-7f163ab0bbc2@linux.ibm.com>
Date:   Wed, 1 Jun 2022 14:55:13 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Reply-To: jjherne@linux.ibm.com
Subject: Re: [PATCH v19 13/20] s390/vfio-ap: hot plug/unplug of AP devices
 when probed/removed
Content-Language: en-US
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
 <20220404221039.1272245-14-akrowiak@linux.ibm.com>
From:   "Jason J. Herne" <jjherne@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220404221039.1272245-14-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kjsRUZU92s9o1PKSeEti_evaqoFtXus3
X-Proofpoint-GUID: J4dnQuZ-Tdye_-lbCgPO1tRWWSmlk-o6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-01_07,2022-06-01_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 clxscore=1015 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206010077
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/4/22 18:10, Tony Krowiak wrote:
> When an AP queue device is probed or removed, if the mediated device is
> attached to a KVM guest, the mediated device's adapter, domain and
> control domain bitmaps must be filtered to update the guest's APCB and if
> any changes are detected, the guest's APCB must then be hot plugged into
> the guest to reflect those changes to the guest.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 23 +++++++++++++++++------
>   1 file changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 47f808122ed2..ec5f37d726ec 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1752,9 +1752,11 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
>   		vfio_ap_mdev_link_queue(matrix_mdev, q);
>   		memset(apm_delta, 0, sizeof(apm_delta));
>   		set_bit_inv(AP_QID_CARD(q->apqn), apm_delta);
> -		vfio_ap_mdev_filter_matrix(apm_delta,
> -					   matrix_mdev->matrix.aqm,
> -					   matrix_mdev);
> +
> +		if (vfio_ap_mdev_filter_matrix(apm_delta,
> +					       matrix_mdev->matrix.aqm,
> +					       matrix_mdev))
> +			vfio_ap_mdev_update_guest_apcb(matrix_mdev);
>   	}
>   	dev_set_drvdata(&apdev->device, q);
>   	release_update_locks_for_mdev(matrix_mdev);
> @@ -1764,7 +1766,7 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
>   
>   void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
>   {
> -	unsigned long apid;
> +	unsigned long apid, apqi;
>   	struct vfio_ap_queue *q;
>   	struct ap_matrix_mdev *matrix_mdev;
>   
> @@ -1776,8 +1778,17 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
>   		vfio_ap_unlink_queue_fr_mdev(q);
>   
>   		apid = AP_QID_CARD(q->apqn);
> -		if (test_bit_inv(apid, q->matrix_mdev->shadow_apcb.apm))
> -			clear_bit_inv(apid, q->matrix_mdev->shadow_apcb.apm);
> +		apqi = AP_QID_QUEUE(q->apqn);
> +
> +		/*
> +		 * If the queue is assigned to the guest's APCB, then remove
> +		 * the adapter's APID from the APCB and hot it into the guest.
> +		 */
> +		if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
> +		    test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm)) {
> +			clear_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
> +			vfio_ap_mdev_update_guest_apcb(matrix_mdev);
> +		}
>   	}
>   
>   	vfio_ap_mdev_reset_queue(q, 1);

Also seems sane.

Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
