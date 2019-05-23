Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55C6F2815C
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 17:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731100AbfEWPgU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 11:36:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44606 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730913AbfEWPgU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 May 2019 11:36:20 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4NFXFin055300
        for <kvm@vger.kernel.org>; Thu, 23 May 2019 11:36:19 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2snwb83a6a-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 23 May 2019 11:36:19 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <akrowiak@linux.ibm.com>;
        Thu, 23 May 2019 16:36:18 +0100
Received: from b01cxnp23033.gho.pok.ibm.com (9.57.198.28)
        by e14.ny.us.ibm.com (146.89.104.201) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 23 May 2019 16:36:15 +0100
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4NFaD3440239452
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 May 2019 15:36:13 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CF8A2805A;
        Thu, 23 May 2019 15:36:13 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C3D2D28059;
        Thu, 23 May 2019 15:36:12 +0000 (GMT)
Received: from [9.85.195.246] (unknown [9.85.195.246])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 23 May 2019 15:36:12 +0000 (GMT)
Subject: Re: [PATCH v9 0/4] vfio: ap: AP Queue Interrupt Control
To:     Pierre Morel <pmorel@linux.ibm.com>, borntraeger@de.ibm.com
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, frankja@linux.ibm.com, pasic@linux.ibm.com,
        david@redhat.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, freude@linux.ibm.com, mimu@linux.ibm.com
References: <1558452877-27822-1-git-send-email-pmorel@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Date:   Thu, 23 May 2019 11:36:12 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1558452877-27822-1-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19052315-0052-0000-0000-000003C6077C
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011149; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01207499; UDB=6.00634153; IPR=6.00988479;
 MB=3.00027020; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-23 15:36:17
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052315-0053-0000-0000-00006104218B
Message-Id: <5b46f988-fa79-4d84-c81f-144daa0c4426@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-23_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905230106
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/21/19 11:34 AM, Pierre Morel wrote:
> This patch series implements PQAP/AQIC interception in KVM.
> 
> 1) Data to handle GISA interrupt for AQIC
> 
> To implement this we need to add a new structure, vfio_ap_queue,
> to be able to retrieve the mediated device associated with a queue
> and specific values needed to register/unregister the interrupt
> structures:
>    - APQN: to be able to issue the commands and search for queue
>      structures
>    - saved NIB : to keep track of the pin page for unpining it
>    - saved ISC : to unregister with the GIB interface
>    - matrix_mdev: to retrieve the associate matrix, the mediated device
>      and KVM
> 
> Specific handling bei keeping old values when re-registering is
> needed because the guest could unregister interrupt in a invisble
> manner bei issuing an un-interceptible RESET command.
> 
> Reset commands issued directly by the guest and indirectly when
> removing the guest unpin the memory and deregister the ISC.
> 
> The vfio_ap_queue is associated to the ap_device during the probe
> of the device and dissociated during the remove of the ap_device.
> 
> The vfio_ap_queue is associated to the matrix mediated device during
> each interception of the AQIC command, so it does not need to be
> dissociated until the guest is terminated.
> 
> The life of the vfio_ap_queue will be protected by the matrix_dev lock
> to guaranty that no change can occur to the CRYCB or that devices can
> not be removed when a vfio_ap_queue is in use.
> 
> 2) KVM destroy race conditions
> 
> To make sure that KVM do not vanish and GISA is still available
> when the VFIO_AP driver is in used we take a reference to KVM
> during the opening of the mediated device and release it on
> releasing the mediated device.
> 
> 3) Interception of PQAP
> 
> The driver registers a hook structure to KVM providing:
> - a pointer to a function implementing PQAP(AQIC) handling
> - the reference to the module owner of the hook
> 
> On interception by KVM we do not change the behavior, returning
>   -EOPNOTSUPP to the user in the case AP instructions are not
> supported by the host or by the guest.
> Otherwise we verify the exceptions cases before trying to call
> the vfio_ap hook.
> 
> In the case we do not find a hook we assume that the CRYCB has not
> been setup for the guest and is empty.
> 
> 4) Enabling and disabling the IRQ
> 
> When enabling the IRQ care is taken to unping the saved NIB.
> When disabling IRQ care is taken to wait until the IRQ bit
> of the queue status is cleared before unpining the NIB.
> 
> On RESET and before unpinning the NIB and unregistering the ISC
> the IRQ is disabled using PQAP/AQIC even when a PQAP/APZQ have
> been done.
> 
> 5) Removing the AP device
> 
> Removing the AP device without having unassign it is clearly
> discourage by the documentation.
> The patch series does not check if the queue is used by a
> guest. It only de-register the IRQ, unregister ISC and unpin
> the NIB, then free the vfio_ap_queue.
> 
> 6) Associated QEMU patch
> 
> There is a QEMU patch which is needed to enable the PQAP/AQIC
> facility in the guest.
> 
> Posted in qemu-devel@nongnu.org as:
> Message-Id: <1550146494-21085-1-git-send-email-pmorel@linux.ibm.com>
> 
> 7) Compatibility with Dynamic configuration patches
> 
> Tony, I did not rebase this series above the dynamic configuration
> patches because:
> - This series do the work it needs to do without having to take
>    care on the dynamic configuration.
> - It is guarantied that interrupt will be shut off after removing
>    the APQueue device
> - The dynamic configuration series is not converging.

Would you consider the following?

* Take dynconfig patch "s390: vfio-ap: wait for queue empty on queue
   reset" and include it in your series. This patch modifies the
   reset function to wait for queue empty.

* In dynconfig patch "s390: vfio-ap: handle bind and unbind of AP queue
   device" the following functions are introduced:

      void vfio_ap_mdev_probe_queue(struct ap_queue *queue)
      void vfio_ap_mdev_remove_queue(struct ap_queue *queue)

   The vfio_ap_mdev_probe_queue function is called from the vfio_ap
   driver probe callback. You could embed the code you've introduced in
   the probe callback there. Of course, you would need to return int
   from the function for the -ENOMEM error.

   The vfio_ap_mdev_remove_queue function is called from the vfio_ap
   driver remove callback. You could embed the code you've introduced in
   the remove callback there.

* Move your vfio_ap_irq_disable function to vfio_ap_ops.c and make it a
   static function.

* Leave the vfio_ap_mdev_reset_queue function as a static function in
   vfio_ap_ops.c

If you do the things above, then I can base the dynconfig series on
the IRQ series without much of a merge issue. What say you?

Note: I've included review comments for patch 3/4 to match the
       suggestions above.

> 
> However Tony, the choice is your's, I won't be able to help
> in a near future.
> 
> 
> Pierre Morel (4):
>    s390: ap: kvm: add PQAP interception for AQIC
>    vfio: ap: register IOMMU VFIO notifier
>    s390: ap: implement PAPQ AQIC interception in kernel
>    s390: ap: kvm: Enable PQAP/AQIC facility for the guest
> 
>   arch/s390/include/asm/kvm_host.h      |   7 +
>   arch/s390/kvm/priv.c                  |  86 ++++++++
>   arch/s390/tools/gen_facilities.c      |   1 +
>   drivers/s390/crypto/vfio_ap_drv.c     |  34 ++-
>   drivers/s390/crypto/vfio_ap_ops.c     | 379 +++++++++++++++++++++++++++++++++-
>   drivers/s390/crypto/vfio_ap_private.h |  15 ++
>   6 files changed, 514 insertions(+), 8 deletions(-)
> 

