Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D32D014E736
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 03:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbgAaCfZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 21:35:25 -0500
Received: from mga05.intel.com ([192.55.52.43]:1707 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727787AbgAaCfZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 21:35:25 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 18:35:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,384,1574150400"; 
   d="scan'208";a="218483700"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga007.jf.intel.com with ESMTP; 30 Jan 2020 18:35:21 -0800
Date:   Thu, 30 Jan 2020 21:26:06 -0500
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH v4 11/12] samples: add vfio-mdev-pci driver
Message-ID: <20200131022606.GK1759@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200109154831.4c43564f@w520.home>
 <A2975661238FB949B60364EF0F2C25743A183EB3@SHSMSX104.ccr.corp.intel.com>
 <20200116142418.6ca1b6b2@w520.home>
 <A2975661238FB949B60364EF0F2C25743A1887A5@SHSMSX104.ccr.corp.intel.com>
 <20200120140748.33fa0b0a@w520.home>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D73EAC0@SHSMSX104.ccr.corp.intel.com>
 <20200121084351.GF1759@joy-OptiPlex-7040>
 <20200121130438.685fc6cb@w520.home>
 <20200121215445.GG1759@joy-OptiPlex-7040>
 <20200123163322.2376da37@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200123163322.2376da37@w520.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 24, 2020 at 07:33:22AM +0800, Alex Williamson wrote:
