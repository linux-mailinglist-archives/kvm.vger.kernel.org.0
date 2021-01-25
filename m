Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E800C3029A8
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 19:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731214AbhAYSJy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 13:09:54 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:13076 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728765AbhAYSFZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 13:05:25 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600f083b0001>; Mon, 25 Jan 2021 10:04:43 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 18:04:43 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 25 Jan 2021 18:04:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MH78bGx+ZzPKPNbAz70ASmhPt+8RE35oSelcOZAuHOSt2XGVFo4C6tE7xbgttQCE0TYIRDyVjSUYdLZferp14ILv6W23uVvgpsCiJ336OvUbqdVnbhxnkvaKHWTWW84op6DuqI7YfB9sdRvCEiWp9B5Zq30+l4W3Fk/yFc5PjcP4DGKsp73vkVP6408F0aglBvlCibrXeJVDPsWncHnxvLHrhOiP+JIa5Wzm9z9lF5BYIJKZGi+JNskVCQ37kllFGVINBbmbGD3PghmfAvJl4jvMCQNSUWflwG4XmSWT/D/Pmo1POcKDnwGZIEXNH74WlpYMyG6I3ZHH5Ay9lGqDGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6d5BZgWXaDjezYe7VULdVIz4cyCBbc3JioQrXIyvPB8=;
 b=IfyCzFKIMc9Pb65BfzOt5V5lRFKy+u8XiTxLU6SL3DzzjUo4oZZfn/CjZQaEOPzBiViDkPeqGFR6C7iw+sQeJ65hX7T5l9NYlCM4xqUgCgHI6wNKGmo1mbiF8oHu81SBcdZexS1CCsZM5EuIPzJk3wXOaeRqHtANGp0iGQLxwzWwn5Q2FlVsd9h6IWOsI3L5ZPk8KXgcoe9W4S1hkENaeudwFoACntbWFUon/5S/4TRJZtZTPl8LllJzaIfceOLT9Wm5EOABjw3bUHyVBuVtmI7fQEWLp0kFqGIN8zZuVsAiidCinsYUj5n49KSMrh38Qy8jIXyyvCFCAXzqyzqHcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4617.namprd12.prod.outlook.com (2603:10b6:5:35::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.17; Mon, 25 Jan
 2021 18:04:42 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 18:04:42 +0000
Date:   Mon, 25 Jan 2021 14:04:40 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liranl@nvidia.com>,
        <oren@nvidia.com>, <tzahio@nvidia.com>, <leonro@nvidia.com>,
        <yarong@nvidia.com>, <aviadye@nvidia.com>, <shahafs@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <gmataev@nvidia.com>, <cjia@nvidia.com>
Subject: Re: [PATCH RFC v1 0/3] Introduce vfio-pci-core subsystem
Message-ID: <20210125180440.GR4147@nvidia.com>
References: <20210117181534.65724-1-mgurtovoy@nvidia.com>
 <20210122122503.4e492b96@omen.home.shazbot.org>
 <20210122200421.GH4147@nvidia.com>
 <20210125172035.3b61b91b.cohuck@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210125172035.3b61b91b.cohuck@redhat.com>
X-ClientProxiedBy: BL1PR13CA0209.namprd13.prod.outlook.com
 (2603:10b6:208:2be::34) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0209.namprd13.prod.outlook.com (2603:10b6:208:2be::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.6 via Frontend Transport; Mon, 25 Jan 2021 18:04:41 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l46EC-006fiI-EV; Mon, 25 Jan 2021 14:04:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611597883; bh=6d5BZgWXaDjezYe7VULdVIz4cyCBbc3JioQrXIyvPB8=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=BKcM5Iipump2yO5DgmCHqiPL5pUGMmdxQvlRFh6l5FWrIhSAtzxLTYHuFa8tZhxtI
         0tKPQLIa5iT7jUbmX+mdDYDHxTJkjDqRl51CvhxyR1URkCSeDBasekeKRZ0eDxjOAf
         7122fL0iNjXKlUSwpTeEQq9z7WsoM9G0Wn3YmfRMDFvCPIaYB8VwaOZevcwMy8AVpx
         zsNw7sj9XuQMX3kJ8TXCaW4uKDH5HU1qag8uxDHv9oxANxS7ODbJCpIDg9O+Y6FxG6
         0FDL5HsmRm4IllCZRSdp8XQZsOc7t0orVJe8v9sA3o+mEDUI2Cp0/okDY/TNCDZDVa
         82ahQuTkx7B8A==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 25, 2021 at 05:20:35PM +0100, Cornelia Huck wrote:

> I think you cut out an important part of Alex' comment, so let me
> repost it here:

Yes, I've already respnded to this.

> I'm missing the bigger picture of how this api is supposed to work out,
> a driver with a lot of TODOs does not help much to figure out whether
> this split makes sense and is potentially useful for a number of use
> cases

The change to vfio-pci is essentially complete, ignoring some
additional cleanup. I'm not sure seeing details how some mlx5 driver
uses it will be substantially more informative if it is useful for
S390, or Intel.

As far as API it is clear to see:

> +/* Exported functions */
> +struct vfio_pci_device *vfio_create_pci_device(struct pci_dev *pdev,
> +               const struct vfio_device_ops *vfio_pci_ops, void *dd_data);
> +void vfio_destroy_pci_device(struct pci_dev *pdev);

Called from probe/remove of the consuming driver

> +int vfio_pci_core_open(void *device_data);
> +void vfio_pci_core_release(void *device_data);
> +long vfio_pci_core_ioctl(void *device_data, unsigned int cmd,
> +               unsigned long arg);
> +ssize_t vfio_pci_core_read(void *device_data, char __user *buf, size_t count,
> +               loff_t *ppos);
> +ssize_t vfio_pci_core_write(void *device_data, const char __user *buf,
> +               size_t count, loff_t *ppos);
> +int vfio_pci_core_mmap(void *device_data, struct vm_area_struct *vma);
> +void vfio_pci_core_request(void *device_data, unsigned int count);
> +int vfio_pci_core_match(void *device_data, char *buf);

Called from vfio_device_ops and has the existing well defined API of
the matching ops.

> +int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn);
> +pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
> +               pci_channel_state_t state);
> +

