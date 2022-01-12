Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6B648C5EE
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 15:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354080AbiALOZx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 09:25:53 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62702 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239105AbiALOZt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Jan 2022 09:25:49 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20CDr28F015803;
        Wed, 12 Jan 2022 14:25:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=2IXUEKfzeDElomINqFEw47xnwGcyhKdwCrRJWlaSCwE=;
 b=Jk89jKfRRXFvXkgzSKyaf4+tifLnHZlPD70gwd73Jnyg2CtXRcxypVmL64OXE8vP8xGM
 mcjBdZw7tnaEOf1mCBmODpM3jSW4zFR0JwB7B8N4y1SkCr5GFVp36inTLZz5bigNk7ud
 Zi1lPKWWbT6XvMm2bNqYX80JDcAs4tgoZaFTGHaHA0LUgjydl0/5nNYBXxQd1kNyMYd0
 1mibGytQPUURZAIRWAe25+xLK+G7vNJz0/sEVlKp7WIX0EaWuNUfKmLKXZytkMFtbBV7
 6yK8xZhspy996XDJdAFSzQThPe1lXaC5/fdAr62Rpk4ZVYquMr7oh3yQeXkR5wva/b0d rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dhycgt0tk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 14:25:46 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20CDvQle005371;
        Wed, 12 Jan 2022 14:25:46 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dhycgt0ss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 14:25:46 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20CECSPe004794;
        Wed, 12 Jan 2022 14:25:44 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3df289k07r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 14:25:44 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20CEPf6C35717422
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jan 2022 14:25:41 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C01B5204F;
        Wed, 12 Jan 2022 14:25:41 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.56.243])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id 8DE5452057;
        Wed, 12 Jan 2022 14:25:40 +0000 (GMT)
Date:   Wed, 12 Jan 2022 15:25:20 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v17 08/15] s390/vfio-ap: keep track of active guests
Message-ID: <20220112152520.4cd37e7c.pasic@linux.ibm.com>
In-Reply-To: <fcce7cc6-6ac7-b22a-a957-80e59a0f4e83@linux.ibm.com>
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
 <20211021152332.70455-9-akrowiak@linux.ibm.com>
 <20211230043322.2ba19bbd.pasic@linux.ibm.com>
 <fcce7cc6-6ac7-b22a-a957-80e59a0f4e83@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IdeELkvS6Iz10UxJKbgCPL9dYIy5D7zv
X-Proofpoint-ORIG-GUID: xkovmHWvlbf8TpuqnDpJFFAIk1HKzFEY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201120093
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Jan 2022 16:58:13 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 12/29/21 22:33, Halil Pasic wrote:
> > On Thu, 21 Oct 2021 11:23:25 -0400
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >  
> >> The vfio_ap device driver registers for notification when the pointer to
> >> the KVM object for a guest is set. Let's store the KVM pointer as well as
> >> the pointer to the mediated device when the KVM pointer is set.  
> > [..]
> >
> >  
> >> struct ap_matrix_dev {
> >>          ...
> >>          struct rw_semaphore guests_lock;
> >>          struct list_head guests;
> >>         ...
> >> }
> >>
> >> The 'guests_lock' field is a r/w semaphore to control access to the
> >> 'guests' field. The 'guests' field is a list of ap_guest
> >> structures containing the KVM and matrix_mdev pointers for each active
> >> guest. An ap_guest structure will be stored into the list whenever the
> >> vfio_ap device driver is notified that the KVM pointer has been set and
> >> removed when notified that the KVM pointer has been cleared.
> >>  
> > Is this about the field or about the list including all the nodes? This
> > reads lie guests_lock only protects the head element, which makes no
> > sense to me. Because of how these lists work.  
> 
> It locks the list, I can rewrite the description.
> 
> >
> > The narrowest scope that could make sense is all the list_head stuff
> > in the entire list. I.e. one would only need the lock to traverse or
> > manipulate the list, while the payload would still be subject to
> > the matrix_dev->lock mutex.  
> 
> The matrix_dev->guests lock is needed whenever the kvm->lock
> is needed because the struct ap_guest object is created and the
> struct kvm assigned to it when the kvm pointer is set
> (vfio_ap_mdev_set_kvm function). 

