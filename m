Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7B21F94B1
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 12:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729381AbgFOKhf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 06:37:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9806 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728885AbgFOKhf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Jun 2020 06:37:35 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05F9WB8k191943;
        Mon, 15 Jun 2020 06:37:33 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31mua61uwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 06:37:33 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05FAIrP7011677;
        Mon, 15 Jun 2020 06:37:33 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31mua61uvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 06:37:32 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05FATw2G015404;
        Mon, 15 Jun 2020 10:37:30 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 31mpe83chp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 10:37:30 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05FAaAMr64684452
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jun 2020 10:36:10 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 990E711C05B;
        Mon, 15 Jun 2020 10:37:27 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A22611C05C;
        Mon, 15 Jun 2020 10:37:27 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.56.158])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 15 Jun 2020 10:37:27 +0000 (GMT)
Date:   Mon, 15 Jun 2020 12:37:25 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, mst@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] s390: protvirt: virtio: Refuse device without IOMMU
Message-ID: <20200615123725.13f6a8de.pasic@linux.ibm.com>
In-Reply-To: <a02b9f94-eb48-4ae2-0ade-a4ce26b61ad8@redhat.com>
References: <1591794711-5915-1-git-send-email-pmorel@linux.ibm.com>
        <467d5b58-b70c-1c45-4130-76b6e18c05af@redhat.com>
        <f7eb1154-0f52-0f12-129f-2b511f5a4685@linux.ibm.com>
        <6356ba7f-afab-75e1-05ff-4a22b88c610e@linux.ibm.com>
        <a02b9f94-eb48-4ae2-0ade-a4ce26b61ad8@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-12_17:2020-06-12,2020-06-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 clxscore=1015 adultscore=0 mlxscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 cotscore=-2147483648 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006150075
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 15 Jun 2020 11:01:55 +0800
Jason Wang <jasowang@redhat.com> wrote:

> > hum, in between I found another way which seems to me much better:
> >
> > We already have the force_dma_unencrypted() function available which 
> > AFAIU is what we want for encrypted memory protection and is already 
> > used by power and x86 SEV/SME in a way that seems AFAIU compatible 
> > with our problem.
> >
> > Even DMA and IOMMU are different things, I think they should be used 
> > together in our case.
> >
> > What do you think?
> >
> > The patch would then be something like:
> >
> > diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> > index a977e32a88f2..53476d5bbe35 100644
> > --- a/drivers/virtio/virtio.c
> > +++ b/drivers/virtio/virtio.c
> > @@ -4,6 +4,7 @@
> >  #include <linux/virtio_config.h>
> >  #include <linux/module.h>
> >  #include <linux/idr.h>
> > +#include <linux/dma-direct.h>
> >  #include <uapi/linux/virtio_ids.h>
> >
> >  /* Unique numbering for virtio devices. */
> > @@ -179,6 +180,10 @@ int virtio_finalize_features(struct virtio_device 
> > *dev)
> >         if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1))
> >                 return 0;
> >
> > +       if (force_dma_unencrypted(&dev->dev) &&
> > +           !virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM))
> > +               return -EIO;
> > +
> >         virtio_add_status(dev, VIRTIO_CONFIG_S_FEATURES_OK);
> >         status = dev->config->get_status(dev);
> >         if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {  
> 
> 
> I think this can work but need to listen from Michael

I don't think Christoph Hellwig will like force_dma_unencrypted()
in virtio code:
https://lkml.org/lkml/2020/2/20/630

Regards,
Halil
