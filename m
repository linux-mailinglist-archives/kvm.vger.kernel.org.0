Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4F1812049B
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 13:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbfLPL74 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 16 Dec 2019 06:59:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:44921 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727241AbfLPL7z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 06:59:55 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Dec 2019 03:59:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,321,1571727600"; 
   d="scan'208";a="221485422"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga001.fm.intel.com with ESMTP; 16 Dec 2019 03:59:54 -0800
Received: from fmsmsx161.amr.corp.intel.com (10.18.125.9) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 16 Dec 2019 03:59:55 -0800
Received: from shsmsx103.ccr.corp.intel.com (10.239.4.69) by
 FMSMSX161.amr.corp.intel.com (10.18.125.9) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 16 Dec 2019 03:59:53 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.90]) by
 SHSMSX103.ccr.corp.intel.com ([169.254.4.29]) with mapi id 14.03.0439.000;
 Mon, 16 Dec 2019 19:59:52 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe.brucker@arm.com" <jean-philippe.brucker@arm.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v3 03/10] vfio_pci: refine vfio_pci_driver reference in
 vfio_pci.c
Thread-Topic: [PATCH v3 03/10] vfio_pci: refine vfio_pci_driver reference in
 vfio_pci.c
Thread-Index: AQHVoSntMsAVvlFieUi72FX6+tynY6e7apkAgAFjZ4A=
Date:   Mon, 16 Dec 2019 11:59:51 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A134FF2@SHSMSX104.ccr.corp.intel.com>
References: <1574335427-3763-1-git-send-email-yi.l.liu@intel.com>
        <1574335427-3763-4-git-send-email-yi.l.liu@intel.com>
 <20191215154642.1d4163bf@x1.home>
In-Reply-To: <20191215154642.1d4163bf@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZmEyMzFjNzUtYWNlYy00M2RjLWIzOGItNjY5MjdmODYwMDc0IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiaXlJbEZYb1wvcnpOMXBWdXdKT0p6VlhUUXlEZ3hJTmc5d0hYQlZSM3J6dEtvVjk1YzVkK2piQjlnbW1HdkJTaUIifQ==
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson < alex.williamson@redhat.com>
> Sent: Monday, December 16, 2019 6:47 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [PATCH v3 03/10] vfio_pci: refine vfio_pci_driver reference in vfio_pci.c
> 
> On Thu, 21 Nov 2019 19:23:40 +0800
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
> >  drivers/vfio/pci/vfio_pci.c | 33 ++++++++++++++++++---------------
> >  1 file changed, 18 insertions(+), 15 deletions(-)
> >
> > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > index b04e43a..2096e66 100644
> > --- a/drivers/vfio/pci/vfio_pci.c
> > +++ b/drivers/vfio/pci/vfio_pci.c
> > @@ -1460,24 +1460,25 @@ static void vfio_pci_reflck_get(struct vfio_pci_reflck
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
> >  		vfio_device_put(device);
> >  		return 1;
> >  	}
> > @@ -1494,7 +1495,7 @@ static int vfio_pci_reflck_attach(struct vfio_pci_device
> *vdev)
> >
> >  	if (pci_is_root_bus(vdev->pdev->bus) ||
> >  	    vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_reflck_find,
> > -					  &vdev->reflck, slot) <= 0)
> > +					  vdev, slot) <= 0)
> >  		vdev->reflck = vfio_pci_reflck_alloc();
> >
> >  	mutex_unlock(&reflck_lock);
> > @@ -1519,6 +1520,7 @@ static void vfio_pci_reflck_put(struct vfio_pci_reflck
> *reflck)
> >
> >  struct vfio_devices {
> >  	struct vfio_device **devices;
> > +	struct vfio_pci_device *vdev;
> >  	int cur_index;
> >  	int max_index;
> >  };
> > @@ -1527,7 +1529,7 @@ static int vfio_pci_get_unused_devs(struct pci_dev
> *pdev, void *data)
> >  {
> >  	struct vfio_devices *devs = data;
> >  	struct vfio_device *device;
> > -	struct vfio_pci_device *vdev;
> > +	struct vfio_pci_device *tmp;
> >
> >  	if (devs->cur_index == devs->max_index)
> >  		return -ENOSPC;
> > @@ -1536,15 +1538,15 @@ static int vfio_pci_get_unused_devs(struct pci_dev
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
> > @@ -1590,6 +1592,7 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_device
> *vdev)
> >  	if (!devs.devices)
> >  		return;
> >
> > +	devs.vdev = vdev;
> 
> This could be added to the declaration initializer:
> 
> struct vfio_devices devs = { .vdev = vdev, .cur_index = 0 };
> 
> It might seem a little less random then.  Thanks,

Got it. Will do it.

Thanks,
Yi Liu

