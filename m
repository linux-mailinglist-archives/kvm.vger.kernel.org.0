Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA7A213DB9E
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 14:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729208AbgAPNXd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 16 Jan 2020 08:23:33 -0500
Received: from mga17.intel.com ([192.55.52.151]:28647 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgAPNXd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 08:23:33 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jan 2020 05:23:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,326,1574150400"; 
   d="scan'208";a="273984161"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Jan 2020 05:23:32 -0800
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 16 Jan 2020 05:23:32 -0800
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 16 Jan 2020 05:23:32 -0800
Received: from shsmsx151.ccr.corp.intel.com (10.239.6.50) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 16 Jan 2020 05:23:32 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.197]) by
 SHSMSX151.ccr.corp.intel.com ([169.254.3.55]) with mapi id 14.03.0439.000;
 Thu, 16 Jan 2020 21:23:29 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: RE: [PATCH v4 11/12] samples: add vfio-mdev-pci driver
Thread-Topic: [PATCH v4 11/12] samples: add vfio-mdev-pci driver
Thread-Index: AQHVxVUACBwDAx59j0yR27cHCInk46frLluAgAIeFUA=
Date:   Thu, 16 Jan 2020 13:23:28 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A184041@SHSMSX104.ccr.corp.intel.com>
References: <1578398509-26453-1-git-send-email-yi.l.liu@intel.com>
        <1578398509-26453-12-git-send-email-yi.l.liu@intel.com>
 <20200115133027.228452fd.cohuck@redhat.com>
In-Reply-To: <20200115133027.228452fd.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNWZmMTIwOTctMjY5My00ZGM3LThhOGEtYmMxYTNkZDA5NzM4IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiT2tpR1dWU2RxaXBpNzI5QUlySzB2QU1UQlphS21cL2luSU5wXC9DeCtHSytMZnIxM1wvRTBhMjB0YnhuZ2lURmtMZSJ9
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Cornelia Huck [mailto:cohuck@redhat.com]
> Sent: Wednesday, January 15, 2020 8:30 PM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [PATCH v4 11/12] samples: add vfio-mdev-pci driver
> 
> On Tue,  7 Jan 2020 20:01:48 +0800
> Liu Yi L <yi.l.liu@intel.com> wrote:
> 
> > This patch adds sample driver named vfio-mdev-pci. It is to wrap
> > a PCI device as a mediated device. For a pci device, once bound
> > to vfio-mdev-pci driver, user space access of this device will
> > go through vfio mdev framework. The usage of the device follows
> > mdev management method. e.g. user should create a mdev before
> > exposing the device to user-space.
> >
> > Benefit of this new driver would be acting as a sample driver
> > for recent changes from "vfio/mdev: IOMMU aware mediated device"
> > patchset. Also it could be a good experiment driver for future
> > device specific mdev migration support. This sample driver only
> > supports singleton iommu groups, for non-singleton iommu groups,
> > this sample driver doesn't work. It will fail when trying to assign
> > the non-singleton iommu group to VMs.
> >
> > To use this driver:
> > a) build and load vfio-mdev-pci.ko module
> >    execute "make menuconfig" and config CONFIG_SAMPLE_VFIO_MDEV_PCI
> >    then load it with following command:
> >    > sudo modprobe vfio
> >    > sudo modprobe vfio-pci
> >    > sudo insmod samples/vfio-mdev-pci/vfio-mdev-pci.ko
> >
> > b) unbind original device driver
> >    e.g. use following command to unbind its original driver
> >    > echo $dev_bdf > /sys/bus/pci/devices/$dev_bdf/driver/unbind
> >
> > c) bind vfio-mdev-pci driver to the physical device
> >    > echo $vend_id $dev_id > /sys/bus/pci/drivers/vfio-mdev-pci/new_id
> >
> > d) check the supported mdev instances
> >    > ls /sys/bus/pci/devices/$dev_bdf/mdev_supported_types/
> >      vfio-mdev-pci-type_name
> >    > ls /sys/bus/pci/devices/$dev_bdf/mdev_supported_types/\
> >      vfio-mdev-pci-type_name/
> >      available_instances  create  device_api  devices  name
> >
> > e)  create mdev on this physical device (only 1 instance)
> >    > echo "83b8f4f2-509f-382f-3c1e-e6bfe0fa1003" > \
> >      /sys/bus/pci/devices/$dev_bdf/mdev_supported_types/\
> >      vfio-mdev-pci-type_name/create
> >
> > f) passthru the mdev to guest
> >    add the following line in QEMU boot command
> >     -device vfio-pci,\
> >      sysfsdev=/sys/bus/mdev/devices/83b8f4f2-509f-382f-3c1e-e6bfe0fa1003
> >
> > g) destroy mdev
> >    > echo 1 > /sys/bus/mdev/devices/83b8f4f2-509f-382f-3c1e-e6bfe0fa1003/\
> >      remove
> 
> I think much/most of those instructions should go (additionally) into
> the sample driver source.

