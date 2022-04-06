Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE5894F5E49
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 14:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiDFMb4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 08:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbiDFMao (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 08:30:44 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A89E37F142;
        Wed,  6 Apr 2022 01:24:08 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2367e10h030535;
        Wed, 6 Apr 2022 08:24:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=PRBSsyd074bJLsUiiP1X62Go97vBLuZOyjv2kzo5KXE=;
 b=lRoCHzfJEjTfenUD/9STCHBFfgkXhn7H20c5LGKvUmV2nLxJJihAw7ll/RVb4tWNcceC
 dCijNu1pTZNvPg8wM5wcJr1827g1Z/oEXBzXlf5uXe579c15tLQWygPNa63ydilFwKp7
 buIIneXNZQ521UkLd29bXV4Iyr5DFxv7Q0Oh7500aPeY482WNy60oB56QvU+GKhWU2Eo
 I/xlIFNW3T7lsMfN7nD+eKzPYmSxjBhBcduBWPIuZWUaD/N0SzO6lHhuiH4UK1ZGqpSb
 b15xtnVk+hSi38jmFL+Ehs+wpqOLWFFEyi1+cA2MCSbllW3s4G2hq97w1bjHU5dzwaKn hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f96b1s3am-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Apr 2022 08:24:06 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2367f9nj000880;
        Wed, 6 Apr 2022 08:24:05 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f96b1s39r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Apr 2022 08:24:05 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2368DkOK017075;
        Wed, 6 Apr 2022 08:24:03 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3f6e48x38w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Apr 2022 08:24:03 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2368O0ds46793140
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Apr 2022 08:24:00 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 313474C040;
        Wed,  6 Apr 2022 08:24:00 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E79A4C046;
        Wed,  6 Apr 2022 08:23:58 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.47.41])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Wed,  6 Apr 2022 08:23:58 +0000 (GMT)
Date:   Wed, 6 Apr 2022 10:23:31 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v18 17/18] s390/Docs: new doc describing lock usage by
 the vfio_ap device driver
Message-ID: <20220406102331.5191f78c.pasic@linux.ibm.com>
In-Reply-To: <2a28e572-a9c8-4a8b-da17-8e8a2c01c2b6@linux.ibm.com>
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
        <20220215005040.52697-18-akrowiak@linux.ibm.com>
        <20220331022852.7f4d86a5.pasic@linux.ibm.com>
        <2a28e572-a9c8-4a8b-da17-8e8a2c01c2b6@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lF87WCN7AW6kJnyqyiF4lf4XTT0IgAsq
X-Proofpoint-ORIG-GUID: YmPHUJnMYVsscFp5ucaIeMznW8EPFX6O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_02,2022-04-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204060038
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 4 Apr 2022 17:34:48 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 3/30/22 20:28, Halil Pasic wrote:
> > On Mon, 14 Feb 2022 19:50:39 -0500
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >  
> >> Introduces a new document describing the locks used by the vfio_ap device
> >> driver and how to use them so as to avoid lockdep reports and deadlock
> >> situations.
> >>
> >> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> >> ---
> >>   Documentation/s390/vfio-ap-locking.rst | 389 +++++++++++++++++++++++++
> >>   1 file changed, 389 insertions(+)
> >>   create mode 100644 Documentation/s390/vfio-ap-locking.rst
> >>
> >> diff --git a/Documentation/s390/vfio-ap-locking.rst b/Documentation/s390/vfio-ap-locking.rst
> >> new file mode 100644
> >> index 000000000000..10abbb6d6089
> >> --- /dev/null
> >> +++ b/Documentation/s390/vfio-ap-locking.rst
> >> @@ -0,0 +1,389 @@
> >> +======================
> >> +VFIO AP Locks Overview
> >> +======================
> >> +This document describes the locks that are pertinent to the secure operation
> >> +of the vfio_ap device driver. Throughout this document, the following variables
> >> +will be used to denote instances of the structures herein described:
> >> +
> >> +struct ap_matrix_dev *matrix_dev;
> >> +struct ap_matrix_mdev *matrix_mdev;
> >> +struct kvm *kvm;
> >> +
> >> +The Matrix Devices Lock (drivers/s390/crypto/vfio_ap_private.h)
> >> +--------------------------------------------------------------
> >> +
> >> +struct ap_matrix_dev {
> >> +	...
> >> +	struct list_head mdev_list;
> >> +	struct mutex mdevs_lock;
> >> +	...
> >> +}
> >> +
> >> +The Matrix Devices Lock (matrix_dev->mdevs_lock) is implemented as a global
> >> +mutex contained within the single instance of struct ap_matrix_dev. This lock  
> > s/single instance of/singleton object of type/  
> 
> I don't see the problem with instance, but I'll go ahead and make the 
> change.

