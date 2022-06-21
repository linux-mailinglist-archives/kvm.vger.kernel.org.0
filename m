Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4A3553B17
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 22:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354272AbiFUUCh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 16:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354258AbiFUUCc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 16:02:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3782E6A4;
        Tue, 21 Jun 2022 13:02:30 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LJnQ0I003552;
        Tue, 21 Jun 2022 20:02:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : reply-to : subject : to : cc : references : from :
 in-reply-to : content-type : content-transfer-encoding; s=pp1;
 bh=pfxcZSsoPi5cw9m2IH90wKecDF7Rlb7JHG8CGniqYac=;
 b=jGORnNiDUUakgYQBPboY/jhQrxRBNM7uqTPBsYdoy9o17U0yvqD/uuddtnF+La/ZHuPq
 uaKPlaCNr61oa+y9egwBN40Hug0eHGVkSZIrgupitit+I+7SdZKSMoQtdz8cnIosdapD
 eHSws5yQ80+KHQrztCruJqaXqdOxppsAOaTXJR5W6SOgshbYT+elk8zGhJyhoPGC/0k3
 l+GYAbKQZg1lWX8Rr1Luk9m1sqFnO5I2F6XmDGtGUjim2ewybLvek4yCEJ+n2XgBCDoM
 ywG/NeS2RW3+s5C5Z2Hocjpv0VSOoti5mH99eyyFRTlMSdDLJ1LApzMnWQAklgi7G+Yl ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gumfx8a8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 20:02:27 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25LK0BVJ026857;
        Tue, 21 Jun 2022 20:02:27 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gumfx8a8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 20:02:27 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25LJpca9020401;
        Tue, 21 Jun 2022 20:02:26 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03dal.us.ibm.com with ESMTP id 3gs6b9ks5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 20:02:26 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25LK2PWH30343610
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 20:02:25 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27A0A7805E;
        Tue, 21 Jun 2022 20:02:25 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C0AD7805C;
        Tue, 21 Jun 2022 20:02:24 +0000 (GMT)
Received: from [9.65.195.48] (unknown [9.65.195.48])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jun 2022 20:02:24 +0000 (GMT)
Message-ID: <99ddfadd-7aac-8f3c-9f07-ae2b66cf45cc@linux.ibm.com>
Date:   Tue, 21 Jun 2022 16:02:23 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Reply-To: jjherne@linux.ibm.com
Subject: Re: [PATCH v20 10/20] s390/vfio-ap: prepare for dynamic update of
 guest's APCB on assign/unassign
Content-Language: en-US
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
 <20220621155134.1932383-11-akrowiak@linux.ibm.com>
