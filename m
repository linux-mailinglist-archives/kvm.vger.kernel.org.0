Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 368C564D1CA
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 22:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiLNV25 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 16:28:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiLNV24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 16:28:56 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7917316;
        Wed, 14 Dec 2022 13:28:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671053335; x=1702589335;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BfyZ0wbnXjjKIR9uhDPYIesZqV9+mxpLj1ZhNhI6kxY=;
  b=dALwBPuE6ZF1B4iHZeRrdFgFwBAG0qf7aHiUw4IMRfQGSnjeYvwUVzur
   csTIYIUXh2qo+XAtNawXvzb7jZkkMkrlZsFezH+KPaAyzeoFaU9s3nNn6
   +gbjDtd9Mi/7o4+jwVX83JSmQLkc68mFu2IBfcQD6LKqOC5wyqWIEQ3pj
   diueNQMzy7dKoqki7vnzjmQ1/4OiEWCPcCwdY1Z9HOy9R+CGlSq5cw9gI
   k9hPHTM3HunjB6vFqmnHI2irc/A65f/9uXUlbN5FfPUJkOlJrnbWRrYzC
   ZxEyzdbi/ZBym1FqADEFoVsaMau3n3AMaRr7opwOtqlSuewQzgH8Bd/rl
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="301927111"
X-IronPort-AV: E=Sophos;i="5.96,245,1665471600"; 
   d="scan'208";a="301927111"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 13:28:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="599341833"
X-IronPort-AV: E=Sophos;i="5.96,245,1665471600"; 
   d="scan'208";a="599341833"
Received: from ranerica-svr.sc.intel.com ([172.25.110.23])
  by orsmga003.jf.intel.com with ESMTP; 14 Dec 2022 13:28:54 -0800
Date:   Wed, 14 Dec 2022 13:37:07 -0800
From:   Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
To:     Zhang Chen <chen.zhang@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Chao Gao <chao.gao@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 3/9] KVM: x86: Add a kvm-only leaf for BHI_CTRL
Message-ID: <20221214213707.GC16072@ranerica-svr.sc.intel.com>
References: <20221210160046.2608762-1-chen.zhang@intel.com>
 <20221210160046.2608762-4-chen.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221210160046.2608762-4-chen.zhang@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Dec 11, 2022 at 12:00:40AM +0800, Zhang Chen wrote:
> KVM needs to check if guests can see BHI_CTRL. If a guest is using
> BHB-clearing sequence and cannot see BHI_CTRL and the host enumerates BHI,
> KVM is responsible for setting BHI_DIS_S for the guest.
> 
> This allows VM migration from parts doesn't enumerate BHI to those
> that enumerate BHI.

Similar comment as in patch 2.
