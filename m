Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 175AC554605
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 14:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352309AbiFVKnG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 06:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbiFVKnD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 06:43:03 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4AADA5;
        Wed, 22 Jun 2022 03:43:01 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25MAJUZn003179;
        Wed, 22 Jun 2022 10:42:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=PsCNyKOOZqPnqcmDFMSluKQ2I/QfRDgsea62aaTLfUQ=;
 b=a8MFftTEsCts1BkRCiPMYF8rzoSGS25UcP6COD677qjy4bcLnex2vVa5eTH3X75emVHu
 qHHcj5TwHyCxllOXIj+p1DjBjvn5f+hEpRQygPApS11LKYNcvNwjgGMj5iLpWkwqpiGu
 JX7J35cHqd+XoNUp1s5Pav3nsrGXTWLemyjzI1aamxNInTIVUIj8xWBkK09BrmXCpBJn
 HEqjKkZFrKBpyhabr7KvpODB/PMtMR4KVjCnHKlbNQTteKgCvpywgoGh0CdZNxyz4B7s
 M8Bno2w8vsro3+/sL2vWVtBwOQHAaS0FsPa75ScWhutGmebByHg2RPNc+Xj4CGaMRb+Y bQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gv17u0ph7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Jun 2022 10:42:59 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25MAToSc029339;
        Wed, 22 Jun 2022 10:42:58 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gv17u0pg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Jun 2022 10:42:58 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25MAaFkF023050;
        Wed, 22 Jun 2022 10:42:56 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3gs6b95g1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Jun 2022 10:42:56 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25MAg76221103060
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jun 2022 10:42:07 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 604A34C044;
        Wed, 22 Jun 2022 10:42:53 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F234B4C040;
        Wed, 22 Jun 2022 10:42:52 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.152.224.212])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Jun 2022 10:42:52 +0000 (GMT)
Date:   Wed, 22 Jun 2022 12:42:51 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jjherne@linux.ibm.com, freude@linux.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v20 00/20] s390/vfio-ap: dynamic configuration support
Message-ID: <20220622124251.1f03d301.pasic@linux.ibm.com>
In-Reply-To: <7b94f1fa-82c7-413e-ca32-02ddf4bec035@de.ibm.com>
References: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
        <7b94f1fa-82c7-413e-ca32-02ddf4bec035@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _r39BvUynNM8ZCKC5IPo54D6pxhw-JM_
