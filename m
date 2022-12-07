Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6AB9645F08
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 17:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiLGQfR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 11:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiLGQfP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 11:35:15 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EA356560;
        Wed,  7 Dec 2022 08:35:13 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id DC7F367373; Wed,  7 Dec 2022 17:35:06 +0100 (CET)
Date:   Wed, 7 Dec 2022 17:35:06 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Lei Rao <lei.rao@intel.com>, kbusch@kernel.org, axboe@fb.com,
        kch@nvidia.com, sagi@grimberg.me, alex.williamson@redhat.com,
        cohuck@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        mjrosato@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, kvm@vger.kernel.org,
        eddie.dong@intel.com, yadong.li@intel.com, yi.l.liu@intel.com,
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH 1/5] nvme-pci: add function nvme_submit_vf_cmd to
 issue admin commands for VF driver.
Message-ID: <20221207163506.GA2010@lst.de>
References: <20221206135810.GA27689@lst.de> <Y49eObpI7QoSnugu@ziepe.ca> <20221206153811.GB2266@lst.de> <Y49k++D3i8DfLOLL@ziepe.ca> <20221206165503.GA8677@lst.de> <Y4+U3VR2LeEh2S7B@ziepe.ca> <20221207075415.GB2283@lst.de> <4f11e0bb-e090-bf9b-4f98-578273865200@nvidia.com> <20221207134644.GB21691@lst.de> <d28a7848-b284-6c86-a2ae-ab79de3675d4@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d28a7848-b284-6c86-a2ae-ab79de3675d4@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 07, 2022 at 04:50:00PM +0200, Max Gurtovoy wrote:
> When we perform step #3 we are narrowing it's scope and maybe some caps 
> that you're concerned of. After this setting, the controlled function is in 
> LM mode (we should define what does that mean in order to be able to 
> migrate it correctly) and the controlling function is the migration master 
> of it. Both can be aware of that. The only one that can master the 
> controlled function is the controlling function in LM mode. Thus, it will 
> be easy to keep that handle inside the kernel for VFs and for MDEVs as 
> well.

Maybe.  So you'd introduce a kernel linkage that both side would have
to be part of?
