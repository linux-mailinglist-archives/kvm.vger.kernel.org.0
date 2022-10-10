Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5955F9990
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 09:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbiJJHOJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 03:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231703AbiJJHMj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 03:12:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C437A5A2C2
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 00:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7gupS0rXYC6sIsEkmKp1q30UcCl4CiVyBak68KOL5oM=; b=4UKNobK96+XvBOru6iEaPa7jJo
        PapALCnv6d2j22vLkMKsJgCgURpkNgizOG7gLnRmxCBY3YLEXXhpdz+9edn9Llpmxnj+do9VkG2wx
        5t2mATLVM/Z4S3Dq2Rqqkoy2MiQvZSgxw4KK6lb3NXsWKGeDbfwEyfCiAxG1SfVN8djeEwyOWCLLY
        vk/2x6vc77QEy6aCFG8Y8Nx7kut2W3YK6zPOE6+nlhNBea5qFm7ya7s0dDib0RSFSCNuDXB65VL5S
        y6G4rAGXU6NWi8exWhkmHDXGJUIyYMLvFm+QFY2sAQVY7h5NjfDk+NGmU3zGuP/GLvPGysgL7PeZM
        XHtfhOKg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ohmsd-00HKEi-EF; Mon, 10 Oct 2022 07:07:15 +0000
Date:   Mon, 10 Oct 2022 00:07:15 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/4] vfio/pci: Move all the SPAPR PCI specific logic
 to vfio_pci_core.ko
Message-ID: <Y0PEo+K+Q7fkcMcB@infradead.org>
References: <0-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
 <1-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 03, 2022 at 12:39:30PM -0300, Jason Gunthorpe wrote:
> The vfio_spapr_pci_eeh_open/release() functions are one line wrappers
> around an arch function. Just make them static inline and move them into
> vfio_pci_priv.h.

Please just kill them entirely - the vfio spapr code depends on EEH
anyway.  In fact I have an old patch to do that floating around
somewhere, but it's probably less work to just recreate it.
