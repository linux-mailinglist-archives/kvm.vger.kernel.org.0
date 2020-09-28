Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F1327A4FF
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 03:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgI1BCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Sep 2020 21:02:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63472 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726328AbgI1BCC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 27 Sep 2020 21:02:02 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08S0XQS1142084;
        Sun, 27 Sep 2020 21:01:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=rZh32UNd9lsVEkbvo775bMSkt/FS+vGNJEy8RT9q0qE=;
 b=Ngu367PSpUfKMnt3Y6DCuVffCLtI9coSs3yXuqfwaE1H2UmxegeCnZjDms9RFbXItBs8
 /2/gB8/he8ScWjMEl+vB4MMgj7OPbluXdJX3HswpoeZ9B+RcUZpmSAGRy1nDD7bhxR1G
 /eBI5UaK03dKrcDKTvDmaRgbWZzVkLtY20f9DI+JXrgI9e+Ls3xb6vyNmmqXcT7aJzl0
 /JZGzC+bmyNe934tOP2m+dLZGzPbUnhPyHHZbDu8Pbg7OmueTZTCC1N/rsoZAByqEipu
 geXus8ygaO8xC0glmL0xRSJAYgFGnlG45vBW1tpKcbHyT/qx4N/+D1A2YqWIMjfgfouA GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33u5d30f43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 27 Sep 2020 21:01:57 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08S0xWUo006501;
        Sun, 27 Sep 2020 21:01:56 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33u5d30f38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 27 Sep 2020 21:01:56 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08S0wiWe000757;
        Mon, 28 Sep 2020 01:01:54 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 33t16k0qk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Sep 2020 01:01:53 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08S11oLC32833850
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 01:01:50 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF7864204D;
        Mon, 28 Sep 2020 01:01:50 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F55C42042;
        Mon, 28 Sep 2020 01:01:50 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.5.131])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 28 Sep 2020 01:01:49 +0000 (GMT)
Date:   Mon, 28 Sep 2020 03:01:47 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v10 11/16] s390/vfio-ap: allow hot plug/unplug of AP
 resources using mdev device
Message-ID: <20200928030147.7ee6f494.pasic@linux.ibm.com>
In-Reply-To: <20200821195616.13554-12-akrowiak@linux.ibm.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
 <20200821195616.13554-12-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-27_18:2020-09-24,2020-09-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 adultscore=0 mlxscore=0 spamscore=0 impostorscore=0
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009280000
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Aug 2020 15:56:11 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> Let's hot plug/unplug adapters, domains and control domains assigned to or
> unassigned from an AP matrix mdev device while it is in use by a guest per
> the following:
> 
> * When the APID of an adapter is assigned to a matrix mdev in use by a KVM
>   guest, the adapter will be hot plugged into the KVM guest as long as each
>   APQN derived from the Cartesian product of the APID being assigned and
>   the APQIs already assigned to the guest's CRYCB references a queue device
>   bound to the vfio_ap device driver.
> 
> * When the APID of an adapter is unassigned from a matrix mdev in use by a
>   KVM guest, the adapter will be hot unplugged from the KVM guest.
> 
> * When the APQI of a domain is assigned to a matrix mdev in use by a KVM
>   guest, the domain will be hot plugged into the KVM guest as long as each
>   APQN derived from the Cartesian product of the APQI being assigned and
>   the APIDs already assigned to the guest's CRYCB references a queue device
>   bound to the vfio_ap device driver.
> 
> * When the APQI of a domain is unassigned from a matrix mdev in use by a
>   KVM guest, the domain will be hot unplugged from the KVM guest



Hm, I suppose this means that what your guest effectively gets may depend
on whether assign_domain or assign_adapter is done first.

Suppose we have the queues
0.0 0.1
1.0 
bound to vfio_ap, i.e. 1.1 is missing for a reason different than
belonging to the default drivers (for what exact reason no idea).

Let's suppose we started with the matix containing only adapter
0 (0.) and domain 0 (.0).

After echo 1 > assign_adapter && echo 1 > assign_domain we end up with
matrix:
0.0 0.1
1.0 1.1
guest_matrix:
0.0 0.1
while after echo 1 > assign_domain && echo 1 > assign_adapter we end up
with:
matrix:
0.0 0.1
1.0 1.1
guest_matrix:
0.0
0.1