From:   "Jason J. Herne" <jjherne@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220621155134.1932383-11-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -7FjAaW-xR-C4CFN8cMC-7Z_TpebuISS
X-Proofpoint-ORIG-GUID: EL37Ui2BBz-IejNenEnPPWYKRX7onZZs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_09,2022-06-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 impostorscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206210083
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/21/22 11:51, Tony Krowiak wrote:
> The functions backing the matrix mdev's sysfs attribute interfaces to
> assign/unassign adapters, domains and control domains must take and
> release the locks required to perform a dynamic update of a guest's APCB
> in the proper order.
> 
> The proper order for taking the locks is:
> 
> matrix_dev->guests_lock => kvm->lock => matrix_dev->mdevs_lock
> 
> The proper order for releasing the locks is:
> 
> matrix_dev->mdevs_lock => kvm->lock => matrix_dev->guests_lock
> 
> Two new macros are introduced for this purpose: One to take the locks and
> the other to release the locks. These macros will be used by the
> assignment/unassignment functions to prepare for dynamic update of
> the KVM guest's APCB.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 69 +++++++++++++++++++++++++------
>   1 file changed, 57 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index f31db1248740..b8f901e6b580 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -75,6 +75,51 @@ static const struct vfio_device_ops vfio_ap_matrix_dev_ops;
>   	mutex_unlock(&matrix_dev->guests_lock);	\
>   })
>   
> +/**
> + * get_update_locks_for_mdev: Acquire the locks required to dynamically update a
> + *			      KVM guest's APCB in the proper order.
> + *
> + * @matrix_mdev: a pointer to a struct ap_matrix_mdev object containing the AP
> + *		 configuration data to use to update a KVM guest's APCB.
> + *
> + * The proper locking order is:
> + * 1. matrix_dev->guests_lock: required to use the KVM pointer to update a KVM
> + *			       guest's APCB.
> + * 2. matrix_mdev->kvm->lock:  required to update a guest's APCB
> + * 3. matrix_dev->mdevs_lock:  required to access data stored in a matrix_mdev
> + *
> + * Note: If @matrix_mdev is NULL or is not attached to a KVM guest, the KVM
> + *	 lock will not be taken.
> + */
> +#define get_update_locks_for_mdev(matrix_mdev) ({	\
> +	mutex_lock(&matrix_dev->guests_lock);		\
> +	if (matrix_mdev && matrix_mdev->kvm)		\
> +		mutex_lock(&matrix_mdev->kvm->lock);	\
> +	mutex_lock(&matrix_dev->mdevs_lock);		\
> +})
> +
> +/**
> + * release_update_locks_for_mdev: Release the locks used to dynamically update a
> + *				  KVM guest's APCB in the proper order.
> + *
> + * @matrix_mdev: a pointer to a struct ap_matrix_mdev object containing the AP
> + *		 configuration data to use to update a KVM guest's APCB.
> + *
> + * The proper unlocking order is:
> + * 1. matrix_dev->mdevs_lock
> + * 2. matrix_mdev->kvm->lock
> + * 3. matrix_dev->guests_lock
> + *
> + * Note: If @matrix_mdev is NULL or is not attached to a KVM guest, the KVM
> + *	 lock will not be released.
> + */
> +#define release_update_locks_for_mdev(matrix_mdev) ({	\
> +	mutex_unlock(&matrix_dev->mdevs_lock);		\
> +	if (matrix_mdev && matrix_mdev->kvm)		\
> +		mutex_unlock(&matrix_mdev->kvm->lock);		\
> +	mutex_unlock(&matrix_dev->guests_lock);		\
> +})
> +
>   /**
>    * vfio_ap_mdev_get_queue - retrieve a queue with a specific APQN from a
>    *			    hash table of queues assigned to a matrix mdev
> @@ -830,7 +875,7 @@ static ssize_t assign_adapter_store(struct device *dev,
>   
>   	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
>   
> -	mutex_lock(&matrix_dev->mdevs_lock);
> +	get_update_locks_for_mdev(matrix_mdev);
>   
>   	/* If the KVM guest is running, disallow assignment of adapter */
>   	if (matrix_mdev->kvm) {
> @@ -862,7 +907,7 @@ static ssize_t assign_adapter_store(struct device *dev,
>   				   matrix_mdev->matrix.aqm, matrix_mdev);
>   	ret = count;
>   done:
> -	mutex_unlock(&matrix_dev->mdevs_lock);
> +	release_update_locks_for_mdev(matrix_mdev);
>   
>   	return ret;
>   }
> @@ -905,7 +950,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
>   	unsigned long apid;
>   	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
>   
> -	mutex_lock(&matrix_dev->mdevs_lock);
> +	get_update_locks_for_mdev(matrix_mdev);
>   
>   	/* If the KVM guest is running, disallow unassignment of adapter */
>   	if (matrix_mdev->kvm) {
> @@ -930,7 +975,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
>   
>   	ret = count;
>   done:
> -	mutex_unlock(&matrix_dev->mdevs_lock);
> +	release_update_locks_for_mdev(matrix_mdev);
>   	return ret;
>   }
>   static DEVICE_ATTR_WO(unassign_adapter);
> @@ -985,7 +1030,7 @@ static ssize_t assign_domain_store(struct device *dev,
>   	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
>   	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
>   
> -	mutex_lock(&matrix_dev->mdevs_lock);
> +	get_update_locks_for_mdev(matrix_mdev);
>   
>   	/* If the KVM guest is running, disallow assignment of domain */
>   	if (matrix_mdev->kvm) {
> @@ -1016,7 +1061,7 @@ static ssize_t assign_domain_store(struct device *dev,
>   				   matrix_mdev);
>   	ret = count;
>   done:
> -	mutex_unlock(&matrix_dev->mdevs_lock);
> +	release_update_locks_for_mdev(matrix_mdev);
>   
>   	return ret;
>   }
> @@ -1059,7 +1104,7 @@ static ssize_t unassign_domain_store(struct device *dev,
>   	unsigned long apqi;
>   	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
>   
> -	mutex_lock(&matrix_dev->mdevs_lock);
> +	get_update_locks_for_mdev(matrix_mdev);
>   
>   	/* If the KVM guest is running, disallow unassignment of domain */
>   	if (matrix_mdev->kvm) {
> @@ -1085,7 +1130,7 @@ static ssize_t unassign_domain_store(struct device *dev,
>   	ret = count;
>   
>   done:
> -	mutex_unlock(&matrix_dev->mdevs_lock);
> +	release_update_locks_for_mdev(matrix_mdev);
>   	return ret;
>   }
>   static DEVICE_ATTR_WO(unassign_domain);
> @@ -1112,7 +1157,7 @@ static ssize_t assign_control_domain_store(struct device *dev,
>   	unsigned long id;
>   	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
>   
> -	mutex_lock(&matrix_dev->mdevs_lock);
> +	get_update_locks_for_mdev(matrix_mdev);
>   
>   	/* If the KVM guest is running, disallow assignment of control domain */
>   	if (matrix_mdev->kvm) {
> @@ -1138,7 +1183,7 @@ static ssize_t assign_control_domain_store(struct device *dev,
>   	vfio_ap_mdev_filter_cdoms(matrix_mdev);
>   	ret = count;
>   done:
> -	mutex_unlock(&matrix_dev->mdevs_lock);
> +	release_update_locks_for_mdev(matrix_mdev);
>   	return ret;
>   }
>   static DEVICE_ATTR_WO(assign_control_domain);
> @@ -1166,7 +1211,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
>   	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
>   	unsigned long max_domid =  matrix_mdev->matrix.adm_max;
>   
> -	mutex_lock(&matrix_dev->mdevs_lock);
> +	get_update_locks_for_mdev(matrix_mdev);
>   
>   	/* If a KVM guest is running, disallow unassignment of control domain */
>   	if (matrix_mdev->kvm) {
> @@ -1189,7 +1234,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
>   
>   	ret = count;
>   done:
> -	mutex_unlock(&matrix_dev->mdevs_lock);
> +	release_update_locks_for_mdev(matrix_mdev);
>   	return ret;
>   }
>   static DEVICE_ATTR_WO(unassign_control_domain);

Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>

-- 
-- Jason J. Herne (jjherne@linux.ibm.com)
