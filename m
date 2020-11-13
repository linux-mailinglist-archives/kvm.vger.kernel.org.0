Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F462B2953
	for <lists+kvm@lfdr.de>; Sat, 14 Nov 2020 00:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgKMXrd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 18:47:33 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37702 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726020AbgKMXrc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Nov 2020 18:47:32 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ADNWvd9138683;
        Fri, 13 Nov 2020 18:47:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=xDFTBSjrBrGkKzm6bdFI3aIgultTMoneykdalu+EQX4=;
 b=B87T9WJRy6C/hZUTfqRHNOlYdAmFv7WkLtvt4CLNcnLCuMtKBPi11RkCbYtSfAn4QBzQ
 BE1yd7zpQYLaKKvZenodEtpKgxJQrB0i4Thy6M3tit+W571LVAdD1eO4T0E0yV09muFn
 J+OO3fEXHE3tsAYVd5rg4+v/ZBSw6J1Fmr+NsKHSYwUHcGrgGs3CN1dYzQFBUSn2m/Nu
 cFua2jFWId3wqo2T/Dx3pxdnSk6YShQ2Q3KEwM2kGrFnxQP6iNttELA49kyX3nEOecZL
 wsSsmVmlnJo/HINYTgBjfL3HIFhbefMpv3ixy3zuGuOGpgbKfrHaBLlOGWot80h4KIVI Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34t2up9qcw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 18:47:30 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0ADNX0TD138787;
        Fri, 13 Nov 2020 18:47:30 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34t2up9qcf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 18:47:29 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ADNflXT004556;
        Fri, 13 Nov 2020 23:47:28 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 34njuh3p3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 23:47:27 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ADNlPNU49611216
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Nov 2020 23:47:25 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C507AE04D;
        Fri, 13 Nov 2020 23:47:25 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D50AAE051;
        Fri, 13 Nov 2020 23:47:24 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.46.164])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Fri, 13 Nov 2020 23:47:24 +0000 (GMT)
Date:   Sat, 14 Nov 2020 00:47:22 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v11 05/14] s390/vfio-ap: implement in-use callback for
 vfio_ap driver
Message-ID: <20201114004722.76c999e0.pasic@linux.ibm.com>
In-Reply-To: <6a5feb16-46b5-9dca-7e85-7d344b0ffa24@linux.ibm.com>
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
        <20201022171209.19494-6-akrowiak@linux.ibm.com>
        <20201027142711.1b57825e.pasic@linux.ibm.com>
        <6a5feb16-46b5-9dca-7e85-7d344b0ffa24@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-13_21:2020-11-13,2020-11-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 suspectscore=0 phishscore=0
 impostorscore=0 mlxscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 malwarescore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011130151
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 Nov 2020 12:14:22 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:
[..]
> >>   }
> >>   
> >> +#define MDEV_SHARING_ERR "Userspace may not re-assign queue %02lx.%04lx " \
> >> +			 "already assigned to %s"
> >> +
> >> +static void vfio_ap_mdev_log_sharing_err(const char *mdev_name,
> >> +					 unsigned long *apm,
> >> +					 unsigned long *aqm)
> >> +{
> >> +	unsigned long apid, apqi;
> >> +
> >> +	for_each_set_bit_inv(apid, apm, AP_DEVICES)
> >> +		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS)
> >> +			pr_err(MDEV_SHARING_ERR, apid, apqi, mdev_name);
> > Isn't error rather severe for this? For my taste even warning would be
> > severe for this.
> 
> The user only sees a EADDRINUSE returned from the sysfs interface,
> so Conny asked if I could log a message to indicate which APQNs are
> in use by which mdev. I can change this to an info message, but it
> will be missed if the log level is set higher. Maybe Conny can put in
> her two cents here since she asked for this.
> 

I'm looking forward to Conny's opinion. :)

[..]
> >>   
> >> @@ -708,18 +732,18 @@ static ssize_t assign_adapter_store(struct device *dev,
> >>   	if (ret)
> >>   		goto done;
> >>   
> >> -	set_bit_inv(apid, matrix_mdev->matrix.apm);
> >> +	memset(apm, 0, sizeof(apm));
> >> +	set_bit_inv(apid, apm);
> >>   
> >> -	ret = vfio_ap_mdev_verify_no_sharing(matrix_mdev);
> >> +	ret = vfio_ap_mdev_verify_no_sharing(matrix_mdev, apm,
> >> +					     matrix_mdev->matrix.aqm);
> > What is the benefit of using a copy here? I mean we have the vfio_ap lock
> > so nobody can see the bit we speculatively flipped.
> 
> The vfio_ap_mdev_verify_no_sharing() function definition was changed
> so that it can also be re-used by the vfio_ap_mdev_resource_in_use()
> function rather than duplicating that code for the in_use callback. The
> in-use callback is invoked by the AP bus which has no concept of
> a mediated device, so I made this change to accommodate that fact.

Seems I was not clear enough with my question. Here you pass a local
apm which has the every bit 0 except the one corresponding to the
adapter we are trying to assign. The matrix.apm actually may have
more apm bits set. What we used to do, is set the matrix.apm bit,
verify, and clear it if verification fails. I think that
would still work.

The computational complexity is currently the same. For
some reason unknown to me ap_apqn_in_matrix_owned_by_def_drv() uses loops
instead of using bitmap operations. But it won't do any less work
if the apm argument is sparse. Same is true bitmap ops are used.

What you do here is not wrong, because if the invariants, which should
be maintained, are maintained, performing the check with the other
bits set in the apm is superfluous. But as I said before, actually
it ain't extra work, and if there was a bug, it could help us detect
it (because the assignment, that should have worked would fail).

Preparing the local apm isn't much extra work either, but I still
don't understand the change. Why can't you pass in matrix.apm
after set_bit_inv(apid, ...) like we use to do before?

Again, no big deal, but I just prefer to understand the whys.

> 
> >
> > I've also pointed out in the previous patch that in_use() isn't
> > perfectly reliable (at least in theory) because of a race.
> 
> We discussed that privately and determined that the sysfs assignment
> interfaces will use mutex_trylock() to avoid races.

I don't think, what we discussed is going to fix the race I'm referring
to here. But I do look forward to v12.

Regards,
Halil
