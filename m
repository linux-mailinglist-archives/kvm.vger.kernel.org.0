Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD222F2554
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 02:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731769AbhALBNo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 20:13:44 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35036 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727431AbhALBNo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Jan 2021 20:13:44 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10C12lUB168955;
        Mon, 11 Jan 2021 20:13:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=3LwHQ2a62to3Rpp1pJDf1ogYH/XXy1VhN0j1I1YUKwY=;
 b=O0SDdpKhfBc9KjFl37rUd38MeGWb0E5eH+BNT6iaOGKF5W+tGIkRTXDCZJygfTmuUGqE
 YEl2zKTg1CNYgG+V9qUkFrSffkc3t+iLrIQ6QmenNCgOvFBRbGKLM4G5tHwFsHYytwaK
 Mtn1HUuPy/bGW1eZFVPrjv9GO16OTbnHO4tlCwUFKIcAWzqC//ewYF53GnpGcB9A5oxi
 e21OqoLQifre/FtmcuRm5QVhD1CAmi618QAs0pfsmPGATRPYCZn9f1ARlanhapHg0ynP
 XetkjXitQGpGJUOI4sr5YIto3+Uq0RScSnafk8ng72R6DZROKbbcybO6B953b90MJOAg /g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3610vbhega-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 20:13:00 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10C12riW169191;
        Mon, 11 Jan 2021 20:13:00 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3610vbhefb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 20:13:00 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10C0wbJk001792;
        Tue, 12 Jan 2021 01:12:57 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 35ydrdahnr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 01:12:57 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10C1CsvF43909576
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 01:12:54 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D73452059;
        Tue, 12 Jan 2021 01:12:54 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.92.32])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id CAC6052057;
        Tue, 12 Jan 2021 01:12:53 +0000 (GMT)
Date:   Tue, 12 Jan 2021 02:12:51 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v13 09/15] s390/vfio-ap: allow hot plug/unplug of AP
 resources using mdev device
