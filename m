Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDCA74B75
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 12:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729845AbfGYKWG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 06:22:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33776 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727402AbfGYKWG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Jul 2019 06:22:06 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6PAHWi5038525
        for <kvm@vger.kernel.org>; Thu, 25 Jul 2019 06:22:04 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tya8n91dw-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 25 Jul 2019 06:22:04 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
        Thu, 25 Jul 2019 11:22:03 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 25 Jul 2019 11:22:01 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6PALx6F38732286
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 10:21:59 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 619D5AE057;
        Thu, 25 Jul 2019 10:21:59 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19606AE053;
        Thu, 25 Jul 2019 10:21:59 +0000 (GMT)
Received: from osiris (unknown [9.152.212.134])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 25 Jul 2019 10:21:59 +0000 (GMT)
Date:   Thu, 25 Jul 2019 12:21:57 +0200
From:   Heiko Carstens <heiko.carstens@de.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        farman@linux.ibm.com, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/1] MAINTAINERS: vfio-ccw: Remove myself as the
 maintainer
References: <cover.1564003585.git.alifm@linux.ibm.com>
 <19aee1ab0e5bcc01053b515117a66426a9332086.1564003585.git.alifm@linux.ibm.com>
 <20190725093335.09c96c0d.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725093335.09c96c0d.cohuck@redhat.com>
X-TM-AS-GCONF: 00
x-cbid: 19072510-0012-0000-0000-000003360C8C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19072510-0013-0000-0000-0000216FA3AC
Message-Id: <20190725102157.GA25333@osiris>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-25_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=721 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907250124
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 25, 2019 at 09:33:35AM +0200, Cornelia Huck wrote:
> On Wed, 24 Jul 2019 17:32:03 -0400
> Farhan Ali <alifm@linux.ibm.com> wrote:
> 
> > I will not be able to continue with my maintainership responsibilities
> > going forward, so remove myself as the maintainer.
> 
> ::sadface::
> 
> Thank you for all of your good work!
> 
> > 
> > Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> > ---
> >  MAINTAINERS | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 0e90487..dd07a23 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -13696,7 +13696,6 @@ F:	drivers/pci/hotplug/s390_pci_hpc.c
> >  
> >  S390 VFIO-CCW DRIVER
> >  M:	Cornelia Huck <cohuck@redhat.com>
> > -M:	Farhan Ali <alifm@linux.ibm.com>
> >  M:	Eric Farman <farman@linux.ibm.com>
> >  R:	Halil Pasic <pasic@linux.ibm.com>
> >  L:	linux-s390@vger.kernel.org
> 
> Acked-by: Cornelia Huck <cohuck@redhat.com>
> 
> Heiko/Vasily/Christian: can you take this one directly through the s390
> tree?

Sure.

