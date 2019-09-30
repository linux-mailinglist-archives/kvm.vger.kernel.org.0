Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F06CC20BC
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 14:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730867AbfI3Mkm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 30 Sep 2019 08:40:42 -0400
Received: from mga18.intel.com ([134.134.136.126]:38278 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726072AbfI3Mkm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 08:40:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Sep 2019 05:40:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,567,1559545200"; 
   d="scan'208";a="194164577"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga003.jf.intel.com with ESMTP; 30 Sep 2019 05:40:41 -0700
Received: from fmsmsx120.amr.corp.intel.com (10.18.124.208) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Sep 2019 05:40:41 -0700
Received: from shsmsx107.ccr.corp.intel.com (10.239.4.96) by
 fmsmsx120.amr.corp.intel.com (10.18.124.208) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Sep 2019 05:40:41 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.166]) by
 SHSMSX107.ccr.corp.intel.com ([169.254.9.33]) with mapi id 14.03.0439.000;
 Mon, 30 Sep 2019 20:40:39 +0800
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
Subject: RE: [PATCH v2 11/13] samples/vfio-mdev-pci: call
 vfio_add_group_dev()
Thread-Topic: [PATCH v2 11/13] samples/vfio-mdev-pci: call
 vfio_add_group_dev()
Thread-Index: AQHVZIuXfFKMbpYABEKE0eIkHeBbGKc811UAgAcTNtA=
Date:   Mon, 30 Sep 2019 12:40:38 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A0B55ED@SHSMSX104.ccr.corp.intel.com>
References: <1567670370-4484-1-git-send-email-yi.l.liu@intel.com>
        <1567670370-4484-12-git-send-email-yi.l.liu@intel.com>
 <20190925203658.18ea50ab@x1.home>
In-Reply-To: <20190925203658.18ea50ab@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYzBlOTcyNWEtZTY1Zi00NTc1LWIyNzYtMTRhMjJlOTljYTA1IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiQUc2eTQ5MFJyelYyMlwvZU44Z1B2VWRGOFdwY2dGaXJkVHZXcWg5VkpxeTFMRDFmY1ljdEJPS0h1ZTk5cUVPOTMifQ==
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
> Subject: Re: [PATCH v2 11/13] samples/vfio-mdev-pci: call vfio_add_group_dev()
> 
> On Thu,  5 Sep 2019 15:59:28 +0800
> Liu Yi L <yi.l.liu@intel.com> wrote:
> 
> > This patch adds vfio_add_group_dev() calling in probe() to make
> > vfio-mdev-pci work well with non-singleton iommu group. User could
> > bind devices from a non-singleton iommu group to either vfio-pci
> > driver or this sample driver. Existing passthru policy works well for
> > this non-singleton group.
> >
> > This is actually a policy choice. A device driver can make this call
> > if it wants to be vfio viable. And it needs to provide dummy
> > vfio_device_ops which is required by vfio framework. To prevent user
> > from opening the device from the iommu backed group fd, the open
> > callback of the dummy vfio_device_ops should return -ENODEV to fail
> > the VFIO_GET_DEVICE_FD request from userspace.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/pci/vfio_mdev_pci.c | 91
> > ++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 82 insertions(+), 9 deletions(-)
> >

[...]

> > +static int vfio_pci_dummy_open(void *device_data) {
> > +	struct vfio_mdev_pci_device *vmdev =
> > +		(struct vfio_mdev_pci_device *) device_data;
> > +	pr_warn("Device %s is not viable for vfio-pci passthru, please follow"
> > +		" vfio-mdev passthru path as it has been wrapped as mdev!!!\n",
> > +					dev_name(&vmdev->vdev.pdev->dev));
> > +	return -ENODEV;
> > +}
> > +
> > +static void vfio_pci_dummy_release(void *device_data) { }
> 
> Theoretically .release will never be called.  If we're paranoid, we could keep it with a
> pr_warn.

yes, it is.

> > +
> > +long vfio_pci_dummy_ioctl(void *device_data,
> > +		   unsigned int cmd, unsigned long arg) {
> > +	return 0;
> > +}
> > +
> > +ssize_t vfio_pci_dummy_read(void *device_data, char __user *buf,
> > +			     size_t count, loff_t *ppos)
> > +{
> > +	return 0;
> > +}
> > +
> > +ssize_t vfio_pci_dummy_write(void *device_data, const char __user *buf,
> > +			      size_t count, loff_t *ppos)
> > +{
> > +	return 0;
> > +}
> > +
> > +int vfio_pci_dummy_mmap(void *device_data, struct vm_area_struct
> > +*vma) {
> > +	return 0;
> > +}
> > +
> > +void vfio_pci_dummy_request(void *device_data, unsigned int count) {
> > +}
> 
> AFAICT, none of .ioctl, .read, .write, .mmap, or .request need to be provided,
> only .open and only .release for paranoia.

sure. let me fix it.

> > +
> > +static const struct vfio_device_ops vfio_pci_dummy_ops = {
> > +	.name		= "vfio-pci",
> 
> This is impersonating vfio-pci, shouldn't we use something like "vfio-mdev-pci-
> dummy".  Thanks,

Yep. will modify it.
 
> Alex

Thanks,
Yi Liu

