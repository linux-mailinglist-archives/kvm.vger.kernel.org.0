Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAAE55092A
	for <lists+kvm@lfdr.de>; Sun, 19 Jun 2022 09:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234223AbiFSHhy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jun 2022 03:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234274AbiFSHhx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Jun 2022 03:37:53 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908BDCE2C;
        Sun, 19 Jun 2022 00:37:52 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 875EB67373; Sun, 19 Jun 2022 09:37:48 +0200 (CEST)
Date:   Sun, 19 Jun 2022 09:37:48 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
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
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>, Neo Jia <cjia@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        Dheeraj Nigam <dnigam@nvidia.com>
Subject: Re: [PATCH 04/13] vfio/mdev: remove
 mdev_{create,remove}_sysfs_files
Message-ID: <20220619073748.GA27820@lst.de>
References: <20220614045428.278494-1-hch@lst.de> <20220614045428.278494-5-hch@lst.de> <fdfd02cf-07be-1cfd-85ca-ae2dbd8a8d84@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fdfd02cf-07be-1cfd-85ca-ae2dbd8a8d84@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 16, 2022 at 01:33:30AM +0530, Kirti Wankhede wrote:
>
> Does this change really required? When mdev was implemented we tried to 
> keep all sysfs related stuff in mdev_sysfs.c file and I would still like to 
> stick to that approach.

It isn't strictly required, but it removes a lot of pointless boilerplate
code.