X-Proofpoint-ORIG-GUID: dMcDCvIvTbHr2wIvT0AcwlGRFJggtU_a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-22_02,2022-06-22_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 priorityscore=1501 mlxscore=0 phishscore=0 adultscore=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206220052
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 22 Jun 2022 08:48:27 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Am 21.06.22 um 17:51 schrieb Tony Krowiak:
> > The current design for AP pass-through does not support making dynamic
> > changes to the AP matrix of a running guest resulting in a few
> > deficiencies this patch series is intended to mitigate:
> > 
> > 1. Adapters, domains and control domains can not be added to or removed
> >      from a running guest. In order to modify a guest's AP configuration,
> >      the guest must be terminated; only then can AP resources be assigned
> >      to or unassigned from the guest's matrix mdev. The new AP
> >      configuration becomes available to the guest when it is subsequently
> >      restarted.
> > 
> > 2. The AP bus's /sys/bus/ap/apmask and /sys/bus/ap/aqmask interfaces can
> >      be modified by a root user without any restrictions. A change to
> >      either mask can result in AP queue devices being unbound from the
> >      vfio_ap device driver and bound to a zcrypt device driver even if a
> >      guest is using the queues, thus giving the host access to the guest's
> >      private crypto data and vice versa.
> > 
> > 3. The APQNs derived from the Cartesian product of the APIDs of the
> >      adapters and APQIs of the domains assigned to a matrix mdev must
> >      reference an AP queue device bound to the vfio_ap device driver. The
> >      AP architecture allows assignment of AP resources that are not
> >      available to the system, so this artificial restriction is not
> >      compliant with the architecture.
> > 
> > 4. The AP configuration profile can be dynamically changed for the linux
> >      host after a KVM guest is started. For example, a new domain can be
> >      dynamically added to the configuration profile via the SE or an HMC
> >      connected to a DPM enabled lpar. Likewise, AP adapters can be
> >      dynamically configured (online state) and deconfigured (standby state)
> >      using the SE, an SCLP command or an HMC connected to a DPM enabled
> >      lpar. This can result in inadvertent sharing of AP queues between the
> >      guest and host.
> > 
> > 5. A root user can manually unbind an AP queue device representing a
> >      queue in use by a KVM guest via the vfio_ap device driver's sysfs
> >      unbind attribute. In this case, the guest will be using a queue that
> >      is not bound to the driver which violates the device model.
> > 
> > This patch series introduces the following changes to the current design
> > to alleviate the shortcomings described above as well as to implement
> > more of the AP architecture:
> > 
> > 1. A root user will be prevented from making edits to the AP bus's
> >      /sys/bus/ap/apmask or /sys/bus/ap/aqmask if the change would transfer
> >      ownership of an APQN from the vfio_ap device driver to a zcrypt driver
> >      while the APQN is assigned to a matrix mdev.
> > 
> > 2. Allow a root user to hot plug/unplug AP adapters, domains and control
> >      domains for a KVM guest using the matrix mdev via its sysfs
> >      assign/unassign attributes.
> > 
> > 4. Allow assignment of an AP adapter or domain to a matrix mdev even if
> >      it results in assignment of an APQN that does not reference an AP
> >      queue device bound to the vfio_ap device driver, as long as the APQN
> >      is not reserved for use by the default zcrypt drivers (also known as
> >      over-provisioning of AP resources). Allowing over-provisioning of AP
> >      resources better models the architecture which does not preclude
> >      assigning AP resources that are not yet available in the system. Such
> >      APQNs, however, will not be assigned to the guest using the matrix
> >      mdev; only APQNs referencing AP queue devices bound to the vfio_ap
> >      device driver will actually get assigned to the guest.
> > 
> > 5. Handle dynamic changes to the AP device model.
> > 
> > 1. Rationale for changes to AP bus's apmask/aqmask interfaces:
> > ----------------------------------------------------------
> > Due to the extremely sensitive nature of cryptographic data, it is
> > imperative that great care be taken to ensure that such data is secured.
> > Allowing a root user, either inadvertently or maliciously, to configure
> > these masks such that a queue is shared between the host and a guest is
> > not only avoidable, it is advisable. It was suggested that this scenario
> > is better handled in user space with management software, but that does
> > not preclude a malicious administrator from using the sysfs interfaces
> > to gain access to a guest's crypto data. It was also suggested that this
> > scenario could be avoided by taking access to the adapter away from the
> > guest and zeroing out the queues prior to the vfio_ap driver releasing the
> > device; however, stealing an adapter in use from a guest as a by-product
> > of an operation is bad and will likely cause problems for the guest
> > unnecessarily. It was decided that the most effective solution with the
> > least number of negative side effects is to prevent the situation at the
> > source.
> > 
> > 2. Rationale for hot plug/unplug using matrix mdev sysfs interfaces:
> > ----------------------------------------------------------------
> > Allowing a user to hot plug/unplug AP resources using the matrix mdev
> > sysfs interfaces circumvents the need to terminate the guest in order to
> > modify its AP configuration. Allowing dynamic configuration makes
> > reconfiguring a guest's AP matrix much less disruptive.
> > 
> > 3. Rationale for allowing over-provisioning of AP resources:
> > -----------------------------------------------------------
> > Allowing assignment of AP resources to a matrix mdev and ultimately to a
> > guest better models the AP architecture. The architecture does not
> > preclude assignment of unavailable AP resources. If a queue subsequently
> > becomes available while a guest using the matrix mdev to which its APQN
> > is assigned, the guest will be given access to it. If an APQN
> > is dynamically unassigned from the underlying host system, it will
> > automatically become unavailable to the guest.
> > 
> > Change log v19-v20:
> > ------------------
> > * Fixed patch 02/20: failed to move creation of status attribute
> >    for a queue device to the vfio_ap_mdev_probe_queue function in
> >    drivers/s390/crypto/vfio_ap_ops.c. (Jason)
> > 
> > * Fixed signature of get_update_locks_for_queue macro
> > 
> > * Take lock in get_update_locks_for_queue macro before
> >    accessing q->matrix_mdev
> > 
> > * Renamed vfio_ap_mdev_get_update_locks_for_apqn function to
> >    get_update_locks_for_apqn (Jason)
> > 
> > * Fix comments in function implementing the AP bus's in_use callback (Jason)
> > 
> > * Fix function name in prologue for ap_owned_by_def_drv function
> > 
> > Tony Krowiak (20):
> >    s390/vfio-ap: use new AP bus interface to search for queue devices
> >    s390/vfio-ap: move probe and remove callbacks to vfio_ap_ops.c
> >    s390/vfio-ap: manage link between queue struct and matrix mdev
> >    s390/vfio-ap: introduce shadow APCB
> >    s390/vfio-ap: refresh guest's APCB by filtering AP resources assigned
> >      to mdev
> >    s390/vfio-ap: allow assignment of unavailable AP queues to mdev device
> >    s390/vfio-ap: rename matrix_dev->lock mutex to matrix_dev->mdevs_lock
> >    s390/vfio-ap: introduce new mutex to control access to the KVM pointer
> >    s390/vfio-ap: use proper locking order when setting/clearing KVM
> >      pointer
> >    s390/vfio-ap: prepare for dynamic update of guest's APCB on
> >      assign/unassign
> >    s390/vfio-ap: prepare for dynamic update of guest's APCB on queue
> >      probe/remove
> >    s390/vfio-ap: allow hot plug/unplug of AP devices when
> >      assigned/unassigned
> >    s390/vfio-ap: hot plug/unplug of AP devices when probed/removed
> >    s390/vfio-ap: reset queues after adapter/domain unassignment
> >    s390/vfio-ap: implement in-use callback for vfio_ap driver
> >    s390/vfio-ap: sysfs attribute to display the guest's matrix
> >    s390/vfio-ap: handle config changed and scan complete notification
> >    s390/vfio-ap: update docs to include dynamic config support
> >    s390/Docs: new doc describing lock usage by the vfio_ap device driver
> >    MAINTAINERS: pick up all vfio_ap docs for VFIO AP maintainers
> > 
> >   Documentation/s390/vfio-ap-locking.rst |  105 ++
> >   Documentation/s390/vfio-ap.rst         |  492 +++++---
> >   MAINTAINERS                            |    2 +-
> >   drivers/s390/crypto/ap_bus.c           |   35 +-
> >   drivers/s390/crypto/vfio_ap_drv.c      |  124 +-
> >   drivers/s390/crypto/vfio_ap_ops.c      | 1436 ++++++++++++++++++------
> >   drivers/s390/crypto/vfio_ap_private.h  |   47 +-
> >   7 files changed, 1648 insertions(+), 593 deletions(-)
> >   create mode 100644 Documentation/s390/vfio-ap-locking.rst  
> 
> Unless somebody disagrees, I think we will carry these patches via the s390 tree.

No objections. I failed to verify that everything is in great shape (no
deadlocks, no races, and the logic is implemented like designed) because
I didn't have the bandwidth. I did spend some time looking at the
locking in v19 and I didn't find any problems. The locking design is
IMHO viable. I think Jason did a full review and r-b-ed all the patches
or is at least very close to it. I don't think it makes any sense to wait
for me. Sorry I couldn't do as much as I would have liked to.

Regards,
Halil