That means, the set of bound queues and the set of assigned resources do
not fully determine the set of resources passed through to the guest.

I that a deliberate design choice?



> 
> * When the domain number of a control domain is assigned to a matrix mdev
>   in use by a KVM guest, the control domain will be hot plugged into the
>   KVM guest.
> 
> * When the domain number of a control domain is unassigned from a matrix
>   mdev in use by a KVM guest, the control domain will be hot unplugged
>   from the KVM guest.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 196 ++++++++++++++++++++++++++++++
>  1 file changed, 196 insertions(+)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index cf3321eb239b..2b01a8eb6ee7 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -731,6 +731,56 @@ static void vfio_ap_mdev_link_queues(struct ap_matrix_mdev *matrix_mdev,
>  	}
>  }
>  
> +static bool vfio_ap_mdev_assign_apqis_4_apid(struct ap_matrix_mdev *matrix_mdev,
> +					     unsigned long apid)
> +{
> +	DECLARE_BITMAP(aqm, AP_DOMAINS);
> +	unsigned long apqi, apqn;
> +
> +	bitmap_copy(aqm, matrix_mdev->matrix.aqm, AP_DOMAINS);
> +
> +	for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, AP_DOMAINS) {
> +		if (!test_bit_inv(apqi,
> +				  (unsigned long *) matrix_dev->info.aqm))
> +			clear_bit_inv(apqi, aqm);
> +
> +		apqn = AP_MKQID(apid, apqi);
> +		if (!vfio_ap_get_mdev_queue(matrix_mdev, apqn))
> +			clear_bit_inv(apqi, aqm);
> +	}
> +
> +	if (bitmap_empty(aqm, AP_DOMAINS))
> +		return false;
> +
> +	set_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
> +	bitmap_copy(matrix_mdev->shadow_apcb.aqm, aqm, AP_DOMAINS);
> +
> +	return true;
> +}
> +
> +static bool vfio_ap_mdev_assign_guest_apid(struct ap_matrix_mdev *matrix_mdev,
> +					   unsigned long apid)
> +{
> +	unsigned long apqi, apqn;
> +
> +	if (!vfio_ap_mdev_has_crycb(matrix_mdev) ||
> +	    !test_bit_inv(apid, (unsigned long *)matrix_dev->info.apm))
> +		return false;
> +
> +	if (bitmap_empty(matrix_mdev->shadow_apcb.aqm, AP_DOMAINS))
> +		return vfio_ap_mdev_assign_apqis_4_apid(matrix_mdev, apid);


Hm. Let's say we have the same situation regarding the bound queues as
above but we start with the empty matrix, and do all the assignments
while the guest is running.

Consider the following sequence of actions.

1) echo 0 > assign_domain
2) echo 1 > assign_domain
3) echo 1 > assign_adapter
4) echo 0 > assign_adapter
5) echo 1 > unassign_adapter

I understand that at 3), because
bitmap_empty(matrix_mdev->shadow_apcb.aqm)we would end up with a shadow
aqm containing just domain 0, as queue 1.1 ain't bound to us.

Thus at the end we would have
matrix:
0.0 0.1
guest_matrix:
0.0

And if we add in an adapter 2. into the mix with the queues 2.0 and 2.1
then after
6) echo 2 > assign_adapter
we get
Thus at the end we would have
matrix:
0.0 0.1
2.0 2.1
guest_matrix:
0.0
2.0

This looks very quirky to me. Did I read the code wrong? Opinions?

