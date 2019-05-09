Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3BBC1871A
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 10:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbfEIIyb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 04:54:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46326 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725821AbfEIIyb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 May 2019 04:54:31 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x498sTgi079466
        for <kvm@vger.kernel.org>; Thu, 9 May 2019 04:54:29 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2scfhym863-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 09 May 2019 04:54:25 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <sebott@linux.ibm.com>;
        Thu, 9 May 2019 09:52:53 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 9 May 2019 09:52:48 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x498qloT46792932
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 May 2019 08:52:47 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E208A4204C;
        Thu,  9 May 2019 08:52:46 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E5414204B;
        Thu,  9 May 2019 08:52:46 +0000 (GMT)
Received: from dyn-9-152-212-30.boeblingen.de.ibm.com (unknown [9.152.212.30])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  9 May 2019 08:52:46 +0000 (GMT)
Date:   Thu, 9 May 2019 10:52:45 +0200 (CEST)
From:   Sebastian Ott <sebott@linux.ibm.com>
X-X-Sender: sebott@schleppi
To:     Halil Pasic <pasic@linux.ibm.com>
cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: Re: [PATCH 06/10] s390/cio: add basic protected virtualization
 support
In-Reply-To: <20190508230809.6b0faaf7.pasic@linux.ibm.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com> <20190426183245.37939-7-pasic@linux.ibm.com> <alpine.LFD.2.21.1905081522300.1773@schleppi> <20190508230809.6b0faaf7.pasic@linux.ibm.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
Organization: =?ISO-8859-15?Q?=22IBM_Deutschland_Research_&_Development_GmbH?=
 =?ISO-8859-15?Q?_=2F_Vorsitzende_des_Aufsichtsrats=3A_Matthias?=
 =?ISO-8859-15?Q?_Hartmann_Gesch=E4ftsf=FChrung=3A_Dirk_Wittkopp?=
 =?ISO-8859-15?Q?_Sitz_der_Gesellschaft=3A_B=F6blingen_=2F_Reg?=
 =?ISO-8859-15?Q?istergericht=3A_Amtsgericht_Stuttgart=2C_HRB_2432?=
 =?ISO-8859-15?Q?94=22?=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
x-cbid: 19050908-0028-0000-0000-0000036BDC01
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050908-0029-0000-0000-0000242B5C52
Message-Id: <alpine.LFD.2.21.1905091041130.1779@schleppi>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=991 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905090056
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On Wed, 8 May 2019, Halil Pasic wrote:
> On Wed, 8 May 2019 15:46:42 +0200 (CEST)
> Sebastian Ott <sebott@linux.ibm.com> wrote:
> > On Fri, 26 Apr 2019, Halil Pasic wrote:
> > >  static struct ccw_device * io_subchannel_allocate_dev(struct subchannel *sch)
> > >  {
> > [..]
> > > +	cdev->private = kzalloc(sizeof(struct ccw_device_private),
> > > +				GFP_KERNEL | GFP_DMA);
> > 
> > Do we still need GFP_DMA here (since we now have cdev->private->dma_area)?
> > 
> 
> We probably do not. I kept it GFP_DMA to keep changes to the
> minimum. Should changing this in your opinion be a part of this patch?

This can be changed on top.

> > > @@ -1062,6 +1082,14 @@ static int io_subchannel_probe(struct subchannel *sch)
> > >  	if (!io_priv)
> > >  		goto out_schedule;
> > >  
> > > +	io_priv->dma_area = dma_alloc_coherent(&sch->dev,
> > > +				sizeof(*io_priv->dma_area),
> > > +				&io_priv->dma_area_dma, GFP_KERNEL);
> > 
> > This needs GFP_DMA.
> 
> Christoph already answered this one. Thanks Christoph!

Yes, I'm still struggling to grasp the whole channel IO + DMA API +
protected virtualization thing..

> 
> > You use a genpool for ccw_private->dma and not for iopriv->dma - looks
> > kinda inconsistent.
> > 
> 
> Please have a look at patch #9. A virtio-ccw device uses the genpool of
> it's ccw device (the pool from which ccw_private->dma is allicated) for
> the ccw stuff it needs to do. AFAICT for a subchannel device and its API
> all the DMA memory we need is iopriv->dma. So my thought was
> constructing a genpool for that would be an overkill.
> 
> Are you comfortable with this answer, or should we change something?

Nope, I'm good with that one - ccw_private->dma has multiple users that
all fit into one page.

