Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4437FC20B8
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 14:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730876AbfI3MjQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 30 Sep 2019 08:39:16 -0400
Received: from mga04.intel.com ([192.55.52.120]:25287 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730867AbfI3MjQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 08:39:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Sep 2019 05:39:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,567,1559545200"; 
   d="scan'208";a="220637682"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga002.fm.intel.com with ESMTP; 30 Sep 2019 05:39:14 -0700
Received: from fmsmsx158.amr.corp.intel.com (10.18.116.75) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Sep 2019 05:39:14 -0700
Received: from shsmsx101.ccr.corp.intel.com (10.239.4.153) by
 fmsmsx158.amr.corp.intel.com (10.18.116.75) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Sep 2019 05:39:14 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.166]) by
 SHSMSX101.ccr.corp.intel.com ([169.254.1.96]) with mapi id 14.03.0439.000;
 Mon, 30 Sep 2019 20:39:12 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>,
        "Xia, Chenbo" <chenbo.xia@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>
Subject: RE: [PATCH v2 10/13] samples: refine vfio-mdev-pci driver
Thread-Topic: [PATCH v2 10/13] samples: refine vfio-mdev-pci driver
Thread-Index: AQHVZIuV8hu7Mezzf0eEOg4XSMUPJqc810QAgAcLA6A=
Date:   Mon, 30 Sep 2019 12:39:11 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A0B55CE@SHSMSX104.ccr.corp.intel.com>
References: <1567670370-4484-1-git-send-email-yi.l.liu@intel.com>
        <1567670370-4484-11-git-send-email-yi.l.liu@intel.com>
 <20190925203644.7273028f@x1.home>
In-Reply-To: <20190925203644.7273028f@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZjNjMzRkYTEtYmNkNC00YjZjLTljODgtZDViOWJhOGMzMmE0IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiVFhWN01xV3Y2QXBVWURcL25CbXVzeFwvcjhMdVhoTEVhTHBrS2JOUEhRbndqMGMxcTVKZ3JCalRSOHFlaXpoMHJ2In0=
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Thursday, September 26, 2019 10:37 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
>
> Subject: Re: [PATCH v2 10/13] samples: refine vfio-mdev-pci driver
> 
> On Thu,  5 Sep 2019 15:59:27 +0800
> Liu Yi L <yi.l.liu@intel.com> wrote:
> 
> > From: Alex Williamson <alex.williamson@redhat.com>
> >
> > This patch refines the implementation of original vfio-mdev-pci driver.
> >
> > And the vfio-mdev-pci-type_name will be named per the following rule:
> >
> > 	vmdev->attr.name = kasprintf(GFP_KERNEL,
> > 				     "%04x:%04x:%04x:%04x:%06x:%02x",
> > 				     pdev->vendor, pdev->device,
> > 				     pdev->subsystem_vendor,
> > 				     pdev->subsystem_device, pdev->class,
> > 				     pdev->revision);
> >
> > Before usage, check the
> > /sys/bus/pci/devices/$bdf/mdev_supported_types/
> > to ensure the final mdev_supported_types.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/pci/vfio_mdev_pci.c | 123
> > +++++++++++++++++++++++----------------
> >  1 file changed, 72 insertions(+), 51 deletions(-)
> >
> > diff --git a/drivers/vfio/pci/vfio_mdev_pci.c
> > b/drivers/vfio/pci/vfio_mdev_pci.c
> > index 07c8067..09143d3 100644
> > --- a/drivers/vfio/pci/vfio_mdev_pci.c
> > +++ b/drivers/vfio/pci/vfio_mdev_pci.c
> > @@ -65,18 +65,22 @@ MODULE_PARM_DESC(disable_idle_d3,
> >
> >  static struct pci_driver vfio_mdev_pci_driver;
> >
> > -static ssize_t
> > -name_show(struct kobject *kobj, struct device *dev, char *buf) -{
> > -	return sprintf(buf, "%s-type1\n", dev_name(dev));
> > -}
> > -
> > -MDEV_TYPE_ATTR_RO(name);
> > +struct vfio_mdev_pci_device {
> > +	struct vfio_pci_device vdev;
> > +	struct mdev_parent_ops ops;
> > +	struct attribute_group *groups[2];
> > +	struct attribute_group attr;
> > +	atomic_t avail;
> > +};
> >
> >  static ssize_t
> >  available_instances_show(struct kobject *kobj, struct device *dev,
> > char *buf)  {
> > -	return sprintf(buf, "%d\n", 1);
> > +	struct vfio_mdev_pci_device *vmdev;
> > +
> > +	vmdev = pci_get_drvdata(to_pci_dev(dev));
> > +
> > +	return sprintf(buf, "%d\n", atomic_read(&vmdev->avail));
> >  }
> >
> >  MDEV_TYPE_ATTR_RO(available_instances);
> > @@ -90,62 +94,57 @@ static ssize_t device_api_show(struct kobject
> > *kobj, struct device *dev,  MDEV_TYPE_ATTR_RO(device_api);
> >
> >  static struct attribute *vfio_mdev_pci_types_attrs[] = {
> > -	&mdev_type_attr_name.attr,
> >  	&mdev_type_attr_device_api.attr,
> >  	&mdev_type_attr_available_instances.attr,
> >  	NULL,
> >  };
> >
> > -static struct attribute_group vfio_mdev_pci_type_group1 = {
> > -	.name  = "type1",
> > -	.attrs = vfio_mdev_pci_types_attrs,
> > -};
> > -
> > -struct attribute_group *vfio_mdev_pci_type_groups[] = {
> > -	&vfio_mdev_pci_type_group1,
> > -	NULL,
> > -};
> > -
> >  struct vfio_mdev_pci {
> >  	struct vfio_pci_device *vdev;
> >  	struct mdev_device *mdev;
> > -	unsigned long handle;
> >  };
> >
> >  static int vfio_mdev_pci_create(struct kobject *kobj, struct
> > mdev_device *mdev)  {
> >  	struct device *pdev;
> > -	struct vfio_pci_device *vdev;
> > +	struct vfio_mdev_pci_device *vmdev;
> >  	struct vfio_mdev_pci *pmdev;
> >  	int ret;
> >
> >  	pdev = mdev_parent_dev(mdev);
> > -	vdev = dev_get_drvdata(pdev);
> > +	vmdev = dev_get_drvdata(pdev);
> > +
> > +	if (atomic_dec_if_positive(&vmdev->avail) < 0)
> > +		return -ENOSPC;
> > +
> >  	pmdev = kzalloc(sizeof(struct vfio_mdev_pci), GFP_KERNEL);
> > -	if (pmdev == NULL) {
> > -		ret = -EBUSY;
> > -		goto out;
> > -	}
> > +	if (!pmdev)
> > +		return -ENOMEM;
> 
> Needs an atomic_inc(&vmdev->avail) in this error path.  Thanks,

Oops, yes it is.

> 
> Alex

Thanks,
Yi Liu
