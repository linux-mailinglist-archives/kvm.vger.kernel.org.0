Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 261D756A3E1
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 15:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235573AbiGGNkZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 09:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235577AbiGGNkW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 09:40:22 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07CAF2AC50;
        Thu,  7 Jul 2022 06:40:21 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2855068AA6; Thu,  7 Jul 2022 15:40:18 +0200 (CEST)
Date:   Thu, 7 Jul 2022 15:40:17 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Vineeth Vijayan <vneethv@linux.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>, Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH 04/15] vfio/mdev: embedd struct mdev_parent in the
 parent data structure
Message-ID: <20220707134017.GB19060@lst.de>
References: <20220706074219.3614-1-hch@lst.de> <20220706074219.3614-5-hch@lst.de> <27e9ef873a00dde07373155e76615437136106c4.camel@linux.ibm.com> <YsaJrX4kpCCz5AZI@tuxmaker.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsaJrX4kpCCz5AZI@tuxmaker.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 07, 2022 at 09:22:21AM +0200, Vineeth Vijayan wrote:
> Thank you Eric for pointing it out. You are right. I think the struct
> subchannel is obviously the wrong place. 
> Also, in this case, the mdev_parent should be in one of the vfio-ccw
> io-subchannel structure, which as you mentioned should be in vfio-ccw*.

It is where the parent dev is embedded into, so it sticks to the
spirit of the old code.  I'm totally fine with you guys moving it
to another structure of your choice, but for making progress on this
series it should be good enough.