Message-ID: <20210112021251.0d989225.pasic@linux.ibm.com>
In-Reply-To: <20201223011606.5265-10-akrowiak@linux.ibm.com>
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
        <20201223011606.5265-10-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_34:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 spamscore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120000
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Dec 2020 20:16:00 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> Let's allow adapters, domains and control domains to be hot plugged into
> and hot unplugged from a KVM guest using a matrix mdev when:
> 
> * The adapter, domain or control domain is assigned to or unassigned from
>   the matrix mdev
> 
> * A queue device with an APQN assigned to the matrix mdev is bound to or
>   unbound from the vfio_ap device driver.
> 
> Whenever an assignment or unassignment of an adapter, domain or control
> domain is performed as well as when a bind or unbind of a queue device
> is executed, the AP control block (APCB) that supplies the AP configuration
> to a guest is first refreshed. The APCB is refreshed by copying the AP
> configuration from the mdev's matrix to the APCB, then filtering the
> APCB according to the following rules:
> 
> * The APID of each adapter and the APQI of each domain that is not in the
>   host's AP configuration is filtered out.
> 
> * The APID of each adapter comprising an APQN that does not reference a
>   queue device bound to the vfio_ap device driver is filtered. The APQNs
>   are derived from the Cartesian product of the APID of each adapter and
>   APQI of each domain assigned to the mdev's matrix.
> 
> After refreshing the APCB, if the mdev is in use by a KVM guest, it is
> hot plugged into the guest to provide access to dynamically provide
> access to the adapters, domains and control domains provided via the
> newly refreshed APCB.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 143 ++++++++++++++++++++++++------
>  1 file changed, 118 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 1b1d5975ee0e..843862c88379 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -307,6 +307,88 @@ static void vfio_ap_mdev_commit_shadow_apcb(struct ap_matrix_mdev *matrix_mdev)
>  					  matrix_mdev->shadow_apcb.adm);
>  }
>  
> +static void vfio_ap_mdev_filter_apcb(struct ap_matrix_mdev *matrix_mdev,
> +				     struct ap_matrix *shadow_apcb)
> +{
> +	int ret;
> +	unsigned long apid, apqi, apqn;
> +
> +	ret = ap_qci(&matrix_dev->info);

Here we do the qci ourselves, thus the view of vfio_ap and the view
of the ap bus may be different.

> +	if (ret)
> +		return;
> +
> +	memcpy(shadow_apcb, &matrix_mdev->matrix, sizeof(struct ap_matrix));
> +

Why is this memcpy necessary...

> +	/*
> +	 * Copy the adapters, domains and control domains to the shadow_apcb
> +	 * from the matrix mdev, but only those that are assigned to the host's
> +	 * AP configuration.
> +	 */
> +	bitmap_and(shadow_apcb->apm, matrix_mdev->matrix.apm,
> +		   (unsigned long *)matrix_dev->info.apm, AP_DEVICES);
> +	bitmap_and(shadow_apcb->aqm, matrix_mdev->matrix.aqm,
> +		   (unsigned long *)matrix_dev->info.aqm, AP_DOMAINS);
> +	bitmap_and(shadow_apcb->adm, matrix_mdev->matrix.adm,
> +		   (unsigned long *)matrix_dev->info.adm, AP_DOMAINS);

... aren't you overwriting shadow_apcb here anyway?

> +
> +	/* If there are no APQNs assigned, then filtering them be unnecessary */
> +	if (bitmap_empty(shadow_apcb->apm, AP_DEVICES)) {
> +		if (!bitmap_empty(shadow_apcb->aqm, AP_DOMAINS))
> +			bitmap_clear(shadow_apcb->aqm, 0, AP_DOMAINS);
> +		return;
> +	} else if (bitmap_empty(shadow_apcb->aqm, AP_DOMAINS)) {
> +		if (!bitmap_empty(shadow_apcb->apm, AP_DEVICES))
> +			bitmap_clear(shadow_apcb->apm, 0, AP_DEVICES);
> +		return;
> +	}
> +

I complained about this before. I still don't understand why do we need
this, but I'm willing to accept it, unless it breaks something later.

BTW I don't think you have to re examine shadow->a[pq]m to tell if empty,
bitmap_and already told you that.

> +	for_each_set_bit_inv(apid, shadow_apcb->apm, AP_DEVICES) {
> +		for_each_set_bit_inv(apqi, shadow_apcb->aqm, AP_DOMAINS) {
> +			/*
> +			 * If the APQN is not bound to the vfio_ap device
> +			 * driver, then we can't assign it to the guest's
> +			 * AP configuration. The AP architecture won't
> +			 * allow filtering of a single APQN, so if we're
> +			 * filtering APIDs, then filter the APID; otherwise,
> +			 * filter the APQI.
> +			 */
> +			apqn = AP_MKQID(apid, apqi);
> +			if (!vfio_ap_mdev_get_queue(matrix_mdev, apqn)) {
> +				clear_bit_inv(apid, shadow_apcb->apm);
> +				break;
> +			}
> +		}
> +	}
> +}
> +
> +/**
> + * vfio_ap_mdev_refresh_apcb
> + *
> + * Filter APQNs assigned to the matrix mdev that do not reference an AP queue
> + * device bound to the vfio_ap device driver.
> + *
> + * @matrix_mdev:  the matrix mdev whose AP configuration is to be filtered
> + * @shadow_apcb:  the shadow of the KVM guest's APCB (contains AP configuration
> + *		  for guest)
> + * @filter_apids: boolean value indicating whether the APQNs shall be filtered
> + *		  by APID (true) or by APQI (false).
> + *

The signature in the doc comment and of the function do not match.

Since none of the complains affects correctness, except maybe for the
qci suff:

Acked-by: Halil Pasic <pasic@linux.ibm.com>

If it's good enough for you, it's good enough for me.

> + * Returns the number of APQNs remaining after filtering is complete.
> + */
> +static void vfio_ap_mdev_refresh_apcb(struct ap_matrix_mdev *matrix_mdev)
> +{
> +	struct ap_matrix shadow_apcb;
> +
> +	vfio_ap_mdev_filter_apcb(matrix_mdev, &shadow_apcb);
> +
> +	if (memcmp(&shadow_apcb, &matrix_mdev->shadow_apcb,
> +		   sizeof(struct ap_matrix)) != 0) {
> +		memcpy(&matrix_mdev->shadow_apcb, &shadow_apcb,
> +		       sizeof(struct ap_matrix));
> +		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
> +	}
> +}
> +
>  static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
>  {
>  	struct ap_matrix_mdev *matrix_mdev;
> @@ -552,10 +634,6 @@ static ssize_t assign_adapter_store(struct device *dev,
>  	struct mdev_device *mdev = mdev_from_dev(dev);
>  	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>  
> -	/* If the guest is running, disallow assignment of adapter */
> -	if (matrix_mdev->kvm)
> -		return -EBUSY;
> -
>  	ret = kstrtoul(buf, 0, &apid);
>  	if (ret)
>  		return ret;
> @@ -577,6 +655,7 @@ static ssize_t assign_adapter_store(struct device *dev,
>  
>  	set_bit_inv(apid, matrix_mdev->matrix.apm);
>  	vfio_ap_mdev_link_adapter(matrix_mdev, apid);
> +	vfio_ap_mdev_refresh_apcb(matrix_mdev);
>  
>  	mutex_unlock(&matrix_dev->lock);
>  
> @@ -619,10 +698,6 @@ static ssize_t unassign_adapter_store(struct device *dev,
>  	struct mdev_device *mdev = mdev_from_dev(dev);
>  	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>  
> -	/* If the guest is running, disallow un-assignment of adapter */
> -	if (matrix_mdev->kvm)
> -		return -EBUSY;
> -
>  	ret = kstrtoul(buf, 0, &apid);
>  	if (ret)
>  		return ret;
> @@ -633,6 +708,8 @@ static ssize_t unassign_adapter_store(struct device *dev,
>  	mutex_lock(&matrix_dev->lock);
>  	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
>  	vfio_ap_mdev_unlink_adapter(matrix_mdev, apid);
> +	vfio_ap_mdev_refresh_apcb(matrix_mdev);
> +
>  	mutex_unlock(&matrix_dev->lock);
>  
>  	return count;
> @@ -691,10 +768,6 @@ static ssize_t assign_domain_store(struct device *dev,
>  	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>  	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
>  
> -	/* If the guest is running, disallow assignment of domain */
> -	if (matrix_mdev->kvm)
> -		return -EBUSY;
> -
>  	ret = kstrtoul(buf, 0, &apqi);
>  	if (ret)
>  		return ret;
> @@ -715,6 +788,7 @@ static ssize_t assign_domain_store(struct device *dev,
>  
>  	set_bit_inv(apqi, matrix_mdev->matrix.aqm);
>  	vfio_ap_mdev_link_domain(matrix_mdev, apqi);
> +	vfio_ap_mdev_refresh_apcb(matrix_mdev);
>  
>  	mutex_unlock(&matrix_dev->lock);
>  
> @@ -757,10 +831,6 @@ static ssize_t unassign_domain_store(struct device *dev,
>  	struct mdev_device *mdev = mdev_from_dev(dev);
>  	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>  
> -	/* If the guest is running, disallow un-assignment of domain */
> -	if (matrix_mdev->kvm)
> -		return -EBUSY;
> -
>  	ret = kstrtoul(buf, 0, &apqi);
>  	if (ret)
>  		return ret;
> @@ -771,12 +841,24 @@ static ssize_t unassign_domain_store(struct device *dev,
>  	mutex_lock(&matrix_dev->lock);
>  	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
>  	vfio_ap_mdev_unlink_domain(matrix_mdev, apqi);
> +	vfio_ap_mdev_refresh_apcb(matrix_mdev);
> +
>  	mutex_unlock(&matrix_dev->lock);
>  
>  	return count;
>  }
>  static DEVICE_ATTR_WO(unassign_domain);
>  
> +static void vfio_ap_mdev_hot_plug_cdom(struct ap_matrix_mdev *matrix_mdev,
> +				       unsigned long domid)
> +{
> +	if (!test_bit_inv(domid, matrix_mdev->shadow_apcb.adm) &&
> +	    test_bit_inv(domid, (unsigned long *) matrix_dev->info.adm)) {
> +		set_bit_inv(domid, matrix_mdev->shadow_apcb.adm);
> +		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
> +	}
> +}
> +
>  /**
>   * assign_control_domain_store
>   *
> @@ -802,10 +884,6 @@ static ssize_t assign_control_domain_store(struct device *dev,
>  	struct mdev_device *mdev = mdev_from_dev(dev);
>  	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>  
> -	/* If the guest is running, disallow assignment of control domain */
> -	if (matrix_mdev->kvm)
> -		return -EBUSY;
> -
>  	ret = kstrtoul(buf, 0, &id);
>  	if (ret)
>  		return ret;
> @@ -820,12 +898,22 @@ static ssize_t assign_control_domain_store(struct device *dev,
>  	 */
>  	mutex_lock(&matrix_dev->lock);
>  	set_bit_inv(id, matrix_mdev->matrix.adm);
> +	vfio_ap_mdev_hot_plug_cdom(matrix_mdev, id);
>  	mutex_unlock(&matrix_dev->lock);
>  
>  	return count;
>  }
>  static DEVICE_ATTR_WO(assign_control_domain);
>  
> +static void vfio_ap_mdev_hot_unplug_cdom(struct ap_matrix_mdev *matrix_mdev,
> +					unsigned long domid)
> +{
> +	if (test_bit_inv(domid, matrix_mdev->shadow_apcb.adm)) {
> +		clear_bit_inv(domid, matrix_mdev->shadow_apcb.adm);
> +		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
> +	}
> +}
> +
>  /**
>   * unassign_control_domain_store
>   *
> @@ -852,10 +940,6 @@ static ssize_t unassign_control_domain_store(struct device *dev,
>  	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>  	unsigned long max_domid =  matrix_mdev->matrix.adm_max;
>  
> -	/* If the guest is running, disallow un-assignment of control domain */
> -	if (matrix_mdev->kvm)
> -		return -EBUSY;
> -
>  	ret = kstrtoul(buf, 0, &domid);
>  	if (ret)
>  		return ret;
> @@ -864,6 +948,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
>  
>  	mutex_lock(&matrix_dev->lock);
>  	clear_bit_inv(domid, matrix_mdev->matrix.adm);
> +	vfio_ap_mdev_hot_unplug_cdom(matrix_mdev, domid);
>  	mutex_unlock(&matrix_dev->lock);
>  
>  	return count;
> @@ -1089,6 +1174,8 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>  				  matrix_mdev->matrix.aqm,
>  				  matrix_mdev->matrix.adm);
>  
> +	vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
> +
>  notify_done:
>  	mutex_unlock(&matrix_dev->lock);
>  	return notify_rc;
> @@ -1330,6 +1417,8 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
>  	q->apqn = to_ap_queue(&apdev->device)->qid;
>  	q->saved_isc = VFIO_AP_ISC_INVALID;
>  	vfio_ap_queue_link_mdev(q);
> +	if (q->matrix_mdev)
> +		vfio_ap_mdev_refresh_apcb(q->matrix_mdev);
>  	mutex_unlock(&matrix_dev->lock);
>  
>  	return 0;
> @@ -1337,6 +1426,7 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
>  
>  void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
>  {
> +	struct ap_matrix_mdev *matrix_mdev;
>  	struct vfio_ap_queue *q;
>  	int apid, apqi;
>  
> @@ -1347,8 +1437,11 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
>  	apqi = AP_QID_QUEUE(q->apqn);
>  	vfio_ap_mdev_reset_queue(apid, apqi, 1);
>  
> -	if (q->matrix_mdev)
> +	if (q->matrix_mdev) {
> +		matrix_mdev = q->matrix_mdev;
>  		vfio_ap_mdev_unlink_queue(q);
> +		vfio_ap_mdev_refresh_apcb(matrix_mdev);
> +	}
>  
>  	kfree(q);
>  	mutex_unlock(&matrix_dev->lock);

