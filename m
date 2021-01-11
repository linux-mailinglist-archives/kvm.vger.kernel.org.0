Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD182F2421
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 01:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405520AbhALAZm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 19:25:42 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11626 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390860AbhAKW66 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Jan 2021 17:58:58 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10BMWTfE041235;
        Mon, 11 Jan 2021 17:58:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=rVjaQP4fgVvBR9iD7xY89CE8z2PPJLAcmFwF05lKHqw=;
 b=QDIyANZ+MldXGQlEl/oL3pED/IDwZPU32sHP7T1QRWczFK44WZSilYyJPqd9jzVXZS4N
 UWJClGNypmAg+2Fk4u4uhwS5DsPQLs2eN3Z6TvqnXknsAKsfxzVRqWwDXigxTOyj9vlN
 zLFNFwiIbrrP6S5WMxSsAcbKhEqOctFerBUaVrMuoTYPCtTcQbgQo6TcPg5x73S9Ku8P
 q2UdibJ332crpvNsviyvv+wjvkuETPQJJ9gK5HQIybJwxPDWwzO/O45AYbvxji4+yPV3
 ooFsJ7+QoJjjiYVi79pVJFEgJLcqJM/WwHORLYBo4Ton20UBGdBKuaf9KpRnQqN9LlCg 8A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 360y93rv9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 17:58:14 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10BMY6xv045482;
        Mon, 11 Jan 2021 17:58:14 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 360y93rv93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 17:58:14 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10BMqFre028522;
        Mon, 11 Jan 2021 22:58:12 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 35ydrdae63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 22:58:12 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10BMw9I745482492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Jan 2021 22:58:09 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90238A4051;
        Mon, 11 Jan 2021 22:58:09 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7BA7A4040;
        Mon, 11 Jan 2021 22:58:08 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.92.32])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Mon, 11 Jan 2021 22:58:08 +0000 (GMT)
Date:   Mon, 11 Jan 2021 23:58:06 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v13 08/15] s390/vfio-ap: sysfs attribute to display the
 guest's matrix
Message-ID: <20210111235806.5df42658.pasic@linux.ibm.com>
In-Reply-To: <20201223011606.5265-9-akrowiak@linux.ibm.com>
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
        <20201223011606.5265-9-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_32:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101110122
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Dec 2020 20:15:59 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> The matrix of adapters and domains configured in a guest's APCB may
> differ from the matrix of adapters and domains assigned to the matrix mdev,
> so this patch introduces a sysfs attribute to display the matrix of
> adapters and domains that are or will be assigned to the APCB of a guest
> that is or will be using the matrix mdev. For a matrix mdev denoted by
> $uuid, the guest matrix can be displayed as follows:
> 
>    cat /sys/devices/vfio_ap/matrix/$uuid/guest_matrix
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>

Reviewed-by: Halil Pasic <pasic@linux.ibm.com>

But because vfio_ap_mdev_commit_shadow_apcb() is not used (see prev
patch) the attribute won't show the guest matrix at this point. :(

> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 51 ++++++++++++++++++++++---------
>  1 file changed, 37 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 44b3a81cadfb..1b1d5975ee0e 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -894,29 +894,24 @@ static ssize_t control_domains_show(struct device *dev,
>  }
>  static DEVICE_ATTR_RO(control_domains);
>  
> -static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
> -			   char *buf)
> +static ssize_t vfio_ap_mdev_matrix_show(struct ap_matrix *matrix, char *buf)
>  {
> -	struct mdev_device *mdev = mdev_from_dev(dev);
> -	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>  	char *bufpos = buf;
>  	unsigned long apid;
>  	unsigned long apqi;
>  	unsigned long apid1;
>  	unsigned long apqi1;
> -	unsigned long napm_bits = matrix_mdev->matrix.apm_max + 1;
> -	unsigned long naqm_bits = matrix_mdev->matrix.aqm_max + 1;
> +	unsigned long napm_bits = matrix->apm_max + 1;
> +	unsigned long naqm_bits = matrix->aqm_max + 1;
>  	int nchars = 0;
>  	int n;
>  
> -	apid1 = find_first_bit_inv(matrix_mdev->matrix.apm, napm_bits);
> -	apqi1 = find_first_bit_inv(matrix_mdev->matrix.aqm, naqm_bits);
> -
> -	mutex_lock(&matrix_dev->lock);
> +	apid1 = find_first_bit_inv(matrix->apm, napm_bits);
> +	apqi1 = find_first_bit_inv(matrix->aqm, naqm_bits);
>  
>  	if ((apid1 < napm_bits) && (apqi1 < naqm_bits)) {
> -		for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, napm_bits) {
> -			for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm,
> +		for_each_set_bit_inv(apid, matrix->apm, napm_bits) {
> +			for_each_set_bit_inv(apqi, matrix->aqm,
>  					     naqm_bits) {
>  				n = sprintf(bufpos, "%02lx.%04lx\n", apid,
>  					    apqi);
> @@ -925,25 +920,52 @@ static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
>  			}
>  		}
>  	} else if (apid1 < napm_bits) {
> -		for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, napm_bits) {
> +		for_each_set_bit_inv(apid, matrix->apm, napm_bits) {
>  			n = sprintf(bufpos, "%02lx.\n", apid);
>  			bufpos += n;
>  			nchars += n;
>  		}
>  	} else if (apqi1 < naqm_bits) {
> -		for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, naqm_bits) {
> +		for_each_set_bit_inv(apqi, matrix->aqm, naqm_bits) {
>  			n = sprintf(bufpos, ".%04lx\n", apqi);
>  			bufpos += n;
>  			nchars += n;
>  		}
>  	}
>  
> +	return nchars;
> +}
> +
> +static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
> +			   char *buf)
> +{
> +	ssize_t nchars;
> +	struct mdev_device *mdev = mdev_from_dev(dev);
> +	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
> +
> +	mutex_lock(&matrix_dev->lock);
> +	nchars = vfio_ap_mdev_matrix_show(&matrix_mdev->matrix, buf);
>  	mutex_unlock(&matrix_dev->lock);
>  
>  	return nchars;
>  }
>  static DEVICE_ATTR_RO(matrix);
>  
> +static ssize_t guest_matrix_show(struct device *dev,
> +				 struct device_attribute *attr, char *buf)
> +{
> +	ssize_t nchars;
> +	struct mdev_device *mdev = mdev_from_dev(dev);
> +	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
> +
> +	mutex_lock(&matrix_dev->lock);
> +	nchars = vfio_ap_mdev_matrix_show(&matrix_mdev->shadow_apcb, buf);
> +	mutex_unlock(&matrix_dev->lock);
> +
> +	return nchars;
> +}
> +static DEVICE_ATTR_RO(guest_matrix);
> +
>  static struct attribute *vfio_ap_mdev_attrs[] = {
>  	&dev_attr_assign_adapter.attr,
>  	&dev_attr_unassign_adapter.attr,
> @@ -953,6 +975,7 @@ static struct attribute *vfio_ap_mdev_attrs[] = {
>  	&dev_attr_unassign_control_domain.attr,
>  	&dev_attr_control_domains.attr,
>  	&dev_attr_matrix.attr,
> +	&dev_attr_guest_matrix.attr,
>  	NULL,
>  };
>  

