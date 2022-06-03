Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 442AC53D241
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 21:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348827AbiFCTMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 15:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348904AbiFCTMV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 15:12:21 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6292F3AA48;
        Fri,  3 Jun 2022 12:12:15 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 253IWFUN002119;
        Fri, 3 Jun 2022 19:12:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=5uy+2inrLr7F2p3V/aW6SXrjjTDJzx6rvENl5VZAHXY=;
 b=T2onpo2lBBDlBfL0uZme+bza4XTpt1hC4ZFTVAYsGB7nSJPN+Be04JZKTzVBhgrq4rMt
 Jw89PANq+LFCn329ndnHvhTppk9WlTiJFQJnImBrF0a5SwjZnppOFBTiKnSU78uDPOwr
 A9GoSyLwXOqQZoKhaPhvho3jw1aL9ITpCHuZNfPviYHClTmVmSbmwlLUxGxtTOjmh9DK
 bAt32gXWEgAClJ10ip/jJpqwbkVt/EdygCpwHtMKAGmoSx2du4zJQnhhNB3llGpEHyP9
 hbQUbYgNfTEWzy6jEL2G1o1yq29Pgx9m8SITSqRQTxx2Jnz9KJu4iE97IG5Y8JAhUNsS 3Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfqntgnfq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 19:12:10 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 253IteBt028214;
        Fri, 3 Jun 2022 19:12:09 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfqntgnfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 19:12:09 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 253J60JJ012992;
        Fri, 3 Jun 2022 19:12:09 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03wdc.us.ibm.com with ESMTP id 3gbc9w3ap7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 19:12:09 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 253JC8Rm22544804
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jun 2022 19:12:08 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1138136059;
        Fri,  3 Jun 2022 19:12:07 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1FF58136055;
        Fri,  3 Jun 2022 19:12:07 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.94.47])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  3 Jun 2022 19:12:07 +0000 (GMT)
Message-ID: <f60647cde44658a4f09b399bd2406bcd6ef31c3e.camel@linux.ibm.com>
Subject: Re: [PATCH v1 02/18] vfio/ccw: Fix FSM state if mdev probe fails
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Fri, 03 Jun 2022 15:12:06 -0400
In-Reply-To: <65e84b02-6cd3-a230-f1e0-d22e2e70024d@linux.ibm.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
         <20220602171948.2790690-3-farman@linux.ibm.com>
         <65e84b02-6cd3-a230-f1e0-d22e2e70024d@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: I45_t51AGOaPHgOZo1X5OqlRYO2X39Fk
X-Proofpoint-ORIG-GUID: 0vRPxXItOihXdn88d4T9_jqqCfHPaE7q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-03_06,2022-06-03_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2206030076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-06-03 at 09:21 -0400, Matthew Rosato wrote:
> On 6/2/22 1:19 PM, Eric Farman wrote:
> > The FSM is in STANDBY state when arriving in vfio_ccw_mdev_probe(),
> > and this routine converts it to IDLE as part of its processing.
> > The error exit sets it to IDLE (again) but clears the private->mdev
> > pointer.
> > 
> > The FSM should of course be managing the state itself, but the
> > correct thing for vfio_ccw_mdev_probe() to do would be to put
> > the state back the way it found it.
> > 
> > The corresponding check of private->mdev in vfio_ccw_sch_io_todo()
> > can be removed, since the distinction is unnecessary at this point.
> > 
> > Fixes: 3bf1311f351ef ("vfio/ccw: Convert to use
> > vfio_register_emulated_iommu_dev()")
> > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > ---
> >   drivers/s390/cio/vfio_ccw_drv.c | 2 +-
> >   drivers/s390/cio/vfio_ccw_ops.c | 2 +-
> >   2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/s390/cio/vfio_ccw_drv.c
> > b/drivers/s390/cio/vfio_ccw_drv.c
> > index 35055eb94115..b18b4582bc8b 100644
> > --- a/drivers/s390/cio/vfio_ccw_drv.c
> > +++ b/drivers/s390/cio/vfio_ccw_drv.c
> > @@ -108,7 +108,7 @@ static void vfio_ccw_sch_io_todo(struct
> > work_struct *work)
> >   	 * has finished. Do not overwrite a possible processing
> >   	 * state if the final interrupt was for HSCH or CSCH.
> >   	 */
> > -	if (private->mdev && cp_is_finished)
> > +	if (cp_is_finished)
> >   		private->state = VFIO_CCW_STATE_IDLE;
> 
> Took me a bit to convince myself this was OK

Me too. :)

> , mainly because AFAICT 
> despite the change below the fsm jumptable would still allow you to 
> reach this code when in STANDBY.  But, it should only be possible for
> an 
> unsolicited interrupt (e.g. unsolicited implies !cp_is_finished) so
> we 
> would still avoid a STANDBY->IDLE transition on accident.
> 
> Maybe work unsolicited interrupt into the comment block above along
> with 
> HSCH/CSCH?

Good idea. How about:

        /*
         * Reset to IDLE only if
processing of a channel program
         * has finished. Do not
overwrite a possible processing
         * state if the interrupt was
unsolicited, or if the final
         * interrupt was for HSCH or CSCH.
 
        */

> 
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
> 
> >   
> >   	if (private->io_trigger)
> > diff --git a/drivers/s390/cio/vfio_ccw_ops.c
> > b/drivers/s390/cio/vfio_ccw_ops.c
> > index bebae21228aa..a403d059a4e6 100644
> > --- a/drivers/s390/cio/vfio_ccw_ops.c
> > +++ b/drivers/s390/cio/vfio_ccw_ops.c
> > @@ -146,7 +146,7 @@ static int vfio_ccw_mdev_probe(struct
> > mdev_device *mdev)
> >   	vfio_uninit_group_dev(&private->vdev);
> >   	atomic_inc(&private->avail);
> >   	private->mdev = NULL;
> > -	private->state = VFIO_CCW_STATE_IDLE;
> > +	private->state = VFIO_CCW_STATE_STANDBY;

