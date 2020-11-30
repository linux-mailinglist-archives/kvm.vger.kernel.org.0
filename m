Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6CD2C92BF
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 00:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389019AbgK3XfR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 18:35:17 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19410 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389009AbgK3XfQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 18:35:16 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AUNYHkw071058;
        Mon, 30 Nov 2020 18:34:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=kVqkkqol21M5O2VZ4tPALbjqKaclMGkgBCURMKttYLM=;
 b=AqFE2zShuWkrs5n22OhHqZzdjN224FsgtG5kyVEE9y7qSzf6yJpWLT7ugAFh3n1iGDU0
 hfDyfrqMLJmJSVqP1Ja6Li7lWS3DxLLzyR8rJB+KLX3QuQMOt4QO/GNJXkoVTqmuFXr9
 aXBg+7TfjVFe+Ujv/AJHn69KoKyukAvlQkjqNx1qp1GCihHnkLorQhGfG+5T4ZZ550x/
 91bRSBxcvgIvwGH4HtqZqE0goHZk4VMT0bra1HXfISrYUJt3ivgxuON/xbfb9jBH4jzV
 QO2i3X30Lk6sjxAKjwB8DQQ39gzDl4s01GRFybDWquZXuThJFR81iAa0D939DrTR3ELv 3Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35585w3rjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 18:34:34 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AUNYXuN072690;
        Mon, 30 Nov 2020 18:34:33 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35585w3qqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 18:34:32 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AUNNQJN013612;
        Mon, 30 Nov 2020 23:32:33 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 353e689a94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 23:32:33 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AUNWUHA58982796
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 23:32:30 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 568F94204C;
        Mon, 30 Nov 2020 23:32:30 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 967D74203F;
        Mon, 30 Nov 2020 23:32:29 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.74.188])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Mon, 30 Nov 2020 23:32:29 +0000 (GMT)
Date:   Tue, 1 Dec 2020 00:32:27 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v12 12/17] s390/vfio-ap: allow hot plug/unplug of AP
 resources using mdev device
Message-ID: <20201201003227.0c3696fc.pasic@linux.ibm.com>
In-Reply-To: <103cbe02-2093-c950-8d65-d3dc385942ce@linux.ibm.com>
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
        <20201124214016.3013-13-akrowiak@linux.ibm.com>
        <20201129025250.16eb8355.pasic@linux.ibm.com>
        <103cbe02-2093-c950-8d65-d3dc385942ce@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_12:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 clxscore=1015 priorityscore=1501 impostorscore=0 spamscore=0 mlxscore=0
 bulkscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011300146
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 30 Nov 2020 14:36:10 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> 
> 
> On 11/28/20 8:52 PM, Halil Pasic wrote:
[..]
> >> * Unassign adapter from mdev's matrix:
> >>
> >>    The domain will be hot unplugged from the KVM guest if it is
> >>    assigned to the guest's matrix.
> >>
> >> * Assign a control domain:
> >>
> >>    The control domain will be hot plugged into the KVM guest if it is not
> >>    assigned to the guest's APCB. The AP architecture ensures a guest will
> >>    only get access to the control domain if it is in the host's AP
> >>    configuration, so there is no risk in hot plugging it; however, it will
> >>    become automatically available to the guest when it is added to the host
> >>    configuration.
> >>
> >> * Unassign a control domain:
> >>
> >>    The control domain will be hot unplugged from the KVM guest if it is
> >>    assigned to the guest's APCB.
> > This is where things start getting tricky. E.g. do we need to revise
> > filtering after an unassign? (For example an assign_adapter X didn't
> > change the shadow, because queue XY was missing, but now we unplug domain
> > Y. Should the adapter X pop up? I guess it should.)
> 
> I suppose that makes sense at the expense of making the code
> more complex. It is essentially what we had in the prior version
> which used the same filtering code for assignment as well as
> host AP configuration changes.
> 

Will have to think about it some more. Making the user unplug and
replug an adapter because at some point it got filtered, but there
is no need to filter it does not feel right. On the other hand, I'm
afraid I'm complaining in circles. 

