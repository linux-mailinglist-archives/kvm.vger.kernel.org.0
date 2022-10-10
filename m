Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C57105F9A32
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 09:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbiJJHmE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 03:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbiJJHlW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 03:41:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91AB067444
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 00:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1686to798xPx4oLSR3xk3E9rKEVWg2gZyMFjBE+Fn30=; b=1D44zkQfJqP8lm9mFFjjZUW8vV
        Si6QLEJvajq1xFtfOlSLEMFJ2G828xOUS/TcFbpxA0ykNZaFx8FdEw0t3OoZHkL2pt/40jwH8NyVm
        +kq4v9rRYBqq6kZUbEabVcxBNbHHQFoV8FtZY2Y/oacZ8CjMBwRa7RgYUMlBWg/jgAoxlJ4ypwbMR
        zNalCVn9uBrTCFfy0/vkxvh5Iy2BLtQKztrF3YbqRI2o5XOissmC11jffy9NmE7qoGdB9sXXMLFss
        GbAX1zW1RzGav2PZlO+6cIzJJj3mm9Pc7u/4YYaLfdKsfYOMAPkenTKtPGsqHg34KIfa38oEA4PBV
        steL7PtQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ohmyD-00HLn3-Ez; Mon, 10 Oct 2022 07:13:01 +0000
Date:   Mon, 10 Oct 2022 00:13:01 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 4/4] vfio: Fold vfio_virqfd.ko into vfio.ko
Message-ID: <Y0PF/fcZ/6gzy1JL@infradead.org>
References: <0-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
 <4-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 03, 2022 at 12:39:33PM -0300, Jason Gunthorpe wrote:
> This is only 1.8k, putting it in its own module is going to waste more
> space rounding up to a PAGE_SIZE than it is worth. Put it in the main
> vfio.ko module now that kbuild can support multiple .c files.

Assuming you actually need it (only vfio_platform and vfio_pci actually
need it) and you don't otherwise need EVENTFD support.  While I guess
the configfs that do not fit the above aren't the most common they
are real and are a real tradeoff.
