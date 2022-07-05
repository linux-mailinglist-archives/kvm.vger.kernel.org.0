Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A00255664FE
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 10:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiGEI0H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 04:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiGEI0G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 04:26:06 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C728F1093;
        Tue,  5 Jul 2022 01:26:03 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0C80768AA6; Tue,  5 Jul 2022 10:26:00 +0200 (CEST)
Date:   Tue, 5 Jul 2022 10:25:59 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org
Subject: Re: [PATCH 02/14] drm/i915/gvt: simplify vgpu configuration
 management
Message-ID: <20220705082559.GA18584@lst.de>
References: <20220704125144.157288-1-hch@lst.de> <20220704125144.157288-3-hch@lst.de> <20220705075938.GW1089@zhen-hp.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705075938.GW1089@zhen-hp.sh.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 05, 2022 at 03:59:38PM +0800, Zhenyu Wang wrote:
> On 2022.07.04 14:51:32 +0200, Christoph Hellwig wrote:
> > Instead of copying the information from the vgpu_types arrays into each
> > intel_vgpu_type structure, just reference this constant information
> > with a pointer to the already existing data structure, and pass it into
> > the low-level VGPU creation helpers intead of copying the data into yet
> > anothe params data structure.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> 
> Looks fine to me. We still carry some legacy codes like vgpu create param
> originally used for other hypervisor. Thanks for cleaning this up!

Note that even there I think this structure makes more sense:

The generic config structure that has not vfio-related bits as the
lowest layer.  vfio/kvm specific structures then carry a pointer to
it can can pass it to lower layers.
