Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B678512858
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 02:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239604AbiD1BBv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 21:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbiD1BBu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 21:01:50 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB00BE24;
        Wed, 27 Apr 2022 17:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651107517; x=1682643517;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ibHcxG9AHdP/Hj3kBOm8zboMb+9SC8cFbK9QS2LtEU4=;
  b=M/qLkpK33ycDu9Wi+t/TWufAY3fUdrxIydEkKL7tEbAljzAyudBGAwh6
   UMvOTRTpVK4sYPZR9wICGa7ltE/IUOlvZnDV3NnU6DIVBMh/s0Y7SmJDV
   f4Q8k/8Bj0+VNH17Gm1oeeI/LUISucInnFYjRbJ5GnJ22XqiIoHNJsdyf
   u62GxiYJmto+IGjsB+sjyGcXWX2nF6eUsd6NhKou63MEHQEFwOga/p8mP
   bTv+tg/KRajx4TnGyE2SY4Ug7IZ+AqP0PUNdO5F8ZWPxqxf46aOQ5K9FW
   2t54dGpS6j8sxAHSfW6Uo8xWpB2w+dZ9xgUkKiEiRV6flsqH7P4I0LS2x
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="329063334"
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="329063334"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 17:58:37 -0700
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="596551591"
Received: from rrnambia-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.60.78])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 17:58:34 -0700
Message-ID: <c90a10763969077826f42be6f492e3a3e062326b.camel@intel.com>
Subject: Re: [PATCH v3 00/21] TDX host kernel support
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Date:   Thu, 28 Apr 2022 12:58:31 +1200
In-Reply-To: <d98ca73b-2d2d-757d-e937-acc83cfedfb0@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <522e37eb-68fc-35db-44d5-479d0088e43f@intel.com>
         <ecf718abf864bbb2366209f00d4315ada090aedc.camel@intel.com>
         <de24ac7e-349c-e49a-70bb-31b9bc867b10@intel.com>
         <9b388f54f13b34fe684ef77603fc878952e48f87.camel@intel.com>
         <d98ca73b-2d2d-757d-e937-acc83cfedfb0@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-04-27 at 17:50 -0700, Dave Hansen wrote:
> On 4/27/22 17:37, Kai Huang wrote:
> > On Wed, 2022-04-27 at 14:59 -0700, Dave Hansen wrote:
> > > In 5 years, if someone takes this code and runs it on Intel hardware
> > > with memory hotplug, CPU hotplug, NVDIMMs *AND* TDX support, what happens?
> > 
> > I thought we could document this in the documentation saying that this code can
> > only work on TDX machines that don't have above capabilities (SPR for now).  We
> > can change the code and the documentation  when we add the support of those
> > features in the future, and update the documentation.
> > 
> > If 5 years later someone takes this code, he/she should take a look at the
> > documentation and figure out that he/she should choose a newer kernel if the
> > machine support those features.
> > 
> > I'll think about design solutions if above doesn't look good for you.
> 
> No, it doesn't look good to me.
> 
> You can't just say:
> 
> 	/*
> 	 * This code will eat puppies if used on systems with hotplug.
> 	 */
> 
> and merrily await the puppy bloodbath.
> 
> If it's not compatible, then you have to *MAKE* it not compatible in a
> safe, controlled way.
> 
> > > You can't just ignore the problems because they're not present on one
> > > version of the hardware.
> 
> Please, please read this again ^^

OK.  I'll think about solutions and come back later.

> 
> > > What about all the concerns about TDX module configuration changing?
> > 
> > Leaving the TDX module in fully initialized state or shutdown state (in case of
> > error during it's initialization) to the new kernel is fine.  If the new kernel
> > doesn't use TDX at all, then the TDX module won't access memory using it's
> > global TDX KeyID.  If the new kernel wants to use TDX, it will fail on the very
> > first SEAMCALL when it tries to initialize the TDX module, and won't use
> > SEAMCALL to call the TDX module again.  If the new kernel doesn't follow this,
> > then it is a bug in the new kernel, or the new kernel is malicious, in which
> > case it can potentially corrupt the data.  But I don't think we need to consider
> > this as if the new kernel is malicious, then it can corrupt data anyway.
> > 
> > Does this make sense?
> 
> No, I'm pretty lost.  But, I'll look at the next version of this with
> fresh eyes and hopefully you'll have had time to streamline the text by
> then.

OK thanks.

-- 
Thanks,
-Kai