Yes reading the code, my impression was, that this is more about the
ap_guest.kvm that about the list.

My understanding is that struct ap_gurest is basically about the
marriage between a matrix_mdev and a kvm. Basically a link between the
two.

But then, it probably does not make a sense for this link to outlive
either kvm or matrix_mdev.

Thus I don't quite understand why do we need the extra allocation? If
we want a list, why don't we just the pointers to matrix_mdev?

We could still protect that stuff with a separate lock.

> So, in order to access the
> ap_guest object and retrieve the kvm pointer, we have to ensure
> the ap_guest_object is still available. The fact we can get the
> kvm pointer from the ap_matrix_mdev object just makes things
> more efficient - i.e., we won't have to traverse the list.

Well if the guests_lock is only protecting the list, then that should not
be true. In that case, you can be only sure about the nodes that you
reached by traversing the list with he lock held. Right.

If only the list is protected, then one could do

down_write(guests_lock)
list_del(element)
up_write(guests_lock)
fancy_free(element)


> 
> Whenever the kvm->lock and matrix_dev->lock mutexes must
> be held, the order is:
> 
>      matrix_dev->guests_lock
>      matrix_dev->guests->kvm->lock
>      matrix_dev->lock
> 
> There are times where all three locks are not required; for example,
> the handle_pqap and vfio_ap_mdev_probe/remove functions only
> require the matrix_dev->lock because it does not need to lock kvm.
> 

Yeah, that is what gets rid of the circular lock dependency. If we had
to take guests_lock there we would have guests_lock in the same role
as matrix_dev->lock before.

But the thing is you do 
kvm = q->matrix_mdev->guest->kvm;
in the pqap_handler (more precisely in a function called by it).

So you do access the struct ap_guest object and its kvm member
without the guests_lock being held. That is where things become very
muddy to me.

It looks to me that the kvm pointer is changed with both the
guests_lock and the matrix_dev->lock held in write mode. And accessing
such stuff read only is safe with either of the two locks held.

Thus I do believe that the general idea is viable. I've pointed that out
in a later email.

But the information you give the unsuspecting reader to aid him in
understanding our new locking scheme is severely lacking.

> >
> > [..]
> >  
> >> +struct ap_guest {
> >> +	struct kvm *kvm;
> >> +	struct list_head node;
> >> +};
> >> +
> >>   /**
> >>    * struct ap_matrix_dev - Contains the data for the matrix device.
> >>    *
> >> @@ -39,6 +44,9 @@
> >>    *		single ap_matrix_mdev device. It's quite coarse but we don't
> >>    *		expect much contention.
> >>    * @vfio_ap_drv: the vfio_ap device driver
> >> + * @guests_lock: r/w semaphore for protecting access to @guests
> >> + * @guests:	list of guests (struct ap_guest) using AP devices bound to the
> >> + *		vfio_ap device driver.  
> > Please compare the above. Also if it is only about the access to the
> > list, then you could drop the lock right after create, and not keep it
> > till the very end of vfio_ap_mdev_set_kvm(). Right?  
> 
> That would be true if it only controlled access to the list, but as I
> explained above, that is not its sole purpose.

Well, but guests is a member of struct ap_matrix_dev and not the whole
list including all the nodes.

> 
> >
> > In any case I'm skeptical about this whole struct ap_guest business. To
> > me, it looks like something that just makes things more obscure and
> > complicated without any real benefit.  
> 
> I'm open to other ideas, but you'll have to come up with a way
> to take the kvm->lock before the matrix_mdev->lock in the
> vfio_ap_mdev_probe_queue and vfio_ap_mdev_remove_queue
> functions where we don't have access to the ap_matrix_mdev
> object to which the APQN is assigned and has the pointer to the
> kvm object.
> 
> In order to retrieve the matrix_mdev, we need the matrix_dev->lock.
> In order to hot plug/unplug the queue, we need the kvm->lock.
> There's your catch-22 that needs to be solved. This design is my
> attempt to solve that.
> 

I agree that having a lock that we take before kvm->lock is taken,
and another one that we take with the kvm->lock taken is a good idea.

I was referring to having ap_guest objects which are separately
allocated, and have a decoupled lifecycle. Please see above!

Regards,
Halil
[..]
