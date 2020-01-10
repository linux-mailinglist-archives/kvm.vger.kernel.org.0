Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBC0136855
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 08:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgAJHfE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 10 Jan 2020 02:35:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:29651 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726186AbgAJHfD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 02:35:03 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 23:35:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,415,1571727600"; 
   d="scan'208";a="212165388"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga007.jf.intel.com with ESMTP; 09 Jan 2020 23:35:02 -0800
Received: from shsmsx101.ccr.corp.intel.com (10.239.4.153) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 9 Jan 2020 23:35:02 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.197]) by
 SHSMSX101.ccr.corp.intel.com ([169.254.1.30]) with mapi id 14.03.0439.000;
 Fri, 10 Jan 2020 15:35:00 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>
Subject: RE: [PATCH v4 03/12] vfio_pci: refine vfio_pci_driver reference in
 vfio_pci.c
Thread-Topic: [PATCH v4 03/12] vfio_pci: refine vfio_pci_driver reference in
 vfio_pci.c
Thread-Index: AQHVxVT0YU6i0iA5BEKaqiieIB/qd6fibQCAgAEY9HA=
Date:   Fri, 10 Jan 2020 07:35:00 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A179AB4@SHSMSX104.ccr.corp.intel.com>
References: <1578398509-26453-1-git-send-email-yi.l.liu@intel.com>
        <1578398509-26453-4-git-send-email-yi.l.liu@intel.com>
 <20200109154819.455f11d3@w520.home>
