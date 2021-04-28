Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7407236D203
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 08:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235939AbhD1GHw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 02:07:52 -0400
Received: from verein.lst.de ([213.95.11.211]:47916 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235859AbhD1GHv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 02:07:51 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id DFF4A68B05; Wed, 28 Apr 2021 08:07:03 +0200 (CEST)
Date:   Wed, 28 Apr 2021 08:07:03 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 09/13] vfio/mdev: Remove vfio_mdev.c
Message-ID: <20210428060703.GA4973@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 26, 2021 at 05:00:11PM -0300, Jason Gunthorpe wrote:
> Preserve VFIO's design of allowing mdev drivers to be !GPL by allowing the
> three functions that replace this module for !GPL usage. This goes along
> with the other 19 symbols that are already marked !GPL in VFIO.

NAK.  This was a sneak by Nvidia to try a GPL condom, and now that we
remove that not working condom it does not mean core symbols can be
just changed.