> >
> >
> >> Note: Now that hot plug/unplug is implemented, there is the possibility
> >>        that an assignment/unassignment of an adapter, domain or control
> >>        domain could be initiated while the guest is starting, so the
> >>        matrix device lock will be taken for the group notification callback
> >>        that initializes the guest's APCB when the KVM pointer is made
> >>        available to the vfio_ap device driver.
> >>
> >> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> >> ---
> >>   drivers/s390/crypto/vfio_ap_ops.c | 190 +++++++++++++++++++++++++-----
> >>   1 file changed, 159 insertions(+), 31 deletions(-)
> >>
> >> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> >> index 586ec5776693..4f96b7861607 100644
> >> --- a/drivers/s390/crypto/vfio_ap_ops.c
> >> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> >> @@ -631,6 +631,60 @@ static void vfio_ap_mdev_manage_qlinks(struct ap_matrix_mdev *matrix_mdev,
> >>   	}
> >>   }
> >>   
> >> +static bool vfio_ap_assign_apid_to_apcb(struct ap_matrix_mdev *matrix_mdev,
> >> +					unsigned long apid)
> >> +{
> >> +	unsigned long apqi, apqn;
> >> +	unsigned long *aqm = matrix_mdev->shadow_apcb.aqm;
> >> +
> >> +	/*
> >> +	 * If the APID is already assigned to the guest's shadow APCB, there is
> >> +	 * no need to assign it.
> >> +	 */
> >> +	if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm))
> >> +		return false;
> >> +
> >> +	/*
> >> +	 * If no domains have yet been assigned to the shadow APCB and one or
> >> +	 * more domains have been assigned to the matrix mdev, then use
> >> +	 * the domains assigned to the matrix mdev; otherwise, there is nothing
> >> +	 * to assign to the shadow APCB.
> >> +	 */
> >> +	if (bitmap_empty(matrix_mdev->shadow_apcb.aqm, AP_DOMAINS)) {
> >> +		if (bitmap_empty(matrix_mdev->matrix.aqm, AP_DOMAINS))
> >> +			return false;
> >> +
> >> +		aqm = matrix_mdev->matrix.aqm;
> >> +	}
> >> +
> >> +	/* Make sure all APQNs are bound to the vfio_ap driver */
> >> +	for_each_set_bit_inv(apqi, aqm, AP_DOMAINS) {
> >> +		apqn = AP_MKQID(apid, apqi);
> >> +
> >> +		if (vfio_ap_mdev_get_queue(matrix_mdev, apqn) == NULL)
> >> +			return false;
> >> +	}
> >> +
> >> +	set_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
> >> +
> >> +	/*
> >> +	 * If we verified APQNs using the domains assigned to the matrix mdev,
> >> +	 * then copy the APQIs of those domains into the guest's APCB
> >> +	 */
> >> +	if (bitmap_empty(matrix_mdev->shadow_apcb.aqm, AP_DOMAINS))
> >> +		bitmap_copy(matrix_mdev->shadow_apcb.aqm,
> >> +			    matrix_mdev->matrix.aqm, AP_DOMAINS);
> >> +
> >> +	return true;
> >> +}
> > What is the rationale behind the shadow aqm empty special handling?
> 
> The rationale was to avoid taking the VCPUs
> out of SIE in order to make an update to the guest's APCB
> unnecessarily. For example, suppose the guest is started
> without access to any APQNs (i.e., all matrix and shadow_apcb
> masks are zeros). Now suppose the administrator proceeds to
> start assigning AP resources to the mdev. Let's say he starts
> by assigning adapters 1 through 100. The code below will return
> true indicating the shadow_apcb was updated. Consequently,
> the calling code will commit the changes to the guest's
> APCB. The problem there is that in order to update the guest's
> VCPUs, they will have to be taken out of SIE, yet the guest will
> not get access to the adapter since no domains have yet been
> assigned to the APCB. Doing this 100 times - once for each
> adapter 1-100 - is probably a bad idea.
>

Not yanking the VCPUs out of SIE does make a lot of sense. At least
I understand your motivation now. I will think some more about this,
but in the meanwhile, please try to answer one more question (see
below).
 
> >   I.e.
> > why not simply:
> >
> >
> > static bool vfio_ap_assign_apid_to_apcb(struct ap_matrix_mdev *matrix_mdev,
> >                                          unsigned long apid)
> > {
> >          unsigned long apqi, apqn;
> >          unsigned long *aqm = matrix_mdev->shadow_apcb.aqm;
> >                                                                                  
> >          /*
> >           * If the APID is already assigned to the guest's shadow APCB, there is
> >           * no need to assign it.
> >           */
> >          if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm))
> >                  return false;
> >                                                                                  
> >          /* Make sure all APQNs are bound to the vfio_ap driver */
> >          for_each_set_bit_inv(apqi, aqm, AP_DOMAINS) {
> >                  apqn = AP_MKQID(apid, apqi);
> >                                                                                  
> >                  if (vfio_ap_mdev_get_queue(matrix_mdev, apqn) == NULL)
> >                          return false;
> >          }
> >                                                                                  
> >          set_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
> >                                                                                  
> >          return true;

Would
s/return true/return !bitmap_empty(matrix_mdev->shadow_apcb.aqm,
AP_DOMAINS)/ 
do the trick?

I mean if empty, then we would not commit the APCB, so we would
not take the vCPUs out of SIE -- see below.

> >> +
> >> +static void vfio_ap_mdev_hot_plug_adapter(struct ap_matrix_mdev *matrix_mdev,
> >> +					  unsigned long apid)
> >> +{
> >> +	if (vfio_ap_assign_apid_to_apcb(matrix_mdev, apid))
> >> +		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
> >> +}
> >> +
[..]

Regards,
Halil
