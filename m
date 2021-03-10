Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C59333366F
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 08:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhCJHcc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 02:32:32 -0500
Received: from verein.lst.de ([213.95.11.211]:34914 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230489AbhCJHcA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 02:32:00 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9644968BFE; Wed, 10 Mar 2021 08:31:58 +0100 (CET)
Date:   Wed, 10 Mar 2021 08:31:58 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 06/10] vfio/mdev: Use
 vfio_init/register/unregister_group_dev
Message-ID: <20210310073158.GF2659@lst.de>
References: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com> <6-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
