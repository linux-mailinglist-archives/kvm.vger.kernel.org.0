Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8DC451284C
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 02:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238601AbiD1Axl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 20:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238547AbiD1Axh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 20:53:37 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 990075F242;
        Wed, 27 Apr 2022 17:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651107023; x=1682643023;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ftKko8hp3u4j+pAON3LHYDZNP7jOD3MOWDTywquN4O0=;
  b=GwkrA2TnqWcZz24HAGXt/HW16IsG1MGO0XEpOGd5FvJfHKHAlWcaUazG
   5YqGBjTJCvx+a/5KnR55BiLVJbvsMIrOBCcIbVjBCHuvguQpdICFSab8U
   HrC/fS3lULOvoWBs2U8MatBmsfNiHtKvk6AK089E7bFKdoXUSH6++Xs7R
   QAUWd8MjtoDo+PZCec0QyDqxNrIzX8rvLxY1FUdhcua+yhaNs94ehGlr7
   dExT576pUL11U4oBqHq4WVU7R+I/zVDn+6hZSXs7rom1a5o9wRWYxNUu4
   d8uW2NUklHKO1HUUIXvTU8eWO9PEq2MuONLmOtC6wt96t35EEsolCZHoJ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="253500432"
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="253500432"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 17:50:23 -0700
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="513979915"
Received: from lcdaughe-mobl1.amr.corp.intel.com (HELO [10.212.72.252]) ([10.212.72.252])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 17:50:22 -0700
Message-ID: <d98ca73b-2d2d-757d-e937-acc83cfedfb0@intel.com>
Date:   Wed, 27 Apr 2022 17:50:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 00/21] TDX host kernel support
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
References: <cover.1649219184.git.kai.huang@intel.com>
 <522e37eb-68fc-35db-44d5-479d0088e43f@intel.com>
 <ecf718abf864bbb2366209f00d4315ada090aedc.camel@intel.com>
 <de24ac7e-349c-e49a-70bb-31b9bc867b10@intel.com>
 <9b388f54f13b34fe684ef77603fc878952e48f87.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <9b388f54f13b34fe684ef77603fc878952e48f87.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/27/22 17:37, Kai Huang wrote:
> On Wed, 2022-04-27 at 14:59 -0700, Dave Hansen wrote:
>> In 5 years, if someone takes this code and runs it on Intel hardware
>> with memory hotplug, CPU hotplug, NVDIMMs *AND* TDX support, what happens?
> 
> I thought we could document this in the documentation saying that this code can
> only work on TDX machines that don't have above capabilities (SPR for now).  We
> can change the code and the documentation  when we add the support of those
> features in the future, and update the documentation.
> 
> If 5 years later someone takes this code, he/she should take a look at the
> documentation and figure out that he/she should choose a newer kernel if the
> machine support those features.
> 
> I'll think about design solutions if above doesn't look good for you.

No, it doesn't look good to me.

You can't just say:

	/*
	 * This code will eat puppies if used on systems with hotplug.
	 */

and merrily await the puppy bloodbath.

If it's not compatible, then you have to *MAKE* it not compatible in a
safe, controlled way.

>> You can't just ignore the problems because they're not present on one
>> version of the hardware.

Please, please read this again ^^

>> What about all the concerns about TDX module configuration changing?
> 
> Leaving the TDX module in fully initialized state or shutdown state (in case of
> error during it's initialization) to the new kernel is fine.  If the new kernel
> doesn't use TDX at all, then the TDX module won't access memory using it's
> global TDX KeyID.  If the new kernel wants to use TDX, it will fail on the very
> first SEAMCALL when it tries to initialize the TDX module, and won't use
> SEAMCALL to call the TDX module again.  If the new kernel doesn't follow this,
> then it is a bug in the new kernel, or the new kernel is malicious, in which
> case it can potentially corrupt the data.  But I don't think we need to consider
> this as if the new kernel is malicious, then it can corrupt data anyway.
> 
> Does this make sense?

No, I'm pretty lost.  But, I'll look at the next version of this with
fresh eyes and hopefully you'll have had time to streamline the text by
then.
