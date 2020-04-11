Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 345C91A4E44
	for <lists+kvm@lfdr.de>; Sat, 11 Apr 2020 07:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgDKFwe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 11 Apr 2020 01:52:34 -0400
Received: from mga06.intel.com ([134.134.136.31]:40189 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725855AbgDKFwd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Apr 2020 01:52:33 -0400
IronPort-SDR: 9/8Mo6zMwPxfP7Yb9gkWxCoo8wOK2dYosR+1YYnvIp6cH4NYl0jOM5xH8NQ0YTjd8hKP2gJ+dD
 J2DpDL1Li8ww==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2020 22:52:33 -0700
IronPort-SDR: D9S4NmhTY9He0vCHWlIIHDwfxarPdFygWdKBlgYxYMAyjMca3hoZdN6fUp+96mF+lgTf32YNKh
 C3aiBL+vOCkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,368,1580803200"; 
   d="scan'208";a="287382593"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga002.fm.intel.com with ESMTP; 10 Apr 2020 22:52:33 -0700
Received: from fmsmsx115.amr.corp.intel.com (10.18.116.19) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 10 Apr 2020 22:52:33 -0700
Received: from shsmsx101.ccr.corp.intel.com (10.239.4.153) by
 fmsmsx115.amr.corp.intel.com (10.18.116.19) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 10 Apr 2020 22:52:32 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX101.ccr.corp.intel.com ([169.254.1.129]) with mapi id 14.03.0439.000;
 Sat, 11 Apr 2020 13:52:23 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>
Subject: RE: [PATCH v1 6/8] vfio/type1: Bind guest page tables to host
Thread-Topic: [PATCH v1 6/8] vfio/type1: Bind guest page tables to host
Thread-Index: AQHWAEUdkW8K+/kg/06c7098DvJyv6hlyxcAgA2TZEA=
Date:   Sat, 11 Apr 2020 05:52:22 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A22AD8E@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
        <1584880325-10561-7-git-send-email-yi.l.liu@intel.com>
 <20200402135700.0da30021@w520.home>
In-Reply-To: <20200402135700.0da30021@w520.home>
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

Hi Alex,

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, April 3, 2020 3:57 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [PATCH v1 6/8] vfio/type1: Bind guest page tables to host
> 
> On Sun, 22 Mar 2020 05:32:03 -0700
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> 
> > From: Liu Yi L <yi.l.liu@intel.com>
> >
> > VFIO_TYPE1_NESTING_IOMMU is an IOMMU type which is backed by
[...]
> > +/**
> > + * Unbind specific gpasid, caller of this function requires hold
> > + * vfio_iommu->lock
> > + */
> > +static long vfio_iommu_type1_do_guest_unbind(struct vfio_iommu *iommu,
> > +				struct iommu_gpasid_bind_data *gbind_data)
> > +{
> > +	return vfio_iommu_for_each_dev(iommu,
> > +				vfio_unbind_gpasid_fn, gbind_data);
> > +}
> > +
> > +static long vfio_iommu_type1_bind_gpasid(struct vfio_iommu *iommu,
> > +				struct iommu_gpasid_bind_data *gbind_data)
> > +{
> > +	int ret = 0;
> > +
> > +	mutex_lock(&iommu->lock);
> > +	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> > +		ret = -EINVAL;
> > +		goto out_unlock;
> > +	}
> > +
> > +	ret = vfio_iommu_for_each_dev(iommu,
> > +			vfio_bind_gpasid_fn, gbind_data);
> > +	/*
> > +	 * If bind failed, it may not be a total failure. Some devices
> > +	 * within the iommu group may have bind successfully. Although
> > +	 * we don't enable pasid capability for non-singletion iommu
> > +	 * groups, a unbind operation would be helpful to ensure no
> > +	 * partial binding for an iommu group.
> 
> Where was the non-singleton group restriction done, I missed that.
> 
> > +	 */
> > +	if (ret)
> > +		/*
> > +		 * Undo all binds that already succeeded, no need to
> > +		 * check the return value here since some device within
> > +		 * the group has no successful bind when coming to this
> > +		 * place switch.
> > +		 */
> > +		vfio_iommu_type1_do_guest_unbind(iommu, gbind_data);
> 
> However, the for_each_dev function stops when the callback function
> returns error, are we just assuming we stop at the same device as we
> faulted on the first time and that we traverse the same set of devices
> the second time?  It seems strange to me that unbind should be able to
> fail.

I think the code needs enhancement. Although one group per container
and one device per group is the most typical and desired case, but
the code here loops domains, groups, devices. It should be able to
unwind prior bind when the loop failed for a device. So I plan to do
below change for bind path.

list_for_each_entry(domain, &iommu->domain_list, next) {
	list_for_each_entry(group, &domain->group_list, next) {
		/*
		  * if bind failed on a certain device, should unbind prior successful
		  * bind iommu_group_for_each_dev() should be modified to take two
		  * callbacks, one for forward loop and one for reverse loop when failure
		  * happened. "return_upon_failure" indicates whether return upon failure
		  * during forward loop or not. If yes, iommu_group_for_each_dev() should
		  * unwind the prior bind in this iommu group before return.
		  */
		ret = iommu_group_for_each_dev(iommu_group, bind_gpasid_fn,
					unbind_gpasid_fn, data, return_upon_failure);
		if (ret)
			break;
	}
	if (ret) {
		/* unwind bindings with prior groups */
		list_for_each_entry_continue_reverse(group,
							&domain->group_list, next) {
			iommu_group_for_each_dev(iommu_group, unbind_gpasid_fn,
						NULL, data, ignore_intermediate_failure);
		}
		break;
	}
}

if (ret) {
	/* unwind bindings with prior domains */
	list_for_each_entry_continue_reverse(domain, &iommu->domain_list, next) {
		iommu_group_for_each_dev(iommu_group, unbind_gpasid_fn,
						NULL, data, ignore_intermediate_failure);
		}
	}
}

return ret;

Regards,
Yi Liu
