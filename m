Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2BA544491
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 09:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236851AbiFIHQK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 03:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbiFIHQI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 03:16:08 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369755A0AE;
        Thu,  9 Jun 2022 00:16:05 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id B883C6732D; Thu,  9 Jun 2022 09:16:00 +0200 (CEST)
Date:   Thu, 9 Jun 2022 09:16:00 +0200
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
        intel-gvt-dev@lists.freedesktop.org, Neo Jia <cjia@nvidia.com>,
        Dheeraj Nigam <dnigam@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 3/8] vfio/mdev: simplify mdev_type handling
Message-ID: <20220609071600.GA4173@lst.de>
References: <20220603063328.3715-1-hch@lst.de> <20220603063328.3715-4-hch@lst.de> <86df429e-9f01-7a91-c420-bb1130b4d343@nvidia.com> <20220607055050.GB8680@lst.de> <a542c244-a793-7889-db9f-610cf525e3b6@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a542c244-a793-7889-db9f-610cf525e3b6@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 08, 2022 at 11:27:02PM +0530, Kirti Wankhede wrote:
>> the code correctness perspective.  It just isn't very useful.  Just
>> like say creating a kobject without attributes in the device model.
>
> Creating kobject without kobj_type is not allowed in the kernel, similarly 
> mdev registration should not be allowed without its type.

But the kobj_type doesn't need to have any attributes.

> Instead of exporting mdev_type_add/mdev_type_remove, these functions might 
> be called internally from registration function.

I very fundamentally disagree.  That is exactly what makes the current
interface so messy and complicated and I want to get rid of that.
