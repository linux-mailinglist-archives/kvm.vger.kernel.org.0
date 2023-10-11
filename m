Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2587C4B14
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 08:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344731AbjJKG7c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 02:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344707AbjJKG7b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 02:59:31 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E3BC9
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 23:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7+3//c/XdIYkg92t2zyGDW07nZCMeH5pMwbxvAuBdFc=; b=GdZlfe3Oe4euK9oxE7pFXqdFm/
        UvCjrDcVEypDCN7pZ7YvuUhrX6PCZm0zyFOuJjNWC/xhxs1xTbyKbiQEWPoXxKTpozOUnb/XPqXXz
        1ZFNyDtszEyWQiRdUdL+BL+Lpbaq9LxZJ8pq0FtRp7NF316RQdZyIALUWwgPrUoPu7HbnmT7lLW7l
        4Sc1kIN2Q5nKuNqopaH/AFb6pzf2lsRMoT0IjE4uNYv+Jnt+x2GNXHXy8o9dz7W5GqSq1hQOh4iDX
        7X90nICtOwzSAUlH2tE+bCTfrljlBNzpkLcxybENt741E24PDgbscWTtaCwnaijie/RTNTMChOc86
        OFJC4eHQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qqTBm-00F24c-2h;
        Wed, 11 Oct 2023 06:59:26 +0000
Date:   Tue, 10 Oct 2023 23:59:26 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <ZSZHzs38Q3oqyn+Q@infradead.org>
References: <ZSAG9cedvh+B0c0E@infradead.org>
 <20231010131031.GJ3952@nvidia.com>
 <20231010094756-mutt-send-email-mst@kernel.org>
 <20231010140849.GL3952@nvidia.com>
 <20231010105339-mutt-send-email-mst@kernel.org>
 <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
 <20231010111339-mutt-send-email-mst@kernel.org>
 <20231010155937.GN3952@nvidia.com>
 <ZSY9Cv5/e3nfA7ux@infradead.org>
 <20231011021454-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231011021454-mutt-send-email-mst@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 11, 2023 at 02:43:37AM -0400, Michael S. Tsirkin wrote:
> > Btw, what is that intel thing everyone is talking about?  And why
> > would the virtio core support vendor specific behavior like that?
> 
> It's not a thing it's Zhu Lingshan :) intel is just one of the vendors
> that implemented vdpa support and so Zhu Lingshan from intel is working
> on vdpa and has also proposed virtio spec extensions for migration.
> intel's driver is called ifcvf.  vdpa composes all this stuff that is
> added to vfio in userspace, so it's a different approach.

Well, so let's call it virtio live migration instead of intel.

And please work all together in the virtio committee that you have
one way of communication between controlling and controlled functions.
If one extension does it one way and the other a different way that's
just creating a giant mess.

