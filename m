Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00360572F63
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 09:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234757AbiGMHkn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 03:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234255AbiGMHki (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 03:40:38 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45AB6E587D;
        Wed, 13 Jul 2022 00:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657698034; x=1689234034;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:in-reply-to;
  bh=p6S9d0eoOccrcr2x6G9e4hJJ9OVvTKahjywxJ3zVPng=;
  b=XF5ri1fOs/6Jvmk8nzWU+eFMmyngz64N+h0AiMmI15I/JOvtRZbKjjok
   gAjBaVh8D315dLNQg3r4/oAEGav2tx+LRsFG8K7dRQNxtqHLLx63SMfZN
   zbYURaW0u1rCbJXHuT+LhTeSrunTciBeHObNuFX5BVn6JjX3zDNkhCNK+
   w7rU0nFpU7FrEqOGs95tMBukML2Jw7vIJHqpmbLJSAgPYBl43GtFj2waL
   DAusmCTdsd5/eHiVGSB/3/AM3uuIf7dlAxq0bnZZZebYYnZgdSk7T2gSs
   MROEGaPjwmQILxySVhuocg9D6JGOL0aSNbpMU0zs9UCfwS57yqeFrYo0x
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="265549705"
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="265549705"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 00:40:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="685065350"
Received: from chaop.bj.intel.com (HELO localhost) ([10.240.192.101])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Jul 2022 00:40:25 -0700
Date:   Wed, 13 Jul 2022 15:37:07 +0800
From:   Chao Peng <chao.p.peng@linux.intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Chao Gao <chao.gao@intel.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, chao.p.peng@intel.com
Subject: Re: [PATCH v7 000/102] KVM TDX basic feature support
Message-ID: <20220713073707.GA2831541@chaop.bj.intel.com>
Reply-To: Chao Peng <chao.p.peng@linux.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <20220711151701.GA1375147@ls.amr.corp.intel.com>
 <20220712050714.GA26573@gao-cwp>
 <20220712105419.GB2805143@chaop.bj.intel.com>
 <20220712172250.GJ1379820@ls.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712172250.GJ1379820@ls.amr.corp.intel.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 12, 2022 at 10:22:50AM -0700, Isaku Yamahata wrote:
> On Tue, Jul 12, 2022 at 06:54:19PM +0800,
> Chao Peng <chao.p.peng@linux.intel.com> wrote:
> 
> > On Tue, Jul 12, 2022 at 01:07:20PM +0800, Chao Gao wrote:
> > > On Mon, Jul 11, 2022 at 08:17:01AM -0700, Isaku Yamahata wrote:
> > > >Hi. Because my description on large page support was terse, I wrote up more
> > > >detailed one.  Any feedback/thoughts on large page support?
> > > >
> > > >TDP MMU large page support design
> > > >
> > > >Two main discussion points
> > > >* how to track page status. private vs shared, no-largepage vs can-be-largepage
> > > 
> > > ...
> > > 
> > > >
> > > >Tracking private/shared and large page mappable
> > > >-----------------------------------------------
> > > >VMM needs to track that page is mapped as private or shared at 4KB granularity.
> > > >For efficiency of EPT violation path (****), at 2MB and 1GB level, VMM should
> > > >track the page can be mapped as a large page (regarding private/shared).  VMM
> > > >updates it on MapGPA and references it on the EPT violation path. (****)
> > > 
> > > Isaku,
> > > 
> > > + Peng Chao
> > > 
> > > Doesn't UPM guarantee that 2MB/1GB large page in CR3 should be either all
> > > private or all shared?
> > > 
> > > KVM always retrieves the mapping level in CR3 and enforces that EPT's
> > > page level is not greater than that in CR3. My point is if UPM already enforces
> > > no mixed pages in a large page, then KVM needn't do that again (UPM can
> > > be trusted).
> > 
> > The backing store in the UMP can tell KVM which page level it can
> > support for a given private gpa, similar to host_pfn_mapping_level() for
> > shared address.
> >
> > However, this solely represents the backing store's capability, KVM
> > still needs additional info to decide whether that can be safely mapped
> > as 2M/1G, e.g. all the following pages in the 2M/1G range should be all
> > private, currently this is not something backing store can tell.
> 
> This argument applies to shared GPA.  The shared pages is backed by normal file
> mapping with UPM.  When KVM is mapping shared GPA, the same check is needed.  So
> I think KVM has to track all private or all shared or no-largepage at 2MB/1GB
> level.  If UPM tracks shared-or-private at 4KB level, probably KVM may not need to
> track it at 4KB level.

Right, the same also applies to shared memory. All the info we need is
whether pages of a 2M range is all private/shared but not mixed. UPM v7
has code tracking that in KVM and previously versions we track that in
the backing store which has been discussed not a good idea.

Chao
> 
> 
> > Actually, in UPM v7 we let KVM record this info so one possible solution
> > is making use of it.
> > 
> >   https://lkml.org/lkml/2022/7/6/259
> > 
> > Then to map a page as 2M, KVM needs to check:
> >   - Memory backing store support that level
> >   - All pages in 2M range are private as we recorded through
> >     KVM_MEMORY_ENCRYPT_{UN,}REG_REGION
> >   - No existing partial 4K map(s) in 2M range
> -- 
> Isaku Yamahata <isaku.yamahata@gmail.com>
