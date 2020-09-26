Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6952797EF
	for <lists+kvm@lfdr.de>; Sat, 26 Sep 2020 10:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbgIZIYV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Sep 2020 04:24:21 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59014 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726037AbgIZIYV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 26 Sep 2020 04:24:21 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08Q8I4pY161946;
        Sat, 26 Sep 2020 04:24:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=G+Gbr71OC+7ot3fzNU1lSATWaR52HohgPx4lAsH9S6w=;
 b=GklKrl5o0JbFWuPaJWQ3PToqaZA6faMYbKP4wi/jv+QcjvPSVEHds4LplgoUiymF736X
 RPUU21engH09b1/Ul+MEhKIanN+g6z9zMznJhhI6fSkG+ipp5fDKeLbeuHdNQYeS7gwC
 jUs92j6Ds/rsK0PGZycg36UPdX16Arg9Mi3dsg+AEv1h3FKLNT7YHp6I8FqrLelYbs7K
 xVJS5wXTphV2dUDX5O4I6c68XCXgSXqR2z+hxR9bV/SUO1jPeo4WMa7XugHp5YqDpf7y
 HaG/ZlStlMRgfyCLfYvjC+7nTjCqrpBjTYlj3CzvCX7a+ywFuEKV5tUIXN/ugh9M8eRb GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33t20x82wk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 04:24:17 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08Q8KC1T166802;
        Sat, 26 Sep 2020 04:24:17 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33t20x82wa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 04:24:17 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08Q8GZ02027857;
        Sat, 26 Sep 2020 08:24:15 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 33svwgr77x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 08:24:15 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08Q8OCk320578812
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Sep 2020 08:24:12 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA1CEA4051;
        Sat, 26 Sep 2020 08:24:12 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF6C9A404D;
        Sat, 26 Sep 2020 08:24:11 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.162.14])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 26 Sep 2020 08:24:11 +0000 (GMT)
Date:   Sat, 26 Sep 2020 10:24:09 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v10 08/16] s390/vfio-ap: filter matrix for unavailable
 queue devices
