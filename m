Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D7E57905C
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 04:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236651AbiGSCBz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 22:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236333AbiGSCBy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 22:01:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE533AB13;
        Mon, 18 Jul 2022 19:01:52 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26J1ftM5020200;
        Tue, 19 Jul 2022 02:01:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=PPw8mwGhjQL0BJg93dX6d9Kp4ZAOw9NYB4OXGXK112s=;
 b=Tl1t3eBx/+3e/gWAWKsV8k8HP1+jM8dZulxAVGRFuTtwK040kXac+5SK3T5N2iBxcZ/f
 4jZxEJfRkH5vaAr+RcVcOjyFZy+4QR6iq9DB/tx/SYe7jUbvbgaBTPwhbH8gubQuUxL0
 80PqIgbmh0E9Q52090aWiNihpvUC8599UR9L12r25PeHvU0FI3OultgUvv0HUHsYUExr
 BwFxJfWSK/uWrSYCfblAaxUUsNYp8OFiDGb530AdmtUoP7E64dcB6G8nlZQiT/Me8e8P
 BUSB3YCJQ5VYrNFagozZDZDCuTTT/GQPMKfFq+vL8H8KDwfMAnfo3SDcp06ayPH8MePi uQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hdk640asq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 02:01:46 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26J1ugPW034569;
        Tue, 19 Jul 2022 02:01:45 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hdk640as8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 02:01:45 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26J1onIf004560;
        Tue, 19 Jul 2022 02:01:44 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma05wdc.us.ibm.com with ESMTP id 3hbmy9geeg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 02:01:44 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26J21hYZ21168774
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 02:01:43 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34C7B136051;
        Tue, 19 Jul 2022 02:01:43 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC214136053;
        Tue, 19 Jul 2022 02:01:41 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.146.30])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 19 Jul 2022 02:01:41 +0000 (GMT)
Message-ID: <1f945ef0eb6c02079700a6785ca3dd9864096b82.camel@linux.ibm.com>
Subject: Re: simplify the mdev interface v6
From:   Eric Farman <farman@linux.ibm.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        Vineeth Vijayan <vneethv@linux.ibm.com>
Date:   Mon, 18 Jul 2022 22:01:40 -0400
In-Reply-To: <20220718153331.18a52e31.alex.williamson@redhat.com>
References: <20220709045450.609884-1-hch@lst.de>
         <20220718054348.GA22345@lst.de>
         <20220718153331.18a52e31.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bPzYFyV32OrQ-bvBA1OaEfajS1Z3nqoV
X-Proofpoint-ORIG-GUID: uE_GeuD9Iu8rY6zWRdsziIVCXWySTCOe
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_22,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2207190006
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-07-18 at 15:33 -0600, Alex Williamson wrote:
> On Mon, 18 Jul 2022 07:43:48 +0200
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > Alex, does this series look good to you now?
> 
> It does.  I was hoping we'd get a more complete set acks from the
> mdev
> driver owners, but I'll grab this within the next day or two with
> whatever additional reviews come in by then. 

Apologies, I have been on vacation since this version was posted.

I'll get the problem with struct subchannel [1] sorted out in the next
couple of days. This series breaks vfio-ccw in its current form (see
reply to patch 14), but even with that addressed the placement of all
these other mdev structs needs to be handled differently.

Eric

[1] https://lore.kernel.org/r/20220707134017.GB19060@lst.de/

>  Thanks,
> 
> Alex
> 
> > On Sat, Jul 09, 2022 at 06:54:36AM +0200, Christoph Hellwig wrote:
> > > Hi all,
> > > 
> > > this series signigicantly simplies the mdev driver interface by
> > > following
> > > the patterns for device model interaction used elsewhere in the
> > > kernel.
> > > 
> > > Changes since v5:
> > >  - rebased to the latest vfio/next branch
> > >  - drop the last patch again
> > >  - make sure show_available_instances works properly for the
> > > internallly
> > >    tracked case
> > > 
> > > Changes since v4:
> > >  - move the kobject_put later in mdev_device_release 
> > >  - add a Fixes tag for the first patch
> > >  - add another patch to remove an extra kobject_get/put
> > > 
> > > Changes since v3:
> > >  - make the sysfs_name and pretty_name fields pointers instead of
> > > arrays
> > >  - add an i915 cleanup to prepare for the above
> > > 
> > > Changes since v2:
> > >  - rebased to vfio/next
> > >  - fix a pre-existing memory leak in i915 instead of making it
> > > worse
> > >  - never manipulate if ->available_instances if drv-
> > > >get_available is
> > >    provided
> > >  - keep a parent reference for the mdev_type
> > >  - keep a few of the sysfs.c helper function around
> > >  - improve the documentation for the parent device lifetime
> > >  - minor spellig / formatting fixes
> > > 
> > > Changes since v1:
> > >  - embedd the mdev_parent into a different sub-structure in i916
> > >  - remove headers now inclued by mdev.h from individual source
> > > files
> > >  - pass an array of mdev_types to mdev_register_parent
> > >  - add additional patches to implement all attributes on the
> > >    mdev_type in the core code
> > > 
> > > Diffstat:
> > >  Documentation/driver-api/vfio-mediated-device.rst |   26 +-
> > >  Documentation/s390/vfio-ap.rst                    |    2 
> > >  Documentation/s390/vfio-ccw.rst                   |    2 
> > >  drivers/gpu/drm/i915/gvt/aperture_gm.c            |   20 +-
> > >  drivers/gpu/drm/i915/gvt/gvt.h                    |   42 ++--
> > >  drivers/gpu/drm/i915/gvt/kvmgt.c                  |  168 ++++---
> > > ----------
> > >  drivers/gpu/drm/i915/gvt/vgpu.c                   |  210
> > > +++++++---------------
> > >  drivers/s390/cio/cio.h                            |    4 
> > >  drivers/s390/cio/vfio_ccw_drv.c                   |   12 -
> > >  drivers/s390/cio/vfio_ccw_ops.c                   |   51 -----
> > >  drivers/s390/cio/vfio_ccw_private.h               |    2 
> > >  drivers/s390/crypto/vfio_ap_ops.c                 |   68 +------
> > >  drivers/s390/crypto/vfio_ap_private.h             |    6 
> > >  drivers/vfio/mdev/mdev_core.c                     |  190 ++++---
> > > ------------
> > >  drivers/vfio/mdev/mdev_driver.c                   |    7 
> > >  drivers/vfio/mdev/mdev_private.h                  |   32 ---
> > >  drivers/vfio/mdev/mdev_sysfs.c                    |  189
> > > ++++++++++---------
> > >  include/linux/mdev.h                              |   77 ++++---
> > > -
> > >  samples/vfio-mdev/mbochs.c                        |  103 +++--
> > > -----
> > >  samples/vfio-mdev/mdpy.c                          |  115 +++--
> > > -------
> > >  samples/vfio-mdev/mtty.c                          |   94 +++--
> > > ----
> > >  21 files changed, 463 insertions(+), 957 deletions(-)  
> > ---end quoted text---
> > 

