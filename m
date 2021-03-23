Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 015BC3468B3
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 20:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbhCWTOw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 15:14:52 -0400
Received: from verein.lst.de ([213.95.11.211]:33868 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233322AbhCWTOS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 15:14:18 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id B9C1F68BEB; Tue, 23 Mar 2021 20:14:15 +0100 (CET)
Date:   Tue, 23 Mar 2021 20:14:15 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 03/18] vfio/mdev: Simplify driver registration
Message-ID: <20210323191415.GA17735@lst.de>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com> <3-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>  static struct mdev_driver vfio_mdev_driver = {
> +	.driver = {
> +		.name = "vfio_mdev",
> +		.owner = THIS_MODULE,
> +		.mod_name = KBUILD_MODNAME,
> +	},

What is the mod_name initialization for?  I've not really seen
that in anywere else, and the only user seems to be
module_add_driver for a rather odd case we shouldn't hit here.

The rest looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
