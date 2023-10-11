Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F27B7C49C0
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 08:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344315AbjJKGNf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 02:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344090AbjJKGNe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 02:13:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958519B
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 23:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IX27illEM0WweUTVOw4Uowp/Sqp2/Whl4YtFtbVzV5Y=; b=F3lj47MdMB0oq0H5JFTSNI6gvA
        ubLRNT8vNIjkn2kvTZF2/XsHJA9TqceLMoAS9qFiOLo0ke5bnaBWiHJFjne04eImAdr3jaLngXoxk
        S1dc7DWwwa82G3b1DT5OlaqYbd1YD2wuZ86EolXttP20uTpMsuZgCDQhK+BQ7oeWyirjWZEEOPlWV
        zk/7kPZ1qlWCxaXJB7El4b2g+e3KyLXUATTQD1IHCJga0OUL9x/KqyYuxylV4D6kgy7iLX1GMphQ6
        XKfRBYhIzZqw4Gz6tqn00fg/+GoVaUuT9Ciogc/n8zGeKdo8emRvHTgN5nF5XKKsAYBicKWyfhJ75
        NVMEzpyQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qqSTK-00Euyf-2N;
        Wed, 11 Oct 2023 06:13:30 +0000
Date:   Tue, 10 Oct 2023 23:13:30 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        alex.williamson@redhat.com, jasowang@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <ZSY9Cv5/e3nfA7ux@infradead.org>
References: <ZR54shUxqgfIjg/p@infradead.org>
 <20231005111004.GK682044@nvidia.com>
 <ZSAG9cedvh+B0c0E@infradead.org>
 <20231010131031.GJ3952@nvidia.com>
 <20231010094756-mutt-send-email-mst@kernel.org>
 <20231010140849.GL3952@nvidia.com>
 <20231010105339-mutt-send-email-mst@kernel.org>
 <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
 <20231010111339-mutt-send-email-mst@kernel.org>
 <20231010155937.GN3952@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231010155937.GN3952@nvidia.com>
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

On Tue, Oct 10, 2023 at 12:59:37PM -0300, Jason Gunthorpe wrote:
> On Tue, Oct 10, 2023 at 11:14:56AM -0400, Michael S. Tsirkin wrote:
> 
> > I suggest 3 but call it on the VF. commands will switch to PF
> > internally as needed. For example, intel might be interested in exposing
> > admin commands through a memory BAR of VF itself.
> 
> FWIW, we have been pushing back on such things in VFIO, so it will
> have to be very carefully security justified.
> 
> Probably since that is not standard it should just live in under some
> intel-only vfio driver behavior, not in virtio land.

Btw, what is that intel thing everyone is talking about?  And why
would the virtio core support vendor specific behavior like that?

