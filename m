Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E856F36D80A
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 15:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239739AbhD1NI6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 09:08:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8569 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239600AbhD1NI4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Apr 2021 09:08:56 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13SCXoJS126269;
        Wed, 28 Apr 2021 08:55:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=GKnRjBHqTsv46WklOLnBMRvqOQXYXQ8LQi8rW/S/Vxs=;
 b=axLpH4yD6cA3vGLDK3dEYHYPvA33oHyjqIA016eGcIVFs3/mB5aK3MpWVHfzbgeUr95e
 jaEk2RkYnpwwrUIFi5HJY52W+m8+NH96Qhxra6IV4q0uicNslptn0pOJJVKXuZIrJsLQ
 9at96NGjmWsq7Cs6fbIAGVjzqDgnqDFUgvBIIFsBGaN3QyELwdaws/8VmFyYGQ5HhxBU
 N5D8UTQarEoJ6uT8gRFJ2oMq6q3h3G/clHGHUaEct/Tzz20L0trbIfwj1C+oDU2OCYxb
 kqvs7fOAQMSl82YPoC2F8Q5Wby87WPOKbEOHavRc0G7hdcJCz0Bon2FNbFChKPCfRu5C LQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3876ghu6e9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Apr 2021 08:55:55 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13SCmxlf193134;
        Wed, 28 Apr 2021 08:55:55 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3876ghu6ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Apr 2021 08:55:55 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13SCrLhr015630;
        Wed, 28 Apr 2021 12:55:54 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02dal.us.ibm.com with ESMTP id 384qdj852c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Apr 2021 12:55:54 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13SCtrNZ39256408
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Apr 2021 12:55:53 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2882728064;
        Wed, 28 Apr 2021 12:55:53 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C246E2805E;
        Wed, 28 Apr 2021 12:55:51 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.160.111.105])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 28 Apr 2021 12:55:51 +0000 (GMT)
Message-ID: <564ab34574dac135cd4e2f8f1816467d4d6dc25f.camel@linux.ibm.com>
Subject: Re: [PATCH v2 07/13] vfio/ccw: Convert to use
 vfio_register_group_dev()
From:   Eric Farman <farman@linux.ibm.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Date:   Wed, 28 Apr 2021 08:55:51 -0400
In-Reply-To: <20210427221030.GK1370958@nvidia.com>
References: <7-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
         <5325cd47bf170b66591bc1e64bf9fa3aa9c365b5.camel@linux.ibm.com>
         <20210427221030.GK1370958@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-14.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZcLMIFFj1oNUYUuPC3Z07Lv6WyZ4_ptC
X-Proofpoint-GUID: 64It7cF6_S0udTe4gMk0RDb86lcfMgBU
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-28_06:2021-04-27,2021-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 priorityscore=1501 spamscore=0
 mlxscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104280084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-04-27 at 19:10 -0300, Jason Gunthorpe wrote:
> On Tue, Apr 27, 2021 at 04:06:04PM -0400, Eric Farman wrote:
> > > @@ -132,19 +137,28 @@ static int vfio_ccw_mdev_create(struct
> > > mdev_device *mdev)
> > >  			   private->sch->schid.ssid,
> > >  			   private->sch->schid.sch_no);
> > >  
> > > +	ret = vfio_register_group_dev(&private->vdev);
> > > +	if (ret)
> > > +		goto err_atomic;
> > > +	dev_set_drvdata(&mdev->dev, private);
> > >  	return 0;
> > > +
> > > +err_atomic:
> > > +	atomic_inc(&private->avail);
> > 
> > Since we're unwinding, should also do
> > 
> > private->mdev = NULL
> > private->state = VFIO_CCW_STATE_STANDBY
> 
> I can change this, but it looks quite weird to do stuff like this
> with
> no locking.

I agree, but mdev_create didn't fail before, so backing out part of its
work seems weird too.

> 
> eg the only reads are here:
> 
> drivers/s390/cio/vfio_ccw_drv.c:        if (private->mdev &&
> is_final)
> drivers/s390/cio/vfio_ccw_drv.c:                private->state =
> private->mdev ? VFIO_CCW_STATE_IDLE :
> 
> Which is from a WQ, if someone thinks setting mdev to NULL should
> effect those WQs then there are problems...
> 
> The non-atomic state is equally confusing

Agreed, it's already on the list.

Eric

> 
> Jason

