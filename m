Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24A1613E9E3
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 18:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393667AbgAPRkn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 12:40:43 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49489 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405569AbgAPRkm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Jan 2020 12:40:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579196441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h8Hp5LsVsY8iyzznMU6rRN7uhlbtTR0PHM4cQMPZpIY=;
        b=Y+7rz+19Tgj8RmHnXY+d0qjWEjk/ZmuqMYKYJyh8aMuq1hSx7EmCjdwKj4xidcMNW18ye/
        aiz9tfA90F/P3oLTYW+CkUt7sf/drDrPzhVWBAQ8FLHjCGeX8ywiRfHbCPTL6ZtTpNWZ3e
        f4+eQ1fhkGZQvqkJvL4/DmHH5jlbGbw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-MDoAMc0ONGSci6jpwrEnvg-1; Thu, 16 Jan 2020 12:40:39 -0500
X-MC-Unique: MDoAMc0ONGSci6jpwrEnvg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2AA36DB33;
        Thu, 16 Jan 2020 17:40:38 +0000 (UTC)
Received: from gondolin (unknown [10.36.117.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0F12101F942;
        Thu, 16 Jan 2020 17:40:30 +0000 (UTC)
Date:   Thu, 16 Jan 2020 18:40:27 +0100
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
Message-ID: <20200116184027.2954c3f5.cohuck@redhat.com>
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A184041@SHSMSX104.ccr.corp.intel.com>
References: <1578398509-26453-1-git-send-email-yi.l.liu@intel.com>
        <1578398509-26453-12-git-send-email-yi.l.liu@intel.com>
        <20200115133027.228452fd.cohuck@redhat.com>
        <A2975661238FB949B60364EF0F2C25743A184041@SHSMSX104.ccr.corp.intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 16 Jan 2020 13:23:28 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Cornelia Huck [mailto:cohuck@redhat.com]
> > Sent: Wednesday, January 15, 2020 8:30 PM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [PATCH v4 11/12] samples: add vfio-mdev-pci driver
> > 
> > On Tue,  7 Jan 2020 20:01:48 +0800
> > Liu Yi L <yi.l.liu@intel.com> wrote:

> > > diff --git a/samples/Kconfig b/samples/Kconfig
> > > index 9d236c3..50d207c 100644
> > > --- a/samples/Kconfig
> > > +++ b/samples/Kconfig
> > > @@ -190,5 +190,15 @@ config SAMPLE_INTEL_MEI
> > >  	help
> > >  	  Build a sample program to work with mei device.
> > >
> > > +config SAMPLE_VFIO_MDEV_PCI
> > > +	tristate "Sample driver for wrapping PCI device as a mdev"
> > > +	select VFIO_PCI_COMMON
> > > +	select VFIO_PCI  
> > 
> > Why does this still need to select VFIO_PCI? Shouldn't all needed
> > infrastructure rather be covered by VFIO_PCI_COMMON already?  
> 
> VFIO_PCI_COMMON is supposed to be the dependency of both VFIO_PCI and
> SAMPLE_VFIO_MDEV_PCI. However, the source code of VFIO_PCI_COMMON are
> under drivers/vfio/pci which is compiled per the configuration of VFIO_PCI.
> Besides of letting SAMPLE_VFIO_MDEV_PCI select VFIO_PCI, I can also add
> a line in drivers/vfio/Makefile to make the source code under drivers/vfio/pci
> to be compiled when either VFIO_PCI or VFIO_PCI_COMMON are configed. But
> I'm afraid it is a bit ugly. So I choose to let SAMPLE_VFIO_MDEV_PCI select
> VFIO_PCI. If you have other idea, I would be pleased to
> know it. :-)

Shouldn't building drivers/vfio/pci/ for CONFIG_VFIO_PCI_COMMON already
be enough (the Makefile changes look fine to me)? Or am I missing
something obvious?

> 
> >   
> > > +	depends on VFIO_MDEV && VFIO_MDEV_DEVICE  
> > 
> > VFIO_MDEV_DEVICE already depends on VFIO_MDEV. But maybe also make this
> > depend on PCI?
> >   
> > > +	help
> > > +	  Sample driver for wrapping a PCI device as a mdev. Once bound to
> > > +	  this driver, device passthru should through mdev path.  
> > 
> > "A PCI device bound to this driver will be assigned through the
> > mediated device framework."
> > 
> > ?  
> 
> Maybe I should have mentioned it as "A PCI device bound to this
> sample driver should follow the passthru steps for mdevs as showed
> in Documentation/driver-api/vfio-mediated-device.rst."
> 
> Does it make more sense?

Yes, it does :)

