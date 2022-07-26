Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 418605818D5
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 19:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239610AbiGZRsW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 13:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239600AbiGZRsV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 13:48:21 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181BF13CC0;
        Tue, 26 Jul 2022 10:48:21 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id C193D68AA6; Tue, 26 Jul 2022 19:48:17 +0200 (CEST)
Date:   Tue, 26 Jul 2022 19:48:17 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     hch@lst.de, akrowiak@linux.ibm.com, alex.williamson@redhat.com,
        intel-gvt-dev@lists.freedesktop.org, jgg@nvidia.com,
        jjherne@linux.ibm.com, kvm@vger.kernel.org, kwankhede@nvidia.com,
        linux-s390@vger.kernel.org, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, vneethv@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com
Subject: Re: [RFC PATCH] vfio/ccw: Move mdev stuff out of struct subchannel
Message-ID: <20220726174817.GB14002@lst.de>
References: <20220720050629.GA6076@lst.de> <20220726153725.2573294-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220726153725.2573294-1-farman@linux.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 26, 2022 at 05:37:25PM +0200, Eric Farman wrote:
> Here's my swipe at a cleanup patch that can be folded in
> to this series, to get the mdev stuff in a more proper
> location for vfio-ccw.
> 
> As previously described, the subchannel is a device-agnostic
> structure that does/should not need to know about specific
> nuances such as mediated devices. This is why things like
> struct vfio_ccw_private exist, so move these details there.

Should I resend the series with that folded in?  At this point we're
probably not talking about 5.20 anyway.