In-Reply-To: <20200109154819.455f11d3@w520.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNGQyMWRlYzEtYjE2Yi00YzkwLWI4ZjctOTc2ZjU0MDJjNDVkIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiMDRnVndcL0E3dHA1SytTYzRSajYxYlByN1pzQ1IxQ2pDTTJVWWNDNTFTUDFZY29KTEU5ZExlWm9SZ1l0RGFTbVQifQ==
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Friday, January 10, 2020 6:48 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [PATCH v4 03/12] vfio_pci: refine vfio_pci_driver reference in vfio_pci.c
> 
> On Tue,  7 Jan 2020 20:01:40 +0800
> Liu Yi L <yi.l.liu@intel.com> wrote:
> 
> > This patch replaces the vfio_pci_driver reference in vfio_pci.c with
> > pci_dev_driver(vdev->pdev) which is more helpful to make the functions
> > be generic to module types.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/pci/vfio_pci.c | 34 ++++++++++++++++++----------------
> >  1 file changed, 18 insertions(+), 16 deletions(-)
> >
> > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > index 009d2df..9140f5e5 100644
> > --- a/drivers/vfio/pci/vfio_pci.c
> > +++ b/drivers/vfio/pci/vfio_pci.c
> > @@ -1463,24 +1463,25 @@ static void vfio_pci_reflck_get(struct vfio_pci_reflck
> *reflck)
> >
> >  static int vfio_pci_reflck_find(struct pci_dev *pdev, void *data)
> >  {
> > -	struct vfio_pci_reflck **preflck = data;
> > +	struct vfio_pci_device *vdev = data;
> > +	struct vfio_pci_reflck **preflck = &vdev->reflck;
> >  	struct vfio_device *device;
> > -	struct vfio_pci_device *vdev;
> > +	struct vfio_pci_device *tmp;
> >
> >  	device = vfio_device_get_from_dev(&pdev->dev);
> >  	if (!device)
> >  		return 0;
> >
> > -	if (pci_dev_driver(pdev) != &vfio_pci_driver) {
> > +	if (pci_dev_driver(pdev) != pci_dev_driver(vdev->pdev)) {
> >  		vfio_device_put(device);
> >  		return 0;
> >  	}
> >
> > -	vdev = vfio_device_data(device);
> > +	tmp = vfio_device_data(device);
> >
> > -	if (vdev->reflck) {
> > -		vfio_pci_reflck_get(vdev->reflck);
> > -		*preflck = vdev->reflck;
> > +	if (tmp->reflck) {
> > +		vfio_pci_reflck_get(tmp->reflck);
> > +		*preflck = tmp->reflck;
> 
> Seems we can do away with preflck entirely with this refactor, this
> simply becomes vdev->reflck = tmp->reflck.  Thanks,

yes, it is. Will modify it.

> Alex

Thanks,
Yi Liu

> >  		vfio_device_put(device);
> >  		return 1;
> >  	}
> > @@ -1497,7 +1498,7 @@ static int vfio_pci_reflck_attach(struct vfio_pci_device
> *vdev)
> >
> >  	if (pci_is_root_bus(vdev->pdev->bus) ||
> >  	    vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_reflck_find,
> > -					  &vdev->reflck, slot) <= 0)
> > +					  vdev, slot) <= 0)
> >  		vdev->reflck = vfio_pci_reflck_alloc();
> >
> >  	mutex_unlock(&reflck_lock);
> > @@ -1522,6 +1523,7 @@ static void vfio_pci_reflck_put(struct vfio_pci_reflck
> *reflck)
> >
> >  struct vfio_devices {
> >  	struct vfio_device **devices;
> > +	struct vfio_pci_device *vdev;
> >  	int cur_index;
> >  	int max_index;
> >  };
> > @@ -1530,7 +1532,7 @@ static int vfio_pci_get_unused_devs(struct pci_dev
> *pdev, void *data)
> >  {
> >  	struct vfio_devices *devs = data;
> >  	struct vfio_device *device;
> > -	struct vfio_pci_device *vdev;
> > +	struct vfio_pci_device *tmp;
> >
> >  	if (devs->cur_index == devs->max_index)
> >  		return -ENOSPC;
> > @@ -1539,15 +1541,15 @@ static int vfio_pci_get_unused_devs(struct pci_dev
> *pdev, void *data)
> >  	if (!device)
> >  		return -EINVAL;
> >
> > -	if (pci_dev_driver(pdev) != &vfio_pci_driver) {
> > +	if (pci_dev_driver(pdev) != pci_dev_driver(devs->vdev->pdev)) {
> >  		vfio_device_put(device);
> >  		return -EBUSY;
> >  	}
> >
> > -	vdev = vfio_device_data(device);
> > +	tmp = vfio_device_data(device);
> >
> >  	/* Fault if the device is not unused */
> > -	if (vdev->refcnt) {
> > +	if (tmp->refcnt) {
> >  		vfio_device_put(device);
> >  		return -EBUSY;
> >  	}
> > @@ -1574,7 +1576,7 @@ static int vfio_pci_get_unused_devs(struct pci_dev
> *pdev, void *data)
> >   */
> >  static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
> >  {
> > -	struct vfio_devices devs = { .cur_index = 0 };
> > +	struct vfio_devices devs = { .vdev = vdev, .cur_index = 0 };
> >  	int i = 0, ret = -EINVAL;
> >  	bool slot = false;
> >  	struct vfio_pci_device *tmp;
> > @@ -1637,7 +1639,7 @@ static void __exit vfio_pci_cleanup(void)
> >  	vfio_pci_uninit_perm_bits();
> >  }
> >
> > -static void __init vfio_pci_fill_ids(char *ids)
> > +static void __init vfio_pci_fill_ids(char *ids, struct pci_driver *driver)
> >  {
> >  	char *p, *id;
> >  	int rc;
> > @@ -1665,7 +1667,7 @@ static void __init vfio_pci_fill_ids(char *ids)
> >  			continue;
> >  		}
> >
> > -		rc = pci_add_dynid(&vfio_pci_driver, vendor, device,
> > +		rc = pci_add_dynid(driver, vendor, device,
> >  				   subvendor, subdevice, class, class_mask, 0);
> >  		if (rc)
> >  			pr_warn("failed to add dynamic id [%04x:%04x[%04x:%04x]]
> class %#08x/%08x (%d)\n",
> > @@ -1692,7 +1694,7 @@ static int __init vfio_pci_init(void)
> >  	if (ret)
> >  		goto out_driver;
> >
> > -	vfio_pci_fill_ids(ids);
> > +	vfio_pci_fill_ids(ids, &vfio_pci_driver);
> >
> >  	return 0;
> >

