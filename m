Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0898A219CA8
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 11:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgGIJ4O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 05:56:14 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16528 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726340AbgGIJ4O (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jul 2020 05:56:14 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0699ZmNI117754;
        Thu, 9 Jul 2020 05:56:03 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 325r2cce2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 05:56:02 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0699qg3u169301;
        Thu, 9 Jul 2020 05:56:02 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 325r2cce1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 05:56:01 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0699l0Id018985;
        Thu, 9 Jul 2020 09:55:59 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 325k0crrsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 09:55:59 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0699tuGL61931650
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Jul 2020 09:55:56 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB156A4054;
        Thu,  9 Jul 2020 09:55:56 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0D42A405C;
        Thu,  9 Jul 2020 09:55:55 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.152.61])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Jul 2020 09:55:55 +0000 (GMT)
Date:   Thu, 9 Jul 2020 11:55:53 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, mst@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v5 2/2] s390: virtio: PV needs VIRTIO I/O device
 protection
Message-ID: <20200709115553.2dde6ab1.pasic@linux.ibm.com>
In-Reply-To: <20200709105733.6d68fa53.cohuck@redhat.com>
References: <1594283959-13742-1-git-send-email-pmorel@linux.ibm.com>
        <1594283959-13742-3-git-send-email-pmorel@linux.ibm.com>
        <20200709105733.6d68fa53.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-09_05:2020-07-09,2020-07-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 spamscore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007090075
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 Jul 2020 10:57:33 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Thu,  9 Jul 2020 10:39:19 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
> > If protected virtualization is active on s390, the virtio queues are
> > not accessible to the host, unless VIRTIO_F_IOMMU_PLATFORM has been
> > negotiated. Use the new arch_validate_virtio_features() interface to
> > fail probe if that's not the case, preventing a host error on access
> > attempt

Punctuation at the end?

Also 'that's not the case' refers to the negation
'VIRTIO_F_IOMMU_PLATFORM has been negotiated',
arch_validate_virtio_features() is however part of
virtio_finalize_features(), which is in turn part of the feature
negotiation. But that is details. I'm fine with keeping the message as
is. 

> > 
> > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > ---
> >  arch/s390/mm/init.c | 27 +++++++++++++++++++++++++++
> >  1 file changed, 27 insertions(+)
> > 
> > diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
> > index 6dc7c3b60ef6..b8e6f90117da 100644
> > --- a/arch/s390/mm/init.c
> > +++ b/arch/s390/mm/init.c
> > @@ -45,6 +45,7 @@
> >  #include <asm/kasan.h>
> >  #include <asm/dma-mapping.h>
> >  #include <asm/uv.h>
> > +#include <linux/virtio_config.h>
> >  
> >  pgd_t swapper_pg_dir[PTRS_PER_PGD] __section(.bss..swapper_pg_dir);
> >  
> > @@ -161,6 +162,32 @@ bool force_dma_unencrypted(struct device *dev)
> >  	return is_prot_virt_guest();
> >  }
> >  
> > +/*
> > + * arch_validate_virtio_features
> > + * @dev: the VIRTIO device being added
> > + *
> > + * Return an error if required features are missing on a guest running
> > + * with protected virtualization.
> > + */
> > +int arch_validate_virtio_features(struct virtio_device *dev)
> > +{
> > +	if (!is_prot_virt_guest())
> > +		return 0;
> > +
> > +	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
> > +		dev_warn(&dev->dev, "device must provide VIRTIO_F_VERSION_1\n");
> 
> I'd probably use "legacy virtio not supported with protected
> virtualization".
> 
> > +		return -ENODEV;
> > +	}
> > +
> > +	if (!virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM)) {
> > +		dev_warn(&dev->dev,
> > +			 "device must provide VIRTIO_F_IOMMU_PLATFORM\n");
> 
> "support for limited memory access required for protected
> virtualization"
> 
> ?
> 
> Mentioning the feature flag is shorter in both cases, though.

I liked the messages in v4. Why did we change those? Did somebody
complain?

I prefer the old ones, but it any case:

Acked-by: Halil Pasic <pasic@linux.ibm.com>


> 
> > +		return -ENODEV;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  /* protected virtualization */
> >  static void pv_init(void)
> >  {
> 
> Either way,
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

