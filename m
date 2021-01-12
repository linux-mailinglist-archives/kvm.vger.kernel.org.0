Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 301A02F3625
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 17:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390490AbhALQuZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 11:50:25 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41420 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728583AbhALQuZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 11:50:25 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10CGhYHD049845;
        Tue, 12 Jan 2021 11:49:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=CPMisSnatD+99YHPEmUR1gJHKPbc6b/P6VGnKEl2XEg=;
 b=WIxRtdVJkgC2F1P0pAbAhstw5Fm4CSpnf+4WSbX0PmlNljQKYP62l2Q4kIX5xLduynUb
 FRSqWGwEHWFOXAlWbGXPUGUGNyPdNypz8Q6BEbcQBPRYWuS3hUHGyDNBF5JzKBiv2aWO
 JBou5WE3pNT/BqhYfJ47oaks4Z0XvFa1CeGXs+yujgMhdPypssRIVUQARh1dDBPXZhYS
 mvXoLIVNUPtPT7L2dZF2sYpQhESrmM+c2p5C3sUoAwpzcZtP4W1DqKBstW/eBm2lsmnt
 xFNKAnmp3iwwJp5DO0F3m36VfhVdbcl3uIq70gdpsw/JhLK1QhUsG1upaYFeY/1hmAzq ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361fhr85um-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 11:49:44 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10CGiosU057090;
        Tue, 12 Jan 2021 11:49:44 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361fhr85tr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 11:49:43 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10CGmwKT027605;
        Tue, 12 Jan 2021 16:49:41 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 35y44820qm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 16:49:41 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10CGncTG40829412
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 16:49:38 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 633EC5204E;
        Tue, 12 Jan 2021 16:49:38 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.60.135])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id A848352050;
        Tue, 12 Jan 2021 16:49:37 +0000 (GMT)
Date:   Tue, 12 Jan 2021 17:49:35 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v13 11/15] s390/vfio-ap: implement in-use callback for
 vfio_ap driver
Message-ID: <20210112174935.41cbda87.pasic@linux.ibm.com>
In-Reply-To: <d717a554-6d0c-6075-38fd-e725b9622437@linux.ibm.com>
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
        <20201223011606.5265-12-akrowiak@linux.ibm.com>
        <20210112022012.4bad464f.pasic@linux.ibm.com>
        <d717a554-6d0c-6075-38fd-e725b9622437@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_12:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 lowpriorityscore=0
 impostorscore=0 spamscore=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120091
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 12 Jan 2021 09:14:07 -0500
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> On 1/11/21 8:20 PM, Halil Pasic wrote:
> > On Tue, 22 Dec 2020 20:16:02 -0500
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >   
> >> Let's implement the callback to indicate when an APQN
> >> is in use by the vfio_ap device driver. The callback is
> >> invoked whenever a change to the apmask or aqmask would
> >> result in one or more queue devices being removed from the driver. The
> >> vfio_ap device driver will indicate a resource is in use
> >> if the APQN of any of the queue devices to be removed are assigned to
> >> any of the matrix mdevs under the driver's control.
> >>
> >> There is potential for a deadlock condition between the matrix_dev->lock
> >> used to lock the matrix device during assignment of adapters and domains
> >> and the ap_perms_mutex locked by the AP bus when changes are made to the
> >> sysfs apmask/aqmask attributes.
> >>
> >> Consider following scenario (courtesy of Halil Pasic):
> >> 1) apmask_store() takes ap_perms_mutex
> >> 2) assign_adapter_store() takes matrix_dev->lock
> >> 3) apmask_store() calls vfio_ap_mdev_resource_in_use() which tries
> >>     to take matrix_dev->lock
> >> 4) assign_adapter_store() calls ap_apqn_in_matrix_owned_by_def_drv
> >>     which tries to take ap_perms_mutex
> >>
> >> BANG!
> >>
> >> To resolve this issue, instead of using the mutex_lock(&matrix_dev->lock)
> >> function to lock the matrix device during assignment of an adapter or
> >> domain to a matrix_mdev as well as during the in_use callback, the
> >> mutex_trylock(&matrix_dev->lock) function will be used. If the lock is not
> >> obtained, then the assignment and in_use functions will terminate with
> >> -EBUSY.
> >>
> >> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> >> ---
> >>   drivers/s390/crypto/vfio_ap_drv.c     |  1 +
> >>   drivers/s390/crypto/vfio_ap_ops.c     | 21 ++++++++++++++++++---
> >>   drivers/s390/crypto/vfio_ap_private.h |  2 ++
> >>   3 files changed, 21 insertions(+), 3 deletions(-)
> >>  
> > [..]  
> >>   }
> >> +
> >> +int vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm)
> >> +{
> >> +	int ret;
> >> +
> >> +	if (!mutex_trylock(&matrix_dev->lock))
> >> +		return -EBUSY;
> >> +	ret = vfio_ap_mdev_verify_no_sharing(NULL, apm, aqm);  
> > 
> > If we detect that resources are in use, then we spit warnings to the
> > message log, right?
> > 
> > @Matt: Is your userspace tooling going to guarantee that this will never
> > happen?  
> 
> Yes, but only when using the tooling to modify apmask/aqmask.  You would 
> still be able to create such a scenario by bypassing the tooling and 
> invoking the sysfs interfaces directly.
> 
> 

Since, I suppose, the tooling is going to catch this anyway, and produce
much better feedback to the user, I believe we should be fine degrading
the severity to info or debug. 

I would prefer not producing a warning here, because I believe it is
likely to do more harm, than good (by implying a kernel problem, as I
don't think based on the message one will think that it is an userspace
problem). But if everybody else agrees, that we want a warning here, then
I can live with that as well.

Regards,
Halil
