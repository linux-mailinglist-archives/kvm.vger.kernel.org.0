Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F743562ED
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 07:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244998AbhDGFQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 01:16:28 -0400
Received: from verein.lst.de ([213.95.11.211]:57404 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229603AbhDGFQ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 01:16:28 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6D2BA68B05; Wed,  7 Apr 2021 07:16:17 +0200 (CEST)
Date:   Wed, 7 Apr 2021 07:16:17 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, "Raj, Ashok" <ashok.raj@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 03/18] vfio/mdev: Add missing typesafety around
 mdev_device
Message-ID: <20210407051617.GB18085@lst.de>
References: <0-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com> <3-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
