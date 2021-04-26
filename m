Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4FA36B4B8
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 16:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbhDZOUD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 10:20:03 -0400
Received: from verein.lst.de ([213.95.11.211]:41465 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231862AbhDZOT4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 10:19:56 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id D12DF68C4E; Mon, 26 Apr 2021 16:19:11 +0200 (CEST)
Date:   Mon, 26 Apr 2021 16:19:11 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
        Eric Farman <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, linux-s390@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 10/12] vfio/mdev: Remove mdev_parent_ops
Message-ID: <20210426141911.GH15209@lst.de>
References: <0-v1-d88406ed308e+418-vfio3_jgg@nvidia.com> <10-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +The mediated bus driver's probe function should create a vfio_device on top of
> +the mdev_device and connect it to an appropriate implementation of vfio_device_ops.

Overly long line.

> +This will provide the 'mdev_supported_types/XX/create' files which can then be used
> +to trigger the creation of a mdev_device. The created mdev_device will be attached

Two more.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
