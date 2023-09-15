Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6F87A1770
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 09:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbjIOH3m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 03:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjIOH3l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 03:29:41 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8931720
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 00:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694762968; x=1726298968;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=vqSqSV0hnxMFN7cPcJHLkiwDafrzR/OIFFgsA1wIytc=;
  b=cxQ1y+04wsHSTIi2CeLZW0Fqki7euUBtppyQBT4SOYyM1BjRHSGoBIY8
   FIQ3mksBUdG5nVxg/LkyX4//LY6S+3Ozoqj50whPKJd4zv44D6WH/pi+3
   QAa6ZFYN0BFPJ3aKs0wepwS3aLL+A2/5i5iBnjW/LJPlnNJMnnW++sGVe
   ntYj2Gj4f8GqaTREZHnhLmnR5qHqC2snEpS9EjYCPZPmF9dSQbPlDDJvI
   gTxStAVHGrf5SArJpr28BfVUvjRb7Msc7WkzJIp9DqN4Afk0IHyDtbJMo
   /05Ak+c3Qd7LGw+rJx+fuf3kv5uJS0cEFiccY+nxUg0VgSa+xp+NdYJmC
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="465549058"
X-IronPort-AV: E=Sophos;i="6.02,148,1688454000"; 
   d="scan'208";a="465549058"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2023 00:29:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="738234049"
X-IronPort-AV: E=Sophos;i="6.02,148,1688454000"; 
   d="scan'208";a="738234049"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orsmga007.jf.intel.com with ESMTP; 15 Sep 2023 00:29:23 -0700
Date:   Fri, 15 Sep 2023 15:40:25 +0800
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
        Babu Moger <babu.moger@amd.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v4 04/21] hw/cpu: Update the comments of nr_cores and
 nr_dies
Message-ID: <ZQQKaeReXGprHMPk@liuzhao-OptiPlex-7080>
References: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
 <20230914072159.1177582-5-zhao1.liu@linux.intel.com>
 <b6acd6c8-fffe-2826-bc02-0968af0236a1@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b6acd6c8-fffe-2826-bc02-0968af0236a1@linaro.org>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 14, 2023 at 09:32:31AM +0200, Philippe Mathieu-Daudé wrote:
> Date: Thu, 14 Sep 2023 09:32:31 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: Re: [PATCH v4 04/21] hw/cpu: Update the comments of nr_cores and
>  nr_dies
> 
> On 14/9/23 09:21, Zhao Liu wrote:
> > From: Zhao Liu <zhao1.liu@intel.com>
> > 
> > In the nr_threads' comment, specify it represents the
> > number of threads in the "core" to avoid confusion.
> > 
> > Also add comment for nr_dies in CPUX86State.
> > 
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > ---
> > Changes since v3:
> >   * The new patch split out of CPUSTATE.nr_cores' fix. (Xiaoyao)
> > ---
> >   include/hw/core/cpu.h | 2 +-
> >   target/i386/cpu.h     | 1 +
> >   2 files changed, 2 insertions(+), 1 deletion(-)
> 
> Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>

Thanks!

-Zhao
