Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDC6502C05
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 16:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354588AbiDOOj0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 10:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349869AbiDOOjZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 10:39:25 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C7548303
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 07:36:57 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7C87768C7B; Fri, 15 Apr 2022 16:36:54 +0200 (CEST)
Date:   Fri, 15 Apr 2022 16:36:53 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH 02/10] kvm/vfio: Reduce the scope of PPC #ifdefs
Message-ID: <20220415143653.GB1958@lst.de>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com> <2-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com> <20220415044731.GB22209@lst.de> <20220415121343.GI2120790@nvidia.com> <20220415123504.GK2120790@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415123504.GK2120790@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 15, 2022 at 09:35:04AM -0300, Jason Gunthorpe wrote:
> Actually, it defeats the whole point of this patch. I wrote it so I
> could compile test all this stuff on x86 - if I shift it into a
> vfio_ppc.c and make some kconfig stuff then it still won't compile
> test on x86.
> 
> At that point I'd rather leave the ifdefs as-is and drop this patch.
> 
> Yes, the #ifdef is ugly, but this whole PPC thing is ugly :\

I'd rather leave it as is then.

