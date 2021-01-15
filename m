Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF502F7021
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 02:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731616AbhAOBpf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 20:45:35 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24478 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731572AbhAOBpe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 20:45:34 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10F1WU4R013878;
        Thu, 14 Jan 2021 20:44:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=evF+qaGB2h93cdj3mzjNUqR1zgSKOzNs8g7BPvKWQ3w=;
 b=LLpIILW4zfNlOu9ih5LXwWoJ2MB/c/rAGoCFxmhW2+DjsQq8/50/ZUMuw0wyFpi/dBOJ
 3TYo14EKm7goQy7grXjKLwXarcwmAMVop5n33e4QLmVJjoZAeVH5q4AqI3dQ8862mafz
 zCmX7zUeKqrVteNitYT2I6NSR4sVLWFgFGgOuE/5IPsVdnEU5Dij7Vzr1LDEk5rM7vPy
 M51L93m15TMeffGqCvKKLsDgeD0hE3pNK6P52CbSQk20EeJw44hCyUwsGfTf5MAwx90s
 0mATMnwAFXCmAVWnS81Y1LKzRJLHIS0Z25Y9Iv38UVeLKiz2We+MHnGMJX+tysAxPUAg Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362yhn317b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 20:44:51 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10F1dNj3064167;
        Thu, 14 Jan 2021 20:44:51 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362yhn315p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 20:44:50 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10F1gHkZ020077;
        Fri, 15 Jan 2021 01:44:47 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 35ydrdep9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 01:44:47 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10F1iiPx25559518
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 01:44:44 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A0604C052;
        Fri, 15 Jan 2021 01:44:44 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD47B4C046;
        Fri, 15 Jan 2021 01:44:43 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.66.6])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Fri, 15 Jan 2021 01:44:43 +0000 (GMT)
Date:   Fri, 15 Jan 2021 02:44:41 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v13 06/15] s390/vfio-ap: allow assignment of unavailable
 AP queues to mdev device
Message-ID: <20210115024441.1d8f41bc.pasic@linux.ibm.com>
In-Reply-To: <270e192b-b88d-b072-428c-6cbfc0f9a280@linux.ibm.com>
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
        <20201223011606.5265-7-akrowiak@linux.ibm.com>
        <20210111214037.477f0f03.pasic@linux.ibm.com>
        <270e192b-b88d-b072-428c-6cbfc0f9a280@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-14_10:2021-01-14,2021-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 clxscore=1015 lowpriorityscore=0 mlxlogscore=999 malwarescore=0
 spamscore=0 bulkscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150003
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Jan 2021 12:54:39 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> >>   /**
> >>    * vfio_ap_mdev_verify_no_sharing
> >>    *
> >> - * Verifies that the APQNs derived from the cross product of the AP adapter IDs
> >> - * and AP queue indexes comprising the AP matrix are not configured for another
> >> - * mediated device. AP queue sharing is not allowed.
> >> + * Verifies that each APQN derived from the Cartesian product of the AP adapter
> >> + * IDs and AP queue indexes comprising the AP matrix are not configured for
> >> + * another mediated device. AP queue sharing is not allowed.
> >>    *
> >> - * @matrix_mdev: the mediated matrix device
> >> + * @matrix_mdev: the mediated matrix device to which the APQNs being verified
> >> + *		 are assigned.
> >> + * @mdev_apm: mask indicating the APIDs of the APQNs to be verified
> >> + * @mdev_aqm: mask indicating the APQIs of the APQNs to be verified
> >>    *
> >> - * Returns 0 if the APQNs are not shared, otherwise; returns -EADDRINUSE.
> >> + * Returns 0 if the APQNs are not shared, otherwise; returns -EBUSY.
> >>    */
> >> -static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
> >> +static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev,
> >> +					  unsigned long *mdev_apm,
> >> +					  unsigned long *mdev_aqm)
> >>   {
> >>   	struct ap_matrix_mdev *lstdev;
> >>   	DECLARE_BITMAP(apm, AP_DEVICES);
> >> @@ -523,20 +426,31 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
> >>   		 * We work on full longs, as we can only exclude the leftover
> >>   		 * bits in non-inverse order. The leftover is all zeros.
> >>   		 */
> >> -		if (!bitmap_and(apm, matrix_mdev->matrix.apm,
> >> -				lstdev->matrix.apm, AP_DEVICES))
> >> +		if (!bitmap_and(apm, mdev_apm, lstdev->matrix.apm, AP_DEVICES))
> >>   			continue;
> >>   
> >> -		if (!bitmap_and(aqm, matrix_mdev->matrix.aqm,
> >> -				lstdev->matrix.aqm, AP_DOMAINS))
> >> +		if (!bitmap_and(aqm, mdev_aqm, lstdev->matrix.aqm, AP_DOMAINS))
> >>   			continue;
> >>   
> >> -		return -EADDRINUSE;
> >> +		vfio_ap_mdev_log_sharing_err(dev_name(mdev_dev(lstdev->mdev)),
> >> +					     apm, aqm);
> >> +
> >> +		return -EBUSY;  
> > Why do we change -EADDRINUSE to -EBUSY? This gets bubbled up to
> > userspace, or? So a tool that checks for the other mdev has it
> > condition by checking for -EADDRINUSE, would be confused...  
> 
> Back in v8 of the series, Christian suggested the occurrences
> of -EADDRINUSE should be replaced by the more appropriate
> -EBUSY (Message ID <d7954c15-b14f-d6e5-0193-aadca61883a8@de.ibm.com>),
> so I changed it here. It does get bubbled up to userspace, so you make a 
> valid point. I will
> change it back. I will, however, set the value returned from the
> __verify_card_reservations() function in ap_bus.c to -EBUSY as
> suggested by Christian.

As long as the error code for an ephemeral failure due to can't take a
lock right now, and the error code for a failure due to a sharing
conflict are (which most likely requires admin action to be resolved)
I'm fine.

Choosing EBUSY for sharing conflict, and something else for can't take
lock for the bus attributes, while choosing EADDRINUSE for sharing
conflict, and EBUSY for can't take lock in the case of the mdev
attributes (assign_*; unassign_*) sounds confusing to me, but is still
better than collating the two conditions. Maybe we can choose EAGAIN
or EWOULDBLOCK for the can't take the lock right now. I don't know.

I'm open to suggestions. And if Christian wants to change this for
the already released interfaces, I will have to live with that. But it
has to be a conscious decision at least.

What I consider tricky about EBUSY, is that according to my intuition,
in pseudocode, object.operation(argument) returns -EBUSY probably tells
me that object is busy (i.e. is in the middle of something incompatible
with performing operation). In our case, it is not the object that is
busy, but the resource denoted by the argument.

Regards,
Halil