yes, it would be helpful to add it in a doc.

> Otherwise, it's not clear to the reader why
> they should wrap the device in mdev instead of simply using a normal
> vfio-pci device.

Actually, the reason of wrapping device in mdev instead of simply using
a normal vfio-pci is to let vendor specific driver to intercept some
device access which is not allowed in vfio-pci usage. We only have PCI
config space access intercepted and some other special accesses intercepted
in vfio-pci. While for some vendor specific handling, it would be nice
to have a way to let vendor specific driver intercept in. mdev allows it.

And back to the purpose of introducing this sample driver, it is supposed
to test IOMMU-capable mdev. We don't have real hardware on market, there
is no way to test the VFIO extensions for IOMMU-capable mdev. Wrapping a
PCI device in mdev can test the VFIO extensions well as it has hardware
enforce DMA isolation. Thus makes it possible to test the extensions in VFIO.

> 
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> > Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> >  samples/Kconfig                       |  10 +
> >  samples/Makefile                      |   1 +
> >  samples/vfio-mdev-pci/Makefile        |   4 +
> >  samples/vfio-mdev-pci/vfio_mdev_pci.c | 397
> ++++++++++++++++++++++++++++++++++
> >  4 files changed, 412 insertions(+)
> >  create mode 100644 samples/vfio-mdev-pci/Makefile
> >  create mode 100644 samples/vfio-mdev-pci/vfio_mdev_pci.c
> >
> > diff --git a/samples/Kconfig b/samples/Kconfig
> > index 9d236c3..50d207c 100644
> > --- a/samples/Kconfig
> > +++ b/samples/Kconfig
> > @@ -190,5 +190,15 @@ config SAMPLE_INTEL_MEI
> >  	help
> >  	  Build a sample program to work with mei device.
> >
> > +config SAMPLE_VFIO_MDEV_PCI
> > +	tristate "Sample driver for wrapping PCI device as a mdev"
> > +	select VFIO_PCI_COMMON
> > +	select VFIO_PCI
> 
> Why does this still need to select VFIO_PCI? Shouldn't all needed
> infrastructure rather be covered by VFIO_PCI_COMMON already?

VFIO_PCI_COMMON is supposed to be the dependency of both VFIO_PCI and
SAMPLE_VFIO_MDEV_PCI. However, the source code of VFIO_PCI_COMMON are
under drivers/vfio/pci which is compiled per the configuration of VFIO_PCI.
Besides of letting SAMPLE_VFIO_MDEV_PCI select VFIO_PCI, I can also add
a line in drivers/vfio/Makefile to make the source code under drivers/vfio/pci
to be compiled when either VFIO_PCI or VFIO_PCI_COMMON are configed. But
I'm afraid it is a bit ugly. So I choose to let SAMPLE_VFIO_MDEV_PCI select
VFIO_PCI. If you have other idea, I would be pleased to
know it. :-)

> 
> > +	depends on VFIO_MDEV && VFIO_MDEV_DEVICE
> 
> VFIO_MDEV_DEVICE already depends on VFIO_MDEV. But maybe also make this
> depend on PCI?
> 
> > +	help
> > +	  Sample driver for wrapping a PCI device as a mdev. Once bound to
> > +	  this driver, device passthru should through mdev path.
> 
> "A PCI device bound to this driver will be assigned through the
> mediated device framework."
> 
> ?

Maybe I should have mentioned it as "A PCI device bound to this
sample driver should follow the passthru steps for mdevs as showed
in Documentation/driver-api/vfio-mediated-device.rst."

Does it make more sense?

Thanks,
Yi Liu

> 
> > +
> > +	  If you don't know what to do here, say N.
> >
> >  endif # SAMPLES