My problem is not with the word "instance", and problem is too strong
word anyway. I think that "the single instance of" is a little vague,
because there is ambiguity about the singularity (and existence) of
the single instance. If you have multiple servers, you may have several
"the single instances" in that system (one per kernel, or none if no
vfio-ap module is loaded for example). If you have a nested
visualization setup, one can even argue that there are multiple instances
of "the single instance" within one Linux system.

I see an advantage in using the "singleton object", because most of us
have at least heard of the singleton design pattern, if not learned
about it in class, and thus the scope of singularity is much better
defined.


> 
> >  
> >> +controls access to all fields contained within each matrix_mdev instance under
> >> +the control of the vfio_ap device driver (matrix_dev->mdev_list).  
> > Are there matrix_mdev instances not under the control of the vfio_ap
> > device driver?  
> 
> No, but it doesn't make the statement any less true. 

No it does not make it less true, just more confusing. By that logic you
could logical and every of your statements with all the tautologies of
this world.

>I'll take it out, 
> however.
> 
> >
> > (MARK 1)
> >  
> >> This lock must
> >> +be held while reading from, writing to or using the data from a field contained
> >> +within a matrix_mdev instance representing one of the vfio_ap device driver's
> >> +mediated devices.  
> > This makes it look like for example struct vfio_ap_queue objects are out
> > of scope.  
> 
> How so? The vfio_ap_queue objects are linked to the ap_matrix_mdev object

The *key* are the words "linked" versus "a field contained within a
matrix_mdev".

> to which the APQN is assigned. Other than that, they are contained in 
> the driver
> data of the queue device.

The vfio_ap_queue object a separate object allocated in
vfio_ap_mdev_probe_queue() and is certainly not a field contained within
a matrix_mdev.

Please notice that if you were to extend to all the objects reachable
from matrix_mdev instances, you would be in trouble, because a pointer
to kvm is also reachable, and via that pointer an awful lot of things
that are certainly out of scope.


> 
> >  
> >> +
> >> +The KVM Lock (include/linux/kvm_host.h)
> >> +---------------------------------------
> >> +
> >> +struct kvm {
> >> +	...
> >> +	struct mutex lock;
> >> +	...
> >> +}
> >> +
> >> +The KVM Lock (kvm->lock) controls access to the state data for a KVM guest. This
> >> +lock must be held by the vfio_ap device driver while one or more AP adapters,
> >> +domains or control domains are being plugged into or unplugged from the guest.
> >> +
> >> +The vfio_ap device driver registers a function to be notified when the pointer
> >> +to the kvm instance has been set. The KVM pointer is passed to the handler by
> >> +the notifier and is stored in the in the matrix_mdev instance
> >> +(matrix_mdev->kvm = kvm) containing the state of the mediated device that has
> >> +been passed through to the KVM guest.
> >> +
> >> +The Guests Lock (drivers/s390/crypto/vfio_ap_private.h)
> >> +-----------------------------------------------------------
> >> +
> >> +struct ap_matrix_dev {
> >> +	...
> >> +	struct list_head mdev_list;
> >> +	struct mutex guests_lock;
> >> +	...
> >> +}
> >> +
> >> +The Guests Lock (matrix_dev->guests_lock) controls access to the
> >> +matrix_mdev instances (matrix_dev->mdev_list) that represent mediated devices
> >> +that hold the state for the mediated devices that have been passed through to a  
> > Didn't say that access to fields of matrix_mdev instances is controlled
> > by the matrix_dev->mdevs lock at (MARK 1)? How do the two statements
> > mesh?  
> 
> The matrix_dev->mdevs_lock controls access to all FIELDS contained within each matrix_mdev
> and the matrix_dev->guests_lock controls access to matrix_mdev instances; in other words, the
> matrix_dev->mdev_list and the matrix_mdev instances for the purposes further described
> below.
> 

See above.

