Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A9F5664E0
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 10:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiGEIFZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 04:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGEIFZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 04:05:25 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 707D96333;
        Tue,  5 Jul 2022 01:05:24 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9DC7368AA6; Tue,  5 Jul 2022 10:05:20 +0200 (CEST)
Date:   Tue, 5 Jul 2022 10:05:20 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH 14/14] vfio/mdev: add mdev available instance checking
 to the core
Message-ID: <20220705080520.GB17663@lst.de>
References: <20220704125144.157288-1-hch@lst.de> <20220704125144.157288-15-hch@lst.de> <20220704150736.GQ693670@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220704150736.GQ693670@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 04, 2022 at 12:07:36PM -0300, Jason Gunthorpe wrote:
> I think the kobject_put() needs to be after this reference to parent
> because mdev_type_release() will:
> 
> 	put_device(type->parent->dev);
> 
> Which is potentially the last reference holding dev, and thus parent,
> at this moment.

Yes, I've moved it.
