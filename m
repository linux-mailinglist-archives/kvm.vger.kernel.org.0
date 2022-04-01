Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D00EF4EE78B
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 07:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244953AbiDAFJW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 01:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234476AbiDAFJV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 01:09:21 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263A025FD42;
        Thu, 31 Mar 2022 22:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648789653; x=1680325653;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hqvHu/vWPMwXBYJFRV8AkDoq4xnOkIf3H0wEgyrnips=;
  b=TDtN3ZXkoJA/nCoNFGzhB4OhBUAvihRkp7Gqo4GhqPtESUrpzZy5cB+f
   hOf0ayGGMRgBzz9+i4L6wAWtPml7ENFcB8ILo8lH8mjBg6fatWsG8IZWR
   GuDhabW2P+wtLMUkIKOJz4nN0eF7ayZ760a13Dkq2jA/kABtKIuC57P+0
   LQ+MAEokCBLGjRC/nX9TOlTuKurGLEUsK0VEDYiinZ0aSMFs1tSwnQ4Gf
   W3/zlhadnpGJIYGiyvesNGqco+XGEdjaAjAFh5EFbMZyRRjxW+DQr7v6m
   1IDBpwvzW11frmNSFtgznEqqeOE1rMcY9JtmkzIUK88UuJLHq19pWYFtb
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10303"; a="284970399"
X-IronPort-AV: E=Sophos;i="5.90,226,1643702400"; 
   d="scan'208";a="284970399"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 22:07:32 -0700
X-IronPort-AV: E=Sophos;i="5.90,226,1643702400"; 
   d="scan'208";a="547650151"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 22:07:29 -0700
Date:   Fri, 1 Apr 2022 13:07:26 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, Chao Gao <chao.gao@intel.com>
Subject: Re: [RFC PATCH v5 008/104] KVM: TDX: Add a function to initialize
 TDX module
Message-ID: <20220401050725.GA12103@gao-cwp>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <b92217283fa96b85e9a683ca3fcf1b368cf8d1c4.1646422845.git.isaku.yamahata@intel.com>
 <05aecc5a-e8d2-b357-3bf1-3d0cb247c28d@redhat.com>
 <20220314194513.GD1964605@ls.amr.corp.intel.com>
 <YkTvw5OXTTFf7j4y@google.com>
 <20220331170303.GA2179440@ls.amr.corp.intel.com>
 <YkYCNF3l62IxpmAD@google.com>
 <20220401032741.GA2806@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401032741.GA2806@gao-cwp>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The original reply was sent to Sean only by mistake. Add others back.

On Fri, Apr 01, 2022 at 11:27:42AM +0800, Chao Gao wrote:
>On Thu, Mar 31, 2022 at 07:34:12PM +0000, Sean Christopherson wrote:
>>+Chao Gao
>>
>>On Thu, Mar 31, 2022, Isaku Yamahata wrote:
>>> On Thu, Mar 31, 2022 at 12:03:15AM +0000, Sean Christopherson <seanjc@google.com> wrote:
>>> > On Mon, Mar 14, 2022, Isaku Yamahata wrote:
>>> > > - VMXON on all pCPUs: The TDX module initialization requires to enable VMX
>>> > > (VMXON) on all present pCPUs.  vmx_hardware_enable() which is called on creating
>>> > > guest does it.  It naturally fits with the TDX module initialization at creating
>>> > > first TD.  I wanted to avoid code to enable VMXON on loading the kvm_intel.ko.
>>> > 
>>> > That's a solvable problem, though making it work without exporting hardware_enable_all()
>>> > could get messy.
>>> 
>>> Could you please explain any reason why it's bad idea to export it?
>>
>>I'd really prefer to keep the hardware enable/disable logic internal to kvm_main.c
>>so that all architectures share a common flow, and so that kvm_main.c is the sole
>>owner.  I'm worried that exposing the helper will lead to other arch/vendor usage,
>>and that will end up with what is effectively duplicate flows.  Deduplicating arch
>>code into generic KVM is usually very difficult.
>>
>>This might also be a good opportunity to make KVM slightly more robust.  Ooh, and
>>we can kill two birds with one stone.  There's an in-flight series to add compatibility
>>checks to hotplug[*].  But rather than special case hotplug, what if we instead do
>>hardware enable/disable during module load, and move the compatibility check into
>>the hardware_enable path?  That fixes the hotplug issue, gives TDX a window for running
>>post-VMXON code in kvm_init(), and makes the broadcast IPI less wasteful on architectures
>>that don't have compatiblity checks.
>
>Sounds good. But more time is wasted on compat checks on architectures
>that have them because they are done each time of enabling hardware.
>A solution for this is caching the result of kvm_arch_check_processor_compat().
>
>>
>>I'm thinking something like this, maybe as a modificatyion to patch 6 in Chao's
>>series, or more likely as a patch 7 so that the hotplug compat checks still get
>>in even
>
>>if the early hardware enable doesn't work on all architectures for some
>>reason.
>
>By "early", do you mean hardware enable during module loading or during CPU hotplug?
>
>And if below change is put into my series, kvm_arch_post_hardware_enable_setup()
>will be an empty function for all architectures until TDX series gets merged.
>So, I prefer to drop kvm_arch_post_hardware_enable_setup() and let TDX series
>introduce it.
