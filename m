Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189CA333657
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 08:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbhCJH0g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 02:26:36 -0500
Received: from verein.lst.de ([213.95.11.211]:34888 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229724AbhCJH0W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 02:26:22 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3265368BEB; Wed, 10 Mar 2021 08:26:19 +0100 (CET)
Date:   Wed, 10 Mar 2021 08:26:19 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 02/10] vfio: Split creation of a vfio_device into init
 and register ops
Message-ID: <20210310072619.GB2659@lst.de>
References: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com> <2-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 09, 2021 at 05:38:44PM -0400, Jason Gunthorpe wrote:
> The pattern also makes it clear that vfio_register_group_dev() must be
> last in the sequence, as once it is called the core code can immediately
> start calling ops. The init/register gap is provided to allow for the
> driver to do setup before ops can be called and thus avoid races.

Yes, APIs that init and register together are generatelly a rather
bad idea.

Reviewed-by: Christoph Hellwig <hch@lst.de>
