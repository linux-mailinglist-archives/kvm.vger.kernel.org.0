Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37A3E2B3B3
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 13:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbfE0L5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 07:57:21 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51760 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726793AbfE0L5V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 May 2019 07:57:21 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4RBq9Wo130762
        for <kvm@vger.kernel.org>; Mon, 27 May 2019 07:57:20 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sreg83ap9-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 27 May 2019 07:57:19 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Mon, 27 May 2019 12:57:18 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 27 May 2019 12:57:15 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4RBvDYJ51249154
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 May 2019 11:57:13 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3FC074C044;
        Mon, 27 May 2019 11:57:13 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62E8F4C046;
        Mon, 27 May 2019 11:57:12 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.72.200])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 May 2019 11:57:12 +0000 (GMT)
Date:   Mon, 27 May 2019 13:57:06 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Michael Mueller <mimu@linux.ibm.com>,
        KVM Mailing List <kvm@vger.kernel.org>,
        Linux-S390 Mailing List <linux-s390@vger.kernel.org>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Subject: Re: [PATCH v2 6/8] virtio/s390: add indirection to indicators
 access
In-Reply-To: <20190527130028.62e1f7d7.cohuck@redhat.com>
References: <20190523162209.9543-1-mimu@linux.ibm.com>
        <20190523162209.9543-7-mimu@linux.ibm.com>
        <20190527130028.62e1f7d7.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19052711-0020-0000-0000-00000340E5FF
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052711-0021-0000-0000-00002193DCD3
Message-Id: <20190527135706.34837062.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-27_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905270085
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 May 2019 13:00:28 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Thu, 23 May 2019 18:22:07 +0200
> Michael Mueller <mimu@linux.ibm.com> wrote:
> 
> > From: Halil Pasic <pasic@linux.ibm.com>
> > 
> > This will come in handy soon when we pull out the indicators from
> > virtio_ccw_device to a memory area that is shared with the hypervisor
> > (in particular for protected virtualization guests).
> > 
> > Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> > Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
> > ---
> >  drivers/s390/virtio/virtio_ccw.c | 40 +++++++++++++++++++++++++---------------
> >  1 file changed, 25 insertions(+), 15 deletions(-)
> > 
> 
> > @@ -338,17 +348,17 @@ static void virtio_ccw_drop_indicator(struct virtio_ccw_device *vcdev,
> >  		ccw->cda = (__u32)(unsigned long) thinint_area;
> >  	} else {
> >  		/* payload is the address of the indicators */
> > -		indicatorp = kmalloc(sizeof(&vcdev->indicators),
> > +		indicatorp = kmalloc(sizeof(indicators(vcdev)),
> >  				     GFP_DMA | GFP_KERNEL);
> >  		if (!indicatorp)
> >  			return;
> >  		*indicatorp = 0;
> >  		ccw->cmd_code = CCW_CMD_SET_IND;
> > -		ccw->count = sizeof(&vcdev->indicators);
> > +		ccw->count = sizeof(indicators(vcdev));
> >  		ccw->cda = (__u32)(unsigned long) indicatorp;
> >  	}
> >  	/* Deregister indicators from host. */
> > -	vcdev->indicators = 0;
> > +	*indicators(vcdev) = 0;
> 
> I'm not too hot about this notation, but it's not wrong and a minor
> thing :)

I don't have any better ideas :/

> 
> >  	ccw->flags = 0;
> >  	ret = ccw_io_helper(vcdev, ccw,
> >  			    vcdev->is_thinint ?
> 
> Patch looks reasonable and not dependent on the other patches here.
> 

looks reasonable == r-b?

Not dependent in a sense that this patch could be made a first patch in
the series. A subsequent patch depends on it.

Regards,
Halil

