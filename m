Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE73E56A3D4
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 15:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235994AbiGGNiJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 09:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235303AbiGGNiE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 09:38:04 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3C92B613;
        Thu,  7 Jul 2022 06:38:03 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id DCD8768AA6; Thu,  7 Jul 2022 15:37:59 +0200 (CEST)
Date:   Thu, 7 Jul 2022 15:37:59 +0200
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
        Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        Tarun Gupta <targupta@nvidia.com>, Neo Jia <cjia@nvidia.com>,
        Shounak Deshpande <shdeshpande@nvidia.com>
Subject: Re: [PATCH 15/15] vfio/mdev: remove an extra parent kobject
 reference
Message-ID: <20220707133759.GA19060@lst.de>
References: <20220706074219.3614-1-hch@lst.de> <20220706074219.3614-16-hch@lst.de> <c967d315-755c-a7ef-569e-9aa25c65d261@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c967d315-755c-a7ef-569e-9aa25c65d261@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 06, 2022 at 07:18:48PM +0530, Kirti Wankhede wrote:
>> -		kobject_put(&type->kobj);
>
> This kobject_put is required here in error case, see description above 
> kobject_init_and_add().

And they are completely unrelated anyway, this should have never slipped
in.
