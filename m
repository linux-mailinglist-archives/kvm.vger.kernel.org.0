Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C062A0CE2
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 18:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgJ3RyT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 13:54:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61024 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726061AbgJ3RyT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Oct 2020 13:54:19 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09UHVbO4115974;
        Fri, 30 Oct 2020 13:54:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=hQ9GXhTjWObrlTROl5RhWZO9DgdbO9lvN76ob0g41pw=;
 b=NYrLVd/atGE6GExxexNNiWKrExV4LXm/xSAU5ApiDrivKJAxypU+2qmhZegqbnixQNc5
 Sdr8IjmWpWMjfWLupXXGpOo1hdZYkebjXv0yeRKD/zdNmkVQBB8fnswrDerYRlxzZ1kH
 J/t4b8Xe5aAgfVPYZ8PRXXJxXamSzEZKVtxCNdeTAwVKKJEYE/czCgOlVjSzQU9pw/Ne
 bErX55hJHSTorqaKQ/yl6dNyV5ZvhPSAXITdJYx7T/uAtDc631RXYMhBl4e6p6JBj+f+
 4mHnMT8voeoZ+M4q67DekaDT1fAGInt4k0a/OZPVxRW4RZBQ39DM8iHI3pzZTApf+JKj 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34gq9arp2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 13:54:14 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09UHVh8j116383;
        Fri, 30 Oct 2020 13:54:13 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34gq9arp1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 13:54:13 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09UHqLYQ015819;
        Fri, 30 Oct 2020 17:54:11 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 34f8craa5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 17:54:11 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09UHs8rV17760698
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Oct 2020 17:54:08 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A04CBA405B;
        Fri, 30 Oct 2020 17:54:08 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA14EA4051;
        Fri, 30 Oct 2020 17:54:07 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.172.93])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 30 Oct 2020 17:54:07 +0000 (GMT)
Date:   Fri, 30 Oct 2020 18:54:06 +0100
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
Message-ID: <20201030185406.7fa13fbe.pasic@linux.ibm.com>
In-Reply-To: <7a2c5930-9c37-8763-7e5d-c08a3638e6a1@linux.ibm.com>
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
        <20201022171209.19494-2-akrowiak@linux.ibm.com>
        <20201027074846.30ee0ddc.pasic@linux.ibm.com>
        <7a2c5930-9c37-8763-7e5d-c08a3638e6a1@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-30_07:2020-10-30,2020-10-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 suspectscore=2 adultscore=0 mlxlogscore=924 spamscore=0
 bulkscore=0 malwarescore=0 impostorscore=0 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010300127
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

[..]

> >
> > Under what circumstances do we expect !q? If we don't, then we need to
> > complain one way or another.  
> 
> In the current code (i.e., prior to introducing the subsequent hot
> plug patches), an APQN can not be assigned to an mdev unless it
> references a queue device bound to the vfio_ap device driver; however,
> there is nothing preventing a queue device from getting unbound
> while the guest is running (one of the problems mostly resolved by this
> series). In that case, q would be NULL.

But if the queue does not belong to us any more it does not make sense
call vfio_ap_mdev_reset_queue() on it's APQN, or?

I think we should have 

if(!q)
	continue; 
at the very beginning of the loop body, or we want to be sure that q is
not null. 

