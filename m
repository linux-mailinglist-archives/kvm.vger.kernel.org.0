Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC2041993D6
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 12:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730403AbgCaKsm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 31 Mar 2020 06:48:42 -0400
Received: from mga05.intel.com ([192.55.52.43]:52858 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730341AbgCaKsm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 06:48:42 -0400
IronPort-SDR: BEymclEx7Qu6XWtvGKhSyOA4MNOzBwVdR8L+Jr0PatHcYNZnUZqFJdhA621QQrHaPD8Tzabio+
 U52hAHKVbCNw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2020 03:48:41 -0700
IronPort-SDR: /KxE8UaVN606pxVD82pMLbaBTRRjTyTVrnwsMDf2oRUpusKQ2fCmIBiu/rYtDf7mmYPvuWqPzq
 OXpLLRaayGGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,327,1580803200"; 
   d="scan'208";a="448624636"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga005.fm.intel.com with ESMTP; 31 Mar 2020 03:48:41 -0700
Received: from fmsmsx102.amr.corp.intel.com (10.18.124.200) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 31 Mar 2020 03:48:41 -0700
Received: from shsmsx153.ccr.corp.intel.com (10.239.6.53) by
 FMSMSX102.amr.corp.intel.com (10.18.124.200) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 31 Mar 2020 03:48:41 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX153.ccr.corp.intel.com ([169.254.12.89]) with mapi id 14.03.0439.000;
 Tue, 31 Mar 2020 18:48:37 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sun, Yi Y" <yi.y.sun@intel.com>, "Wu, Hao" <hao.wu@intel.com>
Subject: RE: [PATCH v1 7/8] vfio/type1: Add VFIO_IOMMU_CACHE_INVALIDATE
Thread-Topic: [PATCH v1 7/8] vfio/type1: Add VFIO_IOMMU_CACHE_INVALIDATE
Thread-Index: AQHWAEUdcc1u01skwUmp6uBHREsZ66hh3P+AgACUz4A=
Date:   Tue, 31 Mar 2020 10:48:36 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A21ACC1@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
 <1584880325-10561-8-git-send-email-yi.l.liu@intel.com>
 <20200331075603.GB26583@infradead.org>
In-Reply-To: <20200331075603.GB26583@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Hellwig,

Thanks for your review, Hellwig. :-) inline reply.

> From: Christoph Hellwig <hch@infradead.org>
> Sent: Tuesday, March 31, 2020 3:56 PM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [PATCH v1 7/8] vfio/type1: Add VFIO_IOMMU_CACHE_INVALIDATE
> 
> > @@ -2629,6 +2638,46 @@ static long vfio_iommu_type1_ioctl(void
> *iommu_data,
> >  		}
> >  		kfree(gbind_data);
> >  		return ret;
> > +	} else if (cmd == VFIO_IOMMU_CACHE_INVALIDATE) {
> 
> Please refactor the spaghetti in this ioctl handler to use a switch statement and a
> helper function per command before growing it even more.

got it. I may get a separate refactor patch before adding my changes.

> 
> > +		/* Get the version of struct iommu_cache_invalidate_info */
> > +		if (copy_from_user(&version,
> > +			(void __user *) (arg + minsz), sizeof(version)))
> > +			return -EFAULT;
> > +
> > +		info_size = iommu_uapi_get_data_size(
> > +					IOMMU_UAPI_CACHE_INVAL, version);
> > +
> > +		cache_info = kzalloc(info_size, GFP_KERNEL);
> > +		if (!cache_info)
> > +			return -ENOMEM;
> > +
> > +		if (copy_from_user(cache_info,
> > +			(void __user *) (arg + minsz), info_size)) {
> 
> The user might have changed the version while you were allocating and
> freeing the
> memory, introducing potentially exploitable racing conditions.

yeah, I know the @version is not welcomed in the thread Jacob is driving.
I'll adjust the code here once the open in that thread has been solved.

But regardless of the version, I'm not sure if I 100% got your point.
Could you elaborate a bit? BTW. The code somehow referenced the code
below. The basic flow is copying partial data from __arg and then copy
the rest data after figuring out how much left. The difference betwen
below code and my code is just different way to figure out left data
size. Since I'm not sure if I got your point. If the racing is true in
such flow, I guess there are quite a few places need to enhance.

vfio_pci_ioctl(){
{
...
        } else if (cmd == VFIO_DEVICE_SET_IRQS) {
                struct vfio_irq_set hdr;
                u8 *data = NULL;
                int max, ret = 0;
                size_t data_size = 0;

                minsz = offsetofend(struct vfio_irq_set, count);

                if (copy_from_user(&hdr, (void __user *)arg, minsz))
                        return -EFAULT;

                max = vfio_pci_get_irq_count(vdev, hdr.index);

                ret = vfio_set_irqs_validate_and_prepare(&hdr, max,
                                                 VFIO_PCI_NUM_IRQS, &data_size);
                if (ret)
                        return ret;

                if (data_size) {
                        data = memdup_user((void __user *)(arg + minsz),
                                            data_size);
                        if (IS_ERR(data))
                                return PTR_ERR(data);
                }

                mutex_lock(&vdev->igate);

                ret = vfio_pci_set_irqs_ioctl(vdev, hdr.flags, hdr.index,
                                              hdr.start, hdr.count, data);

                mutex_unlock(&vdev->igate);
                kfree(data);

                return ret;

        } else if (cmd == VFIO_DEVICE_RESET) {
...
}

Regards,
Yi Liu
