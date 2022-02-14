Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF1174B4CDA
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 12:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349344AbiBNKtt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 05:49:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349252AbiBNKtS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 05:49:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8D2BF95C;
        Mon, 14 Feb 2022 02:12:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B2D6B80DC7;
        Mon, 14 Feb 2022 10:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D67CC340E9;
        Mon, 14 Feb 2022 10:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644833544;
        bh=x2ADvJVG4KISFTdwFK99lBGP04AokizyuA6ZhikneHU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kK6EkXGq8VYPwLoeolFaXsCgFxfGMmowLgTxRLi9LN+dbxfJ2rV1sfcrrYgvsZ/uB
         SsConmaBs7UjyorHV8yh/I/pqtpoBKPrzh7kixUlfOIUkLhi/UcAKOUJXz8lEEqd08
         N1XtTH/bg9bAP+6emhv0mT0XTG/WfXlxj7/I8mXg=
Date:   Mon, 14 Feb 2022 11:01:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 02/14] driver core: Add dma_cleanup callback in
 bus_type
Message-ID: <YgooeYOdMFrKFdrF@kroah.com>
References: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
 <20220104015644.2294354-3-baolu.lu@linux.intel.com>
 <YdQcpHrV7NwUv+qc@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdQcpHrV7NwUv+qc@infradead.org>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 04, 2022 at 02:08:36AM -0800, Christoph Hellwig wrote:
> All these bus callouts still looks horrible and just create tons of
> boilerplate code.

I can't remember anymore what one vs. the other looks like.  Having an
explicit "opt-in" for a bus is good, in that no code breaks and only if
you want to use this do you have to set the flag.  Why do you want it to
be "always"?

thanks,

greg k-h
