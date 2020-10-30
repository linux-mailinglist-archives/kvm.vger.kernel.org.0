Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B6C2A0CA2
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 18:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgJ3Rmw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 13:42:52 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18876 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726873AbgJ3Rmv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Oct 2020 13:42:51 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09UHWrvS005795;
        Fri, 30 Oct 2020 13:42:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=PzfPzrlZS4/NE7RAe34/AFVliQy6XVFJveRmvBjyQ8o=;
 b=kMDZAtH8NCWrGs9qG/6Rvzh3KlP+yd6dqWIFOLVJR9x5bKK1pfvhaL0kxeScBZTjB4YV
 kUTZi8ZB5tkWo59xBMVOapjMCIVn9Yzdk3wpHUr4EPvw5engqS43df4939KYYHxaCdeJ
 FOcn+TmSAvC82vyY3itFMbUsWQCPAoNLW2VyntFq4n42WOiB/cDUVhlJL50l1yGbVQqR
 F0RvBmxhhvcD4V5EtmAXudqa1nojmz92/SsMD81cvgll/yYKenrurR9KXit50CV/Bznc
 250q/ug3/WD1pI5+vvUxd3XtC8n7shSfHQ53l1ghlJvK41NCRiQrJQ5Tn8nB1ZY3Wrky 2A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34gp17jpnh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 13:42:51 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09UHZO0x020137;
        Fri, 30 Oct 2020 13:42:50 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34gp17jpmp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 13:42:50 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09UHbtFq032658;
        Fri, 30 Oct 2020 17:42:48 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 34f7s3s8xt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 17:42:48 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09UHgjFI30671170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Oct 2020 17:42:45 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43F814C04A;
        Fri, 30 Oct 2020 17:42:45 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FA6C4C044;
        Fri, 30 Oct 2020 17:42:44 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.172.93])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 30 Oct 2020 17:42:44 +0000 (GMT)
Date:   Fri, 30 Oct 2020 18:42:42 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v11 01/14] s390/vfio-ap: No need to disable IRQ after
 queue reset
Message-ID: <20201030184242.3bceee09.pasic@linux.ibm.com>
In-Reply-To: <7a2c5930-9c37-8763-7e5d-c08a3638e6a1@linux.ibm.com>
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
        <20201022171209.19494-2-akrowiak@linux.ibm.com>
        <20201027074846.30ee0ddc.pasic@linux.ibm.com>
        <7a2c5930-9c37-8763-7e5d-c08a3638e6a1@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-30_08:2020-10-30,2020-10-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 suspectscore=2 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010300131
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 29 Oct 2020 19:29:35 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> >> @@ -1177,7 +1166,10 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
> >>   			 */
> >>   			if (ret)
> >>   				rc = ret;
> >> -			vfio_ap_irq_disable_apqn(AP_MKQID(apid, apqi));
> >> +			q = vfio_ap_get_queue(matrix_mdev,
> >> +					      AP_MKQID(apid, apqi));
> >> +			if (q)
> >> +				vfio_ap_free_aqic_resources(q);  
> > Is it safe to do vfio_ap_free_aqic_resources() at this point? I don't
> > think so. I mean does the current code (and vfio_ap_mdev_reset_queue()
> > in particular guarantee that the reset is actually done when we arrive
> > here)? BTW, I think we have a similar problem with the current code as
> > well.  
> 
> If the return code from the vfio_ap_mdev_reset_queue() function
> is zero, then yes, we are guaranteed the reset was done and the
> queue is empty.

I've read up on this and I disagree. We should discuss this offline.

>  The function returns a non-zero return code if
> the reset fails or the queue the reset did not complete within a given
> amount of time, so maybe we shouldn't free AQIC resources when
> we get a non-zero return code from the reset function?
> 

If the queue is gone, or broken, it won't produce interrupts or poke the
notifier bit, and we should clean up the AQIC resources.


> There are three occasions when the vfio_ap_mdev_reset_queues()
> is called:
> 1. When the VFIO_DEVICE_RESET ioctl is invoked from userspace
>      (i.e., when the guest is started)
> 2. When the mdev fd is closed (vfio_ap_mdev_release())
> 3. When the mdev is removed (vfio_ap_mdev_remove())
> 
> The IRQ resources are initialized when the PQAP(AQIC)
> is intercepted to enable interrupts. This would occur after
> the guest boots and the AP bus initializes. So, 1 would
> presumably occur before that happens. I couldn't find
> anywhere in the AP bus or zcrypt code where a PQAP(AQIC)
> is executed to disable interrupts, so my assumption is
> that IRQ disablement is accomplished by a reset on
> the guest. I'll have to ask Harald about that. So, 2 would
> occur when the guest is about to terminate and 3
> would occur only after the guest is terminated. In any
> case, it seems that IRQ resources should be cleaned up.
> Maybe it would be more appropriate to do that in the
> vfio_ap_mdev_release() and vfio_ap_mdev_remove()
> functions themselves?

I'm a bit confused. But I think you are wrong. What happens when the
guest reIPLs? I guess the subsystem reset should also do the
VFIO_DEVICE_RESET ioctl, and that has to reset the queues and disable
the interrupts. Or?

Regards,
Halil

