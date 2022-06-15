Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1A054C1DB
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 08:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353321AbiFOG35 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 02:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236311AbiFOG34 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 02:29:56 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CFF3A5E9;
        Tue, 14 Jun 2022 23:29:55 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id F0D3D67373; Wed, 15 Jun 2022 08:29:52 +0200 (CEST)
Date:   Wed, 15 Jun 2022 08:29:52 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 13/13] vfio/mdev: add mdev available instance checking
 to the core
Message-ID: <20220615062952.GC22728@lst.de>
References: <20220614045428.278494-1-hch@lst.de> <20220614045428.278494-14-hch@lst.de> <BN9PR11MB5276BB7AA39243BA5A21CFEC8CAA9@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276BB7AA39243BA5A21CFEC8CAA9@BN9PR11MB5276.namprd11.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 14, 2022 at 10:32:11AM +0000, Tian, Kevin wrote:
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > [count instances per-parent instead of per-type]
> 
> per-parent counting works only if the parent doesn't have overlapping
> instances between types. This is probably worth a clarification in doc.

Yes.  Two cases right now just have a single type, and the third wants
this per-parent counting.  The original patch from Jason actually got
this wrong.
