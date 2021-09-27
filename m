Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30B641A080
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 22:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237041AbhI0Urz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 16:47:55 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64062 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236414AbhI0Urz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Sep 2021 16:47:55 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18RIokti026875;
        Mon, 27 Sep 2021 16:46:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=lwBg6ETHNmezOliV6uYm9wJHkponVlX6ZQYAIV/PAIw=;
 b=lneehF2swa0M0E9cllaE1fMIH4mEQLsOiLYDwh35MKczOPU7V6O6GiRt0yw+u3gJpZQT
 BI27BpxZSg9Gx/eV/G0VfjXpatjVNoCqZ3IkgAclpeMvRh07rbDnRH1lLjV/j446o6If
 rdaQBOYKoDGoXDwqFoeCTA6T4+8gFyEQaW8wTg6j8cWk8JllVVZk8+PQ5E+lY3yp6KhZ
 lkgSe7C2IDjFz7i4rSWyJXm0yxPZO/oiWoiDNxlX66vuZ95HAMPTIKauJnyxpMFCksfS
 LEM8DsHIttRoU2/o5srtXKyYu9ai/j+d72w+gUeCNpYGKRwf7p5KUJMerhpkfZd3Afb5 nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bagx55xp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 16:46:08 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18RJsJM4007485;
        Mon, 27 Sep 2021 16:46:07 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bagx55xnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 16:46:07 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18RKbMUk005939;
        Mon, 27 Sep 2021 20:46:06 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01dal.us.ibm.com with ESMTP id 3b9udb7dkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 20:46:06 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18RKk5up11142088
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Sep 2021 20:46:05 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8288B2805E;
        Mon, 27 Sep 2021 20:46:05 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C892028058;
        Mon, 27 Sep 2021 20:45:58 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.163.16.42])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 27 Sep 2021 20:45:58 +0000 (GMT)
Message-ID: <f1b64606c967e9adf12f4e026cdfdf910ade554e.camel@linux.ibm.com>
Subject: Re: [PATCH v2 7/9] vfio/ccw: Remove private->mdev
From:   Eric Farman <farman@linux.ibm.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, Christoph Hellwig <hch@lst.de>
Date:   Mon, 27 Sep 2021 16:45:56 -0400
In-Reply-To: <20210927123253.GY964074@nvidia.com>
References: <7-v2-7d3a384024cf+2060-ccw_mdev_jgg@nvidia.com>
         <f887a563e688057d6759e6de65d480326f502331.camel@linux.ibm.com>
         <20210927123253.GY964074@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: v0DgXAfibzUmo_LUs0sDhAmrtXJUoU0-
X-Proofpoint-ORIG-GUID: w-2bKWgqbBr-1g7NEf-wxPVRrKgqRuob
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-27_07,2021-09-24_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=798 spamscore=0
 impostorscore=0 suspectscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 mlxscore=0 bulkscore=0 clxscore=1015 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109270138
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-09-27 at 09:32 -0300, Jason Gunthorpe wrote:
> On Fri, Sep 24, 2021 at 04:45:02PM -0400, Eric Farman wrote:
> > On Thu, 2021-09-09 at 16:38 -0300, Jason Gunthorpe wrote:
> > > Having a mdev pointer floating about in addition to a struct
> > > vfio_device
> > > is confusing. It is only used for three things:
> > > 
> > > - Getting the mdev 'struct device *' - this is the same as
> > >      private->vdev.dev
> > > 
> > > - Printing the uuid of the mdev in logging. The uuid is also the
> > > dev_name
> > >   of the mdev so this is the same string as
> > >      dev_name(private->vdev.dev)
> > > 
> > > - A weird attempt to fence the vfio_ccw_sch_io_todo() work. This
> > > work
> > > is
> > >   only queued during states IDLE/PROCESSING/PENDING and flushed
> > > when
> > >   entering CLOSED. Thus the work already cannot run when the mdev
> > > is
> > > NULL.
> > >   Remove it.
> > > 
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > >  drivers/s390/cio/vfio_ccw_drv.c     |  6 ++--
> > >  drivers/s390/cio/vfio_ccw_fsm.c     | 48 +++++++++++++--------
> > > ----
> > >  drivers/s390/cio/vfio_ccw_ops.c     | 16 ++++------
> > >  drivers/s390/cio/vfio_ccw_private.h |  2 --
> > >  include/linux/mdev.h                |  4 ---
> > >  5 files changed, 30 insertions(+), 46 deletions(-)
> > 
> > I like this patch. Unfortunately it depends on the removal of a
> > hunk in
> > patch 4, which sets the FSM state to different values based on
> > whether
> > private->mdev is NULL or not, so can't go on its own. Need to spend
> > more time thinking about that patch.
> 
> The FSM patch is important, really what is happening is the FSM logic
> takes on the roles that was being split all over the place with other
> logic, like this mdev stuff. To make that work we need a FSM that
> makes sense..

No argument from me about that. My point is that I could consume this
patch easier than the FSM patch, and need to get back to that one.

Eric

> 
> Jason

