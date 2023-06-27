Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8311973F3BF
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 06:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjF0EvX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 00:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjF0EvV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 00:51:21 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CDE1EB
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 21:51:20 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id C38146732D; Tue, 27 Jun 2023 06:51:16 +0200 (CEST)
Date:   Tue, 27 Jun 2023 06:51:16 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>, kvm@vger.kernel.org,
        Alexander Egorenkov <egorenar@linux.ibm.com>
Subject: Re: [PATCH] vfio/mdev: Move the compat_class initialization to
 module init
Message-ID: <20230627045116.GA16878@lst.de>
References: <20230626133642.2939168-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230626133642.2939168-1-farman@linux.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yeah, this is the structure that the code should have had since the
very beginning:

Reviewed-by: Christoph Hellwig <hch@lst.de>
