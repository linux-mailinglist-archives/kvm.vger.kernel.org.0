Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A44A4EA5C2
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 05:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbiC2DMg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 23:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbiC2DMe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 23:12:34 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4A823DE92;
        Mon, 28 Mar 2022 20:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648523452; x=1680059452;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FMMPTBKB75Ni5yGfK4sTBPJjLiQ1Oz9Onw+uBAgTlqg=;
  b=S6Mhl8GMXXMNXkCJAy5HDMJZaHvfuiPe9eIItqnsq8qfTcXQK1yI077O
   lomBg++TPUNVmyCGB4Kbel667X+NvANM8m9CTr6h5rk2MnyKfi0QE6A9q
   QAr8I9qwHEW8Z9CjOOl2qhdyYIC8yRX9NqjlWt18gOCNYlMhxCsN2jQvv
   7ljFiNHTSmf9F6UDt3pxdCjf6A1LhOyHMED3SG0nBmosrqf0vWLL5DZDm
   +MaEma2n5qmgdxRjxAiCNaeUBJQmbIdk0n/+8jnSDtBjJISK3Q24zjeWy
   qS6fLoYhoUofzJi9YYdrmEZ+fA8JUEDryus+lJpZMVUBBoBUvMJA0sEFV
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10300"; a="345585914"
X-IronPort-AV: E=Sophos;i="5.90,219,1643702400"; 
   d="scan'208";a="345585914"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 20:10:52 -0700
X-IronPort-AV: E=Sophos;i="5.90,219,1643702400"; 
   d="scan'208";a="719358482"
Received: from rmsatyan-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.94.240])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 20:10:48 -0700
Message-ID: <15c0212fc4ff591a878369ea6ae964e43574a8d9.camel@intel.com>
Subject: Re: [PATCH v2 04/21] x86/virt/tdx: Add skeleton for detecting and
 initializing TDX on demand
From:   Kai Huang <kai.huang@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Gleixner, Thomas" <thomas.gleixner@intel.com>
Cc:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Date:   Tue, 29 Mar 2022 16:10:46 +1300
In-Reply-To: <BN9PR11MB5276C837FE25BACCD53DB5D58C1E9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1647167475.git.kai.huang@intel.com>
         <279af00f90a93491d5ec86672506146153909e5c.1647167475.git.kai.huang@intel.com>
         <BL1PR11MB52713CA82D52248B0905C91D8C189@BL1PR11MB5271.namprd11.prod.outlook.com>
         <a68b378a40310c38f731f4bc7f0a9cc0d89efe92.camel@intel.com>
         <BN9PR11MB52760B743E208684A098B61C8C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
         <b4d97c46c52dbbecc6061f743b172015a73ec189.camel@intel.com>
         <BN9PR11MB52761E8DE55DC8872EC093758C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
         <8f85e6ad76508e0b7ac8667b1c0b7b3b43d67ef8.camel@intel.com>
         <BN9PR11MB5276C837FE25BACCD53DB5D58C1E9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> > > 
> > > *all cpus* is questionable.
> > > 
> > > Say BIOS enabled 8 CPUs: [0 - 7]
> > > 
> > > cpu_present_map covers [0 - 5], due to nr_cpus=6
> > > 
> > > You compared cpus_booted_once_mask to cpu_present_mask so if
> > maxcpus
> > > is set to a number < nr_cpus SEAMRR is considered disabled because you
> > > cannot verify CPUs between [max_cpus, nr_cpus).

Sorry my bad.  We can verify CPUs between [max_cpus, nr_cpus).  When any cpu
within that range becomes online, the detection code is run.  The paranoid check
in seamrr_enabled() is used to check whether all cpus within [max_cpus, nr_cpus)
(if there's any -- cpus within [0, max_cpus) are up during boot) have been
brought up at least once. 

> > 
> > SEAMRR is not considered as disabled in this case, at least in my intention.
> 
> the function is called seamrr_enabled(), and false is returned if above
> check is not passed. So it is the intention from the code.

The false is returned if something error is discovered among cpus [0 -
present_cpus].  It returns true even if we cannot verify [present_cpus,
bios_enabled_cpus).

> 
> > My
> > understanding on the spec is if SEAMRR is configured as enabled on one core
> > (the
> > SEAMRR MSRs are core-scope), the SEAMCALL instruction can work on that
> > core.  It
> > is TDX's requirement that some SEAMCALL needs to be done on all BIOS-
> > enabled
> > CPUs to finish TDX initialization, but not SEAM's.
> > 
> > From this perspective, if we forget TDX at this moment but talk about SEAM
> > alone, it might make sense to not just treat SEAMRR as disabled if kernel
> > usable
> > cpus are limited by 'nr_cpus'.  The chance that BIOS misconfigured SEAMRR is
> > really rare.  If kernel can detect potential BIOS misconfiguration, it
> > should do
> > it.  Otherwise, perhaps it's more reasonable not to just treat SEAM as
> > disabled.
> 
> My problem is just that you didn't adopt consistency policy for CPUs in
> [maxcpus, nr_cpus) and CPUs in [nr_cpus, nr_bios_enabled_cpus). This is
> the only trouble to me no matter what policy you want to pursue...

Let's separate SEAMRR detection and TDX initialization.  The paranoid check is
only for SEAM detection, but not for TDX initialization.  As I said, it is TDX's
requirement that some SEAMCALL must be run on all bios-enabled cpus, but not
SEAM's.


-- 
Thanks,
-Kai


