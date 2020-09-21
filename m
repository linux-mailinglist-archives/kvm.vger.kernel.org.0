Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC226272AA3
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 17:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgIUPrC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 11:47:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11080 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726611AbgIUPrA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Sep 2020 11:47:00 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08LFhplG080640;
        Mon, 21 Sep 2020 11:46:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=nluNtsCp3JizD1agG20vlbu9kvrXab0gUsgwUArlytk=;
 b=GjudGODRy1hYrW5oWKcqPYkQIePG4efSE0Eiw6qZpat9OHLaM3mX64yMsdKkvNSAaD3U
 nmeNSPaSLPsfP7JQFQ2FrkXjb1viJh6sdi4ZFlKKT5PkfJ8vJRGFFJ5/slk9wZomhQWA
 b4tv/U87FiCSyfjcEWudICDN6duWFpH5rrCDlFMsTWJZAqiNMRqA29Oglkb1C2TXsBAJ
 3bPFAqbadVhuxFCKWaQhJkcGo96gZv/G7+ex1pEkV8gcJ0cBgJRff9pFpqVq8fRRYhxb
 mkQubg2IeCKLFPzmlOlTmW71qAtjzPDav2Tp89VpIvkxjPMmPV22H/E6UraBMAjd/FYJ Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33py2u81gb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 11:46:59 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08LFjJi8083288;
        Mon, 21 Sep 2020 11:46:58 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33py2u81fs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 11:46:58 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08LFS5XA013499;
        Mon, 21 Sep 2020 15:46:56 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 33n9m7s4mn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 15:46:56 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08LFkrST16712018
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Sep 2020 15:46:53 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53E81A4054;
        Mon, 21 Sep 2020 15:46:53 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6F98A4060;
        Mon, 21 Sep 2020 15:46:52 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.8.1])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Sep 2020 15:46:52 +0000 (GMT)
Date:   Mon, 21 Sep 2020 17:45:36 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pmorel@linux.ibm.com,
        alex.williamson@redhat.com, cohuck@redhat.com,
        kwankhede@nvidia.com, borntraeger@de.ibm.com
Subject: Re: [PATCH] s390/vfio-ap: fix unregister GISC when KVM is already
 gone results in OOPS
Message-ID: <20200921174536.49e45e68.pasic@linux.ibm.com>
In-Reply-To: <20200918170234.5807-1-akrowiak@linux.ibm.com>
References: <20200918170234.5807-1-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-21_05:2020-09-21,2020-09-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 impostorscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 suspectscore=2
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009210112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 18 Sep 2020 13:02:34 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> Attempting to unregister Guest Interruption Subclass (GISC) when the
> link between the matrix mdev and KVM has been removed results in the
> following:
> 
>    "Kernel panic -not syncing: Fatal exception: panic_on_oops"
> 
> This patch fixes this bug by verifying the matrix mdev and KVM are still
> linked prior to unregistering the GISC.


I read from your commit message that this happens when the link between
the KVM and the matrix mdev was established and then got severed. 

I assume the interrupts were previously enabled, and were not been
disabled or cleaned up because q->saved_isc != VFIO_AP_ISC_INVALID.

That means the guest enabled  interrupts and then for whatever
reason got destroyed, and this happens on mdev cleanup.

Does it happen all the time or is it some sort of a race?

> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index e0bde8518745..847a88642644 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -119,11 +119,15 @@ static void vfio_ap_wait_for_irqclear(int apqn)
>   */
>  static void vfio_ap_free_aqic_resources(struct vfio_ap_queue *q)
>  {
> -	if (q->saved_isc != VFIO_AP_ISC_INVALID && q->matrix_mdev)
> -		kvm_s390_gisc_unregister(q->matrix_mdev->kvm, q->saved_isc);
> -	if (q->saved_pfn && q->matrix_mdev)
> -		vfio_unpin_pages(mdev_dev(q->matrix_mdev->mdev),
> -				 &q->saved_pfn, 1);
> +	if (q->matrix_mdev) {
> +		if (q->saved_isc != VFIO_AP_ISC_INVALID && q->matrix_mdev->kvm)
> +			kvm_s390_gisc_unregister(q->matrix_mdev->kvm,
> +						 q->saved_isc);

I don't quite understand the logic here. I suppose we need to ensure
that the struct kvm is 'alive' at least until kvm_s390_gisc_unregister()
is done. That is supposed be ensured by kvm_get_kvm() in
vfio_ap_mdev_set_kvm() and kvm_put_kvm() in vfio_ap_mdev_release().

If the critical section in vfio_ap_mdev_release() is done and
matrix_mdev->kvm was set to NULL there then I would expect that the
queues are already reset and q->saved_isc == VFIO_AP_ISC_INVALID. So
this should not blow up.

Now if this happens before the critical section in
vfio_ap_mdev_release() is done, I ask myself how are we going to do the
kvm_put_kvm()?

Another question. Do we hold the matrix_dev->lock here?

> +		if (q->saved_pfn)
> +			vfio_unpin_pages(mdev_dev(q->matrix_mdev->mdev),
> +					 &q->saved_pfn, 1);
> +	}
> +
>  	q->saved_pfn = 0;
>  	q->saved_isc = VFIO_AP_ISC_INVALID;
>  }

