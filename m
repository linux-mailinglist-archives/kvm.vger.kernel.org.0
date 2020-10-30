Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9626D2A0FF7
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 22:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbgJ3VGi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 17:06:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45309 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726163AbgJ3VGg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Oct 2020 17:06:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604091995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X7I6BvcvTcATCs3ne7yJMoF1DIkz9Wxm1G9qxszsAaE=;
        b=N3cqHD0H5Ozfa7xuYjj5tgl1dsrqp60Ts2TJ0L+UU3fi2QZgMjn+gYnN2/1uDGgayAAvG2
        EmpogKhABhLd7pKxGykSyuGXSszMIATIvVexW7TQxXxL13iE5kW1d6XK/89IpDS6iEhwpD
        Rc1QHYN3gPSF+An85J3qh8uiFgovui8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-S3rixnEdOD6JCsTzbTJiPw-1; Fri, 30 Oct 2020 17:06:30 -0400
X-MC-Unique: S3rixnEdOD6JCsTzbTJiPw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B01B1005E77;
        Fri, 30 Oct 2020 21:06:27 +0000 (UTC)
Received: from w520.home (ovpn-112-213.phx2.redhat.com [10.3.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 448DD76668;
        Fri, 30 Oct 2020 21:06:26 +0000 (UTC)
Date:   Fri, 30 Oct 2020 15:06:25 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Zeng, Xin" <xin.zeng@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 5/5] vfio/type1: Use mdev bus iommu_ops for IOMMU
 callbacks
Message-ID: <20201030150625.2dc5fb9b@w520.home>
In-Reply-To: <MWHPR11MB1645DEBE7C0E7A61D22081DD8C150@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20201030045809.957927-1-baolu.lu@linux.intel.com>
        <20201030045809.957927-6-baolu.lu@linux.intel.com>
        <MWHPR11MB1645DEBE7C0E7A61D22081DD8C150@MWHPR11MB1645.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 30 Oct 2020 06:16:28 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Lu Baolu <baolu.lu@linux.intel.com>
> > Sent: Friday, October 30, 2020 12:58 PM
> > 
> > With the IOMMU driver registering iommu_ops for the mdev_bus, the
> > IOMMU
> > operations on an mdev could be done in the same way as any normal device
> > (for example, PCI/PCIe). There's no need to distinguish an mdev from
> > others for iommu operations. Remove the unnecessary code.  
> 
> This is really a nice cleanup as the output of this change! :)

It's easy to remove a bunch of code when the result is breaking
everyone else.  Please share with me how SR-IOV backed mdevs continue
to work on AMD platforms, or how they might work on ARM platforms, when
siov_iommu_ops (VT-d only) becomes the one and only provider of
iommu_ops on the mdev bus.  Hard NAK on this series.  Thanks,

Alex 

