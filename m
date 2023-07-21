Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5757075D2A1
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 21:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbjGUTBz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 15:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbjGUTBy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 15:01:54 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C07130DD
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 12:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689966111; x=1721502111;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mz1f5O8eA+QYFmDBVIZ51SFYrvG7QvxxAJG4IJ+mS58=;
  b=QuDwSJAlaseJAXZ8Oli909kMjf5xrEVntoCzAGnG3SDMh1JlSWLQ2S/0
   a+ErskY5FLOFLr7O9tzm5pnpFevr6nopwiF6olC4IkuKDwXfib6eEH3mX
   qwG2bxeQBN2G91kK4nq3v0+3xWm1ITioF4XDlxGKa2x4dlVmKwFr9nTr/
   lVw8cQpL0NhkubUTDhmiiMO77M4pVMo+VTtDAnYaoq5PJjejexE4T3r0i
   VqbzhwnRTV9t4xr3Pmn1gpmNNkm82dh4oQhB6iKUkT7HbNcvwRnmxfsS9
   ZjAAe+l+OLPvyddctWXXBNU0ypJGF92SSD3RbPPWY6Tt+t85mHdpwRPuf
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10778"; a="430888622"
X-IronPort-AV: E=Sophos;i="6.01,222,1684825200"; 
   d="scan'208";a="430888622"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2023 12:01:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10778"; a="795059211"
X-IronPort-AV: E=Sophos;i="6.01,222,1684825200"; 
   d="scan'208";a="795059211"
Received: from liyuexin-mobl.amr.corp.intel.com (HELO desk) ([10.255.230.166])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2023 12:01:22 -0700
Date:   Fri, 21 Jul 2023 12:01:14 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: KVM's sloppiness wrt IA32_SPEC_CTRL and IA32_PRED_CMD
Message-ID: <20230721190114.xznm7xfnuxciufa3@desk>
References: <CALMp9eRQeZESeCmsiLyxF80Bsgp2r54eSwXC+TvWLQAWghCdZg@mail.gmail.com>
 <529cd705-f5c3-a5d1-9999-a3d2ccd09dd6@intel.com>
 <ZLiUrP9ZFMr/Wf4/@chao-email>
 <CALMp9eTQ5zDpjK+=e+Rhu=zvLv_f0scqkUCif2tveq+ahTAYCg@mail.gmail.com>
 <ZLjqVszO4AMx9F7T@chao-email>
 <CALMp9eSw9g0oRh7rT=Nd5aTwiu_zMz21tRrZG5D_QEfTn1h=HQ@mail.gmail.com>
 <ZLn9hgQy77x0hLil@chao-email>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZLn9hgQy77x0hLil@chao-email>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 21, 2023 at 11:37:42AM +0800, Chao Gao wrote:
> On Thu, Jul 20, 2023 at 10:52:44AM -0700, Jim Mattson wrote:
> >> And is it fair to good citizens that won't set reserved bits but will
> >> suffer performance drop caused by the fix?
> >
> >Is it fair to other tenants of the host to have their data exfiltrated
> >by a bad citizen, because KVM didn't control access to the MSR?
> 
> To be clear, I agree to intercept IA32_SPEC_CTRL MSR if allowing guests
> to clear some bits puts host or other tenents at risk.
> 
> >> >As your colleague pointed out earlier, IA32_SPEC_CTRL.STIBP[bit 1] is
> >> >such a bit. If the host has this bit set and you allow the guest to
> >> >clear it, then you have compromised host security.
> 
> ...
> 
> >>
> >> If guest can compromise host security, I definitly agree to intercept
> >> IA32_SPEC_CTRL MSR.
> >
> >I believe that when the decision was made to pass through this MSR for
> >write, the assumption was that the host wouldn't ever use it (hence
> >the host value would be zero). That assumption has not stood the test
> >of time.
> 
> Could you elaborate on the security risk of guests' clearing
> IA32_SPEC_CTRL.STIBP[bit 1] (or any other bit)? +Pawan

Please note that clearing STIBP bit on one thread does not disable STIBP
protection if the sibling has it set:

  Setting bit 1 (STIBP) of the IA32_SPEC_CTRL MSR on a logical processor
  prevents the predicted targets of indirect branches on any logical
  processor of that core from being controlled by software that executes
  (or executed previously) on another logical processor of the same core
  [1].

Also IBRS on Intel parts automatically provides STIBP protection:

  Section 2.4.1.2. IBRS: Support Based on Software Enabling [2]:

  when IA32_SPEC_CTRL.IBRS is set to 1 on any logical processors of that
  core, the predicted targets of indirect branches cannot be controlled by
  software that executes (or executed previously) on another logical
  processor of the same core.

  Section 2.4.2. Single Thread Indirect Branch Predictors (STIBP)[2]:

  Enabling IBRS prevents software operating on one logical processor
  from controlling the predicted targets of indirect branches executed
  on another logical processor. For that reason, it is not necessary to
  enable STIBP when IBRS is enabled.

So a guest disabling STIBP on one thread does not pose a security risk
to the sibling if the sibling has either STIBP or IBRS set. Note that
sensitive applications can always choose to have STIBP set for them via
the prctl() interface.

[1] https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/single-thread-indirect-branch-predictors.html

[2] https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/speculative-execution-side-channel-mitigations.html#IBRS
