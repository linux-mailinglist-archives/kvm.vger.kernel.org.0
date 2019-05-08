Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24C6018178
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 23:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfEHVIV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 17:08:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55718 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726709AbfEHVIU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 May 2019 17:08:20 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x48KpnU3031272
        for <kvm@vger.kernel.org>; Wed, 8 May 2019 17:08:19 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sc54ecdsq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 17:08:19 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Wed, 8 May 2019 22:08:17 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 8 May 2019 22:08:13 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x48L8CtC48038038
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 May 2019 21:08:12 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 598C84C04E;
        Wed,  8 May 2019 21:08:12 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90B9F4C044;
        Wed,  8 May 2019 21:08:11 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.71.200])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 May 2019 21:08:11 +0000 (GMT)
Date:   Wed, 8 May 2019 23:08:09 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Sebastian Ott <sebott@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
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
In-Reply-To: <alpine.LFD.2.21.1905081522300.1773@schleppi>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
        <20190426183245.37939-7-pasic@linux.ibm.com>
        <alpine.LFD.2.21.1905081522300.1773@schleppi>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19050821-0016-0000-0000-00000279B159
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050821-0017-0000-0000-000032D662B1
Message-Id: <20190508230809.6b0faaf7.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-08_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=882 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905080127
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 May 2019 15:46:42 +0200 (CEST)
Sebastian Ott <sebott@linux.ibm.com> wrote:

> 
> On Fri, 26 Apr 2019, Halil Pasic wrote:
> >  static struct ccw_device * io_subchannel_allocate_dev(struct subchannel *sch)
> >  {
> [..]
> > +	cdev->private = kzalloc(sizeof(struct ccw_device_private),
> > +				GFP_KERNEL | GFP_DMA);
> 
> Do we still need GFP_DMA here (since we now have cdev->private->dma_area)?
> 

We probably do not. I kept it GFP_DMA to keep changes to the
minimum. Should changing this in your opinion be a part of this patch?

> > @@ -1062,6 +1082,14 @@ static int io_subchannel_probe(struct subchannel *sch)
> >  	if (!io_priv)
> >  		goto out_schedule;
> >  
> > +	io_priv->dma_area = dma_alloc_coherent(&sch->dev,
> > +				sizeof(*io_priv->dma_area),
> > +				&io_priv->dma_area_dma, GFP_KERNEL);
> 
> This needs GFP_DMA.

Christoph already answered this one. Thanks Christoph!

> You use a genpool for ccw_private->dma and not for iopriv->dma - looks
> kinda inconsistent.
> 

Please have a look at patch #9. A virtio-ccw device uses the genpool of
it's ccw device (the pool from which ccw_private->dma is allicated) for
the ccw stuff it needs to do. AFAICT for a subchannel device and its API
all the DMA memory we need is iopriv->dma. So my thought was
constructing a genpool for that would be an overkill.

Are you comfortable with this answer, or should we change something?

Regards,
Halil