> 
> 
> >  
> >> +KVM guest. This lock must be held:
> >> +
> >> +1. To control access to the KVM pointer (matrix_mdev->kvm) while the vfio_ap
> >> +   device driver is using it to plug/unplug AP devices passed through to the KVM
> >> +   guest.
> >> +
> >> +2. To add matrix_mdev instances to or remove them from matrix_dev->mdev_list.
> >> +   This is necessary to ensure the proper locking order when the list is perused
> >> +   to find an ap_matrix_mdev instance for the purpose of plugging/unplugging
> >> +   AP devices passed through to a KVM guest.
> >> +
> >> +   For example, when a queue device is removed from the vfio_ap device driver,
> >> +   if the adapter is passed through to a KVM guest, it will have to be
> >> +   unplugged. In order to figure out whether the adapter is passed through,
> >> +   the matrix_mdev object to which the queue is assigned will have to be
> >> +   found. The KVM pointer (matrix_mdev->kvm) can then be used to determine if
> >> +   the mediated device is passed through (matrix_mdev->kvm != NULL) and if so,
> >> +   to unplug the adapter.
> >> +
> >> +It is not necessary to take the Guests Lock to access the KVM pointer if the
> >> +pointer is not used to plug/unplug devices passed through to the KVM guest;
> >> +however, in this case, the Matrix Devices Lock (matrix_dev->mdevs_lock) must be
> >> +held in order to access the KVM pointer since it set and cleared under the
> >> +protection of the Matrix Devices Lock. A case in point is the function that
> >> +handles interception of the PQAP(AQIC) instruction sub-function. This handler
> >> +needs to access the KVM pointer only for the purposes of setting or clearing IRQ
> >> +resources, so only the matrix_dev->mdevs_lock needs to be held.
> >> +  
> > It is very unclear what this lock is actually protecting, and when does
> > it need to be taken.  
> 
> I don't know how I can make it clearer. In 1 above, it states the it 
> protects
> access to the KVM pointer when it is being used to plug/unplug AP devices.
> In other words, if the matrix_mdev->kvm pointer is being accessed just
> to verify whether the mdev is attached to a guest or not, it is not 
> necessary to
> take the matrix_dev->guests_lock. On the other hand, whenever the 
> matrix_mdev->kvm
> pointer is being taken to dynamically update the guest's APCB (i.e., hot 
> plug/unplug AP
> devices), the matrix_dev->guests_lock must be held. Maybe if I had said 
> hot plug/unplug
> it would be clearer? I'm open to suggestions.
> 
> >  
> >> +The PQAP Hook Lock (arch/s390/include/asm/kvm_host.h)
> >> +-----------------------------------------------------
> >> +
> >> +typedef int (*crypto_hook)(struct kvm_vcpu *vcpu);
> >> +
> >> +struct kvm_s390_crypto {
> >> +	...
> >> +	struct rw_semaphore pqap_hook_rwsem;
> >> +	crypto_hook *pqap_hook;
> >> +	...
> >> +};
> >> +
> >> +The PQAP Hook Lock is a r/w semaphore that controls access to the function
> >> +pointer of the handler (*kvm->arch.crypto.pqap_hook) to invoke when the
> >> +PQAP(AQIC) instruction sub-function is intercepted by the host. The lock must be
> >> +held in write mode when pqap_hook value is set, and in read mode when the
> >> +pqap_hook function is called.
> >> +
> >> +Locking Order
> >> +-------------
> >> +
> >> +If the various locks are not taken in the proper order, it could potentially
> >> +result in a lockdep splat.  
> > Just in a lockdep splat or in a deadlock?  
> 
> I've never actually encountered a deadlock condition while testing,
> only a lockdep splat indicating a deadlock could occur. I'll go ahead
> and add 'deadlock or lockdep splat'.

Sorry, it is my sensitivity regarding situations were people claim they
are just fixing a compiler warning, where in reality that compiler
warning is just drawing attention to a severe bug. In my eyes lockdep
is just a tool to detect locking problems. Just focusing on the tool
is missing the point.

> 
> >  
> >> The proper order for taking locks depends upon
> >> +the operation taking place,  
> > That sounds very fishy! The whole point of having a locking order is
> > preventing deadlocks if everybody sticks to the locking order. If there
> > are exceptions, i.e. if we violate the locking order, we risk deadlocks.  
> 
> It may sound fishy, but it's a true statement. For example, there
> are cases where the mdev is not attached to a KVM guest.
> In that case, the matrix_mdev->kvm pointer will be NULL and
> the matrix_mdev->kvm->lock will not be taken. Of course, the
> matrix_dev->guests_lock will still have to be taken before the
> matrix_dev->mdevs_lock. 

But the locks are still taken in the very same order. You may never
have a situation where you first blocking-take A with B held, and another
one where you blocking-take B with A held. That is what "locking order"
is about in CS.

> Maybe I should just make that point
> clearer here.
> 
> After rereading the passage, I think that sentence should be
> removed. It can be seen in the examples when the KVM lock
> will not be taken.
> 

No having it on one place is great. If you don't state the lock
hierarchy in one place, people would need to extract it from the
jungle of scenarios.

[..]

Regards,
Halil
