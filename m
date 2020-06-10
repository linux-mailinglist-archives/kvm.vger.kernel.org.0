Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B335B1F5A41
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 19:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgFJRYp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 13:24:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58204 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726254AbgFJRYp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Jun 2020 13:24:45 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05AH2Gtq033508;
        Wed, 10 Jun 2020 13:24:42 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31k27rbjxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Jun 2020 13:24:42 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05AH2jKw035604;
        Wed, 10 Jun 2020 13:24:41 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31k27rbjx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Jun 2020 13:24:41 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05AHFAom030282;
        Wed, 10 Jun 2020 17:24:39 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 31g2s803xt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Jun 2020 17:24:39 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05AHObp435389646
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jun 2020 17:24:37 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01B4CA4064;
        Wed, 10 Jun 2020 17:24:37 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C160A405B;
        Wed, 10 Jun 2020 17:24:36 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.127.50])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 10 Jun 2020 17:24:36 +0000 (GMT)
Date:   Wed, 10 Jun 2020 19:24:22 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, mst@redhat.com, jasowang@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] s390: protvirt: virtio: Refuse device without IOMMU
Message-ID: <20200610192422.1cefb642.pasic@linux.ibm.com>
In-Reply-To: <1591794711-5915-1-git-send-email-pmorel@linux.ibm.com>
References: <1591794711-5915-1-git-send-email-pmorel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-10_10:2020-06-10,2020-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 adultscore=0 clxscore=1011 bulkscore=0 mlxlogscore=999 malwarescore=0
 impostorscore=0 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006100126
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 10 Jun 2020 15:11:51 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> Protected Virtualisation protects the memory of the guest and
> do not allow a the host to access all of its memory.
> 
> Let's refuse a VIRTIO device which does not use IOMMU
> protected access.
> 

Should we ever get a virtio-ccw device implemented in hardware, we could
in theory have a trusted device, i.e. one that is not affected by the
memory protection.

IMHO this restriction applies to paravitualized devices, that is devices
realized by the hypervisor. In that sense this is not about ccw, but
could in the future affect PCI as well. Thus the transport code may not
be the best place to fence this, but frankly looking at how the QEMU
discussion is going (the one where I try to prevent this condition) I
would be glad to have something like this as a safety net.

I would however like the commit message to reflect what is written above.

Do we need backports (and cc-stable) for this? Connie what do you think?

> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  drivers/s390/virtio/virtio_ccw.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> index 5730572b52cd..06ffbc96587a 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -986,6 +986,11 @@ static void virtio_ccw_set_status(struct virtio_device *vdev, u8 status)
>  	if (!ccw)
>  		return;
>  
> +	/* Protected Virtualisation guest needs IOMMU */
> +	if (is_prot_virt_guest() &&
> +	    !__virtio_test_bit(vdev, VIRTIO_F_IOMMU_PLATFORM))

If you were to add && !__virtio_test_bit(vdev, VIRTIO_F_ORDER_PLATFORM)
we could confine this check and the bail out to paravirtualized devices,
because a device realized in HW is expected to give us both
F_ACCESS_PLATFORM and F_ORDER_PLATFORM. I would not bet it will
ever matter for virtio-ccw though.

Connie, do you have an opinion on this?

Regards,
Halil

> +			status &= ~VIRTIO_CONFIG_S_FEATURES_OK;
> +
>  	/* Write the status to the host. */
>  	vcdev->dma_area->status = status;
>  	ccw->cmd_code = CCW_CMD_WRITE_STATUS;