> +
> +	for_each_set_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm, AP_DOMAINS) {
> +		apqn = AP_MKQID(apid, apqi);
> +		if (!vfio_ap_get_mdev_queue(matrix_mdev, apqn))
> +			return false;
> +	}
> +
> +	set_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
> +
> +	return true;
> +}
> +
>  /**
>   * assign_adapter_store
>   *
> @@ -792,12 +842,42 @@ static ssize_t assign_adapter_store(struct device *dev,
>  	}
>  	set_bit_inv(apid, matrix_mdev->matrix.apm);
>  	vfio_ap_mdev_link_queues(matrix_mdev, LINK_APID, apid);
> +	if (vfio_ap_mdev_assign_guest_apid(matrix_mdev, apid))
> +		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
>  	mutex_unlock(&matrix_dev->lock);
>  
>  	return count;
>  }
>  static DEVICE_ATTR_WO(assign_adapter);
>  
> +static bool vfio_ap_mdev_unassign_guest_apid(struct ap_matrix_mdev *matrix_mdev,
> +					     unsigned long apid)
> +{
> +	if (vfio_ap_mdev_has_crycb(matrix_mdev)) {
> +		if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm)) {
> +			clear_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
> +
> +			/*
> +			 * If there are no APIDs assigned to the guest, then
> +			 * the guest will not have access to any queues, so
> +			 * let's also go ahead and unassign the APQIs. Keeping
> +			 * them around may yield unpredictable results during
> +			 * a probe that is not related to a host AP
> +			 * configuration change (i.e., an AP adapter is
> +			 * configured online).
> +			 */

I don't quite understand this comment. Clearing out the other mask when
the one becomes empty, does allow us to recover the full possible guest
matrix in the scenario described above. I don't see any shadow
manipulation in the probe handler at this stage. Are we maybe
talking about the same effect as I described for assign?

Regards,
Halil

