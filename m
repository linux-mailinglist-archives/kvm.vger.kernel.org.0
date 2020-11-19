Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4102B963C
	for <lists+kvm@lfdr.de>; Thu, 19 Nov 2020 16:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbgKSPaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Nov 2020 10:30:13 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7934 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728360AbgKSPaN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Nov 2020 10:30:13 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJFA1S0148038;
        Thu, 19 Nov 2020 10:30:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=W75A4RcZtPqypMMF4Qf2CDXeDTMXq5RsH05OrOg2BH4=;
 b=TzmT8LavydMMWrkcg5bZEfXppnL+8argUzxRAD8aU9I6HFtrzK2Ij0u3brkKCWiAzOvQ
 6DraMrfWzgtdVBqfihzB87xXvow5V/iARMTHIdeK1JDMYxlAlV/PhrMSFkNwgz9DQ1AS
 Sc5GJYXfMkMlbyNLwBrgcGnHXvFR/35HSFCN8gP0ZPaM4koFd0VGfI7Wcjr43xFLNBiL
 h/erENq5JVeQs31e6a4R5Kut1IIzpLAxw4bVxm6t18XDAN4laFIsI4YDBWXq+/CeFnIl
 lOPuYlnAz8WLl3MuUlZLvIMdYYva6VoOgagcegcSzUCwEojmbgSaWG1pKo/juOYY13t9 sQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34wg60h3g1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 10:30:09 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AJFAPTl151053;
        Thu, 19 Nov 2020 10:30:08 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34wg60h3dd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 10:30:08 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AJFS3Ue016982;
        Thu, 19 Nov 2020 15:30:02 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 34w4yfh6y5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 15:30:02 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AJFU0tL2490964
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Nov 2020 15:30:00 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08CF052059;
        Thu, 19 Nov 2020 15:30:00 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.7.71])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id A717752057;
        Thu, 19 Nov 2020 15:29:59 +0000 (GMT)
Date:   Thu, 19 Nov 2020 16:29:58 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] vfio-mdev: Wire in a request handler for mdev
 parent
Message-ID: <20201119162958.2c1a0781.pasic@linux.ibm.com>
In-Reply-To: <20201117032139.50988-2-farman@linux.ibm.com>
References: <20201117032139.50988-1-farman@linux.ibm.com>
        <20201117032139.50988-2-farman@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_09:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 impostorscore=0 malwarescore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011190110
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 Nov 2020 04:21:38 +0100
Eric Farman <farman@linux.ibm.com> wrote:

> While performing some destructive tests with vfio-ccw, where the
> paths to a device are forcible removed and thus the device itself
> is unreachable, it is rather easy to end up in an endless loop in
> vfio_del_group_dev() due to the lack of a request callback for the
> associated device.
> 
> In this example, one MDEV (77c) is used by a guest, while another
> (77b) is not. The symptom is that the iommu is detached from the
> mdev for 77b, but not 77c, until that guest is shutdown:
> 
>     [  238.794867] vfio_ccw 0.0.077b: MDEV: Unregistering
>     [  238.794996] vfio_mdev 11f2d2bc-4083-431d-a023-eff72715c4f0: Removing from iommu group 2
>     [  238.795001] vfio_mdev 11f2d2bc-4083-431d-a023-eff72715c4f0: MDEV: detaching iommu
>     [  238.795036] vfio_ccw 0.0.077c: MDEV: Unregistering
>     ...silence...
> 
> Let's wire in the request call back to the mdev device, so that a hot
> unplug can be (gracefully?) handled by the parent device at the time
> the device is being removed.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/vfio/mdev/vfio_mdev.c | 11 +++++++++++
>  include/linux/mdev.h          |  4 ++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
> index 30964a4e0a28..2dd243f73945 100644
> --- a/drivers/vfio/mdev/vfio_mdev.c
> +++ b/drivers/vfio/mdev/vfio_mdev.c
> @@ -98,6 +98,16 @@ static int vfio_mdev_mmap(void *device_data, struct vm_area_struct *vma)
>  	return parent->ops->mmap(mdev, vma);
>  }
>  
> +static void vfio_mdev_request(void *device_data, unsigned int count)
> +{
> +	struct mdev_device *mdev = device_data;
> +	struct mdev_parent *parent = mdev->parent;
> +
> +	if (unlikely(!parent->ops->request))
> +		return;
> +	parent->ops->request(mdev, count);
> +}
> +
>  static const struct vfio_device_ops vfio_mdev_dev_ops = {
>  	.name		= "vfio-mdev",
>  	.open		= vfio_mdev_open,
> @@ -106,6 +116,7 @@ static const struct vfio_device_ops vfio_mdev_dev_ops = {
>  	.read		= vfio_mdev_read,
>  	.write		= vfio_mdev_write,
>  	.mmap		= vfio_mdev_mmap,
> +	.request	= vfio_mdev_request,
>  };
>  
>  static int vfio_mdev_probe(struct device *dev)
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 0ce30ca78db0..0ed88be1f4bb 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -72,6 +72,9 @@ struct device *mdev_get_iommu_device(struct device *dev);
>   * @mmap:		mmap callback
>   *			@mdev: mediated device structure
>   *			@vma: vma structure
> + * @request:		request callback

In include/linux/vfio.h it is documented like
 * @request: Request for the bus driver to release the device

Can we add 'to release' here as well?

IMHO, when one requests, one needs to say what is requested. So
I would expect a function called request() to have a parameter
(direct or indirect) that expresses, what is requested. But this
does not seem to be the case here. Or did I miss it?

Well it's called  request() and not request_removal() in vfio,
so I believe it's only consistent to keep calling it request().

But I do think we should at least document what is actually requested.

Otherwise LGTM!

> + *			@mdev: mediated device structure
> + *			@count: request sequence number
>   * Parent device that support mediated device should be registered with mdev
>   * module with mdev_parent_ops structure.
>   **/
> @@ -92,6 +95,7 @@ struct mdev_parent_ops {
>  	long	(*ioctl)(struct mdev_device *mdev, unsigned int cmd,
>  			 unsigned long arg);
>  	int	(*mmap)(struct mdev_device *mdev, struct vm_area_struct *vma);
> +	void	(*request)(struct mdev_device *mdev, unsigned int count);
>  };
>  
>  /* interface for exporting mdev supported type attributes */
