Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3524CAC39
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 18:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238287AbiCBRfY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 12:35:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244127AbiCBRfW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 12:35:22 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C42D5F47;
        Wed,  2 Mar 2022 09:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646242460; x=1677778460;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jzifREd1E6S6cVQq/lLaPIGktR6DrXmG+S0OSbMPecs=;
  b=ccDYS6FGM+MtYZN/YZYxXCDyJlu0Pl7mX1g2wXBsfH1+kzA7wtX7rfhB
   kHkj1J9Xr+L95XtZNWy5tkl6DkSLTV08ydcz5pYjToNwLJ18xV61eJjxq
   UI9WLLJM7eDADUy5S29ZhIMrj+Fi6zmHMsdSRxlyggJJIdLZHig/olWB5
   8pvExRoDnIgM9JbMWGfEWCGE+c444XZB7iQ8aMkg3gJ5phyDwFpizKCcv
   0YLB/Lboiryjccs69ebhLiSz30O2XqYOVmP9BUTWHm8fdT0MSQkeBOb0A
   nzzxSGp8Nkn1H3g4mWXVzgJwMj4VE/JSOmhrKQwIZgymulJTkidxxT+TV
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="240876017"
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="240876017"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 09:32:49 -0800
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="493617661"
Received: from smile.fi.intel.com ([10.237.72.59])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 09:32:46 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nPSpT-00AQ2N-1D;
        Wed, 02 Mar 2022 19:31:59 +0200
Date:   Wed, 2 Mar 2022 19:31:58 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Michael Mueller <mimu@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Subject: Re: [PATCH v1 1/1] KVM: s390: Don't cast parameter in bit operations
Message-ID: <Yh+qDhd6FL9nlQdD@smile.fi.intel.com>
References: <20220223164420.45344-1-andriy.shevchenko@linux.intel.com>
 <20220224123620.57fd6c8b@p-imbrenda>
 <3640a910-60fe-0935-4dfc-55bb65a75ce5@linux.ibm.com>
 <Yh+Qw6Pb+Cd9JDNa@smile.fi.intel.com>
 <Yh+m65BSfQgaDFwi@yury-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh+m65BSfQgaDFwi@yury-laptop>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 02, 2022 at 09:18:35AM -0800, Yury Norov wrote:
> On Wed, Mar 02, 2022 at 05:44:03PM +0200, Andy Shevchenko wrote:
> > On Thu, Feb 24, 2022 at 01:10:34PM +0100, Michael Mueller wrote:
> > > On 24.02.22 12:36, Claudio Imbrenda wrote:
> > 
> > ...
> > 
> > > we do that at several places
> > 
> > Thanks for pointing out.
> > 
> > > arch/s390/kernel/processor.c:	for_each_set_bit_inv(bit, (long
> > > *)&stfle_fac_list, MAX_FACILITY_BIT)
> > 
> > This one requires a separate change, not related to this patch.
> > 
> > > arch/s390/kvm/interrupt.c:	set_bit_inv(IPM_BIT_OFFSET + gisc, (unsigned long
> > > *) gisa);
> > 
> > This is done in the patch. Not sure how it appears in your list.
> > 
> > > arch/s390/kvm/kvm-s390.c:		set_bit_inv(vcpu->vcpu_id, (unsigned long *)
> > > sca->mcn);
> > > arch/s390/kvm/kvm-s390.c:		set_bit_inv(vcpu->vcpu_id, (unsigned long *)
> > > &sca->mcn);
> > 
> > These two should be fixed in a separate change.
> > 
> > Also this kind of stuff:
> > 
> > 	bitmap_copy(kvm->arch.cpu_feat, (unsigned long *) data.feat,
> > 	            KVM_S390_VM_CPU_FEAT_NR_BITS);
> > 
> > might require a new API like
> > 
> > bitmap_from_u64_array()
> > bitmap_to_u64_array()
> > 
> > Yury?
> 
> If BE32 is still the case then yes.

The whole point is to get rid of the bad pattern, while it may still work
in the particular case.

-- 
With Best Regards,
Andy Shevchenko