Message-ID: <20200926102409.7884bdd1.pasic@linux.ibm.com>
In-Reply-To: <20200821195616.13554-9-akrowiak@linux.ibm.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
        <20200821195616.13554-9-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-26_06:2020-09-24,2020-09-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 spamscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 malwarescore=0 impostorscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009260069
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Aug 2020 15:56:08 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> Even though APQNs for queues that are not in the host's AP configuration
> may be assigned to a matrix mdev, we do not want to set bits in the guest's
> APCB for APQNs that do not reference AP queue devices bound to the vfio_ap
> device driver. Ideally, it would be great if such APQNs could be filtered
> out before setting the bits in the guest's APCB; however, the architecture
> precludes filtering individual APQNs. Consequently, either the APID or APQI
> must be filtered.
> 
> This patch introduces code to filter the APIDs or APQIs assigned to the
> matrix mdev's AP configuration before assigning them to the guest's AP
> configuration (i.e., APCB). We'll start by filtering the APIDs:
> 
>    If an APQN assigned to the matrix mdev's AP configuration does not
>    reference a queue device bound to the vfio_ap device driver, the APID
>    will be filtered out (i.e., not assigned to the guest's APCB).
> 
> If every APID assigned to the matrix mdev is filtered out, then we'll try
> filtering the APQI's:
> 
>    If an APQN assigned to the matrix mdev's AP configuration does not
>    reference a queue device bound to the vfio_ap device driver, the APQI
>    will be filtered out (i.e., not assigned to the guest's APCB).
> 
> In any case, if after filtering either the APIDs or APQIs there are any
> APQNs that can be assigned to the guest's APCB, they will be assigned and
> the CRYCB will be hot plugged into the guest.
> 
> Example
> =======
> 
> APQNs bound to vfio_ap device driver:
>    04.0004
>    04.0047
>    04.0054
> 
>    05.0005
>    05.0047
>    05.0054
> 
> Assignments to matrix mdev:
>    APIDs  APQIs  -> APQNs
>    04     0004      04.0004
>    05     0005      04.0005
>           0047      04.0047
>           0054      04.0054
>                     05.0004
>                     05.0005
>                     05.0047
>                     04.0054
> 
> Filter APIDs:
>    APID 04 will be filtered because APQN 04.0005 is not bound.
>    APID 05 will be filtered because APQN 05.0004 is not bound.
>    APQNs remaining: None
> 
> Filter APQIs:
>    APQI 04 will be filtered because APQN 05.0004 is not bound.
>    APQI 05 will be filtered because APQN 04.0005 is not bound.
>    APQNs remaining: 04.0047, 04.0054, 05.0047, 05.0054
> 
> APQNs 04.0047, 04.0054, 05.0047, 05.0054 will be assigned to the CRYCB and
> hot plugged into the KVM guest.
> 

I find this logic where we first do one strategy, and if nothing remains
do the other strategy a little confusing. I will ramble on about it some
more in the code.

> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 159 +++++++++++++++++++++++++++++-
>  1 file changed, 155 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 30bf23734af6..eaf4e9eab6cb 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -326,7 +326,7 @@ static bool vfio_ap_mdev_has_crycb(struct ap_matrix_mdev *matrix_mdev)
>  	return (matrix_mdev->kvm && matrix_mdev->kvm->arch.crypto.crycbd);
>  }
>  
> -static void vfio_ap_mdev_commit_crycb(struct ap_matrix_mdev *matrix_mdev)
> +static void vfio_ap_mdev_commit_shadow_apcb(struct ap_matrix_mdev *matrix_mdev)
>  {
>  	kvm_arch_crypto_set_masks(matrix_mdev->kvm,
>  				  matrix_mdev->shadow_apcb.apm,
> @@ -597,6 +597,157 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev,
>  	return 0;
>  }
>  
> +/**
> + * vfio_ap_mdev_filter_matrix
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
> + * Returns the number of APQNs remaining after filtering is complete.
> + */
> +static int vfio_ap_mdev_filter_matrix(struct ap_matrix_mdev *matrix_mdev,
> +				      struct ap_matrix *shadow_apcb,
> +				      bool filter_apids)
> +{
> +	unsigned long apid, apqi, apqn;
> +
> +	memcpy(shadow_apcb, &matrix_mdev->matrix, sizeof(*shadow_apcb));
> +
> +	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, AP_DEVICES) {
> +		/*
> +		 * If the APID is not assigned to the host AP configuration,
> +		 * we can not assign it to the guest's AP configuration
> +		 */
> +		if (!test_bit_inv(apid,
> +				  (unsigned long *)matrix_dev->info.apm)) {

The patch description and the code seem to be out of sync. Here you do
some filtering based on the host's  AP config info read at module read at
module initialization time.

> +			clear_bit_inv(apid, shadow_apcb->apm);
> +			continue;
> +		}
> +
> +		for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm,
> +				     AP_DOMAINS) {
> +			/*
> +			 * If the APQI is not assigned to the host AP
> +			 * configuration, then it can not be assigned to the
> +			 * guest's AP configuration
> +			 */
> +			if (!test_bit_inv(apqi, (unsigned long *)
> +					  matrix_dev->info.aqm)) {
> +				clear_bit_inv(apqi, shadow_apcb->aqm);
> +				continue;
> +			}
> +
> +			/*
> +			 * If the APQN is not bound to the vfio_ap device
> +			 * driver, then we can't assign it to the guest's
> +			 * AP configuration. The AP architecture won't
> +			 * allow filtering of a single APQN, so if we're
> +			 * filtering APIDs, then filter the APID; otherwise,
> +			 * filter the APQI.
> +			 */
> +			apqn = AP_MKQID(apid, apqi);
> +			if (!vfio_ap_get_queue(apqn)) {

Is this really gonna give NULL if the queue is not bound to vfio-ap? I
don't think so. This will get NULL if the queue is not known to the AP
bus, or has no driver-data assigned. In the current state it should give
you non-NULL if another driver has the queue, and maintains it's own
driver specific data in drvdata.

> +				if (filter_apids)
> +					clear_bit_inv(apid, shadow_apcb->apm);
> +				else
> +					clear_bit_inv(apqi, shadow_apcb->aqm);
> +				break;
> +			}
> +		}
> +
> +		/*
> +		 * If we're filtering APQIs and all of them have been filtered,
> +		 * there's no need to continue filtering.
> +		 */
> +		if (!filter_apids)
> +			if (bitmap_empty(shadow_apcb->aqm, AP_DOMAINS))
> +				break;
> +	}
> +
> +	return bitmap_weight(shadow_apcb->apm, AP_DEVICES) *
> +	       bitmap_weight(shadow_apcb->aqm, AP_DOMAINS);
> +}
> +
> +/**
> + * vfio_ap_mdev_config_shadow_apcb
> + *
> + * Configure the shadow of a KVM guest's APCB specifying the adapters, domains
> + * and control domains to be assigned to the guest. The shadow APCB will be
> + * configured after filtering the APQNs assigned to the matrix mdev that do not
> + * reference a queue device bound to the vfio_ap device driver.
> + *
> + * @matrix_mdev: the matrix mdev whose shadow APCB is to be configured.
> + *
> + * Returns true if the shadow APCB contents have been changed; otherwise,
> + * returns false.
> + */
> +static bool vfio_ap_mdev_config_shadow_apcb(struct ap_matrix_mdev *matrix_mdev)
> +{
> +	int napm, naqm;
> +	struct ap_matrix shadow_apcb;
> +
> +	vfio_ap_matrix_init(&matrix_dev->info, &shadow_apcb);
> +	napm = bitmap_weight(matrix_mdev->matrix.apm, AP_DEVICES);
> +	naqm = bitmap_weight(matrix_mdev->matrix.aqm, AP_DOMAINS);
> +
> +	/*
> +	 * If there are no APIDs or no APQIs assigned to the matrix mdev,
> +	 * then no APQNs shall be assigned to the guest CRYCB.
> +	 */
> +	if ((napm != 0) || (naqm != 0)) {
> +		/*
> +		 * Filter the APIDs assigned to the matrix mdev for APQNs that
> +		 * do not reference an AP queue device bound to the driver.
> +		 */
> +		napm = vfio_ap_mdev_filter_matrix(matrix_mdev, &shadow_apcb,
> +						  true);
> +		/*
> +		 * If there are no APQNs that can be assigned to the guest's
> +		 * CRYCB after filtering, then try filtering the APQIs.
> +		 */
> +		if (napm == 0) {

When do we expect this to happen? Currently we don't assign queues that
are not bound to us, and we have ->in_use() that inhibits disappearance
of queues due to re-partitioning.

So what we are left with is queue becomes unavailable to the host
because of a config change, and maybe manual unbind -- not sure about
that.

Now if matrix_dev->info was to reflect the config the bus acts by, which
seems to the idea behind patch 12 we could react accordingly (if the
domain is gone filter aqm).

I mean, the purpose of this callback seems to be getting us out of
trouble when domains are missing across all cards (i.e. some domains
were assigned away from us on the lower level).

Or am I missing something?

> +			naqm = vfio_ap_mdev_filter_matrix(matrix_mdev,
> +							  &shadow_apcb, false);
> +
> +			/*
> +			 * If there are no APQNs that can be assigned to the
> +			 * matrix mdev after filtering the APQIs, then no APQNs
> +			 * shall be assigned to the guest's CRYCB.
> +			 */
> +			if (naqm == 0) {
> +				bitmap_clear(shadow_apcb.apm, 0, AP_DEVICES);
> +				bitmap_clear(shadow_apcb.aqm, 0, AP_DOMAINS);
> +			}
> +		}
> +	}
> +
> +	/*
> +	 * If the guest's AP configuration has not changed, then return
> +	 * indicating such.
> +	 */
> +	if (bitmap_equal(matrix_mdev->shadow_apcb.apm, shadow_apcb.apm,
> +			 AP_DEVICES) &&
> +	    bitmap_equal(matrix_mdev->shadow_apcb.aqm, shadow_apcb.aqm,
> +			 AP_DOMAINS) &&
> +	    bitmap_equal(matrix_mdev->shadow_apcb.adm, shadow_apcb.adm,
> +			 AP_DOMAINS))
> +		return false;
> +
> +	/*
> +	 * Copy the changes to the guest's CRYCB, then return indicating that
> +	 * the guest's AP configuration has changed.
> +	 */
> +	memcpy(&matrix_mdev->shadow_apcb, &shadow_apcb, sizeof(shadow_apcb));
> +
> +	return true;
> +}
> +
>  enum qlink_type {
>  	LINK_APID,
>  	LINK_APQI,
> @@ -1284,9 +1435,8 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>  	if (!vfio_ap_mdev_has_crycb(matrix_mdev))
>  		return NOTIFY_DONE;
>  
> -	memcpy(&matrix_mdev->shadow_apcb, &matrix_mdev->matrix,
> -	       sizeof(matrix_mdev->shadow_apcb));
> -	vfio_ap_mdev_commit_crycb(matrix_mdev);
> +	if (vfio_ap_mdev_config_shadow_apcb(matrix_mdev))
> +		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
>  
>  	return NOTIFY_OK;
>  }
> @@ -1396,6 +1546,7 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
>  	mutex_lock(&matrix_dev->lock);
>  	if (matrix_mdev->kvm) {
>  		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
> +		vfio_ap_matrix_clear_masks(&matrix_mdev->shadow_apcb);
>  		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
>  		vfio_ap_mdev_reset_queues(mdev);
>  		kvm_put_kvm(matrix_mdev->kvm);

