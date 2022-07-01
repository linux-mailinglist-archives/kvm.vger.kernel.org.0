Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E056563394
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 14:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235533AbiGAMkp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 08:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233243AbiGAMkn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 08:40:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B2E3B540;
        Fri,  1 Jul 2022 05:40:43 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 261CKC8A000600;
        Fri, 1 Jul 2022 12:40:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=LTKKI4nMpgZNM50IuzDP1xnM+CykHKeaetkxxpY2J+8=;
 b=nnp1HAW/hwf8VquvEbkfQH6mBEwYJL9b3+Fv5TAW/YhreyaVNR9+vBiI6lbooFlysT2G
 KsEmjrk9//C1JiN4KZpR9TRvj+6MwvfJNb0iwSJPw8g58SOHKGK1EmYBMCJyO4S4iXVP
 eh1QLZo4xWj09BunvqAJsYVlo337lqpNIZkh5jCxEDYQ2a4rWPW2dSDAkbqOS9W4Ud9F
 98HBwCCnZtm5J48Ha7jX4WttXlDsrVUTcVAIjPyPWoejp6cSZVsd6Z7kPa5SyuTDke4q
 W8wkmyKBCv+K3esHTKjTjnmMZadHHqbBixqrunsr1Tz+Rg5EDm2i0o0Q2IFzU3JHjtji tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h20ue8q0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Jul 2022 12:40:40 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 261CL2UJ001872;
        Fri, 1 Jul 2022 12:40:40 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h20ue8q05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Jul 2022 12:40:40 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 261CaO7G002123;
        Fri, 1 Jul 2022 12:40:39 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02dal.us.ibm.com with ESMTP id 3gwt0bbfrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Jul 2022 12:40:39 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 261Cec8C44105994
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Jul 2022 12:40:38 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4E56AC05F;
        Fri,  1 Jul 2022 12:40:38 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8228AC059;
        Fri,  1 Jul 2022 12:40:36 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.163.2.135])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  1 Jul 2022 12:40:36 +0000 (GMT)
Message-ID: <e8f1748eb1bae3e90521b0d5d4471266f4ea7c98.camel@linux.ibm.com>
Subject: Re: [PATCH v3 00/11] s390/vfio-ccw rework
From:   Eric Farman <farman@linux.ibm.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Date:   Fri, 01 Jul 2022 08:40:35 -0400
In-Reply-To: <20220630234411.GM693670@nvidia.com>
References: <20220630203647.2529815-1-farman@linux.ibm.com>
         <20220630234411.GM693670@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4r6sYsvNt6mAxD59uyr8bd6lUWD5z1Wq
X-Proofpoint-GUID: fT-1GOcbBxxm1pkXMiTmPX8FrXfhtJv7
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-01_07,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=0 adultscore=0 clxscore=1015 phishscore=0 mlxlogscore=593
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207010048
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-06-30 at 20:44 -0300, Jason Gunthorpe wrote:
> On Thu, Jun 30, 2022 at 10:36:36PM +0200, Eric Farman wrote:
> > Here's an updated pass through the first chunk of vfio-ccw rework.
> > 
> > As with v2, this is all internal to vfio-ccw, with the exception of
> > the removal of mdev_uuid from include/linux/mdev.h in patch 1.
> > 
> > There is one conflict with the vfio-next branch [2], on patch 6.
> 
> What tree do you plan to take it through?

Don't know. I know Matt's PCI series has a conflict with this same
patch also, but I haven't seen resolution to that. @Christian,
thoughts?

> 
> > The remainder of the work that Jason Gunthorpe originally started
> > [1]
> > in this space remains for a future day.
> 
> Lets see.. These were already applied:
> 
>   vfio/ccw: Remove unneeded GFP_DMA
>   vfio/ccw: Use functions for alloc/free of the vfio_ccw_private
>   vfio/ccw: Pass vfio_ccw_private not mdev_device to various
> functions
>   vfio/ccw: Convert to use vfio_register_emulated_iommu_dev()
> 
> This series replaces this one:
>   vfio/ccw: Make the FSM complete and synchronize it to the mdev
> 
> Christoph recently re-posted this:
> https://lore.kernel.org/kvm/20220628051435.695540-10-hch@lst.de/
>   vfio/mdev: Consolidate all the device_api sysfs into the core code

Correct. Same for "vfio/mdev: Add mdev available instance checking to
the core" which you originally had proposed.

> 
> So this is still left ?
>   vfio/ccw: Remove private->mdev

This is by this series (patch 1-4).

>   vfio: Export vfio_device_try_get()
>   vfio/ccw: Move the lifecycle of the struct vfio_ccw_private to the
>     mdev
> 
> IIRC Kevin's team needs those for their device FD patches?

That's my understanding too. 

> 
> Thanks,
> Jason

