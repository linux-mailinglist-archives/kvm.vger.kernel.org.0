Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6F4339378
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 17:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbhCLQdA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 11:33:00 -0500
Received: from verein.lst.de ([213.95.11.211]:46250 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232238AbhCLQcs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 11:32:48 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0DBCD68B05; Fri, 12 Mar 2021 17:32:47 +0100 (CET)
Date:   Fri, 12 Mar 2021 17:32:46 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 01/10] vfio: Simplify the lifetime logic for vfio_device
Message-ID: <20210312163246.GB11384@lst.de>
References: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com> <1-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com> <20210310072340.GA2659@lst.de> <20210312154133.GE2356281@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312154133.GE2356281@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 12, 2021 at 11:41:33AM -0400, Jason Gunthorpe wrote:
> I split the put/get and it looks nicer. The other stuff is more
> tightly coupled, doesn't look like there is much win from splitting
> further

Splitting the group put/get was all that I mean anyway.  Thanks!
