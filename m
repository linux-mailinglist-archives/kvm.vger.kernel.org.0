Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF99547FBE
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 08:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236950AbiFMGrE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 02:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbiFMGrB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 02:47:01 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8517B101FF;
        Sun, 12 Jun 2022 23:46:59 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D33CB68AA6; Mon, 13 Jun 2022 08:46:55 +0200 (CEST)
Date:   Mon, 13 Jun 2022 08:46:55 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>, Neo Jia <cjia@nvidia.com>,
        Dheeraj Nigam <dnigam@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v1 14/18] vfio/mdev: Add mdev available instance
 checking to the core
Message-ID: <20220613064655.GA493@lst.de>
References: <20220602171948.2790690-1-farman@linux.ibm.com> <20220602171948.2790690-15-farman@linux.ibm.com> <63a87e1e-7d99-b091-4c6b-fa25dd7c5211@nvidia.com> <c818e1ef24c466a3b1d14d4ab10163d5e349a3b4.camel@linux.ibm.com> <BN9PR11MB5276228F26CC7B9EBE13489B8CA69@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276228F26CC7B9EBE13489B8CA69@BN9PR11MB5276.namprd11.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 10, 2022 at 07:43:46AM +0000, Tian, Kevin wrote:
> btw with those latest changes [1] we don't need .get_available() then,
> as mdev type is now added by mdev driver one-by-one then the
> available instance can be provided directly in that path.

Yes, we can probably add a helper to add the vailable attibrute, which
takes the number of instances.  Is it ok if I just add a version of this
patch and the device_api one to my series, and we rebase this series
on top of it?  I'll try to get out a new version ASAP.
