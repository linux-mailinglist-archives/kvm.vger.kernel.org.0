Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFDA36E525
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 08:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbhD2GyP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 02:54:15 -0400
Received: from verein.lst.de ([213.95.11.211]:51965 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239367AbhD2GyE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 02:54:04 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1301967357; Thu, 29 Apr 2021 08:53:16 +0200 (CEST)
Date:   Thu, 29 Apr 2021 08:53:15 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 09/13] vfio/mdev: Remove vfio_mdev.c
Message-ID: <20210429065315.GC2882@lst.de>
References: <9-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com> <20210428060703.GA4973@lst.de> <YIkCVnTFmTHiX3xn@kroah.com> <20210428125321.GP1370958@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210428125321.GP1370958@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 28, 2021 at 09:53:21AM -0300, Jason Gunthorpe wrote:
> The Linux standard is one patch one change. It is inapporiate for me
> to backdoor sneak revert the VFIO communities past decisions on
> licensing inside some unrelated cleanup patch.

That's not what you are doing.  You are removing weird condom code
that could never work, and remove the sneak attempt of an nvidia employee
to create a derived work that has no legal standing.

> Otherwise this patch changes nothing - what existed today continues to
> exist, and nothing new is being allowed.

No, it changes the existing exports, which is a complete no-go.
