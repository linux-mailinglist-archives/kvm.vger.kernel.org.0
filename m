Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A18147FB44
	for <lists+kvm@lfdr.de>; Mon, 27 Dec 2021 10:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235766AbhL0JU4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Dec 2021 04:20:56 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45866 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235782AbhL0JUz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Dec 2021 04:20:55 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BR7g6Mp015656;
        Mon, 27 Dec 2021 09:20:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=tpVCY0hxGcX8bbe9vlEmxzC2+2nW3Mh/0+smp+YnQIA=;
 b=fDpbxRiI/9mPCiY1LeI6kBFxQrb2eCfcWSXC6oIlu0xloJK01FniPOvM/ejBTlA2Jw7F
 ptRH0bAnqk8uJJUM2Yx8UDfb9+ZV0//Y3EIVQCTSTyhOQq85fd10ZmYkfdaj6+fXiSke
 3POyXibmBSK10Z3CclAzn79N/iHe2HTje6gXoTsjIEUisqv0kpPuGsmav5Vpj9sHNRW9
 gZAj0EMHdQyTklB44tez5Vh7mBy+U8rZ4hWOwR1RjW8u85E736YDAEle+iWMku8eYdqL
 S7A2U+C/m6bKLBpBNswaiCXZK0+RFBn8UAKmvmOwlPtwklZS7s8RUnmuZ4XG50GAEXfP lQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3d79assjs8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Dec 2021 09:20:53 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BR94EKw001857;
        Mon, 27 Dec 2021 09:20:52 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3d79assjru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Dec 2021 09:20:52 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BR93jhd000474;
        Mon, 27 Dec 2021 09:06:49 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3d5tx98dhh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Dec 2021 09:06:49 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BR96jix46727510
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Dec 2021 09:06:45 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9146A4054;
        Mon, 27 Dec 2021 09:06:45 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 181D4A405C;
        Mon, 27 Dec 2021 09:06:45 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.90.67])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Mon, 27 Dec 2021 09:06:45 +0000 (GMT)
Date:   Mon, 27 Dec 2021 10:06:24 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v17 07/15] s390/vfio-ap: allow assignment of unavailable
 AP queues to mdev device
Message-ID: <20211227100624.6172bcb7.pasic@linux.ibm.com>
In-Reply-To: <20211021152332.70455-8-akrowiak@linux.ibm.com>
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
        <20211021152332.70455-8-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OO4gpJulci6OCK3AUdiI1F5zScxLj0cM
X-Proofpoint-ORIG-GUID: Ly386FdH8h-3N5XhR0dMQdopa9NxhYA6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-27_02,2021-12-24_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 spamscore=0 bulkscore=0
 adultscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112270045
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 Oct 2021 11:23:24 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> The current implementation does not allow assignment of an AP adapter or
> domain to an mdev device if each APQN resulting from the assignment
> does not reference an AP queue device that is bound to the vfio_ap device
> driver. This patch allows assignment of AP resources to the matrix mdev as
> long as the APQNs resulting from the assignment:
>    1. Are not reserved by the AP BUS for use by the zcrypt device drivers.
>    2. Are not assigned to another matrix mdev.
> 
> The rationale behind this is that the AP architecture does not preclude
> assignment of APQNs to an AP configuration profile that are not available
> to the system.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>

Reviewed-by: Halil Pasic <pasic@linux.ibm.com>

Looks good in isolation!


> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 224 +++++++-----------------------
>  1 file changed, 53 insertions(+), 171 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 46c179363aca..6b40db6dab3c 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -520,141 +520,48 @@ static struct attribute_group *vfio_ap_mdev_type_groups[] = {
>  	NULL,
>  };
>  
> -struct vfio_ap_queue_reserved {
> -	unsigned long *apid;
> -	unsigned long *apqi;
> -	bool reserved;
> -};
> +#define MDEV_SHARING_ERR "Userspace may not re-assign queue %02lx.%04lx " \
> +			 "already assigned to %s"
>  
> -/**
> - * vfio_ap_has_queue - determines if the AP queue containing the target in @data
> - *
> - * @dev: an AP queue device
> - * @data: a struct vfio_ap_queue_reserved reference
> - *
> - * Flags whether the AP queue device (@dev) has a queue ID containing the APQN,
> - * apid or apqi specified in @data:
> - *
> - * - If @data contains both an apid and apqi value, then @data will be flagged
> - *   as reserved if the APID and APQI fields for the AP queue device matches
> - *
> - * - If @data contains only an apid value, @data will be flagged as
> - *   reserved if the APID field in the AP queue device matches
> - *
> - * - If @data contains only an apqi value, @data will be flagged as
> - *   reserved if the APQI field in the AP queue device matches
> - *
> - * Return: 0 to indicate the input to function succeeded. Returns -EINVAL if
> - * @data does not contain either an apid or apqi.
> - */
> -static int vfio_ap_has_queue(struct device *dev, void *data)
> +static void vfio_ap_mdev_log_sharing_err(struct ap_matrix_mdev *matrix_mdev,
> +					 unsigned long *apm,
> +					 unsigned long *aqm)
>  {
> -	struct vfio_ap_queue_reserved *qres = data;
> -	struct ap_queue *ap_queue = to_ap_queue(dev);
> -	ap_qid_t qid;
> -	unsigned long id;
> -
> -	if (qres->apid && qres->apqi) {
> -		qid = AP_MKQID(*qres->apid, *qres->apqi);
> -		if (qid == ap_queue->qid)
> -			qres->reserved = true;
> -	} else if (qres->apid && !qres->apqi) {
> -		id = AP_QID_CARD(ap_queue->qid);
> -		if (id == *qres->apid)
> -			qres->reserved = true;
> -	} else if (!qres->apid && qres->apqi) {
> -		id = AP_QID_QUEUE(ap_queue->qid);
> -		if (id == *qres->apqi)
> -			qres->reserved = true;
> -	} else {
> -		return -EINVAL;
> -	}
> -
> -	return 0;
> -}
> -
> -/**
> - * vfio_ap_verify_queue_reserved - verifies that the AP queue containing
> - * @apid or @aqpi is reserved
> - *
> - * @apid: an AP adapter ID
> - * @apqi: an AP queue index
> - *
> - * Verifies that the AP queue with @apid/@apqi is reserved by the VFIO AP device
> - * driver according to the following rules:
> - *
> - * - If both @apid and @apqi are not NULL, then there must be an AP queue
> - *   device bound to the vfio_ap driver with the APQN identified by @apid and
> - *   @apqi
> - *
> - * - If only @apid is not NULL, then there must be an AP queue device bound
> - *   to the vfio_ap driver with an APQN containing @apid
> - *
> - * - If only @apqi is not NULL, then there must be an AP queue device bound
> - *   to the vfio_ap driver with an APQN containing @apqi
> - *
> - * Return: 0 if the AP queue is reserved; otherwise, returns -EADDRNOTAVAIL.
> - */
> -static int vfio_ap_verify_queue_reserved(unsigned long *apid,
> -					 unsigned long *apqi)
> -{
> -	int ret;
> -	struct vfio_ap_queue_reserved qres;
> -
> -	qres.apid = apid;
> -	qres.apqi = apqi;
> -	qres.reserved = false;
> -
> -	ret = driver_for_each_device(&matrix_dev->vfio_ap_drv->driver, NULL,
> -				     &qres, vfio_ap_has_queue);
> -	if (ret)
> -		return ret;
> -
> -	if (qres.reserved)
> -		return 0;
> -
> -	return -EADDRNOTAVAIL;
> -}
> -
> -static int
> -vfio_ap_mdev_verify_queues_reserved_for_apid(struct ap_matrix_mdev *matrix_mdev,
> -					     unsigned long apid)
> -{
> -	int ret;
> -	unsigned long apqi;
> -	unsigned long nbits = matrix_mdev->matrix.aqm_max + 1;
> -
> -	if (find_first_bit_inv(matrix_mdev->matrix.aqm, nbits) >= nbits)
> -		return vfio_ap_verify_queue_reserved(&apid, NULL);
> -
> -	for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, nbits) {
> -		ret = vfio_ap_verify_queue_reserved(&apid, &apqi);
> -		if (ret)
> -			return ret;
> -	}
> +	unsigned long apid, apqi;
> +	const struct device *dev = mdev_dev(matrix_mdev->mdev);
> +	const char *mdev_name = dev_name(dev);
>  
> -	return 0;
> +	for_each_set_bit_inv(apid, apm, AP_DEVICES)
> +		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS)
> +			dev_warn(dev, MDEV_SHARING_ERR, apid, apqi, mdev_name);
>  }
>  
>  /**
> - * vfio_ap_mdev_verify_no_sharing - verifies that the AP matrix is not configured
> + * vfio_ap_mdev_verify_no_sharing - verify APQNs are not shared by matrix mdevs
>   *
> - * @matrix_mdev: the mediated matrix device
> + * @mdev_apm: mask indicating the APIDs of the APQNs to be verified
> + * @mdev_aqm: mask indicating the APQIs of the APQNs to be verified
>   *
> - * Verifies that the APQNs derived from the cross product of the AP adapter IDs
> - * and AP queue indexes comprising the AP matrix are not configured for another
> + * Verifies that each APQN derived from the Cartesian product of a bitmap of
> + * AP adapter IDs and AP queue indexes is not configured for any matrix
>   * mediated device. AP queue sharing is not allowed.
>   *
> - * Return: 0 if the APQNs are not shared; otherwise returns -EADDRINUSE.
> + * Return: 0 if the APQNs are not shared; otherwise return -EADDRINUSE.
>   */
> -static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
> +static int vfio_ap_mdev_verify_no_sharing(unsigned long *mdev_apm,
> +					  unsigned long *mdev_aqm)
>  {
> -	struct ap_matrix_mdev *lstdev;
> +	struct ap_matrix_mdev *matrix_mdev;
>  	DECLARE_BITMAP(apm, AP_DEVICES);
>  	DECLARE_BITMAP(aqm, AP_DOMAINS);
>  
> -	list_for_each_entry(lstdev, &matrix_dev->mdev_list, node) {
> -		if (matrix_mdev == lstdev)
> +	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
> +		/*
> +		 * If the input apm and aqm belong to the matrix_mdev's matrix,
> +		 * then move on to the next.
> +		 */
> +		if (mdev_apm == matrix_mdev->matrix.apm &&
> +		    mdev_aqm == matrix_mdev->matrix.aqm)
>  			continue;
>  
>  		memset(apm, 0, sizeof(apm));
> @@ -664,20 +571,32 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
>  		 * We work on full longs, as we can only exclude the leftover
>  		 * bits in non-inverse order. The leftover is all zeros.
>  		 */
> -		if (!bitmap_and(apm, matrix_mdev->matrix.apm,
> -				lstdev->matrix.apm, AP_DEVICES))
> +		if (!bitmap_and(apm, mdev_apm, matrix_mdev->matrix.apm,
> +				AP_DEVICES))
>  			continue;
>  
> -		if (!bitmap_and(aqm, matrix_mdev->matrix.aqm,
> -				lstdev->matrix.aqm, AP_DOMAINS))
> +		if (!bitmap_and(aqm, mdev_aqm, matrix_mdev->matrix.aqm,
> +				AP_DOMAINS))
>  			continue;
>  
> +		vfio_ap_mdev_log_sharing_err(matrix_mdev, apm, aqm);
> +
>  		return -EADDRINUSE;
>  	}
>  
>  	return 0;
>  }
>  
> +static int vfio_ap_mdev_validate_masks(struct ap_matrix_mdev *matrix_mdev)
> +{
> +	if (ap_apqn_in_matrix_owned_by_def_drv(matrix_mdev->matrix.apm,
> +					       matrix_mdev->matrix.aqm))
> +		return -EADDRNOTAVAIL;
> +
> +	return vfio_ap_mdev_verify_no_sharing(matrix_mdev->matrix.apm,
> +					      matrix_mdev->matrix.aqm);
> +}
> +
>  static void vfio_ap_mdev_link_adapter(struct ap_matrix_mdev *matrix_mdev,
>  				      unsigned long apid)
>  {
> @@ -743,28 +662,17 @@ static ssize_t assign_adapter_store(struct device *dev,
>  		goto done;
>  	}
>  
> -	/*
> -	 * Set the bit in the AP mask (APM) corresponding to the AP adapter
> -	 * number (APID). The bits in the mask, from most significant to least
> -	 * significant bit, correspond to APIDs 0-255.
> -	 */
> -	ret = vfio_ap_mdev_verify_queues_reserved_for_apid(matrix_mdev, apid);
> -	if (ret)
> -		goto done;
> -
>  	set_bit_inv(apid, matrix_mdev->matrix.apm);
>  
> -	ret = vfio_ap_mdev_verify_no_sharing(matrix_mdev);
> -	if (ret)
> -		goto share_err;
> +	ret = vfio_ap_mdev_validate_masks(matrix_mdev);
> +	if (ret) {
> +		clear_bit_inv(apid, matrix_mdev->matrix.apm);
> +		goto done;
> +	}
>  
>  	vfio_ap_mdev_link_adapter(matrix_mdev, apid);
>  	vfio_ap_mdev_filter_matrix(matrix_mdev);
>  	ret = count;
> -	goto done;
> -
> -share_err:
> -	clear_bit_inv(apid, matrix_mdev->matrix.apm);
>  done:
>  	mutex_unlock(&matrix_dev->lock);
>  
> @@ -836,26 +744,6 @@ static ssize_t unassign_adapter_store(struct device *dev,
>  }
>  static DEVICE_ATTR_WO(unassign_adapter);
>  
> -static int
> -vfio_ap_mdev_verify_queues_reserved_for_apqi(struct ap_matrix_mdev *matrix_mdev,
> -					     unsigned long apqi)
> -{
> -	int ret;
> -	unsigned long apid;
> -	unsigned long nbits = matrix_mdev->matrix.apm_max + 1;
> -
> -	if (find_first_bit_inv(matrix_mdev->matrix.apm, nbits) >= nbits)
> -		return vfio_ap_verify_queue_reserved(NULL, &apqi);
> -
> -	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, nbits) {
> -		ret = vfio_ap_verify_queue_reserved(&apid, &apqi);
> -		if (ret)
> -			return ret;
> -	}
> -
> -	return 0;
> -}
> -
>  static void vfio_ap_mdev_link_domain(struct ap_matrix_mdev *matrix_mdev,
>  				      unsigned long apqi)
>  {
> @@ -921,23 +809,17 @@ static ssize_t assign_domain_store(struct device *dev,
>  		goto done;
>  	}
>  
> -	ret = vfio_ap_mdev_verify_queues_reserved_for_apqi(matrix_mdev, apqi);
> -	if (ret)
> -		goto done;
> -
>  	set_bit_inv(apqi, matrix_mdev->matrix.aqm);
>  
> -	ret = vfio_ap_mdev_verify_no_sharing(matrix_mdev);
> -	if (ret)
> -		goto share_err;
> +	ret = vfio_ap_mdev_validate_masks(matrix_mdev);
> +	if (ret) {
> +		clear_bit_inv(apqi, matrix_mdev->matrix.aqm);
> +		goto done;
> +	}
>  
>  	vfio_ap_mdev_link_domain(matrix_mdev, apqi);
>  	vfio_ap_mdev_filter_matrix(matrix_mdev);
>  	ret = count;
> -	goto done;
> -
> -share_err:
> -	clear_bit_inv(apqi, matrix_mdev->matrix.aqm);
>  done:
>  	mutex_unlock(&matrix_dev->lock);
>  