> +			if (bitmap_empty(matrix_mdev->shadow_apcb.apm,
> +					 AP_DEVICES))
> +				bitmap_clear(matrix_mdev->shadow_apcb.aqm, 0,
> +					     AP_DOMAINS);
> +
> +			return true;
> +		}
> +	}
> +
> +	return false;
> +}
> +
>  /**
>   * unassign_adapter_store
>   *
> @@ -834,12 +914,64 @@ static ssize_t unassign_adapter_store(struct device *dev,
>  	mutex_lock(&matrix_dev->lock);
>  	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
>  	vfio_ap_mdev_link_queues(matrix_mdev, UNLINK_APID, apid);
> +	if (vfio_ap_mdev_unassign_guest_apid(matrix_mdev, apid))
> +		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
>  	mutex_unlock(&matrix_dev->lock);
>  
>  	return count;
>  }
>  static DEVICE_ATTR_WO(unassign_adapter);
>  
> +static bool vfio_ap_mdev_assign_apids_4_apqi(struct ap_matrix_mdev *matrix_mdev,
> +					     unsigned long apqi)
> +{
> +	DECLARE_BITMAP(apm, AP_DEVICES);
> +	unsigned long apid, apqn;
> +
> +	bitmap_copy(apm, matrix_mdev->matrix.apm, AP_DEVICES);
> +
> +	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, AP_DEVICES) {
> +		if (!test_bit_inv(apid,
> +				  (unsigned long *) matrix_dev->info.apm))
> +			clear_bit_inv(apqi, apm);
> +
> +		apqn = AP_MKQID(apid, apqi);
> +		if (!vfio_ap_get_mdev_queue(matrix_mdev, apqn))
> +			clear_bit_inv(apid, apm);
> +	}
> +
> +	if (bitmap_empty(apm, AP_DEVICES))
> +		return false;
> +
> +	set_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm);
> +	bitmap_copy(matrix_mdev->shadow_apcb.apm, apm, AP_DEVICES);
> +
> +	return true;
> +}
> +
> +static bool vfio_ap_mdev_assign_guest_apqi(struct ap_matrix_mdev *matrix_mdev,
> +					   unsigned long apqi)
> +{
> +	unsigned long apid, apqn;
> +
> +	if (!vfio_ap_mdev_has_crycb(matrix_mdev) ||
> +	    !test_bit_inv(apqi, (unsigned long *)matrix_dev->info.aqm))
> +		return false;
> +
> +	if (bitmap_empty(matrix_mdev->shadow_apcb.apm, AP_DEVICES))
> +		return vfio_ap_mdev_assign_apids_4_apqi(matrix_mdev, apqi);
> +
> +	for_each_set_bit_inv(apid, matrix_mdev->shadow_apcb.apm, AP_DEVICES) {
> +		apqn = AP_MKQID(apid, apqi);
> +		if (!vfio_ap_get_mdev_queue(matrix_mdev, apqn))
> +			return false;
> +	}
> +
> +	set_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm);
> +
> +	return true;
> +}
> +
>  /**
>   * assign_domain_store
>   *
> @@ -901,12 +1033,41 @@ static ssize_t assign_domain_store(struct device *dev,
>  	}
>  	set_bit_inv(apqi, matrix_mdev->matrix.aqm);
>  	vfio_ap_mdev_link_queues(matrix_mdev, LINK_APQI, apqi);
> +	if (vfio_ap_mdev_assign_guest_apqi(matrix_mdev, apqi))
> +		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
>  	mutex_unlock(&matrix_dev->lock);
>  
>  	return count;
>  }
>  static DEVICE_ATTR_WO(assign_domain);
>  
> +static bool vfio_ap_mdev_unassign_guest_apqi(struct ap_matrix_mdev *matrix_mdev,
> +					     unsigned long apqi)
> +{
> +	if (vfio_ap_mdev_has_crycb(matrix_mdev)) {
> +		if (test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm)) {
> +			clear_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm);
> +
> +			/*
> +			 * If there are no APQIs assigned to the guest, then
> +			 * the guest will not have access to any queues, so
> +			 * let's also go ahead and unassign the APIDs. Keeping
> +			 * them around may yield unpredictable results during
> +			 * a probe that is not related to a host AP
> +			 * configuration change (i.e., an AP adapter is
> +			 * configured online).
> +			 */
> +			if (bitmap_empty(matrix_mdev->shadow_apcb.aqm,
> +					 AP_DOMAINS))
> +				bitmap_clear(matrix_mdev->shadow_apcb.apm, 0,
> +					     AP_DEVICES);
> +
> +			return true;
> +		}
> +	}
> +
> +	return false;
> +}
>  
>  /**
>   * unassign_domain_store
> @@ -944,12 +1105,28 @@ static ssize_t unassign_domain_store(struct device *dev,
>  	mutex_lock(&matrix_dev->lock);
>  	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
>  	vfio_ap_mdev_link_queues(matrix_mdev, UNLINK_APQI, apqi);
> +	if (vfio_ap_mdev_unassign_guest_apqi(matrix_mdev, apqi))
> +		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
>  	mutex_unlock(&matrix_dev->lock);
>  
>  	return count;
>  }
>  static DEVICE_ATTR_WO(unassign_domain);
>  
> +static bool vfio_ap_mdev_assign_guest_cdom(struct ap_matrix_mdev *matrix_mdev,
> +					   unsigned long domid)
> +{
> +	if (vfio_ap_mdev_has_crycb(matrix_mdev)) {
> +		if (!test_bit_inv(domid, matrix_mdev->shadow_apcb.adm)) {
> +			set_bit_inv(domid, matrix_mdev->shadow_apcb.adm);
> +
> +			return true;
> +		}
> +	}
> +
> +	return false;
> +}
> +
>  /**
>   * assign_control_domain_store
>   *
> @@ -984,12 +1161,29 @@ static ssize_t assign_control_domain_store(struct device *dev,
>  
>  	mutex_lock(&matrix_dev->lock);
>  	set_bit_inv(id, matrix_mdev->matrix.adm);
> +	if (vfio_ap_mdev_assign_guest_cdom(matrix_mdev, id))
> +		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
>  	mutex_unlock(&matrix_dev->lock);
>  
>  	return count;
>  }
>  static DEVICE_ATTR_WO(assign_control_domain);
>  
> +static bool
> +vfio_ap_mdev_unassign_guest_cdom(struct ap_matrix_mdev *matrix_mdev,
> +				 unsigned long domid)
> +{
> +	if (vfio_ap_mdev_has_crycb(matrix_mdev)) {
> +		if (test_bit_inv(domid, matrix_mdev->shadow_apcb.adm)) {
> +			clear_bit_inv(domid, matrix_mdev->shadow_apcb.adm);
> +
> +			return true;
> +		}
> +	}
> +
> +	return false;
> +}
> +
>  /**
>   * unassign_control_domain_store
>   *
> @@ -1024,6 +1218,8 @@ static ssize_t unassign_control_domain_store(struct device *dev,
>  
>  	mutex_lock(&matrix_dev->lock);
>  	clear_bit_inv(domid, matrix_mdev->matrix.adm);
> +	if (vfio_ap_mdev_unassign_guest_cdom(matrix_mdev, domid))
> +		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
>  	mutex_unlock(&matrix_dev->lock);
>  
>  	return count;

u