Callbacks from the PCI core, API defined by the PCI subsystem.

Notice there is no major new API exposed from vfio-pci, nor are
vfio-pci internals any more exposed then they used to be.

Except create/destroy, every single newly exported function was
already available via a function pointer someplace else in the
API. This is a key point, because it is very much NOT like the May
series.

Because the new driver sits before vfio_pci because it owns the
vfio_device_ops, it introduces nearly nothing new. The May series put
the new driver after vfio-pci as some internalized sub-driver and
exposed a whole new API, wrappers and callbacks to go along with it.

For instance if a new driver wants to implement some new thing under
ioctl, like migration, then it would do

static long new_driver_pci_core_ioctl(void *device_data, unsigned int cmd,
               unsigned long arg)
{
   switch (cmd) {
     case NEW_THING: return new_driver_thing();
     default: return vfio_pci_core_ioctl(device_data, cmd, arg);
   }
}
static const struct vfio_device_ops new_driver_pci_ops = {
   [...]
   .ioctl = new_driver_ioctl,
};

Simple enough, if you understand the above, then you also understand
what direction the mlx5 driver will go in.

This is also why it is clearly useful for a wide range of cases, as a
driver can use as much or as little of the vfio-pci-core ops as it
wants. The driver doesn't get to reach into vfio-pci, but it can sit
before it and intercept the entire uAPI. That is very powerful.

> or whether mdev (even with its different lifecycle model) or a

I think it is appropriate to think of mdev as only the special
lifecycle model, it doesn't have any other functionality.

mdev's lifecycle model does nothing to solve the need to libraryize
vfio-pci.

> different vfio bus driver might be a better fit for the more

What is a "vfio bus driver" ? Why would we need a bus here?

> involved cases. (For example, can s390 ISM fit here?)

Don't know what is special about ISM? What TODO do you think will help
answer that question?

Jason
