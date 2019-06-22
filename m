Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92D964F460
	for <lists+kvm@lfdr.de>; Sat, 22 Jun 2019 10:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbfFVIii (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jun 2019 04:38:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44398 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726274AbfFVIii (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 22 Jun 2019 04:38:38 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5M8aduW094600
        for <kvm@vger.kernel.org>; Sat, 22 Jun 2019 04:38:37 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t9d7tdmmu-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Sat, 22 Jun 2019 04:38:37 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
        Sat, 22 Jun 2019 09:38:35 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 22 Jun 2019 09:38:32 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5M8cVoV33620202
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Jun 2019 08:38:31 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E987552050;
        Sat, 22 Jun 2019 08:38:30 +0000 (GMT)
Received: from osiris (unknown [9.152.212.21])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id A02B65204F;
        Sat, 22 Jun 2019 08:38:30 +0000 (GMT)
Date:   Sat, 22 Jun 2019 10:38:29 +0200
From:   Heiko Carstens <heiko.carstens@de.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PULL 13/14] vfio-ccw: Factor out the ccw0-to-ccw1 transition
References: <20190621143355.29175-1-cohuck@redhat.com>
 <20190621143355.29175-14-cohuck@redhat.com>
 <2129b739-6722-123f-ec7d-f751557de7a0@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2129b739-6722-123f-ec7d-f751557de7a0@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19062208-0008-0000-0000-000002F60B93
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062208-0009-0000-0000-00002263325C
Message-Id: <20190622083829.GA3456@osiris>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-22_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906220079
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 21, 2019 at 03:13:20PM -0400, Eric Farman wrote:
> Conny,
> 
> I'm bad at things, because I thought for sure I had checked for and
> fixed this before I sent the patches.  This one gets a sparse warning,
> fixed below.
> 
> Eric
> 
> On 6/21/19 10:33 AM, Cornelia Huck wrote:
> > From: Eric Farman <farman@linux.ibm.com>
> > 
> > This is a really useful function, but it's buried in the
> > copy_ccw_from_iova() routine so that ccwchain_calc_length()
> > can just work with Format-1 CCWs while doing its counting.
> > But it means we're translating a full 2K of "CCWs" to Format-1,
> > when in reality there's probably far fewer in that space.
> > 
> > Let's factor it out, so maybe we can do something with it later.
> > 
> > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > Message-Id: <20190618202352.39702-5-farman@linux.ibm.com>
> > Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> > Reviewed-by: Farhan Ali <alifm@linux.ibm.com>
> > Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> > ---
> >  drivers/s390/cio/vfio_ccw_cp.c | 48 ++++++++++++++++++----------------
> >  1 file changed, 25 insertions(+), 23 deletions(-)
> > 
> > diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> > index a55f8d110920..9a8bf06281e0 100644
> > --- a/drivers/s390/cio/vfio_ccw_cp.c
> > +++ b/drivers/s390/cio/vfio_ccw_cp.c
> > @@ -161,6 +161,27 @@ static inline void pfn_array_idal_create_words(
> >  	idaws[0] += pa->pa_iova & (PAGE_SIZE - 1);
> >  }
> >  
> > +void convert_ccw0_to_ccw1(struct ccw1 *source, unsigned long len)
> 
> static void convert_...

Please send an add-on patch. Code is already in our internal tree for
testing purposes and will be push out next week.

