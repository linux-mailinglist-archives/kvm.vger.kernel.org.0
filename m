Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56EE17D6D30
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 15:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344661AbjJYNbJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 09:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235018AbjJYNaz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 09:30:55 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98269182
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 06:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698240653; x=1729776653;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=olQ2ezotKWBDA6Of1wjDTlEYLDQ2rg4kphj/Smcpnw4=;
  b=LEeXIa84BfhK3iVxjd+MI2PmAt98762/343JH9rKRo8qmLVEykwyrSEV
   +gAjK9sDtWPnMvLYPgscwecOw5GmihZaYnzMa3ck8XA/YAbLDvQSVscL4
   Okw+7onXZDmdWQzJUxV2s/j5xbPckvgqGxjjxg15EWzd4QG2Gn0JBh8ga
   t8ESmUAKi5Vvw4SqbWsi9ivA3dZINXQxBcKJ4KMNLNMYfZL1Y/rwrYGMl
   fLE5CiuJ1rAsouwItTdfmHoK7nMEGmyHvniRfeuen2VImqhnTyYacu2Wr
   t6iNVTstK6m4iGMH6yqILSxshLHUYxcrn5yn6bFdWTFCXe0SGGPQ9fJ5w
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10874"; a="453775528"
X-IronPort-AV: E=Sophos;i="6.03,250,1694761200"; 
   d="scan'208";a="453775528"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 06:30:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,250,1694761200"; 
   d="scan'208";a="6839921"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa001.fm.intel.com with ESMTP; 25 Oct 2023 06:30:41 -0700
Date:   Wed, 25 Oct 2023 21:42:29 +0800
From:   Zhao Liu <zhao1.liu@linux.intel.com>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc:     Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Zhenyu Wang <zhenyu.z.wang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Babu Moger <babu.moger@amd.com>,
        Yongwei Ma <yongwei.ma@intel.com>,
        Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v5 00/20] Support smp.clusters for x86 in QEMU
Message-ID: <ZTkbRUTvdULkDbZU@intel.com>
References: <20231024090323.1859210-1-zhao1.liu@linux.intel.com>
 <9a8e0ab9-48cf-777b-92ac-cd515eec0cf9@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9a8e0ab9-48cf-777b-92ac-cd515eec0cf9@linaro.org>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 25, 2023 at 12:04:12PM +0200, Philippe Mathieu-Daudé wrote:
> Date: Wed, 25 Oct 2023 12:04:12 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: Re: [PATCH v5 00/20] Support smp.clusters for x86 in QEMU
> 
> Hi Zhao,
> 
> On 24/10/23 11:03, Zhao Liu wrote:
> > From: Zhao Liu <zhao1.liu@intel.com>
> > 
> > Hi list,
> > 
> > This is the our v5 patch series, rebased on the master branch at the
> > commit 384dbdda94c0 ("Merge tag 'migration-20231020-pull-request' of
> > https://gitlab.com/juan.quintela/qemu into staging").
> 
> Since the 4 first patches are not x86-specific (and are Acked
> by Michael), I'll queue them to shorten your series. I'll let
> Paolo look at the rest.

Thanks Philippe!

-Zhao

