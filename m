Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF407C6B23
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 12:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377791AbjJLKal (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 06:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235628AbjJLKaj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 06:30:39 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CEDD90
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 03:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697106638; x=1728642638;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hradNalj6PFxuR3qnMWgd3TgXQ0asLVDZrCofaoeVQI=;
  b=Iu1maRYcMLqbCk1YVnXA2Dur+P70uFmDRUjRhHJXA/RLpVjti6AEHqJQ
   eJhlS4ymp8Cr0T5ZOmuZbwjaYPJLGzSMj/KFDN122lLSHZFkIA/HVxQkf
   vXu4oT88wcNW2E9aOuwuCJ/izPswHt9dnhLs4aPm63tgRWKNlfig8kIPo
   V4U5U3NjQGbMxO4ZGjmUPC7Z7YXLDUSqpcZQPktRvDm8RIUkpbNWikGTx
   zq91cEM7d1A9v0kyURTHu+0o3dNuAYAaRzJmqWnHuL45BnTm4WxBi5vd6
   Iye2dB18wawejK2qsudBynyeoZPtJGOz4V4kQoU0S1DjilrPrXs6RL91D
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10860"; a="449074060"
X-IronPort-AV: E=Sophos;i="6.03,218,1694761200"; 
   d="scan'208";a="449074060"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2023 03:30:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10860"; a="820085773"
X-IronPort-AV: E=Sophos;i="6.03,218,1694761200"; 
   d="scan'208";a="820085773"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.93.29.0]) ([10.93.29.0])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2023 03:30:35 -0700
Message-ID: <3aaec14f-6b54-6a4c-7fb3-49120607c42c@intel.com>
Date:   Thu, 12 Oct 2023 18:30:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.15.1
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over virtio
 device
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, maorg@nvidia.com,
        virtualization@lists.linux-foundation.org,
        Jason Gunthorpe <jgg@nvidia.com>, jiri@nvidia.com,
        leonro@nvidia.com
References: <ZSAG9cedvh+B0c0E@infradead.org>
 <20231010131031.GJ3952@nvidia.com>
 <20231010094756-mutt-send-email-mst@kernel.org>
 <20231010140849.GL3952@nvidia.com>
 <20231010105339-mutt-send-email-mst@kernel.org>
 <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
 <20231010111339-mutt-send-email-mst@kernel.org>
 <20231010155937.GN3952@nvidia.com> <ZSY9Cv5/e3nfA7ux@infradead.org>
 <20231011021454-mutt-send-email-mst@kernel.org>
 <ZSZHzs38Q3oqyn+Q@infradead.org>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <ZSZHzs38Q3oqyn+Q@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/11/2023 2:59 PM, Christoph Hellwig wrote:
> On Wed, Oct 11, 2023 at 02:43:37AM -0400, Michael S. Tsirkin wrote:
>>> Btw, what is that intel thing everyone is talking about?  And why
>>> would the virtio core support vendor specific behavior like that?
>> It's not a thing it's Zhu Lingshan :) intel is just one of the vendors
>> that implemented vdpa support and so Zhu Lingshan from intel is working
>> on vdpa and has also proposed virtio spec extensions for migration.
>> intel's driver is called ifcvf.  vdpa composes all this stuff that is
>> added to vfio in userspace, so it's a different approach.
> Well, so let's call it virtio live migration instead of intel.
>
> And please work all together in the virtio committee that you have
> one way of communication between controlling and controlled functions.
> If one extension does it one way and the other a different way that's
> just creating a giant mess.
I hope so, Jason Wang has proposed a solution to cooperate, but sadly
rejected...
>
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization

