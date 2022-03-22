Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A879E4E3F39
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 14:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbiCVNPc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 09:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232654AbiCVNPa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 09:15:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2607658;
        Tue, 22 Mar 2022 06:13:59 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22MCj6TS004482;
        Tue, 22 Mar 2022 13:13:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : reply-to : subject : to : cc : references : from :
 in-reply-to : content-type : content-transfer-encoding; s=pp1;
 bh=xjxaDX+U9M+staFNkzAVXPnKdxOrbMAiXb/+c8xLBUY=;
 b=r66eQHtNoHa+1U1j8Wvf9eg+Ob3XEf514e6Y7xKzjf+5Hn/raiwmRqKvRiN5mW4DW9Vz
 HVk5R2MMXxPkc3IQrZf1ERnfVwrf2WR3/j50dmiwtMQw7I7decAKEEw74XjABYaeZLPq
 /E5Bwf/Lj5eRGfFrr1bZzDl18wrWR8AIQwquLogHoZLqoe+Atws/f/LgA3G9gsn2H9c9
 Lq/hMbgXyTpgTrLh/YrFwMC/wRuKvlO4bsb6Njlk4B9Qgq9fr+UEeZw83q7izO2snBTb
 LZ8u7vc1pmotuUmFCYOG5g/3I9TT1FClNqmNAIY1we4r3sAYzQvEOqd8RR9oqUmztWDS uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ey86ushdf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 13:13:56 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22MCiTR0008046;
        Tue, 22 Mar 2022 13:13:55 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ey86ushcu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 13:13:55 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22MD9NvA004655;
        Tue, 22 Mar 2022 13:13:54 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma05wdc.us.ibm.com with ESMTP id 3ew6t9m77n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 13:13:54 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22MDDrpa29295032
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Mar 2022 13:13:53 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0849AC6065;
        Tue, 22 Mar 2022 13:13:53 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 045AEC605F;
        Tue, 22 Mar 2022 13:13:52 +0000 (GMT)
Received: from [9.160.96.60] (unknown [9.160.96.60])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 22 Mar 2022 13:13:51 +0000 (GMT)
Message-ID: <37e98e6e-35a7-a77a-b057-e19b307c631a@linux.ibm.com>
Date:   Tue, 22 Mar 2022 09:13:46 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Reply-To: jjherne@linux.ibm.com
Subject: Re: [PATCH v18 13/18] s390/vfio-ap: implement in-use callback for
 vfio_ap driver
Content-Language: en-US
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
 <20220215005040.52697-14-akrowiak@linux.ibm.com>
From:   "Jason J. Herne" <jjherne@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220215005040.52697-14-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2jjexNIGoZjr50NhdxyhNQkPkukiXnTw
X-Proofpoint-ORIG-GUID: B99ljwQB9kIPamZP-hl53GU3KH4BDYWr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-22_04,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203220076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/14/22 19:50, Tony Krowiak wrote:
...
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index e9f7ec6fc6a5..63dfb9b89581 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -617,10 +617,32 @@ static int vfio_ap_mdev_verify_no_sharing(unsigned long *mdev_apm,
>   	return 0;
>   }
>   
> +/**
> + * vfio_ap_mdev_validate_masks - verify that the APQNs assigned to the mdev are
> + *				 not reserved for the default zcrypt driver and
> + *				 are not assigned to another mdev.
> + *
> + * @matrix_mdev: the mdev to which the APQNs being validated are assigned.
> + *
> + * Return: One of the following values:
> + * o the error returned from the ap_apqn_in_matrix_owned_by_def_drv() function,
> + *   most likely -EBUSY indicating the ap_perms_mutex lock is already held.
> + * o EADDRNOTAVAIL if an APQN assigned to @matrix_mdev is reserved for the
> + *		   zcrypt default driver.
> + * o EADDRINUSE if an APQN assigned to @matrix_mdev is assigned to another mdev
> + * o A zero indicating validation succeeded.
> + */
>   static int vfio_ap_mdev_validate_masks(struct ap_matrix_mdev *matrix_mdev)
>   {
> -	if (ap_apqn_in_matrix_owned_by_def_drv(matrix_mdev->matrix.apm,
> -					       matrix_mdev->matrix.aqm))
> +	int ret;
> +
> +	ret = ap_apqn_in_matrix_owned_by_def_drv(matrix_mdev->matrix.apm,
> +						 matrix_mdev->matrix.aqm);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	if (ret == 1)
>   		return -EADDRNOTAVAIL;

I took a look at ap_apqn_in_matrix_owned_by_def_drv(). It appears that this function
can only ever return 0 or 1. This patch is changed to watch for a negative return
value from ap_apqn_in_matrix_owned_by_def_drv(). Am I missing something?


-- 
-- Jason J. Herne (jjherne@linux.ibm.com)