> On Tue, 21 Jan 2020 16:54:45 -0500
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > On Wed, Jan 22, 2020 at 04:04:38AM +0800, Alex Williamson wrote:
> > > On Tue, 21 Jan 2020 03:43:51 -0500
> > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > >   
> > > > On Tue, Jan 21, 2020 at 03:43:02PM +0800, Tian, Kevin wrote:  
> > > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > > Sent: Tuesday, January 21, 2020 5:08 AM
> > > > > > 
> > > > > > On Sat, 18 Jan 2020 14:25:11 +0000
> > > > > > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> > > > > >     
> > > > > > > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > > > > > > Sent: Friday, January 17, 2020 5:24 AM
> > > > > > > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > > > > > > Subject: Re: [PATCH v4 11/12] samples: add vfio-mdev-pci driver
> > > > > > > >
> > > > > > > > On Thu, 16 Jan 2020 12:33:06 +0000
> > > > > > > > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> > > > > > > >    
> > > > > > > > > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > > > > > > > > Sent: Friday, January 10, 2020 6:49 AM
> > > > > > > > > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > > > > > > > > Subject: Re: [PATCH v4 11/12] samples: add vfio-mdev-pci driver
> > > > > > > > > >
> > > > > > > > > > On Tue,  7 Jan 2020 20:01:48 +0800
> > > > > > > > > > Liu Yi L <yi.l.liu@intel.com> wrote:
> > > > > > > > > >    
> > > > > > > > > > > This patch adds sample driver named vfio-mdev-pci. It is to wrap
> > > > > > > > > > > a PCI device as a mediated device. For a pci device, once bound
> > > > > > > > > > > to vfio-mdev-pci driver, user space access of this device will
> > > > > > > > > > > go through vfio mdev framework. The usage of the device follows
> > > > > > > > > > > mdev management method. e.g. user should create a mdev before
> > > > > > > > > > > exposing the device to user-space.
> > > > > > > > > > >
> > > > > > > > > > > Benefit of this new driver would be acting as a sample driver
> > > > > > > > > > > for recent changes from "vfio/mdev: IOMMU aware mediated    
> > > > > > device"    
> > > > > > > > > > > patchset. Also it could be a good experiment driver for future
> > > > > > > > > > > device specific mdev migration support. This sample driver only
> > > > > > > > > > > supports singleton iommu groups, for non-singleton iommu groups,
> > > > > > > > > > > this sample driver doesn't work. It will fail when trying to assign
> > > > > > > > > > > the non-singleton iommu group to VMs.
> > > > > > > > > > >
> > > > > > > > > > > To use this driver:
> > > > > > > > > > > a) build and load vfio-mdev-pci.ko module
> > > > > > > > > > >    execute "make menuconfig" and config    
> > > > > > CONFIG_SAMPLE_VFIO_MDEV_PCI    
> > > > > > > > > > >    then load it with following command:    
> > > > > > > > > > >    > sudo modprobe vfio
> > > > > > > > > > >    > sudo modprobe vfio-pci
> > > > > > > > > > >    > sudo insmod samples/vfio-mdev-pci/vfio-mdev-pci.ko    
> > > > > > > > > > >
> > > > > > > > > > > b) unbind original device driver
> > > > > > > > > > >    e.g. use following command to unbind its original driver    
> > > > > > > > > > >    > echo $dev_bdf > /sys/bus/pci/devices/$dev_bdf/driver/unbind    
> > > > > > > > > > >
> > > > > > > > > > > c) bind vfio-mdev-pci driver to the physical device    
> > > > > > > > > > >    > echo $vend_id $dev_id > /sys/bus/pci/drivers/vfio-mdev-    
> > > > > > pci/new_id    
> > > > > > > > > > >
> > > > > > > > > > > d) check the supported mdev instances    
> > > > > > > > > > >    > ls /sys/bus/pci/devices/$dev_bdf/mdev_supported_types/    
> > > > > > > > > > >      vfio-mdev-pci-type_name    
> > > > > > > > > > >    > ls /sys/bus/pci/devices/$dev_bdf/mdev_supported_types/\    
> > > > > > > > > > >      vfio-mdev-pci-type_name/
> > > > > > > > > > >      available_instances  create  device_api  devices  name
> > > > > > > > > > >
> > > > > > > > > > > e)  create mdev on this physical device (only 1 instance)    
> > > > > > > > > > >    > echo "83b8f4f2-509f-382f-3c1e-e6bfe0fa1003" > \    
> > > > > > > > > > >      /sys/bus/pci/devices/$dev_bdf/mdev_supported_types/\
> > > > > > > > > > >      vfio-mdev-pci-type_name/create
> > > > > > > > > > >
> > > > > > > > > > > f) passthru the mdev to guest
> > > > > > > > > > >    add the following line in QEMU boot command
> > > > > > > > > > >     -device vfio-pci,\
> > > > > > > > > > >      sysfsdev=/sys/bus/mdev/devices/83b8f4f2-509f-382f-3c1e-    
> > > > > > e6bfe0fa1003    
> > > > > > > > > > >
> > > > > > > > > > > g) destroy mdev    
> > > > > > > > > > >    > echo 1 > /sys/bus/mdev/devices/83b8f4f2-509f-382f-3c1e-    
> > > > > > e6bfe0fa1003/\    
> > > > > > > > > > >      remove
> > > > > > > > > > >
> > > > > > > > > > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > > > > > > > > > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > > > > > > > > > > Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> > > > > > > > > > > Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> > > > > > > > > > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > > > > > > > > > ---
> > > > > > > > > > >  samples/Kconfig                       |  10 +
> > > > > > > > > > >  samples/Makefile                      |   1 +
> > > > > > > > > > >  samples/vfio-mdev-pci/Makefile        |   4 +
> > > > > > > > > > >  samples/vfio-mdev-pci/vfio_mdev_pci.c | 397    
> > > > > > > > > > ++++++++++++++++++++++++++++++++++    
> > > > > > > > > > >  4 files changed, 412 insertions(+)
> > > > > > > > > > >  create mode 100644 samples/vfio-mdev-pci/Makefile
> > > > > > > > > > >  create mode 100644 samples/vfio-mdev-pci/vfio_mdev_pci.c
> > > > > > > > > > >
> > > > > > > > > > > diff --git a/samples/Kconfig b/samples/Kconfig
> > > > > > > > > > > index 9d236c3..50d207c 100644
> > > > > > > > > > > --- a/samples/Kconfig
> > > > > > > > > > > +++ b/samples/Kconfig
> > > > > > > > > > > @@ -190,5 +190,15 @@ config SAMPLE_INTEL_MEI
> > > > > > > > > > >  	help
> > > > > > > > > > >  	  Build a sample program to work with mei device.
> > > > > > > > > > >
> > > > > > > > > > > +config SAMPLE_VFIO_MDEV_PCI
> > > > > > > > > > > +	tristate "Sample driver for wrapping PCI device as a mdev"
> > > > > > > > > > > +	select VFIO_PCI_COMMON
> > > > > > > > > > > +	select VFIO_PCI
> > > > > > > > > > > +	depends on VFIO_MDEV && VFIO_MDEV_DEVICE
> > > > > > > > > > > +	help
> > > > > > > > > > > +	  Sample driver for wrapping a PCI device as a mdev. Once    
> > > > > > bound to    
> > > > > > > > > > > +	  this driver, device passthru should through mdev path.
> > > > > > > > > > > +
> > > > > > > > > > > +	  If you don't know what to do here, say N.
> > > > > > > > > > >
> > > > > > > > > > >  endif # SAMPLES
> > > > > > > > > > > diff --git a/samples/Makefile b/samples/Makefile
> > > > > > > > > > > index 5ce50ef..84faced 100644
> > > > > > > > > > > --- a/samples/Makefile
> > > > > > > > > > > +++ b/samples/Makefile
> > > > > > > > > > > @@ -21,5 +21,6 @@ obj-$(CONFIG_SAMPLE_FTRACE_DIRECT)    
> > > > > > 	+= ftrace/    
> > > > > > > > > > >  obj-$(CONFIG_SAMPLE_TRACE_ARRAY)	+= ftrace/
> > > > > > > > > > >  obj-$(CONFIG_VIDEO_PCI_SKELETON)	+= v4l/
> > > > > > > > > > >  obj-y					+= vfio-mdev/
> > > > > > > > > > > +obj-y					+= vfio-mdev-pci/    
> > > > > > > > > >
> > > > > > > > > > I think we could just lump this into vfio-mdev rather than making
> > > > > > > > > > another directory.    
> > > > > > > > >
> > > > > > > > > sure. will move it. :-)
> > > > > > > > >    
> > > > > > > > > >    
> > > > > > > > > > >  subdir-$(CONFIG_SAMPLE_VFS)		+= vfs
> > > > > > > > > > >  obj-$(CONFIG_SAMPLE_INTEL_MEI)		+= mei/
> > > > > > > > > > > diff --git a/samples/vfio-mdev-pci/Makefile b/samples/vfio-mdev-    
> > > > > > pci/Makefile    
> > > > > > > > > > > new file mode 100644
> > > > > > > > > > > index 0000000..41b2139
> > > > > > > > > > > --- /dev/null
> > > > > > > > > > > +++ b/samples/vfio-mdev-pci/Makefile
> > > > > > > > > > > @@ -0,0 +1,4 @@
> > > > > > > > > > > +# SPDX-License-Identifier: GPL-2.0-only
> > > > > > > > > > > +vfio-mdev-pci-y := vfio_mdev_pci.o
> > > > > > > > > > > +
> > > > > > > > > > > +obj-$(CONFIG_SAMPLE_VFIO_MDEV_PCI) += vfio-mdev-pci.o
> > > > > > > > > > > diff --git a/samples/vfio-mdev-pci/vfio_mdev_pci.c b/samples/vfio-    
> > > > > > mdev-    
> > > > > > > > > > pci/vfio_mdev_pci.c    
> > > > > > > > > > > new file mode 100644
> > > > > > > > > > > index 0000000..b180356
> > > > > > > > > > > --- /dev/null
> > > > > > > > > > > +++ b/samples/vfio-mdev-pci/vfio_mdev_pci.c
> > > > > > > > > > > @@ -0,0 +1,397 @@
> > > > > > > > > > > +/*
> > > > > > > > > > > + * Copyright © 2020 Intel Corporation.
> > > > > > > > > > > + *     Author: Liu Yi L <yi.l.liu@intel.com>
> > > > > > > > > > > + *
> > > > > > > > > > > + * This program is free software; you can redistribute it and/or    
> > > > > > modify    
> > > > > > > > > > > + * it under the terms of the GNU General Public License version 2 as
> > > > > > > > > > > + * published by the Free Software Foundation.
> > > > > > > > > > > + *
> > > > > > > > > > > + * Derived from original vfio_pci.c:
> > > > > > > > > > > + * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
> > > > > > > > > > > + *     Author: Alex Williamson <alex.williamson@redhat.com>
> > > > > > > > > > > + *
> > > > > > > > > > > + * Derived from original vfio:
> > > > > > > > > > > + * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
> > > > > > > > > > > + * Author: Tom Lyon, pugs@cisco.com
> > > > > > > > > > > + */
> > > > > > > > > > > +
> > > > > > > > > > > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > > > > > > > > > > +
> > > > > > > > > > > +#include <linux/device.h>
> > > > > > > > > > > +#include <linux/eventfd.h>
> > > > > > > > > > > +#include <linux/file.h>
> > > > > > > > > > > +#include <linux/interrupt.h>
> > > > > > > > > > > +#include <linux/iommu.h>
> > > > > > > > > > > +#include <linux/module.h>
> > > > > > > > > > > +#include <linux/mutex.h>
> > > > > > > > > > > +#include <linux/notifier.h>
> > > > > > > > > > > +#include <linux/pci.h>
> > > > > > > > > > > +#include <linux/pm_runtime.h>
> > > > > > > > > > > +#include <linux/slab.h>
> > > > > > > > > > > +#include <linux/types.h>
> > > > > > > > > > > +#include <linux/uaccess.h>
> > > > > > > > > > > +#include <linux/vfio.h>
> > > > > > > > > > > +#include <linux/vgaarb.h>
> > > > > > > > > > > +#include <linux/nospec.h>
> > > > > > > > > > > +#include <linux/mdev.h>
> > > > > > > > > > > +#include <linux/vfio_pci_common.h>
> > > > > > > > > > > +
> > > > > > > > > > > +#define DRIVER_VERSION  "0.1"
> > > > > > > > > > > +#define DRIVER_AUTHOR   "Liu Yi L <yi.l.liu@intel.com>"
> > > > > > > > > > > +#define DRIVER_DESC     "VFIO Mdev PCI - Sample driver for PCI    
> > > > > > device as a    
> > > > > > > > > > mdev"    
> > > > > > > > > > > +
> > > > > > > > > > > +#define VFIO_MDEV_PCI_NAME  "vfio-mdev-pci"
> > > > > > > > > > > +
> > > > > > > > > > > +static char ids[1024] __initdata;
> > > > > > > > > > > +module_param_string(ids, ids, sizeof(ids), 0);
> > > > > > > > > > > +MODULE_PARM_DESC(ids, "Initial PCI IDs to add to the vfio-mdev-    
> > > > > > pci driver,    
> > > > > > > > > > format is    
> > > > > > \"vendor:device[:subvendor[:subdevice[:class[:class_mask]]]]\" and    
> > > > > > > > > > multiple comma separated entries can be specified");    
> > > > > > > > > > > +
> > > > > > > > > > > +static bool nointxmask;
> > > > > > > > > > > +module_param_named(nointxmask, nointxmask, bool, S_IRUGO |    
> > > > > > S_IWUSR);    
> > > > > > > > > > > +MODULE_PARM_DESC(nointxmask,
> > > > > > > > > > > +		  "Disable support for PCI 2.3 style INTx masking.  If    
> > > > > > this resolves    
> > > > > > > > > > problems for specific devices, report lspci -vvvxxx to linux-    
> > > > > > pci@vger.kernel.org    
> > > > > > > > so    
> > > > > > > > > > the device can be fixed automatically via the broken_intx_masking    
> > > > > > flag.");    
> > > > > > > > > > > +
> > > > > > > > > > > +#ifdef CONFIG_VFIO_PCI_VGA
> > > > > > > > > > > +static bool disable_vga;
> > > > > > > > > > > +module_param(disable_vga, bool, S_IRUGO);
> > > > > > > > > > > +MODULE_PARM_DESC(disable_vga, "Disable VGA resource access    
> > > > > > through    
> > > > > > > > vfio-    
> > > > > > > > > > mdev-pci");    
> > > > > > > > > > > +#endif
> > > > > > > > > > > +
> > > > > > > > > > > +static bool disable_idle_d3;
> > > > > > > > > > > +module_param(disable_idle_d3, bool, S_IRUGO | S_IWUSR);
> > > > > > > > > > > +MODULE_PARM_DESC(disable_idle_d3,
> > > > > > > > > > > +		 "Disable using the PCI D3 low power state for idle,    
> > > > > > unused devices");    
> > > > > > > > > > > +
> > > > > > > > > > > +static struct pci_driver vfio_mdev_pci_driver;
> > > > > > > > > > > +
> > > > > > > > > > > +static ssize_t
> > > > > > > > > > > +name_show(struct kobject *kobj, struct device *dev, char *buf)
> > > > > > > > > > > +{
> > > > > > > > > > > +	return sprintf(buf, "%s-type1\n", dev_name(dev));
> > > > > > > > > > > +}
> > > > > > > > > > > +
> > > > > > > > > > > +MDEV_TYPE_ATTR_RO(name);
> > > > > > > > > > > +
> > > > > > > > > > > +static ssize_t
> > > > > > > > > > > +available_instances_show(struct kobject *kobj, struct device *dev,    
> > > > > > char *buf)    
> > > > > > > > > > > +{
> > > > > > > > > > > +	return sprintf(buf, "%d\n", 1);
> > > > > > > > > > > +}
> > > > > > > > > > > +
> > > > > > > > > > > +MDEV_TYPE_ATTR_RO(available_instances);
> > > > > > > > > > > +
> > > > > > > > > > > +static ssize_t device_api_show(struct kobject *kobj, struct device    
> > > > > > *dev,    
> > > > > > > > > > > +		char *buf)
> > > > > > > > > > > +{
> > > > > > > > > > > +	return sprintf(buf, "%s\n", VFIO_DEVICE_API_PCI_STRING);
> > > > > > > > > > > +}
> > > > > > > > > > > +
> > > > > > > > > > > +MDEV_TYPE_ATTR_RO(device_api);
> > > > > > > > > > > +
> > > > > > > > > > > +static struct attribute *vfio_mdev_pci_types_attrs[] = {
> > > > > > > > > > > +	&mdev_type_attr_name.attr,
> > > > > > > > > > > +	&mdev_type_attr_device_api.attr,
> > > > > > > > > > > +	&mdev_type_attr_available_instances.attr,
> > > > > > > > > > > +	NULL,
> > > > > > > > > > > +};
> > > > > > > > > > > +
> > > > > > > > > > > +static struct attribute_group vfio_mdev_pci_type_group1 = {
> > > > > > > > > > > +	.name  = "type1",
> > > > > > > > > > > +	.attrs = vfio_mdev_pci_types_attrs,
> > > > > > > > > > > +};
> > > > > > > > > > > +
> > > > > > > > > > > +struct attribute_group *vfio_mdev_pci_type_groups[] = {
> > > > > > > > > > > +	&vfio_mdev_pci_type_group1,
> > > > > > > > > > > +	NULL,
> > > > > > > > > > > +};
> > > > > > > > > > > +
> > > > > > > > > > > +struct vfio_mdev_pci {
> > > > > > > > > > > +	struct vfio_pci_device *vdev;
> > > > > > > > > > > +	struct mdev_device *mdev;
> > > > > > > > > > > +	unsigned long handle;
> > > > > > > > > > > +};
> > > > > > > > > > > +
> > > > > > > > > > > +static int vfio_mdev_pci_create(struct kobject *kobj, struct    
> > > > > > mdev_device    
> > > > > > > > *mdev)    
> > > > > > > > > > > +{
> > > > > > > > > > > +	struct device *pdev;
> > > > > > > > > > > +	struct vfio_pci_device *vdev;
> > > > > > > > > > > +	struct vfio_mdev_pci *pmdev;
> > > > > > > > > > > +	int ret;
> > > > > > > > > > > +
> > > > > > > > > > > +	pdev = mdev_parent_dev(mdev);
> > > > > > > > > > > +	vdev = dev_get_drvdata(pdev);
> > > > > > > > > > > +	pmdev = kzalloc(sizeof(struct vfio_mdev_pci), GFP_KERNEL);
> > > > > > > > > > > +	if (pmdev == NULL) {
> > > > > > > > > > > +		ret = -EBUSY;
> > > > > > > > > > > +		goto out;
> > > > > > > > > > > +	}
> > > > > > > > > > > +
> > > > > > > > > > > +	pmdev->mdev = mdev;
> > > > > > > > > > > +	pmdev->vdev = vdev;
> > > > > > > > > > > +	mdev_set_drvdata(mdev, pmdev);
> > > > > > > > > > > +	ret = mdev_set_iommu_device(mdev_dev(mdev), pdev);
> > > > > > > > > > > +	if (ret) {
> > > > > > > > > > > +		pr_info("%s, failed to config iommu isolation for    
> > > > > > mdev: %s on    
> > > > > > > > > > pf: %s\n",    
> > > > > > > > > > > +			__func__, dev_name(mdev_dev(mdev)),    
> > > > > > dev_name(pdev));    
> > > > > > > > > > > +		goto out;
> > > > > > > > > > > +	}
> > > > > > > > > > > +
> > > > > > > > > > > +	pr_info("%s, creation succeeded for mdev: %s\n", __func__,
> > > > > > > > > > > +		     dev_name(mdev_dev(mdev)));
> > > > > > > > > > > +out:
> > > > > > > > > > > +	return ret;
> > > > > > > > > > > +}
> > > > > > > > > > > +
> > > > > > > > > > > +static int vfio_mdev_pci_remove(struct mdev_device *mdev)
> > > > > > > > > > > +{
> > > > > > > > > > > +	struct vfio_mdev_pci *pmdev = mdev_get_drvdata(mdev);
> > > > > > > > > > > +
> > > > > > > > > > > +	kfree(pmdev);
> > > > > > > > > > > +	pr_info("%s, succeeded for mdev: %s\n", __func__,
> > > > > > > > > > > +		     dev_name(mdev_dev(mdev)));
> > > > > > > > > > > +
> > > > > > > > > > > +	return 0;
> > > > > > > > > > > +}
> > > > > > > > > > > +
> > > > > > > > > > > +static int vfio_mdev_pci_open(struct mdev_device *mdev)
> > > > > > > > > > > +{
> > > > > > > > > > > +	struct vfio_mdev_pci *pmdev = mdev_get_drvdata(mdev);
> > > > > > > > > > > +	struct vfio_pci_device *vdev = pmdev->vdev;
> > > > > > > > > > > +	int ret = 0;
> > > > > > > > > > > +
> > > > > > > > > > > +	if (!try_module_get(THIS_MODULE))
> > > > > > > > > > > +		return -ENODEV;
> > > > > > > > > > > +
> > > > > > > > > > > +	vfio_pci_refresh_config(vdev, nointxmask, disable_idle_d3);
> > > > > > > > > > > +
> > > > > > > > > > > +	mutex_lock(&vdev->reflck->lock);
> > > > > > > > > > > +
> > > > > > > > > > > +	if (!vdev->refcnt) {
> > > > > > > > > > > +		ret = vfio_pci_enable(vdev);
> > > > > > > > > > > +		if (ret)
> > > > > > > > > > > +			goto error;
> > > > > > > > > > > +
> > > > > > > > > > > +		vfio_spapr_pci_eeh_open(vdev->pdev);
> > > > > > > > > > > +	}
> > > > > > > > > > > +	vdev->refcnt++;
> > > > > > > > > > > +error:
> > > > > > > > > > > +	mutex_unlock(&vdev->reflck->lock);
> > > > > > > > > > > +	if (!ret)
> > > > > > > > > > > +		pr_info("Succeeded to open mdev: %s on pf: %s\n",
> > > > > > > > > > > +		dev_name(mdev_dev(mdev)), dev_name(&pmdev-    
> > > > > > >vdev->pdev-    
> > > > > > > > > > >dev));
> > > > > > > > > > > +	else {
> > > > > > > > > > > +		pr_info("Failed to open mdev: %s on pf: %s\n",
> > > > > > > > > > > +		dev_name(mdev_dev(mdev)), dev_name(&pmdev-    
> > > > > > >vdev->pdev-    
> > > > > > > > > > >dev));
> > > > > > > > > > > +		module_put(THIS_MODULE);
> > > > > > > > > > > +	}
> > > > > > > > > > > +	return ret;
> > > > > > > > > > > +}
> > > > > > > > > > > +
> > > > > > > > > > > +static void vfio_mdev_pci_release(struct mdev_device *mdev)
> > > > > > > > > > > +{
> > > > > > > > > > > +	struct vfio_mdev_pci *pmdev = mdev_get_drvdata(mdev);
> > > > > > > > > > > +	struct vfio_pci_device *vdev = pmdev->vdev;
> > > > > > > > > > > +
> > > > > > > > > > > +	pr_info("Release mdev: %s on pf: %s\n",
> > > > > > > > > > > +		dev_name(mdev_dev(mdev)), dev_name(&pmdev-    
> > > > > > >vdev->pdev-    
> > > > > > > > > > >dev));
> > > > > > > > > > > +
> > > > > > > > > > > +	mutex_lock(&vdev->reflck->lock);
> > > > > > > > > > > +
> > > > > > > > > > > +	if (!(--vdev->refcnt)) {
> > > > > > > > > > > +		vfio_spapr_pci_eeh_release(vdev->pdev);
> > > > > > > > > > > +		vfio_pci_disable(vdev);
> > > > > > > > > > > +	}
> > > > > > > > > > > +
> > > > > > > > > > > +	mutex_unlock(&vdev->reflck->lock);
> > > > > > > > > > > +
> > > > > > > > > > > +	module_put(THIS_MODULE);
> > > > > > > > > > > +}    
> > > > > > > > > >
> > > > > > > > > > open() and release() here are almost identical between vfio_pci and
> > > > > > > > > > vfio_mdev_pci, which suggests maybe there should be common    
> > > > > > functions to    
> > > > > > > > > > call into like we do for the below.    
> > > > > > > > >
> > > > > > > > > yes, let me have more study and do better abstract in next version. :-)
> > > > > > > > >    
> > > > > > > > > > > +static long vfio_mdev_pci_ioctl(struct mdev_device *mdev,    
> > > > > > unsigned int cmd,    
> > > > > > > > > > > +			     unsigned long arg)
> > > > > > > > > > > +{
> > > > > > > > > > > +	struct vfio_mdev_pci *pmdev = mdev_get_drvdata(mdev);
> > > > > > > > > > > +
> > > > > > > > > > > +	return vfio_pci_ioctl(pmdev->vdev, cmd, arg);
> > > > > > > > > > > +}
> > > > > > > > > > > +
> > > > > > > > > > > +static int vfio_mdev_pci_mmap(struct mdev_device *mdev,
> > > > > > > > > > > +				struct vm_area_struct *vma)
> > > > > > > > > > > +{
> > > > > > > > > > > +	struct vfio_mdev_pci *pmdev = mdev_get_drvdata(mdev);
> > > > > > > > > > > +
> > > > > > > > > > > +	return vfio_pci_mmap(pmdev->vdev, vma);
> > > > > > > > > > > +}
> > > > > > > > > > > +
> > > > > > > > > > > +static ssize_t vfio_mdev_pci_read(struct mdev_device *mdev, char    
> > > > > > __user    
> > > > > > > > *buf,    
> > > > > > > > > > > +			size_t count, loff_t *ppos)
> > > > > > > > > > > +{
> > > > > > > > > > > +	struct vfio_mdev_pci *pmdev = mdev_get_drvdata(mdev);
> > > > > > > > > > > +
> > > > > > > > > > > +	return vfio_pci_read(pmdev->vdev, buf, count, ppos);
> > > > > > > > > > > +}
> > > > > > > > > > > +
> > > > > > > > > > > +static ssize_t vfio_mdev_pci_write(struct mdev_device *mdev,
> > > > > > > > > > > +				const char __user *buf,
> > > > > > > > > > > +				size_t count, loff_t *ppos)
> > > > > > > > > > > +{
> > > > > > > > > > > +	struct vfio_mdev_pci *pmdev = mdev_get_drvdata(mdev);
> > > > > > > > > > > +
> > > > > > > > > > > +	return vfio_pci_write(pmdev->vdev, (char __user *)buf,    
> > > > > > count, ppos);    
> > > > > > > > > > > +}
> > > > > > > > > > > +
> > > > > > > > > > > +static const struct mdev_parent_ops vfio_mdev_pci_ops = {
> > > > > > > > > > > +	.supported_type_groups	=    
> > > > > > vfio_mdev_pci_type_groups,    
> > > > > > > > > > > +	.create			= vfio_mdev_pci_create,
> > > > > > > > > > > +	.remove			= vfio_mdev_pci_remove,
> > > > > > > > > > > +
> > > > > > > > > > > +	.open			= vfio_mdev_pci_open,
> > > > > > > > > > > +	.release		= vfio_mdev_pci_release,
> > > > > > > > > > > +
> > > > > > > > > > > +	.read			= vfio_mdev_pci_read,
> > > > > > > > > > > +	.write			= vfio_mdev_pci_write,
> > > > > > > > > > > +	.mmap			= vfio_mdev_pci_mmap,
> > > > > > > > > > > +	.ioctl			= vfio_mdev_pci_ioctl,
> > > > > > > > > > > +};
> > > > > > > > > > > +
> > > > > > > > > > > +static int vfio_mdev_pci_driver_probe(struct pci_dev *pdev,
> > > > > > > > > > > +				       const struct pci_device_id *id)
> > > > > > > > > > > +{
> > > > > > > > > > > +	struct vfio_pci_device *vdev;
> > > > > > > > > > > +	int ret;
> > > > > > > > > > > +
> > > > > > > > > > > +	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
> > > > > > > > > > > +		return -EINVAL;
> > > > > > > > > > > +
> > > > > > > > > > > +	/*
> > > > > > > > > > > +	 * Prevent binding to PFs with VFs enabled, this too easily    
> > > > > > allows    
> > > > > > > > > > > +	 * userspace instance with VFs and PFs from the same device,    
> > > > > > which    
> > > > > > > > > > > +	 * cannot work.  Disabling SR-IOV here would initiate    
> > > > > > removing the    
> > > > > > > > > > > +	 * VFs, which would unbind the driver, which is prone to    
> > > > > > blocking    
> > > > > > > > > > > +	 * if that VF is also in use by vfio-pci or vfio-mdev-pci. Just
> > > > > > > > > > > +	 * reject these PFs and let the user sort it out.
> > > > > > > > > > > +	 */
> > > > > > > > > > > +	if (pci_num_vf(pdev)) {
> > > > > > > > > > > +		pci_warn(pdev, "Cannot bind to PF with SR-IOV    
> > > > > > enabled\n");    
> > > > > > > > > > > +		return -EBUSY;
> > > > > > > > > > > +	}
> > > > > > > > > > > +
> > > > > > > > > > > +	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
> > > > > > > > > > > +	if (!vdev)
> > > > > > > > > > > +		return -ENOMEM;
> > > > > > > > > > > +
> > > > > > > > > > > +	vdev->pdev = pdev;
> > > > > > > > > > > +	vdev->irq_type = VFIO_PCI_NUM_IRQS;
> > > > > > > > > > > +	mutex_init(&vdev->igate);
> > > > > > > > > > > +	spin_lock_init(&vdev->irqlock);
> > > > > > > > > > > +	mutex_init(&vdev->ioeventfds_lock);
> > > > > > > > > > > +	INIT_LIST_HEAD(&vdev->ioeventfds_list);
> > > > > > > > > > > +	vdev->nointxmask = nointxmask;
> > > > > > > > > > > +#ifdef CONFIG_VFIO_PCI_VGA
> > > > > > > > > > > +	vdev->disable_vga = disable_vga;
> > > > > > > > > > > +#endif
> > > > > > > > > > > +	vdev->disable_idle_d3 = disable_idle_d3;
> > > > > > > > > > > +
> > > > > > > > > > > +	pci_set_drvdata(pdev, vdev);
> > > > > > > > > > > +
> > > > > > > > > > > +	ret = vfio_pci_reflck_attach(vdev);
> > > > > > > > > > > +	if (ret) {
> > > > > > > > > > > +		pci_set_drvdata(pdev, NULL);
> > > > > > > > > > > +		kfree(vdev);
> > > > > > > > > > > +		return ret;
> > > > > > > > > > > +	}
> > > > > > > > > > > +
> > > > > > > > > > > +	if (vfio_pci_is_vga(pdev)) {
> > > > > > > > > > > +		vga_client_register(pdev, vdev, NULL,    
> > > > > > vfio_pci_set_vga_decode);    
> > > > > > > > > > > +		vga_set_legacy_decoding(pdev,
> > > > > > > > > > > +    
> > > > > > 	vfio_pci_set_vga_decode(vdev, false));    
> > > > > > > > > > > +	}
> > > > > > > > > > > +
> > > > > > > > > > > +	vfio_pci_probe_power_state(vdev);
> > > > > > > > > > > +
> > > > > > > > > > > +	if (!vdev->disable_idle_d3) {
> > > > > > > > > > > +		/*
> > > > > > > > > > > +		 * pci-core sets the device power state to an    
> > > > > > unknown value at    
> > > > > > > > > > > +		 * bootup and after being removed from a driver.    
> > > > > > The only    
> > > > > > > > > > > +		 * transition it allows from this unknown state is to    
> > > > > > D0, which    
> > > > > > > > > > > +		 * typically happens when a driver calls    
> > > > > > pci_enable_device().    
> > > > > > > > > > > +		 * We're not ready to enable the device yet, but we    
> > > > > > do want to    
> > > > > > > > > > > +		 * be able to get to D3.  Therefore first do a D0    
> > > > > > transition    
> > > > > > > > > > > +		 * before going to D3.
> > > > > > > > > > > +		 */
> > > > > > > > > > > +		vfio_pci_set_power_state(vdev, PCI_D0);
> > > > > > > > > > > +		vfio_pci_set_power_state(vdev, PCI_D3hot);
> > > > > > > > > > > +	}    
> > > > > > > > > >
> > > > > > > > > > Ditto here and remove below, this seems like boilerplate that    
> > > > > > shouldn't    
> > > > > > > > > > be duplicated per leaf module.  Thanks,    
> > > > > > > > >
> > > > > > > > > Sure, the code snippet above may also be abstracted to be a common    
> > > > > > API    
> > > > > > > > > provided by vfio-pci-common.ko. :-)
> > > > > > > > >
> > > > > > > > > I have a confusion which may need confirm with you. Do you also want    
> > > > > > the    
> > > > > > > > > below code snippet be placed in the vfio-pci-common.ko and exposed    
> > > > > > out    
> > > > > > > > > as a wrapped API? Thus it can be used by sample driver and other    
> > > > > > future    
> > > > > > > > > drivers which want to wrap PCI device as a mdev. May be I    
> > > > > > misundstood    
> > > > > > > > > your comment. :-(    
> > > > > > > >
> > > > > > > >
> > > > > > > > I think some sort of vfio_pci_common_{probe,remove}() would be a
> > > > > > > > reasonable starting point where the respective module _{probe,remove}
> > > > > > > > functions would call into these and add their module specific code
> > > > > > > > around it.  That would at least give us a point to cleanup things that
> > > > > > > > are only used by the common code in the common code.    
> > > > > > >
> > > > > > > sure, I can start from here if we are still going with this direction. :-)
> > > > > > >    
> > > > > > > > I'm still struggling how we make this user consumable should we accept
> > > > > > > > this and progress beyond a proof of concept sample driver though.  For
> > > > > > > > example, if a vendor actually implements an mdev wrapper driver or    
> > > > > > even    
> > > > > > > > just a device specific vfio-pci wrapper, to enable for example
> > > > > > > > migration support, how does a user know which driver to use for each
> > > > > > > > particular feature?  The best I can come up with so far is something
> > > > > > > > like was done for vfio-platform reset modules.  For instance a module
> > > > > > > > that extends features for a given device in vfio-pci might register an
> > > > > > > > ops structure and id table with vfio-pci, along with creating a module
> > > > > > > > alias (or aliases) for the devices it supports.  When a device is
> > > > > > > > probed by vfio-pci it could try to match against registered id tables
> > > > > > > > to find a device specific ops structure, if one is not found it could
> > > > > > > > do a request_module using the PCI vendor and device IDs and some    
> > > > > > unique    
> > > > > > > > vfio-pci string, check again, and use the default ops if device
> > > > > > > > specific ops are still not present.  That would solve the problem on
> > > > > > > > the vfio-pci side.    
> > > > > > >
> > > > > > > yeah, this is letting vfio-pci to invoke the ops from vendor drivers/modules.
> > > > > > > I think this is what Yan is trying to do.    
> > > > > > 
> > > > > > I think I'm suggesting a callback ops structure a level above what Yan
> > > > > > previously proposed.  For example, could we have device specific
> > > > > > vfio_device_ops where the vendor module can call out to common code
> > > > > > rather than requiring common code to test for and optionally call out
> > > > > > to device specific code.
> > > > > >     
> > > > > > > > For mdevs, I tend to assume that this vfio-mdev-pci
> > > > > > > > meta driver is an anomaly only for the purpose of creating a generic
> > > > > > > > test device for IOMMU backed mdevs and that "real" mdev vendor
> > > > > > > > drivers will just be mdev enlightened host drivers, like i915 and
> > > > > > > > nvidia are now.  Thanks,    
> > > > > > >
> > > > > > > yes, this vfio-mdev-pci meta driver is just creating a test device.
> > > > > > > Do we still go with the current direction, or find any other way
> > > > > > > which may be easier for adding this meta driver?    
> > > > > > 
> > > > > > I think if the code split allows us to create an environment where
> > > > > > vendor drivers can re-use much of vfio-pci while creating a
> > > > > > vfio_device_ops that supports additional features for their device and
> > > > > > we bring that all together with a request module interface and module
> > > > > > aliases to make that work seamlessly, then it has value.  A concern I
> > > > > > have in only doing this split in order to create the vfio-mdev-pci
> > > > > > module is that it leaves open the question and groundwork for forking
> > > > > > vfio-pci into multiple vendor specific modules that would become a mess
> > > > > > for user's to mange.
> > > > > >     
> > > > > > > Compared with the "real" mdev vendor drivers, it is like a
> > > > > > > "vfio-pci + dummy mdev ops" driver. dummy mdev ops means
> > > > > > > no vendor specific handling and passthru to vfio-pci codes directly.
> > > > > > >
> > > > > > > I think this meta driver is even lighter than the "real" mdev vendor
> > > > > > > drivers. right? Is it possible to let this driver follow the way of
> > > > > > > registering ops structure and id table with vfio-pci? The obstacle
> > > > > > > I can see is the meta driver is a generic driver, which means it has
> > > > > > > no id table... For the "real" mdev vendor drivers, they naturally have
> > > > > > > such info. If vfio-mdev-pci can also get the id info without binding
> > > > > > > to a device, it may be possible. thoughts? :-)    
> > > > > > 
> > > > > > IDs could be provided via a module option or potentially with
> > > > > > build-time options.  That might allow us to test all aspects of the
> > > > > > above proposal, ie. allowing sub-modules to provide vfio_device_ops for
> > > > > > specific devices, allowing those vendor vfio_device_ops to re-use much
> > > > > > of the existing vfio-pci code in that implementation, and a mechanism
> > > > > > for generically testing IOMMU backed mdevs.  That's starting to sound a
> > > > > > lot more worthwhile than moving a bunch of code around only to
> > > > > > implement a sample driver for the latter.  Thoughts?  Thanks,
> > > > > >     
> > > > > 
> > > > > sounds a good idea. If feasible suppose Yan's mediate_ops series
> > > > > can be also largely avoided. The vendor driver can directly register its
> > > > > own vfio_device_ops and selectively introduces proprietary logic 
> > > > > (e.g. for tracking dirty pages) on top of the generic vfio_pci code.    
> > > > 
> > > > hi Alex
> > > > as our previously discussed, I'm preparing to implement my v2 as this
> > > > way:
> > > > 
> > > > 1. on vfio-pci binding to a device, it will modprobe modules of alias
> > > > "vfio-pci-(vendorid)-(deviceid)", as a way to notify vendor drivers of
> > > > registering their vendor ops. (I renamed mediate_ops to vendor_ops in
> > > > v2)
> > > > 2. in a module aliasing to "vfio-pci-(vendor_id)-(devivce_id)", in its
> > > > module_init, it will register a vendor ops to vfio-pci.
> > > > If there are two modules of the same alias and both registering vendor
> > > > ops at the same time, they are chained according to the prio in
> > > > its vendor ops.
> > > > 3. vfio-pci would ask for region_infos for all vendor ops of a vdev in
> > > > vfio_pci_open, and init regions for vendor drivers. Current code in
> > > > vfio_pci_igd.c, vfio_pci_nvlink2.c, vfio_pci_nvlink2.c would all be
> > > > wrapped into separate modules. so current vfio_pci_register_dev_region()
> > > > would be removed accordingly. vfio_pci_rw would now be direct to 
> > > > vendor_ops->region[i].rw. higher priority module's ops wins.
> > > > For example, module vfio_pci_igd may register to regions of index 10,
> > > > 11, 12 for its opregion, and two cfg regions. still, vendor driver can
> > > > provide a module named i915_migration to register for regions of index 0
> > > > and 13 for BAR0 and migration.  
> > > 
> > > My major complaint with the previous version was that sprinkling random
> > > vendor ops call-outs everywhere in vfio-pci is ugly and hard to
> > > maintain.  The idea I'm proposing here is that sub-modules (loaded via
> > > alias) would provide the entire vfio_device_ops for a device.  Yi's
> > > series here would split out common code to make it trivial for vendor
> > > modules to implement those device ops using pieces of vfio-pci if they
> > > wish to do so.  Having multiple modules implement features of a device
> > > based on their loading priority sounds powerful, but also difficult to
> > > maintain and debug.  Do we need that functionality if a vendor
> > > vfio_device_ops can implement it themselves in a handful of lines of
> > > code?  Thanks,  
> > 
> > The main purpose of providing multiple modules is to enable each module
> > to focus on implementing regions of their own interest. If vendor module
> > has to provide vfio_device_ops, I don't think it's only a handful of
> > lines of code for them.
> > For example. in vfio_device_ops.open(), they at least have to hold the
> > &vdev->reflck->lock and call vfio_pci_enable and
> > vfio_spapr_pci_eeh_open. Also, vdev is private inside vfio_pci, do we
> > really want to export this structure?
> > The same to vfio_device_ops.ioctl(). if vendor driver has to implement a
> > little different than vfio_pci_ioctl(), e.g. init a new region, it has
> > to decode region index and knows inside vdev->region[i].
> > when it comes to vfio_device_ops.remove(), in Yi's code, it even has to
> > free each lock and region... in vdev.
> 
> You make some good points, replacing vfio_device_ops altogether per
> vendor module might be too simplistic.  However, we also can't create a
> special case for vendor module handling on every interface.  For
> example, why would vfio_pci_rw() test for and call out to
> mediate_ops->rw() when we've already got per region rw() handlers via
> vfio_pci_regops?  Seems we need to make use of vfio_pci_regops
> ubiquitous for all regions and create an API for a vendor module to
> register new regions with ops (ie. expose vfio_pci_register_dev_region)
> and also manipulate the ops of existing regions.  When a vendor module
> registers, it might just need to provide an open function callback and
> an id table, and perhaps everything else is handled via registering new
> regions and dynamically changing existing regions when we call the open
> callback for a device.  Something about that series needs to change, I
> can't handle the proposed mediated device ops being tested and called
> everywhere.
>  
> > Besides that, one thing I don't understand is that, Yi's sample code is
> > a mdev driver, so rather than binding to vfio-pci, a pci device would
> > bind to Yi's driver directly. Then, how this registering to vfio-pci way
> > work for him?
> 
> It wouldn't, I was trying to justify the code rework that Yi is trying
> to do as also usable to these vfio-pci vendor extension modules.  You
> may have poked a hole in that proposal though, which again puts in
> doubt whether we should really pursue it for a sample driver.  Thanks,
>

hi Alex
I've sent v2 of introducing vendor_ops to vfio-pci.
(https://lkml.org/lkml/2020/1/30/956)
By making vfio_pci_device partly public and incorporating vendor driver
data, it is now able to let vendor driver register their own
vfio_device_ops and calling vfio_pci_ops as default implementations.

Making use of vfio_pci_regops ubiquitous for all regions and create an API
for a vendor module to register new regions with ops is also a good idea,
but its drawback is that the usage is only limited to region customization.
I'd like to send my current v2 implementation to you first and see if you
think it's good.

Thanks
Yan

