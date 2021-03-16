Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C1C33CDF0
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 07:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhCPG1x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 02:27:53 -0400
Received: from verein.lst.de ([213.95.11.211]:58538 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229775AbhCPG1X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 02:27:23 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5C35268C4E; Tue, 16 Mar 2021 07:27:20 +0100 (CET)
Date:   Tue, 16 Mar 2021 07:27:20 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>, Cornelia Huck <cohuck@redhat.com>,
        kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 07/14] vfio/pci: Move VGA and VF initialization to
 functions
Message-ID: <20210316062720.GA13303@lst.de>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com> <7-v2-20d933792272+4ff-vfio1_jgg@nvidia.com> <20210315084534.GC29269@lst.de> <20210315230746.GJ2356281@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315230746.GJ2356281@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 15, 2021 at 08:07:46PM -0300, Jason Gunthorpe wrote:
> So the goto unwind looks quite odd when this is open coded. At least
> with the helpers you can read the init then uninit and go 'yah, OK,
> this makes sense'

Still looks odd to me.  But this is your series and overall a major
improvements, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>
