Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 388AB142638
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 09:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgATIzS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 03:55:18 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58002 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726130AbgATIzR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Jan 2020 03:55:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579510516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fI1fVeRIsOBuPL3W4q06PtSWODULRySXWyy020h2K1k=;
        b=M0m7vaNmHu41XUDY7/QG5kUUZoaX9dDYpYJzeW2mA97SQRsvDU8SfGPN4ScxF7EdzzgW6U
        fuOOYtga97bzlKNvO9HDj/olkLA9qrhcbVPEclbf+CjVoc5VYXxDX5yxV2OcEUgDvd5mRA
        ydyYDaOnJDXeGAaawylX3sW0V/6SQ4s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-LBseXebTN2qYkvWetKJbug-1; Mon, 20 Jan 2020 03:55:15 -0500
X-MC-Unique: LBseXebTN2qYkvWetKJbug-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96CA061264;
        Mon, 20 Jan 2020 08:55:13 +0000 (UTC)
Received: from gondolin (ovpn-205-161.brq.redhat.com [10.40.205.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A17D65C21A;
        Mon, 20 Jan 2020 08:55:03 +0000 (UTC)
Date:   Mon, 20 Jan 2020 09:55:00 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH v4 11/12] samples: add vfio-mdev-pci driver
Message-ID: <20200120095500.1659a4ea.cohuck@redhat.com>
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A18878E@SHSMSX104.ccr.corp.intel.com>
References: <1578398509-26453-1-git-send-email-yi.l.liu@intel.com>
        <1578398509-26453-12-git-send-email-yi.l.liu@intel.com>
        <20200115133027.228452fd.cohuck@redhat.com>
        <A2975661238FB949B60364EF0F2C25743A184041@SHSMSX104.ccr.corp.intel.com>
        <20200116184027.2954c3f5.cohuck@redhat.com>
        <A2975661238FB949B60364EF0F2C25743A18878E@SHSMSX104.ccr.corp.intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 18 Jan 2020 14:23:45 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Cornelia Huck [mailto:cohuck@redhat.com]
> > Sent: Friday, January 17, 2020 1:40 AM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [PATCH v4 11/12] samples: add vfio-mdev-pci driver
> > 
> > On Thu, 16 Jan 2020 13:23:28 +0000
> > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> >   
> > > > From: Cornelia Huck [mailto:cohuck@redhat.com]
> > > > Sent: Wednesday, January 15, 2020 8:30 PM
> > > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > > Subject: Re: [PATCH v4 11/12] samples: add vfio-mdev-pci driver
> > > >
> > > > On Tue,  7 Jan 2020 20:01:48 +0800
> > > > Liu Yi L <yi.l.liu@intel.com> wrote:  
> >   
> > > > > diff --git a/samples/Kconfig b/samples/Kconfig index
> > > > > 9d236c3..50d207c 100644
> > > > > --- a/samples/Kconfig
> > > > > +++ b/samples/Kconfig
> > > > > @@ -190,5 +190,15 @@ config SAMPLE_INTEL_MEI
> > > > >  	help
> > > > >  	  Build a sample program to work with mei device.
> > > > >
> > > > > +config SAMPLE_VFIO_MDEV_PCI
> > > > > +	tristate "Sample driver for wrapping PCI device as a mdev"
> > > > > +	select VFIO_PCI_COMMON
> > > > > +	select VFIO_PCI  
> > > >
> > > > Why does this still need to select VFIO_PCI? Shouldn't all needed
> > > > infrastructure rather be covered by VFIO_PCI_COMMON already?  
> > >
> > > VFIO_PCI_COMMON is supposed to be the dependency of both VFIO_PCI and
> > > SAMPLE_VFIO_MDEV_PCI. However, the source code of VFIO_PCI_COMMON are
> > > under drivers/vfio/pci which is compiled per the configuration of VFIO_PCI.
> > > Besides of letting SAMPLE_VFIO_MDEV_PCI select VFIO_PCI, I can also
> > > add a line in drivers/vfio/Makefile to make the source code under
> > > drivers/vfio/pci to be compiled when either VFIO_PCI or
> > > VFIO_PCI_COMMON are configed. But I'm afraid it is a bit ugly. So I
> > > choose to let SAMPLE_VFIO_MDEV_PCI select VFIO_PCI. If you have other
> > > idea, I would be pleased to know it. :-)  
> > 
> > Shouldn't building drivers/vfio/pci/ for CONFIG_VFIO_PCI_COMMON already be
> > enough (the Makefile changes look fine to me)? Or am I missing something obvious?  
> 
> The problem is in the drivers/vfio/Makefile. If CONFIG_VFIO_PCI is not
> selected then the pci/ directory is not compiled. Even CONFIG_VFIO_PCI=M,
> it will throw error if SAMPLE_VFIO_MDEV_PCI=y. So I let SAMPLE_VFIO_MDEV_PCI
> select CONFIG_VFIO_PCI all the same. I'm not sure if this is good. Or maybe
> there is better way to ensure pci/ is compiled.
> 
> # SPDX-License-Identifier: GPL-2.0
> vfio_virqfd-y := virqfd.o
> 
> obj-$(CONFIG_VFIO) += vfio.o
> obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
> obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
> obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
> obj-$(CONFIG_VFIO_SPAPR_EEH) += vfio_spapr_eeh.o
> obj-$(CONFIG_VFIO_PCI) += pci/

That's actually what I meant: s/CONFIG_VFIO_PCI/CONFIG_VFIO_PCI_COMMON/ here.

> obj-$(CONFIG_VFIO_PLATFORM) += platform/
> obj-$(CONFIG_VFIO_MDEV) += mdev/
> 
> Thanks,
> Yi Liu
> 

